unit edForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ActnList, ComCtrls, BMSearch, p3DataStruct,
  Contnrs, VirtualTrees, MyGameTools, AxGameHackToolBox, Buttons, Tabs, Menus,
  JclExprEval, ImgList, OmniXML, MyOmniXMLHelper;

const
  UM_CLOSE = WM_USER + 100;
  UM_CLOSE_SWITCH_TO_GAME = WM_USER + 101;
  UM_DO_REFRESH = WM_USER + 102;
  UM_SET_FOCUS = WM_USER + 103;
  UM_SHOW_CURSOR = WM_USER + 104;
  UM_GOTO_MEM_PTR = WM_USER + 105; //LPARAM AS OFFSET

type
  TP3EditorIntf = class
  public
    IN_ParentFormHandle: THandle;

    class procedure directExec(const aIN_ParentFormHandle: THandle);
    static;

    procedure exec();
  end;

  TSearchDataType = (
    DT_BYTE,
    DT_WORD,
    DT_DWORD,
    DT_TEXT
  );

//  TGoods = record
//    ID: Integer;
//    ship: PP3Ship;
//  end;
//  PGoods = ^TGoods;

//  TShipObj = class
//  public
//    MemPage: TMemPage;
//    shipCopy: TP3ShipCopy;
//    orgShipPtr: PP3Ship;
//    Locked: Boolean;
//    procedure copyShip();
//    function  validateMem(): Boolean;
//  end;

  TfrmP3Editor = class(TForm)
    ActionList1: TActionList;
    acSearch: TAction;
    pmShipGrid: TPopupMenu;
    miCheckAll: TMenuItem;
    miToggleChecked: TMenuItem;
    miClearChecked: TMenuItem;
    Timer1: TTimer;
    ImageList1: TImageList;
    pcMain: TPageControl;
    TabSheet4: TTabSheet;
    Panel3: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    GoodsGrid: TVirtualStringTree;
    Panel5: TPanel;
    Label16: TLabel;
    Label18: TLabel;
    btnSetAllGoodsQtyTo: TButton;
    btnSetSelectedGoodsQtyTo: TButton;
    btnSetGoodsDirect: TButton;
    btnClearAllGoods: TButton;
    btnSetBuildingMaterialQtyTo: TButton;
    btnSetFoodsQtyTo: TButton;
    edGoodsQty: TEdit;
    gbCityWeapon: TGroupBox;
    Label17: TLabel;
    lblCW1: TLabel;
    Label19: TLabel;
    lblCW2: TLabel;
    Label21: TLabel;
    lblCW3: TLabel;
    Label23: TLabel;
    lblCW4: TLabel;
    Bevel6: TBevel;
    btnFillCityWeapon: TButton;
    btnClearCityWeapon: TButton;
    edTotalLoad: TEdit;
    btnSetTotalLoad: TButton;
    TabSheet3: TTabSheet;
    MemGrid: TVirtualStringTree;
    memValue: TStatusBar;
    TabSheet2: TTabSheet;
    Panel8: TPanel;
    GroupBox3: TGroupBox;
    edCalcExpr: TEdit;
    btnCalc: TButton;
    btnIntToHex: TButton;
    btnHexToInt: TButton;
    edCalcResult: TEdit;
    Note: TMemo;
    Panel4: TPanel;
    Bevel7: TBevel;
    Bevel5: TBevel;
    Bevel4: TBevel;
    Bevel2: TBevel;
    Label1: TLabel;
    Label3: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    lblFrom: TLabel;
    Label13: TLabel;
    lblCurrPlace: TLabel;
    Label15: TLabel;
    lblTo: TLabel;
    lblUnit: TLabel;
    Label12: TLabel;
    lblShiQi: TLabel;
    lblShipWeapon: TLabel;
    Label14: TLabel;
    lblPower: TLabel;
    Bevel3: TBevel;
    Image1: TImage;
    Image2: TImage;
    btnSetLoad: TButton;
    btnMaxStrong: TButton;
    btnSetCaptain: TButton;
    btnFullCannons: TButton;
    btnState0: TButton;
    btnSetShuiShou: TButton;
    edState: TEdit;
    edShuiShou: TEdit;
    edLoadLimit: TEdit;
    btnMaxLoad: TButton;
    btnMaxShiQi: TButton;
    btnMaxShipWeapon: TButton;
    cbCaptain: TComboBox;
    btnFavCaptain: TButton;
    edShipName: TEdit;
    btnSetShipName: TButton;
    btnSetShipNameToOthers: TButton;
    cbShipType: TComboBox;
    cbShipLevel: TComboBox;
    btnSetShipClass: TButton;
    Panel2: TPanel;
    Panel6: TPanel;
    ShipGrid: TVirtualStringTree;
    Panel7: TPanel;
    btnFillAll: TButton;
    btnFillSelected: TButton;
    GroupBox2: TGroupBox;
    cbEnsureShuiShou: TCheckBox;
    cbEnsureMaxPower: TCheckBox;
    cbEnsureGoodsFull: TCheckBox;
    edEnsureShuiShou: TEdit;
    cbEnsureShiQiFull: TCheckBox;
    cbEnsurePointFull: TCheckBox;
    btnLockSelected: TButton;
    TabControl1: TTabControl;
    Panel1: TPanel;
    btnRefresh: TBitBtn;
    btnHide: TBitBtn;
    TabSheet5: TTabSheet;
    Panel9: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    MemInspectGrid: TVirtualStringTree;
    Label22: TLabel;
    ListBox1: TListBox;
    edAddrNote: TEdit;
    btnAddBookmark: TButton;
    btnRemoveBookmark: TButton;
    Label24: TLabel;
    lblCurrPageBase: TLabel;
    btnGotoCurrBookmark: TButton;
    pmShipMemGrid: TPopupMenu;
    miShipMemGridGotoAddress: TMenuItem;
    rbShowBMAddrAsOffset: TRadioButton;
    rbShowBMAddrAbsolute: TRadioButton;
    Label25: TLabel;
    lblCurrPageSize: TLabel;
    GroupBox4: TGroupBox;
    rbSignaled: TRadioButton;
    rbUnsignaled: TRadioButton;
    Label26: TLabel;
    edMemInspValue_B: TEdit;
    Label27: TLabel;
    edMemInspValue_W: TEdit;
    Label28: TLabel;
    edMemInspValue_D: TEdit;
    Label29: TLabel;
    edMemInspValue_Q: TEdit;
    Label30: TLabel;
    edMemInspValue_Single: TEdit;
    Label31: TLabel;
    edMemInspValue_Double: TEdit;
    edMemInspValueAsText: TEdit;
    pmMemInsp: TPopupMenu;
    Label32: TLabel;
    miMemInspGotoAddr: TMenuItem;
    Label20: TLabel;
    edMemInspGotoTargetAddr: TEdit;
    GroupBox5: TGroupBox;
    Label33: TLabel;
    btnMemInspSearch: TButton;
    btnMemInspRset: TButton;
    edMemInspSearchTarget: TEdit;
    rgMemInspSearchDataType: TRadioGroup;
    Button2: TButton;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    btnHide2: TBitBtn;
    TabSheet6: TTabSheet;
    Panel13: TPanel;
    cbCity: TComboBox;
    PageControl2: TPageControl;
    TabSheet7: TTabSheet;
    TabSheet8: TTabSheet;
    btnGotoHomeCity: TButton;
    Panel14: TPanel;
    CityStoreGrid: TVirtualStringTree;
    Panel15: TPanel;
    Panel16: TPanel;
    Panel17: TPanel;
    PopGrid: TVirtualStringTree;
    lblPopTotal: TLabel;
    lblHomeCity: TLabel;
    Panel18: TPanel;
    CityMemGrid: TVirtualStringTree;
    btnCityAddQiGai: TButton;
    btnHide3: TBitBtn;
    rgCityAddrDelta: TRadioGroup;
    Panel19: TPanel;
    Panel20: TPanel;
    SoldierGrid: TVirtualStringTree;
    lblSoldierTotal: TLabel;
    btnTest: TButton;
    lblTestResult: TLabel;
    cbPlayer: TComboBox;
    edPlayerMoney: TEdit;
    btnSetPlayerMoney: TButton;
    btnPlayerMoneyX100: TButton;
    btnPlayerMoneyX1000: TButton;
    btnDecCityStore: TButton;
    btnClearCityGoods: TButton;
    Label34: TLabel;
    lblGameDate: TLabel;
    ListBox2: TListBox;
    rgShiftBits: TRadioGroup;
    btnShl: TButton;
    edPlayerPtr: TEdit;
    btnCalcF1: TButton;
    rgF1Delta: TRadioGroup;
    btnF2: TButton;
    edGameDataAddr: TEdit;
    Label35: TLabel;
    edShengWang1: TEdit;
    Label36: TLabel;
    edShengWang2: TEdit;
    Label37: TLabel;
    edShengWang3: TEdit;
    btnSetShengWang: TButton;
    Label38: TLabel;
    lblPlayerID: TLabel;
    lblPlayerName: TLabel;
    Label39: TLabel;
    edShengWang4: TEdit;
    Label40: TLabel;
    Label41: TLabel;
    edPlayer_15: TEdit;
    edPlayer_1B: TEdit;
    lblBirthday: TLabel;
    edBirthday: TEdit;
    btnAnchor: TButton;
    btnRemoveAnchor: TButton;
    edGotoOffset: TEdit;
    btnGotoOffsetToCurrSelect: TButton;
    btnGotoOfsToAnchor: TButton;
    Bevel8: TBevel;
    btnSetPlayerExtraInfo: TButton;
    edShengWang5: TEdit;
    Label42: TLabel;
    cbDumpSize: TComboBox;
    Label43: TLabel;
    Label44: TLabel;
    btnDumpFromCurrPos: TButton;
    rgSearchCodePage: TRadioGroup;
    Label6: TLabel;
    lblViewPortCityCode: TLabel;
    Label10: TLabel;
    lblPlayerClass: TLabel;
    rgConvertDWSingle1: TRadioGroup;
    Label46: TLabel;
    edPlayer_464: TEdit;
    btnSetPlayer_464: TButton;
    Label47: TLabel;
    lblBusinessOfficePtr: TLabel;
    Label48: TLabel;
    TabSheet9: TTabSheet;
    Panel21: TPanel;
    pnlBusinessHeader: TPanel;
    BusinessOfficeGrid: TVirtualStringTree;
    edBusinessOfsPtr: TEdit;
    BitBtn1: TBitBtn;
    lblMemInspCurrPosOfs: TLabel;
    lblMemInspCurrPosAddr: TLabel;
    TabSheet10: TTabSheet;
    memTradeRoute: TMemo;
    Label49: TLabel;
    btnDump: TButton;
    TabSheet11: TTabSheet;
    BuildingGrid: TVirtualStringTree;
    TabSheet12: TTabSheet;
    PaintBox1: TPaintBox;
    btnDraw: TButton;
    memMapData: TMemo;
    Label50: TLabel;
    edCityTreasury: TEdit;
    edTestInput: TEdit;
    memTestResult: TMemo;
    edPlayer_2C6: TEdit;
    btnSetPlayer_2C6: TButton;
    btnTest2: TButton;
    Label51: TLabel;
    edShipPosX: TEdit;
    Label52: TLabel;
    edShipPosY: TEdit;
    Label45: TLabel;
    Label53: TLabel;
    lblCityX: TLabel;
    lblCityY: TLabel;
    btnKillProcess: TButton;
    Label54: TLabel;
    lblGameTime1: TLabel;
    Label55: TLabel;
    lblGameTime2: TLabel;
    btnSetDest: TButton;
    btnDumpAllCityPos: TButton;
    cbFastForward: TCheckBox;
    GroupBox1: TGroupBox;
    Label56: TLabel;
    Label58: TLabel;
    edPtrOfCaptain: TEdit;
    lblGroupFirstShipIndex: TLabel;
    Label57: TLabel;
    lblShipGroupIndex: TLabel;
    Label59: TLabel;
    GroupBox6: TGroupBox;
    Label60: TLabel;
    Label61: TLabel;
    lblBuildShipResult: TLabel;
    cbBuildTypeA1: TComboBox;
    cbBuildShipType: TComboBox;
    btnBuildShip: TButton;
    edShipCurrPoint: TEdit;
    edShipMaxPoint: TEdit;
    btnAutoFillCaptain: TButton;
    lblIsInSeaView: TLabel;
    btnTestSetShipDest: TButton;
    Label62: TLabel;
    lblShipIndex3C: TLabel;
    Label63: TLabel;
    lblShipGroupInfoPtr: TLabel;
    memCity: TMemo;
    edCityPtr: TEdit;
    Label64: TLabel;
    lblStoreHouseMaxCap: TLabel;
    edCaptainBirthday: TEdit;
    btnSetCaptainBirthday: TButton;
    Panel22: TPanel;
    BusinessOfficeG2: TVirtualStringTree;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSetLoadClick(Sender: TObject);
    procedure btnMaxStrongClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnFullCannonsClick(Sender: TObject);
    procedure btnState0Click(Sender: TObject);
    procedure btnSetShuiShouClick(Sender: TObject);
    procedure GoodsGridGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure btnSetGoodsDirectClick(Sender: TObject);
    procedure btnSetSelectedGoodsQtyToClick(Sender: TObject);
    procedure btnSetAllGoodsQtyToClick(Sender: TObject);
    procedure btnSetAddrRangeClick(Sender: TObject);
    procedure btnBackToGameClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ShipGridGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure ShipGridChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure MemGridGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure MemGridPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
    procedure MemGridFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex);
    procedure MemGridChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure memValueDblClick(Sender: TObject);
    procedure MemGridBeforeCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellRect: TRect);
    procedure MemGridGetSelectionBkColor(aSender: TBaseVirtualTree;
      aNode: PVirtualNode; const aColumn: Integer; const aFocused: Boolean;
      var aColor: TColor);
    procedure btnClearCacheClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ShipGridPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
    procedure btnMaxLoadClick(Sender: TObject);
    procedure btnMaxShiQiClick(Sender: TObject);
    procedure btnMaxShipWeaponClick(Sender: TObject);
    procedure btnClearAllGoodsClick(Sender: TObject);
    procedure btnFillAllClick(Sender: TObject);
    procedure btnFillGoodsClick(Sender: TObject);
    procedure btnFavCaptainClick(Sender: TObject);
    procedure btnSetCaptainClick(Sender: TObject);
    procedure btnFillSelectedClick(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnHideClick(Sender: TObject);
    procedure btnSetShipNameClick(Sender: TObject);
    procedure btnSetShipNameToOthersClick(Sender: TObject);
    procedure btnSetFoodsQtyToClick(Sender: TObject);
    procedure miCheckAllClick(Sender: TObject);
    procedure miToggleCheckedClick(Sender: TObject);
    procedure miClearCheckedClick(Sender: TObject);
    procedure btnFillCityWeaponClick(Sender: TObject);
    procedure btnCalcClick(Sender: TObject);
    procedure NoteChange(Sender: TObject);
    procedure btnIntToHexClick(Sender: TObject);
    procedure btnHexToIntClick(Sender: TObject);
    procedure btnSetTotalLoadClick(Sender: TObject);
    procedure btnSetShipClassClick(Sender: TObject);
    procedure btnLockSelectedClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ShipGridGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure TabControl1Change(Sender: TObject);
    procedure btnClearCityWeaponClick(Sender: TObject);
    procedure miShipMemGridGotoAddressClick(Sender: TObject);
    procedure MemInspectGridGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure MemInspectGridGetHighlightTextColor(aSender: TBaseVirtualTree;
      aNode: PVirtualNode; const aStaticText: Boolean; const aColumn: Integer;
      var aColor: TColor);
    procedure MemInspectGridGetSelectionBkColor(aSender: TBaseVirtualTree;
      aNode: PVirtualNode; const aColumn: Integer; const aFocused: Boolean;
      var aColor: TColor);
    procedure MemInspectGridPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
    procedure MemInspectGridChange(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure MemInspectGridFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure btnMemInspGotoAddrClick(Sender: TObject);
    procedure miMemInspGotoAddrClick(Sender: TObject);
    procedure btnMemInspSearchClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure MemInspectGridAcceptNewText(aSender: TBaseVirtualTree;
      const aEditorWndHandle: Cardinal; aNode: PVirtualNode;
      const aColumn: TColumnIndex; aNewText: WideString; var aAccept: Boolean;
      var aErrHintTitle, aErrHintMsg: WideString);
    procedure PopGridGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure CityStoreGridGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure PopGridAcceptNewText(aSender: TBaseVirtualTree;
      const aEditorWndHandle: Cardinal; aNode: PVirtualNode;
      const aColumn: TColumnIndex; aNewText: WideString; var aAccept: Boolean;
      var aErrHintTitle, aErrHintMsg: WideString);
    procedure CityStoreGridAcceptNewText(aSender: TBaseVirtualTree;
      const aEditorWndHandle: Cardinal; aNode: PVirtualNode;
      const aColumn: TColumnIndex; aNewText: WideString; var aAccept: Boolean;
      var aErrHintTitle, aErrHintMsg: WideString);
    procedure btnCityAddQiGaiClick(Sender: TObject);
    procedure cbCityChange(Sender: TObject);
    procedure rbSignaledClick(Sender: TObject);
    procedure rbUnsignaledClick(Sender: TObject);
    procedure CityStoreGridEditing(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var Allowed: Boolean);
    procedure CityStoreGridDblClick(Sender: TObject);
    procedure SoldierGridGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure SoldierGridEditing(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var Allowed: Boolean);
    procedure SoldierGridAcceptNewText(aSender: TBaseVirtualTree;
      const aEditorWndHandle: Cardinal; aNode: PVirtualNode;
      const aColumn: TColumnIndex; aNewText: WideString; var aAccept: Boolean;
      var aErrHintTitle, aErrHintMsg: WideString);
    procedure btnTestClick(Sender: TObject);
    procedure SoldierGridDblClick(Sender: TObject);
    procedure cbPlayerChange(Sender: TObject);
    procedure btnPlayerMoneyX100Click(Sender: TObject);
    procedure btnSetPlayerMoneyClick(Sender: TObject);
    procedure btnPlayerMoneyX1000Click(Sender: TObject);
    procedure btnDecCityStoreClick(Sender: TObject);
    procedure btnClearCityGoodsClick(Sender: TObject);
    procedure ListBox2DblClick(Sender: TObject);
    procedure btnShlClick(Sender: TObject);
    procedure btnCalcF1Click(Sender: TObject);
    procedure btnF2Click(Sender: TObject);
    procedure btnSetShengWangClick(Sender: TObject);
    procedure btnGotoHomeCityClick(Sender: TObject);
    procedure btnAnchorClick(Sender: TObject);
    procedure btnRemoveAnchorClick(Sender: TObject);
    procedure btnGotoOffsetToCurrSelectClick(Sender: TObject);
    procedure btnGotoOfsToAnchorClick(Sender: TObject);
    procedure btnSetPlayerExtraInfoClick(Sender: TObject);
    procedure btnDumpFromCurrPosClick(Sender: TObject);
    procedure btnMemInspRsetClick(Sender: TObject);
    procedure btnSetPlayer46cClick(Sender: TObject);
    procedure rgConvertDWSingle1Click(Sender: TObject);
    procedure BusinessOfficeGridGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure BusinessOfficeG2GetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure btnDumpClick(Sender: TObject);
    procedure BuildingGridGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure PaintBox1Paint(Sender: TObject);
    procedure btnDrawClick(Sender: TObject);
    procedure btnTest2Click(Sender: TObject);
    procedure btnKillProcessClick(Sender: TObject);
    procedure btnSetDestClick(Sender: TObject);
    procedure btnDumpAllCityPosClick(Sender: TObject);
    procedure cbFastForwardClick(Sender: TObject);
    procedure ShipGridCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure ShipGridHeaderClick(Sender: TVTHeader; Column: TColumnIndex;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure btnBuildShipClick(Sender: TObject);
    procedure btnAutoFillCaptainClick(Sender: TObject);
    procedure btnTestSetShipDestClick(Sender: TObject);
    procedure btnSetCaptainBirthdayClick(Sender: TObject);
  private
    { Private declarations }
    fIntf: TP3EditorIntf;

    fShipList_R2: TList;
//    fOrgShipPtrList: TList;
    fCurrShip: PP3R2Ship;
    fDoClose, fNoteChanged, fDestroying: Boolean;
//    fMemPageList: TObjectList;

//    fHotMemPageList: TList;
    fNonSignaled, fInited: Boolean;
    fEvaluator: TEvaluator;
    fLockedShipName: string;
    fLockedShip: PP3R2Ship;

    fCurrPageMP: TMemPage;
    fCurrSearchDataType: TSearchDataType;
    fSearchStarted: Boolean;
    fSearchHeapOnly, fSearchDataPageOnly: Boolean;
    fSearchResult: TList;
    fSearchTargetS: string;
    fSearchTargetB: Byte;
    fSearchTargetDWORD: DWORD;
    fCityList: PCityList;
    fHomeCity: Byte;
    fCurrCity: PCityStruct;
    fAnchor: Pointer;
    fBusinessOffice: PBusinessOffice;
    fDrawing: Boolean;

    fMap: TBitmap;
    finternalUpdating: integer;

    procedure internalSetShipName(S: string);
    procedure cityWeaponChanged();
    procedure shipWeaponChanged();
    procedure totalLoadChanged();
    procedure shiQiChanged();
    procedure doRefreshSearchResult();
    procedure maxLoadChanged();
    procedure captainChanged();
    procedure shipClassChanged();
    procedure updateMemContent();
    function  getColor(off: Integer): TColor;
    function  getMemRowOffset(ship: PP3R2Ship; const row: Integer): Integer;
    function  getMemOffset(ship: PP3R2Ship; const row, col: Integer): Integer;
    procedure errBox(const aMsg: WideString);
    procedure errMemFreed();
    procedure intStrErr();

    function  getShipMemGridSelectedLongword(): Cardinal;
    procedure clearShipListView();
    procedure loadShipsIntoGrid();

//    procedure checkShipName(mp: TMemPage; p: Pointer);
    procedure updateShipInfo();
    procedure updateMemInspValues();

    procedure memInspectorUpdateCurrPage(aMP: TMemPage);

    function  getSelectedPlayerID(): Byte;

    function  memInspHasSelectedPtr(): Boolean;
    function  memInspGetSelectedPtr(): Pointer;

    procedure setSelectedGoodsQty(const factor: Integer);
    procedure OnUM_CLOSE(var aMsg: TMessage); message UM_CLOSE;
    procedure OnUM_CLOSE_SWITCH_TO_GAME(var aMsg: TMessage); message UM_CLOSE_SWITCH_TO_GAME;
    procedure OnUM_DO_REFRESH(var aMsg: TMessage); message UM_DO_REFRESH;
    procedure OnUM_SET_FOCUS(var aMsg: TMessage); message UM_SET_FOCUS;
    procedure OnUM_SHOW_CURSOR(var aMsg: TMessage); message UM_SHOW_CURSOR;
    function  getMemInspaceGridOff(const aRow: Integer; const aColumn: Integer): Integer;  overload;
    function  getMemInspaceGridOff(const N: PVirtualNode; const aColumn: Integer): Integer; overload;
    procedure OnUM_GOTO_MEM_PTR(var aMsg: TMessage); message UM_GOTO_MEM_PTR;
    procedure DoRefreshCityPage();
    procedure updateCityPopTotal();
    procedure updateSoldierTotal();
    procedure updatePlayerMoney();
    procedure updateGameDate();
    procedure updateShengWang();
    procedure initBusinessOfficeGrid();
    procedure updateBusinessOffice();
    procedure routeInfoChanged();
    procedure updateBuildingGrid();
    procedure updateCityTreasury();
    procedure updateCityMemo();
  protected
    procedure WndProc(var Message: TMessage); override;
    procedure CreateParams(var aParams: TCreateParams); override;
  public
    { Public declarations }
    constructor Create(aIntf: TP3EditorIntf); reintroduce;
    destructor Destroy; override;

    procedure doCloseModal();
  end;



var
  frmP3Editor: TfrmP3Editor;
  NoteFileName: WideString;
  SetFocusMsgID: UINT;
  DoSendKey: Boolean;
//  EditorVisible: Boolean;

implementation

uses confDlg, MP, Math, CommonUtils, p3insight_utils;

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

procedure GridToggleSortDirection(G: TVirtualStringTree);
begin
  if G.Header.SortDirection = sdAscending then
    G.Header.SortDirection := sdDescending
  else
    G.Header.SortDirection := sdAscending;
end;


procedure GridHandleHeaderClickSort(G: TVirtualStringTree; Column: TColumnIndex);
begin
  if Column <> G.Header.SortColumn then
  begin
    G.Header.SortColumn := Column;
    G.Header.SortDirection := sdAscending;
  end
  else
    GridToggleSortDirection(G);

  G.SortTree(G.Header.SortColumn, G.Header.SortDirection, True);
end;

procedure GridApplySort(G: TVirtualStringTree);
begin
  if G.Header.SortColumn >= 0 then
    G.SortTree(G.Header.SortColumn, G.Header.SortDirection, True);
end;



procedure saveBytes(p: PByte; size: Integer);
var
  I, j: Integer;
  ln: string;
  fn: WideString;
  sl: TStringList;
begin
  fn := ExtractFilePath(ParamStr(0)) + IntToHex(integer(p), 8) + '.txt';
  ln := '';

  i := integer(p);
  j := not $03;
  i := i and j;

  size := size + (i - integer(p));
  p := pointer(i);
  
  
  

  sl := TStringList.Create();
  try
    j := 0;
    for I := 0 to size - 1 do
    begin
      if ln = '' then
      begin
        ln := '$' + IntToHex(integer(p), 8) + '   ';
      end;
      ln := ln + IntToHex(p^, 2) + ' ';
      Inc(p);
      Inc(j);
      if (i= 4) then
        ln := ln + ' '
      else if j = 8 then
        ln := ln + '  ';
      if j = 16 then
      begin
        sl.Add(ln);
        ln := '';
        j := 0;
      end;
    end;

    sl.SaveToFile(fn);
  finally
    sl.Destroy();
  end;
end;



//const
//  ADDR_HI = $7FFEFFFF;

//{$DEFINE VQ}

{$R *.dfm}

function  shipObjSortCompare(a, b: Pointer): Integer;
var
  x, y: PP3R2Ship;
  s1, s2: string;
begin
  x := PP3R2Ship(a);
  y := PP3R2Ship(b);
  s1 := getShipName_R2(x);
  s2 := getShipName_R2(y);

  Result := CompareStr(s1, s2);
end;

{ TfrmP3Editor }

procedure TfrmP3Editor.btnAnchorClick(Sender: TObject);
var
  ptr: Pointer;
begin
  if fCurrPageMP = nil then
    Exit;

  if (MemInspectGrid.SelectedNode = nil) or (MemInspectGrid.FocusedColumn < 0) then
    Exit;

  ptr := pointer(getMemInspaceGridOff(MemInspectGrid.SelectedNode, MemInspectGrid.FocusedColumn));
  fAnchor := ptr;
  MemInspectGrid.Invalidate();
end;

function  shipListFilter_autoFillCaptain(ship: PP3R2Ship; data: Pointer): Boolean;
begin
  if (ship^.State = SHIP_STATE__KILLED)
  or (ship^.State = SHIP_STATE__BUILDING)
  or (ship^.State = SHIP_STATE__SINKING) then
    Result := False
  else
    Result := True;
end;

procedure TfrmP3Editor.btnAutoFillCaptainClick(Sender: TObject);
var
  i: integer;
  list, captainIDList: TList;
  captain, captainCnt: Word;
  ship: PP3R2Ship;

//  function  isCaptainUsed(captain: word): boolean;
//  begin
//    Result := captainIDList.IndexOf(pointer(captain)) >= 0;
//  end;

  procedure addUsedCaptain(captain: Word);
  begin
    captainIDList.Remove(pointer(captain));
  end;
    
begin
  captainCnt := getAllocatedCaptainCount();
  
  list := TList.Create();
  captainIDList := TList.Create();
  try
    for I := 0 to captainCnt - 1 do
    begin
      captainIDList.Add(pointer(i));
    end;
    
    getShipListEx(getCurrPlayerID(), list, shipListFilter_autoFillCaptain, nil);

    dbgStr('ship count=' + IntToStr(list.Count));
    
    for I := 0 to list.Count - 1 do
    begin
      ship := list[i];
      if ship^.Captain <> $FFFF then
        addUsedCaptain(ship^.Captain);
    end;

    for I := 0 to List.Count - 1 do
    begin
      ship := list[i];
      if ship^.Captain = $FFFF then
      begin
        while true do
        begin
          if captainIDList.Count = 0 then
            exit;

          captain := integer(captainIDList[0]);
          captainIDList.Delete(0);

          if setCaptain(ship, captain, 18, 250, 250, 250, 1) then
            Break;
        end;
      end;
    end;
  finally
    captainIDList.Destroy();
     list.Destroy();
  end;

  ShipGrid.Invalidate();
end;

procedure TfrmP3Editor.btnBackToGameClick(Sender: TObject);
begin
  SwitchToGame(fIntf.IN_ParentFormHandle);
end;

procedure TfrmP3Editor.btnBuildShipClick(Sender: TObject);
var
  pid: integer;
begin
  if cbCity.ItemIndex < 0 then
    exit;

  if cbPlayer.ItemIndex < 0 then
    exit;

  if cbPlayer.ItemIndex = 0 then
    pid := getCurrPlayerID()
  else
    pid := cbPlayer.ItemIndex - 1;

  lblBuildShipResult.Caption := '';

  dbgStr('a1=' + IntToStr(cbBuildTypeA1.ItemIndex));
  dbgStr('a2=' + IntToStr(cbBuildShipType.ItemIndex));
  dbgStr('a3=' + IntToStr(cbCity.ItemIndex));
  dbgStr('a4=' + IntToStr(pid));

  if buildShip(cbBuildTypeA1.ItemIndex, cbBuildShipType.ItemIndex, cbCity.ItemIndex, pid) then
    lblBuildShipResult.Caption := 'Ok'
  else
    lblBuildShipResult.Caption := 'Error';
end;

procedure TfrmP3Editor.btnCalcClick(Sender: TObject);
var
  S: string;
  dbl: Double;
begin
  s := edCalcExpr.Text;
  s := Trim(s);
  if s = '' then
  begin
    soundBeep();
    Exit;
  end;

  edCalcResult.Text := '';

  if fEvaluator = nil then
    fEvaluator := TEvaluator.Create();

  try
    dbl := fEvaluator.Evaluate(S);
  except
    soundBeep();
    Exit;
  end;
  S := FloatToStr(dbl);

  edCalcResult.Text := S;
end;

procedure TfrmP3Editor.btnCalcF1Click(Sender: TObject);
var
  I: Integer;
  pp: PPointer;
  pb: PByte;
begin
  if not TryStrToInt(edCalcExpr.Text, I) then
  begin
    soundBeep();
    Exit;
  end;

  pp := Pointer($6dfb8c);
  pb := pp^;
  i := (i * 3) shl 7;
  inc(pb, i);
  i := integer(pb);

  case rgF1Delta.ItemIndex of
    0: ;
    1: inc(i, $134);
    2: inc(i, $160);  
  end;
  edCalcResult.Text := '$' + IntToHex(i, 8);
end;

procedure TfrmP3Editor.btnCityAddQiGaiClick(Sender: TObject);
var
  q: integer;
begin
  if (fCityList = nil) or (fCurrCity = nil) then
    Exit;

  q := fCurrCity^.Pop_begger;
  q := q + 50;

  fCurrCity^.Pop_begger := q;
  lblPopTotal.Caption := IntToStr(reCalcCityPopTotal(fCurrCity));

  PopGrid.Invalidate();
end;

procedure TfrmP3Editor.btnClearAllGoodsClick(Sender: TObject);
begin
  if fCurrShip = nil then
    exit;

  GoodsGrid.SelectAll(False);
  setSelectedGoodsQty(0);
end;

procedure TfrmP3Editor.btnCloseClick(Sender: TObject);
begin
  Close();
end;

procedure TfrmP3Editor.btnDecCityStoreClick(Sender: TObject);
var
  I: Integer;
  q: Integer;
begin
  if (fCityList = nil) or (fCurrCity = nil) then
  begin
    soundBeep();
    Exit;
  end;

  for I := 0 to fcityList^.CityCount-1 do
  begin
    q := fCurrCity^.goodsStore[I];
    fCurrCity^.goodsStore[I] := q div 2;
  end;

  CityStoreGrid.Invalidate();
end;

procedure TfrmP3Editor.btnDrawClick(Sender: TObject);
var
  map: PByte;
  c, r, x, y, maxX, maxY: integer;
  b, maxB: Byte;
  clr: TColor;
  ln: string;
begin
  fDrawing := False;
  if fCurrCity = nil then
    Exit;

  maxB := 0;
  maxX := 0;
  maxY := 0;

  map := getCityMap(cbCity.ItemIndex);

  fMap.Canvas.FillRect(fMap.Canvas.ClipRect);
  memMapData.Clear();

  for c := 0 to $E2 - 1 do
  begin
//    ln := '';
    for r := 0 to $80 - 1 do
    begin
      b := map^;
//      ln := ln + byteToHexStr(b) + ' ';
      if b > maxB then
        maxB := b;
//      x := c * 2;
//      y := r * 2;
//      if (r and 1) <> 0 then
//      begin
//        Inc(x);
//        Inc(y);
//      end;
//      if x > maxX then
//        maxX := x;
//      if y > maxY then
//        maxY := y;

      if (b >= $A0) then //and (b <= $BF) then
        clr := clWhite
      else
        clr := clBlack;
//      clr := RGB(b, b, b);
      fMap.Canvas.Pixels[r, c] := clr;
      Inc(map); 
    end;

//    memMapData.Lines.Add(ln);
  end;

//  OutputDebugString(pchar('MaxB=' + byteToHexStr(maxB) + ', MaxX=' + IntToStr(maxX) + ', MaxY=' + IntToStr(maxY)));

  fDrawing := True;
  PaintBox1.Invalidate();
  
//  map := getCityMap()
end;

procedure TfrmP3Editor.btnDumpAllCityPosClick(Sender: TObject);
var
  i, org: byte;
  x, y: integer;
  Doc: IXMLDocument;
  e_city: IXMLElement;
begin
  Doc := TMyXMLUtils.CreateUTF8EncodedXMLDocDefault('city-pos');
  for I := 0 to getCityCount() - 1 do
  begin
    getCityMapPos(i, x, y);

    e_city := TMyXMLUtils.CreateChildElmt(Doc.DocumentElement, 'city');
    org := getOriginalCityID(i);
    e_city.SetAttribute('internal-code', IntToStr(org));
    e_city.SetAttribute('name', getCityName2(i));
    e_city.SetAttribute('x', IntToStr(x));
    e_city.SetAttribute('y', IntToStr(y));
  end;

  Doc.Save(ExtractFilePath(ParamStr(0)) + 'city-pos.xml', ofIndent);
end;

procedure TfrmP3Editor.btnDumpClick(Sender: TObject);
var
  I, J: Integer;
  pname, ln: string;
  sl: TList;
  ship: PP3R2Ship;
  p: Pointer;
begin
  memTradeRoute.Lines.BeginUpdate();
  try
    memTradeRoute.Clear();
  
    sl := TList.Create();
    try
      for I := 0 to getCurrPlayerID() do
      begin
        pname := getPlayerName(I);
        memTradeRoute.Lines.Add('Trader: ' + pname);
        sl.Clear();
        getShipList(I, sl);


        for J := 0 to sl.Count - 1 do
        begin
          ship := sl[J];
          ln := '  Ship ' + IntToStr(J + 1) + ': ';
          ln := ln + wordToHexStr(ship^.TradingIndex);
          memTradeRoute.Lines.Add(ln);
        end;

        memTradeRoute.Lines.Add('');
        memTradeRoute.Lines.Add('');
      end;
    finally
      sl.Destroy();
    end;

    if (cbCity.ItemIndex < 0) or (fCurrCity = nil) then
      exit;

    p := getCityBuilding(fCurrCity, 0);
    memTradeRoute.Lines.Add('City building ptr:' + ptrToHexStr(p));
  finally
    memTradeRoute.Lines.EndUpdate();
  end;
end;

procedure TfrmP3Editor.btnDumpFromCurrPosClick(Sender: TObject);
var
  pb: Pbyte;
  sz: integer;
begin
  if fCurrPageMP = nil then
  begin
    soundBeep();
    exit;
  end;

  if (MemInspectGrid.SelectedNode = nil) or (MemInspectGrid.FocusedColumn < 0) then
  begin
    soundBeep();
    exit;
  end;

  if not TryStrToInt(cbDumpSize.Text, sz) or (sz <= 0) then
  begin
    soundBeep();
    exit;
  end;

  pb := pointer(getMemInspaceGridOff(MemInspectGrid.SelectedNode, MemInspectGrid.FocusedColumn));
  saveBytes(pb, sz);
end;

procedure TfrmP3Editor.btnF2Click(Sender: TObject);
var
  pP: PPointer;
  pb: PByte;
  pw: PWord;
begin
  pb := pointer(getPlayerMoneyPtr(getCurrPlayerID()));

  inc(pb, $0e);
//  pp := Pointer($6fdb7c);
//  pb := pp^;
//  Inc(pb, $8f4);
//  pw := pointer(pb);
  edCalcResult.Text := '$' + IntToHex(integer(pb), 8);
end;

procedure TfrmP3Editor.btnFavCaptainClick(Sender: TObject);
begin
  if fCurrShip = nil then
    Exit;

//  if not fCurrShip.validateMem() then
//  begin
//    errMemFreed();
//    Exit;
//  end;

//  fCurrShip.shipCopy.Ship.Captain := FAV_CAPTAIN;
  fCurrShip^.Captain := FAV_CAPTAIN;
  captainChanged();
  ShipGrid.Invalidate();
  MemGrid.Invalidate();
end;

procedure TfrmP3Editor.btnFillAllClick(Sender: TObject);
var
  I, J: Integer;
  MP: TMemPage;
  Ship: PP3R2Ship;
  seaman: Integer;
begin
  Seaman := 0;

  if not cbEnsureShuiShou.Checked
  and not cbEnsureMaxPower.Checked
  and not cbEnsureGoodsFull.Checked
  and not cbEnsureShiQiFull.Checked
  and not cbEnsurePointFull.Checked then
  begin
    OutputDebugString('all-err-1');
    Exit;
  end;


  if cbEnsureShuiShou.Checked then
  begin
    if not TryStrToInt(edEnsureShuiShou.Text, Seaman) or (Seaman < 0) then
    begin
//      OutputDebugString('all-err-2');
      intStrErr();
      Exit;
    end;
  end;

//  for I := 0 to fHotMemPageList.Count - 1 do
//  begin
//    MP := TMemPage(fHotMemPageList[I]);
//    MP.validateHeapAll();
//  end;

  for I := 0 to fShipList_R2.Count - 1 do
  begin
    Ship := fShipList_R2[I];

    if (Ship.State in [SHIP_STATE__BUILDING, SHIP_STATE__KILLED]) then
      Continue;
//    if Ship.MemPage.Freed then
//    begin
//      OutputDebugString('all-err-3');
//      Continue;
//    end;

    if cbEnsureGoodsFull.Checked then
    begin
      for J := 1 to 20 do
      begin
        Ship^.Goods[J] := FAV_QTY * UNIT_PKG;
      end;
    end;

    if cbEnsurePointFull.Checked then
    begin
      Ship.MaxPoint := FAV_SHIP_POINT;
      Ship.CurrPoint := FAV_SHIP_POINT;
    end;

    if cbEnsureShiQiFull.Checked then
    begin
      Ship^.ShiQi := MAX_SHIQI;
    end;

    if cbEnsureShuiShou.Checked then
    begin
      if Ship^.Seaman < Seaman then
        Ship^.Seaman := Seaman;

      if Ship^.Sword < Ship^.Seaman then
        Ship^.Sword := Ship^.Seaman;
    end;

    if cbEnsureMaxPower.Checked then
    begin
      for J := 1 to 24 do
      begin
        Ship.Carnons[J] := CANNON__JIANONG;
      end;
      Ship.Power := MAX_POWER;
    end;

//    Ship.Locked := False;
  end;


  ShipGrid.Invalidate();
  updateShipInfo();
end;

procedure TfrmP3Editor.btnFullCannonsClick(Sender: TObject);
var
  I: Integer;
begin
  if fCurrShip = nil then
    Exit;

//  if not fCurrShip.validateMem() then
//  begin
//    errMemFreed();
//    Exit;
//  end;

  for I := 1 to 24 do
  begin
    fCurrShip.Carnons[I] := CANNON__JIANONG;
  end;

  fCurrShip.Power := MAX_POWER;

  lblPower.Caption := IntToStr(MAX_POWER);

  ShipGrid.Invalidate();
  MemGrid.Invalidate();
end;

procedure TfrmP3Editor.btnGotoHomeCityClick(Sender: TObject);
begin
  cbCity.ItemIndex := getPlayerHomeCity(getCurrPlayerID());
  cbCityChange(cbCity);
end;

procedure TfrmP3Editor.btnGotoOffsetToCurrSelectClick(Sender: TObject);
var
  pb: PByte;
  off: integer;
  mp: TMemPage;
begin
  if (fCurrPageMP = nil) or (MemInspectGrid.SelectedNode = nil) or (MemInspectGrid.FocusedColumn < 0) then
    exit;

  if not TryStrToInt(edGotoOffset.Text, off) then
    exit;

  pb := pointer(getMemInspaceGridOff(MemInspectGrid.SelectedNode, MemInspectGrid.FocusedColumn));
  Inc(pb, off);

  if not fCurrPageMP.isPtrInPage(pb) then
  begin
    mp := QueryMemPageEx(GetCurrentProcess(), pb);
    if mp = nil then
    begin
      soundBeep();
      Exit;
    end;

    memInspectorUpdateCurrPage(mp);
    fAnchor := pb;
    MemInspectGrid.Invalidate();
    PostMessage(Handle, UM_GOTO_MEM_PTR, 0, integer(pb));
  end
  else
  begin
    fAnchor := pb;
    MemInspectGrid.Invalidate();
    PostMessage(Handle, UM_GOTO_MEM_PTR, 0, integer(pb));
  end;
end;

procedure TfrmP3Editor.btnMemInspGotoAddrClick(Sender: TObject);
var
  I: Integer;
  ptr: Pointer;
  mp: TMemPage;
begin
  if not TryStrToInt(edMemInspGotoTargetAddr.Text, I) then
  begin
    OutputDebugString('err-1');
    soundBeep();
    Exit;
  end;

  if i = 0 then
  begin
    OutputDebugString('err-2');
    soundBeep();
    Exit;
  end;

  ptr := pointer(I);

  mp := QueryMemPageEx(GetCurrentProcess(), ptr);
  if mp = nil then
  begin
    OutputDebugString('err-3');
    soundBeep();
    Exit;
  end;

//  pcMain.ActivePageIndex := 1;
  memInspectorUpdateCurrPage(mp);
  fAnchor := ptr;
  MemInspectGrid.Invalidate();
  PostMessage(Handle, UM_GOTO_MEM_PTR, 0, integer(ptr));
end;

procedure TfrmP3Editor.btnMemInspRsetClick(Sender: TObject);
begin
  fSearchStarted := False;
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


procedure TfrmP3Editor.btnMemInspSearchClick(Sender: TObject);
var
  currPtr: Pointer;

  function  strlenMax(p: PChar; const max: Integer): Integer;
  var
    i: Integer;
  begin
    Result := -1;
    
    for I := 0 to max do
    begin
      if p^ = #0 then
      begin
        Result := i;
        Exit;
      end;
    end;
  end;

  procedure loadSearchResultIntoLB();
  var
    i: Integer;
    s: string;
    ptr: pointer;
  begin
    ListBox1.Items.BeginUpdate();
    try
      ListBox1.Items.Clear();

      for I := 0 to fSearchResult.Count - 1 do
      begin
        ptr := fSearchResult[I];
        s := ptrToHexStr(ptr);
        ListBox1.Items.Add(s);
      end;
             
    finally
      ListBox1.Items.EndUpdate();
    end;
  end;

  procedure internalSearchStrNext(const S: string);
  var
    I, l, addr: Integer;
    p, psrc: pchar;
  begin
    psrc := pchar(s);

    L := Length(s);
    fSearchResult.Clear();

    for I := 0 to ListBox1.Items.Count - 1 do
    begin
      addr := StrToInt(ListBox1.Items[I]);
      p := pointer(addr);
      fSearchResult.Add(p);
    end;
    
    for I := fSearchResult.Count - 1 downto 0 do
    begin
      //TODO: the length fSearchResult[I] was not checked!
      p := pointer(fSearchResult[I]);
      if not CompareMem(p, psrc, l) then
        fSearchResult.Delete(I);
    end;

    loadSearchResultIntoLB();
  end;  

  procedure internalSearchStrFirst(const S: string);
  var
    I, Len: Integer;
    Searcher: TSearchBM;
    MP: TMemPage;
    pCurr, pEnd: PChar;
  begin
    fSearchResult.Clear();
    
    Searcher := TSearchBM.Create();
    try
      Searcher.PrepareStr(S);


      pCurr := currPtr;
      pEnd := Pointer(Integer(fCurrPageMP.P) + fCurrPageMP.Size);
      Len := integer(pEnd) - integer(pCurr);

      try
        while (pCurr <> nil) and (pCurr < pend) do
        begin
          pCurr := Searcher.Search(pCurr, Len);

          if pCurr <> nil then
          begin
            fSearchResult.Add(pCurr);

            inc(pCurr, length(S));

            Len := Integer(pend - pCurr);
          end;
        end;
      except
      end;
    finally
      Searcher.Destroy();
    end;

    loadSearchResultIntoLB();

    fSearchStarted := True;
  end;


  procedure memSearchText();
  var
    WS: WideString;
  begin    
    if fSearchStarted then
    begin
      internalSearchStrNext(fSearchTargetS);
    end
    else
    begin
      fSearchTargetS := edMemInspSearchTarget.Text;
      case rgSearchCodePage.ItemIndex of
        1: fSearchTargetS := AnsiToUtf8(fSearchTargetS);
        2:
        begin
          WS := fSearchTargetS;
          SetLength(fSearchTargetS, length(ws) * 2);
          Move(ws[1], fSearchTargetS[1], Length(fSearchTargetS));
        end;
      end;
      internalSearchStrFirst(fSearchTargetS);
    end;
  end;

  procedure internalSearchByteFirst(const aTargetB: Byte);
  var
    I: Integer;
    pCurr, pEnd: PByte;
  begin
    fSearchResult.Clear();
    
    pCurr := currPtr;
    pEnd := Pointer(Integer(fCurrPageMP.P) + fCurrPageMP.Size);
    try
      while (integer(pCurr) < integer(pend)) do
      begin
        if pCurr^ = aTargetB then
          fSearchResult.Add(pCurr);

        Inc(pCurr);
      end;
    except
      soundBeep();
    end;

    loadSearchResultIntoLB();
    fSearchStarted := True;
  end;

  procedure internalSearchByteNext(const aTargetB: Byte);
  var
    I, l, addr: Integer;
    p: PByte;
  begin
    fSearchResult.Clear();

    for I := 0 to ListBox1.Items.Count - 1 do
    begin
      addr := StrToInt(ListBox1.Items[I]);
      p := pointer(addr);
      fSearchResult.Add(p);
    end;

    for I := fSearchResult.Count - 1 downto 0 do
    begin
      //TODO: the length fSearchResult[I] was not checked!
      p := pointer(fSearchResult[I]);
      if p^ <> aTargetB then
        fSearchResult.Delete(I);
    end;

    loadSearchResultIntoLB();
  end;

  procedure memSearchByte();
  begin
    if fSearchStarted then
    begin
      fSearchTargetB := StrToInt(edMemInspSearchTarget.Text);
      internalSearchByteNext(fSearchTargetB);
    end
    else
    begin
      fSearchTargetB := StrToInt(edMemInspSearchTarget.Text);
      internalSearchByteFirst(fSearchTargetB);
    end;
  end;

  procedure memSearchWord();
  begin
  end;

  procedure memSearchLongword();
  var
    I: Int64;
    c: cardinal;
    j: Integer;
    s: string;
  begin
    if not fSearchStarted then
    begin
      if not TryStrToInt64(edMemInspSearchTarget.Text, I) then
      begin
        soundBeep();
        Exit;
      end;

      if I < 0 then
      begin
        j := I;
        c := j;
      end
      else
      begin
        c := I;
      end;

      SetLength(fSearchTargetS, sizeof(c));
      Move(c, fSearchTargetS[1], sizeof(c));
      internalSearchStrFirst(fSearchTargetS);
    end
    else
    begin
      internalSearchStrNext(fSearchTargetS);
    end;
  end;

  procedure memSearchBin();
  var
    I: Integer;
    s: string;
  begin
    if not fSearchStarted then
    begin
      s := edMemInspSearchTarget.Text;

      for I := length(s) to 1 do
      begin
        case s[i] of
          ' ', '$': Delete(s, i, 1);
          '0'..'9', 'a'..'f', 'A'..'F':
            ;
        else
          soundBeep();
          Exit;
        end;
      end;

      fSearchTargetS := SimpleHexToBin(s);
      internalSearchStrFirst(fSearchTargetS);
    end
    else
    begin
      internalSearchStrNext(fSearchTargetS);
    end;    
  end;

//var
//  I: Integer;
//  MP: TMemPage;
begin
  if edMemInspSearchTarget.Text = '' then
  begin
    soundBeep();
    exit;
  end;

  currPtr := memInspGetSelectedPtr();
  if currPtr = nil then
  begin
    soundBeep();
    exit;
  end;

  if not fSearchStarted then
    ListBox1.Items.Clear();

  case rgMemInspSearchDataType.ItemIndex of
    0: memSearchText();
    1: memSearchByte();
    2: memSearchWord();
    3: memSearchLongword();
    4: memSearchBin();
  end;
end;

procedure TfrmP3Editor.btnPlayerMoneyX1000Click(Sender: TObject);
var
  p: Byte;
  i, j: Integer;
begin
  if cbPlayer.ItemIndex < 0 then
    Exit;

  p := getSelectedPlayerID();

  i := getPlayerMoney(p);
  j := i * 1000;
  if j < i then
  begin
    soundBeep();
    Exit;
  end;

  setPlayerMoney(p, j);
  updatePlayerMoney();
end;

procedure TfrmP3Editor.btnPlayerMoneyX100Click(Sender: TObject);
var
  p: Byte;
  i, j: Integer;
begin
  if cbPlayer.ItemIndex < 0 then
    Exit;

  p := getSelectedPlayerID();

  i := getPlayerMoney(p);
  j := i * 100;
  if j < i then
  begin
    soundBeep();
    Exit;
  end;

  setPlayerMoney(p, j);
  updatePlayerMoney();
end;

procedure TfrmP3Editor.btnHexToIntClick(Sender: TObject);
var
  i: Integer;
  s: string;
begin
  edCalcResult.Text := '';
  try
    i := StrToInt(edCalcExpr.Text);
    s := IntToStr(i);
  except
    soundBeep();
    Exit;
  end;
  edCalcResult.Text := s;
end;

procedure TfrmP3Editor.btnHideClick(Sender: TObject);
begin
  Close();
end;

procedure TfrmP3Editor.btnIntToHexClick(Sender: TObject);
var
  i: Integer;
  s: string;
begin
  edCalcResult.Text := '';
  try
    i := StrToInt(edCalcExpr.Text);
    s := '$' + IntToHex(i, 8);
  except
    soundBeep();
    Exit;
  end;
  edCalcResult.Text := S;
end;

procedure TfrmP3Editor.btnKillProcessClick(Sender: TObject);
begin
  TerminateProcess(GetCurrentProcess(), 0);
end;

procedure TfrmP3Editor.btnTest2Click(Sender: TObject);

var
  cnt: integer;
  edi, eax, ecx, esi: dword;
  d1, d2: Single;
  mem: TMemo;
  p: pointer;
begin
  mem := memMapData;

  mem.Clear();
  edi := longwordAt(pointer($70AD94), 0);

  if edi = 0 then
    mem.Lines.Add('edi=0');

  cnt := 0;

  while (edi <> 0) and (cnt < 100) do
  begin
    eax := byteAt(pointer(edi), 4);
    ecx := eax * 8;
    ecx := ecx - eax;
    ecx := ecx shl 4;

    d1 := singleAt(pointer(edi), ecx + $E08);
    mem.Lines.Add(ptrToHexStr(pointer(ptrAdd(pointer(edi), ecx + $E08))));
    mem.Lines.Add('d1=' + FloatToStr(d1));
    d2 := singleAt(pointer($692820), 0);
    mem.Lines.Add('d2=' + FloatToStr(d2));
    d1 := d1 * d2;

    eax := Trunc(d1);
    mem.Lines.Add(IntToStr(eax));

    edi := longwordAt(pointer(edi), $230c);
    Inc(cnt);
//    p := ptrAdd(pointer(edi), ecx + $E08);
  end;
end;

procedure TfrmP3Editor.btnLockSelectedClick(Sender: TObject);
var
  ship: PP3R2Ship;
begin
  if ShipGrid.SelectedNode = nil then
    Exit;

  ship := ShipGrid.GetNodeUserData(ShipGrid.SelectedNode);
  if ship <> fLockedShip then
  begin
    fLockedShip := ship;
    fLockedShipName := getShipName_R2(@ship);
  end
  else
  begin
    fLockedShip := nil;
    fLockedShipName := '';
  end;

  ShipGrid.Invalidate();
  updateShipInfo();
end;

procedure TfrmP3Editor.btnMaxLoadClick(Sender: TObject);
begin
  if fCurrShip = nil then
    Exit;

//  if not fCurrShip.validateMem() then
//  begin
//    errMemFreed();
//    Exit;
//  end;


  fCurrShip.LoadUpLimit := FAV_LOAD;
  maxLoadChanged();
  ShipGrid.Invalidate();
  MemGrid.Invalidate();
end;

procedure TfrmP3Editor.btnSetLoadClick(Sender: TObject);
var
  tong: integer;
begin
  if fCurrShip = nil then
    Exit;

//  if not fCurrShip.validateMem() then
//  begin
//    errMemFreed();
//    Exit;
//  end;

  if not TryStrToInt(edLoadLimit.Text, tong) then
  begin
    intStrErr();
    Exit;
  end;

  if tong < 0 then
  begin
    intStrErr();
    Exit;
  end;

  tong := tong * UNIT_TONG;

  fCurrShip.LoadUpLimit := tong;
//  fCurrShip.orgShipPtr^.LoadUpLimit:= tong;
  maxLoadChanged();

  ShipGrid.Invalidate();
  MemGrid.Invalidate();
end;

procedure TfrmP3Editor.btnSetPlayer46cClick(Sender: TObject);
//var
//  pid: byte;
//  pp: Pointer;
//  pdw: PDWORD;
//  psing: PSingle;
//  f1, f2: Single;
//  i1, i2: integer;
//  dw: dword;
begin
//  if cbPlayer.ItemIndex <= 0 then
//    pid := getCurrPlayerID()
//  else
//    pid := cbPlayer.ItemIndex - 1;
//
//  pp := getPlayerPtr(pid);
//
//  if rgConvertDWSingle1.ItemIndex = 0 then
//  begin
////    if not TryStrToInt(edPlayer_46C.Text, i1) then
////    begin
////      soundBeep();
////      exit;
////    end;
////
////    if not TryStrToInt(edPlayer_470.Text, i2) then
////    begin
////      soundBeep();
////      exit;
////    end;
//
//    pdw := ptrAdd(pp, $46c);
//    pdw^ := i1;
//
//    pdw := ptrAdd(pp, $470);
//    pdw^ := i2;
//  end
//  else
//  begin
//    if not TryStrToFloat(edPlayer_46C.Text, f1)
//    or not TryStrToFloat(edPlayer_470.Text, f2) then
//    begin
//      soundBeep();
//      exit;
//    end;
//
//    psing := ptrAdd(pp, $46c);
//    psing^ := f1;
//
//    psing := ptrAdd(pp, $470);
//    psing^ := f2;
//  end;
end;

procedure TfrmP3Editor.btnSetPlayerExtraInfoClick(Sender: TObject);
var
  i: Integer;
  b, p: Byte;
begin
  if cbPlayer.ItemIndex < 0 then
    exit;

  if not TryStrToInt(edPlayer_1B.Text, i) then
    exit;

  if cbPlayer.ItemIndex = 0 then
    p := getCurrPlayerID()
  else
    p := cbPlayer.ItemIndex-1;

  if (i < 0) or (i > 255) then
    exit;

  b := i;
  setPlayerExtraInfo_1B(p, b);
end;

procedure TfrmP3Editor.btnSetPlayerMoneyClick(Sender: TObject);
var
  i: Integer;
begin
  if cbPlayer.ItemIndex < 0 then
    Exit;

  if not TryStrToInt(edPlayerMoney.Text, i) then
  begin
    soundBeep();
    Exit;
  end;

  if i < 0 then
  begin
    soundBeep();
    Exit;
  end;

  setPlayerMoney(getSelectedPlayerID(), i);
  updatePlayerMoney();
end;

procedure TfrmP3Editor.btnMaxStrongClick(Sender: TObject);
begin
  if fCurrShip = nil then
    Exit;

//  if not fCurrShip.validateMem() then
//  begin
//    errMemFreed();
//    Exit;
//  end;

  fCurrShip.MaxPoint := FAV_SHIP_POINT;
  fCurrShip.CurrPoint := FAV_SHIP_POINT;

  edShipCurrPoint.Text := IntToStr(FAV_SHIP_POINT);
  edShipMaxPoint.Text := IntToStr(FAV_SHIP_POINT);

  ShipGrid.Invalidate();
  MemGrid.Invalidate();
end;

procedure TfrmP3Editor.btnSearchClick(Sender: TObject);
//var
//  I, Len, minP, maxP: Integer;
//  MP: TMemPage;
//  pCurr, pEnd: PChar;
//  ship: PP3R2Ship;
//  Searcher: TSearchBM;
//  PREFIX_LEN: Integer;
//  N: PVirtualNode;
//  tk: cardinal;


begin
//  PREFIX_LEN := Length(SHIP_NAME_PREFIX);
//  if not TryStrToInt(edAddrFrom.Text, minP) then
//  begin
//    intStrErr();
//    exit;
//  end;
//
//  if Cardinal(minP) < Cardinal(SysInfo.lpMinimumApplicationAddress) then
//    minP := Cardinal(SysInfo.lpMinimumApplicationAddress);
//
//
//  if not TryStrToInt(edAddrTo.Text, maxP) then
//  begin
//    intStrErr();
//    Exit;
//  end;
//
//  if Cardinal(maxP) > Cardinal(SysInfo.lpMaximumApplicationAddress) then
//    maxP := Cardinal(SysInfo.lpMaximumApplicationAddress);
//
//  fLockedShip := nil;
//
//  clearShipListView();
//  fShipList_R2.Clear();
////  fOrgShipPtrList.Clear();
////  fHotMemPageList.Clear();
//  fCurrShip := nil;
//  updateShipInfo();
//  btnSetAddrRange.Enabled := False;
//
//  
//
////  MemInspectGrid.Clear();
////  FreeAndNil(fCurrPageMP);
//
//  Screen.Cursor := crHourGlass;
//  try
////    Searcher := TSearchBM.Create();
////    try
////      Searcher.PrepareStr(SHIP_NAME_PREFIX);
////
////  //    MemPageList := TObjectList.Create(True);
////  //    try
////      if (not cbUseCacheMemPageList.Checked) or (fMemPageList.Count = 0) then
////      begin
////        fMemPageList.Clear();
////        {$IFDEF VQ}
////        ListMemPage2(GetCurrentProcess(), fMemPageList);
////        {$ELSE}
//////        MP := QueryMemPageEx(GetCurrentProcess(), getCityListPtr());
//////        if MP <> nil then
//////          fMemPageList.Add(MP);
//////        tk := GetTickCount();
////        ListMemPage(GetCurrentProcessId(), fMemPageList);
//////        tk := GetTickCount() - tk;
//////        OutputDebugString(pchar('used time: ' + IntToStr(tk div 1000)));
////        {$ENDIF}
//////        testGetHeap();
////
//////        OutputDebugString(pchar('page count: ' + IntToStr(fMemPageList.Count)));
////      end;
////
////      for I := 0 to fMemPageList.Count - 1 do
////      begin
////        MP := TMemPage(fMemPageList[I]);
////
////        {$IFDEF VQ}
////        if MP.MemState <> MS__COMMIT then
////          Continue;
////
////        if MP.MemProtection <> MP__READWRITE then
////          Continue;
////        {$ENDIF}
////
////        if MP.MemType <> MT__PRIVATE then
////          Continue;
////
////        if (Cardinal(MP.P) < Cardinal(minP)) or (Cardinal(MP.P) > Cardinal(maxP)) then
////          Continue;
////
////  //        OutputDebugString('test page');
////
////        Len := MP.Size;
////
////        pCurr := MP.P;
////        pEnd := Pointer(Integer(MP.P) + Len);
////
////        try
////          while (pCurr <> nil) and (pCurr < pend) do
////          begin
////            pCurr := Searcher.Search(pCurr, Len);
////
////            if pCurr <> nil then
////            begin
//////              OutputDebugString(pchar('found a target: ' + IntToHex(integer(pcurr), 8)));
////
////              try
////                checkShipName(MP, pCurr);
////              except
////                OutputDebugString('error in testShip');
////                raise;
////              end;
////
////              inc(pCurr, PREFIX_LEN);
////
////              Len := Integer(pend - pCurr);              
////            end;
////          end;
////        except
////        end;
////      end;
////  //    finally
////  //      MemPageList.Destroy();
////  //    end;
////    finally
////      Searcher.Destroy();
////    end;
//
////    OutputDebugString(pchar('hot page count=' + IntToStr(fHotMemPageList.Count)));
//
//    getShipList(getCurrPlayerID(), fShipList_R2);
//
//    fShipList_R2.Sort(shipObjSortCompare);
//
//    for I := 0 to fShipList_R2.Count - 1 do
//    begin
//      ship := pp3r2Ship(fShipList_R2[I]);
//      if (fLockedShip = nil)
//      and (fLockedShipName <> '')
//      and (getShipName_R2(ship) = fLockedShipName) then
//        fLockedShip := ship;
//
//      N := ShipGrid.AddChild(nil, ship);
//      ShipGrid.CheckType[N] := ctCheckBox;
//      ShipGrid.CheckState[N] := csUncheckedNormal;
//    end;
//
//    btnSetAddrRange.Enabled := fShipList_R2.Count > 0;
//  finally
//    Screen.Cursor := crDefault;
//  end;
end;

procedure TfrmP3Editor.btnSetAddrRangeClick(Sender: TObject);
var
  I: Integer;
  p, pMin, pMax: Cardinal;
  mp: TMemPage;
begin
  pMin := 0;
  pMax := 0;
//  for I := 0 to fHotMemPageList.Count - 1 do
//  begin
//    mp := TMemPage(fHotMemPageList[I]);
//    p := Cardinal(mp.P);
//
//    if pMin = 0 then
//    begin
//      pMin := p;
//    end
//    else
//    begin
//      if p < pMin then
//        pMin := p;
//    end;
//
//    p := p + mp.Size;
//
//    if pMax = 0 then
//      pMax := p
//    else if p > pMax then
//      pMax := p;
//  end;
//
//  if (pMin = 0) or (pMax = 0) then
//    Exit;
//
//  pMin := pMin and $FF000000;
//  pMax := pMax and $FF000000;
//
//  if pMax = pMin then
//  begin
//    pMax := pMax shr 24;
//    Inc(pMax);
//    pMax := pMax shl 24;
//  end;
//
//  edAddrFrom.Text := '$' + IntToHex(pMin, 8);
//  edAddrTo.Text := '$' + IntToHex(pMax, 8);
end;

procedure TfrmP3Editor.btnSetAllGoodsQtyToClick(Sender: TObject);
begin
  if fCurrShip = nil then
    exit;

  GoodsGrid.SelectAll(False);
  setSelectedGoodsQty(FAV_QTY);
end;

procedure TfrmP3Editor.btnSetCaptainBirthdayClick(Sender: TObject);
var
  dt: TDateTime;
  y, m, d: word;
  ts: Cardinal;
  cap: PCaptainRec;
begin
  if (fCurrShip = nil) or (fCurrShip^.Captain = $FFFF) then
    exit;

  dt := StrToDate(edCaptainBirthday.Text);
  DecodeDate(dt, y, m, d);

  ts := dateToTimestamp(y, m, d);
  cap := getCaptionInfo(fcurrship.Captain);
  cap.birdthDay := ts;
end;

procedure TfrmP3Editor.btnSetCaptainClick(Sender: TObject);
var
  I: Integer;
begin
  if fCurrShip = nil then
    Exit;

//  if not fCurrShip.validateMem() then
//  begin
//    errMemFreed();
//    Exit;
//  end;

  if not TryStrToInt(cbCaptain.Text, I) then
  begin
    intStrErr();
    Exit;
  end;

  if not isValidCaptain(I) then
  begin
    soundBeep();
    Exit;
  end;

  setCaptain(fCurrShip, I, 18, 250, 250, 250, 1);

//  fCurrShip.Captain := I;

  captainChanged();
  ShipGrid.Invalidate();
  MemGrid.Invalidate();
end;

procedure TfrmP3Editor.btnSetDestClick(Sender: TObject);
var
  n: PVirtualNode;
  ship: PP3R2Ship;
begin
  n := ShipGrid.SelectedNode;

  if n = nil then
    Exit;

  ship := ShipGrid.GetNodeUserData(n);
//  setShipDest(ship, 0);
end;

procedure TfrmP3Editor.btnSetFoodsQtyToClick(Sender: TObject);
begin
//
end;

procedure TfrmP3Editor.btnSetGoodsDirectClick(Sender: TObject);
var
  factor: Integer;
begin
  if fCurrShip = nil then
    Exit;

  if GoodsGrid.SelectedNode = nil then
    Exit;

  if not TryStrToInt(edGoodsQty.Text, factor) then
  begin
    intStrErr();
    Exit;    
  end;

  setSelectedGoodsQty(factor);
end;

procedure TfrmP3Editor.btnSetShengWangClick(Sender: TObject);
var                                                        
  player: Byte;
  s1, s2, s3, s4, s5: Single;
begin
  if (fCityList = nil) or (fCurrCity = nil) then
  begin
    soundBeep();
    Exit;
  end
  else
  begin
    if not TryStrToFloat(edShengWang1.Text, s1)
    or not TryStrToFloat(edShengWang2.Text, s2)
    or not TryStrToFloat(edShengWang3.Text, s3)
    or not TryStrToFloat(edShengWang4.Text, s4)
    or not TryStrToFloat(edShengWang5.Text, s5) then
    begin
      soundBeep();
      Exit;
    end;

    if (s1 < 0)
    or (s2 < 0)
    or (s3 < 0)
    or (s4 < 0)
    or (s5 < 0) then
    begin
      soundBeep();
      Exit;
    end;


    
    if cbPlayer.ItemIndex <= 0 then
      player := getCurrPlayerID()
    else
      player := cbPlayer.ItemIndex-1;

    setCityShengWang(player, cbCity.ItemIndex, s1, s2, s3, s4, s5);
  end;
end;

procedure TfrmP3Editor.btnSetShipClassClick(Sender: TObject);
begin
  if fCurrShip = nil then
  begin
    soundBeep();
    Exit;
  end;

  if (cbShipType.ItemIndex < 0) or (cbShipLevel.ItemIndex < 0) then
  begin
    soundBeep();
    Exit;
  end;

//  if not fCurrShip.validateMem() then
//  begin
//    errMemFreed();
//    Exit;
//  end;

  fCurrShip.ShipType := cbShipType.ItemIndex;
  fCurrShip.ShipUgLvl := cbShipLevel.ItemIndex;

//  fCurrShip.orgShipPtr^.ShipType := cbShipType.ItemIndex;
//  fCurrShip.orgShipPtr^.ShipLevel := cbShipType.ItemIndex;

  ShipGrid.Invalidate();    
end;

procedure TfrmP3Editor.btnSetShipNameClick(Sender: TObject);
var
  S: string;
begin
  if fCurrShip = nil then
  begin
//    OutputDebugString('---0');
    soundBeep();
    Exit;
  end;

  S := edShipName.Text;

  if s = '' then
  begin
//    OutputDebugString('---1');
    soundBeep();
    Exit;
  end;

  if Length(s) > MAX_SHIP_NAME_LENGTH then
  begin
//    OutputDebugString('---2');
    soundBeep();
    Exit;
  end;

  internalSetShipName(S);
end;

procedure TfrmP3Editor.btnSetShipNameToOthersClick(Sender: TObject);
var
  S: string;
begin
  if fCurrShip = nil then
  begin
    soundBeep();
    Exit;
  end;

  if SHIP_NAME_OTHERS_SEED > 10000 then
    SHIP_NAME_OTHERS_SEED := 1;

  s := SHIP_NAME_OTHERS + IntToStr(SHIP_NAME_OTHERS_SEED);
  Inc(SHIP_NAME_OTHERS_SEED);
  internalSetShipName(S);
end;

procedure TfrmP3Editor.btnSetShuiShouClick(Sender: TObject);
var
  S: string;
  Seaman: Integer;
begin
  if fCurrShip = nil then
    exit;

//  if not fCurrShip.validateMem() then
//  begin
//    errMemFreed();
//    Exit;
//  end;

  S := edShuiShou.Text;

//  if not InputQuery('水手数','请输入新的水手数：', S) then
//    Exit;

  if not TryStrToInt(S, Seaman) then
  begin
    intStrErr();
    Exit;
  end;

  fCurrShip.Seaman := Seaman;
//  fCurrShip.orgShipPtr^.Seaman := Seaman;
  edShuiShou.Text := S;
  ShipGrid.Invalidate();
  MemGrid.Invalidate();
end;

procedure TfrmP3Editor.btnSetTotalLoadClick(Sender: TObject);
var
  I: Int64;
begin
  if fCurrShip = nil then
  begin
    soundBeep();
    Exit;
  end;

//  if not fCurrShip.validateMem() then
//  begin
//    errMemFreed();
//    Exit;
//  end;

  if not TryStrToInt64(edTotalLoad.Text, I) or (I < 0) then
  begin
    intStrErr();
    Exit;
  end;

  I := I * UNIT_TONG;

  if I > MaxInt then
  begin
    intStrErr();
    Exit;
  end;

  fCurrShip.GoodsLoad := I;
//  fCurrShip.orgShipPtr^.GoodsLoad := fCurrShip.shipCopy.Ship.GoodsLoad;
end;

procedure TfrmP3Editor.btnShlClick(Sender: TObject);
var
  i, j: Integer;
begin
  if not TryStrToInt(edCalcExpr.Text, I) then
  begin
    soundBeep();
    Exit;
  end;

  if rgShiftBits.ItemIndex < 0 then
  begin
    soundBeep();
    Exit;
  end;

  j := StrToInt(rgShiftBits.Items[rgShiftBits.itemindex]);
  i := i shl j;
  edCalcResult.Text := IntToStr(i);
end;

procedure TfrmP3Editor.btnState0Click(Sender: TObject);
var
  S: string;
  state: Integer;
  ss: Shortint;
begin
  if fCurrShip = nil then
    Exit;

//  if not fCurrShip.validateMem() then
//  begin
//    errMemFreed();
//    Exit;
//  end;

//  S := '$' + IntToHex(fCurrShip.orgShipPtr^.State, 2);
//
//  if not TConfirmDlgIntf.directExec(Handle, '船只状态','请输入新的状态字节：', S) then
//    Exit;

  S := edState.Text;

  if not TryStrToInt(S, state) then
    Exit;

  ss := state;

  fCurrShip.State := ss;

//  fCurrShip.orgShipPtr^.State := ss;
  edState.Text := '$' + IntToHex(ss, 2);
  ShipGrid.Invalidate();
  MemGrid.Invalidate();
end;

procedure TfrmP3Editor.btnTestClick(Sender: TObject);
var
  idx: Integer;
  pf: PFactoryGroup;
  pb: Pointer;
  s: string;
begin
  if not TryStrToInt(edTestInput.Text, idx) then
    exit;

  pb := PPointer($71CDA8 + $70)^;
  s := 'factory group list ptr: ' + ptrToHexStr(pb);
  memTestResult.Lines.Add(s);

  pf := getFactoryGroupInfo(idx);
  s := 'Factory group ptr: ' + ptrToHexStr(pf);
  memTestResult.Lines.Add(s);

  s := 'intensification: ' + byteToHexStr(pf^.intensification);
  memTestResult.Lines.Add(s);

  s := 'production factor: ' + byteToHexStr(pf^.ProductionFactor);
  memTestResult.Lines.Add(s);

  s := 'current worker: ' + wordToHexStr(pf^.CurrentWorkers);
  memTestResult.Lines.Add(s);

  s := 'build type: ' + byteToHexStr(pf^.BuildType);
  memTestResult.Lines.Add(s);

  s := 'city code: ' + byteToHexStr(pf^.CityCode);
  memTestResult.Lines.Add(s);

  s := 'index: ' + wordToHexStr(pf^.NextIndex);
  memTestResult.Lines.Add(s);

  s := 'max workers: ' + wordToHexStr(pf^.MaxWorkers);
  memTestResult.Lines.Add(s);

  s := 'workers2: ' + wordToHexStr(pf^.Workers2);
  memTestResult.Lines.Add(s);

  s := 'workers3: ' + wordToHexStr(pf^.Workers3);
  memTestResult.Lines.Add(s);  
end;

procedure TfrmP3Editor.btnTestSetShipDestClick(Sender: TObject);
begin
  if fCurrShip = nil then
    exit;

  setShipDest(fCurrShip, $17);
end;

procedure TfrmP3Editor.BuildingGridGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  idx: Integer;
  b: Byte;
  build: PCityBuilding;
begin
  if fCurrCity = nil then
    Exit;

  OutputDebugString('begin get text');
  idx := Sender.GetNodeUserDataInt(Node);
  OutputDebugString(pchar('curr city=' + ptrToHexStr(fCurrCity)));
  build := getCityBuilding(fCurrCity, idx);
  if build = nil then
  begin
    OutputDebugString(pchar('building is null, city addr: ' + ptrToHexStr(fCurrCity) + ', item index=' + IntToStr(idx)));
    CellText := '';
    exit;
  end
  else
    dbgPrintPtr('building', build);

  try
    case Column of
      0: CellText := wordToHexStr(idx);
      1: CellText := byteToHexStr(build^.CoordinateX);
      2: CellText := byteToHexStr(build^.CoordinateY);
      3:
      begin
        if build^.Owner = $FF then
          CellText := 'PUBLIC'
        else 
             

          CellText := getPlayerName(build^.Owner);
      end;
      4:
      begin
        CellText := byteToHexStr(build^.BuildingType);
      end;

      5:
        CellText := wordToHexStr(build^.NextIndex);

      6:
      begin
        b := build^.DaysNeedToComplete;
        CellText := byteToHexStr(b);
      end;

      7:
      begin
        b := build^.ImageDirection;
        if b = BUILDING_IMAGE_DIRECTION__NONE then
          CellText := '(none)'
        else if b = BUILDING_IMAGE_DIRECTION__LEFT_TOP then
          CellText := 'LT'
        else if b = BUILDING_IMAGE_DIRECTION__BOTTOM_RIGHT then
          CellText := 'BR'
        else
          CellText := byteToHexStr(b);
      end;
    end;
  except
    OutputDebugString(pchar('Exception on get text, col=' + IntToStr(Column)));
    CellText := 'error';
    exit;
  end;
end;

procedure TfrmP3Editor.BusinessOfficeG2GetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  idx, q: integer;
  bo: PBusinessOffice;
  ir: PBOImportRec;
begin
  if (fCurrCity = nil) or (fBusinessOffice = nil) then
    exit;

  idx := Sender.GetNodeUserDataInt(Node);
  bo := fBusinessOffice;

  if Column = 0 then
  begin
    case idx of
      BOINFO__CITY_WEAPON_STORE_1: CellText := '刀';
      BOINFO__CITY_WEAPON_STORE_2: CellText := '弓';
      BOINFO__CITY_WEAPON_STORE_3: CellText := '十字弓';
      BOINFO__CITY_WEAPON_STORE_4: CellText := '卡宾枪';
      BOINFO__SWORD: CellText := '剑';
      BOINFO__SHIP_WEAPON_1: CellText := '小投';
      BOINFO__SHIP_WEAPON_2: CellText := '小弩';
      BOINFO__SHIP_WEAPON_3: CellText := '大投';
      BOINFO__SHIP_WEAPON_4: CellText := '大弩';
      BOINFO__SHIP_WEAPON_5: CellText := '铁炮';
      BOINFO__SHIP_WEAPON_6: CellText := '加农';
      BOINFO__GUARD: CellText := '警卫';
      BOINFO__STORE_HOUSE_MAX_CAP: CellText := '仓库容量';
      BOINFO__RENT_INCOMING: CellText := '租金收入';
      BOINFO__PAY: CellText := '工资';
      BOINFO__MANAGER_SALARY: CellText := '本周管理员周薪';
      BOINFO__HIDAGE: CellText := '地税';
      BOINFO__CURR_WORKERS: CellText := '当前工人数';
      BOINFO__MAX_WORKERS: CellText := '最大工人数';
      BOINFO__OWNER: CellText := 'Owner';
      BOINFO__CITY_CODE: CellText := 'City Code';
      BOINFO__BUILDING_STORE_HOUSE_CAP: CellText := '在建仓库容积';
      BOINFO__BUSINESS_BUILDING_QTY: CellText := '商业建筑数量';
      BOINFO__HOUSE_QTY: CellText := '住宅建筑数量';
      BOINFO__HOUSE_RESIDENT_RICH: CellText := '富人入住';
      BOINFO__HOUSE_RESIDENT_COMMON: CellText := '百姓入住';
      BOINFO__HOUSE_RESIDENT_POOR: CellText := '穷人入住';
      BOINFO__HOUSE_CAP_RICH: CellText := '高级房屋容量';
      BOINFO__HOUSE_CAP_COMMON: CellText := '普通房屋容量';
      BOINFO__HOUSE_CAP_POOR: CellText := '简陋房屋容量';
      BOINFO__IR__FACTOR: CellText := 'IR.factor';
      BOINFO__IR__UNKNOWN: CellText := 'IR.unknown';
      BOINFO__IR__INTERNAL_GOODS_ID: CellText := 'IR.internalGoodsID';
      BOINFO__IR__CITY: CellText := 'IR.city';
      BOINFO__IR__NEXT_INDEX: CellText := 'IR.nextIndex';
    end;
  end
  else if Column = 1 then
  begin
    case idx of
      BOINFO__CITY_WEAPON_STORE_1..BOINFO__CITY_WEAPON_STORE_4:
      begin
        q := fBusinessOffice.CityWeaponStore[idx - BOINFO__CITY_WEAPON_STORE_1 + 1];
        CellText := IntToStr(q);
      end;

      BOINFO__SWORD:
      begin
        CellText := IntToStr(fBusinessOffice.Sword);
      end;

      BOINFO__SHIP_WEAPON_1..BOINFO__SHIP_WEAPON_6:
      begin
        q := fBusinessOffice.ShipWeapons[idx-BOINFO__SHIP_WEAPON_1 + 1];
        CellText := IntToStr(q);
      end;

      BOINFO__GUARD:
      begin
        CellText := IntToStr(fbusinessoffice.Guard);
      end;

      BOINFO__CITY_CODE:
        CellText := byteToHexStr(fbusinessoffice.CityCode);

//      BOINFO__INDEX:
//        CellText := wordToHexStr(fBusinessOffice.Index);

      BOINFO__STORE_HOUSE_MAX_CAP:
      begin
        CellText := IntToStr(fBusinessOffice.StoreHouseMaxCap) + '(包)';
      end;

      BOINFO__BUILDING_STORE_HOUSE_CAP:
        CellText := IntToStr(bo.BuildingStoreHouseCap) + '(包)';

      BOINFO__BUSINESS_BUILDING_QTY:
        CellText := IntToStr(bo.BusinessBuildingCount);

      BOINFO__HOUSE_QTY:
        CellText := IntToStr(bo.HouseCount);

      BOINFO__HOUSE_RESIDENT_RICH:
        CellText := IntToStr(bo.HouseResidents_[GRADE__RICH]);

      BOINFO__HOUSE_RESIDENT_COMMON:
        CellText := IntToStr(bo.HouseResidents_[GRADE__COMMON]);

      BOINFO__HOUSE_RESIDENT_POOR:
        CellText := IntToStr(bo.HouseResidents_[GRADE__POOR]);

      BOINFO__HOUSE_CAP_RICH:
        CellText := IntToStr(bo.HouseMaxCapacity_[GRADE__RICH]);

      BOINFO__HOUSE_CAP_COMMON:
        CellText := IntToStr(bo.HouseMaxCapacity_[GRADE__COMMON]);

      BOINFO__HOUSE_CAP_POOR:
        CellText := IntToStr(bo.HouseMaxCapacity_[GRADE__POOR]);


      BOINFO__RENT_INCOMING:
        CellText := IntToStr(fBusinessOffice.RentIncoming);

      BOINFO__PAY:
        CellText := IntToStr(fBusinessOffice^.Pay);

      BOINFO__MANAGER_SALARY:
        CellText := IntToStr(fBusinessOffice^.ThisWeekOfficeManagerPaid);

      BOINFO__HIDAGE:
        CellText := IntToStr(fBusinessOffice^.Hidage);

      BOINFO__CURR_WORKERS:
        CellText := IntToStr(fBusinessOffice^.CurrWorkers);

      BOINFO__MAX_WORKERS:
        CellText := IntToStr(fBusinessOffice^.MaxWorkers);

      BOINFO__OWNER:
        CellText := byteToHexStr(fbusinessoffice.Owner);

      BOINFO__IR__FACTOR:
      begin
        ir := getBOImportRec(fBusinessOffice.BOIndex);
        if ir = nil then
          CellText := ''
        else
          CellText := IntToStr(ir.Factor);
      end;

      BOINFO__IR__UNKNOWN:
      begin
        ir := getBOImportRec(bo.BOIndex);
        if ir = nil then
          CellText := ''
        else
          CellText := '$' + wordToHexStr(ir.unknown);
      end;

      BOINFO__IR__INTERNAL_GOODS_ID:
      begin
        ir := getBOImportRec(bo.BOIndex);
        if ir <> nil then
          CellText := byteToHexStr(ir.ImportGoodsInternalID)
        else
          CellText := '';
      end;

      BOINFO__IR__CITY:
      begin
        ir := getBOImportRec(bo.BOIndex);
        if ir <> nil then
          CellText := byteToHexStr(ir.CityCode)
        else
          CellText := '';
      end;

      BOINFO__IR__NEXT_INDEX:
      begin
        ir := getBOImportRec(bo.BOIndex);
        if ir <> nil then
          CellText := wordToHexStr(ir.NextIndex)
        else
          CellText := '';
      end;

    end;
  end;
end;

procedure TfrmP3Editor.BusinessOfficeGridGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  idx, q, p: Integer;
begin
  idx := Sender.GetNodeUserDataInt(Node);

  case Column of
    0:
    begin
      CellText := getGoodsName(idx);
      exit;
    end;

    1:
    begin
      CellText := getGoodsUnit(idx);
      exit;
    end;
  end;

  if (fCurrCity = nil) or (fBusinessOffice = nil) then
    exit;

  case Column of
    2:
    begin
      q := fBusinessOffice.GoodsStore[idx];
      CellText := getGoodsDisplayQtyText(idx, q);
    end;

    3:
    begin
      q := fBusinessOffice.FactoryConsumes[idx];
      CellText := getGoodsDisplayQtyText(idx, q);
    end;

    4:
    begin
      q := fBusinessOffice.FactoryProductions[idx];
      CellText := getGoodsDisplayQtyText(idx, q);
    end;

    5:
    begin
      p := fBusinessOffice.BusinessPrices[idx];
      if p = 0 then
        CellText := ''
      else if p < 0 then
        CellText := '买入'
      else
        CellText := '卖出';
    end;

    6:
    begin
      p := fBusinessOffice.BusinessPrices[idx];
      if p = 0 then
        CellText := ''
      else if p < 0 then
        CellText := IntToStr(-p)
      else
        CellText := IntToStr(p);
    end;

    7:
    begin
      p := fBusinessOffice.BusinessPrices[idx];
      if p <> 0 then
      begin
        q := fBusinessOffice.BusinessLimits[idx];
        CellText := getGoodsDisplayQtyText(idx, q);
      end;
    end;
  end;
end;

procedure TfrmP3Editor.Button2Click(Sender: TObject);
var
  p: PPointer;
  delta: Integer;
  ptr, p1, p2, p3: PByte;
  mp: TMemPage;
  add: Boolean;

  function  getSize(p2: Pointer; const apreferredSz: Integer): Integer;
  var
    sz, maxRemains: Integer;
    maxPtr: Pbyte;
  begin
    maxPtr := pbyte(fCurrPageMP.P);
    Inc(maxPtr, fCurrPageMP.Size);
    maxRemains := integer(maxptr) - integer(p2);
    if apreferredSz > maxRemains then
      sz := maxRemains
    else
      sz := apreferredSz;
    Result := sz;

//    OutputDebugString(pchar('sz=' + IntToStr(sz)));
  end;
    
begin
  ListBox1.Items.Clear();
  add := ListBox1.Items.Count = 0;

  p1 := nil;
  p2 := nil;
  p3 := nil;

  p := pointer($71ce10);
  try
    ptr := p^;
    if add then
    begin
      ListBox1.Items.AddObject('$' + IntToHex(integer(ptr), 8), tobject(ptr));
      p1 := ptr;

    end;
    delta := (RadioGroup1.ItemIndex * 5) * 64 - RadioGroup1.ItemIndex;
    Inc(ptr, delta*8);
    if add then
    begin
      ListBox1.Items.AddObject('$' + IntToHex(integer(ptr), 8), tobject(ptr));
      p2 := ptr;
    end;
    if RadioGroup2.ItemIndex = 0 then
      Inc(ptr, $2cc)
    else
      Inc(ptr, $848);
    if add then
    begin
      ListBox1.Items.AddObject('$' + IntToHex(integer(ptr), 8), tobject(ptr));
      p3 := ptr;
    end;
  except
    OutputDebugString('err-1');
    soundBeep();
    exit;
  end;



  mp := QueryMemPageEx(GetCurrentProcess(), ptr, True);
  if mp = nil then
  begin
    OutputDebugString('err-2');
    soundBeep();
    Exit;
  end;

  memInspectorUpdateCurrPage(mp);
  PostMessage(Handle, UM_GOTO_MEM_PTR, 0, integer(ptr));
  
//  if add then
//  begin
//    try
//      saveBytes(p1, getSize(ptr, 1024*64));
//      saveBytes(p2, getSize(ptr, 1024*4));
//      saveBytes(p3, getSize(ptr, 1024));
//    except
//      OutputDebugString('err-3');
//      soundBeep();
//      Exit;
//    end;
//  end;
end;

procedure TfrmP3Editor.btnGotoOfsToAnchorClick(Sender: TObject);
var
  pb: PByte;
  off: integer;
  mp: TMemPage;
begin
  if (fCurrPageMP = nil)
//  or (MemInspectGrid.SelectedNode = nil)
//  or (MemInspectGrid.FocusedColumn < 0)
  or (fAnchor = nil) then
    exit;

  if not TryStrToInt(edGotoOffset.Text, off) then
    exit;

  pb := fAnchor;
  Inc(pb, off);

  if not fCurrPageMP.isPtrInPage(pb) then
  begin
    mp := QueryMemPageEx(GetCurrentProcess(), pb);
    if mp = nil then
    begin
      soundBeep();
      Exit;
    end;

    memInspectorUpdateCurrPage(mp);
    fAnchor := pb;
    MemInspectGrid.Invalidate();
    PostMessage(Handle, UM_GOTO_MEM_PTR, 0, integer(pb));
  end
  else
  begin
    fAnchor := pb;
    MemInspectGrid.Invalidate();
    PostMessage(Handle, UM_GOTO_MEM_PTR, 0, integer(pb));
  end;
end;

procedure TfrmP3Editor.btnClearCacheClick(Sender: TObject);
begin
  fCurrShip := nil;
  fLockedShip := nil;
  fLockedShipName := '';
  updateShipInfo();
  ShipGrid.Clear();
  fShipList_R2.Clear();
//  fOrgShipPtrList.Clear();
//  fMemPageList.Clear();
//  fHotMemPageList.Clear();

  {$IFDEF INTERNAL_WND}
  Release();
  {$ELSE}
  Close();
  {$ENDIF}
end;

procedure TfrmP3Editor.btnClearCityGoodsClick(Sender: TObject);
var
  I: Integer;
  q: Integer;
begin
  if (fCityList = nil) or (fCurrCity = nil) then
  begin
    soundBeep();
    Exit;
  end;

  for I := 0 to fcityList^.CityCount-1 do
  begin
    q := fCurrCity^.goodsStore[I];
    fCurrCity^.goodsStore[I] := 0;
  end;

  CityStoreGrid.Invalidate();
end;

procedure TfrmP3Editor.btnClearCityWeaponClick(Sender: TObject);
var
  i, t: Integer;
begin
  if fCurrShip = nil then
    Exit;

//  if not fCurrShip.validateMem() then
//  begin
//    errMemFreed();
//    Exit;
//  end;

  for i := 1 to 4 do
  begin
    fCurrShip.CityWeapons[i] := 0;
//    fCurrShip.orgShipPtr^.CityWeapons[i] := 0;
  end;

  t := 0;

  for I := 1 to 20 do
  begin
    inc(t, fCurrShip.Goods[I]);
  end;

  fCurrShip.GoodsLoad := t;
//  fCurrShip.shipCopy.Ship.GoodsLoad := t;
  totalLoadChanged();

//  GoodsGrid.Invalidate();
//  ShipGrid.Invalidate();
  cityWeaponChanged();
  MemGrid.Invalidate();
end;

procedure TfrmP3Editor.btnFillCityWeaponClick(Sender: TObject);
var
  i, t: Integer;
begin
  if fCurrShip = nil then
    Exit;

//  if not fCurrShip.validateMem() then
//  begin
//    errMemFreed();
//    Exit;
//  end;

  t := 0;

  for i := 1 to 4 do
  begin
    fCurrShip.CityWeapons[i] := FAV_CITY_WEAPON;
//    fCurrShip.orgShipPtr^.CityWeapons[i] := FAV_CITY_WEAPON;
    Inc(t, FAV_CITY_WEAPON);
  end;

  for I := 1 to 20 do
  begin
    inc(t, fCurrShip.Goods[I]);
  end;

//  fCurrShip.orgShipPtr^.GoodsLoad := t;
  fCurrShip.GoodsLoad := t;
  totalLoadChanged();

//  GoodsGrid.Invalidate();
//  ShipGrid.Invalidate();
  cityWeaponChanged();
  MemGrid.Invalidate();
end;

procedure TfrmP3Editor.btnFillGoodsClick(Sender: TObject);
var
  I, J: Integer;
  MP: TMemPage;
  Ship: PP3R2Ship;
begin
//  for I := 0 to fHotMemPageList.Count - 1 do
//  begin
//    MP := TMemPage(fHotMemPageList[I]);
//    MP.validateHeapAll();
//  end;

  for I := 0 to fShipList_R2.Count - 1 do
  begin
    Ship := fShipList_R2[I];
    if not isValidShipPtr_R2(Ship) then
      Continue;
//    if Ship.MemPage.Freed then
//    begin
//      Continue;
//    end;

    for J := 1 to 20 do
    begin
      Ship.Goods[J] := FAV_QTY * UNIT_PKG;
//      Ship.orgShipPtr^.Goods[J] := FAV_QTY * UNIT_PKG;
    end;
  end;

  ShipGrid.Invalidate();

  updateShipInfo();
end;

procedure TfrmP3Editor.btnFillSelectedClick(Sender: TObject);
var
  I, J: Integer;
  MP: TMemPage;
//  Ship: TShipObj;
  Seaman: Integer;
  N: PVirtualNode;
  Ship: PP3R2Ship;
begin
  Seaman := 0;

  if not cbEnsureShuiShou.Checked
  and not cbEnsureMaxPower.Checked
  and not cbEnsureGoodsFull.Checked
  and not cbEnsureShiQiFull.Checked
  and not cbEnsurePointFull.Checked then
  begin
    soundBeep();
    Exit;
  end;

  if cbEnsureShuiShou.Checked then
  begin
    if not TryStrToInt(edEnsureShuiShou.Text, Seaman) or (Seaman < 0) then
    begin
      intStrErr();
      Exit;
    end;
  end;

//  for I := 0 to fHotMemPageList.Count - 1 do
//  begin
//    MP := TMemPage(fHotMemPageList[I]);
//    MP.validateHeapAll();
//  end;

  N := ShipGrid.GetFirst();
  while N <> nil do
  begin
    if ShipGrid.CheckState[N] in [csCheckedNormal, csCheckedPressed] then
    begin
//      OutputDebugString(pchar('checked'));
      Ship := ShipGrid.GetNodeUserData(N);

      if isValidShipPtr_R2(ship)
      and (ship.State <> SHIP_STATE__BUILDING)
      and (ship.State <> SHIP_STATE__KILLED) then
      begin
        if cbEnsureGoodsFull.Checked then
        begin
          for J := 1 to 20 do
          begin
            Ship.Goods[J] := FAV_QTY * UNIT_PKG;
//            Ship.orgShipPtr^.Goods[J] := FAV_QTY * UNIT_PKG;
          end;
        end;

        if cbEnsurePointFull.Checked then
        begin
          Ship.MaxPoint := FAV_SHIP_POINT;
          Ship.CurrPoint := FAV_SHIP_POINT;

//          Ship.orgShipPtr^.MaxPoint := FAV_SHIP_POINT;
//          Ship.orgShipPtr^.CurrPoint := FAV_SHIP_POINT;
        end;

        if cbEnsureShiQiFull.Checked then
        begin
          Ship.ShiQi := MAX_SHIQI;
//          Ship.orgShipPtr^.ShiQi := MAX_SHIQI;
        end;

        if cbEnsureShuiShou.Checked then
        begin
          if Ship.Seaman < Seaman then
            Ship.Seaman := Seaman;

//          Ship.shipCopy.Ship.Seaman := Ship.orgShipPtr^.Seaman;
        end;

        if cbEnsureMaxPower.Checked then
        begin
          for J := 1 to 24 do
          begin
            Ship.Carnons[J] := CANNON__JIANONG;
//            Ship.orgShipPtr^.Carnons[J] := CANNON__JIANONG;
          end;
          Ship.Power := MAX_POWER;
//          Ship.orgShipPtr^.Power := MAX_POWER;
        end;

//        Ship.Locked := False;
      end;
    end;

    N := ShipGrid.GetNextSibling(N);
  end;


  ShipGrid.Invalidate();
  updateShipInfo();
end;

procedure TfrmP3Editor.btnMaxShipWeaponClick(Sender: TObject);
begin
  if fCurrShip = nil then
    Exit;

//  if not fCurrShip.validateMem() then
//  begin
//    errMemFreed();
//    Exit;
//  end;


  fCurrShip.Sword := MAX_SWORD;
//  fCurrShip.orgShipPtr^.ShipWeapon := MAX_SHIP_WEAPON;
  shipWeaponChanged();
  ShipGrid.Invalidate();
  MemGrid.Invalidate();
end;

procedure TfrmP3Editor.btnMaxShiQiClick(Sender: TObject);
begin
  if fCurrShip = nil then
    Exit;

//  if not fCurrShip.validateMem() then
//  begin
//    errMemFreed();
//    Exit;
//  end;


  fCurrShip.ShiQi := MAX_SHIQI;
//  fCurrShip.orgShipPtr^.ShiQi := MAX_SHIQI;
  shiQiChanged();
  ShipGrid.Invalidate();
  MemGrid.Invalidate();
end;

procedure TfrmP3Editor.btnRefreshClick(Sender: TObject);
begin
  doRefreshSearchResult();
end;

procedure TfrmP3Editor.btnRemoveAnchorClick(Sender: TObject);
begin
  fAnchor := nil;
  MemInspectGrid.Invalidate();
end;

procedure TfrmP3Editor.btnSetSelectedGoodsQtyToClick(Sender: TObject);
begin
  if fCurrShip = nil then
    exit;

  if GoodsGrid.SelectedNode = nil then
    Exit;

  setSelectedGoodsQty(FAV_QTY);
end;

procedure TfrmP3Editor.captainChanged;
begin
  if fCurrShip <> nil then
    cbCaptain.Text := '$' + IntToHex(fCurrShip.Captain, 4)
  else
    cbCaptain.Text := '';
end;

procedure TfrmP3Editor.cbCityChange(Sender: TObject);
begin
  fDrawing := False;
  if (fCityList = nil) then
  begin
    fBusinessOffice := nil;
    Exit;
  end;



  if cbCity.ItemIndex < 0 then
    fCurrCity := nil
  else
    fCurrCity := getCityPtr(cbCity.ItemIndex);


  

  if fCurrCity = nil then
    edCityPtr.Text := ''
  else
    edCityPtr.Text :=  '$' + IntToHex(integer(fCurrCity), 8);

  updateCityPopTotal();
  updateSoldierTotal();
  CityStoreGrid.Invalidate();
  PopGrid.Invalidate();
  CityMemGrid.Invalidate();
  SoldierGrid.Invalidate();
  updateShengWang();
  updateBusinessOffice();
  updateBuildingGrid();
  updateCityTreasury();
  updateCityMemo();
end;

procedure TfrmP3Editor.cbFastForwardClick(Sender: TObject);
begin
  if finternalUpdating > 0 then
    exit;

  setFastForwarding(cbFastForward.Checked);
end;

procedure TfrmP3Editor.cbPlayerChange(Sender: TObject);
begin
  updatePlayerMoney();
  updateShengWang();
  updateBusinessOffice();
end;

//procedure TfrmP3Editor.checkShipName(mp: TMemPage; p: Pointer);
//var
//  s: string;
//  ship: PP3R2Ship;
//  shipObj: TShipObj;
//begin
//  ship := testShip(mp.P, p);
//  if ship <> nil then
//  begin
//    if fOrgShipPtrList.IndexOf(ship) < 0 then
//    begin
//      shipObj := TShipObj.Create();
//      shipObj.MemPage := mp;
//      shipObj.orgShipPtr := ship;
//      shipObj.copyShip();
//      
//      fOrgShipPtrList.Add(ship);
//      fShipList.Add(shipObj);
//
//      if fHotMemPageList.IndexOf(mp) < 0 then
//      begin
//        s := '$' + IntToHex(integer(mp.P), 8);
////        s := 'Hot page base: ' + s;
//        OutputDebugString(pchar(s));
//        fHotMemPageList.Add(mp);
//      end;
//
////      OutputDebugString('add a ship');
//    end
//    else
////      OutputDebugString('duplicate addr');
//  end;
//end;

procedure TfrmP3Editor.CityStoreGridAcceptNewText(aSender: TBaseVirtualTree;
  const aEditorWndHandle: Cardinal; aNode: PVirtualNode;
  const aColumn: TColumnIndex; aNewText: WideString; var aAccept: Boolean;
  var aErrHintTitle, aErrHintMsg: WideString);
var
  idx: Integer;
  q: integer;
begin
  aAccept := False;

  if aColumn <> 1 then
    Exit;

  if (fCityList = nil) and (fCurrCity = nil) then
    Exit;

  if not TryStrToInt(aNewText, q) then
    Exit;

  if q < 0 then
    Exit;

  idx := aSender.GetNodeUserDataInt(aNode);
  if isGoodsMeasuredInPkg(idx) then
    q := q * UNIT_PKG
  else
    q := q * UNIT_TONG;

  fCurrCity^.GoodsStore[idx] := q;
end;

procedure TfrmP3Editor.CityStoreGridDblClick(Sender: TObject);
var
  I, q: Integer;
begin
  if CityStoreGrid.FocusedColumn <> 3 then
    Exit;

  if (fCityList = nil) or (fCurrCity = nil) then
    exit;

  if CityStoreGrid.SelectedNode = nil then
    Exit;

  I := CityStoreGrid.GetNodeUserDataInt(CityStoreGrid.SelectedNode);

  if (I-1) = $06 then //香料
    Exit;

  q := GetCityOriginalProdRate(fCurrCity, I);
  if (I-1) = $0A then
  begin
    if fCurrCity^.WhaleOilProdRate < $3E8 then
      fCurrCity^.WhaleOilProdRate := $400
    else if fCurrCity^.WhaleOilProdRate < $600 then
      fCurrCity^.WhaleOilProdRate := $600
    else if fCurrCity^.WhaleOilProdRate < $800 then
      fCurrCity^.WhaleOilProdRate := $800
    else
      fCurrCity^.WhaleOilProdRate := $1000;
  end
  else
  begin
    I := GoodsIDToProdRateIndex(I);
    q := fcurrCity^.OriginalProd[I].Rate;
    if q < $384 then
      q := $400
    else if q < $600 then
      q := $600
    else if q < $800 then
      q := $800
    else
      q := $1000;


    fCurrCity^.OriginalProd[I].Rate := q;
  end;

  CityStoreGrid.Invalidate();
end;

procedure TfrmP3Editor.CityStoreGridEditing(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  Allowed := (fCityList <> nil) and (fCurrCity <> nil) and (Column = 1);
end;

procedure TfrmP3Editor.CityStoreGridGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  I: Integer;
  q: Integer;
  c: Currency;
begin
  I := Sender.GetNodeUserDataInt(Node);

  case Column of
    0: CellText := getGoodsName(I);
    
    1:
    begin
      if (fCityList = nil) or (fCurrCity = nil) then
        CellText := ''
      else
      begin
        c := fCurrCity^.GoodsStore[I];
        if isGoodsMeasuredInPkg(I) then
          c := c / UNIT_PKG
        else
          c := c / UNIT_TONG;
        CellText := FormatCurr('0.000', c);
      end;
    end;

    2:
    begin
      if (fCityList = nil) or (fCurrCity = nil) then
        CellText := ''
      else
        CellText := getGoodsUnit(I);
    end;

    3:
    begin
      if (fCityList = nil) or (fCurrCity = nil) then
        CellText := ''
      else
      begin
        q := GetCityOriginalProdRate(fCurrCity, I);
        if q = 0 then
        begin
          CellText := '';
        end
        else if (I-1) = $0A then
        begin
          if q < $3E8 then
            CellText := '*'
          else if q < $600 then
            CellText := '**'
          else if q < $800 then
            CellText := '***'
          else if q < $1000 then
            CellText := '****'
          else
            CellText := '*****';

//          CellText := CellText + ' ' + IntToHex(q, 4);
        end
        else
        begin
          if q < $384 then
            CellText := '*'
          else if q < $600 then
            CellText := '**'
          else if q < $800 then
            CellText := '***'
          else if q < $1000 then
            CellText := '****'
          else
            CellText := '*****';

//           CellText := CellText + ' ' + IntToHex(q, 4);
        end;
      end;
    end;

    4: //周消费
    begin
      if (fCityList = nil) or (fCurrCity = nil) then
        CellText := ''
      else
      begin
        q := fCurrCity^.GoodsConsumes[I];
        c := q * 7;
        if isGoodsMeasuredInPkg(I) then
          c := c / UNIT_PKG
        else
          c := c / UNIT_TONG;
        CellText := FormatCurr('0.000', c);
      end;
    end;

    5:
    begin
      if (fCityList = nil) or (fCurrCity = nil) then
        CellText := ''
      else
      begin
        c := fCurrCity^.GoodsProduct[I];
        if isGoodsMeasuredInPkg(I) then
          c := c / UNIT_PKG
        else
          c := c / UNIT_TONG;
        CellText := FormatCurr('0.000', c);
      end;
    end;

    6: //sale price
    begin
      if isGoodsMeasuredInPkg(i) then
        q := UNIT_PKG
      else
        q := UNIT_TONG;
        
      I := getCitySalePrice(q, cbCity.ItemIndex, I-1);
      if i = 0 then
        CellText := ''
      else
        CellText := IntToStr(i);
    end;

    7: //purchase price
    begin
      if isGoodsMeasuredInPkg(i) then
        q := UNIT_PKG
      else
        q := UNIT_TONG;

//      if fCurrCity^.GoodsStore[i] = 0 then
//        CellText := ''
//      else
//      begin
//        try
        I := getCityPurchasePrice(q, cbCity.ItemIndex, I-1);
        if i = 0 then
          CellText := ''
        else
          CellText := IntToStr(i);
//        except
//          CellText := 'error';
//        end;
//      end;
    end;
  end;
end;

procedure TfrmP3Editor.cityWeaponChanged;

  function  getCW(const idx: Integer): WideString;
  begin
    Result := IntToStr(fCurrShip.CityWeapons[idx] div 10);
  end;
  
begin
  if fCurrShip = nil then
  begin
    lblCW1.Caption := '';
    lblCW2.Caption := '';
    lblCW3.Caption := '';
    lblCW4.Caption := '';
  end
  else
  begin
    lblCW1.Caption := getCW(1);
    lblCW2.Caption := getCW(2);
    lblCW3.Caption := getCW(3);
    lblCW4.Caption := getCW(4);
  end;
end;

procedure TfrmP3Editor.clearShipListView;
begin
  ShipGrid.Clear();
end;

constructor TfrmP3Editor.Create(aIntf: TP3EditorIntf);
begin
  fIntf := aIntf;
  fShipList_R2 := TList.Create();
//  fOrgShipPtrList := TList.Create();
//  fMemPageList := TObjectList.Create(True);
//  fHotMemPageList := TList.Create();
  frmP3Editor := Self;
  fCurrSearchDataType := DT_TEXT;
  fSearchResult := TList.Create();
  fMap := TBitmap.Create();
  
  inherited Create (nil);
end;

procedure TfrmP3Editor.CreateParams(var aParams: TCreateParams);
begin
  inherited;
  {$IFDEF INTERNAL_WND}
    aParams.WndParent := fIntf.IN_ParentFormHandle;
//    aParams.WndParent := HWND_DESKTOP;
//    aParams.ExStyle := aParams.ExStyle or WS_EX_TOPMOST;
//    aParams.Style := aParams.Style or WS_POPUP;
  {$ENDIF}
//  aParams.
end;

destructor TfrmP3Editor.Destroy;
begin
  fDrawing := False;
  fDestroying := True;
  if Timer1 <> nil then
    Timer1.Enabled := False;
  inherited;
  frmP3Editor := nil;
  FreeAndNil(fShipList_R2);
//  FreeAndNil(fOrgShipPtrList);
//  FreeAndNil(fMemPageList);
//  FreeAndNil(fHotMemPageList);
  FreeAndNil(fIntf);
  FreeAndNil(fEvaluator);
  FreeAndNil(fSearchResult);
  FreeAndNil(fMap);
end;

procedure TfrmP3Editor.doCloseModal;
begin
  ModalResult := mrCancel;
  CloseModal();
end;

procedure TfrmP3Editor.DoRefreshCityPage;

begin
  updatePlayerMoney();
  updateGameDate();
  updateBusinessOffice();

  if not isCityListAvailable() then
  begin
    fCityList := nil;
    fCurrCity := nil;
    lblHomeCity.Caption := '';
    cbCity.ItemIndex := -1;
    cbCity.Enabled := False;
    btnGotoHomeCity.Enabled := False;
    lblPopTotal.Caption := '';
    btnCityAddQiGai.Enabled := False;
  end
  else
  begin
    fCityList := getCityListPtr();
    fHomeCity := getPlayerHomeCity(getCurrPlayerID());
    lblHomeCity.Caption := getCityName2(fHomeCity);
    cbCity.Enabled := True;
    btnGotoHomeCity.Enabled := True;
    updateCityPopTotal();
    updateSoldierTotal();
    btnCityAddQiGai.Enabled := True;
  end;

  updateCityMemo();


  if fCurrCity = nil then
    edCityPtr.Text := ''
  else
    edCityPtr.Text :=  '$' + IntToHex(integer(fCurrCity), 8);

  updateShengWang();
  lblViewPortCityCode.Caption := getCityName2(getViewPortCityCode());
  updateCityTreasury();

  CityStoreGrid.Invalidate();
  PopGrid.Invalidate();
  CityMemGrid.Invalidate();
  SoldierGrid.Invalidate();
  updateBuildingGrid();

  lblIsInSeaView.Caption := byteToHexStr(P6E2030());

  Inc(finternalUpdating);
  try
    cbFastForward.Checked := isFastForwarding();
  finally
    Dec(finternalUpdating);
  end;
end;

procedure TfrmP3Editor.doRefreshSearchResult;
//var
//  I: Integer;
//  Ship: PP3R2Ship;
//  MP: TMemPage;
//
//  procedure deleteNode();
//  var
//    N: PVirtualNode;
//    SO: TShipObj;
//  begin
//    N := ShipGrid.GetFirst();
//    while N <> nil do
//    begin
//      SO := TShipObj(ShipGrid.GetNodeUserData(N));
//
//      if SO = Ship then
//      begin
//        ShipGrid.DeleteNode(N, True);
//        Exit;
//      end;
//
//      N := ShipGrid.GetNext(N);
//    end;
//  end;
//
begin
//  OutputDebugString('doRefreshSearchResult');
  ShipGrid.Clear();
  getShipList(getCurrPlayerID(), fShipList_R2);
  loadShipsIntoGrid();
  updateShipInfo();
//  if fShipList.Count > 0 then
//  begin
//    for I := 0 to fHotMemPageList.Count - 1 do
//    begin
//      MP := TMemPage(fHotMemPageList[I]);
//      MP.validateHeapAll();
//    end;
//
//    for I := fShipList.Count - 1 downto 0 do
//    begin
//      Ship := TShipObj(fShipList[I]);
//      if not Ship.MemPage.Freed then
//      begin
//        Ship.copyShip();
//        if Ship.shipCopy.Ship.State = SHIP_STATE__KILLED then
//        begin
//          deleteNode();
//          fShipList.Delete(I); 
//        end;
//      end
//      else
//      begin
//        if Ship = fLockedShip then
//        begin
//          fLockedShip := nil;
//          fLockedShipName := '';
//        end
//        else if Ship = fCurrShip then
//        begin
//          fCurrShip := nil;
//        end;
//
//        deleteNode();
//        fShipList.Delete(I);        
//      end;
//    end;
//
//    loadShipsIntoGrid();
//    ShipGrid.Invalidate();
//    updateShipInfo();
//  end;
end;

procedure TfrmP3Editor.errBox(const aMsg: WideString);
const
  SErr: WideString = '错误';
begin
  MessageBoxW(Handle, PWideChar(aMsg), PWideChar(SErr), MB_ICONSTOP or MB_OK);
end;



procedure TfrmP3Editor.errMemFreed;
begin
//  soundBeep();
  errBox('当前船只的内存已被释放或无效。');
end;


procedure TfrmP3Editor.FormActivate(Sender: TObject);
var
  pw: PLongWord;
begin
//  OutputDebugString(pchar('activate'));
  doRefreshSearchResult();
  DoRefreshCityPage();

  if fCurrPageMP <> nil then
  begin
    if not fCurrPageMP.validateHeapAll() then
    begin
      MemInspectGrid.Clear();
      FreeAndNil(fCurrPageMP);
    end;
  end;


  pw := ptrAdd(pointer($71cda8), $0C);
  lblGameTime1.Caption := longwordToHexStr(pw^);
  pw := ptrAdd(pointer($71cda8), $14);
  lblGameTime2.Caption := longwordToHexStr(pw^);
end;

procedure TfrmP3Editor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fDrawing := False;
  ClipCursor(nil);
//  OutputDebugString('FormClose');
  {$IFDEF INTERNAL_WND}
  Action := caHide;
  {$ELSE}
  Action := caFree;
  {$ENDIF}

  PostMessage(fIntf.IN_ParentFormHandle, SetFocusMsgID, 0, 2);

  if fNoteChanged then
  begin
    Note.Lines.SaveToFile(NoteFileName);
    fNoteChanged := False;
  end;

//  EditorVisible := False;
end;

procedure TfrmP3Editor.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
//const
//  confirm: WideString = '是否要关闭编辑器？';
//  heading: WideString = '关闭';
begin
  if not fDoClose then
  begin
//    OutputDebugString('close query');
    {$ifdef INTERNAL_WND}
      fDoClose := True;
      CanClose := True;
    {$ELSE}
      SwitchToGame(fIntf.IN_ParentFormHandle);
      PostMessage(Handle, UM_CLOSE_SWITCH_TO_GAME, 0, 0);

      CanClose := False;
    {$ENDIF}
  end
  else
    CanClose := True;
end;

procedure TfrmP3Editor.FormShow(Sender: TObject);
var
  I, minP, maxP, mW, mH: Integer;
  s: string;
//  entry: TCityCodeEntry;
  Monitor: TMonitor;
begin
//  EditorVisible := True;
//  BringToFront();

//  OutputDebugString('formShow');

//  if not (fsModal in formstate) then
//    OutputDebugString('not modal state');

//  ReleaseCapture();
  Mouse.Capture := Handle;

  Monitor := Screen.MonitorFromWindow(fIntf.IN_ParentFormHandle);

  mW := Monitor.Width;
  mH := Monitor.Height;

//  OutputDebugString(pchar('mW=' + IntToStr(mW) + ', mH=' + IntToStr(mH)));

  if mW >= 1080 then
  begin
    Width := 1080;
  end
  else if Width < mW then
  begin
    Width := mW;
  end;

  Height := mH;

//  if Screen.Height >= 750 then
//    Height := 750
//  else if Height < Screen.Height then
//    Height := Screen.Height;

  Left := (mW - Width) div 2;
  Top := (mH - Height) div 2;


  if not fInited then
  begin
    mp_func(s);
    Caption := 'P3Ed - R1 - 记得先改船名 - by ' + s;

    lblCurrPageBase.Caption := '';

//    {$IFDEF INTERNAL_WND}
//    btnBackToGame.Visible := False;
//    {$ENDIF}
    if FileExists(NoteFileName) then
    begin
      try
        Note.Lines.LoadFromFile(NoteFileName);
      except
      end;
      fNoteChanged := False;
    end;
    
    minP := integer(FAV_START_ADDR);
    maxP := integer(FAV_END_ADDR);

    fMap.Width := PaintBox1.Width;
    fMap.Height := PaintBox1.Height;

    pcMain.ActivePageIndex := 0;
    PageControl1.ActivePageIndex := 0;

//    btnMaxCaptain.Caption := '$' + IntToHex(FAV_CAPTAIN, 4);
    btnSetAllGoodsQtyTo.Caption := '全部' + IntToStr(FAV_QTY) + '包';
    btnSetSelectedGoodsQtyTo.Caption := '该选中为' + IntToStr(FAV_QTY) + '包';
    edGoodsQty.Text := IntToStr(FAV_QTY);
    btnFillCityWeapon.Caption := '全部' + IntToStr(FAV_CITY_WEAPON div 10);

    cbCaptain.Items.Add('$FFFF');
    edCalcResult.Text := '';

    for I := $00 to $3F do
    begin
      cbCaptain.Items.Add('$' + IntToHex(I, 4));
    end;

    btnFavCaptain.Caption := '$' + IntToHex(FAV_CAPTAIN, 4);

  //  if maxP > ADDR_HI then
  //    maxP := ADDR_HI;

//    edAddrFrom.Text := '$' + IntToHex(minP, 8);
//    edAddrTo.Text := '$' + IntToHex(maxP, 8);

    ShipGrid.NodeDataSize := SizeOf(Pointer);
    GoodsGrid.NodeDataSize := sizeof(pointer);
    MemInspectGrid.NodeDataSize := sizeof(pointer);
    MemGrid.NodeDataSize := SizeOf(Pointer);

    CityStoreGrid.NodeDataSize := sizeof(pointer);
    CityMemGrid.NodeDataSize := sizeof(pointer);
    PopGrid.NodeDataSize := sizeof(pointer);

    SoldierGrid.NodeDataSize := sizeof(pointer);
    BuildingGrid.NodeDataSize := sizeof(pointer);
    BuildingGrid.DefaultText := '';

    initBusinessOfficeGrid();

    for I := 0 to 3 do
    begin
      PopGrid.AddChild(nil, pointer(i));
    end;

    for I := 0 to 3 do
      SoldierGrid.AddChild(nil, Pointer(i));

    for I := 1 to 20 do
      CityStoreGrid.AddChild(nil, pointer(i));

    for I := 1 to 20 do
    begin
      GoodsGrid.AddChild(nil, Pointer(I));
    end;

    for I := 0 to 27-1 do
    begin
      MemGrid.AddChild(nil, Pointer(I));
    end;

    for I := 0 to getCurrPlayerID() do
      cbPlayer.Items.Add('Player ' + IntToStr(i));

    RadioGroup1.Items.Clear();
    getCityNames(RadioGroup1.Items, True);
    getCityNames(cbCity.Items, True);
//    for I := 0 to MAX_CITY_CODE do
//    begin
//      entry := CityCodeEntries[I];
//      if entry <> nil then
//      begin
//        s := '$' + IntToHex(I, 2) + ' ' + entry.CityName;
//        cbCity.Items.Add(s);
//        RadioGroup1.Items.Add(s);
//      end;
//    end;


    lblHomeCity.Caption := '';

    cbDumpSize.Items.Add(inttostr(sizeof(tcitystruct)));
    cbDumpSize.Items.Add(inttostr(playerdatasize));
    cbDumpSize.Items.Add(inttostr(32*1024));
    cbDumpSize.Items.Add(inttostr(64*1024));
    cbDumpSize.Items.Add(inttostr(128*1024));


    fInited := True;
  end;

  updateShipInfo();
  PostMessage(Handle, UM_SET_FOCUS, 0, 0);
end;

function TfrmP3Editor.getColor(off: Integer): TColor;
begin
  if off < 0 then
    Result := COLOR_UNKNOWN
  else if off >= SizeOf(Tp3r2ship) then
    Result := COLOR_UNKNOWN
  else
    Result := getOffsetColor(off);
end;



function TfrmP3Editor.getMemInspaceGridOff(const aRow,
  aColumn: Integer): Integer;
begin
  if fCurrPageMP = nil then
    Result := 0
  else if aColumn = 0 then
    Result := Integer(fCurrPageMP.P) + aRow * 16
  else
  begin
    Result := Integer(fCurrPageMP.P) + aRow * 16 + aColumn - 1;
  end;
end;

function TfrmP3Editor.getMemInspaceGridOff(const N: PVirtualNode;
  const aColumn: Integer): Integer;
begin
  Result := getMemInspaceGridOff(MemInspectGrid.GetNodeUserDataInt(N), aColumn);
end;

function TfrmP3Editor.getMemOffset(ship: PP3R2Ship; const row,
  col: Integer): Integer;
begin
  Result := getMemRowOffset(ship, row) + col;
end;

function TfrmP3Editor.getMemRowOffset(ship: PP3R2Ship;
  const row: Integer): Integer;
var
  off: Integer;
begin
  off := Integer(ship);
  Result := integer(off and $FFFFFFF0) - 16 + row * 16;
end;

function TfrmP3Editor.getSelectedPlayerID: Byte;
begin
  if cbPlayer.ItemIndex <= 0 then
    Result := getCurrPlayerID()
  else
    Result := cbPlayer.ItemIndex - 1;
end;

function TfrmP3Editor.getShipMemGridSelectedLongword: Cardinal;
var
  row, offset, delta: Integer;
  plw: PLongWord;
begin
  Result := 0;
  
  if MemGrid.SelectedNode = nil then
    Exit;

  row := MemGrid.GetNodeUserDataInt(MemGrid.SelectedNode);

  offset := getMemOffset(fCurrShip, row, MemGrid.FocusedColumn-1);
  delta := offset - integer(fCurrShip);

  offset := integer(fCurrShip);
  Inc(offset, delta);

  plw := pointer(offset);
  Result := plw^;
end;

procedure TfrmP3Editor.GoodsGridGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  goods: Integer;
  q: Integer;
begin
  goods := Sender.GetNodeUserDataInt(Node);

  case Column of
    0:
    begin
      CellText := getGoodsName(goods);
    end;

    1:
    begin
      CellText := getGoodsUnit(goods);
    end;

    2:
    begin
      if fCurrShip = nil then
        CellText := ''
      else
      begin
        q := fCurrShip.goods[goods];
        if isGoodsMeasuredInPkg(goods) then
          q := q div 2000
        else
          q := q div 200;

        CellText := IntToStr(q);
      end;
    end;
  end;
end;

procedure TfrmP3Editor.initBusinessOfficeGrid;
var
  I: Integer;
begin
  BusinessOfficeGrid.NodeDataSize := sizeof(pointer);
  BusinessOfficeGrid.DefaultText := '';

  BusinessOfficeG2.NodeDataSize := sizeof(pointer);
  BusinessOfficeG2.DefaultText := '';

  for I := 1 to 20 do
  begin
    BusinessOfficeGrid.AddChild(nil, pointer(i));  
  end;

  for i := BOINFOFIRST to BOINFOLAST do
    BusinessOfficeG2.AddChild(NIL, POINTER(I));
end;

procedure TfrmP3Editor.internalSetShipName(S: string);
begin
  if fCurrShip = nil then
  begin
//    OutputDebugString('---3.5');
    soundBeep();
    Exit;
  end;

//  if not fCurrShip.validateMem() then
//  begin
////    OutputDebugString('---4');
//    errMemFreed();
//    Exit;
//  end;

  p3setShipName_R2(fCurrShip, S);
//  p3setShipName(fCurrShip.orgShipPtr, S);

  ShipGrid.Invalidate();
//  edShipName.Text := getShipName(@fCurrShip.shipCopy.Ship);

end;

procedure TfrmP3Editor.intStrErr();
begin
  soundBeep();
//  errBox('"' + S + '"不是有效整数。');
end;

procedure TfrmP3Editor.ListBox1DblClick(Sender: TObject);
var
  ptr: PByte;
  mp: TMemPage;
begin
  if ListBox1.ItemIndex < 0 then
    Exit;

  ptr := pointer(strtoint(ListBox1.Items[listbox1.itemindex]));

  case rgCityAddrDelta.ItemIndex of
    1: Inc(ptr, $2cc);
    2: Inc(ptr, $848);
  end;

  mp := QueryMemPageEx(GetCurrentProcess(), ptr, True);
  if mp = nil then
  begin
    OutputDebugString('err-2');
    soundBeep();
    Exit;
  end;

  memInspectorUpdateCurrPage(mp);
  PostMessage(Handle, UM_GOTO_MEM_PTR, 0, integer(ptr));
end;

procedure TfrmP3Editor.ListBox2DblClick(Sender: TObject);
var
  ptr: PByte;
  mp: TMemPage;
begin
  if ListBox2.ItemIndex < 0 then
    Exit;

  ptr := pointer(strtoint(ListBox2.Items[listbox2.itemindex]));

  mp := QueryMemPageEx(GetCurrentProcess(), ptr, True);
  if mp = nil then
  begin
    OutputDebugString('err-2');
    soundBeep();
    Exit;
  end;

  memInspectorUpdateCurrPage(mp);
  PostMessage(Handle, UM_GOTO_MEM_PTR, 0, integer(ptr));
end;

procedure TfrmP3Editor.loadShipsIntoGrid;
var
  I: Integer;
  N: PVirtualNode;
  Ship: PP3R2Ship;
begin
  ShipGrid.BeginUpdate();
  try
    ShipGrid.Clear();
  
    for I := 0 to fShipList_R2.Count - 1 do
    begin
      ship := fShipList_R2[I];
      if Ship.State = SHIP_STATE__KILLED then
        Continue;

      case TabControl1.TabIndex of
        1:
        begin
          if Ship.IsTrading = 0 then
            Continue;
        end;

        2:
        begin
          if Ship.IsTrading <> 0 then
            Continue;

          if Ship.State in [SHIP_STATE__FIX, SHIP_STATE__REMOTE_TRADING, SHIP_STATE__PIRATE] then
            Continue;
        end;

        3:
        begin
          if Ship.IsTrading <> 0 then
            Continue;

          if not (Ship.State in [SHIP_STATE__FIX, SHIP_STATE__REMOTE_TRADING, SHIP_STATE__PIRATE]) then
            Continue;
        end;
      end;
    
      if (fLockedShip = nil)
      and (fLockedShipName <> '')
      and (getShipName_R2(ship) = fLockedShipName) then
        fLockedShip := ship;

      N := ShipGrid.AddChild(nil, ship);
      ShipGrid.CheckType[N] := ctCheckBox;
      ShipGrid.CheckState[N] := csUncheckedNormal;
    end;
  finally
    ShipGrid.EndUpdate();
  end;
end;

procedure TfrmP3Editor.maxLoadChanged;
var
  tong: Integer;
begin
  if fCurrShip = nil then
    edLoadLimit.Text := ''
  else
  begin
    tong := fCurrShip.LoadUpLimit;
    tong := tong div UNIT_TONG;
    edLoadLimit.Text := IntToStr(tong);
  end;
end;

procedure TfrmP3Editor.MemGridBeforeCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellRect: TRect);
var
  row, off, delta: Integer;
  clr: TColor;
begin
  if (fCurrShip = nil) or (Column = 0) then
    clr := clWindow
  else
  begin
    row := Sender.GetNodeUserDataInt(Node);
    off := getMemOffset(fCurrShip, row, Column -1);

    delta := off - Integer(fCurrShip);
    clr := getColor(delta);
  end;

  TargetCanvas.Brush.Color := clr;
  TargetCanvas.FillRect(CellRect);
end;

procedure TfrmP3Editor.MemGridChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  updateMemContent();
end;

procedure TfrmP3Editor.MemGridFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  updateMemContent();
end;

procedure TfrmP3Editor.MemGridGetSelectionBkColor(aSender: TBaseVirtualTree;
  aNode: PVirtualNode; const aColumn: Integer; const aFocused: Boolean;
  var aColor: TColor);
var
  row, off, delta: Integer;
begin
  if (fCurrShip = nil) or (aColumn = 0) then
    aColor := clWindow
  else
  begin
    row := aSender.GetNodeUserDataInt(aNode);
    off := getMemOffset(fCurrShip, row, aColumn -1);

    delta := off - Integer(fCurrShip);
    aColor := getColor(delta);
  end;
end;

procedure TfrmP3Editor.MemGridGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  r, off, delta: Integer;
  p: PByte;
begin
  if fCurrShip = nil then
  begin
    CellText := '';
    Exit;
  end;


  r := Sender.GetNodeUserDataInt(Node);

  if Column = 0 then
  begin
    off := getMemRowOffset(fCurrShip, r);
    CellText := '$' + IntToHex(off, 8);
    Exit;
  end;

  off := getMemOffset(fCurrShip, r, Column-1);
  delta := off - Integer(fCurrShip);

  Assert(delta >= -30);

  p := pointer(fCurrShip);
  Inc(p, delta);

//  OutputDebugString(pchar('offset=' + IntToHex(off, 8)));

//  p := Pointer(off);

  CellText := IntToHex(p^, 2);

//  OutputDebugStringW(PWideChar(CellText));
end;

procedure TfrmP3Editor.MemGridPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
//var
//  delta: Integer;
//  p: Pointer;
begin
  if Sender.Selected[Node] and ((Column = Sender.FocusedColumn)or (Column = 0)) then
    TargetCanvas.Font.Style := [fsBold]
  else
    TargetCanvas.Font.Style := [];
////  TargetCanvas.Font.Color := clWindowText;
//
//  if (fCurrShip = nil) or (Column = 0) then
//    Exit;
//
//  row := Sender.GetNodeUserDataInt(Node);
//  off := getMemOffset(fCurrShip, row, Column-1);
//
//  delta := off - Integer(fCurrShip);
////  TargetCanvas.Font.Color := getColor(delta);
//  if delta = 0 then
//    TargetCanvas.Font.Style := [fsBold];
end;

procedure TfrmP3Editor.MemInspectGridAcceptNewText(aSender: TBaseVirtualTree;
  const aEditorWndHandle: Cardinal; aNode: PVirtualNode;
  const aColumn: TColumnIndex; aNewText: WideString; var aAccept: Boolean;
  var aErrHintTitle, aErrHintMsg: WideString);
var
  i: Integer;
  s: Shortint;
  b: Byte;
  off: PByte;
begin
  aAccept := (aColumn > 0)
            and (Length(aNewText) = 2)
            and TryStrToInt('$' + aNewText, I);
            
  if aAccept then
  begin
    if i < 0 then
    begin
      s := i;
      b := s;
    end
    else
      b := i;

    off := pointer(getMemInspaceGridOff(aNode, aColumn));
    if off^ <> b then
      off^ := b;
  end;
end;

procedure TfrmP3Editor.MemInspectGridChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  updateMemInspValues();
end;

procedure TfrmP3Editor.MemInspectGridFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  updateMemInspValues();
end;

procedure TfrmP3Editor.MemInspectGridGetHighlightTextColor(
  aSender: TBaseVirtualTree; aNode: PVirtualNode; const aStaticText: Boolean;
  const aColumn: Integer; var aColor: TColor);
begin
  aColor := clWindowText;
end;

procedure TfrmP3Editor.MemInspectGridGetSelectionBkColor(
  aSender: TBaseVirtualTree; aNode: PVirtualNode; const aColumn: Integer;
  const aFocused: Boolean; var aColor: TColor);
begin
  case aColumn of
    1..4, 9..12:
      aColor := $00E7E7E7;
  else
    aColor := clWhite;
  end;
end;

procedure TfrmP3Editor.MemInspectGridGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
//  off: Integer;
  offset: pbyte;
begin
  if fCurrPageMP = nil then
  begin
    CellText := '';
    Exit;
  end;
  
  offset := pointer(getMemInspaceGridOff(Node, Column));
//  Inc(off, integer(fCurrPageMP.P));

  if Column = 0 then
  begin
    CellText := '$' + IntToHex(integer(offset), 8);
  end
  else
  begin
    try
      CellText := IntToHex(offset^, 2);
    except
      CellText := '00';
    end;
  end;
end;

procedure TfrmP3Editor.MemInspectGridPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  offset: pByte;
  fs: TFontStyles;
begin
  fs := [];
  
  if (Column > 0) and (fCurrPageMP <> nil) and (fAnchor <> nil) then
  begin
    offset := pointer(getMemInspaceGridOff(Node, Column));
    if cardinal(offset) >= cardinal(fAnchor) then
      Include(fs, fsUnderline);
  end;
  
  if Sender.Selected[Node] and ((Column = Sender.FocusedColumn) or (Column = 0)) then
    Include(fs, fsBold);

  TargetCanvas.Font.Style := fs;
end;

procedure TfrmP3Editor.memInspectorUpdateCurrPage(aMP: TMemPage);
var
  I, Cnt: Integer;
begin
  fAnchor := nil;
  MemInspectGrid.BeginUpdate();
  try
    MemInspectGrid.Clear();

    FreeAndNil(fCurrPageMP);
    fCurrPageMP := aMP;

    Cnt := aMP.Size div 16;
    for I := 0 to Cnt - 1 do
    begin
      MemInspectGrid.AddChild(nil, Pointer(I));
    end;

    lblCurrPageBase.Caption := '$' + IntToHex(integer(aMP.P), 8);
    lblCurrPageSize.Caption := getPageSizeText(aMP.Size);
  finally
    MemInspectGrid.EndUpdate();
  end;
end;

function TfrmP3Editor.memInspGetSelectedPtr: Pointer;
begin
  Result := nil;
  if (fCurrPageMP = nil)
  or (MemInspectGrid.SelectedNode = nil)
  or (MemInspectGrid.FocusedColumn < 0) then
    Exit;

  Result := pointer(getMemInspaceGridOff(MemInspectGrid.SelectedNode, MemInspectGrid.FocusedColumn));
end;

function TfrmP3Editor.memInspHasSelectedPtr: Boolean;
begin
  Result := (fCurrPageMP <> nil) and (MemInspectGrid.SelectedNode <> nil) and (MemInspectGrid.FocusedColumn >= 0);
end;

procedure TfrmP3Editor.memValueDblClick(Sender: TObject);
begin
  fNonSignaled := not fNonSignaled;
  updateMemContent();
end;

procedure TfrmP3Editor.miCheckAllClick(Sender: TObject);
var
  N: PVirtualNode;
begin
  N := ShipGrid.GetFirst();
  while N <> nil do
  begin
    ShipGrid.CheckState[N] := csCheckedNormal;

    N := ShipGrid.GetNextSibling(N);
  end;
end;

procedure TfrmP3Editor.miClearCheckedClick(Sender: TObject);
var
  N: PVirtualNode;
begin
  N := ShipGrid.GetFirst();
  while N <> nil do
  begin
    ShipGrid.CheckState[N] := csUncheckedNormal;

    N := ShipGrid.GetNextSibling(N);
  end;
end;

procedure TfrmP3Editor.miMemInspGotoAddrClick(Sender: TObject);
var
  off: Integer;
//  u_d: PDWORD;
  ptr: pointer;
  mp: TMemPage;
begin
  if (MemInspectGrid.SelectedNode = nil)
  or (MemInspectGrid.FocusedColumn < 0) then
  begin
    soundBeep();
    Exit;
  end;

  if fCurrPageMP = nil then
  begin
    soundBeep();
    Exit;
  end;
  
  off := getMemInspaceGridOff(MemInspectGrid.SelectedNode, MemInspectGrid.FocusedColumn);
  if off = 0 then
  begin
    soundBeep();
    exit;
  end;

  ptr := pointer(off);

  mp := QueryMemPageEx(GetCurrentProcess(), ptr);
  if mp = nil then
  begin
    soundBeep();
    Exit;
  end;

  memInspectorUpdateCurrPage(mp);
  PostMessage(Handle, UM_GOTO_MEM_PTR, 0, integer(ptr));
end;

procedure TfrmP3Editor.miShipMemGridGotoAddressClick(Sender: TObject);
var
  ptr: Pointer;
  mp: TMemPage;
begin
  if fCurrShip = nil then
  begin
    soundBeep();
    Exit;
  end;

  ptr := pointer(getShipMemGridSelectedLongword());
  if ptr = nil then
  begin
//    OutputDebugString('err-1');
    soundBeep();
    Exit;
  end;

  mp := QueryMemPageEx(GetCurrentProcess(), ptr);
  if mp = nil then
  begin
//    OutputDebugString('err-2');
    soundBeep();
    Exit;
  end;

  pcMain.ActivePageIndex := 1;
  memInspectorUpdateCurrPage(mp);
  PostMessage(Handle, UM_GOTO_MEM_PTR, 0, integer(ptr));
end;

procedure TfrmP3Editor.miToggleCheckedClick(Sender: TObject);
var
  N: PVirtualNode;
begin
  N := ShipGrid.GetFirst();
  while N <> nil do
  begin
    if ShipGrid.CheckState[N] in [csCheckedNormal, csCheckedPressed] then
      ShipGrid.CheckState[N] := csUncheckedNormal
    else
      ShipGrid.CheckState[N] := csCheckedNormal;

    N := ShipGrid.GetNextSibling(N);
  end;
end;

procedure TfrmP3Editor.NoteChange(Sender: TObject);
begin
  fNoteChanged := True;
end;

procedure TfrmP3Editor.OnUM_CLOSE(var aMsg: TMessage);
begin
  if aMsg.LParam > 0 then
  begin
    ModalResult := mrCancel;
    PostMessage(Handle, UM_CLOSE, 0, aMsg.LParam-1);
    Exit;
  end;

  fDoClose := True;
  Hide();
//  PostMessage(Handle, )
end;

procedure TfrmP3Editor.OnUM_CLOSE_SWITCH_TO_GAME(var aMsg: TMessage);
begin
  Hide();
//  AxSetForegroundWindow98(fIntf.IN_ParentFormHandle, nil);
  PostMessage(Handle, UM_CLOSE, 0, 0);
end;

procedure TfrmP3Editor.OnUM_DO_REFRESH(var aMsg: TMessage);
begin
  doRefreshSearchResult();
  DoRefreshCityPage();
end;

procedure TfrmP3Editor.OnUM_GOTO_MEM_PTR(var aMsg: TMessage);
var
  np, coloff: Integer;
  row: Integer;
  N: PVirtualNode;
begin
  if fCurrPageMP = nil then
    Exit;

  np := aMsg.LParam;
  row := (np - integer(fCurrPageMP.P)) div 16;
  coloff := np and $0f + 1;



  N := MemInspectGrid.GetFirst();
  if N = nil then
  begin
    soundBeep();
    Exit;
  end;

//  Inc(row);

  while row > 0 do
  begin  
    Dec(row);

    N := MemInspectGrid.GetNextSibling(N);
  end;

  MemInspectGrid.SelectNode(N);
  MemInspectGrid.ScrollIntoView(N, True, False);
  MemInspectGrid.FocusedNode := N;
  MemInspectGrid.FocusedColumn := coloff;
end;

procedure TfrmP3Editor.OnUM_SET_FOCUS(var aMsg: TMessage);
var
  Pt: TPoint;
  r: TRect;
//  w, h: Integer;

  procedure m(const aFlag: DWORD);
  begin
    mouse_event(MOUSEEVENTF_ABSOLUTE or aFlag, Pt.X, Pt.Y, 0, 0);
  end;

begin
  if Visible then
  begin
//    SwitchToGame(Handle);
    SetForegroundWindow(Handle);
    Mouse.Capture := Handle;

    SetFocus();

    r := ClientRect;

    r.TopLeft := ClientToScreen(r.TopLeft);
    r.BottomRight := ClientToScreen(r.BottomRight);

//    GetWindowRect(Handle, r);


//    w := ClientWidth;
//    h := ClientHeight;
//
//    Pt.X := 0;
//    Pt.Y := 0;
//
//    Pt := ClientToScreen(Pt);
//    r.TopLeft := Pt;
//    r.Right := r.Left + w ;
//    r.Bottom := r.Top + h;
    ClipCursor(@r);

//    GetSystemMetrics()

//    OutputDebugString(pchar('pt.x=' + IntToStr(Pt.X) + ', pt.y=' + IntToStr(Pt.Y)));


//    ClipCursor(nil);

    Pt.X := ClientWidth div 2;
    Pt.Y := ClientHeight div 2;

    Pt := ClientToScreen(Pt);

    if not SetCursorPos(Pt.X, Pt.Y) then
    begin
      OutputDebugString(pchar('SetCursorPos error: ' + IntToStr(GetLastError())));
    end;



    m(MOUSEEVENTF_MOVE);
    m(MOUSEEVENTF_LEFTDOWN);
    m(MOUSEEVENTF_LEFTUP);

//    ClipCursor(nil);
    PostMessage(Handle, UM_SHOW_CURSOR, Pt.X, Pt.Y);
  end;
end;

procedure TfrmP3Editor.OnUM_SHOW_CURSOR(var aMsg: TMessage);

  procedure m(const aFlag: DWORD);
  begin
    mouse_event(MOUSEEVENTF_ABSOLUTE or aFlag, aMsg.WParam, aMsg.LParam, 0, 0);
  end;

begin
  windows.SetFocus(handle);
    m(MOUSEEVENTF_MOVE);
    m(MOUSEEVENTF_LEFTDOWN);
    m(MOUSEEVENTF_LEFTUP);
  ShowCursor(True);
  ShowCursor(False);
  ShowCursor(True);
end;

procedure TfrmP3Editor.PaintBox1Paint(Sender: TObject);
begin
  if fMap <> nil then
    PaintBox1.Canvas.Draw(0, 0, fMap);
end;

procedure TfrmP3Editor.PopGridAcceptNewText(aSender: TBaseVirtualTree;
  const aEditorWndHandle: Cardinal; aNode: PVirtualNode;
  const aColumn: TColumnIndex; aNewText: WideString; var aAccept: Boolean;
  var aErrHintTitle, aErrHintMsg: WideString);
var
  idx: Integer;
  q: integer;
begin
  aAccept := False;

  if (aColumn <> 1) and (aColumn <> 3) then
    Exit;

  if (fCityList = nil) and (fCurrCity = nil) then
    Exit;

  if not TryStrToInt(aNewText, q) then
  begin
    soundBeep();
    Exit;
  end;

  if aColumn = 1 then
  begin
    if q < 0 then
    begin
      soundBeep();
      Exit;
    end;
  end;

  idx := aSender.GetNodeUserDataInt(aNode);

  if aColumn = 1 then
  begin
    case idx of
      0: fCurrCity^.Pop_rich := q;
      1: fCurrCity^.Pop_common:= q;
      2: fCurrCity^.Pop_poor := q;
      3: fCurrCity^.Pop_begger := q;
    end;

    reCalcCityPopTotal(fCurrCity);
    updateCityPopTotal();
  end
  else
  begin
    case idx of
      0: fCurrCity^.Satisfy_rich := q;
      1: fCurrCity^.Satisfy_common := q;
      2: fCurrCity^.Satisfy_poor := q;
      3: fCurrCity^.Satisfy_begger := q;   
    end;
  end;

  aSender.Invalidate();

  aAccept := True;
end;

procedure TfrmP3Editor.PopGridGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  idx, v, v2: Integer;
  c: Currency;
begin
  idx := Sender.GetNodeUserDataInt(Node);

  case Column of
    0:
    begin
      case idx of
        0: CellText := '富豪';
        1: CellText := '富人';
        2: CellText := '百姓';
        3: CellText := '乞丐';
      else
        CellText := '?';
      end;
    end;

    1:
    begin
      if fCurrCity = nil then
        CellText := ''
      else
      begin
        case idx of
          0: v := fCurrCity^.Pop_rich;
          1: v := fCurrCity^.Pop_common;
          2: v := fCurrCity^.Pop_poor;
          3: v := fCurrCity^.Pop_begger;
        else
          Exit;
        end;

        CellText := IntToStr(v);
      end;
    end;

    2:
    begin
      if (fCurrCity = nil) or (idx >= 3) then
        CellText := ''
      else
      begin
        v := fCurrCity^.Pop_rich + fCurrCity^.Pop_common + fCurrCity^.Pop_poor;
        case idx of
          0: v2 := fCurrCity^.Pop_rich;
          1: v2 := fcurrCity^.Pop_common;
          2: v2 := fCurrCity^.Pop_poor;
        else
          CellText := '';
          v2 := 0;
          Exit;
        end;

        c := v2 * 100;
        c := c / v;

        CellText := FormatCurr('0.00', c);
      end;
    end;

    3:
    begin
      if (fCurrCity = nil) then
        CellText := ''
      else
      begin
        case idx of
          0: v := fCurrCity^.Satisfy_rich;
          1: v := fcurrCity^.Satisfy_common;
          2: v := fcurrcity^.Satisfy_poor;
          3: v := fCurrCity^.Satisfy_begger;
        else
          v := 0;
        end;

        CellText := IntToStr(v);
      end;
    end;
  end;
end;

procedure TfrmP3Editor.rbSignaledClick(Sender: TObject);
begin
  updateMemInspValues();
end;

procedure TfrmP3Editor.rbUnsignaledClick(Sender: TObject);
begin
  updateMemInspValues();
end;

procedure TfrmP3Editor.rgConvertDWSingle1Click(Sender: TObject);
begin
  updateShengWang();
end;

procedure TfrmP3Editor.routeInfoChanged;
var
  i, gid, price, q: Integer;
  p: PTradeRoute;
  s: string;

  procedure addI(const name: string; i: Integer);
  begin
    memTradeRoute.Lines.Add(name + ': ' + IntToStr(i));
  end;

  procedure addS(const name: string; s: string);
  begin
    memTradeRoute.Lines.Add(name + ': ' + s);
  end;

  procedure addHex(const name: string; const dw: LongWord);
  begin
    memTradeRoute.Lines.Add(name + ': ' + longwordToHexStr(dw));
  end;

var
  idx, loop: Integer;
  trindices: TTradeRouteIndices;
begin
  memTradeRoute.Lines.Clear();
  if fCurrShip = nil then
    Exit;

  memTradeRoute.Lines.BeginUpdate();
  try
  idx := fcurrShip^.TradingIndex;
  memTradeRoute.Lines.Add('Trading index = ' + wordToHexStr(idx));


  if tradeRoute_getIndices(fCurrShip, trindices) = 0 then
  begin
    memTradeRoute.Lines.Add('Trading index = $FFFF');
    Exit;
  end;

  try
    for loop := 1 to trindices.Count do
    begin
      idx := trindices.indices[loop];

      p := getTradeRoute(idx);
      addHex('Pointer: ', longword(p));
      addI('index1', idx);
      addI('Index', indexOfTradeRoute(p));

      addI('NextIndex', p^.NextIndex);
      addS('City', getCityName2(p^.CityCode));
      addS('Flags: ', byteToHexStr(p^.Flags));
      if (p^.Flags and TRADE_ROUTE_FLAG__FIRST) <> 0 then
        addS('First', 'True')
      else
        addS('First', 'False');
      if (p^.Flags and TRADE_ROUTE_FLAG__NO_STOP) <> 0 then
        addS('Options', '不靠港');
      if (p^.Flags and TRADE_ROUTE_FLAG__FIX) <> 0 then
        addS('Options', '靠港修理');

      memTradeRoute.Lines.Add('');

      for I := 1 to 20 do
      begin
        gid := p^.Orders[I] + 1;

        addS('Good name ' + IntToStr(I), getGoodsName(gid));

        gid := gid;
        addI('goods id', gid);

        price := p^.Prices[gid];
        q := p^.MaxQty[gid];
        if price = 0 then
        begin
          if q < 0 then
          begin
            q := -q;
            s := '入仓';
          end
          else
            s := '出仓';
        end
        else if price < 0 then
        begin
          price := -price;
          s := '买入';
        end
        else
          s := '销售';

        addS('Type', s);
        Addi('Price', price);


        if q = 1000000000  then
          s := 'Max'
        else
          s := IntToStr(q);
        Adds('MaxQty', s);
        memTradeRoute.Lines.Add('');
      end;
    end;
  except
    memTradeRoute.Lines.Add('Error');
  end;
  finally
    memTradeRoute.Lines.EndUpdate();
  end;
end;

//procedure TfrmP3Editor.OnWMActivate(var aMsg: TMessage);
//begin
//  if aMsg.WParam = WA_INACTIVE then
//  begin
//    Close();
//    aMsg.Result := 0;
//    Exit;
//  end;
//
//  if (FormStyle <> fsMDIForm) or (csDesigning in ComponentState) then
//    SetActive(Message.Active <> WA_INACTIVE);
//
//  inherited OnWMActivate(amsg);
//end;

procedure TfrmP3Editor.setSelectedGoodsQty(const factor: Integer);
var
  N: PVirtualNode;
  goods, q, t: Cardinal;
  I: Integer;
begin
  if fCurrShip = nil then
    Exit;

  if GoodsGrid.SelectedNode = nil then
    Exit;

//  if not fCurrShip.validateMem() then
//  begin
//    errMemFreed();
//    Exit;
//  end;

  t := 0;

  N := GoodsGrid.GetFirstSelected();
  while N <> nil do
  begin
    goods := GoodsGrid.GetNodeUserDataInt(N);
//    if isGoodsMeasuredInPkg(goods) then
//      q := 2000
//    else
//      q := 200;

    q := factor * UNIT_PKG;
    Inc(t, q);
    
    fCurrShip.Goods[goods] := q;
//    fCurrShip.orgShipPtr^.Goods[goods] := q;

    N := GoodsGrid.GetNextSelected(N);
  end;

  for I := 1 to 4 do
  begin
    t := t + fCurrShip.CityWeapons[I];
  end;



  fCurrShip.GoodsLoad := t;
//  fCurrShip.shipCopy.Ship.GoodsLoad := t;
  totalLoadChanged();

  GoodsGrid.Invalidate();
  ShipGrid.Invalidate();
  MemGrid.Invalidate();
end;

procedure TfrmP3Editor.shipClassChanged;
begin
  if fCurrShip = nil then
  begin
    cbShipType.ItemIndex := -1;
    cbShipLevel.ItemIndex := -1;
  end
  else
  begin
    if isValidShipType(fCurrShip.ShipType) then
      cbShipType.ItemIndex := fCurrShip.ShipType
    else
      cbShipType.ItemIndex := -1;

    if isValidShipUgLvl(fCurrShip.ShipUgLvl) then
      cbShipLevel.ItemIndex := fCurrShip.ShipUgLvl
    else
      cbShipLevel.ItemIndex := -1;
  end;
end;

procedure TfrmP3Editor.ShipGridChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  if Node = nil then
    fCurrShip := nil
  else
    fCurrShip := Sender.GetNodeUserData(Node);

  updateShipInfo();
end;

procedure TfrmP3Editor.ShipGridCompareNodes(Sender: TBaseVirtualTree; Node1,
  Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  s1, s2: PP3R2Ship;
begin
  s1 := Sender.GetNodeUserData(Node1);
  s2 := Sender.GetNodeUserData(Node2);

  case Column of
    0:
    begin
      Result := CompareStr(getShipName_R2(s1), getShipName_R2(s2));
    end;

    1:
    begin
      Result := IntCompare(indexOfShip(s1), indexOfShip(s2));
    end;  
  end;
end;

procedure TfrmP3Editor.ShipGridGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  ShipObj: PP3R2Ship;
begin
  ImageIndex := -1;

  if (Kind = ikNormal) or (Kind = ikSelected) then
  begin
    if (Column = 0) then
    begin
      ShipObj := Sender.GetNodeUserData(Node);
      if ShipObj = fLockedShip then
        ImageIndex := 0
      else if ShipObj.IsTrading <> 0 then
        ImageIndex := 1
      else if ShipObj.State = SHIP_STATE__REMOTE_TRADING then
        ImageIndex := 2
      else if ShipObj.State = SHIP_STATE__PIRATE then
        ImageIndex := 3
      else if ShipObj.State = SHIP_STATE__FIX then
        ImageIndex := 4;
    end;
  end;
end;

procedure TfrmP3Editor.ShipGridGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  ship: PP3R2Ship;
begin
  ship := Sender.GetNodeUserData(Node);

  case Column of
    0:
    begin
      CellText := getShipName_R2(ship);
      if ship^.State = SHIP_STATE__BUILDING then
      begin
        if ship^.CurrPoint = 0 then
          CellText := CellText + '(计划建造中)'
        else
          CellText := CellText + '(建造中)';
      end;
    end;

    1:
    begin
      CellText := IntToStr(indexOfShip(ship));
    end;

    2:
    begin
      CellText := getShipTypeAndLvlText_R2(ship);
    end;

    3:
    begin
      if (ship^.State = SHIP_STATE__BUILDING) and (ship.CurrPoint = 0) then
        CellText := '---'
      else
        CellText := FormatCurr('0%', ship.CurrPoint * 100 / ship.MaxPoint);
    end;

    4:
    begin
      if ship.Captain = $ffff then
        CellText := ''
      else
        CellText := '$' + IntToHex(ship.Captain, 4);
    end;

    5:
    begin
      CellText := IntToStr(ship.Power);
    end;

    6:
    begin
      CellText := IntToStr(ship.ShiQi);
    end;

    7:
    begin
      CellText := '$' + IntToHex(Integer(ship), 8);
    end;
  end;
end;

procedure TfrmP3Editor.ShipGridHeaderClick(Sender: TVTHeader;
  Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  if (Column = 0) or (Column = 1) then
  begin
    GridHandleHeaderClickSort(ShipGrid, Column);
  end;
end;

procedure TfrmP3Editor.ShipGridPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  ship: PP3R2Ship;
begin
  ship := Sender.GetNodeUserData(Node);
//  if ship.MemPage.Freed then
//    TargetCanvas.Font.Style := [fsStrikeOut]
//  else
//    TargetCanvas.Font.Style := [];

  if isPirateShip_R2(ship) then
    TargetCanvas.Font.Color := clBlue
  else if ship.State = SHIP_STATE__BATTLE then
    TargetCanvas.Font.Color := clRed
  else
    TargetCanvas.Font.Color := clWindowText;
end;

procedure TfrmP3Editor.shipWeaponChanged;
begin
  if fCurrShip = nil then
    lblShipWeapon.Caption := ''
  else
    lblShipWeapon.Caption := IntToStr(fCurrShip.Sword);
end;

procedure TfrmP3Editor.shiQiChanged;
begin
  if fCurrShip = nil then
    lblShiQi.Caption := ''
  else
    lblShiQi.Caption := IntToStr(fCurrShip.ShiQi);
end;

procedure TfrmP3Editor.SoldierGridAcceptNewText(aSender: TBaseVirtualTree;
  const aEditorWndHandle: Cardinal; aNode: PVirtualNode;
  const aColumn: TColumnIndex; aNewText: WideString; var aAccept: Boolean;
  var aErrHintTitle, aErrHintMsg: WideString);
var
  idx, q: Integer;
begin
  aAccept := False;
  
  if (fCityList = nil) or (fCurrCity = nil) or (aColumn <> 1) then
    Exit;

  if not TryStrToInt(aNewText, q) then
  begin
    soundBeep();
    Exit;
  end;

  if (q < 0) or (q > 255) then
  begin
    soundBeep();
    Exit;
  end;

  idx := aSender.GetNodeUserDataInt(aNode);

  fCurrCity^.Soldiers[idx] := q;
  reCalcTotalAllowedSoldiers(fCurrCity);
  updateSoldierTotal();

  SoldierGrid.Invalidate();

  aAccept := True;  
end;

procedure TfrmP3Editor.SoldierGridDblClick(Sender: TObject);
var
  idx, q: Integer;
begin
  if (fCityList = nil) or (fCurrCity = nil) then
    Exit;

  if SoldierGrid.SelectedNode = nil then
    Exit;

  idx := SoldierGrid.GetNodeUserDataInt(SoldierGrid.SelectedNode);

  q := fCurrCity^.Soldiers[idx];

  if q > 255 then
    q := 255;

  fCurrCity^.Soldiers[idx] := q;
  reCalcTotalAllowedSoldiers(fCurrCity);
  updateSoldierTotal();

  SoldierGrid.Invalidate();
end;

procedure TfrmP3Editor.SoldierGridEditing(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  Allowed := (fCityList <> nil) and (fCurrCity <> nil) and (Column = 1);
end;

procedure TfrmP3Editor.SoldierGridGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  q, idx: Integer;
begin
  if (fCityList = nil) or (fCurrCity = nil) then
  begin
    CellText := '';
    Exit;
  end;

  idx := Sender.GetNodeUserDataInt(Node);

  case Column of
    0:
    begin
      CellText := getSoldierTypeName(idx);
    end;

    1:
    begin
      q := fCurrCity^.Soldiers[idx];
      CellText := IntToStr(q);  
    end;

    2:
    begin
      q := fCurrCity^.TrainingSoldiers[idx];
      CellText := IntToStr(q);
    end

  else
    CellText := '';
  end;
end;


procedure TfrmP3Editor.TabControl1Change(Sender: TObject);
begin
  loadShipsIntoGrid();
end;

procedure TfrmP3Editor.Timer1Timer(Sender: TObject);
var
  J: Integer;
begin
  if csDestroying in Componentstate then
    Exit;

  if fDestroying then
    Exit;

  if fLockedShip = nil then
    Exit;

  try
    if not isValidShipPtr_R2(fLockedShip) then
      Exit;

    if fLockedShip.State = SHIP_STATE__KILLED then
    begin
      fLockedShip := nil;
      fLockedShipName := '';
      Exit;
    end;

    fLockedShip.MaxPoint := FAV_SHIP_POINT;
    fLockedShip.CurrPoint := FAV_SHIP_POINT;

//    fLockedShip.orgShipPtr^.MaxPoint := FAV_SHIP_POINT;
//    fLockedShip.orgShipPtr^.CurrPoint := FAV_SHIP_POINT;

    fLockedShip.ShiQi := MAX_SHIQI;
//    fLockedShip.orgShipPtr^.ShiQi := MAX_SHIQI;

    if fLockedShip.Seaman < 50 then
      fLockedShip.Seaman := 50;

    if fLockedShip.Sword < 50 then
      fLockedShip.Sword := 50;

//    fLockedShip.shipCopy.Ship.Seaman := fLockedShip.orgShipPtr^.Seaman;
//    fLockedShip.shipCopy.Ship.ShipWeapon := fLockedShip.orgShipPtr^.ShipWeapon;

    for J := 1 to 24 do
    begin
      fLockedShip.Carnons[J] := CANNON__JIANONG;
//      fLockedShip.orgShipPtr^.Carnons[J] := CANNON__JIANONG;
    end;
    fLockedShip.Power := MAX_POWER;
//    fLockedShip.orgShipPtr^.Power := MAX_POWER;
  except
    soundBeep();
    Exit;
  end;

  if Visible then
  begin
    ShipGrid.Invalidate();
    MemGrid.Invalidate();
    if fLockedShip = fCurrShip then
      updateShipInfo();
  end;
end;

procedure TfrmP3Editor.totalLoadChanged;
begin
  if fCurrShip = nil then
    edTotalLoad.Text := ''
  else
    edTotalLoad.Text := IntToStr(fCurrShip.GoodsLoad div UNIT_TONG);
end;

procedure TfrmP3Editor.updateBuildingGrid;
var
  i: integer;
  b: PCityBuilding;
begin
  BuildingGrid.BeginUpdate();
  try
    BuildingGrid.Clear();
    
    if fCurrCity = nil then
      exit;

    for I := 0 to fcurrcity^.BuildingCount - 1 do
    begin
      BuildingGrid.AddChild(nil, pointer(i));
    end;
  finally
    BuildingGrid.EndUpdate();
  end;
end;

procedure TfrmP3Editor.updateBusinessOffice;
var
  pid: Byte;
begin
  if cbCity.ItemIndex < 0 then
    fBusinessOffice := nil
  else
  begin
    if cbPlayer.ItemIndex <= 0 then
      pid := getCurrPlayerID()
    else
      pid := cbPlayer.ItemIndex - 1;

    fBusinessOffice := getBusinessOfficePtr(pid, cbCity.ItemIndex);
  end;
  
  if fBusinessOffice = nil then
  begin
    edBusinessOfsPtr.Text := '';
    lblStoreHouseMaxCap.Caption := '';
  end
  else
  begin
    edBusinessOfsPtr.Text := ptrToHexStr(fBusinessOffice);
    lblStoreHouseMaxCap.Caption := IntToStr(fBusinessOffice.StoreHouseMaxCap);
  end;

  BusinessOfficeGrid.Invalidate();
  BusinessOfficeG2.Invalidate();
end;

procedure TfrmP3Editor.updateCityMemo;

  procedure cityFlag(flag: byte; s: string);
  begin
    if (fcurrcity.CityTypeFlags and flag) = flag then
      memCity.Lines.Add(s);
  end;

begin
  memCity.Lines.Clear();
  if fCurrCity = nil then
  begin

    exit;
  end;

  memCity.Lines.Add(getCityName2(fCurrCity.CityCode));
  memCity.Lines.Add('City code: ' + byteToHexStr(fcurrcity.CityCode));
  memCity.Lines.Add('City internal code: ' + byteToHexStr(fcurrcity.CityInternalCode));
  memCity.Lines.Add('City type flags: ' + byteToHexStr(fcurrcity.CityTypeFlags));
  memCity.Lines.Add('713: ' + byteToHexStr(byteAt(fCurrCity, 713)));
  memCity.Lines.Add('714: ' + byteToHexStr(byteAt(fCurrCity, 714)));
  memCity.Lines.Add('715: ' + byteToHexStr(byteAt(fCurrCity, 715)));

  cityFlag(CITY_FLAG__INNER_PORT, '内河港');
  cityFlag(CITY_FLAG__WINTER, '冬季');
  cityFlag(CITY_FLAG__SIEGE, '围攻');
  cityFlag(CITY_FLAG__TRADE_STATION, '可贸易');
  cityFlag(CITY_FLAG__LEAGUE, '同盟');
  cityFlag(CITY_FLAG__BRANCH, '分部');  
end;

procedure TfrmP3Editor.updateCityPopTotal;
begin
  if (fCityList = nil) or (fCurrCity = nil) then
    lblPopTotal.Caption := ''
  else
  begin
    lblPopTotal.Caption := IntToStr(
            fCurrCity^.Pop_rich + fCurrCity^.Pop_common + fCurrCity^.Pop_poor + fcurrCity^.Pop_begger);
  end;       
end;

procedure TfrmP3Editor.updateCityTreasury;
begin
  if fCurrCity = nil then
    edCityTreasury.Text := ''
  else
  begin
    edCityTreasury.Text := IntToStr(fCurrCity^.Treasury);
    lblTestResult.Caption := ptrToHexStr(@fCurrCity^.Treasury);
  end;
end;

procedure TfrmP3Editor.updateGameDate;
var
  y, m, d, h: Integer;
begin
  h := getGameDate(y, m, d);
  lblGameDate.Caption := IntToStr(y) + '-' + IntToStr(m) + '-' + IntToStr(d) + ' ' + IntToStr(h) + '时';
  edGameDataAddr.Text := '$71CDA8';
end;

procedure TfrmP3Editor.updateMemContent;
var
  i64: Int64;
  row, offset, delta: Integer;
  pb: PByte;
  pw: PWord;
  pl: PLongWord;
  psh: PShortInt;
  psm: PSmallInt;
  plo: PLongint;
begin
  if (fCurrShip = nil)
  or (MemGrid.SelectedNode = nil)
  or (MemGrid.FocusedColumn <= 0) then
  begin
    memValue.Panels[0].Text := '';
    memValue.Panels[1].Text := '';
    memValue.Panels[2].Text := '';
  end
  else
  begin
    row := MemGrid.GetNodeUserDataInt(MemGrid.SelectedNode);

    offset := getMemOffset(fCurrShip, row, MemGrid.FocusedColumn-1);
    delta := offset - integer(fCurrShip);

    offset := integer(fCurrShip);
    Inc(offset, delta);
    
    if fNonSignaled then
    begin
      pb := Pointer(offset);
      pw := Pointer(pb);
      pl := Pointer(pb);
      memValue.Panels[0].Text := '[' + IntToStr(pb^) + ']';
      memValue.Panels[1].Text := '[' + IntToStr(pw^) + ']';
      i64 := pl^;
      memValue.Panels[2].Text := '[' + IntToStr(i64) + ']';  
    end
    else
    begin
      psh := Pointer(offset);
      psm := Pointer(psh);
      plo := Pointer(psh);

      memValue.Panels[0].Text := IntToStr(psh^);
      memValue.Panels[1].Text := IntToStr(psm^);
      memValue.Panels[2].Text := IntToStr(plo^);
    end;
  end;
end;

procedure TfrmP3Editor.updateMemInspValues;

  procedure clearValues();
  begin
    edMemInspValue_B.Text := '';
    edMemInspValue_W.Text := '';
    edMemInspValue_D.Text := '';
    edMemInspValue_Q.Text := '';
    edMemInspValue_Single.Text := '';
    edMemInspValue_Double.Text := '';
    lblMemInspCurrPosOfs.Caption := '';
    lblMemInspCurrPosAddr.Caption := '';
  end;

var
  off, delta: Integer;
  i64: Int64;
  u_b: Pbyte;
  u_w: PWORD;
  u_d: PDWORD;
  s_b: PShortInt;
  s_w: PSmallInt;
  s_d: PLongint;
  pi64: PInt64;
  p_single: PSingle;
  p_double: PDouble;
  s: string;
  pc: PChar;
  i, l, remains: Integer;
begin
  if fCurrPageMP = nil then
  begin
    clearValues();
    Exit;
  end;

  if (MemInspectGrid.SelectedNode = nil)
  or (MemInspectGrid.FocusedColumn < 0) then
  begin
    clearValues();
    Exit;
  end;

  off := getMemInspaceGridOff(MemInspectGrid.SelectedNode, MemInspectGrid.FocusedColumn);
  if off = 0 then
  begin
    clearValues();
    exit;
  end;

  if fAnchor <> nil then
  begin
    delta := off - integer(fAnchor);
    lblMemInspCurrPosOfs.Caption := 'Ofs: ' + IntToStr(delta);
  end;

  lblMemInspCurrPosAddr.Caption := longwordToHexStr(off);

  if not rbSignaled.Checked then
  begin
    u_b := pointer(off);
    u_w := pointer(off);
    u_d := pointer(off);

    edMemInspValue_B.Text := IntToStr(u_b^);
    edMemInspValue_W.Text := IntToStr(u_w^);
    i64 := u_d^;
    edMemInspValue_D.Text := IntToStr(i64);
  end
  else
  begin
    s_b := pointer(off);
    s_w := pointer(off);
    s_d := pointer(off);

    edMemInspValue_B.Text := IntToStr(s_b^);
    edMemInspValue_W.Text := IntToStr(s_w^);
    edMemInspValue_D.Text := IntToStr(s_d^);
  end;

  pi64 := pointer(off);

  edMemInspValue_Q.Text := IntToStr(pi64^);

  p_single := pointer(off);

  if IsNan(p_single^) then
    s := 'NAN'
  else if IsInfinite(p_single^) then
    s := 'Infinite'
  else
  try
    s := FloatToStr(p_single^);
  except
    s := 'Error';
  end;

  edMemInspValue_Single.Text := s;

  p_double := pointer(off);

  if IsNan(p_double^) then
    s := 'NAN'
  else if IsInfinite(p_double^) then
    s := 'Infinite'
  else
  try
    s := FloatToStr(p_double^);
  except
    s := 'Error';
  end;

  edMemInspValue_Double.Text := s;

  pc := pointer(off);

  remains := integer(fCurrPageMP.P) + Integer(fCurrPageMP.Size) - off - 1;

  if remains < 65 then
    remains := 65;

  l := 0;
  for I := 0 to remains-1 do
  begin
    if pc^ = #0 then
    begin
      Break;
    end;

    Inc(l);
  end;

  if l > 64 then
    l := 64;

  SetString(s, pc, l);
  edMemInspValueAsText.Text := s;
end;

procedure TfrmP3Editor.updatePlayerMoney;
var
  i, idx, m: Integer;
begin
  i := cbPlayer.ItemIndex;
  if i < 0 then
  begin
    edPlayerMoney.Text := '';
    edPlayerPtr.Text := '';
    lblPlayerName.Caption := '';
    lblPlayerClass.Caption := '';
  end
  else
  begin
    if i = 0 then
      i := getCurrPlayerID()
    else
      i := i - 1;

    idx := i;
    m := getPlayerMoney(i);
    edPlayerMoney.Text := IntToStr(m);
    lblPlayerName.Caption := getPlayerName(idx);
    i := integer(getPlayerMoneyPtr(i));
    edPlayerPtr.Text := '$' + IntToHex(i, 8);
    lblPlayerClass.Caption := getPlayerClass(idx);
  end;

  lblPlayerID.Caption := '$' + IntToHex(getCurrPlayerID_Program(), 2);


  updateShengWang();
end;

procedure TfrmP3Editor.updateShengWang;
var
  player: Byte;
  totalAsset, totalLoadingCap, posx,posy: integer;
  a15, a1B: Byte;
  s1, s2, s3, s4, s5: Single;
  y, m, d: Integer;
  pp, p464, p2C6: Pointer;
  pdw: PDWORD;
  psing: PSingle;
begin
  if (fCityList = nil) or (fCurrCity = nil) or (cbCity.ItemIndex < 0) then
  begin
    edShengWang1.Text := '';
    edShengWang2.Text := '';
    edShengWang3.Text := '';
    edShengWang4.Text := '';
    edShengWang5.Text := '';


    edPlayer_15.Text := '';
    edPlayer_1B.Text := '';
    edPlayer_464.Text := '';

    edBirthday.Text := '';


//    edPlayer_46C.Text := '';
//    edPlayer_470.Text := '';
    edPlayer_2C6.Text := '';
    lblCityX.Caption := '';
    lblCityY.Caption := '';

    lblBusinessOfficePtr.Caption := '';
  end
  else
  begin
//    OutputDebugString('updateShengWang');
    if cbPlayer.ItemIndex <= 0 then
      player := getCurrPlayerID()
    else
      player := cbPlayer.ItemIndex-1;

    getCityShengWang(player, cbCity.ItemIndex, s1, s2, s3, s4, s5);
    edShengWang1.Text := FormatFloat('0.000', s1);
    edShengWang2.Text := FormatFloat('0.000', s2);
    edShengWang3.Text := FormatFloat('0.000', s3);
    edShengWang4.Text := FormatFloat('0.000', s4);
    edShengWang5.Text := FormatFloat('0.000', s5);


    getPlayerExtraInfo(player, totalAsset, totalLoadingCap, a15, a1B);
    pp := getPlayerPtr(player);

    p464 := ptrAdd(pp, $464);
//    p470 := ptrAdd(pp, $470);
    p2C6 := ptrAdd(pp, $2C6);
    
    edPlayer_15.Text := byteToHexStr(a15);
    edPlayer_1B.Text := byteToHexStr(a1B);
//    edPlayer_46C.Text := IntToStr(totalAsset);
//    edPlayer_470.Text := IntToStr(totalLoadingCap);

    getCityMapPos(cbCity.ItemIndex, posx, posy);
    lblCityX.Caption := IntToStr(posx);
    lblCityY.Caption := IntToStr(posy);

    getPlayerBirthday(player, y, m, d);
    edBirthday.Text := IntToStr(y) + '-' + IntToStr(m) + '-' + IntToStr(d) + ' ' + IntToStr(howOldIs(player));


    if rgConvertDWSingle1.ItemIndex = 0 then
    begin
      pdw := p464;
      edPlayer_464.Text := IntToStr(pdw^);

      pdw := p2C6;
      edPlayer_2C6.Text := IntToStr(pdw^);
    end
    else
    begin
      psing := p464;
      edPlayer_464.Text := FloatToStr(psing^);

      psing := p2C6;
      edPlayer_2C6.Text := floatToStr(psing^);
    end;

    try
      lblBusinessOfficePtr.Caption := ptrToHexStr(getBusinessOfficePtr(player, cbCity.ItemIndex));
    except
      lblBusinessOfficePtr.Caption := 'Error'; 
    end;
  end;
end;

procedure TfrmP3Editor.updateShipInfo;

  procedure updateCaptionInfo();
  var
    cap: PCaptainRec;
  begin
    if (fCurrShip = nil) or (fCurrShip^.Captain = $FFFF) then
    begin
      edCaptainBirthday.Text := '';
//      lblCaptainRetirementDay.Caption := '';
      edPtrOfCaptain.Text := '';
    end
    else
    begin
      cap := getCaptionInfo(fcurrship^.Captain);
      edCaptainBirthday.Text := timestampToDateStr(cap.birdthDay);
      edPtrOfCaptain.Text := ptrToHexStr(cap);
    end;
  end;

  procedure updateShipGroupInfo();
  var
    gid: word;
  begin
    if fCurrShip = nil then
    begin
      lblShipGroupIndex.Caption := '';
      lblGroupFirstShipIndex.Caption := '';
      lblShipIndex3C.Caption := '';
      lblShipGroupInfoPtr.Caption := '';
    end
    else
    begin
      gid := fcurrship^.GroupIndex;
      lblShipGroupIndex.Caption := wordToHexStr(gid);

      if gid <> $FFFF then
      begin
        lblGroupFirstShipIndex.Caption := wordToHexStr(getShipGroupFirstShipIndex(gid));
        lblShipGroupInfoPtr.Caption := ptrToHexStr(getShipGroupInfo(gid));
      end
      else
      begin
        lblGroupFirstShipIndex.Caption := '';
        lblShipGroupInfoPtr.Caption := '';
      end;

      lblShipIndex3C.Caption := wordToHexStr(fcurrShip.Ship_Index_3C);
    end;
  end;

begin
  if not Visible then
    Exit;

  captainChanged();
  maxLoadChanged();
  shiQiChanged();
  shipWeaponChanged();
  cityWeaponChanged();
  totalLoadChanged();
  shipClassChanged();
  routeInfoChanged();

  if fCurrShip = nil then
  begin
    edShipName.Text := '';
    edLoadLimit.Text := '';
    edShipCurrPoint.Text := '';
    edShipMaxPoint.Text := '';
    edState.Text := '';
    edShuiShou.Text := '';
    edShuiShou.Enabled := False;
//    lblShipWeapon.Caption := '';
    lblFrom.Caption := '';
    lblCurrPlace.Caption := '';
    lblTo.Caption := '';
    lblPower.Caption := '';
    btnSetLoad.Enabled := False;
    btnMaxLoad.Enabled := False;
    btnMaxStrong.Enabled := False;
    btnSetCaptain.Enabled := False;
    btnFavCaptain.Enabled := False;
    btnSetShipName.Enabled := False;
    btnSetShipNameToOthers.Enabled := False;
    btnFullCannons.Enabled := False;
    btnState0.Enabled := False;
    btnSetShuiShou.Enabled := False;
    btnMaxShiQi.Enabled := False;
    btnMaxShipWeapon.Enabled := False;
    btnSetAllGoodsQtyTo.Enabled := False;
    btnSetSelectedGoodsQtyTo.Enabled := False;
    btnClearAllGoods.Enabled := False;
    btnSetGoodsDirect.Enabled := False;
    btnSetFoodsQtyTo.Enabled := False;
    btnSetBuildingMaterialQtyTo.Enabled := False;
    btnFillCityWeapon.Enabled := False;
    btnSetTotalLoad.Enabled := False;
    btnSetShipClass.Enabled := False;
    btnClearCityWeapon.Enabled := False;
    edShipPosX.Text := '';
    edShipPosY.Text := '';
  end
  else
  begin
    edShipName.Text := getShipName_R2(fCurrShip);
    edShipCurrPoint.Text := IntToStr(fCurrShip.CurrPoint);
    edShipMaxPoint.Text := IntToStr(fCurrShip.MaxPoint);
    edState.Text := '$' + IntToHex(fCurrShip.State, 2);
    
    edShuiShou.Text := IntToStr(fCurrShip.Seaman);

    if fCurrShip = fLockedShip then
    begin
      btnSetShuiShou.Enabled := False;
      edShuiShou.Enabled := False;
      btnMaxShiQi.Enabled := False;
      btnFullCannons.Enabled := False;
    end
    else
    begin
      btnSetShuiShou.Enabled := True;
      edShuiShou.Enabled := True;
      btnMaxShiQi.Enabled := True;
      btnFullCannons.Enabled := True;
    end;
//    lblShipWeapon.Caption := IntToStr(fCurrShip.shipCopy.Ship.ShipWeapon);

    lblFrom.Caption := getCityName2(fCurrShip.From);
    lblCurrPlace.Caption := getCityName2(fCurrShip.Curr);
    lblTo.Caption := getCityName2(fCurrShip.Dest);

    lblPower.Caption := IntToStr(fCurrShip.Power);
    btnMaxShipWeapon.Enabled := True;
    btnSetLoad.Enabled := True;
    btnMaxLoad.Enabled := True;
    btnMaxStrong.Enabled := True;
    btnSetCaptain.Enabled := True;
    btnFavCaptain.Enabled := True;
    btnSetShipName.Enabled := True;
    btnSetShipNameToOthers.Enabled := True;

    btnState0.Enabled := True;
    btnSetShuiShou.Enabled := True;
    btnSetAllGoodsQtyTo.Enabled := True;
    btnSetSelectedGoodsQtyTo.Enabled := True;
    btnClearAllGoods.Enabled := True;
    btnSetGoodsDirect.Enabled := True;
    btnSetFoodsQtyTo.Enabled := True;
    btnSetBuildingMaterialQtyTo.Enabled := True;
    btnFillCityWeapon.Enabled := True;
    btnSetTotalLoad.Enabled := True;
    btnSetShipClass.Enabled := True;
    btnClearCityWeapon.Enabled := True;

    edShipPosX.Text := IntToStr(fCurrShip^.PosX);
    edShipPosY.Text := IntToStr(fcurrship^.PosY);


  end;

  if fLockedShip = nil then
    btnLockSelected.Caption := '锁定选中的'
  else if fLockedShip = fCurrShip then
    btnLockSelected.Caption := '反锁选中的'
  else
    btnLockSelected.Caption := '锁定选中的';

  updateCaptionInfo();
  updateShipGroupInfo();

  GoodsGrid.Invalidate();
  MemGrid.Invalidate();

  updateMemContent();
end;

procedure TfrmP3Editor.updateSoldierTotal;
var
  ptr: Pointer;
  s: string;
begin
  if (fCityList = nil) or (fCurrCity = nil) then
    lblSoldierTotal.Caption := ''
  else
  begin
    s := IntToStr(calcSoldierTotal(fCurrCity, True))
            + '/' + IntToStr(calcSoldierTotal(fCurrCity, False));
            
    s := s + ', 定额：' + IntToStr(fcurrCity^.TotalAllowedSoldiers);
//    ptr := @fCurrCity^.Soldiers[0];
//    s := s + ' ' + IntToHex(integer(ptr), 8);
    lblSoldierTotal.Caption := s;
  end;
end;

procedure TfrmP3Editor.WndProc(var Message: TMessage);
begin
  if (Message.Msg = WM_ACTIVATE) and (Message.WParam = WA_INACTIVE) then
  begin
    fDrawing := False;
    DoSendKey := True;
    ModalResult := mrCancel;
//    EditorVisible := False;
    Hide();
//    OutputDebugString('WA_INACTIVE');
//    if Visible then
//      OutputDebugString('Still visible');
//    PostMessage(Handle, UM_CLOSE, 0, 1);
  end;

  inherited;

end;

{ TP3EditorIntf }

class procedure TP3EditorIntf.directExec(const aIN_ParentFormHandle: THandle);
begin
  with TP3EditorIntf.Create() do
  begin
    IN_ParentFormHandle := aIN_ParentFormHandle;
    exec();
  end;

//  OutputDebugString('TP3EditorIntf.directExec(');
end;

procedure TP3EditorIntf.exec;
begin
  with TfrmP3Editor.Create(Self) do
  {$IFDEF INTERNAL_WND}
  begin
//    Show();
    ShowModal();
//    Hide();
  end;
  {$ELSE}
    Show();
  {$ENDIF}
end;

//{ TShipObj }
//
//procedure TShipObj.copyShip;
//var
//  c: Cardinal;
//  oldf: Boolean;
//begin
//  oldf := MemPage.Freed;
//  c := cardinal(orgShipPtr) - SizeOf(tbytes30);
//  if (c < cardinal(MemPage.P)) then
//  begin
//    fillchar(shipCopy.Bytes30[1], 30, 0);
//  end
//  else
//  begin
//    move(pointer(c)^, shipCopy.Bytes30[1], 30);
//  end;
//  
//  c := cardinal(orgShipPtr) + SizeOf(tp3ship) + sizeof(tbytes18);
//
//  if c > (cardinal(MemPage.P) + MemPage.Size) then
//  begin
//    move(orgshipptr^, shipCopy.Ship, sizeof(tp3ship) - sizeof(tbytes28));
//    FillChar(shipCopy.Ship.Stub8[1], sizeof(tbytes28) + sizeof(tbytes18), 0);
//  end
//  else
//  begin
//    move(orgshipptr^, shipCopy.Ship, sizeof(tp3ship) + sizeof(tbytes18));  
//  end;
//  if oldf <> MemPage.Freed then
//    OutputDebugString('copyship error.');
//end;
//
//function TShipObj.validateMem: Boolean;
//begin
//  if MemPage.Freed then
//  begin
//    Result := False;
////    OutputDebugString(pchar('mem page is freed'));
//  end
//  else
//  begin
//    Result := MemPage.validateHeap(orgShipPtr);
////    if not Result then
////      OutputDebugString('Validate failed')
////    else
////      OutputDebugString('validate ok');
//  end;
//end;

initialization
  NoteFileName := ExtractFilePath(ParamStr(0)) + 'p3ednote.txt';

end.
