unit AxGameHackToolBox;

interface
uses
  SysUtils, Classes, Windows, TlHelp32, TypInfo, Contnrs;

type

  TMemType = (
    MT__IMAGE,
    MT__MAPPED,
    MT__PRIVATE
  );

  TMemState = (
    MS__COMMIT,
    MS__FREE,
    MS__RESERVE
  );

  TMemProtection = (
    MP__UNKNOWN,
    MP__NOACCESS,
    MP__READONLY,
    MP__READWRITE,
    MP__WRITECOPY,
    MP__EXECUTE,
    MP__EXECUTE_READ,
    MP__EXECUTE_READWRITE,
    MP__EXECUTE_WRITECOPY
  );

  TMemPage = class
  public
    P: Pointer;
    MemType: TMemType;
    MemState: TMemState;
    MemProtection: TMemProtection;
    Size: Cardinal;

    hHeap: THandle;

    ExData: Cardinal;
    Freed: Boolean;
    VirtualProtectChanged: Boolean;
    OldProt: DWORD;

    constructor Create();

    procedure ShowMsgBox;
    function GetAddrText: string;
    function GetMemTypeText: string;
    function GetMemStateText: string;
    function GetMemProtectionText: string;
    function GetSizeText: string;

    function  validateHeap(ptr: Pointer): Boolean;
    function  validateHeapAll(): Boolean;

    function  isPtrInPage(ptr: Pointer): Boolean;
    function  isPtrRangeInPage(ptr: Pointer; const len: Integer): Boolean;

    function  SetVirtProt(const aNewProt: DWORD): Boolean;
    function  undoVirtProt(): Boolean;  
  end;

  TMemPageList = class
  private
    fList: TObjectList;
  public
    constructor Create(const aOwnsPages: Boolean);
    destructor Destroy; override;

    procedure add(aMP: TMemPage);
    function  findPage(p: pointer): TMemPage;
    function  findPageRange(p: pointer; const len: Integer): TMemPage;
    function  get(const aIndex: Integer): TMemPage;

    function  qry(p: pointer): TMemPage;
    function  qryRange(p: Pointer; const len: Integer): TMemPage;

    function  count(): Integer;
  end;

  TSearchType = (
//    ST_Byte,
//    ST_TinyInt
//    ST_Word,
//    ST_SmallInt,
//    ST_LongWord,
//    ST_LongInt,
//    ST_Cardinal,
//    ST_Int64,
    ST_AnsiStr
//    ST_WideStr
  );

  TSearchReq = packed record
    CallerMsgHandle: THandle; //WM_COPY
    SearchType: TSearchType; //Byte
    Flags: Byte; //
    SearchInResult: Integer; //ID, 0 for not used
    case Integer of
      0: (search_ansi_str: array[0..25] of Char;) //max 25 characters, null terminated
  end; //32
  

  TSearchResult = packed record
    ResultCount: Word; //Result count, max 65535
    ResultAddr: array[0..0] of Pointer;     
  end;

  TPreallocatedMemPageList = class
  private
    fList: TObjectList;
  public
    constructor Create(const aPreallocatedCount: Integer);
    destructor Destroy; override;

    function  get(): TMemPage;
  end;


const
  SHARE_MEM_BLOCK_NAME = '{9752CABF-35CB-4EC7-9E36-6EABE3ADA95E}';




function AxFindProcIDByExeFullPath(
        const aExeFullPathName: WideString;
        out aProcID: Cardinal): Boolean;


function AxFindProcIDByExeBaseName(
        const aExeBaseName: WideString;
        out aProcID: Cardinal): Boolean;

function AxSetForegroundWindow98(
        const Wnd: THandle; aProcIDPtr: PCardinal): Boolean;        

function QueryMemPageEx(
    const aProcHandle: THandle;
    aAddr: Pointer; const aCommitOnly: Boolean = True): TMemPage;

//type
//  TListMemPage3Cb = procedure (
procedure ListMemPage2(const aProcHandle: THandle; aResult: TList);
//procedure AttachedSearchASCII(
//          const aProcHandle: THandle;
//          aMemPageList: TList;
//          const aASCIIText: string;
//          const aAddrList: TList);

procedure ListMemPage(const aProcID: Cardinal; aResult: TList);

function  getProcModuleEntry(
        const aProcID: Cardinal;
        const aModuleBaseName: string;
        var aEntry: TModuleEntry32): Boolean;


function  getModuleBaseAddr(const aModuleName: string): Cardinal;


var
  SysInfo: TSystemInfo;

function IsAddrInSysRange(aAddr: Pointer): Boolean;  

implementation
uses
  PSAPI;

function  alignToPageBoundary(p: Pointer): Pointer;
var
  dw: DWORD;
begin
  dw := SysInfo.dwPageSize - 1;
  dw := not dw;
  dw := dword(p) and dw;
  Result := pointer(dw);
end;  



function MemTypeToText(mt: TMemType): string;
begin
  case mt of
    MT__IMAGE: Result := 'IMAGE';
    MT__MAPPED : Result := 'MAPPED';
  else
    Result := 'PRIVATE';
  end;
end;

function MemStateToText(ms: TMemState): string;
begin
  case ms of
    MS__COMMIT: Result := 'COMMIT';
    MS__FREE: Result := 'FREE';
  else
    Result := 'RESERVE';
  end;
end;

function MemProtectionToText(mp: TMemProtection): string;
begin
  Result := GetEnumName(TypeInfo(TMemProtection), integer(mp));
end;



function IsAddrInSysRange(aAddr: Pointer): Boolean;
begin
  Result := (Cardinal(aAddr) >= Cardinal(SysInfo.lpMinimumApplicationAddress))
        and (Cardinal(aAddr) <= Cardinal(SysInfo.lpMaximumApplicationAddress));
end;

function DWORDToMemType(dw: Cardinal): TMemType;
begin
  case dw of
    MEM_IMAGE: Result := MT__IMAGE;
    MEM_MAPPED: Result := MT__MAPPED;
  else
    Result := MT__PRIVATE;
  end;
end;

function DWORDTOMemState(dw: Cardinal): TMemState;
begin
  case dw of
    MEM_COMMIT: Result := MS__COMMIT;
    MEM_FREE: Result := MS__FREE;
  else
    Result := MS__RESERVE;
  end;
end;

function DWORDToMemProtection(dw: Cardinal): TMemProtection;
begin
  case dw and $FF of
    PAGE_NOACCESS: Result := MP__NOACCESS;
    PAGE_READONLY: Result := MP__READONLY;
    PAGE_READWRITE: Result := MP__READWRITE;
    PAGE_WRITECOPY: Result := MP__WRITECOPY;
    PAGE_EXECUTE: Result := MP__WRITECOPY;
    PAGE_EXECUTE_READ: Result := MP__EXECUTE_READ;
    PAGE_EXECUTE_READWRITE: Result := MP__EXECUTE_READWRITE;
    PAGE_EXECUTE_WRITECOPY: Result := MP__EXECUTE_WRITECOPY;
  else
    Result := MP__UNKNOWN;
  end;
end;
  


function AxFindProcIDByExeFullPath(
        const aExeFullPathName: WideString;
        out aProcID: Cardinal): Boolean;
var
  Snap: THandle;
  PE: TProcessEntry32W;
  exeFile: WideString;
begin
  aProcID := 0;

  Snap := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);

  PE.dwSize := SizeOf(PE);
  try
    if Process32FirstW(Snap, PE) then
      repeat
        exeFile := PE.szExeFile;
        if WideSameText(exeFile, aExeFullPathName) then
        begin
          aProcID := PE.th32ProcessID;
          Result := True;
          Exit;
        end;
      until not Process32NextW(Snap, PE);
  finally
    CloseHandle(Snap);
  end;
  Result := False;
end;

function AxFindProcIDByExeBaseName(
        const aExeBaseName: WideString;
        out aProcID: Cardinal): Boolean;
var
  Snap: THandle;
  PE: TProcessEntry32W;
  exeFile: WideString;
begin
  aProcID := 0;

  Snap := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);

  PE.dwSize := SizeOf(PE);
  try
    if Process32FirstW(Snap, PE) then
      repeat
        exeFile := ExtractFileName(PE.szExeFile);
        if WideSameText(exeFile, aExeBaseName) then
        begin
          aProcID := PE.th32ProcessID;
          Result := True;
          Exit;
        end;
      until not Process32NextW(Snap, PE);
  finally
    CloseHandle(Snap);
  end;
  Result := False;
end;


function AxSetForegroundWindow98(const Wnd: THandle; aProcIDPtr: PCardinal): Boolean;
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


{ TMemPage }

function TMemPage.SetVirtProt(const aNewProt: DWORD): Boolean;
var
  dw: DWORD;
begin
  Result := VirtualProtect(P, Size, aNewProt, dw);
  if Result then
  begin
    if not VirtualProtectChanged then
      OldProt := dw;

    VirtualProtectChanged := True;
  end;
end;

constructor TMemPage.Create;
begin
  Freed := False;
end;

function TMemPage.GetAddrText: string;
begin
  Result := '$' + IntToHex(integer(p), 8);
end;

function TMemPage.GetMemProtectionText: string;
begin
  Result := MemProtectionToText(MemProtection);
end;

function TMemPage.GetMemStateText: string;
begin
  Result := MemStateToText(MemState);
end;

function TMemPage.GetMemTypeText: string;
begin
  Result := MemTypeToText(MemType);
end;

function TMemPage.GetSizeText: string;
begin
  Result := IntToHex(Size, 6);
end;

function TMemPage.isPtrInPage(ptr: Pointer): Boolean;
begin
  Result := (integer(ptr) >= integer(P)) and (integer(ptr) < integer(ptr) + integer(Size));
end;

function TMemPage.isPtrRangeInPage(ptr: Pointer; const len: Integer): Boolean;
begin
  Result := isPtrInPage(ptr);
  if Result and (len > 1) then
  begin
    ptr := pointer(integer(ptr) + len-1);
    Result := isPtrInPage(ptr);
  end;
end;

procedure TMemPage.ShowMsgBox;
var
  S: string;
begin
  S := 'Addr: %s' + sLineBreak
      + 'Type: %s' + sLineBreak
      + 'State: %s' + sLineBreak
      + 'Protection: %s' + sLineBreak
      + 'Size: %s'
  ;

  S := Format(
          S,
          [
                  GetAddrText(),
                  GetMemTypeText(),
                  GetMemStateText(),
                  GetMemProtectionText(),
                  GetSizeText()
                ]
        );

  MessageBox(0, PChar(S), 'Memory Infomation', MB_ICONINFORMATION or MB_OK);
end;

function TMemPage.undoVirtProt: Boolean;
var
  dummy: DWORD;
begin
  if VirtualProtectChanged then
  begin
    Result := VirtualProtect(P, Size, OldProt, dummy);
    if Result then
      VirtualProtectChanged := False;
  end
  else
    Result := True;
end;

function TMemPage.validateHeap(ptr: Pointer): Boolean;
var
  MemInfo: TMemoryBasicInformation;
begin
  if VirtualQueryEx(GetCurrentProcess(), ptr, MemInfo, SizeOf(MemInfo)) <> 0 then
  begin
    Result := MemInfo.State = MEM_COMMIT;
    if not Result then
      Freed := True;
  end
  else
    Result := False;
end;

function TMemPage.validateHeapAll: Boolean;
begin
  Result := validateHeap(P);
end;

function  queryMemPage(aAddr: Pointer; const aCommitOnly: Boolean = true): TMemPage;
var
  MemInfo: TMemoryBasicInformation;
begin
  if IsAddrInSysRange(aAddr) then
  begin
    aAddr := alignToPageBoundary(aAddr);
    if VirtualQuery(aAddr, MemInfo, SizeOf(MemInfo)) = 0 then
    begin
      OutputDebugString('vq-err');
      RaiseLastOSError();
    end;

    if aCommitOnly and (MemInfo.State <> MEM_COMMIT) then
    begin
      Result := nil;
      Exit;
    end;

    Result := TMemPage.Create();
    Result.P := MemInfo.BaseAddress;
    Result.MemType := DWORDToMemType(MemInfo.Type_9);
    Result.MemState := DWORDTOMemState(MemInfo.State);
    Result.MemProtection := DWORDToMemProtection(MemInfo.AllocationProtect);
    Result.Size := MemInfo.RegionSize;
  end
  else Result := nil;
end;

function QueryMemPageEx(
    const aProcHandle: THandle;
    aAddr: Pointer; const aCommitOnly: Boolean = True): TMemPage;
var
  MemInfo: TMemoryBasicInformation;
begin
  if IsAddrInSysRange(aAddr) then
  begin
    aAddr := alignToPageBoundary(aAddr);
    if VirtualQueryEx(aProcHandle, aAddr, MemInfo, SizeOf(MemInfo)) = 0 then
    begin
      OutputDebugString('vq-err');
      RaiseLastOSError();
    end;

    if aCommitOnly and (MemInfo.State <> MEM_COMMIT) then
    begin
      Result := nil;
      Exit;
    end;

    Result := TMemPage.Create();
    Result.P := MemInfo.BaseAddress;
    Result.MemType := DWORDToMemType(MemInfo.Type_9);
    Result.MemState := DWORDTOMemState(MemInfo.State);
    Result.MemProtection := DWORDToMemProtection(MemInfo.AllocationProtect);
    Result.Size := MemInfo.RegionSize;
  end
  else Result := nil;
end;

procedure ListMemPage2(const aProcHandle: THandle; aResult: TList);
var
  Addr: DWORD;
  MemPage: TMemPage;
begin
  aResult.Capacity := 4096;
  Addr := DWORD(SysInfo.lpMinimumApplicationAddress);

  while Addr < DWORD(SysInfo.lpMaximumApplicationAddress) do
  begin
    MemPage := QueryMemPageEx(aProcHandle, Pointer(addr));
    if MemPage <> nil then
      aResult.Add(MemPage);

    Addr := Addr + SysInfo.dwAllocationGranularity;
  end;
end;


procedure ListMemPage(const aProcID: Cardinal; aResult: TList);
var
  Snap: Cardinal;
  HL: THeapList32;
  HE: THeapEntry32;
  MP: TMemPage;
  List: TPreallocatedMemPageList;
begin
  HL.dwSize := SizeOf(HL);
  HE.dwSize := SizeOf(HE);

  List := TPreallocatedMemPageList.Create(1024*20);
  try
    Snap := CreateToolhelp32Snapshot(TH32CS_SNAPHEAPLIST, aProcID);
    try
      if Heap32ListFirst(Snap, HL) then
        repeat
          if Heap32First(HE, HL.th32ProcessID, HL.th32HeapID) then
            repeat
              MP := List.get();
              MP.P := Pointer(HE.dwAddress);
              MP.MemType := DWORDToMemType(HE.dwFlags);
              MP.hHeap := HE.hHandle;
              MP.Size := HE.dwBlockSize;

              aResult.Add(MP);            
            until not Heap32Next(HE);
        until not Heap32ListNext(Snap, HL);
    finally
      CloseHandle(snap);
    end;
  finally
    List.Destroy();
  end;
end;

function  getModuleBaseAddr(const aModuleName: string): Cardinal;
var
  p3h: THandle;
//  baseName: array[0..MAX_PATH-1] of Char;
//  len: Integer;
begin
  p3h := GetModuleHandle(pchar(aModuleName));
  Result := p3h;
//  if p3h then
//  begin
//
//  end;
//  GetModuleInformation()
//  len := GetModuleBaseName(p3h, p3h, @baseName[0], SizeOf(baseName));
//  if len = 0 then
//  begin
//    OutputDebugString('get module base name failed.');
//    Result := 0;
//    Exit;
//  end;
end;

function  getProcModuleEntry(
        const aProcID: Cardinal;
        const aModuleBaseName: string;
        var aEntry: TModuleEntry32): Boolean;
var
  Snap: Cardinal;
  Module: TModuleEntry32;
  s: string;
  err: DWORD;
begin
  Result := False;
  
  Snap := CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, aProcID);
  if Snap = INVALID_HANDLE_VALUE then
    RaiseLastOSError();
    
  try
    Module.dwSize := SizeOf(Module);
    if Module32First(Snap, Module) then
    begin
      repeat
        s := Module.szModule;
        if AnsiSameText(s, aModuleBaseName) then
        begin
          Result := True;
          aEntry := Module;
          Exit;  
        end;       
      until not Module32Next(Snap, Module);
    end
    else
    begin
      err := GetLastError();
      if err <> ERROR_NO_MORE_FILES then
      begin
        raise EOSError.Create(SysErrorMessage(err));
      end;
    end;
  finally
    CloseHandle(snap);
  end;
end;


{ TPreallocatedMemPageList }

constructor TPreallocatedMemPageList.Create(const aPreallocatedCount: Integer);
var
  I: Integer;
  MP: TMemPage;
begin
  fList := TObjectList.Create(False);
  fList.Capacity := aPreallocatedCount;

  for I := 0 to aPreallocatedCount - 1 do
  begin
    MP := TMemPage.Create();
    fList.Add(MP);
  end;
end;

destructor TPreallocatedMemPageList.Destroy;
begin
  if fList <> nil then
  begin
    fList.OwnsObjects := True;
    FreeAndNil(fList);
  end;
  inherited;
end;

function TPreallocatedMemPageList.get: TMemPage;
begin
  if fList.Count > 0 then
  begin
    Result := TMemPage(fList[fList.Count-1]);
    fList.Delete(fList.Count-1);
  end
  else
    Result := TMemPage.Create();
end;

{ TMemPageList }

procedure TMemPageList.add(aMP: TMemPage);
begin
  fList.Add(aMP);
end;

function TMemPageList.count: Integer;
begin
  Result := fList.Count;
end;

constructor TMemPageList.Create(const aOwnsPages: Boolean);
begin
  fList := TObjectList.Create(aOwnsPages);
end;

destructor TMemPageList.Destroy;
begin
  FreeAndNil(fList);
  inherited;
end;

function TMemPageList.findPage(p: pointer): TMemPage;
var
  i: Integer;
begin
  for I := 0 to fList.Count - 1 do
  begin
    Result := get(I);
    if Result.isPtrInPage(p) then
      Exit;
  end;

  Result := nil;
end;

function TMemPageList.findPageRange(p: pointer; const len: Integer): TMemPage;
var
  i: Integer;
begin
  for I := 0 to fList.Count - 1 do
  begin
    Result := get(I);
    if Result.isPtrRangeInPage(p, len) then
      Exit;
  end;

  Result := nil;
end;

function TMemPageList.get(const aIndex: Integer): TMemPage;
begin
  Result := TMemPage(fList[aIndex]);
end;

function TMemPageList.qry(p: pointer): TMemPage;
begin
  Result := findPage(p);
  if Result = nil then
  begin
    Result := queryMemPage(p, True);
    if Result <> nil then
      fList.Add(Result);
  end;
end;

function TMemPageList.qryRange(p: Pointer; const len: Integer): TMemPage;
begin
  Result := findPageRange(p, len);
  if Result = nil then
  begin
    Result := queryMemPage(p, True);
    if Result <> nil then
      fList.Add(Result);
  end;
end;

initialization
  GetSystemInfo(SysInfo);

end.
