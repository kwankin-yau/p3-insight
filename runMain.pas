unit runMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

const
  ACTION__LOAD = 1;
  ACTION__FREE = 2;

type
  TInjectLibA = function (hProc: THandle; libFile: PChar; actionFlag: Integer): BOOL; cdecl;
  TInjectLibW = function (hProc: THandle; libFile: PWideChar; actionFlag: Integer): BOOL; cdecl;

var
  InjLib: THandle;
  InjectLibA: TInjectLibA;
  InjectLibW: TInjectLibW;

procedure loadLib();
begin
  InjLib := LoadLibrary('InjLib.dll');

  if InjLib = 0 then
    RaiseLastOSError();

  InjectLibA := getprocAddress(InjLib, 'InjectLibA');
  if not Assigned(InjectLibA) then
    raise Exception.Create('no func');
  InjectLibW := getprocAddress(InjLib, 'InjectLibW');
  if not Assigned(InjectLibW) then
    raise Exception.Create('no func');
end;


procedure TForm1.Button1Click(Sender: TObject);
const
  target_home = 'E:\games\p3\p3.exe';
  target_off = 'V:\temp\p3\p3.exe';
var
  targets, dirs: string;
  dlls: WideString;
  p, dir: pchar;
  eddll: PWideChar;
  startInfo: TStartupInfo;
  pi: TProcessInformation;
  ok: Boolean;
  proc: THandle;
begin
  targets := target_off;
  dirs := ExtractFilePath(targets);
  dlls := ExtractFilePath(ParamStr(0)) + 'p3ed.dll';



  p := pchar(targets);
  dir := pchar(dirs);
  eddll := pwidechar(dlls);

//  if LoadLibraryW(eddll) = 0 then
//    RaiseLastOSError();
//
//  exit;
//  setprocess
//  if not InjectLibW(GetCurrentProcess(), eddll, ACTION__LOAD) then
//  begin
//    ShowMessage('inject error');
//  end;
//  Exit;

  FillChar(startInfo, SizeOf(startInfo), 0);
  startInfo.cb := SizeOf(startInfo);
  
  if not CreateProcess(nil, p, nil, nil, False, 0, nil, dir, startInfo, pi) then
    RaiseLastOSError();

  ok := False;

  try
    if WaitForInputIdle(pi.hProcess, 20*1000) = 0 then
    begin
//      OutputDebugString(pchar('process created.'));
//      if not InjectLibA(pi.hProcess, eddll, true) then
//        OutputDebugString('inject failed')
//      else
//        OutputDebugString('inject success');
      ok := True;
    end;
  finally
    CloseHandle(pi.hThread);
    CloseHandle(pi.hProcess);
  end;

  proc := OpenProcess(PROCESS_ALL_ACCESS, False, pi.dwProcessId);
  if proc = 0 then
    RaiseLastOSError();
  if not InjectLibW(proc, eddll, ACTION__LOAD) then
    OutputDebugString('inject failed')
  else
    OutputDebugString('inject success');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  loadLib();
end;

end.
