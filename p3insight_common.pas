unit p3insight_common;

interface
uses
  SysUtils, Classes, OmniXML, MyOmniXMLHelper, Contnrs, Windows, p3DataStruct,
  JvWavePlayer, WideStrings;

const
  MAX_AREA_COUNT = 5;

type
  TPriceDefType = (
    PDT__NONE,
    PDT__B,
    PDT__S
  );
  
  TModItem = class
  public
    Enabled: Boolean;
    Name: string;
    Ofs: Integer;
    Sz: Integer;
    Verify: Boolean;
    OrgValue: Integer;
    Value: Integer;
    OrgBinValue: string;
    BinValue: string;
    BinaryForm, IsCode: Boolean;
    VA: Boolean;
  end;

  TModItems = class
  public
    Enabled: Boolean;
    List: TObjectList;

    constructor Create();
    destructor Destroy; override;

    procedure clear();

    function  get(const aIndex: Integer): TModItem;

    function  find(const name: string): TModItem;
    function  getByName(const name: string): TModItem;
  end;

  TBasicGoods = class
  public
    count: Integer;
    GoodsIDs: array[1..MAX_GOODS] of byte;

    constructor Create();

    procedure add(goodsID: Byte);
    procedure clear();
    procedure parse(const s: string);  
  end;

  TPriceList = class
  public
    Name: WideString;
    count: Integer;
    priceDefType: TPriceDefType;
    Prices: array[1..20] of Integer;

    constructor Create();
    procedure add(const price: Integer);

    function  get(gid: integer): integer;  
  end;

  TPriceDefs = class
  public
    List: TObjectList;
    DefaultPPriceList, DefaultSPriceList: TPriceList;

    constructor Create();
    destructor Destroy; override;

    procedure clear();

    function  getDefaultPPriceList(): TPriceList;
    procedure setDefaultPPriceList(list: TPriceList);

    function  getDefaultSPriceList(): TPriceList;
    procedure setDefaultSPriceList(list: TPriceList);  

    function  get(const index: integer): TPriceList;
    function  getByName(const aName: WideString): TPriceList;
    procedure add(aPriceList: TPriceList);

    procedure getPriceListForTrade(result: TList);

    procedure load();
    procedure save();   
  end;


  TAreaImpl = class;

  TAreaCityImpl = class
  public
    InternalCode: Byte;
    CityCode: Byte;
    Comment: WideString;
    AreaImpl: TAreaImpl;

    constructor Create(
            const aInternalCode: Byte;
            const aCityCode: Byte);

    function  isValid(): Boolean;
    function  getInternalCode(): Byte;

    //return $FF for invalid
    function  getCode(): Byte;
    procedure setCode(const aCode: Byte);

    function  getCityName(): WideString;

    procedure updateCityCode();
    procedure deattachArea();
    procedure attachArea(aArea: TAreaImpl);
  end;



  TAreaCityListImpl = class
  public
    List: TObjectList;

    constructor Create(owns: Boolean);
    destructor Destroy; override;

    procedure clear();
    procedure add(const aAreaCity: TAreaCityImpl);


    function  getCount(): Integer;
    function  get(const aIndex: Integer): TAreaCityImpl;
    function  find(const aCityCode: Byte): TAreaCityImpl;
    function  findByInternalCode(const aInternalCode: Byte): TAreaCityImpl;
    procedure remove(aitem: TAreaCityImpl);
  end;

  TBaseGoodsSupplyInfo = record
    Store: array[MIN_GOODS_ID..MAX_GOODS_ID] of Single;

    //prod/consume in day
    Consume: array[MIN_GOODS_ID..MAX_GOODS_ID] of Single;
    Prod: array[MIN_GOODS_ID..MAX_GOODS_ID] of Single;

    function  getStore(gid: integer): Single;
    function  getConsume(gid: integer): Single;
    function  getProd(gid: Integer): Single;
    function  getRemain(period: integer; gid: integer; consultStore: Boolean): Single;

    procedure add(addend: TBaseGoodsSupplyInfo);

    procedure reset();  
  end;

  PBaseGoodsSupplyInfo = ^TBaseGoodsSupplyInfo;
  
  TAreaImpl = class
  public
    ID: string;
    Name: WideString;
    Comment: WideString;
    ShipNamePrefix: WideString;
    ShipNamePrefixFull: WideString;
    cityList: TAreaCityListImpl;
    goodsSupplyInfoReady: Boolean;
    goodsSupplyInfo: TBaseGoodsSupplyInfo;

    constructor Create();
    constructor CreateEx(
              const aID: string;
              const aName: WideString;
              const aComment, aShipNamePrefix: WideString);
    destructor Destroy; override;
    
    function  getID(): string;
    function  getName(): WideString;
    procedure setName(const aName: WideString);
    function  getComment(): WideString;
    procedure setComment(const aComment: WideString);
    function  getShipNamePrefix(): WideString;
    procedure setShipNamePrefix(const prefix: WideString);
    function  isShipBelongs(ship: PP3R2Ship): Boolean;

    
    procedure fillCityCodes();
  end;
  


  TAreaDefImpl = class
  public
    id: string;
    name: WideString;
    areaList: TObjectList;
    areaCityList: TAreaCityListImpl;

    constructor Create();
    constructor CreateEx(const aID: string; const aName: WideString);
    destructor Destroy; override;

    function  getID(): string;
    function  getName(): WideString;
    function  getAreaCount(): Integer;
    function  getArea(const index: Integer): TAreaImpl;
    function  findByID(const aAreaID: string): TAreaImpl;
    function  getByID(const aAreaID: string): TAreaImpl;
    function  findByShipNamePrefix(const s: string): TAreaImpl;
    procedure add(const aArea: TAreaImpl);
    procedure clear();

    procedure fillCityCodes();
    procedure resetGoodsSupplyInfoCache();
  end;

  IAreaDefList = interface
  ['{32585167-2A44-4690-AEAF-6038636E1387}']
    function  isChanged(): Boolean;
    procedure setChanged(changed: Boolean);
    function  getCount(): Integer;
    function  get(const aIndex: Integer): TAreaDefImpl;

    procedure add(const aItem: TAreaDefImpl);
    procedure clear();
    function  findByID(const aAreaID: string): TAreaDefImpl;
    function  getByID(const aAreaID: string): TAreaDefImpl;
    function  getDefault(): TAreaDefImpl;
    procedure setDefault(const aDefault: TAreaDefImpl);
    procedure load(const aShipNameSeperator: WideChar);
    procedure save();
  end;

  TAreaDefListImpl = class(TInterfacedObject, IAreaDefList)
  public
    default: TAreaDefImpl;
    List: TObjectList;
    changed: Boolean;
    constructor Create();
    destructor Destroy; override;

    function  isChanged(): Boolean;
    procedure setChanged(changed: Boolean);  
    function  getCount(): Integer;
    function  get(const aIndex: Integer): TAreaDefImpl;

    procedure add(const aItem: TAreaDefImpl);
    procedure clear();
    function  findByID(const aAreaDefID: string): TAreaDefImpl;
    function  getByID(const aAreaDefID: string): TAreaDefImpl;
    function  getDefault(): TAreaDefImpl;
    procedure setDefault(const aDefault: TAreaDefImpl);

    procedure load(const aShipNameSeperator: WideChar);
    procedure save();
  end;


  TCustomTROp = class
  public
    GoodsID: Integer;
    OpType: TTradeRouteOpType;
    Price: Integer;
    Qty: Integer;
  end;

  TTRCityOption = (CO__NONE, CO__FIX, CO__NO_STOP);

  TCustomTRCity = class
  public
    CityInternalCode: Integer;
    Option: TTRCityOption;
    OpList: TObjectList;

    constructor Create();
    destructor Destroy; override;

    function  getCount(): Integer;
    function  get(index: integer): TCustomTROp;
  end;

  TCustomTradeRoute = class
  public
    Inserting: Boolean;
    Name, Desc: WideString;
    Category: WideString;
    Items: TObjectList;

    constructor Create();
    destructor Destroy; override;

    function  getCount(): Integer;
    function  get(index: Integer): TCustomTRCity;

    procedure clear();
  end;

  TCustomTradeRouteList = class
  public
    Changed: Boolean;
    Categories: TWideStrings;
    TradeRoutes: TObjectList;

    constructor Create();
    destructor Destroy; override;

    procedure clear();

    function  newTR(const Category: WideString): TCustomTradeRoute;
    function  newCategory(): WideString;

    function  getTRCount(): Integer;
    function  getTR(index: integer): TCustomTradeRoute;

    function  findByName(const aName: WideString): TCustomTradeRoute;
    function  findOther(this: TCustomTradeRoute; const aName: WideString): TCustomTradeRoute;

    procedure loadFromDoc(doc: IXMLDocument);
    procedure loadFromDefaultLocation();

    function  saveToDoc(): IXMLDocument;
    procedure saveToDefaultLocation();

    procedure getTradeRoutesByCategory(const aCategory: WideString; list: TList);
    procedure removeCategory(cate: WideString);
    procedure removeTR(tr: TCustomTradeRoute);

    procedure resetInsertingFlags();
  end;
  
  TP3InsightConf = class
  public
    ModItems: TModItems;
    AreaDefList: IAreaDefList;
    ShipNameSeperator: WideChar;
    WarningSoundFN: WideString;
    BasicGoods: TBasicGoods;
    PriceDefs: TPriceDefs;
    WavPlayer: TJvWavePlayer;
    AutoResetCaptainBirthday, AllowModify: Boolean;
    CustomTRList: TCustomTradeRouteList;

    constructor Create();
    destructor Destroy; override;

    procedure load();
    procedure clear();

    procedure playWarningSound();
  end;

  IP3GameStateListener = interface
  ['{C0056755-F9E2-40DB-A840-D301A22F8E00}']
    procedure onExitGame();
  end;

  IP3GameStateListenerList = interface
  ['{64DBC94E-6F99-4390-B17E-CDBA8817D948}']
    procedure add(const l: IP3GameStateListener);
    procedure remove(const l: IP3GameStateListener);
    function  getCount(): Integer;
    function  get(const index: Integer): IP3GameStateListener;
  end;

  IP3DateUpdateListener = interface
  ['{F8E5AC75-D498-4E83-BA7F-496313066308}']
    procedure onNewDate(y, m, d: integer);
  end;

  IP3DateUpdateListenerList = interface
  ['{23DFADD2-1238-4CC5-A378-55CC4F325828}']
    procedure add(const l: IP3DateUpdateListener);
    procedure remove(const l: IP3DateUpdateListener);
    function  getCount(): Integer;
    function  get(const index: integer): IP3DateUpdateListener;
  end;


  TGoodsSupplyInfo = class
  private
    ready: Boolean;
    residentConsumePrecalc: TResidentConsumePrecalc;
    BaseGoodsSupplyInfo: TBaseGoodsSupplyInfo;
    procedure update();
  public
    cityCode: Byte;


    constructor Create(cityCode: Byte; residentPrecalc: TResidentConsumePrecalc);
    function  get(): PBaseGoodsSupplyInfo;
    procedure reset();
  end;

  TAreaDataCache = class
  private
    residentConsumePrecalc: TResidentConsumePrecalc;
    GoodsSupplyInfoArr: array[MIN_CITY_CODE..MAX_CITY_CODE] of TGoodsSupplyInfo;
    AllGoodsSupplyInfoReady: Boolean;
    OtherGoodsSupplyInfo,
    AllGoodsSuuplyInfo: TBaseGoodsSupplyInfo;
    AreaDef: TAreaDefImpl;

    procedure prepareAllGoodsSupplyInfo();
  public
    constructor Create(
            residentConsumePrecalc: TResidentConsumePrecalc;
            areaDef: TAreaDefImpl);

    //do not update or cache the result
    function  get(city: integer): PBaseGoodsSupplyInfo;
    procedure reset();

    procedure summarize(area: TAreaImpl);
    function  getAllCityGoodsSupplyInfo(): PBaseGoodsSupplyInfo;
    function  getOtherCityGoodsSupplyInfo(): PBaseGoodsSupplyInfo;
  end;



var
  AppPath, StuffPath, ImgPath, SoundPath: WideString;
  Conf: TP3InsightConf;
//  DoSendKey: Boolean;
//  DoSendKeyMsgID: Cardinal;
  P3WndHandle: THandle;
  InsightDlgVisible: Boolean;
  GameStateListenerList: IP3GameStateListenerList;
  DateUpdateListenerList: IP3DateUpdateListenerList;


//not include the '-'
procedure extractShipAreaPrefix(ship: PP3R2Ship; out prefix, name, suffix: WideString);
function encodeShipName(const prefix, name, suffix: WideString): WideString;
//procedure setShipAreaPrefix(ship: PP3R2Ship; const area: WideString);

implementation

uses jclWideStrings, p3insight_utils;

function  strToTRCityOption(const s: string): TTRCityOption;
begin
  if s = 'fix' then
    Result := CO__FIX
  else if s = 'no-stop' then
    Result := CO__NO_STOP
  else if s = '' then
    Result := CO__NONE
  else
    raise Exception.Create('无效的选项：' + s);
end;

function  trCityOptionToStr(option: TTRCityOption): string;
begin
  case option of
    CO__NONE:   Result := '';
    CO__FIX:    Result := 'fix';
    CO__NO_STOP:  Result := 'no-stop';
  else
    raise Exception.Create('未处理的选项，Ord=' + IntToStr(Ord(option)));
  end;
end;

function  strToTradeRouteOpType(const S: string): TTradeRouteOpType;
begin
  if S = 'b' then
    Result := RT__BUY
  else if s = 's' then
    Result := RT__SELL
  else if s = 'i' then
    Result := RT__PUT_INTO
  else if s = 'o' then
    Result := RT__GET_OUT
  else if s = '' then
    Result := RT__UNSPECIFIED
  else
    raise Exception.Create('无效的的操作类型：' + S);
end;

function  tradeRouteOpTypeToStr(opType: TTradeRouteOpType): string;
begin
  case opType of
    RT__UNSPECIFIED:  Result := '';
    RT__SELL:         Result := 's';
    RT__BUY:          Result := 'b';
    RT__PUT_INTO:     Result := 'i';
    RT__GET_OUT:      Result := 'o';
  else
    raise Exception.Create('未处理的选项，Ord=' + IntToStr(Ord(opType)));
  end;
end;

{ TModItems }

procedure TModItems.clear;
begin
  List.Clear();
end;

constructor TModItems.Create;
begin
  List := TObjectList.Create(True);
end;

destructor TModItems.Destroy;
begin
  FreeAndNil(List);
  inherited;
end;


function TModItems.find(const name: string): TModItem;
var
  i: integer;
begin
  for I := 0 to List.Count - 1 do
  begin
    Result := get(I);
    if Result.Name = name then
      exit;
  end;

  Result := nil;
end;

function TModItems.get(const aIndex: Integer): TModItem;
begin
  Result := TModItem(List[aIndex]);
end;

function TModItems.getByName(const name: string): TModItem;
begin
  Result := find(name);
  if Result = nil then
    raise Exception.Create('Mod item not found: ' + name);
end;

{ TP3InsightConf }

procedure TP3InsightConf.clear;
begin
  ModItems.clear();
  AreaDefList.clear();
  BasicGoods.clear();
  PriceDefs.clear();
  CustomTRList.clear();
end;

constructor TP3InsightConf.Create;
begin
  ModItems := TModItems.Create();
  AreaDefList := TAreaDefListImpl.Create();
  BasicGoods := TBasicGoods.Create();
  PriceDefs := TPriceDefs.Create();
  WavPlayer := TJvWavePlayer.Create(nil);
  CustomTRList := TCustomTradeRouteList.Create();
end;

destructor TP3InsightConf.Destroy;
begin
  FreeAndNil(ModItems);
  FreeAndNil(BasicGoods);
  FreeAndNil(PriceDefs);
  FreeAndNil(WavPlayer);
  FreeAndNil(CustomTRList);
  inherited;
end;

procedure TP3InsightConf.load;
const
  att_enabled = 'enabled';
var
  FN: WideString;
  Doc: IXMLDocument;

  procedure errConfFile();
  begin
    raise Exception.Create('配置文件错误');
  end;

  procedure loadModItems();
  var
    Doc: IXMLDocument;
    static_data_mod, e_general, e_mod, e_value: IXMLElement;
    ModItem: TModItem;
    name, s, hex, bin, temp: string;
    ofs, sz, setTo: integer;
    code, va, useBin, valueEnable: Boolean;
  begin
    Doc := TMyXMLUtils.LoadXMLDocFromFile(StuffPath + 'static-data-mod.xml');

    //mod items
    static_data_mod := Doc.DocumentElement;

    e_general := TMyXMLUtils.FindFirstChildElmtNamed(
            static_data_mod,
            'general');
    if e_general = nil then
    begin
      dbgStr('general element not found.');
      exit;
    end;

    ModItems.Enabled := TMyXMLUtils.GetAttrValueAsBooleanDef(
            e_general,
            att_enabled, False);

    e_mod := TMyXMLUtils.FindFirstChildElmtNamed(
            static_data_mod,
            'mod');

    while e_mod <> nil do
    begin
      if TMyXMLUtils.GetAttrValueAsBooleanDef(
              e_mod,
              att_enabled,
              False) then
      begin
        e_value := TMyXMLUtils.FindFirstChildElmtNamed(
                e_mod,
                'value');

        while e_value <> nil do
        begin
          name := TMyXMLUtils.GetAttrValueDefEmpty(e_value, 'name');
          valueEnable := TMyXMLUtils.GetAttrValueAsBooleanDef(e_value, 'enabled', True);
          s := TMyXMLUtils.GetAttrValue(e_value, 'off', False);
          s := Trim(s);
          if s = '' then
            errConfFile();
          if s[1] <> '$' then
            s := '$' + s;

          if not TryStrToInt(s, ofs) then
            errConfFile();

          sz := TMyXMLUtils.GetAttrValueAsLongInt(e_value, 'sz');
          temp := TMyXMLUtils.GetAttrValueDefEmpty(e_value, 'verify');
          useBin := TMyXMLUtils.GetAttrValueAsBooleanDef(e_value, 'bin', False);
          if not (sz in [1,2,4]) then
            useBin := True;

          if not useBin then
          begin
            setTo := TMyXMLUtils.GetAttrValueAsLongInt(e_value, 'setTo');
          end
          else
          begin
            hex := TMyXMLUtils.GetAttrValueNotEmpty(e_value, 'setTo');
            if hex[1] <> '$' then
              errConfFile();

            hex := Copy(hex, 2, length(hex) - 1);
            if hex = '' then
              errConfFile();


            if temp <> '' then
              if temp[1] <> '$' then
                errConfFile();

              temp := Copy(temp, 2, length(temp) - 1);
              if temp = '' then
                errConfFile();
                
            setTo := 0;
          end;

          code := TMyXMLUtils.GetAttrValueAsBooleanDef(e_value, 'code', False);
          va := TMyXMLUtils.GetAttrValueAsBooleanDef(e_value, 'va', False);

          ModItem := TModItem.Create();
          ModItem.Enabled := valueEnable;
          ModItem.Name := name;
          ModItem.Ofs := ofs;
          ModItem.Sz := sz;
          ModItem.IsCode := code;
          ModItem.VA := va;
          ModItem.BinaryForm := useBin;

          if not useBin then
          begin
            ModItem.Value := setTo;
            if temp <> '' then
              ModItem.OrgValue := StrToInt(temp);
          end
          else
          begin
            ModItem.BinValue := SimpleHexToBin(hex);
            if Length(ModItem.BinValue) <> sz then
              errConfFile();

            ModItem.OrgBinValue := SimpleHexToBin(temp);
          end;
          ModItem.Verify := temp <> '';


          ModItems.List.Add(ModItem);

          e_value := TMyXMLUtils.FindNextSiblingElmtSameName(e_value);
        end;
      end;
      

      e_mod := TMyXMLUtils.FindNextSiblingElmtSameName(e_mod);
    end;
  end;

  procedure loadMisc();
  var
    e_general: IXMLElement;
    S: WideString;
  begin
    e_general:= TMyXMLUtils.GetFirstChildElmtNamed(
              Doc.DocumentElement,
              'general');

    S := TMyXMLUtils.GetAttrValue(
              e_general,
              'ship-name-seperator',
              False);

    if Length(S) <> 1 then
      raise Exception.Create('ship-name-seperator must be 1 unicode character.');

    ShipNameSeperator := S[1];




    S := TMyXMLUtils.GetAttrValueDefEmpty(e_general, 'warning-sound');
    if S <> '' then
    begin
      WarningSoundFN := SoundPath + S;
      if not FileExistsWide(WarningSoundFN) then
        WarningSoundFN := '';
    end;
    

    

    s := TMyXMLUtils.GetAttrValueDefEmpty(e_general, 'store-house-cap');
    if s <> '' then
      StdStoreHouseCapacity := StrToInt(s);


    AutoResetCaptainBirthday := TMyXMLUtils.GetAttrValueAsBoolean(
            e_general,
            'auto-reset-captain-birthday');

    AllowModify := TMyXMLUtils.GetAttrValueAsBooleanDef(
            e_general,
            'allow-modify',
            True);
  end;

  procedure loadCityListViewer();
  var
    e_city_list_viewer, e_basic_goods: IXMLElement;
    s: string;
  begin
    e_city_list_viewer := TMyXMLUtils.GetFirstChildElmtNamed(Doc.DocumentElement, 'city-list-viewer');

    e_basic_goods := TMyXMLUtils.GetFirstChildElmtNamed(e_city_list_viewer, 'basic-goods');
    s := TMyXMLUtils.GetAttrValue(e_basic_goods, 'id-list', False);
    BasicGoods.parse(s);
  end;

  procedure loadPriceDefs();
  begin
    PriceDefs.load();
  end;

  procedure loadCustomTRList();
  begin
    CustomTRList.loadFromDefaultLocation();
  end;

begin
  clear();

  FN := StuffPath + 'conf.xml';

  Doc := TMyXMLUtils.LoadXMLDocFromFile(FN);


  loadPriceDefs();
  loadMisc();
  loadCityListViewer();
  loadModItems();
  CustomTRList.loadFromDefaultLocation();

//  fn := StuffPath + 'area-defs.xml';
  AreaDefList.load(ShipNameSeperator);
end;


procedure TP3InsightConf.playWarningSound;
begin
  if WavPlayer = nil then
    exit;

  if WarningSoundFN = '' then
    exit;

  WavPlayer.FileName := WarningSoundFN;
  WavPlayer.Play();
end;

{ TAreaImpl }

constructor TAreaImpl.Create;
begin
  cityList := TAreaCityListImpl.Create(False);
end;

constructor TAreaImpl.CreateEx(const aID: string; const aName,
  aComment, aShipNamePrefix: WideString);
begin
  cityList := TAreaCityListImpl.Create(False);
  
  ID := aID;
  Name := aName;
  Comment := aComment;
  ShipNamePrefix := aShipNamePrefix;
end;

destructor TAreaImpl.Destroy;
begin
  FreeAndNil(cityList);
  inherited;
end;

procedure TAreaImpl.fillCityCodes;
var
  i: integer;
  city: TAreaCityImpl;
begin
  for I := 0 to cityList.getCount() - 1 do
  begin
    city := cityList.get(i);
    city.setCode(internalCityIDToCityCode(city.getInternalCode()));
  end;
end;

function TAreaImpl.getComment: WideString;
begin
  Result := Comment;
end;

function TAreaImpl.getID: string;
begin
  Result := ID;
end;

function TAreaImpl.getName: WideString;
begin
  Result := Name;
end;

function TAreaImpl.getShipNamePrefix: WideString;
begin
  Result := ShipNamePrefix;
end;

function TAreaImpl.isShipBelongs(ship: PP3R2Ship): Boolean;
begin
  Result := getshipArea(ship, Conf.ShipNameSeperator) = ShipNamePrefix;
//  if ShipNamePrefixFull = '' then
//  begin
//    ShipNamePrefixFull := ShipNamePrefix;
//    if Conf <> nil then
//    begin
//      if Conf.ShipNameSeperator <> #0 then
//        ShipNamePrefixFull := ShipNamePrefixFull + Conf.ShipNameSeperator;
//    end;
//  end;
//
//  Result := WidePos(ShipNamePrefixFull, aShipName) = 1;
end;

procedure TAreaImpl.setComment(const aComment: WideString);
begin
  Comment := aComment;
end;

procedure TAreaImpl.setName(const aName: WideString);
begin
  Name := aName;
end;

procedure TAreaImpl.setShipNamePrefix(const prefix: WideString);
begin
  ShipNamePrefix := prefix;
  ShipNamePrefixFull := '';
end;

{ TAreaCityImpl }

procedure TAreaCityImpl.attachArea(aArea: TAreaImpl);
begin
  deattachArea();
  AreaImpl := aArea;
  if aArea <> nil then
    aArea.cityList.add(Self);
end;

constructor TAreaCityImpl.Create(const aInternalCode, aCityCode: Byte);
begin
  InternalCode := aInternalCode;
  CityCode := aCityCode;
end;

procedure TAreaCityImpl.deattachArea;
begin
  if AreaImpl <> nil then
    AreaImpl.cityList.remove(Self);
  AreaImpl := nil;
end;

function TAreaCityImpl.getCityName: WideString;
begin
  if CityCode = $FF then
    Result := '?'
  else
    Result := getCityName2(CityCode);
end;

function TAreaCityImpl.getCode: Byte;
begin
  Result := CityCode;
end;

function TAreaCityImpl.getInternalCode: Byte;
begin
  Result := InternalCode;
end;

function TAreaCityImpl.isValid: Boolean;
begin
  Result := CityCode = $FF;
end;

procedure TAreaCityImpl.setCode(const aCode: Byte);
begin
  CityCode := aCode;
end;

procedure TAreaCityImpl.updateCityCode;
begin
  CityCode := internalCityIDToCityCode(InternalCode);
end;

{ TAreaCityListImpl }

procedure TAreaCityListImpl.add(const aAreaCity: TAreaCityImpl);
begin
  if List.IndexOf(aAreaCity) < 0 then
    List.Add(aAreaCity);
end;

procedure TAreaCityListImpl.clear;
begin
  List.Clear();
end;

constructor TAreaCityListImpl.Create(owns: Boolean);
begin
  List := TObjectList.Create(owns);
end;

destructor TAreaCityListImpl.Destroy;
begin
  FreeAndNil(List);
  inherited;
end;

function TAreaCityListImpl.find(const aCityCode: Byte): TAreaCityImpl;
var
  I: Integer;
begin
  for I := 0 to List.Count - 1 do
  begin
    Result := get(I);
    if Result.getCode() = aCityCode then
      exit;
  end;

  Result := nil;
end;

function TAreaCityListImpl.findByInternalCode(
  const aInternalCode: Byte): TAreaCityImpl;
var
  I: Integer;
begin
  for I := 0 to List.Count - 1 do
  begin
    Result := get(i);
    if Result.getInternalCode() = aInternalCode then
      exit;
  end;

  Result := nil;
end;

function TAreaCityListImpl.get(const aIndex: Integer): TAreaCityImpl;
begin
  Result := list[aindex] as TAreaCityImpl;
end;

function TAreaCityListImpl.getCount: Integer;
begin
  Result := List.Count;
end;

procedure TAreaCityListImpl.remove(aitem: TAreaCityImpl);
begin
  List.Remove(aitem);
end;

{ TAreaDefImpl }

procedure TAreaDefImpl.add(const aArea: TAreaImpl);
begin
  areaList.Add(aArea);
end;

procedure TAreaDefImpl.clear;
begin
  areaList.Clear();
end;

constructor TAreaDefImpl.Create;
begin
  areaList := TObjectList.Create(True);
  areaCityList := TAreaCityListImpl.Create(True);
end;

constructor TAreaDefImpl.CreateEx(const aID: string; const aName: WideString);
begin
  areaList := TObjectList.Create(True);
  areaCityList := TAreaCityListImpl.Create(True);

  id := aID;
  name := aName;  
end;

destructor TAreaDefImpl.Destroy;
begin
  FreeAndNil(areaList);
  FreeAndNil(areaCityList);
  inherited;
end;

procedure TAreaDefImpl.fillCityCodes;
var
  I: Integer;
  city: TAreaCityImpl;
begin
  for I := 0 to areaCityList.getCount() - 1 do
  begin
    city := areaCityList.get(i);
    city.updateCityCode();
  end;
//  for I := 0 to getAreaCount()- 1 do
//  begin
//    area := getArea(I);
//    area.fillCityCodes();
//  end;
end;

function TAreaDefImpl.findByID(const aAreaID: string): TAreaImpl;
var
  I: Integer;
begin
  for I := 0 to getAreaCount() - 1 do
  begin
    Result := getArea(I);
    if Result.getID() = aAreaID then
      exit;
  end;

  Result := nil;
end;

function TAreaDefImpl.findByShipNamePrefix(const s: string): TAreaImpl;
var
  I: Integer;
begin
  for I := 0 to getAreaCount() - 1 do
  begin
    Result := getArea(I);
    if WideSameText(Result.getShipNamePrefix(), s) then
      exit;
  end;

  Result := nil;
end;

function TAreaDefImpl.getArea(const index: Integer): TAreaImpl;
begin
  Result := areaList[index] as TAreaImpl;
end;

function TAreaDefImpl.getAreaCount: Integer;
begin
  Result := areaList.Count;
end;

function TAreaDefImpl.getByID(const aAreaID: string): TAreaImpl;
begin
  Result := findByID(aAreaID);
  if Result = nil then
    raise Exception.Create('Area not found, ID=' + aAreaID);
end;

function TAreaDefImpl.getID: string;
begin
  Result := id;
end;

function TAreaDefImpl.getName: WideString;
begin
  Result := name;
end;


procedure TAreaDefImpl.resetGoodsSupplyInfoCache;
var
  i: integer;
  area: TAreaImpl;
begin
  for I := 0 to areaList.Count - 1 do
  begin
    area := getArea(i);
    area.goodsSupplyInfoReady := False;
  end;
end;

{ TAreaDefListImpl }

procedure TAreaDefListImpl.add(const aItem: TAreaDefImpl);
begin
  List.Add(aItem);
end;

procedure TAreaDefListImpl.clear;
begin
  List.Clear();
end;

constructor TAreaDefListImpl.Create;
begin
  List := TObjectList.Create(True);
end;


destructor TAreaDefListImpl.Destroy;
begin
  FreeAndNil(List);
  inherited;
end;

function TAreaDefListImpl.findByID(const aAreaDefID: string): TAreaDefImpl;
var
  I: Integer;
begin
  for I := 0 to getCount() - 1 do
  begin
    Result := get(I);
    if Result.getID = aAreaDefID then
      exit;
  end;

  Result := nil;
end;

function TAreaDefListImpl.get(const aIndex: Integer): TAreaDefImpl;
begin
  Result := List[aIndex] as TAreaDefImpl;
end;

function TAreaDefListImpl.getByID(const aAreaDefID: string): TAreaDefImpl;
begin
  Result := findByID(aAreaDefID);
  if Result = nil then
    raise Exception.Create('AreaDef not found, ID=' + aAreaDefID);
end;

function TAreaDefListImpl.getCount: Integer;
begin
  Result := List.Count;
end;

function TAreaDefListImpl.getDefault: TAreaDefImpl;
begin
  Result := default;
end;

function TAreaDefListImpl.isChanged: Boolean;
begin
  Result := changed ;
end;

procedure TAreaDefListImpl.load(const aShipNameSeperator: WideChar);
var
  fn: WideString;
  doc: IXMLDocument;
  e_area_defs, e_active, e_area_def, e_area, e_city: IXMLElement;
  areaDefID, areaID, activeID: string;
  areaDefName, areaName, areaComment, shipNamePrefix: WideString;
  Area: TAreaImpl;
  AreaDef: TAreaDefImpl;
  i: integer;
  cityInternalCode: Byte;
  cityAreaID: string;
  areaCity: TAreaCityImpl;
begin
  clear();

  fn := StuffPath + 'area-defs.xml';
  doc := TMyXMLUtils.LoadXMLDocFromFile(fn);

  e_area_defs := doc.DocumentElement;

  e_active := TMyXMLUtils.GetFirstChildElmtNamed(
            e_area_defs,
            'active');

  activeID := TMyXMLUtils.GetAttrValue(e_active, 'id', False);

  e_area_def := TMyXMLUtils.GetFirstChildElmtNamed(
            e_area_defs,
            'area-def');

  while e_area_def <> nil do
  begin
    areaDefID := TMyXMLUtils.GetAttrValue(e_area_def, 'id', False);

    if findByID(areaDefID) <> nil then
      raise Exception.Create('Duplicate areaDef ID');

    areaDefName := TMyXMLUtils.GetAttrValue(e_area_def, 'name', False);

    AreaDef := TAreaDefImpl.CreateEx(areaDefID, areaDefName);
    add(AreaDef);

    if activeID = areaDefID then
      default := AreaDef;

    e_area := TMyXMLUtils.GetFirstChildElmtNamed(
            e_area_def,
            'area');
    while e_area <> nil do
    begin
      if AreaDef.getAreaCount() = MAX_AREA_COUNT then
        raise Exception.CreateFmt('Only %d arae can defined in a areaDef.', [MAX_AREA_COUNT]);
        
      areaID := TMyXMLUtils.GetAttrValue(e_area, 'id', False);

      if AreaDef.findByID(areaID) <> nil then
        raise Exception.Create('Duplicate area ID');
      
      areaName := TMyXMLUtils.GetAttrValue(e_area, 'name', False);
      areaComment := TMyXMLUtils.GetAttrValueDef(e_area, 'comment', '');
      shipNamePrefix := TMyXMLUtils.GetAttrValue(e_area, 'ship-name-prefix', False);

      if WidePos(shipNamePrefix, aShipNameSeperator) <> 0 then
        raise Exception.Create('ship-name-prefix can not contains ship-name-seperator character');

      if AreaDef.findByShipNamePrefix(shipNamePrefix) <> nil then
        raise Exception.Create('Duplciate ship name prefix');
        
//      if shipNamePrefix = aTradeShipNamePrefix then
//        raise Exception.Create('Duplicate ship name prefix');

      Area := TAreaImpl.CreateEx(areaID, areaName, areaComment, shipNamePrefix);
      AreaDef.add(Area);

//      e_city := TMyXMLUtils.FindFirstChildElmtNamed(
//              e_area,
//              'city');

//      while e_city <> nil do
//      begin
//        i := TMyXMLUtils.GetAttrValueAsLongInt(
//              e_city,
//              'internal-code');
//
//        if (i < 0) or (i > MAX_INTERNAL_CITY_CODE) then
//          raise Exception.Create('Invalid internal city code.');
//
//        e_city := TMyXMLUtils.FindNextSiblingElmtSameName(e_city);
//      end;

      e_area := TMyXMLUtils.FindNextSiblingElmtSameName(e_area);
    end;

    e_city := TMyXMLUtils.FindFirstChildElmtNamed(
            e_area_def,
            'city');

    while e_city <> nil do
    begin
      i := TMyXMLUtils.GetAttrValueAsLongInt(
            e_city,
            'internal-code');

      if (i < 0) or (i > MAX_INTERNAL_CITY_CODE) then
        raise Exception.Create('Invalid internal city code.');

      cityInternalCode := i;

      if AreaDef.areaCityList.findByInternalCode(cityInternalCode) <> nil then
        raise Exception.Create('The city has already defined.');

      cityAreaID := TMyXMLUtils.GetAttrValueDefEmpty(e_city, 'area-id');

      if cityAreaID <> '' then
      begin
        Area := AreaDef.getByID(cityAreaID);
        areaCity := TAreaCityImpl.Create(cityInternalCode, $FF);
        AreaDef.areaCityList.add(areaCity);

        areaCity.AreaImpl := Area;
        Area.cityList.add(areaCity);
      end;

      e_city := TMyXMLUtils.FindNextSiblingElmtSameName(e_city);
    end;

//    if AreaDef.areaCityList.getCount() <> MAX_CITY_COUNT then
//      raise Exception.Create('无效的城镇列表，数量不足');

    for I := MIN_INTERNAL_CITY_CODE to MAX_INTERNAL_CITY_CODE do
    begin
      if AreaDef.areaCityList.findByInternalCode(i) = nil then
      begin
        areaCity := TAreaCityImpl.Create(i, $FF);
        AreaDef.areaCityList.add(areaCity);
      end;
    end;


    e_area_def := TMyXMLUtils.FindNextSiblingElmtSameName(e_area_def);
  end;

  if default = nil then
    raise Exception.Create('No default areaDef defined');
end;

procedure TAreaDefListImpl.save;
var
  I, J, K: integer;
  fn: WideString;
  doc: IXMLDocument;
  e_active, e_area_def, e_area, e_city: IXMLElement;
  areaDef: TAreaDefImpl;
  area: TAreaImpl;
  areaCity: TAreaCityImpl;
begin
  if default = nil then
    raise Exception.Create('Default area was not defined.');

  fn := StuffPath + 'area-defs.xml';

  doc := TMyXMLUtils.CreateUTF8EncodedXMLDocDefault('area-defs');

  e_active := TMyXMLUtils.CreateChildElmt(doc.DocumentElement, 'active');
  e_active.SetAttribute('id', default.getID());

  for I := 0 to getCount() - 1 do
  begin
    areaDef := get(i);

    e_area_def := TMyXMLUtils.CreateChildElmt(doc.DocumentElement, 'area-def');
    e_area_def.SetAttribute('id', areaDef.id);
    e_area_def.SetAttribute('name', areaDef.name);

    for J := 0 to areaDef.getAreaCount() - 1 do
    begin
      area := areaDef.getArea(J);
      e_area := TMyXMLUtils.CreateChildElmt(e_area_def, 'area');
      e_area.SetAttribute('id', area.ID);
      e_area.SetAttribute('name', area.Name);
      e_area.SetAttribute('comment', area.Comment);
      e_area.SetAttribute('ship-name-prefix', area.ShipNamePrefix);      
    end;

    for J := 0 to areaDef.areaCityList.getCount() - 1 do
    begin
      areaCity := areaDef.areaCityList.get(J);

      e_city := TMyXMLUtils.CreateChildElmt(e_area_def, 'city');
      e_city.SetAttribute('internal-code', byteToHexStr(areaCity.InternalCode));
      if areaCity.Comment <> '' then
        e_city.SetAttribute('comment', areaCity.Comment);
      if areaCity.AreaImpl = nil then
        e_city.SetAttribute('area-id', '')
      else
        e_city.SetAttribute('area-id', areaCity.AreaImpl.ID);
    end;
  end;

  prettyPrintSaveXMLToFile(doc, fn);
  changed := True;
//  doc.Save(fn, ofIndent);
end;

procedure TAreaDefListImpl.setChanged(changed: Boolean);
begin
  Self.changed := changed;
end;

procedure TAreaDefListImpl.setDefault(const aDefault: TAreaDefImpl);
begin
  default := aDefault;
end;

{ TBasicGoods }

procedure TBasicGoods.add(goodsID: Byte);
begin
  if count >= MAX_GOODS then
    raise Exception.Create('too may basic goods defines.');

  GoodsIDs[count] := goodsID;
  Inc(count);
end;

procedure TBasicGoods.clear;
begin
  count := 0;
end;

constructor TBasicGoods.Create;
begin
  //nop
end;

procedure TBasicGoods.parse(const s: string);
var
  sl: TStringList;
  ln: string;
  i: Integer;
  v: integer;
begin
  clear();
  
  sl := TStringList.Create();
  try
    AxExtractStringByDelimiter(s, ';', false, sl);

    for I := 0 to sl.Count - 1 do
    begin
      ln := '$' + sl[i];
      if not TryStrToInt(ln, v) then
        raise Exception.Create('Invalid basic-goods id-list: ' + s);

      add(v);
    end;
  finally
    sl.Destroy();
  end;
end;

{ TPriceList }

procedure TPriceList.add(const price: Integer);
begin
  if count >= MAX_GOODS then
    raise Exception.Create('Too many price definition');

  Prices[count + 1] := price;
  Inc(count);
end;

constructor TPriceList.Create;
begin
  //nop
end;

function TPriceList.get(gid: integer): integer;
begin
  Result := Prices[gid];
end;

{ TPriceDefs }

procedure TPriceDefs.add(aPriceList: TPriceList);
begin
  List.Add(aPriceList);
end;

procedure TPriceDefs.clear;
begin
  List.Clear();
end;

constructor TPriceDefs.Create;
begin
  List := TObjectList.Create(True);
end;

destructor TPriceDefs.Destroy;
begin
  FreeAndNil(List);
  inherited;
end;

function TPriceDefs.get(const index: integer): TPriceList;
begin
  Result := TPriceList(List[index]);
end;

function TPriceDefs.getByName(const aName: WideString): TPriceList;
var
  i: integer;
begin
  for I := 0 to List.Count - 1 do
  begin
    Result := get(i);
    if WideSameText(Result.Name, aName) then
      Exit;
  end;

  Result := nil;
end;

function TPriceDefs.getDefaultPPriceList: TPriceList;
var
  i: integer;
begin
  Result := DefaultPPriceList;
  if Result = nil then
  begin
    for I := 0 to List.Count - 1 do
    begin
      Result := get(i);
      if Result.priceDefType = PDT__B then
        exit;
    end;

    Result := nil;
  end;
end;

function TPriceDefs.getDefaultSPriceList: TPriceList;
var
  I: Integer;
begin
  Result := DefaultSPriceList;

  if Result = nil then
  begin
    for I := 0 to List.Count - 1 do
    begin
      Result := get(i);
      if Result.priceDefType = PDT__S then
        exit;
    end;

    Result := nil;
  end;
end;

procedure TPriceDefs.getPriceListForTrade(result: TList);
var
  i: integer;
  l: TPriceList;
begin
  if DefaultPPriceList <> nil then
    result.Add(DefaultPPriceList);

  if DefaultSPriceList <> nil then
    result.Add(DefaultSPriceList);



  for I := 0 to List.Count - 1 do
  begin
    l := get(i);
    if l.priceDefType <> PDT__NONE then
      if result.IndexOf(l) < 0 then
        result.Add(l);
  end;
end;

procedure TPriceDefs.load;
var
  Doc: IXMLDocument;
  cnt: Integer;
  e_price_defs, e_general, e_price_list, e_p: IXMLElement;
  name, _type: WideString;
  priceList: TPriceList;
  v: Integer;
  pdt: TPriceDefType;
begin
  clear();
  
  Doc := TMyXMLUtils.LoadXMLDocFromFile(StuffPath + 'price-defs.xml');

  e_price_defs := doc.DocumentElement;



//    if e_price_defs = nil then
//      exit;

  e_price_list := TMyXMLUtils.FindFirstChildElmtNamed(e_price_defs, 'price-list');
  while e_price_list <> nil do
  begin
    name := TMyXMLUtils.GetAttrValue(e_price_list, 'name', False);
    _type := TMyXMLUtils.GetAttrValueDefEmpty(e_price_list, 'type');

    if _type = 's' then
      pdt := PDT__S
    else if _type = 'b' then
      pdt := PDT__B
    else
      pdt := PDT__NONE;

    priceList := TPriceList.Create();
    priceList.Name := name;
    priceList.priceDefType := pdt;

    cnt := 0;
    e_p := TMyXMLUtils.GetFirstChildElmtNamed(
            e_price_list,
            'p');

    while e_p <> nil do
    begin
      Inc(cnt);

      if not TryStrToInt(e_p.GetAttribute('p'), v)
      or (v <= 0) then
        raise Exception.Create('无效的价格列表定义');

      priceList.add(v);

      e_p := TMyXMLUtils.FindNextSiblingElmtSameName(e_p);
    end;

    if (cnt <> MAX_GOODS) then
      raise Exception.Create('无效的价格列表定义');

    add(priceList);

    e_general := TMyXMLUtils.GetFirstChildElmtNamed(e_price_defs, 'general');

    name := e_general.GetAttribute('def-bprice');
    if name <> '' then
    begin
      priceList := getByName(name);
      if priceList <> nil then
        setDefaultPPriceList(priceList);
    end;

    name := e_general.GetAttribute('def-sprice');
    if name <> '' then
    begin
      priceList := getByName(name);
      if priceList <> nil then
        setDefaultSPriceList(priceList);
    end;


    e_price_list := TMyXMLUtils.FindNextSiblingElmtSameName(e_price_list);
  end;
end;

procedure TPriceDefs.save;
var
  I, gid: integer;
  Doc: IXMLDocument;
  e_general, e_price_list, e_p: IXMLElement;
  pl: TPriceList;
  fn: WideString;
begin
  Doc := TMyXMLUtils.CreateUTF8EncodedXMLDocDefault('price-defs');

  e_general := TMyXMLUtils.CreateChildElmt(Doc.DocumentElement, 'general');
  if DefaultPPriceList <> nil then
    e_general.SetAttribute('def-bprice', DefaultPPriceList.Name)
  else
    e_general.SetAttribute('def-bprice', '');

  if DefaultSPriceList <> nil then
    e_general.SetAttribute('def-sprice', DefaultSPriceList.Name)
  else
    e_general.SetAttribute('def-sprice', '');

  for I := 0 to List.Count - 1 do
  begin
    pl := TPriceList(List[I]);

    e_price_list := TMyXMLUtils.CreateChildElmt(
            e_general,
            'price-list');

    e_price_list.SetAttribute('name', pl.Name);
    case pl.priceDefType of
      PDT__B: e_price_list.SetAttribute('type', 'b');
      PDT__S: e_price_list.SetAttribute('type', 's');
    else
      e_price_list.SetAttribute('type', '');
    end;

    for gid := MIN_GOODS_ID to MAX_GOODS_ID do
    begin
      e_p := TMyXMLUtils.CreateChildElmt(e_price_list, 'p');
      e_p.SetAttribute('p', IntToStr(pl.Prices[gid]));
    end;
  end;

  fn := StuffPath + 'price-defs.xml';
  Doc.Save(fn, ofIndent);
end;

procedure TPriceDefs.setDefaultPPriceList(list: TPriceList);
begin
  DefaultPPriceList := list;
end;

procedure TPriceDefs.setDefaultSPriceList(list: TPriceList);
begin
  DefaultSPriceList := list;
end;

{ TGoodsSupplyInfo }

constructor TGoodsSupplyInfo.Create(cityCode: Byte;
  residentPrecalc: TResidentConsumePrecalc);
begin
  Self.cityCode := cityCode;
  residentConsumePrecalc := residentPrecalc;
end;



function TGoodsSupplyInfo.get: PBaseGoodsSupplyInfo;
begin
  if not ready then
    update();

  Result := @BaseGoodsSupplyInfo;
end;

procedure TGoodsSupplyInfo.reset;
begin
  ready := False;
end;

procedure TGoodsSupplyInfo.update();
var
  i, gid: integer;
  boIdx: Word;
  areaCity: TAreaCityImpl;
  city: PCityStruct;
  bo: PBusinessOffice;
  s, p, c: Single;
  gp: PGameData;
  boCount: word;
begin
  city := getCityPtr(cityCode);

  gp := getGameDataPtr();
  boCount := gp.BOCount;

  for gid := MIN_GOODS_ID to MAX_GOODS_ID do
  begin
    s := city.getGoodsStore(gid);
    p := city.getFactoryProd(gid);
    c := city.getFactoryConsume(gid);
    c := c + residentConsumePrecalc.calcCityConsumeInDay(gid, cityCode);

    boIdx := city.FirstBOIndex;

    while boIdx < boCount do
    begin
      bo := getBOByIndex(boIdx);

      s := s + bo.GoodsStore[gid];
      p := p + bo.FactoryProductions[gid];
      c := c + bo.FactoryConsumes[gid];

      boIdx := bo.NextBOIndexInSameCity;
    end;

    if (boIdx > boCount) and (boIdx <> $FFFF) then
    begin
      dbgStr('BOIdx > boCount, cityCode=' + IntToStr(boIdx));
    end;

    BaseGoodsSupplyInfo.Store[gid] := s;
    BaseGoodsSupplyInfo.Prod[gid] := p;
    BaseGoodsSupplyInfo.Consume[gid] := c;
  end;

  ready := True;
//  dbgStr('<-getBO');
end;

{ TAreaDataCache }

constructor TAreaDataCache.Create(residentConsumePrecalc: TResidentConsumePrecalc;
  areaDef: TAreaDefImpl);
begin
  Self.residentConsumePrecalc := residentConsumePrecalc;
  Self.AreaDef := areaDef;
end;

function TAreaDataCache.get(city: integer): PBaseGoodsSupplyInfo;
var
  info: TGoodsSupplyInfo;
begin
  info := GoodsSupplyInfoArr[city];
  if info = nil then
  begin
    info := TGoodsSupplyInfo.Create(city, residentConsumePrecalc);
    GoodsSupplyInfoArr[city] := info;
  end;

  Result := info.get();
end;

function TAreaDataCache.getAllCityGoodsSupplyInfo: PBaseGoodsSupplyInfo;
begin
  if not AllGoodsSupplyInfoReady then
    prepareAllGoodsSupplyInfo();

  Result := @AllGoodsSuuplyInfo;
end;

function TAreaDataCache.getOtherCityGoodsSupplyInfo: PBaseGoodsSupplyInfo;
begin
  if not AllGoodsSupplyInfoReady then
    prepareAllGoodsSupplyInfo();

  Result := @OtherGoodsSupplyInfo;
end;

procedure TAreaDataCache.prepareAllGoodsSupplyInfo;
var
  I, cityCount: integer;
  city: TAreaCityImpl;
  cityCode: integer;
begin
  AllGoodsSuuplyInfo.reset();

  cityCount := getCityCount();

  for I := MIN_CITY_CODE to cityCount - 1 do
  begin
    AllGoodsSuuplyInfo.add(get(i)^);
  end;


  OtherGoodsSupplyInfo.reset();

  for I := 0 to AreaDef.areaCityList.getCount() - 1 do
  begin
    city := AreaDef.areaCityList.get(I);    
    if (city.CityCode = $FF) or (city.CityCode >= cityCount) then
      Continue;
      
    if city.AreaImpl = nil then
    begin
      OtherGoodsSupplyInfo.add(get(city.CityCode)^);
    end;
  end;

  AllGoodsSupplyInfoReady := True;
end;

procedure TAreaDataCache.reset;
var
  i: integer;
  info: TGoodsSupplyInfo;
begin
  AllGoodsSupplyInfoReady := False;

  for I := MIN_CITY_CODE to MAX_CITY_CODE do
  begin
    info := GoodsSupplyInfoArr[i];
    if info <> nil then
      info.reset();
  end;
end;

procedure TAreaDataCache.summarize(area: TAreaImpl);
var
  i: integer;
  city: TAreaCityImpl;
  gsi: PBaseGoodsSupplyInfo;
begin
  area.goodsSupplyInfo.reset();

  for I := 0 to area.cityList.getCount() - 1 do
  begin
    city := area.cityList.get(I);
    gsi := get(city.CityCode);
    area.goodsSupplyInfo.add(gsi^);
  end;
end;

{ TBaseGoodsSupplyInfo }

procedure TBaseGoodsSupplyInfo.add(addend: TBaseGoodsSupplyInfo);
var
  gid: integer;
begin
  for gid := MIN_GOODS_ID to MAX_GOODS_ID do
  begin
    Store[gid] := Store[gid] + addend.Store[gid];
    Prod[gid] := Prod[gid] + addend.Prod[gid];
    Consume[gid] := Consume[gid] + addend.Consume[gid];
  end;
end;

function TBaseGoodsSupplyInfo.getConsume(gid: integer): Single;
begin
  Result := Consume[gid];
end;

function TBaseGoodsSupplyInfo.getProd(gid: integer): Single;
begin
  Result := Prod[gid];
end;

function TBaseGoodsSupplyInfo.getRemain(period: integer; gid: integer;
  consultStore: Boolean): Single;
var
  p, c: Single;
begin
  p := Prod[gid] * period;
  c := Consume[gid] * period;
  if consultStore then
    p := p + Store[gid];

  Result := p - c;
end;

function TBaseGoodsSupplyInfo.getStore(gid: integer): Single;
begin
  Result := Store[gid];
end;

procedure TBaseGoodsSupplyInfo.reset;
var
  gid: integer;
begin
  for gid := MIN_GOODS_ID to MAX_GOODS_ID do
  begin
    Store[gid] := 0;
    Consume[gid] := 0;
    Prod[gid] := 0;
  end;
end;

//not include the '-'
procedure extractShipAreaPrefix(ship: PP3R2Ship; out prefix, name, suffix: WideString);
var
  p: integer;
  n, s: WideString;
begin
  n := getShipName_R2(ship);
  s := Conf.ShipNameSeperator;

  p := WidePos(s, n);
  if p <= 1 then
  begin
    prefix := '';
    name := n;
    suffix := '';
    exit;
  end;

  prefix := Copy(n, 1, p-1);
  name := Copy(n, p+1, length(n) - p);

  p := WidePos(s, name);
  if p > 0 then
  begin
    suffix := Copy(name, p+1, length(name)-p);
    name := Copy(name, 1, p-1);
  end
  else
    suffix := '';
end;

function encodeShipName(const prefix, name, suffix: WideString): WideString;
begin
  if prefix <> '' then
  begin
    if suffix <> '' then
      Result := prefix + Conf.ShipNameSeperator + name + Conf.ShipNameSeperator + suffix
    else
      Result := prefix + Conf.ShipNameSeperator + name;
  end
  else
  begin
    if suffix <> '' then
      Result := Conf.ShipNameSeperator + name + Conf.ShipNameSeperator + suffix
    else
      Result := name;
  end;
end;

{ TCustomTRCity }

constructor TCustomTRCity.Create;
begin
  OpList := TObjectList.Create(True);
end;

destructor TCustomTRCity.Destroy;
begin
  FreeAndNil(OpList);
  inherited;
end;

function TCustomTRCity.get(index: integer): TCustomTROp;
begin
  Result := TCustomTROp(OpList[index]);
end;

function TCustomTRCity.getCount: Integer;
begin
  Result := OpList.Count;
end;

{ TCustomTradeRoute }

procedure TCustomTradeRoute.clear;
begin
  Items.Clear();
end;

constructor TCustomTradeRoute.Create;
begin
  Items := TObjectList.Create(True);
end;

destructor TCustomTradeRoute.Destroy;
begin
  FreeAndNil(Items);
  inherited;
end;

function TCustomTradeRoute.get(index: Integer): TCustomTRCity;
begin
  Result := TCustomTRCity(Items[index]);
end;

function TCustomTradeRoute.getCount: Integer;
begin
  Result := Items.Count;
end;

{ TCustomTradeRouteList }

procedure TCustomTradeRouteList.clear;
begin
  TradeRoutes.Clear();
  Categories.Clear();
end;

constructor TCustomTradeRouteList.Create;
begin
  Categories := WideStrings.TWideStringList.Create();
  TradeRoutes := TObjectList.Create(True);
end;

destructor TCustomTradeRouteList.Destroy;
begin
  FreeAndNil(TradeRoutes);
  FreeAndNil(Categories);
  inherited;
end;

function TCustomTradeRouteList.findByName(
  const aName: WideString): TCustomTradeRoute;
var
  I: integer;
begin
  for I := 0 to getTRCount() - 1 do
  begin
    Result := getTR(I);
    if Result.Name = aName then
      exit;
  end;

  Result := nil;
end;

function TCustomTradeRouteList.findOther(
  this: TCustomTradeRoute; const aName: WideString): TCustomTradeRoute;
var
  I: integer;
begin
  for I := 0 to getTRCount() - 1 do
  begin
    Result := getTR(I);
    if (Result <> this) and (Result.Name = aName) then
      exit;
  end;

  Result := nil;
end;

function TCustomTradeRouteList.getTR(index: integer): TCustomTradeRoute;
begin
  Result := TCustomTradeRoute(TradeRoutes[index]);
end;

procedure TCustomTradeRouteList.getTradeRoutesByCategory(
  const aCategory: WideString; list: TList);
var
  I: integer;
  tr: TCustomTradeRoute;
begin
  for I := 0 to getTRCount() - 1 do
  begin
    tr := getTR(I);
    if tr.Category = aCategory then
      list.Add(tr);
  end;
end;

function TCustomTradeRouteList.getTRCount: Integer;
begin
  Result := TradeRoutes.Count;
end;

procedure TCustomTradeRouteList.loadFromDefaultLocation;
var
  fn: WideString;
  doc: IXMLDocument;
begin
  fn := StuffPath + 'trade-routes.xml';
  if not FileExistsWide(fn) then
  begin
    clear();
    exit;
  end;

  doc := TMyXMLUtils.LoadXMLDocFromFile(fn);
  loadFromDoc(doc);
end;

procedure TCustomTradeRouteList.loadFromDoc(doc: IXMLDocument);
var
  root, e_categories, e_tr: IXMLElement;

  procedure confErr(const msg: WideString);
  begin
    configError('trade-routes.xml', msg);
  end;

  procedure loadCategories();
  var
    e_cate: IXMLElement;
    name: WideString;
  begin
    e_cate := TMyXMLUtils.FindFirstChildElmtNamed(e_categories, 'cate');
    while e_cate <> nil do
    begin
      name := TMyXMLUtils.GetAttrValueNotEmpty(e_cate, 'name');
      if Categories.IndexOf(name) >= 0 then
        confErr('重复的分类名称');
        
      Categories.Add(name);

      e_cate := TMyXMLUtils.FindNextSiblingElmtSameName(e_cate);
    end;
  end;

  procedure loadTR();
  var
    name, desc, cate: WideString;
    tr: TCustomTradeRoute;
    e_city: IXMLElement;

    procedure loadCity();
    var
      code: byte;
      option: TTRCityOption;
      city: TCustomTRCity;

      e_op: IXMLElement;

      procedure loadOp();
      var
        gid, price, qty: integer;
        trOp: TTradeRouteOpType;
        s: string;
        Op: TCustomTROp;
      begin
        gid := TMyXMLUtils.GetAttrValueAsLongInt(e_op, 'goods-id') + 1;
        if (gid < 0) or (gid > MAX_GOODS_ID) then
          confErr('无效的货物ID: ' + IntToStr(gid));

        trOp := strToTradeRouteOpType(TMyXMLUtils.GetAttrValueDefEmpty(e_op, 'type'));
        price := TMyXMLUtils.GetAttrValueAsLongIntDef(e_op, 'price', 0);
        if price < 0 then
          confErr('无效的价格：' + IntToStr(price));

        s := TMyXMLUtils.GetAttrValue(e_op, 'qty', False);
        if s = 'max' then
          qty := TRADE_ROUTE__MAX_QTY
        else
        begin
          if not TryStrToInt(s, qty)
          or (qty < 0)
          or (qty > TRADE_ROUTE__MAX_QTY) then
            confErr('无效的数量：' + s);
        end;

        Op := TCustomTROp.Create();
        Op.GoodsID := gid;
        Op.OpType := trOp;
        Op.Price := price;
        Op.Qty := qty;

        city.OpList.Add(Op);        
      end;

    begin
      code := TMyXMLUtils.GetAttrValueAsByte(e_city, 'internal-code');
      if code > MAX_INTERNAL_CITY_CODE then
        confErr('无效的城镇代码：' + byteToHexStr(code));

      option := strToTRCityOption(TMyXMLUtils.GetAttrValueDefEmpty(e_city, 'option'));

      city := TCustomTRCity.Create();
      try
        city.CityInternalCode := code;
        city.Option := option;

        e_op := TMyXMLUtils.FindFirstChildElmtNamed(
                e_city, 'op');

        while e_op <> nil do
        begin
          loadOp();

          e_op := TMyXMLUtils.FindNextSiblingElmtSameName(e_op);
        end;
      except
        city.Destroy();
        raise;
      end;

      tr.Items.Add(city);
    end;
      
  begin
    name := TMyXMLUtils.GetAttrValueNotEmpty(e_tr, 'name');
    desc := TMyXMLUtils.GetAttrValueDefEmpty(e_tr, 'desc');
    cate := TMyXMLUtils.GetAttrValueDefEmpty(e_tr, 'cate');

    tr := TCustomTradeRoute.Create();
    try
      tr.Name := name;
      tr.Desc := desc;
      tr.Category := cate;

      e_city := TMyXMLUtils.FindFirstChildElmtNamed(
              e_tr,
              'city');
      while e_city <> nil do
      begin
        loadCity();

        e_city := TMyXMLUtils.FindNextSiblingElmtSameName(e_city);
      end;
    except
      tr.Destroy();
      raise;
    end;

    TradeRoutes.Add(tr);
  end; 

begin
  clear();

  root := doc.DocumentElement;

  e_categories := TMyXMLUtils.GetFirstChildElmtNamed(root, 'categories');
  loadCategories();

  e_tr := TMyXMLUtils.FindFirstChildElmtNamed(
          root,
          'tr');
          
  while e_tr <> nil do
  begin
    loadTR();
    
    e_tr := TMyXMLUtils.FindNextSiblingElmtSameName(e_tr);
  end;
end;

function TCustomTradeRouteList.newCategory: WideString;
label l1;
var
  idx: integer;
begin
  idx := 1;

l1:
  Result := '未命名类别' + IntToStr(idx);
  if Categories.IndexOf(Result) >= 0 then
  begin
    Inc(idx);
    goto l1;
  end;

  Categories.Add(Result);
  Changed := True;
end;

function TCustomTradeRouteList.newTR(const Category: WideString): TCustomTradeRoute;
label l1;
var
  idx: integer;
  name: string;
begin
  idx := 1;

l1:
  name := '未命名航线' + IntToStr(idx);

  if findByName(name) <> nil then
  begin
    Inc(idx);
    goto l1;
  end;

  Result := TCustomTradeRoute.Create();
  Result.Name := name;
  Result.Inserting := True;
  Result.Category := Category;

  TradeRoutes.Add(Result);
  Changed := True;
end;

procedure TCustomTradeRouteList.removeCategory(cate: WideString);
var
  idx: integer;
begin
  idx := Categories.IndexOf(cate);

  if idx >= 0 then
  begin
    Categories.Delete(idx);
    Changed := True;
  end;
end;

procedure TCustomTradeRouteList.removeTR(tr: TCustomTradeRoute);
begin
  TradeRoutes.Remove(tr);
  Changed := True;
end;

procedure TCustomTradeRouteList.resetInsertingFlags;
var
  i: integer;
  tr: TCustomTradeRoute;
begin
  for I := 0 to getTRCount() - 1 do
  begin
    tr := getTR(i);
    tr.Inserting := False;
  end;
end;

procedure TCustomTradeRouteList.saveToDefaultLocation;
var
  fn: WideString;
  doc: IXMLDocument;
begin
  fn := StuffPath + 'trade-routes.xml';
  doc := saveToDoc();
  prettyPrintSaveXMLToFile(doc, fn);
  Changed := False;
end;

function TCustomTradeRouteList.saveToDoc: IXMLDocument;
var
  root: IXMLElement;

  procedure saveCategories();
  var
    I: Integer;
    e_categories, e_cate: IXMLElement;
  begin
    e_categories := TMyXMLUtils.CreateChildElmt(root, 'categories');

    for I := 0 to Categories.Count - 1 do
    begin
      e_cate := TMyXMLUtils.CreateChildElmt(e_categories, 'cate');
      e_cate.SetAttribute('name', Categories[i]);
    end;
  end;

  procedure saveTRList();
  var
    I: Integer;
    TR: TCustomTradeRoute;
    e_tr: IXMLElement;

    procedure saveCityList();
    var
      J: Integer;
      City: TCustomTRCity;
      e_city: IXMLElement;

      procedure saveOpList();
      var
        K: Integer;
        Op: TCustomTROp;
        e_op: IXMLElement;
      begin
        for K := 0 to city.getCount() - 1 do
        begin
          Op := City.get(K);
          e_op := TMyXMLUtils.CreateChildElmt(e_city, 'op');
          e_op.SetAttribute('goods-id', IntToStr(Op.GoodsID-1));
          e_op.SetAttribute('type', tradeRouteOpTypeToStr(Op.OpType));
          if Op.Price <> 0 then
            e_op.SetAttribute('price', IntToStr(Op.Price));
          if Op.Qty = TRADE_ROUTE__MAX_QTY then
            e_op.SetAttribute('qty', 'max')
          else
            e_op.SetAttribute('qty', IntToStr(Op.Qty));
        end;
      end;

    begin
      for J := 0 to TR.getCount() - 1 do
      begin
        City := TR.get(J);
        e_city := TMyXMLUtils.CreateChildElmt(e_tr, 'city');
        e_city.SetAttribute('internal-code', byteToHexStr(City.CityInternalCode));
        e_city.SetAttribute('option', trCityOptionToStr(City.Option));
        saveOpList();
      end;
    end;

  begin
    for I := 0 to getTRCount() - 1 do
    begin
      TR := getTR(I);
      e_tr := TMyXMLUtils.CreateChildElmt(root, 'tr');
      e_tr.SetAttribute('name', TR.Name);
      e_tr.SetAttribute('desc', TR.Desc);
      e_tr.SetAttribute('cate', TR.Category);
      saveCityList();
    end;
  end;

begin
  Result := TMyXMLUtils.CreateUTF8EncodedXMLDocDefault('trade-routes');

  root := Result.DocumentElement;

  saveCategories();
  saveTRList();
end;

initialization
  AppPath := ExtractFilePath(ParamStr(0));
  StuffPath := AppPath + 'p3insight-stuff\';
  ImgPath := StuffPath + 'images\';
  SoundPath := StuffPath + 'sound\';
  Conf := TP3InsightConf.Create();

end.

