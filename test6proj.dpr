program test6proj;

uses
  Forms,
  test6main in 'test6main.pas' {Form1},
  p3DataStruct in 'p3DataStruct.pas',
  p3insight_common in 'p3insight_common.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
