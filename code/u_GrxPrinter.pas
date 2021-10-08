unit u_GrxPrinter;

interface

uses
  Windows, Forms, SysUtils, Graphics, Classes;

resourcestring
  rsPrintPrepare='Preparing file to printing...';

type
  TGrxPrinter = class
  private { Private declarations }
    m_PrintPos: Integer;
    m_PrintSizMode: Integer;
    m_PrintSizScale: Double;
    m_PrintScaleSmooth: Boolean;
    m_PrintScaleMethod: Integer;
    m_PrintOrtVert: Boolean;
    m_PrintHeader: Boolean;
    m_HeaderText: String;
    m_HeaderOrientation: Integer;
    m_PrintFooter: Boolean;
    m_FooterText: String;
    m_FooterOrientation: Integer;
    m_Copies: Integer;
    function DoResize(srcBitmap: TBitmap; iTyp: Integer; cff: Double): Boolean;

  published { Published declarations }
    property PrintPos           : Integer read m_PrintPos           write m_PrintPos;
    property PrintSizMode       : Integer read m_PrintSizMode       write m_PrintSizMode;
    property PrintSizScale      : Double  read m_PrintSizScale      write m_PrintSizScale;
    property PrintScaleSmooth   : Boolean read m_PrintScaleSmooth   write m_PrintScaleSmooth;
    property PrintScaleMethod   : Integer read m_PrintScaleMethod   write m_PrintScaleMethod;
    property PrintOrtVert       : Boolean read m_PrintOrtVert       write m_PrintOrtVert;
    property PrintHeader        : Boolean read m_PrintHeader        write m_PrintHeader;
    property HeaderText         : String  read m_HeaderText         write m_HeaderText;
    property HeaderOrientation  : Integer read m_HeaderOrientation  write m_HeaderOrientation;
    property PrintFooter        : Boolean read m_PrintFooter        write m_PrintFooter;
    property FooterText         : String  read m_FooterText         write m_FooterText;
    property FooterOrientation  : Integer read m_FooterOrientation  write m_FooterOrientation;
    property Copies             : Integer read m_Copies             write m_Copies;

  public { Public declarations }
    procedure DoPrint;
    function  XltTemplate(const sTxt: String): String;

  end;

var
  GlbGrxPrinter: TGrxPrinter;

implementation

uses
  u_Main, uMWStrings, Printers, Controls, gfx_basedef, gfx_rotresize,
  vcl_tools, IniLang;

var
  fPrinter: TPrinter;

//------------------------------------------------------------------------------
// Expand header/footer templates
function TGrxPrinter.XltTemplate(const sTxt: String): String;
var
  sResult: String;
begin
  sResult := sTxt;

  sResult := ReplStr('%d', FormatDateTime(ShortDateFormat, Date), sResult);
  sResult := ReplStr('%D', FormatDateTime(LongDateFormat, Date), sResult);

  sResult := ReplStr('%t', FormatDateTime(ShortTimeFormat, Time), sResult);
  sResult := ReplStr('%T', FormatDateTime(LongTimeFormat, Time), sResult);

  sResult := ReplStr('%x', IntToStr(frmMain.imgPreview.Picture.Bitmap.Width), sResult);
  sResult := ReplStr('%y', IntToStr(frmMain.imgPreview.Picture.Bitmap.Height), sResult);

  sResult := ReplStr('%n', ExtractFileName(frmMain.LastSavePath), sResult);
  sResult := ReplStr('%p', frmMain.LastSavePath, sResult);
  Result := sResult;
end;
//------------------------------------------------------------------------------
// Draw the given bitmap stretched into the canvas so that it fits the DestRect
procedure DrawImage(Canvas: TCanvas; DestRect: TRect; ABitmap: TBitmap);
var
  Header, Bits: Pointer;
  HeaderSize: DWord;
  BitsSize: DWord;
begin
  GetDIBSizes(ABitmap.Handle, HeaderSize, BitsSize);
  Header := AllocMem(HeaderSize);
  Bits := AllocMem(BitsSize);
  try
    GetDIB(ABitmap.Handle, ABitmap.Palette, Header^, Bits^);
    StretchDIBits(Canvas.Handle, DestRect.Left, DestRect.Top,
        DestRect.Right, DestRect.Bottom,
        0, 0, ABitmap.Width, ABitmap.Height, Bits, TBitmapInfo(Header^),
        DIB_RGB_COLORS, SRCCOPY);
  finally
    FreeMem(Header, HeaderSize);
    FreeMem(Bits, BitsSize);
  end;
end;
//------------------------------------------------------------------------------
// Prepare the destination bitmap
function TGrxPrinter.DoResize(srcBitmap: TBitmap; iTyp: Integer; cff: Double): Boolean;
var
  dx, dy: Double;
  wdt, hgt: Integer;
  dstBitmap: TBitmap;
begin
  DoResize := False;
  if iTyp in [0..6] then
  begin
    dstBitmap := TBitmap.Create;

    Screen.Cursor := crHourGlass;
    CreateXPanel(frmMain, 200, 50);
    XPanel.Caption := ilMiscStr(rsPrintPrepare, 'rsPrintPrepare');

    if srcBitmap.PixelFormat <> pf24Bit then
      srcBitmap.Pixelformat := pf24bit;

    dx  := srcBitmap.Width * cff;
    dy  := srcBitmap.Height * cff;
    wdt := Trunc(dx);
    hgt := Trunc(dy);

    try
      case iTyp of
        0:  Resample(srcBitmap, dstBitmap, wdt, hgt, SplineFilter  , 3, XProgress);
        1:  Resample(srcBitmap, dstBitmap, wdt, hgt, BellFilter    , 3, XProgress);
        2:  Resample(srcBitmap, dstBitmap, wdt, hgt, TriangleFilter, 3, XProgress);
        3:  Resample(srcBitmap, dstBitmap, wdt, hgt, BoxFilter     , 3, XProgress);
        4:  Resample(srcBitmap, dstBitmap, wdt, hgt, HermiteFilter , 3, XProgress);
        5:  Resample(srcBitmap, dstBitmap, wdt, hgt, Lanczos3Filter, 3, XProgress);
        6:  Resample(srcBitmap, dstBitmap, wdt, hgt, MitchellFilter, 3, XProgress);
      end;
      DoResize := True;
    finally
      ReleaseXPanel;
      srcBitmap.Assign(dstBitmap);
      dstBitmap.Free;
      Screen.Cursor := crDefault;
    end;
  end;
end;
//------------------------------------------------------------------------------
procedure TGrxPrinter.DoPrint;
var
  srcX, srcY: Integer; // source bitmap size (after eventual trimming)
  prnWdt, prnHgt: Integer; // printer canvas size
  ofsX, ofsY: Integer; // offset, for positioning the bitmap
  scl: Double;
  srcBitmap: TBitmap;
  hdrHgt, hdrWdt: Integer; // header text geometry
  ftrHgt, ftrWdt: Integer; // footer text geometry

  // Calculate the X position of the aligned text
  function GetXPos(wdt: Integer; ort: Integer): Integer;
  begin
    case ort of
      0: // left
         Result := 0;
      1: // center
         Result := (prnWdt - wdt) div 2;
      2: // right
         Result := prnWdt - wdt;
    else
      Result := 0;
    end;
  end;
begin
  srcBitmap := TBitmap.Create;
  srcBitmap.PixelFormat := pf24Bit;
  try
    // create our own pointer to the Printer object
    fPrinter := Printers.Printer;
    fPrinter.Title := 'MWSnap document';

    // set the page orientation
    if PrintOrtVert then
      fPrinter.Orientation := poPortrait
    else
      fPrinter.Orientation := poLandscape;
    prnWdt := fPrinter.PageWidth;
    prnHgt := fPrinter.PageHeight;

    hdrHgt := 0;
    hdrWdt := 0;
    if PrintHeader then
    begin
      hdrHgt := fPrinter.Canvas.TextHeight(XltTemplate(HeaderText));
      hdrWdt := fPrinter.Canvas.TextWidth(XltTemplate(HeaderText));
    end;
    ftrHgt := 0;
    ftrWdt := 0;
    if PrintFooter then
    begin
      ftrHgt := fPrinter.Canvas.TextHeight(XltTemplate(FooterText));
      ftrWdt := fPrinter.Canvas.TextWidth(XltTemplate(FooterText));
    end;

    // prepare the source bitmap
    srcBitmap.Assign(frmMain.imgPreview.Picture.Bitmap);
    srcBitmap.PixelFormat := pf24Bit;
    srcX  := srcBitmap.Width;
    srcY  := srcBitmap.Height;
    if srcX * srcY = 0 then
    begin
      srcBitmap.Free;
      Exit;
    end;

    // rescale the source bitmap
    scl := 1;
    if (PrintSizMode = 2) then
      scl := PrintSizScale
    else if (PrintSizMode = 3) then
      scl := prnWdt / srcX;

    if scl <= 0.00001 then
    begin
      srcBitmap.Free;
      Exit;
    end;

    if PrintScaleSmooth then
    begin
      DoResize(srcBitmap, PrintScaleMethod, scl);
      srcX  := srcBitmap.Width;
      srcY  := srcBitmap.Height;
    end
    else
    begin
      //DoResize(srcBitmap, 3, scl); // box - no rendering
      //srcX  := srcBitmap.Width;
      //srcY  := srcBitmap.Height;
      srcX  := Trunc(srcBitmap.Width * scl);
      srcY  := Trunc(srcBitmap.Height * scl);
    end;

    // adjust the position
    ofsX := 0; // default - left
    if srcX < prnWdt then
    begin
      if (PrintPos in [21, 22, 23]) then
      begin // centered
        ofsX := (prnWdt - srcX) div 2;
      end
      else if (PrintPos in [31, 32, 33]) then
      begin // right
        ofsX := prnWdt - srcX + 1;
      end;
    end;

    ofsY := 0;  // default - top
    if srcY < prnHgt then
    begin
      if (PrintPos in [12, 22, 32]) then
      begin // centered
        ofsY := (prnHgt - srcY) div 2;
      end
      else if (PrintPos in [13, 23, 33]) then
      begin // bottom
        ofsY := prnHgt - srcY + 1;
      end;
    end;

    // go
    screen.cursor := crHourglass;
    fPrinter.Copies := Copies;
    fPrinter.BeginDoc;
    DrawImage(fPrinter.Canvas, Rect(ofsX, ofsY + hdrHgt * 2, srcX, srcY), srcBitmap);
    if PrintHeader then
      fPrinter.Canvas.TextOut(GetXPos(hdrWdt, HeaderOrientation), 0, XltTemplate(HeaderText));
    if PrintFooter then
      fPrinter.Canvas.TextOut(GetXPos(ftrWdt, FooterOrientation), prnHgt - ftrHgt, XltTemplate(FooterText));
    fPrinter.EndDoc;
    screen.cursor := crDefault;

  except
    on E: Exception do
    begin
      fPrinter.Abort;
      frmMain.CstShowMessage(E.Message + ' (' + IntToStr(E.HelpContext) + ')');
    end;
  end;

  srcBitmap.Free;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

end.
