unit DesktopReturnerMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

type
  TForm1 = class(TForm)
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure OnWM_HOTKEY(var aMsg: TMessage); message WM_HOTKEY;

  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses AxGameHackToolBox, MyGameTools;

{$R *.dfm}

procedure TForm1.FormShow(Sender: TObject);
begin
  if not RegisterHotKey(Handle, 1, MOD_CONTROL or MOD_ALT, VK_F7) then
    RaiseLastOSError();
end;

procedure TForm1.OnWM_HOTKEY(var aMsg: TMessage);
var
  h: THandle;
begin
  h := GetForegroundWindow();
  if h <> Handle then
  begin
    BackToGameTools(h, Handle);
  end
  else
//  MessageBeep()
//  MessageBeep(MB_ICONEXCLAMATION);
//  WindowState := wsMinimized;
  SwitchToGame(Handle);
end;

end.
