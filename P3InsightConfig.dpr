program P3InsightConfig;

uses
  Forms,
  P3InsightConfigurerMain in 'P3InsightConfigurerMain.pas' {P3InsightSetup},
  p3insight_common in 'p3insight_common.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TP3InsightSetup, P3InsightSetup);
  Application.Run;
end.
