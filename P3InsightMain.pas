unit P3InsightMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, ActiveX, p3insight_common, VirtualTrees, Buttons,
  ImgList, jpeg, Contnrs, p3DataStruct, JvTabBar, JvPageList, JvExControls,
  Menus, GR32_Image, JvXPCore, JvXPContainer, GR32, PngImage, GR32_Filters,
  p3Maps, p3Types, ButtonGroup, CategoryButtons, JvComponentBase, JvWavePlayer,
  BcDrawModule, BcXPMenuDrawModule, BarMenus, ActnList, Spin, Mask, JvExMask,
  JvSpin;

const
  UM__CLOSE = WM_USER + 100;


type
  TMsgType = (
    MT__INFO,
    MT__WARNING,
    MT__ERROR
  );
  
  TfrmP3Insight = class;
  TViewerType = (
    GLOBAL_VIEWER,
    CITY_LIST_VIWEER,
    CITY_DETAIL_VIEWER,
    SHIP_LIST_VIEWER,
    TRADER_LIST_VIEWER,
    AREA_VIEWER,

    MAP_VIEWER
  );

  {
    增加1个Viewer时，要修改：
    1，TViewerList.create
    2, TViewerList.add
    3, TfrmP3Insight.Create
    4, TfrmP3Insight.PageControlMainChange()
  }
  
//  TPropSubViewType = (
//    SUBVIEW_NONE,
//    SUBVIEW_RESIDENT
//  );

  TViewer = class
  protected
    procedure DefaultGridShortenString(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      const S: WideString; TextSpace: Integer; RightToLeft: Boolean;
      var Result: WideString; var Done: Boolean);
    procedure initGrid(aVT: TVirtualStringTree);
    procedure cancelEdit(aVT: TBaseVirtualTree);
    procedure internalPrepare();  virtual; abstract;
    procedure internalUpdate; virtual; abstract;
    procedure internalReset();  virtual; abstract;
    function  getColTagOf(aVT: TVirtualStringTree; const col: Integer): Integer;
  public
    frm: TfrmP3Insight;
    prepared: Boolean;

    constructor Create(aForm: TfrmP3Insight); virtual;

    class function  getViewerType(): TViewerType; virtual; abstract;
    procedure init();  virtual; abstract;
    procedure reset();

    procedure prepare();  virtual;
    procedure update();
    procedure cancelEdits(); virtual; abstract;
    procedure deactivate();  virtual; abstract;
    procedure activePrimaryViewerChanged();  virtual;
//    function  acceptPropSubView(aSubView: TPropSubViewType): Boolean;  virtual;
    function  getRecCount(): Integer; virtual;
  end;

  TViewerList = class
  public
    List: TObjectList;

    GlobalViewer: TViewer;
    TraderViewer: TViewer;
    CityDetailViewer: TViewer;
    ShipListViewer: TViewer;
    CityListViewer: TViewer;
    AreaViewer: TViewer;
    MapViewer: TViewer;

    ActivePrimaryViewer: TViewer;

    ActiveViewerList: TList;

    constructor Create(aForm: TfrmP3Insight);
    destructor Destroy; override;

    procedure add(aView: TViewer);

    function  getCount(): Integer;
    function  get(const aIndex: Integer): TViewer;

    function  getActiveCount(): Integer;
    function  getActive(const aIndex: Integer): TViewer;
    procedure setActivePrimaryViewer(aViewer: TViewer);
    function  getViewerByType(viewerType: TViewerType): TViewer;


    procedure initAll();
    procedure resetAll();
    procedure deactivateAll();
    procedure cancelEditAll();
    procedure updateAllActive();
    procedure activePrimaryViewerChanged();
  end;

  ITradeRouteSelectClient = interface
  ['{EB85C0CE-6500-434D-928A-F21D4207CDA5}']
    function  isLoad(): Boolean;
    function  getCallerRect(): TRect;

    procedure onOk(aSelected: TCustomTradeRoute);
    procedure onCancel();
  end;

  TGoodsImageProviderImpl = class(TGoodsImageProvider)
  public
    frm: TfrmP3Insight;
    ready: Boolean;
    bitmaps: array[MIN_GOODS_ID..MAX_GOODS_ID] of TBitmap;


    constructor Create(frm: TfrmP3Insight);
    destructor Destroy; override;
    procedure prepare();
    function  get(const aGoodsID: Integer): HDC; override;
    function  rect(): TRect;  override;
  end;

  TSelectTradeRouteCategoryItem = class
  public
    Category: WideString;
    Others: Boolean;
  end;

  TfrmP3Insight = class(TForm,
          IP3GameStateListener,
          IMapViewerInfoProvider,
          IPriceProvider,
          IP3DateUpdateListener)
    HeadingPanel: TPanel;
    lblDate: TStaticText;
    StatusBar: TStatusBar;
    btnPlayer: TButton;
    btnClose: TBitBtn;
    ilMeasureUnit: TImageList;
    il20x20: TImageList;
    pnlClient: TPanel;
    PageControlMain: TPageControl;
    tabTraderList: TTabSheet;
    ilEmote5: TImage;
    ilEmote1: TImage;
    ilEmote6: TImage;
    ilEmote2: TImage;
    ilEmote3: TImage;
    ilEmote4: TImage;
    btnHomeCity: TButton;
    lblPlayerCash: TLabel;
    Image9: TImage;
    tabShipList: TTabSheet;
    Panel5: TPanel;
    Label2: TLabel;
    btnShipList_PrevTrader: TButton;
    cbShipList_Trader: TComboBox;
    btnShipList_NextTrader: TButton;
    StaticText1: TStaticText;
    rbShipList_StateAll: TRadioButton;
    rbShipList_StateTrading: TRadioButton;
    rbShipList_StateFree: TRadioButton;
    rbShipList_StateFix: TRadioButton;
    rbShipList_StateBuilding: TRadioButton;
    ShipListGrid: TVirtualStringTree;
    Panel6: TPanel;
    tabbarShipListArea: TJvTabBar;
    tabbarShipList_ViewType: TJvTabBar;
    tabCityDetail: TTabSheet;
    pcCityDetail: TPageControl;
    tabCityDetail_CityInfo: TTabSheet;
    CityDetailGrid: TVirtualStringTree;
    tabCityDetail_Dockyard: TTabSheet;
    tabCityDetail_Building: TTabSheet;
    Panel2: TPanel;
    Label3: TLabel;
    Bevel5: TBevel;
    Bevel6: TBevel;
    btnCityDetail_NextCity: TButton;
    btnCityDetail_PrevCity: TButton;
    cbCityDetail_City: TComboBox;
    cbCityDetail_BOCombineTraderValue: TCheckBox;
    TraderListGrid: TVirtualStringTree;
    btnKillProcess: TButton;
    Label1: TLabel;
    cbCityDetail_Trader: TComboBox;
    btnCityDetail_PrevTrader: TButton;
    btnCityDetail_NextTrader: TButton;
    il16x16: TImageList;
    ilShipStuff: TImageList;
    tabCityList: TTabSheet;
    CityListGrid: TVirtualStringTree;
    Panel7: TPanel;
    cityListViewModeTabBar: TJvTabBar;
    msgTimer: TTimer;
    tabMap: TTabSheet;
    MapContainer: TJvXPContainer;
    Map: TImage32;
    JvXPContainer1: TJvXPContainer;
    JvWavePlayer1: TJvWavePlayer;
    pcMapViewCtrl: TPageControl;
    tabMapCtrl_TradeRoute: TTabSheet;
    tabMapCtrl_ViewOpt: TTabSheet;
    cbMap_drawCityName: TCheckBox;
    pnlMap_DrawGoodsOptions: TPanel;
    sbMap_ShowGoods_Rice: TSpeedButton;
    sbMap_ShowGoods_Meat: TSpeedButton;
    sbMap_ShowGoods_Cloth: TSpeedButton;
    sbMap_ShowGoods_Honey: TSpeedButton;
    sbMap_ShowGoods_WhaleOil: TSpeedButton;
    sbMap_ShowGoods_Hemp: TSpeedButton;
    sbMap_ShowGoods_Wood: TSpeedButton;
    sbMap_ShowGoods_Beer: TSpeedButton;
    sbMap_ShowGoods_Leather: TSpeedButton;
    sbMap_ShowGoods_Wine: TSpeedButton;
    sbMap_ShowGoods_AnimalSkin: TSpeedButton;
    sbMap_ShowGoods_Pottery: TSpeedButton;
    sbMap_ShowGoods_Tools: TSpeedButton;
    sbMap_ShowGoods_Spice: TSpeedButton;
    sbMap_ShowGoods_Salt: TSpeedButton;
    sbMap_ShowGoods_Wool: TSpeedButton;
    sbMap_ShowGoods_Fish: TSpeedButton;
    sbMap_ShowGoods_Brick: TSpeedButton;
    sbMap_ShowGoods_Iron: TSpeedButton;
    sbMap_ShowGoods_Asphalt: TSpeedButton;
    Label5: TLabel;
    sbMap_ShowGoods_Clear: TSpeedButton;
    Timer1: TTimer;
    Panel8: TPanel;
    lblMap_SelectedShipName: TLabel;
    tabMapCtrl_ShipGroup: TTabSheet;
    MapShipGroupSelectGrid: TVirtualStringTree;
    Panel9: TPanel;
    Label6: TLabel;
    edMap_ShipGroupSelect_Name: TEdit;
    sbMap_ClearShipGroupSelectName: TSpeedButton;
    Map_TradeRouteGoodsGrid: TVirtualStringTree;
    Map_TradeRouteCityGrid: TVirtualStringTree;
    cbMap_SelectedShipGroupIsTrading: TCheckBox;
    numBmpList: TBitmap32List;
    pnlLoadTradeRoute: TPanel;
    pmTradeRouteCityGrid: TBcBarPopupMenu;
    DrawModule: TBcXPMenuDrawModule;
    miMap_TRCityGrid_AddCity: TMenuItem;
    miMap_TRCityGrid_RemoveCity: TMenuItem;
    pmTradeRouteGoodsGrid: TBcBarPopupMenu;
    miMap_TRGoods_LoadPriceToSelected: TMenuItem;
    miMap_TRGoods_LoadPriceToAll: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    miMap_TRGoods_OpNONE: TMenuItem;
    miMap_TRGoods_Buy: TMenuItem;
    miMap_TRGoods_Sell: TMenuItem;
    miMap_TRGoods_PutInto: TMenuItem;
    miMap_TRGoods_GetOut: TMenuItem;
    N10: TMenuItem;
    N01: TMenuItem;
    ilTradeButtons: TImageList;
    miMap_TRGoods_AllBuy: TMenuItem;
    miMap_TRGoods_AllSell: TMenuItem;
    miMap_TRGoods_AllPutInto: TMenuItem;
    miMap_TRGoods_AllGetOut: TMenuItem;
    miMap_TRGoods_AllNone: TMenuItem;
    ActionList1: TActionList;
    acClose: TAction;
    tabCityDetail_BO: TTabSheet;
    tabArea: TTabSheet;
    GroupBox1: TGroupBox;
    Config_AreaGrid: TVirtualStringTree;
    Config_AreaCityGrid: TVirtualStringTree;
    rbShipList_StateNonTrading: TRadioButton;
    StaticText2: TLabel;
    StaticText3: TLabel;
    Panel1: TPanel;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    pmBO: TBcBarPopupMenu;
    miBO_Mod_BuildShipMaterialAdd100: TMenuItem;
    miBOModItems: TMenuItem;
    miBO_Mod_ConstructionMaterialAdd100: TMenuItem;
    N13: TMenuItem;
    miBO_Mod_EnsureCelebrationGoods: TMenuItem;
    N14: TMenuItem;
    miBO_Mod_GoodsAdd300: TMenuItem;
    N15: TMenuItem;
    miBO_Mod_ShipWeaponAdd100: TMenuItem;
    miBO_Mod_CityWeaponAdd100: TMenuItem;
    miBO_Mod_SetSwordTo100: TMenuItem;
    cbCityList_Goods_ShowStore: TCheckBox;
    cbCityList_Goods_ShowConsume: TCheckBox;
    cbCityList_Goods_ShowProd: TCheckBox;
    cbCityList_Goods_ShowBPrice: TCheckBox;
    cbCityList_Goods_ShowSPrice: TCheckBox;
    cbCityList_Goods_3Bao: TCheckBox;
    cbCityList_Goods_7Xian: TCheckBox;
    cbCityList_Goods_6Cao: TCheckBox;
    cbCityList_Goods_Others: TCheckBox;
    cbCityList_Goods_RawMaterial: TCheckBox;
    Label8: TLabel;
    lblCityDetail_DockyardExp: TLabel;
    GroupBox2: TGroupBox;
    Label10: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    lblCityDetail_Dockyard_ShinaikeNextLvlExpReq: TLabel;
    Label15: TLabel;
    lblCityDetail_Dockyard_KeleierNextLvlExpReq: TLabel;
    Label17: TLabel;
    lblCityDetail_Dockyard_KegeNextLvlExpReq: TLabel;
    Label19: TLabel;
    lblCityDetail_Dockyard_HuoerkeLvlExpReq: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    CityDetail_Dockyard_BuildingShipGrid: TVirtualStringTree;
    GroupBox3: TGroupBox;
    Label23: TLabel;
    Panel10: TPanel;
    Bevel4: TBevel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Image2: TImage;
    lblTraderBOPopRich: TLabel;
    Image3: TImage;
    lblTraderBOPopCommon: TLabel;
    Image4: TImage;
    lblTraderBOPoor: TLabel;
    Image5: TImage;
    lblTraderBOPopBeggar: TLabel;
    Label4: TLabel;
    lblTraderBOPopTotal: TLabel;
    pbTraderList_SatisfyRich: TPaintBox;
    pbTraderList_SatisfyCommon: TPaintBox;
    pbTraderList_SatisfyPoor: TPaintBox;
    lblTraderList_SatisfyRich: TLabel;
    lblTraderList_SatisfyCommon: TLabel;
    lblTraderList_SatisfyPoor: TLabel;
    Image6: TImage;
    lblTraderList_HouseCapRich: TLabel;
    Image7: TImage;
    lblTraderList_HouseCapCommon: TLabel;
    Image8: TImage;
    lblTraderList_HouseCapPoor: TLabel;
    gbCityDetail_Popularity: TGroupBox;
    Label7: TLabel;
    lblCityDetail_Popularity_Construction: TLabel;
    Label9: TLabel;
    lblCityDetail_Popularity_Public: TLabel;
    Label11: TLabel;
    lblCityDetail_Popularity_Trade: TLabel;
    Label24: TLabel;
    Bevel7: TBevel;
    Label25: TLabel;
    btnCityDetail_Dockyard_Booking: TButton;
    Bevel8: TBevel;
    rgCityDetail_Dockyard_BookingShipType: TRadioGroup;
    imgCityDetail_Dockyard_ShipLvlIcon1: TImage32;
    imgCityDetail_Dockyard_ShipLvlIcon2: TImage32;
    imgCityDetail_Dockyard_ShipLvlIcon3: TImage32;
    imgCityDetail_Dockyard_ShipLvlIcon4: TImage32;
    Label16: TLabel;
    cbCityDetail_Dockyard_Booker: TComboBox;
    pmCityDetail_Dockyard_BuildingShipGrid: TBcBarPopupMenu;
    miCityDetail_Dockyard_SetShipCompleteNow: TMenuItem;
    pmCityListGrid: TBcBarPopupMenu;
    miCityListGridModItems: TMenuItem;
    miCityList_AddGoodsSatisfy1Week: TMenuItem;
    miCityList_ClearGoods: TMenuItem;
    miCityList_SetGoodsSatisfy1Week: TMenuItem;
    N17: TMenuItem;
    miCityList_BeggerAdd50: TMenuItem;
    N18: TMenuItem;
    miCityList_CompleteFacility: TMenuItem;
    miCityList_CompletePlayerBuilding: TMenuItem;
    pcCityDetail_BO: TPageControl;
    tabBO_Goods: TTabSheet;
    CityDetail_BOGrid: TVirtualStringTree;
    TabSheet1: TTabSheet;
    Label18: TLabel;
    CityDetail_BO_WeaponStore: TVirtualStringTree;
    Panel3: TPanel;
    Label20: TLabel;
    lblCityDetail_BO_Manager: TLabel;
    Label26: TLabel;
    lblCityDetail_BO_Guard: TLabel;
    Label27: TLabel;
    lblCityDetail_BO_Workers: TLabel;
    N19: TMenuItem;
    miCityList_TreasuryAdd: TMenuItem;
    miCityList_TreasurySetTo: TMenuItem;
    CityDetail_BuildingGrid: TVirtualStringTree;
    btnCityDetail_Building_Refresh: TButton;
    GroupBox4: TGroupBox;
    AreaSupplyGrid: TVirtualStringTree;
    cbArea_ExclStoreWhenCalcRemains: TCheckBox;
    lblArea_CalcRemainPeriod: TLabel;
    seCityDetail_Dockyard_BookingQty: TJvSpinEdit;
    seArea_CalcRemainPeriod: TJvSpinEdit;
    N20: TMenuItem;
    miCityList_SoldierRestrictAdd: TMenuItem;
    miCityList_Soldier0Add: TMenuItem;
    miCityList_Soldier1Add: TMenuItem;
    miCityList_Soldier2Add: TMenuItem;
    miCityList_Soldier3Add: TMenuItem;
    miCityList_AllSoldierAdd: TMenuItem;
    Label28: TLabel;
    cbMap_ShipGroupSelect_Area: TComboBox;
    Label29: TLabel;
    sbMap_SelectPrevShip: TSpeedButton;
    sbMap_SelectNextShip: TSpeedButton;
    pnlLoadTradeRouteHeading: TPanel;
    btnCloseTradeRouteSelectPanel: TBitBtn;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    TradeRouteSelectGrid: TVirtualStringTree;
    btnLoadSelectedTradeRoute: TButton;
    btnTradeRouteSelectCancel: TButton;
    pmShipListGrid: TBcBarPopupMenu;
    miShipListGridPM_SetAreaItems: TMenuItem;
    miShipListGridPM_RenameShipByCityNameItems: TMenuItem;
    miShipListModItems: TMenuItem;
    miShipListGridPM_Mod_CityWeaponAdd300: TMenuItem;
    N22: TMenuItem;
    miShipListGridPM_Mod_MaxShiQi: TMenuItem;
    miShipListGridPM_Mod_SeamanAdd20: TMenuItem;
    miShipListGridPM_Mod_FullPower: TMenuItem;
    N25: TMenuItem;
    miShipListGridPM_Mod_AssignCaptain: TMenuItem;
    N27: TMenuItem;
    miShipListGridPM_Mod_SetGoodsTo45000: TMenuItem;
    miShipListGridPM_Mod_GoodsQtyX10: TMenuItem;
    N28: TMenuItem;
    miShipListGridPM_Mod_SetCapacityTo990000: TMenuItem;
    miShipListGridPM_Mod_SetCapacityTo3500: TMenuItem;
    N29: TMenuItem;
    miShipListGridPM_Mod_RestoreCurrPoints: TMenuItem;
    miShipListGridPM_Mod_SetPointsTo10000000: TMenuItem;
    pmPlayerCash: TBcBarPopupMenu;
    miPlayerCashModItems: TMenuItem;
    miSetPlayerMoneyX10: TMenuItem;
    miSetPlayerMoneyX100: TMenuItem;
    SelectTradeRouteCategoriesGrid: TVirtualStringTree;
    N1: TMenuItem;
    miMap_LoadTradeRoutes: TMenuItem;
    miMap_SaveTradeRoutes: TMenuItem;
    sbSelectTradeRouteCategoriesGridAdd: TSpeedButton;
    sbSelectTradeRouteCategoriesGridRemove: TSpeedButton;
    Panel4: TPanel;
    sbTradeRouteSelectGridAdd: TSpeedButton;
    sbTradeRouteSelectGridRemove: TSpeedButton;
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnPlayerClick(Sender: TObject);
    procedure btnHomeCityClick(Sender: TObject);
    procedure PageControlMainChange(Sender: TObject);
    procedure btnKillProcessClick(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
    procedure msgTimerTimer(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure HeadingPanelDblClick(Sender: TObject);
    procedure acCloseExecute(Sender: TObject);
    procedure StatusBarDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
      const Rect: TRect);
    procedure sbMap_ClearShipGroupSelectNameClick(Sender: TObject);
    procedure btnCloseTradeRouteSelectPanelClick(Sender: TObject);
    procedure btnTradeRouteSelectCancelClick(Sender: TObject);
    procedure TradeRouteSelectGridGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure TradeRouteSelectGridNewText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; NewText: WideString);
    procedure SelectTradeRouteCategoriesGridGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure SelectTradeRouteCategoriesGridNewText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; NewText: WideString);
    procedure SelectTradeRouteCategoriesGridFocusChanged(
      Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure btnLoadSelectedTradeRouteClick(Sender: TObject);
    procedure SelectTradeRouteCategoriesGridFreeNode(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure sbTradeRouteSelectGridAddClick(Sender: TObject);
    procedure sbTradeRouteSelectGridRemoveClick(Sender: TObject);
    procedure sbSelectTradeRouteCategoriesGridAddClick(Sender: TObject);
    procedure sbSelectTradeRouteCategoriesGridRemoveClick(Sender: TObject);
    procedure SelectTradeRouteCategoriesGridDragOver(Sender: TBaseVirtualTree;
      Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint;
      Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
    procedure SelectTradeRouteCategoriesGridDragDrop(Sender: TBaseVirtualTree;
      Source: TObject; DataObject: IDataObject; Formats: TFormatArray;
      Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
    procedure TradeRouteSelectGridDblClick(Sender: TObject);
    procedure TradeRouteSelectGridChange(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
  private
    procedure clearMsgSB();
    procedure reloadTradeRouteSelectGrid();
  private
    { IPriceProvider }
    function  getPPrice(goodsID: integer): Integer;
    function  getSPrice(goodsID: integer): Integer;
  private
    { IP3GameStateListener }
    procedure onExitGame();
  private
    { IP3DateUpdateListener }
    procedure onNewDate(y, m, d: integer);
  private
    { IMapViewerInfoProvider }
    function  getResidentConsumePrecalc(): TResidentConsumePrecalc;
    function  getBO(const pid, city: integer): PBusinessOffice;
  private
    procedure OnUM__CLOSE(var aMsg: TMessage); message UM__CLOSE;
  private
    fViewList: TViewerList;
    fInternalUpdate: Integer;
    fGoodsImageProv: TGoodsImageProvider;
    fMsgType: TMsgType;

    procedure initUI();
    procedure cancelEdits();

    procedure resetStructures();
    procedure onDlgDeactivate();
  protected
    procedure CreateParams(var aParams: TCreateParams); override;
    procedure WndProc(var Message: TMessage); override;
  public
    { Viewer的 在init() 函数不能访问这些数据！ }
    initialized: Boolean;
    currPlayer: Byte;
    currPlayerHomeCity: Byte;
    currCity: Byte;
    currCityPtr: pCityStruct;
    currBO: PBusinessOffice;
    cityBODataCacheList: TCityBODataCacheList;
    residentConsumePrecalc: TResidentConsumePrecalc;
    winter: Boolean;
    AreaDef: TAreaDefImpl;
    allCityShipList: TAllCityShipList;
    houseCapInfo: THouseCapacityInfo;
    traderInfoCache: TTraderInfoCache;
    captainSetuped: Boolean;
    shipGroupInfoCacheList: TShipGroupInfoCacheList;
    cityBuildingCacheList: TCityBuildingCacheList;
    areaDataCache: TAreaDataCache;
  private
    _currPlayerShipListReady: Boolean;
    _currPlayerShipList: TList;
  public
    bluePen: HPEN;
    gridSelectBkClrBrush: HBRUSH;
    gridOddBkClrBrush: HBRUSH;
    mouseClipped: Boolean;
    tradeRouteSelectClient: ITradeRouteSelectClient;
    tradeRouteSelectOverwritePrompted: Boolean;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure prepare();

    procedure beginInternalUpdate();
    procedure endInternalUpdate();
    function  isInternalUpdating(): Boolean;

    procedure updateUI();

    function  mapSatisfyEmotes(const aSatisfy: Smallint): TImage;

    procedure setCurrView(const aPlayerID, aCity: Byte);

    function  getActivePrimaryViewer(): TViewer;
    procedure activePrimaryViewerChanged();
    function  getCurrPlayerShipList(): TList;

    procedure showMsg(const aMsgType: TMsgType; const aMsg: WideString);
    procedure updateSB_recCount(cnt: integer);
    procedure recCountChanged();

    procedure showTradeRouteSelectPanel();
    procedure closeTradeRouteSelectPanel();

    property  GoodsImageProv: TGoodsImageProvider read fGoodsImageProv;
  end;

  TGlobalViewer = class(TViewer)
  private
    procedure OnMISetPlayerMoneyX10Click(sender: TObject);  
  protected
    procedure internalPrepare();  override;
    procedure internalReset();  override;
    procedure internalUpdate();  override;
  public
    class function  getViewerType(): TViewerType; override;

    procedure init();  override;
    procedure cancelEdits(); override;
    procedure deactivate();  override;
  end;

//  TPropViewer = class(TViewer)
//  private
//    procedure drawEmote(pb: TPaintBox; aSatisfy: Smallint);
//  private
//    procedure pbTraderList_SatisfyRichPaint(Sender: TObject);
//    procedure pbTraderList_SatisfyCommonPaint(Sender: TObject);
//    procedure pbTraderList_SatisfyPoorPaint(Sender: TObject);
//
//    procedure btnPropPanelFoldingClick(Sender: TObject);
//  private
//    procedure setPropPanelFold(const aFold: Boolean);
//  protected
//    procedure internalPrepare();  override;
//    procedure internalReset();  override;
//    procedure internalUpdate();  override;
//  public
//    class function  getViewerType(): TViewerType; override;
//
//    procedure init();  override;
//    procedure cancelEdits(); override;
//    procedure deactivate();  override;
//    procedure activePrimaryViewerChanged();  override;
//  end;

  TTraderListViewer = class(TViewer)
  private
    procedure TraderListGridGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);

    procedure TraderListGridBeforeItemErase(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect;
      var ItemColor: TColor; var EraseAction: TItemEraseAction);
      
  private
    procedure reloadTraderListDataIntoView();

    function  findTraderListNode(const playerID: Byte): PVirtualNode;
  protected
    procedure internalPrepare(); override;
    procedure internalReset();  override;
    procedure internalUpdate();  override;
  public
    class function  getViewerType(): TViewerType; override;
    procedure init();  override;
    procedure cancelEdits(); override;
    procedure deactivate();  override;
//    function  acceptPropSubView(aSubView: TPropSubViewType): Boolean;  override;
    function  getRecCount(): Integer; override;
  end;

  TCityDetaiViewer = class(TViewer)
  public const

    BOTAG__GOODS_NAME = 1;
    BOTAG__MEASURE_UNIT = 2;
    BOTAG__BO_STORE = 3;
    BOTAG__TRADE_OP = 4;
    BOTAG__TRADE_QTY = 5;
    BOTAG__TRADE_PRICE = 6;
    BOTAG__SHIP_LOAD_RESTRICT = 7;
    BOTAG__CITY_STORE = 8;
    BOTAG__CITY_SPRICE = 9;
    BOTAG__CITY_PPRICE = 10;
    BOTAG__PROD_SCALE = 11;
    BOTAG__PROD_QTY = 12;

    WEAPTAG__CITY_WEAPON_1 = 1;
    WEAPTAG__CITY_WEAPON_2 = 2;
    WEAPTAG__CITY_WEAPON_3 = 3;
    WEAPTAG__CITY_WEAPON_4 = 4;
    WEAPTAG__SHIP_WEAPON_1 = 5;
    WEAPTAG__SHIP_WEAPON_2 = 6;
    WEAPTAG__SHIP_WEAPON_3 = 7;
    WEAPTAG__SHIP_WEAPON_4 = 8;
    WEAPTAG__SHIP_WEAPON_5 = 9;
    WEAPTAG__SHIP_WEAPON_6 = 10;
    WEAPTAG__SWORD = 11;
  private
    function  calcSurplus(goodsID: integer): integer;
  private
    procedure CityDetailGridAfterCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellRect: TRect);
//    procedure CityDetailGridPaintCell(aSender: TBaseVirtualTree;
//      aPaintInfo: TVTPaintInfo; var aDefaultDraw: Boolean);
    procedure CityDetailGridGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);

    procedure CityDetailGridDblClick(Sender: TObject);
    procedure CityDetail_BOGridKeyPress(Sender: TObject; var Key: Char);

    procedure CityDetailGridGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);

    procedure CityDetailGridBeforeItemErase(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect;
      var ItemColor: TColor; var EraseAction: TItemEraseAction);

    procedure CityDetail_BOGridGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure CityDetail_BOGridGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure CityDetail_BOGridPaintCell(aSender: TBaseVirtualTree;
      aPaintInfo: TVTPaintInfo; var aDefaultDraw: Boolean);
    procedure CityDetail_BOGridBeforeItemErase(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect;
      var ItemColor: TColor; var EraseAction: TItemEraseAction);

    procedure CityDetail_BOGridFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure CityDetail_BOGridEditing(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure CityDetail_BOGridCreateEditor(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
    procedure CityDetail_BOGridNewText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; NewText: WideString);
      

    procedure CityDetail_BOGridDblClick(Sender: TObject);

    procedure cbCityDetail_TraderChanged(sender: TObject);
    procedure cbCityDetail_CityChanged(sender: TObject);


    procedure btnCityDetail_PrevTraderClick(Sender: TObject);
    procedure btnCityDetail_NextTraderClick(Sender: TObject);
    procedure btnCityDetail_PrevCityClick(Sender: TObject);
    procedure btnCityDetail_NextCityClick(Sender: TObject);

//    procedure pcTraderChange(Sender: TObject);

    procedure cbCityDetail_BOCombineTraderValueClick(Sender: TObject);

    procedure miBO_Mod_BuildShipMaterialAddClick(Sender: TObject);
    procedure miBO_Mod_ConstructionMaterialAddClick(Sender: TObject);
    procedure miBO_Mod_EnsureCelebrationGoodsClick(Sender: TObject);
    procedure miBO_Mod_GoodsAddClick(Sender: TObject);
    procedure miBO_Mod_ShipWeaponAddClick(Sender: TObject);
    procedure miBO_Mod_CityWeaponAddClick(Sender: TObject);
    procedure miBO_Mod_SwordAddClick(Sender: TObject);

    function  miGetTag(sender: TObject): Integer;
    
    procedure boModAddGoods(gid: integer; tag: integer);

    procedure drawEmote(pb: TPaintBox; aSatisfy: Smallint);

    procedure pbTraderList_SatisfyRichPaint(Sender: TObject);
    procedure pbTraderList_SatisfyCommonPaint(Sender: TObject);
    procedure pbTraderList_SatisfyPoorPaint(Sender: TObject);

    procedure CityDetail_Dockyard_BuildingShipGridGetText(
      Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType; var CellText: WideString);

    procedure btnCityDetail_Dockyard_BookingClick(Sender: TObject);

    procedure miCityDetail_Dockyard_SetShipCompleteNowClick(Sender: TObject);


    procedure updateResidentPanel();
    procedure updateDockyardTab();
    procedure CityDetail_BO_WeaponStoreGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);

    procedure CityDetail_BuildingGridGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure btnCityDetail_Building_RefreshClick(Sender: TObject);

    procedure updateGeneralBOInfo();
  protected
    procedure internalPrepare(); override;
    procedure internalReset();  override;
    procedure internalUpdate();  override;
  public
    class function  getViewerType(): TViewerType; override;
    procedure init();  override;
    procedure cancelEdits(); override;
    procedure deactivate();  override;
//    function  acceptPropSubView(aSubView: TPropSubViewType): Boolean;  override;
    function  getRecCount(): Integer; override;
  end;

  TShipListNode = record
    NodeType: Integer;
    Obj: Pointer;

    procedure setup(nt: integer; aObj: Pointer);
  public const
    NT__GROUP = 1; //point to TShipGroupInfoCache
    NT__SHIP = 2; //pp3r2ship
  end;
  PShipListNode = ^TShipListNode;

  //init value of changed is True, abortIteration is False
  TSelectedShipIterator = procedure (
            ship: PP3R2Ship;
            iParam: integer;
            pParam: pointer;
            var changed: Boolean;
            var abortIteration: Boolean) of object;

  TShipListViewer = class(TViewer)
  public const
    COLTAG__NAME = 1;
    COLTAG__SHIP_POINTS = 2;
    COLTAG__CAPACITY = 3;
    COLTAG__CAPTAIN = 4;
    COLTAG__SEAMAN = 5;
    COLTAG__SWORD = 6;
    COLTAG__POWER = 7;
    COLTAG__SAIL_STATE = 8;
    COLTAG__SHIP_TYPE = 9;

    COLTAG__GOODS_1 = 10;
    COLTAG__GOODS_20 = 29;

    COLTAG__CURR_CITY = 30;

    COLTAG__CITY_WEAPON_1 = 31;
    COLTAG__CITY_WEAPON_2 = 32;
    COLTAG__CITY_WEAPON_3 = 33;
    COLTAG__CITY_WEAPON_4 = 34;

    COLTAG__SHIP_PTR = 100; 
  private
    procedure ShipListGridGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure ShipListGridGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
//    procedure ShipListGridAfterCellPaint(Sender: TBaseVirtualTree;
//      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
//      CellRect: TRect);
    procedure ShipListGridBeforeItemErase(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect;
      var ItemColor: TColor; var EraseAction: TItemEraseAction);
    procedure ShipListGridPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
    procedure ShipListGridFreeNode(Sender: TBaseVirtualTree;
      Node: PVirtualNode);



    procedure onMIShipListGridPM_Mod_GoodsQtyX10(sender: TObject);
    procedure miShipListGridPM_Mod_AssignCaptainClick(Sender: TObject);

    procedure btnShipList_PrevTraderClick(Sender: TObject);
    procedure btnShipList_NextTraderClick(Sender: TObject);
    procedure cbShipList_TraderChange(Sender: TObject);

    procedure onRbShipList_StateClick(sender: TObject);
    procedure tabbarShipListAreaChange(Sender: TObject);
    procedure tabbarShipListAreaTabSelected(Sender: TObject;
      Item: TJvTabBarItem);
    procedure tabbarShipList_ViewTypeTabSelected(Sender: TObject;
      Item: TJvTabBarItem);
    procedure miShipListGridPM_Mod_SetCapacityToClick(Sender: TObject);
    procedure miShipListGridPM_Mod_SetGoodsToClick(Sender: TObject);
    procedure miShipListGridPM_Mod_FullPowerClick(Sender: TObject);
    procedure miShipListGridPM_Mod_SeamanAddClick(Sender: TObject);
    procedure miShipListGridPM_Mod_CityWeaponAddClick(Sender: TObject);
    procedure miShipListGridPM_Mod_SetPointsToClick(Sender: TObject);
    procedure miShipListGridPM_Mod_RestoreCurrPointsClick(Sender: TObject);
    procedure miShipListGridPM_Mod_ShiQiClick(Sender: TObject);

    procedure miShipListGrid_ShipSetAreaClick(Sender: TObject);
    procedure miShipListGrid_RenameShipByCityNameClick(Sender: TObject);
    procedure pmShipListGridPopup(Sender: TObject);
  protected
    procedure internalPrepare(); override;
    procedure internalReset();  override;
    procedure internalUpdate();  override;

  private
    //return changed Count
    function  selectedShipIterate(
            iterator: TSelectedShipIterator;
            iParam: integer;
            pParam: Pointer = nil): Integer;

    procedure iter_setCapacityTo(
            ship: PP3R2Ship;
            iParam: integer;
            pParam: pointer;
            var changed: Boolean;
            var abortIteration: Boolean);
    procedure iter_setGoodsTo(
            ship: PP3R2Ship;
            iParam: integer;
            pParam: pointer;
            var changed: Boolean;
            var abortIteration: Boolean);
    procedure iter_fullPower(
            ship: PP3R2Ship;
            iParam: integer;
            pParam: pointer;
            var changed: Boolean;
            var abortIteration: Boolean);
    procedure iter_seaManAdd(
            ship: PP3R2Ship;
            iParam: integer;
            pParam: pointer;
            var changed: Boolean;
            var abortIteration: Boolean);
    procedure iter_MaxShiQi(
            ship: PP3R2Ship;
            iParam: integer;
            pParam: pointer;
            var changed: Boolean;
            var abortIteration: Boolean);
    procedure iter_cityWeaponAdd(
            ship: PP3R2Ship;
            iParam: integer;
            pParam: pointer;
            var changed: Boolean;
            var abortIteration: Boolean);
    procedure iter_setPointsTo(
            ship: PP3R2Ship;
            iParam: integer;
            pParam: pointer;
            var changed: Boolean;
            var abortIteration: Boolean);
    procedure iter_restoreCurrPoints(
            ship: PP3R2Ship;
            iParam: integer;
            pParam: pointer;
            var changed: Boolean;
            var abortIteration: Boolean);


    function  getTagOfMenuItem(sender: TObject): Integer;
  private
    tempShipList: TList;
    procedure rebuildGridColumns();
  public
    class function  getViewerType(): TViewerType; override;
    constructor Create(aForm: TfrmP3Insight); override;
    destructor Destroy; override;
    procedure init();  override;
    procedure cancelEdits(); override;
    procedure deactivate();  override;
//    function  acceptPropSubView(aSubView: TPropSubViewType): Boolean;  override;
    function  getRecCount(): Integer; override;
  end;

  TCityListSelectedIterator = procedure (city: PCityStruct; iParam: integer; pParam: Pointer; var changed: Boolean; var abortIteration: Boolean) of object;

  TCityListViewer = class(TViewer)
  public const
    TAG__CITY_ID = 1;
    TAG__CITY_PTR = 2;
    TAG__CITY_NAME = 3;
    TAG__POP_TOTAL = 4;

    TAG__SATISFY_RICH = 5;
    TAG__SATISFY_COMMON = 6;
    TAG__SATISFY_POOR = 7;

    TAG__ADV_HOUSE = 8;
    TAG__COMMON_HOUSE = 9;
    TAG__POOR_HOUSE = 10;

    TAG__POP_RICH = 11;
    TAG__POP_COMMON = 12;
    TAG__POP_POOR = 13;
    TAG__POP_BEGGER = 14;

    TAG__TREASURY = 15;

    TAG__FREE_CAPTAIN = 16;

    TAG__GOODS1 = 100;
    TAG__GOODS_MAX = MAX_GOODS * 5 + TAG__GOODS1 - 1;

    TAG__CITY_WEAPON_STORE1 = 201;
    TAG__CITY_WEAPON_STORE4 = 204;

    TAG__CITY_SHIP_WEAPON_STORE1 = 211;
    TAG__CITY_SHIP_WEAPON_STORE6 = 216;
    TAG__CITY_SWORD_STORE = 217;

    TAG__FACILITY_WELL = 301;
    TAG__FACILITY_HOSPITAL = 302;
//    TAG__FACILITY_CHURCH_1 = 303;
//    TAG__FACILITY_CHURCH_2 = 304;
    TAG__FACILITY_CHURCH_UG_REQ = 305;
    TAG__FACILITY_ROAD = 306;
    TAG__FACILITY_CHAPEL = 307;
    TAG__FACILITY_SCHOOL = 308;
    TAG__FACILITY_MINTAGE = 309;
    TAG__FACILITY_WALL = 310;

    TAG__FACILITY_SEACOAST_ARTILLERY = 321;
    TAG__FACILITY_CITYGATE_ARTILLERY = 322;
    TAG__FACILITY_PAOSHE = 323;

    TAG__SOLDIER_TOTAL = 331;
    TAG__SOLDIER_0 = 332;
    TAG__SOLDIER_1 = 333;
    TAG__SOLDIER_2 = 334;
    TAG__SOLDIER_3 = 335;
  private
    procedure CityListGridGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure CityListGridGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure CityListGridBeforeItemErase(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect;
      var ItemColor: TColor; var EraseAction: TItemEraseAction);
    procedure CityListGridPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
    procedure CityListGridAfterCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellRect: TRect);
    procedure cityListViewModeTabBarTabSelected(Sender: TObject;
      Item: TJvTabBarItem);
    procedure miCityList_SetGoodsSatisfy1WeekClick(Sender: TObject);
    procedure miCityList_AddGoodsSatisfy1WeekClick(sender: TObject);
    procedure miCityList_ClearGoodsClick(sender: TObject);
    procedure miCityList_BeggerAddClick(Sender: TObject);
    procedure miCityList_CompleteFacilityClick(Sender: TObject);
    procedure miCityList_CompletePlayerBuildingClick(Sender: TObject);

    procedure miCityList_TotalAllowedSoldierAdd(Sender: TObject);
    procedure miCityList_Soldier0Add(Sender: TObject);
    procedure miCityList_Soldier1Add(Sender: TObject);
    procedure miCityList_Soldier2Add(Sender: TObject);
    procedure miCityList_Soldier3Add(Sender: TObject);
    procedure miCityList_AllSoldierAdd(Sender: TObject);

    procedure columnsChanged(Sender: TObject);
    procedure onGoodsButtonClick(Sender: TObject);

    procedure miCityList_TreasurySetToClick(Sender: TObject);
    procedure miCityList_TreasuryAddClick(Sender: TObject);
  protected
    procedure internalPrepare(); override;
    procedure internalReset();  override;
    procedure internalUpdate();  override;
  private
    fShowGoods: array[MIN_GOODS_ID..MAX_GOODS_ID] of boolean;

    procedure rebuildColumns();

    function  getMITag(sender: TObject): Integer;

    //return true if changed
    function  cityListSelectedIterate(iterator: TCityListSelectedIterator; iParam: integer; pParam: Pointer): Boolean;

    procedure iter_SetGoodsSatisfy1Week(
            city: PCityStruct;
            iParam: integer;
            pParam: Pointer;
            var changed: Boolean;
            var abortIteration: Boolean);
    procedure iter_AddGoodsSatisfy1Week(
            city: PCityStruct;
            iParam: integer;
            pParam: Pointer;
            var changed: Boolean;
            var abortIteration: Boolean);
    procedure iter_ClearGoods(
            city: PCityStruct;
            iParam: integer;
            pParam: Pointer;
            var changed: Boolean;
            var abortIteration: Boolean);
    procedure iter_BeggerAdd(
            city: PCityStruct;
            iParam: integer;
            pParam: Pointer;
            var changed: Boolean;
            var abortIteration: Boolean);
    procedure iter_CompleteFacility(
            city: PCityStruct;
            iParam: integer;
            pParam: Pointer;
            var changed: Boolean;
            var abortIteration: Boolean);
    procedure iter_CompletePlayerBuilding(
            city: PCityStruct;
            iParam: integer;
            pParam: Pointer;
            var changed: Boolean;
            var abortIteration: Boolean);
    procedure iter_TreasuryAdd(
            city: PCityStruct;
            iParam: integer;
            pParam: Pointer;
            var changed: Boolean;
            var abortIteration: Boolean);
    procedure iter_TreasurySetTo(
            city: PCityStruct;
            iParam: integer;
            pParam: Pointer;
            var changed: Boolean;
            var abortIteration: Boolean);
    procedure iter_SoldierRestrictAdd(
            city: PCityStruct;
            iParam: integer;
            pParam: Pointer;
            var changed: Boolean;
            var abortIteration: Boolean);
    procedure iter_SoldierAdd(
            city: PCityStruct;
            iParam: integer;
            pParam: Pointer;              //ord=0 for solder1, ord=1 for soldier2...ord=-1 for soldier all 
            var changed: Boolean;
            var abortIteration: Boolean);
  public
    class function  getViewerType(): TViewerType; override;
    constructor Create(aForm: TfrmP3Insight); override;
    destructor Destroy; override;
    procedure init();  override;
    procedure cancelEdits(); override;
    procedure deactivate();  override;
//    function  acceptPropSubView(aSubView: TPropSubViewType): Boolean;  override;
    function  getRecCount(): Integer; override;
  end;

  TMapViewer = class(TViewer)
  private
    MapSrc, MapSrcOrg: TBitmap32;
    fMapInfo: TCachedMapInfo;
    fGoodsButtons: TList;
    fSelectedShipIndex: Integer;
    fSelectedShip: PP3R2Ship;
    fSelectedTradeIndex: Integer;
    fSelectedTradeRoute: PTradeRoute;
    fRunningTradeRoute: PTradeRoute;
    fTradeRouteIndices: TTradeRouteIndices;

    fTempList_UsedForPriceList: TList;

    fFilter_ShipName, fFilter_Area: WideString;

    procedure cbMap_drawCityNameClick(Sender: TObject);
    procedure onGoodsButtonClick(sender: TObject);
    procedure MapShipGroupSelectGridDblClick(Sender: TObject);
    procedure MapShipGroupSelectGridGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure sbMap_ShowGoods_ClearClick(Sender: TObject);
    procedure Map_TradeRouteCityGridGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);

    procedure Map_TradeRouteGoodsGridGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure Map_TradeRouteGoodsGridGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure Map_TradeRouteCityGridChange(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure cbMap_SelectedShipGroupIsTradingClick(Sender: TObject);
    procedure Map_TradeRouteCityGridDblClick(Sender: TObject);
    procedure Map_TradeRouteGoodsGridEditing(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure Map_TradeRouteGoodsGridBeforeItemErase(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect;
      var ItemColor: TColor; var EraseAction: TItemEraseAction);
    procedure Map_TradeRouteCityGridDragDrop(Sender: TBaseVirtualTree;
      Source: TObject; DataObject: IDataObject; Formats: TFormatArray;
      Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
    procedure Map_TradeRouteCityGridDragOver(Sender: TBaseVirtualTree;
      Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint;
      Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
    procedure Map_TradeRouteGoodsGridCreateEditor(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
    procedure Map_TradeRouteGoodsGridNewText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; NewText: WideString);
    procedure Map_TradeRouteGoodsGridFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure Map_TradeRouteGoodsGridKeyPress(Sender: TObject; var Key: Char);
    procedure Map_TradeRouteGoodsGridHeaderDblClick(Sender: TVTHeader;
      Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);

    procedure Map_TradeRouteGoodsGridAfterCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellRect: TRect);
      

    procedure pmTradeRouteCityGridPopup(Sender: TObject);
    procedure onMITradeRouteAddCityClick(sender: TObject);
    procedure onSelectedRoutePointIndexChanged(sender: TObject);
    procedure miMap_TRCityGrid_RemoveCityClick(Sender: TObject);
    procedure pmTradeRouteGoodsGridPopup(Sender: TObject);

    procedure miMap_TRGoodsGrid_LoadPriceIntoSelected(Sender: TObject);
    procedure miMap_TRGoodsGrid_LoadPriceIntoAll(sender: TObject);
    procedure miMap_TRGoods_SetOpClick(sender: TObject);

    procedure miMap_TRGoods_AllOpClick(Sender: TObject);
    procedure Map_TradeRouteGoodsGridDblClick(Sender: TObject);

    procedure MapDblClick(sender: TObject);
    procedure edMap_ShipGroupSelect_NameChange(Sender: TObject);

    procedure cbMap_ShipGroupSelect_AreaChanged(Sender: TObject);

    procedure sbMap_SelectPrevShipClick(Sender: TObject);
    procedure sbMap_SelectNextShipClick(Sender: TObject);

    procedure miMap_LoadTradeRoutesClick(Sender: TObject);
    procedure miMap_SaveTradeRoutesClick(Sender: TObject);
  private
    procedure SelectedShipGroupChanged();

    //return true if changed
    //before = false for after
    function  RoutePointMove(indexFrom, indexTo: integer; before: boolean): boolean;

    procedure loadPriceIntoSelectedNodes(nodeList: TList; pl: TPriceList);
    procedure TRSetOp(gid: integer; op: TTradeRouteOpType; price, qty: integer);
    procedure TRSetOpByNodes(nodes: TList; op: TTradeRouteOpType);
    function  getDefaultSPrcie(gid: integer): Integer;
    function  getDefaultPPrice(gid: integer): Integer;

    procedure reloadShipGroupSelectGrid();
  protected
    procedure internalPrepare(); override;
    procedure internalReset();  override;
    procedure internalUpdate();  override;
  public
    class function  getViewerType(): TViewerType; override;
    constructor Create(aForm: TfrmP3Insight); override;
    destructor Destroy; override;
    procedure init();  override;
    procedure cancelEdits(); override;
    procedure deactivate();  override;
//    function  acceptPropSubView(aSubView: TPropSubViewType): Boolean;  override;
    function  getRecCount(): Integer; override;

    procedure loadTradeRoutes(tr: TCustomTradeRoute);
    procedure saveTradeRoutes(tr: TCustomTradeRoute);
    function  doTradeRouteAddCity(city: integer): PVirtualNode;

    property  SelectedShip: PP3R2Ship read fSelectedShip;
  end;

  TAreaViewer = class(TViewer)
  private
    procedure Config_AreaGridGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure Config_AreaGridChange(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure Config_AreaCityGridGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure Config_AreaCityGridChecked(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure Config_AreaCityGridChecking(Sender: TBaseVirtualTree;
      Node: PVirtualNode; var NewState: TCheckState; var Allowed: Boolean);
    procedure AreaSupplyGridGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure AreaSupplyGridGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure cbArea_ExclStoreWhenCalcRemainsClick(Sender: TObject);
    procedure Config_AreaGridFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure seArea_CalcRemainPeriodChange(Sender: TObject);
  protected
    procedure internalPrepare(); override;
    procedure internalReset();  override;
    procedure internalUpdate();  override;
  public
    class function  getViewerType(): TViewerType; override;
    constructor Create(aForm: TfrmP3Insight); override;
    destructor Destroy; override;
    procedure init();  override;
    procedure cancelEdits(); override;
    procedure deactivate();  override;
//    function  acceptPropSubView(aSubView: TPropSubViewType): Boolean;  override;
    function  getRecCount(): Integer; override;
  end;



//  TCityIconTypeProviderImpl = class(TCityIconTypeProvider)
//  public
//    function  get(const cityCode: Byte): TCityIconType; override;
//  end;

var
  frmP3Insight: TfrmP3Insight;
  disallowF1: boolean;  

procedure showP3InsightDlg();

implementation

uses P3InsightUICommon, p3insight_test, p3insight_utils, Types, Math, JclWideStrings;

{$R *.dfm}

const
  DEFAULT_PROP_PANEL_WIDTH = 155;
  FOLDED_PROP_PANEL_WIDHT = 24;

  ODD_BK_COLOR = $00F2F2F2;
  selectionColor = $00D0D0D0;

  IL20__GOODS_1 = 0;
  IL20__GOODS_20 = 19;
  IL20__PKG = 20;
  IL20__TONG = 21;
  IL20__HEART = 22;
  IL20__STAR = 23;
  IL20__SEAMAN = 24;

  IL16__EMPTY = 0;
  IL16__LOCK = 1;
  IL16__TRADING = 2;
  IL16__SAILING = 3;
  IL16__PIRATE = 4;
  IL16__FIXING = 5;
  IL16__RED_BTN = 6;
  IL16__RED_BLUE_BTN = 7;
  IL16__BLUE_BTN = 8;

type
  TTradeRouteSelectClientImpl_Load = class(TInterfacedObject, ITradeRouteSelectClient)
  private
    mapViewer: TMapViewer;
  public
    constructor Create(mapViewer: TMapViewer);
    function  isLoad(): Boolean;
    function  getCallerRect(): TRect;

    procedure onOk(aSelected: TCustomTradeRoute);
    procedure onCancel();
  end;

  TTradeRouteSelectClientImpl_Save = class(TInterfacedObject, ITradeRouteSelectClient)
  private
    mapViewer: TMapViewer;
  public
    constructor Create(mapViewer: TMapViewer);
    function  isLoad(): Boolean;
    function  getCallerRect(): TRect;

    procedure onOk(aSelected: TCustomTradeRoute);
    procedure onCancel();
  end;

procedure TfrmP3Insight.acCloseExecute(Sender: TObject);
begin
  Application.ProcessMessages();
  disallowF1 := True;
  PostMessage(Handle, UM__CLOSE, 0, 1);
end;

procedure TfrmP3Insight.activePrimaryViewerChanged;
begin
  fViewList.activePrimaryViewerChanged();
  recCountChanged();
end;

procedure TfrmP3Insight.beginInternalUpdate;
begin
  Inc(fInternalUpdate);
end;

procedure TfrmP3Insight.btnCloseClick(Sender: TObject);
begin
  PostMessage(Handle, UM__CLOSE, 0, 0);
end;

procedure TfrmP3Insight.btnCloseTradeRouteSelectPanelClick(Sender: TObject);
begin
  closeTradeRouteSelectPanel();
end;

procedure TfrmP3Insight.btnHomeCityClick(Sender: TObject);
begin
  setCurrView(currPlayer, currPlayerHomeCity);
end;

procedure TfrmP3Insight.btnKillProcessClick(Sender: TObject);
begin
  TerminateProcess(GetCurrentProcess(), 0);
end;

procedure TfrmP3Insight.btnLoadSelectedTradeRouteClick(Sender: TObject);
var
  tr: TCustomTradeRoute;
begin
  tr := TCustomTradeRoute(TradeRouteSelectGrid.GetNodeUserData(TradeRouteSelectGrid.SelectedNode));

  if tr = nil then
  begin
    showMsg(MT__ERROR, '请选择贸易航线。');
    exit;
  end;

  if tradeRouteSelectClient = nil then
  begin
    soundBeep();
    exit;
  end;

  if not tradeRouteSelectClient.isLoad() then
  begin
    if not tr.Inserting
    and not tradeRouteSelectOverwritePrompted then
    begin
      soundBeep();
      btnLoadSelectedTradeRoute.Caption := '覆盖？';
      btnLoadSelectedTradeRoute.Font.Color := clRed;
      tradeRouteSelectOverwritePrompted := True;
      exit;
    end;
  end;

  tradeRouteSelectClient.onOk(tr);
  closeTradeRouteSelectPanel();
end;

procedure TfrmP3Insight.btnPlayerClick(Sender: TObject);
begin
  setCurrView(getCurrPlayerID(), currCity);
end;

procedure TfrmP3Insight.btnTestClick(Sender: TObject);
var
  R, I, J, price: Integer;
  n: PVirtualNode;
  ship: PP3R2Ship;
  rpCnt: Integer;
  priceList: TPriceList;
  idx, first, prev: Integer;

  route, prevRoute: PTradeRoute;
begin
  if PageControlMain.ActivePage.Tag <> Ord(SHIP_LIST_VIEWER) then
    exit;

  n := ShipListGrid.SelectedNode;
  if n = nil then
  begin
    soundBeep();
    exit;
  end;

  ship := ShipListGrid.GetNodeUserData(n);
  rpCnt := tradeRoute_getPointCount(ship);
  if rpCnt <> 0 then
  begin
    showMsg(MT__ERROR, 'There is route point defined.');
    exit;
  end;

  Assert(Conf.PriceDefs.List.count > 0);
  priceList := Conf.PriceDefs.get(0);

  first := -1;
  prev := -1;
  prevRoute := nil;

  for R := 1 to 2 do
  begin
    idx := tradeRoute_new();
    if first < 0 then
      first := idx;

    route := getTradeRoute(idx);

    if prev < 0 then
    begin
      prev := idx;
      prevRoute := route;
      route^.NextIndex := idx;
    end
    else
    begin
      prevRoute^.NextIndex := idx;
      route^.NextIndex := first;
      prevRoute := route;
    end;
////    dbgPtr('tradeRoute', route);
//    if route^.NextIndex <> idx then
//    begin
//      dbgStr('You muse assign the index');
//      route^.Index := idx;
//    end;

    route^.CityCode := $09;
    if first = idx then
      route^.Flags := TRADE_ROUTE_FLAG__FIRST
    else
      route^.Flags := 0;

    tradeRoute_initOrders(route);

    for I := 1 to 20 do
    begin
      price := priceList.Prices[I];
      route^.Prices[I] := price;
      route^.MaxQty[I] := TRADE_ROUTE__MAX_QTY;
    end;
  end;

  ship^.TradingIndex := first;
  ship^.IsTrading := 1;
end;

procedure TfrmP3Insight.btnTradeRouteSelectCancelClick(Sender: TObject);
begin
  closeTradeRouteSelectPanel();
end;

procedure TfrmP3Insight.cancelEdits;
begin
  fViewList.cancelEditAll();
end;

procedure TfrmP3Insight.clearMsgSB;
begin
  StatusBar.Panels[2].Text := '';
  msgTimer.Enabled := False;
end;

procedure TfrmP3Insight.closeTradeRouteSelectPanel;
var
  r: TRect;
begin
  pnlLoadTradeRoute.Visible := False;

  r.Left := 1;
  r.Top := 1;
  r.Right := Width - 1;
  r.Bottom := Height - 1;
  ClipCursor(@r);

  tradeRouteSelectClient := nil;
  tradeRouteSelectOverwritePrompted := False;
end;

constructor TfrmP3Insight.Create(AOwner: TComponent);
begin
  bluePen := CreatePen(PS_SOLID, 1, clBlue);
  gridSelectBkClrBrush := CreateSolidBrush(ColorToRGB(selectionColor));
  gridOddBkClrBrush := CreateSolidBrush(ColorToRGB(ODD_BK_COLOR));
  AreaDef := Conf.AreaDefList.getDefault();
  _currPlayerShipList := TList.Create();
  _currPlayerShipListReady := False;
  allCityShipList := TAllCityShipList.Create();
  residentConsumePrecalc := TResidentConsumePrecalc.Create();
  houseCapInfo.init();
  traderInfoCache := TTraderInfoCache.Create();
  shipGroupInfoCacheList := TShipGroupInfoCacheList.Create();
  cityBuildingCacheList := TCityBuildingCacheList.Create();
  areaDataCache := TAreaDataCache.Create(residentConsumePrecalc, AreaDef);
  inherited;
  tabTraderList.Tag := Ord(TRADER_LIST_VIEWER);
  tabCityDetail.Tag := Ord(CITY_DETAIL_VIEWER);
  tabShipList.Tag := Ord(SHIP_LIST_VIEWER);
  tabCityList.Tag := Ord(CITY_LIST_VIWEER);
  tabMap.Tag := Ord(MAP_VIEWER);
  tabArea.Tag := Ord(AREA_VIEWER);

  GameStateListenerList.add(Self);
  DateUpdateListenerList.add(Self);
  fGoodsImageProv := TGoodsImageProviderImpl.Create(Self);
  fViewList := TViewerList.Create(Self);
end;

procedure TfrmP3Insight.CreateParams(var aParams: TCreateParams);
begin
  inherited;
  aParams.ExStyle := aParams.ExStyle or WS_EX_TOPMOST;
  aParams.Style := aParams.Style or WS_POPUP;
  aParams.WndParent := P3WndHandle;
end;

destructor TfrmP3Insight.Destroy;
begin
  GameStateListenerList.remove(Self);
  if fViewList <> nil then
  begin
    fViewList.resetAll();
  end;
  inherited;
  FreeAndNil(fViewList);
  FreeAndNil(_currPlayerShipList);
  FreeAndNil(allCityShipList);
  FreeAndNil(residentConsumePrecalc);
  FreeAndNil(traderInfoCache);
  FreeAndNil(shipGroupInfoCacheList);
  if bluePen <> 0 then
    DeleteObject(bluePen);
  if gridSelectBkClrBrush <> 0 then
    DeleteObject(gridSelectBkClrBrush);
  if gridOddBkClrBrush <> 0 then
    DeleteObject(gridOddBkClrBrush);
  FreeAndNil(cityBuildingCacheList);
  FreeAndNil(areaDataCache);
end;

procedure TfrmP3Insight.endInternalUpdate;
begin
  Dec(fInternalUpdate);
end;

procedure TfrmP3Insight.FormActivate(Sender: TObject);
begin
  InsightDlgVisible := True;
  prepare();
  updateUI();
//  Timer1.Enabled := True;
end;

procedure TfrmP3Insight.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  onDlgDeactivate();
    
  InsightDlgVisible := False;
  ClipCursor(nil);
  ShowCursor(False);
  Action := caHide;
//  DoSendKey := True;
//  PostMessage(P3WndHandle, DoSendKeyMsgID, 0, 2);
end;

procedure TfrmP3Insight.FormCreate(Sender: TObject);
begin
  initUI();
end;

procedure TfrmP3Insight.FormShow(Sender: TObject);
var
  Monitor: TMonitor;
  mW, mH: Integer;
  r: TRect;
begin
  InsightDlgVisible := True;
  Monitor := Screen.MonitorFromWindow(P3WndHandle);

  mW := Monitor.Width;
  mH := Monitor.Height;

  Left := 0;
  Top := 0;
  Width := mW;
  Height := mH;

  ShowCursor(True);
  r.Left := 1;
  r.Top := 1;
  r.Right := mW - 1;
  r.Bottom := mH - 1;
  ClipCursor(@r);
  BringToFront();
  SetFocus();
end;


function TfrmP3Insight.getActivePrimaryViewer: TViewer;
begin
  Result := fViewList.ActivePrimaryViewer;
end;

function TfrmP3Insight.getBO(const pid, city: integer): PBusinessOffice;
begin
  Result := cityBODataCacheList.findBO(city, pid);
end;

function TfrmP3Insight.getCurrPlayerShipList: TList;
begin
  if not _currPlayerShipListReady then
  begin
    getShipList(currPlayer, _currPlayerShipList);
//    dbgStr('shipcount=' + IntToStr(_currPlayerShipList.Count) );
    _currPlayerShipListReady := True;
  end;

  Result := _currPlayerShipList;
end;

function TfrmP3Insight.getPPrice(goodsID: integer): Integer;
var
  pl: TPriceList;
begin
  pl := Conf.PriceDefs.getDefaultPPriceList();
  if pl <> nil then
    Result := pl.get(goodsID)
  else
    Result := getGeneralGoodsProdCost(goodsID);
end;

function TfrmP3Insight.getResidentConsumePrecalc: TResidentConsumePrecalc;
begin
  Result := residentConsumePrecalc;
end;

function TfrmP3Insight.getSPrice(goodsID: integer): Integer;
var
  pl: TPriceList;
begin
  pl := Conf.PriceDefs.getDefaultSPriceList();
  if pl <> nil then
    Result := pl.get(goodsID)
  else
    Result := getGeneralGoodsProdCost(goodsID);
end;

procedure TfrmP3Insight.recCountChanged;
var
  v: TViewer;
  c: integer;
begin
  v := fViewList.ActivePrimaryViewer;
  if v = nil then
    StatusBar.Panels[0].Text := ''
  else
  begin
    c := v.getRecCount();
    if c < 0 then
      StatusBar.Panels[0].Text := ''
    else
      StatusBar.Panels[0].Text := IntToStr(c);
  end;
end;

procedure TfrmP3Insight.reloadTradeRouteSelectGrid;
var
  selected: TSelectTradeRouteCategoryItem;
  I: integer;
  list: TList;
  tr: TCustomTradeRoute;
  cate: WideString;
begin
  TradeRouteSelectGrid.CancelEditNode();
  
  selected := TSelectTradeRouteCategoryItem(
          SelectTradeRouteCategoriesGrid.GetNodeUserData(
                  SelectTradeRouteCategoriesGrid.SelectedNode));

  TradeRouteSelectGrid.BeginUpdate();
  try
    TradeRouteSelectGrid.Clear();

    if selected = nil then
      exit;

    list := TList.Create();
    try
      if selected.Others then
        cate := ''
      else
        cate := selected.Category;

      Conf.CustomTRList.getTradeRoutesByCategory(cate, list);

      for I := 0 to List.Count - 1 do
      begin
        tr := TCustomTradeRoute(list[I]);
        TradeRouteSelectGrid.AddChild(nil, tr);
      end;
    finally
      list.Destroy();
    end;
  finally
    TradeRouteSelectGrid.EndUpdate();
  end; 
end;

procedure TfrmP3Insight.resetStructures;
begin
//  dbgStr('resetStructures->');
  captainSetuped := False;
  cityBODataCacheList.reset();
  residentConsumePrecalc.reset();
  _currPlayerShipListReady := False;
  _currPlayerShipList.Clear();
  allCityShipList.clear();
  houseCapInfo.reset();
  traderInfoCache.reset();
  cityBuildingCacheList.reset();
  areaDataCache.reset();
  AreaDef.resetGoodsSupplyInfoCache();
//  dbgStr('<-resetStructures');
end;

procedure TfrmP3Insight.initUI;
begin
  SelectTradeRouteCategoriesGrid.NodeDataSize := SizeOf(TObject);
  SelectTradeRouteCategoriesGrid.DefaultText := '';

  TradeRouteSelectGrid.NodeDataSize := SizeOf(TObject);
  TradeRouteSelectGrid.DefaultText := '';
  
  beginInternalUpdate();
  try    
    fViewList.initAll();

    PageControlMain.ActivePageIndex := 0;
  finally
    endInternalUpdate();
  end;
end;

function TfrmP3Insight.isInternalUpdating: Boolean;
begin
  Result := fInternalUpdate > 0;
end;

function TfrmP3Insight.mapSatisfyEmotes(const aSatisfy: Smallint): TImage;
begin
  if aSatisfy >= 30 then
    Result := ilEmote6
  else if aSatisfy >= 19 then
    Result := ilEmote5
  else if aSatisfy >= 10 then
    Result := ilEmote4
  else if aSatisfy >= 1 then
    Result := ilEmote3
  else if aSatisfy >= -10 then
    Result := ilEmote2
  else
    Result := ilEmote1;
end;

procedure TfrmP3Insight.msgTimerTimer(Sender: TObject);
begin
  clearMsgSB();
end;

procedure TfrmP3Insight.onDlgDeactivate;
begin
//  dbgStr('onDlgDeactivate->');
//  Timer1.Enabled := False;
  clearMsgSB();
//  dbgStr('onDlgDeactivate1');
  cityBODataCacheList.reset();
//  dbgStr('onDlgDeactivate2');
  fViewList.deactivateAll();
//  dbgStr('onDlgDeactivate3');
  allCityShipList.clear();
//  dbgStr('onDlgDeactivate4');
//  houseCapInfo.reset(); //only reset when exit game
  btnKillProcess.Visible := False;
//  dbgStr('onDlgDeactivate5');
  _currPlayerShipListReady := False;
//  dbgStr('onDlgDeactivate6');
  _currPlayerShipList.Clear();
//  dbgStr('onDlgDeactivate7');
  shipGroupInfoCacheList.reset();
//  dbgStr('onDlgDeactivate8');
  cityBuildingCacheList.reset();
  areaDataCache.reset();
  AreaDef.resetGoodsSupplyInfoCache();

  if Conf.AreaDefList.isChanged() then
    Conf.AreaDefList.save();

  if Conf.CustomTRList.Changed then
  begin
    Conf.CustomTRList.saveToDefaultLocation();
    dbgStr('doSaveTR');
  end;

  if pnlLoadTradeRoute.Visible then
    closeTradeRouteSelectPanel();
//  dbgStr('<-onDlgDeactivate');
end;

procedure TfrmP3Insight.onExitGame;
begin
//  dbgStr('TfrmP3Insight.onExitGame');
  fViewList.resetAll();
  resetStructures();
  initialized := False;  
end;

procedure TfrmP3Insight.onNewDate(y, m, d: integer);
begin
//  dbgStr('date changed: to ' + IntToStr(y) + '-' + IntToStr(m) + '-' + IntToStr(d));
end;

procedure TfrmP3Insight.OnUM__CLOSE(var aMsg: TMessage);
begin
  if aMsg.LParam > 0 then
    PostMessage(Handle, UM__CLOSE, aMsg.WParam, aMsg.LParam-1)
  else
    Close();
end;

procedure TfrmP3Insight.PageControlMainChange(Sender: TObject);
var
  oldViewer: TViewer;
begin
  if isInternalUpdating() then
    exit;

//  OutputDebugString('pagecontrolmainchanged->');

  oldViewer := fViewList.ActivePrimaryViewer;

//  if PageControlMain.ActivePage = nil then
//  begin
//    OutputDebugString('active page = nil');
//    exit;
//  end;

//  if oldViewer <> nil then
//    fViewList.ActiveViewerList.Remove(oldViewer);

  case TViewerType(PageControlMain.ActivePage.Tag) of
    TRADER_LIST_VIEWER: fViewList.setActivePrimaryViewer(fViewList.TraderViewer);
    CITY_DETAIL_VIEWER: fViewList.setActivePrimaryViewer(fViewList.CityDetailViewer);
    SHIP_LIST_VIEWER: fViewList.setActivePrimaryViewer(fViewList.ShipListViewer);
    CITY_LIST_VIWEER: fViewList.setActivePrimaryViewer(fViewList.CityListViewer);
    MAP_VIEWER: fViewList.setActivePrimaryViewer(fViewList.MapViewer);
    AREA_VIEWER: fViewList.setActivePrimaryViewer(fViewList.AreaViewer);
  else
    fViewList.setActivePrimaryViewer(nil);
  end;

  if oldViewer <> fViewList.ActivePrimaryViewer then
    activePrimaryViewerChanged();

  if fViewList.ActivePrimaryViewer <> nil then
  begin
    fViewList.ActivePrimaryViewer.prepare();
    fViewList.ActivePrimaryViewer.update();
  end;

//  OutputDebugString('<-pagecontrolmainchanged');
end;

procedure TfrmP3Insight.HeadingPanelDblClick(Sender: TObject);
begin
  if not btnKillProcess.Visible then
  begin
    btnKillProcess.Left := (HeadingPanel.Width - btnKillProcess.Width) div 2;
    btnKillProcess.Visible := True;
  end
  else
    btnKillProcess.Visible := False;
end;

procedure TfrmP3Insight.prepare;
var
  I: Integer;
  pid, cid: Byte;
begin
  winter := isWinterNow();

  shipGroupInfoCacheList.reset(); //must reset it!
  currCityPtr := getCityPtr(currCity);
//  if currBO <> nil then
    currBO := getBO(currPlayer, currCity);
//    if currBO = nil then
//      dbgStr('currBO = nil, pid=' + IntToStr(currPlayer) + ', city=' +  IntToStr(currCity));

  if initialized then
    exit;

  pid := getCurrPlayerID();

  cid := getViewPortCityCode();
  if cid = $FF then
    cid := getPlayerHomeCity(pid);

  cityBODataCacheList.init();

    
  setCurrView(pid, cid);

//  fViewList.setActivePrimaryViewer();


//  residentConsumePrecalc.prepare();

  initialized := True;
end;

procedure TfrmP3Insight.updateSB_recCount(cnt: integer);
begin
  StatusBar.Panels[0].Text := IntToStr(cnt);
end;

procedure TfrmP3Insight.updateUI;
begin
  beginInternalUpdate();
  try
    fViewList.updateAllActive();
  finally
    endInternalUpdate();
  end;
  recCountChanged();
end;

procedure TfrmP3Insight.sbMap_ClearShipGroupSelectNameClick(Sender: TObject);
begin
  edMap_ShipGroupSelect_Name.Text := '';
end;

procedure TfrmP3Insight.sbSelectTradeRouteCategoriesGridAddClick(
  Sender: TObject);
var
  n: PVirtualNode;
  item: TSelectTradeRouteCategoryItem;  
begin
  item := TSelectTradeRouteCategoryItem.Create();
  item.Category := Conf.CustomTRList.newCategory();

  n := SelectTradeRouteCategoriesGrid.InsertNode(SelectTradeRouteCategoriesGrid.GetLast(nil), amInsertBefore, item);

  SelectTradeRouteCategoriesGrid.ScrollIntoView(n, False);
  SelectTradeRouteCategoriesGrid.ClearSelection();
  SelectTradeRouteCategoriesGrid.SelectNode(n);
  SelectTradeRouteCategoriesGrid.FocusedNode := n;
  SelectTradeRouteCategoriesGrid.FocusedColumn := 0;

  SelectTradeRouteCategoriesGrid.SetFocus();

  reloadTradeRouteSelectGrid();

  SelectTradeRouteCategoriesGrid.EditNode(n, 0);
end;

procedure TfrmP3Insight.sbSelectTradeRouteCategoriesGridRemoveClick(
  Sender: TObject);
var
  n: PVirtualNode;
  item: TSelectTradeRouteCategoryItem;
begin
  n := SelectTradeRouteCategoriesGrid.SelectedNode;
  if n = nil then
  begin
    showMsg(MT__ERROR, '请选择需要删除的类别');
    exit;
  end;

  item := TSelectTradeRouteCategoryItem(SelectTradeRouteCategoriesGrid.GetNodeUserData(n));
  if item.Others then
  begin
    soundBeep();
    exit;
  end;

  Conf.CustomTRList.removeCategory(item.Category);
  SelectTradeRouteCategoriesGrid.DeleteSelectedNodes();
  reloadTradeRouteSelectGrid();
end;

procedure TfrmP3Insight.sbTradeRouteSelectGridAddClick(Sender: TObject);
var
  tr: TCustomTradeRoute;
  n: PVirtualNode;
  cate: TSelectTradeRouteCategoryItem;
  category: WideString;
begin
  n := SelectTradeRouteCategoriesGrid.SelectedNode;
  if n <> nil then
  begin
    cate := TSelectTradeRouteCategoryItem.Create();
    category := cate.Category;
  end
  else
    category := '';

  tr := Conf.CustomTRList.newTR(category);

  n := TradeRouteSelectGrid.AddChild(nil, tr);

  TradeRouteSelectGrid.ScrollIntoView(n, False);
  TradeRouteSelectGrid.ClearSelection();
  TradeRouteSelectGrid.SelectNode(n);
  TradeRouteSelectGrid.FocusedNode := n;
  TradeRouteSelectGrid.FocusedColumn := 0;

  TradeRouteSelectGrid.SetFocus();

  TradeRouteSelectGrid.EditNode(n, 0);
end;

procedure TfrmP3Insight.sbTradeRouteSelectGridRemoveClick(Sender: TObject);
var
  i: integer;
  n: PVirtualNode;
  item: TCustomTradeRoute;
  list: TList;
begin
  if TradeRouteSelectGrid.SelectedCount = 0 then
  begin
    showMsg(MT__ERROR, '请选择需要删除的航线');
    exit;
  end;

  list := TList.Create();
  try
    n := TradeRouteSelectGrid.GetFirstSelected();
    while n <> nil do
    begin
      item := TCustomTradeRoute(TradeRouteSelectGrid.GetNodeUserData(n));

      list.Add(item);

      n := TradeRouteSelectGrid.GetNextSelected(n);
    end;

    TradeRouteSelectGrid.DeleteSelectedNodes();

    for I := 0 to list.Count - 1 do
    begin
      item := TCustomTradeRoute(list[i]);
      Conf.CustomTRList.removeTR(item);
    end;
  finally
    list.Destroy();
  end;
end;

procedure TfrmP3Insight.SelectTradeRouteCategoriesGridDragDrop(
  Sender: TBaseVirtualTree; Source: TObject; DataObject: IDataObject;
  Formats: TFormatArray; Shift: TShiftState; Pt: TPoint; var Effect: Integer;
  Mode: TDropMode);
var
  trN, n: PVirtualNode;
  tr: TCustomTradeRoute;
  item: TSelectTradeRouteCategoryItem;
begin
  Effect := 0;
  trN := TradeRouteSelectGrid.SelectedNode;
  if trN = nil then
  begin
    soundBeep();
    exit;
  end;

  n := Sender.GetNodeAt(pt.X, pt.Y);
  if n = nil then
  begin
    soundBeep();
    exit;
  end;

  tr := TCustomTradeRoute(TradeRouteSelectGrid.GetNodeUserData(trN));
  item := TSelectTradeRouteCategoryItem(Sender.GetNodeUserData(n));

  tr.Category := item.Category;
  Conf.CustomTRList.Changed := True;

  reloadTradeRouteSelectGrid();
end;

procedure TfrmP3Insight.SelectTradeRouteCategoriesGridDragOver(
  Sender: TBaseVirtualTree; Source: TObject; Shift: TShiftState;
  State: TDragState; Pt: TPoint; Mode: TDropMode; var Effect: Integer;
  var Accept: Boolean);
begin
  Accept := (Source = TradeRouteSelectGrid) and (Mode = dmOnNode);
end;

procedure TfrmP3Insight.SelectTradeRouteCategoriesGridFocusChanged(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
begin
  if isInternalUpdating() then
    exit;
    
  reloadTradeRouteSelectGrid();
end;

procedure TfrmP3Insight.SelectTradeRouteCategoriesGridFreeNode(
  Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  TObject(Sender.GetNodeUserData(Node)).Free();
end;

procedure TfrmP3Insight.SelectTradeRouteCategoriesGridGetText(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType; var CellText: WideString);
var
  item: TSelectTradeRouteCategoryItem;
begin
  if TextType <> ttNormal then
    exit;
    
  case Column of
    0:
    begin
      item := TSelectTradeRouteCategoryItem(Sender.GetNodeUserData(Node));

      if item.Others then
        CellText := '[其他]'
      else
        CellText := item.Category;
    end;
  end;
end;

procedure TfrmP3Insight.SelectTradeRouteCategoriesGridNewText(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  NewText: WideString);
var
  item: TSelectTradeRouteCategoryItem;
begin
  if Column <> 0 then
  begin
    soundBeep();
    exit;
  end;

  if NewText = '' then
  begin
    soundBeep();
    exit;
  end;
    
  item := TSelectTradeRouteCategoryItem(Sender.GetNodeUserData(Node));
  item.Category := NewText;

  Conf.CustomTRList.Changed := True;

  SelectTradeRouteCategoriesGrid.Invalidate();
  reloadTradeRouteSelectGrid();  
end;

procedure TfrmP3Insight.setCurrView(const aPlayerID, aCity: Byte);
var
  playerChanged: Boolean;
  I, idx, bt: Integer;
  factoryGroup: PFactoryGroup;
begin
  playerChanged := currPlayer <> aPlayerID;

  currPlayer := aPlayerID;
  currPlayerHomeCity := getPlayerHomeCity(currPlayer);
  currCity := aCity;
  currCityPtr := getCityPtr(currCity);
  currBO := cityBODataCacheList.findBO(currCity, currPlayer);
  if _currPlayerShipListReady and playerChanged then
  begin
    _currPlayerShipList.Clear();
    _currPlayerShipListReady := False;
  end;

//  if shipGroupInfoCacheList.Ready and playerChanged then
//  begin
//    shipGroupInfoCacheList.reset(currPlayer);
//  end;

  fViewList.cancelEditAll();
  fViewList.updateAllActive();
end;

procedure TfrmP3Insight.showMsg(const aMsgType: TMsgType;
  const aMsg: WideString);
begin
  fMsgType := aMsgType;
  StatusBar.Panels[2].Text := aMsg;
  msgTimer.Enabled := True;

  if (aMsgType = MT__WARNING) or (aMsgType = MT__ERROR) then
  begin
    soundBeep();
  end;
end;

procedure TfrmP3Insight.showTradeRouteSelectPanel();
var
  i, w, l, t: integer;
  pt: TPoint;
  panelRect: TRect;
  callerRect: TRect;
  n: PVirtualNode;
  tr: TCustomTradeRoute;
  category: WideString;
  cate: TSelectTradeRouteCategoryItem;
begin
  if tradeRouteSelectClient = nil then
    exit;

  callerRect := tradeRouteSelectClient.getCallerRect();

  Conf.CustomTRList.resetInsertingFlags();

  panelRect := pnlLoadTradeRoute.BoundsRect;
  w := panelRect.Right - panelRect.Left;

  pt.X := callerRect.Left - w - 1;
  pt.Y := callerRect.Top;
  if pt.X < 0 then
    pt.X := callerRect.Right + 1;

  pt := ScreenToClient(pt);


  pnlLoadTradeRoute.Left := pt.X;
  pnlLoadTradeRoute.Top := pt.Y;

  if tradeRouteSelectClient.isLoad() then
  begin
    pnlLoadTradeRouteHeading.Caption := '加载贸易航线';
    btnLoadSelectedTradeRoute.Caption := '加载';
  end
  else
  begin
    pnlLoadTradeRouteHeading.Caption := '保存贸易航线';
    btnLoadSelectedTradeRoute.Caption := '保存';
  end;

  tradeRouteSelectOverwritePrompted := False;
  btnLoadSelectedTradeRoute.Font.Color := clBlack; 

  beginInternalUpdate();
  try
    SelectTradeRouteCategoriesGrid.BeginUpdate();
    try
      SelectTradeRouteCategoriesGrid.Clear();

      for I := 0 to Conf.CustomTRList.Categories.Count - 1 do
      begin
        category := Conf.CustomTRList.Categories[I];
        cate := TSelectTradeRouteCategoryItem.Create();
        cate.Category := category;

        SelectTradeRouteCategoriesGrid.AddChild(nil, cate);
      end;

      cate := TSelectTradeRouteCategoryItem.Create();
      cate.Others := True;
      SelectTradeRouteCategoriesGrid.AddChild(nil, cate);
    finally
      SelectTradeRouteCategoriesGrid.EndUpdate();
    end;   
  finally
    endInternalUpdate();
  end;

//  reloadTradeRouteSelectGrid();

  n := SelectTradeRouteCategoriesGrid.SelectedNode;
  if n <> nil then
  begin
    cate := TSelectTradeRouteCategoryItem.Create();
    category := cate.Category;
  end
  else
    category := '';

  pnlLoadTradeRoute.Visible := True;

  panelRect := pnlLoadTradeRoute.BoundsRect;
  InflateRect(panelRect, -1, -1);
  ClipCursor(@panelRect);
  mouseClipped := True;

//  if not tradeRouteSelectClient.isLoad() then
//  begin
//    tr := Conf.CustomTRList.newTR(category);
//    
//    n := TradeRouteSelectGrid.AddChild(nil, tr);
//    TradeRouteSelectGrid.ScrollIntoView(n, False);
//    TradeRouteSelectGrid.ClearSelection();
//    TradeRouteSelectGrid.SelectNode(n);
//    TradeRouteSelectGrid.FocusedNode := n;
//    TradeRouteSelectGrid.FocusedColumn := 0;
//
//    TradeRouteSelectGrid.SetFocus();
//
//    TradeRouteSelectGrid.EditNode(n, 0); 
//  end; 
end;

procedure TfrmP3Insight.StatusBarDrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
var
  r: TRect;
begin
  StatusBar.Canvas.FillRect(Rect);

  if Panel.Text = '' then
    exit;

  r := Rect;
  InflateRect(r, -4, -1);
  DrawText(
          StatusBar.Canvas.Handle,
          pchar(Panel.Text),
          Length(Panel.Text),
          r,
          DT_SINGLELINE or DT_VCENTER or DT_LEFT);
end;

procedure TfrmP3Insight.Timer1Timer(Sender: TObject);
//var
//  hs: THeapStatus;
begin
//  hs := GetHeapStatus();
//  dbgStr('allocated: ' + IntToStr(hs.TotalAllocated div (1024 * 1024)) + 'M');
end;

procedure TfrmP3Insight.TradeRouteSelectGridChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  if tradeRouteSelectClient <> nil then
  begin
    if not tradeRouteSelectClient.isLoad() then
    begin
      if tradeRouteSelectOverwritePrompted then
      begin
        btnLoadSelectedTradeRoute.Font.Color := clBlack;
        btnLoadSelectedTradeRoute.Caption := '保存';
        tradeRouteSelectOverwritePrompted := False;
      end;
    end;
  end;
end;

procedure TfrmP3Insight.TradeRouteSelectGridDblClick(Sender: TObject);
var
  n: PVirtualNode;
  item: TCustomTradeRoute;
begin
  n := TradeRouteSelectGrid.SelectedNode;
  if n <> nil then
  begin
    item := TCustomTradeRoute(TradeRouteSelectGrid.GetNodeUserData(n));
    if item.getCount() > 0 then
      btnLoadSelectedTradeRoute.Click();
  end;
end;

procedure TfrmP3Insight.TradeRouteSelectGridGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  tr: TCustomTradeRoute;
begin
  tr := TCustomTradeRoute(Sender.GetNodeUserData(Node));

  if TextType = ttNormal then
  begin
    case Column of
      0:
        CellText := tr.Name;

      1:
        CellText := tr.Desc;
    end;
  end
  else if TextType = ttStatic then
  begin
    if Column = 0 then
      CellText := '(' + IntToStr(tr.getCount()) + ')';
  end;
end;

procedure TfrmP3Insight.TradeRouteSelectGridNewText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; NewText: WideString);
var
  tr, other: TCustomTradeRoute;
begin
  tr := TCustomTradeRoute(Sender.GetNodeUserData(Node));

  case Column of
    0:
    begin
      if NewText = '' then
      begin
        soundBeep();
        exit;
      end;
      
      other := Conf.CustomTRList.findOther(tr, NewText);
      if other <> nil then
      begin
        showMsg(MT__ERROR, '已经存在航向命名为：' + NewText);
        exit;
      end;

      tr.Name := NewText;
      Conf.CustomTRList.Changed := True;
      Sender.Invalidate();
    end;

    1:
    begin
      tr.Desc := NewText;
      Conf.CustomTRList.Changed := True;
      Sender.Invalidate();
    end;

  else
    soundBeep();
  end;
end;

procedure TfrmP3Insight.WndProc(var Message: TMessage);
begin
  if (Message.Msg = WM_ACTIVATE) and (Message.WParam = WA_INACTIVE) then
  begin
//    OutputDebugString('deactivate');
    cancelEdits();
    InsightDlgVisible := False;
//    DoSendKey := True;
    ModalResult := mrCancel;
    Hide();
  end;

  inherited;

end;

procedure showP3InsightDlg();
begin
//  OutputDebugString('doShowP3InsightDlg->');
  if frmP3Insight = nil then
    frmP3Insight := TfrmP3Insight.Create(nil);

  if not frmP3Insight.Visible then
    frmP3Insight.ShowModal();
//  OutputDebugString('<-doShowP3InsightDlg');
end;

{ TViewer }

//function TViewer.acceptPropSubView(aSubView: TPropSubViewType): Boolean;
//begin
//  Result := False;
//end;

procedure TViewer.activePrimaryViewerChanged;
begin
  //nop
end;

procedure TViewer.cancelEdit(aVT: TBaseVirtualTree);
begin
  if aVT.IsEditing() then
    aVT.CancelEditNode();
end;

constructor TViewer.Create(aForm: TfrmP3Insight);
begin
  frm := aForm;
end;

procedure TViewer.DefaultGridShortenString(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  const S: WideString; TextSpace: Integer; RightToLeft: Boolean;
  var Result: WideString; var Done: Boolean);
begin
  Result := S;
  Done := True;
end;

function TViewer.getColTagOf(aVT: TVirtualStringTree;
  const col: Integer): Integer;
begin
  Result := aVT.Header.Columns[col].Tag;
end;

function TViewer.getRecCount: Integer;
begin
  Result := -1;
end;

procedure TViewer.initGrid(aVT: TVirtualStringTree);
begin
  aVT.NodeDataSize := SizeOf(Pointer);
  aVT.DefaultText := '';

  aVT.Colors.FocusedSelectionColor := selectionColor;
  aVT.Colors.FocusedSelectionBorderColor := selectionColor;
  aVT.Colors.SelectionRectangleBlendColor := selectionColor;
  aVT.Colors.SelectionRectangleBorderColor := selectionColor;
  aVT.Colors.UnfocusedSelectionColor := selectionColor;
  aVT.Colors.UnfocusedSelectionBorderColor := selectionColor;

  aVT.Colors.HighlightTextColor := clBlack;
  aVT.OnShortenString := DefaultGridShortenString;
end;

procedure TViewer.prepare;
begin
  if not prepared then
  begin
    internalPrepare();
    prepared := True;
  end;
end;

procedure TViewer.reset;
begin
  internalReset();
  prepared := False;
end;

procedure TViewer.update;
begin
  frm.beginInternalUpdate();
  try
    prepare();
    internalUpdate();
  finally
    frm.endInternalUpdate();
  end;
end;

{ TTraderListViewer }

//function TTraderListViewer.acceptPropSubView(
//  aSubView: TPropSubViewType): Boolean;
//begin
//  Result := False;
//end;
//
//function TCityDetaiViewer.acceptPropSubView(
//  aSubView: TPropSubViewType): Boolean;
//begin
//  Result := aSubView = SUBVIEW_RESIDENT;
//end;

procedure TCityDetaiViewer.boModAddGoods(gid, tag: integer);
begin
  frm.currBO.GoodsStore[gid] := frm.currBO.GoodsStore[gid] + tag * UNIT_TONG;
end;

procedure TCityDetaiViewer.btnCityDetail_Building_RefreshClick(Sender: TObject);
var
  first, idx: word;
  cb: PCityBuilding;
  g: TVirtualStringTree;
begin
  if frm.currCityPtr = nil then
    exit;

  g := frm.CityDetail_BuildingGrid;
  g.BeginUpdate();
  try
    g.Clear();

    idx := frm.currCityptr.FirstFinishedBuildingIndex;
    first := idx;

//    dbgStr('idx=' + wordToHexStr(idx));

    while (idx <> $FFFF) do
    begin
      g.AddChild(nil, pointer(idx));

      cb := getCityBuilding(frm.currCityPtr, idx);

      idx := cb.NextIndex;

      if (idx = first) then
        Break;
    end;
    
    idx := frm.currCityptr.FirstUnfinishedBuildingIndex;
    first := idx;

//    dbgStr('idx=' + wordToHexStr(idx));

    while (idx <> $FFFF) do
    begin
      g.AddChild(nil, pointer(idx));

      cb := getCityBuilding(frm.currCityPtr, idx);

      idx := cb.NextIndex;
      
      if (idx = first) then
        Break;
    end;
  finally
    g.EndUpdate();
  end;
end;

procedure TCityDetaiViewer.btnCityDetail_Dockyard_BookingClick(Sender: TObject);
var
  i, cnt, success: integer;
  msg: WideString;
begin
  success := 0;
  cnt := frm.seCityDetail_Dockyard_BookingQty.AsInteger;

  for I := 1 to cnt do
  begin
    if buildShip(0,
            frm.rgCityDetail_Dockyard_BookingShipType.ItemIndex,
            frm.currCity,
            frm.cbCityDetail_Dockyard_Booker.ItemIndex) then
      Inc(success)
    else
      Break;
  end;

  if success < cnt then
  begin
    soundBeep();
    msg := WideFormat('物资不足，只订造了%d艘船只', [success]);
    frm.showMsg(MT__ERROR, msg);
  end
  else
  begin
    msg := '成功订造了指定数量的船只。';
    frm.showMsg(MT__INFO, msg);
  end;

  frm.updateUI();
end;

procedure TCityDetaiViewer.btnCityDetail_NextCityClick(Sender: TObject);
var
  idx: Integer;
begin
  if frm.cbCityDetail_City.ItemIndex = frm.cbCityDetail_City.Items.Count-1 then
    idx := 0
  else
    idx := frm.cbCityDetail_City.ItemIndex + 1;

  frm.setCurrView(frm.currPlayer, idx);
end;

procedure TCityDetaiViewer.btnCityDetail_NextTraderClick(Sender: TObject);
var
  idx: integer;
begin
  if frm.cbCityDetail_Trader.ItemIndex = frm.cbCityDetail_Trader.Items.Count-1 then
    idx := 0
  else
    idx := frm.cbCityDetail_Trader.ItemIndex + 1;

  frm.setCurrView(idx, frm.currCity);
end;

procedure TCityDetaiViewer.btnCityDetail_PrevCityClick(Sender: TObject);
var
  idx: Integer;
begin
  if frm.cbCityDetail_City.ItemIndex = 0 then
    idx := frm.cbCityDetail_City.Items.Count-1
  else
    idx := frm.cbCityDetail_City.ItemIndex - 1;

  frm.setCurrView(frm.currPlayer, idx);
end;

procedure TCityDetaiViewer.btnCityDetail_PrevTraderClick(Sender: TObject);
var
  idx: Integer;
begin
  if frm.cbCityDetail_Trader.ItemIndex = 0 then
    idx := frm.cbCityDetail_Trader.Items.Count-1
  else
    idx := frm.cbCityDetail_Trader.ItemIndex - 1;

  frm.setCurrView(idx, frm.currCity);
end;

procedure TTraderListViewer.cancelEdits;
begin
  cancelEdit(frm.TraderListGrid);
end;

function TCityDetaiViewer.calcSurplus(goodsID: integer): integer;
var
  pid, bt: Byte;
  product, consume, mreq, remains: Integer;
  bo: PBusinessOffice;
  cache: PCityBODataCache;
begin
  Result := 0;
  if frm.currCityPtr = nil then
    exit;
    
  product := frm.currCityPtr^.GoodsProduct[goodsID] * 7;

  consume := Round(frm.residentConsumePrecalc.calcCityConsumeInWeek(goodsID, frm.currCity));

  //resident requirement
  mreq := frm.currCityPtr^.GoodsConsumes[goodsID] * 7;


  if not frm.cbCityDetail_BOCombineTraderValue.Checked then
  begin
    if frm.currBO <> nil then
    begin
      product := product + integer(frm.currBO^.FactoryProductions[goodsID] * 7);
      mreq := mreq + frm.currBO^.FactoryConsumes[goodsID] * 7;
    end;
  end
  else
  begin
    cache := @frm.cityBODataCacheList.Caches[frm.currCity];
    for pid := MIN_TRADER_ID to getLastPlayerID() do
    begin
      bo := cache.findPlayerBO(pid);
      if bo = nil then
        Continue;

      product := product + integer(bo^.FactoryProductions[goodsID] * 7);
      mreq := mreq + integer(bo^.FactoryConsumes[goodsID] * 7);
    end;
  end;
    
  Result := product - consume - mreq;
end;

procedure TCityDetaiViewer.cancelEdits;
begin
  cancelEdit(frm.CityDetailGrid);
  cancelEdit(frm.CityDetail_BOGrid);
  cancelEdit(frm.CityDetail_Dockyard_BuildingShipGrid);
end;

procedure TCityDetaiViewer.cbCityDetail_BOCombineTraderValueClick(
  Sender: TObject);
begin
  if frm.isInternalUpdating() then
    exit;

  frm.CityDetailGrid.Invalidate();
end;

procedure TCityDetaiViewer.cbCityDetail_CityChanged(sender: TObject);
begin
  if frm.isInternalUpdating() then
    exit;

  frm.setCurrView(frm.currPlayer, frm.cbCityDetail_City.ItemIndex);
end;

procedure TCityDetaiViewer.cbCityDetail_TraderChanged(sender: TObject);
begin
  if frm.isInternalUpdating() then
    exit;
    
  frm.setCurrView(frm.cbCityDetail_Trader.ItemIndex, frm.currCity);
end;

procedure TTraderListViewer.deactivate;
begin
  //nop
end;


function TTraderListViewer.findTraderListNode(
  const playerID: Byte): PVirtualNode;
var
  N: PVirtualNode;
begin
  N := frm.TraderListGrid.GetFirst();
  while N <> nil do
  begin
    if frm.TraderListGrid.GetNodeUserDataInt(N) = playerID then
    begin
      Result := N;
      exit;
    end;
    N := frm.TraderListGrid.GetNext(N);
  end;

  Result := nil; 
end;

function TTraderListViewer.getRecCount: Integer;
begin
  Result := frm.TraderListGrid.TotalCount;
end;

class function TTraderListViewer.getViewerType: TViewerType;
begin
  Result := TRADER_LIST_VIEWER;
end;

procedure TTraderListViewer.init;
begin
  initGrid(frm.TraderListGrid);
  frm.TraderListGrid.OnGetText := TraderListGridGetText;
  frm.TraderListGrid.OnBeforeItemErase := TraderListGridBeforeItemErase;
end;


procedure TTraderListViewer.internalUpdate;
begin    
  reloadTraderListDataIntoView();
end;

//procedure TTraderListViewer.pcTraderChange(Sender: TObject);
//begin
//  if frm.isInternalUpdating() then
//    exit;
//
//  frm.activePrimaryViewerChanged();
//end;


procedure TTraderListViewer.reloadTraderListDataIntoView;
begin
  frm.TraderListGrid.Invalidate();
end;

procedure TTraderListViewer.internalPrepare;
var
  I: Integer;
begin  
  for I := getCurrPlayerID() downto 0 do
  begin
    frm.TraderListGrid.AddChild(nil, pointer(i));
  end;
end;

procedure TTraderListViewer.internalReset;
begin
  frm.TraderListGrid.Clear();
end;



procedure TCityDetaiViewer.CityDetailGridAfterCellPaint(
  Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
  Column: TColumnIndex; CellRect: TRect);
var
  buy: boolean;
  idx, ilidx, t, l, p, surplus: Integer;
  r: TRect;
  s: string;
  txt: WideString;
  clr: TColor;
  f: double;
begin
  if Column = 1 then
  begin
    TargetCanvas.FillRect(CellRect);
    idx := Sender.GetNodeUserDataInt(Node);

    if isGoodsMeasuredInPkg(idx) then
      ilidx := 0
    else
      ilidx := 1;

    r := CellRect;

    l := r.Left + (r.Right - r.Left - frm.ilMeasureUnit.Width) div 2;
    t := r.Top + (r.Bottom - r.Top - frm.ilMeasureUnit.Height) div 2;

    frm.ilMeasureUnit.Draw(TargetCanvas, l, t, ilidx);
    if (Node = Sender.FocusedNode) and (Column = Sender.FocusedColumn) then
    begin
//      InflateRect(CellRect, -1, -1);
      TargetCanvas.DrawFocusRect(CellRect);
    end;
  end
  else if (Column = 11) or (Column = 12) then //buy price and sell price
  begin
    TargetCanvas.FillRect(CellRect);
    if frm.currBO = nil then
    begin
      if (Node = Sender.FocusedNode) and (Column = Sender.FocusedColumn) then
      begin
//        InflateRect(CellRect, -1, -1);
        TargetCanvas.DrawFocusRect(CellRect);
      end;
      exit;
    end;

    idx := Sender.GetNodeUserDataInt(Node);
    buy := Column = 11;
    if buy then
      p := getCitySalePriceDef(frm.currCity, idx)
    else
      p := getCityPurchasePriceDef(frm.currCity, idx);
    s := IntToStr(p);
    drawPriceCell(
              TargetCanvas.Handle,
              CellRect,
              buy,
              s,
              clBlack);
    if (Node = Sender.FocusedNode) and (Column = Sender.FocusedColumn) then
    begin
//      InflateRect(CellRect, -1, -1);
      TargetCanvas.DrawFocusRect(CellRect);
    end;
  end
  else if Column = 10 then //surplus
  begin
    TargetCanvas.FillRect(CellRect);
    idx := Sender.GetNodeUserDataInt(Node);
    surplus := calcSurplus(idx);
    if surplus = 0 then
    begin
      if (Node = Sender.FocusedNode) and (Column = Sender.FocusedColumn) then
      begin
//        InflateRect(CellRect, -1, -1);
        TargetCanvas.DrawFocusRect(CellRect);
      end;
      exit;
    end;

    if surplus < 0 then
      clr := clRed
    else
      clr := clBlack;

    s := formatQty(surplus, isGoodsMeasuredInPkg(idx));
//    f := surplus / getGoodsQtyFactor(idx);
//    s := FormatFloat('0.0', surplus);

    defaultDrawCell(frm.CityDetailGrid, Column, TargetCanvas, CellRect, clr, s);
    if (Node = Sender.FocusedNode) and (Column = Sender.FocusedColumn) then
    begin
//      InflateRect(CellRect, -1, -1);
      TargetCanvas.DrawFocusRect(CellRect);
    end;
  end;
end;

procedure TCityDetaiViewer.CityDetailGridBeforeItemErase(
  Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
  ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
var
  gid: integer;
begin
  EraseAction := eaColor;

  gid := Sender.GetNodeUserDataInt(Node);
  if (gid and 1) = 1 then
    ItemColor := clWhite
  else
    ItemColor := ODD_BK_COLOR;
end;

procedure TCityDetaiViewer.CityDetailGridDblClick(Sender: TObject);
var
  idx, gid, q: integer;
  n: PVirtualNode;
  g: TVirtualStringTree;
  cp: PCityStruct;
begin
  g := frm.CityDetailGrid;
  if g.FocusedColumn < 0  then
    exit;

  n := g.SelectedNode;
  if n = nil then
    exit;

  if g.FocusedColumn <> 4 then
    exit;

  cp := frm.currCityPtr;
  if cp = nil then
    exit;


  gid := g.GetNodeUserDataInt(n);
  if gid = GOODSID__SPICE then
    exit;

  if gid = GOODSID__WHALE_OIL then
  begin
    q := cp.WhaleOilProdRate;
    if q < $3E8 then
      cp.WhaleOilProdRate := $400
    else if q < $600 then
      cp.WhaleOilProdRate := $600
    else if q < $800 then
      cp.WhaleOilProdRate := $800
    else if q < $1000 then
      cp.WhaleOilProdRate := $1000
    else
      cp.WhaleOilProdRate := $300;
  end
  else
  begin
    idx := GoodsIDToProdRateIndex(gid);
    q := cp.OriginalProd[idx].Rate;
    if q < $384 then
      q := $400
    else if q < $600 then
      q := $600
    else if q < $800 then
      q := $800
    else if q < $1000 then
      q := $1000
    else
      q := $300;

    cp.OriginalProd[idx].Rate := q;
  end;

  frm.updateUI();  
end;

procedure TCityDetaiViewer.CityDetailGridGetImageIndex(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
  Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
begin
  ImageIndex := -1;
  if Column <> 0 then
    exit;

  if (Kind <> ikNormal) and (Kind <> ikSelected) then
    exit;

  ImageIndex := Sender.GetNodeUserDataInt(Node)-1;
end;

procedure TCityDetaiViewer.CityDetailGridGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  idx: Integer;

  procedure gt_cityStoreQty();
  begin
    CellText := formatQty(frm.currCityPtr^.GoodsStore[idx], isGoodsMeasuredInPkg(idx));
  end;

  procedure gt_BOStoreQty();
  var
    q: Integer;
  begin
    if frm.currBO = nil then
      CellText := '---'
    else
    begin
      q := frm.currBO^.GoodsStore[idx];
      if q = 0 then
        CellText := ''
      else
        CellText := formatQty(q, isGoodsMeasuredInPkg(idx));
    end;
  end;

  procedure gt_hightLowProductionRate();
  var
    r: Word;
    lvl1Cp: integer;
  begin
    r := GetCityOriginalProdRate(frm.currCityPtr, idx);
    if r = 0 then
      CellText := ''
    else
    begin

      if idx = GOODSID__WHALE_OIL then
        lvl1Cp := $3E8
      else
        lvl1Cp := $384;

      if r < lvl1Cp then
        CellText := '*'
      else if r < $600 then
        CellText := '**'
      else if r < $800 then
        CellText := '***'
      else
        CellText := '****';        
    end;
  end;

  procedure gt_ProductionScale();
  var
    bt, pid: Byte;
    I, cnt, factoryCount, factoryMaxWorkers: Integer;
    cache: PCityBODataCache;
    fg: PFactoryGroup;
    s: string;
    intensification: Byte;
  begin
    if frm.cbCityDetail_BOCombineTraderValue.Checked then
    begin
      cache := @frm.cityBODataCacheList.Caches[frm.currCity];
      if cache^.getCount()= 0 then
        CellText := ''
      else
      begin
        bt := getGoodsFactoryType(idx);
        if bt = $FF then
          CellText := ''
        else
        begin
          factoryMaxWorkers := getFactoryMaxWorker(bt);

//          OutputDebugString('step2');

          factoryCount := 0;
          for pid := MIN_TRADER_ID to getLastPlayerID() do
          begin
            fg := cache^.findFactoryGroup(pid, bt);
//            OutputDebugString('step3');
            if (fg <> nil) and (fg^.MaxWorkers > 0) then
            begin
//              OutputDebugString('step4');
              cnt := fg^.MaxWorkers div factoryMaxWorkers;
              Inc(factoryCount, cnt);
//              OutputDebugString('step5');
            end;
          end;

          if factoryCount > 0 then
            CellText := IntToStr(factoryCount)
          else
            CellText := '';
        end;
      end;
    end
    else
    begin
      if frm.currBO = nil then
        CellText := ''
      else
      begin
        bt := getGoodsFactoryType(idx);
        if bt = $FF then
          CellText := ''
        else
        begin
          fg := frm.cityBODataCacheList.findFactoryGroup(frm.currCity, frm.currPlayer, bt);
            
          if fg = nil then
            CellText := ''
          else
          begin
            factoryMaxWorkers := getFactoryMaxWorker(bt);
            s := IntToStr(fg.MaxWorkers div factoryMaxWorkers);

            intensification := fg.intensification;
            if fg.intensification <> 0 then
            begin
              if fg.ProductionFactor >= $4 then
              begin
                if intensification = $1E then
                  s := s + '(+3%)'
                else if intensification = $3D then
                  s := s + '(+6%)'
                else if intensification = $66 then
                  s := s + '(+10%)'
                else
                  s := s + '(' + byteToHexStr(intensification) + ')';
              end
              else
              begin
                if intensification = $17 then
                  s := s + '(+3%)'
                else if intensification = $24 then
                  s := s + '(+6%)'
                else if intensification = $4C then
                  s := s + '(+10%)'
                else
                  s := s + '(' + byteToHexStr(intensification) + ')';
              end;
            end;

            CellText := s;
          end;
        end;
      end;
    end;
  end;

  procedure gt_ProductionOutput();
  var
    bt, pid: Byte;
    bo: PBusinessOffice;
    fg: PFactoryGroup;
    cache: PCityBODataCache;
    outputCount, workerCount, maxCount, q, rate: Integer;
    s: string;
    c1, c2: Double;
  begin
    if not frm.cbCityDetail_BOCombineTraderValue.Checked then
    begin
      if frm.currBO = nil then
        CellText := ''
      else
      begin
        bt := getGoodsFactoryType(idx);

        if bt = $FF then
          CellText := ''
        else
        begin
          q := frm.currBO^.FactoryProductions[idx];
          if q <> 0 then
          begin
            s := formatQty(q * 7, isGoodsMeasuredInPkg(idx));

            fg := frm.cityBODataCacheList.findFactoryGroup(frm.currCity, frm.currPlayer, bt);

            if fg <> nil then
            begin
              if fg.CurrentWorkers <> fg.MaxWorkers then
              begin
                c1 := fg.CurrentWorkers;
                c2 := fg.MaxWorkers;
                c1 := c1 * 100 / c2;
                rate := Trunc(c1);
                s := s + '(' + IntToStr(rate) + '%)';
              end;
            end;

            CellText := s;
          end
          else
            CellText := '';
        end;
      end;
    end
    else
    begin
      cache := @frm.cityBODataCacheList.Caches[frm.currCity];
      if cache^.getCount()= 0 then
        CellText := ''
      else
      begin
        bt := getGoodsFactoryType(idx);
        if bt = $FF then
          CellText := ''
        else
        begin
          outputCount := 0;
          workerCount := 0;
          maxCount := 0;
          
          for pid := MIN_TRADER_ID to getLastPlayerID() do
          begin
            bo := cache.findPlayerBO(pid);
            if bo <> nil then
            begin
              outputCount := outputCount + integer(bo.FactoryProductions[idx] * 7);
              fg := cache.findFactoryGroup(pid, bt);
              if fg <> nil then
              begin
                workerCount := workerCount + fg^.CurrentWorkers;
                maxCount := maxCount + fg^.MaxWorkers;
              end;
            end;
          end;

          if outputCount > 0 then
          begin
            s := formatQty(outputCount, isGoodsMeasuredInPkg(idx));
            if workerCount <> maxCount then
            begin
              c1 := workerCount;
              c2 := maxCount;
              c1 := c1 * 100 / c2;
              s := s + '(' + FormatCurr('0.0', c1) + ')';
            end;

            CellText := s;
          end
          else
            CellText := '';
        end;
      end;
    end;
  end;

  procedure gt_MaterialReq();
  var
    q: integer;
    bo: PBusinessOffice;
    pid: Byte;
  begin
    if not frm.cbCityDetail_BOCombineTraderValue.Checked then
    begin
      if frm.currBO = nil then
        q := 0
      else
        q := frm.currBO^.FactoryConsumes[idx] * 7;
    end
    else
    begin
      q := 0;
      for pid := MIN_TRADER_ID to getLastPlayerID() do
      begin
        bo := frm.cityBODataCacheList.findBO(frm.currCity, pid);
        if bo <> nil then
          q := q + integer(bo^.FactoryConsumes[idx] * 7);
      end;
    end;

    if q = 0 then
      CellText := ''
    else
      CellText := formatQty(-q, isGoodsMeasuredInPkg(idx));
  end;

  procedure gt_cityProductAndConsume();
  var
    q: Integer;
    p, c: Integer;
  begin
    p := frm.currCityPtr^.GoodsProduct[idx];
    c := frm.currCityPtr^.GoodsConsumes[idx];
    q := p - c;
    
    if (p = 0) and (c = 0) then
      CellText := ''
    else
      CellText := formatQty(q * 7, isGoodsMeasuredInPkg(idx));
  end;

  procedure gt_surplus();
  var
    pid, bt: Byte;
    product, consume, mreq, remains: Integer;
    bo: PBusinessOffice;
    cache: PCityBODataCache;
  begin
//    dbgStr('gt_surplus->');
    product := frm.currCityPtr^.GoodsProduct[idx] * 7;

    //resident requirement
    consume := Round(frm.residentConsumePrecalc.calcCityConsumeInWeek(idx, frm.currCity));

    mreq := frm.currCityPtr^.GoodsConsumes[idx] * 7;



    if not frm.cbCityDetail_BOCombineTraderValue.Checked then
    begin
      if frm.currBO <> nil then
      begin
//        dbgStr('product=' + IntToStr(product));
//        dbgStr('consume=' + IntToStr(consume));
//        dbgStr('mreq=' + IntToStr(mreq));
        product := product + integer(frm.currBO^.FactoryProductions[idx] * 7);
        mreq := mreq + frm.currBO^.FactoryConsumes[idx] * 7;
//        dbgStr('product2=' + IntToStr(product));
//        dbgStr('mreq2=' + IntToStr(mreq));
      end;
    end
    else
    begin
      cache := @frm.cityBODataCacheList.Caches[frm.currCity];
      for pid := MIN_TRADER_ID to getLastPlayerID() do
      begin
        bo := cache.findPlayerBO(pid);
        if bo = nil then
          Continue;

        product := product + integer(bo^.FactoryProductions[idx] * 7);
        mreq := mreq + integer(bo^.FactoryConsumes[idx] * 7);
      end;
    end;
    
    remains := product - consume - mreq;

//    dbgStr('remains=' + IntToStr(remains));

    if remains = 0 then
      CellText := ''
    else
      CellText := formatQty(remains, isGoodsMeasuredInPkg(idx));

//    dbgStr('<-gt_surplus');
  end;

  procedure gt_ResidentReq();
  var
    c: Double;
  begin
    c := frm.residentConsumePrecalc.calcCityConsumeInWeek(idx, frm.currCity);
    if frm.winter then
      c := calcWinterReqIncrease(c, idx);
      
    if c = 0 then
      CellText := ''
    else
      CellText := formatQty(-Round(c), isGoodsMeasuredInPkg(idx));
  end;

  procedure gt_salePrice();
  begin
    CellText := IntToStr(getCityPurchasePriceDef(frm.currCity, idx));
  end;

  procedure gt_purchasePrice();
  begin
    CellText := IntToStr(getCitySalePriceDef(frm.currCity, idx));
  end;

begin
  idx := Sender.GetNodeUserDataInt(Node);

  try
    case Column of
      0: //goods name
        CellText := getGoodsName(idx);

      1: // unit, usage image
        CellText := '';

      2: //city store qty
        gt_cityStoreQty();

      3: //bo store qty
        gt_BOStoreQty();

      4: //高低产
        gt_hightLowProductionRate();

      5: //规模
        gt_ProductionScale();

      6: //产量
        gt_ProductionOutput();

      7: //市民需求
        gt_ResidentReq();

      8: //城镇消费
        gt_cityProductAndConsume();

      9: //原料需求
        gt_MaterialReq();

      10: //剩余缺口
        gt_surplus();

      11: //sale-price
        gt_salePrice();

      12: //purchase-price
        gt_purchasePrice();
    end;
  except
    on E: Exception do
    begin
      CellText := 'Error';
    end;

  else
    raise;
  end;
end;

//procedure TCityDetaiViewer.CityDetailGridPaintCell(
//  aSender: TBaseVirtualTree; aPaintInfo: TVTPaintInfo;
//  var aDefaultDraw: Boolean);
//var
//  buy: boolean;
//  idx, ilidx, t, l, p: Integer;
//  r: TRect;
//  s: string;
//  txt: WideString;
//begin
//  aDefaultDraw := True;
////
////  if aPaintInfo.Column = 1 then
////  begin
////    aPaintInfo.Canvas.FillRect(aPaintInfo.CellRect);
////    idx := aSender.GetNodeUserDataInt(aPaintInfo.Node);
////
////    if isGoodsMeasuredInPkg(idx) then
////      ilidx := 0
////    else
////      ilidx := 1;
////
////    r := aPaintInfo.CellRect;
////
////    l := r.Left + (r.Right - r.Left - frm.ilMeasureUnit.Width) div 2;
////    t := r.Top + (r.Bottom - r.Top - frm.ilMeasureUnit.Height) div 2;
////
////    frm.ilMeasureUnit.Draw(aPaintInfo.Canvas, l, t, ilidx);
////    aDefaultDraw := False;
////  end
////  else if (aPaintInfo.Column = 11) or (aPaintInfo.Column = 12) then
////  begin
////    aDefaultDraw := False;
////    aPaintInfo.Canvas.FillRect(aPaintInfo.CellRect);
////    if frm.currBO = nil then
////      exit;
////
////
////
////    idx := aSender.GetNodeUserDataInt(aPaintInfo.Node);
////    buy := aPaintInfo.Column = 11;
////    if buy then
////      p := getCitySalePriceDef(frm.currCity, idx)
////    else
////      p := getCityPurchasePriceDef(frm.currCity, idx);
////    s := IntToStr(p);
////    drawPriceCell(
////              aPaintInfo.Canvas.Handle,
////              aPaintInfo.CellRect,
////              buy,
////              s,
////              clBlack);
////
////    aDefaultDraw := False;
////  end
////  else
////  begin
////    txt := '';
////    CityDetailGridGetText(frm.CityDetailGrid, aPaintInfo.Node, aPaintInfo.Column, ttNormal, txt);
////    defaultDrawCell(frm.CityDetailGrid, aPaintInfo, clBlack, txt);
////    aDefaultDraw := False;
////  end;
//end;

procedure TCityDetaiViewer.CityDetail_BOGridBeforeItemErase(
  Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
  ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
var
  gid: integer;
begin
  EraseAction := eaColor;

  gid := Sender.GetNodeUserDataInt(Node);
  if (gid and 1) = 1 then
  begin
    ItemColor := clWhite;
  end
  else
  begin
    ItemColor := ODD_BK_COLOR;
  end;
end;

procedure TCityDetaiViewer.CityDetail_BOGridCreateEditor(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  out EditLink: IVTEditLink);
var
  allowed: boolean;
  tag: integer;
begin
  if frm.currBO = nil then
    exit;

  if frm.currPlayer <> getCurrPlayerID() then
    exit;

  tag := getColTagOf(frm.CityDetail_BOGrid, Column);

  Allowed := (tag = BOTAG__TRADE_QTY) or (tag = BOTAG__TRADE_PRICE);
  if allowed then
    EditLink := TMyStringEditLink.Create();
end;

procedure TCityDetaiViewer.CityDetail_BOGridDblClick(Sender: TObject);
var
  n: PVirtualNode;
  gid: integer;
  g: TVirtualStringTree;
  restricted: Boolean;
begin
  if frm.currBO = nil then
    exit;

  g := frm.CityDetail_BOGrid;

  if g.FocusedColumn < 0 then
    exit;

  n := g.SelectedNode;
  if n = nil then
    exit;

  gid := g.GetNodeUserDataInt(n);

  if getColTagOf(
          g,
          g.FocusedColumn) = BOTAG__SHIP_LOAD_RESTRICT then
  begin
    restricted := frm.currBO.isTradeShipLoadRestricted(gid);
    frm.currBO.setTradeShipLoadRestricted(gid, not restricted);

    g.Invalidate();
  end;
end;

procedure TCityDetaiViewer.CityDetail_BOGridEditing(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
var
  tag: integer;
begin
  Allowed := False;

  if frm.currBO = nil then
    exit;

  if frm.currPlayer <> getCurrPlayerID() then
    exit;

  tag := getColTagOf(frm.CityDetail_BOGrid, Column);

  Allowed := (tag = BOTAG__TRADE_QTY) or (tag = BOTAG__TRADE_PRICE);
end;

procedure TCityDetaiViewer.CityDetail_BOGridFocusChanged(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
var
  tag: integer;
begin
  if Node = nil then
    exit;

  if frm.currBO = nil then
    exit;

  if frm.currPlayer <> getCurrPlayerID() then
    exit;
    
  tag := getColTagOf(frm.CityDetail_BOGrid, Column);

  if (tag = BOTAG__TRADE_QTY) or (tag = BOTAG__TRADE_PRICE) then
    Sender.EditNode(Node, Column);
end;

procedure TCityDetaiViewer.CityDetail_BOGridGetImageIndex(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
  Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
begin
  ImageIndex := -1;
  if Column <> 0 then
    exit;

  if (Kind <> ikNormal) and (Kind <> ikSelected) then
    exit;

  ImageIndex := Sender.GetNodeUserDataInt(Node)-1;
end;

procedure TCityDetaiViewer.CityDetail_BOGridGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  idx: integer;
  
  procedure gt_BOStoreQty();
  var
    q: Integer;
  begin
    if frm.currBO <> nil then
    begin
      q := frm.currBO^.GoodsStore[idx];
      if q <> 0 then
        CellText := formatQty(q, isGoodsMeasuredInPkg(idx));
    end;
  end;

  procedure gt_TradeOpType();
  begin
    if frm.currBO = nil then
    begin
      CellText := '---';
      exit;
    end;
      
    case frm.currBO^.getTradeOpType(idx) of
      OT__Buy: CellText := '买入';
      OT__Sell: CellText := '卖出';
    end;
  end;

  procedure gt_TradeQty();
  var
    op: TTradeOpType;
    q, store: integer;
    s: string;
  begin
    if frm.currBO = nil then
      exit;
      
    op := frm.currbo.getTradeOpType(idx);
    if op <> OT__Unspecified then
    begin
      q := frm.currBO.getTradeQty(idx);
      if q <> 0 then
      begin
//        store := frm.currbo.GoodsStore[idx];
//
//        if op = OT__Buy then
//        begin
//          if store >= q then
//            s := '╤'
//          else
//            s := '';
//        end
//        else s := '';

        s := {s + }formatQty(q, isGoodsMeasuredInPkg(idx));
        CellText := s;
      end;
    end;
  end;

  procedure gt_TradePrice();
  var
    op: TTradeOpType;
    p: integer;
  begin
    if frm.currBO = nil then
      exit;
      
    op := frm.currbo.getTradeOpType(idx);
    if op <> OT__Unspecified then
    begin
      p := frm.currbo.getTradePrice(idx);
      CellText := IntToStr(p);
    end;
  end;



  procedure gt_ProductionScale();
  var
    bt, intensification: byte;
    fg: PFactoryGroup;
    factoryMaxWorkers: integer;
    s: string;
  begin
    if frm.currBO = nil then
      CellText := ''
    else
    begin
      bt := getGoodsFactoryType(idx);
      if bt = $FF then
        CellText := ''
      else
      begin
        fg := frm.cityBODataCacheList.findFactoryGroup(frm.currCity, frm.currPlayer, bt);
            
        if fg = nil then
          CellText := ''
        else
        begin
          factoryMaxWorkers := getFactoryMaxWorker(bt);
          s := IntToStr(fg.MaxWorkers div factoryMaxWorkers);

          intensification := fg.intensification;
          if fg.intensification <> 0 then
          begin
            if fg.ProductionFactor >= $4 then
            begin
              if intensification = $1E then
                s := s + '(+3%)'
              else if intensification = $3D then
                s := s + '(+6%)'
              else if intensification = $66 then
                s := s + '(+10%)'
              else
                s := s + '(' + byteToHexStr(intensification) + ')';
            end
            else
            begin
              if intensification = $17 then
                s := s + '(+3%)'
              else if intensification = $24 then
                s := s + '(+6%)'
              else if intensification = $4C then
                s := s + '(+10%)'
              else
                s := s + '(' + byteToHexStr(intensification) + ')';
            end;
          end;

          CellText := s;
        end;
      end;
    end;
  end;

  procedure gt_ProductionOutput();
  var
    bt, pid: Byte;
    bo: PBusinessOffice;
    fg: PFactoryGroup;
    cache: PCityBODataCache;
    outputCount, workerCount, maxCount, q, rate: Integer;
    s: string;
    c1, c2: Double;
  begin
    if frm.currBO = nil then
      CellText := ''
    else
    begin
      bt := getGoodsFactoryType(idx);

      if bt = $FF then
        CellText := ''
      else
      begin
        q := frm.currBO^.FactoryProductions[idx];
        if q <> 0 then
        begin
          s := formatQty(q * 7, isGoodsMeasuredInPkg(idx));

          fg := frm.cityBODataCacheList.findFactoryGroup(frm.currCity, frm.currPlayer, bt);

          if fg <> nil then
          begin
            if fg.CurrentWorkers <> fg.MaxWorkers then
            begin
              c1 := fg.CurrentWorkers;
              c2 := fg.MaxWorkers;
              c1 := c1 * 100 / c2;
              rate := Trunc(c1);
              s := s + '(' + IntToStr(rate) + '%)';
            end;
          end;

          CellText := s;
        end
        else
          CellText := '';
      end;
    end;
  end;

  procedure gt_ShipLoadRestrict();
  begin
    if frm.currBO = nil then
      exit;

    if frm.currBO.isTradeShipLoadRestricted(idx) then
      CellText := '√';
  end;

  procedure gt_CitySPrice();
  begin
    if frm.currCityPtr <> nil then
      CellText := IntToStr(getCitySalePriceDef(frm.currCity, idx));
  end;

  procedure gt_CityPPrice();
  var
    p: integer;
  begin
    if frm.currCityPtr <> nil then
    begin      
      CellText := IntToStr(getCityPurchasePriceDef(frm.currCity, idx));
    end;
  end;

  procedure gt_CityStore();
  var
    q: integer;
  begin
    if frm.currCityPtr <> nil then
    begin
      q := frm.currCityPtr.GoodsStore[idx];
      if q <> 0 then
        CellText := formatQty(q, isGoodsMeasuredInPkg(idx));
    end;
  end;

begin
  idx := Sender.GetNodeUserDataInt(Node);

  case getColTagOf(frm.CityDetail_BOGrid, Column) of
    BOTAG__GOODS_NAME: //goods name
      CellText := getGoodsName(idx);

    BOTAG__MEASURE_UNIT: //measure unit
      ;

    BOTAG__BO_STORE: //bo store
      gt_BOStoreQty();

    BOTAG__TRADE_OP: //贸易设定
      gt_TradeOpType();

    BOTAG__TRADE_QTY: //贸易数量
      gt_TradeQty();

    BOTAG__TRADE_PRICE: //贸易价格
      gt_TradePrice();

    BOTAG__SHIP_LOAD_RESTRICT: //船只装载限制
      gt_ShipLoadRestrict();

    BOTAG__CITY_STORE:
      gt_CityStore();

    BOTAG__CITY_SPRICE:
      gt_CitySPrice();

    BOTAG__CITY_PPRICE:
      gt_CityPPrice();

    BOTAG__PROD_SCALE: //生产规模
      gt_ProductionScale();

    BOTAG__PROD_QTY: //产量
      gt_ProductionOutput();
  end;
end;


procedure TCityDetaiViewer.CityDetail_BOGridKeyPress(Sender: TObject;
  var Key: Char);
var
  n: PVirtualNode;
  g: TVirtualStringTree;
  gid, tag: integer;
  restricted: boolean;
begin
  if (frm.currBO = nil) then
    exit;

  g := frm.CityDetail_BOGrid;
  if g.IsEditing() then
    exit;

  if g.SelectedCount = 0 then
  begin
    soundBeep();
    exit;
  end;
  
  tag := getColTagOf(g, g.FocusedColumn);

  gid := g.GetNodeUserDataInt(g.FocusedNode);
  
  if tag = BOTAG__TRADE_OP then
  begin
    case Key of
      'b', 'B':
      begin
        frm.currBO.setTradeOpType(gid, OT__Buy, frm);
        g.Invalidate();
        exit;
      end;
      
      's', 'S':
      begin
        frm.currBO.setTradeOpType(gid, OT__Sell, frm);
        g.Invalidate();
        exit;
      end;

      ' ':
      begin
        frm.currBO.setTradeOpType(gid, OT__Unspecified, frm);
        g.Invalidate();
        exit;
      end;
    end;
  end
  else if tag = BOTAG__SHIP_LOAD_RESTRICT then
  begin
    if key = ' ' then
    begin
      restricted := frm.currbo.isTradeShipLoadRestricted(gid);
      frm.currBO.setTradeShipLoadRestricted(gid, not restricted);

      g.Invalidate();
      exit;
    end;
  end;

  soundBeep();
end;

procedure TCityDetaiViewer.CityDetail_BOGridNewText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; NewText: WideString);
var
  gid, q, p, tag, factor: integer;
  allowed: boolean;
begin
  if frm.currBO = nil then
    exit;

  if frm.currPlayer <> getCurrPlayerID() then
    exit;

  tag := getColTagOf(frm.CityDetail_BOGrid, Column);

  Allowed := (tag = BOTAG__TRADE_QTY) or (tag = BOTAG__TRADE_PRICE);
  if not allowed then
    exit;

  gid := Sender.GetNodeUserDataInt(Node);

  case tag of
    BOTAG__TRADE_QTY:
    begin
      if not TryStrToInt(NewText, q) or (q < 0) then
      begin
        soundBeep();
        exit;
      end;

      if frm.currBO.getTradeOpType(gid) = OT__Unspecified then
        frm.currBO.setTradeOpType(gid, OT__Sell, frm);

      if isGoodsMeasuredInPkg(gid) then
        factor := UNIT_PKG
      else
        factor := UNIT_TONG;

      q := q * factor;

      frm.currBO.setTradeQty(gid, q);
      Sender.Invalidate();
    end;

    BOTAG__TRADE_PRICE:
    begin
      if not TryStrToInt(NewText, p) then
      begin
        soundBeep();
        exit;
      end;

      frm.currBO.setTradePrice(gid, p);
      Sender.Invalidate();
    end;
  end;
end;

procedure TCityDetaiViewer.CityDetail_BOGridPaintCell(aSender: TBaseVirtualTree;
  aPaintInfo: TVTPaintInfo; var aDefaultDraw: Boolean);
var
  buy: boolean;
  tag, idx, ilidx, t, l, p, gid: Integer;
  r: TRect;
  s: string;
  op: TTradeOpType;
  dc: HDC;
begin
  tag := getColTagOf(frm.CityDetail_BOGrid, aPaintInfo.Column);

  if tag = BOTAG__MEASURE_UNIT then
  begin
    idx := aSender.GetNodeUserDataInt(aPaintInfo.Node);

    if isGoodsMeasuredInPkg(idx) then
      ilidx := 0
    else
      ilidx := 1;

    r := aPaintInfo.CellRect;

    l := r.Left + (r.Right - r.Left - frm.ilMeasureUnit.Width) div 2;
    t := r.Top + (r.Bottom - r.Top - frm.ilMeasureUnit.Height) div 2;

    frm.ilMeasureUnit.Draw(aPaintInfo.Canvas, l, t, ilidx);
    aDefaultDraw := False;
  end
  else if (tag = BOTAG__TRADE_PRICE) then
  begin
    if (frm.currBO <> nil) then
    begin
      gid := aSender.GetNodeUserDataInt(aPaintInfo.Node);
      op := frm.currBO.getTradeOpType(gid);
      if op = OT__Unspecified then
        exit;

      s := IntToStr(frm.currbo.getTradePrice(gid));
      drawPriceCell(aPaintInfo.Canvas.Handle, aPaintInfo.CellRect, op = OT__Buy, s, clBlack);
    end;

    aDefaultDraw := True;
  end
  else if (tag = BOTAG__CITY_SPRICE) or (tag = BOTAG__CITY_PPRICE) then
  begin
      buy := tag = BOTAG__CITY_SPRICE;
      gid := aSender.GetNodeUserDataInt(aPaintInfo.Node);
      
      if buy then
        p := getCitySalePriceDef(frm.currCity, gid)
      else
        p := getCityPurchasePriceDef(frm.currCity, gid);
      s := IntToStr(p);
      dc := aPaintInfo.Canvas.Handle;
      r := aPaintInfo.CellRect;
      drawPriceCell(dc, r, buy, s, clBlack);

      if (frm.currBO <> nil) and (aSender.Selected[aPaintInfo.Node]) then
      begin
        op := frm.currbo.getTradeOpType(gid);
        if op = OT__Buy then
        begin
          if tag = BOTAG__CITY_SPRICE then
          begin
            InflateRect(r, -4, 0);
            DrawSquigglyUnderlineEx(dc, frm.bluePen, r.Left, r.Bottom-2, r.Right-r.Left);
          end;
        end
        else if op = OT__Sell then
        begin
          if tag = BOTAG__CITY_PPRICE then
          begin
            InflateRect(r, -4, 0);
            DrawSquigglyUnderlineEx(dc, frm.bluePen, r.Left, r.Bottom-2, r.Right-r.Left);
          end;
        end;
      end;

    aDefaultDraw := True;
  end
  else
  begin

    aDefaultDraw := True;
  end;
end;

procedure TCityDetaiViewer.CityDetail_BO_WeaponStoreGetText(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType; var CellText: WideString);
var
  rec, idx, q: integer;
  g: TVirtualStringTree;
begin
  if Column < 0 then
    exit;

  if frm.currBO = nil then
    exit;

  g := frm.CityDetail_BO_WeaponStore;
  rec := g.GetNodeUserDataInt(Node);

  case rec of
    WEAPTAG__CITY_WEAPON_1..WEAPTAG__CITY_WEAPON_4:
    begin
      idx := rec - WEAPTAG__CITY_WEAPON_1 + CITY_WEAPON_1;
      q := frm.currBO.CityWeaponStore[idx];
      q := q div CITY_WEAPON_WEIGH_FACTOR;
      CellText := IntToStr(q);
    end;

    WEAPTAG__SHIP_WEAPON_1..WEAPTAG__SHIP_WEAPON_6:
    begin
      idx := rec - WEAPTAG__SHIP_WEAPON_1 + SHIP_WEAPON_1;
      q := frm.currBO.ShipWeapons[idx];
      q := q div getCityShipWeaponWeighFactor(idx);
      CellText := IntToStr(q);
    end;

    WEAPTAG__SWORD:
    begin
      CellText := IntToStr(frm.currbo.Sword);
    end;
  end;
end;

procedure TCityDetaiViewer.CityDetail_BuildingGridGetText(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType; var CellText: WideString);
var
  idx: word;
  cb: PCityBuilding;
begin
  if frm.currCityPtr = nil then
    exit;

  if Column < 0 then
    exit;

  idx := Sender.GetNodeUserDataInt(Node);

  cb := getCityBuilding(frm.currCityPtr, idx);
  case Column of
    0: //x
      CellText := IntToStr(cb.CoordinateX);

    1: //y
      CellText := IntToStr(cb.CoordinateY);

    2: //owner
      CellText := byteToHexStr(cb.Owner);

    3: //type
      CellText := getBuildingTypeName(cb.BuildingType);

    4: //DaysTC
      if cb.DaysNeedToComplete = $FF then
        CellText := '$FF'
      else
        CellText := IntToStr(cb.DaysNeedToComplete);

    5: //Direct
      CellText := byteToHexStr(cb.ImageDirection);
  end;    
end;

procedure TCityDetaiViewer.CityDetail_Dockyard_BuildingShipGridGetText(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType; var CellText: WideString);
var
  ship: PP3R2Ship;

  procedure gt_ShipType();
  begin
    CellText := getShipTypeText(ship.ShipType);
  end;

  procedure gt_BookingDate();
  begin
    CellText := timestampToDateStr(ship.ReachNextPointTS);
  end;

  procedure gt_Capacity();
  begin
    CellText := formatQty(ship.LoadUpLimit, False);
  end;

  procedure gt_MaxPoint();
  begin
    CellText := IntToStr(ship.MaxPoint);
  end;

  procedure gt_Progress();
  begin
    if ship.CurrPoint = 0 then
      CellText := ''
    else
    begin
      if ship.MaxPoint = 0 then
        CellText := 'Error'
      else
        CellText := FormatFloat('0.0', ship.CurrPoint * 100 / ship.MaxPoint) + '%';
    end;
  end;   
  
begin
  ship := Sender.GetNodeUserData(Node);

  case Column of
    0: gt_ShipType();
    1: gt_BookingDate();
    2: gt_Capacity();
    3: gt_MaxPoint();
    4: gt_Progress();
  end;
end;

procedure TCityDetaiViewer.deactivate;
begin
  //nop
  frm.CityDetail_Dockyard_BuildingShipGrid.Clear();
  frm.CityDetail_BuildingGrid.Clear();
end;

procedure TCityDetaiViewer.drawEmote(pb: TPaintBox; aSatisfy: Smallint);
begin
  pb.Canvas.Draw(0, 0, frm.mapSatisfyEmotes(aSatisfy).Picture.Graphic);
end;

function TCityDetaiViewer.getRecCount: Integer;
begin
  if frm.pcCityDetail.ActivePageIndex = 0 then
    Result := frm.CityDetailGrid.TotalCount
  else
    Result := frm.CityDetail_BOGrid.TotalCount;
end;

class function TCityDetaiViewer.getViewerType: TViewerType;
begin
  Result := CITY_DETAIL_VIEWER;
end;

procedure TCityDetaiViewer.init;

  procedure initBOGridColTags();
  var
    g: TVirtualStringTree;

    procedure setTag(col, tag: integer);
    begin
      g.Header.Columns[col].Tag := tag;
    end;

  begin
    g := frm.CityDetail_BOGrid;
    setTag(0, BOTAG__GOODS_NAME);
    setTag(1, BOTAG__MEASURE_UNIT);
    setTag(2, BOTAG__TRADE_OP);
    setTag(3, BOTAG__BO_STORE);
    setTag(4, BOTAG__TRADE_QTY);
    setTag(5, BOTAG__SHIP_LOAD_RESTRICT);
    setTag(6, BOTAG__TRADE_PRICE);
    setTag(7, BOTAG__CITY_STORE);
    setTag(8, BOTAG__CITY_SPRICE);
    setTag(9, BOTAG__CITY_PPRICE);
    setTag(10, BOTAG__PROD_SCALE);
    setTag(11, BOTAG__PROD_QTY);
  end;

  procedure initcbCityDetail_Dockyard_BookingShipType();
  var
    i: integer;
  begin
    frm.rgCityDetail_Dockyard_BookingShipType.Items.Clear();
    for I := SHIP_TYPE__SHINAIKE to SHIP_TYPE__HUOERKE do
      frm.rgCityDetail_Dockyard_BookingShipType.Items.Add(getShipTypeText(i));
    frm.rgCityDetail_Dockyard_BookingShipType.ItemIndex := 0;
  end;

  procedure initBooker();
  var
    pid: integer;
  begin
    for pid := MIN_TRADER_ID to getLastPlayerID() do
    begin
      frm.cbCityDetail_Dockyard_Booker.Items.Add(IntToStr(pid) + ' ' + getPlayerName(pid));
    end;

    frm.cbCityDetail_Dockyard_Booker.ItemIndex := getLastPlayerID();
  end;

  procedure initWeapsonStoreGridContents();
  var
    I: integer;
    g: TVirtualStringTree;
  begin
    g := frm.CityDetail_BO_WeaponStore;

    for I := WEAPTAG__CITY_WEAPON_1 to WEAPTAG__SWORD do
      g.AddChild(nil, pointer(I));
  end;

begin
  initGrid(frm.CityDetailGrid);
  initGrid(frm.CityDetail_BOGrid);
  initGrid(frm.CityDetail_Dockyard_BuildingShipGrid);
  initGrid(frm.CityDetail_BO_WeaponStore);
  initGrid(frm.CityDetail_BuildingGrid);
  initBOGridColTags();
  
  frm.CityDetailGrid.OnGetText := CityDetailGridGetText;
//  frm.CityDetailGrid.OnPaintCell := CityDetailGridPaintCell;
  frm.CityDetailGrid.OnAfterCellPaint := CityDetailGridAfterCellPaint;
  frm.CityDetailGrid.OnGetImageIndex := CityDetailGridGetImageIndex;
  frm.CityDetailGrid.OnBeforeItemErase := CityDetailGridBeforeItemErase;
  frm.CityDetailGrid.OnDblClick := CityDetailGridDblClick;

//  frm.CityDetailGrid.OnKeyPress :=


  frm.CityDetail_BOGrid.OnGetText := CityDetail_BOGridGetText;
  frm.CityDetail_BOGrid.OnGetImageIndex := CityDetail_BOGridGetImageIndex;
  frm.CityDetail_BOGrid.OnPaintCell := CityDetail_BOGridPaintCell;
  frm.CityDetail_BOGrid.OnBeforeItemErase := CityDetail_BOGridBeforeItemErase;
  frm.CityDetail_BOGrid.OnDblClick := CityDetail_BOGridDblClick;
  frm.CityDetail_BOGrid.OnKeyPress := CityDetail_BOGridKeyPress;
  frm.CityDetail_BOGrid.OnNewText := CityDetail_BOGridNewText;
  frm.CityDetail_BOGrid.OnEditing := CityDetail_BOGridEditing;
  frm.CityDetail_BOGrid.OnFocusChanged := CityDetail_BOGridFocusChanged;
  frm.CityDetail_BOGrid.OnCreateEditor := CityDetail_BOGridCreateEditor;

  frm.cbCityDetail_Trader.OnChange := cbCityDetail_TraderChanged;
  frm.cbCityDetail_City.OnChange := cbCityDetail_CityChanged;

  frm.btnCityDetail_PrevTrader.OnClick := btnCityDetail_PrevTraderClick;
  frm.btnCityDetail_NextTrader.OnClick := btnCityDetail_NextTraderClick;

  frm.btnCityDetail_PrevCity.OnClick := btnCityDetail_PrevCityClick;
  frm.btnCityDetail_NextCity.OnClick := btnCityDetail_NextCityClick;

  frm.cbCityDetail_BOCombineTraderValue.OnClick := cbCityDetail_BOCombineTraderValueClick;


  frm.pbTraderList_SatisfyRich.OnPaint := pbTraderList_SatisfyRichPaint;
  frm.pbTraderList_SatisfyCommon.OnPaint := pbTraderList_SatisfyCommonPaint;
  frm.pbTraderList_SatisfyPoor.OnPaint := pbTraderList_SatisfyPoorPaint;

  frm.imgCityDetail_Dockyard_ShipLvlIcon1.SetupBitmap();
  frm.imgCityDetail_Dockyard_ShipLvlIcon2.SetupBitmap();
  frm.imgCityDetail_Dockyard_ShipLvlIcon3.SetupBitmap();
  frm.imgCityDetail_Dockyard_ShipLvlIcon4.SetupBitmap();

  frm.CityDetail_Dockyard_BuildingShipGrid.OnGetText := CityDetail_Dockyard_BuildingShipGridGetText;
  frm.btnCityDetail_Dockyard_Booking.OnClick := btnCityDetail_Dockyard_BookingClick;

  frm.CityDetail_BuildingGrid.OnGetText := CityDetail_BuildingGridGetText;
  frm.btnCityDetail_Building_Refresh.OnClick := btnCityDetail_Building_RefreshClick;

  initBooker();
  initcbCityDetail_Dockyard_BookingShipType();

  frm.CityDetail_BO_WeaponStore.OnGetText := CityDetail_BO_WeaponStoreGetText;
  initWeapsonStoreGridContents();


  frm.pcCityDetail_BO.ActivePageIndex := 0;

  if not Conf.AllowModify then
  begin
    frm.miBOModItems.Enabled := False;
    frm.miCityDetail_Dockyard_SetShipCompleteNow.Enabled := False;
    exit;
  end;

  frm.miBO_Mod_BuildShipMaterialAdd100.OnClick := miBO_Mod_BuildShipMaterialAddClick;
  frm.miBO_Mod_ConstructionMaterialAdd100.OnClick := miBO_Mod_ConstructionMaterialAddClick;
  frm.miBO_Mod_EnsureCelebrationGoods.OnClick := miBO_Mod_EnsureCelebrationGoodsClick;
  frm.miBO_Mod_GoodsAdd300.OnClick := miBO_Mod_GoodsAddClick;
  frm.miBO_Mod_ShipWeaponAdd100.OnClick := miBO_Mod_ShipWeaponAddClick;
  frm.miBO_Mod_CityWeaponAdd100.OnClick := miBO_Mod_CityWeaponAddClick;
  frm.miBO_Mod_SetSwordTo100.OnClick := miBO_Mod_SwordAddClick;
  
  frm.miCityDetail_Dockyard_SetShipCompleteNow.OnClick := miCityDetail_Dockyard_SetShipCompleteNowClick;
end;

procedure TCityDetaiViewer.internalPrepare;
var
  I: Integer;
begin
//  OutputDebugString('city-detail-viewer.internalPrepare->');
  frm.cbCityDetail_Trader.Items.Clear();
  for I := MIN_TRADER_ID to getLastPlayerID() do
  begin
    frm.cbCityDetail_Trader.Items.Add(IntToStr(I) + ' ' + getPlayerName(I));
  end;
  frm.cbCityDetail_Trader.ItemIndex := frm.currPlayer;

  
  frm.cbCityDetail_City.Items.Clear();
  for I := 0 to getCityCount() - 1 do
  begin
    frm.cbCityDetail_City.Items.Add(IntToStr(i) + ' ' + getCityName2(I));
  end;
  frm.cbCityDetail_City.ItemIndex := frm.currCity;

  for I := 1 to MAX_GOODS do
  begin
    frm.CityDetailGrid.AddChild(nil, pointer(i));
    frm.CityDetail_BOGrid.AddChild(nil, pointer(i));
  end;

  frm.pcCityDetail.ActivePageIndex := 0;
  frm.cbCityDetail_Dockyard_Booker.ItemIndex := getLastPlayerID();

//  OutputDebugString('<-city-detail-viewer.internalPrepare');
end;

procedure TCityDetaiViewer.internalReset;
begin
  frm.CityDetailGrid.Clear();
  frm.CityDetail_BOGrid.Clear();
  frm.CityDetail_Dockyard_BuildingShipGrid.Clear();
end;

procedure TCityDetaiViewer.internalUpdate;
var
  I, Cnt: Integer;
begin
//  dbgStr('city-detail-viewer.internalUpdate->');
  Cnt := getCityCount();

  if Cnt > frm.cbCityDetail_City.Items.Count then
  begin
    for I := frm.cbCityDetail_City.Items.Count to Cnt - 1 do
      frm.cbCityDetail_City.Items.Add(IntToStr(i) + ' ' + getCityName2(I));
  end;

  if frm.cbCityDetail_Trader.ItemIndex <> frm.currPlayer then
    frm.cbCityDetail_Trader.ItemIndex := frm.currPlayer;

  if frm.cbCityDetail_City.ItemIndex <> frm.currCity then
    frm.cbCityDetail_City.ItemIndex := frm.currCity;

//  dbgStr('internalUpdate,2');

  frm.CityDetailGrid.Invalidate();
//  dbgStr('internalUpdate,3');
  frm.CityDetail_BOGrid.Invalidate();

//  dbgStr('internalUpdate,4');
  updateResidentPanel();
//  dbgStr('internalUpdate,5');
  updateDockyardTab();
  updateGeneralBOInfo();
//  dbgStr('<-city-detail-viewer.internalUpdate');
end;

procedure TCityDetaiViewer.miBO_Mod_BuildShipMaterialAddClick(Sender: TObject);
var
  tag: integer;
begin
  if frm.currBO = nil then
  begin
    soundBeep();
    exit;
  end;

  tag := miGetTag(Sender);

  boModAddGoods(GOODSID__WOOD, tag);
  boModAddGoods(GOODSID__CLOTH, tag);
  boModAddGoods(GOODSID__TOOLS, tag);
  boModAddGoods(GOODSID__HEMP, tag);
  boModAddGoods(GOODSID__ASPHALT, tag);

  frm.updateUI();
end;

procedure TCityDetaiViewer.miBO_Mod_ConstructionMaterialAddClick(
  Sender: TObject);
var
  tag: integer;
begin
  if frm.currBO = nil then
  begin
    soundBeep();
    exit;
  end;

  tag := miGetTag(Sender);

  boModAddGoods(GOODSID__WOOD, tag);
  boModAddGoods(GOODSID__TOOLS, tag);
  boModAddGoods(GOODSID__HEMP, tag);
  boModAddGoods(GOODSID__BRICK, tag);

  frm.updateUI();
end;

procedure TCityDetaiViewer.miBO_Mod_EnsureCelebrationGoodsClick(
  Sender: TObject);
var
  cele: TCelebrationGoods;

  procedure ensure(gid: integer; q: integer);
  begin
    if frm.currBO.GoodsStore[gid] < q then
      frm.currBO.GoodsStore[gid] := q;
  end;

begin
  if frm.currBO = nil then
  begin
    soundBeep();
    exit;
  end;

  cele.get(frm.currCity);

  ensure(GOODSID__RICE, cele.rice);
  ensure(GOODSID__MEAT, cele.meat);
  ensure(GOODSID__FISH, cele.fish);
  ensure(GOODSID__BEER, cele.beer);
  ensure(GOODSID__WINE, cele.wine);
  ensure(GOODSID__HONEY, cele.honey);

  frm.updateUI();
end;

procedure TCityDetaiViewer.miBO_Mod_CityWeaponAddClick(Sender: TObject);
var
  i, tag: integer;
begin
  if frm.currBO = nil then
  begin
    soundBeep();
    exit;
  end;

  tag := miGetTag(Sender);

  for I := CITY_WEAPON_1 to CITY_WEAPON_4 do
  begin
    frm.currBO.CityWeaponStore[I] := frm.currBO.CityWeaponStore[I] + tag * CITY_WEAPON_WEIGH_FACTOR;
  end;

  frm.updateUI();
end;

procedure TCityDetaiViewer.miBO_Mod_GoodsAddClick(Sender: TObject);
var
  gid: integer;
  tag: integer;
begin
  if frm.currBO = nil then
  begin
    soundBeep();
    exit;
  end;

  tag := miGetTag(Sender);

  for gid := MIN_GOODS_ID to MAX_GOODS_ID do
    boModAddGoods(gid, tag);

  frm.updateUI();
end;

procedure TCityDetaiViewer.miBO_Mod_ShipWeaponAddClick(Sender: TObject);
var
  i: integer;
  tag: integer;
begin
  if frm.currBO = nil then
  begin
    soundBeep();
    exit;
  end;

  tag := miGetTag(Sender);

  for I := SHIP_WEAPON_1 to SHIP_WEAPON_6 do
  begin
    frm.currBO.ShipWeapons[i] := frm.currBO.ShipWeapons[i] + tag * getCityShipWeaponWeighFactor(i); 
  end;

  frm.updateUI();
end;

procedure TCityDetaiViewer.miBO_Mod_SwordAddClick(Sender: TObject);
begin
  if frm.currBO = nil then
  begin
    soundBeep();
    exit;
  end;

  frm.currBO.Sword := frm.currBO.Sword + miGetTag(Sender);
  frm.updateUI();
end;

procedure TCityDetaiViewer.miCityDetail_Dockyard_SetShipCompleteNowClick(
  Sender: TObject);
var
  n: PVirtualNode;
  g: TVirtualStringTree;
  ship: PP3R2Ship;
begin
  g := frm.CityDetail_Dockyard_BuildingShipGrid;

  n := g.GetFirstSelected();
  if n = nil then
  begin
    soundBeep();
    exit;
  end;

  while n <> nil do
  begin
    ship := g.GetNodeUserData(n);
    ship.CurrPoint := ship.MaxPoint;    

    n := g.GetNextSelected(n);
  end;

  frm.updateUI();
end;

function TCityDetaiViewer.miGetTag(sender: TObject): Integer;
begin
  Result := TMenuItem(sender).Tag;
end;

procedure TCityDetaiViewer.pbTraderList_SatisfyCommonPaint(Sender: TObject);
begin
  drawEmote(frm.pbTraderList_SatisfyCommon, frm.currCityPtr^.Satisfy_common);
end;

procedure TCityDetaiViewer.pbTraderList_SatisfyPoorPaint(Sender: TObject);
begin
  drawEmote(frm.pbTraderList_SatisfyPoor, frm.currCityPtr^.Satisfy_poor);
end;

procedure TCityDetaiViewer.pbTraderList_SatisfyRichPaint(Sender: TObject);
begin
  drawEmote(frm.pbTraderList_SatisfyRich, frm.currCityPtr^.Satisfy_rich);
end;

function  sortCompare_shipBuildDateDesc(a, b: pointer): integer;
var
  x, y: PP3R2Ship;
begin
  x := a;
  y := b;

  Result := y.ReachNextPointTS - x.ReachNextPointTS;
end;  

procedure TCityDetaiViewer.updateDockyardTab;
var
  cityPtr: PCityStruct;

  procedure drawLvl(img: TImage32; shipType: integer);
  var
    lvl: integer;
  begin
    lvl := cityPtr.DockyardLvl[shipType];

    if lvl < 0 then
    begin
      img.Bitmap.Clear(clWhite32);
      img.Bitmap.FrameRectS(img.Bitmap.BoundsRect(), clBlack32);
    end
    else
      frm.numBmpList.Bitmap[lvl].DrawTo(img.Bitmap);
  end;

  procedure setNextExpTxt(lbl: TLabel; shipType: integer);
  var
    nextLvl, expReq: integer;
  begin
    nextLvl := cityptr.DockyardLvl[shipType];
    if nextLvl = SHIP_LVL3 then
    begin
      lbl.Caption := '---';
      exit;
    end;

    Inc(nextLvl);

    expReq := getDockyardExpRequirement(shipType, nextLvl);
    lbl.Caption := format10thousandBaseValue(expReq);
  end;

  procedure reloadBuildingShipGrid();
  var
    i: integer;
    list, listTemp: TList;
  begin
    list := TList.Create();
    listTemp := TList.Create();
    try
      for I := MIN_TRADER_ID to getLastPlayerID() do
      begin
        listTemp.Clear();
        getShipList_Building(i, listTemp, frm.currCity);

//        dbgStr('listemp.count=' + IntToStr(listTemp.Count));

        list.Assign(listTemp, laOr);
      end;

      if list.Count > 0 then
        list.Sort(sortCompare_shipBuildDateDesc);

      frm.CityDetail_Dockyard_BuildingShipGrid.BeginUpdate();
      try
        frm.CityDetail_Dockyard_BuildingShipGrid.Clear();
        for I := 0 to List.Count - 1 do
          frm.CityDetail_Dockyard_BuildingShipGrid.AddChild(nil, list[i]);
      finally
        frm.CityDetail_Dockyard_BuildingShipGrid.EndUpdate();
      end;
    finally
      list.Destroy();
      listTemp.Destroy();
    end;
  end;   

begin
//  dbgStr('updateDockyardTab->, ' + byteToHexStr(frm.currCity));
  cityPtr := frm.currCityPtr;

  frm.lblCityDetail_DockyardExp.Caption := format10thousandBaseValue(cityptr.DockyardExp);

//  dbgStr('updateDockyardTab,1');
  drawLvl(frm.imgCityDetail_Dockyard_ShipLvlIcon1, SHIP_TYPE__SHINAIKE);
  drawLvl(frm.imgCityDetail_Dockyard_ShipLvlIcon2, SHIP_TYPE__KELEIER);
  drawLvl(frm.imgCityDetail_Dockyard_ShipLvlIcon3, SHIP_TYPE__KEGE);
  drawLvl(frm.imgCityDetail_Dockyard_ShipLvlIcon4, SHIP_TYPE__HUOERKE);

//  dbgStr('updateDockyardTab,2');

  setNextExpTxt(frm.lblCityDetail_Dockyard_ShinaikeNextLvlExpReq, SHIP_TYPE__SHINAIKE);
  setNextExpTxt(frm.lblCityDetail_Dockyard_KeleierNextLvlExpReq, SHIP_TYPE__KELEIER);
  setNextExpTxt(frm.lblCityDetail_Dockyard_KegeNextLvlExpReq, SHIP_TYPE__KEGE);
  setNextExpTxt(frm.lblCityDetail_Dockyard_HuoerkeLvlExpReq, SHIP_TYPE__HUOERKE);
//  dbgStr('updateDockyardTab,3');
  reloadBuildingShipGrid();
//  dbgStr('<-updateDockyardTab');
end;

procedure TCityDetaiViewer.updateGeneralBOInfo;
var
  req, max_guard: integer;
  bo: PBusinessOffice;
  cap: PCaptainRec;
begin
  bo := frm.currBO;
  if bo = nil then
  begin
    frm.lblCityDetail_BO_Manager.Caption := '---';
    frm.lblCityDetail_BO_Guard.Caption := '---/---';
    frm.lblCityDetail_BO_Workers.Caption := '---/---';
  end
  else
  begin
    if bo.ManagerID = $FFFF then
      frm.lblCityDetail_BO_Manager.Caption := Txt_None
    else
    begin
      cap := getCaptionInfo(bo.ManagerID);
      frm.lblCityDetail_BO_Manager.Caption := IntToStr(cap.getBOManagerTradingExpLvl()) + '级';
    end;

    req := bo.StoreHouseMaxCap;
    max_guard := ceil(req / StdStoreHouseCapacity);
    frm.lblCityDetail_BO_Guard.Caption := IntToStr(bo.Guard) + '/' + IntToStr(max_guard);
    if bo.Guard < max_guard then
      frm.lblCityDetail_BO_Guard.Font.Color := clRed
    else
      frm.lblCityDetail_BO_Guard.Font.Color := clBlack;
      
    frm.lblCityDetail_BO_Workers.Caption := IntToStr(bo.CurrWorkers) + ' / ' + IntToStr(bo.MaxWorkers);
    if bo.CurrWorkers < bo.MaxWorkers then
      frm.lblCityDetail_BO_Workers.Font.Color := clRed
    else
      frm.lblCityDetail_BO_Workers.Font.Color := clBlack;
  end;
end;

procedure TCityDetaiViewer.updateResidentPanel;

  procedure setSatisfyLabel(aLabel: TLabel; const aSatisfy: Smallint);
  begin
    aLabel.Caption := IntToStr(aSatisfy);
    if aSatisfy <= 0 then
      aLabel.Font.Color := clRed
    else if aSatisfy >= 10 then
      aLabel.Font.Color := clGreen
    else
      aLabel.Font.Color := clOlive;
  end;

  procedure setHouseCap(aLabel: TLabel; const aCurrResident: Word; const aHouseCap: Word);
  var
    c1, c2: Currency;
    s: string;
  begin
    c1 := aCurrResident;
    c2 := aHouseCap;

    if aCurrResident < aHouseCap then
      c1 := aCurrResident * 100 / aHouseCap
    else
      c1 := 100;

    aLabel.Caption := FormatCurr('0.0', c1) + '%';
    if c1 >= 90 then
      aLabel.Font.Color := clRed
    else if c1 >= 80 then
      aLabel.Font.Color := clOlive
    else
      aLabel.Font.Color := clBlack;
  end;

  procedure loadResidentsData();
  begin
    frm.lblTraderBOPopRich.Caption := IntToStr(frm.currCityPtr^.Pop_rich);
    frm.lblTraderBOPopCommon.Caption := IntToStr(frm.currCityPtr^.Pop_common);
    frm.lblTraderBOPoor.Caption := IntToStr(frm.currCityPtr^.Pop_poor);
    frm.lblTraderBOPopBeggar.Caption := IntToStr(frm.currCityPtr^.Pop_begger);
    frm.lblTraderBOPopTotal.Caption := IntToStr(frm.currCityPtr^.Pop_Total);

    setSatisfyLabel(frm.lblTraderList_SatisfyRich, frm.currCityPtr^.Satisfy_rich);
    setSatisfyLabel(frm.lblTraderList_SatisfyCommon, frm.currCityPtr^.Satisfy_common);
    setSatisfyLabel(frm.lblTraderList_SatisfyPoor, frm.currCityPtr^.Satisfy_poor);

    setHouseCap(frm.lblTraderList_HouseCapRich, frm.currCityPtr^.Pop_rich, frm.currCityPtr^.AdvHouseCap);
    setHouseCap(frm.lblTraderList_HouseCapCommon, frm.currCityPtr^.Pop_common, frm.currCityPtr^.CommonHouseCap);
    setHouseCap(frm.lblTraderList_HouseCapPoor, frm.currCityPtr^.Pop_poor, frm.currCityPtr^.PoorHouseCap);
  end;

  procedure loadPopularity();
  var
    s1, s2, s3, s4, s5: Single;
  begin
    getCityShengWang(frm.currPlayer, frm.currCity, s1, s2, s3, s4, s5);

    frm.lblCityDetail_Popularity_Construction.Caption := FormatFloat('0.0', s1);
    frm.lblCityDetail_Popularity_Public.Caption := FormatFloat('0.0', s2);
    frm.lblCityDetail_Popularity_Trade.Caption := FormatFloat('0.0', s3);
  end;
  
begin
//  dbgStr('updateResidentPanel->');
  loadResidentsData();
//  dbgStr('updateResidentPanel1');
  loadPopularity();
//  dbgStr('updateResidentPanel2');
  frm.pbTraderList_SatisfyRich.Invalidate();
  frm.pbTraderList_SatisfyCommon.Invalidate();
  frm.pbTraderList_SatisfyPoor.Invalidate();
//  dbgStr('<-updateResidentPanel');
end;

procedure TTraderListViewer.TraderListGridBeforeItemErase(
  Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
  ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
var
  pid: integer;
begin
  pid := Sender.GetNodeUserDataInt(Node);

  if (pid and 1) = 1 then
    ItemColor := ODD_BK_COLOR
  else
    ItemColor := clWhite;

  EraseAction := eaColor;
end;

procedure TTraderListViewer.TraderListGridGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  pid: Byte;
  tinfo: PTraderInfo;
begin
  pid := Sender.GetNodeUserDataInt(Node);
  
  case Column of
    0: //index
    begin
      CellText := IntToStr(pid);
    end;

    1: //ptr
      CellText := ptrToHexStr(getPlayerPtr(pid));

    2: // name
    begin
      CellText := getPlayerName(pid);
    end;

    3: // class
    begin
      CellText := getPlayerClass(pid);
    end;

    4: // total-asset
    begin
      CellText := formatMoney(getPlayerTotalAssets(pid));
    end;

    5: // cash
    begin
      CellText := formatMoney(getPlayerMoney(pid));
    end;

    6: // home city
    begin
      CellText := getCityName2(getPlayerHomeCity(pid));
    end;

    7: //office count
    begin
      tinfo := frm.traderInfoCache.get(pid);
      if tinfo.BOCount > 0 then
        CellText := IntToStr(tinfo.BOCount);
    end;

    8: // total loading cap
    begin
      CellText := formatCapacity(getPlayerTotalLoadingCap(pid), True);
      tinfo := frm.traderInfoCache.get(pid);
      CellText := CellText + ' (' + IntToStr(tinfo.ShipCount) + ')';
    end;

    9: //46c
    begin
    
    end;
  end;
end;

{ TViewerList }

procedure TViewerList.activePrimaryViewerChanged;
begin
  //nop
end;

procedure TViewerList.add(aView: TViewer);
begin
  List.Add(aView);

  case aView.getViewerType() of
    GLOBAL_VIEWER: GlobalViewer := aView;
    TRADER_LIST_VIEWER: TraderViewer := aView;
    CITY_DETAIL_VIEWER: CityDetailViewer := aView;
    SHIP_LIST_VIEWER: ShipListViewer := aView;
    CITY_LIST_VIWEER: CityListViewer := aView;
    AREA_VIEWER: AreaViewer:= aView;
    MAP_VIEWER: MapViewer := aView;
  end;
end;

procedure TViewerList.cancelEditAll;
var
  I: Integer;
begin
  for I := 0 to getCount() - 1 do
    get(i).cancelEdits();
end;

constructor TViewerList.Create(aForm: TfrmP3Insight);
begin
  List := TObjectList.Create(True);
  ActiveViewerList := TList.Create();

  add(TGlobalViewer.Create(aForm));
  add(TTraderListViewer.Create(aForm));
  add(TCityDetaiViewer.Create(aForm));
  add(TShipListViewer.Create(aForm));
  add(TCityListViewer.Create(aForm));
  add(TAreaViewer.Create(aForm));

//  add(TPropViewer.Create(aForm));
  add(TMapViewer.Create(aForm));

  ActiveViewerList.Add(GlobalViewer);

  setActivePrimaryViewer(CityListViewer);
end;

procedure TViewerList.deactivateAll;
var
  I: Integer;
  v: TViewer;
begin
//  dbgStr('deactivateAll');
  for I := 0 to getCount() - 1 do
  begin
    v := get(i);
//    if v = nil then
////      dbgStr('viewer = nil')
//    else
//      dbgStr('viewer.class=' + v.ClassName());
    get(i).deactivate();
//    dbgStr('ok');
  end;
end;

destructor TViewerList.Destroy;
begin
  FreeAndNil(List);
  FreeAndNil(ActiveViewerList);
  inherited;
end;

function TViewerList.get(const aIndex: Integer): TViewer;
begin
  Result := TViewer(List[aIndex]);
end;

function TViewerList.getActive(const aIndex: Integer): TViewer;
begin
  Result := TViewer(ActiveViewerList[aIndex]);
end;

function TViewerList.getActiveCount: Integer;
begin
  Result := ActiveViewerList.Count;
end;

function TViewerList.getCount: Integer;
begin
  Result := List.Count;
end;

function TViewerList.getViewerByType(viewerType: TViewerType): TViewer;
var
  i: integer;
begin
  for I := 0 to List.Count - 1 do
  begin
    Result := TViewer(List[I]);
    if Result.getViewerType() = viewerType then
      exit;
  end;

  raise Exception.Create('Internal error');
end;

procedure TViewerList.initAll;
var
  I: Integer;
begin
  for I := 0 to getCount() - 1 do
    get(i).init();
end;

procedure TViewerList.updateAllActive;
var
  i: Integer;
  v: TViewer;
begin
  for I := 0 to getActiveCount() - 1 do
  begin
    v := getActive(i);
//    dbgStr('Update: ' +  v.ClassName());
//    v.prepare();
    v.update();
  end;
end;

procedure TViewerList.resetAll;
var
  I: Integer;
begin
  for I := 0 to getCount() - 1 do
    get(i).reset();
end;

procedure TViewerList.setActivePrimaryViewer(aViewer: TViewer);
begin
  if aViewer = ActivePrimaryViewer then
    exit;

  if ActivePrimaryViewer <> nil then
  begin
    ActivePrimaryViewer.deactivate();
    ActiveViewerList.Remove(ActivePrimaryViewer);
  end;
  
  ActivePrimaryViewer := aViewer;
  
  if ActiveViewerList.IndexOf(aViewer) < 0 then
    ActiveViewerList.Add(aViewer);
end;

{ TGlobalViewer }

procedure TGlobalViewer.cancelEdits;
begin
  //nop
end;

procedure TGlobalViewer.deactivate;
begin
  //nop
end;

class function TGlobalViewer.getViewerType: TViewerType;
begin
  Result := GLOBAL_VIEWER;
end;

procedure TGlobalViewer.init;
begin
  if not Conf.AllowModify then
  begin
    frm.miPlayerCashModItems.Enabled := False;
    exit;
  end;

  frm.miSetPlayerMoneyX10.OnClick := OnMISetPlayerMoneyX10Click;
  frm.miSetPlayerMoneyX100.OnClick := OnMISetPlayerMoneyX10Click;
end;

procedure TGlobalViewer.internalUpdate;
var
  y, m, d: integer;
  dt: TDateTime;
  s: string;
  pid: byte;
begin
  pid := getCurrPlayerID();

  getGameDate(y, m, d);
  dt := EncodeDate(y, m, d);
  s := FormatDateTime('yyyy-mm-dd', dt);
  frm.lblDate.Caption := s;
  frm.lblPlayerCash.Caption := formatMoney(getPlayerMoney(pid));

  frm.btnPlayer.Caption := getPlayerName(pid);
  frm.btnHomeCity.Caption := getCityName2(getPlayerHomeCity(pid))
end;

procedure TGlobalViewer.OnMISetPlayerMoneyX10Click(sender: TObject);
var
  pid: byte;
  mi: TMenuItem;
begin
  mi := TMenuItem(sender);
  
  pid := getCurrPlayerID();
  setPlayerMoney(pid, getPlayerMoney(pid) * mi.Tag);

  frm.updateUI();
end;

procedure TGlobalViewer.internalPrepare;
begin
  //nop
end;

procedure TGlobalViewer.internalReset;
begin
  //nop
end;

//{ TPropViewer }
//
//procedure TPropViewer.internalUpdate;
//
//  procedure setSatisfyLabel(aLabel: TLabel; const aSatisfy: Smallint);
//  begin
//    aLabel.Caption := IntToStr(aSatisfy);
//    if aSatisfy <= 0 then
//      aLabel.Font.Color := clRed
//    else if aSatisfy >= 10 then
//      aLabel.Font.Color := clGreen
//    else
//      aLabel.Font.Color := clOlive;
//  end;
//
//  procedure setHouseCap(aLabel: TLabel; const aCurrResident: Word; const aHouseCap: Word);
//  var
//    c1, c2: Currency;
//    s: string;
//  begin
//    c1 := aCurrResident;
//    c2 := aHouseCap;
//
//    if aCurrResident < aHouseCap then
//      c1 := aCurrResident * 100 / aHouseCap
//    else
//      c1 := 100;
//
//    aLabel.Caption := FormatCurr('0.0', c1) + '%';
//    if c1 >= 90 then
//      aLabel.Font.Color := clRed
//    else if c1 >= 80 then
//      aLabel.Font.Color := clOlive
//    else
//      aLabel.Font.Color := clBlack;
//  end;
//
//  procedure loadResidentsData();
//  begin
//    frm.lblTraderBOPopRich.Caption := IntToStr(frm.currCityPtr^.Pop_rich);
//    frm.lblTraderBOPopCommon.Caption := IntToStr(frm.currCityPtr^.Pop_common);
//    frm.lblTraderBOPoor.Caption := IntToStr(frm.currCityPtr^.Pop_poor);
//    frm.lblTraderBOPopBeggar.Caption := IntToStr(frm.currCityPtr^.Pop_begger);
//    frm.lblTraderBOPopTotal.Caption := IntToStr(frm.currCityPtr^.Pop_Total);
//
//    setSatisfyLabel(frm.lblTraderList_SatisfyRich, frm.currCityPtr^.Satisfy_rich);
//    setSatisfyLabel(frm.lblTraderList_SatisfyCommon, frm.currCityPtr^.Satisfy_common);
//    setSatisfyLabel(frm.lblTraderList_SatisfyPoor, frm.currCityPtr^.Satisfy_poor);
//
//    setHouseCap(frm.lblTraderList_HouseCapRich, frm.currCityPtr^.Pop_rich, frm.currCityPtr^.AdvHouseCap);
//    setHouseCap(frm.lblTraderList_HouseCapCommon, frm.currCityPtr^.Pop_common, frm.currCityPtr^.CommonHouseCap);
//    setHouseCap(frm.lblTraderList_HouseCapPoor, frm.currCityPtr^.Pop_poor, frm.currCityPtr^.PoorHouseCap);
//  end;
//
//  procedure loadPopularity();
//  var
//    s1, s2, s3, s4, s5: Single;
//  begin
//    getCityShengWang(frm.currPlayer, frm.currCity, s1, s2, s3, s4, s5);
//
//    frm.lblCityDetail_Popularity_Construction.Caption := FormatFloat('0.0', s1);
//    frm.lblCityDetail_Popularity_Public.Caption := FormatFloat('0.0', s2);
//    frm.lblCityDetail_Popularity_Trade.Caption := FormatFloat('0.0', s3);
//  end;
//
//var
//  visible_Resident: Boolean;
//  visibleCnt: Integer;
//  viewer: TViewer;
//  firstPage: TJvStandardPage;
//begin
//  visibleCnt := 0;
//
//  viewer := frm.getActivePrimaryViewer();
//  visible_Resident := False;
//
//  if viewer <> nil then
//  begin
//    visible_Resident := frm.getActivePrimaryViewer().acceptPropSubView(SUBVIEW_RESIDENT);
//    if visible_Resident then
//      Inc(visibleCnt);
//  end;
//
//  setPropPanelFold(visibleCnt = 0);
//  firstPage := nil;
//
//  if visibleCnt > 0 then
//  begin
//    frm.PropTab.Tabs[0].Visible := visible_Resident;
//    frm.PropPanel_ResidentPage.Visible := visible_Resident;
//    
//    if visible_Resident and (firstPage = nil) then
//      firstPage := frm.PropPanel_ResidentPage;
//
//    if visible_Resident then
//    begin
//      loadResidentsData();
//      loadPopularity();
//    end;
//
//    if firstPage <> nil then
//      frm.PropPageList.ActivePage := firstPage;
//  end;
//end;
//
//procedure TPropViewer.activePrimaryViewerChanged;
//begin
//  update();
//end;
//
//procedure TPropViewer.btnPropPanelFoldingClick(Sender: TObject);
//begin
//  setPropPanelFold(frm.btnPropPanelFolding.Tag = 0);
//end;
//
//procedure TPropViewer.cancelEdits;
//begin
//  //nop
//end;
//
//procedure TPropViewer.deactivate;
//begin
//  //nop
//end;
//
//class function TPropViewer.getViewerType: TViewerType;
//begin
//  Result := PROP_VIEWER;
//end;
//
//procedure TPropViewer.init;
//begin
//  frm.pbTraderList_SatisfyRich.OnPaint := pbTraderList_SatisfyRichPaint;
//  frm.pbTraderList_SatisfyCommon.OnPaint := pbTraderList_SatisfyCommonPaint;
//  frm.pbTraderList_SatisfyPoor.OnPaint := pbTraderList_SatisfyPoorPaint;
//
//  frm.btnPropPanelFolding.OnClick := btnPropPanelFoldingClick;
//end;
//
//procedure TPropViewer.internalPrepare;
//begin
//  //nop
//end;
//
//procedure TPropViewer.internalReset;
//begin
//  //nop
//end;
//
//procedure TPropViewer.drawEmote(pb: TPaintBox; aSatisfy: Smallint);
//begin
//  pb.Canvas.Draw(0, 0, frm.mapSatisfyEmotes(aSatisfy).Picture.Graphic);
//end;
//
//procedure TPropViewer.pbTraderList_SatisfyCommonPaint(Sender: TObject);
//begin
//  drawEmote(frm.pbTraderList_SatisfyCommon, frm.currCityPtr^.Satisfy_common);
//end;
//
//procedure TPropViewer.pbTraderList_SatisfyPoorPaint(Sender: TObject);
//begin
//  drawEmote(frm.pbTraderList_SatisfyPoor, frm.currCityPtr^.Satisfy_poor);
//end;
//
//procedure TPropViewer.pbTraderList_SatisfyRichPaint(Sender: TObject);
//begin
//  drawEmote(frm.pbTraderList_SatisfyRich, frm.currCityPtr^.Satisfy_rich);
//end;
//
//
//
//procedure TPropViewer.setPropPanelFold(const aFold: Boolean);
//var
//  folding: Boolean;
//begin
//  folding := frm.btnPropPanelFolding.Tag = 1;
//  if aFold = folding then
//    exit;
//    
//  if aFold then
//  begin
//    frm.pnlProp.Width := FOLDED_PROP_PANEL_WIDHT;
//    frm.btnPropPanelFolding.Caption := '<';
//    frm.btnPropPanelFolding.Tag := 1;
//    frm.PropPageList.Visible := False;
//  end
//  else
//  begin
//    frm.pnlProp.Width := DEFAULT_PROP_PANEL_WIDTH;
//    frm.btnPropPanelFolding.Caption := '>';
//    frm.btnPropPanelFolding.Tag := 0;
//    frm.PropPageList.Visible := True;  
//  end;
//end;

{ TShipListViewer }

//function TShipListViewer.acceptPropSubView(aSubView: TPropSubViewType): Boolean;
//begin
//  Result := False;
//end;

procedure TShipListViewer.btnShipList_NextTraderClick(Sender: TObject);
var
  idx: integer;
begin
  if frm.cbShipList_Trader.ItemIndex = frm.cbShipList_Trader.Items.Count-1 then
    idx := 0
  else
    idx := frm.cbShipList_Trader.ItemIndex + 1;

  frm.setCurrView(idx, frm.currCity);
end;

procedure TShipListViewer.btnShipList_PrevTraderClick(Sender: TObject);
var
  idx: Integer;
begin
  if frm.cbShipList_Trader.ItemIndex = 0 then
    idx := frm.cbShipList_Trader.Items.Count-1
  else
    idx := frm.cbShipList_Trader.ItemIndex - 1;

  frm.setCurrView(idx, frm.currCity);
end;

procedure TShipListViewer.cancelEdits;
begin
  frm.ShipListGrid.CancelEditNode();
end;

procedure TShipListViewer.cbShipList_TraderChange(Sender: TObject);
begin
  if frm.isInternalUpdating() then
    exit;
    
  frm.setCurrView(frm.cbShipList_Trader.ItemIndex, frm.currCity);
end;

constructor TShipListViewer.Create(aForm: TfrmP3Insight);
begin
//  fTempList := TList.Create();
  tempShipList := TList.Create();
  inherited;
end;

procedure TShipListViewer.deactivate;
begin
  //nop
  frm.ShipListGrid.Clear();
end;

destructor TShipListViewer.Destroy;
begin
  inherited;
  FreeAndNil(tempShipList);
//  FreeAndNil(fTempList);
end;

function TShipListViewer.getRecCount: Integer;
begin
  Result := frm.ShipListGrid.TotalCount;
end;

function TShipListViewer.getTagOfMenuItem(sender: TObject): Integer;
begin
  Result := TMenuItem(sender).Tag;
end;

class function TShipListViewer.getViewerType: TViewerType;
begin
  Result := SHIP_LIST_VIEWER;
end;

procedure TShipListViewer.init;
var
  I: Integer;
  Area: TAreaImpl;
  tabItem: TJvTabBarItem;
begin
  for I := frm.tabbarShipListArea.Tabs.Count-1 downto 1 do
    frm.tabbarShipListArea.Tabs.Delete(I);

  for I := 0 to frm.AreaDef.getAreaCount() - 1 do
  begin
    Area := frm.AreaDef.getArea(I);
    
    tabItem := frm.tabbarShipListArea.Tabs.Add() as TJvTabBarItem;
    tabItem.Caption := Area.getName();
    tabItem.Hint := Area.getComment();
    tabItem.Tag := 1 + I;
  end;

  initGrid(frm.ShipListGrid);

  rebuildGridColumns();

  frm.ShipListGrid.OnGetImageIndex := ShipListGridGetImageIndex;
  frm.ShipListGrid.OnGetText := ShipListGridGetText;
//  frm.ShipListGrid.OnAfterCellPaint := ShipListGridAfterCellPaint;
  frm.ShipListGrid.OnBeforeItemErase := ShipListGridBeforeItemErase;
  frm.ShipListGrid.OnPaintText := ShipListGridPaintText;
  frm.ShipListGrid.OnFreeNode := ShipListGridFreeNode;


  frm.pmShipListGrid.OnPopup := pmShipListGridPopup;

  frm.btnShipList_PrevTrader.OnClick := btnShipList_PrevTraderClick;
  frm.btnShipList_NextTrader.OnClick := btnShipList_NextTraderClick;
  frm.cbShipList_Trader.OnChange := cbShipList_TraderChange;

  frm.tabbarShipListArea.OnTabSelected := tabbarShipListAreaTabSelected;

  frm.rbShipList_StateAll.OnClick := onRbShipList_StateClick;
  frm.rbShipList_StateTrading.OnClick := onRbShipList_StateClick;
  frm.rbShipList_StateFree.OnClick := onRbShipList_StateClick;
  frm.rbShipList_StateFix.OnClick := onRbShipList_StateClick;
  frm.rbShipList_StateBuilding.OnClick := onRbShipList_StateClick;
  frm.rbShipList_StateNonTrading.OnClick := onRbShipList_StateClick;

  frm.tabbarShipList_ViewType.OnTabSelected := tabbarShipList_ViewTypeTabSelected;

  if not Conf.AllowModify then
  begin
    frm.miShipListModItems.Enabled := False;
    Exit;
  end;

  frm.miShipListGridPM_Mod_GoodsQtyX10.OnClick := onMIShipListGridPM_Mod_GoodsQtyX10;
  frm.miShipListGridPM_Mod_AssignCaptain.OnClick := miShipListGridPM_Mod_AssignCaptainClick;
  frm.miShipListGridPM_Mod_SetCapacityTo3500.OnClick := miShipListGridPM_Mod_SetCapacityToClick;
  frm.miShipListGridPM_Mod_SetCapacityTo990000.OnClick := miShipListGridPM_Mod_SetCapacityToClick;
  frm.miShipListGridPM_Mod_SetGoodsTo45000.OnClick := miShipListGridPM_Mod_SetGoodsToClick;
  frm.miShipListGridPM_Mod_FullPower.OnClick := miShipListGridPM_Mod_FullPowerClick;
  frm.miShipListGridPM_Mod_SeamanAdd20.OnClick := miShipListGridPM_Mod_SeamanAddClick;
  frm.miShipListGridPM_Mod_CityWeaponAdd300.OnClick := miShipListGridPM_Mod_CityWeaponAddClick;
  frm.miShipListGridPM_Mod_SetPointsTo10000000.OnClick := miShipListGridPM_Mod_SetPointsToClick;
  frm.miShipListGridPM_Mod_RestoreCurrPoints.OnClick := miShipListGridPM_Mod_RestoreCurrPointsClick;
  frm.miShipListGridPM_Mod_MaxShiQi.OnClick := miShipListGridPM_Mod_ShiQiClick;
end;

procedure TShipListViewer.internalPrepare;
var
  I: integer;
  cb: TComboBox;
begin
  cb := frm.cbShipList_Trader;

  cb.Items.Clear();
  for I := MIN_TRADER_ID to getLastPlayerID() do
  begin
    cb.Items.Add(IntToStr(I) + ' ' + getPlayerName(I));
  end;
  cb.ItemIndex := frm.currPlayer;
end;

procedure TShipListViewer.internalReset;
begin
  frm.ShipListGrid.Clear();
end;

procedure TShipListViewer.internalUpdate;
var
  I, J: Integer;
  ship: PP3R2Ship;
  sl: TList;

  function  accept(ship: PP3R2Ship): Boolean;
  var
    area: TAreaImpl;
  begin
    Result := False;

    if frm.rbShipList_StateTrading.Checked then
    begin
      if ship^.IsTrading = 0 then
        exit;
    end
    else if frm.rbShipList_StateNonTrading.Checked then
    begin
      if ship^.IsTrading <> 0 then
        exit;
    end
    else if frm.rbShipList_StateFree.Checked then
    begin
      if ship^.IsTrading <> 0 then
        exit;

      if ship^.State <> SHIP_STATE__ANCHOR then
        exit;
    end
    else if frm.rbShipList_StateFix.Checked then
    begin
      if ship^.State <> SHIP_STATE__FIX then
        exit;
    end
    else if frm.rbShipList_StateBuilding.Checked then
    begin
      if ship^.State <> SHIP_STATE__BUILDING then
        exit;
    end;

    if frm.tabbarShipListArea.SelectedTab.Tag <> 0 then
    begin
      area := frm.AreaDef.getArea(frm.tabbarShipListArea.SelectedTab.Tag-1);
      if not area.isShipBelongs(ship) then
        exit;
    end;

    Result := True;
  end;

var
  n: PVirtualNode;
  nd, childND: PShipListNode;
  sg: PShipGroupInfo;
  other: PP3R2Ship;
  sgCache: TShipGroupInfoCache;
begin
//  dbgStr('internalUpdate->');
  if frm.cbShipList_Trader.ItemIndex <> frm.currPlayer then
    frm.cbShipList_Trader.ItemIndex := frm.currPlayer;

  frm.ShipListGrid.BeginUpdate();
  try
    frm.ShipListGrid.Clear();

//    dbgStr('currTrader=' + byteToHexStr(frm.currPlayer));
    sl := frm.getCurrPlayerShipList();

    for I := 0 to sl.Count - 1 do
    begin
      ship := sl[I];
      if not accept(ship) then
        Continue;

      GetMem(nd, sizeof(nd^));        

      if frm.rbShipList_StateTrading.Checked and (ship.GroupIndex <> $FFFF) then
      begin
        sgCache := frm.shipGroupInfoCacheList.findByFirstShip(ship);

        if sgCache = nil then
        begin
//          dbgStr('shipGroupInfo not found');
          nd.NodeType := tshiplistnode.NT__SHIP;
          nd.Obj := ship;
          frm.ShipListGrid.AddChild(nil, nd);
          Continue;
        end;

        nd.NodeType := tshiplistnode.NT__GROUP;
        nd.Obj := sgCache;
        n := frm.ShipListGrid.AddChild(nil, nd);

        if sgCache.ShipList.Count > 1 then
        begin
          for J := 0 to sgCache.ShipList.Count - 1 do
          begin
            GetMem(childND, sizeof(childND^));
            childND.NodeType := tshiplistnode.NT__SHIP;
            childND.Obj := sgCache.ShipList[J];
            frm.ShipListGrid.AddChild(n, childND);
          end;
        end;
      end
      else
      begin
        nd.NodeType := tshiplistnode.NT__SHIP;
        nd.Obj := ship;
        frm.ShipListGrid.AddChild(nil, nd);
      end;
    end;
  finally
    frm.ShipListGrid.EndUpdate();
  end;
//  dbgStr('<-internalUpdate');
end;

procedure TShipListViewer.iter_cityWeaponAdd(ship: PP3R2Ship; iParam: integer;
  pParam: pointer; var changed, abortIteration: Boolean);
var
  i: integer;
begin
  iParam := iParam * CITY_WEAPON_WEIGH_FACTOR;
  for I := CITY_WEAPON_1 to CITY_WEAPON_4 do
    ship.CityWeapons[I] := ship.CityWeapons[I] + iParam;

  updateShipGoodsLoad(ship);
end;

procedure TShipListViewer.iter_fullPower(ship: PP3R2Ship; iParam: integer;
  pParam: pointer; var changed, abortIteration: Boolean);
var
  i: integer;
begin
  for I := 1 to 24 do
    ship.Carnons[I] := CANNON__JIANONG;

  ship.Power := MAX_POWER;
end;

procedure TShipListViewer.iter_MaxShiQi(ship: PP3R2Ship; iParam: integer;
  pParam: pointer; var changed, abortIteration: Boolean);
begin
  ship.ShiQi := MAX_SHIQI;
end;

procedure TShipListViewer.iter_restoreCurrPoints(ship: PP3R2Ship;
  iParam: integer; pParam: pointer; var changed, abortIteration: Boolean);
begin
  ship.CurrPoint := ship.MaxPoint;
end;

procedure TShipListViewer.iter_seaManAdd(ship: PP3R2Ship; iParam: integer;
  pParam: pointer; var changed, abortIteration: Boolean);
begin
  ship.Seaman := ship.Seaman + iParam;
  if ship.Sword < ship.Seaman then
    ship.Sword := ship.Seaman;

  ship.ShiQi := MAX_SHIQI;
end;

procedure TShipListViewer.iter_setCapacityTo(ship: PP3R2Ship; iParam: integer;
  pParam: pointer; var changed, abortIteration: Boolean);
begin
  ship.LoadUpLimit := iParam * UNIT_TONG;
end;

procedure TShipListViewer.iter_setGoodsTo(ship: PP3R2Ship; iParam: integer;
  pParam: pointer; var changed, abortIteration: Boolean);
var
  i: integer;
begin
  iParam := iParam * UNIT_TONG;

  for I := MIN_GOODS_ID to MAX_GOODS_ID do
    ship.Goods[I] := iParam;

  updateShipGoodsLoad(ship);
end;

procedure TShipListViewer.iter_setPointsTo(ship: PP3R2Ship; iParam: integer;
  pParam: pointer; var changed, abortIteration: Boolean);
begin
  ship.CurrPoint := iParam;
  ship.MaxPoint := iParam;
end;

procedure TShipListViewer.miShipListGridPM_Mod_AssignCaptainClick(
  Sender: TObject);
const
  CAPTAIN = $0002;
var
  n: PVirtualNode;
  ship: PP3R2Ship;
  nd: PShipListNode;

  procedure setupCaptain();
  var
    cap: PCaptainRec;
  begin
    if frm.captainSetuped then
      exit;

    cap := getCaptionInfo(CAPTAIN);
    cap^.birdthDay := getCurrTS() - 18 * 356 * 256;
    cap^.exp_sailing := $FA;
    cap^.exp_trading := $FA;
    cap^.exp_fighting := $FA;
    cap^.salaryInDay := $01;
    cap^.Unknown2 := $00;
    cap^.Owner := getCurrPlayerID();

    frm.captainSetuped := True;
  end;
  
begin
  n := frm.ShipListGrid.SelectedNode;
  if n = nil then
  begin
    soundBeep();
    exit;
  end;

  while n <> nil do
  begin
    nd := frm.ShipListGrid.GetNodeUserData(n);
    if nd.NodeType <> tshiplistnode.NT__GROUP then
    begin
      ship := nd.Obj;
      ship^.Captain := CAPTAIN;

      setupCaptain();
    end;

    n := frm.ShipListGrid.GetNextSelected(n);
  end;

  frm.ShipListGrid.Invalidate();
  frm.updateUI();
end;

procedure TShipListViewer.miShipListGridPM_Mod_CityWeaponAddClick(
  Sender: TObject);
begin
  if selectedShipIterate(iter_cityWeaponAdd, getTagOfMenuItem(Sender)) > 0 then
    frm.updateUI();  
end;

procedure TShipListViewer.miShipListGridPM_Mod_FullPowerClick(Sender: TObject);
begin
  if selectedShipIterate(iter_fullPower, 0) > 0 then
    frm.updateUI();
end;

procedure TShipListViewer.miShipListGridPM_Mod_RestoreCurrPointsClick(
  Sender: TObject);
begin
  if selectedShipIterate(iter_restoreCurrPoints, 0) > 0 then
    frm.updateUI();
end;

procedure TShipListViewer.miShipListGridPM_Mod_SeamanAddClick(Sender: TObject);
begin
  if selectedShipIterate(iter_seaManAdd, getTagOfMenuItem(Sender)) > 0 then
    frm.updateUI();
end;

procedure TShipListViewer.miShipListGridPM_Mod_SetCapacityToClick(
  Sender: TObject);
begin
  if selectedShipIterate(iter_setCapacityTo, getTagOfMenuItem(Sender)) > 0 then
    frm.updateUI();
end;

procedure TShipListViewer.miShipListGridPM_Mod_SetGoodsToClick(Sender: TObject);
begin
  if selectedShipIterate(iter_setGoodsTo, getTagOfMenuItem(Sender)) > 0 then
    frm.updateUI();
end;

procedure TShipListViewer.miShipListGridPM_Mod_SetPointsToClick(
  Sender: TObject);
begin
  if selectedShipIterate(iter_setPointsTo, getTagOfMenuItem(sender)) > 0 then
    frm.updateUI();
end;

procedure TShipListViewer.miShipListGridPM_Mod_ShiQiClick(Sender: TObject);
begin
  if selectedShipIterate(iter_MaxShiQi, 0) > 0 then
    frm.updateUI();
end;

procedure TShipListViewer.miShipListGrid_RenameShipByCityNameClick(
  Sender: TObject);
var
  nd: PShipListNode;
  sgcache: TShipGroupInfoCache;
  n: PVirtualNode;
  ship: PP3R2Ship;
  i, q: integer;
  ShipNameToolong: Boolean;
  mi: TMenuItem;
  newName: WideString;
  allShipList, processedShips: TList;

  function findShipByName(const shipName: WideString): PP3R2Ship;
  var
    i: integer;
    sn: WideString;
  begin
    for I := 0 to allShipList.Count - 1 do
    begin
      Result := allShipList[I];

      sn := getShipName_R2(Result);

      if WideSameText(shipName, sn) then
        Exit;
    end;

    Result := nil;
  end;

  procedure process(ship: PP3R2Ship);
  label
    l1;
  var
    snPrefix, snName, snSuffix: WideString;
    newName2, encodedName: WideString;
    idx: integer;
  begin
    if processedShips.IndexOf(ship) >= 0 then
      Exit;
      
    idx := 1;
  l1:
    newName2 := newName + IntToStr(idx);
    extractShipAreaPrefix(ship, snPrefix, snName, snSuffix);
    encodedName := encodeShipName(snPrefix, newName2, snSuffix);

    if findShipByName(encodedName) <> nil then
    begin
      inc(idx);
      goto l1;
    end;

    if not setShipName(ship, encodedName) then
      ShipNameToolong := True;
  end;

begin
  n := frm.ShipListGrid.SelectedNode;
  if n = nil then
  begin
    soundBeep();
    exit;
  end;

  mi := TMenuItem(sender);

  newName := mi.Hint;
  ShipNameToolong := False;

  allShipList := TList.Create();
  processedShips := TList.Create();
  try
    getAllShipList(allShipList);
    while n <> nil do
    begin
      nd := frm.ShipListGrid.GetNodeUserData(n);

      if nd.NodeType <> tshiplistnode.NT__GROUP then
      begin
        ship := nd.Obj;
        process(ship);
      end
      else
      begin
        sgcache := TShipGroupInfoCache(nd.Obj);
        for I := 0 to sgcache.ShipList.Count - 1 do
        begin
          ship := sgcache.ShipList[I];

          process(ship);
        end;
      end;

      n := frm.ShipListGrid.GetNextSelected(n);
    end;
  finally
    FreeAndNil(allShipList);
    FreeAndNil(processedShips);
  end;

  frm.ShipListGrid.Invalidate();
  frm.updateUI();
end;

procedure TShipListViewer.miShipListGrid_ShipSetAreaClick(Sender: TObject);
var
  nd: PShipListNode;
  sgcache: TShipGroupInfoCache;
  n: PVirtualNode;
  ship: PP3R2Ship;
  i, q: integer;
  ShipNameToolong: Boolean;
  mi: TMenuItem;
  newPrefix: WideString;
  processedShips: TList;

  procedure process(ship: PP3R2Ship);
  var
    snPrefix, snName, snSuffix: WideString;
    newName: WideString;
  begin
    if processedShips.IndexOf(ship) >= 0 then
      Exit;

    extractShipAreaPrefix(ship, snPrefix, snName, snSuffix);
//    dbgStr('prefix=' + snPrefix);
//    dbgStr('name=' + snName);
//    dbgStr('suffix=' + snSuffix);
//    dbgStr('seperator=' + conf.ShipNameSeperator);
    newName := encodeShipName(newPrefix, snName, snSuffix);
//    dbgStr('newname=' + newName);
    if not setShipName(ship, newName) then
      ShipNameToolong := True;
  end;

begin
  n := frm.ShipListGrid.SelectedNode;
  if n = nil then
  begin
    soundBeep();
    exit;
  end;

  mi := TMenuItem(sender);

  newPrefix := mi.Hint;
  ShipNameToolong := False;

  processedShips := TList.Create();
  try
    while n <> nil do
    begin
      nd := frm.ShipListGrid.GetNodeUserData(n);

      if nd.NodeType <> tshiplistnode.NT__GROUP then
      begin
        ship := nd.Obj;

        process(ship);
      end
      else
      begin
        sgcache := TShipGroupInfoCache(nd.Obj);
        for I := 0 to sgcache.ShipList.Count - 1 do
        begin
          ship := sgcache.ShipList[I];

          process(ship);
        end;
      end;

      n := frm.ShipListGrid.GetNextSelected(n);
    end;

    frm.ShipListGrid.Invalidate();
    frm.updateUI();
  finally
    processedShips.Destroy();
  end;
end;

procedure TShipListViewer.onMIShipListGridPM_Mod_GoodsQtyX10(
  sender: TObject);
var
  nd: PShipListNode;
  sgcache: TShipGroupInfoCache;
  n: PVirtualNode;
  ship: PP3R2Ship;
  i, q: integer;
begin
  n := frm.ShipListGrid.SelectedNode;
  if n = nil then
  begin
    soundBeep();
    exit;
  end;

  while n <> nil do
  begin
    nd := frm.ShipListGrid.GetNodeUserData(n);

    if nd.NodeType <> tshiplistnode.NT__GROUP then
    begin
      ship := nd.Obj;

      for I := MIN_GOODS_ID to MAX_GOODS_ID do
      begin
        ship^.Goods[I] := ship^.Goods[I] * 10;
      end;

      updateShipGoodsLoad(ship);
      frm.shipGroupInfoCacheList.shipLoadingChanged(ship);
    end;

    n := frm.ShipListGrid.GetNextSelected(n);
  end;

  frm.ShipListGrid.Invalidate();
  frm.updateUI();
end;

procedure TShipListViewer.onRbShipList_StateClick(sender: TObject);
begin
  update();
end;

procedure TShipListViewer.pmShipListGridPopup(Sender: TObject);
var
  i: integer;
  area: TAreaDefImpl;

  procedure createMI(prefix, name: WideString);
  var
    mi: TMenuItem;
  begin
    mi := TMenuItem.Create(frm.miShipListGridPM_SetAreaItems);
    mi.Caption := name;
    mi.Hint := prefix;
    mi.OnClick := miShipListGrid_ShipSetAreaClick;

    frm.miShipListGridPM_SetAreaItems.Add(mi);
  end;

  procedure createSeperator(parent: TMenuItem);
  var
    mi: TMenuItem;
  begin
    mi := TMenuItem.Create(parent);
    mi.Caption := '-';
//    mi.Break := mbBreak;
    parent.Add(mi);
  end;

  procedure createNoneMI();
  var
    mi: TMenuItem;
  begin
    mi := TMenuItem.Create(frm.miShipListGridPM_SetAreaItems);
    mi.Caption := Txt_None;
    mi.OnClick := miShipListGrid_ShipSetAreaClick;

    frm.miShipListGridPM_SetAreaItems.Add(mi);
  end;

  procedure createCityMI(city: byte);
  var
    mi: TMenuItem;
  begin
    mi := TMenuItem.Create(frm.miShipListGridPM_RenameShipByCityNameItems);
    mi.Caption := getCityName2(city);
    mi.Hint := mi.Caption;
    mi.OnClick := miShipListGrid_RenameShipByCityNameClick;

    frm.miShipListGridPM_RenameShipByCityNameItems.Add(mi);
  end;

var
  city: byte;
  lastCityCode: byte;
begin
  frm.miShipListGridPM_SetAreaItems.Clear();

  area := Conf.AreaDefList.getDefault();

  for I := 0 to area.getAreaCount() - 1 do
  begin
    createMI(area.getArea(i).getShipNamePrefix(), area.getArea(i).getName());
  end;

  createSeperator(frm.miShipListGridPM_SetAreaItems);
  createNoneMI();


  frm.miShipListGridPM_RenameShipByCityNameItems.Clear();

  lastCityCode := getCityCount() - 1;
  for city := MIN_CITY_CODE to lastCityCode do
  begin
    createCityMI(city);

    if (city <> lastCityCode) and ((city mod 4) = 3) then
      createSeperator(frm.miShipListGridPM_RenameShipByCityNameItems);
  end;
end;

procedure TShipListViewer.rebuildGridColumns;
var
  gid: integer;
  g: TVirtualStringTree;

  procedure addCol(
          const cap: WideString;
          const tag: integer;
          const width: integer;
          const imgIndex: integer;
          const align: TAlignment);
  var
    col: TVirtualTreeColumn;
  begin
    col := g.Header.Columns.Add();

    col.Text := cap;
    col.Tag := tag;
    col.Width := width;
    col.ImageIndex := imgIndex;
    col.Alignment := align;
  end;
  
begin
  g := frm.ShipListGrid;

  g.BeginUpdate();
  try
//    g.Clear();

    g.Header.Columns.Clear();

    addCol('Ptr', COLTAG__SHIP_PTR, 100, -1, taLeftJustify);
    addCol('名称', COLTAG__NAME, 160, -1, taLeftJustify);
    addCol('类型', COLTAG__SHIP_TYPE, 55, -1, taLeftJustify);
    addCol('所在', COLTAG__CURR_CITY, 100, -1, taLeftJustify);


    case frm.tabbarShipList_ViewType.SelectedTab.Tag of
      1:
      begin
        addCol('耐久', COLTAG__SHIP_POINTS, 130, IL20__HEART, taRightJustify);
        addCol('容量', COLTAG__CAPACITY, 120, IL20__TONG, taRightJustify);
        addCol('船长', COLTAG__CAPTAIN, 64, IL20__STAR, taCenter);
        addCol('水手', COLTAG__SEAMAN, 64, IL20__SEAMAN, taRightJustify);
        addCol('短剑', COLTAG__SWORD, 50, -1, taRightJustify);
        addCol('火力', COLTAG__POWER, 50, -1, taRightJustify);
        addCol('航行状态', COLTAG__SAIL_STATE, 200, -1, taLeftJustify);    
      end;

      2:
      begin
        addCol('容量', COLTAG__CAPACITY, 140, IL20__TONG, taRightJustify);
        for gid := MIN_GOODS_ID to MAX_GOODS_ID do
        begin
          addCol(
                getGoodsName(gid),
                COLTAG__GOODS_1 + gid -1,
                65,
                IL20__GOODS_1 + gid-1,
                taRightJustify);
        end;
      end;

      3:
      begin
        addCol('容量', COLTAG__CAPACITY, 140, IL20__TONG, taRightJustify);
        for gid in [GOODSID__WOOL, GOODSID__CLOTH, GOODSID__TOOLS, GOODSID__HEMP, GOODSID__ASPHALT] do
        begin
          addCol(
                getGoodsName(gid),
                COLTAG__GOODS_1 + gid -1,
                65,
                IL20__GOODS_1 + gid-1,
                taRightJustify);
        end;
        
        addCol(getCityWeaponName(CITY_WEAPON_1), COLTAG__CITY_WEAPON_1, 40, -1, taRightJustify);
        addCol(getCityWeaponName(CITY_WEAPON_2), COLTAG__CITY_WEAPON_2, 40, -1, taRightJustify);
        addCol(getCityWeaponName(CITY_WEAPON_3), COLTAG__CITY_WEAPON_3, 40, -1, taRightJustify);
        addCol(getCityWeaponName(CITY_WEAPON_4), COLTAG__CITY_WEAPON_4, 40, -1, taRightJustify);

        addCol('短剑', COLTAG__SWORD, 50, -1, taRightJustify);
      end;
    end;
  finally
    g.EndUpdate();
  end;
end;

function  TShipListViewer.selectedShipIterate(iterator: TSelectedShipIterator;
  iParam: integer; pParam: Pointer): Integer;
var
  nd: PShipListNode;
  changed, abortIteration: Boolean;
  n: PVirtualNode;
  g: TVirtualStringTree;
  ship: PP3R2Ship;
  sgCache: TShipGroupInfoCache;
begin
  Result := 0;
  g := frm.ShipListGrid;

  n := g.GetFirstSelected();
  while n <> nil do
  begin
    nd := g.GetNodeUserData(n);

    ship := nil;

    if (nd.NodeType = tshiplistnode.NT__GROUP) then
    begin
      sgCache := TShipGroupInfoCache(nd.Obj);
      if sgCache.ShipList.Count = 1 then
      begin
        ship := sgCache.FirstShip;
      end;
    end
    else
      ship := nd.Obj;

    if ship <> nil then
    begin
      changed := True;
      abortIteration := False;
      iterator(ship, iParam, pParam, changed, abortIteration);
      if changed then
        Inc(Result);

      if abortIteration then
        Exit;
    end;

    n := g.GetNextSelected(n);
  end;
end;

//procedure TShipListViewer.ShipListGridAfterCellPaint(Sender: TBaseVirtualTree;
//  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
//  CellRect: TRect);
//var
//  ship: PP3R2Ship;
//  tag: integer;
//  dc: HDC;
//  S: WideString;
//  bkColor: TColor;
//  br: HBRUSH;
//begin
//  tag := getColTagOf(frm.ShipListGrid, Column);
//  ship := Sender.GetNodeUserData(Node);
//
//  case tag of
//    COLTAG__NAME:
//    begin
//      if ship.State = SHIP_STATE__BUILDING then
//      begin
//        S := getShipName_R2(ship);
//        dc := TargetCanvas.Handle;
//        if Sender.Selected[node] then
//          br := frm.gridSelectBkClrBrush
//        else
//        begin
//          if (Node.Index and 1) = 1 then
//            br := frm.gridOddBkClrBrush
//          else
//            br := GetStockObject(WHITE_BRUSH);
//        end;
//        FillRect(dc, CellRect, br);
//        SetTextColor(dc, clGray);
//        InflateRect(CellRect, -frm.ShipListGrid.Header.Columns[column].Margin, 0);
//        DrawTextW(dc, pwidechar(s), length(s), CellRect, DT_SINGLELINE or DT_LEFT or DT_VCENTER, False);
//
//        if (Sender.FocusedNode = Node) and (Sender.FocusedColumn = Column) then
//          DrawFocusRect(dc, CellRect);
//      end;      
//    end;  
//  end;
//end;

procedure TShipListViewer.ShipListGridBeforeItemErase(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect;
  var ItemColor: TColor; var EraseAction: TItemEraseAction);
//var
//  nd: PVirtualNode;
begin
  if (Node.Index and 1) = 1 then
    ItemColor := ODD_BK_COLOR
  else
    ItemColor := clWhite;

  EraseAction := eaColor;
end;

procedure TShipListViewer.ShipListGridFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  p: pointer;
begin
  p := Sender.GetNodeUserData(Node);
  FreeMem(p);
end;

procedure TShipListViewer.ShipListGridGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  nd: PShipListNode;
  sgCache: TShipGroupInfoCache;
  ship: PP3R2Ship;
begin
  ImageIndex := -1;
  if Column < 0 then
    exit;

  if (Kind = ikNormal) or (Kind = ikSelected) then
  begin
    nd := Sender.GetNodeUserData(Node);
    
    case getColTagOf(frm.ShipListGrid, Column) of
      COLTAG__NAME:
      begin
        if nd.NodeType = tshiplistnode.NT__GROUP then
        begin
          sgCache := TShipGroupInfoCache(nd.Obj);
          ship := sgCache.FirstShip;
        end
        else if sender.NodeParent[node] = nil then
        begin
          ship := nd.Obj;
        end
        else
          ship := nil;

        if ship <> nil then
        begin
          if ship.IsTrading <> 0 then
            ImageIndex := IL16__TRADING
          else if ship.State = SHIP_STATE__REMOTE_TRADING then
            ImageIndex := IL16__SAILING
          else if ship.State = SHIP_STATE__PIRATE then
            ImageIndex := IL16__PIRATE
          else
            ImageIndex := IL16__EMPTY;
        end;
      end;

      COLTAG__SHIP_POINTS:
      begin
        if nd.NodeType = tshiplistnode.NT__SHIP then
        begin
          ship := nd.Obj;

          if ship.State = SHIP_STATE__FIX then
            ImageIndex := IL16__FIXING;
        end;
      end;
    end;
  end;
end;

procedure TShipListViewer.ShipListGridGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  nd: PShipListNode;
  ship: PP3R2Ship;
  s: string;
  d1, d2: Double;
  days, hours, q: Integer;
  gid, tag: integer;
  sgcache: TShipGroupInfoCache;
begin
  if Column < 0 then
    exit;
    
  nd := Sender.GetNodeUserData(Node);

  if nd.NodeType = tshiplistnode.NT__GROUP then
  begin
    sgcache := TShipGroupInfoCache(nd.Obj);
    ship := sgcache.FirstShip;
  end
  else
  begin
    sgcache :=  nil;
    ship := nd.Obj;
  end;

  tag := getColTagOf(frm.ShipListGrid, Column);
  try
  case tag of
    COLTAG__SHIP_PTR:
    begin
      CellText := ptrToHexStr(ship);
    end;
    
    COLTAG__NAME: //name
    begin
      CellText := getShipName_R2(ship);
      
      if sgcache <> nil then
        CellText := '[' + IntToStr(sgcache.ShipList.Count) + '] ' + CellText
      else
      begin
        if ship.GroupIndex <> $FFFF then
          CellText := '*' + CellText;
      end;
    end;

    COLTAG__SHIP_TYPE:
    begin
      if (sgcache <> nil) and (sgcache.ShipList.Count > 1) then
        CellText := '舰队'
      else
        CellText := getShipTypeText(ship.ShipType);
    end;

    COLTAG__CURR_CITY:
      CellText := getCityName2(ship.Curr);

    COLTAG__SHIP_POINTS: //point
    begin
      if (sgcache <> nil) and (sgcache.ShipList.Count > 1) then
      begin
        CellText := '---';
        exit;
      end;
      
      if ship^.State = SHIP_STATE__BUILDING then
      begin
        if (ship^.CurrPoint = 0) or (ship^.MaxPoint = 0) then
          CellText := '(计划建造中)'
        else
        begin
          d1 := ship^.CurrPoint;
          d2 := ship^.MaxPoint;
          CellText := '(建造中)' + FormatFloat('0', d1 * 100 / d2) + '%';
        end;
      end
      else
      begin
        if (ship^.CurrPoint = 0) then
          CellText := '0'
        else if (ship^.MaxPoint = 0) then 
          CellText := '0'
        else
        begin
          d1 := ship^.CurrPoint;
          d2 := ship^.MaxPoint;

          s := IntToStr(ship^.MaxPoint) + ' (' + FormatFloat('0', d1 * 100 / d2) + '%)';
          CellText := s;
        end;
      end;
    end;

    COLTAG__CAPACITY: //loadlimit
    begin
      if (sgcache <> nil) and (sgcache.ShipList.Count > 1) then
      begin
        d1 := sgcache.LoadingTotal;
        d2 := sgcache.ShipGroupInfo.Capacity;

        s := formatQty(sgcache.LoadingTotal, false) + ' (' + FormatFloat('0', d1 * 100 / d2) + '%)';
        CellText := s;
        exit;
      end;
      
      if ship^.LoadUpLimit = 0 then
        CellText := ''
      else if ship^.State = SHIP_STATE__BUILDING then
        CellText := formatQty(ship^.LoadUpLimit, False)
      else
      begin
        d1 := ship^.GoodsLoad + ship^.WeaponLoad;
        d2 := ship^.LoadUpLimit;

        s := formatQty(ship^.LoadUpLimit, false) + ' (' + FormatFloat('0', d1 * 100 / d2) + '%)';

        CellText := s;
      end;
    end;

    COLTAG__CAPTAIN: //captain
    begin
//      if (sgcache <> nil) and (sgcache.ShipList.Count > 1) then
//      begin
//        CellText := '---';
//        exit;
//      end;
      
      if (ship^.State <> SHIP_STATE__BUILDING) then
      begin
        if ship^.Captain <> CAPTAIN_NONE then
          CellText := wordToHexStr(ship^.Captain, False)
        else
          CellText := '';
      end;
    end;

    COLTAG__SEAMAN: //seaman
    begin
      if (ship^.State <> SHIP_STATE__BUILDING) then
      begin
        if (sgcache <> nil) and (sgcache.ShipList.Count > 1) then
          CellText := IntToStr(sgcache.SeaManTotal)
        else
          CellText := IntToStr(ship^.Seaman);
      end;
    end;

    COLTAG__SWORD: //sword
    begin
      if (ship^.State <> SHIP_STATE__BUILDING) then
      begin

        if (sgcache <> nil) and (sgcache.ShipList.Count > 1) then
          q := sgcache.ShipWeaponTotal
        else
        begin
          q := ship^.Sword;
        end;

        if q <> 0 then
          CellText := IntToStr(q);
      end;
    end;

    COLTAG__POWER: //power
    begin
      if (sgcache <> nil) and (sgcache.ShipList.Count > 1) then
      begin
        CellText := '---';
        exit;
      end;
      
      if ship^.State <> SHIP_STATE__BUILDING then
        CellText := IntToStr(ship^.Power);
    end;

    COLTAG__SAIL_STATE: //航行状态
    begin
      if ship^.State <> SHIP_STATE__BUILDING then
      begin
        if ship.State = SHIP_STATE__SINKING then
          CellText := '下沉中'
        else if ship.State = SHIP_STATE__BATTLE then
          CellText := '海战'
        else if ship.State = SHIP_STATE__ANCHOR then
          CellText := '停泊-' + getCityName2(ship.Curr)
        else if ship.State = SHIP_STATE__LEAVE then
          CellText := '离港-(' + getCityName2(ship^.From) + '->' + getCityName2(ship^.Dest) + ')'
        else if ship.State = SHIP_STATE__ENTER then
          CellText := '靠港-' + getCityName2(ship^.From)
        else if ship.State = SHIP_STATE__BUSINESS then
          CellText := '交易中-' + getCityName2(ship.Curr)
        else if (ship^.Curr = ship^.From) and (ship^.From = ship^.Dest) then
          CellText := '停泊-' + getCityName2(ship^.Curr)
        else
        begin
//          dbgStr('currTS=' + longwordToHexStr(getCurrTS()));
//          dbgStr('reachDestTS=' + longwordToHexStr(ship^.ReachDestTS));
          if ship^.ReachDestTS = 0 then
          begin
            if ship^.State = SHIP_STATE__FIX then
            begin
              CellText := '停泊-' + getCityName2(ship^.Curr);
              exit;
            end;
            
            days := 0;
            hours := 0;
          end
          else
          begin
            getTimeDiffInDays(ship^.ReachDestTS, days, hours);
          end;
          
          CellText := '航行->' + getCityName2(ship^.Dest) + ' (' + intervalToStr(days, hours) + ')';
        end;
      end;
    end;

    COLTAG__GOODS_1..COLTAG__GOODS_20:
    begin
      if ship.State = SHIP_STATE__BUILDING then
        CellText := '---'
      else
      begin
        gid := tag - COLTAG__GOODS_1 + 1;
        if (sgcache <> nil) and (sgcache.ShipList.Count > 1) then
        begin
          q := sgcache.GoodsLoading[gid];
        end
        else
          q := ship.Goods[gid];
          
        if q <> 0 then
        begin
          s := formatQty(q, isGoodsMeasuredInPkg(gid));

          CellText := s;
        end;
      end;
    end;

    COLTAG__CITY_WEAPON_1..COLTAG__CITY_WEAPON_4:
    begin
      if ship.State = SHIP_STATE__BUILDING then
        CellText := '---'
      else
      begin
        if (sgcache <> nil) and (sgcache.ShipList.Count > 1) then
        begin
          CellText := '---';
          exit;
        end;

        gid := tag - COLTAG__CITY_WEAPON_1 + 1;

        q := ship.CityWeapons[gid];
          
        if q <> 0 then
        begin
          s := formatCityWeaponQty(q);
          CellText := s;
        end;
      end;
    end;
  end;
  except
    CellText := 'Error';
  end;
end;

procedure TShipListViewer.ShipListGridPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  nd: PShipListNode;
  ship: PP3R2Ship;
  sgcahe: TShipGroupInfoCache;
begin
  if Column < 0 then
    exit;
    
  if getColTagOf(frm.ShipListGrid, Column) = COLTAG__NAME then
  begin
    nd := Sender.GetNodeUserData(Node);

    if nd.NodeType = tshiplistnode.NT__GROUP then
    begin
      sgcahe := TShipGroupInfoCache(nd.Obj);
      ship := sgcahe.FirstShip;
    end
    else
      ship := nd.Obj;

    if ship.State = SHIP_STATE__BUILDING then
        TargetCanvas.Font.Color := clGrayText
    else if ship.State = SHIP_STATE__BATTLE then
      TargetCanvas.Font.Color := clRed
    else
      TargetCanvas.Font.Color := clBlack;
  end;
end;

procedure TShipListViewer.tabbarShipListAreaChange(Sender: TObject);
begin
  update();
end;

procedure TShipListViewer.tabbarShipListAreaTabSelected(Sender: TObject;
  Item: TJvTabBarItem);
begin
  update();
end;

procedure TShipListViewer.tabbarShipList_ViewTypeTabSelected(Sender: TObject;
  Item: TJvTabBarItem);
begin
  rebuildGridColumns();
//  update();
end;

{ TCityListViewer }

//function TCityListViewer.acceptPropSubView(aSubView: TPropSubViewType): Boolean;
//begin
//  Result := False;
//end;

procedure TCityListViewer.cancelEdits;
begin
  frm.CityListGrid.CancelEditNode();
end;

procedure TCityListViewer.CityListGridAfterCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellRect: TRect);
var
  tag, gid: integer;
  g: TVirtualStringTree;
  S: WideString;
  r: TRect;

  procedure clearRect();
  begin
//    InflateRect(CellRect, 1, 1);
    TargetCanvas.FillRect(CellRect);
//    InflateRect(CellRect, -1, -1);
  end;

  procedure doDrawFocusRect();
  begin
    if (Sender.FocusedNode = Node) and (Sender.FocusedColumn = Column) then
    begin
//      TargetCanvas.Brush.Color := clBlack;
//      TargetCanvas.Pen.Color := clBlack;
//      InflateRect(CellRect, -1, -1);
      TargetCanvas.Font.Color := clBlack;
      TargetCanvas.DrawFocusRect(CellRect);
//      DrawFocusRect(TargetCanvas.Handle, CellRect);
    end;
  end;

  procedure drawUnitBmp();
  var
    bmp: TBitmap32;
    l, t: integer;
    ilIdx: integer;
  begin
    t := r.Top + (r.Bottom - r.Top - frm.il20x20.Height) div 2;
    if isGoodsMeasuredInPkg(gid) then
      ilIdx := IL20__PKG
    else
      ilIdx := IL20__TONG;
      
    frm.il20x20.Draw(TargetCanvas, r.Left, t, ilIdx);
  end;

  procedure setupTxtStyle(out warning: Boolean);
  var
    d: double;
    store: double;
    city: integer;
    cityPtr: PCityStruct;
  begin
    city := Sender.GetNodeUserDataInt(Node);
    d := frm.residentConsumePrecalc.calcCityConsumeInDay(gid, city) * 2;
    cityPtr := getCityPtr(city);
    store := cityptr.getGoodsStore(gid);
    warning := store < d;
    if warning then
    begin
      TargetCanvas.Font.Color := clRed;
      TargetCanvas.Font.Style := [fsBold];
    end
    else
    begin
      TargetCanvas.Font.Color := clBlack;
      TargetCanvas.Font.Style := [];
    end;
  end;

  procedure handleGoodsStore();
  var
    warning: Boolean;
    dc: HDC;
  begin
    clearRect();
    CityListGridGetText(Sender, Node, Column, ttNormal, S);
    r := CellRect;

    if node.Index = 0 then
    begin
      drawUnitBmp();
    end;


    setupTxtStyle(warning);
    Dec(r.Right, 4);
    dc := TargetCanvas.Handle;
    DrawTextW(dc, PWideChar(S), Length(S), r, DT_SINGLELINE or DT_RIGHT or DT_VCENTER, False);
    if warning then
    begin
      r := CellRect;
      Inc(r.Left, frm.il20x20.Width + 4);
      Dec(r.Right, 4);
      DrawSquigglyUnderlineEx(dc, frm.bluePen, r.Left, r.Bottom - 4, r.Right - r.Left);
    end;
    doDrawFocusRect();
  end;

begin
  if Column < 0 then
    exit;
    
  g := frm.CityListGrid;

  tag := getColTagOf(g, Column);

  if (tag < TAG__GOODS1) or (tag > TAG__GOODS_MAX) then
    exit;

  tag := tag - TAG__GOODS1;

  gid := tag div 5 + 1;


  case tag mod 5 of
    0:
    begin
      handleGoodsStore();
    end;

    3: //buy price
    begin
      clearRect();
      CityListGridGetText(Sender, Node, Column, ttNormal, S);
      r := CellRect;
      drawPriceCell(TargetCanvas.Handle, r, True, S, clBlack);
      doDrawFocusRect();
    end;

    4: //sale price
    begin
      clearRect();
      CityListGridGetText(Sender, Node, Column, ttNormal, S);
      r := CellRect;
      drawPriceCell(TargetCanvas.Handle, r, False, S, clBlack);
      doDrawFocusRect();
    end;
  end;
end;

procedure TCityListViewer.CityListGridBeforeItemErase(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect;
  var ItemColor: TColor; var EraseAction: TItemEraseAction);
var
  city: integer;
begin
  if Sender.Selected[node] then
  begin
    ItemColor := selectionColor;
  end
  else
  begin
    city := Sender.GetNodeUserDataInt(Node);
    if (city and 1) = 1 then
      ItemColor := ODD_BK_COLOR
    else
      ItemColor := clWhite;
  end;

  EraseAction := eaColor;
end;

procedure TCityListViewer.CityListGridGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  pid: Byte;
  traderShipsInCity: TCityTraderShipList;
  city: Integer;
  tag: Integer;
  bo: PBusinessOffice;
  cityPtr: PCityStruct;
begin
  ImageIndex := -1;

  if ((Kind <> ikNormal) and (Kind <> ikSelected)) then
    Exit;

  if Column < 0 then
    exit;

  tag := getColTagOf(frm.CityListGrid, Column);
  if tag <> TAG__CITY_NAME then
    exit;

  pid := frm.currPlayer;
  city := Sender.GetNodeUserDataInt(Node);

  bo := getBusinessOfficePtr(pid, city);

  if bo <> nil then
  begin
    if city = frm.currPlayerHomeCity then
      ImageIndex := IL16__BLUE_BTN
    else
      ImageIndex := IL16__RED_BLUE_BTN;
  end
  else
    ImageIndex := IL16__RED_BTN;
//  begin
//    traderShipsInCity := frm.allCityShipList.get(city).get(getCurrPlayerID());
//    if traderShipsInCity.ShipList.Count > 0 then
//      ImageIndex := 7
//    else
//      ImageIndex := 6;
//  end;
end;

procedure TCityListViewer.CityListGridGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  city, tag: Integer;
  cityPtr: PCityStruct;

  procedure gt_index();
  begin
    CellText := IntToStr(city);
  end;

  procedure gt_ptr();
  begin
    CellText := ptrToHexStr(cityPtr);
  end;

  procedure gt_cityName();
  begin
    CellText := getCityName2(city);
  end;

  procedure gt_popTotal();
  begin
    CellText := IntToStr(cityptr^.Pop_Total);
  end;

  procedure gt_Satisfy_rich();
  begin
    CellText := IntToStr(cityPtr^.Satisfy_rich);
  end;

  procedure gt_Satisfy_common();
  begin
    CellText := IntToStr(cityPtr^.Satisfy_common);
  end;

  procedure gt_Satisfy_poor();
  begin
    CellText := IntToStr(cityPtr^.Satisfy_poor);
  end;
  
  procedure gt_UnhapplyGrade();
  var
    lvl, satisfy: Integer;  
  begin
    lvl := GRADE__RICH;
    satisfy := cityPtr^.Satisfy_rich;

    if cityPtr^.Satisfy_common < satisfy then
    begin
      lvl := GRADE__COMMON;
      satisfy := cityPtr^.Satisfy_common;
    end;

    if cityPtr^.Satisfy_poor < satisfy then
    begin
      lvl := GRADE__POOR;
      satisfy := cityptr^.Satisfy_poor;
    end;

    if satisfy < 19 then
    begin
      CellText := getGradeText(lvl) + '(' + IntToStr(satisfy) + ')';
    end;
  end;


  procedure _gtHouse(const currResident, capacity: Integer; const houseSz: Integer);
  var
    r, c: integer;
  begin
    if capacity = 0 then
    begin
      r := 0;
      OutputDebugString('capacity=0');
    end
    else if currResident >= capacity then
      r := 100
    else
      r := currResident * 100 div capacity;

    if houseSz = 0 then
    begin
      c := 0;
      OutputDebugString('houseSz=0');
    end
    else
    begin
//      dbgStr('houseSz=' + IntToStr(houseSz) + ' cap=' + IntToStr(capacity));
      c := capacity div houseSz;
      if (c = 0) and (capacity <> 0) then
        c := 1;
    end;

    CellText := IntToStr(c) + '(' + IntToStr(r) + '%)'; 
  end;

  procedure gt_AdvHouse();
  begin
    _gtHouse(cityptr^.Pop_rich, cityptr^.AdvHouseCap, frm.houseCapInfo.getCap(GRADE__RICH));
  end;

  procedure gt_CommonHouse();
  begin
    _gtHouse(cityptr^.Pop_common, cityptr^.CommonHouseCap, frm.houseCapInfo.getCap(GRADE__COMMON));
  end;

  procedure gt_PoorHouse();
  begin
    _gtHouse(cityptr^.Pop_poor, cityptr^.PoorHouseCap, frm.houseCapInfo.getCap(GRADE__POOR));
  end;

  procedure gt_Pop_rich();
  begin
    if cityptr.Pop_rich <> 0 then
      CellText := IntToStr(cityptr.Pop_rich);
  end;

  procedure gt_Pop_common();
  begin
    if cityptr.Pop_common <> 0 then
      CellText := IntToStr(cityptr.Pop_common);
  end;

  procedure gt_Pop_poor();
  begin
    if cityPtr.Pop_poor <> 0 then
      CellText := IntToStr(cityptr.Pop_poor);
  end;

  procedure gt_Pop_begger();
  begin
    if cityPtr.Pop_begger <> 0 then
      CellText := IntToStr(cityptr.Pop_begger);
  end;

  procedure gt_CityStore(gid: integer);
  begin
    CellText := cityptr.getGoodsStoreText(gid);
  end;

  procedure gt_CitySPrice(gid: integer);
  begin
    CellText := getCitySPriceStr(city, gid);
  end;

  procedure gt_CityPPrice(gid: integer);
  begin
    CellText := getCityPPriceStr(city, gid);
  end;

  procedure gt_CityConsume(gid: integer);
  var
    pid, q: integer;
    boCache: pCityBODataCache;
    bo: PBusinessOffice;
  begin
    q := Round(frm.residentConsumePrecalc.calcCityConsumeInWeek(gid, city));
    q := q + cityPtr.getFactoryConsume(gid) * 7;

    boCache := frm.cityBODataCacheList.get(city);

    for pid := MIN_TRADER_ID to getLastPlayerID() do
    begin
      bo := boCache.findPlayerBO(pid);
      if bo <> nil then
        q := q + bo.FactoryConsumes[gid] * 7;
    end;

    if q <> 0 then
      CellText := formatQty(q, isGoodsMeasuredInPkg(gid));
  end;

  procedure gt_CityProd(gid: integer);
  var
    pid, q: integer;
    boCache: pCityBODataCache;
    bo: PBusinessOffice;
  begin
    q := cityPtr.getFactoryProd(gid) * 7;

    boCache := frm.cityBODataCacheList.get(city);

    for pid := MIN_TRADER_ID to getLastPlayerID() do
    begin
      bo := boCache.findPlayerBO(pid);
      if bo <> nil then
        q := q + bo.FactoryProductions[gid] * 7;
    end;

    if q <> 0 then
      CellText := formatQty(q, isGoodsMeasuredInPkg(gid));
  end;

  procedure gt_CityWeaponStore(cityWeaponId: integer);
  begin
    CellText := cityPtr.getCityWeaponStr(cityWeaponId);
  end;

  procedure gt_CityShipWeaponStore(shipWeaponID: integer);
  begin
    CellText := cityPtr.getCityShipWeaponStr(shipWeaponID);
  end;

  procedure gt_citySwordStore();
  begin
    if cityptr.SwordStore > 0 then
      CellText := IntToStr(cityptr.SwordStore);
  end;

  procedure _gt_FacilityReq(req, prov: double);
  var
    d: double;
  begin
    if prov = 0 then
      d := 0
    else
      d := prov * 100 /req;

    CellText := IntToStr(Trunc(prov));
    CellText := CellText + '(' + IntToStr(Trunc(d)) + '%)';
  end;

//    TAG__FACILITY_WELL = 301;
  procedure gt_Facility_Well();
  begin
    _gt_FacilityReq(cityPtr.Pop_Total / 500, cityPtr.WellProv);
  end;

//    TAG__FACILITY_HOSPITAL = 302;
  procedure gt_Facility_Hospital();
  begin
    if cityPtr.HospitalReq = 0 then
      CellText := ''
    else
      _gt_FacilityReq(cityPtr.HospitalReq, cityPtr.HospitalProv);
  end;

//    TAG__FACILITY_CHURCH_1 = 303;
  procedure gt_Facility_Church1();
  begin
    CellText := wordToHexStr(cityptr.Church_1_);
  end;

  procedure gt_Facility_Church2();
  begin
    CellText := wordToHexStr(cityptr.Church_2_);
  end;

  procedure gt_Facility_ChurchUpgradeReq();
  begin
    CellText := IntToStr(cityptr.Church_UpgradeReq_);
  end;

  procedure gt_Facility_Road();
  var
    f: double;
  begin
    if cityPtr.RoadComplete = 0 then
      CellText := '0%'
    else if cityptr.RoadReq = 0 then
      CellText := Txt_Infinite
    else
    begin
      f := cityPtr.RoadComplete * 100 / cityptr.RoadReq;
      CellText := IntToStr(Trunc(f)) + '%';
    end;
  end;

  procedure gt_Facility_Chapel();
  begin
    if cityPtr.ChapelReq = 0 then
      CellText := ''
    else
      _gt_FacilityReq(cityptr.ChapelReq, cityptr.ChapelProv);
  end;

  procedure gt_Facility_School();
  var
    daysToComplete: integer;
    bc: TCityBuildingDataCache;
  begin
    bc := frm.cityBuildingCacheList.get(city);
    if bc.getHasSchool() then
    begin
      daysToComplete := bc.getSchoolDaysToComplete();
      if daysToComplete > 0 then
        CellText := '(' + IntToStr(daysToComplete) + '天完工)'
      else
        CellText := Txt_Tick;
    end
    else
      CellText := '';
  end;

  procedure gt_Facility_Mintage();
  var
    daysToComplete: integer;
    bc: TCityBuildingDataCache;
  begin
    bc := frm.cityBuildingCacheList.get(city);
    if bc.getHasMintage() then
    begin
      daysToComplete := bc.getMintageDaysToComplete();
      if daysToComplete > 0 then
        CellText := '(' + IntToStr(daysToComplete) + '天完工)'
      else
        CellText := Txt_Tick;
    end
    else
      CellText := '';
  end;

  procedure gt_Facility_Wall();
  var
    bc: TCityBuildingDataCache;
    l1cnt, l2cnt, l2finish, l3cnt, l3finish: integer;
  begin
    bc := frm.cityBuildingCacheList.get(city);

    bc.getWallInfo(l1cnt, l2cnt, l2finish, l3cnt, l3finish);

    if l3cnt <> 0 then
    begin
      if l3finish < l3cnt then
        CellText := Txt_CycleClear
      else
        CellText := Txt_CycleSolid;

      //lvl2
      if l2cnt <> 0 then
      begin
        if l2finish < l2cnt then
          CellText := CellText + ' ' + Txt_CycleClear
        else
          CellText := CellText + ' ' + Txt_CycleSolid;
      end
      else
        CellText := CellText + ' ' + Txt_CycleSolid;

      //lvl1
      CellText := CellText + ' ' + Txt_CycleSolid;
    end
    else if l2cnt <> 0 then
    begin
      if l2finish < l2cnt then
        CellText := Txt_CycleClear
      else
        CellText := Txt_CycleSolid;

      CellText := CellText + ' ' + Txt_CycleSolid;
    end
    else
      CellText := Txt_CycleSolid;
  end;

  procedure gt_SoldierTotal();
  var
    cnt, training: integer;
  begin
    cityPtr.getSoldierCount(cnt, training);
    if cnt <> 0 then
      CellText := IntToStr(cnt);

    if training <> 0 then
      CellText := CellText + '(' + IntToStr(training) + ') / ' + IntToStr(cityPtr.TotalAllowedSoldiers)
    else
      CellText := CellText + ' / ' + IntToStr(cityPtr.TotalAllowedSoldiers);
  end;

  procedure _gt_soldier(typ: integer);
  var
    s, t: integer;
  begin
    s := cityPtr.Soldiers[typ];
    if s <> 0 then
      CellText := CellText + IntToStr(s);

    t := cityPtr.TrainingSoldiers[typ];
    if t <> 0 then
      CellText := CellText + '(' + IntToStr(cityPtr.TrainingSoldiers[typ]) + ')';
  end;

  procedure gt_Soldier0();
  begin
    _gt_soldier(SOLDIER_TYPE_0);
  end;

  procedure gt_Soldier1();
  begin
    _gt_soldier(SOLDIER_TYPE_1);
  end;

  procedure gt_Soldier2();
  begin
    _gt_soldier(SOLDIER_TYPE_2);
  end;

  procedure gt_Soldier3();
  begin
    _gt_soldier(SOLDIER_TYPE_3);
  end;

  procedure gt_CityGate_Artillery();
  var
    bc: TCityBuildingDataCache;
    i, l1, l2: integer;
    s: string;
  begin
    bc := frm.cityBuildingCacheList.get(city);
    bc.getCityGate_Artillery(l1, l2);

    s := '';

    for i := 0 to l2 - 1 do
    begin
      if s <> '' then
        s := s + ' ';
      s := s + Txt_SquareClear;
    end;


    for I := 0 to l1 - 1 do
    begin
      if s <> '' then
        s := s + ' ';

      s := s + Txt_CycleSolid;
    end;

    CellText := s;
  end;

  procedure gt_SeaCoast_Artillery();
  var
    bc: TCityBuildingDataCache;
    i, l1, l2: integer;
    s: string;
  begin
    bc := frm.cityBuildingCacheList.get(city);
    bc.getSeacoast_Artillery(l1, l2);

    s := '';

    for i := 0 to l2 - 1 do
    begin
      if s <> '' then
        s := s + ' ';
      s := s + Txt_SquareClear;
    end;


    for I := 0 to l1 - 1 do
    begin
      if s <> '' then
        s := s + ' ';

      s := s + Txt_CycleSolid;
    end;

    CellText := s;
  end;

  procedure gt_PaoShe();
  var
    bc: TCityBuildingDataCache;
    i, cnt: integer;
    s: string;
  begin
    bc := frm.cityBuildingCacheList.get(city);
    cnt := bc.getPaoSheCount();

    s := '';

    for I := 0 to cnt - 1 do
    begin
      if i <> 0 then
        s := s + ' ';
      s := s + Txt_CycleSolid;
    end;

    CellText := s;
  end;

  procedure gt_Treasury();
  begin
    CellText := IntToStr(cityptr.Treasury);
  end;

  procedure gt_FreeCaptain();
  var
    cap: word;
    captain: PCaptainRec;
  begin
    cap := getFreeCaptain(cityPtr);

    if cap <> $FFFF then
    begin
      captain := getCaptionInfo(cap);
      CellText := formatCaptainAbility(captain);
    end;
  end; 

//    TAG__FACILITY_CHURCH_2 = 304;
//    TAG__FACILITY_CHURCH_UG_REQ = 305;
//    TAG__FACILITY_ROAD = 306;
//    TAG__FACILITY_CHAPEL = 307;
//    TAG__FACILITY_SCHOOL = 308;
//    TAG__FACILITY_MINTAGE = 309;
var
  gid: integer;
begin
  if Column < 0 then
    exit;
    
  try
    city := Sender.GetNodeUserDataInt(Node);

    tag := getColTagOf(frm.CityListGrid, Column);
    cityPtr := getCityPtr(city);

    case tag of
      TAG__CITY_ID: gt_index();
      TAG__CITY_PTR: gt_ptr();
      TAG__CITY_NAME: gt_cityName();
      TAG__POP_TOTAL: gt_popTotal();
      TAG__POP_RICH: gt_Pop_rich();
      TAG__POP_COMMON: gt_Pop_common();
      TAG__POP_POOR: gt_Pop_poor();
      TAG__POP_BEGGER: gt_Pop_begger();
      TAG__TREASURY: gt_Treasury();
      TAG__SATISFY_RICH: gt_Satisfy_rich();
      TAG__SATISFY_COMMON: gt_Satisfy_common();
      TAG__SATISFY_POOR: gt_Satisfy_poor();
      TAG__ADV_HOUSE: gt_AdvHouse();
      TAG__COMMON_HOUSE: gt_CommonHouse();
      TAG__POOR_HOUSE: gt_PoorHouse();

      TAG__GOODS1..TAG__GOODS_MAX:
      begin
        tag := tag - TAG__GOODS1;

        gid := tag div 5 + 1;

        case tag mod 5 of
          0: gt_CityStore(gid);
          1: gt_CityConsume(gid);
          2: gt_CityProd(gid);
          3: gt_CitySPrice(gid);
          4: gt_CityPPrice(gid);
        end;
      end;

      TAG__CITY_WEAPON_STORE1..TAG__CITY_WEAPON_STORE4:
      begin
        gt_CityWeaponStore(tag - TAG__CITY_WEAPON_STORE1 + 1);
      end;

      TAG__CITY_SHIP_WEAPON_STORE1..TAG__CITY_SHIP_WEAPON_STORE6:
      begin
        gt_CityShipWeaponStore(tag - TAG__CITY_SHIP_WEAPON_STORE1 + 1);
      end;

      TAG__CITY_SWORD_STORE:
        gt_citySwordStore();

      TAG__FACILITY_WELL:
        gt_Facility_Well();

      TAG__FACILITY_HOSPITAL:
        gt_Facility_Hospital();

//      TAG__FACILITY_CHURCH_1:
//        gt_Facility_Church1();
//
//      TAG__FACILITY_CHURCH_2:
//        gt_Facility_Church2();

      TAG__FACILITY_CHURCH_UG_REQ:
        gt_Facility_ChurchUpgradeReq();

      TAG__FACILITY_ROAD:
        gt_Facility_Road();

      TAG__FACILITY_CHAPEL:
        gt_Facility_Chapel();

      TAG__FACILITY_SCHOOL:
        gt_Facility_School();

      TAG__FACILITY_MINTAGE:
        gt_Facility_Mintage();

      TAG__FACILITY_WALL:
        gt_Facility_Wall();

      TAG__SOLDIER_TOTAL:
        gt_SoldierTotal();

      TAG__SOLDIER_0:
        gt_Soldier0();

      TAG__SOLDIER_1:
        gt_Soldier1();

      TAG__SOLDIER_2:
        gt_Soldier2();

      TAG__SOLDIER_3:
        gt_Soldier3();

      TAG__FACILITY_SEACOAST_ARTILLERY:
        gt_SeaCoast_Artillery();

      TAG__FACILITY_CITYGATE_ARTILLERY:
        gt_CityGate_Artillery();

      TAG__FACILITY_PAOSHE:
        gt_PaoShe();

      TAG__FREE_CAPTAIN:
        gt_FreeCaptain();
    end;
  except
    CellText := 'Error';
  end;
end;

procedure TCityListViewer.CityListGridPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  tag, city: integer;
  cityPtr: PCityStruct;
  g: TVirtualStringTree;

  procedure handleSatisfy(grade: integer);
  var
    psmall: PSmallInt;
  begin
    psmall := @cityPtr.Satisfy_rich;
    inc(psmall, grade);

    if psmall^ < 10 then
      TargetCanvas.Font.Color := clRed
    else
      TargetCanvas.Font.Color := clBlack;
  end;

  procedure handleHouse(grade: integer);
  var
    capacity, c, r, currResident: integer;
    pw: PWORD;
    pi: PInteger;
  begin
    pw := @cityPtr.AdvHouseCap;
    Inc(pw, grade);
    capacity := pw^;

    pi := @cityptr.Pop_rich;
    Inc(pi, grade);
    currResident := pi^;
    
    if capacity = 0 then
    begin
      r := 0;
    end
    else if currResident >= capacity then
      r := 100
    else
      r := Trunc(currResident * 100 / capacity);

    if r > 90 then
      TargetCanvas.Font.Color := clRed
    else
      TargetCanvas.Font.Color := clBlack;
  end;

  procedure handleWell();
  var
    rate: integer;
  begin
    rate := Trunc(cityPtr.WellProv * 500 * 100 / cityPtr.Pop_Total);
    if rate < 90 then
      TargetCanvas.Font.Color := clRed
    else
      TargetCanvas.Font.Color := clBlack;
  end;

  procedure handleRoad();
  var
    f: double;
  begin
    if cityPtr.RoadComplete = 0 then
      f := 0
    else if cityptr.RoadReq = 0 then
      f := 0
    else
    begin
      f := cityPtr.RoadComplete * 100 / cityptr.RoadReq;
    end;

    if f < 90 then
      TargetCanvas.Font.Color := clRed
    else
      TargetCanvas.Font.Color := clBlack;
  end;

  procedure handleHospital();
  var
    r: integer;
  begin
    if cityPtr.HospitalReq > 0 then
    begin
      r := cityPtr.HospitalProv * 100 div cityPtr.HospitalReq;
      if r < 90 then
        TargetCanvas.Font.Color := clRed
      else
        TargetCanvas.Font.Color := clBlack;
    end
    else
      TargetCanvas.Font.Color := clBlack;
  end;

  procedure handleChapel();
  var
    r: integer;
  begin
    if cityPtr.ChapelReq > 0 then
    begin
      r := cityPtr.ChapelProv * 100 div cityPtr.ChapelReq;
      if r < 90 then
        TargetCanvas.Font.Color := clRed
      else
        TargetCanvas.Font.Color := clBlack;
    end
    else
      TargetCanvas.Font.Color := clBlack;
  end;


begin
  if Column < 0 then
    exit;
    
  g := frm.CityListGrid;
  tag := getColTagOf(g, Column);
  city := g.GetNodeUserDataInt(Node);
  cityPtr := getCityPtr(city);
  
  case tag of
    TAG__SATISFY_RICH..TAG__SATISFY_POOR:
    begin
      handleSatisfy(tag - TAG__SATISFY_RICH);
    end;

    TAG__ADV_HOUSE..TAG__POOR_HOUSE:
    begin
      handleHouse(tag - TAG__ADV_HOUSE);
    end;

    TAG__FACILITY_ROAD:
    begin
      handleRoad();
    end;

    TAG__FACILITY_WELL:
      handleWell();

    TAG__FACILITY_HOSPITAL:
      handleHospital();

    TAG__FACILITY_CHAPEL:
      handleChapel();
  end;
end;

function  TCityListViewer.cityListSelectedIterate(
  iterator: TCityListSelectedIterator; iParam: integer; pParam: Pointer): Boolean;
var
  n: PVirtualNode;
  changed, abortIteration: Boolean;
  g: TVirtualStringTree;
  cityCode: integer;
  city: PCityStruct;
begin
  Result := False;
  g := frm.CityListGrid;
  n := g.GetFirstSelected();
  if n = nil then
  begin
    soundBeep();
    exit;
  end;

  while n <> nil do
  begin
    cityCode := g.GetNodeUserDataInt(n);
    city := getCityPtr(cityCode);

    changed := True;
    abortIteration := False;

    iterator(city, iParam, pParam, changed, abortIteration);
    if changed then
      Result := True;

    if abortIteration then
      exit;

    n := g.GetNextSelected(n);
  end;
end;

procedure TCityListViewer.cityListViewModeTabBarTabSelected(Sender: TObject;
  Item: TJvTabBarItem);
begin
  rebuildColumns();
end;

procedure TCityListViewer.columnsChanged(Sender: TObject);

  function  is3Bao(gid: integer): Boolean;
  begin
    case gid of
      GOODSID__RICE, GOODSID__BEER, GOODSID__FISH:
        Result := True;
    else
      Result := False;
    end;
  end;

  function  is7Xian(gid: integer): Boolean;
  begin
    case gid of
      GOODSID__POTTERY, GOODSID__WOOL, GOODSID__WHALE_OIL,
      GOODSID__MEAT, GOODSID__LEATHER, GOODSID__WOOD, GOODSID__SALT:
        Result := True;

    else
      Result := False;
    end;
  end;

  function  is6Cao(gid: integer): Boolean;
  begin
    case gid of
      GOODSID__ANIMAL_SKIN, GOODSID__TOOLS, GOODSID__CLOTH,
      GOODSID__HONEY, GOODSID__SPICE, GOODSID__WINE:
        Result := True;

    else
      Result := False;
    end;
  end;

  function  isConstructMaterial(gid: integer): Boolean;
  begin
    case gid of
      GOODSID__BRICK, GOODSID__WOOD, GOODSID__TOOLS,
      GOODSID__HEMP, GOODSID__ASPHALT:
        Result := True;

    else
      Result := False;
    end;
  end;

  function  isRawMaterial(gid: integer): Boolean;
  begin
    case gid of
      GOODSID__WOOL, GOODSID__RICE, GOODSID__WOOD, GOODSID__HEMP,
      GOODSID__IRON, GOODSID__SALT, GOODSID__TOOLS:
        Result := True;

    else
      Result := False;
    end;
  end;

var
  gid: integer;
  accept: Boolean;
begin
  frm.beginInternalUpdate();
  try
    for gid := MIN_GOODS_ID to MAX_GOODS_ID do
    begin
      accept := False;

      if not accept and frm.cbCityList_Goods_3Bao.Checked then
      begin
        if is3Bao(gid) then
          accept := True;
      end;

      if not accept and frm.cbCityList_Goods_7Xian.Checked then
      begin
        if is7Xian(gid) then
          accept := True;
      end;

      if not accept and frm.cbCityList_Goods_6Cao.Checked then
      begin
        if is6Cao(gid) then
          accept := True;
      end;

      if not accept and frm.cbCityList_Goods_Others.Checked then
      begin
        if isConstructMaterial(gid) then
          accept := True;
      end;

      if not accept and frm.cbCityList_Goods_RawMaterial.Checked then
      begin
        if isRawMaterial(gid) then
          accept := True;
      end;

      fShowGoods[gid] := accept;
    end;
  finally
    frm.endInternalUpdate();
  end;
  rebuildColumns();
end;

constructor TCityListViewer.Create(aForm: TfrmP3Insight);
begin
  inherited;
end;

procedure TCityListViewer.deactivate;
begin
  //nop
end;

destructor TCityListViewer.Destroy;
begin
  //nop
  inherited;
end;

function TCityListViewer.getMITag(sender: TObject): Integer;
begin
  Result := TMenuItem(sender).Tag;
end;

function TCityListViewer.getRecCount: Integer;
begin
  Result := frm.CityListGrid.TotalCount;
end;

class function TCityListViewer.getViewerType: TViewerType;
begin
  Result := CITY_LIST_VIWEER;
end;

procedure TCityListViewer.init;

  procedure initGoodsButtons();
  var
    i: integer;  
  begin
    for I := MIN_GOODS_ID to MAX_GOODS_ID do
    begin
      fShowGoods[i] := False;
    end;
    
    fShowGoods[GOODSID__RICE] := True;
    fShowGoods[GOODSID__BEER] := True;
    fShowGoods[GOODSID__FISH] := True;
  end;
  
begin
//  OutputDebugString('init');
  initGrid(frm.CityListGrid);

  frm.CityListGrid.Clear();

  initGoodsButtons();

  rebuildColumns();

  frm.CityListGrid.OnGetImageIndex := CityListGridGetImageIndex;
  frm.CityListGrid.OnGetText := CityListGridGetText;
  frm.CityListGrid.OnBeforeItemErase := CityListGridBeforeItemErase;
  frm.CityListGrid.OnAfterCellPaint := CityListGridAfterCellPaint;
  frm.CityListGrid.OnPaintText := CityListGridPaintText;
  frm.cityListViewModeTabBar.OnTabSelected := cityListViewModeTabBarTabSelected;

  frm.cbCityList_Goods_ShowStore.OnClick := columnsChanged;
  frm.cbCityList_Goods_ShowConsume.OnClick := columnsChanged;
  frm.cbCityList_Goods_ShowProd.OnClick := columnsChanged;
  frm.cbCityList_Goods_ShowBPrice.OnClick := columnsChanged;
  frm.cbCityList_Goods_ShowSPrice.OnClick := columnsChanged;

  frm.cbCityList_Goods_3Bao.OnClick := columnsChanged;
  frm.cbCityList_Goods_7Xian.OnClick := columnsChanged;
  frm.cbCityList_Goods_6Cao.OnClick := columnsChanged;
  frm.cbCityList_Goods_Others.OnClick := columnsChanged;
  frm.cbCityList_Goods_RawMaterial.OnClick := columnsChanged;


  if not Conf.AllowModify then
  begin
    frm.miCityListGridModItems.Enabled := False;
    exit;
  end;

  frm.miCityList_SetGoodsSatisfy1Week.OnClick := miCityList_SetGoodsSatisfy1WeekClick;
  frm.miCityList_AddGoodsSatisfy1Week.OnClick := miCityList_AddGoodsSatisfy1WeekClick;
  frm.miCityList_ClearGoods.OnClick := miCityList_ClearGoodsClick;
  frm.miCityList_BeggerAdd50.OnClick := miCityList_BeggerAddClick;
  frm.miCityList_CompleteFacility.OnClick := miCityList_CompleteFacilityClick;
  frm.miCityList_CompletePlayerBuilding.OnClick := miCityList_CompletePlayerBuildingClick;

  frm.miCityList_TreasuryAdd.OnClick := miCityList_TreasuryAddClick;
  frm.miCityList_TreasurySetTo.OnClick := miCityList_TreasurySetToClick;

  frm.miCityList_SoldierRestrictAdd.OnClick := miCityList_TotalAllowedSoldierAdd;
  frm.miCityList_Soldier0Add.OnClick := miCityList_Soldier0Add;
  frm.miCityList_Soldier1Add.OnClick := miCityList_Soldier1Add;
  frm.miCityList_Soldier2Add.OnClick := miCityList_Soldier2Add;
  frm.miCityList_Soldier3Add.OnClick := miCityList_Soldier3Add;
  frm.miCityList_AllSoldierAdd.OnClick := miCityList_AllSoldierAdd;
end;

procedure TCityListViewer.internalPrepare;
var
  i: byte;
  cnt: Integer;
begin
//  OutputDebugString('TCityListViewer.internalPrepare');
//  if frm.CityListGrid.TotalCount = 0 then
//  begin
    for I := 0 to getCityCount() - 1 do
    begin
      frm.CityListGrid.AddChild(nil, pointer(I));
    end;
//  end;
//  else
//  begin
//    cnt := getCityCount();
//
//    if cnt > integer(frm.CityListGrid.TotalCount) then
//    begin
//      for I := frm.CityListGrid.TotalCount to cnt - 1 do
//      begin
//        frm.CityListGrid.AddChild(nil, pointer(I));
//      end;
//    end;
//  end;

//  OutputDebugString('<-prepare');
end;

procedure TCityListViewer.internalReset;
begin
//  dbgStr('TCityListViewer.internalReset');
  frm.CityListGrid.Clear();
end;

procedure TCityListViewer.internalUpdate;
var
  i, cnt: integer;
begin
  cnt := getCityCount();

  if cnt > integer(frm.CityListGrid.TotalCount) then
  begin
    for I := frm.CityListGrid.TotalCount to cnt - 1 do
    begin
      frm.CityListGrid.AddChild(nil, pointer(I));
    end;
  end
  else
    frm.CityListGrid.Invalidate();
end;

procedure TCityListViewer.iter_AddGoodsSatisfy1Week(city: PCityStruct;
  iParam: integer; pParam: Pointer; var changed, abortIteration: Boolean);
var
  gid: integer;
  consume: integer;
begin
  for gid := MIN_GOODS_ID to MAX_GOODS_ID do
  begin
    consume := round(frm.residentConsumePrecalc.calcCityConsumeInWeek(gid, city.CityCode));
    city.GoodsStore[gid] := city.GoodsStore[gid] + consume;
  end;
end;

procedure TCityListViewer.iter_BeggerAdd(city: PCityStruct; iParam: integer;
  pParam: Pointer; var changed, abortIteration: Boolean);
begin
  city.Pop_begger := city.Pop_begger + iParam;
end;

procedure TCityListViewer.iter_ClearGoods(city: PCityStruct; iParam: integer;
  pParam: Pointer; var changed, abortIteration: Boolean);
var
  gid: integer;
  consume: integer;
begin
  for gid := MIN_GOODS_ID to MAX_GOODS_ID do
    city.GoodsStore[gid] := 0;
end;

procedure TCityListViewer.iter_CompleteFacility(city: PCityStruct;
  iParam: integer; pParam: Pointer; var changed, abortIteration: Boolean);
var
  i: integer;
  cb: PCityBuilding;
begin
  changed := False;
  
  for I := 0 to city.BuildingCount - 1 do
  begin
    cb := getCityBuilding(city, i);

    if (cb.CoordinateX = $FF) and (cb.CoordinateY = $FF) then
      Continue;

    if (cb.DaysNeedToComplete = 0) or (cb.DaysNeedToComplete = $FF) then
      Continue;

//    if (cb.Owner <> CITY_BUILDING_OWNER__PUBLIC)
//    and (cb.Owner <> CITY_BUILDING_OWNER__PUBLIC_LVL2_WALL)
//    and (cb.Owner <> CITY_BUILDING_OWNER__PUBLIC_LVL3_WALL) then
//      Continue;

    case cb.BuildingType of
      BUILDING__WEAPON_SHOP,
      BUILDING__CHURCH,
      BUILDING__MARKET,
      BUILDING__BAR,
      BUILDING__BANK,
      BUILDING__BATH_HOUSE,
      BUILDING__CITY_HALL,
      BUILDING__BARRACKS,
      BUILDING__CHAMBER_OF_COMMERCE,
      BUILDING__SEACOAST_ARTILLERY,
      BUILDING__SEACOAST_ARTILLERY_ADV,
      BUILDING__CITY_GATE_ARTILLERY,
      BUILDING__CITY_GATE_ARTILLERY_ADV,
      BUILDING__PAO_SHE,
      BUILDING__CITY_WALL,
      BUILDING__SCHOOL,
      BUILDING__WELL,
      BUILDING__MINTAGE,
      BUILDING__APIARY:
      begin
        if cb.DaysNeedToComplete > 5 then
        begin
//          dbgStr(ptrToHexStr(cb) + ': ' + getBuildingTypeName(cb.BuildingType) + ' changed!');
          cb.DaysNeedToComplete := 5;
          changed := True;
        end
        else if cb.DaysNeedToComplete <> 0 then
        begin
//          dbgStr(ptrToHexStr(cb) + ': ' + getBuildingTypeName(cb.BuildingType) + ', dayToComplete=' + IntToStr(cb.DaysNeedToComplete));
        end;
      end;
    end;
  end;
end;

procedure TCityListViewer.iter_CompletePlayerBuilding(city: PCityStruct;
  iParam: integer; pParam: Pointer; var changed, abortIteration: Boolean);
var
  i: integer;
  cb: PCityBuilding;
  idx: word;
begin
  changed := False;

  idx := city.FirstUnfinishedBuildingIndex;
  while idx <> $FFFF do
  begin
    cb := getCityBuilding(city, idx);

    idx := cb.NextIndex;

    if (cb.CoordinateX = $FF) and (cb.CoordinateY = $FF) then
      Continue;

    if (cb.DaysNeedToComplete = 0) or (cb.DaysNeedToComplete = $FF) then
      Continue;

    if (cb.Owner <> frm.currPlayer) then
      Continue;


    if cb.DaysNeedToComplete > 5 then
    begin
//      dbgStr(ptrToHexStr(cb) + ': ' + getBuildingTypeName(cb.BuildingType) + ' changed!');
      cb.DaysNeedToComplete := 5;
      changed := True;
    end
    else if cb.DaysNeedToComplete <> 0 then
    begin
//      dbgStr(ptrToHexStr(cb) + ': ' + getBuildingTypeName(cb.BuildingType) + ', dayToComplete=' + IntToStr(cb.DaysNeedToComplete));
    end;
  end;

//  for I := 0 to city.BuildingCount - 1 do
//  begin
//    cb := getCityBuilding(city, i);
//
//
//    if (cb.CoordinateX = $FF) and (cb.CoordinateY = $FF) then
//      Continue;
//
//    if (cb.DaysNeedToComplete = 0) or (cb.DaysNeedToComplete = $FF) then
//      Continue;
//
//    if (cb.Owner <> frm.currPlayer) then
//      Continue;
//
//    if cb.DaysNeedToComplete > 5 then
//    begin
//      dbgStr(ptrToHexStr(cb) + ': ' + getBuildingTypeName(cb.BuildingType) + ' changed!');
//      cb.DaysNeedToComplete := 5;
//      changed := True;
//    end
//    else if cb.DaysNeedToComplete <> 0 then
//    begin
//      dbgStr(ptrToHexStr(cb) + ': ' + getBuildingTypeName(cb.BuildingType) + ', dayToComplete=' + IntToStr(cb.DaysNeedToComplete));
//    end;
//  end;
end;

procedure TCityListViewer.iter_SetGoodsSatisfy1Week(city: PCityStruct;
  iParam: integer; pParam: Pointer; var changed, abortIteration: Boolean);
var
  gid: integer;
  consume: integer;
begin
  for gid := MIN_GOODS_ID to MAX_GOODS_ID do
  begin
    consume := round(frm.residentConsumePrecalc.calcCityConsumeInWeek(gid, city.CityCode));
    city.GoodsStore[gid] := consume;
  end;
end;

procedure TCityListViewer.iter_SoldierAdd(city: PCityStruct; iParam: integer;
  pParam: Pointer; var changed, abortIteration: Boolean);
var
  idx, p2: integer;
begin
  p2 := integer(pParam);
  if p2 < 0 then
  begin
    for idx := SOLDIER_TYPE_0 to SOLDIER_TYPE_3 do
      city.Soldiers[idx] := city.Soldiers[idx] + iParam;
  end
  else
  begin
    city.Soldiers[p2] := city.Soldiers[p2] + iParam;
  end;

  city.updateTotalAllowedSoldiers();
end;

procedure TCityListViewer.iter_SoldierRestrictAdd(city: PCityStruct;
  iParam: integer; pParam: Pointer; var changed, abortIteration: Boolean);
var
  i: integer;
begin
  i := city.TotalAllowedSoldiers + iParam;
  if i > High(smallint) then
    i := High(smallint);
  city.TotalAllowedSoldiers := i;
end;

procedure TCityListViewer.iter_TreasuryAdd(city: PCityStruct; iParam: integer;
  pParam: Pointer; var changed, abortIteration: Boolean);
begin
  city.Treasury := city.Treasury + iParam;
end;

procedure TCityListViewer.iter_TreasurySetTo(city: PCityStruct; iParam: integer;
  pParam: Pointer; var changed, abortIteration: Boolean);
begin
  city.Treasury := iParam;
end;

procedure TCityListViewer.miCityList_AddGoodsSatisfy1WeekClick(sender: TObject);
begin
  if cityListSelectedIterate(iter_AddGoodsSatisfy1Week, 0, nil) then
    frm.updateUI();  
end;

procedure TCityListViewer.miCityList_AllSoldierAdd(Sender: TObject);
begin
  if cityListSelectedIterate(iter_SoldierAdd, getMITag(Sender), pointer(-1)) then
    frm.updateUI();
end;

procedure TCityListViewer.miCityList_BeggerAddClick(Sender: TObject);
begin
  if cityListSelectedIterate(iter_BeggerAdd, getMITag(Sender), nil) then
  begin
    frm.updateUI();
  end;
end;

procedure TCityListViewer.miCityList_ClearGoodsClick(sender: TObject);
begin
  if cityListSelectedIterate(iter_ClearGoods, 0, nil) then
    frm.updateUI();
end;

procedure TCityListViewer.miCityList_CompleteFacilityClick(Sender: TObject);
begin
  if cityListSelectedIterate(iter_CompleteFacility, 0, nil) then
  begin
    frm.cityBuildingCacheList.reset();
    frm.updateUI();
  end;
end;

procedure TCityListViewer.miCityList_CompletePlayerBuildingClick(
  Sender: TObject);
begin
  if cityListSelectedIterate(iter_CompletePlayerBuilding, 0, nil) then
    frm.updateUI();
end;

procedure TCityListViewer.miCityList_SetGoodsSatisfy1WeekClick(Sender: TObject);
begin
  if cityListSelectedIterate(iter_SetGoodsSatisfy1Week, 0, nil) then
    frm.updateUI();
end;

procedure TCityListViewer.miCityList_Soldier0Add(Sender: TObject);
begin
  if cityListSelectedIterate(iter_SoldierAdd, getMITag(Sender), pointer(0)) then
    frm.updateUI();
end;

procedure TCityListViewer.miCityList_Soldier1Add(Sender: TObject);
begin
  if cityListSelectedIterate(iter_SoldierAdd, getMITag(Sender), pointer(1)) then
    frm.updateUI();
end;

procedure TCityListViewer.miCityList_Soldier2Add(Sender: TObject);
begin
  if cityListSelectedIterate(iter_SoldierAdd, getMITag(Sender), pointer(2)) then
    frm.updateUI();
end;

procedure TCityListViewer.miCityList_Soldier3Add(Sender: TObject);
begin
  if cityListSelectedIterate(iter_SoldierAdd, getMITag(Sender), pointer(3)) then
    frm.updateUI();
end;

procedure TCityListViewer.miCityList_TotalAllowedSoldierAdd(Sender: TObject);
begin
  if cityListSelectedIterate(iter_SoldierRestrictAdd, getMITag(Sender), nil) then
    frm.updateUI();
end;

procedure TCityListViewer.miCityList_TreasuryAddClick(Sender: TObject);
begin
  if cityListSelectedIterate(iter_TreasuryAdd, getMITag(Sender), nil) then
    frm.updateUI();

end;

procedure TCityListViewer.miCityList_TreasurySetToClick(Sender: TObject);
begin
  if cityListSelectedIterate(iter_TreasurySetTo, getMITag(sender), nil) then
    frm.updateUI();
end;

procedure TCityListViewer.onGoodsButtonClick(Sender: TObject);
var
  sb: TSpeedButton;
begin
  if frm.isInternalUpdating() then
    exit;
    
  sb := TSpeedButton(sender);
  fShowGoods[sb.Tag] := sb.Down;
  rebuildColumns();
end;

procedure TCityListViewer.rebuildColumns;

  procedure addCol(
          const aHeading: WideString;
          const aWidth: Integer;
          const aAlign: TAlignment;
          const aTag: Integer;
          const infoBk: Boolean = False;
          const imgIdx: integer = -1);
  var
    col: TVirtualTreeColumn;
  begin
    col := frm.CityListGrid.Header.Columns.Add();
    col.Text := aHeading;
    col.Width := aWidth;
    col.Alignment := aAlign;
    col.Tag := aTag;
    if imgIdx >= 0 then
      col.ImageIndex:= imgIdx;
    if infoBk then
      col.Color := clInfoBk;
  end;

var
  txt_rich, txt_common, txt_poor: WideString;

  procedure prepareGradeText();
  begin
    txt_rich := getGradeText(GRADE__RICH);
    txt_common := getGradeText(GRADE__COMMON);
    txt_poor := getGradeText(GRADE__POOR);
  end;

var
  gid, tag: integer;
  infobk, firstCol, accept: Boolean;
  S: WideString;

  function  colName(const S: WideString): WideString;
  begin
    if firstCol then
    begin
      Result := getGoodsName(gid) + S;
      firstCol := False;
    end
    else
      Result := S;
  end;

  function  is3Bao(gid: integer): Boolean;
  begin
    case gid of
      GOODSID__RICE, GOODSID__BEER, GOODSID__FISH:
        Result := True;
    else
      Result := False;
    end;
  end;

  function  is7Xian(gid: integer): Boolean;
  begin
    case gid of
      GOODSID__POTTERY, GOODSID__WOOL, GOODSID__WHALE_OIL,
      GOODSID__MEAT, GOODSID__LEATHER, GOODSID__WOOD, GOODSID__SALT:
        Result := True;

    else
      Result := False;
    end;
  end;

  function  is6Cao(gid: integer): Boolean;
  begin
    case gid of
      GOODSID__ANIMAL_SKIN, GOODSID__TOOLS, GOODSID__CLOTH,
      GOODSID__HONEY, GOODSID__SPICE, GOODSID__WINE:
        Result := True;

    else
      Result := False;
    end;
  end;

  function  isConstructMaterial(gid: integer): Boolean;
  begin
    case gid of
      GOODSID__BRICK, GOODSID__WOOD, GOODSID__TOOLS,
      GOODSID__HEMP, GOODSID__ASPHALT:
        Result := True;

    else
      Result := False;
    end;
  end;

  function  isRawMaterial(gid: integer): Boolean;
  begin
    case gid of
      GOODSID__WOOL, GOODSID__RICE, GOODSID__WOOD, GOODSID__HEMP,
      GOODSID__IRON, GOODSID__SALT, GOODSID__TOOLS:
        Result := True;

    else
      Result := False;
    end;
  end;      
    
begin
//  dbgStr('rebuildColumns->');

  frm.CityListGrid.BeginUpdate();
  try
    frm.CityListGrid.Header.Columns.Clear();

//    dbgStr('rebuildColumns1');

  //  addCol('Idx', 40, taRightJustify, TAG__CITY_ID);
  //  addCol('Ptr', 100, taLeftJustify, TAG__CITY_PTR);

    addCol('城镇名称', 140, taLeftJustify, TAG__CITY_NAME);
    addCol('总人口', 55, taRightJustify, TAG__POP_TOTAL);

//    dbgStr('rebuildColumns2');

    case frm.cityListViewModeTabBar.SelectedTab.Tag of
      1:
      begin
        prepareGradeText();

        addCol(txt_rich, 50, taRightJustify, TAG__POP_RICH);
        addCol(txt_common, 50, taRightJustify, TAG__POP_COMMON);
        addCol(txt_poor, 50, taRightJustify, TAG__POP_POOR);
      
        addCol(txt_rich + '满意度', 78, taRightJustify, TAG__SATISFY_RICH);
        addCol(txt_common + '满意度', 78, taRightJustify, TAG__SATISFY_COMMON);
        addCol(txt_poor + '满意度', 78, taRightJustify, TAG__SATISFY_POOR);
      //  addCol('不快乐阶级', 90, taRightJustify, TAG__UNHAPPY_GRADE);

        addCol(getHouseName(GRADE__RICH), 70, taRightJustify, TAG__ADV_HOUSE);
        addCol(getHouseName(GRADE__COMMON), 70, taRightJustify, TAG__COMMON_HOUSE);
        addCol(getHouseName(GRADE__POOR), 70, taRightJustify, TAG__POOR_HOUSE);

        addCol('金库', 80, taRightJustify, TAG__TREASURY);

        addCol('待业船长', 80, taRightJustify, TAG__FREE_CAPTAIN);
      end;

      2: //物资
      begin
        infobk := True;

        for gid := MIN_GOODS_ID to MAX_GOODS_ID do
        begin
          if not fShowGoods[gid] then
            Continue;

          tag := TAG__GOODS1 + (gid - 1) * 5;

          firstCol := True;

          if frm.cbCityList_Goods_ShowStore.Checked then
          begin
            addCol(colName('库存'), 90, taRightJustify, tag, infobk, IL20__GOODS_1 + gid - 1);
          end;

          if frm.cbCityList_Goods_ShowConsume.Checked then
            addCol(colName('需求'), 60, taRightJustify, tag + 1, infobk);

          if frm.cbCityList_Goods_ShowProd.Checked then
            addCol(colName('产出'), 60, taRightJustify, tag + 2, infobk);

          if frm.cbCityList_Goods_ShowBPrice.Checked then
            addCol(colName('买入'), 60, taRightJustify, tag + 3, infobk);

          if frm.cbCityList_Goods_ShowSPrice.Checked then
            addCol(colName('卖出'), 60, taRightJustify, tag + 4, infobk);

          infobk := not infobk;
        end;

//        dbgStr('rebuildColumns3');

        if frm.cbCityList_Goods_Others.Checked then
        begin
          for gid := CITY_WEAPON_1 to CITY_WEAPON_4 do
            addCol(getCityWeaponName(gid), 60, taRightJustify, TAG__CITY_WEAPON_STORE1 + (gid - CITY_WEAPON_1), infobk);

          infobk := not infobk;

          for gid := SHIP_WEAPON_1 to SHIP_WEAPON_6 do
            addCol(getCityShipWeaponName(gid), 60, taRightJustify, TAG__CITY_SHIP_WEAPON_STORE1 + (gid - SHIP_WEAPON_1), infobk);

          infobk := not infobk;

          addCol(getSwordName(), 60, taRightJustify, TAG__CITY_SWORD_STORE, infobk);
        end;

//        dbgStr('rebuildColumns4');
      end;

      3: //建筑
      begin
        infobk := False;
        addCol(getHouseName(GRADE__RICH), 70, taRightJustify, TAG__ADV_HOUSE);
        addCol(getHouseName(GRADE__COMMON), 70, taRightJustify, TAG__COMMON_HOUSE);
        addCol(getHouseName(GRADE__POOR), 70, taRightJustify, TAG__POOR_HOUSE);

        addCol('水井', 70, taRightJustify, TAG__FACILITY_WELL, infobk);
        addCol('医院', 70, taRightJustify, TAG__FACILITY_HOSPITAL, infobk);
        addCol('礼拜堂', 70, taRightJustify, TAG__FACILITY_CHAPEL, infobk);
//        addCol('教堂等级1？', 80, taRightJustify, TAG__FACILITY_CHURCH_1, infobk);
//        addCol('教堂等级2？', 80, taRightJustify, TAG__FACILITY_CHURCH_2, infobk);
        addCol('教堂需求？', 80, taRightJustify, TAG__FACILITY_CHURCH_UG_REQ, infobk);
        addCol('道路', 80, taRightJustify, TAG__FACILITY_ROAD, infobk);
        addCol('学校', 42, taRightJustify, TAG__FACILITY_SCHOOL, infobk);
        addCol('铸币', 42, taRightJustify, TAG__FACILITY_MINTAGE, infobk);
        addCol('城墙', 80, taRightJustify, TAG__FACILITY_WALL, infobk);
      end;

      4: //军事
      begin
        infobk := False;

        addCol('士兵总数', 90, taRightJustify, TAG__SOLDIER_TOTAL, infobk);
        addCol(getSoldierTypeName(SOLDIER_TYPE_0), 50, taRightJustify, TAG__SOLDIER_0, infobk);
        addCol(getSoldierTypeName(SOLDIER_TYPE_1), 50, taRightJustify, TAG__SOLDIER_1, infobk);
        addCol(getSoldierTypeName(SOLDIER_TYPE_2), 50, taRightJustify, TAG__SOLDIER_2, infobk);
        addCol(getSoldierTypeName(SOLDIER_TYPE_3), 50, taRightJustify, TAG__SOLDIER_3, infobk);

        infobk := True;
        addCol('城墙', 80, taRightJustify, TAG__FACILITY_WALL, infobk);
        addCol('城墙炮', 135, taRightJustify, TAG__FACILITY_CITYGATE_ARTILLERY, infobk);
        addCol('抛射', 80, taRightJustify, TAG__FACILITY_PAOSHE, infobk);
        addCol('海岸炮', 100, taRightJustify, TAG__FACILITY_SEACOAST_ARTILLERY, infobk);

        infobk := False;
        for gid := CITY_WEAPON_1 to CITY_WEAPON_4 do
          addCol(getCityWeaponName(gid), 60, taRightJustify, TAG__CITY_WEAPON_STORE1 + (gid - CITY_WEAPON_1), infobk);
      end;
    end;
  finally
    frm.CityListGrid.EndUpdate();
  end;

//  dbgStr('<-rebuildColumns');
end;

{ TMapViewer }

//function TMapViewer.acceptPropSubView(aSubView: TPropSubViewType): Boolean;
//begin
//  Result := False;
//end;

procedure TMapViewer.cancelEdits;
begin
  frm.MapShipGroupSelectGrid.CancelEditNode();
  frm.Map_TradeRouteGoodsGrid.CancelEditNode();
  frm.Map_TradeRouteCityGrid.CancelEditNode();
end;

procedure TMapViewer.cbMap_drawCityNameClick(Sender: TObject);
begin
  if frm.isInternalUpdating() then
    exit;

//  dbgStr('cbMap_drawCityNameClick');

  fMapInfo.PropDrawCityName := frm.cbMap_drawCityName.Checked;
  fMapInfo.update();  
end;

procedure TMapViewer.cbMap_SelectedShipGroupIsTradingClick(Sender: TObject);
begin
  if frm.isInternalUpdating() then
    exit;

  if (fSelectedShip = nil) or (fSelectedShip.TradingIndex = $FFFF) then
  begin
    soundBeep();
    exit;
  end;

  if frm.cbMap_SelectedShipGroupIsTrading.Checked then
    fSelectedShip^.IsTrading := 1
  else
    fSelectedShip^.IsTrading := 0;
end;

procedure TMapViewer.cbMap_ShipGroupSelect_AreaChanged(Sender: TObject);
var
  idx: integer;
  area: TAreaImpl;
begin
  if frm.isInternalUpdating() then
    exit;

  idx := frm.cbMap_ShipGroupSelect_Area.ItemIndex;
  if idx < 0 then
    idx := 0;

  if idx = 0 then
    fFilter_Area := ''
  else
  begin
    area := frm.AreaDef.getArea(idx-1);
    fFilter_Area := area.ShipNamePrefix;
  end;

  reloadShipGroupSelectGrid();
end;

constructor TMapViewer.Create(aForm: TfrmP3Insight);
var
  opts: TCachedMapInfoOptions;

  procedure initGoodsButtons();
  
    procedure add(b: TSpeedButton; goodsID: Integer);
    begin
      b.AllowAllUp := True;
      b.Down := False;
      b.Tag := goodsID;
      b.GroupIndex := goodsID;
      b.OnClick := onGoodsButtonClick;
      fGoodsButtons.Add(b);
    end;

  begin
    fGoodsButtons := TList.Create();

    add(frm.sbMap_ShowGoods_Rice, GOODSID__RICE);
    add(frm.sbMap_ShowGoods_Fish, GOODSID__FISH);
    add(frm.sbMap_ShowGoods_Meat, GOODSID__MEAT);
    add(frm.sbMap_ShowGoods_Beer, GOODSID__BEER);
    add(frm.sbMap_ShowGoods_Wine, GOODSID__WINE);
    add(frm.sbMap_ShowGoods_Salt, GOODSID__SALT);
    add(frm.sbMap_ShowGoods_Honey, GOODSID__HONEY);
    add(frm.sbMap_ShowGoods_Spice, GOODSID__SPICE);

    add(frm.sbMap_ShowGoods_Wool, GOODSID__WOOL);
    add(frm.sbMap_ShowGoods_Cloth, GOODSID__CLOTH);
    add(frm.sbMap_ShowGoods_AnimalSkin, GOODSID__ANIMAL_SKIN);
    add(frm.sbMap_ShowGoods_Leather, GOODSID__LEATHER);

    add(frm.sbMap_ShowGoods_Tools, GOODSID__TOOLS);
    add(frm.sbMap_ShowGoods_Wood, GOODSID__WOOD);
    add(frm.sbMap_ShowGoods_Pottery, GOODSID__POTTERY);
    add(frm.sbMap_ShowGoods_WhaleOil, GOODSID__WHALE_OIL);
    add(frm.sbMap_ShowGoods_Hemp, GOODSID__HEMP);
    add(frm.sbMap_ShowGoods_Asphalt, GOODSID__ASPHALT);
    add(frm.sbMap_ShowGoods_Brick, GOODSID__BRICK);
    add(frm.sbMap_ShowGoods_Iron, GOODSID__IRON);
  end;

begin
  inherited;
  opts.doDrawCityName := True;
  initGoodsButtons();

  fMapInfo := TCachedMapInfo.Create(
          frm.Map,
          frm.GoodsImageProv,
          opts,
          frm,
          frm.numBmpList);
  fMapInfo.OnSelectedRoutePointIndexChanged := onSelectedRoutePointIndexChanged;

  fTempList_UsedForPriceList := TList.Create();
end;

procedure TMapViewer.deactivate;
begin
//  dbgStr('TMapViewer.deactivate->');
  fMapInfo.deactivate();
//  dbgStr('deactivate2');
  fSelectedShip := nil;
  fSelectedTradeRoute := nil;
  frm.MapShipGroupSelectGrid.Clear();
  frm.Map_TradeRouteCityGrid.Clear();
//  dbgStr('<-TMapViewer.deactivate');
end;

destructor TMapViewer.Destroy;
begin
  FreeAndNil(MapSrcOrg);
  FreeAndNil(MapSrc);
  FreeAndNil(fMapInfo);
  FreeAndNil(fGoodsButtons);
  FreeAndNil(fTempList_UsedForPriceList);
  inherited;
end;

function  TMapViewer.doTradeRouteAddCity(city: integer): PVirtualNode;
var
  I, trIdx, prevTrIdx, toIdx: integer;
  n: PVirtualNode;
  tr, trPrev: PTradeRoute;
  needChangeOrder: boolean;
begin
  Result := nil;
  
  if fSelectedShip = nil then
    exit;

  if fTradeRouteIndices.Count >= 20 then
    exit;

  n := frm.Map_TradeRouteCityGrid.SelectedNode;

  trIdx := tradeRoute_new();
  tr := getTradeRoute(trIdx);
  tr.CityCode := city;

  dbgStr('Add city: ' + byteToHexStr(city));

  if n <> nil then
  begin
    toIdx := n^.Index + 1 + 1;
    needChangeOrder := integer(n^.Index + 1) <> fTradeRouteIndices.Count;
    prevTrIdx := fTradeRouteIndices.getTRIndex(n^.Index + 1); 
  end
  else
  begin
    toIdx := fTradeRouteIndices.Count + 1;
    needChangeOrder := False;
    if fTradeRouteIndices.Count = 0 then
      prevTrIdx := $FFFF
    else
      prevTrIdx := fTradeRouteIndices.getLastTRIndex();
  end;

  if needChangeOrder then
  begin
    for I := fTradeRouteIndices.Count downto toIdx do 
    begin
      fTradeRouteIndices.Indices[i+1] := fTradeRouteIndices.Indices[i];
    end;
  end;

  Inc(fTradeRouteIndices.Count);

  fTradeRouteIndices.Indices[toIdx] := trIdx;

  if prevTrIdx <> $FFFF then
  begin
    trPrev := getTradeRoute(prevTrIdx);

    tr.NextIndex := trPrev.NextIndex;
    trPrev.NextIndex := trIdx;
  end
  else
    tr.NextIndex := trIdx;

  if needChangeOrder then
    Result := frm.Map_TradeRouteCityGrid.InsertNode(n, amInsertAfter, tr)
  else
    Result := frm.Map_TradeRouteCityGrid.AddChild(nil, tr);

  if fTradeRouteIndices.Count = 1 then
  begin
    fSelectedShip.TradingIndex := trIdx;
    fSelectedTradeIndex := trIdx;
    fSelectedTradeRoute := tr;
    fRunningTradeRoute := tr;
    tr.setFirstFlag();
  end;  

  fMapInfo.setTradeRouteDrawInfo(fSelectedShip, fTradeRouteIndices);
end;

procedure TMapViewer.edMap_ShipGroupSelect_NameChange(Sender: TObject);
begin
  if frm.isInternalUpdating() then
    exit;

  fFilter_ShipName := frm.edMap_ShipGroupSelect_Name.Text;

  reloadShipGroupSelectGrid();  
end;

function TMapViewer.getDefaultPPrice(gid: integer): Integer;
var
  ppl: TPriceList;
begin
  ppl := Conf.PriceDefs.getDefaultPPriceList();
  if ppl = nil then
    Result := getGeneralGoodsProdCost(gid)
  else
    Result := ppl.get(gid);
end;

function TMapViewer.getDefaultSPrcie(gid: integer): Integer;
var
  spl: TPriceList;
begin
  spl := Conf.PriceDefs.getDefaultSPriceList();
  if spl = nil then
    Result := getGeneralGoodsProdCost(gid)
  else
    Result := spl.get(gid);
end;

function TMapViewer.getRecCount: Integer;
begin
  Result := -1;
end;

class function TMapViewer.getViewerType: TViewerType;
begin
  Result := MAP_VIEWER;
end;

procedure TMapViewer.init;
var
  i: Integer;
begin
  fSelectedShipIndex := $FFFF;
  fSelectedTradeIndex := $FFFF;

  initGrid(frm.MapShipGroupSelectGrid);
  initGrid(frm.Map_TradeRouteGoodsGrid);
  initGrid(frm.Map_TradeRouteCityGrid);
//  MapSrcOrg := TBitmap32.Create();
//  MapSrcOrg.LoadFromFile(StuffPath + 'map.png');
//
//  MapSrc := TBitmap32.Create();
//  MapSrc.Width := MapSrcOrg.Width;
//  MapSrc.Height := MapSrcOrg.Height;
  frm.lblMap_SelectedShipName.Caption := '';
  frm.cbMap_drawCityName.OnClick := cbMap_drawCityNameClick;
  frm.sbMap_ShowGoods_Clear.OnClick := sbMap_ShowGoods_ClearClick;
  
  frm.MapShipGroupSelectGrid.OnDblClick := MapShipGroupSelectGridDblClick;
  frm.MapShipGroupSelectGrid.OnGetText := MapShipGroupSelectGridGetText;

 

  frm.Map_TradeRouteCityGrid.OnGetText := Map_TradeRouteCityGridGetText;
  frm.Map_TradeRouteCityGrid.OnChange := Map_TradeRouteCityGridChange;
  frm.Map_TradeRouteCityGrid.OnDblClick := Map_TradeRouteCityGridDblClick;
  frm.Map_TradeRouteCityGrid.OnDragOver := Map_TradeRouteCityGridDragOver;
  frm.Map_TradeRouteCityGrid.OnDragDrop := Map_TradeRouteCityGridDragDrop;
  frm.pmTradeRouteCityGrid.OnPopup := pmTradeRouteCityGridPopup;
  frm.miMap_TRCityGrid_RemoveCity.OnClick := miMap_TRCityGrid_RemoveCityClick;

  frm.Map_TradeRouteGoodsGrid.OnGetText := Map_TradeRouteGoodsGridGetText;
  frm.Map_TradeRouteGoodsGrid.OnGetImageIndex := Map_TradeRouteGoodsGridGetImageIndex;
  frm.Map_TradeRouteGoodsGrid.OnEditing := Map_TradeRouteGoodsGridEditing;
  frm.Map_TradeRouteGoodsGrid.OnBeforeItemErase := Map_TradeRouteGoodsGridBeforeItemErase;
  frm.Map_TradeRouteGoodsGrid.OnFocusChanged := Map_TradeRouteGoodsGridFocusChanged;
  frm.Map_TradeRouteGoodsGrid.OnNewText := Map_TradeRouteGoodsGridNewText;
  frm.Map_TradeRouteGoodsGrid.OnCreateEditor := Map_TradeRouteGoodsGridCreateEditor;
  frm.Map_TradeRouteGoodsGrid.OnKeyPress := Map_TradeRouteGoodsGridKeyPress;
  frm.Map_TradeRouteGoodsGrid.OnHeaderDblClick := Map_TradeRouteGoodsGridHeaderDblClick;
  frm.Map_TradeRouteGoodsGrid.OnDblClick := Map_TradeRouteGoodsGridDblClick;
  frm.Map_TradeRouteGoodsGrid.OnAfterCellPaint := Map_TradeRouteGoodsGridAfterCellPaint;

  frm.pmTradeRouteGoodsGrid.OnPopup := pmTradeRouteGoodsGridPopup;

  frm.miMap_TRGoods_OpNONE.Tag := Ord(RT__UNSPECIFIED);
  frm.miMap_TRGoods_OpNONE.OnClick := miMap_TRGoods_SetOpClick;
  frm.miMap_TRGoods_Buy.Tag := Ord(RT__BUY);
  frm.miMap_TRGoods_Buy.OnClick := miMap_TRGoods_SetOpClick;
  frm.miMap_TRGoods_Sell.Tag := Ord(RT__SELL);
  frm.miMap_TRGoods_Sell.OnClick := miMap_TRGoods_SetOpClick;
  frm.miMap_TRGoods_PutInto.Tag := Ord(RT__PUT_INTO);
  frm.miMap_TRGoods_PutInto.OnClick := miMap_TRGoods_SetOpClick;
  frm.miMap_TRGoods_GetOut.Tag := Ord(RT__GET_OUT);
  frm.miMap_TRGoods_GetOut.OnClick := miMap_TRGoods_SetOpClick;

  frm.miMap_TRGoods_AllNone.Tag := Ord(RT__UNSPECIFIED);
  frm.miMap_TRGoods_AllNone.OnClick := miMap_TRGoods_AllOpClick;

  frm.miMap_TRGoods_AllSell.Tag := Ord(RT__SELL);
  frm.miMap_TRGoods_AllSell.OnClick := miMap_TRGoods_AllOpClick;

  frm.miMap_TRGoods_AllBuy.Tag := Ord(RT__BUY);
  frm.miMap_TRGoods_AllBuy.OnClick := miMap_TRGoods_AllOpClick;

  frm.miMap_TRGoods_AllPutInto.Tag := Ord(RT__PUT_INTO);
  frm.miMap_TRGoods_AllPutInto.OnClick := miMap_TRGoods_AllOpClick;

  frm.miMap_TRGoods_AllGetOut.Tag := Ord(RT__GET_OUT);
  frm.miMap_TRGoods_AllGetOut.OnClick := miMap_TRGoods_AllOpClick;

  frm.cbMap_SelectedShipGroupIsTrading.OnClick := cbMap_SelectedShipGroupIsTradingClick;
  frm.edMap_ShipGroupSelect_Name.OnChange := edMap_ShipGroupSelect_NameChange;

  frm.sbMap_SelectPrevShip.OnClick := sbMap_SelectPrevShipClick;
  frm.sbMap_SelectNextShip.OnClick := sbMap_SelectNextShipClick;

  frm.cbMap_ShipGroupSelect_Area.OnChange := cbMap_ShipGroupSelect_AreaChanged;

  for I := MIN_GOODS_ID to MAX_GOODS_ID do
  begin
    frm.Map_TradeRouteGoodsGrid.AddChild(nil, Pointer(PYIndexToGoodsID(i)));
  end;

  frm.Map.OnDblClick := MapDblClick;

  frm.miMap_LoadTradeRoutes.OnClick := miMap_LoadTradeRoutesClick;
  frm.miMap_SaveTradeRoutes.OnClick := miMap_SaveTradeRoutesClick;

  frm.pcMapViewCtrl.ActivePageIndex := 0;
end;

procedure TMapViewer.internalPrepare;
var
  i: integer;
  area: TAreaImpl;
begin
  fMapInfo.prepare();

  frm.cbMap_ShipGroupSelect_Area.Items.Clear();

  frm.cbMap_ShipGroupSelect_Area.Items.Add(Txt_All);

  for I := 0 to frm.AreaDef.getAreaCount() - 1 do
  begin
    area := frm.AreaDef.getArea(i);
    frm.cbMap_ShipGroupSelect_Area.Items.Add(area.Name);
  end;
end;

procedure TMapViewer.internalReset;
begin
  fMapInfo.reset();
  fSelectedShipIndex := $FFFF;
  fSelectedShip := nil;
  fSelectedTradeIndex := $FFFF;
  fSelectedTradeRoute := nil;
//  fFilter_ShipName := '';
//  fFilter_Area := '';

  frm.MapShipGroupSelectGrid.Clear();
end;

procedure TMapViewer.internalUpdate;
var
  I: Integer;
  sgList, shipList: TList;
  sgInfo: PShipGroupInfo;
//  ship: PP3R2Ship;
begin
  if fSelectedShipIndex <> $FFFF then
  begin
    fSelectedShip := getShipByIndex(fSelectedShipIndex);
    if fSelectedTradeIndex <> $FFFF then
      fSelectedTradeRoute := getTradeRoute(fSelectedTradeIndex)
    else
      fSelectedTradeRoute := nil;
  end
  else
  begin
    fSelectedShip := nil;
    fSelectedTradeIndex := $FFFF;
    fSelectedTradeRoute := nil;
  end;

  reloadShipGroupSelectGrid();
  
  fMapInfo.update();

  SelectedShipGroupChanged();
end;

procedure TMapViewer.loadPriceIntoSelectedNodes(nodeList: TList; pl: TPriceList);
var
  i: integer;
  grid: TVirtualStringTree;
  n: PVirtualNode;
  gid, price, defQty: Integer;
  op: TTradeRouteOpType;
begin
  if (fSelectedShip = nil) or (fSelectedTradeRoute = nil) then
    exit;


  if nodeList.Count = 0 then
    exit;

  grid := frm.Map_TradeRouteGoodsGrid;

  for I := 1 to nodeList.count-1 do
  begin
    n := nodeList[I];
    gid := grid.GetNodeUserDataInt(n);
    op := fSelectedTradeRoute.getOpType(gid);
    price := pl.get(gid);

    if op = RT__UNSPECIFIED then
      defQty := getGoodsQtyFactor(gid)
    else
      defQty := fSelectedTradeRoute.getMaxQty(gid);

    case op of
      RT__UNSPECIFIED, RT__SELL, RT__BUY:
      begin
        if pl.priceDefType = PDT__B then
          fSelectedTradeRoute.setBuy(gid, price, defQty)
        else
          fSelectedTradeRoute.setSell(gid, price, defQty);
      end;
    end;
  end;

  grid.Invalidate();
end;

procedure TMapViewer.loadTradeRoutes(tr: TCustomTradeRoute);

//  function  findCityMI(city: integer): TMenuItem;
//  var
//    i: integer;
//    pm: TBcBarPopupMenu;
//  begin
//    pm := frm.pmTradeRouteCityGrid;
//
//    for I := 0 to pm.Items.Count - 1 do
//    begin
//      Result := pm.Items[I];
//      if Result.Tag = city then
//        exit;
//    end;
//
//    Result := nil;
//  end;

//  function  findNodeByCity(city: byte): PVirtualNode;
//  var
//    n: PVirtualNode;
//    tr: PTradeRoute;
//    g: TVirtualStringTree;
//  begin
//    g := frm.Map_TradeRouteCityGrid;
//    n := g.GetFirst();
//    while n <> nil do
//    begin
//      tr := g.GetNodeUserData(n);
//      if tr.CityCode = city then
//      begin
//        Result := n;
//        exit;
//      end;
//
//      n := g.GetNext(n);
//    end;
//
//    Result := nil;
//  end;

var
  i, J: integer;
  city: TCustomTRCity;
//  mi: TMenuItem;
  n: PVirtualNode;
  tradeRoute{, firstTR}: PTradeRoute;
//  first: Boolean;
  op: TCustomTROp;
  cityCode: Byte;
  firstN: PVirtualNode;
//  firstTradeIdx: Word;
begin
  frm.Map_TradeRouteCityGrid.CancelEditNode();
  frm.Map_TradeRouteCityGrid.SelectAll(False);
  miMap_TRCityGrid_RemoveCityClick(frm.miMap_TRCityGrid_RemoveCity);

//  first := True;
//  firstTradeIdx := $FFFF;
//  firstTR := nil;

  firstN := nil;

  for I := 0 to tr.getCount() - 1 do
  begin
    city := tr.get(I);

    cityCode := internalCityIDToCityCode(city.CityInternalCode);

//    mi := findCityMI(cityCode);
//    if mi = nil then
//    begin
//      dbgStr('至少有一个航线城镇没有添加到航线中');
//      frm.showMsg(MT__ERROR, '至少有一个航线城镇没有添加到航线中');
//      Continue;
//    end;
//
//    onMITradeRouteAddCityClick(mi);
    n := doTradeRouteAddCity(cityCode);

    if n = nil then
    begin
      frm.showMsg(MT__ERROR, '错误，可能是航线中的城镇太多');
      Continue;
    end;

    if firstN = nil then
      firstN := n;

    tradeRoute := frm.Map_TradeRouteCityGrid.GetNodeUserData(n);
//    if first then
//    begin
//      tradeRoute.setFirstFlag();
//      firstTradeIdx := indexOfTradeRoute(tradeRoute);
//      firstTR := nil;
//      first := False;
//    end;

    case city.Option of
      CO__NONE: ;
      CO__FIX:      tradeRoute.setFixFlag();
      CO__NO_STOP:  tradeRoute.setNoStopFlag();
    end;

    for J := 0 to city.getCount() - 1 do
    begin
      op := city.get(J);

      case op.OpType of
        RT__UNSPECIFIED: ;
        RT__SELL:
        begin
          tradeRoute.setSell(op.GoodsID, op.Price, op.Qty);
        end;
        
        RT__BUY:
        begin
          tradeRoute.setBuy(op.GoodsID, op.Price, op.Qty);
        end;
        
        RT__PUT_INTO:
        begin
          tradeRoute.setPutInto(op.GoodsID, op.Qty);
        end;

        RT__GET_OUT:
        begin
          tradeRoute.setGetOut(op.GoodsID, op.Qty);
        end;
      end;
    end;
  end;

  frm.Map_TradeRouteCityGrid.ClearSelection();
  if firstN <> nil then
    frm.Map_TradeRouteCityGrid.SelectNode(firstN);

//  if tr.getCount() = 0 then
//  begin
//    fSelectedTradeIndex := 0;
//    fSelectedTradeRoute := nil;
//    fSelectedShip.IsTrading := 0;
//    fSelectedShip.TradingIndex := $FFFF;
//  end
//  else
//  begin
//    fSelectedTradeIndex := firstTradeIdx;
//    fSelectedTradeRoute := firstTR;
//
//    fSelectedShip.TradingIndex := firstTradeIdx;
//   end;

  fMapInfo.setTradeRouteDrawInfo(fSelectedShip, fTradeRouteIndices);    
  frm.Map_TradeRouteGoodsGrid.Invalidate();
end;

procedure TMapViewer.MapDblClick(sender: TObject);
var
  i, x, y, xMin, xMax, yMin, yMax: integer;
  fp: TFixedPoint;
  city: integer;
  trIdx, prevTrIdx, toIdx: integer;
  n: PVirtualNode;
  tr, trPrev: PTradeRoute;
  needChangeOrder: boolean;
begin
  city := -1;

  for I := 0 to getCityCount() - 1 do
  begin
    x :=  fMapInfo.fCityPosInMap[I].X + fMapInfo.fMapXDelta;
    y := fMapInfo.fCityPosInMap[I].Y + fMapInfo.fMapYDelta;

    xMin := x;
    xMax := x + 22;
    yMin := y;
    yMax := y + 22;

    if (fMapInfo.fLastMousePos.X >= xMin)
    and (fMapInfo.fLastMousePos.X <= xMax)
    and (fMapInfo.fLastMousePos.Y >= yMin)
    and (fMapInfo.fLastMousePos.Y <= yMax) then
    begin
      city := i;
//      dbgStr('click on city=' + getCityName2(city));
      break;
    end;
  end;

  if city < 0 then
    exit;

  if fSelectedShip = nil then
    exit;

  if fTradeRouteIndices.Count >= 20 then
    exit;

  n := frm.Map_TradeRouteCityGrid.SelectedNode;

  trIdx := tradeRoute_new();
  tr := getTradeRoute(trIdx);
  tr.CityCode := city;

  if n <> nil then
  begin
    toIdx := n^.Index + 1 + 1;
    needChangeOrder := integer(n^.Index + 1) <> fTradeRouteIndices.Count;
    prevTrIdx := fTradeRouteIndices.getTRIndex(n^.Index + 1); 
  end
  else
  begin
    toIdx := fTradeRouteIndices.Count + 1;
    needChangeOrder := False;
    if fTradeRouteIndices.Count = 0 then
      prevTrIdx := $FFFF
    else
      prevTrIdx := fTradeRouteIndices.getLastTRIndex();
  end;

  if needChangeOrder then
  begin
    for I := fTradeRouteIndices.Count downto toIdx do 
    begin
      fTradeRouteIndices.Indices[i+1] := fTradeRouteIndices.Indices[i];
    end;
  end;

  Inc(fTradeRouteIndices.Count);

  fTradeRouteIndices.Indices[toIdx] := trIdx;

  if prevTrIdx <> $FFFF then
  begin
    trPrev := getTradeRoute(prevTrIdx);

    tr.NextIndex := trPrev.NextIndex;
    trPrev.NextIndex := trIdx;
  end
  else
    tr.NextIndex := trIdx;

  if needChangeOrder then
    frm.Map_TradeRouteCityGrid.InsertNode(n, amInsertAfter, tr)
  else
    frm.Map_TradeRouteCityGrid.AddChild(nil, tr);

  if fTradeRouteIndices.Count = 1 then
  begin
    fSelectedShip.TradingIndex := trIdx;
    fSelectedTradeRoute := tr;
    fRunningTradeRoute := tr;
    tr.setFirstFlag();
  end;  

  fMapInfo.setTradeRouteDrawInfo(fSelectedShip, fTradeRouteIndices);
end;

procedure TMapViewer.MapShipGroupSelectGridDblClick(Sender: TObject);
var
  n: PVirtualNode;
  ship: PP3R2Ship;
begin
  n := frm.MapShipGroupSelectGrid.SelectedNode;
  if n = nil then
    exit;

  ship := frm.MapShipGroupSelectGrid.GetNodeUserData(n);
  fSelectedShip := ship;
  fSelectedShipIndex := indexOfShip(ship);
  SelectedShipGroupChanged();
  
  frm.pcMapViewCtrl.ActivePage := frm.tabMapCtrl_TradeRoute;
end;

procedure TMapViewer.MapShipGroupSelectGridGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  ship: PP3R2Ship;
begin
  ship := Sender.GetNodeUserData(Node);

  case Column of
    0: CellText := getShipName_R2(ship);
    1: CellText := getshipArea(ship, Conf.ShipNameSeperator);
  end;
end;

procedure TMapViewer.Map_TradeRouteCityGridChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  tr: PTradeRoute;
begin
  if frm.isInternalUpdating() then
    exit;

  if Node = nil then
  begin
    fSelectedTradeIndex := $FFFF;
    fSelectedTradeRoute := nil;

    frm.Map_TradeRouteGoodsGrid.Invalidate();
    exit;
  end;

  if fSelectedShip = nil then
  begin
    fSelectedTradeIndex := $FFFF;
    fSelectedTradeRoute := nil;
    exit;
  end;
  
  tr := Sender.GetNodeUserData(Node);

//  fSelectedTradeIndex := indexOfTradeRoute(tr);
  fSelectedTradeRoute := tr;

  frm.Map_TradeRouteGoodsGrid.Invalidate();       
end;

procedure TMapViewer.Map_TradeRouteCityGridDblClick(Sender: TObject);
var
  g: TVirtualStringTree;
  n: PVirtualNode;
  r: PTradeRoute;
  forceUpdate: Boolean;
  idx: word;
begin
  g := frm.Map_TradeRouteCityGrid;
  n := g.SelectedNode;
  if n = nil then
    exit;

  if g.FocusedColumn < 0 then
    exit;

  r := g.GetNodeUserData(n);
  if g.FocusedColumn = 0 then
  begin
    idx := indexOfTradeRoute(r);
    if fSelectedShip.TradingIndex <> idx then
    begin
      fSelectedShip.TradingIndex := idx;
      fRunningTradeRoute := r;
      g.Invalidate();
    end;
  end
  else if g.FocusedColumn = 1 then
  begin
    if (fSelectedShip <> nil) and (fTradeRouteIndices.Count > 0) then
    begin
      fMapInfo.selectRoutePoint(n.Index + 1, False);
      forceUpdate := True;
    end
    else
      forceUpdate := False;

    fMapInfo.showCity(r.CityCode, forceUpdate);
  end
  else if g.FocusedColumn = 2 then
  begin
    if (r.Flags and (TRADE_ROUTE_FLAG__FIX or TRADE_ROUTE_FLAG__NO_STOP)) <> 0 then
    begin
      if (r.Flags and TRADE_ROUTE_FLAG__FIX) = TRADE_ROUTE_FLAG__FIX then
      begin
        r.clearFixFlag();
        r.setNoStopFlag();
      end
      else
      begin
        r.clearNoStopFlag();
      end;
    end
    else
    begin
      r.setFixFlag();
      g.Invalidate();
    end;
  end;
end;

procedure TMapViewer.Map_TradeRouteCityGridDragDrop(Sender: TBaseVirtualTree;
  Source: TObject; DataObject: IDataObject; Formats: TFormatArray;
  Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
var
  src, target: PVirtualNode;
  TR: PTradeRoute;
  before: Boolean;
  i, indexFrom, indexTo, orgFirst, newFirst: integer;
  am: TVTNodeAttachMode;
  list: TList;
begin
  if Mode = dmNowhere then
    Exit;

  if Sender.SelectedCount = 0 then
    exit;

  Effect := 0;

  target := Sender.GetNodeAt(Pt.X, Pt.Y);
  before := (Mode = dmAbove) or (Mode = dmOnNode);
  if before then
    am := amInsertBefore
  else
    am := amInsertAfter;

  orgFirst := fTradeRouteIndices.firstShipIndex;

  list := TList.Create();
  try
    src := Sender.GetFirstSelected();
    while src <> nil do
    begin
      list.Add(src);

      src := Sender.GetNextSelected(src);
    end;

    for I := 0 to List.Count - 1 do
    begin
      src := list[i];

      indexFrom := src.Index + 1;
      indexTo := target.Index + 1;

      RoutePointMove(indexFrom, indexTo, before);

      Sender.MoveTo(src, target, am, False);
    end;
  finally
    list.Destroy();
  end;

  newFirst := fTradeRouteIndices.indices[1];
  if orgFirst <> newFirst then
  begin
    for I := 2 to fTradeRouteIndices.Count do
    begin
      TR := getTradeRoute(fTradeRouteIndices.Indices[I]);
      TR.clearFirstFlag();
    end;

    TR := getTradeRoute(newFirst);
    tr.setFirstFlag();

    fTradeRouteIndices.firstShipIndex := newFirst;
  end;

  fMapInfo.setTradeRouteDrawInfo(fSelectedShip, fTradeRouteIndices);
end;

procedure TMapViewer.Map_TradeRouteCityGridDragOver(Sender: TBaseVirtualTree;
  Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint;
  Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
begin
  Accept := (Source = Sender) and (Mode <> dmNowhere);
end;

procedure TMapViewer.Map_TradeRouteCityGridGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  r: PTradeRoute;
begin
  r := Sender.GetNodeUserData(Node);

  case Column of
    0:
    begin
      if r = fRunningTradeRoute then
        CellText := '*';
    end;

    1:
    begin
      CellText := getCityName2(r^.CityCode);
    end;

    2:
    begin
      if (r^.Flags and TRADE_ROUTE_FLAG__NO_STOP) = TRADE_ROUTE_FLAG__NO_STOP then
        CellText := '不靠港'
      else if (r^.Flags and TRADE_ROUTE_FLAG__FIX) = TRADE_ROUTE_FLAG__FIX then
        CellText := '维修'
      else
        CellText := '';

//      CellText := CellText + ' ' + byteToHexStr(r^.Flags, False);
    end;
  end;
end;

procedure TMapViewer.Map_TradeRouteGoodsGridAfterCellPaint(
  Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
  Column: TColumnIndex; CellRect: TRect);
var
  city, gid, lvl, l, t: integer;
  cityStruct: PCityStruct;
begin
  if Column = 0 then
  begin
    if (fSelectedShip = nil) or (fSelectedTradeRoute = nil) then
      exit;

    gid := Sender.GetNodeUserDataInt(Node);

    city := fSelectedTradeRoute.CityCode;

    cityStruct := getCityPtr(city);
    lvl := getCityOriginalProdLvl(cityStruct, gid);

    if lvl = 0 then
      exit;

    t := CellRect.Top + (CellRect.Bottom - CellRect.Top - fMapInfo.ProdStar.Height) div 2;
    l := CellRect.Left + TVirtualStringTree(Sender).Header.Columns[Column].Margin + frm.il20x20.Width + 2;

    fMapInfo.ProdStar.DrawTo(TargetCanvas.Handle, l, t);

    if lvl > 1 then
    begin
      l := l + fMapInfo.ProdStar.Width;
      fMapInfo.ProdStar.DrawTo(TargetCanvas.Handle, l, t);
    end;
  end;
end;

procedure TMapViewer.Map_TradeRouteGoodsGridBeforeItemErase(
  Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
  ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
begin
  EraseAction := eaColor;

  if (Node.Index and 1) = 0 then
    ItemColor := clWhite
  else
    ItemColor := $00F2F2F2;
end;

procedure TMapViewer.Map_TradeRouteGoodsGridCreateEditor(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  out EditLink: IVTEditLink);
begin
  if (Column > 1) and (fSelectedShip <> nil) and (fSelectedTradeRoute <> nil) then
    EditLink := TMyStringEditLink.Create();
end;

procedure TMapViewer.Map_TradeRouteGoodsGridDblClick(Sender: TObject);
var
  i, gid: integer;
  n: PVirtualNode;
  g: TVirtualStringTree;
  btn: TSpeedButton;
begin
  g := frm.Map_TradeRouteGoodsGrid;
  n := g.SelectedNode;
  if n = nil then
    exit;
  
  for gid := MIN_GOODS_ID to MAX_GOODS_ID do
    fMapInfo.DrawGoodsInfo[gid] := False;

  gid := g.GetNodeUserDataInt(n);
  fMapInfo.DrawGoodsInfo[gid] := True;

  frm.beginInternalUpdate();
  try
    for I := 0 to fGoodsButtons.Count - 1 do
    begin
      btn := TSpeedButton(fGoodsButtons[I]);
      btn.Down := btn.Tag = gid;
    end;
  finally
    frm.endInternalUpdate();
  end;

  fMapInfo.update();
end;

procedure TMapViewer.Map_TradeRouteGoodsGridEditing(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
var
  gid: integer;
begin
  Allowed := False;

  if Column <= 1 then
    exit;

  if (fSelectedShip = nil) or (fSelectedTradeRoute = nil) then
    exit;

  if Column = 3 then
  begin
    gid := Sender.GetNodeUserDataInt(Node);

    if fSelectedTradeRoute.getOpType(gid)
    in [RT__UNSPECIFIED, RT__PUT_INTO, RT__GET_OUT] then
      exit;
  end;

  Allowed := True;
end;

procedure TMapViewer.Map_TradeRouteGoodsGridFocusChanged(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
begin
  if (fSelectedShip = nil)
  or (fSelectedTradeRoute = nil)
  or (Column <= 1)
  or (Node = nil) then
    exit;

  Sender.EditNode(Node, Column);
end;

procedure TMapViewer.Map_TradeRouteGoodsGridGetImageIndex(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
  Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
var
  gid: integer;
begin
  ImageIndex := -1;
  if (Column <> 0) or ((Kind <> ikNormal) and (Kind <> ikSelected)) then
    exit;
    
  gid := Sender.GetNodeUserDataInt(Node);

  ImageIndex := gid-1;
end;

procedure TMapViewer.Map_TradeRouteGoodsGridGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  gid, q, p: integer;
begin
  gid := Sender.GetNodeUserDataInt(Node);

  case Column of
    0: ;
    
    1:
    begin
      if fSelectedTradeRoute = nil then
        exit;

      CellText := fSelectedTradeRoute.getOpTypeStr(gid);
    end;

    2:
    begin
      if fSelectedTradeRoute = nil then
        exit;

      if fSelectedTradeRoute.IsUnlimitedQty(gid) then
        CellText := '最大'
      else
      begin
        q := fSelectedTradeRoute.getMaxQty(gid);
        if q = 0 then
          CellText := ''
        else
        begin
          if isGoodsMeasuredInPkg(gid) then
            q := q div UNIT_PKG
          else
            q := q div UNIT_TONG;
            
          CellText := IntToStr(q);
        end;
      end;
    end;

    3:
    begin
      if fSelectedTradeRoute = nil then
        exit;

      p := fSelectedTradeRoute.getPrice(gid); 
      q := fSelectedTradeRoute.MaxQty[gid];
      if q = 0 then
        CellText := ''
      else if p = 0 then
        CellText := '---'
      else
        CellText := IntToStr(p);
    end;
  end;
end;

procedure TMapViewer.Map_TradeRouteGoodsGridHeaderDblClick(Sender: TVTHeader;
  Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  if (Column <> 1) or (Button <> mbLeft)
  or (fSelectedShip = nil)
  or (fSelectedTradeRoute = nil) then
    exit;  
end;

procedure TMapViewer.Map_TradeRouteGoodsGridKeyPress(Sender: TObject;
  var Key: Char);
var
  I, gid: integer;
//  n: PVirtualNode;
  g: TVirtualStringTree;
  op: TTradeRouteOpType;
  price: integer;
begin
  if (fSelectedShip = nil)
  or (fSelectedTradeRoute = nil) then
    exit;

  g := frm.Map_TradeRouteGoodsGrid;

  if g.IsEditing() then
    exit;
    
  if g.SelectedCount = 0 then
  begin
    soundBeep();
    exit;
  end;


  if g.FocusedColumn = 1 then
  begin
    fTempList_UsedForPriceList.Clear();
    VTGetSelectedNodes(g, fTempList_UsedForPriceList);

    case Key of
      'b', 'B': TRSetOpByNodes(fTempList_UsedForPriceList, RT__BUY);
      's', 'S': TRSetOpByNodes(fTempList_UsedForPriceList, RT__SELL);
      'i', 'I': TRSetOpByNodes(fTempList_UsedForPriceList, RT__PUT_INTO);
      'o', 'O': TRSetOpByNodes(fTempList_UsedForPriceList, RT__GET_OUT);
      ' ': TRSetOpByNodes(fTempList_UsedForPriceList, RT__UNSPECIFIED);
    else
      soundBeep();
    end;
  end
  else if g.FocusedColumn = 2 then
  begin
    if (key = 'm') or (key = 'M') then
    begin
      fTempList_UsedForPriceList.Clear();
      VTGetSelectedNodes(g, fTempList_UsedForPriceList);

      for I := 0 to fTempList_UsedForPriceList.Count - 1 do
      begin
        gid := g.GetNodeUserDataInt(fTempList_UsedForPriceList[I]);
        op := fSelectedTradeRoute.getOpType(gid);
        price := fSelectedTradeRoute.getPrice(gid);
        TRSetOp(gid, op, price, TRADE_ROUTE__MAX_QTY);
      end;

      g.Invalidate();
    end
    else
      soundBeep();
  end;
end;

procedure TMapViewer.Map_TradeRouteGoodsGridNewText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; NewText: WideString);
var
  i, price, qty: integer;
  gid: integer;
begin
  if (Node = nil)
  or (Column <= 1)
  or (fSelectedShip = nil)
  or (fSelectedTradeRoute = nil) then
  begin
    soundBeep();
    exit;
  end;

  gid := Sender.GetNodeUserDataInt(Node);

  case Column of
    2: //qty
    begin
      if NewText = 'm' then
        i := TRADE_ROUTE__MAX_QTY
      else
      begin
        if not TryStrToInt(NewText, i) then
        begin
          soundBeep();
          exit;
        end;

        if isGoodsMeasuredInPkg(gid) then
          i := i * UNIT_PKG
        else
          i := i * UNIT_TONG;
      end;

      case fSelectedTradeRoute.getOpType(gid) of
        RT__UNSPECIFIED:
        begin
          price := getDefaultPPrice(gid);          
          fSelectedTradeRoute.setSell(gid, price, i);
        end;

        RT__SELL:
        begin
          price := fSelectedTradeRoute.getPrice(gid);
          fSelectedTradeRoute.setSell(gid, price, i);
        end;

        RT__BUY:
        begin
          price := fSelectedTradeRoute.getPrice(gid);
          fSelectedTradeRoute.setBuy(gid, price, i);
        end;

        RT__PUT_INTO:
        begin
          fSelectedTradeRoute.setPutInto(gid, i);
        end;

        RT__GET_OUT:
        begin
          fSelectedTradeRoute.setGetOut(gid, i);
        end;
      else
        soundBeep();
        exit;
      end;
    end;


    3: //price
    begin
      if not TryStrToInt(NewText, price) then
      begin
        soundBeep();
        exit;
      end;

      case fSelectedTradeRoute.getOpType(gid) of
        RT__UNSPECIFIED:
        begin
          qty := fSelectedTradeRoute.MaxQty[gid];
          fSelectedTradeRoute.setSell(gid, price, qty);
        end;

        RT__SELL:
        begin
          qty := fSelectedTradeRoute.getPrice(gid);
          fSelectedTradeRoute.setSell(gid, price, qty);
        end;

        RT__BUY:
        begin
          qty := fSelectedTradeRoute.getPrice(gid);
          fSelectedTradeRoute.setBuy(gid, price, qty);
        end;

     else
      soundBeep();
      exit;
     end;

    end;
  end;


  frm.Map_TradeRouteGoodsGrid.Invalidate();
end;

procedure TMapViewer.miMap_LoadTradeRoutesClick(Sender: TObject);
begin
  frm.tradeRouteSelectClient := TTradeRouteSelectClientImpl_Load.Create(
        Self);

  frm.showTradeRouteSelectPanel();
end;

procedure TMapViewer.miMap_SaveTradeRoutesClick(Sender: TObject);
begin
  frm.tradeRouteSelectClient := TTradeRouteSelectClientImpl_Save.Create(
        Self);
        
  frm.showTradeRouteSelectPanel();
end;

procedure TMapViewer.miMap_TRCityGrid_RemoveCityClick(Sender: TObject);
var
  i, indicesRemoveI, seq, cnt,
  selectedRPID, runningRPID: integer;
  n: PVirtualNode;
  firstRP: PTradeRoute;
  indicesToRemove: array[1..20] of integer;
begin
  if fSelectedShip = nil then
    exit;

  if frm.Map_TradeRouteCityGrid.SelectedCount = 0 then
    exit;

  if fSelectedTradeRoute = nil then
    selectedRPID := $FFFF
  else
    selectedRPID := indexOfTradeRoute(fSelectedTradeRoute);

  indicesRemoveI := 1;

  n := frm.Map_TradeRouteCityGrid.GetFirstSelected();

  while n <> nil do
  begin
    indicesToRemove[indicesRemoveI] := n.Index + 1;
    Inc(indicesRemoveI);

    n := frm.Map_TradeRouteCityGrid.GetNextSelected(n);
  end;

  cnt := indicesRemoveI - 1;

  for I := cnt downto 1 do
  begin
    seq := indicesToRemove[i];
    tradeRoute_free(fTradeRouteIndices.getTRIndex(seq));

    fTradeRouteIndices.remove(seq, False);
  end;

  fTradeRouteIndices.rechain();
  if fTradeRouteIndices.Count > 0 then
  begin
    seq := fTradeRouteIndices.firstFlagSeq();
    if seq <= 0 then
    begin
      fTradeRouteIndices.getTR(1).setFirstFlag();
      fTradeRouteIndices.firstShipIndex := 1;    
    end
    else
      fTradeRouteIndices.firstShipIndex := seq;
  end
  else
    fTradeRouteIndices.firstShipIndex := $FFFF;


  if not fTradeRouteIndices.has(selectedRPID) then
  begin
    fSelectedTradeRoute := nil;
  end;
  
  if not fTradeRouteIndices.has(fSelectedShip.TradingIndex) then
  begin
    fRunningTradeRoute := nil;
    fSelectedShip.TradingIndex := $FFFF;
  end;

  if fTradeRouteIndices.firstShipIndex <> $FFFF then
  begin
    firstRP := fTradeRouteIndices.getFirstRP();
    if fSelectedTradeRoute = nil then
      fSelectedTradeRoute := firstRP;

    if fRunningTradeRoute = nil then
    begin
      fRunningTradeRoute := firstRP;
      fSelectedShip.TradingIndex := fTradeRouteIndices.firstShipIndex;
    end;
  end;

  frm.Map_TradeRouteCityGrid.DeleteSelectedNodes();

  fMapInfo.setTradeRouteDrawInfo(fSelectedShip, fTradeRouteIndices);
end;

procedure TMapViewer.miMap_TRGoodsGrid_LoadPriceIntoAll(sender: TObject);
var
  grid: TVirtualStringTree;
  n: PVirtualNode;
  mi: TMenuItem;
  pl: TPriceList;  
begin
  if (fSelectedShip = nil) or (fSelectedTradeRoute = nil) then
    exit;
    
  grid := frm.Map_TradeRouteGoodsGrid;
  if grid.SelectedCount = 0 then
    exit;

  mi := TMenuItem(Sender);
  pl := TPriceList(mi.Tag);

  fTempList_UsedForPriceList.Clear();

  n := grid.GetFirst();
  while n <> nil do
  begin
    fTempList_UsedForPriceList.Add(n);
    
    n := grid.GetNext(n);
  end;

  loadPriceIntoSelectedNodes(fTempList_UsedForPriceList, pl);
end;

procedure TMapViewer.miMap_TRGoodsGrid_LoadPriceIntoSelected(Sender: TObject);
var
  grid: TVirtualStringTree;
  n: PVirtualNode;
  mi: TMenuItem;
  pl: TPriceList;  
begin
  if (fSelectedShip = nil) or (fSelectedTradeRoute = nil) then
    exit;

  grid := frm.Map_TradeRouteGoodsGrid;
  if grid.SelectedCount = 0 then
    exit;

  mi := TMenuItem(Sender);
  pl := TPriceList(mi.Tag);

  fTempList_UsedForPriceList.Clear();


  n := grid.GetFirstSelected();
  while n <> nil do
  begin
    fTempList_UsedForPriceList.Add(n);

    n := grid.GetNextSelected(n);
  end;

  loadPriceIntoSelectedNodes(fTempList_UsedForPriceList, pl);
end;


procedure TMapViewer.miMap_TRGoods_AllOpClick(Sender: TObject);
var
  mi: TMenuItem;
  op: TTradeRouteOpType;
  g: TVirtualStringTree;
begin
  if (fSelectedShip = nil)
  or (fSelectedTradeRoute = nil) then
    exit;

  mi := TMenuItem(Sender);
  op := TTradeRouteOpType(mi.Tag);

  fTempList_UsedForPriceList.Clear();

  g := frm.Map_TradeRouteGoodsGrid;

  VTGetAllNodes(g, fTempList_UsedForPriceList);
  TRSetOpByNodes(fTempList_UsedForPriceList, op);
end;

procedure TMapViewer.miMap_TRGoods_SetOpClick(sender: TObject);
var
  mi: TMenuItem;
  op: TTradeRouteOpType;
  N: PVirtualNode;
  grid: TVirtualStringTree;
begin
  grid := frm.Map_TradeRouteGoodsGrid;
  if grid.SelectedCount = 0 then
    exit;

  if (fSelectedShip = nil) or (fSelectedTradeRoute = nil) then
    exit;
    
  mi := TMenuItem(sender);

  op := TTradeRouteOpType(mi.Tag);

  fTempList_UsedForPriceList.Clear();

  n := grid.GetFirstSelected();
  while n <> nil do
  begin
    fTempList_UsedForPriceList.Add(N);

    n := grid.GetNextSelected(N);
  end;

  TRSetOpByNodes(fTempList_UsedForPriceList, op);
end;

procedure TMapViewer.onGoodsButtonClick(sender: TObject);
var
  sb: TSpeedButton;
begin
  if frm.isInternalUpdating() then
    exit;
    
  sb := TSpeedButton(sender);
  fMapInfo.DrawGoodsInfo[sb.Tag] := sb.Down;
  fMapInfo.update();
end;

procedure TMapViewer.onMITradeRouteAddCityClick(sender: TObject);
var
  city: integer;
begin
  city := TMenuItem(sender).Tag;
  doTradeRouteAddCity(city);
end;

procedure TMapViewer.onSelectedRoutePointIndexChanged(sender: TObject);
var
  idx: integer;
  n: PVirtualNode;
begin
  if frm.isInternalUpdating() then
    exit;

  if fSelectedShip = nil then
    exit;

  if fTradeRouteIndices.Count = 0 then
    exit;

  idx := fMapInfo.getSelectedRoutePointIndex();
  if (idx <= 0) or (idx > fTradeRouteIndices.Count) then
    exit;

  fSelectedTradeRoute := fTradeRouteIndices.getTR(idx);
  n := VTGetNodeByIndex(frm.Map_TradeRouteCityGrid, idx-1);
  if frm.Map_TradeRouteCityGrid.GetNodeUserData(n) <> fSelectedTradeRoute then
  begin
    dbgStr('error 1!');
    exit;
  end;
  frm.Map_TradeRouteCityGrid.ClearSelection();
  frm.Map_TradeRouteCityGrid.SelectNode(n);
  frm.Map_TradeRouteCityGrid.FocusedNode := n;
  if frm.Map_TradeRouteCityGrid.FocusedColumn < 0 then
    frm.Map_TradeRouteCityGrid.FocusedColumn := 0;
end;

procedure TMapViewer.pmTradeRouteCityGridPopup(Sender: TObject);
var
  cnt, city: integer;
  mi: TMenuItem;
begin
  frm.miMap_TRCityGrid_AddCity.Clear();

  if (fSelectedShip = nil) then
  begin
    frm.miMap_TRCityGrid_AddCity.Enabled := False;
    frm.miMap_TRCityGrid_RemoveCity.Enabled := False;
    exit;
  end;

  frm.miMap_TRCityGrid_RemoveCity.Enabled := frm.Map_TradeRouteCityGrid.SelectedCount > 0;

  if fTradeRouteIndices.Count >= 20 then
  begin
    frm.miMap_TRCityGrid_AddCity.Enabled := False;
    exit;
  end;
  

  cnt := 0;  

  for city := MIN_CITY_CODE to getCityCount()-1 do
  begin
    mi := TMenuItem.Create(frm.miMap_TRCityGrid_AddCity);
    mi.Caption := getCityName2(city);
    mi.OnClick := onMITradeRouteAddCityClick;
    mi.Tag := city;
    frm.miMap_TRCityGrid_AddCity.Add(mi);

    Inc(cnt);

    if cnt = 5 then
    begin
      mi := TMenuItem.Create(frm.miMap_TRCityGrid_AddCity);
      mi.Caption := Menus.cLineCaption;
      mi.Tag := -1;
      frm.miMap_TRCityGrid_AddCity.Add(mi);

      cnt := 0;
    end;
  end;
end;

procedure TMapViewer.pmTradeRouteGoodsGridPopup(Sender: TObject);
var
  hasSelected, hasRP: Boolean;
  pl: TPriceList;
  mi, miParent: TMenuItem;

  procedure createMItems(loadToSelected: boolean; pdt: TPriceDefType);
  var
    i: integer;
  begin
    mi := TMenuItem.Create(miParent);
    mi.Caption := '-';
    case pdt of
      PDT__B: mi.Hint := '买入价';
      PDT__S: mi.Hint := '卖出价';
    else
      mi.Hint := '其他';
    end;
    miParent.Add(mi);


    for I := 0 to fTempList_UsedForPriceList.Count - 1 do
    begin
      pl := TPriceList(fTempList_UsedForPriceList[I]);
      if pl.priceDefType <> pdt then
        Continue;
        
      mi := TMenuItem.Create(miParent);
      mi.Caption := pl.Name;
      mi.Tag := integer(pl);
      if loadToSelected then
        mi.OnClick := miMap_TRGoodsGrid_LoadPriceIntoSelected
      else
        mi.OnClick := miMap_TRGoodsGrid_LoadPriceIntoAll;

      miParent.Add(mi);
    end;
  end;

//  pm: TBcBarPopupMenu;
begin
  fTempList_UsedForPriceList.Clear();

  Conf.PriceDefs.getPriceListForTrade(fTempList_UsedForPriceList);

  hasSelected := frm.Map_TradeRouteGoodsGrid.SelectedCount > 0;
  hasRP := (fSelectedShip <> nil) and (fSelectedTradeRoute <> nil);

  if not hasSelected or not hasRP then
  begin
    frm.miMap_TRGoods_Buy.Enabled := False;
    frm.miMap_TRGoods_Sell.Enabled := False;
    frm.miMap_TRGoods_PutInto.Enabled := False;
    frm.miMap_TRGoods_GetOut.Enabled := False;
    frm.miMap_TRGoods_OpNONE.Enabled := False;

    frm.miMap_TRGoods_AllBuy.Enabled := False;
    frm.miMap_TRGoods_AllSell.Enabled := False;
    frm.miMap_TRGoods_AllPutInto.Enabled := False;
    frm.miMap_TRGoods_AllGetOut.Enabled := False;
    frm.miMap_TRGoods_AllNone.Enabled := False;
  end
  else
  begin
    frm.miMap_TRGoods_Buy.Enabled := True;
    frm.miMap_TRGoods_Sell.Enabled := True;
    frm.miMap_TRGoods_PutInto.Enabled := True;
    frm.miMap_TRGoods_GetOut.Enabled := True;
    frm.miMap_TRGoods_OpNONE.Enabled := True;

    frm.miMap_TRGoods_AllBuy.Enabled := True;
    frm.miMap_TRGoods_AllSell.Enabled := True;
    frm.miMap_TRGoods_AllPutInto.Enabled := True;
    frm.miMap_TRGoods_AllGetOut.Enabled := True;
    frm.miMap_TRGoods_AllNone.Enabled := True;
  end;

  miParent := frm.miMap_TRGoods_LoadPriceToSelected;
  miParent.Clear();


  if not hasSelected or not hasRP then
  begin
    miParent.Enabled := False;
  end
  else
  begin
    miParent.Enabled := True;
    createMItems(True, PDT__B);
    createMItems(True, PDT__S);
    createMItems(True, PDT__NONE);
  end;

  miParent := frm.miMap_TRGoods_LoadPriceToAll;
  miParent.Clear();

  if not hasSelected or not hasRP then
    miParent.Enabled := False
  else
  begin
    miParent.Enabled := True;
    createMItems(False, PDT__B);
    createMItems(False, PDT__S);
    createMItems(False, PDT__NONE);
  end;
end;

procedure TMapViewer.reloadShipGroupSelectGrid;
var
  pid: Integer;
  I: Integer;
  sgList, shipList: TList;
  sgInfo: PShipGroupInfo;
  ship: PP3R2Ship;
  sn, area: WideString;
  n: PVirtualNode;
begin
  pid := getCurrPlayerID();
  sgList := TList.Create();
  shipList := TList.Create();
  try
    getShipGroupList2(pid, sgList);

    for I := 0 to sgList.Count - 1 do
    begin
      sgInfo := sgList[I];
      ship := getShipByIndex(sgInfo.FirstShipIndex);
      shipList.Add(ship);
    end;

    sgList.Clear();
    getShipList(pid, sgList);

    for I := 0 to sgList.Count - 1 do
    begin
      ship := sgList[I];
      if ship.State
      in [SHIP_STATE__BUILDING, SHIP_STATE__SINKING, SHIP_STATE__PIRATE,
        SHIP_STATE__KILLED, SHIP_STATE__BATTLE, SHIP_STATE__REMOTE_TRADING] then
        Continue;

      if ship.GroupIndex <> $FFFF then
        Continue;

      shipList.Add(ship);
    end;

    frm.MapShipGroupSelectGrid.BeginUpdate();
    try
      frm.MapShipGroupSelectGrid.Clear();

      for I := 0 to shipList.Count - 1 do
      begin
        ship := shipList[i];
        sn := '';
        if fFilter_ShipName <> '' then
        begin
          sn := getShipName_R2(ship);
          if WidePos(fFilter_ShipName, sn) = 0 then
            Continue;
        end;

        if fFilter_Area <> '' then
        begin
          if sn = '' then
            sn := getShipName_R2(ship);

          area := getshipArea(ship, Conf.ShipNameSeperator);
          if area <> fFilter_Area then
            Continue;
        end;

        n := frm.MapShipGroupSelectGrid.AddChild(nil, ship);
        if ship = fSelectedShip then
          frm.MapShipGroupSelectGrid.SelectNode(n);
      end;
    finally
      frm.MapShipGroupSelectGrid.EndUpdate();
    end;
  finally
    sgList.Destroy();
    shipList.Destroy();
  end;
end;

function  TMapViewer.RoutePointMove(indexFrom, indexTo: integer; before: boolean): boolean;
var
  i, idx: integer;
  v: word;
  s: string;
  tr: PTradeRoute;
begin
  if before then
    s := 'before'
  else
    s := 'after';

//  dbgStr('RPMove from ' + IntToStr(indexFrom) + ' to ' + IntToStr(indexTo) + ', ' + s);

  Result := False;

  if fSelectedShip = nil then
    exit;

  if fTradeRouteIndices.Count = 0 then
    exit;

  if indexFrom = indexTo then
    exit;

  if (indexFrom <= 0) or (indexFrom > fTradeRouteIndices.Count) then
    exit;

  if (indexTo <= 0) or (indexTo > fTradeRouteIndices.Count) then
    exit;

  if before then
  begin
    if indexTo-1 = indexFrom then
      exit;
  end
  else
  begin
    if indexTo+1 = indexFrom then
      exit;
  end;

  v := fTradeRouteIndices.Indices[indexFrom];
//  trFrom := getTradeRoute(v);
//
//
//  if indexFrom = 1 then
//    trPrev := getTradeRoute(fTradeRouteIndices.Indices[fTradeRouteIndices.Count])
//  else
//    trPrev := getTradeRoute(fTradeRouteIndices.Indices[indexFrom-1]);

  if indexFrom < indexTo then
  begin
    if before then
    begin
      for I := indexFrom + 1 to indexTo-1 do
      begin
        fTradeRouteIndices.Indices[i-1] := fTradeRouteIndices.Indices[i];
      end;

      fTradeRouteIndices.Indices[indexTo-1] := v;
    end
    else
    begin
      for I := indexFrom + 1 to indexTo do
      begin
        fTradeRouteIndices.Indices[i-1] := fTradeRouteIndices.indices[i];
      end;

      fTradeRouteIndices.Indices[indexTo] := v;
    end;
  end
  else
  begin
    if before then
    begin
      for I := indexFrom - 1 downto indexTo do
      begin
        fTradeRouteIndices.Indices[i+1] := fTradeRouteIndices.Indices[i];
      end;

      fTradeRouteIndices.Indices[indexTo] := v;
    end
    else
    begin
      for I := IndexFrom - 1 downto indexTo + 1 do
      begin
        fTradeRouteIndices.Indices[i+1] := fTradeRouteIndices.Indices[i];
      end;

      fTradeRouteIndices.Indices[indexTo+1] := v;
    end;
  end;

  for I := 1 to fTradeRouteIndices.Count - 1 do
  begin
    idx := fTradeRouteIndices.Indices[I];
    tr := getTradeRoute(idx);
    idx := fTradeRouteIndices.Indices[I+1];
    tr.NextIndex := idx;
  end;

  idx := fTradeRouteIndices.Indices[fTradeRouteIndices.Count];
  tr := getTradeRoute(idx);
  idx := fTradeRouteIndices.Indices[1];
  tr^.NextIndex := idx;

//  dbgStr('Moved');
  Result := True;
end;

procedure TMapViewer.saveTradeRoutes(tr: TCustomTradeRoute);
var
  i, j, gid, cnt: integer;
  trIdx: Word;
//  indices: TTradeRouteIndices;
  tradeRoute: PTradeRoute;
  first: Boolean;
  trCity: TCustomTRCity;
  trOp: TCustomTROp;
  OpType: TTradeRouteOpType;
begin
  if fSelectedShip = nil then
  begin
    soundBeep();
    exit;
  end;

//  fTradeRouteIndices

  cnt := fTradeRouteIndices.Count;
//  indices.reorder();

  tr.clear();

  for I := 1 to cnt do
  begin
    trIdx := fTradeRouteIndices.getTRIndex(I);
    tradeRoute := getTradeRoute(trIdx);

    dbgStr('Save: ' + IntToStr(trIdx));

    if i = 1 then
    begin
      if not tradeRoute.isFirstFlagSet() then
      begin
        dbgStr('first is not set');
      end
      else
        dbgStr('first is set');

      if tradeRoute.isFirstFlagSet() then
        dbgStr('first is fix')
      else
        dbgStr('first is not fix');
    end;

    trCity := TCustomTRCity.Create();
    trCity.CityInternalCode := cityCodeToInternalCode(tradeRoute.CityCode);

    if tradeRoute.isFixFlagSet() then
      trCity.Option := CO__FIX
    else if tradeRoute.isNoStopFlagSet() then
      trCity.Option := CO__NO_STOP
    else
      trCity.Option := CO__NONE;

    tr.Items.Add(trCity);

    for gid := MIN_GOODS_ID to MAX_GOODS_ID do
    begin
      OpType := tradeRoute.getOpType(gid);

      trOp := TCustomTROp.Create();
      trOp.GoodsID := gid;
      trOp.OpType := OpType;
      trOp.Price := tradeRoute.getPrice(gid);
      trOp.Qty := traderoute.getMaxQty(gid);

      trCity.OpList.Add(trOp);
    end;      
  end;

  tr.Inserting := False;
end;

procedure TMapViewer.sbMap_SelectNextShipClick(Sender: TObject);
var
  n, next: PVirtualNode;
  ship: PP3R2Ship;
begin
  n := frm.MapShipGroupSelectGrid.SelectedNode;
  if (n = nil) or (frm.MapShipGroupSelectGrid.TotalCount = 1) then
  begin
    soundBeep();
    exit;
  end;

//  next :=

  ship := frm.MapShipGroupSelectGrid.GetNodeUserData(n);
  if ship <> fSelectedShip then
  begin
    soundBeep();
    exit;
  end;

  next := frm.MapShipGroupSelectGrid.GetNext(n);
  if next = nil then
    next := frm.MapShipGroupSelectGrid.GetFirst();

  n := next;

  ship := frm.MapShipGroupSelectGrid.GetNodeUserData(n);

  fSelectedShip := ship;                                      
  fSelectedShipIndex := indexOfShip(ship);

//  if fSelectedShip = nil then
//    dbgStr('selectShip = nil');
//  fSelectedTradeIndex := ;
  SelectedShipGroupChanged();

  frm.MapShipGroupSelectGrid.ClearSelection();
  frm.MapShipGroupSelectGrid.SelectNode(n);
  frm.MapShipGroupSelectGrid.ScrollIntoView(n, false);
  frm.MapShipGroupSelectGrid.FocusedNode := n;

  if frm.pcMapViewCtrl.ActivePage <> frm.tabMapCtrl_TradeRoute then
    frm.pcMapViewCtrl.ActivePage := frm.tabMapCtrl_TradeRoute;
end;

procedure TMapViewer.sbMap_SelectPrevShipClick(Sender: TObject);
var
  n, next: PVirtualNode;
  ship: PP3R2Ship;
begin
  n := frm.MapShipGroupSelectGrid.SelectedNode;
  if (n = nil) or (frm.MapShipGroupSelectGrid.TotalCount = 1) then
  begin
    soundBeep();
    exit;
  end;

  ship := frm.MapShipGroupSelectGrid.GetNodeUserData(n);
  if ship <> fSelectedShip then
  begin
    soundBeep();
    exit;
  end;

  next := frm.MapShipGroupSelectGrid.GetPrevious(n);
  if next = nil then
    next := frm.MapShipGroupSelectGrid.GetLast();

  n := next;

  ship := frm.MapShipGroupSelectGrid.GetNodeUserData(n);

  fSelectedShip := ship;
  fSelectedShipIndex := indexOfShip(ship);
  SelectedShipGroupChanged();

  frm.MapShipGroupSelectGrid.ClearSelection();
  frm.MapShipGroupSelectGrid.SelectNode(n);
  frm.MapShipGroupSelectGrid.ScrollIntoView(n, false);
  frm.MapShipGroupSelectGrid.FocusedNode := n;
  
  if frm.pcMapViewCtrl.ActivePage <> frm.tabMapCtrl_TradeRoute then
    frm.pcMapViewCtrl.ActivePage := frm.tabMapCtrl_TradeRoute;
end;

procedure TMapViewer.sbMap_ShowGoods_ClearClick(Sender: TObject);
var
  gid: integer;
begin
  for gid := MIN_GOODS_ID to MAX_GOODS_ID do
    fMapInfo.DrawGoodsInfo[gid] := False;

  fMapInfo.update();
end;

procedure TMapViewer.SelectedShipGroupChanged;
var
  I: integer;
  tradeRoute: PTradeRoute;
  N, SelectN: PVirtualNode;
begin
  if fSelectedShip = nil then
    frm.lblMap_SelectedShipName.Caption := ''
  else
    frm.lblMap_SelectedShipName.Caption := getShipName_R2(fSelectedShip);

  frm.beginInternalUpdate();
  try
    if fSelectedShip <> nil then
    begin
      frm.cbMap_SelectedShipGroupIsTrading.Checked := fSelectedShip.IsTrading <> 0;
      frm.cbMap_SelectedShipGroupIsTrading.Enabled := True;
    end
    else
      frm.cbMap_SelectedShipGroupIsTrading.Enabled := False;
  finally
    frm.endInternalUpdate();
  end;

  if fSelectedShip <> nil then
  begin
    tradeRoute_getIndices(fSelectedShip, fTradeRouteIndices);

    if fTradeRouteIndices.Count = 0 then
    begin
      fSelectedTradeIndex := $FFFF;
      fSelectedTradeRoute := nil;
      fRunningTradeRoute := nil;
      fMapInfo.resetTradeRouteDrawInfo();
    end
    else
    begin
      fSelectedTradeIndex := fTradeRouteIndices.firstShipIndex;
      fSelectedTradeRoute := getTradeRoute(fTradeRouteIndices.firstShipIndex);
      fRunningTradeRoute := getTradeRoute(fselectedship.TradingIndex);
      fMapInfo.setTradeRouteDrawInfo(fSelectedShip, fTradeRouteIndices);
    end;
  end
  else
  begin
    fSelectedTradeIndex := $FFFF;
    fSelectedTradeRoute := nil;
    fRunningTradeRoute := nil;
    fTradeRouteIndices.reset();
    fMapInfo.resetTradeRouteDrawInfo();
  end;

  SelectN := nil;


  frm.beginInternalUpdate();
  try
    frm.Map_TradeRouteCityGrid.BeginUpdate();
    try
      frm.Map_TradeRouteCityGrid.Clear();
    
      for I := 1 to fTradeRouteIndices.Count do
      begin
        tradeRoute := getTradeRoute(fTradeRouteIndices.Indices[I]);
        N := frm.Map_TradeRouteCityGrid.AddChild(nil, tradeRoute);
        if tradeRoute = fSelectedTradeRoute then
          SelectN := N;
      end;
    finally
      frm.Map_TradeRouteCityGrid.EndUpdate();
    end;
  finally
    frm.endInternalUpdate();
  end;

//  if fSelectedTradeRoute = nil then
//    dbgStr('selectedTradeRoute = nil')
//  else
//    dbgStr('selectedTradeRoute <> nil');

  if SelectN <> nil then
  begin
//    dbgStr('SelectN <> nil');
    frm.beginInternalUpdate();
    try
      frm.Map_TradeRouteCityGrid.ClearSelection();
      frm.Map_TradeRouteCityGrid.SelectNode(SelectN);
      frm.Map_TradeRouteCityGrid.FocusedNode := SelectN;
      if frm.Map_TradeRouteCityGrid.FocusedColumn = -1 then
        frm.Map_TradeRouteCityGrid.FocusedColumn := 0;
    finally
      frm.endInternalUpdate();
    end;
  end;
//  else
//    dbgStr('SelectN = nil');


  frm.Map_TradeRouteGoodsGrid.Invalidate();
end;

procedure TMapViewer.TRSetOp(gid: integer; op: TTradeRouteOpType; price,
  qty: integer);
begin
//  if (fSelectedShip = nil) or (fSelectedTradeRoute = nil) then
//    exit;

  case op of
    RT__UNSPECIFIED:
    begin
      fSelectedTradeRoute.setNoOp(gid);
    end;

    RT__SELL:
    begin
      fSelectedTradeRoute.setSell(gid, price, qty);
    end;

    RT__BUY:
      fSelectedTradeRoute.setBuy(gid, price, qty);

    RT__PUT_INTO:
      fSelectedTradeRoute.setPutInto(gid, qty);

    RT__GET_OUT:
      fSelectedTradeRoute.setGetOut(gid, qty);

  else
    fSelectedTradeRoute.setNoOp(gid);
  end;
end;

procedure TMapViewer.TRSetOpByNodes(nodes: TList; op: TTradeRouteOpType);
var
  n: PVirtualNode;
  grid: TVirtualStringTree;
  i, gid, qty, price: integer;
  ppl, spl: TPriceList;
begin
  if (fSelectedShip = nil) or (fSelectedTradeRoute = nil) then
    exit;

  if nodes.Count = 0 then
    exit;

  ppl := Conf.PriceDefs.getDefaultPPriceList();  
  spl := Conf.PriceDefs.getDefaultSPriceList();

  grid := frm.Map_TradeRouteGoodsGrid;

  for I := 0 to nodes.Count - 1 do
  begin
    n := nodes[i];
    gid := grid.GetNodeUserDataInt(n);
    
    price := fSelectedTradeRoute.getPrice(gid);
    qty := fSelectedTradeRoute.getMaxQty(gid);
    if qty = 0 then
      qty := getGoodsQtyFactor(gid);

    case op of
      RT__UNSPECIFIED:
      begin
        fSelectedTradeRoute.setNoOp(gid);
      end;

      RT__SELL:
      begin
        if spl <> nil then
          price := spl.get(gid)
        else if price = 0 then
          price := getGeneralGoodsProdCost(gid);

        fSelectedTradeRoute.setSell(gid, price, qty);
      end;

      RT__BUY:
      begin
        if ppl <> nil then
          price := ppl.get(gid)
        else if price = 0 then
          price := getGeneralGoodsProdCost(gid);

        fSelectedTradeRoute.setBuy(gid, price, qty);
      end;

      RT__PUT_INTO:
      begin
        fSelectedTradeRoute.setPutInto(gid, qty);
      end;

      RT__GET_OUT:
      begin
        fSelectedTradeRoute.setGetOut(gid, qty);
      end;
    end;
  end;

  grid.Invalidate();
end;

{ TGoodsImageProviderImpl }

constructor TGoodsImageProviderImpl.Create(frm: TfrmP3Insight);
begin
  Self.frm := frm;
end;

destructor TGoodsImageProviderImpl.Destroy;
var
  i: Integer;
begin
  for I := Low(bitmaps) to high(bitmaps) do
    bitmaps[I].Free();
    
  inherited;
end;

function TGoodsImageProviderImpl.get(const aGoodsID: Integer): HDC;
begin
  if not ready then
    prepare();

  Result := bitmaps[aGoodsID].Canvas.Handle;
end;

procedure TGoodsImageProviderImpl.prepare;
var
  i: integer;
  bm: TBitmap;
begin
  for I := MIN_GOODS_ID to MAX_GOODS_ID do
  begin
    bm := TBitmap.Create();
    frm.il20x20.GetBitmap(i-1, bm);
    bitmaps[i] := bm;
  end;

  ready := True;  
end;

function TGoodsImageProviderImpl.rect: TRect;
begin
  if not ready then
    prepare();

  Result.Left := 0;
  Result.Top := 0;
  Result.Right := bitmaps[min_goods_id].Width;
  Result.Bottom := bitmaps[min_goods_id].Height;
end;

{ TAreaViewer }

//function TAreaViewer.acceptPropSubView(aSubView: TPropSubViewType): Boolean;
//begin
//  Result := False;
//end;

procedure TAreaViewer.AreaSupplyGridGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  gid: integer;
begin
  if (kind <> ikNormal) and (Kind <> ikSelected) then
    exit;

  if Column < 0 then
    exit;

  if Column > 1 then
    exit;

  gid := Sender.GetNodeUserDataInt(Node);

  if Column = 0 then
    ImageIndex := gid-1
  else
  begin
    if isGoodsMeasuredInPkg(gid) then
      ImageIndex := IL20__PKG
    else
      ImageIndex := IL20__TONG;
  end;
end;

procedure TAreaViewer.AreaSupplyGridGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  q, gid, period: integer;
  nArea: PVirtualNode;
  data: pointer;
  gArea: TVirtualStringTree;
  supplyInfo: PBaseGoodsSupplyInfo;
  AreaImpl: TAreaImpl;
begin
  if Column < 0 then
    exit;

  gid := Sender.GetNodeUserDataInt(Node);

  if Column = 0 then
  begin
    CellText := getGoodsName(gid);
    exit;
  end
  else if Column = 1 then
    exit;

  gArea := frm.Config_AreaGrid;

  nArea := gArea.SelectedNode;
  if nArea = nil then
    exit;

  try

  data := gArea.GetNodeUserData(nArea);

  if data = nil then
  begin
    supplyInfo := frm.areaDataCache.getOtherCityGoodsSupplyInfo();
  end
  else if data = Self then
    supplyInfo := frm.areaDataCache.getAllCityGoodsSupplyInfo()
  else
  begin
    AreaImpl := TAreaImpl(data);
    if not AreaImpl.goodsSupplyInfoReady then
      frm.areaDataCache.summarize(AreaImpl);

    supplyInfo := @AreaImpl.goodsSupplyInfo;
  end;

  period := frm.seArea_CalcRemainPeriod.AsInteger;

  case Column of
    2: //store
    begin
      q := round(supplyInfo.getStore(gid));
      if q <> 0 then
        CellText := getGoodsDisplayQtyText(gid, q);
    end;

    3: //consume
    begin
      CellText := getGoodsDisplayQtyText(gid, round(supplyinfo.getConsume(gid) * period));
    end;

    4: //prod
    begin
      CellText := getGoodsDisplayQtyText(gid, round(supplyinfo.getProd(gid) * period));
    end;

    5: //remains
    begin
      CellText := getGoodsDisplayQtyText(gid, Round(supplyinfo.getRemain(period, gid, not frm.cbArea_ExclStoreWhenCalcRemains.Checked)));
    end;
  end;
  except
    CellText := 'Error';
  end;

//  dbgStr('<-AreaSupplyGridGetText');
end;


procedure TAreaViewer.cancelEdits;
begin
  frm.Config_AreaGrid.CancelEditNode();
  frm.Config_AreaCityGrid.CancelEditNode();
end;

procedure TAreaViewer.cbArea_ExclStoreWhenCalcRemainsClick(Sender: TObject);
begin
  frm.AreaSupplyGrid.Invalidate();
end;

procedure TAreaViewer.Config_AreaCityGridChecked(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  internalCode, cityCode: integer;
  city: TAreaCityImpl;
  cs: TCheckState;
  area: TAreaImpl;
  data: pointer;
begin
  if frm.isInternalUpdating() then
    exit;

  data := frm.Config_AreaGrid.GetNodeUserData(frm.Config_AreaGrid.SelectedNode);
  if data = Self then
    exit;

  area := TAreaImpl(data);
  
  internalCode := Sender.GetNodeUserDataInt(Node);
  cityCode := internalCityIDToCityCode(internalCode);
  if not isValidCity(cityCode) then
  begin
    soundBeep();
    exit;
  end;
  
  city := Conf.AreaDefList.getDefault().areaCityList.findByInternalCode(internalCode);
  if city = nil then
  begin
    soundBeep();
    exit;
  end;

  cs := Sender.CheckState[Node];

  if cs in [csCheckedNormal, csCheckedPressed] then
  begin
    city.attachArea(area);
  end
  else
  begin
    city.deattachArea();
  end;

  Conf.AreaDefList.setChanged(True);

  frm.areaDataCache.reset();

//  frm.updateUI();

  frm.Config_AreaCityGrid.InvalidateNode(Node);
  frm.Config_AreaGrid.Invalidate();
  frm.AreaSupplyGrid.Invalidate();
end;

procedure TAreaViewer.Config_AreaCityGridChecking(Sender: TBaseVirtualTree;
  Node: PVirtualNode; var NewState: TCheckState; var Allowed: Boolean);
var
  data: Pointer;
  area: TAreaImpl;
begin
  if frm.isInternalUpdating() then
  begin
    Allowed := True;
    exit;
  end;

  if (NewState = csUncheckedNormal) or (NewState = csUncheckedPressed) then
  begin
    data := frm.Config_AreaGrid.GetNodeUserData(frm.Config_AreaGrid.SelectedNode);
    if data = Self then
      Allowed := False
    else
    begin
      area := TAreaImpl(data);
      Allowed := area <> nil;
    end;
  end
  else
    Allowed := True;
end;

procedure TAreaViewer.Config_AreaCityGridGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  internalCode: integer;
  city: TAreaCityImpl;
begin
  internalCode := Sender.GetNodeUserDataInt(Node);

  case Column of
    0:
    begin
      city := Conf.AreaDefList.getDefault().areaCityList.findByInternalCode(internalCode);
      if city = nil then
        CellText := 'Error'
      else
      begin
        CellText := city.getCityName();
        if city.AreaImpl <> nil then
          CellText := CellText + ' (' + city.AreaImpl.Name + ')';
      end;
    end;
  end;
end;

procedure TAreaViewer.Config_AreaGridChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  I, internalCode: integer;
  n: PVirtualNode;
  area: TAreaImpl;
  city: TAreaCityImpl;
  g: TVirtualStringTree;
  data: Pointer;
begin
  g := frm.Config_AreaCityGrid;
  if Node = nil then
  begin
    g.Clear();
    frm.AreaSupplyGrid.Invalidate();
  end
  else
  begin
    data := Sender.GetNodeUserData(Node);
    if data = Self then
    begin
      frm.beginInternalUpdate();
      try
        g.BeginUpdate();
        try
          for i := MIN_CITY_CODE to getCityCount - 1 do
          begin
            internalCode := cityCodeToInternalCode(I);
            g.AddChild(nil, pointer(internalCode));
            //no check box
          end;
        finally
          g.EndUpdate();
        end; 
      finally
        frm.endInternalUpdate();
      end;

      frm.AreaSupplyGrid.Invalidate();
      exit;
    end;

    area := TAreaImpl(data);

    frm.beginInternalUpdate();
    try
      g.BeginUpdate();
      try
        g.Clear();

        for I := MIN_CITY_CODE to getCityCount()-1 do
        begin
          internalCode := cityCodeToInternalCode(I);
          city := conf.AreaDefList.getDefault().areaCityList.findByInternalCode(internalCode);
//          city := area.cityList.findByInternalCode(internalCode);
          n := g.AddChild(nil, pointer(internalCode));
          g.CheckType[n] := ctCheckBox;
          
          if city <> nil then
          begin
            if city.AreaImpl = area then
              g.CheckState[n] := csCheckedNormal
            else
              g.CheckState[n] := csUncheckedNormal;
          end
          else
            g.CheckState[n] := csUncheckedNormal;
        end;
      finally
        g.EndUpdate();
      end;
    finally
      frm.endInternalUpdate();
    end;

    frm.AreaSupplyGrid.Invalidate();
  end;
end;

procedure TAreaViewer.Config_AreaGridFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  frm.AreaSupplyGrid.Invalidate();
end;

procedure TAreaViewer.Config_AreaGridGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  area: TAreaImpl;

  function  countOthers(): Integer;
  var
    i, internalCode: integer;
    city: TAreaCityImpl;
    areaDef: TAreaDefImpl;
  begin
    areaDef := Conf.AreaDefList.getDefault();
    
    Result := 0;
    for i := MIN_CITY_CODE to getCityCount()-1 do
    begin
      internalCode := cityCodeToInternalCode(i);
      city := areaDef.areaCityList.findByInternalCode(internalCode);
      if city <> nil then
      begin
        if city.AreaImpl = nil then
          Inc(Result);
      end;
    end;      
  end;

var
  data: pointer;
begin
  data := Sender.GetNodeUserData(Node);
  if data = Self then
  begin
    case Column of
      0: CellText := '(全部)';
      1: CellText := IntToStr(getCityCount());
    end;
    Exit;
  end;

  area := TAreaImpl(data);

  case Column of
    0:
      if area <> nil then
        CellText := area.getName()
      else
        CellText := '(其他)';

    1:
    begin
      if area <> nil then
        CellText := IntToStr(area.cityList.getCount())
      else
        CellText := IntToStr(countOthers());
    end;
  end;
end;

constructor TAreaViewer.Create(aForm: TfrmP3Insight);
begin
  inherited;  
end;

procedure TAreaViewer.deactivate;
begin
  reset();
  {
  frm.Config_AreaGrid.Clear();
  frm.Config_AreaCityGrid.Clear();
  }
end;

destructor TAreaViewer.Destroy;
begin

  inherited;
end;

function TAreaViewer.getRecCount: Integer;
begin
  Result := -1;
end;

class function TAreaViewer.getViewerType: TViewerType;
begin
  Result := AREA_VIEWER;
end;

procedure TAreaViewer.init;
begin
  initGrid(frm.Config_AreaGrid);
  initGrid(frm.Config_AreaCityGrid);
  initGrid(frm.AreaSupplyGrid);

  frm.Config_AreaGrid.OnGetText :=
          Config_AreaGridGetText;
  frm.Config_AreaGrid.OnChange :=
          Config_AreaGridChange;
  frm.Config_AreaGrid.OnFocusChanged :=
          Config_AreaGridFocusChanged;

  frm.Config_AreaCityGrid.TreeOptions.MiscOptions :=
          frm.Config_AreaCityGrid.TreeOptions.MiscOptions + [toCheckSupport];
  frm.Config_AreaCityGrid.OnGetText :=
          Config_AreaCityGridGetText;
  frm.Config_AreaCityGrid.OnChecking := Config_AreaCityGridChecking;
  frm.Config_AreaCityGrid.OnChecked := Config_AreaCityGridChecked;

  frm.AreaSupplyGrid.OnGetText := AreaSupplyGridGetText;
  frm.AreaSupplyGrid.OnGetImageIndex := AreaSupplyGridGetImageIndex;
  frm.cbArea_ExclStoreWhenCalcRemains.OnClick := cbArea_ExclStoreWhenCalcRemainsClick;
  frm.seArea_CalcRemainPeriod.OnChange := seArea_CalcRemainPeriodChange;
end;

procedure TAreaViewer.internalPrepare;
var
  I: integer;
  area: TAreaImpl;
  areaDef: TAreaDefImpl;
begin
  frm.Config_AreaCityGrid.Clear();

  areaDef := Conf.AreaDefList.getDefault();

  areaDef.fillCityCodes();

  frm.Config_AreaGrid.BeginUpdate();
  try
    frm.Config_AreaGrid.Clear();

    for I := 0 to areaDef.getAreaCount() - 1 do
    begin
      area := areaDef.getArea(i);

      frm.Config_AreaGrid.AddChild(nil, area);
    end;

    frm.Config_AreaGrid.AddChild(nil, nil);
    frm.Config_AreaGrid.AddChild(nil, Self);
  finally
    frm.Config_AreaGrid.EndUpdate();
  end;

  frm.AreaSupplyGrid.BeginUpdate();
  try
    frm.AreaSupplyGrid.Clear();

    for I := MIN_GOODS_ID to MAX_GOODS_ID do
    begin
      frm.AreaSupplyGrid.AddChild(nil, pointer(i));
    end;
  finally
    frm.AreaSupplyGrid.EndUpdate();
  end;
end;

procedure TAreaViewer.internalReset;
begin
  frm.Config_AreaCityGrid.Clear();
  frm.Config_AreaGrid.Clear();
end;

procedure TAreaViewer.internalUpdate;
begin
  frm.Config_AreaGrid.Invalidate();
  frm.Config_AreaCityGrid.Invalidate();
end;

procedure TAreaViewer.seArea_CalcRemainPeriodChange(Sender: TObject);
begin
  frm.AreaSupplyGrid.Invalidate();
end;

{ TShipListNode }

procedure TShipListNode.setup(nt: integer; aObj: Pointer);
begin
  NodeType := nt;
  Obj := aObj;
end;

{ TTradeRouteSelectClientImpl_Load }

constructor TTradeRouteSelectClientImpl_Load.Create(
  mapViewer: TMapViewer);
begin
  Self.mapViewer := mapViewer;
end;

function TTradeRouteSelectClientImpl_Load.getCallerRect: TRect;
begin
  Result := frmP3Insight.Map_TradeRouteCityGrid.BoundsRect;
  Result.TopLeft := frmP3Insight.Map_TradeRouteCityGrid.ClientToScreen(Result.TopLeft);
  Result.BottomRight := frmP3Insight.Map_TradeRouteCityGrid.ClientToScreen(Result.BottomRight);
end;

function TTradeRouteSelectClientImpl_Load.isLoad: Boolean;
begin
  Result := True;
end;

procedure TTradeRouteSelectClientImpl_Load.onCancel;
begin
  //nop
end;

procedure TTradeRouteSelectClientImpl_Load.onOk(aSelected: TCustomTradeRoute);
begin
  mapViewer.loadTradeRoutes(aSelected);
end;

{ TTradeRouteSelectClientImpl_Save }

constructor TTradeRouteSelectClientImpl_Save.Create(mapViewer: TMapViewer);
begin
  Self.mapViewer := mapViewer;
end;

function TTradeRouteSelectClientImpl_Save.getCallerRect: TRect;
begin
  Result := frmP3Insight.Map_TradeRouteCityGrid.BoundsRect;
  
  Result.TopLeft := frmP3Insight.Map_TradeRouteCityGrid.ClientToScreen(Result.TopLeft);
  Result.BottomRight := frmP3Insight.Map_TradeRouteCityGrid.ClientToScreen(Result.BottomRight);
end;

function TTradeRouteSelectClientImpl_Save.isLoad: Boolean;
begin
  Result := False;
end;

procedure TTradeRouteSelectClientImpl_Save.onCancel;
begin
  //nop
end;

procedure TTradeRouteSelectClientImpl_Save.onOk(aSelected: TCustomTradeRoute);
begin
  mapViewer.saveTradeRoutes(aSelected);
end;

end.
