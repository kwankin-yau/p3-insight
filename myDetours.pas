unit myDetours;

interface
uses
  SysUtils, Classes, Windows;


procedure doMyDetours(targetProc, detoursProc: Pointer; targetLen: integer);

implementation


type
  TTrampoline = packed record
    push_opCode: byte;
    push_ret_addr: pointer;
    jmp_opCode: byte;
    jmp_offset: integer;
    stub: array[0..21] of Byte; //15+5
  end; //size=32
  PTrampoline = ^TTrampoline;

  TTrampolines = packed record
    count: integer;
    items: array[0..126] of TTrampoline;
  end; //above 4 k

  TJmpRec = packed record
    jmp_opCode: byte;
    jmp_offset: integer;
  end;
  PJmpRec = ^TJmpRec;

  PTrampolines = ^TTrampolines;

var
  trampolines: PTrampolines;

  function markReadWrite(p: Pointer; sz: Integer; out aOldProt: DWORD): Boolean;
  begin
    if not Windows.VirtualProtect(p, sz, PAGE_EXECUTE_READWRITE, aOldProt) then
    begin
      Result := False;
      OutputDebugString('Write memory failed');
      Exit;
    end;

    Result := True;
  end;

  function  undoProtected(p: Pointer; sz: Integer; aOldProt: DWORD): Boolean;
  begin
    if not Windows.VirtualProtect(p, sz, aOldProt, aOldProt) then
    begin
      Result := False;
      OutputDebugString(pchar('Write memory failed'));
      Exit;
    end;

    Result := True;
  end;


function  allocateTrampoline(): PTrampoline;
begin
  if trampolines = nil then
  begin
    trampolines := VirtualAlloc(nil, 4096, MEM_COMMIT, PAGE_EXECUTE_READWRITE);
    if trampolines = nil then
      raise Exception.Create('allocate memory failed.');

    FillChar(trampolines^, sizeof(trampolines^), 0);
  end;

  if trampolines.count >= 127 then
    raise Exception.Create('Not enough memory.');

  Result := @trampolines.items[trampolines.count];
  Inc(trampolines.count);
end;
  

function CalcJmpOffset(Src, Dest: Pointer): Longint;
begin
  Result := Longint(Dest) - (Longint(Src) + 5);
end;


procedure doMyDetours(targetProc, detoursProc: Pointer; targetLen: integer);
var
  tramp: PTrampoline;
  pb: PByte;
  jmpPtr, jmpOfs: integer;
  pJmp: PJmpRec;
  oldProd: DWORD;
begin
  jmpPtr := integer(targetProc) + targetLen;

  tramp := allocateTrampoline();
  tramp.push_opCode := $68;
  tramp.push_ret_addr := @tramp.stub[0];
  tramp.jmp_opCode := $E9;
  tramp.jmp_offset := CalcJmpOffset(@tramp.jmp_opCode, detoursProc);

  Move(targetproc^, tramp.stub[0], targetLen);  
  pb := @tramp.stub[0];
  Inc(pb, targetLen);
  pJmp := pointer(pb);
  pJmp^.jmp_opCode := $E9;
  pJmp^.jmp_offset := CalcJmpOffset(pJmp, pointer(jmpPtr));

  markReadWrite(targetProc, 5, oldProd);
  pJmp := targetProc;
  pJmp^.jmp_opCode := $E9;
  pJmp^.jmp_offset := CalcJmpOffset(pJmp, tramp);
  undoProtected(targetProc, 5, oldProd);
end;




end.
