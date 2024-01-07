program p3edrunner;

uses
  SysUtils,
  Classes,
  Windows,
  Messages,
  TlHelp32,
  AxGameHackToolBox in 'AxGameHackToolBox.pas';

//  Forms;

{$R *.res}



const
  ACTION__LOAD = 1;
  ACTION__FREE = 2;

type
  TInjectLibA = function (hProc: THandle; libFile: PChar; actionFlag: Integer): BOOL; cdecl;
  TInjectLibW = function (hProc: THandle; libFile: PWideChar; actionFlag: Integer): BOOL; cdecl;

var
  InjLib: THandle;
  InjectLibA: TInjectLibA;
  InjectLibW: TInjectLibW;

  procedure loadLib();
  begin
    InjLib := LoadLibrary('InjLib.dll');

    if InjLib = 0 then
      RaiseLastOSError();

    InjectLibA := getprocAddress(InjLib, 'InjectLibA');
    if not Assigned(InjectLibA) then
      raise Exception.Create('no func');
    InjectLibW := getprocAddress(InjLib, 'InjectLibW');
    if not Assigned(InjectLibW) then
      raise Exception.Create('no func');
  end;

  procedure SetP3HouseCapacity(
          const aProcID: Cardinal;
          const aProcHandle: THandle; const aFactor: Currency);
  var
//    s: string;
    ptr: PByte;
    pW: PWord;
    I: Integer;
    Cnt: DWORD;
    OldProt: DWORD;
    mi: TMemoryBasicInformation;
    c: Currency;
    Buff: array[0..6] of Word;
    Entry: TModuleEntry32;
  begin
//    if not getProcModuleEntry(aProcID, 'p3.exe', Entry) then
//    begin
//      MessageBox(HWND_DESKTOP, 'not found', 'module', MB_OK);
//      TerminateProcess(aProcHandle, 0);
//      raise Exception.Create('无法找到[p3.exe]模块。');
//    end;
//
//    ptr := Entry.modBaseAddr;
//    ptr := pointer(getModuleBaseAddr('p3.exe'));
    ptr := pointer($00400000);
    VirtualQueryEx(aProcHandle, ptr, mi, sizeof(mi));

    ptr := mi.BaseAddress;
    inc(ptr, mi.RegionSize);
    inc(ptr, $282000);
    inc(ptr, $5EF8);

    if not Windows.VirtualProtectEx(aProcHandle, ptr, 14, PAGE_EXECUTE_READWRITE, OldProt) then
      RaiseLastOSError();

    pW := @Buff[0];

    if not ReadProcessMemory(aProcHandle, ptr, pW, SizeOf(Buff), Cnt) then
      RaiseLastOSError();

    for I := 0 to 3 - 1 do
    begin
      c := pW^ * aFactor;
      OutputDebugString(pchar('old-value=' +  IntToStr(pw^)));
      if c > 60000 then
        c := 60000;
      pW^ := Trunc(c);
      OutputDebugString(pchar('set to =' +  IntToStr(pw^)));
      Inc(pW);
    end;

    Inc(pW);

    for I := 0 to 3 - 1 do
    begin
      c := pW^ * aFactor;
      OutputDebugString(pchar('old-value=' +  IntToStr(pw^)));
      if c > 60000 then
        c := 60000;
      pW^ := Trunc(c);
      OutputDebugString(pchar('set to =' +  IntToStr(pw^)));
      Inc(pW);
    end;

    pW := @Buff[0];

    if not WriteProcessMemory(aProcHandle, ptr, pW, SizeOf(Buff), Cnt) then
      RaiseLastOSError();

    if not Windows.VirtualProtectEx(aProcHandle, ptr, SizeOf(Buff), OldProt, OldProt) then
      RaiseLastOSError();

    OutputDebugString('SetHouseCapacity OK');
  end;

//const
//  target_home = 'E:\games\p3\p3.exe';
//  target_off = 'V:\temp\p3\p3.exe';
var
  I, paramCnt: Integer;
  targets, dirs, params: string;
  dlls: WideString;
  p, dir: pchar;
  eddll: PWideChar;
  startInfo: TStartupInfo;
  pi: TProcessInformation;
  proc: THandle;
//  Env: IP3MEEnv;
begin
//  Env := EnvProvider.Env;
//  if not Env.IsP3Installed() then
//  begin
//    MessageBox(HWND_DESKTOP, 'P3 not intalled.', 'Error', MB_ICONSTOP or MB_OK);
//    Exit;
//  end;

  loadLib();


  dirs := ExtractFilePath(ParamStr(0));
  
  targets := dirs + 'p3.exe';
  dlls := dirs + 'p3ed.dll';

//  OutputDebugString(pchar('paramcount=' + IntToStr(ParamCount())));


  paramCnt := ParamCount();
  for I := 1 to paramCnt do
  begin
    params := params + ParamStr(I);
    if I <> paramCnt then
      params := params + ' ';
  end;

  p := pchar(targets + ' ' + params);
  dir := pchar(dirs);
  eddll := pwidechar(dlls);

  FillChar(startInfo, SizeOf(startInfo), 0);
  startInfo.cb := SizeOf(startInfo);

  if not CreateProcess(nil, p, nil, nil, False, CREATE_SUSPENDED, nil, dir, startInfo, pi) then
    RaiseLastOSError();

  try
//    SetP3HouseCapacity(pi.dwProcessId, pi.hProcess, 3);
    ResumeThread(pi.hThread);

    if WaitForInputIdle(pi.hProcess, 20*1000) = 0 then
    begin
      if not InjectLibW(pi.hProcess, eddll, ACTION__LOAD) then
        raise Exception.Create('注入失败。');
    end;
  finally
    CloseHandle(pi.hThread);
    CloseHandle(pi.hProcess);
  end;

//  Sleep(500);


//  proc := OpenProcess(PROCESS_ALL_ACCESS, False, pi.dwProcessId);
//  if proc = 0 then
//    RaiseLastOSError();
//  if not InjectLibW(proc, eddll, ACTION__LOAD) then
//    raise Exception.Create('注入失败。');
end.
