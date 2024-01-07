unit edThread;

interface
uses
  SysUtils, Classes, Windows, Messages;

type
  TEdThread = class(TThread)
  protected
    procedure Execute();  override;
    procedure MsgProc(var aMsg: TMessage);
    procedure onHotKey(var aMsg: TMessage);
  public
    ParentWnd: THandle;
    Wnd: THandle;
//    hkID: Word;
    constructor Create(const aParentWnd: THandle);
  end;

implementation

uses edForm, AxGameHackToolBox, p3DataStruct;

function ThreadProcessMsg(var Msg: TMsg; out aQuitDetected: Boolean): Boolean;
var
  Unicode: Boolean;
  MsgExists: Boolean;
begin
  aQuitDetected := False;
  Result := False;
  if PeekMessage(Msg, 0, 0, 0, PM_NOREMOVE) then
  begin
    Unicode := (Msg.hwnd <> 0) and IsWindowUnicode(Msg.hwnd);
    if Unicode then
      MsgExists := PeekMessageW(Msg, 0, 0, 0, PM_REMOVE)
    else
      MsgExists := PeekMessage(Msg, 0, 0, 0, PM_REMOVE);
      
    if not MsgExists then Exit;

    if Msg.Message <> WM_QUIT then
    begin
      Result := True;

      TranslateMessage(Msg);
      if Unicode then
        DispatchMessageW(Msg)
      else
        DispatchMessage(Msg);
    end
    else aQuitDetected := True;
  end;
end;


procedure ThreadProcessMessages(out aQuitDetected: Boolean);
var
  Msg: TMsg;
begin
  aQuitDetected := False;
  while ThreadProcessMsg(Msg, aQuitDetected) do
  ;
end;


{ TEdThread }

constructor TEdThread.Create(const aParentWnd: THandle);
begin
  ParentWnd := aParentWnd;
  FreeOnTerminate := True;
//  hkID := GlobalAddAtom(pchar('alphax-p3ed'));
  inherited Create (True);
end;

procedure TEdThread.Execute;
var
  q: Boolean;
begin
//  OutputDebugString(pchar('Thread started.'));
//  try
    Wnd := AllocateHWnd(MsgProc);
    if Wnd = 0 then
    begin
      OutputDebugString(pchar('Allocate window failed'));
      Exit;
    end;

    try
      if not RegisterHotKey(Wnd, 1, HK__MODIFIER, HK__KEY) then
      begin
        OutputDebugString('Register hot key failed');
        Exit;
      end;
      
      while not Self.Terminated do
      begin
        ThreadProcessMessages(q);
        if q then
          Break;
      end;
    finally
      DeallocateHWnd(Wnd);
    end;
//  finally
////    OutputDebugString(pchar('Thread stopped'));
//  end;
end;

procedure TEdThread.MsgProc(var aMsg: TMessage);
begin
  if aMsg.Msg = WM_HOTKEY then
  begin
    onHotKey(aMsg);
  end
  else
    aMsg.Result := DefWindowProc(Wnd, aMsg.Msg, aMsg.WParam, aMsg.LParam);
end;

procedure TEdThread.onHotKey(var aMsg: TMessage);
begin
  if aMsg.WParam = 1 then
  begin
    if frmP3Editor = nil then
      TP3EditorIntf.directExec(ParentWnd)
    else
    begin
      AxSetForegroundWindow98(frmP3Editor.Handle, nil);
      PostMessage(frmP3Editor.Handle, UM_DO_REFRESH, 0, 0);
    end;
  end;
end;

end.
