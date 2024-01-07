program P3BinEd;

uses
  Forms,
  P3BinEdMain in 'P3BinEdMain.pas' {frmExeBinEd};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmExeBinEd, frmExeBinEd);
  Application.Run;
end.
