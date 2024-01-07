unit P3InsightConfigurerMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, p3insight_common, ComCtrls, ExtCtrls, StdCtrls;

type
  TP3InsightSetup = class(TForm)
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    btnOk: TButton;
    btnCancel: TButton;
    GroupBox1: TGroupBox;
    cbMod_GlobalEnabled: TCheckBox;
    cbHouseCap1: TCheckBox;
    edHouseCap1: TEdit;
    cbHouseCap2: TCheckBox;
    edHouseCap2: TEdit;
    cbHouseCap3: TCheckBox;
    edHouseCap3: TEdit;
    GroupBox4: TGroupBox;
    cbShip1Cap: TCheckBox;
    edShip1CapL1: TEdit;
    cbShip2Cap: TCheckBox;
    cbShip3Cap: TCheckBox;
    cbShip4Cap: TCheckBox;
    edShip2CapL1: TEdit;
    edShip3CapL1: TEdit;
    edShip4CapL1: TEdit;
    GroupBox5: TGroupBox;
    cbHunterHouseWorkers: TCheckBox;
    edHunterHouseWorkers: TEdit;
    cbPiscaryWorkers: TCheckBox;
    edPiscaryWorkers: TEdit;
    cbBeerFactory: TCheckBox;
    edBeerFactory: TEdit;
    cbFactoryWorkers: TCheckBox;
    edFactoryWorkers: TEdit;
    cbApiary: TCheckBox;
    edApiary: TEdit;
    cbGrainField: TCheckBox;
    edGrainField: TEdit;
    cbCowFarm: TCheckBox;
    edCowFarm: TEdit;
    cbLoggingCamp: TCheckBox;
    edLoggingCamp: TEdit;
    cbTextileMill: TCheckBox;
    edTextileMill: TEdit;
    cbSaltern: TCheckBox;
    edSaltern: TEdit;
    cbIronMill: TCheckBox;
    edIronMill: TEdit;
    cbSheepFarm: TCheckBox;
    edSheepFarm: TEdit;
    cbWineyard: TCheckBox;
    edWineyard: TEdit;
    cbCeramicFactory: TCheckBox;
    edCeramicFactory: TEdit;
    cbBrickyard: TCheckBox;
    edBrickyard: TEdit;
    cbAsphaltFactory: TCheckBox;
    edAsphaltFactory: TEdit;
    cbHempField: TCheckBox;
    edHempField: TEdit;
    GroupBox6: TGroupBox;
    cbGrainReq: TCheckBox;
    edGrainReqRich: TEdit;
    cbMeatReq: TCheckBox;
    edMeatReqRich: TEdit;
    cbFishReq: TCheckBox;
    edFishReqRich: TEdit;
    cbBeerReq: TCheckBox;
    edBeerReqRich: TEdit;
    cbSaltReq: TCheckBox;
    edSaltReqRich: TEdit;
    cbHoneyReq: TCheckBox;
    edHoneyReqRich: TEdit;
    cbSpiceReq: TCheckBox;
    edSpiceReqRich: TEdit;
    cbWineReq: TCheckBox;
    edWineReqRich: TEdit;
    cbClothReq: TCheckBox;
    edClothReqRich: TEdit;
    cbAnimalSkinReq: TCheckBox;
    edAnimalSkinReqRich: TEdit;
    cbWhaleOilReq: TCheckBox;
    edWhaleOilReqRich: TEdit;
    cbWoodReq: TCheckBox;
    edWoodReqRich: TEdit;
    cbIronGoodsReq: TCheckBox;
    edIronGoodsReqRich: TEdit;
    cbLeatherReq: TCheckBox;
    edLeatherReqRich: TEdit;
    cbWoolReq: TCheckBox;
    edWoolReqRich: TEdit;
    cbAsphaltReq: TCheckBox;
    edAsphaltReqRich: TEdit;
    cbIronReq: TCheckBox;
    edIronReqRich: TEdit;
    cbHempReq: TCheckBox;
    edHempReqRich: TEdit;
    cbPotteryReq: TCheckBox;
    edPotteryReqRich: TEdit;
    cbBrickReq: TCheckBox;
    edBrickReqRich: TEdit;
    GroupBox7: TGroupBox;
    cbBOCap: TCheckBox;
    edBOCap: TEdit;
    cbSHCap: TCheckBox;
    edSHCap: TEdit;
    GroupBox8: TGroupBox;
    cbShip1Seaman: TCheckBox;
    edShip1Seaman: TEdit;
    cbShip2Seaman: TCheckBox;
    cbShip3Seaman: TCheckBox;
    cbShip4Seaman: TCheckBox;
    edShip2Seaman: TEdit;
    edShip3Seaman: TEdit;
    edShip4Seaman: TEdit;
    GroupBox9: TGroupBox;
    cbShip1Speed: TCheckBox;
    edShip1Speed: TEdit;
    cbShip2Speed: TCheckBox;
    cbShip3Speed: TCheckBox;
    cbShip4Speed: TCheckBox;
    edShip2Speed: TEdit;
    edShip3Speed: TEdit;
    edShip4Speed: TEdit;
    GroupBox2: TGroupBox;
    cbWear1: TCheckBox;
    cbWear2: TCheckBox;
    cbWear3: TCheckBox;
    cbWear4: TCheckBox;
    GroupBox3: TGroupBox;
    cbMorale1: TCheckBox;
    cbMorale2: TCheckBox;
    GroupBox10: TGroupBox;
    cbSeaman1: TCheckBox;
    cbSeaman2: TCheckBox;
    cbSeaman3: TCheckBox;
    edShip1CapL2: TEdit;
    edShip2CapL2: TEdit;
    edShip3CapL2: TEdit;
    edShip4CapL2: TEdit;
    edShip1CapL3: TEdit;
    edShip2CapL3: TEdit;
    edShip3CapL3: TEdit;
    edShip4CapL3: TEdit;
    edShip1CapL4: TEdit;
    edShip2CapL4: TEdit;
    edShip3CapL4: TEdit;
    edShip4CapL4: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edGrainReqCommon: TEdit;
    edMeatReqCommon: TEdit;
    edFishReqCommon: TEdit;
    edBeerReqCommon: TEdit;
    edSaltReqCommon: TEdit;
    edHoneyReqCommon: TEdit;
    edSpiceReqCommon: TEdit;
    edWineReqCommon: TEdit;
    edClothReqCommon: TEdit;
    edAnimalSkinReqCommon: TEdit;
    edGrainReqPoor: TEdit;
    edMeatReqPoor: TEdit;
    edFishReqPoor: TEdit;
    edBeerReqPoor: TEdit;
    edSaltReqPoor: TEdit;
    edHoneyReqPoor: TEdit;
    edSpiceReqPoor: TEdit;
    edWineReqPoor: TEdit;
    edClothReqPoor: TEdit;
    edAnimalSkinReqPoor: TEdit;
    edWhaleOilReqCommon: TEdit;
    edWoodReqCommon: TEdit;
    edIronGoodsReqCommon: TEdit;
    edLeatherReqCommon: TEdit;
    edWoolReqCommon: TEdit;
    edAsphaltReqCommon: TEdit;
    edIronReqCommon: TEdit;
    edHempReqCommon: TEdit;
    edPotteryReqCommon: TEdit;
    edBrickReqCommon: TEdit;
    edWhaleOilReqPoor: TEdit;
    edWoodReqPoor: TEdit;
    edIronGoodsReqPoor: TEdit;
    edLeatherReqPoor: TEdit;
    edWoolReqPoor: TEdit;
    edAsphaltReqPoor: TEdit;
    edIronReqPoor: TEdit;
    edHempReqPoor: TEdit;
    edPotteryReqPoor: TEdit;
    edBrickReqPoor: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
  private
    { Private declarations }
    fConf: TP3InsightConf;

    procedure mod_loadFromConf();
    procedure mod_saveToConf();  
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

var
  P3InsightSetup: TP3InsightSetup;

implementation

{$R *.dfm}

{ TP3InsightSetup }

constructor TP3InsightSetup.Create(AOwner: TComponent);
begin
  fConf := TP3InsightConf.Create();
  fConf.load();
  inherited;
end;

procedure TP3InsightSetup.mod_loadFromConf;

  function  getEnabled(valueName: string): Boolean;
  var
    item: TModItem;
  begin
    item := Conf.ModItems.getByName(valueName);
    Result := item.Enabled;
  end;

var
  item: TModItem;

begin
  item := Conf.ModItems.getByName('house-cap-adv');
  cbHouseCap1.Checked := item.Enabled;
  edHouseCap1.Text := IntToStr(item.Value);

  item := Conf.ModItems.getByName('house-cap-common');
  cbHouseCap2.Checked := item.Enabled;
  edHouseCap2.Text := IntToStr(item.Value);

  item := Conf.ModItems.getByName('hosue-cap-poor');
  cbHouseCap3.Checked := item.Enabled;
  edHouseCap3.Text := IntToStr(item.Value);




  item := Conf.ModItems.getByName('min-seaman-1');
  cbShip1Seaman.Checked := item.Enabled;
  edShip1Seaman.Text := IntToStr(item.Value);

  item := Conf.ModItems.getByName('min-seaman-2');
  cbShip2Seaman.Checked := item.Enabled;
  edShip2Seaman.Text := IntToStr(item.Value);

  item := Conf.ModItems.getByName('min-seaman-3');
  cbShip3Seaman.Checked := item.Enabled;
  edShip3Seaman.Text := IntToStr(item.Value);

  item := Conf.ModItems.getByName('min-seaman-4');
  cbShip4Seaman.Checked := item.Enabled;
  edShip4Seaman.Text := IntToStr(item.Value);




  item := Conf.ModItems.getByName('ship-speed-1');
  cbShip1Speed.Checked := item.Enabled;
  edShip1Speed.Text := IntToStr(item.Value);

  item := Conf.ModItems.getByName('ship-speed-2');
  cbShip2Speed.Checked := item.Enabled;
  edShip2Speed.Text := IntToStr(item.Value);

  item := Conf.ModItems.getByName('ship-speed-3');
  cbShip3Speed.Checked := item.Enabled;
  edShip3Speed.Text := IntToStr(item.Value);

  item := Conf.ModItems.getByName('ship-speed-4');
  cbShip4Speed.Checked := item.Enabled;
  edShip4Speed.Text := IntToStr(item.Value);




  item := Conf.ModItems.getByName('ship1-cap-l1');
  cbShip1Cap.Checked := item.Enabled;
  edShip1CapL1.Text := IntToStr(item.Value);
  item := Conf.ModItems.getByName('ship1-cap-l2');
  edShip1CapL2.Text := IntToStr(item.Value);
  item := Conf.ModItems.getByName('ship1-cap-l3');
  edShip1CapL3.Text := IntToStr(item.Value);
  item := Conf.ModItems.getByName('ship1-cap-l4');
  edShip1CapL4.Text := IntToStr(item.Value);




  item := Conf.ModItems.getByName('ship2-cap-l1');
  cbShip2Cap.Checked := item.Enabled;
  edShip2CapL1.Text := IntToStr(item.Value);
  item := Conf.ModItems.getByName('ship2-cap-l2');
  edShip2CapL2.Text := IntToStr(item.Value);
  item := Conf.ModItems.getByName('ship2-cap-l3');
  edShip2CapL3.Text := IntToStr(item.Value);
  item := Conf.ModItems.getByName('ship2-cap-l4');
  edShip2CapL4.Text := IntToStr(item.Value);




  item := Conf.ModItems.getByName('ship3-cap-l1');
  cbShip3Cap.Checked := item.Enabled;
  edShip3CapL1.Text := IntToStr(item.Value);
  item := Conf.ModItems.getByName('ship3-cap-l2');
  edShip3CapL2.Text := IntToStr(item.Value);
  item := Conf.ModItems.getByName('ship3-cap-l3');
  edShip3CapL3.Text := IntToStr(item.Value);
  item := Conf.ModItems.getByName('ship3-cap-l4');
  edShip4CapL4.Text := IntToStr(item.Value);




  item := Conf.ModItems.getByName('hunter-house');
  cbHunterHouseWorkers.Checked := item.Enabled;
  edHunterHouseWorkers.Text := IntToStr(item.Value);

  item := Conf.ModItems.getByName('piscary');
  cbPiscaryWorkers.Checked := item.Enabled;
  edPiscaryWorkers.Text := IntToStr(item.Value);

  item := Conf.ModItems.getByName('beer-factory');
  cbBeerFactory.Checked := item.Enabled;
  edBeerFactory.Text := IntToStr(item.Value);

  item := Conf.ModItems.getByName('iron-goods-factory');
  cbFactoryWorkers.Checked := item.Enabled;
  edFactoryWorkers.Text := IntToStr(item.Value);

  item := Conf.ModItems.getByName('apiary');
  cbApiary.Checked := item.Enabled;
  edApiary.Text := IntToStr(item.Value);

  item := Conf.ModItems.getByName('grain-field');
  cbGrainField.Checked := item.Enabled;
  edGrainField.Text := IntToStr(item.Value);

  item := Conf.ModItems.getByName('cow-farm');
  cbCowFarm.Checked := item.Enabled;
  edCowFarm.Text := IntToStr(item.Value);

  item := Conf.ModItems.getByName('logging-camp');
  cbLoggingCamp.Checked := item.Enabled;
  edLoggingCamp.Text := IntToStr(item.Value);

  item := Conf.ModItems.getByName('textile-mill');
  cbTextileMill.Checked := item.Enabled;
  edTextileMill.Text := IntToStr(item.Value);

  item := Conf.ModItems.getByName('saltern');
  cbSaltern.Checked := item.Enabled;
  edSaltern.Text := IntToStr(item.Value);

  item := Conf.ModItems.getByName('iron-mill');
  cbIronMill.Checked := item.Enabled;
  edIronMill.Text := IntToStr(item.Value);

  item := Conf.ModItems.getByName('sheep-farm');
  cbSheepFarm.Checked := item.Enabled;
  edSheepFarm.Text := IntToStr(item.Value);

  item := Conf.ModItems.getByName('wineyard');
  cbWineyard.Checked := item.Enabled;
  edWineyard.Text := IntToStr(item.Value);

  item := Conf.ModItems.getByName('ceramic-factory');
  cbCeramicFactory.Checked := item.Enabled;
  edCeramicFactory.Text := IntToStr(item.Value);

  item := Conf.ModItems.getByName('brickyard');
  cbBrickyard.Checked := item.Enabled;
  edBrickyard.Text := IntToStr(item.Value);

  item := Conf.ModItems.getByName('asphalt-factory');
  cbAsphaltFactory.Checked := item.Enabled;
  edAsphaltFactory.Text := IntToStr(item.Value);

  item := Conf.ModItems.getByName('hemp-field');
  cbHempField.Checked := item.Enabled;
  edHempField.Text := IntToStr(item.Value);





  item := Conf.ModItems.getByName('rich-grain');
  cbGrainReq.Checked := item.Enabled;
  edGrainReq.Text := IntToStr(item.Value);

  item := Conf.ModItems.getByName('common-grain');	


  cbMod_GlobalEnabled.Enabled := Conf.ModItems.Enabled;
end;

procedure TP3InsightSetup.mod_saveToConf;
begin

end;

end.
