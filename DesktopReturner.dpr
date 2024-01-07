program DesktopReturner;

uses
  Forms,
  DesktopReturnerMain in 'DesktopReturnerMain.pas' {Form1},
  AxGameHackToolBox in 'AxGameHackToolBox.pas',
  MyGameTools in 'MyGameTools.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
