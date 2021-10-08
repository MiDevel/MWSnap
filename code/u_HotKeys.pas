unit u_HotKeys;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, ExtCtrls;

const
  rsHotKeyRegError='Not all hotkeys could be registered - check their settings in Tools/Hotkeys!';

const
  DFTKEY_FIXD = 'act=1,ctr=1,alt=0,shf=1,key=F';
  DFTKEY_AREA = 'act=1,ctr=1,alt=0,shf=1,key=A';
  DFTKEY_WIND = 'act=1,ctr=1,alt=0,shf=1,key=W';
  DFTKEY_DESK = 'act=1,ctr=1,alt=0,shf=1,key=D';
  DFTKEY_LAST = 'act=1,ctr=1,alt=0,shf=1,key=L';

  DFTKEY_RULR = 'act=1,ctr=1,alt=1,shf=0,key=R';
  DFTKEY_ZOOM = 'act=1,ctr=1,alt=1,shf=0,key=Z';
  DFTKEY_CLOP = 'act=1,ctr=1,alt=1,shf=0,key=C';
  DFTKEY_INFO = 'act=1,ctr=1,alt=1,shf=0,key=I';

type
  TOneHotkey = class
    m_ctrl, m_alt, m_shift: Boolean;
    m_active, m_success: Boolean;
    m_key: String;
    m_id: Integer; // key will be registered with this id
    function  GetAsString: String;
    procedure SetFromString(sStr: String);
    function  RegisterIt(id: Integer; opt: TMenuItem): Boolean;
    procedure UnRegisterIt;
  end;

  TfrmHotkeys = class(TForm)
    lblRect: TLabel;
    lblArea: TLabel;
    lblWind: TLabel;
    lblDesk: TLabel;
    lblLast: TLabel;
    chkRect_Ctrl: TCheckBox;
    lblAlt: TLabel;
    lblShift: TLabel;
    lblCtrl: TLabel;
    lblKey: TLabel;
    chkRect_Alt: TCheckBox;
    chkRect_Shift: TCheckBox;
    outcmbRect_Key: TComboBox;
    lblActive: TLabel;
    chkRect_Active: TCheckBox;
    chkArea_Ctrl: TCheckBox;
    chkArea_Alt: TCheckBox;
    chkArea_Shift: TCheckBox;
    outcmbArea_Key: TComboBox;
    chkArea_Active: TCheckBox;
    chkWind_Ctrl: TCheckBox;
    chkWind_Alt: TCheckBox;
    chkWind_Shift: TCheckBox;
    outcmbWind_Key: TComboBox;
    chkWind_Active: TCheckBox;
    chkDesk_Ctrl: TCheckBox;
    chkDesk_Alt: TCheckBox;
    chkDesk_Shift: TCheckBox;
    outcmbDesk_Key: TComboBox;
    chkDesk_Active: TCheckBox;
    chkLast_Ctrl: TCheckBox;
    chkLast_Alt: TCheckBox;
    chkLast_Shift: TCheckBox;
    outcmbLast_Key: TComboBox;
    chkLast_Active: TCheckBox;
    btnOk: TButton;
    btnCancel: TButton;
    btnApply: TButton;
    Bevel1: TBevel;
    Bevel2: TBevel;
    btnDefault: TButton;
    btnHelp: TButton;
    Bevel3: TBevel;
    lblRulr: TLabel;
    lblZoom: TLabel;
    lblInfo: TLabel;
    chkRulr_Ctrl: TCheckBox;
    chkRulr_Alt: TCheckBox;
    chkRulr_Shift: TCheckBox;
    outcmbRulr_Key: TComboBox;
    chkRulr_Active: TCheckBox;
    chkZoom_Ctrl: TCheckBox;
    chkZoom_Alt: TCheckBox;
    chkZoom_Shift: TCheckBox;
    outcmbZoom_Key: TComboBox;
    chkZoom_Active: TCheckBox;
    chkInfo_Ctrl: TCheckBox;
    chkInfo_Alt: TCheckBox;
    chkInfo_Shift: TCheckBox;
    outcmbInfo_Key: TComboBox;
    chkInfo_Active: TCheckBox;
    lblClop: TLabel;
    chkClop_Ctrl: TCheckBox;
    chkClop_Alt: TCheckBox;
    chkClop_Shift: TCheckBox;
    outcmbClop_Key: TComboBox;
    chkClop_Active: TCheckBox;
    procedure btnOkClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnDefaultClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private { Private declarations }

  public { Public declarations }

  end;

var
  frmHotkeys: TfrmHotkeys;
  HKFixd, HKArea, HKWind, HKDesk, HKLast: TOneHotkey;
  HKRulr, HKZoom, HKClop, HKInfo: TOneHotkey;

  function  RegisterHotkeys(fWarn: Boolean): Boolean;
  procedure UnRegisterHotkeys;

implementation

uses
  u_Main, u_Snap, uMWTools, uMWStrings, IniLang;

{$R *.DFM}


//------------------------------------------------------------------------------
// Register hotkeys
function RegisterHotkeys(fWarn: Boolean): Boolean;
var
  ok: Boolean;
  okC1, okC2, okC3, okC4, okC5: Boolean;
  okT1, okT2, okT3, okT4: Boolean;
begin
  okC1 := HKFixd.RegisterIt(100 + Ord(SNAP_RECT), frmMain.optCaptureRect);
  okC2 := HKArea.RegisterIt(100 + Ord(SNAP_AREA), frmMain.optCaptureArea);
  okC3 := HKWind.RegisterIt(100 + Ord(SNAP_WIND), frmMain.optCaptureWind);
  okC4 := HKDesk.RegisterIt(100 + Ord(SNAP_DESK), frmMain.optCaptureDesk);
  okC5 := HKLast.RegisterIt(100 + Ord(SNAP_LAST), frmMain.optCaptureLast);

  okT1 := HKRulr.RegisterIt(100 + Ord(SNAP_RULR), frmMain.optRuler);
  okT2 := HKZoom.RegisterIt(100 + Ord(SNAP_ZOOM), frmMain.optZoomer);
  okT3 := HKClop.RegisterIt(100 + Ord(SNAP_CLOP), frmMain.optColorPicker);
  okT4 := HKInfo.RegisterIt(100 + Ord(SNAP_INFO), frmMain.optWdwInfo);

  frmMain.outpopoptCaptureRect.ShortCut := frmMain.optCaptureRect.ShortCut;
  frmMain.outpopoptCaptureArea.ShortCut := frmMain.optCaptureArea.ShortCut;
  frmMain.outpopoptCaptureWind.ShortCut := frmMain.optCaptureWind.ShortCut;
  frmMain.outpopoptCaptureDesk.ShortCut := frmMain.optCaptureDesk.ShortCut;
  frmMain.outpopoptCaptureLast.ShortCut := frmMain.optCaptureLast.ShortCut;

  frmMain.outpopoptRuler.ShortCut := frmMain.optRuler.ShortCut;
  frmMain.outpopoptZoomer.ShortCut := frmMain.optZoomer.ShortCut;
  frmMain.outpopoptColorPicker.ShortCut := frmMain.optColorPicker.ShortCut;
  frmMain.outpopoptWdwInfo.ShortCut := frmMain.optWdwInfo.ShortCut;

  ok := okC1 and okC2 and okC3 and okC4 and okC5 and okT1 and okT2 and okT3 and okT4;
  if not (ok) then
    if (fWarn) then
      frmMain.CstShowMessage(ilMiscStr(rsHotKeyRegError, 'rsHotKeyRegError'));
  RegisterHotkeys := ok;
end;
//------------------------------------------------------------------------------
// Free hotkeys
procedure UnRegisterHotkeys;
begin
  HKFixd.UnRegisterIt;
  HKArea.UnRegisterIt;
  HKWind.UnRegisterIt;
  HKDesk.UnRegisterIt;
  HKLast.UnRegisterIt;

  HKRulr.UnRegisterIt;
  HKZoom.UnRegisterIt;
  HKClop.UnRegisterIt;
  HKInfo.UnRegisterIt;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// TOneHotkey class handling

//------------------------------------------------------------------------------
// Get the hotkey parameters as a string
// Example: act=1,ctr=1,alt=0,shf=1,key=P
function TOneHotkey.GetAsString: String;
var
  sBff: String;
begin
  sBff :=        'act=' + IntToStr(BoolToInt(m_active)) + ',';
  sBff := sBff + 'ctr=' + IntToStr(BoolToInt(m_ctrl))   + ',';
  sBff := sBff + 'alt=' + IntToStr(BoolToInt(m_alt))    + ',';
  sBff := sBff + 'shf=' + IntToStr(BoolToInt(m_shift))  + ',';
  sBff := sBff + 'key=' + m_key;
  GetAsString := sBff;
end;
//------------------------------------------------------------------------------
// Extract the hotkey parameters from a string
procedure TOneHotkey.SetFromString(sStr: String);
begin
  m_active := GetValueStartingWith(sStr, 'act=', ',') <> '0';
  m_ctrl   := GetValueStartingWith(sStr, 'ctr=', ',') <> '0';
  m_alt    := GetValueStartingWith(sStr, 'alt=', ',') <> '0';
  m_shift  := GetValueStartingWith(sStr, 'shf=', ',') <> '0';
  m_key    := GetValueStartingWith(sStr, 'key=', ',');
end;
//------------------------------------------------------------------------------
// Register the hotkey using the passed id
function TOneHotkey.RegisterIt(id: Integer; opt: TMenuItem): Boolean;
var
  flags: Integer;     // used for shortcut registering
  state: TShiftState; // used for the menu option shortcut
  vkey:  Integer;     // virtual key code
begin
  m_success := True; // success
  flags := 0;
  state := [];
  vkey  := 0;
  m_id  := id;
  if m_active then
  begin
    if Length(m_key) > 0 then
    begin
      if Length(m_key) = 1 then
        vkey := Ord(m_key[1])
      else
      begin
             if m_key = 'F1'  then vkey := VK_F1
        else if m_key = 'F2'  then vkey := VK_F2
        else if m_key = 'F3'  then vkey := VK_F3
        else if m_key = 'F4'  then vkey := VK_F4
        else if m_key = 'F5'  then vkey := VK_F5
        else if m_key = 'F6'  then vkey := VK_F6
        else if m_key = 'F7'  then vkey := VK_F7
        else if m_key = 'F8'  then vkey := VK_F8
        else if m_key = 'F9'  then vkey := VK_F9
        else if m_key = 'F10' then vkey := VK_F10
        else if m_key = 'F11' then vkey := VK_F11
        else if m_key = 'F12' then vkey := VK_F12
//        else if m_key = 'Print' then vkey := VK_PRINT;
      end;
    end;
    if m_ctrl  then begin Inc(flags, MOD_CONTROL); state := state + [ssCtrl]; end;
    if m_alt   then begin Inc(flags, MOD_ALT); state := state + [ssAlt]; end;
    if m_shift then begin Inc(flags, MOD_SHIFT); state := state + [ssShift]; end;
    m_success := RegisterHotKey(frmMain.Handle, id, flags, vkey);

    if m_success then
      opt.ShortCut := ShortCut(vkey, state)
    else
      opt.ShortCut := 0;
  end
  else
  begin
    opt.ShortCut := 0;
  end;

  RegisterIt := m_success;
end;
//------------------------------------------------------------------------------
// Unregister the hotkey using the passed id
procedure TOneHotkey.UnRegisterIt;
begin
  UnRegisterHotKey(frmMain.Handle, m_id);
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// Form handling
//
//------------------------------------------------------------------------------
// First-time initialization
procedure TfrmHotkeys.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  outcmbRect_Key.Clear;
  outcmbArea_Key.Clear;
  outcmbWind_Key.Clear;
  outcmbDesk_Key.Clear;
  outcmbLast_Key.Clear;
  for i := Ord('A') to Ord('Z') do
  begin
    outcmbRect_Key.Items.Add(Chr(i));
    outcmbArea_Key.Items.Add(Chr(i));
    outcmbWind_Key.Items.Add(Chr(i));
    outcmbDesk_Key.Items.Add(Chr(i));
    outcmbLast_Key.Items.Add(Chr(i));
  end;
  for i := Ord('0') to Ord('9') do
  begin
    outcmbRect_Key.Items.Add(Chr(i));
    outcmbArea_Key.Items.Add(Chr(i));
    outcmbWind_Key.Items.Add(Chr(i));
    outcmbDesk_Key.Items.Add(Chr(i));
    outcmbLast_Key.Items.Add(Chr(i));
  end;
  for i := 1 to 12 do
  begin
    outcmbRect_Key.Items.Add('F' + IntToStr(i));
    outcmbArea_Key.Items.Add('F' + IntToStr(i));
    outcmbWind_Key.Items.Add('F' + IntToStr(i));
    outcmbDesk_Key.Items.Add('F' + IntToStr(i));
    outcmbLast_Key.Items.Add('F' + IntToStr(i));
  end;
//  outcmbRect_Key.Items.Add('Print');
//  outcmbArea_Key.Items.Add('Print');
//  outcmbWind_Key.Items.Add('Print');
//  outcmbDesk_Key.Items.Add('Print');
//  outcmbLast_Key.Items.Add('Print');

  frmMain.ReadWindowPosition(self, False);
end;
//------------------------------------------------------------------------------
procedure TfrmHotkeys.FormDestroy(Sender: TObject);
begin
  frmMain.SaveWindowPosition(self, False);
end;
//------------------------------------------------------------------------------
procedure TfrmHotkeys.FormActivate(Sender: TObject);
begin
  with HKFixd do
  begin
    chkRect_Ctrl.Checked   := m_ctrl;
    chkRect_Alt.Checked    := m_alt;
    chkRect_Shift.Checked  := m_shift;
    outcmbRect_Key.Text    := m_key;
    chkRect_Active.Checked := m_active;
    if m_success then
      lblRect.Font.Color := clBlack
    else
      lblRect.Font.Color := clRed;
  end;

  with HKArea do
  begin
    chkArea_Ctrl.Checked   := m_ctrl;
    chkArea_Alt.Checked    := m_alt;
    chkArea_Shift.Checked  := m_shift;
    outcmbArea_Key.Text    := m_key;
    chkArea_Active.Checked := m_active;
    if m_success then
      lblArea.Font.Color := clBlack
    else
      lblArea.Font.Color := clRed;
  end;

  with HKWind do
  begin
    chkWind_Ctrl.Checked   := m_ctrl;
    chkWind_Alt.Checked    := m_alt;
    chkWind_Shift.Checked  := m_shift;
    outcmbWind_Key.Text    := m_key;
    chkWind_Active.Checked := m_active;
    if m_success then
      lblWind.Font.Color := clBlack
    else
      lblWind.Font.Color := clRed;
  end;

  with HKDesk do
  begin
    chkDesk_Ctrl.Checked   := m_ctrl;
    chkDesk_Alt.Checked    := m_alt;
    chkDesk_Shift.Checked  := m_shift;
    outcmbDesk_Key.Text    := m_key;
    chkDesk_Active.Checked := m_active;
    if m_success then
      lblDesk.Font.Color := clBlack
    else
      lblDesk.Font.Color := clRed;
  end;

  with HKLast do
  begin
    chkLast_Ctrl.Checked   := m_ctrl;
    chkLast_Alt.Checked    := m_alt;
    chkLast_Shift.Checked  := m_shift;
    outcmbLast_Key.Text    := m_key;
    chkLast_Active.Checked := m_active;
    if m_success then
      lblLast.Font.Color := clBlack
    else
      lblLast.Font.Color := clRed;
  end;

  with HKRulr do
  begin
    chkRulr_Ctrl.Checked   := m_ctrl;
    chkRulr_Alt.Checked    := m_alt;
    chkRulr_Shift.Checked  := m_shift;
    outcmbRulr_Key.Text    := m_key;
    chkRulr_Active.Checked := m_active;
    if m_success then
      lblRulr.Font.Color := clBlack
    else
      lblRulr.Font.Color := clRed;
  end;

  with HKZoom do
  begin
    chkZoom_Ctrl.Checked   := m_ctrl;
    chkZoom_Alt.Checked    := m_alt;
    chkZoom_Shift.Checked  := m_shift;
    outcmbZoom_Key.Text    := m_key;
    chkZoom_Active.Checked := m_active;
    if m_success then
      lblZoom.Font.Color := clBlack
    else
      lblZoom.Font.Color := clRed;
  end;

  with HKClop do
  begin
    chkClop_Ctrl.Checked   := m_ctrl;
    chkClop_Alt.Checked    := m_alt;
    chkClop_Shift.Checked  := m_shift;
    outcmbClop_Key.Text    := m_key;
    chkClop_Active.Checked := m_active;
    if m_success then
      lblClop.Font.Color := clBlack
    else
      lblClop.Font.Color := clRed;
  end;

  with HKInfo do
  begin
    chkInfo_Ctrl.Checked   := m_ctrl;
    chkInfo_Alt.Checked    := m_alt;
    chkInfo_Shift.Checked  := m_shift;
    outcmbInfo_Key.Text    := m_key;
    chkInfo_Active.Checked := m_active;
    if m_success then
      lblInfo.Font.Color := clBlack
    else
      lblInfo.Font.Color := clRed;
  end;

end;
//------------------------------------------------------------------------------
procedure TfrmHotkeys.btnOkClick(Sender: TObject);
begin
  btnApplyClick(Nil);
end;
//------------------------------------------------------------------------------
procedure TfrmHotkeys.btnDefaultClick(Sender: TObject);
begin
  HKFixd.SetFromString(DFTKEY_FIXD);
  HKArea.SetFromString(DFTKEY_AREA);
  HKWind.SetFromString(DFTKEY_WIND);
  HKDesk.SetFromString(DFTKEY_DESK);
  HKLast.SetFromString(DFTKEY_LAST);

  HKRulr.SetFromString(DFTKEY_RULR);
  HKZoom.SetFromString(DFTKEY_ZOOM);
  HKClop.SetFromString(DFTKEY_CLOP);
  HKInfo.SetFromString(DFTKEY_INFO);

  FormActivate(Nil);
end;
//------------------------------------------------------------------------------
procedure TfrmHotkeys.btnApplyClick(Sender: TObject);
begin
  with HKFixd do
  begin
    m_ctrl   := chkRect_Ctrl.Checked;
    m_alt    := chkRect_Alt.Checked;
    m_shift  := chkRect_Shift.Checked;
    m_key    := outcmbRect_Key.Text;
    m_active := chkRect_Active.Checked;
  end;

  with HKArea do
  begin
    m_ctrl   := chkArea_Ctrl.Checked;
    m_alt    := chkArea_Alt.Checked;
    m_shift  := chkArea_Shift.Checked;
    m_key    := outcmbArea_Key.Text;
    m_active := chkArea_Active.Checked;
  end;

  with HKWind do
  begin
    m_ctrl   := chkWind_Ctrl.Checked;
    m_alt    := chkWind_Alt.Checked;
    m_shift  := chkWind_Shift.Checked;
    m_key    := outcmbWind_Key.Text;
    m_active := chkWind_Active.Checked;
  end;

  with HKDesk do
  begin
    m_ctrl   := chkDesk_Ctrl.Checked;
    m_alt    := chkDesk_Alt.Checked;
    m_shift  := chkDesk_Shift.Checked;
    m_key    := outcmbDesk_Key.Text;
    m_active := chkDesk_Active.Checked;
  end;

  with HKLast do
  begin
    m_ctrl   := chkLast_Ctrl.Checked;
    m_alt    := chkLast_Alt.Checked;
    m_shift  := chkLast_Shift.Checked;
    m_key    := outcmbLast_Key.Text;
    m_active := chkLast_Active.Checked;
  end;

  with HKRulr do
  begin
    m_ctrl   := chkRulr_Ctrl.Checked;
    m_alt    := chkRulr_Alt.Checked;
    m_shift  := chkRulr_Shift.Checked;
    m_key    := outcmbRulr_Key.Text;
    m_active := chkRulr_Active.Checked;
  end;

  with HKZoom do
  begin
    m_ctrl   := chkZoom_Ctrl.Checked;
    m_alt    := chkZoom_Alt.Checked;
    m_shift  := chkZoom_Shift.Checked;
    m_key    := outcmbZoom_Key.Text;
    m_active := chkZoom_Active.Checked;
  end;

  with HKClop do
  begin
    m_ctrl   := chkClop_Ctrl.Checked;
    m_alt    := chkClop_Alt.Checked;
    m_shift  := chkClop_Shift.Checked;
    m_key    := outcmbClop_Key.Text;
    m_active := chkClop_Active.Checked;
  end;

  with HKInfo do
  begin
    m_ctrl   := chkInfo_Ctrl.Checked;
    m_alt    := chkInfo_Alt.Checked;
    m_shift  := chkInfo_Shift.Checked;
    m_key    := outcmbInfo_Key.Text;
    m_active := chkInfo_Active.Checked;
  end;

  UnRegisterHotkeys;
  RegisterHotkeys(True);
  FormActivate(Nil);
end;
//------------------------------------------------------------------------------
// Show help on printing
procedure TfrmHotkeys.btnHelpClick(Sender: TObject);
begin
  frmMain.ShowHelpPage('dlghotkey.htm', Handle);
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

begin
  // Create hotkeys variables
  HKFixd := TOneHotkey.Create;
  HKArea := TOneHotkey.Create;
  HKWind := TOneHotkey.Create;
  HKDesk := TOneHotkey.Create;
  HKLast := TOneHotkey.Create;

  HKRulr := TOneHotkey.Create;
  HKZoom := TOneHotkey.Create;
  HKClop := TOneHotkey.Create;
  HKInfo := TOneHotkey.Create;
end.
