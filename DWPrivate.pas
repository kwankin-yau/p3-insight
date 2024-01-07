unit DWPrivate;

interface
uses
  SysUtils,
  Classes,
  ChillsCode,
  Blowfish;

procedure P1(inStream, outStream: TStream; v: Pointer);
procedure P2(out S: string);
function  P3(const aPlainText: string; v: Pointer): string;
function  P4(const aCipherText: string; v: Pointer; const aOrgSize: Integer): string;

implementation

const
  a: array[0..7] of Char = (
    Chr(not Ord('D')),
    Chr(not Ord('W')),
    Chr(not Ord('S')),
    Chr(not Ord('E')),
    Chr(not Ord('R')),
    Chr(not Ord('V')),
    Chr(not Ord('E')),
    Chr(not Ord('R'))
    //DWSERVER
  );

procedure P2(out S: string);
var
  I: Integer;
begin
  SetLength(S, SizeOf(a));
  for I := 1 to Length(S) do
    S[I] := Chr(not Ord(a[I-1]));
end;

procedure P1(inStream, outStream: TStream; v: Pointer);
var
  K: string;
begin
  P2(K);

  BFCryptDecryptStream(
          inStream,
          outStream,
          K,
          nil,
          nil,
          False,
          False,
          0,
          emCBC,
          v);
end;

function  P3(const aPlainText: string; v: Pointer): string;
var
  k: string;
begin
  P2(k);

  BFCryptEncryptString(aPlainText, Result, PBlowfishIV(V)^, k, emCBC);
end;

function  P4(const aCipherText: string; v: Pointer; const aOrgSize: Integer): string;
var
  k: string;
begin
  P2(k);

  BFCryptDecryptString(
          aCipherText,
          aOrgSize,
          Result,
          PBlowfishIV(V)^,
          k,
          emCBC);
end;

end.
