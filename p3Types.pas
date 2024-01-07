unit p3Types;

interface
uses
  SysUtils, Classes, Windows;

type
  TCityIconType = (
    CI__RED,
    CI__RED_BLUE,
    CI__BLUE
  );
  
  TGoodsImageProvider = class
  public
    function  get(const aGoodsID: Integer): HDC; virtual; abstract;
//    function  height(): Integer;  virtual; abstract;
    function  rect(): TRect;  virtual; abstract;
  end;


//  TCityIconTypeProvider = class
//  public
//    function  get(const cityCode: Byte): TCityIconType; virtual; abstract;
//  end;


const
  Txt_All = '(È«²¿)';
  Txt_None = '(ÎÞ)';
  Txt_Tick = '¡Ì';
  Txt_CycleClear = '¡ð';
  Txt_CycleSolid = '¡ñ';
  Txt_SquareClear = '¡õ';
  Txt_SquareSolid = '¡ö';
  Txt_Infinite = '¡Þ';
  

implementation

end.
