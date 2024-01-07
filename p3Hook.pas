unit p3Hook;

interface
uses
  SysUtils, Classes, Windows;

var
  OnP3Load: TProcedure;

procedure patchP3();

implementation

uses HookApi;

//type
//  TOrgInstBlock = array[0..7] of Byte;
//  POrgInstBlock = ^TOrgInstBlock;
//
//  TJmpInstruction = packed record
//    Jmp: Byte;
//    Offset: Integer;
//    Ret: Byte;
//  end;
//  PJmpInstruction = ^TJmpInstruction;
//
//
//procedure RedirectProc(aOrgProc: Pointer; aNewProc: Pointer;
//        out aOrgInstBlock: TOrgInstBlock);
//const
//  OpJmp = $E9;
//  OpRet = $C3;
//var
//  Protect, Dummy, Offset: Cardinal;
//  Org: POrgInstBlock;
//begin
//  Offset := Cardinal(aNewProc) - (Cardinal(aOrgProc) + 5);
//  if not VirtualProtect(aOrgProc, 16, PAGE_READWRITE, Protect) then
//    RaiseLastOSError();
//
//  Org := aOrgProc;
//  aOrgInstBlock[0] := Org^[0];
//  aOrgInstBlock[1] := Org^[1];
//  aOrgInstBlock[2] := Org^[2];
//  aOrgInstBlock[3] := Org^[3];
//  aOrgInstBlock[4] := Org^[4];
//  aOrgInstBlock[5] := Org^[5];
//  aOrgInstBlock[6] := Org^[6];
//
//
//  PJmpInstruction(aOrgProc)^.Jmp := OpJmp;
//  PJmpInstruction(aOrgProc)^.Offset := Offset;
//
//  if not VirtualProtect(aOrgProc, 16, Protect, Dummy) then
//    RaiseLastOSError();
//
//  FlushInstructionCache(GetCurrentProcess(), aOrgProc, SizeOf(TJmpInstruction));
//end;
//
//procedure RestoreProcInst(aOrgProc: Pointer; const aOrgInstBlock: TOrgInstBlock);
//var
//  Protect, DummyProtect: Cardinal;
//  Org: POrgInstBlock;
//begin
//  if not VirtualProtect(aOrgProc, 16, PAGE_READWRITE, Protect) then
//    RaiseLastOSError();
//
//  Org := aOrgProc;
//  Org[0] := aOrgInstBlock[0];
//  Org[1] := aOrgInstBlock[1];
//  Org[2] := aOrgInstBlock[2];
//  Org[3] := aOrgInstBlock[3];
//  Org[4] := aOrgInstBlock[4];
//  Org[5] := aOrgInstBlock[5];
//  Org[6] := aOrgInstBlock[6];
//
//  if not VirtualProtect(aOrgProc, 16, Protect, DummyProtect) then
//    RaiseLastOSError();
//
//  FlushInstructionCache(GetCurrentProcess(), aOrgProc, SizeOf(TJmpInstruction));
//end;
//
//procedure UpdateCode(aCodePtr: Pointer;
//        const aNewInstructions;
//        const aSize: Cardinal;
//        aOrgInstructions: PByte);
//var
//  Protect, DummyProtect: Cardinal;
//begin
//  if not VirtualProtect(aCodePtr, aSize, PAGE_READWRITE, Protect) then
//    RaiseLastOSError();
//
//  if aOrgInstructions <> nil then
//    Move(aCodePtr^, aOrgInstructions^, aSize);
//
//  Move(aNewInstructions, aCodePtr^, aSize);
//
//  if not VirtualProtect(aCodePtr, aSize, Protect, DummyProtect) then
//    RaiseLastOSError();
//
//  FlushInstructionCache(GetCurrentProcess(), aCodePtr, aSize);
//end;

procedure p3Hook_LoadImpl();
begin
  OutputDebugString('P3 On Load hooked.');
  try
    if Assigned(OnP3Load) then
      OnP3Load();
  except
  end;
end;

//procedure p3Hook_Load();
//asm
//  pusha
//  call p3Hook_loadImpl
//  popa
//
//
//  db $53                { push ebx }
//  db $55                { push ebp }
//  db $56                { push esi }
//  db $8b                { mov esi, ecx }
//  db $f1
//
//  db $e9                { jmp $00609635 }
//  db $35
//  db $96
//  db $60
//  db $00
//
//  ret
//end;

procedure patchP3();
//var
//  instProc: TOrgInstBlock;
begin
//  Exit;  
//  detours(Pointer($609630), @p3Hook_loadImpl);
//  RedirectProc(Pointer($609630), @p3Hook_load, instProc);
end;


end.
