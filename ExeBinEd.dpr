program ExeBinEd;

uses
  Forms,
  ExeBinEdMain in 'ExeBinEdMain.pas' {frmExeBinEd},
  ExeEdGotoDlg in 'ExeEdGotoDlg.pas' {frmExeEdGoto},
  ExeEdCommon in 'ExeEdCommon.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmExeBinEd, frmExeBinEd);
  Application.Run;
end.
