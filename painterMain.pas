unit painterMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GR32, GR32_Image, GR32_RangeBars,
  GR32_Transforms, GR32_Resamplers, GR32_Layers, ExtCtrls, StdCtrls, Buttons,
  ComCtrls, Grids, citypos, GR32_Text, pngimage, GR32_Lines, GR32_Blend,
  GR32_Filters, p3DataStruct;

type
  TZooms = array[1..5] of Single;

  Timage32_ex = class(TImage32)
  protected
//    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
  end;
  
  TForm1 = class(TForm)
    SrcImage: TImage32;
    numBmpList: TBitmap32List;
    img321: TImage32;
    imgShouPi: TImage32;
    procedure FormCreate(Sender: TObject);
    procedure MapMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure MapMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer;
      Layer: TCustomLayer);
    procedure MapMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure MapKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MapMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure MapMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
//    SrcRubberBandLayer: TRubberBandLayer;
//    Map:
    AT: TAffineTransformation;
//    PT: TProjectiveTransformation;
    TT: TTransformation;
    DraggedVertex: Integer;
    LastMousePos: TPoint;
    Vertices: array[0..3] of TPoint;
    bmpWidth, bmpHeigh: Integer;
    minLeft, maxLeft, minTop, MaxTop: Integer;
    mapLeft, mapTop: Integer;
    SrcRect: TFloatRect;
    Map: Timage32_ex;
    CityPos: TCityPositions;
    drawArrow: Boolean;
    drawArrowHeading: TFixedPoint;
    routeLineDrawer: TLine32;

    routes: TArrayOfFixedPoint;
    citiesRectCache: TCitiesRectCache;

    drawRaiseRect: Boolean;
    raiseRect: TRect;
    hintPt: TPoint;
    firstPt, middlePt: TFixedPoint;

    red_button: TBitmap32;
    hintBmp, hintTempBmp: TBitmap32;

    procedure SrcRBResizingEvent(Sender: TObject; const OldLocation: TFloatRect;
      var NewLocation: TFloatRect; DragState: TDragState; Shift: TShiftState);

    procedure InitVertices; // for projective mapping
    procedure GenTransform();
    procedure DoTransform();

    procedure drawCity(internalCode: Byte);
    procedure drawRoute();

    procedure onAppIdle(aSender: TObject; var Done: Boolean);
    function  shouldDrawCity(internalCode: Byte): Boolean;
    function  getButtonBmp(internalCode: Byte): TBitmap32;

    procedure calcRoutePoints();
    procedure testBlendTransfer();

    procedure drawCityRaiseRect();

    procedure recalcCityRectCaches();
//    procedure drawRaiseRect;
    function  findCityRect(x, y: Integer): Boolean;

    procedure drawUnsatisfiedItems();

    procedure onMapMouseLeave(sender: TObject);
  public
    { Public declarations }
    destructor Destroy; override;
  end;

var
  Form1: TForm1;
  Zooms: TZooms;
  ZoomIndex: Integer;

implementation

uses Types;



{$R *.dfm}
function  createRouteLine(): TLine32;
var
  line: TLine32;
begin
  line := TLine32.Create();

  line.EndStyle := esSquared;

  with line do
  begin
    ArrowStart.Color := clYellow32;
    ArrowStart.Pen.Width := 1.5;
    ArrowStart.Pen.Color := clWhite32;

    ArrowStart.Style := asNone;

    ArrowEnd.Color := clYellow32;
    ArrowEnd.Pen.Color := clWhite32;
    ArrowEnd.Size := 8;
    ArrowEnd.Pen.Width := 1;

    ArrowEnd.Style := asFourPoint;
  end;

  Result := line;
end;

function  selfPoints(const aFirstPt: TPoint): TArrayOfPoint;
begin
  SetLength(Result, 4);
  Result[0] := aFirstPt;
  Result[1].X := aFirstPt.X - 10;
  Result[1].Y := aFirstPt.Y - 30;
  Result[2].X := aFirstPt.X + 20;
  Result[2].Y := aFirstPt.Y - 35;
  Result[3].X := aFirstPt.X + 20;
  Result[3].Y := aFirstPt.Y - 10;
end;

function  toFixedPointArray(const aPts: TArrayOfPoint): TArrayOfFixedPoint;
var
  i, l: Integer;
begin
  l := length(apts);
  SetLength(Result, l);

  for I := 0 to l - 1 do
  begin
    Result[i] := FixedPoint(apts[i].x, apts[i].Y);
  end;
end; 


procedure dbgStr(const S: string);
begin
  OutputDebugString(pchar(s));
end;

procedure dbgPointArr(pa: TArrayOfFixedPoint);
var
  i, l, x, y: integer;
begin
  l := length(pa);
  dbgStr('length=' + IntToStr(l));

  for I := 0 to l - 1 do
  begin
    x := pa[i].X;
    y := pa[i].Y;

    dbgStr('x=' + IntToStr(x) + ', y=' + IntToStr(y));
  end;
end;

function  calcMiddlePoint(pt1, pt2: TFixedPoint): TFixedPoint;
begin
  if (pt1.X = pt2.X) and (pt1.y = pt2.Y) then
  begin
    Result.X := pt1.X + Fixed(40);
    Result.Y := pt1.Y + Fixed(40);
  end
  else
  begin
    Result.X := (pt1.X + pt2.X) div 2;
    Result.Y := (pt1.Y + pt2.Y) div 2;
  end;
end;  

procedure TForm1.calcRoutePoints;
var
  i, l, x, y, tx, ty: Integer;
  btnXDelta, btnYDelta: integer;
  first: TPoint;
  ptrs: TArrayOfPoint;
  fixedptrs: TArrayOfFixedPoint;    
begin
  btnXDelta := red_button.Width div 2;
  btnYDelta := red_button.Height div 2;
  SetLength(routes, 3);

  CityPos.getXY(14, x, y);

  first := Point(x, y);

  Ptrs := selfPoints(first);
  fixedptrs := toFixedPointArray(ptrs);

  firstPt := fixedptrs[0];

  middlePt := fixedptrs[2];


//  CityPos.getXY(14, x, y);
//  lastPt := FixedPoint(x + btnXDelta + 10, y + btnYDelta + 10);
//
//
//
//  middlePt := calcMiddlePoint(firstPt, lastPt);


//  pt3.X := (pt1.X + pt2.X) div 2;
//  pt3.Y := (pt1.Y + pt2.Y) div 2;  
//
  routes := GetCBezierPoints(fixedptrs);
//
//  l := length(routes);
//  dbgStr('length=' + IntToStr(l));
//
//  for I := 0 to l - 1 do
//  begin
//    x := routes[i].X;
//    y := routes[i].Y;
//
//    dbgStr('x=' + IntToStr(x) + ', y=' + IntToStr(y));
//  end;
end;

destructor TForm1.Destroy;
begin
  inherited;

  FreeAndNil(red_button);
  FreeAndNil(CityPos);
  FreeAndNil(routeLineDrawer);
  FreeAndNil(hintBmp);
end;

procedure TForm1.DoTransform;
var
  i: Integer;
  r: TRect;
begin
  GenTransform();

  Map.BeginUpdate;

  Map.Bitmap.Clear($00000000);
//  r := Map.BoundsRect;
//  InflateRect(r, -r.Left, -r.Top);
  Transform(Map.Bitmap, SrcImage.Bitmap, TT);

  for I := 0 to citypos.Count - 1 do
    drawCity(i);

  drawRoute();

  testBlendTransfer();
  drawCityRaiseRect();
//  drawRaiseRect();

  Map.EndUpdate;
  Map.Invalidate;  
end;

procedure TForm1.drawCity(internalCode: Byte);
var
  x, y, x2: Integer;
  bmp, nameBmp: TBitmap32;
begin
  if not shouldDrawCity(internalCode) then
    exit;

  bmp := getButtonBmp(internalCode);

  x := cityPos.items[internalCode].X;
  y := cityPos.items[internalCode].y;
  
  Inc(x, mapLeft);
  inc(y, mapTop);

  if x < (0 - bmp.Width + 1) then
    exit;

  if x > Map.Width then
    exit;

  if y < (0 - bmp.Height + 1) then
    exit;

  if y > Map.Height then
    exit;

  bmp.DrawTo(Map.Bitmap, x, y);

  x2 := x + bmp.Width + 2;

  bmp := CityPos.getTextBitmap(internalCode);
  bmp.DrawTo(Map.Bitmap, x2, y);

  Inc(y, bmp.Height + 4);

  imgShouPi.Bitmap.DrawTo(Map.Bitmap, x2, y);
end;

function func(F, B, M: TColor32): TColor32;
var
  rf, gf, bf,
  rb, gb, bb: byte;
  ri, gi, bi, m2: integer;

  function  c(var r: byte; m: integer): byte;
  begin
    m := r * m div 256;
    if m >= 256 then
      r := $FF
    else
      r := m;
  end;

begin
  Color32ToRGB(F, rf, gf, bf);
  Color32ToRGB(B, rb, gb, bb);

  m2 := 256 - m;

  ri := (rf * m + rb * m2) div 256;
  gi := (gf * m + gb * m2) div 256;
  bi := (bf * m + bb * m2) div 256;

  if ri >= 256 then
    rb := $FF
  else
    rb := ri;

  if gi >= 256 then
    gb := $FF
  else
    gb := gi;

  if bi >= 256 then
    bb := $FF
  else
    bb := bi;
  Result := Color32(rb, gb, bb);
end;

procedure TForm1.drawCityRaiseRect;
var
  i: Integer;
  r, r2, r3: TRect;
begin
  if not drawRaiseRect then
    exit;

  Map.Bitmap.RaiseRectTS(raiseRect, 100);

  r2 := hintBmp.BoundsRect;
  r := r2;
  OffsetRect(r, hintPt.X, hintPt.Y);

  Map.Bitmap.DrawTo(hintTempBmp, 0, 0, r);

  BlendTransfer(
        Map.Bitmap, hintPt.X, hintPt.Y, Map.Bitmap.ClipRect,
        hintBmp,
        hintBmp.BoundsRect,
        hintTempBmp,
        hintTempBmp.BoundsRect,
        CombineReg,
        200);


  InflateRect(r, 2, 2);
  Map.Bitmap.FrameRectS(r, clWhite32);
end;

//procedure TForm1.drawRaiseRect;
//begin
//  Map.Bitmap.RaiseRectTS(200, 20, 360, 52, 100);
//end;

procedure TForm1.drawRoute;
var
  i: integer;
  x, y: integer;
  pts: TArrayOfFixedPoint;
  line: TLine32;
  pt, firstPtCpy: TFixedPoint;
begin
  SetLength(pts, length(routes));

  for I := 0 to length(routes) - 1 do
  begin
    x := routes[I].X;
    y := routes[I].Y;

    inc(x, Fixed(mapLeft));
    inc(y, Fixed(mapTop));

    pts[i].X := x;
    pts[i].Y := y;
  end;

  firstPtCpy := firstPt;
  firstPtCpy.X := firstPtCpy.X + Fixed(mapLeft);
  firstPtCpy.Y := firstPtCpy.Y + Fixed(mapTop);

  line := routeLineDrawer;

  line.Clear();
  line.SetPoints(pts);

  line.Draw(Map.Bitmap, 2, [clWhite32, clBlue32, clBlue32, clBlue32, clBlue32], 0.65);

//  pt := calcMiddlePoint(firstPt, lastPt);
  pt := middlePt;
  pt.X := pt.X shr 16 + mapLeft;
  pt.Y := pt.Y shr 16 + mapTop;



  Map.Bitmap.Draw(pt.X + 1, pt.Y + 1, numBmpList.Bitmap[0]);

  if drawArrow then
  begin
    line.Clear();
    line.SetPoints(
            [
                    firstPtCpy,
                    FixedPoint(drawArrowHeading.X, drawArrowHeading.Y)
            ]
          );
    line.Draw(Map.Bitmap, 2, [clWhite32, clYellow32, clYellow32, 0, 0], 0.65);
  end;
end;

procedure TForm1.drawUnsatisfiedItems;
begin
  //
end;

function TForm1.findCityRect(x, y: Integer): Boolean;
var
  I, left, top, y2: integer;
  pt: TPoint;
begin
  pt.X := x;
  pt.Y := y;

  recalcCityRectCaches();

  for I := MIN_INTERNAL_CITY_CODE to MAX_INTERNAL_CITY_CODE do
  begin
    raiseRect := citiesRectCache.rects[I];
    if PtInRect(raiseRect, pt) then
    begin
      drawRaiseRect := True;


      left := raiseRect.Left - 10 - hintBmp.Width;
      if left > 0 then
      begin
        hintPt.X := left;
      end
      else
      begin
        hintPt.X := raiseRect.Right + 10;
      end;

      y2 := raiseRect.Top + hintBmp.Height;

      if y2 < Map.Height then
        hintPt.Y := raiseRect.Top
      else
      begin
        y2 := Map.Height - hintBmp.Height - 1;
        hintPt.Y := y2;
      end;
      exit;
    end;
  end;

  drawRaiseRect := False;
end;

//procedure ChromaKey(ABitmap: TBitmap32; TrColor: TColor32);    // former CromaKey <v1.8.3
//var
//  P: PColor32;
//  C: TColor32;
//  I: Integer;
//begin
//  TrColor := TrColor and $00FFFFFF; // erase alpha, (just in case it has some)
//  with ABitmap do
//  begin
//    P := PixelPtr[0, 0];
//    for I := 0 to Width * Height - 1 do
//    begin
//      C := P^ and $00FFFFFF; // get RGB without alpha
//      if C = TrColor then // is this pixel "transparent"?
//        P^ := C; // write RGB with "transparent" alpha back into the SrcBitmap
//      Inc(P); // proceed to the next pixel
//    end;
//  end;
//end;


procedure TForm1.FormCreate(Sender: TObject);
begin
  citiesRectCache.reset();
  
  routeLineDrawer := createRouteLine();
  
  CityPos := TCityPositions.Create(Font);
  CityPos.load();



  red_button := TBitmap32.Create();
//  red_button.LoadFromFile('V:\temp\p3info\inject\test6\imgs\red-button2.bmp');
  red_button.LoadFromFile('V:\temp\p3info\inject\test6\imgs\big-red-button.png');


  ChromaKey(red_button, clBlack);
  red_button.DrawMode := dmBlend;

  calcRoutePoints();
//  red_button.ResetAlpha();


  
  SrcImage.Bitmap.LoadFromFile('V:\temp\p3\p3insight-stuff\images\map.png');
//  ImgView321.Bitmap.LoadFromFile('map.bmp');
//  Map.MouseWheelHandler();

  bmpWidth := SrcImage.Bitmap.Width;
  bmpHeigh := SrcImage.Bitmap.Height;

  



  Map := Timage32_ex.Create(Self);
  Map.Left := 16;
  Map.Top := 8;
  Map.Width := 800;
  Map.Height := 441;
  Map.OnMouseDown := MapMouseDown;
  Map.OnMouseMove := MapMouseMove;
  Map.OnMouseUp := MapMouseUp;
  Map.OnMouseWheel := MapMouseWheel;
  Map.OnMouseLeave := onMapMouseLeave;
  Map.OnKeyUp := MapKeyUp;
  Map.Parent := Self;
  Map.RepaintMode := rmOptimizer;
  Map.ScaleMode := smOptimalScaled;

  Map.SetupBitmap();
//  Map.Bitmap.MasterAlpha := 10;

  minLeft := Map.Width - bmpWidth + 3;
  maxLeft := 0;
  minTop := Map.Height - bmpHeigh + 3;
  MaxTop := 0;

  mapLeft := 0;
  mapTop := 0;

  DraggedVertex := -1;

  InitVertices();

//  SrcRubberBandLayer := TRubberBandLayer.Create(Map.Layers);
//  SrcRubberBandLayer.OnResizing := SrcRBResizingEvent;
//  SrcRubberBandLayer.Location := FloatRect(0, 0, bmpWidth- 1, bmpHeigh- 1);
  SrcRect := FloatRect(0, 0, bmpWidth-1, bmpHeigh-1);



  AT := TAffineTransformation.Create;
  AT.SrcRect := SrcRect;
  TT := AT;

//    OutputDebugString(pchar('left' + inttostr(mapLeft)));
//
//    OutputDebugString(pchar('top' + IntToStr(mapTop)));

  hintBmp := TBitmap32.Create();
  hintBmp.Width := 160;
  hintBmp.Height := 220;

  hintBmp.Clear(clWhite32);
  hintBmp.Font.Color := clRed;
  hintBmp.Font.Size := 12;
  hintBmp.Font.Style := [fsBold];
  hintBmp.Textout(1, 1, 'This is a test!');

  hintTempBmp := TBitmap32.Create();
  hintTempBmp.Width := hintBmp.Width;
  hintTempBmp.Height := hintBmp.Height;

  DoTransform();

  Application.OnIdle := onAppIdle;
end;

procedure TForm1.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var
  c: TControl;
begin
  Handled := True;

  c := ControlAtPos(MousePos, False, True);

  if c = Map then
    Map.SetFocus();
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  FocusControl(Map);
end;


procedure TForm1.GenTransform;
var
  s: Single;
begin
  AT.Clear();
  AT.Translate(mapLeft, mapTop);
  if ZoomIndex <> 3 then
  begin
    s := Zooms[ZoomIndex];
    AT.Scale(s, s);
  end;
end;

function TForm1.getButtonBmp(internalCode: Byte): TBitmap32;
begin
  Result := red_button;
end;

procedure TForm1.InitVertices;
begin
  Vertices[0].X := 0;
  Vertices[0].Y := 0;
  Vertices[1].X := SrcImage.Bitmap.Width - 1;
  Vertices[1].Y := 0;
  Vertices[2].X := SrcImage.Bitmap.Width - 1;
  Vertices[2].Y := SrcImage.Bitmap.Height - 1;
  Vertices[3].X := 0;
  Vertices[3].Y := SrcImage.Bitmap.Height - 1;
end;

procedure TForm1.MapKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = 0) and (Shift = [ssCtrl]) then
  begin
    if drawArrow then
    begin
      drawArrow := False;
      DoTransform();
    end;
  end;
end;

procedure TForm1.MapMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
var
  changed: Boolean;
  I: Integer;
begin
  DraggedVertex := -1;
  changed := drawArrow;
  drawArrow := mbLeft = Button;
  if drawArrow then
  begin
    drawArrowHeading.X := x;
    drawArrowHeading.Y := y;
  end;

  changed := drawArrow <> changed;

  for I := 0 to 3 do
  begin
    if (Abs(Vertices[I].X - X) < 3) and (Abs(Vertices[I].Y - Y) < 3) then
    begin
      DraggedVertex := I;
      Break;
    end;
  end;

  // or drag all of them, (DragVertex = 4)
  if DraggedVertex = -1 then DraggedVertex := 4;

  // store current mouse position
  LastMousePos := Point(X, Y);

  if changed then
    DoTransform();
end;

procedure TForm1.MapMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer; Layer: TCustomLayer);
var
  Dx, Dy, I, newMapX, newMapY: Integer;
  r: TFloatRect;
  pt: TPoint;
  redraw: Boolean;
begin
////  if [ssCtrl] = Shift then
////  begin
//    DraggedVertex := -1;
//
////    pt := Map.ScreenToClient(Point(x, y));
//    drawArrowHeading.X := X; // - mapLeft;
//    drawArrowHeading.Y := y; // - mapTop;
//    drawArrow := True;
//    DoTransform();
//    exit;
//  end;

//  recalcCityRectCaches();
  

  if DraggedVertex = -1 then
  begin
    redraw := findCityRect(X, y);
    if drawArrow then
    begin
      redraw := true;
      drawArrowHeading.X := X;
      drawArrowHeading.Y := y;
//      drawArrow := False;

    end;

    if redraw then
      DoTransform();
    Exit; // mouse is not pressed
  end;



  if drawArrow then
  begin
    drawArrowHeading.X := X; // - mapLeft;
    drawArrowHeading.Y := y; // - mapTop;
//    drawArrow := True;
  end;
//  else
//    drawArrow := False;

  Dx := X - LastMousePos.X;
  Dy := Y - LastMousePos.Y;

  newMapX := mapLeft + Dx;
  newMapY := mapTop + Dy;
  
  if newMapX < minLeft then
    Dx := minLeft - mapLeft
  else if newMapX > maxLeft then
    Dx := maxLeft - mapLeft;

  if newMapY < minTop then
    Dy := minTop - mapTop 
  else if newMapY > MaxTop then
    Dy := MaxTop - mapTop;

  LastMousePos := Point(x, y);

//    OutputDebugString(pchar('x=' + inttostr(x)));
//
//  if mapTop < minTop then
//    OutputDebugString(pchar('y=' + IntToStr(y)));

  if (Dx = 0) and (Dy = 0) then
    exit;



  Inc(mapLeft, Dx);
  Inc(mapTop, Dy);



  citiesRectCache.reset();

  findCityRect(x, y);


//  r.Left := mapLeft;
//  r.Right := mapLeft + bmpWidth;
//  r.Top := mapTop;
//  r.Bottom := mapTop + bmpHeigh;
//
//  AT.SrcRect := r;                


//  // update coords
//  if DraggedVertex = 4 then
//  begin
//    for I := 0 to 3 do
//    begin
//      Inc(Vertices[I].X, Dx);
//      Inc(Vertices[I].Y, Dy);
//    end;
//  end
//  else
//  begin
//    Inc(Vertices[DraggedVertex].X, Dx);
//    Inc(Vertices[DraggedVertex].Y, Dy);
//  end;

  DoTransform;
end;

procedure TForm1.MapMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
begin
  DraggedVertex := -1;
//  if drawArrow then
//  begin
//    drawArrow := False;
//    DoTransform();
//  end;
end;

procedure TForm1.MapMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if WheelDelta < 0 then
  begin
    if ZoomIndex = 1 then
      exit;

    Dec(ZoomIndex);
  end
  else
  begin
    if ZoomIndex = 5 then
      Exit;

    Inc(ZoomIndex);
  end;

  DoTransform();
end;

procedure TForm1.MapMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if ZoomIndex = 5 then
    Exit;

  Inc(ZoomIndex);
  DoTransform();
end;

procedure TForm1.onAppIdle(aSender: TObject; var Done: Boolean);
begin
  Map.Invalidate();
end;



procedure TForm1.onMapMouseLeave(sender: TObject);
begin
  DraggedVertex := -1;
end;

procedure TForm1.recalcCityRectCaches;
var
  r, r2: TRect;
  x, y: integer;
  code: byte;
begin
  if citiesRectCache.Ready then
    exit;
    
  r := Rect(0, 0, 160, 32);

  for code := MIN_INTERNAL_CITY_CODE to MAX_INTERNAL_CITY_CODE do
  begin
    x := cityPos.items[code].X;
    y := cityPos.items[code].y;

    Inc(x, mapLeft);
    Inc(y, mapTop);

    citiesRectCache.Rects[code] := r;
//    r2 := r;
    OffsetRect(citiesRectCache.Rects[code], x, y);
  end;

  citiesRectCache.Ready := True;

//  RaiseRectTS(200, 20, 360, 52, 100);
end;

function TForm1.shouldDrawCity(internalCode: Byte): Boolean;
begin
  Result := True;
end;

procedure TForm1.SrcRBResizingEvent(Sender: TObject;
  const OldLocation: TFloatRect; var NewLocation: TFloatRect;
  DragState: TDragState; Shift: TShiftState);
var
  l, t, r, b: Integer;
begin
  if DragState = dsMove then
  begin
    NewLocation := OldLocation;
//    if NewLocation.Left < minLeft then
//    begin
//      NewLocation.Left := minLeft;
//      NewLocation.Right := minLeft + bmpWidth;
//    end
//    else if NewLocation.Left > maxLeft then
//    begin
//      NewLocation.Left := maxLeft;
//      NewLocation.Right := maxLeft + bmpWidth;
//    end;
//
//    if NewLocation.Top < minTop then
//    begin
//      NewLocation.Top := minTop;
//      NewLocation.Bottom := minTop + bmpHeigh;
//    end
//    else if NewLocation.Top < MaxTop then         
//    begin
//      NewLocation.Top := MaxTop;
//      NewLocation.Bottom := MaxTop + bmpHeigh;
//    end;

//    l := Trunc(NewLocation.Left);
//    t := Trunc(NewLocation.Top);
//    r := Trunc(NewLocation.Right);
//    b := Trunc(NewLocation.Bottom);
//
//    Vertices[0].X := l;
//    Vertices[0].Y := 0;
//
//    Vertices[1].X := r;
//    Vertices[1].Y := 0;
//
//    Vertices[2].X := r;
//    Vertices[2].Y := b;
//    
//    Vertices[3].X := 0;
//    Vertices[3].Y := t;
  end;
  
  DoTransform();
end;

procedure blendcb();
begin

end;

procedure TForm1.testBlendTransfer;
var
  r: TRect;
begin
//  r := img321.Bitmap.BoundsRect;
//  OffsetRect(r, 10, 10);
//  BlendTransfer(
//          Map.Bitmap,
//          10, 10,
//          Map.ClientRect,
//          img321.Bitmap,
//          img321.Bitmap.BoundsRect(),
//          Map.Bitmap,
//          r,
//          BlendRegEx,
//          180);
end;

procedure iniZooms();
begin
  Zooms[1] := 0.25;
  Zooms[2] := 0.5;
  Zooms[3] := 1.0;
  Zooms[4] := 2.5;
  Zooms[5] := 5;

  ZoomIndex := 3;
end;

{ Timage32_ex }

//procedure Timage32_ex.WMMouseWheel(var Message: TWMMouseWheel);
//begin
//  DefaultHandler(Message);
//end;

initialization
  iniZooms();


end.
