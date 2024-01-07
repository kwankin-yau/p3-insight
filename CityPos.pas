unit CityPos;

interface
uses
  SysUtils, Classes, OmniXML, MyOmniXMLHelper, p3DataStruct, Contnrs, GR32, GR32_Image, GR32_Text,
  Graphics, Windows, GR32_Filters;

type
  TCityCode = record
    internalCode: Integer;
    Name: WideString;
    X, Y: Integer;
  end;

  TCitiesRectCache = record
    Ready: Boolean;
    Rects: array[MIN_INTERNAL_CITY_CODE..MAX_INTERNAL_CITY_CODE] of TRect;

    procedure reset();
  end;

  TCityPositions = class
  public
    Count: Integer;
    items: array[MIN_INTERNAL_CITY_CODE..MAX_INTERNAL_CITY_CODE] of TCityCode;
    bitmaps: TObjectList;
    font: TFont;

    constructor Create(aFont: TFont);
    destructor Destroy; override;
    
    procedure reset();
    procedure load();
    procedure getXY(const internalCode: integer; out x, y: Integer);

    function  getTextBitmap(const internalCode: Integer): TBitmap32;  
  end;

implementation

uses Types;

{ TCityPositions }

constructor TCityPositions.Create(aFont: TFont);
var
  I: integer;
begin
  font := TFont.Create();
//  font.Assign(aFont);
//  font.Name := 'Courier New';
  font.Color := clRed;
  font.Size := 10;
  font.Style := [fsBold];
  bitmaps := TObjectList.Create(True);
  bitmaps.Count := MAX_INTERNAL_CITY_CODE + 1;
end;

destructor TCityPositions.Destroy;
begin
  FreeAndNil(bitmaps);
  FreeAndNil(font);
  inherited;
end;

function TCityPositions.getTextBitmap(const internalCode: Integer): TBitmap32;
var
  txt: TText32;
  S: WideString;
  R: TSize;
  bmp2: TBitmap32;
begin
  Result := TBitmap32(bitmaps[internalCode]);
  if Result = nil then
  begin
    Result := TBitmap32.Create();
    Result.Font.Assign(font);
    Result.Font.Color := clRed;
    S := items[internalCode].Name;
    R := Result.TextExtentW(S);
    Result.Width := R.cx + 2*2;
    Result.Height := R.cy + 2 * 2;
    Result.Clear(0);
//    Result.FillRect(0, 0, Result.Width, Result.Height, clBlack32);
    Result.Textout(2, 2, S);
//    GR32_Filters.ChromaKey(Result, 0);

//    ChromaKey(Result, clBlack32);

//    Result.DrawMode := dmBlend;
//    Result.CombineMode := cmMerge;

    bitmaps[internalCode] := Result;
  end;
end;

procedure TCityPositions.getXY(const internalCode: integer; out x, y: Integer);
begin
  X := items[internalCode].X;
  Y := items[internalCode].Y;
end;

procedure TCityPositions.load;
var
  doc: IXMLDocument;
  e_city: IXMLElement;
  code, x, y: Integer;
begin
  reset();
  
  doc := TMyXMLUtils.LoadXMLDocFromFile('V:\temp\p3\city-pos.xml');

  e_city := TMyXMLUtils.GetFirstChildElmtNamed(doc.DocumentElement, 'city');
  while e_city <> nil do
  begin
    code := StrToInt(e_city.GetAttribute('internal-code'));
    x := StrToInt(e_city.GetAttribute('x'));
    y := StrToInt(e_city.GetAttribute('y'));


    items[count].internalCode := code;
    items[count].X := x;
    items[count].Y := y;
    items[count].Name := e_city.GetAttribute('name');

    Inc(Count);

    e_city := TMyXMLUtils.FindNextSiblingElmtSameName(e_city);
  end;
end;

procedure TCityPositions.reset;
begin
  Count := 0;
end;

{ TCitiesRectCache }

procedure TCitiesRectCache.reset;
begin
  Ready := False;
end;

end.
