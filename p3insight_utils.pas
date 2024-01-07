unit p3insight_utils;

interface
uses
  SysUtils, Classes, Windows, Messages, Forms,
  GR32, GR32_Lines, VirtualTrees, Graphics, Types,
  OmniXML, MyOmniXMLHelper;
  
procedure soundBeep();

function  bToHex(const b: Byte; const aDollarPrefix: Boolean = true): string;
function  wToHex(const w: Word; const aDollarPrefix: Boolean = true): string;
function  ltoHex(const l: LongWord; const aDollarPrefix: Boolean = true): string;
function  pToHex(const p: Pointer; const aDollarPrefix: Boolean = true): string;

procedure dbgPtr(const name: string; const p: Pointer);
procedure dbgPrintPtr(const aPrefix: string; P: Pointer);

function  ptrAdd(const p: Pointer; const adelta: Integer): Pointer;
function  byteAt(p: pointer; delta: integer): byte;
function  longwordAt(p: pointer; delta: integer): longword;
function  singleAt(p: pointer; delta: integer): Single;
function  doubleAt(p: pointer; delta: integer): Double;
function  format10thousandBaseValue(value: Integer): string;
function  formatMoney(const m: Integer): string;
function  formatCapacity(const c: Integer; const aTongUnitSuffix: Boolean): string;
function  formatQty(q: Integer; const aIsPkgUnit: Boolean): string;

procedure dbgStr(const s: string);
procedure dbgRect(const name: string; const r: TRect);
procedure dbgXY(s: string; x, y: Integer);
procedure dbgBool(s: string; b: Boolean);

function  cyclePoints(const aFirstPt: TFixedPoint): TArrayOfFixedPoint;
function  sameFixedPoint(const fp1, fp2: TFixedPoint): Boolean;

function  VTGetNodeByIndex(VT: TBaseVirtualTree; aIndex: Integer): PVirtualNode;
//function  VTIndexOfNote(VT: TBaseVirtualTree; n: PVirtualNode): Integer;

type
  TMyVTEditor = class(TVTEdit)
  private
    fLeftCount, fRightCount: Integer;
    procedure WMKeyDown(var Message: TWMKeyDown); message WM_KEYDOWN;
  end;

  TMyStringEditLink = class(TStringEditLink)
  protected
//    procedure SetEdit(const Value: TVTEdit); override;
//    class function GetDefaultErrHintTitle: WideString; override;
//    function InternalAcceptNewText(const aNewText: WideString; var aErrHintTitle, aErrHintMsg: WideString): Boolean; override;
    procedure InitEditor(); override;
  public
  end;


procedure VTGetSelectedNodes(vt: TBaseVirtualTree; result: TList);
procedure VTGetAllNodes(vt: TBaseVirtualTree; result: TList);

procedure drawPriceCell(
          DC: HDC;
          rect: TRect;
          buy: boolean;
          s: WideString;
          textColor: cardinal);

procedure defaultDrawCell(
        vt: TVirtualStringTree;
        aPaintInfo: TVTPaintInfo;
        aTxtColor: TColor;
        aText: WideString); overload;

procedure defaultDrawCell(
        vt: TVirtualStringTree;
        column: integer;
        canvas: TCanvas;
        cellRect: TRect;
        aTxtColor: TColor;
        aText: WideString); overload;


procedure DrawSquigglyUnderlineEx(
        aDC: HDC; aPen: HPEN; aLeft, aTop, aWidth: Integer);
        
procedure DrawSquigglyUnderlineClr(
        aDC: HDC;
        const aColor: TColor;
        aLeft, aTop, aWidth: Integer);
        
procedure DrawDiagonalUnderlineEx(
        aDC: HDC;
        aPen: HPEN;
        aLeft, aTop, aWidth: Integer);

procedure DrawDiagonalUnderlineClr(
        aDC: HDC;
        const aColor: TColor;
        aLeft, aTop, aWidth: Integer);

function FileExistsWide(const aFileName: WideString): Boolean;        
function SimpleHexToBin(const aHexStr: string): string;
function SimpleBinToHex(const aBinStr: string): string;

procedure prettyPrintSaveXMLToStream(doc: IXMLDocument; str: TStream);
procedure prettyPrintSaveXMLToFile(doc: IXMLDocument; const FileName: WideString);

procedure configError(const fn, msg: WideString);


implementation

uses p3DataStruct;

function  cyclePoints(const aFirstPt: TFixedPoint): TArrayOfFixedPoint;
begin
  SetLength(Result, 4);
  Result[0] := aFirstPt;
  Result[1].X := aFirstPt.X - GR32.Fixed(10);
  Result[1].Y := aFirstPt.Y - GR32.Fixed(30);
  Result[2].X := aFirstPt.X + GR32.Fixed(20);
  Result[2].Y := aFirstPt.Y - GR32.Fixed(35);
  Result[3].X := aFirstPt.X + GR32.Fixed(20);
  Result[3].Y := aFirstPt.Y - GR32.Fixed(10);

  Result := GetCBezierPoints(Result);
end;

function  sameFixedPoint(const fp1, fp2: TFixedPoint): Boolean;
begin
  Result := (fp1.X = fp2.X) and (fp1.Y = fp2.Y);
end;


procedure soundBeep();
begin
  MessageBeep(MB_ICONEXCLAMATION);
end;

function  bToHex(const b: Byte; const aDollarPrefix: Boolean = true): string;
begin
  Result := IntToHex(b, 2);
  if aDollarPrefix then
    Result := '$' + Result;
end;

function  wToHex(const w: Word; const aDollarPrefix: Boolean = true): string;
begin
  Result := IntToHex(w, 4);
  if aDollarPrefix then
    Result := '$' + Result;
end;

function  ltoHex(const l: LongWord; const aDollarPrefix: Boolean = true): string;
begin
  Result := IntToHex(l, 8);
  if aDollarPrefix then
    Result := '$' + Result;
end;

function  pToHex(const p: Pointer; const aDollarPrefix: Boolean = true): string;
begin
  Result := IntToHex(integer(p), 8);
  if aDollarPrefix then
    Result := '$' + Result;
end;

procedure dbgPtr(const name: string; const p: Pointer);
var
  s: string;
begin
  s := name + ': ' + pToHex(p);
  OutputDebugString(pchar(s));
end;

procedure dbgPrintPtr(const aPrefix: string; P: Pointer);
var
  s: string;
begin
  s := aPrefix + ': ' + pToHex(p);
  OutputDebugString(pchar(s));
end;

function  ptrAdd(const p: Pointer; const adelta: Integer): Pointer;
begin
  Result := pointer(integer(p) + adelta);
end;

function  byteAt(p: pointer; delta: integer): byte;
var
  pb: pbyte;
begin
  pb := p;
  inc(pb, delta);
  Result := pb^;
end;

function  longwordAt(p: pointer; delta: integer): longword;
var
  pl: PLongWord;
begin
  pl := ptrAdd(p, delta);
  Result := pl^;
end;

function  doubleAt(p: pointer; delta: integer): Double;
var
  pd: PDouble;
begin
  pd := ptrAdd(p, delta);
  Result := pd^;
end;

function  singleAt(p: pointer; delta: integer): Single;
var
  ps: PSingle;
begin
  ps := ptrAdd(p, delta);
  Result := ps^;
end;

function  format10thousandBaseValue(value: Integer): string;
var
  l: Integer;
begin
  Result := IntToStr(value);
  l := Length(Result);
  case l of
    1..4: ;
    5..8: Insert(' ', Result, l - 4 + 1);
  else
    Insert(' ', Result, l - 4 + 1);
    Insert(' ', Result, l - 8 + 1);
  end;
end;

function  formatMoney(const m: Integer): string;
begin
  Result := format10thousandBaseValue(m);
end;

function  formatCapacity(const c: Integer; const aTongUnitSuffix: Boolean): string;
begin
  Result := format10thousandBaseValue(c div UNIT_TONG);
  if aTongUnitSuffix then
    Result := Result + '(桶)';
end;

function  formatQty(q: Integer; const aIsPkgUnit: Boolean): string;
var
  c: double;
begin
  c := q;
  if aIsPkgUnit then
    c := c / UNIT_PKG
  else
    c := c / UNIT_TONG;

  Result := FormatCurr('0.0', c);
end;


procedure dbgStr(const s: string);
begin
  OutputDebugString(pchar(s));
end;

procedure dbgRect(const name: string; const r: TRect);
var
  s: string;
begin
  s := name + ': ' + IntToStr(r.Left) + ', ' + IntToStr(r.Top) + ', ' + IntToStr(r.Right) + ', ' + IntToStr(r.Bottom);
  dbgStr(s);
end;

procedure dbgXY(s: string; x, y: Integer);
begin
  s := s + ': ' + IntToStr(x) + ', ' + IntToStr(y);
  dbgStr(s);
end;

procedure dbgBool(s: string; b: Boolean);
begin
  s := s + ': ' + BoolToStr(b, True);
end;

//function combine(F, B, M: TColor32): TColor32;
//var
//  rf, gf, bf,
//  rb, gb, bb: byte;
//  ri, gi, bi, m2: integer;
//
//  function  c(var r: byte; m: integer): byte;
//  begin
//    m := r * m div 256;
//    if m >= 256 then
//      r := $FF
//    else
//      r := m;
//  end;
//
//begin
//  Color32ToRGB(F, rf, gf, bf);
//  Color32ToRGB(B, rb, gb, bb);
//
//  m2 := 256 - m;
//
//  ri := (rf * m + rb * m2) div 256;
//  gi := (gf * m + gb * m2) div 256;
//  bi := (bf * m + bb * m2) div 256;
//
//  if ri >= 256 then
//    rb := $FF
//  else
//    rb := ri;
//
//  if gi >= 256 then
//    gb := $FF
//  else
//    gb := gi;
//
//  if bi >= 256 then
//    bb := $FF
//  else
//    bb := bi;
//  Result := Color32(rb, gb, bb);
//end;

function  VTGetNodeByIndex(VT: TBaseVirtualTree; aIndex: Integer): PVirtualNode;
var
  N: PVirtualNode;
begin
  N := VT.GetFirst();
  Dec(aIndex);

  while aIndex >= 0 do
  begin
    Dec(aIndex);
    N := VT.GetNextSibling(N);
  end;

  Result := N;
end;

//function  VTIndexOfNote(VT: TBaseVirtualTree; n: PVirtualNode): Integer;
//begin
//  Result := n.Index;
//  dbgStr('node.index=' + IntToStr(Result));
//end;




{ TMyVTEditor }

procedure TMyVTEditor.WMKeyDown(var Message: TWMKeyDown);
var
  Tree: TBaseVirtualTree;
  ShiftState: TShiftState;

begin
  ShiftState := KeyDataToShiftState(Message.KeyData);
  if ShiftState <> [] then
  begin
    inherited;
    Exit;
  end;

  case Message.CharCode of
    VK_PRIOR:
    begin
      Tree := fLink.Tree;
      if Tree.CanSelectPrev() then
        if Tree.DoEndEdit() then
          PostMessage(Tree.Handle, UM_PAGE_UP, 0, 0);
      Message.Result := 0;
    end;

    VK_NEXT:
    begin
      Tree := fLink.Tree;
      if Tree.CanSelectNext() then
        if Tree.DoEndEdit() then
          PostMessage(Tree.Handle, UM_PAGE_DOWN, 0, 0);
      Message.Result := 0;

//      Tree := fLink.Tree;
////      PostMessage(Tree.Handle, UM_CANCEL_EDIT, 0, 0);
//      Message.Result := 0;
    end;

    VK_HOME:
    begin
      Tree := fLink.Tree;
      if (SelStart = 0) and (SelLength = 0) then
      begin
        if fLeftCount = 0 then
        begin
          fLeftCount := 1;
          inherited;
        end
        else
        begin
          fLeftCount := 0;
          PostMessage(Tree.Handle, UM_CANCEL_EDIT, 0, 0);
          Message.Result := 0;
        end;
      end
      else
      begin
        fLeftCount := 0;
        inherited;
      end;
    end;

    VK_END:
    begin
      Tree := fLink.Tree;
      if (SelStart = (Length(Text))) and (SelLength = 0) then
      begin
        if fRightCount = 0 then
        begin
          fRightCount := 1;
          inherited;
        end
        else
        begin
          fRightCount := 0;
          PostMessage(Tree.Handle, UM_CANCEL_EDIT, 0, 0);
          Message.Result := 0;
        end;
      end
      else
      begin
        fRightCount := 0;
        inherited;
      end;
    end;

    VK_LEFT:
    begin
      Tree := fLink.Tree;
      if (SelStart = 0) and (SelLength = 0) then
      begin
        if fLeftCount = 0 then
          fLeftCount := 1
        else
        begin
          fLeftCount := 0;
          PostMessage(Tree.Handle, UM_CANCEL_EDIT, 0, 0);
        end;
        Message.Result := 0;
      end
      else
      begin
        fLeftCount := 0;
        inherited;
      end;
    end;

    VK_RIGHT:
    begin
      Tree := fLink.Tree;
      
      if (SelStart = (Length(Text))) and (SelLength = 0) then
      begin
        if fRightCount = 0 then
          fRightCount := 1
        else
        begin
          fRightCount := 0;
          PostMessage(Tree.Handle, UM_CANCEL_EDIT, 0, 0);
        end;
        Message.Result := 0;
      end
      else
      begin
        fRightCount := 0;
        inherited;
      end;
    end;

    VK_UP:
      begin
        Tree := fLink.Tree;
        if Tree.CanSelectPrev() then
          if Tree.DoEndEdit() then
            Tree.PostSelectAndSetFocusMsg(False, True);
        Message.Result := 0;
      end;

    VK_DOWN:
      begin
        Tree := FLink.Tree;
        if Tree.CanSelectNext() then
          if Tree.DoEndEdit() then
            Tree.PostSelectAndSetFocusMsg(True, True);
        Message.Result := 0;
      end;

  else
    fLeftCount := 0;
    fRightCount := 0;
    inherited;
  end;
end;

{ TMyStringEditLink }

procedure TMyStringEditLink.InitEditor;
begin
  FEdit := TMyVTEditor.Create(Self);
  with FEdit do
  begin
    Visible := False;
    BorderStyle := bsSingle;
    AutoSize := False;
  end;
end;

procedure VTGetSelectedNodes(vt: TBaseVirtualTree; result: TList);
var
  n: PVirtualNode;
begin
  n := vt.GetFirstSelected();
  while n <> nil do
  begin
    result.Add(n);
    n := vt.GetNextSelected(n);
  end;
end;

procedure VTGetAllNodes(vt: TBaseVirtualTree; result: TList);
var
  n: PVirtualNode;
begin
  n := vt.GetFirst();
  while n <> nil do
  begin
    result.Add(n);
    n := vt.GetNext(n);
  end;
end;

procedure drawPriceCell(DC: HDC; rect: TRect; buy: boolean; s: WideString; textColor: cardinal);
const
  b_clr = $007979FF;
  s_clr = $0093FF93;
var
  b: WideString;
  color: TColor;
  bm: Integer;
begin
  if buy then
  begin
    b := 'B';
    color := b_clr;
  end
  else
  begin
    b := 'S';
    color := s_clr;
  end;

  SetTextColor(DC, color);
  bm := SetBkMode(DC, TRANSPARENT);
  InflateRect(rect, -4, -2);

  DrawTextW(DC, pwidechar(b), 1, rect, DT_SINGLELINE or DT_VCENTER or DT_LEFT, False);
  SetTextColor(DC, textColor);

  DrawTextW(DC, pwidechar(s), length(s), rect, DT_SINGLELINE or DT_VCENTER or DT_RIGHT, false);

  SetBkMode(DC, bm);
end;

procedure defaultDrawCell(
          vt: TVirtualStringTree;
          aPaintInfo: TVTPaintInfo;
          aTxtColor: TColor;
          aText: WideString);
var
  align: dword;
  r: TRect;
begin
  aPaintInfo.Canvas.FillRect(aPaintInfo.CellRect);


  case vt.Header.Columns[aPaintInfo.Column].Alignment of
    taLeftJustify: align := DT_LEFT;
    taRightJustify: align := DT_RIGHT;
  else
    align := DT_CENTER;
  end;

  r := aPaintInfo.CellRect;
  InflateRect(r, -4, -2);
  SetTextColor(aPaintInfo.Canvas.Handle, aTxtColor);
  DrawTextW(aPaintInfo.Canvas.Handle, pWideChar(aText), length(aText), r, DT_SINGLELINE or DT_VCENTER or align, False);

//  vt.GetTextInfo();
end;

procedure defaultDrawCell(
        vt: TVirtualStringTree;
        column: integer;
        canvas: TCanvas;
        cellRect: TRect;
        aTxtColor: TColor;
        aText: WideString);
var
  align: dword;
  r: TRect;
begin
  Canvas.FillRect(cellRect);


  case vt.Header.Columns[Column].Alignment of
    taLeftJustify: align := DT_LEFT;
    taRightJustify: align := DT_RIGHT;
  else
    align := DT_CENTER;
  end;

  r := cellRect;
  InflateRect(r, -4, -2);
  SetTextColor(Canvas.Handle, aTxtColor);
  DrawTextW(Canvas.Handle, pWideChar(aText), length(aText), r, DT_SINGLELINE or DT_VCENTER or align, False);
end;

//function TMyStringEditLink.InternalAcceptNewText(const aNewText: WideString;
//  var aErrHintTitle, aErrHintMsg: WideString): Boolean;
//begin
//
//end;

//procedure TMyStringEditLink.SetEdit(const Value: TVTEdit);
//begin
//  inherited;
//
//end;

procedure DrawSquigglyUnderlineEx(
        aDC: HDC; aPen: HPEN; aLeft, aTop, aWidth: Integer);
var
  x, y, r: Integer;
  OldPen: HPEN;
begin
  OldPen := SelectObject(aDC, aPen);
  MoveToEx(aDC, aLeft, aTop, nil);
  x := aLeft + 2;
  y := 2;
  r := aLeft + aWidth;

  while x < r do
  begin
    LineTo(aDC, x, aTop + y);
    Inc(x, 2);
    y := 2 - y;
  end;

  LineTo(aDC, r, aTop + y);
  SelectObject(aDC, OldPen);  
end;

procedure DrawSquigglyUnderlineClr(
        aDC: HDC;
        const aColor: TColor;
        aLeft, aTop, aWidth: Integer);
var
  Pen: HPEN;
begin
  Pen := CreatePen(PS_SOLID, 1, ColorToRGB(aColor));
  DrawSquigglyUnderlineEx(aDC, Pen, aLeft, aTop, aWidth);
  DeleteObject(Pen);
end;

procedure DrawDiagonalUnderlineEx(
        aDC: HDC;
        aPen: HPEN;
        aLeft, aTop, aWidth: Integer);
var
  x, endX, endY, r: Integer;
  OldPen: HPEN;
begin
  OldPen := SelectObject(aDC, aPen);

  r := aLeft + aWidth;

  x := aLeft;
  while x < r do
  begin
    MoveToEx(aDC, x, aTop + 2, nil);
    endX := x + 3;
    endY := aTop - 1;
    if endY > r then
    begin
      Inc(endY, endX - r);
      endX := r;
    end;
    LineTo(aDC, endX, endY);
    Inc(x, 4);
  end;

  SelectObject(aDC, OldPen);
end;

procedure DrawDiagonalUnderlineClr(
        aDC: HDC;
        const aColor: TColor;
        aLeft, aTop, aWidth: Integer);
var
  Pen: HPEN;
begin
  Pen := CreatePen(PS_SOLID, 1, ColorToRGB(aColor));
  DrawDiagonalUnderlineEx(aDC, Pen, aLeft, aTop, aWidth);
  DeleteObject(Pen);
end;

function FileExistsWide(const aFileName: WideString): Boolean;
var
  Code: Integer;
begin
  Code := GetFileAttributesW(PWideChar(aFileName));
  Result := (Code <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code = 0);
end;

function SimpleHexToBin(const aHexStr: string): string;
var
  L: Integer;
begin
  L := Length(aHexStr);
  if L > 0 then
  begin
    L := L div 2;
    SetLength(Result, L);
    HexToBin(PChar(aHexStr), PChar(Result), L);
  end
  else Result := '';
end;

function SimpleBinToHex(const aBinStr: string): string;
var
  L: Integer;
begin
  L := Length(aBinStr);
  if L > 0 then
  begin
    SetLength(Result, L * 2);
    BinToHex(PChar(aBinStr), PChar(Result), L);
  end
  else Result := '';
end;

procedure prettyPrintSaveXMLToStream(doc: IXMLDocument; str: TStream);
var
  pw: Boolean;
  tmp: TMemoryStream;
  tempDoc: IXMLDocument;
begin
  pw := doc.PreserveWhiteSpace;
  if pw then
    doc.PreserveWhiteSpace := False;

  tmp := TMemoryStream.Create();
  try
    doc.SaveToStream(tmp, ofNone);
    doc.PreserveWhiteSpace := pw;

    tempDoc := CreateXMLDoc();

    tmp.Position := 0;
    tempDoc.LoadFromStream(tmp);
    tempDoc.PreserveWhiteSpace := True;
    tempDoc.SaveToStream(str, ofIndent);    
  finally
    tmp.Destroy();
  end;
end;

procedure prettyPrintSaveXMLToFile(doc: IXMLDocument; const FileName: WideString);
var
  str: TFileStream;
begin
  str := TFileStream.Create(FileName, fmCreate);
  try
    prettyPrintSaveXMLToStream(doc, str);
  finally
    str.Destroy();
  end;
end;

procedure configError(const fn, msg: WideString);
begin
  raise Exception.Create(WideFormat('配置文件"%s"错误：%s', [fn, msg]));
end;



end.
