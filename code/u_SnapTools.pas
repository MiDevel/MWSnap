unit u_SnapTools;

interface

uses
  Windows, Forms, Classes;

  procedure FormStayOnTop(frm: Tform; bOnTop: Boolean);

//------------------------------------------------------------------------------
type
  PFindWindowStruct = ^TFindWindowStruct;
  TFindWindowStruct = record
    windowHandle: THandle;
    rect: TRect;
  end;

  TWndClass = class
    rect: TRect;
    hWindow: hWnd;
  end;

//------------------------------------------------------------------------------
var
  WindowInfo: TFindWindowStruct;
  WndList: TList;

procedure EnumAllWindows;
function  FindWindow(pos: TPoint; var theRect: TRect): THandle;

implementation


//------------------------------------------------------------------------------
function EnumWindowsProc(hWindow: hWnd; lParam: LongInt): Bool stdcall;
var
  rect: TRect;
  oneWind: TWndClass;
begin
   Result := True;

   if IsWindowVisible(hWindow) then
   try
     GetWindowRect(hWindow, rect);
     oneWind := TWndClass.Create;
     oneWind.rect := rect;
     oneWind.hWindow := hWindow;
     EnumChildWindows(hWindow, @EnumWindowsProc, 0); // first append child windows
     WndList.Add(oneWind); // next the main window
   finally
     ;
   end;
end;
//------------------------------------------------------------------------------
procedure EnumAllWindows;
var
  tmpObj: TWndClass;
begin
  while WndList.Count > 0 do
  begin
    tmpObj := WndList[0];
    tmpObj.Destroy;
    WndList.Delete(0);
  end;
  EnumWindows(@EnumWindowsProc, LongInt(@WindowInfo));
end;
//------------------------------------------------------------------------------
function FindWindow(pos: TPoint; var theRect: TRect): THandle;
var
  i: Integer;
  tmpObj: TWndClass;
begin
  FindWindow := 0;
  for i := 0 to WndList.Count - 1 do
  begin
    tmpObj := WndList[i];
    with tmpObj do
      if (pos.x >= rect.Left) and (pos.x <= rect.Right)  and
         (pos.y >= rect.Top)  and (pos.y <= rect.Bottom) then
      begin
        theRect := rect;
        FindWindow := hWindow;
        Exit;
      end;
  end;
end;
//------------------------------------------------------------------------------
Const
  Swp_Nosize:integer = $1;
  SWP_Nomove:integer = $2;
  Swp_NoActivate:integer = $10;
  Swp_ShowWindow :integer= $40;
//------------------------------------------------------------------------------
procedure FormStayOnTop(frm: Tform; bOnTop: boolean);
var
  PosFlag: Hwnd;
  wFlags: integer;
begin
  wFlags:= SWP_Nomove Or Swp_Nosize Or Swp_ShowWindow Or Swp_NoActivate;
  if bOnTop then
    PosFlag := HWND_TOPMOST //Hwnd_TopMost
  else
    PosFlag := HWND_NOTOPMOST; //Hwnd_NoTopMost;
  SetWindowPos(frm.handle, PosFlag, 0, 0, 0, 0, wFlags);
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

begin
  WndList := TList.Create;
end.
