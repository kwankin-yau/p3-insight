unit ExeBinEdMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, VirtualTrees, ExtCtrls, ComCtrls, JclPeImage, ExeEdCommon;

const
  MAX_FILE_SIZE = 1024 * 1024 * 256;

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
    edByteValue: TEdit;
    Label3: TLabel;
    btnSet: TButton;
    Button1: TButton;
    edWordValue: TEdit;
    Label4: TLabel;
    edDWordValue: TEdit;
    Button2: TButton;
    OpenDialog: TOpenDialog;
    StatusBar1: TStatusBar;
    lblSectionInfo: TLabel;
    cbUnsigned: TCheckBox;
    miBackupFile: TMenuItem;
    N1: TMenuItem;
    SaveDialog: TSaveDialog;
    Search1: TMenuItem;
    miGoto: TMenuItem;
    Label5: TLabel;
    edTextValue: TMemo;
    gbCodePage: TGroupBox;
    rgCP_GB2312: TRadioButton;
    rgUnicode: TRadioButton;
    Label6: TLabel;
    lblOfs: TLabel;
    Label111: TLabel;
    lblDelta: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure miExitClick(Sender: TObject);
    procedure miOpenClick(Sender: TObject);
    procedure ImageGridGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure cbSectionsChange(Sender: TObject);
    procedure ImageGridBeforeCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellRect: TRect);
    procedure ImageGridHeaderDraw(Sender: TVTHeader; HeaderCanvas: TCanvas;
      Column: TVirtualTreeColumn; R: TRect; Hover, Pressed: Boolean;
      DropMark: TVTDropMarkMode);
    procedure ImageGridFocusChanging(Sender: TBaseVirtualTree; OldNode,
      NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex;
      var Allowed: Boolean);
    procedure ImageGridPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
    procedure ImageGridFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure cbUnsignedClick(Sender: TObject);
    procedure miBackupFileClick(Sender: TObject);
    procedure miGotoClick(Sender: TObject);
    procedure ImageGridChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
  private
    { Private declarations }
    fImage: TJclPeImage;
    fModified: Boolean;
    fFileName: WideString;
//    fFileHandle: THandle;
//    fFileMap: THandle;
    fFileView: PByte;
    fFileSize: Integer;
    fCurrSectionPhysOffset: Integer;
    fCurrSectionPtr: PByte;
    fCurrSectionSz: Integer;

    procedure doCloseFile();
    procedure doOpen(const aFileName: WideString);
    procedure PeLoaded();
    procedure reloadCurrSectionContent();
    procedure clearCurrSectionContent();

    function  findSectionIndex(const aAbsoluteOffset: Integer; out aSectionIndex: Integer; out aSectionOffset: Integer): Boolean;
    procedure internalSetCurrSectionInfo(const aHeader: TImageSectionHeader);


    procedure offsetToRowCol(aOffset: Integer; out aRow, aCol: Integer);

    function  getNodeByIndex(aIndex: Integer): PVirtualNode;
    function  getCurrFocusedOffset(): Integer;
    procedure setCurrFocused(const row, col: Integer);
  private
    fInternalUpdate: Integer;

    procedure doSave();
  private
    procedure updateLoadedFile();
    procedure updateCurrValue();  
  private
    function  getRowOffset(const aRowIndex: Integer): Integer;
    function  getColOffset(const aRow, aCol: Integer): Integer;
  public
    { Public declarations }
  end;

var
  frmExeBinEd: TfrmExeBinEd;

implementation
uses
  MyCommonDialogs, ExeEdGotoDlg;

{$R *.dfm}

function  intToHex8(const I: Integer): string;
begin
  Result := '$' + IntToHex(I, 8);
end;

function  ptrToHex8(const P: Pointer): string;
begin
  Result := '$' + IntToHex(Integer(p), 8);
end;

function  byteToHex2(const B: Byte; const aHexPrefix: Boolean): string;
begin
  Result := IntToHex(b, 2);
  if aHexPrefix then
    Result := '$' + Result;
end;

function  strLenMax(p: PChar; const aMaxLen: Integer): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to aMaxLen - 1 do
  begin
    if p^ <> #0 then
    begin
      Inc(Result);
      Inc(p);
    end
    else
      Break;
  end;
end;

function  strLenMaxW(p: PWideChar; aMaxLen: Integer): Integer;
var
  I: Integer;
begin
  aMaxLen := aMaxLen div SizeOf(WideChar);
  Result := 0;
  for I := 0 to aMaxLen - 1 do
  begin
    if p^ <> #0 then
    begin
      Inc(Result);
      Inc(p);
    end
    else
      Break;
  end;
end;


procedure TfrmExeBinEd.cbSectionsChange(Sender: TObject);
var
  Header: TImageSectionHeader;
begin
  if fInternalUpdate > 0 then
    Exit;

  if (fImage = nil) or (cbSections.ItemIndex < 0) then
  begin
    fCurrSectionPhysOffset := 0;
    fCurrSectionPtr := nil;
    fCurrSectionSz := 0;
  end
  else
  begin
    Header := fImage.ImageSectionHeaders[cbSections.ItemIndex];
    
    fCurrSectionPhysOffset := Header.PointerToRawData;
    fCurrSectionPtr := fFileView;
    Inc(fCurrSectionPtr, Header.PointerToRawData);
    fCurrSectionSz := Header.SizeOfRawData;
  end;


  reloadCurrSectionContent();
end;

procedure TfrmExeBinEd.cbUnsignedClick(Sender: TObject);
begin
  updateCurrValue();
end;

procedure TfrmExeBinEd.clearCurrSectionContent;
begin
//  fCurrSectionPtr := nil;
//  fCurrSectionSz := 0;
  lblSectionInfo.Caption := '';
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
    fFileSize := 0;
    fFileView := nil;
    fCurrSectionPhysOffset := 0;
    fCurrSectionPtr := nil;
    fCurrSectionSz := 0;
  finally
    Dec(fInternalUpdate);
  end;
end;

procedure TfrmExeBinEd.doOpen(const aFileName: WideString);
var
  I64: Int64;
  I64Struct: Int64Rec absolute I64;
  FS: TFileStream;
begin
  fImage := TJclPeImage.Create(False);
  try
    FS := TFileStream.Create(aFileName, fmOpenRead or fmShareDenyWrite);
    try
      fFileSize := FS.Size;
      if fFileSize = 0 then
        raise Exception.Create('The file is empty.');
      if fFileSize > MAX_FILE_SIZE then
        raise Exception.Create('The file is too large.');

      GetMem(fFileView, fFileSize);
      FS.ReadBuffer(fFileView^, fFileSize);
    finally
      FS.Destroy();
    end;

    fImage.FileName := aFileName;
    if not fImage.StatusOK() then
      raise Exception.Create('Bad Pe image!');
  except
    doCloseFile();
    raise;
  end;

  fFileName := aFileName;

  PeLoaded();
end;

procedure TfrmExeBinEd.doSave;
begin
//  DoClose;
end;

function TfrmExeBinEd.findSectionIndex(
        const aAbsoluteOffset: Integer;
        out aSectionIndex: Integer;
        out aSectionOffset: Integer): Boolean;
var
  I: Integer;
  Header: TImageSectionHeader;
begin
  Result := False;
  aSectionIndex := -1;
  aSectionOffset := -1;
  if fImage = nil then
    Exit;

  for I := 0 to fImage.ImageSectionCount - 1 do
  begin
    Header := fImage.ImageSectionHeaders[I];
    if (aAbsoluteOffset >= Header.PointerToRawData)
    and (aAbsoluteOffset < Header.PointerToRawData + Header.SizeOfRawData) then
    begin
      aSectionIndex := I;
      aSectionOffset := aAbsoluteOffset - Header.PointerToRawData;
      Result := True;
      Exit;
    end;
  end;
end;

procedure TfrmExeBinEd.FormCreate(Sender: TObject);
//var
//  I: Integer;
begin
  ImageGrid.DefaultText := '';
  ImageGrid.NodeDataSize := SizeOf(Pointer);

//  for I := 0 to ImageGrid.Header.Columns.Count - 1 do
//  begin
//    ImageGrid.Header.Columns[I].Index := I;
//  end;
end;

function TfrmExeBinEd.getColOffset(const aRow, aCol: Integer): Integer;
begin
  Result := getRowOffset(aRow) + aCol;
end;

function TfrmExeBinEd.getCurrFocusedOffset: Integer;
var
  Offset, Idx: Integer;
  N: PVirtualNode;
begin
  N := ImageGrid.SelectedNode;

  if (N = nil) or (ImageGrid.FocusedColumn <= 0) then
    Result := -1
  else
  begin
    Result := getColOffset(ImageGrid.GetNodeUserDataInt(N), ImageGrid.FocusedColumn-1);
  end;
end;

function TfrmExeBinEd.getNodeByIndex(aIndex: Integer): PVirtualNode;
begin
  Result := ImageGrid.GetFirst();

  while aIndex > 0 do
  begin
    Dec(aIndex);
    Result := ImageGrid.GetNext(Result);
  end;   
end;

function TfrmExeBinEd.getRowOffset(const aRowIndex: Integer): Integer;
begin
  Result := aRowIndex * 16;
end;

procedure TfrmExeBinEd.ImageGridBeforeCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellRect: TRect);
var
  BkClr: TColor;
begin
  if (Column <> 0) and ((Node = Sender.SelectedNode) or (Column = Sender.FocusedColumn)) then
    BkClr := $009FEAFD
  else
  begin
    case Column of
      0: BkClr := clBtnFace;
      1..4, 9..12: BkClr := clWindow;
    else
      BkClr := $00EFEFEF;
    end;     
  end;

  TargetCanvas.Brush.Color := BkClr;
  TargetCanvas.FillRect(CellRect);
end;

procedure TfrmExeBinEd.ImageGridChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  updateCurrValue();
end;

procedure TfrmExeBinEd.ImageGridFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  updateCurrValue();
end;

procedure TfrmExeBinEd.ImageGridFocusChanging(Sender: TBaseVirtualTree; OldNode,
  NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex;
  var Allowed: Boolean);
begin
  Allowed := True;
  ImageGrid.InvalidateColumn(OldColumn);
  ImageGrid.InvalidateColumn(NewColumn);
end;

procedure TfrmExeBinEd.ImageGridGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  row, off: Integer;
  p: PByte;
  v: Byte;
  s, s1, s2: string;
begin
  if (fImage = nil) or (fCurrSectionPtr = nil) then
    Exit;

  row := Sender.GetNodeUserDataInt(Node);

  if Column = 0 then
  begin
    off := fCurrSectionPhysOffset + getRowOffset(row);
    CellText := intToHex8(off);
    s := intToHex8(off);
    Insert(' ', s, 6);
    CellText := s;
    exit;
  end;

  off := getColOffset(row, Column-1);
  if (off + fCurrSectionPhysOffset) >= fFileSize then
    v := 0
  else
  begin
    p := fCurrSectionPtr;
    Inc(p, off);
    v := p^;
  end;

  CellText := byteToHex2(v, False);
end;

procedure TfrmExeBinEd.ImageGridHeaderDraw(Sender: TVTHeader;
  HeaderCanvas: TCanvas; Column: TVirtualTreeColumn; R: TRect; Hover,
  Pressed: Boolean; DropMark: TVTDropMarkMode);
var
  DC: HDC;
//  idx: Integer;
begin
  case Column.Index of
    0, 1, 5, 9, 13:
    begin
      HeaderCanvas.Font.Style := [fsBold];
    end;

  else
    HeaderCanvas.Font.Style := [];
  end;

  DC := HeaderCanvas.Handle;

  InflateRect(R, -1, -3);
  SetBkMode(DC, TRANSPARENT);

  DrawTextW(
          DC,
          PWideChar(Column.Text),
          Length(Column.Text),
          R,
          DT_SINGLELINE or DT_LEFT or DT_VCENTER,
          False);
end;

procedure TfrmExeBinEd.ImageGridPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
  case Column of
    0, 1, 5, 9, 13:
    begin
      TargetCanvas.Font.Style := [fsBold];
    end;

  else
    TargetCanvas.Font.Style := [];
  end;
end;

procedure TfrmExeBinEd.internalSetCurrSectionInfo(
  const aHeader: TImageSectionHeader);
begin
  fCurrSectionPhysOffset := aHeader.PointerToRawData;
  fCurrSectionPtr := fFileView;
  Inc(fCurrSectionPtr, aHeader.PointerToRawData);
  fCurrSectionSz := aHeader.SizeOfRawData;
end;

procedure TfrmExeBinEd.miBackupFileClick(Sender: TObject);
var
  FS, FSBk: TFileStream;
begin
  if fFileName = '' then
    raise Exception.Create('No file open.');
    
  if not SaveDialog.Execute(Handle) then
    Exit;

  FS := TFileStream.Create(fFileName, fmOpenRead or fmShareDenyWrite);
  try
    FSBk := TFileStream.Create(SaveDialog.FileName, fmCreate);
    try
      FSBk.CopyFrom(FS, 0);
    finally
      FSBk.Destroy();
    end;
  finally
    FS.Destroy();
  end;
end;

procedure TfrmExeBinEd.miExitClick(Sender: TObject);
begin
  Close();
end;

procedure TfrmExeBinEd.miGotoClick(Sender: TObject);
var
  Relative: TOffsetRelative;
  Offset, row, col, CurrOffset: Integer;
  Idx: Integer;
  Header: TImageSectionHeader;
  N: PVirtualNode;
begin
  if fImage = nil then
    raise Exception.Create('No file open.');

  if not TExeEdGotoDlgIntf.directExec(
          Handle,
          Relative,
          Offset) then
    Exit;

  case Relative of
    OR_Absolute:
    begin
      if Offset < 0 then
        raise Exception.Create('Invalid offset: ' + intToHex8(Offset));

      if not findSectionIndex(Offset, idx, Offset) then
        raise Exception.Create('Invalid offset: ' + intToHex8(Offset));

      Header := fImage.ImageSectionHeaders[Idx];
      Inc(fInternalUpdate);
      try
        internalSetCurrSectionInfo(Header);

        cbSections.ItemIndex := Idx;
        reloadCurrSectionContent();

        offsetToRowCol(Offset, row, col);
        setCurrFocused(row, col);
      finally
        Dec(fInternalUpdate);
      end;
    end;
    
    OR_Section:
    begin
      if (Offset < 0) or (Offset >= fCurrSectionSz) then
        raise Exception.Create('Invalid offset: ' + intToHex8(Offset));

      offsetToRowCol(Offset, row, col);
      setCurrFocused(row, col);
    end;
    
    OR_CurrPos:
    begin
      CurrOffset := getCurrFocusedOffset();
      if CurrOffset < 0 then
        raise Exception.Create('Can not determine current position.');

      offsetToRowCol(CurrOffset, row, col);
      setCurrFocused(row, col);
    end;
  end;
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

  doCloseFile();

  doOpen(OpenDialog.FileName);
end;

procedure TfrmExeBinEd.offsetToRowCol(aOffset: Integer; out aRow,
  aCol: Integer);
begin
  aRow := aOffset div 16;
  aCol := aOffset mod 16;
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

    fCurrSectionPtr := nil;
    fCurrSectionPhysOffset := 0;
    fCurrSectionSz := 0;

    if fImage = nil then
      Exit;

    for I := 0 to fImage.ImageSectionCount - 1 do
    begin
      Header := fImage.ImageSectionHeaders[I];
      cbSections.Items.AddObject(fImage.ImageSectionNames[I], TObject(I));

      if fCurrSectionPtr = nil then
      begin
        fCurrSectionPhysOffset := Header.PointerToRawData;
        fCurrSectionPtr := fFileView;
        Inc(fCurrSectionPtr, Header.PointerToRawData);
        fCurrSectionSz := Header.SizeOfRawData;
      end;
    end;

    if cbSections.Items.Count > 0 then
      cbSections.ItemIndex := 0;

    reloadCurrSectionContent();
  finally
    Dec(fInternalUpdate);
    updateLoadedFile();
  end;
end;

procedure TfrmExeBinEd.reloadCurrSectionContent;
var
  I, Idx, Row: Integer;
  Header: TJclPeSectionStream;
begin
  lblSectionInfo.Caption := '';
  ImageGrid.CancelEditNode();
  ImageGrid.BeginUpdate();
  try
    ImageGrid.Clear();
    if fImage = nil then
      Exit;

    if fCurrSectionPtr = nil then
      Exit;

    if fCurrSectionSz = 0 then
      Exit;

    Row := fCurrSectionSz div 16;
    if fCurrSectionSz and 1 <> 0 then
      Inc(Row);

    lblSectionInfo.Caption := '(Sz:' + intToHex8(fCurrSectionSz)
            + ', Ofs:' + intToHex8(fCurrSectionPhysOffset) + ')'; 
      
    for I := 0 to Row - 1 do
    begin
      ImageGrid.AddChild(nil, Pointer(I));
    end;
  finally
    ImageGrid.EndUpdate();
  end;
end;

procedure TfrmExeBinEd.setCurrFocused(const row, col: Integer);
var
  N: PVirtualNode;
begin
  N := getNodeByIndex(row);
  if N = nil then
    ImageGrid.ClearSelection()
  else
  begin
    ImageGrid.SelectNode(N);
    ImageGrid.FocusedColumn := col + 1;
    ImageGrid.ScrollIntoView(N, True, False);
  end;
end;

procedure TfrmExeBinEd.updateCurrValue;
var
  row, col, len, mL: Integer;
  off, off2: Integer;
//  b: Byte;
//  w: Word;
//  dw: DWORD;
  p: PByte;
  I64: Int64;

  vShortInt: Shortint;
  vSmallInt: Smallint;
  vInt: Longint;
  S: string;
  WS: WideString;

  function  testSize(sz: Integer): Boolean;
  begin
    Result := (fCurrSectionPhysOffset + off + sz) <= fFileSize;
  end;

begin
  if (fCurrSectionPtr = nil) or (ImageGrid.SelectedNode = nil)
  or (ImageGrid.FocusedColumn <= 0) then
  begin
    edByteValue.Text := '';
    edWordValue.Text := '';
    edDWordValue.Text := '';
    edTextValue.Text := '';
    lblOfs.Caption := '';
    lblDelta.Caption := '';
    Exit;
  end;

  row := ImageGrid.GetNodeUserDataInt(ImageGrid.SelectedNode);
  off := getColOffset(row, ImageGrid.FocusedColumn-1);


  s := intToHex8(off);
  Insert(' ', s, 6);
  lblDelta.Caption := s;

  off2 := fCurrSectionPhysOffset + off;
  s := intToHex8(off2);
  Insert(' ', s, 6);
  lblOfs.Caption := s;

  p := fCurrSectionPtr;
  Inc(p, off);

  if not testSize(sizeof(byte)) then
  begin
    edByteValue.Text := '';
  end
  else
  begin
    if cbUnsigned.Checked then
    begin
      I64 := p^;
    end
    else
    begin
      vShortInt := p^;
      I64 := vShortInt;
    end;
    edByteValue.Text := IntToStr(I64);
  end;

  if not testSize(SizeOf(word)) then
  begin
    edWordValue.Text := '';
  end
  else
  begin
    if cbUnsigned.Checked then
    begin
      I64 := PWord(p)^;
    end
    else
    begin
      vSmallInt := PWord(p)^;
      I64 := vSmallInt;
    end;

    edWordValue.Text := IntToStr(I64);
  end;

  if not testSize(sizeof(longword)) then
    edDWordValue.Text := ''
  else
  begin
    if cbUnsigned.Checked then
      I64 := PLongWord(p)^
    else
    begin
      vInt := PLongWord(p)^;
      I64 := vInt;
    end;

    edDWordValue.Text := IntToStr(I64);
  end;

  len := fFileSize - (fCurrSectionPhysOffset + off);

  if rgCP_GB2312.Checked then
    mL := 128
  else
    mL := 256;
  if len > mL then
    len := mL;

  if rgCP_GB2312.Checked then
  begin
    len := strLenMax(Pointer(p), len);
    SetString(S, pchar(p), len);
    edTextValue.Text := S;
  end
  else
  begin
    len := strLenMaxW(Pointer(p), len);
    SetString(S, PWideChar(p), len);
    edTextValue.Text := S;
  end;
end;

procedure TfrmExeBinEd.updateLoadedFile;
var
  S: WideString;
begin
  S := fFileName;
  if fModified then
    S := '*'
  else
    S := '';

  StatusBar1.Panels[1].Text := S;
  StatusBar1.Panels[2].Text := fFileName;
end;

end.
