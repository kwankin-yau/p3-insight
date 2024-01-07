unit pedump;

interface
uses
  SysUtils, Classes, JclPeimage, Windows;

procedure dumpP3header();

implementation

uses AxGameHackToolBox, p3DataStruct;

  procedure dumpP3header();
  var
    i: Integer;
    p: Pointer;
    hmod: THandle;
    image: TJclPeImage;
    ln: string;
  begin
    hmod := GetModuleHandle('p3.exe');

    image := TJclPeImage.Create();
    try
      image.AttachLoadedModule(hmod);
      OutputDebugString('pedump====');

      for I := 0 to image.ImageSectionCount-1 do
      begin
        with image.ImageSectionHeaders[I] do
        begin
          ln := image.ImageSectionNames[I] + ': ';
          ln := ln + ' RVA=' + longwordToHexStr(VirtualAddress);
          OutputDebugString(pchar(ln));
        end;
      end;

      OutputDebugString('====pedump');
    finally
      image.Destroy();
    end;
  end;


end.
