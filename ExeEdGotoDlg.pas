unit ExeEdGotoDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ExeEdCommon;

type
  TExeEdGotoDlgIntf = class
  public
    IN_ParentFormHandle: THandle;
    OUT_Relative: TOffsetRelative;
    OUT_Offset: Integer;

    class function  directExec(
            const aIN_ParentFormHandle: THandle;
            out aOUT_Relative: TOffsetRelative;
            out aOUT_Offset: Integer): Boolean;
    static;

    function  Exec(): Boolean;
  public
  end;

  TfrmExeEdGoto = class(TForm)
    Label1: TLabel;
    edOffset: TEdit;
    rgRelative: TRadioGroup;
    btnOk: TButton;
    btnCancel: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    { Private declarations }
    fIntf: TExeEdGotoDlgIntf;
  protected
    procedure CreateParams(var aParams: TCreateParams); override;
  public
    { Public declarations }
    constructor Create(aIntf: TExeEdGotoDlgIntf); reintroduce;
  end;

var
  frmExeEdGoto: TfrmExeEdGoto;
  GlobalRelative: TOffsetRelative;
  GloablOffset: string;

implementation

{$R *.dfm}

{ TfrmExeEdGoto }

procedure TfrmExeEdGoto.btnOkClick(Sender: TObject);
var
  I: Integer;
begin
  I := StrToInt(edOffset.Text);
  GlobalRelative := ToffsetRelative(rgRelative.ItemIndex);
  GloablOffset := edOffset.Text;

  fIntf.OUT_Relative := GlobalRelative;
  fIntf.OUT_Offset := I;

  ModalResult := mrOk;
end;

constructor TfrmExeEdGoto.Create(aIntf: TExeEdGotoDlgIntf);
begin
  fIntf := aIntf;
  inherited Create (nil);
end;

procedure TfrmExeEdGoto.CreateParams(var aParams: TCreateParams);
begin
  inherited;
  aParams.WndParent := fIntf.IN_ParentFormHandle;
end;

procedure TfrmExeEdGoto.FormShow(Sender: TObject);
begin
  edOffset.Text := GloablOffset;
  rgRelative.ItemIndex := Ord(GlobalRelative);
end;

{ TExeEdGotoDlgIntf }

class function TExeEdGotoDlgIntf.directExec(const aIN_ParentFormHandle: THandle;
  out aOUT_Relative: TOffsetRelative; out aOUT_Offset: Integer): Boolean;
begin
  with TExeEdGotoDlgIntf.Create() do
  try
    IN_ParentFormHandle := aIN_ParentFormHandle;

    Result := Exec();

    if Result then
    begin
      aOUT_Relative := OUT_Relative;
      aOUT_Offset := OUT_Offset;
    end;
  finally
    Destroy();
  end;
end;

function TExeEdGotoDlgIntf.Exec: Boolean;
begin
  with TfrmExeEdGoto.Create(Self) do
  try
    Result := ShowModal() = mrOk;
  finally
    Destroy();
  end;
end;

end.
