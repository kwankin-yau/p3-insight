unit BMSearch;


(* -------------------------------------------------------------------
   Boyer-Moore string searching.

   This is one of the fastest string search algorithms.
   See a description in:

     R. Boyer and S. Moore.
     A fast string searching algorithm.
     Communications of the ACM 20, 1977, Pags 762-772
------------------------------------------------------------------- *)


interface


type
{$ifdef WINDOWS}
   size_t = Word;
{$else}
   size_t = LongInt;
{$endif}


type
   TTranslationTable = array[char] of char;  { translation table }

   TSearchBM = class(TObject)
   private
      FTranslate  : TTranslationTable;     { translation table }
      FJumpTable  : array[char] of Byte;   { Jumping table }
      FShift_1    : integer;
      FPattern    : pchar;
      FPatternLen : size_t;

   public
      procedure Prepare( Pattern: pchar; PatternLen: size_t);
      procedure PrepareStr( const Pattern: string);

      function  Search( Text: pchar; TextLen: size_t ): pchar;
      function  Pos( const S: string ): integer;
   end;




implementation


uses  SysUtils;



(* -------------------------------------------------------------------
   Ignore Case Table Translation
------------------------------------------------------------------- *)

procedure CreateTranslationTable( var T: TTranslationTable);
var
   c: char;
begin
   for c := #0 to #255 do
       T[c] := c;

//   if not IgnoreCase then
//      exit;
//      
//   for c := 'a' to 'z' do
//      T[c] := UpCase(c);
//
//   { Mapping all acented characters to their uppercase equivalent }
//   
//   T['?] := 'A';
//   T['?] := 'A';
//   T['?] := 'A';
//   T['?] := 'A';
//
//   T['?] := 'A';
//   T['?] := 'A';
//   T['?] := 'A';
//   T['?] := 'A';
//
//   T['?] := 'E';
//   T['?] := 'E';
//   T['?] := 'E';
//   T['?] := 'E';
//
//   T['?] := 'E';
//   T['?] := 'E';
//   T['?] := 'E';
//   T['?] := 'E';
//
//   T['?] := 'I';
//   T['?] := 'I';
//   T['?] := 'I';
//   T['?] := 'I';
//
//   T['?] := 'I';
//   T['?] := 'I';
//   T['?] := 'I';
//   T['?] := 'I';
//
//   T['?] := 'O';
//   T['?] := 'O';
//   T['?] := 'O';
//   T['?] := 'O';
//
//   T['?] := 'O';
//   T['?] := 'O';
//   T['?] := 'O';
//   T['?] := 'O';
//
//   T['?] := 'U';
//   T['?] := 'U';
//   T['?] := 'U';
//   T['?] := 'U';
//
//   T['?] := 'U';
//   T['?] := 'U';
//   T['?] := 'U';
//   T['?] := 'U';
//
//   T['?] := '?;
end;



(* -------------------------------------------------------------------
   Preparation of the jumping table
------------------------------------------------------------------- *)

procedure TSearchBM.Prepare( Pattern: pchar; PatternLen: size_t);
var
   i: integer;
   c, lastc: char;
begin
   FPattern := Pattern;
   FPatternLen := PatternLen;

   if FPatternLen < 1 then
      FPatternLen := strlen(FPattern);

   { This algorythm is based in a character set of 256 }

   if FPatternLen > 256 then
      exit;


   { 1. Preparing translating table }

   CreateTranslationTable( FTranslate);


   { 2. Preparing jumping table }

   for c := #0 to #255 do
      FJumpTable[c] := FPatternLen;

   for i := FPatternLen - 1 downto 0 do begin
      c := FTranslate[FPattern[i]];
      if FJumpTable[c] >= FPatternLen - 1 then
         FJumpTable[c] := FPatternLen - 1 - i;
   end;

   FShift_1 := FPatternLen - 1;
   lastc := FTranslate[Pattern[FPatternLen - 1]];

   for i := FPatternLen - 2 downto 0 do
      if FTranslate[FPattern[i]] = lastc  then begin
         FShift_1 := FPatternLen - 1 - i;
         break;
      end;

   if FShift_1 = 0 then
      FShift_1 := 1;
end;


procedure TSearchBM.PrepareStr( const Pattern: string);
var
   str: pchar;
begin
   if Pattern <> '' then begin
{$ifdef Windows}
      str := @Pattern[1];
{$else}
      str := pchar(Pattern);
{$endif}

      Prepare( str, Length(Pattern));
   end;
end;



{ Searching Last char & scanning right to left }

function TSearchBM.Search( Text: pchar; TextLen: size_t ): pchar;
var
   shift, m1, j: integer;
   jumps: size_t;
begin
   result := nil;
   if FPatternLen > 256 then
      exit;

   if TextLen < 1 then
      TextLen := strlen(Text);


   m1 := FPatternLen - 1;
   shift := 0;
   jumps := 0;

   { Searching the last character }

   while jumps <= TextLen do begin
      Inc( Text, shift);
      shift := FJumpTable[FTranslate[Text^]];
      while shift <> 0 do begin
          Inc( jumps, shift);
          if jumps > TextLen then
             exit;

          Inc( Text, shift);
          shift := FJumpTable[FTranslate[Text^]];
      end;

      { Compare right to left FPatternLen - 1 characters }

      if jumps >= m1 then begin
         j := 0;
         while FTranslate[FPattern[m1 - j]] = FTranslate[(Text - j)^] do begin
            Inc(j);
            if j = FPatternLen then begin
               result := Text - m1;
               exit;
            end;
         end;
      end;

      shift := FShift_1;
      Inc( jumps, shift);
   end;
end;


function TSearchBM.Pos( const S: string ): integer;
var
   str, p: pchar;
begin
   result := 0;
   if S <> '' then begin
{$ifdef Windows}
      str := @S[1];
{$else}
      str := pchar(S);
{$endif}

      p := Search( str, Length(S));
      if p <> nil then
         result := 1 + p - str;
   end;
end;



end.
