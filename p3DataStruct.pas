unit p3DataStruct;

interface
uses
  SysUtils, Classes, Windows, Graphics, Menus, IniFiles, Contnrs, p3Types;


const
  MAX_SHIP_NAME_LENGTH = 17;
  SHIP_NAME_OTHERS = 'others';
  MIN_GOODS_ID = 1;
  MAX_GOODS = 20;
  MAX_GOODS_ID = 20;
  MAX_TRADER = 128;
  MIN_TRADER_ID = 0;
  GRADE__RICH = 0;
  GRADE__COMMON = 1;
  GRADE__POOR = 2;

const
  SOLDIER_TYPE_0 = 0;
  SOLDIER_TYPE_1 = 1;
  SOLDIER_TYPE_2 = 2;
  SOLDIER_TYPE_3 = 3;
  
  CITY_WEAPON_1 = 1;
  CITY_WEAPON_2 = 2;
  CITY_WEAPON_3 = 3;
  CITY_WEAPON_4 = 4;

  CITY_WEAPON_WEIGH_FACTOR = 10;

  SHIP_WEAPON_1 = 1;
  SHIP_WEAPON_2 = 2;
  SHIP_WEAPON_3 = 3;
  SHIP_WEAPON_4 = 4;
  SHIP_WEAPON_5 = 5;
  SHIP_WEAPON_6 = 6;

  SHIP_WEAPON_WEIGHT_FACTOR_1 = 1000;
  SHIP_WEAPON_WEIGHT_FACTOR_2 = 1000;
  SHIP_WEAPON_WEIGHT_FACTOR_3 = 2000;
  SHIP_WEAPON_WEIGHT_FACTOR_4 = 2000;
  SHIP_WEAPON_WEIGHT_FACTOR_5 = 2000;
  SHIP_WEAPON_WEIGHT_FACTOR_6 = 1000;

  SHIP_LVL0 = 0;
  SHIP_LVL1 = 1;
  SHIP_LVL2 = 2;
  SHIP_LVL3 = 3;
  
type
  IPriceProvider = interface
  ['{E7B2947B-6640-494B-B0DF-986273E44A40}']
    function  getPPrice(goodsID: integer): Integer;
    function  getSPrice(goodsID: integer): Integer;
  end;
  
  TBytes14 = array[1..14] of Byte;
  TP3R2Ship = packed record
    Owner: Byte;
    Heading: Byte; //航向，01为左，05为上，09为右，0E为下
    Stub0: array[1..2] of Byte;
    NextShipIndex: Word;
    UnknownIndex: Word;
    //above 6
    
    GroupIndex: Word;
    Stub0_1: array[1..4] of Byte;
    ShipType: Byte;
    ShipUgLvl: Byte;
    //above 16

    LoadUpLimit: LongWord;      
    MaxPoint: LongWord;
    CurrPoint: LongWord;

    Stub0_2: array[1..2] of Byte; //疑为横向角度
    PosX: Word;
    Stub0_3: array[1..2] of Byte; //疑为纵向角度
    PosY: Word;

    //above 36

    Stub1: array[1..16] of Byte;

    //above 52
    Stub2: array[1..3] of Byte;

    //above 55
    From, Dest, Curr: Byte;
    Stub3: array[1..2] of Byte;

    Ship_Index_3C: Word; //unknown index, may be next ship index in same group

    //above 62

    ShiQi: Smallint; 

    Seaman: Word;
    Captain: Word;

    //above 68
    ReachNextPointTS: LongWord;
    ReachDestTS: LongWord;
    StartSailTS: LongWord;
    Stub4: LongWord;

    //above 84

    Goods: array[1..MAX_GOODS] of integer;     //164
    CityWeapons: array[1..4] of integer;       //180

    Stub5: array[1..25] of LongWord;
    //280

    GoodsLoad: integer;
    WeaponLoad: integer;
    //above 288

    Power: Word;
    Stub5_2: array[1..16] of byte;
    //306

    TradingIndex: Word;
    //308=$134
    
    State: Byte;
    Stub5_3: Byte;

    //310

    IsTrading: Byte;
    Stub5_4: byte;

    //312=$138
    UnknownWord: Word;        //这个值和$40作比较，是何意？

    Stub6: array[1..2] of Byte;
    Carnons: array[1..24] of Byte;
    Sword: Word;                 //短剑
    Stub7: array[1..10] of Byte;
    ShipName: array[1..MAX_SHIP_NAME_LENGTH+1] of Char; //#0 terminated
    Stub8: TBytes14;
  public const  //ShipType
//    ST__ShiNaiKa  = 0;
//    ST__KeLeiEr   = 1;
//    ST__KeKe      = 2;
//    ST__HuoEr     = 3;
  public const //Upgrade level
    UL__1         = 0;
    UL__2         = 1;
    UL__3         = 2;
  public
    function  isInGroup(): Boolean;
  end;

  PP3R2Ship = ^TP3R2Ship;

  TCaptainRec = record
    UnknownIndex: Word;         //next index
    Unknown: byte;              //may be first name index
    unknown1_1: byte;           //may be last name index
    birdthDay: LongWord;
    unknown1_2: byte;
    exp_sailing: byte;
    exp_trading: byte;
    exp_fighting: byte;
    salaryInDay: Word;
    Unknown2: Byte;
    Owner: Byte;

    function  getBOManagerTradingExpLvl(): Integer;
  end;

  PCaptainRec = ^TCaptainRec;
  
  TMyHotKey = class
  public
    Modifier, VKey: DWORD;
  end;

  THotKeyList = class
  private
    fList: THashedStringList;
  public
    constructor Create();
    destructor Destroy; override;

    procedure addMod(const text: string; aModifier: word);
    procedure addKey(const text: string; aKey: word);

    function  getHotkey(text: string): TMyHotKey;
  private
    procedure add(text: string; aModifier, aKey: Word);
  end;


const
  SHIP_NAME_OFFSET_R2 = $160; //338 + 14

const
  SHIP_TYPE__SHINAIKE = 0;
  SHIP_TYPE__KELEIER = 1;
  SHIP_TYPE__KEGE = 2;
  SHIP_TYPE__HUOERKE = 3;

//  SHIP_LVL__1 = 0;
//  SHIP_LVL__2 = 1;
//  SHIP_LVL__3 = 2;

  CANNON__STUB = $FF;
  CANNON__NONE = $07;
  CANNON__QIEPAO = $04;
  CANNON__JIANONG = $05;
  CANNON__DAN_PAO_WEI_TOU_SHI = $00;
  CANNON__DAN_PAO_WEI_NU_PAO = $02;

  SHIP_STATE__ANCHOR = $00;  //港内(不动)
  SHIP_STATE__BUSINESS = $01;  //港内(贸易)
  SHIP_STATE__LEAVE = $02;  //离港，出城
  SHIP_STATE__ENTER = $03;  //靠港，靠岸(未到岸)

  SHIP_STATE__FIX = $06; //维修
  SHIP_STATE__DEFENSE = $08; //城市护卫

  SHIP_STATE__BUILDING = $0E;

  SHIP_STATE__ON_SEA = $0F;
  SHIP_STATE__SINKING = $11; //下沉中
  SHIP_STATE__PIRATE = $12;
  SHIP_STATE__REMOTE_TRADING = $13;
  SHIP_STATE__BATTLE = $14;
  SHIP_STATE__KILLED = $FF;

  CAPTAIN_NONE = $FFFF;



//  city__lubike = 09;
//  CANNON__

function  isValidShipType(const typ: Byte): Boolean;
function  getShipTypeText(const typ: Byte): WideString;


function  isValidShipUgLvl(const lvl: Byte): Boolean;
function  getShipLvlText(const lvl: Byte): WideString;

function  isValidCaptain(const captain: Word): Boolean;

function  isValidCannon(const aCannon: Byte): Boolean;

function  isValidUpload(const aUpload: Cardinal): Boolean;

//function  isValidQty(const q: Cardinal): Boolean;

procedure clearMemList(aList: TList);
procedure freeMemList(aList: TList);

function  isValidShipPtr_R2(ship: PP3R2Ship): Boolean;
function  testShip_R2(minP: Pointer; p: Pointer): Pointer;

function  getShipTypeAndLvlText_R2(ship: PP3R2Ship): WideString;

//procedure dbgShipContent(ship: PP3Ship);

function  getGoodsName(const aGoodsID: Integer): WideString;
function  isGoodsMeasuredInPkg(const aGoodsID: Integer): Boolean;
function  getGoodsUnit(const aGoodsID: Integer): WideString;
//function  getGoodsQtyFactor(goodsID: integer): Integer;

function  getGoodsDisplayQty(const aGoodsID: Integer; const aQty: Integer): Currency;
function  getGoodsDisplayQtyText(const aGoodsID: Integer; const aQty: Integer): WideString;

function  getShipName_R2(ship: PP3R2Ship): string;
function  setShipName(ship: PP3R2Ship; const shipName: string): Boolean;
function  isValidShipName(sn: string): Boolean;
function  isValidCity(city: Byte): Boolean;

const
  UNIT_WEAPON = 10;
  UNIT_TONG = 200;
  UNIT_PKG = 2000;

const
  MAX_UPLOAD = 990000 * UNIT_TONG;
  MIN_UPLOAD = 90 * UNIT_TONG;
  MAX_SHIQI = $0700;
  MAX_SWORD = 300;
  MAX_POWER = 432;
  MAX_CITY_COUNT = 40;
  MIN_CITY_CODE = 0;
  MAX_CITY_CODE = 40-1;
  MIN_INTERNAL_CITY_CODE = 0;
  MAX_INTERNAL_CITY_CODE = 40-1;

const
  COLOR_RED: TColor = clSkyBlue;
  COLOR_BLUE: TColor = $00A8F0F9;
  COLOR_UNKNOWN: TColor = clWhite;

var
  FAV_CAPTAIN: Word = $02;
  FAV_LOAD: LongWord = MAX_UPLOAD;
  FAV_SHIP_POINT: LongWord = 1000000;
  FAV_QTY: Integer = 4500;
  FAV_START_ADDR: Cardinal = 0;
  FAV_END_ADDR: Cardinal = 0;
  HK__MODIFIER: WORD;
  HK__KEY: WORD;
  SHIP_NAME_PREFIX: string = 'alphax';
  FAV_CITY_WEAPON: Integer = 10000 * 10;

  SHIP_NAME_OTHERS_SEED: Integer = 1;
  USE_FORM2: Boolean = False;

function  getOffsetColor(const aOffset: Integer): TColor;

procedure p3setShipName_R2(ship: PP3R2Ship; const aName: string);


const
  CITY_FLAG__INNER_PORT = $01;        //内河
  CITY_FLAG__WINTER = $02;            //冬季
  CITY_FLAG__SIEGE = $10;             //围攻
  CITY_FLAG__TRADE_STATION = $20;     //贸易站
  CITY_FLAG__LEAGUE = $40;            //同盟            //可以当市长
  CITY_FLAG__BRANCH = $80;            //汉萨分部        //公会，造船

  //同盟城镇为$E0

type
//  TCityCodeEntry = class
//  public
//    CityName: WideString;
//  end;


  TCityOriginalProd = packed record
    Rate: Word;
    Stub1: Word;
    Stub2: array[1..3] of LongWord;
  end;

  TCityBuilding = packed record
    CoordinateX: Byte;
    CoordinateY: Byte;
    Owner: Byte;              //$FF for public
    BuildingType: Byte;
    NextIndex: Word;
    DaysNeedToComplete: Byte; //$FF for invalid
    ImageDirection: Byte;
  end;
  PCityBuilding = ^TCityBuilding;

  TCityBuildings = array[0..High(Word)] of TCityBuilding;
  PCityBuildings = ^TCityBuildings;
  
  TCityStruct = packed record
//    IsHomeCity: Byte;
    Stub0: array[0..3] of Byte;
    GoodsStore: array[1..MAX_GOODS] of Integer;    //84
    CityWeapon: array[CITY_WEAPON_1..CITY_WEAPON_4] of LongWord;
    //above 100

    GoodsConsumes: array[1..MAX_GOODS] of LongWord; //180 (80) //城镇生产消耗
    Stub0_3: array[1..16] of Byte;                  //196
    GoodsProduct: array[1..MAX_GOODS] of LongWord; //276  (80)
    Stub0_4: array[1..16] of Byte;                  //292
    //above 292
    ShipWeapons: array[SHIP_WEAPON_1..SHIP_WEAPON_6] of Longword; //(24)
    //above 316
    Stub1: array[1..384] of Byte;           //700

    //above 700
    SwordStore: Smallint;
    Stub1_1: array[1..2] of Byte;
    //Above 704

    CityCode: Byte;
    CityInternalCode: byte;
    //Above 706
    Stub1_1_2: array[1..6] of Byte;
    //Above 712
    CityTypeFlags: Byte;
    Stub1_1_3: array[1..3] of Byte;

    //above 716
    WhaleOilProdRate: Word;
    Stub1_2: array[1..6] of Byte;           //724
    Pop_Total: integer;                    //=rich+common+poor+begger
    Pop_rich: integer;
    Pop_common: integer;
    Pop_poor: integer;
    Pop_begger: integer;                    //744

    PrevPop_Rich: integer;
    PrevPop_Common: integer;
    PrevPop_Poor: integer;
    PrevPop_Begger: integer;

    AdvHouseCap: Word;                    //测过是word
    CommonHouseCap: Word;
    PoorHouseCap: Word;
    
    Stub2: array[1..10] of Byte;            //776
    Satisfy_rich: Smallint;
    Satisfy_common: Smallint;
    Satisfy_poor: Smallint;
    Satisfy_begger: Smallint;                    //784
    Stub2_1: array[1..1008] of Byte;
    Treasury: Integer;
    Stub2_1_2: array[1..88] of Byte;
    //above 1884
    BuildingListPtr: Pointer;
    //above 1888
    Stub2_1_3: array[1..2] of Byte;
    //above 1890
    FirstUnfinishedBuildingIndex: Word;             //只包括城镇的设施？
    FirstFinishedBuildingIndex: Word;
    Stub2_2: array[1..6] of Byte;
    //above 1900
    Stub2_3: array[1..4] of Byte;
    //above 1904
    ChapelReq: Byte;
    ChapelProv: Byte;
    //above 1906
    HospitalReq: Byte;
    HospitalProv: Byte;
    //above 1908
    Stub2_4: array[1..2] of Byte;
    //above 1910

    BuildingCount: Word;
    //above 1912
    Stub2_4_2: array[1..12] of Byte;
    //above 1924
    FirstBOIndex: Word;
    Stub2_5: array[1..3] of Byte;
    //above 1929
    WellProv: Byte;       //水井
    Stub2_6: array[1..2] of Byte;
    //above 1932
    Church_1_: Word; //教堂等级？
    Church_2_: Word; //教堂等级？
    //above 1936
    RoadComplete: Word;       //道路完成
    RoadReq: Word;            //道路需求
    //above 1940
    FitmentFunds: LongWord;   //装修经费
    //above 1944
    ChapelUpgradeFunds: Longword;
    //above 1948
    Church_UpgradeReq_: Word;         //教堂升级需求？
    //above 1950
    Stub2_7: array[1..50] of Byte;
    //above 2000
    Stub2_8: array[1..64] of Byte;
    //above 2064
    DockyardExp: Integer;           //
    //above 2068
    Stub2_9: array[1..16] of Byte;
    //above 2084
    DockyardLvl: array[SHIP_TYPE__SHINAIKE..SHIP_TYPE__HUOERKE] of Shortint;
    //above 2088
    Stub2_10: array[1..6] of Byte;
    //above 2094
    FreeCaptain: Word;              //不要直接使用，请调用getFreeCaptain()
    Stub3: array[1..24] of Byte;               //2120
    //above 2120
    OriginalProd: array[0..$13] of TCityOriginalProd;
    //above 2440      
    Stub3_1: array[1..16] of Byte;
    //above 2456
    Soldiers: array[SOLDIER_TYPE_0..SOLDIER_TYPE_3] of Byte;
    TrainingSoldiers: array[0..3] of Byte;
    TotalAllowedSoldiers: SmallInt;
    Stub4: array[1..86] of Byte;

    function  getGoodsStore(goodsID: integer): LongWord;
    function  getFactoryProd(goodsID: integer): integer;
    function  getFactoryConsume(goodsID: integer): integer;
    function  getGoodsStoreText(goodsID: integer): string;
//    function  calcConsumeInDay(goodsID: integer; const consultSeasonEffect: boolean): double;

    function  getCityWeapon(id: integer): integer;
    function  getCityWeaponStr(id: integer): string;

    function  getCityShipWeapon(id: integer): integer;
    function  getCityShipWeaponStr(id: integer): string;

    procedure getSoldierCount(out cnt, training: integer);

    function  isBranch(): Boolean;

    procedure updateTotalAllowedSoldiers();  
  end; //2552
  PCityStruct = ^TCityStruct;

  TCityList = packed record
    CityCount: Integer;
    Cities: array[0..MAX_CITY_CODE] of TCityStruct; //
  end;
  PCityList = ^TCityList;


  TCityBuildingDataCache = class
  private
    ready: Boolean;

    city: integer;

    HasSchool: Boolean;
    SchoolDaysToComplete: integer;

    HasMintage: Boolean;
    MintageDaysToComplete: Integer;

    Lvl1WallCount: integer;
    Lvl2WallCount, Lvl2WallCompleted: integer;
    Lvl3WallCount, Lvl3WallCompleted: integer;

    l1CityGate_Artillery, l2CityGate_Artillery,
    l1Seacoast_Artillery, l2Seacoast_Artillery,
    paoSheCount: integer;
    
    procedure prepare();  
  public
    constructor Create(city: Integer);

    procedure reset();

    function  getHasSchool(): Boolean;
    function  getSchoolDaysToComplete(): Integer;

    function  getHasMintage(): Boolean;
    function  getMintageDaysToComplete(): Integer;

    procedure getWallInfo(
            out lvl1WallCount, lvl2WallCount, lvl2WallComplete,
            lvl3WallCount, lvl3WallCompleted: integer);  

    function  getLvl1WallCount(): Integer;

    function  getLvl2WallCount(): Integer;
    function  getLvl2WallCompleted(): Integer;

    function  getLvl3WallCount(): Integer;
    function  getLvl3WallCompleted(): Integer;

    procedure getCityGate_Artillery(out l1, l2: integer);
    procedure getSeacoast_Artillery(out l1, l2: integer);
    function  getPaoSheCount(): integer;
  end;

  TCityBuildingCacheList = class
  private
    caches: array[MIN_CITY_CODE..MAX_CITY_CODE] of TCityBuildingDataCache;
  public
    constructor Create();
    destructor Destroy; override;
    function  get(city: integer): TCityBuildingDataCache;
    procedure reset();
  end;


const
  CITY_BUILDING_OWNER__PUBLIC = $FF;
  CITY_BUILDING_OWNER__PUBLIC_LVL2_WALL = $FE;
  CITY_BUILDING_OWNER__PUBLIC_LVL3_WALL = $FD;

  BUILDING__WEAPON_SHOP = $03;          //武器店
  BUILDING__HUNTER_HOUSE = $04;         //猎屋
  BUILDING__PISCARY = $05;              //捕鱼场
  BUILDING__BEER_FACTORY = $06;
  BUILDING__TOOLS_FACTORY = $07;
  BUILDING__APIARY = $08;               //养蜂场
  BUILDING__RICE_FIELD = $09;
  BUILDING__COW_FARM = $0A;
  BUILDING__LOGGING_CAMP = $0B;         //伐木场
  BUILDING__TEXTILE_MILL = $0C;         //纺织厂
  BUILDING__SALTERN = $0D;
  BUILDING__IRON_MILL = $0E;
  BUILDING__SHEEP_FARM = $0F;
  BUILDING__VINEYARD = $10;
  BUILDING__CERAMIC_FACTORY = $11;      //陶瓷厂
  BUILDING__BRICKYARD = $12;            //砖厂
  BUILDING__ASPHALT_FACTORY = $13;      //沥青厂
  BUILDING__HEMP_FIELD = $14;           //麻田
  BUILDING__HOUSE_ADV_1 = $15;
  BUILDING__HOUSE_ADV_2 = $16;
  BUILDING__HOUSE_ADV_3 = $17;
  BUILDING__HOUSE_NOR_1 = $18;
  BUILDING__HOUSE_NOR_2 = $19;
  BUILDING__HOUSE_NOR_3 = $1A;
  BUILDING__HOUSE_SIM_1 = $1B;
  BUILDING__HOUSE_SIM_2 = $1C;
  BUILDING__HOUSE_SIM_3 = $1D;
  BUILDING__STORE_HOUSE = $1E;
  BUILDING__CHURCH = $1F;
  BUILDING__CITY_HALL = $20;
  BUILDING__BARRACKS = $21;
  BUILDING__CHAMBER_OF_COMMERCE = $22;
  BUILDING__MARKET = $23;
  BUILDING__BAR = $24;
  BUILDING__BANK = $25;
  BUILDING__BATH_HOUSE = $26;
  BUILDING__WELL = $28;
  BUILDING__HOSPITAL = $29;
  BUILDING__MINTAGE = $2A;
  BUILDING__SCHOOL = $2B;
  BUILDING__CHAPEL = $2C;
  BUILDING__STATUE = $2D;
  BUILDING__COAL_MINE = $2F;
  BUILDING__SEACOAST_ARTILLERY = $30;
  BUILDING__SEACOAST_ARTILLERY_ADV = $31;
  BUILDING__CITY_GATE_ARTILLERY = $32;
  BUILDING__CITY_GATE_ARTILLERY_ADV = $33;
  BUILDING__PAO_SHE = $34;
  BUILDING__CITY_WALL = $36;

  FIRST_FACTORY_BUILDING = BUILDING__HUNTER_HOUSE;
  LAST_FACTORY_BUILDING = BUILDING__HEMP_FIELD;

  BUILDING_IMAGE_DIRECTION__NONE = $00;
  BUILDING_IMAGE_DIRECTION__LEFT_TOP = $20;   //游戏视角中为东北-西南向
  BUILDING_IMAGE_DIRECTION__BOTTOM_RIGHT = $E0;



const
  CITY_STRUCT_SZ = 2552;
  CITY_LIST_SZ = SizeOf(TcityList);

const
 RESIDENT_REQ_OFFSET = $288d30;
 REQ_UNIT_PACKAGE = 0.035;
 REQ_UNIT_TONG = 0.350;

 P3_MONEY_UPPER_LIMIT_OFFSET = $228E1E;
 P3_MODULE_BASE = $400000;
 P3_GAME_DATA_OFFSET = $71CDA8 - P3_MODULE_BASE;
 P3__71CDA8 = P3_GAME_DATA_OFFSET;
 P3_SET_SHIP_DEST_FUNC_OFFSET = $557A80 - P3_MODULE_BASE;

 P3_HOUSE_CAPACITY_DATA_OFFSET = $288EE8;

type
  TGameData = packed record
    day: Byte;
    month: Byte;
    year: word;
    //above 4
    Stub1: Longword;     //(玩家id + stub1) div cityCount
    //aboev 8
    BOCount: Word;
    TraderCount: Word; 
    //above $0C

    baseTS: LongWord;

    //above $10
    cityCount: byte;
    Stub2: array[1..3] of Byte;

    //above $14
    currTS: LongWord;

    //above $18, decimal(24)

    cityInternalCodeMapping: array[1..40] of Byte;

    //above 64
  end;

  PGameData = ^TGameData;

  TResidentReq = packed record
    FuHaoReqQty: Word;
    FuRenReqQty: Word;
    QiongRenReqQty: Word;
    Importance: Byte;
    Unknown: Byte;
  end;

  TItemRequirement = array[1..20] of TResidentReq;
  PItemRequirement = ^TItemRequirement;

  TTradeOpType = (
    OT__Unspecified,
    OT__Buy,
    OT__Sell
  );

  TBOShipLoadingFlags = array[1..3] of Byte;

  TBusinessOffice = packed record
    Stub1: Longword;
    GoodsStore: array[1..MAX_GOODS] of integer;
    CityWeaponStore: array[1..4] of integer;
    FactoryConsumes: array[1..MAX_GOODS] of integer;
    Stub2: array[1..16] of Byte;
    FactoryProductions: array[1..MAX_GOODS] of integer;
    Stub3: array[1..16] of Byte;
    //above 292
    ShipWeapons: array[1..6] of Integer; //小投、小弩、大投、大弩、铁炮、加农，小型乘1000，大型乘2000
    Stub4: array[1..384] of Byte;
    //above 700
    Sword: SmallInt;
    Stub5: array[1..6] of Byte;
    //above 708
    Owner: Byte;            
    Stub5_1: byte;
    //above 710
    CityCode: Byte;
    Guard: Byte;
    Stub5_2: array[1..2] of Byte;
    //above 714
    NextBOIndexInSameCity: Word;
    //above 716
    BOIndex: Word;           //BOIndex
    //above 718
    FirstBusinessBuildingIndex: SmallInt;         //第一商业建筑索引？或仓库索引？
    FirstHouseBuildingIndex: SmallInt;              //第一住宅索引
    //above 722

    BusinessBuildingCount: SmallInt;                        //商业建筑数量？
    HouseCount: SmallInt;                             //住宅类建筑数量
    // above 726
    Stub5_3: array[1..2] of Byte;
    // above 728
    HouseMaxCapacity_: array[GRADE__RICH..GRADE__POOR] of Word;
    // above 734
    HouseResidents_: array[GRADE__RICH..GRADE__POOR] of Word;
    //above 740
    Stub7: array[1..8] of Byte;
    //above 748
    StoreHouseMaxCap: Word; //当前仓库容量，单位包
    //ABOVE 750
    BuildingStoreHouseCap: Word;  //在建仓库容量，单位包
    Stub8: array[1..2] of Byte;
    //above 754
    ManagerID: Word;          //管理员ID
    
    //above 756
    BusinessPrices: array[1..MAX_GOODS] of Integer; //谷物定价，采用带符号的表示方法，正数卖出，负数买进。


    Stub9: array[1..16] of Byte; //not used

    //above 852 
    BusinessLimits: array[MIN_GOODS_ID..MAX_GOODS_ID] of LongWord; //谷物购入或销售的限额

    Stub9_2: array[1..16] of Byte; //not used

    //above 948
    

    {20种物品分三类，各赋以16进制值，三位字节分别相加的结果作为纪录。
    反之可求当前事务所设置状况,
    see also:
      ..\mod-stuff\事务所船只装载限制选项.jpg
    }
    ShipLoadStrictFlags: TBOShipLoadingFlags;

    Stub10: array[1..96] of Byte;

    
    Stub11: array[1..5] of Byte;

    //1052
    RentIncoming: LongWord;           //租金收入
    Stub12: array[1..12] of Byte;
    Pay: Longword;                    //工厂工资
    Stub13: array[1..2] of Byte;
    ThisWeekOfficeManagerPaid: Word;       //本周支付管理员工资

    //1076
    LastWeekOfficeManagerPaid: word;        //上周支付管理员工资
    Stub14: array[1..6] of Byte;
    Hidage: LongWord;                 //地税
    Stub15: array[1..8] of Byte;
    CurrWorkers: Word;                //当前工人总数
    MaxWorkers: Word;                 //最大工人数量
  public
    function  getFactoryProd(goodsID: Integer): longword;
    function  getFactoryConsume(goodsID: Integer): longword;

    function  getTradeOpType(goodsID: integer): TTradeOpType;
    function  getTradeQty(goodsID: integer): Integer;
    function  getTradePrice(goodsID: integer): Integer;
    procedure setTradeOpType(goodsID: integer; opType: TTradeOpType; const aPriceProv: IPriceProvider);
    procedure setTradePrice(goodsID: integer; price: integer);
    procedure setTradeQty(goodsID: integer; qty: integer);  

    //船只装载限制
    function  isTradeShipLoadRestricted(goodsID: integer): boolean;
    procedure setTradeShipLoadRestricted(goodsID: integer; restricted: Boolean);

    function  getStoreHouseCount(): Integer;
  end; //size=1100

  PBusinessOffice = ^TBusinessOffice;

  TTradeRouteOpType = (
    RT__UNSPECIFIED,
    RT__SELL,
    RT__BUY,
    RT__PUT_INTO,
    RT__GET_OUT
  );
  
  TTradeRoute = packed record
    NextIndex: Word;
    CityCode: Byte;
    Flags: Byte;
    Orders: array[1..24] of Byte;
    Prices: array[1..24] of LongWord;
//    Unknown: array[1..4] of LongWord;
    MaxQty: array[1..24] of LongWord;

    function  isFirstFlagSet(): Boolean;
    procedure setFirstFlag();
    procedure clearFirstFlag();

    function  isFixFlagSet(): Boolean;
    procedure setFixFlag();
    procedure clearFixFlag();

    function  isNoStopFlagSet(): Boolean;
    procedure setNoStopFlag();
    procedure clearNoStopFlag();  

    function  getOpType(index: Integer): TTradeRouteOpType;
    function  getOpTypeStr(index: integer): WideString;
    function  IsUnlimitedQty(index: Integer): Boolean;
    function  getMaxQty(index: Integer): Integer;
    function  getPrice(index: Integer): Integer;

    procedure setSell(index: integer; price, qty: integer);
    procedure setBuy(index: integer; price, qty: integer);
    procedure setPutInto(index: integer; qty: integer);
    procedure setGetOut(index: integer; qty: integer);
    procedure setNoOp(index: integer);
  end;
  PTradeRoute = ^TTradeRoute;


  TFactoryGroup = packed record                           
    intensification: Byte;
    {
      第1字节表示该组工厂的集约化程度，
        1~2间，高低产均为“00”，无加成，
        3~5间，高产“1E”，低产“17”，加成3%
        6~8间，高产“3D”，低产“2E”，加成6%
        9间以上，高产“66”，低产“4C”，加成10%
        高低之间的16进制值符合4：3的关系    
    }

    ProductionFactor: Byte; //表示高低产，03=低，04=高

    Unknown: array[1..2] of Byte;
    CurrentWorkers: Word;
    BuildType: Byte;          //建筑类型，巡洋舰认为是物产代码，未验证
    CityCode: Byte;
    NextIndex: Word;
    MaxWorkers: Word;
    Workers2: Word;
    Workers3: Word;
    Unknown2: array[1..4] of Byte;
  end;
  PFactoryGroup = ^TFactoryGroup;

  TFactoryGroupEx = packed record
    IsValid: LongBool;
    DataPtr: PFactoryGroup;
  end;

  TCityBOData = record
    PlayerID: Byte;
    BOPtr: PBusinessOffice;
    FactoryGroups: array[FIRST_FACTORY_BUILDING..LAST_FACTORY_BUILDING] of TFactoryGroupEx;
  end;

  TCityBODataCache = record
    Ready: Boolean;
    CityCode: Byte;
    Count: Integer;
    BOData: array[0..MAX_TRADER-1] of TCityBOData;

    procedure init(const aCityCode: Byte);
    procedure reset();
    procedure fill();

    function  getCount(): Integer;
    function  findPlayerBO(const pid: Byte): PBusinessOffice;
    function  findFactoryGroup(const pid: Byte; const aBuildingType: Byte): PFactoryGroup;
  end;
  PCityBODataCache = ^TCityBODataCache;

  TCityBODataCacheList = record
    Caches: array[0..MAX_CITY_CODE] of TCityBODataCache;

    procedure reset();
    procedure init();
    function  findBO(const aCity: Byte; const aPlayer: Byte): PBusinessOffice;
    function  findFactoryGroup(const aCity: Byte; const pid: Byte; const aBuildingType: Byte): PFactoryGroup;
    function  get(city: integer): PCityBODataCache;
  end;


  TCityTraderShipList = class
  public
    owner: Byte; //traderID
    ShipList: TList;

    constructor Create();
    destructor Destroy; override;
  end;

  TCityShipList = class
  public
    cityCode: Byte;
    List: TObjectList;

    constructor Create(cityCode: Byte);
    destructor Destroy; override;

    function  get(const aTrader: Byte): TCityTraderShipList;
    procedure clear();


  end;

  TAllCityShipList = class
  public
    List: TObjectList;

    constructor Create();
    destructor Destroy; override;

    procedure clear();
    function  get(const city: Byte): TCityShipList;

    function  getCityIconType(cityCode: Byte): TCityIconType;
  end;

  THouseCapacityInfo = record
    Ready: Boolean;

    _AdvHouseCap: Integer;
    _CommonHouseCap: Integer;
    _PoorHouseCap: Integer;

    procedure init();
    procedure reset();
    function  getCap(const grade: byte): integer;  
  end;

  TTraderInfo = record
    Ready: Boolean;
    traderID: byte;
    BOCount: Integer;
    ShipCount: Integer;

    procedure reset(traderID: Byte);
    procedure load();
    procedure prepare();
    procedure traderShipCountChanged();  
  end;

  PTraderInfo = ^TTraderInfo;

  TTraderInfoCache = class
  private
    Info: array[0..MAX_TRADER-1] of TTraderInfo;
  public
    constructor Create();
    procedure reset();

    function  get(traderID: byte): PTraderInfo;
    procedure traderShipCountChanged(trader: byte);
  end;
  


const
  TRADE_ROUTE_FLAG__NO_STOP = $08;  //不靠港
  TRADE_ROUTE_FLAG__FIRST = $04;    
  TRADE_ROUTE_FLAG__FIX = $01;      //维修

const
  SIZE_OF_BUSINESS_OFFICE = 1100;

  BOINFO__CITY_WEAPON_STORE_1 = 1;
  BOINFO__CITY_WEAPON_STORE_2 = 2;
  BOINFO__CITY_WEAPON_STORE_3 = 3;
  BOINFO__CITY_WEAPON_STORE_4 = 4;




  BOINFO__SWORD = 5;

  BOINFO__SHIP_WEAPON_1 = 6;
  BOINFO__SHIP_WEAPON_2 = 7;
  BOINFO__SHIP_WEAPON_3 = 8;
  BOINFO__SHIP_WEAPON_4 = 9;
  BOINFO__SHIP_WEAPON_5 = 10;
  BOINFO__SHIP_WEAPON_6 = 11;

  BOINFO__GUARD = 12;
  BOINFO__CITY_CODE = 13;
  BOINFO__STORE_HOUSE_MAX_CAP = 14;
  BOINFO__BUILDING_STORE_HOUSE_CAP = 15;

  BOINFO__PAY = 16;
  BOINFO__MANAGER_SALARY = 17;
  BOINFO__HIDAGE = 18;
  BOINFO__CURR_WORKERS = 19;
  BOINFO__MAX_WORKERS = 20;
  BOINFO__OWNER = 21;
  BOINFO__RENT_INCOMING = 22;
  BOINFO__BUSINESS_BUILDING_QTY = 23;
  BOINFO__HOUSE_QTY = 24;
  BOINFO__HOUSE_RESIDENT_RICH = 25;
  BOINFO__HOUSE_CAP_RICH = 26;
  BOINFO__HOUSE_RESIDENT_COMMON = 27;
  BOINFO__HOUSE_CAP_COMMON = 28;
  BOINFO__HOUSE_RESIDENT_POOR = 29;
  BOINFO__HOUSE_CAP_POOR = 30;

  BOINFO__IR__FACTOR = 31;
  BOINFO__IR__UNKNOWN = 32;
  BOINFO__IR__INTERNAL_GOODS_ID = 33;
  BOINFO__IR__CITY = 34;
  BOINFO__IR__NEXT_INDEX = 35;



  BOINFOFIRST = BOINFO__CITY_WEAPON_STORE_1;
  BOINFOLAST = BOINFO__IR__NEXT_INDEX;

const
  //比游戏值多1
  GOODSID__RICE = 1;
  GOODSID__MEAT = 2;
  GOODSID__FISH = 3;
  GOODSID__BEER = 4;

  GOODSID__SALT = 5;
  GOODSID__HONEY = 6;
  GOODSID__SPICE = 7;           //香料
  GOODSID__WINE = 8;

  GOODSID__CLOTH = 9;
  GOODSID__ANIMAL_SKIN = 10;
  GOODSID__WHALE_OIL = 11;
  GOODSID__WOOD = 12;

  GOODSID__TOOLS = 13;
  GOODSID__LEATHER = 14;        //皮革
  GOODSID__WOOL = 15;
  GOODSID__ASPHALT = 16;        //沥青

  GOODSID__IRON = 17;
  GOODSID__HEMP = 18;
  GOODSID__POTTERY = 19;        //陶器
  GOODSID__BRICK = 20;


//var
//  CityCodeEntries: array[0..MAX_CITY_CODE] of TCityCodeEntry;

//var
//  OrginalCityNames: array[0..MAX_CITY_CODE] of WideString;

//  CityListPtr: Pointer;

//function  getCityName(const aCityCode: Byte): WideString;
function  isPirateShip_R2(p: PP3R2Ship): Boolean;
function  getPageSizeText(const sz: Integer): WideString;
function  getCityPtr(const aCityCode: Byte): PCityStruct;
function  getCityListPtr(): PCityList;
procedure p3DSSelfTest();
function  isCityListAvailable(): Boolean;
//function  getHomeCity(cityList: PCityList): Byte;
function  reCalcCityPopTotal(city: PCityStruct): cardinal;
function  GoodsIDToProdRateIndex(const aGoodsID: Integer): Integer;
function  GetCityOriginalProdRate(const aCity: PCityStruct; const aGoodsID: Integer): Word;
//procedure setCityOriginalProdRate(const aCity: Pci);

const
  PROD_LVL__NO_PROD = 0;
  PROD_LVL__LOW_PROD = 1;
  PROD_LVL__HIGH_PROD = 2;

//return 0 - 不产，1 - 低产，2 - 高产
function  getCityOriginalProdLvl(city: PCityStruct; goodsID: Integer): integer;
function  getProdAdv(aCity: PCityStruct; const aGoodsID: Integer): Currency;
function  calcSoldierTotal(aCity: PCityStruct; const aExcludeTraining: Boolean): Integer;
function  reCalcTotalAllowedSoldiers(aCity: PCityStruct): Integer;
function  getSoldierTypeName(const aSoldierIndex: Integer): WideString;
function  updateShipGoodsLoad(ship: PP3R2Ship): integer;

function  PYIndexToGoodsID(goodsPYIndex: integer): Integer;

//procedure testGetHeap();



procedure modP3StaticData(
        const aHouseCapacity: Boolean;
        const aShipCapacity: Boolean;
        const aShipSpeed: Boolean;
        const aFactoryWorkers: Boolean;
        const aResidentReq: Boolean;
        const aMoneyUpperLimit: Boolean);

function  getPlayerPtr(const aPlayerID: Byte): Pointer;
function  getPlayerMoneyPtr(const aPlayerID: Byte): PInteger;
function  getPlayerMoney(const aPlayerID: Byte): Integer;
procedure setPlayerMoney(const aPlayerID: Byte; const aMoney: Integer);

function  getGameDataPtr(): PGameData;
function getGameDate(out aYear, aMonth, aDay: Integer): Integer;
function  howOldIs(const aTraderID: Byte): Integer;
function  getCurrTS(): Cardinal;
//function  timestampToDateTime(const aTS: Cardinal): TDateTime;

//return hour
function timestampToDate(aTS: Cardinal; out y, m, d: Integer): Integer;
function  timestampToDateStr(aTS: Cardinal): string;
function  dateToTimestamp(y, m, d: integer): Cardinal;

procedure getGameDateFromTS(out y, m, d: integer);

procedure getCityShengWang(
          const aPlayerID: Byte;
          const aCityCode: Byte;
          out S1, S2, S3, S4, S5: Single);

procedure setCityShengWang(
          const aPlayerID: Byte;
          const aCityCode: Byte;
          const S1, S2, S3, S4, S5: Single);


function  getShipByIndex(index: integer): PP3R2Ship;

function  getShipList(const aTraderID: Byte; aList: TList): integer;
function  getTraderShipCount(trader: byte): Integer;
procedure getAllShipList(list: TList);
function  getshipArea(ship: PP3R2Ship; shipNameSeperator: WideChar): WideString;

type
  tshipFilter = function (ship: PP3R2Ship; data: Pointer): Boolean;
    
function  getShipListEx(const aTraderID: Byte; aList: TList; aFilter: tshipFilter; data: Pointer): Integer;
procedure getShipGroupList2(const traderID: Byte; aShipGroupList: TList);
function  getShipList_Building(const aTrader: Byte; list: TList; city: integer): Integer;

//function  getCityGoodsPrice(const aCity: ): Integer;

//function  getGamePtr(): Integer;


function  getCurrPlayerID(): Byte;
function  getCurrPlayerID_Program(): Byte;

function  getPlayerHomeCity(const aPlayerID: Byte): Byte;

function  cityCodeToInternalCode(cityCode: integer): Integer;
function  getOriginalCityID(aCityCode: Byte): Byte;

//return $FF for not occurred in current game
function  internalCityIDToCityCode(const aInternalCode: Byte): Byte;

function  getCityCount(): Integer;
procedure getCityNames(aList: TStrings; const aAddHexCodePrefix: Boolean);
function  getPlayerCount(): Integer;
function  isValidPlayerID(const aPlayerID: byte): Boolean;
function  getPlayerName(const aPlayerID: Byte): WideString;
function  getCityName2(const aCityCode: Byte): WideString;

function  isGameActive(): Boolean;
procedure getPlayerExtraInfo(
        const aPlayerID: Byte;
        out aTotalAssets: Integer;      //总资产
        out aTotalLoadingCap: Integer; //总运载能力
        out a15, a1B: Byte);
function  getPlayerTotalAssets(const aPlayerID: Byte): integer;
function  getPlayerTotalLoadingCap(const aPlayerID: Byte): Integer;
procedure setPlayerExtraInfo_1B(const aPlayerID: Byte; const a1B: Byte);


procedure getPlayerBirthday(const aPlayerID: Byte; out Y, M, D: Integer);


function  byteToHexStr(const b: Byte; const aDollarPrefix: Boolean = true): string;
function  wordToHexStr(const w: Word; const aDollarPrefix: Boolean = true): string;
function  longwordToHexStr(const lw: Longword; const aDollarPrefix: Boolean = true): string;
function  ptrToHexStr(const p: Pointer; const aDollarPrefix: Boolean = true): string;

function  getViewPortCityCode(): Byte;

const
  PlayerDataSize = (5 * 5 * 4 + 1) * 16;

function  getEvaluationPrefix(const aPlayerID: Byte): WideString;
function  getPlayerClass(const aPlayerID: Byte): WideString;
function  ptrAdd(p: Pointer; const aDelta: Integer): Pointer;
function  ptrAddI(p: integer; const aDelta: Integer): pointer;

//may return nil
function  getBusinessOfficePtr(const aPlayerID: Byte; const aCityCode: Byte): PBusinessOffice;

function  ptrDelta(pOrg, pOfs: Pointer): Integer;

function  getTradeRoute(const aIndex: Word): PTradeRoute;


function  getCityBuilding(aCity: PCityStruct; const aIndex: Integer): PCityBuilding;

function  getCityMap(const aCityCode: Byte): PByte;

function  getMapOffset(const aPt: TPoint): Integer;
function  getMapByte(aMap: PByte; const aPt: TPoint): Byte;
function  mapOffsetToPt(aOffset: Integer): TPoint;
//function  canMoveLT(aPt: TPoint): boolean;
//function  canMoveRT(aPt: TPoint): boolean;
function  transPtLT(aPt: TPoint; aDelta: Integer): TPoint;
function  transPtRT(aPt: TPoint; aDelta: Integer): TPoint;
//procedure  processMap(aMap: PByte);

function  getFactoryGroupInfo(const aIndex: Integer): PFactoryGroup;

function  getFirstFactoryGroupIndex(
          const aPlayerID: Byte;
          const aCityCode: Byte): Word;

function  buildTypeToGoodsID(const aBuildingType: Byte): Byte;
function  getGoodsFactoryType(const aGoodsID: Byte): Byte;

function  getFactoryMaxWorker(const aFactoryType: Byte): Integer;
function  getLastPlayerID(): Byte;


//aLvl:
//0 - rich
//1 - common
//2 - poor
//return week consume in 1/200 tong
function  getResidentConsumeRateInWeek(const aLvl: Byte; const aGoodsID: Byte): Double;

type
  TResidentReqF = record
    ThousandResidentsReqsInWeek: array[0..2] of Double;
  end;

  TResidentConsumePrecalc = class
  public
    Ready: Boolean;
    items: array[1..20] of TResidentReqF;

    constructor Create();

    procedure prepare();
    procedure reset();


    function  internalCalcWeek(
            const alvl: byte;
            const aGoodsID: byte;
            const aResidentCount: Integer): Double;

    function  calcDay(
            const alvl: byte;
            const aGoodsID: byte;
            const aResidentCount: Integer): Double;

    function  calcWeek(
            const alvl: byte;
            const aGoodsID: byte;
            const aResidentCount: Integer): Double;

    function  calcCityConsumeInDay(
            const aGoodsID: Byte;
            const aCityCode: Byte): Double;
    function  calcCityConsumeInWeek(
            const aGoodsID: Byte;
            const aCityCode: Byte): Double;  
  end;

const
  WINTER_REQ_INCREASE_RATE = 1 + 0.2;
  WINTER_PROD_DECREASE_RATE___RICE = 1 - 0.6666;
  WINTER_PROD_DECREASE_RATE___OTHERS = 1 - 0.5;


var
  P3ModuleHandle: THandle;

function  isWinter(const month: integer): Boolean;
function  isWinterNow(): Boolean;

function  isWinterReqIncGoods(const aGoodsID: Integer): Boolean;
function  isWinterProdDecGoods(const aGoodsID: Integer): Boolean;
function  calcWinterReqIncrease(const aCurrReq: Double; const aGoodsID: Integer): Double;
function  calcWinterProdDecrease(const aCurrProd: Double; const aGoodsID: Integer): Double;

procedure getCityMapPos(const aCityCode: Byte; out x, y: Integer);
function  isInSeaView(): Boolean;
procedure getTimeDiffInDays(aTS: Longword; out days, hours: Integer);
function  intervalToStr(const days, hours: Integer): string;

function  getGradeText(const grade: Byte): WideString;

procedure AxExtractStringByDelimiter(
        const aStr: string;         { 给定字符串 }
        const aDelimiter: Char;     { 分界符 }
        const aAddEmptyField: Boolean; { 是否把空字符串也添加到字符串列表中 }
        aResultStrList: TStrings    { 返回的子字符串列表 }
      );


{ *** TRADE ROUTE *** }

const
  MAX_TRADE_ROUTE_POINT = 20;
  TRADE_ROUTE__MAX_QTY = 1000000000;
  P3_TRADE_ROUTE_LIST_PPTR_OFFSET = $6DD070 - P3_MODULE_BASE;

function  tradeRoute_getPointCount(ship: PP3R2Ship): Integer;

//return new index
function  tradeRoute_new(): Word;

procedure tradeRoute_free(const aRoutePointIndex: Integer);

procedure tradeRoute_initOrders(p: PTradeRoute);

function  tradeRoute_getOpTypeName(opType: TTradeRouteOpType): WideString;

//function  tradeRoute_getOpType(p: PTradeRoute; index: integer): TTradeRouteOpType;

function  indexOfShip(ship: PP3R2Ship): Integer;

type
  TTradeRouteIndices = record
    Count: Integer;
    firstShipIndex: Integer;
    Indices: array[1..20] of Word;

    procedure reset();
    procedure add(const index: word);
    procedure reorder(firstSeq: integer);
    function  getTRIndex(seq: integer): Word;
    function  getTR(seq: integer): PTradeRoute;
    function  getFirstRP(): PTradeRoute;
    function  getLastTRIndex(): Word;
    procedure rechain();
    procedure remove(seq: integer; doRechain: boolean);
    function  has(TRID: integer): Boolean;
    function  firstFlagSeq(): integer;  
  end;

function  tradeRoute_getIndices(ship: PP3R2Ship; var indices: TTradeRouteIndices): Integer;
function  indexOfTradeRoute(p: PTradeRoute): Integer;

function  getGoodsQtyFactor(goodsID: Integer): Integer;

//城市售价
function  getCitySalePrice(qty, city, goodsID: Integer): Integer;
function  getCitySalePriceDef(city, goodsID: Integer): Integer;
function  getCityPurchasePrice(qty, city, goodsID: Integer): Integer;
function  getCityPurchasePriceDef(city, goodsID: Integer): Integer;
function  getCitySPriceStr(city, gid: integer): string;
function  getCityPPriceStr(city, gid: integer): string;


function  isFastForwarding(): Boolean;
procedure setFastForwarding(const fastForward: Boolean);

type
  TShipGroupInfo = packed record
    Owner: Byte;
    Stub1: array[1..3] of Byte;

    //above 4
    Capacity: LongWord;
    //above 8

    Stub2: array[1..2] of longWord;
    //above 9

    FirstShipIndex: Word; //疑为Longword类型
    Stub3: Word;
    Stub4: array[1..10] of Longword;
  end;
  PShipGroupInfo = ^TShipGroupInfo;

  TShipGroupInfoCache = class
  public
    ShipGroupInfo: PShipGroupInfo;
    FirstShip: PP3R2Ship;
    ShipList: TList;

    SeaManTotal: Integer;
    LoadingTotal: Integer;
    ShipWeaponTotal: integer;
    GoodsLoading: array[MIN_GOODS_ID..MAX_GOODS_ID] of Integer;

    constructor Create(sg: PShipGroupInfo);
    destructor Destroy; override;
    function  shipLoadingChanged(ship: PP3R2Ship): Boolean;
    function  shipCapacityChanged(ship: PP3R2Ship): Boolean;
    function  shipSeaManChanged(ship: PP3R2Ship): Boolean;
    function  shipWeaponChanged(ship: PP3R2Ship): Boolean;   
  end;

  TShipGroupInfoCacheList = class
  private
    List: TObjectList;
    procedure prepare();
  public
//    Ready: Boolean;

    Trader: Byte;


    constructor Create();
    destructor Destroy; override;

    procedure reset();

//    function  getCount(): Integer;
//    function  get(index: integer): TShipGroupInfoCache;

    function  findByFirstShip(p: PP3R2Ship): TShipGroupInfoCache;

//    function  getList(): Integer;

    function  shipLoadingChanged(ship: PP3R2Ship): Boolean;
    function  shipCapacityChanged(ship: PP3R2Ship): Boolean;
    function  shipSeaManChanged(ship: PP3R2Ship): Boolean;
    function  shipWeaponChanged(ship: PP3R2Ship): Boolean;  
  end;

  //unknown record
  TBOImportRec = packed record
    Factor: LongWord;
    unknown: Word;
    ImportGoodsInternalID: Byte;
    CityCode: Byte;
    NextIndex: Word;
  end;

  PBOImportRec = ^TBOImportRec;

function getBOImportRec(boIndex: Word): PBOImportRec;



function  getShipGroupInfo(const aGroupIndex: Word): PShipGroupInfo;  
function  getShipGroupFirstShipIndex(aGroupIndex: Word): Word;
procedure getShipGroupShips(sg: PShipGroupInfo; shipList: TList);




//function  hasShipsInCity(const aPlayer: Byte; const city: Byte): Boolean;

//function  setShipDest(ship: PP3R2Ship; const destCityCode: Byte): Integer;

function  P6E2030(): Byte;

function  getCaptionInfo(const aCaptainIndex: Integer): PCaptainRec;

function  buildShip(
        a1: Integer;
        shipType: Integer;
        cityCode: Byte;
        traderID: Integer): Boolean;

function  getAllocatedCaptainCount(): Integer;
function  setCaptain(
        ship: PP3R2Ship;
        aCaptain: Word;
        aAge: byte;
        const expSailing, expTrade, expFight: byte;
        const aSalary: Word): Boolean;

function  setShipDest(ship: PP3R2Ship; const destCityCode: Integer): Integer;
function  playerHasBOIn(city: byte): Boolean;
function  getHouseName(grade: Byte): WideString;

const
  PYIDX_TO_GOODSID: array[MIN_GOODS_ID..MAX_GOODS_ID] of Integer = (
    GOODSID__CLOTH,
    GOODSID__RICE,
    GOODSID__HONEY,
    GOODSID__WHALE_OIL,

    GOODSID__ASPHALT,
    GOODSID__HEMP,
    GOODSID__WOOD,
    GOODSID__BEER,

    GOODSID__LEATHER,
    GOODSID__WINE,
    GOODSID__MEAT,
    GOODSID__IRON,

    GOODSID__ANIMAL_SKIN,
    GOODSID__POTTERY,
    GOODSID__TOOLS,
    GOODSID__SPICE,

    GOODSID__SALT,
    GOODSID__WOOL,
    GOODSID__FISH,
    GOODSID__BRICK
  );

function  getGeneralGoodsProdCost(gid: integer): Integer;

//procedure sendMsgToScreen(const s: string);

function  getCityWeaponName(idx: integer): WideString;
function  formatCityWeaponQty(weigh: integer): string;
function  getCityShipWeaponName(idx: integer): WideString;
function  getCityShipWeaponWeighFactor(idx: integer): Integer;
function  formatCityShipWeaponQty(idx, weigh: integer): string;

function  getSwordName(): WideString;


type
  TCelebrationGoods = record
    rice, meat, fish, wine, beer, honey: integer;

    procedure get(city: integer);
  end;

function  getDockyardExpRequirement(shipType, lvl: integer): Integer;

function  getBuildingTypeName(bt: byte): WideString;

function  getBOListPtr(): Pointer;
function  getBOByIndex(index: Word): PBusinessOffice;

//return $FFFF for no free captain
function  getFreeCaptain(cityPtr: PCityStruct): Word;

function  formatCaptainAbility(cap: PCaptainRec): WideString;
//function  getBOManagerCount(): Integer;

var
  StdStoreHouseCapacity: integer = 200;

implementation

uses AxGameHackToolBox, MyGameTools, JclWideStrings, p3insight_utils, Math;




type
  TDaysRec = record
    days: Integer;
//    month: Integer;
  end;

var
  DaysRecList: array[1..12] of TDaysRec;

function  relocate(rawOffset: Integer): pointer;
begin
  Result := pointer(rawOffset + integer(P3ModuleHandle));
end;

procedure initDaysRecList();
var
  I: Integer;
  cnt, delta: Integer;
begin
  cnt := 0;

  for I := 1 to 12 do
  begin
    case I of
      1, 3, 5, 7, 8, 10, 12:
        delta := 31;

      2: delta := 28;
    else
      delta := 30;
    end;

    DaysRecList[I].days := cnt;
    Inc(cnt, delta);
  end;
end;

procedure getMonthDay(aDays: Integer; out m, d: Integer);
var
  I: Integer;
begin
  if aDays >= daysRecList[7].days then
  begin
    for I := 12 downto 7 do
    begin
      if aDays >= daysRecList[I].days then
      begin
        m := i;
        d := aDays - daysRecList[I].days + 1;
        exit;
      end;
    end;
  end
  else
  begin
    for I := 6 downto 1 do
    begin
      if aDays >= daysRecList[I].days then
      begin
        m := i;
        d := aDays - daysRecList[I].days + 1;
        exit;
      end;
    end;
  end;
end;


function  PYIndexToGoodsID(goodsPYIndex: integer): Integer;
begin
  Result := PYIDX_TO_GOODSID[goodsPYIndex];
end;

procedure AxExtractStringByDelimiter(
        const aStr: string;         { 给定字符串 }
        const aDelimiter: Char;     { 分界符 }
        const aAddEmptyField: Boolean; { 是否把空字符串也添加到字符串列表中 }
        aResultStrList: TStrings    { 返回的子字符串列表 }
      );
var
  P, I, L: Integer;
  S: string;
begin
  if aStr <> '' then
  begin
    P := 1;
    L := Length(aStr);
    for I := 1 to L do
    begin
      if aStr[I] = aDelimiter then
      begin
        if ByteType(aStr, I) = mbSingleByte then
        begin
          if I > P then
          begin
            S := Copy(aStr, P, I-P);
            aResultStrList.Add(S);
          end
          else
            if aAddEmptyField then
              aResultStrList.Add('');

          P := I + 1;
        end;
      end;
    end;
    if P = 1 then
      aResultStrList.Add(aStr)
    else if (L >= P)
    or (
          (aStr[L] = aDelimiter)
          and
          (ByteType(aStr, L) = mbSingleByte)
    ) then
    begin
      S := Copy(aStr, P, L-P+1);
      if S <> '' then
        aResultStrList.Add(S)
      else if aAddEmptyField then
        aResultStrList.Add('');
    end;
  end;
end;
   

function  ptrAdd(p: Pointer; const aDelta: Integer): Pointer;
begin
  Result := pointer(Integer(p) + aDelta);
end;

function  ptrAddI(p: integer; const aDelta: Integer): pointer;
begin
  Result := pointer(p + aDelta);
end;

function  byteToHexStr(const b: Byte; const aDollarPrefix: Boolean): string;
begin
  Result := IntToHex(b, 2);
  if aDollarPrefix then
    Result := '$' + Result;
end;

function  ptrDelta(pOrg, pOfs: Pointer): Integer;
begin
  Result := integer(pOfs) - integer(pOrg);
end;

function  wordToHexStr(const w: Word; const aDollarPrefix: Boolean = true): string;
begin
  Result := IntToHex(w, 4);
  if aDollarPrefix then
    Result := '$' + Result;
end;

function  longwordToHexStr(const lw: Longword; const aDollarPrefix: Boolean): string;
begin
  Result := IntToHex(lw, 8);
  if aDollarPrefix then
    Result := '$' + Result;
end;

function  ptrToHexStr(const p: Pointer; const aDollarPrefix: Boolean = true): string;
begin
  Result := longwordToHexStr(cardinal(p), aDollarPrefix);
end;



//var
////  I: Integer;
//  p: PByteArray;
////  cnt: Integer;
//begin
////  p := Pointer($71CDA8 + $10);
////  cnt := p^;
////
//  p := Pointer($71CDA8 + $18);
//  Result := p[aCityCode];
////  for I := 0 to cnt - 1 do
////  begin
////    if p^ = aCityCode then
////
////  end;
//end;

function  getCityCount(): Integer;
var
  pb: PByte;
begin
  pb := relocate(P3_GAME_DATA_OFFSET + $10);
  Result := pb^;
end;


function  getCityMapTablePtr(): PByteArray;
begin
  Result := relocate(P3_GAME_DATA_OFFSET + $18);
end;

function  cityCodeToInternalCode(cityCode: integer): Integer;
var
  pb: PByteArray;
begin
  pb := getCityMapTablePtr();
  Result := pb[cityCode];
end;

function  getCityShipWeaponName(idx: integer): WideString;
begin
  case idx of
    SHIP_WEAPON_1: Result := '小投';
    SHIP_WEAPON_2: Result := '小弩';
    SHIP_WEAPON_3: Result := '大投';
    SHIP_WEAPON_4: Result := '大弩';
    SHIP_WEAPON_5: Result := '铁炮';
    SHIP_WEAPON_6: Result := '加农';
  else
    Result := '?';
  end;
end;

function  getCityShipWeaponWeighFactor(idx: integer): Integer;
begin
  case idx of
    SHIP_WEAPON_1: Result := SHIP_WEAPON_WEIGHT_FACTOR_1;
    SHIP_WEAPON_2: Result := SHIP_WEAPON_WEIGHT_FACTOR_2;
    SHIP_WEAPON_3: Result := SHIP_WEAPON_WEIGHT_FACTOR_3;
    SHIP_WEAPON_4: Result := SHIP_WEAPON_WEIGHT_FACTOR_4;
    SHIP_WEAPON_5: Result := SHIP_WEAPON_WEIGHT_FACTOR_5;
    SHIP_WEAPON_6: Result := SHIP_WEAPON_WEIGHT_FACTOR_6;
  else
    raise Exception.Create('getCityShipWeaponWeighFactor: Invalid argument, idx=' + IntToStr(idx));
  end;
end;

function  formatCityShipWeaponQty(idx, weigh: integer): string;
var
  f: integer;
begin
  f := getCityShipWeaponWeighFactor(idx);
  Result := FormatFloat('0.0', weigh / f);  
end;


{
  as same as cityCodeToInternalCode
}
function  getOriginalCityID(aCityCode: Byte): Byte;
var
  pb: PByteArray;
begin
  pb := getCityMapTablePtr();
  Result := pb[aCityCode];
end;

function  internalCityIDToCityCode(const aInternalCode: Byte): Byte;
var
  pb: PByte;
  i, cc: byte;
  p: PByteArray;
begin
  pb := Pointer($71CDA8 + $10);
  cc := pb^;

  p := Pointer($71CDA8 + $18);

  for I := 0 to cc - 1 do
  begin
    if p[i] = aInternalCode then
    begin
      Result := i;
      exit;
    end;
  end;

  Result := $FF;
end;


function FileExistsWide(const aFileName: WideString): Boolean;
var
  Code: Integer;
begin
  Code := GetFileAttributesW(PWideChar(aFileName));
  Result := (Code <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code = 0);
end;



function  ptrToStr(p: Pointer; const incDollar: Boolean = true): string;
begin
  Result := '$' + IntToHex(integer(p), 8);
end;


function  isValidUpload(const aUpload: Cardinal): Boolean;
begin
//  Result := True;
  Result := (aUpload >= MIN_UPLOAD) and (aUpload <= FAV_LOAD);
  if Result then
  begin
    Result := aUpload mod 200 = 0;
  end;
end;

function  isValidShipName(sn: string): Boolean;
var
  l: integer;
begin
  l := Length(sn);
  Result := (l > 0) and (l <= MAX_SHIP_NAME_LENGTH);
end;

//function  isValidQty(const q: Cardinal): Boolean;
//begin
//  Result := True;
////  Result := q mod 200 = 0;
//end;

function  isValidShipType(const typ: Byte): Boolean;
begin
  Result := (typ <= SHIP_TYPE__HUOERKE);
end;

function  getShipTypeText(const typ: Byte): WideString;
begin
  case typ of
    SHIP_TYPE__SHINAIKE: Result := '史奈卡';
    SHIP_TYPE__KELEIER: Result := '克雷尔';
    SHIP_TYPE__KEGE: Result := '克格';
    SHIP_TYPE__HUOERKE: Result := '霍尔克';
  else
    Result := '?';
  end;
end;

function  isValidShipUgLvl(const lvl: Byte): Boolean;
begin
  Result := (lvl <= 2);
end;

function  getShipLvlText(const lvl: Byte): WideString;
begin
  case lvl of
    0: Result := '(L1)';
    1: Result := '(L2)';
    2: Result := '(L3)';
  end;
end;

const
  P3__6DFC7A = $6DFC7A - P3_MODULE_BASE;


function  getAllocatedCaptainCount(): Integer;
var
  pw: PWORD;
begin
  pw := relocate(P3__6DFC7A);
  Result := pw^;
end;

function  isValidCaptain(const captain: Word): Boolean;
begin
  if captain = $ffff then
    Result := True
  else
  begin
    Result := (captain < getAllocatedCaptainCount());
  end;
end;

function  isValidCannon(const aCannon: Byte): Boolean;
begin
  Result := (aCannon = CANNON__STUB) or (aCannon <= CANNON__NONE);
end;


procedure clearMemList(aList: TList);
var
  I: Integer;
  P: Pointer;
begin
  for I := 0 to aList.Count - 1 do
  begin
    P := aList[I];
    FreeMem(P);
  end;

  aList.Clear();
end;

procedure freeMemList(aList: TList);
begin
  if aList <> nil then
  begin
    clearMemList(aList);
    aList.Destroy();
  end;
end;

function  isValidCity(city: Byte): Boolean;
var
  pb: PByte;
begin
  Result := (city = $ff);

  if not Result then
  begin
    pb := pointer($71CDA8 + $10);
    Result := city < pb^;
  end;
end;

function  isValidShipPtr_R2(ship: PP3R2Ship): Boolean;
var
  I: Integer;
  cannon: byte;
  nilFound: Boolean;
begin
  Result := False;
  nilFound := False;

  try
    for I := 1 to 18 do
    begin
      if ship^.ShipName[I] = #0 then
      begin
        nilFound := True;
        Break;
      end;
    end;

    if not nilFound then
    begin
      OutputDebugString('TEST: nil not found');
      Exit;
    end;

    if not isValidShipType(ship^.ShipType) then
    begin
      OutputDebugString('TEST: invaid ship type');
      Exit;
    end;

    if not isValidShipUgLvl(ship^.ShipUgLvl) then
    begin
      OutputDebugString('TEST: invalid ShipUgLvl.');
      Exit;
    end;

    if not isValidCity(ship^.From) or not isValidCity(ship^.Curr) or not isValidCity(ship^.Dest) then
    begin
      OutputDebugString('TEST: invalid place');
      Exit;
    end;

    if ship^.MaxPoint < 42000 then
    begin
      OutputDebugString(pchar('TEST: max point < 42000, ' + IntToStr(ship^.MaxPoint)));
      Exit;
    end;

    if ship^.CurrPoint = 0 then
    begin
      OutputDebugString('TEST: curr point = 0');
      Exit;
    end;

    if ship^.CurrPoint > ship^.MaxPoint then
    begin
      OutputDebugString(pchar('TEST: current point > max point'));
      Exit;
    end;

    if ship^.MaxPoint > FAV_SHIP_POINT then
    begin
      OutputDebugString(pchar('TEST: max point > ' + inttostr(FAV_SHIP_POINT) + '=' + IntToStr(ship^.MaxPoint)));
      Exit;
    end;

    if not isValidUpload(ship^.LoadUpLimit) then
    begin
      OutputDebugString(pchar('TEST: invalid load up limit - ' + inttostr(ship^.LoadUpLimit)));
      EXIT;
    end;

    if not isValidCaptain(ship^.Captain) then
    begin
      OutputDebugString('TEST: invalid captain');
      Exit;
    end;

//    for I := 1 to 20 do
//    begin
//      if not isValidQty(ship^.Goods[i]) then
//      begin
//        OutputDebugString('TEST: Invalid goods qty');
//        Exit;
//      end;
//    end;

    for I := 1 to 24 do
    begin
      cannon := ship^.Carnons[I];
      if not isValidCannon(cannon) then
      begin
        OutputDebugString(pchar('TEST: invalid cannon: ' + IntToStr(cannon)));
        Exit;
      end;
    end;
  except
    OutputDebugString('TEST: Access exception');
    Exit;
  end;

  Result := True;
end;

function  testShip_R2(minP: Pointer; p: Pointer): Pointer;
var
  ship: PP3R2Ship;
begin
  Result := nil;
  if Integer(p) - Integer(minP) < SHIP_NAME_OFFSET_R2 then
    Exit;

  ship := pointer(integer(p) - SHIP_NAME_OFFSET_R2);

  if isValidShipPtr_R2(ship) then
    Result := ship;
end;

function  getShipTypeAndLvlText_R2(ship: PP3R2Ship): WideString;
begin
  Result := getShipTypeText(ship^.ShipType) + getShipLvlText(ship^.ShipUgLvl);
end;

//procedure dbgShipContent(ship: PP3Ship);
//var
//  idx: Integer;
//
//  procedure p(const S: WideString);
//  begin
//    OutputDebugStringW(PWideChar(S));
//  end;
//
//  procedure b(const S: WideString; const b: Byte);
//  begin
//    p(S + IntToHex(b, 2));
//  end;
//
//  procedure i(const S: WideString; i: Integer);
//  begin
//    p(S + IntToStr(i));
//  end;
//
//  procedure h(const S: WideString; c: cardinal);
//  begin
//    p(S + IntToHex(c, 8));
//  end;
//
//  procedure hw(const S: WideString; w: Word);
//  begin
//    p(S + IntToHex(w, 4));
//  end;
//
//  procedure goods(const Name: WideString; const pkg: Boolean = false);
//  var
//    u: WideString;
//    q: Integer;
//  begin
//    q := ship^.goods[idx];
//    
//    if pkg then
//    begin
//      u := '包';
//      q := q div 2000;
//    end
//    else
//    begin
//      u := '桶';
//      q := q div 200;
//    end;
//    
//    p(Name + '=' + IntToStr(q) + u);
//    Inc(idx);
//  end;
//
//  procedure cannons();
//  var
//    I: Integer;
//    s: string;
//  begin
//    S := '';
//    for I := 1 to 24 do
//    begin
//      S := S + IntToHex(ship^.Carnons[I], 2) + ' ';
//    end;
//
//    p('Cannons=' + s);
//  end;
//
//begin
//  if isValidShipType(ship^.ShipType) then
//  begin
//    p('ShipType=' + getShipTypeText(ship^.ShipType));
//  end
//  else
//    b('ShipType=', ship^.ShipType);
//
//  if isValidShipLvl(ship^.ShipLevel) then
//  begin
//    p('ShipLevel=' + getShipLvlText(ship^.ShipLevel));
//  end
//  else
//    b('ShipLevel=', ship^.ShipLevel);
//
//
//  p('Loadup=' + IntToStr(ship^.LoadUpLimit));
//  p('maxPoint=' + IntToStr(ship^.MaxPoint));
//  p('currPoint=' + IntToStr(ship^.CurrPoint));
//
//  b('from=', ship^.From);
//  b('curr=', ship^.Curr);
//  b('dest=', ship^.Dest);
//
//  i('Seaman=', ship^.Seaman);
//  hw('captain=', ship^.Captain);
//
//  idx := 1;
//  goods('谷子', true);
//  goods('肉类', true);
//  goods('鱼类', true);
//  goods('啤酒');
//  goods('盐巴');
//
//  goods('蜂蜜');
//  goods('香料');
//  goods('红酒');
//  goods('布料');
//  goods('兽皮');
//
//  goods('鲸油');
//  goods('木料', true);
//  goods('铁器');
//  goods('皮革');
//  goods('羊毛', true);
//
//  goods('沥青');
//  goods('生铁', true);
//  goods('麻类', true);
//  goods('瓷器');
//  goods('砖头', true);
//
//
//  i('宝剑', ship^.CityWeapons[1]);
//  i('弓', ship^.CityWeapons[2]);
//  i('十字弓', ship^.CityWeapons[3]);
//  i('卡宾枪', ship^.CityWeapons[4]);
//
//  b('State=', ship^.State);
//  i('船只武器', ship^.ShipWeapon);
//
//  cannons();
//end;



function  getCurrTS(): Cardinal;
var
  pw: PLongWord;
begin
  pw := Pointer($71CDA8 + $14);
  Result := pw^;
end;



function  getGoodsName(const aGoodsID: Integer): WideString;
begin
  case aGoodsID of
    1: Result := '稻谷';
    2: Result := '肉类';
    3: Result := '鱼类';
    4: Result := '啤酒';
    5: Result := '盐巴';

    6: Result := '蜂蜜';
    7: Result := '香料';
    8: Result := '红酒';
    9: Result := '布料';
    10: Result := '兽皮';

    11: Result := '鲸油';
    12: Result := '木料';
    13: Result := '铁器';
    14: Result := '皮革';
    15: Result := '羊毛';

    16: Result := '沥青';
    17: Result := '生铁';
    18: Result := '麻类';
    19: Result := '瓷器';
    20: Result := '砖头';
  else
    Result := '?';
  end;
end;

function  isGoodsMeasuredInPkg(const aGoodsID: Integer): Boolean;
begin
  case aGoodsID of
    1,2,3,12,15,17,18,20: Result := True;
  else
    Result := False;
  end;
end;

var
  GOODS_QTY_FACTORS: array[MIN_GOODS_ID..MAX_GOODS_ID] of integer;

procedure initGOODS_QTY_FACTORS();
var
  i, q: integer;
begin
  for i := MIN_GOODS_ID to MAX_GOODS_ID do
  begin
    if isGoodsMeasuredInPkg(i) then
      q := UNIT_PKG
    else
      q := UNIT_TONG;
      
    GOODS_QTY_FACTORS[i] := q;
  end;
end;

function  getGoodsQtyFactor(goodsID: integer): Integer;
begin
  Result := GOODS_QTY_FACTORS[goodsID];
end;

function  getGoodsUnit(const aGoodsID: Integer): WideString;
begin
  if isGoodsMeasuredInPkg(aGoodsID) then
    Result := '包'
  else
    Result := '桶';
end;

function  getShipName_R2(ship: PP3R2Ship): string;
var
  l: Integer;
begin
  l := StrLen(@ship^.ShipName[1]);
  SetLength(Result, l);
  Move(ship^.ShipName[1], Result[1], l);
end;

function  setShipName(ship: PP3R2Ship; const shipName: string): Boolean;
var
  l: integer;
begin
  Result := False;

  if not isValidShipName(shipName) then
    exit;

  l := Length(shipName);
  Move(shipName[1], ship^.shipName[1], l+1); //include null char
  Result := True;
end;

const
  BYTE_UNKNOWN = $00;
  BYTE_RED = $01;
  BYTE_BLUE = $02;

  WORD_UNKNOWN = $0000;
  WORD_RED = $0101;
  WORD_BLUE = $0202;

  LONGWORD_UNKNOWN = $00000000;
  LONGWORD_RED = $01010101;
  LONGWORD_BLUE = $02020202;


var
  shipColorMap: TP3R2Ship;

procedure initShipColorTable();
var
  Red: Boolean;
//  b: Byte;
//  I: Integer;

  function  getByte(): Byte;
  begin
    if Red then
      Result := BYTE_RED
    else
      Result := BYTE_BLUE;

    Red := not Red;
  end;

  function  getWord(): Word;
  begin
    if Red then
      Result := WORD_RED
    else
      Result := WORD_BLUE;

    Red := not Red;
  end;

  function  getLongword(): LongWord;
  begin
    if Red then
      Result := LONGWORD_RED
    else
      Result := LONGWORD_BLUE;

    Red := not Red;
  end;

  procedure fillUnknown(var x; len: Integer);
  begin
    FillChar(x, len, 0);
  end;

  procedure fill(var x; len: Integer);
  var
    b: Byte;
  begin
    b := getByte();
    FillChar(x, len, b);
  end;

begin
  Red := True;

  shipColorMap.Owner := getByte();
  shipColorMap.Heading := getByte();

  shipColorMap.NextShipIndex := getWord();
  shipColorMap.UnknownIndex := getWord();
  shipColorMap.GroupIndex := getWord();

  fillUnknown(shipColorMap.Stub0, Sizeof(shipColorMap.Stub0));

  shipColorMap.ShipType := getByte();
  shipColorMap.ShipUgLvl := getByte();

  shipColorMap.LoadUpLimit := getLongword();
  shipColorMap.MaxPoint := getLongword();
  shipColorMap.CurrPoint := getLongword();

  shipColorMap.PosX := getWord();
  shipColorMap.PosY := getWord();

  fillUnknown(shipColorMap.Stub1, SizeOf(shipColorMap.Stub1));
  fillUnknown(shipColorMap.Stub2, SizeOf(shipColorMap.Stub2));

  shipColorMap.From := getByte();
  shipColorMap.Dest := getByte();
  shipColorMap.Curr := getByte();

  shipColorMap.UnknownWord := getWord();

  fillUnknown(shipColorMap.Stub3, SizeOf(shipColorMap.Stub3));

  shipColorMap.ShiQi := getWord();
  shipColorMap.Seaman := getWord();
  shipColorMap.Captain := getWord();

  shipColorMap.ReachNextPointTS := getLongword();
  shipColorMap.ReachDestTS := getLongword();
  shipColorMap.StartSailTS := getLongword();

  fillUnknown(shipColorMap.Stub4, SizeOf(shipColorMap.Stub4));

  fill(shipColorMap.Goods[1], 20 * SizeOf(LongWord));
//  for I := 1 to 20 do
//  begin
//    shipColorMap.Goods[I] := getLongword();
//  end;

  fill(shipColorMap.CityWeapons[1], 4 * SizeOf(Longword));




//  for I := 1 to 4 do
//  begin
//    shipColorMap.CityWeapons[I] := getLongword();
//  end;

  fillUnknown(shipColorMap.Stub5, SizeOf(shipColorMap.Stub5));

  shipColorMap.GoodsLoad := getLongword();

  shipColorMap.WeaponLoad := getLongword(); 

  shipColorMap.Power := getWord();

  fillUnknown(shipColorMap.Stub5_2, sizeof(shipColorMap.Stub5_2));

  shipColorMap.TradingIndex := getWord();

  shipColorMap.State := getByte();

  shipColorMap.Stub5_3 := 0;

  shipColorMap.IsTrading := getByte();

  fillUnknown(shipColorMap.Stub6, sizeof(shipColorMap.Stub6));

  fill(shipColorMap.Carnons[1], 24);
//  for I := 1 to 24 do
//  begin
//    shipColorMap.Carnons[I] := getByte();
//  end;

  shipColorMap.Sword := getWord();

  fillUnknown(shipColorMap.Stub7, sizeof(shipColorMap.Stub7));

  fill(shipColorMap.ShipName[1], 18);
//  for I := 1 to 18 do
//  begin
//    shipColorMap.ShipName[I] := Chr(getByte());
//  end;

  fillUnknown(shipColorMap.Stub8, sizeof(shipColorMap.Stub8));
//
//    ShipName: array[1..18] of Char; //#0 terminated       //252
//    Stub8: array[1..28] of Byte;            //280 + 96 + 8 = 384
end;

function  getOffsetColor(const aOffset: Integer): TColor;
var
  b: Byte;
  p: PByte;
begin
  p := @shipColorMap;
  Inc(p, aOffset);
  b := p^;

  case b of
    1: Result := COLOR_RED;
    2: Result := COLOR_BLUE;
  else
    Result := COLOR_UNKNOWN;
  end;
end;


const
  hks__ctrl = 'ctrl';
  hks__alt = 'alt';
  hks__win = 'win';
  hks__shift = 'shift';
  hks__scroll_lock = 'scroll_lock';
  hks__break = 'break';


var
  HotkeyList: THotKeyList;

procedure InitHotkeyList();
var
  I: Integer;
  c: char;
begin
  HotkeyList := THotKeyList.Create();
  HotkeyList.addMod(hks__ctrl, MOD_CONTROL);
  HotkeyList.addMod(hks__alt, MOD_ALT);
  HotkeyList.addMod(hks__win, MOD_WIN);
  HotkeyList.addMod(hks__shift, MOD_SHIFT);
  HotkeyList.addKey(hks__scroll_lock, VK_SCROLL);
  HotkeyList.addKey(hks__break, VK_PAUSE);

  for I := 1 to 12 do
    HotkeyList.addKey('f' + IntToStr(I), VK_F1 + (I-1));

  for c := 'a' to 'z' do
    HotkeyList.addKey(c, Ord(UpCase(c)));

  for c := '0' to '9' do
    HotkeyList.addKey(c, Ord(c));


  for I := 0 to 9 do
    HotkeyList.addKey('num' + IntToStr(I), VK_NUMPAD0 + I);
end;

{ THotKeyList }

procedure THotKeyList.add(text: string; aModifier, aKey: Word);
var
  obj: TMyHotKey;
begin
  obj := TMyHotKey.Create();
  obj.Modifier := aModifier;
  obj.VKey := aKey;
  fList.AddObject(text, obj);
end;

procedure THotKeyList.addKey(const text: string; aKey: word);
begin
  add(text, 0, aKey);
end;

procedure THotKeyList.addMod(const text: string; aModifier: word);
begin
  add(text, aModifier, 0);
end;

constructor THotKeyList.Create;
begin
  fList := THashedStringList.Create();
  fList.CaseSensitive := True;
end;

destructor THotKeyList.Destroy;
var
  I: Integer;
begin
  if fList <> nil then
  begin
    for I := 0 to fList.Count - 1 do
        fList.Objects[I].Free();

    FreeAndNil(fList);
  end;

  inherited;
end;

function THotKeyList.getHotkey(text: string): TMyHotKey;
var
  idx: Integer;
begin
  idx := fList.IndexOf(text);
  if idx >= 0 then
    Result := TMyHotKey(fList.Objects[Idx])
  else
    Result := nil;
end;

function  pHotkey(const S: string; var aModifier, aKey: Word): Boolean;
var
  hk: TMyHotKey;
begin
  hk := HotkeyList.getHotkey(LowerCase(S));

  Result := hk <> nil;
  if Result then
  begin
    aModifier := aModifier or hk.Modifier;
    aKey := hk.VKey;
  end;
end;

procedure extraValue(var line, resultStr: string; const seperator: char = ';');
var
  p: Integer;
begin
  p := Pos(seperator, line);

  if p = 0 then
  begin
    resultStr := line;
    line := '';
  end
  else
  begin
    resultStr := Copy(line, 1, p-1);
    line := Copy(line, p+1, Length(line)-p);
  end;
end;

function  ParseHotKey(value: string; var aModifier, aKey: Word): Boolean;
var
  temp: Word;
  valueCopy, keyS: string;
begin
  Result := False;
  aModifier := 0;
  aKey := 0;
  value := Trim(value);
  valueCopy := value;

  while value <> '' do
  begin
    extraValue(value, keyS, '+');
    if not pHotkey(keyS, aModifier, temp) then
    begin
      OutputDebugString(pchar('The hot key element was not recognized: ' + valueCopy));
      Exit;
    end;

    if temp <> 0 then
      aKey := temp;
  end;

  Result := True;

////    if (Key = 0) then
////      raise Exception.Create('The hot key is not recognized: ' + valueCopy);
//
//  Hotkeys[index].Modifier := Modifier;
//  Hotkeys[index].VKey := Key;
end;


procedure initVars();
var
  bool: Boolean;
  i: Integer;
  s: string;
  fn: WideString;
  sL: TStringList;

//  procedure loadCityCodes(const aFN: WideString);
//  var
//    I, iValue: Integer;
//    n, v: string;
//    sl2: TStringList;
//    entry: TCityCodeEntry;
//  begin
//    sl2 := TStringList.Create();
//    try
//      sl2.LoadFromFile(aFN);
//
//      for I := 0 to sl2.Count - 1 do
//      begin
//        n := sL2.Names[I];
////        OutputDebugString(pchar('name=' + n));
//        if TryStrToInt(n, iValue) and (iValue <> $FF) and (isValidCity(iValue)) then
//        begin
//          v := sL2.ValueFromIndex[I];
//          if v <> '' then
//          begin
////            OutputDebugString(pchar('City:' + v));
//            entry := TCityCodeEntry.Create();
//            entry.CityName := v;
//            CityCodeEntries[iValue] := entry;
//          end;
//        end;
//      end;
//    finally
//      sl2.Destroy();
//    end;
//  end;

//  modifier, key: word;
begin
  FAV_START_ADDR := cardinal(SysInfo.lpMinimumApplicationAddress);
  FAV_END_ADDR := cardinal(SysInfo.lpMaximumApplicationAddress);
  HK__MODIFIER := 0;
  HK__KEY := 0;

  FN := ExtractFilePath(ParamStr(0)) + 'p3edit.cfg';
  sL := TStringList.Create();
  try
    if not FileExists(fn) then
      Exit;

    sL.LoadFromFile(FN);

    s := sL.Values['P3ED_HOTKEY'];
    if s <> '' then
    begin
//      OutputDebugString(pchar('value=' + s));
      if not ParseHotkey(s, HK__MODIFIER, HK__KEY) then
      begin
//        OutputDebugString('parse failed');
        HK__MODIFIER := MOD_CONTROL or MOD_ALT;
        HK__KEY := VK_F1;
      end;
    end
    else
    begin
      HK__MODIFIER := MOD_CONTROL or MOD_ALT;
      HK__KEY := VK_F1;
    end;

    s := sL.Values['P3ED_SHIP_NAME_PREFIX'];
    if s <> '' then
    begin
      if Length(s) <= MAX_SHIP_NAME_LENGTH then
        SHIP_NAME_PREFIX := s;
    end;

    s := sL.Values['P3ED_R2'];
    if s <> '' then
    begin
      if TryStrToBool(s, bool) then
        USE_FORM2 := bool;
    end;


    s := sL.Values['P3ED_CAPTAIN'];
    if (s <> '') and (TryStrToInt(s, i)) then
      FAV_CAPTAIN := i;

    S := sL.Values['P3ED_MAX_LOAD'];
    if (s <> '') and (TryStrToInt(s, i)) then
      FAV_LOAD := i;

    s := sL.Values['P3ED_MAX_POINT'];
    if (s <> '') and (TryStrToInt(s, i)) then
      FAV_SHIP_POINT := i;

    s := sL.Values['P3ED_GOODS_QTY'];
    if (s <> '') and (TryStrToInt(s, i)) then
      FAV_QTY := i;

    s := sL.Values['P3ED_ADDR_START'];
    if (s <> '') and (TryStrToInt(s, i)) then
      FAV_START_ADDR := i;
      
    s := sL.Values['P3ED_ADDR_END'];
    if (s <> '') and (TryStrToInt(s, i)) then
      FAV_END_ADDR := i;

//    s := sL.Values['P3ED_CITY_CODE_FILE'];
//    if s <> '' then
//    begin
//      if ExtractFilePath(s) = '' then
//        s := ExtractFilePath(ParamStr(0)) + s;
//
////      OutputDebugString(pchar('filename=' + s));
//
//      if FileExists(s) then
//      begin
//        try
//          loadCityCodes(s);
//        except
//        end;
//      end
//      else
//        OutputDebugString(pchar('File not exists: ' + s));
//    end;
//    else
//      OutputDebugString('city code file not defined.');

  finally
    sL.Destroy();
  end;
end;

procedure p3setShipName_R2(ship: PP3R2Ship; const aName: string);
var
  l: Integer;
begin
//  OutputDebugString(pchar('newshipname=' + aName));
  l := Length(aName);
  if l = 0 then
    Exit;

  if l > MAX_SHIP_NAME_LENGTH then
    l := MAX_SHIP_NAME_LENGTH;

  Move(aName[1], ship^.ShipName[1], l);
  ship^.ShipName[l+1] := #0;
//  OutputDebugString(pchar('changed-shipname=' + getShipName(ship)));
end;

function  getCityName2(const aCityCode: Byte): WideString;
var
  pp: PPointer;
  pc: Pchar;
  s: string;
begin
//  try
  if aCityCode = $FF then
    s := '海上'
  else if isValidCity(aCityCode) then
  begin
    pp := Pointer($6e0080 + aCityCode * 4);
    pc := pp^;
    s := pc;
  end
  else
    s := '$' + IntToHex(aCityCode, 2);
//  except
//    Result := 'Error';
//    Exit;
//  end;


  Result := s;
end;

//function  getCityName(const aCityCode: Byte): WideString;
//var
//  orgID: Byte;
//begin
//  if isValidCity(aCityCode) then
//  begin
//    if aCityCode = $FF then
//      Result := '海上'
//    else
//    begin
//
//      orgID := getOriginalCityID(aCityCode);
//      Result := OrginalCityNames[orgID];
//    end;
//  end
//  else
//    Result := '$' + IntToHex(aCityCode, 2);
//end;

function  isPirateShip_R2(p: PP3R2Ship): Boolean;
begin
  Result := p^.Owner = $FF;
end;

function  getPageSizeText(const sz: Integer): WideString;
begin
  if (sz mod 1024) = 0 then
  begin
    Result := IntToStr(sz div 1024) + '(K)';
  end
  else
    Result := IntToStr(sz) + '(B)';
end;

function  getCityListPtr(): PCityList;
var
  p: PLongWord;
begin
  Result := pointer($71ce10);     //$71cda8 + $68
  p := Pointer(Ppointer(result)^);
  Dec(p);
  Result := pointer(p);
end;

function  getCityPtr(const aCityCode: Byte): PCityStruct;
var
//  off: Integer;
  list: PCityList;
begin
  list := getCityListPtr();
  Result := @(list^.Cities[aCityCode]);

//  off := (aCityCode * 5) * 64 - aCityCode;
//  off := integer(list) + 4 + off * 8;
//  if Result <> Pointer(off) then
//  begin
//    OutputDebugString(pchar('City ptr error, r=' + IntToHex(integer(result), 8) + ', o=' + IntToStr(off) + ', diff=' + IntToStr(integer(result) - integer(off))));
//  end;
end;

procedure p3DSSelfTest();

  procedure testSize(const structName: string; const sz, expected: integer);
  begin
    if sz <> expected then
      raise Exception.Create('Self test failed, structure ' + structName
          + ' expected size= ' + IntToStr(expected)
          + ', we got = ' + IntToStr(sz));
  end;
  
begin
  testSize('TP3R2Ship', sizeof(TP3R2Ship), 384);
  testSize('TCityStruct', sizeof(tcitystruct), CITY_STRUCT_SZ);
  testSize('TBusinessOffice', sizeof(tbusinessoffice), SIZE_OF_BUSINESS_OFFICE);
  testSize('TShipGroupInfo', sizeof(tshipGroupInfo), 15*4);
end;

function  isCityListAvailable(): Boolean;
var
  remainSz: Integer;
  ptr: pointer;
  mp: TMemPage;
begin
//  OutputDebugString('cityListavail->');
  Result := False;
  ptr := pointer($71ce10);
  mp := QueryMemPageEx(GetCurrentProcess(), ptr, True);
  if mp = nil then
  begin
    OutputDebugString('city list addr not readable');
    Exit;
  end;

  mp.Destroy();

  ptr := PPointer(ptr)^;
  mp := QueryMemPageEx(GetCurrentProcess(), ptr, True);
  if mp = nil then
  begin
    OutputDebugString('city list addr 2 not readable');
    Exit;
  end;

  remainSz := integer(mp.p) + integer(mp.Size) - integer(ptr);
  mp.Destroy();

  if remainSz < CITY_LIST_SZ then
  begin
    OutputDebugString(pchar('< city_list_sz, =' + inttostr(remainSz)));
    exit;
  end;

  Result := True;
//  OutputDebugString('<-cityListavail');
end;

//function  getHomeCity(cityList: PCityList): Byte;
//var
//  I: Integer;
//begin
//  if cityList = nil then
//  begin
//    cityList := getCityListPtr();
//    if cityList = nil then
//    begin
//      Result := 0;
//      Exit;
//    end;
//  end;
//
//  for I := 0 to cityList^.CityCount - 1 do
//  begin
//    if cityList^.Cities[I].IsHomeCity <> 0 then
//    begin
//      Result := I;
//      Exit;
//    end;
//  end;
//
//  Result := 0;
//end;

function  reCalcCityPopTotal(city: PCityStruct): Cardinal;
begin
  city.Pop_Total := city.Pop_rich + city.Pop_common + city.Pop_poor + city.Pop_begger;
  Result := city.Pop_Total;
end;

function  getProdAdv(aCity: PCityStruct; const aGoodsID: Integer): Currency;
var
  pb: PByte;
  pw: PWord;
  pd: PLongWord;
  delta: Integer;
  c: Currency;
  q: LongWord;
begin
  pb := pointer(aCity);

  if aGoodsID <> $0a then
  begin
    delta := (aGoodsID-1) shl 4;
    Inc(pb, delta + $848);
    pw := pointer(pb);
    q := pw^;
    if q = 0 then
      c := 0
    else if isGoodsMeasuredInPkg(aGoodsID) then
      c := q / UNIT_PKG
    else
      c := q / UNIT_TONG;
  end
  else
  begin
    Inc(pb, $2cc);
    pd := pointer(pb);
    q := pd^;
    if q = 0 then
      c := 0
    else
      c := q / UNIT_TONG;
  end;

  Result := c;
end;

function  GoodsIDToProdRateIndex(const aGoodsID: Integer): Integer;
var
  idx: Integer;
begin
  case aGoodsID-1 of
    0: idx := $09;
    1: idx := $0A;
    2: idx := $05;
    3: idx := $06;
    4: idx := $0D;
    5: idx := $08;
    7: idx := $10;
    8: idx := $0C;
    9: idx := $04;
    $0B: idx := $0B;
    $0C: idx := $07;
    $0D: idx := $0A;
    $0E: idx := $0F;
    $0F: idx := $13;
    $10: idx := $0E;
    $11: idx := $14;
    $12: idx := $11;
    $13: idx := $12;
  else
    raise Exception.Create('Unexpected error');
  end;

  Result := idx;
end;

function  GetCityOriginalProdRate(const aCity: PCityStruct; const aGoodsID: Integer): Word;
var
  idx: Integer;
begin
  if aGoodsID = GOODSID__WHALE_OIL then
  begin
    Result := aCity^.WhaleOilProdRate;
    Exit;
  end;

  if aGoodsID = GOODSID__SPICE then
  begin
    Result := 0;
    Exit;
  end;

  idx := GoodsIDToProdRateIndex(aGoodsID);
  Result := aCity^.OriginalProd[idx].Rate;
end;

//return 0 - 不产，1 - 低产，2 - 高产
function  getCityOriginalProdLvl(city: PCityStruct; goodsID: Integer): integer;
var
  cmp: integer;
begin
  Result := GetCityOriginalProdRate(city, goodsID);
  if Result = 0 then
    Result := PROD_LVL__NO_PROD
  else
  begin
    if goodsID = GOODSID__WHALE_OIL then
      cmp := $3E8
    else
      cmp := $384;

    if Result >= cmp then
      Result := PROD_LVL__HIGH_PROD
    else
      Result := PROD_LVL__LOW_PROD;
  end;
end;

function  calcSoldierTotal(aCity: PCityStruct; const aExcludeTraining: Boolean): Integer;
var
  i: Integer;
begin
  Result := 0;
  for I := 0 to 3 do
    Result := Result + aCity^.Soldiers[i];

  if not aExcludeTraining then
    for I := 0 to 3 do
      Result := Result + aCity^.TrainingSoldiers[i];
end;

function  getSoldierTypeName(const aSoldierIndex: Integer): WideString;
begin
  case aSoldierIndex of
    SOLDIER_TYPE_0: Result := '监察';
    SOLDIER_TYPE_1: Result := '弓兵';
    SOLDIER_TYPE_2: Result := '弩兵';
    SOLDIER_TYPE_3: Result := '步兵';
  else
    Result := '?';
  end;
end;

function  reCalcTotalAllowedSoldiers(aCity: PCityStruct): Integer;
var
  r: Integer;
begin
  r := calcSoldierTotal(aCity, False);
  Result := r div 10;
  if r mod 10 > 0 then
    Inc(Result);

  Result := Result * 10;

  if Result > 65530 then
    Result := 65530;

  aCity^.TotalAllowedSoldiers := Result;
end;

//procedure testGetHeap();
//var
//  h: THandle;
//  entry: TProcessHeapEntry;
//begin
//  h := GetProcessHeap();
//  if h = 0 then
//  begin
//    OutputDebugString('Get heap handle failed.');
//
//    exit;
//  end;
//
//  entry.lpData := nil;
//
//  while HeapWalk(h, entry) do
//  begin
//    if (entry.wFlags and PROCESS_HEAP_REGION) = PROCESS_HEAP_REGION then
//    begin
//      OutputDebugString(pchar('heap bloack Addr: ' + IntToHex(integer(entry.lpData), 8)));
//    end;
//  end;
//end;

procedure modP3StaticData(
        const aHouseCapacity: Boolean;
        const aShipCapacity: Boolean;
        const aShipSpeed: Boolean;
        const aFactoryWorkers: Boolean;
        const aResidentReq: Boolean;
        const aMoneyUpperLimit: Boolean);
var
//  s: string;
  ptr: PByte;
  pW: PWord;
  I, Sz: Integer;
  OldProt: DWORD;
  mi: TMemoryBasicInformation;
  Req: PItemRequirement;
  pi: PInteger;

  function markReadWrite(p: Pointer; sz: Integer; out aOldProt: DWORD): Boolean;
  begin
    if not Windows.VirtualProtect(p, sz, PAGE_EXECUTE_READWRITE, aOldProt) then
    begin
      Result := False;
      soundBeep();
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
      soundBeep();
      OutputDebugString(pchar('Write memory failed'));
      Exit;
    end;

    Result := True;
  end;
  
begin
  ptr := pointer(P3ModuleHandle);
  dbgPrintPtr('p3 module base addr', ptr);
  if VirtualQuery(ptr, mi, sizeof(mi)) = 0 then
  begin
    OutputDebugString('VirtualQuery failed');
    Exit;
  end;

  ptr := mi.BaseAddress;
  dbgPrintPtr('p3 module base addr2', ptr);
  inc(ptr, mi.RegionSize);

  if aHouseCapacity then
  begin
    inc(ptr, $282000);
    inc(ptr, $5EE8);
    pW := pointer(ptr);
    dbgPrintPtr('HouseCapacity', ptr);



    if not Windows.VirtualProtect(pW, 14, PAGE_EXECUTE_READWRITE, OldProt) then
    begin
      soundBeep();
      OutputDebugString('Write memory failed');
      Exit;
    end;

    for I := 0 to 3 - 1 do
    begin
      pW^ := pW^ * 10;
      Inc(pW);
    end;

    Inc(pW);

    for I := 0 to 3 - 1 do
    begin
      pW^ := pW^ * 10;
      Inc(pW);
    end;

    if not Windows.VirtualProtect(pW, 14, OldProt, OldProt) then
    begin
      soundBeep();
      OutputDebugString(pchar('Write memory failed'));
      Exit;
    end;
  end;


  
  if aShipSpeed then
  begin
    ptr := mi.BaseAddress;
    inc(ptr, mi.RegionSize);
  

    inc(ptr, $282000);
    inc(ptr, $AF74);

    dbgPrintPtr('ship-speed', ptr);

    Sz := 12;

    if not markReadWrite(ptr, Sz, OldProt) then
      Exit;

    pW := pointer(ptr);

    for I := 1 to Sz div 2 do
    begin
      pW^ := pW^ * 5;
      Inc(pW);
    end;
  
    if not undoProtected(ptr, Sz, OldProt) then
      Exit;
  end;



  if aShipCapacity then
  begin
    ptr := mi.BaseAddress;
    inc(ptr, mi.RegionSize);


    inc(ptr, $282000);
    inc(ptr, $F6C0);

    Sz := 16;

    dbgPrintPtr('ship-capacity', ptr);

    if not markReadWrite(ptr, Sz, OldProt) then
      Exit;

    for I := 1 to Sz do
    begin
      ptr^ := ptr^ * 2;
      Inc(ptr);
    end;

    if not undoProtected(ptr, Sz, OldProt) then
      Exit;
  end;

  if aFactoryWorkers then
  begin
    ptr := mi.BaseAddress;
    inc(ptr, mi.RegionSize);
  

    inc(ptr, $282000);
    inc(ptr, $5EA4);

    Sz := 17;

    dbgPrintPtr('factory-workers', ptr);

    if not markReadWrite(ptr, Sz, OldProt) then
      Exit;

    for I := 0 to 17 - 1 do
    begin
      ptr^ := ptr^ * 3;
      Inc(ptr);
    end;

    if not undoProtected(ptr, Sz, OldProt) then
      Exit;
  end;


  if aResidentReq then
  begin
    ptr := mi.BaseAddress;
    inc(ptr, RESIDENT_REQ_OFFSET);
    
    Sz := SizeOf(TItemRequirement);

    dbgPrintPtr('Resident-req', ptr);

    if not markReadWrite(ptr, Sz, OldProt) then
      Exit;

    Req := pointer(ptr);
    Req[5].FuHaoReqQty := Req[5].FuHaoReqQty * 2;
    Req[5].FuRenReqQty := Req[5].FuRenReqQty * 2;
    Req[5].QiongRenReqQty := Req[5].QiongRenReqQty * 2;

    Req[11].FuHaoReqQty := Req[11].FuHaoReqQty * 2;
    Req[11].FuRenReqQty := Req[11].FuRenReqQty * 2;
    Req[11].QiongRenReqQty := Req[11].QiongRenReqQty * 2;

    Req[12].FuHaoReqQty := Req[12].FuHaoReqQty * 2;
    Req[12].FuRenReqQty := Req[12].FuRenReqQty * 2;
    Req[12].QiongRenReqQty := Req[12].QiongRenReqQty * 2;

    if not undoProtected(ptr, Sz, OldProt) then
      Exit;
  end;

  exit;
  
  if aMoneyUpperLimit then
  begin
    ptr := mi.BaseAddress;
    inc(ptr, P3_MONEY_UPPER_LIMIT_OFFSET);

    Sz := SizeOf(Integer);

    dbgPrintPtr('Money upper limit', ptr);

    if not markReadWrite(ptr, Sz, OldProt) then
      Exit;

    pi := pointer(ptr);
    pi^ := 2000000000;

    if not undoProtected(ptr, Sz, OldProt) then
      Exit;   
  end;
end;


function  getPlayerPtr(const aPlayerID: Byte): Pointer;
var
  pp: PPointer;
  pb: PByte;
begin
  pp := Pointer($71CDA8 + $78);
  pb := pp^;
  Inc(pb, (aPlayerID * 5 * 5 * 4 + aPlayerID) * 16);
  Result := pb;
end;

function  getPlayerPtrOffset(const aPlayerID: Byte; const aOffset: Integer): Pointer;
var
  pb: PByte;
begin
  pb := getPlayerPtr(aPlayerID);
  Inc(pb, aOffset);
  Result := pb;
end;

function  getPlayerMoneyPtr(const aPlayerID: Byte): PInteger;
begin
  Result := Pointer(getPlayerPtr(aPlayerID));
//  result := Pointer($71CDA8 + $78);
//  Result := Pointer(result^ + (aPlayerID * 5 * 5 * 4 + aPlayerID) * 16);
end;

function  getPlayerMoney(const aPlayerID: Byte): Integer;
var
  pi: PInteger;
begin
  pi := getPlayerMoneyPtr(aPlayerID);
  Result := pi^;
end;

procedure setPlayerMoney(const aPlayerID: Byte; const aMoney: Integer);
var
  pi: PInteger;
begin
  pi := getPlayerMoneyPtr(aPlayerID);
  pi^ := aMoney;
end;

function  getGameDataPtr(): PGameData;
begin
  Result := pointer(P3ModuleHandle + P3_GAME_DATA_OFFSET);
end;

function  hourPartConvert(hourPart: Byte): Integer;
var
  f: Single;
begin
  f := hourPart;
  f := f * 24 / 256;
  result := trunc(f);
end;

function  getHourPart(ts: LongWord): Integer;
begin
//  OutputDebugString(pchar('hourPart = ' + byteToHexStr(ts and $FF) ));
  Result := hourPartConvert(ts and $FF);
//  OutputDebugString(pchar('hourPartRsult=' + IntToStr(Result)));
end;

function getGameDate(out aYear, aMonth, aDay: Integer): Integer;
var
  pb: PByte;
  f: single;
begin
  pb := Pointer($71CDA8);
  aDay := pb^;
  Inc(pb);
  aMonth := pb^ + 1;
  Inc(pb);
  aYear := pWord(pb)^;

  pb := Pointer($71CDA8 + $14);
  Result := hourPartConvert(pb^);
end;

function timestampToDate(aTS: Cardinal; out y, m, d: Integer): Integer;
var
  r: Integer;
  f: Single;
begin
  Result := aTS and $FF;
  aTS := aTS shr 8;
  y := aTS div 365;
  r := aTS mod 365;

  getMonthDay(r, m, d);

  Result := hourPartConvert(Result);
end;

function  dateToTimestamp(y, m, d: integer): Cardinal;
var
  I: Integer;
begin
  Result := y * 365;

  for I := 1 to m-1 do
  begin
    case i of
      1,3,5,7,8,10,12:
        Inc(Result, 31);
      4,6,9,11:
        Inc(Result, 30);
    else
      Inc(Result, 28);
    end;
  end;

  Inc(Result, d-1);
  Result := Result shl 8;
end;

function  timestampToDateStr(aTS: Cardinal): string;
var
  y, m, d: integer;
begin
  timestampToDate(aTS, y, m, d);
  Result := IntToStr(y) + '-' + IntToStr(m) + '-' + IntToStr(d);
end;

procedure getGameDateFromTS(out y, m, d: integer);
begin
  timestampToDate(getCurrTS(), y, m, d);
end;

//function  timestampToDateTime(const aTS: Cardinal): TDateTime;
//var
//  pg: PGameData;
//  y, m, d: Integer;
//begin
//  timestampToDate(aTS, y, m, d);
//end;
//var
//  pl: PLongWord;
//  pg: PGameData;
//  d, m, y: word;
//  dt: TDateTime;
//
//  dateDiff, yd, md, dd, r: Integer;
//  gameDate, inputDate: Integer;
//  prev: Boolean;
//begin
//  pg := getGameDataPtr();
//  d := pg^.day;
//  m := pg^.month + 1;
//  y := pg^.year;
//
//  dt := EncodeDate(y, m, d);
//
//  gameDate := pg^.currTS shr 8;
//  inputDate := aTS shr 8;
//
//
//  dateDiff := inputDate - gameDate;
//
//  Result := dt + dateDiff;
//end;

procedure getCityShengWang(
        const aPlayerID: Byte;
        const aCityCode: Byte;
        out S1, S2, S3, S4, S5: Single);
var
  pb, player: PByte;
  ps: PSingle;
begin
  player := pointer(getPlayerMoneyPtr(aPlayerID));
  pb := player;
//  OutputDebugString(pchar('P:$' + inttohex(integer(pb), 8)));
  Inc(pb, $11c);

//  OutputDebugString(pchar('S:$' + inttohex(integer(pb), 8)));

  ps := pointer(pb);
  Inc(ps, aCityCode * 3);

//  OutputDebugString(pchar('C:$' + inttohex(integer(ps), 8)));
  S1 := ps^;
  Inc(ps);
  S2 := ps^;
  Inc(ps);
  S3 := ps^;
  //211c

  pb := player;
  Inc(pb, $2fc + aCityCode * SizeOf(Single));

  ps := pointer(pb);
  S4 := ps^;

  pb := player;
  Inc(pb, $3c4 + aCityCode * SizeOf(Single));
  ps := pointer(pb);
  S5 := ps^;
end;

procedure setCityShengWang(
        const aPlayerID: Byte;
        const aCityCode: Byte;
        const S1, S2, S3, S4, S5: Single);
var
  player, pb: PByte;
  ps: PSingle;
begin
  player := pointer(getPlayerMoneyPtr(aPlayerID));
  pb := player;
//  OutputDebugString(pchar('P:$' + inttohex(integer(pb), 8)));
  Inc(pb, $11c);

//  OutputDebugString(pchar('S:$' + inttohex(integer(pb), 8)));

  ps := pointer(pb);
  Inc(ps, aCityCode * 3);

//  OutputDebugString(pchar('C:$' + inttohex(integer(ps), 8)));
  ps^ := S1;
  Inc(ps);
  ps^ := S2;
  Inc(ps);
  ps^ := S3;
  //211c

  pb := player;
  Inc(pb, $2fc + aCityCode * 3 * SizeOf(Single));

  ps := pointer(pb);
  ps^ := S4;

  pb := player;
  Inc(pb, $3c4 + aCityCode * SizeOf(Single));
  ps := pointer(pb);
  ps^ := S5;
end;

const
  P3_SHIP_LIST_PTR_PTR = $6DFB8C - P3_MODULE_BASE;

function  getAllShipListPtr(): PByte;
var
  pp: PPointer;
begin
//  pp := Pointer($6dfb8c);
  pp := relocate(P3_SHIP_LIST_PTR_PTR);
  Result := pp^;
end;

function  indexOfShip(ship: PP3R2Ship): Integer;
var
  sl: cardinal;
  sz: Integer;
begin
  sl := cardinal(getAllShipListPtr());

  sl := cardinal(ship) - sl;

  sz := sizeof(TP3R2Ship);

  Result := integer(sl) div sz;
end;

function  getShipByIndex(index: integer): PP3R2Ship;
var
  sl, pb: PByte;
  ofs: integer;
begin
  sl := getAllShipListPtr();
  ofs := (index * 3);
  ofs := ofs shl 7;
  Inc(sl, ofs);

  Result := pointer(sl);
end;


function  getShipListEx(const aTraderID: Byte; aList: TList; aFilter: tshipFilter; data: Pointer): Integer;
var
  pb, sl: PByte;
  pw: PWORD;
  idx: Word;
  i: Integer;
  ship: PP3R2Ship;
  comparer: Word;
begin
  if aList <> nil then
    aList.Clear();

  Result := 0;

  pb := pointer(getPlayerMoneyPtr(aTraderID));
  Inc(pb, $0E);
  pw := pointer(pb);

  idx := pw^;
  if idx = $FFFF then
  begin
//    dbgStr('No ship.' + byteToHexStr(aTraderID));
    Exit;
  end;

  sl := getAllShipListPtr();

  comparer := PWord(Pointer($6DFB88 + $F4))^;

  while (idx < comparer) and (idx <> $FFFF) do
  begin
    i := (idx * 3);
    i := i shl 7;

    pb := sl;
    Inc(pb, i);
    ship := pointer(pb);

    if Assigned(aFilter) then
    begin
      if aFilter(ship, data) then
      begin
        if aList <> nil then
          aList.Add(ship);

        Inc(Result);
      end;
    end
    else
    begin
      Inc(Result);
      if aList <> nil then
        aList.Add(ship);
    end;

    idx := ship^.NextShipIndex;
  end;

  if (idx <> $FFFF) and (idx >= comparer) then
  begin
    OutputDebugString('TEST: idx >= comparer.');
  end;
end;

function  getShipListExNoClear(const aTraderID: Byte; aList: TList; aFilter: tshipFilter; data: Pointer): Integer;
var
  pb, sl: PByte;
  pw: PWORD;
  idx: Word;
  i: Integer;
  ship: PP3R2Ship;
  comparer: Word;
begin
  Result := 0;

  pb := pointer(getPlayerMoneyPtr(aTraderID));
  Inc(pb, $0E);
  pw := pointer(pb);

  idx := pw^;
  if idx = $FFFF then
  begin
//    dbgStr('No ship.' + byteToHexStr(aTraderID));
    Exit;
  end;

  sl := getAllShipListPtr();

  comparer := PWord(Pointer($6DFB88 + $F4))^;

  while (idx < comparer) and (idx <> $FFFF) do
  begin
    i := (idx * 3);
    i := i shl 7;

    pb := sl;
    Inc(pb, i);
    ship := pointer(pb);

    if Assigned(aFilter) then
    begin
      if aFilter(ship, data) then
      begin
        if aList <> nil then
          aList.Add(ship);

        Inc(Result);
      end;
    end
    else
    begin
      Inc(Result);
      if aList <> nil then
        aList.Add(ship);
    end;

    idx := ship^.NextShipIndex;
  end;

  if (idx <> $FFFF) and (idx >= comparer) then
  begin
    OutputDebugString('TEST: idx >= comparer.');
  end;
end;


function shipFilter_getShipList_Building(ship: PP3R2Ship; data: Pointer): Boolean;
begin
  Result := (ship.State = SHIP_STATE__BUILDING) and (ship.Curr = integer(data));
end;

function  getShipList_Building(const aTrader: Byte; list: TList; city: integer): Integer;
begin
  Result := getShipListEx(aTrader, list, shipFilter_getShipList_Building, pointer(city));
end;

const
  P3__6DFB90 = $6DFB90 - P3_MODULE_BASE;

function  getShipGroupInfo(const aGroupIndex: Word): PShipGroupInfo;
var
  p6DFB90: PLongWord;
  eax, edx: Integer;
begin
  p6DFB90 := ptrAdd(pointer(P3__6DFB90), P3ModuleHandle);
  edx := p6DFB90^;

  eax := aGroupIndex * 3 * 5;

  Result := pointer(edx + eax * 4);
end;


type
  TGetShipGroupStruct = record
    list: TList;
  end;
  PGetShipGroupStruct = ^TGetShipGroupStruct;

function GetShipGroupFilter(ship: PP3R2Ship; data: Pointer): Boolean;
var
  idx: word;
  d: PGetShipGroupStruct;
begin
  Result := False;

  if (ship^.State = SHIP_STATE__BUILDING)
  or (ship^.State = SHIP_STATE__SINKING)
  or (ship^.State = SHIP_STATE__KILLED) then
  begin
    Exit;
  end;

  if ship^.GroupIndex <> $FFFF then
  begin
//    dbgStr('ship^.GroupIndex <> $FFFF');
    d := data;
    if d.list.IndexOf(pointer(ship.GroupIndex)) < 0 then
      d.list.Add(pointer(ship.GroupIndex));
  end;

  Result := True;
end;

procedure getShipGroupList2(const traderID: Byte; aShipGroupList: TList);
var
  i, gid: integer;
  st: TGetShipGroupStruct;
  tmpList: TList;
  sgInfo: PShipGroupInfo;
begin
//  dbgStr('getShipGroupList->');
  tmpList := TList.Create();
  try
    st.list := tmpList;
    getShipListEx(traderID, nil, GetShipGroupFilter, @st);

    for I := 0 to tmpList.Count - 1 do
    begin
      gid := integer(tmpList[i]);
      sgInfo := getShipGroupInfo(gid);
      aShipGroupList.Add(sgInfo);
    end;
  finally
    tmpList.Destroy();
  end;
//  dbgStr('<-getShipGroupList');
end;

function  getShipList(const aTraderID: Byte; aList: TList): integer;
begin
  Result := getShipListEx(aTraderID, aList, nil, nil);
end;

function  getCurrPlayerID(): Byte;
//const
//  PLAYER_ID = $24; //GET FROM $70C77C
begin
//  Result := $24;
  Result := PByte($70c77c)^;
end;

function  getCurrPlayerID_Program(): Byte;
begin
  Result := PByte($70c77c)^;
end;

function  getLastPlayerID(): Byte;
begin
  Result := getCurrPlayerID();
end;


procedure getAllShipList(list: TList);
var
  tid: byte;
begin
  for tid := MIN_TRADER_ID to getLastPlayerID() do
  begin
    getShipListExNoClear(tid, list, nil, nil);
  end;
end;

function  getTraderShipCount(trader: byte): Integer;
begin
  Result := getShipList(trader, nil);
end;

function  getshipArea(ship: PP3R2Ship; shipNameSeperator: WideChar): WideString;
var
  p: integer;
begin
  if shipNameSeperator = #0 then
  begin
    Result := '';
    exit;
  end;
  
  Result := getShipName_R2(ship);
  if Length(Result) < 3 then
  begin
    Result := '';
    exit;
  end;

  p := WidePos(shipNameSeperator, Result);

  if p > 1 then
  begin
    Result := Copy(Result, 1, p-1);
  end
  else
    Result := '';
//
//  if Result[2] = shipNameSeperator then
//  begin
//    Result := Result[1];
//  end
//  else
//    Result := '';
end;


function  getPlayerHomeCity(const aPlayerID: Byte): Byte;
var
  pb: PByte;
begin
  pb := pointer(getPlayerMoneyPtr(aPlayerID));
  Inc(pb, $19);
  Result:= pb^;
end;

//procedure loadCityCodes();
//var
//  I, Idx: Integer;
//  ln: WideString;
//  SL: TStringList;
//  fn: WideString;
//
//  procedure invalidContent(const tag: integer);
//  begin
//    OutputDebugString(pchar('Invalid content in p3citycode.txt, ' + inttostr(tag)));
//    raise Exception.Create('Invalid content in p3citycode.txt');
//  end;
//
//  procedure useDefaultCityCode();
//  var
//    idx: Integer;
//    
//    procedure p(const S: WideString);
//    begin
//      OrginalCityNames[idx] := S;
//      Inc(idx);
//    end;
//
//  begin
//    idx := 0;
//
//    p('爱丁堡');
//    p('纽卡斯尔');
//    p('斯卡伯勒');
//    p('波士顿');
//    p('伦敦');
//    p('布鲁日');
//    p('哈勒母');
//    p('哈灵根');
//    p('格罗宁根');
//    p('科隆');
//    p('不莱梅');
//    p('里彭');
//    p('汉堡');
//    p('弗伦斯堡');
//    p('吕贝克');
//    p('罗斯托克');
//    p('卑尔根');
//    p('斯塔万格');
//    p('图什堡');
//    p('奥斯堡');
//    p('奥尔堡');
//    p('哥得堡');
//    p('奈斯特韦兹');
//    p('马尔摩');
//    p('奥胡斯');
//    p('斯德哥尔摩');
//    p('维斯比');
//    p('赫尔辛基');
//    p('斯德丁');
//    p('罗根沃德');
//    p('格但斯克');
//    p('托伦');
//    p('格尼斯堡');
//    p('梅梅尔');
//    p('文岛');
//    p('里加');
//    p('帕尔努');
//    p('瑞威尔');
//    p('拉多加');
//    p('诺夫哥罗德');
//  end;
//
//begin
//  fn := ExtractFilePath(ParamStr(0)) + 'p3citycode.txt';
//
//  if not FileExistsWide(FN) then
//  begin
//    useDefaultCityCode();
//    Exit;
//  end;
//
//  SL := TStringList.Create();
//  try
//    SL.LoadFromFile(fn);
//
//    if SL.Count < MAX_CITY_CODE+1 then
//      invalidContent(1);
//
//    Idx := 0;
//
//    for I := 0 to SL.Count - 1 do
//    begin
//      ln := Trim(SL[I]);
//      if ln = '' then
//        Continue;
//
//      if Idx > MAX_CITY_CODE then
//        invalidContent(2);
//
//      OrginalCityNames[Idx] := ln;
//      Inc(Idx);
//    end;
//  finally
//    SL.Destroy();
//  end;
//
//  if Idx <> MAX_CITY_CODE + 1 then
//    invalidContent(3);
//end;


procedure getCityNames(aList: TStrings; const aAddHexCodePrefix: Boolean);
var
  I, Cnt: Integer;
  s: string;
begin
  Cnt := getCityCount();

  for I := 0 to Cnt - 1 do
  begin
    s := '';
    if aAddHexCodePrefix then
      s := '$' + IntToHex(i, 2) + ' ';

    s := s + getCityName2(I);
    aList.Add(s);
  end;
end;

function  getPlayerCount(): Integer;
begin
  Result := getCurrPlayerID() + 1;
end;

function  isValidPlayerID(const aPlayerID: byte): Boolean;
begin
  Result := aPlayerID <= getCurrPlayerID();
end;

function  getPlayerName(const aPlayerID: Byte): WideString;
var
  pb: PByte;
  pc: PChar;
  pp: PPointer;
  s1, s2: string;
begin
  if not isValidPlayerID(aPlayerID) then
  begin
    Result := byteToHexStr(aPlayerID);
    exit;
  end;
  
  pb := pointer(getPlayerMoneyPtr(aPlayerID));
//  dbgPrintPtr('player', pb);
  Inc(pb, $E4);
//  dbgPrintPtr('player-ptr+$e4', pb);

  pp := Pointer(pb);

  pc := pp^;
  s1 := pc;

  Inc(pp);
//  dbgPrintPtr('player-ptr+$e8', pp);

//  pp := Pointer(pb);
  pc := pp^;
  s2 := pc;

  Result := s2 + ' ' + s1;
end;

function  isGameActive(): Boolean;
begin
  Result := getCurrPlayerID() <> $FF;
end;

procedure getPlayerExtraInfo(
        const aPlayerID: Byte;
        out aTotalAssets: Integer;      //总资产
        out aTotalLoadingCap: Integer; //总运载能力
        out a15, a1B: Byte);
var
  pb, player: PByte;
begin
  player := getPlayerPtr(aPlayerID);

  pb := player;
  Inc(pb, $15);
  a15 := pb^;

  pb := player;
  Inc(pb, $1B);
  a1B := pb^;

  pb := player;
  inc(pb, $46C);

  aTotalAssets := Pinteger(pb)^;

  pb := player;
  Inc(pb, $470);
  aTotalLoadingCap := PInteger(pb)^;
end;

procedure setPlayerExtraInfo_1B(const aPlayerID: Byte; const a1B: Byte);
var
  pb, player: PByte;
begin
  player := getPlayerPtr(aPlayerID);

  pb := player;
  Inc(pb, $1B);
  pb^ := a1B;
end;

function getPlayerTotalAssets(const aPlayerID: Byte): integer;
var
  pb, player: PByte;
begin
  player := getPlayerPtr(aPlayerID);
  pb := player;
  inc(pb, $46C);

  Result := Pinteger(pb)^;
end;

function  getPlayerTotalLoadingCap(const aPlayerID: Byte): Integer;
var
  pb, player: PByte;
begin
  player := getPlayerPtr(aPlayerID);
  pb := player;
  Inc(pb, $470);

  Result := PInteger(pb)^;  
end;

procedure getPlayerBirthday(const aPlayerID: Byte; out Y, M, D: Integer);
var
  pw: PInteger;
begin
  pw := pointer(getPlayerPtrOffset(aPlayerID, $10));
  timestampToDate(pw^, Y, M, D);
end;

function  getViewPortCityCode(): Byte;
var
  pb: PByte;
begin
  pb := PPointer($6def7c)^;
  Inc(pb, $c324);
  Result := pb^;
end;

function  getPlayerClass(const aPlayerID: Byte): WideString;
var
  ptr: PByte;
  {p19, p1a, }pTemp: Pbyte;

  {b19, b1a, b39c, }esp24: Byte;
  eax, ecx, edx: LongWord;
  pc: Pchar;
  s: string;
begin
  ptr := getPlayerPtr(aPlayerID);

  pTemp := ptrAdd(ptr, $19);
  edx := pTemp^;

  pTemp := ptrAdd(ptr, $39C + edx);
  eax := pTemp^;

  esp24 := eax;

  pTemp := ptrAdd(ptr, $1A);
  eax := pTemp^;

  edx := esp24;

  ecx := eax;
  ecx := ecx and 1;


//  eax := eax * 3;
  ecx := edx + ecx * 8;
//  eax := eax * 5;

  edx := ecx * 4 + $6B05B4;

  pc := ppointer(edx)^;

//  dbgPrintPtr('Class', pc);
  s := pc;
  Result := s;
end;

function  getEvaluationPrefix(const aPlayerID: Byte): WideString;
begin

end;

function  getBusinessOfficePtr(
        const aPlayerID: Byte;
        const aCityCode: Byte): PBusinessOffice;
var
  pid: integer;
  citycode: integer;
begin
  pid := aPlayerID;
  citycode := aCityCode;
  asm
    pushad

    push 0

    mov eax, citycode
    push eax

    mov eax, pid
    push eax

    mov ecx, $71CDA8

    mov eax, $628640
    call eax
    mov result, eax
    popad
  end;
end;

function  getGoodsDisplayQty(const aGoodsID: Integer; const aQty: Integer): Currency;
begin
  Result := aQty;
  if isGoodsMeasuredInPkg(aGoodsID) then
    Result := Result / UNIT_PKG
  else
    Result := Result / UNIT_TONG;
end;

function  getGoodsDisplayQtyText(const aGoodsID: Integer; const aQty: Integer): WideString;
begin
  Result := FormatCurr('0.0', getGoodsDisplayQty(aGoodsID, aQty));
end;

function  getTradeRoute(const aIndex: Word): PTradeRoute;
var
  ecx, edx: Integer;
begin
  ecx := PInteger($6DD070)^ + 220 * aIndex;
  Result := pointer(ecx);
end;

function  tradeRoute_getOpTypeName(opType: TTradeRouteOpType): WideString;
begin
  case opType of
    RT__UNSPECIFIED:  Result := '';
    RT__SELL:         Result := '卖出';
    RT__BUY:          Result := '买入';
    RT__PUT_INTO:     Result := '入仓';
    RT__GET_OUT:      Result := '出仓';
  else
    Result := '';
  end;
end;



//function  getTradeRoute(const aIndex: Word): PTradeRoute;
//var
//  ecx, edx: Integer;
//begin
//  ecx := aIndex;
//  edx := ecx * 5;
//  ecx := ecx + 2 * edx;
//  edx := PInteger($6DD070)^;
//  ecx := ecx * 5;
//  ecx := edx + ecx * 4;
//  Result := pointer(ecx);
//end;

function  indexOfTradeRoute(p: PTradeRoute): Integer;
var
  pi: pointer;
begin
  Result := P3ModuleHandle + P3_TRADE_ROUTE_LIST_PPTR_OFFSET;
  Result := (integer(p) - PInteger(Result)^) div 220;
end;

function  getCityBuilding(aCity: PCityStruct; const aIndex: Integer): PCityBuilding;
begin
   result := aCity^.BuildingListPtr;
   inc(Result, aIndex);
end;

function  getCityMap(const aCityCode: Byte): PByte;
var
  city, pb: PByte;
  pp: PPointer;
begin
  city := pointer(getCityPtr(aCityCode));
  pb := ptrAdd(city, $7a4 + $68); //map info = city + $7a4
  pp := pointer(pb);
  Result := pp^;
//  pp := pointer(pb);
end;

function  getMapOffset(const aPt: TPoint): Integer;
begin
  Result := aPt.Y * 226 + aPt.X;
end;

function  getMapByte(aMap: PByte; const aPt: TPoint): Byte;
begin
  Inc(aMap, getMapOffset(aPt));
  Result := aMap^;
end;

function  mapOffsetToPt(aOffset: Integer): TPoint;
begin
  Result.Y := aOffset div 226;
  Result.X := aOffset mod 226;
end;

function  transPtLT(aPt: TPoint; aDelta: Integer): TPoint;
begin
  Result := aPt;
  while aDelta > 0 do
  begin
    if (Result.Y and 1) = 1 then
      Dec(Result.Y)
    else
    begin
      Dec(Result.X);
      Dec(Result.Y);
    end;
    Dec(aDelta);
  end;
end;

//function  canMoveLT(aPt: TPoint): boolean;
//var
//  pt: TPoint;
//begin
//  pt := transPtLT(aPt, 1);
//  Result := (pt.X >= 0) and (pt.Y >= 0) and (pt.X <;
//end;

//function  canMoveRT(aPt: TPoint): boolean;
//begin
//
//end;


function  transPtRT(aPt: TPoint; aDelta: Integer): TPoint;
begin
  Result := aPt;
  while aDelta > 0 do
  begin
    if (Result.Y and 1) = 0 then
      Dec(Result.Y)
    else
    begin
      Inc(Result.X);
      Dec(Result.Y);
    end;
    Dec(aDelta);
  end;
end;

//procedure processMap(aMap: PByte);
//begin
//
//end;

function  getFactoryGroupInfo(const aIndex: Integer): PFactoryGroup;
var
  pb: PByte;
begin
  pb := PPointer($71CDA8 + $70)^;
  Result := ptrAdd(pb, 20 * aIndex);
end;

function  getFirstFactoryGroupIndex(
          const aPlayerID: Byte;
          const aCityCode: Byte): Word;
var
  dw1, dw2: DWORD;
  pb: PByte;
begin
  dw1 := aCityCode;
  dw2 := aPlayerID;

  asm
    pushad
    push 0
    mov eax, dw1
    push eax
    mov eax, dw2
    push eax
    mov ecx, $71CDA8
    mov eax, $628640
    call eax
    mov dw1, eax
    popad
  end;

  if dw1 = 0 then
    Result := $FFFF
  else
  begin
    pb := pointer(dw1);
    Inc(pb, $2CC);

    Result := PWord(pb)^;
  end;
end;

function  buildTypeToGoodsID(const aBuildingType: Byte): Byte;
begin
  case aBuildingType of
    BUILDING__RICE_FIELD:               Result := 1;
    BUILDING__COW_FARM:                 Result := 2;
    BUILDING__PISCARY:                  Result := 3;
    BUILDING__BEER_FACTORY:             Result := 4;

    

    BUILDING__SALTERN:                  Result := 5;
    BUILDING__APIARY:                   Result := 6;

    BUILDING__VINEYARD:                 Result := 8;



    BUILDING__TEXTILE_MILL:             Result := 9;
    BUILDING__HUNTER_HOUSE:             Result := 10;

    BUILDING__LOGGING_CAMP:             Result := 12;



    BUILDING__TOOLS_FACTORY:            Result := 13;

    BUILDING__SHEEP_FARM:               Result := 15;
    BUILDING__ASPHALT_FACTORY:          Result := 16;


    
    BUILDING__IRON_MILL:                Result := 17;
    BUILDING__HEMP_FIELD:               Result := 18;
    BUILDING__CERAMIC_FACTORY:          Result := 19;
    BUILDING__BRICKYARD:                Result := 20;
  else
    Result := $FF;
  end;
end;

function  getGoodsFactoryType(const aGoodsID: Byte): Byte;
begin
  case aGoodsID of
    1:  Result := BUILDING__RICE_FIELD;
    2:  Result := BUILDING__COW_FARM;
    3:  Result := BUILDING__PISCARY;
    4:  Result := BUILDING__BEER_FACTORY;

    5:  Result := BUILDING__SALTERN;
    6:  Result := BUILDING__APIARY;

    8:  Result := BUILDING__VINEYARD;

    9:  Result := BUILDING__TEXTILE_MILL;
    10: Result := BUILDING__HUNTER_HOUSE;
    11: Result := BUILDING__PISCARY;
    12: Result := BUILDING__LOGGING_CAMP;

    13: Result := BUILDING__TOOLS_FACTORY;
    14: Result := BUILDING__COW_FARM;
    15: Result := BUILDING__SHEEP_FARM;
    16: Result := BUILDING__ASPHALT_FACTORY;

    17: Result := BUILDING__IRON_MILL;
    18: Result := BUILDING__HEMP_FIELD;
    19: Result := BUILDING__CERAMIC_FACTORY;
    20: Result := BUILDING__BRICKYARD;
  else
    Result := $FF;
  end;
end;

function  getFactoryMaxWorker(const aFactoryType: Byte): Integer;
var
  pb: PByte;
begin
  pb := pointer(P3ModuleHandle);
  Inc(pb, $288EA4 + (aFactoryType-BUILDING__HUNTER_HOUSE));
  Result := pb^;
//  OutputDebugString(pchar('maxWorker=' + IntToStr(Result)));
end;


{ TCityBODataCache }

procedure TCityBODataCache.fill;
var
  pid, bt, firstIdx: Integer;
  ptr: PBusinessOffice;
  fg: PFactoryGroup;
begin
//  dbgStr('TCityBODataCache.fill called, cityCode=' + IntToStr(CityCode));
  Count := 0;

  try

  for pid := 0 to getLastPlayerID() do
  begin
    ptr := getBusinessOfficePtr(pid, CityCode);
    if ptr <> nil then
    begin
      BOData[Count].PlayerID := pid;
      BOData[Count].BOPtr := ptr;

      for bt := FIRST_FACTORY_BUILDING to LAST_FACTORY_BUILDING - 1 do
        BOData[Count].FactoryGroups[bt].IsValid := False;

      firstIdx := getFirstFactoryGroupIndex(pid, CityCode);
      while firstIdx <> $FFFF do
      begin
        fg := getFactoryGroupInfo(firstIdx);
        if fg <> nil then
        begin
          bt := fg^.BuildType;

          BOData[Count].FactoryGroups[bt].DataPtr := fg;
          BOData[Count].FactoryGroups[bt].IsValid := True;

          firstIdx := fg^.NextIndex;
        end
        else
        begin
          firstIdx := $FFFF;
          OutputDebugString('May be error here');
        end;
      end;

      Inc(Count);
    end;
  end;
  except
    OutputDebugString(pchar('error in fill prod'));
    raise;
  end;

  Ready := True;     
end;

function TCityBODataCache.findFactoryGroup(const pid,
  aBuildingType: Byte): PFactoryGroup;
var
  I: Integer;
begin
  if not Ready then
    fill();

  for I := 0 to Count - 1 do
  begin
    if BOData[I].PlayerID = pid then
    begin
      if BOData[I].FactoryGroups[aBuildingType].IsValid then
        Result := BOData[I].FactoryGroups[aBuildingType].DataPtr
      else
        Result := nil;

      exit;
    end;
  end;

  Result := nil;
end;

function TCityBODataCache.findPlayerBO(const pid: Byte): PBusinessOffice;
var
  I: Integer;
begin
  if not Ready then
    fill();


  for I := 0 to Count - 1 do
  begin
    if BOData[I].PlayerID = pid then
    begin
      Result := BOData[I].BOPtr;
      exit;
    end;
  end;

  Result := nil;
end;

function TCityBODataCache.getCount: Integer;
begin
  if not Ready then
    fill();

  Result := Count;
end;

procedure TCityBODataCache.init(const aCityCode: Byte);
begin
  reset();
  CityCode := aCityCode;
end;

procedure TCityBODataCache.reset;
begin
  Ready := False;
  Count := 0;  
end;

{ TCityBODataCacheList }

function TCityBODataCacheList.findBO(const aCity,
  aPlayer: Byte): PBusinessOffice;
begin
  Result := Caches[aCity].findPlayerBO(aPlayer);
end;

function TCityBODataCacheList.findFactoryGroup(const aCity, pid,
  aBuildingType: Byte): PFactoryGroup;
begin
  Result := Caches[aCity].findFactoryGroup(pid, aBuildingType);
end;

function TCityBODataCacheList.get(city: integer): PCityBODataCache;
begin
  Result := @Caches[city];
end;

procedure TCityBODataCacheList.init;
var
  i: Integer;
begin
  FillChar(Caches[0], SizeOf(Caches), 0);
  
  for I := Low(Caches) to High(Caches) do
    Caches[I].init(i);
end;

procedure TCityBODataCacheList.reset;
var
  I: Integer;
begin
  for I := Low(Caches) to High(Caches) do
    Caches[I].reset();
end;

//aLvl:
//0 - rich
//1 - common
//2 - poor
//return week consume in 1/200 tong
function  getResidentConsumeRateInWeek(const aLvl: Byte; const aGoodsID: Byte): Double;
var
  pb: PByte;
  pi: PItemRequirement;
  factor: Double;
  pw: PWORD;
begin
  pb := pointer(P3ModuleHandle);
  Inc(pb, RESIDENT_REQ_OFFSET);

  pi := pointer(pb);
  pw := @pi^[aGoodsID];
  inc(pw, aLvl);

  Result := pw^;
//  if isGoodsMeasuredInPkg(aGoodsID) then
//    factor := 0.035
//  else
//    factor := 0.35;

  Result := Result * UNIT_TONG * 0.35;
end;


{ TResidentConsumePrecalc }

function TResidentConsumePrecalc.calcCityConsumeInDay(const aGoodsID,
  aCityCode: Byte): Double;
begin
  Result := calcCityConsumeInWeek(aGoodsID, aCityCode) / 7;
end;

function TResidentConsumePrecalc.calcCityConsumeInWeek(const aGoodsID,
  aCityCode: Byte): Double;
var
  city: PCityStruct;
begin
  prepare();
  
  city := getCityPtr(aCityCode);

  Result := internalCalcWeek(GRADE__RICH, aGoodsID, city^.Pop_rich)
          + internalCalcWeek(GRADE__COMMON, aGoodsID, city^.Pop_common)
          + internalCalcWeek(GRADE__POOR, aGoodsID, city^.Pop_poor);
end;

function TResidentConsumePrecalc.calcDay(
  const alvl: Byte;
  const aGoodsID: byte;
  const aResidentCount: Integer): Double;
begin
  prepare();
  Result := items[aGoodsID].ThousandResidentsReqsInWeek[alvl];
  Result := Result * aResidentCount / 1000 / 7;
end;

function TResidentConsumePrecalc.calcWeek(const alvl, aGoodsID: byte;
  const aResidentCount: Integer): Double;
begin
  prepare();
  Result := internalCalcWeek(alvl, aGoodsID, aResidentCount);
end;

constructor TResidentConsumePrecalc.Create;
begin
  reset();
end;

function TResidentConsumePrecalc.internalCalcWeek(const alvl, aGoodsID: byte;
  const aResidentCount: Integer): Double;
begin
  Result := items[aGoodsID].ThousandResidentsReqsInWeek[alvl];
  Result := Result * aResidentCount / 1000;
end;

procedure TResidentConsumePrecalc.prepare;
var
  lvl: Byte;
  goodsID: Byte;
  s: string;
  v: double;
begin
  if Ready then
    exit;

  for lvl := 0 to 2 do
    for goodsID := 1 to MAX_GOODS do
    begin
      v := getResidentConsumeRateInWeek(lvl, goodsID);
//      s := 'Lvl = ' + IntToStr(lvl) + ' ' + getGoodsName(goodsID) + '=' + FormatFloat('0.00', v);
      items[goodsID].ThousandResidentsReqsInWeek[lvl] := v;
      OutputDebugString(pchar(s)); 
    end;

  Ready := True;
end;

procedure TResidentConsumePrecalc.reset;
begin
  Ready := False;
end;

function  isWinter(const month: integer): Boolean;
begin
  Result := (month = 1) or (month = 2) or (month = 12);
end;

function  isWinterNow(): Boolean;
var
  y, m, d: Integer;
begin
  getGameDate(y, m, d);

  Result := isWinter(m);
end;

function  isWinterReqIncGoods(const aGoodsID: Integer): Boolean;
begin
  Result := (aGoodsID = GOODSID__WOOD) or (aGoodsID = GOODSID__ANIMAL_SKIN); 
end;

function  isWinterProdDecGoods(const aGoodsID: Integer): Boolean;
begin
  Result := (aGoodsID = GOODSID__RICE) or (aGoodsID = GOODSID__HONEY) or (aGoodsID = GOODSID__WINE) or (aGoodsID = GOODSID__HEMP);
end;

function  calcWinterReqIncrease(const aCurrReq: Double; const aGoodsID: Integer): Double;
begin
  if isWinterReqIncGoods(aGoodsID) then
    Result := aCurrReq * WINTER_REQ_INCREASE_RATE
  else
    Result := aCurrReq;
end;

function  calcWinterProdDecrease(const aCurrProd: Double; const aGoodsID: Integer): Double;
begin
  case aGoodsID of
    GOODSID__RICE: Result := aCurrProd * WINTER_PROD_DECREASE_RATE___RICE;
    GOODSID__HONEY, GOODSID__WINE, GOODSID__HEMP: Result := aCurrProd * WINTER_PROD_DECREASE_RATE___OTHERS;
  else
    Result := aCurrProd;
  end;
end;

procedure getCityMapPos(const aCityCode: Byte; out x, y: Integer);
var
  InternalCode: Byte;
  eax, edx: dword;
  pi: PInteger;
begin
  InternalCode := getOriginalCityID(aCityCode);

  edx := InternalCode * 3;
  eax := InternalCode + edx * 4;
  eax := eax shl 2;

  pi := ptrAdd(pointer($709910), eax);
  x := pi^;

  pi := ptrAdd(pointer($709914), eax);
  y := pi^;
end;

function  P6E2030(): Byte;
begin
  Result := PByte($6E2020+$10)^;
end;

function  isInSeaView(): Boolean;
var
  pb: PByte;
begin
  pb := pointer($6E2020+$10);
  Result := pb^ <> 0;
end;


function  howOldIs(const aTraderID: Byte): Integer;
var
  bd: PLongWord;
begin
  bd := ptrAdd(getPlayerPtr(aTraderID), $10);
  Result := getCurrTS() - bd^;
  Result := (Result shr 8) div 365;
end;

function  setShipDest(ship: PP3R2Ship; const destCityCode: Integer): Integer;
var
  idx, city: Integer;
  p, func: Cardinal;
  pb: PByte;
begin
  if ship^.State = $00 then
    ship^.State := $02;

  idx := indexOfShip(ship);
  Result := idx;
  p := cardinal(ship);
  city := destCityCode;
  func := P3ModuleHandle + P3_SET_SHIP_DEST_FUNC_OFFSET;

  asm
    pushad
    push idx
    push 0
    push 0
    push destCityCode
    mov ecx, p
    mov eax, func
    call eax
//    mov result, eax
    popad
  end;

  pb := pointer(ship);
  inc(pb, $13B);
  pb^ := destCityCode;

  pb := pointer(ship);
  Inc(pb, $30);
  pb^ := 1;




//  OutputDebugString(pchar(
//    'long=' + longwordToHexStr(Result)));
end;

procedure getTimeDiffInDays(aTS: Longword; out days, hours: Integer);
var
  curr: LongWord;
begin
  curr := getCurrTS();
  days := aTS - curr;
  if days < 0 then
    days := - days;

  hours := getHourPart(days);
  days := days shr 8;
end;

function  intervalToStr(const days, hours: Integer): string;
begin
  if days > 0 then
    Result := IntToStr(days) + '天' + IntToStr(hours) + '小时'
  else
    Result := IntToStr(hours) + '小时';
end;

//function  hasShipsInCity(const aPlayer: Byte; const city: Byte): Boolean;
//begin
////  getShipList(aPlayer, );
//end;

//function  getGoodsQtyFactor(goodsID: Integer): Integer;
//begin
//  if isGoodsMeasuredInPkg(goodsID) then
//    Result := UNIT_PKG
//  else
//    Result := UNIT_TONG;
//end;

{ TCityShipList }

procedure TCityShipList.clear;
begin
  List.Clear();
end;

constructor TCityShipList.Create(cityCode: Byte);
begin
  List := TObjectList.Create(True);
  Self.cityCode := cityCode;  
end;

destructor TCityShipList.Destroy;
begin
  FreeAndNil(List);
  inherited;
end;

function  shipFilter_City(ship: PP3R2Ship; data: Pointer): boolean;
var
  r: TCityShipList;
begin
  r := TCityShipList(data);

  Result := ship^.Curr = r.cityCode;  
end;   

function TCityShipList.get(const aTrader: Byte): TCityTraderShipList;
var
  ship: PP3R2Ship;
begin
  if aTrader >= List.Count-1 then
  begin
    List.Count := aTrader + 1;
    Result := TCityTraderShipList.Create();
    Result.owner := aTrader;
    getShipListEx(aTrader, Result.ShipList, shipFilter_City, Self);

    List[aTrader] := Result;
  end
  else
  begin
    Result := TCityTraderShipList(List[aTrader]);
    if Result = nil then
    begin
      Result := TCityTraderShipList.Create();
      Result.owner := aTrader;
      getShipListEx(aTrader, Result.ShipList, shipFilter_City, Self);

      List[aTrader] := Result;
    end;
  end;
end;

{ TAllCityShipList }

procedure TAllCityShipList.clear;
begin
  List.Clear();
end;

constructor TAllCityShipList.Create;
begin
  List := TObjectList.Create(True);
end;

destructor TAllCityShipList.Destroy;
begin
  FreeAndNil(List);
  inherited;
end;

function TAllCityShipList.get(const city: Byte): TCityShipList;
begin
  if city >= List.Count-1 then
  begin
    List.Count := city + 1;
    Result := TCityShipList.Create(city);
    List[city] := Result;
  end
  else
  begin
    Result := TCityShipList(List[city]);
    if Result = nil then
    begin
      Result := TCityShipList.Create(city);
      List[city] := Result;
    end;
  end;
end;

function TAllCityShipList.getCityIconType(cityCode: Byte): TCityIconType;
var
  pid: byte;
  bo: PBusinessOffice;
  list: TCityShipList;
begin
  pid := getCurrPlayerID();

  bo := getBusinessOfficePtr(pid, cityCode);
  if bo <> nil then
    Result := CI__BLUE
  else
  begin
    list := get(cityCode);
    if list.get(pid).ShipList.Count > 0 then
      Result := CI__RED_BLUE
    else
      Result := CI__RED;
  end;
       
end;

function  getGradeText(const grade: Byte): WideString;
begin
  case grade of
    GRADE__RICH: Result := '富豪';
    GRADE__COMMON: Result := '富人';
    GRADE__POOR: Result := '穷人';
  else
    Result := '?';
  end;
end;


{ THouseCapacityInfo }

function THouseCapacityInfo.getCap(const grade: byte): integer;
var
  ptr: PWORD;
begin
  if not Ready then
  begin
    ptr := ptrAdd(pointer(P3ModuleHandle), P3_HOUSE_CAPACITY_DATA_OFFSET);

    _AdvHouseCap := ptr^;
    Inc(ptr);
    _CommonHouseCap := ptr^;
    Inc(ptr);
    _PoorHouseCap := ptr^;
    Ready := True;
  end;

  case grade of
    GRADE__RICH: Result := _AdvHouseCap;
    GRADE__COMMON: Result := _CommonHouseCap;
    GRADE__POOR: Result := _PoorHouseCap;
  else
    Result := 1;
    OutputDebugString(pchar('Invalid parameter: house capacity info.'));
  end;
end;

procedure THouseCapacityInfo.init;
begin
  reset();
end;

procedure THouseCapacityInfo.reset;
begin
  Ready := False;
end;

{ TCityTraderShipList }

constructor TCityTraderShipList.Create;
begin
  ShipList := TList.Create();
end;

destructor TCityTraderShipList.Destroy;
begin
  FreeAndNil(ShipList);
  inherited;
end;



function  tradeRoute_getPointCount(ship: PP3R2Ship): Integer;
var
  curr, next: Word;
  tr: PTradeRoute;
begin
  Result := 0;
  
  if ship^.TradingIndex = $FFFF then
  begin

    Exit;
  end;

  curr := ship^.TradingIndex;
  tr := getTradeRoute(curr);
  next := tr.NextIndex;
  Inc(Result);
  while (next <> $FFFF) and (next <> curr) do
  begin
    tr := getTradeRoute(next);
    Inc(Result);

    next := tr^.NextIndex;
  end;  
end;

const
  P3__6DD06C = $6DD06C - P3_MODULE_BASE;
  P3__ALLOC_TR_FUNC_OFFSET = $41A030 - P3_MODULE_BASE;
  P3__FREE_TR_FUNC_OFFSET = $41A220 - P3_MODULE_BASE;
  P3__70C2DC = $70C2DC - P3_MODULE_BASE;

function  tradeRoute_new(): Word;
var
  v: Integer;
  f: Integer;
  r: PTradeRoute;
//  _esi: DWORD;
begin
  v := P3ModuleHandle + P3__6DD06C;
  f := P3ModuleHandle + P3__ALLOC_TR_FUNC_OFFSET;
//  _esi := P3ModuleHandle + P3__70C2DC;
  try
    asm
      pushad
      mov ecx, v
      mov eax, f
      call eax
      mov v, eax
//      mov esi, _esi
//      dec dword ptr ds:[esi+$0c]
      popad
    end;
  except
    OutputDebugString('error on tradeRoute_new');
    raise;
  end;

  Result := v and $FFFF;
end;

procedure tradeRoute_free(const aRoutePointIndex: Integer);
var
  v, f: Integer;
begin
  v := P3ModuleHandle + P3__6DD06C;
  f := P3ModuleHandle + P3__FREE_TR_FUNC_OFFSET;

  try
    asm
      pushad
      mov ecx, v
      mov eax, aRoutePointIndex
      push eax
      mov eax, f
      call eax
      popad
    end;
  except
    OutputDebugString('error on tradeRoute_free');
    raise;
  end;
end;

procedure tradeRoute_initOrders(p: PTradeRoute);
var
  idx: Integer;

  procedure put(const goodsID: Byte);
  begin
    p^.Orders[idx] := goodsID-1;
    Inc(idx);
  end;
    
begin
  idx := 1;

  put(GOODSID__CLOTH);
  put(GOODSID__RICE);
  put(GOODSID__HONEY);
  put(GOODSID__WHALE_OIL);

  put(GOODSID__ASPHALT);
  put(GOODSID__HEMP);
  put(GOODSID__WOOD);
  put(GOODSID__BEER);

  put(GOODSID__LEATHER);
  put(GOODSID__WINE);
  put(GOODSID__MEAT);
  put(GOODSID__IRON);

  put(GOODSID__ANIMAL_SKIN);
  put(GOODSID__POTTERY);
  put(GOODSID__TOOLS);
  put(GOODSID__SPICE);

  put(GOODSID__SALT);
  put(GOODSID__WOOL);
  put(GOODSID__FISH);
  put(GOODSID__BRICK);
end;

const
  P3_GET_CITY_SALE_PRICE_FUNC_OFFSET = $623720 - P3_MODULE_BASE;
  P3_GET_CITY_PURCHASE_PRICE_FUNC_OFFSET = $6234C0 - P3_MODULE_BASE;
  P3__71C938 = $71C938 - P3_MODULE_BASE;

//var
//  __r: integer;


function  getCitySalePrice(qty, city, goodsID: Integer): Integer;
var
  c938, f: integer;

begin
  f := P3ModuleHandle + P3_GET_CITY_SALE_PRICE_FUNC_OFFSET;
  c938 := P3ModuleHandle + P3__71C938;
  goodsID := goodsID-1;
  asm
    pushad
    push qty
    push city
    push goodsId
    mov eax, f
    mov ecx, c938
    call eax
    mov result, eax
    popad
  end;
end;

function  getCitySalePriceDef(city, goodsID: Integer): Integer;
var
  q: Integer;
begin
  q := getGoodsQtyFactor(goodsID);
  Result := getCitySalePrice(q, city, goodsID);
end;

function  getCityPurchasePrice(qty, city, goodsID: Integer): Integer;
var
  f: integer;
  c938: Integer;
begin
  f := P3ModuleHandle + P3_GET_CITY_PURCHASE_PRICE_FUNC_OFFSET;
  c938 := P3ModuleHandle + P3__71C938;
  goodsID := goodsID - 1;
  asm
    pushad
    push qty
    push city
    push goodsId
    mov eax, f
    mov ecx, c938
    call eax
    mov result, eax
    popad
  end;
end;

function  getCityPurchasePriceDef(city, goodsID: Integer): Integer;
var
  q: Integer;
begin
  q := getGoodsQtyFactor(goodsID);
  Result := getCityPurchasePrice(q, city, goodsID);
end;

function  getCitySPriceStr(city, gid: integer): string;
var
  p: integer;
begin
  p := getCitySalePriceDef(city, gid);
  if p <> 0 then
    Result := formatMoney(p)
  else
    Result := '';
end;

function  getCityPPriceStr(city, gid: integer): string;
var
  p: integer;
begin
  p :=  getCityPurchasePriceDef(city, gid);
  if p <> 0 then
    Result := formatMoney(p)
  else
    Result := '';
end;


function  tradeRoute_getIndices(ship: PP3R2Ship; var indices: TTradeRouteIndices): Integer;
var
  first, next, firstIdx, idx: Word;
  tr: PTradeRoute;
begin
  indices.reset();

//  OutputDebugString(pchar('tradeRoute_getIndices->'));

  firstIdx := 0;
  idx := 1;

  first := ship^.TradingIndex;
  indices.firstShipIndex := first;
  
  if first <> $FFFF then
  begin
    tr := getTradeRoute(first);
    next := tr^.NextIndex;

    if (tr^.Flags and TRADE_ROUTE_FLAG__FIRST) = TRADE_ROUTE_FLAG__FIRST then
    begin
      firstIdx := idx;
      indices.firstShipIndex := first;
//      dbgStr('firstIdx=' + IntToStr(idx));
    end;

    Inc(idx);

    indices.add(first);

    while (next <> $FFFF) and (next <> first) do
    begin
      tr := getTradeRoute(next);

      if (tr^.Flags and TRADE_ROUTE_FLAG__FIRST) = TRADE_ROUTE_FLAG__FIRST then
      begin
        firstIdx := idx;
        indices.firstShipIndex := next;
//        dbgStr('firstIdx=' + IntToStr(next));
      end;

      indices.add(next);

      Inc(idx);

      next := tr^.NextIndex;
    end;
  end;

  if firstIdx > 1 then
    indices.reorder(firstIdx);

//  OutputDebugString(pchar('<-tradeRoute_getIndices'));

  Result := indices.Count;
end;


{ TTradeRouteIndices }

procedure TTradeRouteIndices.add(const index: word);
begin
//  OutputDebugString(pchar('index=' + inttostr(index)));
  if Count >= 20 then
    raise Exception.Create('Too may indices.');

  Inc(Count);
  Indices[Count] := index;
end;

function TTradeRouteIndices.getLastTRIndex: Word;
begin
  Result := getTRIndex(Count);
end;

function TTradeRouteIndices.getFirstRP: PTradeRoute;
begin
  Result := nil;

  if Count = 0 then
    exit;

  if firstShipIndex <= 0 then
    exit;

  Result := getTradeRoute(firstShipIndex);
end;

function TTradeRouteIndices.getTR(seq: integer): PTradeRoute;
begin
  Result := getTradeRoute(getTRIndex(seq));
end;

function TTradeRouteIndices.getTRIndex(seq: integer): Word;
begin
  Result := Indices[seq];
end;

function TTradeRouteIndices.has(TRID: integer): Boolean;
var
  i: integer;
begin
  if TRID <> $FFFF then
  begin
    for I := 1 to Count do
    begin
      if Indices[I] = TRID then
      begin
        Result := True;
        exit;
      end;
    end;
  end;

  Result := False;
end;

function  TTradeRouteIndices.firstFlagSeq(): integer;
var
  i: integer;
  rp: PTradeRoute;
begin
  Result := -1;
  if Count = 0 then
    exit;

  for I := 1 to Count do
  begin
    rp := getTR(i);
    if rp.isFirstFlagSet() then
    begin
      Result := i;
      exit;
    end;
  end;
end;

procedure TTradeRouteIndices.rechain;
var
  i, RPID: Integer;
  tr: PTradeRoute;
begin
  if Count = 0 then
    exit;

  if Count = 1 then
  begin
    RPID := getTRIndex(1);
    tr := getTradeRoute(RPID);
    tr.NextIndex := RPID;
    exit;
  end;

  for I := 1 to count - 1 do
  begin
    RPID := getTRIndex(i);
    tr := getTradeRoute(RPID);
    tr.NextIndex := getTRIndex(i+1);
  end;

  RPID := getLastTRIndex();
  tr := getTradeRoute(RPID);
  tr^.NextIndex := getTRIndex(1);
end;

procedure TTradeRouteIndices.remove(seq: integer; doRechain: boolean);
var
  i: integer;
begin
  if (seq <= 0) or (seq > Count) then
    exit;
    
  if seq = Count then
  begin
    Dec(Count);
    exit;
  end;
  
  for I := seq+1 to Count do
    Indices[I-1] := indices[I];

  Dec(Count);
    
  if doRechain then
    rechain();
end;

procedure TTradeRouteIndices.reorder(firstSeq: integer);
var
  i, idx: integer;
  temp: array[1..20] of Word;
begin
  if firstSeq = 1 then
    exit;

  idx := 1;

  for I := firstSeq to Count do
  begin
    temp[idx] := Indices[I];
    Inc(idx);
  end;

  for I := 1 to firstSeq - 1 do
  begin
    temp[idx] := Indices[I];
    Inc(idx);
  end;

  Move(temp[1], indices[1], sizeof(indices[1]) * Count);
end;

procedure TTradeRouteIndices.reset;
begin
  Count := 0;
  firstShipIndex := $FFFF;
end;

const
  P3__70C784 = $70c784 - P3_MODULE_BASE;

function  isFastForwarding(): Boolean;
var
  p: PLongWord;
begin
  p := ptrAdd(pointer(P3__70C784), P3ModuleHandle);
  Result := p^ <> 0;
end;

procedure setFastForwarding(const fastForward: Boolean);
var
  p: PLongWord;
begin
  p := ptrAdd(pointer(P3__70C784), P3ModuleHandle);
  if fastForward then
    p^ := 1
  else
    p^ := 0;
end;

const
  P3__CAPTAIN_TABLE_PPTR_OFFSET = $6DFB88 - P3_MODULE_BASE;

function  getCaptionInfo(const aCaptainIndex: Integer): PCaptainRec;
var
  p: Pointer;
begin
  p := PPointer(P3__CAPTAIN_TABLE_PPTR_OFFSET + P3ModuleHandle)^;
  Result := ptrAdd(p, aCaptainIndex * 16);
end;



function  getShipGroupFirstShipIndex(aGroupIndex: Word): Word;
var
  p6DFB90: PLongWord;
  eax, edx: Integer;
  pw: PWord;
begin
  p6DFB90 := ptrAdd(pointer(P3__6DFB90), P3ModuleHandle);
  edx := p6DFB90^;

  eax := aGroupIndex * 3 * 5;

  pw := pointer(edx + eax * 4 + $10);

  Result := pw^;
end;

//type
//  TGetShipGroupOtherShipFilterData = record
//    first: PP3R2Ship;
//    resultList: TList;
//  end;
//  PGetShipGroupOtherShipFilterData = ^TGetShipGroupOtherShipFilterData;

function GetShipGroupOtherShipFilter(ship: PP3R2Ship; data: Pointer): Boolean;
var
  first: PP3R2Ship;
begin
  Result := False;

  first := data;
//  if ship.Owner <> first.Owner then
//    exit;

  if ship.GroupIndex <> first.GroupIndex then
    exit;

//  if ship = first then
//    exit;

  Result := True;
end;

procedure getShipGroupShips(sg: PShipGroupInfo; shipList: TList);
var
  fship: PP3R2Ship;
  idx: integer;
begin
  fship := getShipByIndex(sg^.FirstShipIndex);
//  dbgPtr('shipPtr', fship);
  getShipListEx(fship^.Owner, shipList, GetShipGroupOtherShipFilter, fship);
  idx := shipList.IndexOf(fship);
  if idx > 0 then
    shipList.Exchange(0, idx);
end;

const
  P3__BUILD_SHIP_FUNC_OFFSET = $5F6840 - P3_MODULE_BASE;

function  buildShip(
        a1: Integer;
        shipType: Integer;
        cityCode: Byte;
        traderID: Integer): Boolean;
var
  f: longword;
  cityPtr: longword;
  r: byte;
//  arg1, arg2, arg3: integer;
begin
  f := longword(ptrAddI(P3__BUILD_SHIP_FUNC_OFFSET, P3ModuleHandle));
  cityPtr := longword(getCityPtr(cityCode));

//  arg1 := a1;
//  arg2 := shipType;
//  arg3 := cityCode;

  asm
    pushad
    push a1
    push shipType
    push traderID
    mov ecx, cityPtr
    mov eax, f
    call eax
    mov r, al
    popad
  end;

  Result := r <> 0;
end;


function  setCaptain(
        ship: PP3R2Ship;
        aCaptain: Word;
        aAge: byte;
        const expSailing, expTrade, expFight: byte;
        const aSalary: Word): Boolean;
var
  cnt: Word;
  captainInfo: PCaptainRec;
  pid: Byte;
begin
  Result := False;

  if aCaptain = $FFFF then
    exit;

  cnt := getAllocatedCaptainCount();
  if aCaptain >= cnt then
    exit;

  pid := getCurrPlayerID();

  captainInfo := getCaptionInfo(aCaptain);
  if (captainInfo^.Owner <> $FF) and (captainInfo^.Owner <> pid) then
    exit;

  if ship^.Captain = aCaptain then
  begin
    Result := True;
    exit;
  end;

  captainInfo^.birdthDay := getCurrTS() - (aAge * 365 shl 8);

  captainInfo^.exp_sailing := expSailing;
  captainInfo^.exp_trading := expTrade;
  captainInfo^.exp_fighting := expFight;

  captainInfo^.salaryInDay := aSalary;

  captainInfo^.Unknown2 := 0;
  captainInfo^.Owner := pid;

  ship^.Captain := aCaptain;
  
  Result := True;
end;

//function  getCityIconType(cityCode: Integer): TCityIconType;
//var
//  BO: PBusinessOffice;
//begin
//  BO := getBusinessOfficePtr(getCurrPlayerID(), cityCode);
//  if BO <> nil then
//    Result := CI__BLUE
//  else
//  begin
//        
//  end;       
//end;

function  playerHasBOIn(city: byte): Boolean;
begin
  Result := getBusinessOfficePtr(getCurrPlayerID(), city) <> nil;
end;

function  getHouseName(grade: Byte): WideString;
begin
  case grade of
    GRADE__RICH: Result := '商人房屋';
    GRADE__COMMON: Result := '石砌房屋';
  else
    Result := '木制房屋';
  end;
end;

{ TBusinessOffice }

function TBusinessOffice.getFactoryConsume(goodsID: Integer): longword;
begin
  Result := FactoryConsumes[goodsID];
end;

function TBusinessOffice.getFactoryProd(goodsID: Integer): longword;
begin
  Result := FactoryProductions[goodsID];
end;


function TBusinessOffice.getStoreHouseCount: Integer;
var
  idx: Smallint;
  build: PCityBuilding;
  city: PCityStruct;
begin
  Result := 0;

  if Word(FirstBusinessBuildingIndex) = $FFFF then
    Exit;

  city := getCityPtr(CityCode);

  idx := FirstBusinessBuildingIndex;
  while word(idx) <> $FFFF do
  begin
    build := getCityBuilding(city, idx);
    if build.BuildingType = BUILDING__STORE_HOUSE then
    begin
      Inc(Result);
    end;

    idx := build.NextIndex;
  end;
end;

function TBusinessOffice.getTradeOpType(goodsID: integer): TTradeOpType;
var
  p: integer;
begin
  p := BusinessPrices[goodsID];
//  q := BusinessLimits[goodsID];

  if p = 0 then
    Result := OT__Unspecified
  else if p > 0 then
    Result := OT__Sell
  else
    Result := OT__Buy;
end;

function TBusinessOffice.getTradePrice(goodsID: integer): Integer;
begin
  Result := BusinessPrices[goodsID];
  if Result < 0 then
    Result := -Result;
end;

function TBusinessOffice.getTradeQty(goodsID: integer): Integer;
begin
  Result := BusinessLimits[goodsID];
end;

var
  TradeShipLoadFlags: array[MIN_GOODS_ID..MAX_GOODS_ID] of Integer;

procedure initTradeShipLoadFlags();
var
  i, f: integer;
begin
  for I := MIN_GOODS_ID to MAX_GOODS_ID do
  begin
    f := 1 shl (i-1);
    TradeShipLoadFlags[i] := f;
  end;
end;

function TBusinessOffice.isTradeShipLoadRestricted(goodsID: integer): boolean;
var
  flag: PInteger;
  mask: integer;
begin
  flag := @ShipLoadStrictFlags[1];
  mask := TradeShipLoadFlags[goodsID];
  Result := (flag^ and mask) = mask;
end;

procedure TBusinessOffice.setTradeOpType(goodsID: integer;
  opType: TTradeOpType; const aPriceProv: IPriceProvider);
var
  p: integer;
begin
  p := BusinessPrices[goodsID];

  if opType = OT__Unspecified then
    p := 0
  else if opType = OT__Buy then
  begin
    if p = 0 then
      p := - aPriceProv.getPPrice(goodsID) 
    else if p > 0 then
      p := -p;
  end
  else
  begin
    if p = 0 then
      p := aPriceProv.getSPrice(goodsID)
    else if p < 0 then
      p := -p;
  end;

  BusinessPrices[goodsID] := p;
end;

procedure TBusinessOffice.setTradePrice(goodsID, price: integer);
var
  op: TTradeOpType; 
begin
  op := getTradeOpType(goodsID);

  if op = OT__Unspecified then
  begin
    BusinessPrices[goodsID] := price;
  end
  else if op = OT__Buy then
  begin
    if price > 0 then
      price := -price;

    BusinessPrices[goodsID] := price;
  end
  else
  begin
    if price < 0 then
      price := -price;

    BusinessPrices[goodsID] := price;
  end;
end;

procedure TBusinessOffice.setTradeQty(goodsID, qty: integer);
begin
  BusinessLimits[goodsID] := qty;
end;

procedure TBusinessOffice.setTradeShipLoadRestricted(goodsID: integer;
  restricted: Boolean);
var
  flag: PInteger;
  mask: integer;
begin
  flag := @ShipLoadStrictFlags[1];
  mask := TradeShipLoadFlags[goodsID];
  if restricted then
    flag^ := flag^ or mask
  else
    flag^ := flag^ and (not mask);
end;

{ TCityStruct }

//function TCityStruct.calcConsumeInDay(goodsID: integer;
//  const consultSeasonEffect: boolean): longword;
//begin
//  getResidentConsumeRateInWeek()
//end;

function TCityStruct.getCityShipWeapon(id: integer): integer;
begin
  Result := ShipWeapons[id];
end;

function TCityStruct.getCityShipWeaponStr(id: integer): string;
var
  q: integer;
begin
  q := getCityShipWeapon(id);
  if q = 0 then
    Result := ''
  else
    Result := formatCityShipWeaponQty(id, q);
end;

function TCityStruct.getCityWeapon(id: integer): integer;
begin
  Result := CityWeapon[id];
end;

function TCityStruct.getCityWeaponStr(id: integer): string;
var
  q: integer;
begin
  q := getCityWeapon(id);
  if q = 0 then
    Result := ''
  else
    Result := FormatFloat('0.0', q / CITY_WEAPON_WEIGH_FACTOR);
end;

function TCityStruct.getFactoryConsume(goodsID: integer): integer;
begin
  Result := GoodsConsumes[goodsID];
end;

function TCityStruct.getFactoryProd(goodsID: integer): integer;
begin
  Result := GoodsProduct[goodsID];
end;

function TCityStruct.getGoodsStore(goodsID: integer): LongWord;
begin
  Result := GoodsStore[goodsID];
end;

function TCityStruct.getGoodsStoreText(goodsID: integer): string;
var
  q: integer;
begin
  q := getGoodsStore(goodsID);
//  if q <> 0 then
  Result := formatQty(q, isGoodsMeasuredInPkg(goodsID))
//  else
//    Result := '';
end;

procedure TCityStruct.getSoldierCount(out cnt, training: integer);
var
  i: integer;
begin
  cnt := 0;
  training := 0;

  for I := SOLDIER_TYPE_0 to SOLDIER_TYPE_3 do
  begin
    Inc(cnt, Soldiers[i]);
    Inc(training, TrainingSoldiers[i]);
  end;
end;

function TCityStruct.isBranch: Boolean;
begin
  Result := CityTypeFlags and CITY_FLAG__BRANCH = CITY_FLAG__BRANCH;
end;

procedure TCityStruct.updateTotalAllowedSoldiers;
begin
  reCalcTotalAllowedSoldiers(@Self);
end;

function  updateShipGoodsLoad(ship: PP3R2Ship): integer;
var
  i: integer;
begin
  Result := 0;

  for I := MIN_GOODS_ID to MAX_GOODS_ID do
    inc(result, ship.Goods[I]);

  for I := 1 to 4 do
    Inc(Result, ship.cityWeapons[I]);

  ship.GoodsLoad := Result;
end;

{ TTraderInfoCache }

constructor TTraderInfoCache.Create;
begin
  //nop
  reset();
end;

function TTraderInfoCache.get(traderID: byte): PTraderInfo;
begin
  if not info[traderID].Ready then
    info[traderID].load();
  
  Result := @Info[traderID];
end;

procedure TTraderInfoCache.reset;
var
  i: Integer;
begin
  for I := MIN_TRADER_ID to MAX_TRADER - 1 do
  begin
    Info[I].reset(i);
  end;
end;

procedure TTraderInfoCache.traderShipCountChanged(trader: byte);
begin
  info[trader].traderShipCountChanged();
end;

{ TTraderInfo }

procedure TTraderInfo.load;
var
  city: integer;
  bo: PBusinessOffice;
begin
  BOCount := 0;

  for city := MIN_CITY_CODE to MAX_CITY_CODE do
  begin
    bo := getBusinessOfficePtr(traderID, city);
    if bo <> nil then
      Inc(BOCount); 
  end;

  ShipCount := getTraderShipCount(traderID);
  
  Ready := True;
end;

procedure TTraderInfo.prepare;
begin
  if not Ready then
    load(); 
end;

procedure TTraderInfo.reset(traderID: Byte);
begin
  Self.traderID := traderID;
  Ready := False;
end;

procedure TTraderInfo.traderShipCountChanged;
begin
  if not Ready then
    exit;

  ShipCount := getTraderShipCount(traderID);
end;

//function  tradeRoute_getOpType(p: PTradeRoute; index: integer): TTradeRouteOpType;
//var
//  price, q: integer;
//begin
//  price := p.Prices[index];
//  q := p.MaxQty[index];
//
//  if price =0 then
//  begin
//    if q < 0 then
//      Result :=
//  end;
//end;

{ TTradeRoute }

procedure TTradeRoute.clearFirstFlag;
begin
  Flags := Flags and (not TRADE_ROUTE_FLAG__FIRST);
end;

procedure TTradeRoute.clearFixFlag;
begin
  Flags := Flags and (not TRADE_ROUTE_FLAG__FIX);
end;

procedure TTradeRoute.clearNoStopFlag;
begin
  Flags := Flags and (not TRADE_ROUTE_FLAG__NO_STOP);
end;

function TTradeRoute.getMaxQty(index: Integer): Integer;
var
  p: integer;
begin
  Result := MaxQty[index];
  if Result < 0 then
    Result := -Result;
end;

function TTradeRoute.getOpType(index: integer): TTradeRouteOpType;
var
  p, q: integer;
begin
  q := MaxQty[index];
  if q = 0 then
  begin
    Result := RT__UNSPECIFIED;
    exit;
  end;
  
  p := Prices[index];

  if p = 0 then
  begin
    if q < 0 then
      Result := RT__PUT_INTO
    else 
      Result := RT__GET_OUT;
  end
  else
  begin
    if p < 0 then
      Result := RT__BUY
    else
      Result := RT__SELL;
  end;
end;

function TTradeRoute.getOpTypeStr(index: integer): WideString;
begin
  Result := tradeRoute_getOpTypeName(getOpType(index));
end;

function TTradeRoute.getPrice(index: Integer): Integer;
begin
  Result := Prices[index];
  if Result < 0 then
    Result := -Result;
end;

function TTradeRoute.isFirstFlagSet: Boolean;
begin
  Result := (Flags and TRADE_ROUTE_FLAG__FIRST) = TRADE_ROUTE_FLAG__FIRST;
end;

function TTradeRoute.isFixFlagSet: Boolean;
begin
  Result := (Flags and TRADE_ROUTE_FLAG__FIX) = TRADE_ROUTE_FLAG__FIX;
end;

function TTradeRoute.isNoStopFlagSet: Boolean;
begin
  Result := (Flags and TRADE_ROUTE_FLAG__NO_STOP) = TRADE_ROUTE_FLAG__NO_STOP;
end;

function TTradeRoute.IsUnlimitedQty(index: Integer): Boolean;
begin
  Result := getMaxQty(index) = TRADE_ROUTE__MAX_QTY;
end;

procedure TTradeRoute.setBuy(index, price, qty: integer);
begin
  if price > 0 then
    price := -price;

  Prices[index] := price;
  MaxQty[index] := qty;
end;

procedure TTradeRoute.setFirstFlag;
begin
  Flags := Flags or TRADE_ROUTE_FLAG__FIRST;
end;

procedure TTradeRoute.setFixFlag;
begin
  Flags := Flags or TRADE_ROUTE_FLAG__FIX;
end;

procedure TTradeRoute.setGetOut(index, qty: integer);
begin
  if qty < 0 then
    qty := -qty;
    
  Prices[index] := 0;
  MaxQty[index] := qty;
end;

procedure TTradeRoute.setNoOp(index: integer);
begin
  MaxQty[index] := 0;
  Prices[index] := 0;  
end;

procedure TTradeRoute.setNoStopFlag;
begin
  Flags := Flags or TRADE_ROUTE_FLAG__NO_STOP;
end;

procedure TTradeRoute.setPutInto(index, qty: integer);
begin
  if qty > 0 then
    qty := -qty;

  Prices[index] := 0;
  MaxQty[index] := qty;
end;

procedure TTradeRoute.setSell(index, price, qty: integer);
begin
  if price < 0 then
    price := -price;

  Prices[index] := price;
  MaxQty[index] := qty;
end;

function  getGeneralGoodsProdCost(gid: integer): Integer;
begin
  case gid of
    GOODSID__RICE: Result := 110;
    GOODSID__MEAT: Result := 957;
    GOODSID__FISH: Result := 440;
    GOODSID__BEER: Result := 34;

    GOODSID__SALT: Result := 28;
    GOODSID__HONEY: Result := 110;
    GOODSID__SPICE: Result := 279;
    GOODSID__WINE: Result := 220;

    GOODSID__CLOTH: Result := 206;
    GOODSID__ANIMAL_SKIN: Result := 676;
    GOODSID__WHALE_OIL: Result := 82;
    GOODSID__WOOD: Result := 55;

    GOODSID__TOOLS: Result := 255;
    GOODSID__LEATHER: Result := 224;
    GOODSID__WOOL: Result := 880;
    GOODSID__ASPHALT: Result := 55;

    GOODSID__IRON: Result := 880;
    GOODSID__HEMP: Result := 440;
    GOODSID__POTTERY: Result := 170;
    GOODSID__BRICK: Result := 79;

  else
    Result := 1;
  end;
end;

//var
//  msgToSend: string;
//
//procedure sendMsgToScreen(const s: string);
//var
//  func, str, obj: integer;
//begin
//  msgToSend := s;
//  func := $58AB30;
//  str := integer(pointer(msgToSend));
//  obj := $6ECFD8;
//
//  asm
//    pushad
//    push str
//    mov ecx, obj
//    mov eax, func
//    call eax
//    popad
//  end;
//end;


{ TShipGroupInfoCacheList }

constructor TShipGroupInfoCacheList.Create;
begin
  List := TObjectList.Create(True);
  Trader := $FF;
end;

destructor TShipGroupInfoCacheList.Destroy;
begin
  FreeAndNil(List);
  inherited;
end;

function TShipGroupInfoCacheList.findByFirstShip(
  p: PP3R2Ship): TShipGroupInfoCache;
var
  I: integer;
begin
  if trader <> p^.Owner then
  begin
    Trader := p^.Owner;
    prepare();
  end;

  for I := 0 to List.Count - 1 do
  begin
    Result := TShipGroupInfoCache(List[I]);
    if Result.FirstShip = p then
      exit;
//    if Result.ShipList.IndexOf((p)) >= 0 then
//      exit;
  end;

  Result := nil;
end;

//function TShipGroupInfoCacheList.get(index: integer): TShipGroupInfoCache;
//begin
//  if not Ready then
//    prepare();
//
//  Result := TShipGroupInfoCache(List[index]);
//end;
//
//function TShipGroupInfoCacheList.getCount: Integer;
//begin
//  if not Ready then
//    prepare();
//
//  Result := List.Count;
//end;

procedure TShipGroupInfoCacheList.prepare;
var
  i: integer;
  sg: PShipGroupInfo;
  tmpList: TList;
  cache: TShipGroupInfoCache;
  ship: PP3R2Ship;
begin
  List.Clear();

//  dbgStr('trader=' + byteToHexStr(Trader));

  tmpList := TList.Create();
  try
    getShipGroupList2(Trader, tmpList);

    for I := 0 to tmpList.Count - 1 do
    begin
      sg := tmpList[I];
      cache := TShipGroupInfoCache.Create(sg);
      List.Add(cache);
    end;
  finally
    tmpList.Destroy();
  end;
end;

procedure TShipGroupInfoCacheList.reset();
begin
  Trader := $FF;
  List.Clear();
end;

function TShipGroupInfoCacheList.shipCapacityChanged(ship: PP3R2Ship): Boolean;
var
  i: integer;
  cache: TShipGroupInfoCache;
begin
  Result := False;
  if ship.Owner <> Trader then
    exit;

  for I := 0 to List.Count - 1 do
  begin
    cache := TShipGroupInfoCache(List[I]);
    if cache.shipCapacityChanged(ship) then
      Result := True;
  end;
end;

function TShipGroupInfoCacheList.shipLoadingChanged(ship: PP3R2Ship): Boolean;
var
  i: integer;
  cache: TShipGroupInfoCache;
begin
  Result := False;
  if ship.Owner <> Trader then
    exit;

  for I := 0 to List.Count - 1 do
  begin
    cache := TShipGroupInfoCache(List[I]);
    if cache.shipLoadingChanged(ship) then
      Result := True;
  end;
end;

function TShipGroupInfoCacheList.shipSeaManChanged(ship: PP3R2Ship): Boolean;
var
  i: integer;
  cache: TShipGroupInfoCache;
begin
  Result := False;
  if ship.Owner <> Trader then
    exit;


  for I := 0 to List.Count - 1 do
  begin
    cache := TShipGroupInfoCache(List[I]);
    if cache.shipSeaManChanged(ship) then
      Result := True;
  end;
end;

function TShipGroupInfoCacheList.shipWeaponChanged(ship: PP3R2Ship): Boolean;
var
  i: integer;
  cache: TShipGroupInfoCache;
begin
  Result := False;
  
  if ship.Owner <> Trader then
    exit;
    
  for I := 0 to List.Count - 1 do
  begin
    cache := TShipGroupInfoCache(List[I]);
    if cache.shipWeaponChanged(ship) then
      Result := True;
  end;
end;

{ TShipGroupInfoCache }

constructor TShipGroupInfoCache.Create(sg: PShipGroupInfo);
var
  I, J, q: integer;
  ship: PP3R2Ship;
begin
  ShipList := TList.Create();

  ShipGroupInfo := sg;
  FirstShip := getShipByIndex(sg.FirstShipIndex);
  getShipGroupShips(ShipGroupInfo, ShipList);

  LoadingTotal := 0;
  ShipWeaponTotal := 0;

  for I := 0 to ShipList.Count - 1 do
  begin
    ship := ShipList[I];
    Inc(SeaManTotal, ship.Seaman);
    Inc(LoadingTotal, ship.WeaponLoad);
    Inc(ShipWeaponTotal, ship.Sword);

    for J := MIN_GOODS_ID to MAX_GOODS_ID do
    begin
      q := ship.Goods[J];
      LoadingTotal := LoadingTotal + q;
      GoodsLoading[J] := GoodsLoading[J] + q; 
    end;
  end;
end;

destructor TShipGroupInfoCache.Destroy;
begin
  FreeAndNil(ShipList);
  inherited;
end;

function  TShipGroupInfoCache.shipCapacityChanged(ship: PP3R2Ship): Boolean;
var
  i: integer;
  q: integer;
begin
  Result := False;
  if ShipList.IndexOf(ship) < 0 then
    exit;

  q := 0;

  for I := 0 to ShipList.Count - 1 do
  begin
    ship := ShipList[I];
    q := q + ship.GoodsLoad;
  end;

  ShipGroupInfo.Capacity := q;
  Result := True;
end;

function  TShipGroupInfoCache.shipLoadingChanged(ship: PP3R2Ship): Boolean;
var
  i, gid: integer;
  q: integer;
begin
  Result := False;
  if ShipList.IndexOf(ship) < 0 then
    exit;

  LoadingTotal := 0;

  for gid := MIN_GOODS_ID to MAX_GOODS_ID do
    GoodsLoading[gid] := 0;

  for I := 0 to ShipList.Count - 1 do
  begin
    ship := ShipList[I];
    inc(LoadingTotal, ship.WeaponLoad);
    
    for gid := MIN_GOODS_ID to MAX_GOODS_ID do
    begin
      q := ship.Goods[gid];
      GoodsLoading[gid] := goodsLoading[gid] + q;

      Inc(LoadingTotal, q);
    end;
  end;

  Result := True;
end;

function TShipGroupInfoCache.shipSeaManChanged(ship: PP3R2Ship): Boolean;
var
  i: integer;
begin
  Result := False;
  if ShipList.IndexOf(ship) < 0 then
    exit;

  SeaManTotal := 0;
  for I := 0 to ShipList.Count - 1 do
  begin
    ship := ShipList[I];
    Inc(SeaManTotal, ship.Seaman);
  end;
  Result := True;
end;

function TShipGroupInfoCache.shipWeaponChanged(ship: PP3R2Ship): Boolean;
var
  i: integer;
begin
  Result := False;
  if ShipList.IndexOf(ship) < 0 then
    exit;

  ShipWeaponTotal := 0;

  for I := 0 to ShipList.Count - 1 do
  begin
    ship := ShipList[I];
    Inc(ShipWeaponTotal, ship.Sword);
  end;

  Result := True;
end;

{ TP3R2Ship }

function TP3R2Ship.isInGroup: Boolean;
begin
  Result := GroupIndex <> $FFFF;
end;

function  getCityWeaponName(idx: integer): WideString;
begin
  case idx of
    CITY_WEAPON_1: Result := '刀';
    CITY_WEAPON_2: Result := '弓';
    CITY_WEAPON_3: Result := '强弓';
    CITY_WEAPON_4: Result := '枪';
  else
    Result := '?';
  end;
end;



function  formatCityWeaponQty(weigh: integer): string;
begin
  Result := IntToStr(weigh div CITY_WEAPON_WEIGH_FACTOR);
end;

function  getSwordName(): WideString;
begin
  Result := '剑';
end;


{ TCityBuildingDataCache }

constructor TCityBuildingDataCache.Create(city: Integer);
begin
  Self.city := city;
end;

procedure TCityBuildingDataCache.getCityGate_Artillery(out l1, l2: integer);
begin
  if not ready then
    prepare();

  l1 := l1CityGate_Artillery;
  l2 := l2CityGate_Artillery;
end;

function TCityBuildingDataCache.getHasMintage: Boolean;
begin
  if not ready then
    prepare();

  Result := HasMintage;
end;

function TCityBuildingDataCache.getHasSchool: Boolean;
begin
  if not ready then
    prepare();

  Result := HasSchool;
end;

function TCityBuildingDataCache.getLvl1WallCount: Integer;
begin
  if not ready then
    prepare();

  Result := Lvl1WallCount;
end;

function TCityBuildingDataCache.getLvl2WallCompleted: Integer;
begin
  if not ready then
    prepare();

  Result := Lvl2WallCompleted;
end;

function TCityBuildingDataCache.getLvl2WallCount: Integer;
begin
  if not ready then
    prepare();

  Result := Lvl2WallCount;
end;

function TCityBuildingDataCache.getLvl3WallCompleted: Integer;
begin
  if not ready then
    prepare();

  Result := Lvl3WallCompleted;
end;

function TCityBuildingDataCache.getLvl3WallCount: Integer;
begin
  if not ready then
    prepare();

  Result := Lvl3WallCount;
end;

function TCityBuildingDataCache.getMintageDaysToComplete: Integer;
begin
  if not ready then
    prepare();

  Result := MintageDaysToComplete;
end;

function TCityBuildingDataCache.getPaoSheCount: integer;
begin
  if not ready then
    prepare();
    
  Result := paoSheCount;
end;

function TCityBuildingDataCache.getSchoolDaysToComplete: Integer;
begin
  if not ready then
    prepare();

  Result := SchoolDaysToComplete;
end;

procedure TCityBuildingDataCache.getSeacoast_Artillery(out l1, l2: integer);
begin
  if not ready then
    prepare();

  l1 := l1Seacoast_Artillery;
  l2 := l2Seacoast_Artillery;
end;

procedure TCityBuildingDataCache.getWallInfo(out lvl1WallCount, lvl2WallCount,
  lvl2WallComplete, lvl3WallCount, lvl3WallCompleted: integer);
begin
  if not ready then
    prepare();

  lvl1WallCount := Self.Lvl1WallCount;
  lvl2WallCount := Self.Lvl2WallCount;
  lvl2WallComplete := Self.Lvl2WallCompleted;
  lvl3WallCount := Self.Lvl3WallCount;
  Lvl3WallCompleted := Self.Lvl3WallCompleted;
end;

procedure TCityBuildingDataCache.prepare;
var
  i: integer;
  cityPtr: PCityStruct;
  building: PCityBuilding;
begin
  cityPtr := getCityPtr(city);
  HasSchool := False;
  HasMintage := False;
  Lvl1WallCount := 0;
  Lvl2WallCount := 0;
  Lvl2WallCompleted := 0;
  Lvl3WallCount := 0;
  Lvl3WallCompleted := 0;
  l1CityGate_Artillery := 0;
  l2CityGate_Artillery := 0;
  l1Seacoast_Artillery := 0;
  l2Seacoast_Artillery := 0;
  paoSheCount := 0;

  for I := 0 to cityptr.BuildingCount - 1 do
  begin
    building := getCityBuilding(cityPtr, i);

    case building.BuildingType of
      BUILDING__SCHOOL:
      begin
        HasSchool := True;
        SchoolDaysToComplete := building.DaysNeedToComplete;
      end;

      BUILDING__MINTAGE:
      begin
        HasMintage := True;
        MintageDaysToComplete := building.DaysNeedToComplete;
      end;

      BUILDING__CITY_WALL:
      begin
        case building.Owner of
          CITY_BUILDING_OWNER__PUBLIC:
          begin
            Inc(Lvl1WallCount);
          end;

          CITY_BUILDING_OWNER__PUBLIC_LVL2_WALL:
          begin
            Inc(Lvl2WallCount);
            if building.DaysNeedToComplete = 0 then
              Inc(Lvl2WallCompleted);
          end;

          CITY_BUILDING_OWNER__PUBLIC_LVL3_WALL:
          begin
            Inc(Lvl3WallCount);
            if building.DaysNeedToComplete = 0 then
              Inc(Lvl3WallCompleted);
          end;
        end;
      end;

      BUILDING__CITY_GATE_ARTILLERY:
      begin
        if (building.CoordinateX <> $FF)
        and (building.CoordinateY <> $FF) then
          Inc(l1CityGate_Artillery);
      end;

      BUILDING__CITY_GATE_ARTILLERY_ADV:
      begin
        if (building.CoordinateX <> $FF)
        and (building.CoordinateY <> $FF) then
          Inc(l2CityGate_Artillery);
      end;

      BUILDING__SEACOAST_ARTILLERY:
      begin
        if (building.CoordinateX <> $FF) and (building.CoordinateY <> $FF) then
          Inc(l1Seacoast_Artillery);
      end;

      BUILDING__SEACOAST_ARTILLERY_ADV:
      begin
        if (building.CoordinateX <> $FF) and (building.CoordinateY <> $FF) then
          Inc(l2Seacoast_Artillery);
      end;

      BUILDING__PAO_SHE:
        if (building.CoordinateX <> $FF) and (building.CoordinateY <> $FF) then
          Inc(paoSheCount);
    end;
  end;

  ready := True;
end;

procedure TCityBuildingDataCache.reset;
begin
  ready := False;
end;

{ TCityBuildingCacheList }

constructor TCityBuildingCacheList.Create;
begin
  //nop
end;

destructor TCityBuildingCacheList.Destroy;
var
  i: integer;
begin
  for I := low(caches) to high(caches) do
  begin
    caches[i].Free();
  end;
    
  inherited;
end;

function TCityBuildingCacheList.get(city: integer): TCityBuildingDataCache;
begin
  Result := caches[city];
  if Result = nil then
  begin
    Result := TCityBuildingDataCache.Create(city);
    caches[city] := Result;
  end;
end;

procedure TCityBuildingCacheList.reset;
var
  i: integer;
  cache: TCityBuildingDataCache;
begin
  for I := low(caches) to high(caches) do
  begin
    cache := caches[i];
    if cache <> nil then
      cache.reset();
  end;
end;

{ TCelebrationGoods }

procedure TCelebrationGoods.get(city: integer);
var
  cityPtr: PCityStruct;
  f: double;
  temp: integer;
begin
  cityPtr := getCityPtr(city);

  f := cityPtr^.Pop_Total / 1000;

  rice := Ceil(f * 3) + 1;
  rice := rice * getGoodsQtyFactor(GOODSID__RICE);

  temp := Ceil(f * 2) + 1;
  meat := temp * getGoodsQtyFactor(GOODSID__MEAT);
  fish := temp * getGoodsQtyFactor(GOODSID__FISH);

  temp := Ceil(f * 20) + 1;
  wine := temp * getGoodsQtyFactor(GOODSID__WINE);
  beer := temp * getGoodsQtyFactor(GOODSID__BEER);

  honey := Ceil(f * 10) + 1;
  honey := honey * getGoodsQtyFactor(GOODSID__HONEY);
end;

const
  P3_DOCKYARD_EXP_LVL_TABLE_PTR = $6926A0 - P3_MODULE_BASE;

type
  TDockyearExpMiniStruct = packed record
    ExpReqs: array[SHIP_LVL0..SHIP_LVL3] of Word;
  end;
  PDockyearExpMiniStruct = ^TDockyearExpMiniStruct;


function  getDockyardExpRequirement(shipType, lvl: integer): Integer;
var
  p: PDockyearExpMiniStruct;
begin
  p := relocate(P3_DOCKYARD_EXP_LVL_TABLE_PTR);
  inc(p, shipType);

  Result := p^.ExpReqs[lvl];
  Result := Result * 7;
  Result := Result * 25;
  Result := Result shl 4;
end;

function  getBuildingTypeName(bt: byte): WideString;
begin
  case bt of
    BUILDING__WEAPON_SHOP: Result := '武器店';
    BUILDING__HUNTER_HOUSE: Result := '猎屋';
    BUILDING__PISCARY: Result := '捕鱼场';
    BUILDING__BEER_FACTORY: Result := '啤酒厂';
    BUILDING__TOOLS_FACTORY: Result := '工厂';
    BUILDING__APIARY: Result := '养蜂场';
    BUILDING__RICE_FIELD: Result := '稻田';
    BUILDING__COW_FARM: Result := '养牛场';
    BUILDING__LOGGING_CAMP: Result := '伐木场';
    BUILDING__TEXTILE_MILL: Result := '纺织厂';
    BUILDING__SALTERN: Result := '制盐厂';
    BUILDING__IRON_MILL: Result := '生铁厂';
    BUILDING__SHEEP_FARM: Result := '牧羊场';
    BUILDING__VINEYARD: Result := '葡萄园';
    BUILDING__CERAMIC_FACTORY: Result := '陶瓷厂';
    BUILDING__BRICKYARD: Result := '砖厂';
    BUILDING__ASPHALT_FACTORY: Result := '沥青厂';
    BUILDING__HEMP_FIELD: Result := '麻田';
    BUILDING__HOUSE_ADV_1: Result := getHouseName(GRADE__RICH) + '1';
    BUILDING__HOUSE_ADV_2: Result := getHouseName(GRADE__RICH) + '2';
    BUILDING__HOUSE_ADV_3: Result := getHouseName(GRADE__RICH) + '3';
    BUILDING__HOUSE_NOR_1: Result := getHouseName(GRADE__COMMON) + '1';
    BUILDING__HOUSE_NOR_2: Result := getHouseName(GRADE__COMMON) + '2';
    BUILDING__HOUSE_NOR_3: Result := getHouseName(GRADE__COMMON) + '3';
    BUILDING__HOUSE_SIM_1: Result := getHouseName(GRADE__POOR) + '1';
    BUILDING__HOUSE_SIM_2: Result := getHouseName(GRADE__POOR) + '2';
    BUILDING__HOUSE_SIM_3: Result := getHouseName(GRADE__POOR) + '3';
    BUILDING__STORE_HOUSE: Result := '仓库';
    BUILDING__CHURCH: Result := '教堂';
    BUILDING__CITY_HALL: Result := '市镇大厅';
    BUILDING__BARRACKS: Result := '兵营';
    BUILDING__CHAMBER_OF_COMMERCE: Result := '公会';
    BUILDING__MARKET: Result := '市场';
    BUILDING__BAR: Result := '酒馆';
    BUILDING__BANK: Result := '借贷所';
    BUILDING__BATH_HOUSE: Result := '澡堂';
    BUILDING__WELL: Result := '水井';
    BUILDING__HOSPITAL: Result := '医院';
    BUILDING__MINTAGE: Result := '铸币厂';
    BUILDING__SCHOOL: Result := '学校';
    BUILDING__CHAPEL: Result := '礼拜堂';
    BUILDING__STATUE: Result := '雕像';
    BUILDING__COAL_MINE: Result := '煤矿';
    BUILDING__SEACOAST_ARTILLERY: Result := '海岸炮';
    BUILDING__SEACOAST_ARTILLERY_ADV: Result := '高级海岸炮';
    BUILDING__CITY_GATE_ARTILLERY: Result := '城门炮';
    BUILDING__CITY_GATE_ARTILLERY_ADV: Result := '高级城门炮';
    BUILDING__PAO_SHE: Result := '抛射';
    BUILDING__CITY_WALL: Result := '城墙';
  else
    Result := byteToHexStr(bt);
  end;

//  dbgStr('input' + byteToHexStr(bt) + ', result=' + Result);
end;

function  getBOListPtr(): Pointer;
begin
  Result := relocate(P3__71CDA8 + $74);
  Result := PPointer(Result)^;
end;

function  getBOByIndex(index: Word): PBusinessOffice;
begin
  Result := getBOListPtr();
  Inc(Result, index);
end;

const
//  P3__GET_FREE_CAPTAIN_PROC = $5EA750 - P3_MODULE_BASE;
  P3__GET_FREE_CAPTAIN_PROC = $5EAF20 - P3_MODULE_BASE;

//return $FFFF for not available
function  getFreeCaptain(cityPtr: PCityStruct): Word;
var
  proc: cardinal;
  pid: Integer;
begin
  {$O-}
  Result := 0;

  proc := cardinal(relocate(P3__GET_FREE_CAPTAIN_PROC));
  pid := getCurrPlayerID();

  asm
    pushad
    mov ecx, cityptr
    mov eax, proc
    push pid
    call eax
    mov result, ax
    popad
  end;

  {$O+}
end;

function  formatCaptainAbility(cap: PCaptainRec): WideString;
begin
  Result := IntToStr(cap.exp_trading div 50)
          + ',' + IntToStr(cap.exp_sailing div 50)
          + ',' + IntToStr(cap.exp_fighting div 50);
end;

function getBOImportRec(boIndex: Word): PBOImportRec;
var
  pp: PPointer;
  pb: PByte;
begin
  pp := relocate(P3__71CDA8 + $70);
  pb := pp^;
  Inc(pb, boIndex * 20);
  Result := pointer(pb);
end;


{ TCaptainRec }

function TCaptainRec.getBOManagerTradingExpLvl: Integer;
begin
  Result := exp_trading div 43;
end;

initialization
//  loadCityCodes();
  initTradeShipLoadFlags();
  initGOODS_QTY_FACTORS();
  initDaysRecList();
  initShipColorTable();
  InitHotkeyList();
  {$IFNDEF P3INSIGHT}
  initVars();
  {$ENDIF}



end.

