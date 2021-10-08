unit u_ColorInfo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons;

type
  TfrmColorInfo = class(TForm)
    pnlClo: TPanel;
    lblCloRGB: TLabel;
    btnClose: TButton;
    outfldCloRGB: TEdit;
    lblCloHTML: TLabel;
    lblCloDelphi: TLabel;
    lblCloSystem: TLabel;
    outfldCloHTML: TEdit;
    outfldCloDelphi: TEdit;
    outfldCloSystem: TEdit;
    btnCloRGB: TBitBtn;
    btnCloHTML: TBitBtn;
    btnCloDelphi: TBitBtn;
    btnCloSystem: TBitBtn;
    procedure FormActivate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnCloRGBClick(Sender: TObject);
    procedure btnCloHTMLClick(Sender: TObject);
    procedure btnCloDelphiClick(Sender: TObject);
    procedure btnCloSystemClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private { Private declarations }
    m_Clo: TColor;

  public { Public declarations }
    property Clo: TColor read m_Clo write m_Clo;

  end;

var
  frmColorInfo: TfrmColorInfo;

implementation

uses
  Clipbrd, IniLang, u_Main;

{$R *.DFM}

//------------------------------------------------------------------------------
procedure TfrmColorInfo.FormCreate(Sender: TObject);
begin
  frmMain.ReadWindowPosition(self, False);
end;
//------------------------------------------------------------------------------
procedure TfrmColorInfo.FormDestroy(Sender: TObject);
begin
  frmMain.SaveWindowPosition(self, False);
end;
//------------------------------------------------------------------------------
procedure TfrmColorInfo.FormActivate(Sender: TObject);
var
  r, g, b: Byte;
  sBff: String;
begin
  pnlClo.Color := Clo;

  r := GetRValue(clo);
  g := GetGValue(clo);
  b := GetBValue(clo);

  outfldCloRGB.Text := 'R:' + IntToHex(r, 2) + ', G:' + IntToHex(g, 2) + ', B:' + IntToHex(b, 2);
  outfldCloDelphi.Text := '$00' + IntToHex(b, 2) + IntToHex(g, 2) + IntToHex(r, 2);
  outfldCloHTML.Text := '#' + IntToHex(r, 2) + IntToHex(g, 2) + IntToHex(b, 2);
  if ColorToIdent(Clo, sBff) then
    outfldCloSystem.Text := sBff
  else
    outfldCloSystem.Text := '-';
end;
//------------------------------------------------------------------------------
// Close with Esc
procedure TfrmColorInfo.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then // Escape
    Close;
end;
procedure TfrmColorInfo.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F4 then // Close
    Close;
end;
//------------------------------------------------------------------------------
procedure TfrmColorInfo.btnCloRGBClick(Sender: TObject);
begin
  Clipboard.SetTextBuf(PChar(outfldCloRGB.Text));
end;
procedure TfrmColorInfo.btnCloHTMLClick(Sender: TObject);
begin
  Clipboard.SetTextBuf(PChar(outfldCloHTML.Text));
end;
procedure TfrmColorInfo.btnCloDelphiClick(Sender: TObject);
begin
  Clipboard.SetTextBuf(PChar(outfldCloDelphi.Text));
end;
procedure TfrmColorInfo.btnCloSystemClick(Sender: TObject);
begin
  Clipboard.SetTextBuf(PChar(outfldCloSystem.Text));
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------


end.
