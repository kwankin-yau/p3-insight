unit P3BinEdMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, VirtualTrees, ExtCtrls, ComCtrls, JclPeImage;

type
  TfrmExeBinEd = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    miExit: TMenuItem;
    miOpen: TMenuItem;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel1: TPanel;
    ImageGrid: TVirtualStringTree;
    Panel2: TPanel;
    Label1: TLabel;
    cbSections: TComboBox;
    Panel3: TPanel;
    Label2: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    btnSet: TButton;
    Button1: TButton;
    Edit2: TEdit;
    Label4: TLabel;
    Edit3: TEdit;
    Button2: TButton;
    OpenDialog: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure miExitClick(Sender: TObject);
    procedure miOpenClick(Sender: TObject);
  private
    { Private declarations }
    fImage: TJclPeImage;
    fModified: Boolean;
    fFileName: WideString;
    fFileHandle: THandle;

    procedure doCloseFile();
    procedure doOpen(const aFileName: WideString);
    procedure PeLoaded();
    procedure reloadCurrSectionContent();
    procedure clearCurrSectionContent();
  private
    fInternalUpdate: Integer;

    procedure doSave();
  public
    { Public declarations }
  end;

var
  frmExeBinEd: TfrmExeBinEd;

implementation
uses
  MyCommonDialogs;

{$R *.dfm}

procedure TfrmExeBinEd.clearCurrSectionContent;
begin
  ImageGrid.CancelEditNode();
  ImageGrid.Clear();
end;

procedure TfrmExeBinEd.doCloseFile;
begin
  Inc(fInternalUpdate);
  try
    ImageGrid.Clear();
    cbSections.Items.Clear();

    FreeAndNil(fImage);
    fFileName := '';
    fModified := False;
    CloseHandle(fFileHandle);
  finally
    Dec(fInternalUpdate);
  end;
end;

procedure TfrmExeBinEd.doOpen(const aFileName: WideString);
begin
  fImage := TJclPeImage.Create(False);
  try
    fImage.FileName := aFileName;
    if not fImage.StatusOK() then
      raise Exception.Create('Bad Pe image!');
      
    fFileHandle := CreateFileW(
            PWideChar(aFileName),
            GENERIC_READ or GENERIC_WRITE,
            FILE_SHARE_READ,
            nil,
            OPEN_EXISTING,
            0,
            0);

    if fFileHandle = INVALID_HANDLE_VALUE then
      raise Exception.Create('Open file failed.');
  except
    fImage.Destroy();
    raise;
  end;


  
  fFileName := aFileName;

  PeLoaded();
end;

procedure TfrmExeBinEd.doSave;
begin

end;

procedure TfrmExeBinEd.FormCreate(Sender: TObject);
begin
  ImageGrid.NodeDataSize := SizeOf(Pointer);
end;

procedure TfrmExeBinEd.miExitClick(Sender: TObject);
begin
  Close();
end;

procedure TfrmExeBinEd.miOpenClick(Sender: TObject);
begin
  if fModified then
  begin
    case QYesNoCancelBox(
            'The file was modified, do you want to save it before close?',
            Self,
            MB_DEFBUTTON1,
            'Close') of
      IDYES:
      begin
        doSave();
      end;

      IDNO:
      begin
      //nop
      end;

      IDCANCEL:
      begin
        Exit;
      end;
    end;
  end;

  if not OpenDialog.Execute(Handle) then
    Exit;

  doCloseFile();v

  doOpen(fFileName);
end;

procedure TfrmExeBinEd.PeLoaded;
var
  I: Integer;
  Header: TImageSectionHeader;
begin
  Inc(fInternalUpdate);
  try
    clearCurrSectionContent();
    
    cbSections.Items.Clear();

    if fImage = nil then
      Exit;

    for I := 0 to fImage.ImageSectionCount - 1 do
    begin
      Header := fImage.ImageSectionHeaders[I];
      cbSections.Items.AddObject(fImage.ImageSectionNames[I], TObject(I));
    end;

    if cbSections.Items.Count > 0 then
      reloadCurrSectionContent()
    else
      clearCurrSectionContent();
  finally
    Dec(fInternalUpdate);
  end;
end;

procedure TfrmExeBinEd.reloadCurrSectionContent;
begin
  ImageGrid.CancelEditNode();
  ImageGrid.BeginUpdate();
  try
    ImageGrid.Clear();
    if fImage = nil then
      Exit;

    //
  finally
    ImageGrid.EndUpdate();
  end;
end;

end.
