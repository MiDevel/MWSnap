unit u_Zoomer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls;

type
  TfrmZoomer = class(TForm)
    imgZoom: TImage;
    sttBar: TStatusBar;
    Label2: TLabel;
    lblCdi: TLabel;
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);

  private { Private declarations }

  public { Public declarations }
    procedure CreateParams(var params:tcreateparams); override;
  end;

var
  frmZoomer: TfrmZoomer;

implementation

{$R *.DFM}


//------------------------------------------------------------------------------
procedure TFrmZoomer.CreateParams(var params:tcreateparams);
begin
  inherited CreateParams(Params);
  Params.WndParent := GetDesktopWindow;
end;
//------------------------------------------------------------------------------
procedure TfrmZoomer.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
//var
//  dc: HDC;
begin
//  dc := GetDC(0);
//  BitBlt(imgZoom.Canvas.handle, 0, 0, 40, 40, dc, X, Y, srcCopy);
//  ReleaseDC(0, dc);
  lblCdi.Caption := '(' + IntToStr(X) + ',' + IntToStr(Y) + ')';
end;
//------------------------------------------------------------------------------
procedure TfrmZoomer.FormActivate(Sender: TObject);
begin
  SetCaptureControl(imgZoom);
end;
//------------------------------------------------------------------------------
procedure TfrmZoomer.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SetCaptureControl(Nil);
end;
//------------------------------------------------------------------------------
// Close with Esc
procedure TfrmZoomer.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then // Escape
    Close;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

end.
