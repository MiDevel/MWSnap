unit u_Ruler;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, Buttons, StdCtrls, ExtCtrls, ImgList;

type
  TfrmRuler = class(TForm)
    popmnuMain: TPopupMenu;
    optClose: TMenuItem;
    optHorizontal: TMenuItem;
    optVertical: TMenuItem;
    N3: TMenuItem;
    optHelp: TMenuItem;
    N1: TMenuItem;
    imgSmall: TImageList;
    imgRuler: TImage;
    imgHole: TImage;
    outlblLength: TLabel;
    imgDirection: TImage;
    pnlResize: TPanel;
    imgResize: TImage;
    tmrRuler: TTimer;
    optToggleDir: TMenuItem;
    N2: TMenuItem;
    procedure optCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormResize(Sender: TObject);
    procedure popmnuMainPopup(Sender: TObject);
    procedure optHorizontalClick(Sender: TObject);
    procedure optVerticalClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure optHelpClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure imgResizeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure imgResizeMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure imgResizeMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure imgRulerMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure imgRulerMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure imgRulerMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure imgHoleClick(Sender: TObject);
    procedure tmrRulerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure optToggleDirClick(Sender: TObject);

  protected { Protected declarations }
    procedure CreateParams(var Params: TCreateParams); override;

  private { Private declarations }
    procedure PaintRuler;
{
    procedure WMNCHitTest(var Msg: TWMNCHitTest); message WM_NCHitTest;
    procedure WMNCLButtonDown(var Msg: TWMNCLButtonDown); message WM_NCLBUTTONDOWN;
    procedure WMNCLButtonUp(var Msg: TWMNCLButtonUp); message WM_NCLBUTTONUP;
    procedure WMNCRButtonDown(var Msg: TWMNCRButtonDown); message WM_NCRBUTTONDOWN;
    procedure WMNCMouseMove(var Msg: TWMNCMouseMove); message WM_NCMOUSEMOVE;
}
  public  { Public declarations }
  end;

const
  LIN_LNG = 10;
  LIN_MID =  6;
  LIN_SHT =  4;

var
  frmRuler: TfrmRuler;

implementation

uses
  u_Main, uMWTools;

var
  m_Horizontal: Boolean;
  m_DirRight: Boolean;
  m_borderWdt: Integer; // form border width
  m_Redraw: Boolean; // redraw the ruler?

  m_IsDragging: Boolean;
  m_DragCX, m_DragCY: Integer;

  m_IsResizing: Boolean;
  m_ResizeCX, m_ResizeCY: Integer;

{$R *.DFM}


//------------------------------------------------------------------------------
// We want our window to be system-wide on top
procedure TfrmRuler.FormCreate(Sender: TObject);
begin
//  SetSystemModalWindow(handle);
  m_Redraw := False;
  frmMain.ReadWindowPosition(self, True);
  imgRuler.Align := alClient;
  m_Horizontal := frmRuler.Width > frmRuler.Height;
  m_DirRight := True;
  m_IsResizing := False;
end;
//------------------------------------------------------------------------------
procedure TfrmRuler.FormDestroy(Sender: TObject);
begin
  frmMain.SaveWindowPosition(self, True);
end;
//------------------------------------------------------------------------------
//
procedure TfrmRuler.FormActivate(Sender: TObject);
begin
  m_Redraw := True;
  m_borderWdt := (Width - imgRuler.Width) div 2;
//  imgSmall.GetBitmap(1, imgHole.Picture.Bitmap);
//  imgSmall.GetBitmap(2, imgResize.Picture.Bitmap);

  PaintRuler;
  tmrRuler.Enabled := True;
end;
//------------------------------------------------------------------------------
procedure TfrmRuler.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  tmrRuler.Enabled := False;
end;
//------------------------------------------------------------------------------
// Close with Esc
procedure TfrmRuler.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #27: Close; // Escape
  end;
end;
//------------------------------------------------------------------------------
// Handle the keyboard
procedure TfrmRuler.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  iStep: Integer;
begin

  if ssShift in Shift then // smooth
    iStep := 1
  else if ssCtrl in Shift then // large
    iStep := 20
  else
    iStep := 5;

  case Key of
    VK_RIGHT: Width  := Width  + iStep;
    VK_LEFT : Width  := Width  - iStep;
    VK_UP   : Height := Height - iStep;
    VK_DOWN : Height := Height + iStep;
    VK_SPACE: if m_Horizontal then
                optVerticalClick(nil)
              else
                optHorizontalClick(nil);
    VK_BACK :
              begin
                m_DirRight := not m_DirRight;
                PaintRuler;
              end;
  end;
end;
//------------------------------------------------------------------------------
// Remove the caption, preserve resizable border
// Make sure BorderStyle is bsSizeable!
procedure TfrmRuler.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := (Style OR WS_POPUP) AND NOT WS_DLGFRAME;
    WndParent := GetDesktopWindow;
  end;
end;
//------------------------------------------------------------------------------
// Resizing
procedure TfrmRuler.imgResizeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  m_ResizeCX := Mouse.CursorPos.x;
  m_ResizeCY := Mouse.CursorPos.y;
  m_IsResizing := True;
end;
procedure TfrmRuler.imgResizeMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  m_IsResizing := False;
end;
procedure TfrmRuler.imgResizeMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if m_IsResizing then
  begin
    frmRuler.Width  := frmRuler.Width  + (Mouse.CursorPos.x - m_ResizeCX);
    frmRuler.Height := frmRuler.Height + (Mouse.CursorPos.y - m_ResizeCY);
    m_ResizeCX := Mouse.CursorPos.x;
    m_ResizeCY := Mouse.CursorPos.y;
  end;
end;
//------------------------------------------------------------------------------
// Dragging
procedure TfrmRuler.imgRulerMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if m_IsDragging then
  begin
    frmRuler.Left := frmRuler.Left + (Mouse.CursorPos.x - m_DragCX);
    frmRuler.Top  := frmRuler.Top  + (Mouse.CursorPos.y - m_DragCY);
    m_DragCX := Mouse.CursorPos.x;
    m_DragCY := Mouse.CursorPos.y;
  end;
end;
procedure TfrmRuler.imgRulerMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  m_DragCX := Mouse.CursorPos.x;
  m_DragCY := Mouse.CursorPos.y;
  m_IsDragging := True;
  Cursor := crHandPoint;
end;
procedure TfrmRuler.imgRulerMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  m_IsDragging := False;
  Cursor := crArrow;
end;
//------------------------------------------------------------------------------
// Change the ruler direction
procedure TfrmRuler.optToggleDirClick(Sender: TObject);
begin
  m_DirRight := not m_DirRight;
  PaintRuler;
end;
//------------------------------------------------------------------------------
// Local menu
procedure TfrmRuler.imgHoleClick(Sender: TObject);
begin
  popmnuMain.Popup(Mouse.CursorPos.x, Mouse.CursorPos.y);
end;
//------------------------------------------------------------------------------
// Timer event - show the readings
procedure TfrmRuler.tmrRulerTimer(Sender: TObject);
var
  cx, cy: Integer;
begin

  if (not m_IsResizing) and (not m_IsDragging) then
  begin
    cx := Mouse.CursorPos.x - Left - m_borderWdt;
    cy := Mouse.CursorPos.y - Top  - m_borderWdt;
    if m_Horizontal then
      outlblLength.Caption := IntToStr(iifi(m_DirRight, cx, imgRuler.Width  - cx - 1))
    else
      outlblLength.Caption := IntToStr(iifi(m_DirRight, cy, imgRuler.Height - cy - 1));
  end;
end;

{
//------------------------------------------------------------------------------
// Allow dragging by catching any form's location
procedure TfrmRuler.WMNCHitTest(var Msg: TWMNCHitTest);
begin
  inherited;   // call the inherited message handler

  // is the click in the client area?
  if Msg.Result = htClient then
    Msg.Result := htCaption; // if so, make Windows think it's on the caption bar
end;
//------------------------------------------------------------------------------
// Detect left-clicks
procedure TfrmRuler.WMNCLButtonDown(var Msg: TWMNCLButtonDown);
var
  cx, cy: Integer;
  function CtrlHit(ctl: TControl): Boolean;
  begin
    Result := (cx >= ctl.Left) and (cy >= ctl.Top)
              and (cx <  ctl.Left + ctl.Width) and (cy <  ctl.Top  + ctl.Height);
  end;
begin
  inherited;   // call the inherited message handler
  cx := Msg.XCursor - Left - m_borderWdt;
  cy := Msg.YCursor - Top - m_borderWdt;

  if CtrlHit(pnlResize) then
  begin
    m_ResizeCX := Mouse.CursorPos.x;
    m_ResizeCY := Mouse.CursorPos.y;
    m_IsResizing := True;
  end
  else if CtrlHit(imgHole) then
  begin
    popmnuMain.Popup(Mouse.CursorPos.x, Mouse.CursorPos.y);
  end
  else if CtrlHit(imgDirection) then
  begin
    m_DirRight := not m_DirRight;
    PaintRuler;
  end;
end;
//------------------------------------------------------------------------------
// Detect left-clicks
procedure TfrmRuler.WMNCLButtonUp(var Msg: TWMNCLButtonUp);
begin
  m_IsResizing := False;
end;
//------------------------------------------------------------------------------
// Detect right-clicks
procedure TfrmRuler.WMNCRButtonDown(var Msg: TWMNCRButtonDown);
begin
inherited;   // call the inherited message handler
  popmnuMain.Popup(Mouse.CursorPos.x, Mouse.CursorPos.y);
end;
//------------------------------------------------------------------------------
// Detect mouse move
procedure TfrmRuler.WMNCMouseMove(var Msg: TWMNCMouseMove);
var
  cx, cy: Integer;
begin
inherited;   // call the inherited message handler

  if m_IsResizing then
  begin
    frmRuler.Width  := frmRuler.Width  + (Mouse.CursorPos.x - m_ResizeCX);
    frmRuler.Height := frmRuler.Height + (Mouse.CursorPos.y - m_ResizeCY);
    m_ResizeCX := Mouse.CursorPos.x;
    m_ResizeCY := Mouse.CursorPos.y;
  end;

  cx := Msg.XCursor - Left - m_borderWdt;
  cy := Msg.YCursor - Top - m_borderWdt;
  if m_Horizontal then
    outlblLength.Caption := IntToStr(iifi(m_DirRight, cx, imgRuler.Width - cx - 1))
  else
    outlblLength.Caption := IntToStr(iifi(m_DirRight, cy, imgRuler.Height - cy - 1));
end;
}
//------------------------------------------------------------------------------
// Paint the face of the ruler
procedure TfrmRuler.PaintRuler;
var
  i: Integer;
  lLen, tWdt, tHgt, icx, icy: Integer;
  siz: Integer;
  bmp: TBitmap;
  sTxt: String;
  function CX(x: Integer): Integer;
  begin
    Result := iifi(m_DirRight, x, siz - x - 1)
  end;
  function CY(y: Integer): Integer;
  begin
    Result := iifi(m_DirRight, y, siz - y - 1)
  end;
begin
  if not m_Redraw then
    Exit;

  pnlResize.Top := Height - pnlResize.Height;
  pnlResize.Left := Width - pnlResize.Width;
  pnlResize.Color := frmMain.CloRuler;

  bmp := TBitmap.Create;
  bmp.Width := imgRuler.Width;
  bmp.Height := imgRuler.Height;
  with bmp do
  begin
    Canvas.Brush.Color := frmMain.CloRuler;
    Canvas.FillRect(imgRuler.ClientRect);
    Canvas.Font.Assign(frmRuler.Font);

    // determine the ruler length
    imgDirection.Picture.Bitmap.Canvas.FillRect(imgDirection.ClientRect);
    if m_Horizontal then
    begin
      siz := Width;
      imgSmall.GetBitmap(iifi(m_DirRight, 3, 4), imgDirection.Picture.Bitmap);
    end
    else
    begin
      siz := Height;
      imgSmall.GetBitmap(iifi(m_DirRight, 5, 6), imgDirection.Picture.Bitmap);
    end;

    // paint the scale
    for i := 0 to siz - 1 do
    begin
      case (i mod 50) of
        0: lLen := LIN_LNG;
  //      5,15,25,35,45: len := LIN_SHT;
        2,4,6,8,12,14,16,18,22,24,26,28,32,34,36,38,42,44,46,48: lLen := LIN_SHT;
        10,20,30,40: lLen := LIN_MID;
      else
        lLen := 0;
      end;

      if (lLen > 0) then // output a line
      begin
        if m_Horizontal then // horizontal
        begin
          icx := CX(i);
          Canvas.MoveTo(icx, 0);
          Canvas.LineTo(icx, lLen); // top
          Canvas.MoveTo(icx, Height - 1);
          Canvas.LineTo(icx, Height - 1 - lLen); // bottom
          if lLen = LIN_LNG then // output a label
          begin
            sTxt := IntToStr(i);
            tHgt := Canvas.TextHeight(sTxt);
            tWdt := Canvas.TextWidth(sTxt);
            Canvas.TextOut(icx-(tWdt div 2), lLen + 1, sTxt);
            if Height > (2 * (LIN_LNG + 1 + tHgt)) then
              Canvas.TextOut(icx-(tWdt div 2), Height - lLen - 1 - 12, sTxt);
          end;
        end
        else // vertical
        begin
          icy := CY(i);
          Canvas.MoveTo(0               , icy);
          Canvas.LineTo(lLen            , icy);
          Canvas.MoveTo(Width - 1       , icy);
          Canvas.LineTo(Width - 1 - lLen, icy);
          if lLen = LIN_LNG then // output a label
          begin
            sTxt := IntToStr(i);
            tHgt := Canvas.TextHeight(sTxt);
            tWdt := Canvas.TextWidth(sTxt);
            Canvas.TextOut(lLen + 1, icy-(tHgt div 2), sTxt); // left
            if Width > (2 * (LIN_LNG + 1 + tWdt)) then
              Canvas.TextOut(Width - lLen - 1 - tWdt, icy-(tHgt div 2), sTxt); // right
          end;
        end;
      end;
    end;
  end;
  imgRuler.Picture.Bitmap.Assign(bmp);
  bmp.Free;

  // set the position of the hole and other controls
  if m_Horizontal then
  begin
    imgHole.Left := 14;
    imgHole.Top := (Height - imgHole.Height) div 2 - 1;
    imgDirection.Left := imgHole.Left + imgHole.Width + 4;
    imgDirection.Top  := imgHole.Top;

    outlblLength.Left := imgDirection.Left + imgDirection.Width + 4;
    outlblLength.Top  := imgHole.Top;
  end
  else
  begin
    imgHole.Top := 14;
    imgHole.Left := (Width - imgHole.Width) div 2 - 1;
    imgDirection.Top := imgHole.Top + imgHole.Height + 4;
    imgDirection.Left := imgHole.Left;

    outlblLength.Left := imgHole.Left - 2;
    outlblLength.Top  := imgDirection.Top + imgDirection.Height + 4;
  end;
  outlblLength.Caption := '';
end;
//------------------------------------------------------------------------------
procedure TfrmRuler.FormResize(Sender: TObject);
begin
  PaintRuler;
end;
//------------------------------------------------------------------------------
// Update checks on the menu
procedure TfrmRuler.popmnuMainPopup(Sender: TObject);
begin
  optHorizontal.Checked := m_Horizontal;
  optVertical.Checked := not m_Horizontal;
end;
//------------------------------------------------------------------------------
// Local menu options
procedure TfrmRuler.optHorizontalClick(Sender: TObject);
var
  tmp: Integer;
begin
  m_Redraw := False;
  m_Horizontal := True;
  if Width < Height then
  begin
    tmp := Height;
    Height := Width;
    Width := tmp;
  end;
  m_Redraw := True;
  PaintRuler;
end;
procedure TfrmRuler.optVerticalClick(Sender: TObject);
var
  tmp: Integer;
begin
  m_Redraw := False;
  m_Horizontal := False;
  if Width > Height then
  begin
    tmp := Height;
    Height := Width;
    Width := tmp;
  end;
  m_Redraw := True;
  PaintRuler;
end;
//------------------------------------------------------------------------------
procedure TfrmRuler.optCloseClick(Sender: TObject);
begin
  Close;
end;
//------------------------------------------------------------------------------
// Show help on ruler tool
procedure TfrmRuler.optHelpClick(Sender: TObject);
begin
  frmMain.ShowHelpPage('dlgruler.htm', Handle);
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------


end.
