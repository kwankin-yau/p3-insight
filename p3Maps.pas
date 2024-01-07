unit p3Maps;

interface
uses
  SysUtils, Classes, Windows, PngImage, Types, Graphics, p3DataStruct,
  GR32, GR32_Filters, p3Types, GR32_Resamplers,
  GR32_Transforms, GR32_Image, p3insight_utils, GR32_Layers, Controls,
  GR32_Blend, GR32_Lines, Contnrs;

type
  TTradeRouteLine = class(TLine32)
  public
    RoutePointIndex: Integer;
    IsCyclePoints: Boolean;
    procedure Clear; override;
    procedure setCyclePoints(pt: TFixedPoint);
  end;
  
  IMapViewerInfoProvider = interface
  ['{A987F749-9562-460F-A837-2A8082491E31}']
    function  getResidentConsumePrecalc(): TResidentConsumePrecalc;
    function  getBO(const pid, city: integer): PBusinessOffice;
  end;
  
  TCityIconNameState = (
    NotUsed,
    NotDrawed,
    IconRedraw,
    Ready
  );

  TMapGoodsDemand = record
    ProdLvl: integer; //0 - 不是特产，1 - 低产，2 - 高产
    product, remains, consume: double;
    citySPrice, cityPPrice: Integer;

    procedure reset();
    procedure addProduct(prod: double);
    procedure addConsume(cons: double);
    procedure calcRemains();
    procedure calcPrices(city, goodsID: integer);
  end;
  PMapGoodsDemand = ^TMapGoodsDemand;

  TMapCityPeople = record
    total, rich, common, poor: Integer;

    procedure init(city: integer);
  end;

  PMapCityPeople = ^TMapCityPeople;

  TMapCityInfo = class
  private
    procedure reloadGoodsDemand();
  public
    cityInfoProv: IMapViewerInfoProvider;
    cityCode: Byte;
    cityName: WideString;



    goodsDemandInfoReady: Boolean;
    goodsDemand: array[MIN_GOODS_ID..MAX_GOODS_ID] of TMapGoodsDemand;

    peopleInfoReady: Boolean;
    people: TMapCityPeople;

    constructor Create(cityCode: Byte; cityInfoProv: IMapViewerInfoProvider);

    function  getGoodsDemand(const aGoodsID: integer): PMapGoodsDemand;
    function  getPeople(): PMapCityPeople;
  end;

  TMapCityInfoCache = class
  private
    fPrepared: Boolean;
    procedure clearCityInfo();
    procedure internalPrepare();
  public
    cityInfoProv: IMapViewerInfoProvider;
    Period: Integer;
    cityCount: Integer;
    CityInfo: array[MIN_CITY_CODE..MAX_CITY_CODE] of TMapCityInfo;

    constructor Create(cityInfoProv: IMapViewerInfoProvider);
    destructor Destroy; override;

    procedure reset(period: Integer);

    procedure prepare();
    function  getCityInfo(city: Integer): TMapCityInfo;
  end;
  
  TCachedMapInfoOptions = record
    doDrawCityName: Boolean;
  end;

  TTradeRouteDrawInfoItem = record
    Index: Integer;
    OrgTradeRouteIndex: Word;
    CityCode: Byte;
  end;

  TCityRoutePointIndices = record
    count: integer;
    indices: array[1..20] of Integer;
    idxIconRectCombine: TRect;
    idxIconRects: array[1..20] of TRect;
    procedure reset();

    procedure add(index: integer);
  end;
  PCityRoutePointIndices = ^TCityRoutePointIndices;

  TTradeRouteDrawInfo = record
    Ready: Boolean;
    Ship: PP3R2Ship;
    SelectedRouteIndex: Integer;
    Count: Integer;
    TradeRoutes: array[1..20] of TTradeRouteDrawInfoItem;
    CityRoutePointIndices: array[MIN_CITY_CODE..MAX_CITY_CODE] of TCityRoutePointIndices;

    procedure init();
    procedure reset();

    procedure resetCityRoutePointIndices();
  end;

  TTempDrawInfo = record
    tempBitmap: TBitmap32;
//    selectedFont: TFont;
    top: integer;
//    width: integer;
//    height: integer;
    tempLeft: integer;

    x, y: integer;
  end;

  TCachedMapInfo = class
  public const
    ORG_MAP_WIDTH = 2400;
    ORG_MAP_HEIGHT = 1800;
  private
    procedure initCityIcons();
    procedure copyFromSrcOrg();
    procedure drawToTarget();  
    procedure drawCityName(
            bmp: TBitmap32;
            const aCityCode: Integer);
    procedure drawCityIcon(const aCityCode: Integer);
    procedure doDrawGoodsInfo(city: integer; var tempDrawInfo: TTempDrawInfo);
    procedure drawTradeRouteLines(target: TBitmap32);
  private
    fPrepared: Boolean;
//    fIsOrgMapSize: Boolean;
    fCityCount: Integer;
    fCityPos: array[MIN_CITY_CODE..MAX_CITY_CODE] of TPoint;

    fIconType: array[MIN_CITY_CODE..MAX_CITY_CODE] of TCityIconType;
    fIconNameState: array[MIN_CITY_CODE..MAX_CITY_CODE] of TCityIconNameState;
    fRectOfCityIconAndName: array[MIN_CITY_CODE..MAX_CITY_CODE] of TRect;

//    fCityIconTypeProv: TCityIconTypeProvider;

//    fCityIconState: array[MIN_CITY_CODE..MAX_CITY_CODE] of Boolean;
    fCityIconEdgeLen, fCityIconEdgeLen_Half: Integer;
//    fMapSize: TPoint;
    fMapSrcReady: Boolean;
    fMapSrcOrg, fMapSrc, fMapTemp: TBitmap32;
    fSrcMapRect: TRect;
    fMapPainter: TImage32;
    fCityIcons: array[TCityIconType] of TBitmap32;
    fGoodsImaegProv: TGoodsImageProvider;
    fStdCityIconAndNameRect: TRect;
    fCityInfoTempBmp, fCityInfoTempBmp2: TBitmap32;
    fTempRoutePointNumBmp: TBitmap32;
    fRoutePointNumBmpRect: TRect;

    fProdStar: TBitmap32;


    fCityNameFont: TFont;
    fSelectedCity: Byte;


    minLeft, maxLeft, minTop, MaxTop: Integer;

    fAT: TAffineTransformation;

    fDrawCityName: Boolean;
    fMapDraging: Boolean;

    fCityInfoCache: TMapCityInfoCache;
    fTradeRouteDrawInfo: TTradeRouteDrawInfo;
    fTradeRouteLines: TObjectList;
    fActiveTradeRouteLines: TList;
    fNumBmpList: TBitmap32List;
    fNumBmpEdgeLen: integer;

    procedure loadResource();

    //return true if changed
    function  updateCityPosAndIconType(): Boolean;

    procedure resetCityPos();
    procedure resetCityIconsTypes();

    function  projectToMap(var aCityPos: TPoint): TPoint;


    procedure prepareMapSrc();

    function  createFont(
            const name: WideString;
            const sz: Integer;
            const clr: TColor;
            const bold: Boolean): TFont;

    procedure createFonts();
    procedure freeFonts();
    procedure recalcMinMaxMapPos();
    procedure rebuildTradeRouteLines();
    function  createGraphObj_RouteLine(): TTradeRouteLine;
    procedure notifySelectedRoutePointIndexChanged();
  private
    fOnSelectedRoutePointIndexChanged: TNotifyEvent;
    //events
    procedure MapResize(Sender: TObject);
    procedure SetDrawCityName(const Value: Boolean);
    procedure MapMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure MapMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer;
      Layer: TCustomLayer);
    procedure MapMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
  public
    DrawGoodsInfo: array[MIN_GOODS_ID..MAX_GOODS_ID] of Boolean;
    fMapXDelta, fMapYDelta: Integer;
    fCityPosInMap: array[MIN_CITY_CODE..MAX_CITY_CODE] of TPoint;
    fLastMousePos: TPoint;

    constructor Create(
            aMapPainter: TImage32;
            aGoodsImaegProv: TGoodsImageProvider;
            const aOptions: TCachedMapInfoOptions;
            const cityInfoProv: IMapViewerInfoProvider;
            aNumBmpList: TBitmap32List);

    destructor Destroy; override;

    procedure reset();
    procedure update();
    procedure prepare();
    procedure deactivate();

    procedure clearDrawGoodsInfo();
    procedure setTradeRouteDrawInfo(ship: PP3R2Ship; tradeRouteIndices: TTradeRouteIndices);
    procedure selectRoutePoint(index: integer; doUpdate: Boolean);  
    procedure resetTradeRouteDrawInfo();
    procedure showCity(city: Integer; forceUpdate: Boolean);
    function  getSelectedRoutePointIndex(): Integer;


    property  PropDrawCityName: Boolean read fDrawCityName write SetDrawCityName;
    property  ProdStar: TBitmap32 read fProdStar;

    property  OnSelectedRoutePointIndexChanged: TNotifyEvent
          read fOnSelectedRoutePointIndexChanged write fOnSelectedRoutePointIndexChanged;
  end;

implementation

uses p3insight_common;

{ TCachedMapInfo }




procedure TCachedMapInfo.clearDrawGoodsInfo;
var
  I: integer;
begin
  for I := MIN_GOODS_ID to MAX_GOODS_ID do
    DrawGoodsInfo[I] := False;
end;

procedure TCachedMapInfo.copyFromSrcOrg;
begin
//  OutputDebugString('copyFromSrcOrg->');
  BlockTransfer(
          fMapSrc,
          0,
          0,
          fSrcMapRect,
          fMapSrcOrg,
          fSrcMapRect,
          dmOpaque);
//  OutputDebugString('<-copyFromSrcOrg');
end;

constructor TCachedMapInfo.Create(
        aMapPainter: TImage32;
        aGoodsImaegProv: TGoodsImageProvider;
        const aOptions: TCachedMapInfoOptions;
        const cityInfoProv: IMapViewerInfoProvider;
        aNumBmpList: TBitmap32List);
var
  I: integer;
  line: TTradeRouteLine;
//        aCityIconTypeProv: TCityIconTypeProvider);
begin
//  OutputDebugString('TCachedMapInfo.Create->');
  fNumBmpList := aNumBmpList;
  fNumBmpEdgeLen := fNumBmpList.Bitmap[0].Width;


  fMapPainter := aMapPainter;
  fMapPainter.OnResize := MapResize;
  fMapPainter.OnMouseDown := MapMouseDown;
  fMapPainter.OnMouseMove := MapMouseMove;
  fMapPainter.OnMouseUp := MapMouseUp;

  fCityInfoTempBmp := TBitmap32.Create();
  fCityInfoTempBmp.Width := 120;
  fCityInfoTempBmp.Height := 40 * 25;
//  fCityInfoTempBmp.DrawMode := dmBlend;
//  fCityInfoTempBmp.Clear(clWhite);

  fCityInfoTempBmp2 := TBitmap32.Create();
  fCityInfoTempBmp2.Width := fCityInfoTempBmp.Width;
  fCityInfoTempBmp2.Height := fCityInfoTempBmp.Height;


   
  fGoodsImaegProv := aGoodsImaegProv;
  
  fDrawCityName := aOptions.doDrawCityName;
  
  createFonts();

  fStdCityIconAndNameRect.Left := 0;
  fStdCityIconAndNameRect.Top := 0;
  fStdCityIconAndNameRect.Right := 160;
  fStdCityIconAndNameRect.Bottom := 26;
  
  fMapSrcOrg := TBitmap32.Create();
  fMapSrcOrg.LoadFromFile(ImgPath + 'map.png');

//  fMapSize.X := aMapPainter.Width;
//  fMapSize.Y := aMapPainter.Height;

  fMapSrc := TBitmap32.Create();
  fMapSrc.Width := fMapSrcOrg.Width;
  fMapSrc.Height := fMapSrcOrg.Height;

  fMapTemp := TBitmap32.Create();
  fMapTemp.Width := fMapSrcOrg.Width;
  fMapTemp.Height := fMapSrcOrg.Height;

  fSrcMapRect := fMapSrcOrg.BoundsRect();

  recalcMinMaxMapPos();

//  dbgRect('SrcMapRect', fSrcMapRect);

  fAT := TAffineTransformation.Create();
  fAT.SrcRect := FloatRect(fSrcMapRect);

  fCityInfoCache := TMapCityInfoCache.Create(cityInfoProv);
  
//  fIsOrgMapSize := (fMapSize.X = ORG_MAP_WIDTH) and (fMapSize.Y = ORG_MAP_HEIGHT);

  initCityIcons();

  fProdStar := TBitmap32.Create();
  fProdStar.LoadFromFile(ImgPath + 'star-10x10.bmp');

  fTradeRouteDrawInfo.init();
  fTradeRouteLines := TObjectList.Create(True);
  for I := 1 to 20 do
  begin
    line := createGraphObj_RouteLine();
    fTradeRouteLines.Add(line);
  end;
  fActiveTradeRouteLines := TList.Create();

  fTempRoutePointNumBmp := TBitmap32.Create();
  fTempRoutePointNumBmp.Width := fNumBmpList.Bitmap[0].Width;
  fTempRoutePointNumBmp.Height := fTempRoutePointNumBmp.Width;
  fTempRoutePointNumBmp.Clear(clBlue32);
  fRoutePointNumBmpRect := fTempRoutePointNumBmp.BoundsRect();
//  OutputDebugString('<-TCachedMapInfo.Create');
end;

function TCachedMapInfo.createFont(const name: WideString;
  const sz: Integer;
  const clr: TColor;
  const bold: Boolean): TFont;
begin
  Result := TFont.Create();
  Result.Name := name;
  Result.Size := sz;
  Result.Color := clr;
  if bold then
    Result.Style := [fsBold];
end;

procedure TCachedMapInfo.createFonts;
const
  DefaultFontName = '黑体';
begin
  fCityNameFont := createFont(DefaultFontName, 10, clWhite, True);
end;

function TCachedMapInfo.createGraphObj_RouteLine: TTradeRouteLine;
var
  line: TTradeRouteLine;
begin
  line := TTradeRouteLine.Create();

  line.EndStyle := esSquared;

  with line do
  begin
    ArrowStart.Color := clYellow32;
    ArrowStart.Pen.Width := 1;
    ArrowStart.Pen.Color := clWhite32;
    ArrowStart.Style := asCircle;
    ArrowStart.Size := 5;

    ArrowEnd.Color := clYellow32;
    ArrowEnd.Pen.Color := clGray32;
    ArrowEnd.Size := 12;
    ArrowEnd.Pen.Width := 1.5;

    ArrowEnd.Style := asFourPoint;
  end;

  Result := line;
end;

procedure TCachedMapInfo.deactivate;
begin
  resetTradeRouteDrawInfo();
  fCityInfoCache.reset(7);
end;

destructor TCachedMapInfo.Destroy;
var
  I: TCityIconType;
begin
  FreeAndNil(fMapSrcOrg);
  FreeAndNil(fMapSrc);
  FreeAndNil(fMapTemp);

  for I := low(i) to high(i) do
    fCityIcons[I].Free();

  freeFonts();

  FreeAndNil(fAT);
  FreeAndNil(fCityInfoCache);
  FreeAndNil(fCityInfoTempBmp);
  FreeAndNil(fCityInfoTempBmp2);
  FreeAndNil(fProdStar);
  FreeAndNil(fTradeRouteLines);
  FreeAndNil(fActiveTradeRouteLines);
  FreeAndNil(fTempRoutePointNumBmp);
  inherited;
end;

procedure TCachedMapInfo.drawCityIcon(const aCityCode: Integer);
var
  it: TCityIconType;
  x, y: integer;
begin
  it := fIconType[aCityCode];
  x := fCityPosInMap[aCityCode].X;
  y := fCityPosInMap[aCityCode].Y;
//  dbgXY('cityIcon of ' + IntToStr(aCityCode), x, y);
  fCityIcons[it].DrawTo(
            fMapSrc,
            x,
            y);
end;

procedure TCachedMapInfo.drawCityName(
          bmp: TBitmap32;
          const aCityCode: Integer);
var
  name: WideString;
  dc: HDC;
  r: TRect;
  th, x, y: Integer;
  cityInfo: TMapCityInfo;
begin
  cityInfo := fCityInfoCache.getCityInfo(aCityCode);
  name := cityInfo.cityName + ' (' + IntToStr(cityInfo.getPeople().total) + ')';


  r := fRectOfCityIconAndName[aCityCode];
  r.Left := r.Left + fCityIconEdgeLen + 4;

  th := fMapSrc.TextHeight(name);
  x := r.Left;
  y := r.Top + (r.Bottom - r.Top - th) div 2;
//  dbgXY('cityname of ' + name, x, y);
  bmp.Textout(x, y, name);
end;

procedure TCachedMapInfo.doDrawGoodsInfo(city: integer; var tempDrawInfo: TTempDrawInfo);
var
  s: string;
  v: Double;
  iconDrawed: Boolean;
  goodsID, firstLineHeight: integer;
  cityInfo: TMapCityInfo;
  goodsDemand: PMapGoodsDemand;

  procedure drawProdLvl(lvl: word; r: TRect);
  begin
    fProdStar.DrawTo(tempDrawInfo.tempBitmap, r.Left, r.Bottom + 1);
    if lvl > 1 then
      fProdStar.DrawTo(tempDrawInfo.tempBitmap, r.Left + 1 + fProdStar.Width, r.Bottom + 1);
  end;  

  //return text height, 0 for not calculated
  function putS(const s: string): integer;
  var
    txtHeight, iconHeight, t: integer;
    icon: HDC;
    destR, srcR: TRect;
  begin
    Result := 0;
    if firstLineHeight > 0 then
      exit;

    srcR := fGoodsImaegProv.rect();

    txtHeight := tempDrawInfo.tempBitmap.TextHeight(s);
    iconHeight := srcR.Bottom - srcR.Top;
    if txtHeight > iconHeight then
      firstLineHeight := txtHeight
    else
      firstLineHeight := iconHeight;

    Inc(firstLineHeight, 2);

    t := (firstLineHeight - iconHeight) div 2 + tempDrawInfo.top;

    tempDrawInfo.tempLeft := 2;


    destR := srcR;
    OffsetRect(destR, tempDrawInfo.tempLeft{ + tempDrawInfo.x}, t{ + tempDrawInfo.y});

//    dbgRect('DrawgoodsIconto', destR);

    icon := fGoodsImaegProv.get(goodsID);
    tempDrawInfo.tempBitmap.Draw(destR, srcR, icon);
    if goodsDemand^.ProdLvl > 0 then
      drawProdLvl(goodsdemand^.ProdLvl, destR);

    tempDrawInfo.tempLeft := tempDrawInfo.tempLeft + srcR.Right - srcR.Left + 2;

    t := (firstLineHeight - txtHeight) div 2 + tempDrawInfo.top;
    tempDrawInfo.top := t;

    Result := txtHeight;    
  end;

  procedure drawS(const s: string; const color: TColor);
  var
    th: integer;
  begin
    th := putS(s);

    tempDrawInfo.tempBitmap.Font.Color := color;
    tempDrawInfo.tempBitmap.Textout(tempDrawInfo.tempLeft{ + tempDrawInfo.x}, tempDrawInfo.top{ + tempDrawInfo.y}, s);

    if th = 0 then
      th := tempDrawInfo.tempBitmap.TextHeight(s);

    tempDrawInfo.top := tempDrawInfo.top + th + 4;
  end;

  procedure drawPrice(sprice, pprice: integer; const color: TColor);
  var
    s: string;
  begin
    s := '价格: ';
    if sprice <> 0 then
      s := s + IntToStr(sprice)
    else
      s := s + '-';

    s := s + ' / ';

    if pprice <> 0 then
      s := s + IntToStr(pprice)
    else
      s := s + '-';

    drawS(s, color);
  end;

  procedure drawValue(const name: string; v: Double; const color: TColor);
  var
    s: string;
    q: Double;
  begin
    if v < 0 then
    begin
      dbgStr('Demand values < 0');
      exit;
    end;

    if v = 0 then
      exit;

    if isGoodsMeasuredInPkg(goodsID) then
      q := UNIT_PKG
    else
      q := UNIT_TONG;
      
    v := v * fCityInfoCache.Period / q;
    s := name + ': ' + FormatFloat('0.0', v);
    drawS(s, color);
  end;
    
begin
  cityInfo := fCityInfoCache.getCityInfo(city);
//  dbgStr('city=' + cityInfo.cityName);

  for goodsID := MIN_GOODS_ID to MAX_GOODS_ID do
  begin
    if not DrawGoodsInfo[goodsID] then
      Continue;

    firstLineHeight := -1;

    goodsDemand := cityInfo.getGoodsDemand(goodsID);
    drawPrice(goodsDemand^.citySPrice, goodsDemand^.cityPPrice, clBlack);
    drawValue('产出', goodsDemand^.product, clGreen);
    drawValue('剩余', goodsDemand^.remains, clBlue);
    drawValue('需求', goodsDemand^.consume, clRed);

    Inc(tempDrawInfo.top, 5);
  end;
end;

procedure TCachedMapInfo.drawToTarget;

  procedure draw_cityNames(target: TBitmap32);
  var
    city: integer;
  begin
    target.Font.Assign(fCityNameFont);
    
    for city := MIN_CITY_CODE to getCityCount() - 1 do
    begin
      drawCityName(target, city);
    end;
  end;

  procedure draw_goodsInfo(city: integer; var tempInfo: TTempDrawInfo);
  begin
    doDrawGoodsInfo(city, tempInfo);
  end;

  procedure draw_cityInfo(target: TBitmap32);
  var
    i, deltaX, deltaY: Integer;
    tempInfo: TTempDrawInfo;
    srcR, r: TRect;
  begin
    dbgStr('draw_cityInfo->');
    for I := MIN_CITY_CODE to getCityCount() - 1 do
    begin
      fCityInfoTempBmp.Clear(clWhite32);

      tempInfo.tempBitmap := fCityInfoTempBmp;
      tempInfo.top := 0;
//      tempInfo.width := target.Width;
//      tempInfo.height := target.Height;
      tempInfo.tempLeft := 0;
//      tempInfo.x := fCityPosInMap[I].X;
//      tempInfo.y := fRectOfCityIconAndName[I].Bottom + 5; 

      draw_goodsInfo(i, tempInfo);
      if tempInfo.top = 0 then
        Continue;

      r := fCityInfoTempBmp.BoundsRect();
      r.Bottom := r.Top + tempInfo.top;
      srcR := r;

//      dbgRect('cityInfo.src', srcR);
//      dbgRect('cityInfo.tar', r);

      deltaY := fRectOfCityIconAndName[I].Bottom + 2;



      if fTradeRouteDrawInfo.Ready then
      begin
        if fTradeRouteDrawInfo.CityRoutePointIndices[i].count > 0 then
          Inc(deltaY, fNumBmpEdgeLen + 4);
      end;

      OffsetRect(r, fCityPosInMap[I].X, deltaY);

//      dbgStr('-drawto-');
      BlockTransfer(fCityInfoTempBmp2, srcR.Left, srcR.Top, srcR, target, r, dmOpaque);
//      dbgStr('-blendtransfer-');

      BlendTransfer(
              target,
              r.Left, r.Top, r,
              fCityInfoTempBmp, srcR,
              fCityInfoTempBmp2, srcR,
              CombineReg,
              160);
//      dbgStr('---');
    end;
    dbgStr('<-draw_cityInfo');
  end;

var
  r, r2: TRect;

begin
  OutputDebugString('drawToTarget->');
//  fAT.Clear();
//  fAT.Translate(fMapXDelta, fMapYDelta);

  r := fMapPainter.Bitmap.ClipRect;
//  dbgRect('clipRect', r);
  r2.Left := -fMapXDelta;
  r2.Top := -fMapYDelta;
  r2.Right := -fMapXDelta + fMapPainter.Width;
  r2.Bottom := -fMapYDelta + fMapPainter.Height;
//  dbgRect('srcRect', r2);

  BlockTransfer(fMapTemp, 0, 0, fSrcMapRect, fMapSrc, fSrcMapRect, dmOpaque);
  if fDrawCityName then
    draw_cityNames(fMapTemp);

  draw_cityInfo(fMapTemp);
  drawTradeRouteLines(fMapTemp);

  fMapPainter.BeginUpdate();
  try
    BlockTransfer(fMapPainter.Bitmap, 0, 0, r, fMapTemp, r2, dmOpaque);
//    Transform(fMapPainter.Bitmap, fMapSrc, fAT);
//    dbgBool('DrawCityName', fDrawCityName);
  finally
    fMapPainter.EndUpdate();
  end;
  fMapPainter.Invalidate();
  OutputDebugString('<-drawToTarget');
end;

procedure TCachedMapInfo.drawTradeRouteLines(target: TBitmap32);
var
  i, j, rIdx: integer;
  line, selectedLine: TTradeRouteLine;
  rp: PCityRoutePointIndices;
  r: PRect;
  bmp: TBitmap32;
begin
//  dbgStr('fActiveTradeRouteLines.Count=' + IntToStr(fActiveTradeRouteLines.Count));

  selectedLine := nil;
  
  for I := 0 to fActiveTradeRouteLines.Count - 1 do
  begin
    line := TTradeRouteLine(fActiveTradeRouteLines[I]);
    if line.RoutePointIndex = fTradeRouteDrawInfo.SelectedRouteIndex then
    begin
      selectedLine := line;
      Continue;
    end;

    line.ArrowStart.Color := clYellow32;
    line.ArrowEnd.Color := clYellow32;
    line.Draw(target, 3, [clYellow32, clYellow32, clWhite32, clYellow32, 0], 1.65);
  end;

  if selectedLine <> nil then
  begin
    selectedLine.ArrowStart.Color := clBlue32;
    selectedLine.ArrowEnd.Color := clBlue32;
    selectedLine.Draw(target, 3, [clBlue32, clGreen32, clWhite32, clGreen32, 0], 1.65);
  end;

  if fTradeRouteDrawInfo.Count > 0 then
  begin
    for I := MIN_CITY_CODE to MAX_CITY_CODE do
    begin
      rp := @fTradeRouteDrawInfo.CityRoutePointIndices[I];
      if rp.count > 0 then
      begin
        for j := 1 to rp.Count do
        begin
          r := @rp.idxIconRects[J];

          rIdx := rp.indices[j];
          bmp := fNumBmpList.Bitmap[rIdx-1];

          if rIdx = fTradeRouteDrawInfo.SelectedRouteIndex then
          begin
            BlendTransfer(
                      target,
                      r^.Left,
                      r^.Top,
                      r^,
                      bmp,
                      fRoutePointNumBmpRect,
                      fTempRoutePointNumBmp,
                      fRoutePointNumBmpRect,
                      BlendRegEx,
                      100);
          end
          else
            bmp.DrawTo(target, r^, bmp.BoundsRect());
        end;
      end;
    end;
  end;
end;

procedure TCachedMapInfo.freeFonts;
begin
  FreeAndNil(fCityNameFont);
end;

function TCachedMapInfo.getSelectedRoutePointIndex: Integer;
begin
  if (not fTradeRouteDrawInfo.Ready) or (fTradeRouteDrawInfo.Count = 0) then
    Result := 0
  else
    Result := fTradeRouteDrawInfo.SelectedRouteIndex;
end;

procedure TCachedMapInfo.initCityIcons;

  function  p(b: TBitmap32): TBitmap32;
  begin
    ChromaKey(b, clBlack);
    b.DrawMode := dmBlend;
    Result := b;
  end;

var
  i: TCityIconType;
  b: TBitmap32;
begin
  b := TBitmap32.Create();
  b.LoadFromFile(ImgPath + 'city-icon-red.png');
  fCityIcons[CI__RED] := p(b);

  b := TBitmap32.Create();
  b.LoadFromFile(ImgPath + 'city-icon-red-blue.png');
  fCityIcons[CI__RED_BLUE] := p(b);

  b := TBitmap32.Create();
  b.LoadFromFile(ImgPath + 'city-icon-blue.png');
  fCityIcons[CI__BLUE] := p(b);

  fCityIconEdgeLen := b.Width;
  fCityIconEdgeLen_Half := fCityIconEdgeLen div 2;
end;

procedure TCachedMapInfo.loadResource;
begin
  
end;

procedure TCachedMapInfo.MapMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
var
  city, I, j: integer;
  line: TTradeRouteLine;
  r: PRect;
  pt: TPoint;
  fpt: TFixedPoint;
begin
  if fTradeRouteDrawInfo.Count > 0 then
  begin
    pt.X := X - fMapXDelta;
    pt.Y := Y - fMapYDelta;

    for city := MIN_CITY_CODE to getCityCount() - 1 do
    begin
      for J := 1 to fTradeRouteDrawInfo.CityRoutePointIndices[city].count do
      begin
        r := @fTradeRouteDrawInfo.CityRoutePointIndices[city].idxIconRects[J];
        if PtInRect(r^, pt) then
        begin
          fTradeRouteDrawInfo.SelectedRouteIndex := fTradeRouteDrawInfo.CityRoutePointIndices[city].indices[J];
          update();
          notifySelectedRoutePointIndexChanged();          
          exit;
        end;
      end;
    end;

    fpt := FixedPoint(pt);

    for I := 0 to fActiveTradeRouteLines.Count - 1 do
    begin
      line := TTradeRouteLine(fActiveTradeRouteLines[I]);
      if line.DoHitTest(fpt) = htLine then
      begin
        fTradeRouteDrawInfo.SelectedRouteIndex := line.RoutePointIndex;
        update();
        notifySelectedRoutePointIndexChanged();
        exit;
      end;
    end;
  end;

  fMapDraging := True;
  fLastMousePos.X := X;
  fLastMousePos.Y := Y;
  if fTradeRouteDrawInfo.Count = 0 then
    fTradeRouteDrawInfo.SelectedRouteIndex := 0;
  

//  dbgXY('mapTo', x - fMapXDelta, y - fMapYDelta);

//  pt := FixedPoint(x - fMapXDelta, y - fMapYDelta);
//
//
//  for I := 0 to fActiveTradeRouteLines.Count - 1 do
//  begin
//    line := TLine32(fActiveTradeRouteLines[I]);
//    if line.DoHitTest(pt) = htLine then
//    begin
//      soundBeep();
//      exit;
//    end;
//  end;
end;

procedure TCachedMapInfo.MapMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer; Layer: TCustomLayer);
var
  Dx, Dy, I, newMapX, newMapY: Integer;
begin
  if not fMapDraging then
    exit;

  Dx := X - fLastMousePos.X;
  Dy := Y - fLastMousePos.Y;

  newMapX := fMapXDelta + Dx;
  newMapY := fMapYDelta + Dy;

  if newMapX < minLeft then
    Dx := minLeft - fMapXDelta
  else if newMapX > maxLeft then
    Dx := maxLeft - fMapXDelta;

  if newMapY < minTop then
    Dy := minTop - fMapYDelta
  else if newMapY > MaxTop then
    Dy := MaxTop - fMapYDelta;

  fLastMousePos.X := X;
  fLastMousePos.Y := Y;

  if (Dx = 0) and (Dy = 0) then
    exit;

  Inc(fMapXDelta, Dx);
  Inc(fMapYDelta, Dy);

  drawToTarget();
end;

procedure TCachedMapInfo.MapMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
begin
  fMapDraging := False;
end;

procedure TCachedMapInfo.MapResize(Sender: TObject);
begin
  fMapPainter.SetupBitmap();
  recalcMinMaxMapPos();
  update();
end;

procedure TCachedMapInfo.notifySelectedRoutePointIndexChanged;
begin
  if Assigned(OnSelectedRoutePointIndexChanged) then
    OnSelectedRoutePointIndexChanged(self);
end;

procedure TCachedMapInfo.prepare;
begin
  if fPrepared then
    exit;

  fMapPainter.SetupBitmap();

  fPrepared := True;
end;

procedure TCachedMapInfo.prepareMapSrc;
var
  city: integer;
  cnt: Integer;
  changed: Boolean;
begin
  dbgStr('prepareMapSrc->');
  changed := updateCityPosAndIconType();

  if not fMapSrcReady then
  begin
    copyFromSrcOrg();

    for city := MIN_CITY_CODE to getCityCount() - 1 do
    begin
      if fIconNameState[city] <> NotUsed then
      begin
        drawCityIcon(city);
//        drawCityName(city);
      end;
    end;

    fMapSrcReady := True;
  end
  else if changed then
  begin
    cnt := getCityCount();
    for city := MIN_CITY_CODE to cnt- 1 do
    begin
      case fIconNameState[city] of
        NotDrawed:
        begin
          drawCityIcon(city);
//          drawCityName(city);
        end;

        IconRedraw:
        begin
          drawCityIcon(city);
        end;
      end;
    end;
  end;
  dbgStr('<-prepareMapSrc');
end;

function  TCachedMapInfo.projectToMap(var aCityPos: TPoint): TPoint;
begin
//  if fIsOrgMapSize then
//  begin
//    Result := aCityPos;
//    exit;
//  end;
  Result := aCityPos;

//  Result.X := Round(aCityPos.X * 800 / ORG_MAP_WIDTH);
//  Result.Y := Round(aCityPos.Y * 600 / ORG_MAP_HEIGHT);
end;

procedure TCachedMapInfo.rebuildTradeRouteLines;
//label
//  l1;

var
  I, idx: Integer;
  city, prevCity: byte;
  pt: TPoint;
  fpt: TFixedPoint;
  mpt, delta: TFixedPoint;
  lastFpt, firstFpt: TFixedPoint;
  last, first: boolean;
  ptArr: TArrayOfFixedPoint;
  ht: THitTestResult;
  useMpt: Boolean;
  line: TTradeRouteLine;
begin
  dbgStr('rebuildTradeRouteLines->');

  fActiveTradeRouteLines.Clear();

  if fTradeRouteDrawInfo.Count > 0 then
  begin
    first := True;
    idx := 0;

    if fTradeRouteDrawInfo.Count < 2 then
      fTradeRouteDrawInfo.SelectedRouteIndex := 0;

    for I := 1 to fTradeRouteDrawInfo.Count do
    begin
      city := fTradeRouteDrawInfo.TradeRoutes[I].CityCode;
  //    dbgStr('city:' + byteToHexStr(city));
      pt := fCityPosInMap[city];
      pt.X := pt.X + fCityIconEdgeLen_Half;
      pt.Y := pt.Y + fCityIconEdgeLen_Half;

//      dbgXY('routePt', pt.x, pt.y);

      fpt := FixedPoint(pt);
      if first then
      begin
        firstFpt := fpt;
        first := False;
      end
      else 
      begin
        line := TTradeRouteLine(fTradeRouteLines[idx]);
        Inc(idx);
        line.Clear();
        line.RoutePointIndex := i-1;
        if sameFixedPoint(lastFpt, fpt) then
        begin
          line.setCyclePoints(lastFpt);
        end
        else
          line.AddPoints([lastFpt, fpt]);

        fActiveTradeRouteLines.Add(line);
      end;

      lastFpt := fpt;
    end;

    if fTradeRouteDrawInfo.Count >= 2 then
    begin
      line := TTradeRouteLine(fTradeRouteLines[idx]);
      line.Clear();
      line.RoutePointIndex := fTradeRouteDrawInfo.Count;
      if sameFixedPoint(lastFpt, firstFpt) then
        line.setCyclePoints(lastFpt)
      else
        line.AddPoints([lastFpt, firstFpt]);
      fActiveTradeRouteLines.Add(line);
    end;
  end;

  dbgStr('<-rebuildTradeRouteLines');
end;

procedure TCachedMapInfo.recalcMinMaxMapPos;
begin
  minLeft := fMapPainter.Width - fMapSrcOrg.Width;
  maxLeft := 0;
  minTop := fMapPainter.Height - fMapSrcOrg.Height;
  MaxTop := 0;
end;

procedure TCachedMapInfo.reset;
begin
  fPrepared := False;
  fSelectedCity := $FF;
  fMapSrcReady := False;
  resetCityPos();
  resetCityIconsTypes();
  resetTradeRouteDrawInfo();
end;

procedure TCachedMapInfo.resetCityIconsTypes;
var
  i: Byte;
begin
  for I := MIN_CITY_CODE to MAX_CITY_CODE - 1 do
  begin
    fIconType[I] := CI__RED;
    fIconNameState[I] := NotUsed;
  end;
end;

procedure TCachedMapInfo.resetCityPos;
begin
  fCityCount := 0;
end;

procedure TCachedMapInfo.resetTradeRouteDrawInfo;
begin
  dbgStr('resetTradeRouteDrawInfo->');
  fTradeRouteDrawInfo.reset();
  dbgStr('resetTradeRouteDrawInfo2');
  fActiveTradeRouteLines.Clear();
  dbgStr('resetTradeRouteDrawInfo3');
  update();
  dbgStr('<-resetTradeRouteDrawInfo');
end;

procedure TCachedMapInfo.selectRoutePoint(index: integer; doUpdate: Boolean);
begin
  dbgStr('selectRoutePoint->');
  if not fTradeRouteDrawInfo.Ready then
    exit;

  if (index <= 0) or (index > fTradeRouteDrawInfo.Count) then
    exit;

  fTradeRouteDrawInfo.SelectedRouteIndex := index;
  dbgStr('<-selectRoutePoint');
end;

procedure TCachedMapInfo.SetDrawCityName(const Value: Boolean);
begin
  fDrawCityName := Value;
end;

procedure TCachedMapInfo.setTradeRouteDrawInfo(ship: PP3R2Ship;
  tradeRouteIndices: TTradeRouteIndices);
var
  city: integer;
  I, idx: Integer;
  tr: PTradeRoute;
  rp: PCityRoutePointIndices;
  r: TRect;
begin
  if ship = nil then
    resetTradeRouteDrawInfo()
  else if tradeRouteIndices.Count = 0 then
    resetTradeRouteDrawInfo()
  else
  begin
    dbgStr('setTradeRouteDrawInfo, ' + getShipName_R2(ship));
    fTradeRouteDrawInfo.Ship := ship;
    fTradeRouteDrawInfo.Count := tradeRouteIndices.Count;

    fTradeRouteDrawInfo.resetCityRoutePointIndices();

    for I := 1 to tradeRouteIndices.Count do
    begin
      idx := tradeRouteIndices.Indices[I];
      fTradeRouteDrawInfo.TradeRoutes[I].OrgTradeRouteIndex := idx;
      tr := getTradeRoute(idx);
      city := tr.CityCode;
      fTradeRouteDrawInfo.TradeRoutes[I].CityCode := city;
      rp := @fTradeRouteDrawInfo.CityRoutePointIndices[city];
      rp.add(I);
      r.Left := fCityPosInMap[city].X + 2 + fNumBmpEdgeLen * (rp.count-1);
      r.Top := fCityPosInMap[city].Y + fCityIconEdgeLen + 2;
      r.Right := r.Left + fNumBmpEdgeLen;
      r.Bottom := r.Top + fNumBmpEdgeLen;
      rp.idxIconRects[rp.count] := r;
    end;

    if tradeRouteIndices.Count > 1 then
      fTradeRouteDrawInfo.SelectedRouteIndex := 1
    else
      fTradeRouteDrawInfo.SelectedRouteIndex := 0;

    rebuildTradeRouteLines();

    fTradeRouteDrawInfo.Ready := True;

    update();
  end;
end;

procedure TCachedMapInfo.showCity(city: Integer; forceUpdate: Boolean);
var
  changed: Boolean;
  x, y, temp: integer;
begin
  getCityMapPos(city, x, y);
//  Inc(x, fMapXDelta);
//  Inc(y, fMapYDelta);

  changed := False;
  
  if (x + fMapXDelta - 120) < 0 then
  begin
//    dbgStr('-(x-20), xdelta=' + IntToStr(fMapXDelta) + ', -(x-20)=' + IntToStr(-(x-20)));
    fMapXDelta := -(x - 120);
    changed := True;
  end
  else if x + fMapXDelta + 120 > fMapPainter.Width then
  begin
    fMapXDelta := -(x - fMapPainter.Width + 120);
    changed := True;
  end;

  if (y + fMapYDelta - 120) < 0 then
  begin
    fMapYDelta := -(y-120);
    changed := True;
  end
  else if (y + fMapYDelta + 120) > fMapPainter.Height then
  begin
    fMapYDelta := -(y - fMapPainter.Height + 120);
    changed := True;
  end;

  if changed then
  begin
    temp := -(fMapSrcOrg.Width - fMapPainter.Width - 1);
    if fMapXDelta < temp then
      fMapXDelta := temp
    else if fMapXDelta > 0 then
      fMapXDelta := 0;

    temp := -(fMapSrcOrg.Height - fMapPainter.Height-1);
    if fMapYDelta < temp then
      fMapYDelta := temp
    else if fMapYDelta > 0 then
      fMapYDelta := 0;
    update();
  end
  else if forceUpdate then
    update();
end;

procedure TCachedMapInfo.update;
begin
  prepare();
  prepareMapSrc();
  drawToTarget();  
end;

function  TCachedMapInfo.updateCityPosAndIconType: Boolean;
var
  I, x, y, newCityCount, yDelta, edgeDelta: Integer;
  mapPos: TPoint;
  cityPtr: PCityStruct;
  homeCity: integer;
//  iconType: TCityIconType;
begin
  Result := False;
  
  newCityCount := getCityCount();
  
  if fCityCount <> newCityCount then
  begin
    Result := True;
    
    for I := fCityCount to newCityCount - 1 do
    begin
      fIconNameState[I] := NotDrawed;
      
      getCityMapPos(I, x, y);
      
      fCityPos[I].X := x;
      fCityPos[I].Y := y;

      fCityPosInMap[I] := projectToMap(fCityPos[I]);

      edgeDelta := fCityIconEdgeLen_Half;

      x := fCityPosInMap[I].X + edgeDelta;
      y := fCityPosInMap[I].Y + edgeDelta;

      fRectOfCityIconAndName[I].Left := x - edgeDelta - 5;
      fRectOfCityIconAndName[I].Right := fRectOfCityIconAndName[I].Left + fStdCityIconAndNameRect.Right;

      fRectOfCityIconAndName[I].Top := y - fStdCityIconAndNameRect.Bottom div 2;
      fRectOfCityIconAndName[I].Bottom := fRectOfCityIconAndName[I].Top + fStdCityIconAndNameRect.Bottom;
    end;

    fCityCount := newCityCount;
  end;

  homeCity := getPlayerHomeCity(getCurrPlayerID());

  for I := MIN_CITY_CODE to newCityCount do
  begin
    if fIconType[I] = CI__RED then
    begin
      if playerHasBOIn(i) then
      begin
        if I = homeCity then
          fIconType[I] := CI__BLUE
        else
          fIconType[I] := CI__RED_BLUE;
          
        case fIconNameState[I] of
          NotUsed, Ready:
            fIconNameState[I] := IconRedraw;
        end;
        
        Result := True;
      end;
    end;
  end;
end;


{ TMapCityInfoCache }

procedure TMapCityInfoCache.clearCityInfo;
var
  i: Integer;
begin
  for I := MIN_CITY_CODE to MAX_CITY_CODE - 1 do
    FreeAndNil(CityInfo[I]);
end;

constructor TMapCityInfoCache.Create(cityInfoProv: IMapViewerInfoProvider);
begin
  Self.cityInfoProv := cityInfoProv;
  Period := 7;
end;

destructor TMapCityInfoCache.Destroy;
begin
  clearCityInfo();  
  inherited;
end;

function TMapCityInfoCache.getCityInfo(city: Integer): TMapCityInfo;
begin
  if not fPrepared then
    internalPrepare();

  Result := CityInfo[city];
  if Result = nil then
  begin
    Result := TMapCityInfo.Create(city, cityInfoProv);
    CityInfo[city] := Result;
  end;
end;

procedure TMapCityInfoCache.internalPrepare;
var
  i: Integer;
  ci: TMapCityInfo;
begin
  clearCityInfo();
  cityCount := getCityCount();

  for I := MIN_CITY_CODE to cityCount - 1 do
  begin
    ci := TMapCityInfo.Create(i, cityInfoProv);
    CityInfo[I] := ci;  
  end;

  fPrepared := True;
end;

procedure TMapCityInfoCache.prepare;
begin
  if fPrepared then
    exit;

  internalPrepare();
end;

procedure TMapCityInfoCache.reset(period: Integer);
begin
  Self.Period := period;
  clearCityInfo();
end;

{ TMapCityInfo }

constructor TMapCityInfo.Create(cityCode: Byte; cityInfoProv: IMapViewerInfoProvider);
begin
  Self.cityCode := cityCode;
  Self.cityInfoProv := cityInfoProv;
  cityName := getCityName2(cityCode);
end;

var
  dbgPrintDemand: Boolean;

function TMapCityInfo.getGoodsDemand(const aGoodsID: integer): PMapGoodsDemand;
begin
  if not goodsDemandInfoReady then
  begin
    reloadGoodsDemand();
  end;

  Result := @goodsDemand[aGoodsID];
end;

function TMapCityInfo.getPeople: PMapCityPeople;
begin
  if not peopleInfoReady then
  begin
    people.init(cityCode);
    peopleInfoReady := True;
  end;

  Result := @people;
end;

procedure TMapCityInfo.reloadGoodsDemand;
var
  I, v, lvl: integer;
  pid: integer;
  pG: PMapGoodsDemand;
  bo: PBusinessOffice;
  prod, remains, demond: integer;
  city: PCityStruct;
  consumePrecalc: TResidentConsumePrecalc;
begin
  pG := @goodsDemand[MIN_GOODS_ID];
  city := getCityPtr(cityCode);
  consumePrecalc := cityInfoProv.getResidentConsumePrecalc();

//  dbgPrintDemand := cityCode = $0F;


  for I := MIN_GOODS_ID to MAX_GOODS_ID do
  begin
    pG^.reset();

//    dbgPrintDemand := dbgPrintDemand and (i = goodsid__)

    pg^.ProdLvl := getCityOriginalProdLvl(city, I); 

    v := city.getFactoryProd(I);
//    v := v - city.getFactoryConsume(I);
    pG^.addProduct(v);
    pG^.addConsume(city.getFactoryConsume(I) + consumePrecalc.calcCityConsumeInDay(I, cityCode));
    Inc(pG);
  end;


  for pid := MIN_TRADER_ID to getLastPlayerID() do
  begin
    bo := cityInfoProv.getBO(pid, cityCode);

    if bo = nil then
      Continue;

    pG := @goodsDemand[MIN_GOODS_ID];
    for I := MIN_GOODS_ID to MAX_GOODS_ID do
    begin
      pG^.addProduct(bo.getFactoryProd(I));
      pG^.addConsume(bo.getFactoryConsume(I));
      Inc(pG);      
    end;
  end;

  pG := @goodsDemand[MIN_GOODS_ID];
  for I := MIN_GOODS_ID to MAX_GOODS_ID do
  begin
    pG.calcPrices(cityCode, I);
    pG.calcRemains();
    
    Inc(pG);
  end;
  
  goodsDemandInfoReady := True;  
end;


{ TMapGoodsDemand }

procedure TMapGoodsDemand.addConsume(cons: double);
begin
  if dbgPrintDemand then
    dbgStr('consum+=' + FormatFloat('0.00', cons));
  consume := consume + cons;
end;

procedure TMapGoodsDemand.addProduct(prod: Double);
begin
  if dbgPrintDemand then
    dbgStr('prod+=' + FormatFloat('0.00', prod));
    
  product := product + prod;
end;

procedure TMapGoodsDemand.calcPrices(city, goodsID: integer);
begin
  cityPPrice := getCityPurchasePriceDef(city, goodsID);
  citySPrice := getCitySalePriceDef(city, goodsID);
end;

procedure TMapGoodsDemand.calcRemains;
begin
  if product > 0 then
  begin
    remains := product - consume;
    if remains >= 0 then
      consume := 0
    else
    begin
      consume := -remains;
      remains := 0;
    end;
  end
  else
  begin
    consume := consume - product;
  end;
end;

procedure TMapGoodsDemand.reset;
begin
  ProdLvl := PROD_LVL__NO_PROD;
  product := 0;
  remains := 0;
  consume := 0;

  citySPrice := 0;
  cityPPrice := 0;
end;


{ TMapCityPeople }

procedure TMapCityPeople.init(city: integer);
var
  pCity: PCityStruct;
begin
  pCity := getCityPtr(city);
  total := pCity^.Pop_Total;
  rich := pCity^.Pop_rich;
  common := pCity^.Pop_common;
  poor := pCity^.Pop_poor;
end;


{ TTradeRouteDrawInfo }

procedure TTradeRouteDrawInfo.init;
var
  i: integer;
begin
  reset();

  for I := 1 to 20 do
    TradeRoutes[I].Index := i;
end;

procedure TTradeRouteDrawInfo.reset;
begin
  Ship := nil;
  SelectedRouteIndex := 0;
  Count := 0;
  resetCityRoutePointIndices();
  Ready := False;
end;

procedure TTradeRouteDrawInfo.resetCityRoutePointIndices;
var
  city: integer;
begin
  for city := MIN_CITY_CODE to MAX_CITY_CODE do
    CityRoutePointIndices[city].reset();
end;

{ TTradeRouteLine }

procedure TTradeRouteLine.Clear;
begin
  inherited;
  IsCyclePoints := False;
end;

procedure TTradeRouteLine.setCyclePoints(pt: TFixedPoint);
begin
  SetPoints(cyclePoints(pt));
  IsCyclePoints := True;  
end;

{ TCityRoutePointIndices }

procedure TCityRoutePointIndices.add(index: integer);
begin
  if count >= 20 then
    raise Exception.Create('Too many indices.');
  Inc(count);
  indices[count] := index;
end;

procedure TCityRoutePointIndices.reset;
begin
  count := 0;
end;

end.
