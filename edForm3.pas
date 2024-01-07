unit edForm3;

interface
uses
  SysUtils, Classes, Windows, Messages;






implementation

function  f3WndProc(wnd: HWND; uMsg: UINT; wP: WPARAM; lp: LPARAM): LRESULT; stdcall;
begin
  Result := DefWindowProc(wnd, uMsg, wP, lp);
end;

end.
