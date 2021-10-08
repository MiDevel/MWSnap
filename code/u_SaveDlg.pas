unit u_SaveDlg;

interface

uses
  Windows, Classes, Controls, StdCtrls, ExtCtrls, Buttons, Dialogs, ComCtrls;

type

  TMyOpenDlg = class(TOpenDialog)  // custom I/O dialogs
  private
    m_isSave: Boolean; // are we in "Save" dialog? Else in "Open".

    FpnlBottom: TPanel;
    FgrpParameters: TGroupBox;
    m_txtParameters: String;
    FfldQuality: TEdit;
    FlblQuality: TLabel;
    FspnQuality: TUpDown;
    m_Quality: Integer;
    m_txtQuality: String;
    FlblColorBits: TLabel;
    m_txtColorBits: String;
    m_ColorBits: Integer;
    FrdiBits1: TRadioButton;
    FrdiBits4: TRadioButton;
    FrdiBits8: TRadioButton;
    FrdiBits15: TRadioButton;
    FrdiBits16: TRadioButton;
    FrdiBits24: TRadioButton;
    FrdiBits32: TRadioButton;
    FchkTransparent: TCheckBox;
    m_txtTransparent: String;
    m_Transparent: Boolean;
    FlblTranspPixel: TLabel;
    m_txtTranspPixel: String;
    FcmbTranspPixel: TComboBox;
    m_TranspPixel: Integer;
    m_txt1bit  : String;
    m_txt4bits : String;
    m_txt8bits : String;
    m_txt15bits: String;
    m_txt16bits: String;
    m_txt24bits: String;
    m_txt32bits: String;
    m_txtLeftTop: String;
    m_txtRightTop: String;
    m_txtLeftBottom: String;
    m_txtRightBottom: String;
    m_txtCenter: String;
    procedure SetQuality(iVal: Integer);
    procedure AfterTypeChange;

  protected
    procedure DoClose; override;
    procedure DoShow; override;
    procedure DoTypeChange; override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    function    Execute: Boolean; override;

  published
    property txtParameters : String  read m_txtParameters  write m_txtParameters;
    property txtQuality    : String  read m_txtQuality     write m_txtQuality;
    property Quality       : Integer read m_Quality        write SetQuality;
    property ColorBits     : Integer read m_ColorBits      write m_ColorBits;
    property txtColorBits  : String  read m_txtColorBits   write m_txtColorBits;
    property Transparent   : Boolean read m_Transparent    write m_Transparent;
    property txtTransparent: String  read m_txtTransparent write m_txtTransparent;
    property txtTranspPixel: String  read m_txtTranspPixel write m_txtTranspPixel;
    property TranspPixel   : Integer read m_TranspPixel    write m_TranspPixel;
    property txt1bit       : String  read m_txt1bit        write m_txt1bit;
    property txt4bits      : String  read m_txt4bits       write m_txt4bits;
    property txt8bits      : String  read m_txt8bits       write m_txt8bits;
    property txt15bits     : String  read m_txt15bits      write m_txt15bits;
    property txt16bits     : String  read m_txt16bits      write m_txt16bits;
    property txt24bits     : String  read m_txt24bits      write m_txt24bits;
    property txt32bits     : String  read m_txt32bits      write m_txt32bits;
    property txtLeftTop    : String  read m_txtLeftTop     write m_txtLeftTop;
    property txtRightTop   : String  read m_txtRightTop    write m_txtRightTop;
    property txtLeftBottom : String  read m_txtLeftBottom  write m_txtLeftBottom;
    property txtRightBottom: String  read m_txtRightBottom write m_txtRightBottom;
    property txtCenter     : String  read m_txtCenter      write m_txtCenter;
  end;

  TMySaveDlg = class(TMyOpenDlg)
  public
    function Execute: Boolean; override;
  end;

implementation

uses
  SysUtils, Consts, Forms, CommDlg, Dlgs;

{$R *.RES}


// TMyOpenDlg
//------------------------------------------------------------------------------
constructor TMyOpenDlg.Create(AOwner: TComponent);
var
  rdiWdt, rdiTop, rdiHgt, rdiOfs: Integer;
begin
  inherited Create(AOwner);

  m_isSave := False;
  rdiWdt := 66;
  rdiTop := 52;
  rdiHgt := 18;
  rdiOfs := 24;

  m_Quality := 75;
  m_TranspPixel := 0;
  txtQuality     := 'JPG quality (1..100):';
  txtParameters  := 'Saving parameters';
  txtColorBits   := 'Color depth (bits per pixel)';
  txtTransparent := 'Transparent';
  txtTranspPixel := 'Transparent pixel:';
  txt1bit        := '1 bit';
  txt4bits       := '4 bits';
  txt8bits       := '8 bits';
  txt15bits      := '15 bits';
  txt16bits      := '16 bits';
  txt24bits      := '24 bits';
  txt32bits      := '32 bits';
  txtLeftTop     := 'Left-top';
  txtRightTop    := 'Right-top';
  txtLeftBottom  := 'Left-bottom';
  txtRightBottom := 'Right-bottom';
  txtCenter      := 'Center';

  FpnlBottom := TPanel.Create(Self);
  with FpnlBottom do
  begin
    Name := 'pnlBottom';
    Caption := '';
    BevelOuter := bvNone;
    BorderWidth := 2;
    TabOrder := 1;

    FgrpParameters := TGroupBox.Create(Self);
    with FgrpParameters do
    begin
      Name := 'grpParameters';
      Caption := txtParameters;
      SetBounds(4, 4, 412, 112);
      Align := alNone;
      Ctl3D := True;
      Parent := FpnlBottom;
    end;

    FlblQuality := TLabel.Create(Self);
    with FlblQuality do
    begin
      Name := 'lblQuality';
      SetBounds(8, 24, 80, 16);
      Ctl3D := True;
      Autosize := True;
      Caption := txtQuality;
      Parent := FgrpParameters;
    end;

    FfldQuality := TEdit.Create(Self);
    with FfldQuality do
    begin
      Name := 'fldQuality';
      Text := '100';
      SetBounds(140, 20, 40, 16);
      Ctl3D := True;
      Parent := FgrpParameters;
    end;

    FspnQuality := TUpDown.Create(Self);
    with FspnQuality do
    begin
      Name := 'spnQuality';
      Min := 1;
      Max := 100;
      SetBounds(FfldQuality.Left + FfldQuality.Width, FfldQuality.Top, 14, FfldQuality.Height);
      Position := 75;
      Parent := FgrpParameters;
      Ctl3D := True;
    end;

    FlblColorBits := TLabel.Create(Self);
    with FlblColorBits do
    begin
      Name := 'lblColorBits';
      SetBounds(8, rdiTop, 180, 16);
      Ctl3D := True;
      Autosize := True;
      Caption := txtColorBits;
      Parent := FgrpParameters;
    end;

    FrdiBits1 := TRadioButton.Create(Self);
    with FrdiBits1 do
    begin
      Name := 'rdiBits1';
      Caption := txt1bit;
      SetBounds(rdiOfs, rdiTop + rdiHgt, rdiWdt, rdiHgt);
      Parent := FgrpParameters;
    end;

    FrdiBits4 := TRadioButton.Create(Self);
    with FrdiBits4 do
    begin
      Name := 'rdiBits4';
      Caption := txt4bits;
      SetBounds(rdiOfs + rdiWdt, rdiTop + rdiHgt, rdiWdt, rdiHgt);
      Parent := FgrpParameters;
    end;

    FrdiBits8 := TRadioButton.Create(Self);
    with FrdiBits8 do
    begin
      Name := 'rdiBits8';
      Caption := txt8bits;
      SetBounds(rdiOfs + 2*rdiWdt, rdiTop + rdiHgt, rdiWdt, rdiHgt);
      Parent := FgrpParameters;
    end;

    FrdiBits15 := TRadioButton.Create(Self);
    with FrdiBits15 do
    begin
      Name := 'rdiBits15';
      Caption := txt15bits;
      SetBounds(rdiOfs + 3*rdiWdt, rdiTop + rdiHgt, rdiWdt, rdiHgt);
      Parent := FgrpParameters;
    end;

    FrdiBits16 := TRadioButton.Create(Self);
    with FrdiBits16 do
    begin
      Name := 'rdiBits16';
      Caption := txt16bits;
      SetBounds(rdiOfs, rdiTop + 2*rdiHgt, rdiWdt, rdiHgt);
      Parent := FgrpParameters;
    end;

    FrdiBits24 := TRadioButton.Create(Self);
    with FrdiBits24 do
    begin
      Name := 'rdiBits24';
      Caption := txt24bits;
      SetBounds(rdiOfs + rdiWdt, rdiTop + 2*rdiHgt, rdiWdt, rdiHgt);
      Parent := FgrpParameters;
    end;

    FrdiBits32 := TRadioButton.Create(Self);
    with FrdiBits32 do
    begin
      Name := 'rdiBits32';
      Caption := txt32bits;
      SetBounds(rdiOfs + 2*rdiWdt, rdiTop + 2*rdiHgt, rdiWdt, rdiHgt);
      Parent := FgrpParameters;
    end;

    FchkTransparent := TCheckBox.Create(Self);
    with FchkTransparent do
    begin
      Name := 'chkTransparent';
      Caption := txtTransparent;
      SetBounds(300, 18, 100, 16);
      Parent := FgrpParameters;
    end;

    FlblTranspPixel := TLabel.Create(Self);
    with FlblTranspPixel do
    begin
      Name := 'lblTranspPixel';
      SetBounds(300, 44, 100, 16);
      Ctl3D := True;
      Autosize := True;
      Caption := txtTranspPixel;
      Parent := FgrpParameters;
    end;

    FcmbTranspPixel := TComboBox.Create(Self);
    with FcmbTranspPixel do
    begin
      Name := 'cmbTranspPixel';
      Style := csDropDown;
      SetBounds(300, 60, 100, 16);
      Parent := FgrpParameters;
    end;
  end;
end;
//------------------------------------------------------------------------------
destructor TMyOpenDlg.Destroy;
begin
  FlblQuality.Free;
  FfldQuality.Free;
  FspnQuality.Free;
  FlblColorBits.Free;
  FrdiBits1.Free;
  FrdiBits4.Free;
  FrdiBits8.Free;
  FrdiBits15.Free;
  FrdiBits16.Free;
  FrdiBits24.Free;
  FrdiBits32.Free;
  FchkTransparent.Free;
  FlblTranspPixel.Free;
  FcmbTranspPixel.Free;
  FgrpParameters.Free;
  FpnlBottom.Free;
  inherited Destroy;
end;
//------------------------------------------------------------------------------
// We are about to close, return settings
procedure TMyOpenDlg.DoClose;
begin

  m_Quality     := FspnQuality.Position;

  m_ColorBits :=  24;
       if FrdiBits1.Checked  then m_ColorBits :=  1
  else if FrdiBits4.Checked  then m_ColorBits :=  4
  else if FrdiBits8.Checked  then m_ColorBits :=  8
  else if FrdiBits15.Checked then m_ColorBits := 15
  else if FrdiBits16.Checked then m_ColorBits := 16
  else if FrdiBits24.Checked then m_ColorBits := 24
  else if FrdiBits32.Checked then m_ColorBits := 32;

  m_Transparent := FchkTransparent.Checked;
  m_TranspPixel := FcmbTranspPixel.ItemIndex;

  inherited DoClose;

  // hide eventual hint windows left behind
  Application.HideHint;
end;
//------------------------------------------------------------------------------
// File type has been selected, prepare the UI
procedure TMyOpenDlg.AfterTypeChange;
begin
  case FilterIndex of
    1: // bmp
       DefaultExt := 'bmp';
    2: // jpeg
       DefaultExt := 'jpg';
    3: // gif
       DefaultExt := 'gif';
    4: // png
       DefaultExt := 'png';
    5: // tiff
       DefaultExt := 'tif';
  end;

  FlblColorBits.Enabled := FilterIndex in [1, 5];
  FrdiBits1.Enabled     := FilterIndex in [1, 5];
  FrdiBits4.Enabled     := FilterIndex in [1, 5];
  FrdiBits8.Enabled     := FilterIndex in [1, 5];
  FrdiBits15.Enabled    := FilterIndex in [1];
  FrdiBits16.Enabled    := FilterIndex in [1, 5];
  FrdiBits24.Enabled    := FilterIndex in [1, 5];
  FrdiBits32.Enabled    := FilterIndex in [1, 5];

  FlblQuality.Enabled   := FilterIndex in [2];
  FfldQuality.Enabled   := FilterIndex in [2];
  FspnQuality.Enabled   := FilterIndex in [2];

  if FrdiBits15.Checked and (not FrdiBits15.Enabled) then
    FrdiBits16.Checked := True;

  FchkTransparent.Enabled := FilterIndex in [3];//, 4];
  FlblTranspPixel.Enabled := FilterIndex in [3];//, 4];
  FcmbTranspPixel.Enabled := FilterIndex in [3];//, 4];
end;
//------------------------------------------------------------------------------
procedure TMyOpenDlg.DoTypeChange;
begin
  inherited;
  AfterTypeChange; // set default ext., update UI
end;
//------------------------------------------------------------------------------
procedure TMyOpenDlg.DoShow;
var
  sepRect, staticRect: TRect;
begin
  // set extra area to bottom of the static area
  staticRect     := GetStaticRect;
  sepRect.Top    := staticRect.Bottom;
  sepRect.Left   := staticRect.Left;
  sepRect.Bottom := sepRect.Top + 200;
  sepRect.Right  := staticRect.Right;

  FpnlBottom.ParentWindow := Handle;
  FpnlBottom.BoundsRect   := sepRect;

  // initialize controls
  FgrpParameters.Caption := txtParameters;
  FlblQuality.Caption    := txtQuality;
  FspnQuality.Associate  := FfldQuality;
  FspnQuality.Position   := m_Quality;
  FlblColorBits.Caption  := txtColorBits;
  FchkTransparent.Caption := m_txtTransparent;
  FlblTranspPixel.Caption := m_txtTranspPixel;
  FchkTransparent.Checked := m_Transparent;
  FcmbTranspPixel.Clear;

  FrdiBits1.Caption := txt1bit;
  FrdiBits4.Caption := txt4bits;
  FrdiBits8.Caption := txt8bits;
  FrdiBits15.Caption := txt15bits;
  FrdiBits16.Caption := txt16bits;
  FrdiBits24.Caption := txt24bits;
  FrdiBits32.Caption := txt32bits;

  FcmbTranspPixel.Items.Add(txtLeftTop);
  FcmbTranspPixel.Items.Add(txtRightTop);
  FcmbTranspPixel.Items.Add(txtLeftBottom);
  FcmbTranspPixel.Items.Add(txtRightBottom);
  if TranspPixel < 0 then TranspPixel := 0
  else if TranspPixel > 3 then TranspPixel := 3;
  FcmbTranspPixel.ItemIndex := TranspPixel;
  //FcmbTransparent.Text := FcmbTransparent.Items.Strings[TranspPixel];

  case m_ColorBits of
     1: FrdiBits1.Checked := True;
     4: FrdiBits4.Checked := True;
     8: FrdiBits8.Checked := True;
    15: FrdiBits15.Checked := True;
    16: FrdiBits16.Checked := True;
    24: FrdiBits24.Checked := True;
    32: FrdiBits32.Checked := True;
  else
    FrdiBits24.Checked := True;
  end;

  AfterTypeChange; // set default ext., update UI

  inherited DoShow;
end;
//------------------------------------------------------------------------------
function TMyOpenDlg.Execute;
begin
  m_isSave := False;
//  if NewStyleControls and not (ofOldStyleDialog in Options) then
//    Template := 'MYSAVETEMPLATE'
//  else
    Template := nil;
  Result := inherited Execute;
end;
//------------------------------------------------------------------------------
// TMySaveDlg
function TMySaveDlg.Execute: Boolean;
begin
  m_isSave := True;
  if NewStyleControls and not (ofOldStyleDialog in Options) then
    Template := 'MYSAVETEMPLATE'
  else
    Template := nil;
  Result := DoExecute(@GetSaveFileName);
end;
//------------------------------------------------------------------------------
procedure TMyOpenDlg.SetQuality(iVal: Integer);
begin
  if iVal < 1 then iVal := 1;
  if iVal > 100 then iVal := 100;
  m_Quality := iVal;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

end.
