unit test6main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, PDJButton, BcDrawModule, BcXPMenuDrawModule, Menus,
  BarMenus, JvComponentBase, JvWavePlayer;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    btnSelftTest: TButton;
    Button2: TButton;
    Edit1: TEdit;
    btnSingle: TButton;
    Edit2: TEdit;
    btnConvert: TButton;
    btnConvertUtf8: TButton;
    btnHexToStr: TButton;
    btnConvertUnicode: TButton;
    btnTestLoadConf: TButton;
    BcBarPopupMenu1: TBcBarPopupMenu;
    BcXPMenuDrawModule1: TBcXPMenuDrawModule;
    N1: TMenuItem;
    test1: TMenuItem;
    JvWavePlayer1: TJvWavePlayer;
    btnplaywave: TButton;
    procedure btnSelftTestClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure btnSingleClick(Sender: TObject);
    procedure btnConvertClick(Sender: TObject);
    procedure btnConvertUtf8Click(Sender: TObject);
    procedure btnHexToStrClick(Sender: TObject);
    procedure btnConvertUnicodeClick(Sender: TObject);
    procedure btnTestLoadConfClick(Sender: TObject);
    procedure PDJButton1Click(Sender: TObject);
    procedure test1Click(Sender: TObject);
    procedure btnplaywaveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses p3DataStruct, p3insight_common;

{$R *.dfm}

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

procedure TForm1.btnConvertClick(Sender: TObject);
var
  s: string;
begin
  s := Edit1.Text;
  s := SimpleBinToHex(s);
  Edit2.Text := s;
end;

procedure TForm1.btnConvertUnicodeClick(Sender: TObject);
var
  WS: WideString;
  s: string;
begin
  WS := Edit1.Text;
  SetLength(s, length(ws) * 2);
  Move(ws[1], s[1], length(s));
  s := SimpleBinToHex(s);
  Edit2.Text := s;
end;

procedure TForm1.btnConvertUtf8Click(Sender: TObject);
var
  s: string;
begin
  s := Edit1.Text;
  s := AnsiToUtf8(s);
  s := SimpleBinToHex(s);
  Edit2.Text := s;
end;


procedure TForm1.btnHexToStrClick(Sender: TObject);
var
  s: string;
begin
  s := SimpleHexToBin(Edit2.Text);
  Edit1.Text := s;
end;

procedure TForm1.btnplaywaveClick(Sender: TObject);
begin
  if JvWavePlayer1.Play() then
    Memo1.Lines.Add('ok')
  else
    Memo1.Lines.Add('failed');
end;

procedure TForm1.btnSingleClick(Sender: TObject);
var
  f: Single;
  pi: PInteger;
begin
  f := StrToFloat(Edit1.Text);
  pi := @f;
  Edit2.Text := '$' + IntToHex(pi^, 8);
end;

procedure TForm1.btnTestLoadConfClick(Sender: TObject);
begin
  Conf.load();
  Memo1.Lines.Add('Ok');
end;

procedure TForm1.btnSelftTestClick(Sender: TObject);
var
  s: TBusinessOffice;
  c: TCityStruct;

  procedure testOfs(name: string; offset, expected: integer);
  begin
    if offset <> expected then
      Memo1.Lines.Add('ERROR!!!,         ' + name + ' offset=' + IntToStr(offset) + ', but expected: ' + IntToStr(expected))
    else
      Memo1.Lines.Add(name + ' delta=' + IntToStr(offset));
  end;

  procedure showOffset(name: string; baseAddr, ofs: pointer);
  begin
    Memo1.Lines.Add('offset of ' + name + ' = ' + IntToStr(ptrDelta(baseAddr, ofs)));
  end;

begin

  Memo1.Lines.Add('business price delta=' + inttostr(ptrDelta(@s, @s.BusinessPrices[1])));
  Memo1.Lines.Add('satisfy of fuhao delta=' + IntToStr(ptrDelta(@c, @c.Satisfy_rich)));
  Memo1.Lines.Add('city stub3 delta=' + IntToStr(ptrDelta(@c, @c.stub3[1])));
  Memo1.Lines.Add('city orginal prod delta=' + IntToStr(ptrDelta(@c, @c.originalProd[0])));
  Memo1.Lines.Add('city stub3_1 delta=' + IntToStr(ptrDelta(@c, @c.stub3_1[1])));
  showOffset('BO.ShipWeapons', @s, @s.ShipWeapons);
  showOffset('BO.sword', @s, @s.Sword);
  showOffset('BO.HouseResidents ofs=', @s, @s.HouseResidents_[1]);
  testOfs('ship load restrict flags', ptrDelta(@s, @s.ShipLoadStrictFlags[1]), 948);

  testofs('ShipWeapons ofs=', ptrDelta(@c, @c.ShipWeapons[1]), 292);
  testofs('SwordStore ofs=', ptrDelta(@c, @c.SwordStore), 700);
  testOfs('whale oil ofs=', ptrDelta(@c, @c.WhaleOilProdRate), 716);
  testOfs('city.FirstUnfinishedBuildingIndex ofs=', ptrDelta(@c, @c.FirstUnfinishedBuildingIndex), 1890);
  testOfs('city.FirstBOIndex ofs=', ptrDelta(@c, @c.FirstBOIndex), 1924);

  testOfs('ChapelReq ofs=', ptrDelta(@c, @c.ChapelReq), 1904);
    testOfs('HospitalReq ofs=', ptrDelta(@c, @c.HospitalReq), 1906);
  testOfs('BuildingCount ofs=', ptrDelta(@c, @c.BuildingCount), 1910);

  testOfs('WellProv ofs=', ptrDelta(@c, @c.WellProv), 1929);

  testOfs('RoadReq ofs=', ptrDelta(@c, @c.Roadcomplete), 1936);
  testofs('UpgradeReq_ ofs=', ptrDelta(@c, @c.Church_UpgradeReq_), 1948);
  testOfs('DockyardExp ofs=', ptrDelta(@c, @c.DockyardExp), 2064);
  testOfs('DockyardLvl ofs=', ptrDelta(@c, @c.DockyardLvl[0]), 2084);
  testofs('OriginalProd ofs=', ptrDelta(@c, @c.OriginalProd), 2120);
  testOfs('Soldiers ofs=', ptrDelta(@c, @c.Soldiers), 2456);
  testOfs('BO.shipWeapons', ptrDelta(@s, @s.shipWeapons), 292);
  testOfs('BO.sword', ptrDelta(@s, @s.sword), 700);
  testofs('bo.Owner', ptrDelta(@s, @s.Owner), 708);
  testOfs('bo.NextBOIndexInSameCity', ptrDelta(@s, @s.NextBOIndexInSameCity), 714);
  testOfs('BO.houseResidents', ptrDelta(@s, @s.houseResidents_), 734);
  testOfs('Bo.RentIncoming', ptrDelta(@s, @s.RentIncoming), 1052);
  testOfs('Bo.LastWeekOfficeManagerPaid', ptrDelta(@s, @s.LastWeekOfficeManagerPaid), 1076);
  testOfs('Bo.StoreHouseMaxCap', ptrDelta(@s, @s.StoreHouseMaxCap), 748);
  testOfs('Bo.BusinessPrices', ptrDelta(@s, @s.BusinessPrices), 756);
  testOfs('Bo.BusinessLimits', ptrDelta(@s, @s.BusinessLimits), 852);
  testOfs('Bo.ShipLoadStrictFlags', ptrDelta(@s, @s.ShipLoadStrictFlags), 948);

  
  Memo1.Lines.Add('bo size=' + IntToStr(sizeof(tbusinessoffice)));


  p3DSSelfTest();

  ShowMessage('Ok');
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  h: THandle;
  Monitor: TMonitor;
begin
  h := FindWindow('OLLYDBG', nil);
  if h = 0 then
    Exit;

  if IsIconic(h) then
    ShowWindow(h, SW_RESTORE)
  else if IsZoomed(h) then
    ShowWindow(h, SW_RESTORE);

  if Screen.MonitorCount > 1 then
    Monitor := Screen.Monitors[1]
  else
    Monitor := Screen.Monitors[0];

  SetWindowPos(
          h,
          HWND_TOP,
          Monitor.Left,
          Monitor.Top,
          Monitor.Width,
          Monitor.Height,
          SWP_SHOWWINDOW);
end;

procedure TForm1.PDJButton1Click(Sender: TObject);
var
  btn: TPDJButton;
//  st:
begin
  btn := TPDJButton(sender);

end;

procedure TForm1.test1Click(Sender: TObject);
begin
//
end;

end.
