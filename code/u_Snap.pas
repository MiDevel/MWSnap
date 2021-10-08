unit u_Snap;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons;

const
  POSCRS_SIZE = 3; // size of the cursor marking the exact location

type
  TSnapMode = (SNAP_RECT, SNAP_AREA, SNAP_DESK, SNAP_WIND, SNAP_LAST, SNAP_ZOOM, SNAP_CLOP, SNAP_INFO, SNAP_RULR);

  TfrmSnap = class(TForm)
    tmrStart: TTimer;
    pnlPreview: TPanel;
    imgPreview: TImage;
    outlblCoords: TLabel;
    lblHelpCursors: TLabel;
    lblHelpTglCorner: TLabel;
    pnlZoomer: TPanel;
    imgZoomer: TImage;
    pnlZoomerInfo: TPanel;
    lblHelpResize: TLabel;
    lblHelpPlusMinus: TLabel;
    pnlZoomerTitle: TPanel;
    btnZoomerTitle: TSpeedButton;
    outlblZomCoords: TLabel;
    lblHelpShowPreview: TLabel;
    pnlWdwInfo: TPanel;
    lblWinInfoPos: TLabel;
    lblWinInfoSize: TLabel;
    lblWinInfoText: TLabel;
    lblWinInfoClass: TLabel;
    outfldWinInfoPos: TLabel;
    outfldWinInfoSize: TLabel;
    outfldWinInfoText: TLabel;
    outfldWinInfoClass: TLabel;
    pnlWdwInfoTitle: TPanel;
    btnWdwInfoTitle: TSpeedButton;
    lblWinInfoHandle: TLabel;
    outfldWinInfoHandle: TLabel;
    pnlClop: TPanel;
    imgClop: TImage;
    pnlClopOneColor: TPanel;
    pnlClopTitle: TPanel;
    btnClopTitle: TSpeedButton;
    outlblHelpPlusMinus: TLabel;
    outlblClopCoords: TLabel;
    pnlClopCrrColor: TPanel;
    outlblClopCrrRGB: TLabel;
    pnlClopColorsHistory: TPanel;
    lblClopColorDetails: TLabel;
    pnlClopColor01: TPanel;
    pnlClopColor10: TPanel;
    pnlClopColor09: TPanel;
    pnlClopColor08: TPanel;
    pnlClopColor07: TPanel;
    pnlClopColor06: TPanel;
    pnlClopColor05: TPanel;
    pnlClopColor04: TPanel;
    pnlClopColor03: TPanel;
    pnlClopColor02: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure tmrStartTimer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure pnlPreviewMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure pnlZoomerTitleMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure pnlZoomerTitleMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure pnlZoomerTitleMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure pnlZoomerTitleResize(Sender: TObject);
    procedure btnZoomerTitleClick(Sender: TObject);
    procedure pnlWdwInfoTitleMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure pnlWdwInfoTitleMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure pnlWdwInfoTitleMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure pnlWdwInfoTitleResize(Sender: TObject);
    procedure btnWdwInfoTitleClick(Sender: TObject);
    procedure pnlClopColorMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure pnlClopColorClick(Sender: TObject);
    procedure pnlClopTitleMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure pnlClopTitleMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure pnlClopTitleMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

  private { Private declarations }
    fMarkRectOn: Boolean; // is the rectangle drawn?
    m_snapP1, m_snapP2: TPoint; // current snapping
    m_lastSnapP1, m_lastSnapP2: TPoint; // previous snapping
    m_p1Set: Boolean;
    m_lastMarkRectP1, m_lastMarkRectP2: TPoint;
    m_lastMarkRectDouble: Boolean;
    m_initDone: Boolean;
    procedure RepaintBackground;
    procedure WMEraseBkGnd(var Msg: TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure MarkRect(mde: Integer; fDouble: Boolean);
    procedure DrawRect(x1, y1, x2, y2: Integer; fDouble: Boolean);
    procedure UpdatePreviewBox(X, Y: Integer);
    procedure UpdateZoomerBox(X, Y: Integer);
    procedure UpdateClopBox(X, Y: Integer; clo: TColor);
    procedure AddNewClopColor(X, Y: Integer; clo: TColor);
    procedure UpdateInfoBox(X, Y: Integer);

  public { Public declarations }
    dx, dy: Integer;
    mode: TSnapMode;
    procedure DoSnap;

  end;

var
  frmSnap: TfrmSnap;

implementation

uses
  u_Main, Math, u_SnapTools, u_Zoomer, uMWTools, uMWErrorLog, u_ColorInfo,
  u_Sounds;

var
  bmpPreview: TBitmap;
  bmpZoomer: TBitmap;
  facZoomer: Integer;

  ZB_fDrag: Boolean = False; // flag for whether dragging the item or not
  ZB_XOS, ZB_YOS: Integer;   // X & Y offset while dragging

{$R *.DFM}

//------------------------------------------------------------------------------
//
procedure TfrmSnap.FormCreate(Sender: TObject);
begin
  fMarkRectOn := False; // no rectangle yet
  m_snapP1 := Point(-1, -1);
  dx := 32;
  dy := 32;
  m_p1Set := False;
end;
//------------------------------------------------------------------------------
//
procedure TfrmSnap.FormActivate(Sender: TObject);
begin
  Application.BringToFront;
  BringToFront;

  m_initDone := False;
  fMarkRectOn := False; // no rectangle yet
  m_p1Set := False;
  lblHelpTglCorner.Visible := False;
  pnlPreview.Visible := False;
  pnlZoomer.Visible := False;
  pnlClop.Visible := False;
  pnlWdwInfo.Visible := False;
  ZB_fDrag := False; // flag for whether dragging the item or not
  SetBounds(0, 0, Screen.Width, Screen.Height); // form on the whole screen
  outlblHelpPlusMinus.Caption := lblHelpPlusMinus.Caption;

  Canvas.Pen.Width := 1;
  Canvas.Pen.Color := clRed;
  Canvas.Pen.Style := psDot;
  Canvas.Pen.Mode := pmXor;

  RepaintBackground; // refresh the full desktop image
  Application.ProcessMessages;
  tmrStart.Enabled := True;
end;
//------------------------------------------------------------------------------
//
procedure TfrmSnap.FormDestroy(Sender: TObject);
begin
end;
//------------------------------------------------------------------------------
// Start snapping - activate the cursor
procedure TfrmSnap.tmrStartTimer(Sender: TObject);
begin
  // start!
  tmrStart.Enabled := False; // only once
  m_p1Set := False;

  case mode of
    SNAP_RECT:
         begin
            frmSnap.Cursor := crArrow;
            m_snapP1.x := Mouse.CursorPos.x - dx div 2;
            m_snapP1.y := Mouse.CursorPos.y - dy div 2;
            m_snapP2.x := m_snapP1.x + dx - 1;
            m_snapP2.y := m_snapP1.y + dy - 1;
            MarkRect(1, False); // show the initial rectangle
            pnlPreview.Visible := frmMain.ShowPreviewBox;
         end;
      SNAP_AREA:
         begin
            frmSnap.Cursor := crCross;
            m_snapP1 := Mouse.CursorPos;
            pnlPreview.Visible := frmMain.ShowPreviewBox;
         end;
      SNAP_DESK:
         begin
            frmSnap.Cursor := crArrow;
            m_snapP1 := Point(0, 0);
            m_snapP2.x := Screen.Width - 1;
            m_snapP2.y := Screen.Height - 1;
            DoSnap;
            ModalResult := mrOk; // that's all
            Exit;
         end;
      SNAP_WIND:
         begin
            frmSnap.Cursor := crHandPoint;
         end;
      SNAP_LAST:
         begin
            frmSnap.Cursor := crArrow;
            m_SnapP1 := m_lastSnapP1;
            m_SnapP2 := m_lastSnapP2;
            DoSnap;
            ModalResult := mrOk; // that's all
            Exit;
         end;
      SNAP_ZOOM:
         begin
            m_snapP1 := Mouse.CursorPos;
            pnlZoomer.Visible := True;
         end;
      SNAP_CLOP:
         begin
            m_snapP1 := Mouse.CursorPos;
            pnlClop.Visible := True;
         end;
      SNAP_INFO:
         begin
            frmSnap.Cursor := crArrow;
            m_snapP1 := Mouse.CursorPos;
            pnlWdwInfo.Visible := True;
         end;
  end;
  UpdatePreviewBox(Mouse.CursorPos.x, Mouse.CursorPos.y);
  m_initDone := True;
end;
//------------------------------------------------------------------------------
// Everything's been set, do snap!
procedure TfrmSnap.DoSnap;
var
  dx, dy: Integer;
begin
  BoundInt(0, m_snapP1.x, Screen.Width  - 1);
  BoundInt(0, m_snapP1.y, Screen.Height - 1);
  BoundInt(0, m_snapP2.x, Screen.Width  - 1);
  BoundInt(0, m_snapP2.y, Screen.Height - 1);

  dx := Abs(m_snapP1.x - m_snapP2.x) + 1;
  dy := Abs(m_snapP1.y - m_snapP2.y) + 1;
  m_snapP1.x := Min(m_snapP1.x, m_snapP2.x);
  m_snapP1.y := Min(m_snapP1.y, m_snapP2.y);
  m_snapP2.x := m_snapP1.x + dx - 1;
  m_snapP2.y := m_snapP1.y + dy - 1;

  pnlPreview.Visible := False;
  pnlZoomer.Visible := False;
  pnlClop.Visible := False;
  pnlWdwInfo.Visible := False;
  RepaintBackground; // refresh the full desktop image

  frmMain.TheBmp.Width  := dx;
  frmMain.TheBmp.Height := dy;
  frmMain.TheBmp.Canvas.CopyRect(Rect(0, 0, dx, dy),
                                 Canvas,
                                 Rect(m_snapP1.x, m_snapP1.y, m_snapP1.x+dx, m_snapP1.y+dy));

  m_lastSnapP1 := m_SnapP1;
  m_lastSnapP2 := m_SnapP2;
{
ErrLog.WriteString('>?Snap1  m_snapP1.x=' + FloatToStr(m_snapP1.x) +
                   ', m_snapP1.y=' + FloatToStr(m_snapP1.y) +
                   ', m_snapP2.x=' + FloatToStr(m_snapP2.x) +
                   ', m_snapP2.y=' + FloatToStr(m_snapP2.y));
}
end;
//------------------------------------------------------------------------------
// Preview panel should always start initially invisible
procedure TfrmSnap.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  pnlPreview.Visible := False;
  pnlZoomer.Visible := False;
  pnlClop.Visible := False;
  pnlWdwInfo.Visible := False;
end;
//------------------------------------------------------------------------------
// Refresh the image of the whole desktop
procedure TfrmSnap.RepaintBackground;
begin
  MarkRect(0, False); // hide rectangle
  Canvas.Draw(0, 0, frmMain.TheBmp);
end;
//------------------------------------------------------------------------------
// Avoid flickering
procedure TfrmSnap.WMEraseBkGnd(var Msg: TWMEraseBkGnd);
begin
  Msg.Result := 1;
end;
//------------------------------------------------------------------------------
//
procedure TfrmSnap.DrawRect(x1, y1, x2, y2: Integer; fDouble: Boolean);
begin
  Canvas.Polyline([Point(x1, y1), Point(x1, y2), Point(x2, y2), Point(x2, y1), Point(x1, y1)]);

  if fDouble then
  begin
    Inc(x1); Inc(y1);
    Dec(x2); Dec(y2);
    Canvas.Polyline([Point(x1, y1), Point(x1, y2), Point(x2, y2), Point(x2, y1), Point(x1, y1)]);
  end;
end;
//------------------------------------------------------------------------------
// mde: 0 - clear, 1 - normal
procedure TfrmSnap.MarkRect(mde: Integer; fDouble: Boolean);
begin
  BoundInt(0, m_snapP1.x, Screen.Width  - 1);
  BoundInt(0, m_snapP1.y, Screen.Height - 1);
  BoundInt(0, m_snapP2.x, Screen.Width  - 1);
  BoundInt(0, m_snapP2.y, Screen.Height - 1);

  // when last drawn hide it
  if fMarkRectOn then
  begin
    DrawRect(m_lastMarkRectP1.x, m_lastMarkRectP1.y, m_lastMarkRectP2.x, m_lastMarkRectP2.y, m_lastMarkRectDouble);
    fMarkRectOn := False; // no rectangle
  end;

  if (mde <> 0) then // not clear
  begin
    // mark new
    if m_snapP1.x >= 0 then
    begin
      m_lastMarkRectP1 := m_snapP1;
      m_lastMarkRectP2 := m_snapP2;
      m_lastMarkRectDouble := fDouble;
      DrawRect(m_lastMarkRectP1.x, m_lastMarkRectP1.y, m_lastMarkRectP2.x, m_lastMarkRectP2.y, fDouble);
      fMarkRectOn := True;
    end;
  end;
end;
//------------------------------------------------------------------------------
// Mouse down detected
procedure TfrmSnap.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  rect: TRect;
begin
  if m_initDone and (Button = mbLeft) then
  begin
    MarkRect(0, False); // hide rectangle

    case mode of
      SNAP_RECT:
           begin
              m_snapP1.x := X - dx div 2;
              m_snapP1.y := Y - dy div 2;
              m_snapP2.x := m_snapP1.x + dx - 1;
              m_snapP2.y := m_snapP1.y + dy - 1;
              DoSnap; // ready, go snap
              ModalResult := mrOk;
           end;
      SNAP_AREA:
           begin
              if m_p1Set then
              begin
                m_snapP2 := Point(X, Y);
                DoSnap; // ready, go snap
                ModalResult := mrOk;
              end
              else
              begin
                m_snapP1 := Point(X, Y);
                m_p1Set := True; // 1st point set, ask for the second one
                lblHelpTglCorner.Visible := True;
              end;
           end;
      SNAP_WIND:
           begin
             if (FindWindow(Point(X, Y), rect) <> 0) then
             begin
               m_snapP1 := rect.TopLeft;
               m_snapP2 := rect.BottomRight;
               Dec(m_snapP2.x);
               Dec(m_snapP2.y);
               DoSnap; // ready, go snap
               ModalResult := mrOk;
             end
           end;
      SNAP_ZOOM:
           begin
           end;
      SNAP_CLOP:
           begin
             AddNewClopColor(X, Y, Canvas.Pixels[X, Y]);
           end;
      SNAP_INFO:
           begin
           end;
    end;
  end;
end;
//------------------------------------------------------------------------------
// Preview the area around the cursor
procedure TfrmSnap.UpdatePreviewBox(X, Y: Integer);
var
  posX, posY: Integer;
  cx, cy: Integer;
  ofs: Integer;
begin
  if not pnlPreview.Visible then
    Exit;

  ofs := 20 + dx div 2; // the minimal distance to the preview window
  if ofs > 100 then ofs := 100;

  if     (X > pnlPreview.Left-ofs) and (X < pnlPreview.Left + pnlPreview.Width+ofs)
     and (Y > pnlPreview.Top-ofs) and (Y < pnlPreview.Top + pnlPreview.Height+ofs) then
  begin // we are inside the preview panel, move the panel
    if X < Screen.Width div 2 then
      posX := Screen.Width - pnlPreview.Width - 50
    else
      posX := 50;

    if Y < Screen.Height div 2 then
      posY := Screen.Height - pnlPreview.Height - 50
    else
      posY := 50;

    pnlPreview.SetBounds(posX, posY, pnlPreview.Width, pnlPreview.Height);
    RepaintBackground; // refresh the full desktop image
  end;

  bmpPreview.Canvas.CopyRect(Rect(0, 0, 39, 39), Canvas, Rect(X-20,Y-20,X+19,Y+19));
  if frmMain.MarkCrsPos then // mark the exact cursor position
  begin
    with bmpPreview.Canvas do
    begin
      Pen.Mode := pmXor;
      Pen.Color := clWhite;
      cx := bmpPreview.Width div 2;
      cy := bmpPreview.Height div 2;
      MoveTo(cx + 1, cy); LineTo(cx + POSCRS_SIZE, cy);
      MoveTo(cx - 1, cy); LineTo(cx - POSCRS_SIZE, cy);
      MoveTo(cx, cy + 1); LineTo(cx, cy + POSCRS_SIZE);
      MoveTo(cx, cy - 1); LineTo(cx, cy - POSCRS_SIZE);
    end;
  end;
  imgPreview.Picture.Assign(bmpPreview);

  // show coordinates
  case mode of
    SNAP_RECT:
        outlblCoords.Caption := IntToStr(X) + ',' + IntToStr(Y) +
             ' (' + IntToStr(dx) + 'x' + IntToStr(dy) +  ')';
    SNAP_AREA:
        outlblCoords.Caption := IntToStr(X) + ',' + IntToStr(Y) +
             ' (' + IntToStr(X-m_snapP1.x+1) + 'x' + IntToStr(Y-m_snapP1.y+1) +  ')';
  else
        outlblCoords.Caption := IntToStr(X) + ',' + IntToStr(Y);
  end;
end;
//------------------------------------------------------------------------------
// Zoom the area around the cursor
procedure TfrmSnap.UpdateZoomerBox(X, Y: Integer);
var
  w, h: Integer;
  cx, cy: Integer;
begin
  if not pnlZoomer.Visible then
    Exit;

  // first clear the zoomer box
  with bmpZoomer do
  begin
    Width  := imgZoomer.Width;
    Height := imgZoomer.Height;
    Canvas.Pen.Color := clWhite;
    Canvas.FillRect(Rect(0, 0, imgZoomer.Width, imgZoomer.Height));
  end;
  imgZoomer.Picture.Assign(bmpZoomer);

  // now show the zoomed contents
  w := imgZoomer.Width  div facZoomer;
  h := imgZoomer.Height div facZoomer;
  bmpZoomer.Width  := w;
  bmpZoomer.Height := h;
  bmpZoomer.Canvas.CopyRect(Rect(0, 0, w-1, h-1),
                            Canvas,
                            Rect(X-w div 2,Y-h div 2,X+(w - w div 2),Y+(h - h div 2)));

  if frmMain.MarkCrsPos then // mark the exact cursor position
  begin
    with bmpZoomer.Canvas do
    begin
      Pen.Mode := pmXor;
      Pen.Color := clWhite;
      cx := w div 2;
      cy := h div 2;
      MoveTo(cx + 1, cy); LineTo(cx + POSCRS_SIZE, cy);
      MoveTo(cx - 1, cy); LineTo(cx - POSCRS_SIZE, cy);
      MoveTo(cx, cy + 1); LineTo(cx, cy + POSCRS_SIZE);
      MoveTo(cx, cy - 1); LineTo(cx, cy - POSCRS_SIZE);
    end;
  end;

  imgZoomer.Picture.Assign(bmpZoomer);
  outlblZomCoords.Caption := '(' + IntToStr(X) + ',' + IntToStr(Y) + '), zoom: ' + IntToStr(facZoomer);
end;
//------------------------------------------------------------------------------
// Zoom the area around the cursor
procedure TfrmSnap.UpdateClopBox(X, Y: Integer; clo: TColor);
var
  w, h: Integer;
  r, g, b: Byte;
  cx, cy: Integer;
begin
  if not pnlClop.Visible then
    Exit;

  // first clear the zoomer box
  with bmpZoomer do
  begin
    Width  := imgClop.Width;
    Height := imgClop.Height;
    Canvas.Pen.Color := clWhite;
    Canvas.FillRect(Rect(0, 0, imgClop.Width, imgClop.Height));
  end;
  imgClop.Picture.Assign(bmpZoomer);

  // now show the zoomed contents
  w := imgClop.Width  div facZoomer;
  h := imgClop.Height div facZoomer;
  bmpZoomer.Width  := w;
  bmpZoomer.Height := h;
  bmpZoomer.Canvas.CopyRect(Rect(0, 0, w-1, h-1),
                            Canvas,
                            Rect(X-w div 2,Y-h div 2,X+(w - w div 2),Y+(h - h div 2)));

  if frmMain.MarkCrsPos then // mark the exact cursor position
  begin
    with bmpZoomer.Canvas do
    begin
      Pen.Mode := pmXor;
      Pen.Color := clWhite;
      cx := w div 2;
      cy := h div 2;
      MoveTo(cx + 1, cy); LineTo(cx + POSCRS_SIZE, cy);
      MoveTo(cx - 1, cy); LineTo(cx - POSCRS_SIZE, cy);
      MoveTo(cx, cy + 1); LineTo(cx, cy + POSCRS_SIZE);
      MoveTo(cx, cy - 1); LineTo(cx, cy - POSCRS_SIZE);
    end;
  end;

  imgClop.Picture.Assign(bmpZoomer);
  outlblClopCoords.Caption := '(' + IntToStr(X) + ',' + IntToStr(Y) + '), zoom: ' + IntToStr(facZoomer);

  // show the color info
  pnlClopCrrColor.Color := clo;
  r := GetRValue(clo);
  g := GetGValue(clo);
  b := GetBValue(clo);
  outlblClopCrrRGB.Caption := 'R:' + IntToHex(r, 2) + ', G:' + IntToHex(g, 2) + ', B:' + IntToHex(b, 2);
end;
//------------------------------------------------------------------------------
// Display the parameters of the window below the cursor
procedure TfrmSnap.UpdateInfoBox(X, Y: Integer);
var
  hWindow: hWnd;
  rect: TRect;
  lpWinText, lpWinClass: PChar;
begin
  if not pnlWdwInfo.Visible then
    Exit;

  hWindow := FindWindow(Point(X, Y), rect);
  if (hWindow <> 0) then
  begin
    GetMem(lpWinText, 255);
    GetMem(lpWinClass, 255);
    try
      GetWindowText(hWindow, lpWinText, 255);
      GetClassName(hWindow, lpWinClass, 255);

      outfldWinInfoPos.Caption    := Format('(%d, %d)', [rect.Left, rect.Top]);
      outfldWinInfoSize.Caption   := Format('(%d, %d)', [rect.Right-rect.Left, rect.Bottom-rect.Top]);
      outfldWinInfoText.Caption   := '"' + lpWinText  + '"';
      outfldWinInfoClass.Caption  := '"' + lpWinClass + '"';
      outfldWinInfoHandle.Caption := IntToStr(hWindow);
    finally
      FreeMem(lpWinText, sizeof(lpWinText^));
      FreeMem(lpWinClass, sizeof(lpWinClass^));
    end;
 end;
end;
//------------------------------------------------------------------------------
// Mouse move event, update zooming windows, coordinates, etc.
procedure TfrmSnap.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  rect: TRect;
begin
  if m_initDone then
  begin
    case mode of
      SNAP_RECT:
           begin
              m_snapP1.x := X - dx div 2;
              m_snapP1.y := Y - dy div 2;
              m_snapP2.x := m_snapP1.x + dx - 1;
              m_snapP2.y := m_snapP1.y + dy - 1;
              MarkRect(1, False); // show new rectangle
           end;
      SNAP_AREA:
           begin
              if m_p1Set then
              begin
                m_snapP2 := Point(X, Y);
                MarkRect(1, False); // show new rectangle
              end
              else
              begin
                m_snapP1 := Point(X, Y);
              end;
           end;
      SNAP_WIND, SNAP_INFO:
           begin
             if (FindWindow(Point(X, Y), rect) <> 0) then
             begin
               m_snapP1 := rect.TopLeft;
               m_snapP2 := rect.BottomRight;
               MarkRect(1, True); // show new rectangle
             end
             else
               MarkRect(0, True); // hide rectangle
           end;
    end;

    case mode of
      SNAP_ZOOM: UpdateZoomerBox(X, Y);
      SNAP_CLOP: UpdateClopBox(X, Y, Canvas.Pixels[X, Y]);
      SNAP_INFO: UpdateInfoBox(X, Y);
      else       UpdatePreviewBox(X, Y);
    end;
  end;
end;
//------------------------------------------------------------------------------
// Handle basic keys
procedure TfrmSnap.FormKeyPress(Sender: TObject; var Key: Char);
var
  tmpPnt: TPoint;
begin

  case Key of
    #13: // Enter - accept
        FormMouseDown(Nil,  mbLeft, [], Mouse.CursorPos.x, Mouse.CursorPos.y);
    #27: // Escape - cancel
        ModalResult := mrCancel;
    #32: // Space - swap endpoints
        if (mode = SNAP_AREA) and m_p1Set then
        begin
          tmpPnt := m_snapP1;
          m_snapP1 := m_snapP2;
          m_snapP2 := tmpPnt;
          Mouse.CursorPos := m_snapP2;
        end;
    '+': // increase zoom factor
        if (mode in [SNAP_ZOOM, SNAP_CLOP]) then
        begin
          Inc(facZoomer);
          if facZoomer > 10 then facZoomer := 10;
          if mode = SNAP_ZOOM then
            UpdateZoomerBox(Mouse.CursorPos.x, Mouse.CursorPos.y)
          else
            UpdateClopBox(Mouse.CursorPos.x, Mouse.CursorPos.y, Canvas.Pixels[Mouse.CursorPos.x, Mouse.CursorPos.y]);
        end;
    '-': // decrease zoom factor
        if (mode in [SNAP_ZOOM, SNAP_CLOP]) then
        begin
          Dec(facZoomer);
          if facZoomer < 1 then facZoomer := 1;
          if mode = SNAP_ZOOM then
            UpdateZoomerBox(Mouse.CursorPos.x, Mouse.CursorPos.y)
          else
            UpdateClopBox(Mouse.CursorPos.x, Mouse.CursorPos.y, Canvas.Pixels[Mouse.CursorPos.x, Mouse.CursorPos.y]);
        end;
  end;
end;
//------------------------------------------------------------------------------
// Fine movement with cursor keys
procedure TfrmSnap.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  d: Integer;
begin
  d := 1;
  case Key of
    VK_F1:
          case mode of
            SNAP_ZOOM: frmMain.ShowHelpPage('dlgzoom.htm', Handle);
            SNAP_CLOP: frmMain.ShowHelpPage('dlg_clopick.htm', Handle);
            SNAP_INFO: frmMain.ShowHelpPage('dlg_wininfo.htm', Handle);
            else       frmMain.ShowHelpPage('snapping.htm', Handle);
          end;

    VK_SPACE:
          if mode = SNAP_CLOP then
          begin
            pnlClopColorClick(Nil);
          end;

    VK_F5:
          begin
            RepaintBackground; // refresh the full desktop image
          end;

    VK_F6:
          begin
            pnlPreview.Visible := not pnlPreview.Visible;
            RepaintBackground; // refresh the full desktop image
            UpdatePreviewBox(Mouse.CursorPos.x, Mouse.CursorPos.y);
          end;

    VK_LEFT, VK_RIGHT, VK_UP, VK_DOWN:
          if (mode = SNAP_ZOOM) then
          begin
            if ssShift in Shift then // move window
            case Key of
              VK_LEFT:  pnlZoomer.Left := pnlZoomer.Left - 8;
              VK_RIGHT: pnlZoomer.Left := pnlZoomer.Left + 8;
              VK_UP:    pnlZoomer.Top := pnlZoomer.Top - 8;
              VK_DOWN:  pnlZoomer.Top := pnlZoomer.Top + 8;
            end
            else if ssCtrl in Shift then // resize window
            case Key of
              VK_LEFT:
                begin
                  pnlZoomer.Width := pnlZoomer.Width - 8;
                  RepaintBackground; // refresh the full desktop image
                end;
              VK_RIGHT:
                pnlZoomer.Width := pnlZoomer.Width + 8;
              VK_UP:
                begin
                  pnlZoomer.Height := pnlZoomer.Height - 8;
                  RepaintBackground; // refresh the full desktop image
                end;
              VK_DOWN:
                pnlZoomer.Height := pnlZoomer.Height + 8;
            end
            else // move cursor
            case Key of
              VK_LEFT:  Mouse.CursorPos := Point(Mouse.CursorPos.x - d, Mouse.CursorPos.y);
              VK_RIGHT: Mouse.CursorPos := Point(Mouse.CursorPos.x + d, Mouse.CursorPos.y);
              VK_UP:    Mouse.CursorPos := Point(Mouse.CursorPos.x, Mouse.CursorPos.y - d);
              VK_DOWN:  Mouse.CursorPos := Point(Mouse.CursorPos.x, Mouse.CursorPos.y + d);
            end;
          end
          else if (mode = SNAP_CLOP) then
          begin
            case Key of
              VK_LEFT:  Mouse.CursorPos := Point(Mouse.CursorPos.x - d, Mouse.CursorPos.y);
              VK_RIGHT: Mouse.CursorPos := Point(Mouse.CursorPos.x + d, Mouse.CursorPos.y);
              VK_UP:    Mouse.CursorPos := Point(Mouse.CursorPos.x, Mouse.CursorPos.y - d);
              VK_DOWN:  Mouse.CursorPos := Point(Mouse.CursorPos.x, Mouse.CursorPos.y + d);
            end;
          end
          else
          begin
            if ssCtrl in Shift then
              d := 5;
            case Key of
              VK_LEFT:
                Mouse.CursorPos := Point(Mouse.CursorPos.x - d, Mouse.CursorPos.y);
              VK_RIGHT:
                Mouse.CursorPos := Point(Mouse.CursorPos.x + d, Mouse.CursorPos.y);
              VK_UP:
                Mouse.CursorPos := Point(Mouse.CursorPos.x, Mouse.CursorPos.y - d);
              VK_DOWN:
                Mouse.CursorPos := Point(Mouse.CursorPos.x, Mouse.CursorPos.y + d);
            end;
          end;
  end;
end;
//------------------------------------------------------------------------------
// Delegate the mouse move to the form
procedure TfrmSnap.pnlPreviewMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  FormMouseMove(Sender, Shift, Mouse.CursorPos.x, Mouse.CursorPos.y);
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// Handle dragging of the zoomer box
//------------------------------------------------------------------------------
procedure TfrmSnap.pnlZoomerTitleMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ZB_XOS := X;
  ZB_YOS := y;
  if Button = mbLeft then
    ZB_fDrag := True
end;
//------------------------------------------------------------------------------
procedure TfrmSnap.pnlZoomerTitleMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  newX, newY: Integer;
begin
  if ZB_fDrag = True then
  begin
    newX := x + pnlZoomer.Left + TControl(Sender).Left - ZB_XOS;
    newY := y + pnlZoomer.Top + TControl(Sender).Top  - ZB_YOS;
    pnlZoomer.Left := newX;
    pnlZoomer.Top  := newY;
    RepaintBackground; // refresh the full desktop image
  end;
end;
//------------------------------------------------------------------------------
procedure TfrmSnap.pnlZoomerTitleMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ZB_fDrag := False;
end;
//------------------------------------------------------------------------------
procedure TfrmSnap.pnlZoomerTitleResize(Sender: TObject);
begin
  btnZoomerTitle.Left := pnlZoomerTitle.Width - btnZoomerTitle.Width - 2;
end;
//------------------------------------------------------------------------------
procedure TfrmSnap.btnZoomerTitleClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// Handle dragging of the window info box
procedure TfrmSnap.pnlWdwInfoTitleMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ZB_XOS := X;
  ZB_YOS := y;
  if Button = mbLeft then
    ZB_fDrag := True
end;
//------------------------------------------------------------------------------
procedure TfrmSnap.pnlWdwInfoTitleMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  newX, newY: Integer;
begin
  if ZB_fDrag = True then
  begin
    newX := x + pnlWdwInfo.Left + TControl(Sender).Left - ZB_XOS;
    newY := y + pnlWdwInfo.Top + TControl(Sender).Top  - ZB_YOS;
    pnlWdwInfo.Left := newX;
    pnlWdwInfo.Top  := newY;
    RepaintBackground; // refresh the full desktop image
  end;
end;
//------------------------------------------------------------------------------
procedure TfrmSnap.pnlWdwInfoTitleMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ZB_fDrag := False;
end;
//------------------------------------------------------------------------------
procedure TfrmSnap.pnlWdwInfoTitleResize(Sender: TObject);
begin
  btnWdwInfoTitle.Left := pnlWdwInfoTitle.Width - btnWdwInfoTitle.Width - 2;
end;
//------------------------------------------------------------------------------
procedure TfrmSnap.btnWdwInfoTitleClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// Handle dragging of the color picker box
//------------------------------------------------------------------------------
procedure TfrmSnap.pnlClopTitleMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ZB_XOS := X;
  ZB_YOS := y;
  if Button = mbLeft then
    ZB_fDrag := True
end;
//------------------------------------------------------------------------------
procedure TfrmSnap.pnlClopTitleMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  newX, newY: Integer;
begin
  if ZB_fDrag = True then
  begin
    newX := x + pnlClop.Left + TControl(Sender).Left - ZB_XOS;
    newY := y + pnlClop.Top + TControl(Sender).Top  - ZB_YOS;
    pnlClop.Left := newX;
    pnlClop.Top  := newY;
    RepaintBackground; // refresh the full desktop image
  end;
end;
//------------------------------------------------------------------------------
procedure TfrmSnap.pnlClopTitleMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ZB_fDrag := False;
end;
//------------------------------------------------------------------------------
// Add the next color to the color picker history
procedure TfrmSnap.AddNewClopColor(X, Y: Integer; clo: TColor);
begin
  if (pnlClopColor01.Color <> Canvas.Pixels[X, Y]) then
  begin
    pnlClopColor10.Color := pnlClopColor09.Color;
    pnlClopColor09.Color := pnlClopColor08.Color;
    pnlClopColor08.Color := pnlClopColor07.Color;
    pnlClopColor07.Color := pnlClopColor06.Color;
    pnlClopColor06.Color := pnlClopColor05.Color;
    pnlClopColor05.Color := pnlClopColor04.Color;
    pnlClopColor04.Color := pnlClopColor03.Color;
    pnlClopColor03.Color := pnlClopColor02.Color;
    pnlClopColor02.Color := pnlClopColor01.Color;
    pnlClopColor01.Color := clo;

    pnlClopColor10.Hint := pnlClopColor09.Hint;
    pnlClopColor09.Hint := pnlClopColor08.Hint;
    pnlClopColor08.Hint := pnlClopColor07.Hint;
    pnlClopColor07.Hint := pnlClopColor06.Hint;
    pnlClopColor06.Hint := pnlClopColor05.Hint;
    pnlClopColor05.Hint := pnlClopColor04.Hint;
    pnlClopColor04.Hint := pnlClopColor03.Hint;
    pnlClopColor03.Hint := pnlClopColor02.Hint;
    pnlClopColor02.Hint := pnlClopColor01.Hint;
    pnlClopColor01.Hint := '(' + IntToStr(X) + ',' + IntToStr(Y) + ')';

    PlayOneSound(sndOK);
  end;
end;
//------------------------------------------------------------------------------
procedure TfrmSnap.pnlClopColorMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  UpdateClopBox(Mouse.CursorPos.x, Mouse.CursorPos.y, TPanel(Sender).Color);
end;
//------------------------------------------------------------------------------
procedure TfrmSnap.pnlClopColorClick(Sender: TObject);
begin
  frmColorInfo.Clo := pnlClopCrrColor.Color;
  frmColorInfo.ShowModal;
  RepaintBackground; // refresh the full desktop image
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

begin
  bmpPreview := TBitmap.Create;
  bmpPreview.Width  := 40;
  bmpPreview.Height := 40;

  facZoomer := 4;
  bmpZoomer := TBitmap.Create;

end.
