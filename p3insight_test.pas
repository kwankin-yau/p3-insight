unit p3insight_test;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

type
  TTestDlgIntf = class
  public
    IN_ParnetHandle: THandle;

    class procedure directExec(const aIN_ParentHandle: THandle);
    static;

    procedure exec();
  end;
  
  TfrmTest = class(TForm)
  private
    { Private declarations }
    fIntf: TTestDlgIntf;
  protected
    procedure CreateParams(var aParams: TCreateParams); override;
  public
    { Public declarations }
    constructor Create(aIntf: TTestDlgIntf); reintroduce;
  end;

var
  frmTest: TfrmTest;

implementation

{$R *.dfm}

{ TfrmTest }

constructor TfrmTest.Create(aIntf: TTestDlgIntf);
begin
  fIntf := aIntf;
  inherited Create (nil);
end;

procedure TfrmTest.CreateParams(var aParams: TCreateParams);
begin
  inherited;
  aParams.WndParent := fIntf.IN_ParnetHandle;
end;

{ TTestDlgIntf }

class procedure TTestDlgIntf.directExec(const aIN_ParentHandle: THandle);
begin
  with TTestDlgIntf.Create() do
  try
    IN_ParnetHandle := aIN_ParentHandle;
    exec();
  finally
    Destroy();
  end;
end;

procedure TTestDlgIntf.exec;
begin
  with TfrmTest.Create(Self) do
  try
    ShowModal();
  finally
    Release();
  end;
end;

end.
