unit hookApiLib;

interface

{.$DEFINE Ring0}

uses
  LDE32,
{$IFDEF Ring0}
  ntddk,
  macros
{$ELSE}
  Windows
{$ENDIF}
  ;

function HookCode(OldProc, NewProc: Pointer): Pointer;
function UnHookCode(TargetProc: Pointer): Boolean;

implementation

type
  LPfar_jmp = ^_far_jmp;
  _far_jmp = packed record
    PushOpCode: BYTE;
    PushArg: Pointer;
    RetOpCode: BYTE;
  end;
  Tfar_jmp = _far_jmp;

function HookCode(OldProc, NewProc: Pointer): Pointer;
var
  lpFuncProc, lpInlineProc: Pointer;
  InlineLen, OpcodeLen: ULONG;
  stfar_jmp_hook: Tfar_jmp;
{$IFNDEF Ring0}
  OldProtect: ULONG;
{$ENDIF}
begin
  Result := nil;
  if ((OldProc = nil) or (NewProc = nil)) then Exit;

  InlineLen := 0;
  lpFuncProc := OldProc;

  while (InlineLen < SizeOf(Tfar_jmp)) do
  begin
    GetInstLenght(lpFuncProc, @OpcodeLen);
    lpFuncProc := Pointer(ULONG(lpFuncProc) + OpcodeLen);
    InlineLen := InlineLen + OpcodeLen;
  end;

  stfar_jmp_hook.PushOpCode := $68;
  stfar_jmp_hook.PushArg := NewProc;
  stfar_jmp_hook.RetOpCode := $C3;

{$IFDEF Ring0}
  lpInlineProc := ExAllocatePoolWithTag(NonPagedPool, 8 + InlineLen  + SizeOf(Tfar_jmp), PoolWithTag);
{$ELSE}
  lpInlineProc := Pointer(GlobalAlloc(GMEM_FIXED, SizeOf(Pointer) + SizeOf(ULONG) + InlineLen  + SizeOf(Tfar_jmp)));
{$ENDIF}

  if (lpInlineProc = nil) then Exit;
 
  PPointer(lpInlineProc)^ := OldProc;
  Inc(PBYTE(lpInlineProc), SizeOf(Pointer));

  PULONG(lpInlineProc)^ := InlineLen;
  Inc(PBYTE(lpInlineProc), SizeOf(ULONG));

{$IFDEF Ring0}
  memcpy(lpInlineProc, OldProc, InlineLen);
{$ELSE}
  CopyMemory(lpInlineProc, OldProc, InlineLen);
{$ENDIF}
  Inc(PBYTE(lpInlineProc), InlineLen);
  //  改写跳转代码
  with LPfar_jmp(lpInlineProc)^ do
  begin
    PushOpCode := $68;
    PushArg := Pointer(ULONG(OldProc) + InlineLen);
    RetOpCode := $C3;
  end;

{$IFDEF Ring0}
  //  开始嵌入Hook
  if NT_SUCCESS(WriteReadOnlyMemoryMark(OldProc, @stfar_jmp_hook, SizeOf(Tfar_jmp))) then
  begin
    Result := Pointer(ULONG(lpInlineProc) - InlineLen);
  end else
  begin
    ExFreePoolWithTag(lpInlineProc, PoolWithTag);
    Result := nil;
  end; 
{$ELSE}
  //  使内存可写
  VirtualProtect(OldProc, SizeOf(Tfar_jmp), PAGE_EXECUTE_READWRITE, OldProtect);
  //  写入跳转代码
  CopyMemory(OldProc, @stfar_jmp_hook, SizeOf(Tfar_jmp));
  Result := Pointer(ULONG(lpInlineProc) - InlineLen);
  //  写回原属性
  VirtualProtect(OldProc, SizeOf(Tfar_jmp), OldProtect, OldProtect);
{$ENDIF}
end;

function UnHookCode(TargetProc: Pointer): Boolean;
var
  lpFuncProc, lpInlineProc: Pointer;
  InlineLen: ULONG;
{$IFNDEF Ring0}
  OldProtect: ULONG;
{$ENDIF}
begin
  Result := False;
  if (TargetProc = nil) then Exit;
  lpInlineProc := TargetProc;
  Dec(PBYTE(lpInlineProc), SizeOf(Pointer) + SizeOf(ULONG));

  lpFuncProc := PPointer(lpInlineProc)^;
  Inc(PBYTE(lpInlineProc), SizeOf(Pointer));

  InlineLen := PULONG(lpInlineProc)^;
  Inc(PBYTE(lpInlineProc), SizeOf(ULONG));

{$IFDEF Ring0}
  //  开始解除Hook
  if NT_SUCCESS(WriteReadOnlyMemoryMark(lpFuncProc, TargetProc, InlineLen)) then
  begin
    Dec(PBYTE(lpInlineProc), SizeOf(Pointer) + SizeOf(ULONG));
    ExFreePoolWithTag(lpInlineProc, PoolWithTag);
    Result := True;
  end; 
{$ELSE}
  //  使内存可写
  VirtualProtect(lpFuncProc, InlineLen, PAGE_EXECUTE_READWRITE, OldProtect);
  //  写回原有数据
  CopyMemory(lpFuncProc, TargetProc, InlineLen);
  Dec(PBYTE(lpInlineProc), SizeOf(Pointer) + SizeOf(ULONG));

  GlobalFree(ULONG(lpInlineProc));
  Result := True;
  //  写回原属性
  VirtualProtect(lpFuncProc, InlineLen, OldProtect, OldProtect);
{$ENDIF}
end;

end.
