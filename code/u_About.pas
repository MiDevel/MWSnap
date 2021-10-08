unit u_About;

interface

uses
  Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, VerView, ShellAPI, Dialogs;

const
  rsVersion='Version';
  rsThanksGoTo='My thanks go to:';

type
  TfrmAbout = class(TForm)
    Panel1: TPanel;
    ProgramIcon: TImage;
    outlblTitle1: TLabel;
    outlblCopyright: TLabel;
    OKButton: TButton;
    outlblTitle2: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Image1: TImage;
    outlblEMail2: TLabel;
    outlblWWW1: TLabel;
    Image2: TImage;
    Image3: TImage;
    outlblEMail1: TLabel;
    Image4: TImage;
    outlblWWW2: TLabel;
    lblHttp1: TEdit;
    lblE_mail1: TEdit;
    lblHttp2: TEdit;
    lblE_mail2: TEdit;
    outlblVersion: TLabel;
    outlblBeta: TLabel;
    btnCredits: TButton;
    imgPayPal: TImage;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnCredits1Click(Sender: TObject);
    procedure lblE_mail1Click(Sender: TObject);
    procedure lblE_mail2Click(Sender: TObject);
    procedure lblHttp1Click(Sender: TObject);
    procedure lblHttp2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure imgPayPalClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

uses
  u_Main, uMWStrings, IniLang;

{$R *.DFM}



//------------------------------------------------------------------------------
// Allow <Esc> to close the form
procedure TfrmAbout.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Chr(27) then Close; // Escape
end;
//------------------------------------------------------------------------------
// Send me an e-mail
procedure TfrmAbout.lblE_mail1Click(Sender: TObject);
begin
  ShellExecute(Handle,'open',PChar('mailto:info@mirekw.com?Subject=MWSnap' + ' ' + frmMain.lblVsn.GetLabelText),'','',sw_Normal);
end;
procedure TfrmAbout.lblE_mail2Click(Sender: TObject);
begin
  ShellExecute(Handle,'open',PChar('mailto:mirwoj@life.pl?Subject=MWSnap' + ' ' + frmMain.lblVsn.GetLabelText),'','',sw_Normal);
  //ShellExecute(Handle,'open','mailto:mirwoj@homemail.com?Subject=MCell','','',sw_Normal);
end;
//------------------------------------------------------------------------------
// Visit my home page
procedure TfrmAbout.lblHttp1Click(Sender: TObject);
begin
  ShellExecute(Handle,'open','http://www.mirekw.com/index.html','','',sw_Normal);
  //HLinkNavigateString(Nil,'http://www.mirwoj.opus.chelm.pl');
end;
procedure TfrmAbout.lblHttp2Click(Sender: TObject);
begin
  ShellExecute(Handle,'open','http://www.mirwoj.opus.chelm.pl/index.html','','',sw_Normal);
end;
procedure TfrmAbout.imgPayPalClick(Sender: TObject);
begin
  ShellExecute(Handle,'open','http://www.mirekw.com/donate/donate.html ','','',sw_Normal);
end;
//------------------------------------------------------------------------------
procedure TfrmAbout.btnCredits1Click(Sender: TObject);
var
  sMsg: String;
begin
  sMsg := ilMiscStr(rsThanksGoTo, 'rsThanksGoTo') + S_CRLFLF;
  sMsg := sMsg + '- Günter Lahner, Dan and Danis Whitehurst, for extensive Beta-testing and ideas,' + S_CRLF;
  sMsg := sMsg + '- Anders Melander (anders@melander.dk), for TGifImage component,' + S_CRLF;
  sMsg := sMsg + '- Gustave Daud (gustavodaud@uol.com.br), for TPNGImage component,' + S_CRLF;
  sMsg := sMsg + '- Wolfgang Krug (krug@sdm.de), for Bmp2Tiff component,' + S_CRLF;
  sMsg := sMsg + '- Alexey Krivonogov (www.gentee.com) for Setup Generator,' + S_CRLF;
  sMsg := sMsg + '- Markus F.X.J. Oberhumer && Laszlo Molnar for the UPX executables packer,' + S_CRLF;
  sMsg := sMsg + '- Alberto Borja, Aleksandar Savic, Babenkov Eugeny, Günter Lahner, Johan Ditmar,' + S_CRLF +
                 '  Leif Larsson, Luca Degani, Tsung-Che Wu, Zdenìk Jantaè and Vlamo for translations.';

  frmMain.CstShowMessage(sMsg);
end;
//------------------------------------------------------------------------------
procedure TfrmAbout.FormCreate(Sender: TObject);
begin
  outlblBeta.Visible := frmMain.IsBeta;
  frmMain.ReadWindowPosition(self, False);
end;
//------------------------------------------------------------------------------
procedure TfrmAbout.FormDestroy(Sender: TObject);
begin
  frmMain.SaveWindowPosition(self, False);
end;
//------------------------------------------------------------------------------
procedure TfrmAbout.FormShow(Sender: TObject);
begin
  outlblVersion.Caption  := ilMiscStr(rsVersion, 'rsVersion') + ' ' + frmMain.lblVsn.GetLabelText +
    ' - freeware';
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------


end.

