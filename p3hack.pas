unit p3hack;

interface
uses
  SysUtils, Classes, Windows, p3insight_common, JclPeImage,
  Messages, Menus, Forms;


const
  P3WndClassName = 'Afx:400000:3:0:1900011:0';
  P3WndText = '´ó º½ º£ ¼Ò 3';

var
  P3Module: THandle;
  P3ModuleBase: Pointer;
  P3Image: TJclPeImage;

const
  P3CODEPTR__EXIT_PROC = $609630 - $400000;
  P3CODEPTR__UPDATE_DATE_PROC = $628E70 - $400000;
  

procedure p3HackInit();
procedure patchP3();

procedure modP3(aModItems: TModItems);
function attachP3(): Boolean;

implementation

uses AxGameHackToolBox, p3insight_utils, P3InsightMain, p3DataStruct,
  myDetours;


var
  oldWndProc: Pointer;
//  InitMsgID,
  ShowInsightMsgID: Cardinal;
  CursorX, CursorY: Integer;
  IntLeftClick, IntRightClick: Boolean;
//  HKAtom: ATOM;

type
  TP3GameStateListenerListImpl = class(TInterfacedObject, IP3GameStateListenerList)
  public
    list: IInterfaceList;

    constructor Create();

    procedure add(const l: IP3GameStateListener);
    procedure remove(const l: IP3GameStateListener);
    function  getCount(): Integer;
    function  get(const index: Integer): IP3GameStateListener;
  end;

  TP3DateUpdateListenerListImpl = class(TInterfacedObject, IP3DateUpdateListenerList)
  public
    list: IInterfaceList;

    constructor Create();

    procedure add(const l: IP3DateUpdateListener);
    procedure remove(const l: IP3DateUpdateListener);
    function  getCount(): Integer;
    function  get(const index: integer): IP3DateUpdateListener;
  end;




procedure p3HackInit();
begin
  P3Module := GetModuleHandle('p3.exe');
  P3ModuleBase := pointer(P3Module);
  P3Image := TJclPeImage.Create();
  P3Image.AttachLoadedModule(P3Module);
  p3DataStruct.P3ModuleHandle := P3Module;
end;

procedure actual_p3Hook_ExitGame();
var
  i: Integer;
  l: IP3GameStateListener;
begin
//  dbgStr('actual_p3Hook_ExitGame, active=' + BoolToStr(isGameActive(), True));

  try
    for I := 0 to GameStateListenerList.getCount() - 1 do
    begin
      l := GameStateListenerList.get(I);
      l.onExitGame();
    end;
  except
  end;
end;

procedure p3Hook_ExitGame();
asm
  pushad
  call actual_p3Hook_ExitGame
  popad
end;

procedure doAutoResetCaptainBirthday(ts: cardinal);
var
  pid: byte;
  i, cnt, changed: integer;
  cap: PCaptainRec;
  newbd: cardinal;
begin
//  dbgStr('Reset captain birthday');

  cnt := getAllocatedCaptainCount();
  pid := getCurrPlayerID();

  newbd := ts - (30 * 365 * 256);
  ts := ts - (35 * 365 * 256);

//  changed := 0;

  for I := 0 to cnt - 1 do
  begin
    cap := getCaptionInfo(i);
    if cap.Owner = pid then
    begin
      if cap.birdthDay < ts then
      begin
        cap.birdthDay := newbd;
//        Inc(changed);
      end;
    end;
  end;

//  if changed > 0 then
//    dbgStr('changed count=' + IntToStr(changed));
end;

procedure autoResetCaptainBirthday(ts: cardinal);
//var
//  ts2: cardinal;
begin
  if not Conf.AutoResetCaptainBirthday
  or not Conf.AllowModify then
    exit;
    
//  ts2 := ts and $F00;
//  ts2 := ts2 shr 8;
  if (ts and $FF00) = 0 then
    doAutoResetCaptainBirthday(ts);
end;

procedure actual_p3Hook_DateUpdated();
var
  ts: cardinal;
  i, y, m, d: integer;
  l: IP3DateUpdateListener;
begin
  if not isGameActive() then
    exit;
    
  ts := getCurrTS();
  if ts = 0 then
    exit;

  autoResetCaptainBirthday(ts);
    
  timestampToDate(ts, y, m, d);

  try
    for I := 0 to DateUpdateListenerList.getCount() - 1 do
    begin
      l := DateUpdateListenerList.get(i);
      l.onNewDate(y, m, d);
    end;
  except
  end;
end;

procedure p3Hook_DateUpdated();
asm
  pushad
  call actual_p3Hook_DateUpdated
  popad
end;

procedure patchP3();
begin
  if not Conf.AllowModify then
    exit;
    
  doMyDetours(
    P3Image.RawToVa(P3CODEPTR__EXIT_PROC),
    @p3Hook_ExitGame,
    6);

//  dbgStr('lHookProc->');
//  p3Hook_DateUpdated();
  doMyDetours(
    P3Image.RawToVa(P3CODEPTR__UPDATE_DATE_PROC),
    @p3Hook_DateUpdated,
    9);
//  dbgStr('<-lHookProc');
end;

procedure modP3(aModItems: TModItems);
var
  I: Integer;
  modItem: TModItem;
  p: Pointer;
  oldProt: DWORD;
  mpList: TMemPageList;



  procedure dbgOldValue();
  var
    s: string;
    i: Integer;
  begin
    if not modItem.BinaryForm then
    begin
      case modItem.Sz of
        1: i := pbyte(p)^;
        2: i := pword(p)^;
        4: i := pinteger(p)^;
      else
        i := 0;
      end;
      s := 'addr: ' + pToHex(p) + ' oldValue=' + IntToStr(i);
      dbgStr(pchar(s));
    end;
    
    SetLength(s, modItem.Sz);
    Move(p^, s[1], modItem.Sz);
    s := SimpleBinToHex(s);
    s := 'addr: ' + pToHex(p) + ' oldValue=$' + s;
    dbgStr(s);
  end;

  procedure errVerifyFailed();
  begin
    dbgStr('Verify failed');
    dbgOldValue();
    TerminateProcess(GetCurrentProcess(), 1);
  end;

  procedure sz1();
  var
    b, orgB: Byte;
    s, orgS: Shortint;
  begin
    if modItem.Verify then
    begin
      if modItem.OrgValue < 0 then
      begin
        orgS := modItem.OrgValue;
        if orgS <> pShortInt(p)^ then
          errVerifyFailed();          
      end
      else
      begin
        orgB := modItem.OrgValue;
        if orgB <> pByte(p)^ then
          errVerifyFailed();
      end;
    end;

    if modItem.Value < 0 then
    begin
      s := modItem.Value;
      pByte(p)^ := s;
    end
    else
    begin
      b := modItem.Value;
      pByte(p)^ := b;
    end;
  end;

  procedure sz2();
  var
    w, orgW: word;
    s, orgS: Smallint;
  begin
    if modItem.Verify then
    begin
      if modItem.OrgValue < 0 then
      begin
        orgS := modItem.OrgValue;
        if orgS <> pSmallInt(p)^ then
          errVerifyFailed();
      end
      else
      begin
        orgW := modItem.OrgValue;
        if orgW <> pWord(p)^ then
          errVerifyFailed();
      end;
    end;
    
    if modItem.Value < 0 then
    begin
      s := modItem.Value;
      pSmallInt(p)^ := s;
    end
    else
    begin
      w := modItem.Value;
      pWord(p)^ := w;
    end;
  end;

  procedure sz4();
  begin
    if modItem.Verify then
    begin
      if pInteger(p)^ <> modItem.OrgValue then
        errVerifyFailed();
    end;
    
    pInteger(p)^ := modItem.Value;
  end;

  procedure binary();
  begin
    if modItem.Verify then
    begin
      if not CompareMem(@modItem.OrgBinValue[1], p, modItem.Sz) then
        errVerifyFailed();
    end;

    Move(modItem.BinValue[1], p^, modItem.Sz);
  end;

  function markReadWrite(p: Pointer; sz: Integer): Boolean;
  var
    mp: TMemPage;
  begin
    Result := False;
    mp := mpList.qryRange(p, sz);

    if mp = nil then
      raise Exception.Create('The page is not committed.');

    if not mp.VirtualProtectChanged then
    begin
      if not mp.SetVirtProt(PAGE_EXECUTE_READWRITE) then
      begin
        soundBeep();
        dbgStr('VirtualProtect failed');
        Exit;
      end;
//      OutputDebugString('SetVirtualProtect called');
    end;

    Result := True;
  end;

var
  mp: TMemPage;
  count: integer;
begin
  count := 0;

  if aModItems.List.Count = 0 then
  begin
    dbgStr('mod count=0');
    exit;
  end;

  mpList := TMemPageList.Create(True);
  try
    for I := 0 to aModItems.List.Count - 1 do
    begin
      modItem := aModItems.get(i);

      if modItem.VA then
      begin
        p :=P3Image.RawToVa(modItem.Ofs - P3_MODULE_BASE);
      end
      else
        p := P3Image.RawToVa(modItem.Ofs);

      if markReadWrite(p, modItem.Sz) then
      begin
        if modItem.BinaryForm then
          binary()
        else
          case modItem.Sz of
            1: sz1();
            2: sz2();
            4: sz4();
          end;
        Inc(count);
      end;

      if modItem.IsCode then
        FlushInstructionCache(GetCurrentProcess(), p, modItem.Sz);
    end;
  finally
    for I := 0 to mpList.count() - 1 do
    begin
      mp := mpList.get(I);
      mp.undoVirtProt();
    end;
    mpList.Destroy();
  end;

  if count > 0 then
    dbgStr('Mod applied: ' + IntToStr(count) + ' items.');
end;

function  newWndProc(wnd: HWND; uMsg: UINT; wP: WPARAM; lp: LPARAM): LRESULT; stdcall;
//var
//  quit: Boolean;
var
  c: char;
  s: string;
//  dc: HDC;
  ss: TShiftState;
  charCode: Byte;
  pt: TPoint;

  procedure doHotKey();
  begin
    if disallowF1 then
    begin
      disallowF1 := False;
      exit;
    end;
    
//    dbgStr('hotkey');
    if not isGameActive() then
    begin
//      dbgStr(byteToHexStr(P6E2030()));
      soundBeep();
      exit;
    end;

//    if InsightDlgVisible then
//    begin
//      dbgStr('F1 pressed when dialog showing.');
//      exit;
//    end;

    PostMessage(wnd, ShowInsightMsgID, 0, 0);
  end;

  procedure doTest();
  begin

  end;

//  procedure sendKey();
//  begin
//    SetActiveWindow(wnd);
//    exit;
//
//    if GetForegroundWindow() = wnd then
//      keybd_event(VK_CONTROL, 0, 0, 0);
//
//    if GetForegroundWindow() = wnd then
//      keybd_event(VK_F2, 0, 0, 0);
//
//    if GetForegroundWindow() = wnd then
//      keybd_event(VK_F2, 0, KEYEVENTF_KEYUP, 0);
//
//    if GetForegroundWindow() = wnd then
//      keybd_event(VK_CONTROL, 0, KEYEVENTF_KEYUP, 0);
//  end;

begin
  Result := 0;
//  if uMsg = WM_KEYDOWN then
//  begin
//    ss := KeyDataToShiftState(lp);
//    charCode := wP;
//
//    if ss = [] then
//    begin
//      if charCode = VK_RETURN then
//      begin
//        DebugBreak();
//      end;
//    end;
//  end
//  else
  if uMsg = WM_KEYUP then
  begin
    ss := KeyDataToShiftState(lp);
    charCode := wP;
    if ([ssCtrl] = ss) then
    begin
      if (charCode = Ord('D')) or (charCode = Ord('d')) then
        DebugBreak()
//      else if (charCode = Ord('E')) or (charCode = Ord('e')) then
//      begin
//        sendMsgToScreen('This is a test!');
//        Exit;
//      end
      else if (charCode = Ord('L')) or (charCode = Ord('l')) then
      begin
        IntLeftClick := True;
      end
      else if (charCode = Ord('R')) or (charCode = Ord('r')) then
      begin
        IntRightClick := True;
      end
      else if (charCode = Ord('T')) or (charCode = Ord('t')) then
      begin
        doTest();
        Exit;
      end;
    end
    else if (ss = []) then
    begin
//      OutputDebugString(pchar('keyUp=' + IntToStr(wP)));
      if wP = VK_F1 then
      begin
        doHotKey();
        Result := 0;
        exit;
      end;
    end;
  end
//  else if uMsg = InitMsgID then
//  begin
////    HKAtom := GlobalAddAtom(pchar('alphax-p3-reghk'));
////
////    if not RegisterHotKey(wnd, HKAtom, MOD_CONTROL or MOD_ALT, VK_F1) then
////      OutputDebugString('Register hot key failed');
//
//    Exit;
//  end
//  else if uMsg = DoSendKeyMsgID then
//  begin
//    if lp > 0 then
//    begin
//      PostMessage(wnd, uMsg, wP, lp-1);
//      Result := 0;
//      Exit;
//    end;
//
//    sendKey();
//
//    Exit;
//  end
//  else if uMsg = WM_HOTKEY then
//  begin
////    if wP = HKAtom then
////    begin
////      doHotKey();
////      Exit;
////    end;
//  end
  else if uMsg = WM_CHAR then
  begin
    c := chr(wP);
    s := c;
//    OutputDebugString(pchar('wm_char:' + s));
  end
  else if (uMsg >= WM_MOUSEFIRST) and (uMsg <= WM_MOUSELAST) then
  begin
    if (InsightDlgVisible) then
    begin
      Exit;
    end
    else if uMsg = WM_RBUTTONDOWN then
    begin
      if IntLeftClick then
      begin
        IntRightClick := False;
        DebugBreak();
      end;
    end

    else if uMsg = WM_LBUTTONDOWN then
    begin
      if IntLeftClick then
      begin
        IntLeftClick := False;
        DebugBreak();
      end;
    end;
  end
//  else if (uMsg = WM_ACTIVATE) and ((wP = WA_ACTIVE) or (wP = WM_MOUSEACTIVATE)) then
//  begin
//    if DoSendKey then
//    begin
//      DoSendKey := False;
//      PostMessage(wnd, DoSendKeyMsgID, 0, 2);
//    end;
//  end
  else if uMsg = ShowInsightMsgID then
  begin
    GetCursorPos(pt);
    CursorX := pt.X;
    CursorY := pt.Y;
    showP3InsightDlg();  
  end;


  Result := CallWindowProc(oldWndProc, wnd, uMsg, wP, lp);
end;


function attachP3(): Boolean;
var
  p: Pointer;
begin
  Result := False;

  P3WndHandle := FindWindow(P3WndClassName, P3WndText);
  if P3WndHandle = 0 then
  begin
//    OutputDebugString('Game not started or not found.');
    Exit;
  end;

//  InitMsgID := RegisterWindowMessage(pchar('alphax-p3-m1'));
//  if InitMsgID = 0 then
//  begin
//    OutputDebugString(pchar('register window message failed: m1'));
//    Exit;
//  end;

//  DoSendKeyMsgID := RegisterWindowMessage('alphax-p3-m2');
//  if DoSendKeyMsgID = 0 then
//  begin
//    OutputDebugString(pchar('register window message failed: m2'));
//    Exit;
//  end;

  ShowInsightMsgID := RegisterWindowMessage('alphax-p3-m3');
  if ShowInsightMsgID = 0 then
  begin
    OutputDebugString('register window message failed: m3');
    exit;
  end;

//  SetFocusMsgID := RegisterWindowMessage('alpahx-p3-m3');
//  if SetFocusMsgID = 0 then
//  begin
//    OutputDebugString(pchar('register window message failed: m3'));
//    Exit;
//  end;

  p := @newWndProc;

  oldWndProc := Pointer(SetWindowLong(P3WndHandle, GWL_WNDPROC, Integer(p)));
  if oldWndProc = nil then
  begin
    OutputDebugString('Attach failed');
    exit;
  end;

//  PostMessage(P3WndHandle, InitMsgID, 0, 0);

  Result := True;
end;



{ TP3GameStateListenerListImpl }

procedure TP3GameStateListenerListImpl.add(const l: IP3GameStateListener);
begin
  list.Add(l);
end;

constructor TP3GameStateListenerListImpl.Create;
begin
  list := TInterfaceList.Create();
end;

function TP3GameStateListenerListImpl.get(
  const index: Integer): IP3GameStateListener;
begin
  Result := list[index] as IP3GameStateListener;
end;

function TP3GameStateListenerListImpl.getCount: Integer;
begin
  Result := list.Count;
end;

procedure TP3GameStateListenerListImpl.remove(const l: IP3GameStateListener);
begin
  list.Remove(l);
end;

{ TP3DateUpdateListenerListImpl }

procedure TP3DateUpdateListenerListImpl.add(const l: IP3DateUpdateListener);
begin
  list.Add(l);
end;

constructor TP3DateUpdateListenerListImpl.Create;
begin
  list := TInterfaceList.Create();
end;

function TP3DateUpdateListenerListImpl.get(
  const index: integer): IP3DateUpdateListener;
begin
  Result := list[index] as IP3DateUpdateListener;
end;

function TP3DateUpdateListenerListImpl.getCount: Integer;
begin
  Result := list.Count;
end;

procedure TP3DateUpdateListenerListImpl.remove(const l: IP3DateUpdateListener);
begin
  list.Remove(l);
end;

initialization
  GameStateListenerList := TP3GameStateListenerListImpl.Create();
  DateUpdateListenerList := TP3DateUpdateListenerListImpl.Create();

end.
