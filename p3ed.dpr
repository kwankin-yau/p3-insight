library p3ed;

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
  edThread in 'edThread.pas',
  edForm in 'edForm.pas' {frmP3Editor},
  p3DataStruct in 'p3DataStruct.pas',
  AxGameHackToolBox in 'AxGameHackToolBox.pas',
  confDlg in 'confDlg.pas' {frmConfirm},
  edAttach in 'edAttach.pas',
  MyGameTools in 'MyGameTools.pas',
  MP in 'MP.pas',
  DxVBLib_TLB in 'DxVBLib_TLB.pas',
  HookApi in 'HookApi.pas',
  edForm2 in 'edForm2.pas' {frmP3EdR2},
  edForm3 in 'edForm3.pas',
  p3Hook in 'p3Hook.pas',
  pedump in 'pedump.pas',
  p3insight_utils in 'p3insight_utils.pas';

{$R *.res}

const
  WndClassName = 'Afx:400000:3:0:1900011:0';

  WndText = '´ó º½ º£ ¼Ò 3';

var
  hWnd: THandle;
{$IFNDEF INTERNAL_WND}
  Thread: TEdThread;
{$ENDIF}

  procedure doAttach();
  begin
    hWnd := FindWindow(WndClassName, WndText);

    if hWnd <> 0 then
    begin
      patchP3();
      {$IFDEF INTERNAL_WND}
      attachTop3(hWnd);
      {$ELSE}
      Thread := TEdThread.Create(hWnd);
      Thread.Resume();
      {$ENDIF}
    end
    else
      OutputDebugString('Game not started or not found.');
  end;

  procedure dllHandler(reason: Integer);
  begin
    case reason of
      DLL_PROCESS_ATTACH:
      begin
        P3ModuleHandle := GetModuleHandle('p3.exe');
        if P3ModuleHandle = 0 then
        begin
          OutputDebugString('P3 module not found.');
          exit;
        end;
          
//        dumpP3header();
        doAttach();
      end;
    end;
  end;



begin
  DllProc := dllHandler;
  dllHandler(DLL_PROCESS_ATTACH);
end.
