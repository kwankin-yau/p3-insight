
///////////////////////////////////////////////////////////////////////////////
//
//	 API HOOK Lib by Skyer 2oo5 v1.1
//
//	 2oo5.8.11 first release
//
//	 如果您的程式 or 商品有使用或參考本 lib 的話，煩請跟我說一聲
//	 讓我高興一下 ^Q^
//
//	 可至 Delphi.KTop (http://delphi.ktop.com.tw) 發短訊 or 寫 email 給 Skyer
//
//	 本 lib 使用了 (c) sars [HI-TECH] 2003 [sars@ukrtop.com] 的
//	 Catchy32 v1.6 - Length Disassembler Engine 32bit
//
//	 版本演進：
//
//	 2oo5/08/20 v1.1
//		[@] 修正了原 API 開頭如果遇到 E8 (call), E9 (jmp) 忘記重新計算偏移值
//
//	 2oo5/08/11 v1.0
//		first release.
//
///////////////////////////////////////////////////////////////////////////////
unit HookApi2;

interface

uses
  Windows, Classes, SysUtils;

type
  PApiData = ^TApiData;
  TApiData = packed record
	procAPI: Pointer;
	dwStolenBytes: DWORD;
	dwUsage: DWORD;
	lprocHookBegin: DWORD;
	procOrig: array[0..24] of Byte;
	procHookBegin: array[0..39] of Byte;
	procHookEnd: array[0..15] of Byte;
  end;

  function sHookApi(dll, api	: string;
					callbackFunc: Pointer): Pointer;
  function sUnhookApi(origFunc: Pointer): Boolean;

const
  HEAP_NO_SERIALIZE = 1;
  HEAP_ZERO_MEMORY = 8;
var
  hHookApiHeap: DWORD;
  dwHookApiCount: DWORD;

implementation

{$L catchy32.obj}
function c_Catchy(dwInst: Pointer): DWORD; stdcall; external;

procedure sHookBegin;
asm
  add esp, 4
  push eax
  push edi
  mov edi, $12345678		  //begin_1
  mov eax, [esp+8]
  mov [edi], eax			  //end_1
  mov eax, $12345678		  //begin_2
  mov [esp+8], eax
  mov eax, $12345678		  //begin_3
  inc [eax].TApiData.dwUsage
  pop edi
  pop eax
  db $e9,0,0,0,0			  //begin_4
end;

procedure sHookEnd;
asm
  push 012345678h			  //end_1
  push eax
  mov eax, 012345678h		  //end_2
  dec [eax].TApiData.dwUsage
  pop eax
  ret
end;

procedure CheckInstruction(insArr: PByteArray; refer: DWORD);
var
  offset: DWORD;
begin
  if (insArr[0] = $E8) or (insArr[0] = $E9) then begin
	Move(insArr[1], offset, 4);
	offset := offset + refer - DWORD(insArr); 
	Move(offset, insArr[1], 4);
  end;
end;

function sHookApi(dll, api: string; callbackFunc: Pointer): Pointer;
var
  hlib: DWORD;
  pt: Pointer;
  dw, count, inscount, oldProtect: DWORD;
  data: PApiData;
  mbi: MEMORY_BASIC_INFORMATION;
  parr: PByteArray;
begin
  Result := nil;
  hlib := GetModuleHandle(PChar(dll));
  if hlib = 0 then
	Exit;
  pt := GetProcAddress(hlib, PChar(api));
  if pt = nil then
	Exit;
  if dwHookApiCount = 0 then begin
	hHookApiHeap := HeapCreate(HEAP_NO_SERIALIZE, 1024, 0);
	if hHookApiHeap = 0 then
	  Exit;
  end;
  data := HeapAlloc(hHookApiHeap,HEAP_ZERO_MEMORY or HEAP_NO_SERIALIZE,SizeOf(TApiData));
  if data = nil then
	Exit;
  Inc(dwHookApiCount);
  // 處理 HookBegin
  data.lprocHookBegin := DWORD(@data.procHookBegin);
  data.procAPI := pt;
  Move(sHookBegin, data.procHookBegin[0], 40);
  //begin_2
  dw := DWORD(@data.procHookEnd);
  Move(dw, data.procHookBegin[17], 4);
  //begin_3
  dw := DWORD(data);
  Move(dw, data.procHookBegin[26], 4);
  //begin_4  
  dw := DWORD(callbackFunc) - DWORD(@data.procHookBegin[36]) - 4;
  Move(dw, data.procHookBegin[36], 4);
  // 處理 HookEnd
  Move(sHookEnd, data.procHookEnd[0], 16);
  // end_2
  dw := DWORD(data);
  Move(dw, data.procHookEnd[7], 4);
  // begin_1
  dw := DWORD(@data.procHookEnd) + 1  ;
  Move(dw, data.procHookBegin[6], 4);
  VirtualQuery(data.procAPI, mbi, SizeOf(mbi));
  VirtualProtect(mbi.BaseAddress, mbi.RegionSize, PAGE_EXECUTE_READWRITE,
	oldProtect);
  count := 0;
  while count < 6 do begin
	inscount := c_Catchy(pt);
	Move(pt^, data.procOrig[count], inscount);
	CheckInstruction(@data.procOrig[count], DWORD(pt));
	inc(count, inscount);
	  pt := Pointer(DWORD(pt) + inscount);
  end;
  data.dwStolenBytes := count;
  data.procOrig[count] := $e9;
  dw := DWORD(pt) - DWORD(@data.procOrig[count]) - 5;
  Move(dw, data.procOrig[count+1], 4);
  parr := data.procAPI;
  parr[0] := $ff;
  parr[1] := $15;
  dw := DWORD(@data.lprocHookBegin);
  Move(dw, parr[2], 4);
  VirtualProtect(mbi.BaseAddress, mbi.RegionSize, oldProtect, oldProtect);
  Result := @data.procOrig;
end;

function sUnhookApi(origFunc: Pointer): Boolean;
var
  mbi: MEMORY_BASIC_INFORMATION;
  dw, oldProtect: DWORD;
  data: PApiData;
begin
  Result := False;
  dw := DWORD(origFunc) - 16;
  data := Pointer(dw);
  if data.dwUsage <> 0 then
	Exit;
  VirtualQuery(data.procAPI, mbi, SizeOf(mbi));
  VirtualProtect(mbi.BaseAddress, mbi.RegionSize, PAGE_EXECUTE_READWRITE,
	oldProtect);
  Move(data.procOrig[0], data.procAPI^, data.dwStolenBytes);
  VirtualProtect(mbi.BaseAddress, mbi.RegionSize, oldProtect, oldProtect);
  HeapFree(hHookApiHeap, HEAP_NO_SERIALIZE, data);
  Dec(dwHookApiCount);
  if dwHookApiCount = 0 then
	HeapDestroy(hHookApiHeap);
  Result := True;
end;

end.
