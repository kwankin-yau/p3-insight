unit MyGameTools;

interface
uses
  SysUtils, Classes, Windows, TLHelp32, Messages;

function FindProcIDByModuleName(
        const aModuleName: string;
        out aProcID: Cardinal): Boolean;


procedure BackToGameTools(const aGameForeWnd, aToolsForeWnd: THandle);
procedure SwitchToGame(const aGameForeWnd: THandle);

function  GetWndClassName(const aWnd: THandle): WideString;
function  GetWndName(const aWnd: THandle): WideString;

function  GetWndTxt(const Wnd: THandle): WideString;
function  GetTargetWnd(const aExe, aWndClass, aWndText: WideString): THandle;

procedure SendMultibytesToAnsiWnd(const aWnd: THandle; const aTextToSend: string);
function SetForegroundWindow98(const Wnd: THandle; aProcIDPtr: PCardinal): Boolean;


implementation

function  GetTargetWnd(const aExe, aWndClass, aWndText: WideString): THandle;
var
  ProcID: Cardinal;
  Txt: PWideChar;
begin
  Result := 0;

  if not FindProcIDByModuleName(aExe, ProcID) then
    Exit;

  if aWndText = '' then
    Txt := nil
  else
    Txt := PWideChar(aWndText);

  Result := FindWindowW(PWideChar(aWndClass), Txt);
end;



//      if fWnd = 0 then
//      begin
//        fWnd := GetForegroundWindow();
//        GetWindowThreadProcessId(fWnd, @fProcID);
//      end
//      else
//      begin
//        if not CheckWndAndProc() then
//          Exit;
//      end;
//      ShowWindow(fWnd, SW_MINIMIZE);
//      SetForegroundWindow98(Application.Handle, nil);
//      fIsPopuped := True;

function FindProcIDByModuleName(const aModuleName: string; out aProcID: Cardinal): Boolean;
var
  Snap: THandle;
  PE: TProcessEntry32;
  exeFile: string;
begin
  aProcID := 0;

  Snap := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);

  PE.dwSize := SizeOf(PE);
  try
    if Process32First(Snap, PE) then
      repeat
        exeFile := PE.szExeFile;
        if AnsiSameText(ExtractFileName(exeFile), aModuleName) then
        begin
          aProcID := PE.th32ProcessID;
          Result := True;
          Exit;
        end;
      until not Process32Next(Snap, PE);
  finally
    CloseHandle(Snap);
  end;
  Result := False;
end;

function SetForegroundWindow98(const Wnd: THandle; aProcIDPtr: PCardinal): Boolean;
var
  ForeThreadID, NewThreadID: DWORD;
begin
  if GetForegroundWindow <> Wnd then
  begin
    ForeThreadID := GetWindowThreadProcessId(GetForegroundWindow, nil);
    NewThreadID := GetWindowThreadProcessId(Wnd, aProcIDPtr);
    if ForeThreadID <> NewThreadID then
    begin
      AttachThreadInput(ForeThreadID, NewThreadID, True);
      Result := SetForegroundWindow(Wnd);
      AttachThreadInput(ForeThreadID, NewThreadID, False);
      if Result then
        Result := SetForegroundWindow(Wnd);
    end
    else
      Result := SetForegroundWindow(Wnd);
  end
  else
    Result := True;
end;


procedure BackToGameTools(const aGameForeWnd, aToolsForeWnd: THandle);
//var
//  locked: Boolean;
begin
  ShowWindow(aGameForeWnd, SW_MINIMIZE);
//  locked := LockWindowUpdate(aToolsForeWnd);
  Sleep(0);  
//  if locked then
//    LockWindowUpdate(0);
  SetForegroundWindow98(aToolsForeWnd, nil);

  if IsIconic(aToolsForeWnd) then
    ShowWindow(aToolsForeWnd, SW_RESTORE);
end;

procedure SwitchToGame(const aGameForeWnd: THandle);
begin
  if IsIconic(aGameForeWnd) then
    ShowWindow(aGameForeWnd, SW_RESTORE);
    
  BringWindowToTop(aGameForeWnd);
  SetForegroundWindow98(aGameForeWnd, nil);
end;

function  GetWndClassName(const aWnd: THandle): WideString;
var
  Cnt: Integer;
begin
  Cnt := 512;
  SetLength(Result, Cnt);
  Cnt := GetClassNameW(aWnd, PWideChar(Result), Cnt);
  SetLength(Result, Cnt);
end;

function  GetWndTxt(const Wnd: THandle): WideString;
var
  Cnt: Integer;
begin
  SetLength(Result, 256);
  Cnt := GetWindowTextW(Wnd, PWideChar(Result), 256);
  SetLength(Result, Cnt);
end;


function  GetWndName(const aWnd: THandle): WideString;
begin
  Result := GetWndTxt(aWnd); 
end;

procedure SendMultibytesToAnsiWnd(const aWnd: THandle; const aTextToSend: string);
var
  I, L: Integer;
begin
  L := Length(aTextToSend);

  for I := 1 to L do
    SendMessage(aWnd, WM_CHAR, Ord(aTextToSend[I]), 0);
end;



end.
