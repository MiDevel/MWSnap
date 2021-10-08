unit u_AddFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls;

type
  TAddFrameTypes = (ADDFRM_SMP, ADDFRM_SHD, ADDFRM_BTN);

  TAddFrame = class
  private { Private declarations }
    m_FrameType: TAddFrameTypes;
    m_SmpWidth: Integer;
    m_SmpColor: TColor;
    m_ShdWidth: Integer;
    m_ShdColor1: TColor;
    m_ShdColor2: TColor;
    m_BtnWidth: Integer;
    m_BtnColor1: TColor;
    m_BtnColor2: TColor;

  published { Published declarations }
    property FrameType: TAddFrameTypes read m_FrameType write m_FrameType;
    property SmpWidth : Integer read m_SmpWidth  write m_SmpWidth ;
    property SmpColor : TColor  read m_SmpColor  write m_SmpColor ;
    property ShdWidth : Integer read m_ShdWidth  write m_ShdWidth ;
    property ShdColor1: TColor  read m_ShdColor1 write m_ShdColor1;
    property ShdColor2: TColor  read m_ShdColor2 write m_ShdColor2;
    property BtnWidth : Integer read m_BtnWidth  write m_BtnWidth ;
    property BtnColor1: TColor  read m_BtnColor1 write m_BtnColor1;
    property BtnColor2: TColor  read m_BtnColor2 write m_BtnColor2;

  public { Public declarations }
    constructor Create;
    function  GetAsString(fType: TAddFrameTypes): String;
    procedure SetFromString(fType: TAddFrameTypes; sStr: String);
    procedure SetTypeFromInt(iType: Integer);
    function  Perform(var bmp: TBitmap; fSound: Boolean): Boolean;

  end;

  TfrmAddFrame = class(TForm)
    btnAccept: TButton;
    btnCancel: TButton;
    pgectlFrames: TPageControl;
    tabSmp: TTabSheet;
    tabShd: TTabSheet;
    tabBtn: TTabSheet;
    lblSmpColor: TLabel;
    pnlSmpColor: TPanel;
    lblSmpWidth: TLabel;
    fldSmpWidth: TEdit;
    spnSmpWidth: TUpDown;
    lblShdColor1: TLabel;
    lblShdColor2: TLabel;
    pnlShdColor1: TPanel;
    pnlShdColor2: TPanel;
    lblShdWidth: TLabel;
    fldShdWidth: TEdit;
    spnShdWidth: TUpDown;
    lblBtnColor1: TLabel;
    pnlBtnColor1: TPanel;
    lblBtnColor2: TLabel;
    pnlBtnColor2: TPanel;
    lblBtnWidth: TLabel;
    fldBtnWidth: TEdit;
    spnBtnWidth: TUpDown;
    imgSample: TImage;
    lblSample: TLabel;
    dlgClo: TColorDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ParameterChange(Sender: TObject);
    procedure pnlColorClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private { Private declarations }
    procedure UpdateSample;

  public { Public declarations }

  end;

var
  frmAddFrame: TfrmAddFrame;
  GlbAddFrame: TAddFrame;

implementation

uses
  u_Main, IniLang, u_Settings, uMWStrings, u_Sounds;

var
  SampleBitmap: TBitmap;

{$R *.DFM}

//------------------------------------------------------------------------------
constructor TAddFrame.Create;
begin
  m_FrameType := ADDFRM_SMP;
  m_SmpWidth  := 1;
  m_SmpColor  := clRed;
  m_ShdWidth  := 5;
  m_ShdColor1 := clYellow;
  m_ShdColor2 := clBlue;
  m_BtnWidth  := 3;
  m_BtnColor1 := clWhite;
  m_BtnColor2 := clGray;
end;
//------------------------------------------------------------------------------
function TAddFrame.GetAsString(fType: TAddFrameTypes): String;
var
  sRetStr: String;
begin
  case fType of
    ADDFRM_SMP:
      begin
        sRetStr := 'wdt=' + IntToStr(SmpWidth);
        sRetStr := sRetStr + ', clo=' + IntToStr(SmpColor);
      end;
    ADDFRM_SHD:
      begin
        sRetStr := 'wdt=' + IntToStr(ShdWidth);
        sRetStr := sRetStr + ', clo1=' + IntToStr(ShdColor1);
        sRetStr := sRetStr + ', clo2=' + IntToStr(ShdColor2);
      end;
    ADDFRM_BTN:
      begin
        sRetStr := 'wdt=' + IntToStr(BtnWidth);
        sRetStr := sRetStr + ', clo1=' + IntToStr(BtnColor1);
        sRetStr := sRetStr + ', clo2=' + IntToStr(BtnColor2);
      end;
  end;

  Result := sRetStr;
end;
//------------------------------------------------------------------------------
procedure TAddFrame.SetFromString(fType: TAddFrameTypes; sStr: String);
var
  sBff: String;
  wdt, clo, clo1, clo2: Integer;
begin
  sBff := GetValueStartingWith(sStr, 'wdt=', ',');
  wdt := CvtStr2Int(sBff);

  sBff := GetValueStartingWith(sStr, 'clo=', ',');
  clo := CvtStr2Int(sBff);

  sBff := GetValueStartingWith(sStr, 'clo1=', ',');
  clo1 := CvtStr2Int(sBff);

  sBff := GetValueStartingWith(sStr, 'clo2=', ',');
  clo2 := CvtStr2Int(sBff);

  case fType of
    ADDFRM_SMP:
                begin
                  SmpWidth := wdt;
                  SmpColor := clo;
                end;
    ADDFRM_SHD:
                begin
                  ShdWidth  := wdt;
                  ShdColor1 := clo1;
                  ShdColor2 := clo2;
                end;
    ADDFRM_BTN:
                begin
                  BtnWidth  := wdt;
                  BtnColor1 := clo1;
                  BtnColor2 := clo2;
                end;
  end;

end;
//------------------------------------------------------------------------------
procedure TAddFrame.SetTypeFromInt(iType: Integer);
begin
  case iType of
    Ord(ADDFRM_SMP): FrameType := ADDFRM_SMP;
    Ord(ADDFRM_SHD): FrameType := ADDFRM_SHD;
    Ord(ADDFRM_BTN): FrameType := ADDFRM_BTN;
  end;
end;
//------------------------------------------------------------------------------
function TAddFrame.Perform(var bmp: TBitmap; fSound: Boolean): Boolean;
var
  tmpBmp: TBitmap;
  cRed1, cGrn1, cBlu1: Integer;
  cRed2, cGrn2, cBlu2: Integer;
  stepR, stepG, stepB: Integer;
  i: Integer;
  //----------------------------------------------------------------------------
  // Add a border
  procedure AddBorder(borderWdt: Integer);
  var
    wdt, hgt: Integer;
  begin
    wdt := bmp.Width;
    hgt := bmp.Height;
    tmpBmp.Width  := wdt + 2*borderWdt;
    tmpBmp.Height := hgt + 2*borderWdt;
    tmpBmp.Canvas.CopyRect(Rect(borderWdt, borderWdt, wdt+borderWdt, hgt+borderWdt),
                           bmp.Canvas,
                           Rect(0, 0, wdt, hgt));
  end;
begin
  tmpBmp := TBitmap.Create;
  case FrameType of
    ADDFRM_SMP:
      begin
        AddBorder(SmpWidth);
        tmpBmp.Canvas.Brush.Color := SmpColor;
        for i := 0 to SmpWidth - 1 do
          tmpBmp.Canvas.FrameRect(Rect(i, i, tmpBmp.Width - i, tmpBmp.Height - i));
      end;

    ADDFRM_SHD:
      begin
        AddBorder(ShdWidth);

        cRed1 := GetRValue(ShdColor1);
        cGrn1 := GetGValue(ShdColor1);
        cBlu1 := GetBValue(ShdColor1);

        cRed2 := GetRValue(ShdColor2);
        cGrn2 := GetGValue(ShdColor2);
        cBlu2 := GetBValue(ShdColor2);

        stepR := Round((cRed2 - cRed1) div (ShdWidth));
        stepG := Round((cGrn2 - cGrn1) div (ShdWidth));
        stepB := Round((cBlu2 - cBlu1) div (ShdWidth));

        for i := 0 to ShdWidth - 1 do
        begin
          if i = (ShdWidth - 1) then // the last color
            tmpBmp.Canvas.Brush.Color := RGB(cRed2, cGrn2, cBlu2)
          else
            tmpBmp.Canvas.Brush.Color := RGB(cRed1 + i*stepR, cGrn1 + i*stepG, cBlu1 + i*stepB);
          tmpBmp.Canvas.FrameRect(Rect(i, i, tmpBmp.Width - i, tmpBmp.Height - i));
        end;
      end;

    ADDFRM_BTN:
      begin
        AddBorder(BtnWidth);
        tmpBmp.Canvas.Pen.Color := BtnColor1;
        for i := 0 to BtnWidth - 1 do
        begin
          tmpBmp.Canvas.MoveTo(tmpBmp.Width - 1 - i, i);
          tmpBmp.Canvas.LineTo(i, i);
          tmpBmp.Canvas.LineTo(i, tmpBmp.Height - 1 - i);
        end;
        tmpBmp.Canvas.Pen.Color := BtnColor2;
        for i := 0 to BtnWidth - 1 do
        begin
          tmpBmp.Canvas.MoveTo(tmpBmp.Width - 1 - i, i);
          tmpBmp.Canvas.LineTo(tmpBmp.Width - 1 - i, tmpBmp.Height - 1 - i);
          tmpBmp.Canvas.LineTo(i, tmpBmp.Height - 1 - i);
        end;
      end;
  end;

  bmp.Assign(tmpBmp);
  tmpBmp.Free;
  Result := True;
  if fSound then
    PlayOneSound(sndOK);
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// Restore the dialog position
procedure TfrmAddFrame.FormCreate(Sender: TObject);
begin
  SampleBitmap := TBitmap.Create;
  SampleBitmap.Assign(imgSample.Picture.Bitmap);
  frmMain.ReadWindowPosition(self, False);
end;
//------------------------------------------------------------------------------
// Save the dialog position
procedure TfrmAddFrame.FormDestroy(Sender: TObject);
begin
  frmMain.SaveWindowPosition(self, False);
end;
//------------------------------------------------------------------------------
procedure TfrmAddFrame.FormActivate(Sender: TObject);
begin
  pnlSmpColor.Color    := GlbAddFrame.SmpColor;
  spnSmpWidth.Position := GlbAddFrame.SmpWidth;

  pnlShdColor1.Color   := GlbAddFrame.ShdColor1;
  pnlShdColor2.Color   := GlbAddFrame.ShdColor2;
  spnShdWidth.Position := GlbAddFrame.ShdWidth;

  pnlBtnColor1.Color   := GlbAddFrame.BtnColor1;
  pnlBtnColor2.Color   := GlbAddFrame.BtnColor2;
  spnBtnWidth.Position := GlbAddFrame.BtnWidth;

  case GlbAddFrame.FrameType of
    ADDFRM_SMP: pgectlFrames.ActivePageIndex := 0;
    ADDFRM_SHD: pgectlFrames.ActivePageIndex := 1;
    ADDFRM_BTN: pgectlFrames.ActivePageIndex := 2;
  end;

  UpdateSample;
end;
//------------------------------------------------------------------------------
procedure TfrmAddFrame.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  case pgectlFrames.ActivePageIndex of
    0: GlbAddFrame.FrameType := ADDFRM_SMP;
    1: GlbAddFrame.FrameType := ADDFRM_SHD;
    2: GlbAddFrame.FrameType := ADDFRM_BTN;
  end;

  GlbAddFrame.SmpColor  := pnlSmpColor.Color;
  GlbAddFrame.SmpWidth  := spnSmpWidth.Position;

  GlbAddFrame.ShdColor1 := pnlShdColor1.Color;
  GlbAddFrame.ShdColor2 := pnlShdColor2.Color;
  GlbAddFrame.ShdWidth  := spnShdWidth.Position;

  GlbAddFrame.BtnColor1 := pnlBtnColor1.Color;
  GlbAddFrame.BtnColor2 := pnlBtnColor2.Color;
  GlbAddFrame.BtnWidth  := spnBtnWidth.Position;
end;
//------------------------------------------------------------------------------
// Update the preview panel
procedure TfrmAddFrame.UpdateSample;
var
  tmpAddFrame: TAddFrame;
  tmpBmp: TBitmap;
begin
  tmpAddFrame := TAddFrame.Create;
  case pgectlFrames.ActivePageIndex of
    0:
      begin
        tmpAddFrame.FrameType := ADDFRM_SMP;
        tmpAddFrame.SmpWidth  := spnSmpWidth.Position;
        tmpAddFrame.SmpColor  := pnlSmpColor.Color;
      end;
    1:
      begin
        tmpAddFrame.FrameType := ADDFRM_SHD;
        tmpAddFrame.ShdColor1 := pnlShdColor1.Color;
        tmpAddFrame.ShdColor2 := pnlShdColor2.Color;
        tmpAddFrame.ShdWidth  := spnShdWidth.Position;
      end;
    2:
      begin
        tmpAddFrame.FrameType := ADDFRM_BTN;
        tmpAddFrame.BtnColor1 := pnlBtnColor1.Color;
        tmpAddFrame.BtnColor2 := pnlBtnColor2.Color;
        tmpAddFrame.BtnWidth  := spnBtnWidth.Position;
      end;
  end;
  tmpBmp := TBitmap.Create;
  tmpBmp.Assign(SampleBitmap);
  tmpAddFrame.Perform(tmpBmp, False);
  imgSample.Picture.Bitmap.Assign(tmpBmp);

  tmpAddFrame.Free;
  tmpBmp.Free;
end;
//------------------------------------------------------------------------------
procedure TfrmAddFrame.ParameterChange(Sender: TObject);
begin
  UpdateSample;
end;
//------------------------------------------------------------------------------
procedure TfrmAddFrame.pnlColorClick(Sender: TObject);
begin
  try
    dlgClo.Color := TPanel(Sender).Color;
    if dlgClo.Execute then
    begin
      TPanel(Sender).Color := dlgClo.Color;
    end;
  except
    frmMain.CstShowMessage(ilMiscStr(rsErrorColorDialog, 'rsErrorColorDialog'));
  end;
  UpdateSample;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------



end.
