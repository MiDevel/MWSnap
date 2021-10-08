unit u_Print;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls;

const
  rsPrintTplHdr='The following templates can be used in the header and in the footer:';
  rsPrintTplDateShort='print date (short)';
  rsPrintTplDateLong='print date (long)';
  rsPrintTplTimeShort='print time (short)';
  rsPrintTplTimeLong='print time (long)';
  rsPrintTplPicWidth='picture width (in pixels)';
  rsPrintTplPicHeight='picture height (in pixels)';
  rsPrintTplFileName='file name';
  rsPrintTplFilePath='file path';
  rsPrintTplFtr='Any other text will appear as entered.';

type
  TfrmPrint = class(TForm)
    grpPosition: TGroupBox;
    grpSize: TGroupBox;
    Panel1: TPanel;
    rdiPrintPos11: TRadioButton;
    rdiPrintPos21: TRadioButton;
    rdiPrintPos31: TRadioButton;
    rdiPrintPos12: TRadioButton;
    rdiPrintPos22: TRadioButton;
    rdiPrintPos32: TRadioButton;
    rdiPrintPos13: TRadioButton;
    rdiPrintPos23: TRadioButton;
    rdiPrintPos33: TRadioButton;
    rdiPrintSizOrig: TRadioButton;
    rdiPrintSizScale: TRadioButton;
    fldPrintSizScale: TEdit;
    outLblX: TLabel;
    rdiPrintSizFit: TRadioButton;
    btnPrint: TButton;
    btnCancel: TButton;
    grpOrientation: TGroupBox;
    Image1: TImage;
    Image2: TImage;
    rdiPrintOrtVert: TRadioButton;
    rdiPrintOrtHorz: TRadioButton;
    chkPrintScaleSmooth: TCheckBox;
    lblMethod: TLabel;
    outcmbPrintScaleMethod: TComboBox;
    Bevel1: TBevel;
    chkPrintHeader: TCheckBox;
    chkPrintFooter: TCheckBox;
    fldHeaderText: TEdit;
    fldFooterText: TEdit;
    cmbHeaderOrientation: TComboBox;
    cmbFooterOrientation: TComboBox;
    outlblHeaderText: TLabel;
    outlblFooterText: TLabel;
    outbtnHdrFtrHelp: TButton;
    btnHelp: TButton;
    lblCopies: TLabel;
    fldCopies: TEdit;
    spnCopies: TUpDown;
    procedure btnCancelClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure outbtnHdrFtrHelpClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure fldHeaderTextChange(Sender: TObject);
    procedure fldFooterTextChange(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private { Private declarations }
    procedure Apply;

  public { Public declarations }

  end;

var
  frmPrint: TfrmPrint;

implementation

uses
  Math, uMWTools, uMWStrings, IniLang, u_GrxPrinter, u_Main;


{$R *.DFM}

//------------------------------------------------------------------------------
// Save / restore the dialog position
procedure TfrmPrint.FormCreate(Sender: TObject);
begin
  frmMain.ReadWindowPosition(self, False);
end;
procedure TfrmPrint.FormDestroy(Sender: TObject);
begin
  frmMain.SaveWindowPosition(self, False);
end;
//------------------------------------------------------------------------------
// Preparations
procedure TfrmPrint.FormActivate(Sender: TObject);
begin
  rdiPrintPos11.Checked := GlbGrxPrinter.PrintPos = 11;
  rdiPrintPos21.Checked := GlbGrxPrinter.PrintPos = 21;
  rdiPrintPos31.Checked := GlbGrxPrinter.PrintPos = 31;
  rdiPrintPos12.Checked := GlbGrxPrinter.PrintPos = 12;
  rdiPrintPos22.Checked := GlbGrxPrinter.PrintPos = 22;
  rdiPrintPos32.Checked := GlbGrxPrinter.PrintPos = 32;
  rdiPrintPos13.Checked := GlbGrxPrinter.PrintPos = 13;
  rdiPrintPos23.Checked := GlbGrxPrinter.PrintPos = 23;
  rdiPrintPos33.Checked := GlbGrxPrinter.PrintPos = 33;

  rdiPrintSizOrig.Checked := GlbGrxPrinter.PrintSizMode = 1;
  rdiPrintSizScale.Checked := GlbGrxPrinter.PrintSizMode = 2;
  fldPrintSizScale.Text := FloatToStr(GlbGrxPrinter.PrintSizScale);
  rdiPrintSizFit.Checked := GlbGrxPrinter.PrintSizMode = 3;
  chkPrintScaleSmooth.Checked := GlbGrxPrinter.PrintScaleSmooth;
  outcmbPrintScaleMethod.ItemIndex := GlbGrxPrinter.PrintScaleMethod;

  if GlbGrxPrinter.PrintOrtVert then
    rdiPrintOrtVert.Checked := True
  else
    rdiPrintOrtHorz.Checked := True;

  chkPrintHeader.Checked := GlbGrxPrinter.PrintHeader;
  fldHeaderText.Text := GlbGrxPrinter.HeaderText;
  cmbHeaderOrientation.ItemIndex := GlbGrxPrinter.HeaderOrientation;

  chkPrintFooter.Checked := GlbGrxPrinter.PrintFooter;
  fldFooterText.Text := GlbGrxPrinter.FooterText;
  cmbFooterOrientation.ItemIndex := GlbGrxPrinter.FooterOrientation;

  fldHeaderTextChange(nil);
  fldFooterTextChange(nil);
end;
//------------------------------------------------------------------------------
procedure TfrmPrint.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Apply;
end;
//------------------------------------------------------------------------------
procedure TfrmPrint.Apply;
begin
  if      rdiPrintPos11.Checked then
    GlbGrxPrinter.PrintPos := 11
  else if rdiPrintPos21.Checked then
    GlbGrxPrinter.PrintPos := 21
  else if rdiPrintPos31.Checked then
    GlbGrxPrinter.PrintPos := 31
  else if rdiPrintPos12.Checked then
    GlbGrxPrinter.PrintPos := 12
  else if rdiPrintPos22.Checked then
    GlbGrxPrinter.PrintPos := 22
  else if rdiPrintPos32.Checked then
    GlbGrxPrinter.PrintPos := 32
  else if rdiPrintPos13.Checked then
    GlbGrxPrinter.PrintPos := 13
  else if rdiPrintPos23.Checked then
    GlbGrxPrinter.PrintPos := 23
  else if rdiPrintPos33.Checked then
    GlbGrxPrinter.PrintPos := 33;

  if rdiPrintSizOrig.Checked then
    GlbGrxPrinter.PrintSizMode := 1
  else if rdiPrintSizScale.Checked then
    GlbGrxPrinter.PrintSizMode := 2
  else if rdiPrintSizFit.Checked then
    GlbGrxPrinter.PrintSizMode := 3;

  GlbGrxPrinter.PrintSizScale :=  CvtStr2Dbl(fldPrintSizScale.Text);
  GlbGrxPrinter.PrintScaleSmooth := chkPrintScaleSmooth.Checked;
  GlbGrxPrinter.PrintScaleMethod := outcmbPrintScaleMethod.ItemIndex;

  GlbGrxPrinter.PrintOrtVert := rdiPrintOrtVert.Checked;

  GlbGrxPrinter.PrintHeader := chkPrintHeader.Checked;
  GlbGrxPrinter.HeaderText := fldHeaderText.Text;
  GlbGrxPrinter.HeaderOrientation := cmbHeaderOrientation.ItemIndex;

  GlbGrxPrinter.PrintFooter := chkPrintFooter.Checked;
  GlbGrxPrinter.FooterText := fldFooterText.Text;
  GlbGrxPrinter.FooterOrientation := cmbFooterOrientation.ItemIndex;

  GlbGrxPrinter.Copies := spnCopies.Position;
end;
//------------------------------------------------------------------------------
procedure TfrmPrint.btnCancelClick(Sender: TObject);
begin
  Apply;
  Close; // close the form
end;
//------------------------------------------------------------------------------
// Print
procedure TfrmPrint.btnPrintClick(Sender: TObject);
begin
  Apply;
  GlbGrxPrinter.DoPrint;
  Close; // close the form
end;
//------------------------------------------------------------------------------
// Show available header/footer templates
procedure TfrmPrint.outbtnHdrFtrHelpClick(Sender: TObject);
var
  sMsg: String;
begin
  sMsg :=                  ilMiscStr(rsPrintTplHdr      , 'rsPrintTplHdr') + S_CRLF;
  sMsg := sMsg + '%d - ' + ilMiscStr(rsPrintTplDateShort, 'rsPrintTplDateShort') + S_CRLF;
  sMsg := sMsg + '%D - ' + ilMiscStr(rsPrintTplDateLong , 'rsPrintTplDateLong') + S_CRLF;
  sMsg := sMsg + '%t - ' + ilMiscStr(rsPrintTplTimeShort, 'rsPrintTplTimeShort') + S_CRLF;
  sMsg := sMsg + '%T - ' + ilMiscStr(rsPrintTplTimeLong , 'rsPrintTplTimeLong') + S_CRLF;
  sMsg := sMsg + '%x - ' + ilMiscStr(rsPrintTplPicWidth , 'rsPrintTplPicWidth') + S_CRLF;
  sMsg := sMsg + '%y - ' + ilMiscStr(rsPrintTplPicHeight, 'rsPrintTplPicHeight') + S_CRLF;
  sMsg := sMsg + '%n - ' + ilMiscStr(rsPrintTplFileName , 'rsPrintTplFileName') + S_CRLF;
  sMsg := sMsg + '%p - ' + ilMiscStr(rsPrintTplFilePath , 'rsPrintTplFilePath') + S_CRLF;
  sMsg := sMsg +           ilMiscStr(rsPrintTplFtr      , 'rsPrintTplFtr');

  frmMain.CstShowMessage(sMsg);
end;
//------------------------------------------------------------------------------
// Show expanded templates
procedure TfrmPrint.fldHeaderTextChange(Sender: TObject);
begin
  outlblHeaderText.Caption := GlbGrxPrinter.XltTemplate(fldHeaderText.Text);
end;
procedure TfrmPrint.fldFooterTextChange(Sender: TObject);
begin
  outlblFooterText.Caption := GlbGrxPrinter.XltTemplate(fldFooterText.Text);
end;
//------------------------------------------------------------------------------
// Show help on printing
procedure TfrmPrint.btnHelpClick(Sender: TObject);
begin
  frmMain.ShowHelpPage('dlgprint.htm', Handle);
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

end.
