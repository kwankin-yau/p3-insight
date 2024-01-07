unit edAttach;

interface
uses
  SysUtils, Classes, Windows, Messages, Forms;
  
var
  oldWndProc: Pointer;
  InitMsgID, SendKeyMsgID: UINT;
  HKAtom: ATOM;

procedure attachTop3(const aP3Wnd: THandle);

implementation

uses edForm, AxGameHackToolBox, MyGameTools, p3DataStruct, edForm2;

var
  p3Wnd: THandle;
  IntLeftClick, IntRightClick: Boolean;
  CursorX, CursorY: Integer;

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

procedure drawLogo(wnd: HWND);
var
  DC: HDC;
  r: TRect;
begin
  DC := GetDC(wnd);
  if DC = 0 then
  begin
    OutputDebugString('GetDC failed');
    Exit;
  end;
  
  if not GetClientRect(wnd, r) then
  begin
    OutputDebugString('GetClientRect failed');
    Exit;
  end;

  r.Top := r.Bottom - 20;
  r.Right := r.Left + 70;
  if DrawText(DC, 'Alphax', 6, r, DT_SINGLELINE or DT_VCENTER or DT_LEFT) = 0 then
  begin
    OutputDebugString('DrawText failed');
    Exit;
  end;
    
  ReleaseDC(wnd, DC);
end; 


function  newWndProc(wnd: HWND; uMsg: UINT; wP: WPARAM; lp: LPARAM): LRESULT; stdcall;
//var
//  quit: Boolean;
var
  c: char;
  s: string;
  dc: HDC;
  ss: TShiftState;
  charCode: Byte;

  procedure doHotKey();
  var
    pt: TPoint;
  begin
    GetCursorPos(pt);
    CursorX := pt.X;
    CursorY := pt.Y;
      if frmP3Editor = nil then
      begin
//        OutputDebugString('Create new editor.');
        TP3EditorIntf.directExec(wnd);
      end
      else
      begin
//        OutputDebugString('Show hidden');
        {$IFDEF INTERNAL_WND}
        if not frmP3Editor.Visible then
          frmP3Editor.ShowModal()
        else
          AxSetForegroundWindow98(frmP3Editor.Handle, nil);
        {$ELSE}
        AxSetForegroundWindow98(frmP3Editor.Handle, nil);
        {$ENDIF}
        PostMessage(frmP3Editor.Handle, UM_DO_REFRESH, 0, 0);
      end;
  end;

  procedure doTest();
  begin
    TP3EdR2DlgIntf.directExec(wnd);
  end;

  procedure sendKey();
  begin
    DoSendKey := False;
    if GetForegroundWindow() = wnd then
      keybd_event(VK_CONTROL, 0, 0, 0);

    if GetForegroundWindow() = wnd then
      keybd_event(VK_F2, 0, 0, 0);

    if GetForegroundWindow() = wnd then
      keybd_event(VK_F2, 0, KEYEVENTF_KEYUP, 0);

    if GetForegroundWindow() = wnd then
      keybd_event(VK_CONTROL, 0, KEYEVENTF_KEYUP, 0);
  end;

begin
  Result := 0;
{  if uMsg = WM_PAINT then
  begin
//    OutputDebugString('WM_PAINT');
    Result := CallWindowProc(oldWndProc, wnd, uMsg, wP, lp);
    drawLogo(wnd);
    Exit;
  end
  else }
  if uMsg = WM_KEYUP then
  begin
    ss := KeyDataToShiftState(lp);
    charCode := wP;
    if (ss = []) then
    begin
      if charCode = VK_F1 then
      begin
        doHotKey();
        exit;
      end;
    end
    else if (ssCtrl in ss) then
    begin
      if (charCode = Ord('D')) or (charCode = Ord('d')) then
        DebugBreak()
      else if (charCode = Ord('E')) or (charCode = Ord('e')) then
      begin
        doHotKey();
        Exit;
      end
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
//        MessageBox(wnd, 'KeyUp', 'test', MB_OK);
      end;
    end;         
  end
  else if uMsg = InitMsgID then
  begin
//    modP3StaticData(True, True, True, True, True, True);
    
    HKAtom := GlobalAddAtom(pchar('alphax-p3-reghk'));

    if not RegisterHotKey(wnd, HKAtom, MOD_CONTROL or MOD_ALT, VK_F1) then
      OutputDebugString('Register hot key failed');

    Exit;
  end
  else if uMsg = SetFocusMsgID then
  begin
    if lp > 0 then
    begin
      PostMessage(wnd, uMsg, wP, lp-1);
      Result := 0;
      Exit;
    end;

//    AttachThreadInput()
//    EnableWindow(wnd, True);
//    SetForegroundWindow(wnd);
//    SetFocus(wnd);
//    SetCursorPos(CursorX, CursorY);
//    SetCapture(wnd);
//    ShowCursor(True);
//    sendKey();

    Exit;
  end
  else if uMsg = WM_HOTKEY then
  begin
    if wP = HKAtom then
    begin
      doHotKey();
      Exit;
    end;
  end
  else if uMsg = WM_CHAR then
  begin
    c := chr(wP);
    s := c;
    OutputDebugString(pchar('wm_char:' + s));
  end
//  else if uMsg = WM_ACTIVATEAPP then
//  begin
//    OutputDebugString(pchar('WM_ACTIVATEAPP'));
//    if wP <> 0 then
//    begin      
//      if (frmP3Editor <> nil) and EditorVisible then
//      begin
//        OutputDebugString('Do set focus');
//        PostMessage(frmP3Editor.Handle, UM_SET_FOCUS, 0, 0);
//        PostMessage(frmP3Editor.Handle, UM_DO_REFRESH, 0, 0);
//      end;
//    end
//    else
//    begin
//      if (frmP3Editor <> nil) and EditorVisible then
//      begin
//        OutputDebugString(pchar('deactivate app.'));
//        frmP3Editor.doCloseModal();
//
//        ThreadProcessMessages(quit);
//
//        if frmP3Editor.Visible then
//          OutputDebugString('The editor still visible');
//      end;
//    end;
//
//    //do not exit, use wndProc to process it
//  end
  else if (uMsg >= WM_MOUSEFIRST) and (uMsg <= WM_MOUSELAST) then
  begin
//    OutputDebugString('mouse event');
    if (frmP3Editor <> nil) and (frmP3Editor.Visible) then
    begin
      Exit;
    end
    else if uMsg = WM_RBUTTONDOWN then
    begin
      if IntRightClick then
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

//    if frmP3Editor <> nil then
//      OutputDebugString('mouse event');
  end
  else if (uMsg = WM_ACTIVATE) and ((wP = WA_ACTIVE) or (wP = WM_MOUSEACTIVATE)) then
  begin
    if DoSendKey then
    begin
      DoSendKey := False;
      PostMessage(wnd, SendKeyMsgID, 0, 1);
    end;
  end
  else if (uMsg = SendKeyMsgID) then
  begin
    if lp > 0 then
    begin
      PostMessage(wnd, SendKeyMsgID, 0, lp-1);
      Exit;
    end;

    OutputDebugString('sendKeys');
    sendKey();
  end;


//  if uMsg = WM_CAPTURECHANGED then
//  begin
//    OutputDebugString(pchar('capture changed.'));
//  end;

  Result := CallWindowProc(oldWndProc, wnd, uMsg, wP, lp);
end;

procedure attachTop3(const aP3Wnd: THandle);
var
  p: Pointer;
begin
  p3Wnd := aP3Wnd;

  InitMsgID := RegisterWindowMessage(pchar('alphax-p3-m1'));
  if InitMsgID = 0 then
  begin
    OutputDebugString(pchar('register window message failed: m1'));
    Exit;
  end;

  SendKeyMsgID := RegisterWindowMessage('alphax-p3-m2');
  if SendKeyMsgID = 0 then
  begin
    OutputDebugString(pchar('register window message failed: m2'));
    Exit;
  end;

  SetFocusMsgID := RegisterWindowMessage('alpahx-p3-m3');
  if SetFocusMsgID = 0 then
  begin
    OutputDebugString(pchar('register window message failed: m3'));
    Exit;
  end;

  oldWndProc := Pointer(GetWindowLong(aP3Wnd, GWL_WNDPROC));

  p := @newWndProc;

  SetWindowLong(aP3Wnd, GWL_WNDPROC, Integer(p));
  PostMessage(aP3Wnd, InitMsgID, 0, 0);
end;


end.
