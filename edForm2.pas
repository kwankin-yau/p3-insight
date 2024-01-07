unit edForm2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TP3EdR2DlgIntf = class
  public
    IN_ParentFormHandle: THandle;

    class procedure directExec(const aIN_ParentFormHandle: THandle);
    static;
    procedure exec();
  end;
  
  TfrmP3EdR2 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    fIntf: TP3EdR2DlgIntf;
  public
    { Public declarations }
    procedure CreateParams(var aParams: TCreateParams); override;
  public
    constructor Create(aIntf: TP3EdR2DlgIntf); reintroduce;
  end;

var
  frmP3EdR2: TfrmP3EdR2;

implementation

uses edForm;

{$R *.dfm}

{ TfrmP3EdR2 }

procedure TfrmP3EdR2.Button1Click(Sender: TObject);
begin
  Close();
end;

constructor TfrmP3EdR2.Create(aIntf: TP3EdR2DlgIntf);
begin
  fIntf := aIntf;
  inherited Create (nil);
end;

procedure TfrmP3EdR2.CreateParams(var aParams: TCreateParams);
begin
  inherited;
    aParams.ExStyle := aParams.ExStyle or WS_EX_TOPMOST;
    aParams.Style := aParams.Style or WS_POPUP;
    aParams.WndParent := fIntf.IN_ParentFormHandle;
end;

procedure TfrmP3EdR2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  ShowCursor(False);
//  EnableWindow(fIntf.IN_ParentFormHandle, True);
  PostMessage(fIntf.IN_ParentFormHandle, SetFocusMsgID, 0, 2);
end;

procedure TfrmP3EdR2.FormCreate(Sender: TObject);
begin
//  DoubleBuffered := True;
end;

procedure TfrmP3EdR2.FormDestroy(Sender: TObject);
begin
  OutputDebugString('Destroy!');
end;

procedure TfrmP3EdR2.FormShow(Sender: TObject);
begin
//  EnableWindow(fIntf.IN_ParentFormHandle, False);
  Left := 0;
  Top := 0;
  Width := Screen.Width;
  Height := Screen.Height;

  ShowCursor(True);
  BringToFront();
  SetFocus();
//  SetCapture(Handle);
end;

{ TP3EdR2DlgIntf }

class procedure TP3EdR2DlgIntf.directExec(const aIN_ParentFormHandle: THandle);
begin
  with TP3EdR2DlgIntf.Create() do
  try
    IN_ParentFormHandle := aIN_ParentFormHandle;

    exec();
  finally
    Destroy();
  end;
end;

procedure TP3EdR2DlgIntf.exec;
begin
  with TfrmP3EdR2.Create(Self) do
  try
    ShowModal();
  finally
    Release();
  end;
end;

end.
