program Painter;

uses
  Forms,
  painterMain in 'painterMain.pas' {Form1},
  CityPos in 'CityPos.pas',
  p3Maps in 'p3Maps.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
