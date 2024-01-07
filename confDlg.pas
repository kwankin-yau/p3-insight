unit confDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TConfirmDlgIntf = class
  public
    IN_ParentFormHandle: THandle;
    IN_Caption: WideString;
    IN_Prompt: WideString;
    INOUT_Value: string;

    class function  directExec(
            const aIN_ParentFormHandle: THandle;
            const aIN_Caption: WideString;
            const aIN_Prompt: WideString;
            var aINOUT_Value: string): Boolean;
    static;

    function  exec(): Boolean;
  end;

  TfrmConfirm = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    btnOk: TButton;
    btnCancel: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    { Private declarations }
    fIntf: TConfirmDlgIntf;
  protected
    procedure CreateParams(var aParams: TCreateParams); override;
  public
    { Public declarations }
    constructor Create(aIntf: TConfirmDlgIntf); reintroduce;
  end;

var
  frmConfirm: TfrmConfirm;

implementation

{$R *.dfm}

{ TfrmConfirm }

procedure TfrmConfirm.btnOkClick(Sender: TObject);
begin
  fIntf.INOUT_Value := Edit1.Text;
  ModalResult := mrOk;
end;

constructor TfrmConfirm.Create(aIntf: TConfirmDlgIntf);
begin
  fIntf := aIntf;
  inherited Create (nil);
end;

procedure TfrmConfirm.CreateParams(var aParams: TCreateParams);
begin
  inherited;
  aParams.WndParent := fIntf.IN_ParentFormHandle;
end;

procedure TfrmConfirm.FormShow(Sender: TObject);
begin
  Caption := fIntf.IN_Caption;
  Label1.Caption := fIntf.IN_Prompt;
  Edit1.Text := fIntf.INOUT_Value;
end;

{ TConfirmDlgIntf }

class function TConfirmDlgIntf.directExec(const aIN_ParentFormHandle: THandle;
  const aIN_Caption, aIN_Prompt: WideString; var aINOUT_Value: string): Boolean;
begin
  with TConfirmDlgIntf.Create() do
  try
    IN_ParentFormHandle := aIN_ParentFormHandle;
    IN_Caption := aIN_Caption;
    IN_Prompt := aIN_Prompt;

    INOUT_Value := aINOUT_Value;

    Result := exec();

    if Result then
      aINOUT_Value := INOUT_Value;
  finally
    Destroy();
  end;
end;

function TConfirmDlgIntf.exec: Boolean;
begin
  with TfrmConfirm.Create(Self) do
  try
    Result := ShowModal() = mrOk;
  finally
    Destroy();
  end;
end;

end.
