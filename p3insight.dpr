library p3insight;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  SysUtils,
  Classes,
  Windows,
  Forms,
  MyGameTools in 'MyGameTools.pas',
  p3DataStruct in 'p3DataStruct.pas',
  p3hack in 'p3hack.pas',
  AxGameHackToolBox in 'AxGameHackToolBox.pas',
  BMSEARCH in 'BMSEARCH.PAS',
  p3insight_common in 'p3insight_common.pas',
  p3insight_utils in 'p3insight_utils.pas',
  P3InsightMain in 'P3InsightMain.pas' {frmP3Insight},
  P3InsightUICommon in 'P3InsightUICommon.pas',
  P3InsightUICityView in 'P3InsightUICityView.pas',
  p3insight_test in 'p3insight_test.pas' {frmTest},
  p3Maps in 'p3Maps.pas',
  p3Types in 'p3Types.pas',
  myDetours in 'myDetours.pas';

{$R *.res}

var
  init: Boolean = False;
begin
  if not init then
  begin
    init := True;
    try
      p3HackInit();

//      OutputDebugString('conf loading...');

      Conf.load();

//      OutputDebugString('conf loaded.');

      p3hack.patchP3();

//      OutputDebugString('patched');
      p3hack.modP3(Conf.ModItems);

      p3hack.attachP3();

//      OutputDebugString('Ok');
    except
      on E: Exception do
      begin
        OutputDebugString(pchar(e.Message));
        raise;
      end;
    else
      raise;
    end;
  end;
end.
