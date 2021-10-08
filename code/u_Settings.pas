unit u_Settings;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, Buttons, BrowseFolder;

resourcestring
  rsEnterNewSize='Enter a new size, width x height, e.g., 60x40:';
  rsErrorColorDialog='Color selection dialog failed to load';
  rsSoundOK='Delicate confirmations';
  rsSoundError='Errors and warnings';
  rsSoundSnap='Snapping done';
  rsSoundSave='Saving done';
  rsSoundClipCopy='Copy to the clipboard';
  rsSoundClipPaste='Paste from the clipboard';
  rsSoundFiles='Sound files';
  rsSelectAutosaveFolder='Select folder for auto-saved images';
  rsDateTime_yyyy ='Displays the year as a four-digit number (0000-9999)';
  rsDateTime_yy   ='Displays the year as a two-digit number (00-99)';
  rsDateTime_mm   ='Displays the month as a number with a leading zero (01-12)';
  rsDateTime_m    ='Displays the month as a number without a leading zero (1-12)';
  rsDateTime_dd   ='Displays the day as a number with a leading zero (01-31)';
  rsDateTime_d    ='Displays the day as a number without a leading zero (1-31)';
  rsDateTime_hh   ='Displays the hour with a leading zero (00-23)';
  rsDateTime_h    ='Displays the hour without a leading zero (0-23)';
  rsDateTime_nn   ='Displays the minute with a leading zero (00-59)';
  rsDateTime_n    ='Displays the minute without a leading zero (0-59)';
  rsDateTime_ss   ='Displays the second with a leading zero (00-59)';
  rsDateTime_s    ='Displays the second without a leading zero (0-59)';
  rsDateTime_am_pm='Uses the 12-hour clock for the preceding h or hh specifier, and displays "am" for any hour before noon, and "pm" for any hour after noon';
  rsDateTime_Legend='The following symbols can appear within the format template:';
  rsDateTime_Sample='Your current template expands to';

type
  TfrmSettings = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    btnApply: TButton;
    tabOptions: TPageControl;
    tabGeneral: TTabSheet;
    tabSnapping: TTabSheet;
    dlgClo: TColorDialog;
    tabAutoSave: TTabSheet;
    tabSizes: TTabSheet;
    dlgBrowseFolder: TBrowseFolder;
    tabAppearance: TTabSheet;
    GroupBox1: TGroupBox;
    lblCloBack: TLabel;
    lblCloRuler: TLabel;
    pnlCloBkg: TPanel;
    pnlCloRuler: TPanel;
    GroupBox2: TGroupBox;
    lblSavePath: TLabel;
    outbtnPickAutoSaveFolder: TSpeedButton;
    lblAutoSaveNumFrom: TLabel;
    lblAutoSaveNumTo: TLabel;
    chkAutoSaveActive: TCheckBox;
    fldAutoSaveFolder: TEdit;
    rdiAutoSaveNamePrompt: TRadioButton;
    rdiAutoSaveNameFixed: TRadioButton;
    fldAutoSaveName: TEdit;
    chkAutoSaveAddSuffix: TCheckBox;
    fldAutoSaveNumFrom: TEdit;
    fldAutoSaveNumTo: TEdit;
    spnAutoSaveNumFrom: TUpDown;
    spnAutoSaveNumTo: TUpDown;
    GroupBox3: TGroupBox;
    lblDelay: TLabel;
    lblDelayHint: TLabel;
    fldDelay: TEdit;
    spnDelay: TUpDown;
    chkHidePgm: TCheckBox;
    chkAutoCopy: TCheckBox;
    GroupBox4: TGroupBox;
    chkWarnKeys: TCheckBox;
    chkStartMinimized: TCheckBox;
    chkAutostart: TCheckBox;
    chkUseTray: TCheckBox;
    chkMarkCrsPos: TCheckBox;
    lblFormat: TLabel;
    outlisAutoSaveFormat: TComboBox;
    btnHelp: TButton;
    tabSounds: TTabSheet;
    GroupBox5: TGroupBox;
    lisSounds: TListBox;
    chkSoundOn: TCheckBox;
    chkOneSoundActive: TCheckBox;
    rdiSoundBuiltIn: TRadioButton;
    rdiSoundWaveFile: TRadioButton;
    fldSoundWavePath: TEdit;
    outcmdSoundWavePath: TSpeedButton;
    btnSoundTest: TButton;
    btnSoundSave: TButton;
    dlgOpen: TOpenDialog;
    chkShowPreviewBox: TCheckBox;
    chkAskOverwrite: TCheckBox;
    chkAutoPrintActive: TCheckBox;
    chkAutoSaveAddDate: TCheckBox;
    lblAutoSaveDateFormat: TLabel;
    fldAutoSaveDateFormat: TEdit;
    outbtnAutoSaveDateFormatHelp: TButton;
    GroupBox6: TGroupBox;
    btnfs_add: TButton;
    btnfs_del: TButton;
    btnfs_up: TButton;
    btnfs_dn: TButton;
    btnfs_def: TButton;
    lis_fixSiz: TListBox;
    lblUndoCount: TLabel;
    fldMaxUndoCount: TEdit;
    spnMaxUndoCount: TUpDown;
    lblBackStyle: TLabel;
    pnlBackStyle1: TScrollBox;
    pnlBackStyle2: TScrollBox;
    pnlBackStyle3: TScrollBox;
    pnlBackStyle4: TScrollBox;
    pnlBackStyle5: TScrollBox;
    pnlBackStyle7: TScrollBox;
    pnlBackStyle6: TScrollBox;
    rdiBackStyle1: TRadioButton;
    rdiBackStyle2: TRadioButton;
    rdiBackStyle3: TRadioButton;
    rdiBackStyle4: TRadioButton;
    rdiBackStyle5: TRadioButton;
    rdiBackStyle6: TRadioButton;
    rdiBackStyle7: TRadioButton;
    chkRestPgm: TCheckBox;
    chkAlwaysInTray: TCheckBox;
    imgIcon: TImage;
    chkCloseMinimizes: TCheckBox;
    procedure btnOkClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnfs_addClick(Sender: TObject);
    procedure btnfs_delClick(Sender: TObject);
    procedure btnfs_upClick(Sender: TObject);
    procedure btnfs_dnClick(Sender: TObject);
    procedure btnfs_defClick(Sender: TObject);
    procedure lis_fixSizClick(Sender: TObject);
    procedure pnlCloBkgClick(Sender: TObject);
    procedure pnlCloRulerClick(Sender: TObject);
    procedure outbtnPickAutoSaveFolderClick(Sender: TObject);
    procedure rdiAutoSaveNameClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure lisSoundsClick(Sender: TObject);
    procedure lisSoundsDblClick(Sender: TObject);
    procedure btnSoundTestClick(Sender: TObject);
    procedure btnSoundSaveClick(Sender: TObject);
    procedure outcmdSoundWavePathClick(Sender: TObject);
    procedure outbtnAutoSaveDateFormatHelpClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure pnlBackStyleClick(Sender: TObject);
    procedure chkUseTrayClick(Sender: TObject);

  private { Private declarations }
    procedure UpdateUI;

  public { Public declarations }
  end;

var
  frmSettings: TfrmSettings;

implementation

uses
  u_Main, uMWStrings, IniLang, u_Sounds, u_Undo;

{$R *.DFM}

//------------------------------------------------------------------------------
// Save / restore the dialog position
procedure TfrmSettings.FormCreate(Sender: TObject);
begin
  frmMain.ReadWindowPosition(self, False);
end;
procedure TfrmSettings.FormDestroy(Sender: TObject);
begin
  frmMain.SaveWindowPosition(self, False);
end;
//------------------------------------------------------------------------------
procedure TfrmSettings.FormActivate(Sender: TObject);
var
  i: Integer;
  iSnd: TSounds;
begin
  imgIcon.Picture.Assign(Icon);

  // General
  chkWarnKeys.Checked        := frmMain.WarnKeys;
  chkAutostart.Checked       := frmMain.Autostart;
  chkUseTray.Checked         := frmMain.MinimizeToTray;
  chkAlwaysInTray.Checked    := frmMain.AlwaysInTray;
  chkStartMinimized.Checked  := frmMain.StartMinimized;
  chkCloseMinimizes.Checked  := frmMain.CloseMinimizes;
  chkAskOverwrite.Checked    := frmMain.AskOverwrite;
  spnMaxUndoCount.Position   := GlbUndo.MaxSteps;

  // Snapping
  spnDelay.Position          := frmMain.DelayTime;
  chkHidePgm.Checked         := frmMain.SnapHidePgm;
  chkRestPgm.Checked         := frmMain.SnapRestPgm;
  chkAutoCopy.Checked        := frmMain.AutoCopy;
  chkShowPreviewBox.Checked  := frmMain.ShowPreviewBox;
  chkMarkCrsPos.Checked      := frmMain.MarkCrsPos;
  chkAutoPrintActive.Checked := frmMain.AutoPrintActive;

  // Appearance
  pnlCloBkg.Color            := frmMain.CloBkg;
  pnlCloRuler.Color          := frmMain.CloRuler;
  case frmMain.BkgStyle of
    2: rdiBackStyle2.Checked := True;
    3: rdiBackStyle3.Checked := True;
    4: rdiBackStyle4.Checked := True;
    5: rdiBackStyle5.Checked := True;
    6: rdiBackStyle6.Checked := True;
    7: rdiBackStyle7.Checked := True;
  else
       rdiBackStyle1.Checked := True;
  end;

  // Auto-save
  fldAutoSaveFolder.Text        := frmMain.AutoSaveFolder;
  fldAutoSaveName.Text          := frmMain.AutoSaveName;
  if frmMain.AutoSaveNamePrompt then
    rdiAutoSaveNamePrompt.Checked := True
  else
    rdiAutoSaveNameFixed.Checked := True;
  chkAutoSaveAddSuffix.Checked  := frmMain.AutoSaveAddSuffix;
  spnAutoSaveNumFrom.Position   := frmMain.AutoSaveNumFrom;
  spnAutoSaveNumTo.Position     := frmMain.AutoSaveNumTo;
  chkAutoSaveAddDate.Checked    := frmMain.AutoSaveAddDate;
  fldAutoSaveDateFormat.Text    := frmMain.AutoSaveDateFormat;
  chkAutoSaveActive.Checked     := frmMain.AutoSaveActive;
  rdiAutoSaveNameClick(Nil); // update auto-save interface
  if frmMain.AutoSaveFormat = 'bmp' then
    outlisAutoSaveFormat.ItemIndex := 0
  else if frmMain.AutoSaveFormat = 'jpeg' then
    outlisAutoSaveFormat.ItemIndex := 1
  else if frmMain.AutoSaveFormat = 'gif' then
    outlisAutoSaveFormat.ItemIndex := 2
  else if frmMain.AutoSaveFormat = 'png' then
    outlisAutoSaveFormat.ItemIndex := 3
  else if frmMain.AutoSaveFormat = 'tiff' then
    outlisAutoSaveFormat.ItemIndex := 4
  else
    outlisAutoSaveFormat.ItemIndex := 0;

  // Fixed sizes
  lis_fixSiz.Clear;
  for i := 0 to frmMain.RectSizes.Count - 1 do
  begin
    lis_fixSiz.Items.Add(frmMain.RectSizes.Strings[i]);
  end;
  if lis_fixSiz.Items.Count > 0 then
    lis_fixSiz.ItemIndex := 0;
  lis_fixSizClick(Nil); // update buttons activity

  // Sounds
  chkSoundOn.Checked := frmMain.SoundOn;
  lisSounds.Clear;
  lisSounds.Items.Add(ilMiscStr(rsSoundOK, 'rsSoundOk'));
  lisSounds.Items.Add(ilMiscStr(rsSoundError, 'rsSoundError'));
  lisSounds.Items.Add(ilMiscStr(rsSoundSnap , 'rsSoundSnap'));
  lisSounds.Items.Add(ilMiscStr(rsSoundSave , 'rsSoundSave'));
  lisSounds.Items.Add(ilMiscStr(rsSoundClipCopy , 'rsSoundClipCopy'));
  lisSounds.Items.Add(ilMiscStr(rsSoundClipPaste , 'rsSoundClipPaste'));
  lisSounds.ItemIndex := 0;
  for iSnd := sndNONE to LastSound do
  begin
    TmpSoundsAry[iSnd].Sound       := SoundsAry[iSnd].Sound;
    TmpSoundsAry[iSnd].Active      := SoundsAry[iSnd].Active;
    TmpSoundsAry[iSnd].UseInternal := SoundsAry[iSnd].UseInternal;
    TmpSoundsAry[iSnd].Path        := SoundsAry[iSnd].Path;
  end;

  lisSoundsClick(nil);
  UpdateUI;
end;
//------------------------------------------------------------------------------
procedure TfrmSettings.btnOkClick(Sender: TObject);
begin
  btnApplyClick(Nil);
end;
//------------------------------------------------------------------------------
procedure TfrmSettings.btnApplyClick(Sender: TObject);
var
  i: Integer;
  iSnd: TSounds;
begin
  // General
  frmMain.WarnKeys        := chkWarnKeys.Checked;
  frmMain.Autostart       := chkAutostart.Checked;
  frmMain.StartMinimized  := chkStartMinimized.Checked;
  frmMain.CloseMinimizes  := chkCloseMinimizes.Checked;
  frmMain.MinimizeToTray  := chkUseTray.Checked;
  frmMain.AlwaysInTray    := chkAlwaysInTray.Checked;
  frmMain.AskOverwrite    := chkAskOverwrite.Checked;
  GlbUndo.MaxSteps        := spnMaxUndoCount.Position;

  // Snapping
  frmMain.DelayTime       := spnDelay.Position;
  frmMain.SnapHidePgm     := chkHidePgm.Checked;
  frmMain.SnapRestPgm     := chkRestPgm.Checked;
  frmMain.AutoCopy        := chkAutoCopy.Checked;
  frmMain.ShowPreviewBox  := chkShowPreviewBox.Checked;
  frmMain.MarkCrsPos      := chkMarkCrsPos.Checked;
  frmMain.AutoPrintActive := chkAutoPrintActive.Checked;

  // Appearance
  frmMain.CloBkg          := pnlCloBkg.Color;
  frmMain.CloRuler        := pnlCloRuler.Color;
       if (rdiBackStyle2.Checked) then frmMain.BkgStyle := 2
  else if (rdiBackStyle3.Checked) then frmMain.BkgStyle := 3
  else if (rdiBackStyle4.Checked) then frmMain.BkgStyle := 4
  else if (rdiBackStyle5.Checked) then frmMain.BkgStyle := 5
  else if (rdiBackStyle6.Checked) then frmMain.BkgStyle := 6
  else if (rdiBackStyle7.Checked) then frmMain.BkgStyle := 7
  else                                 frmMain.BkgStyle := 1;

  // Auto-save
  frmMain.AutoSaveFolder      := fldAutoSaveFolder.Text;
  frmMain.AutoSaveName        := fldAutoSaveName.Text;
  frmMain.AutoSaveNamePrompt  := rdiAutoSaveNamePrompt.Checked;
  frmMain.AutoSaveAddSuffix   := chkAutoSaveAddSuffix.Checked;
  frmMain.AutoSaveNumFrom     := spnAutoSaveNumFrom.Position;
  frmMain.AutoSaveNumTo       := spnAutoSaveNumTo.Position;
  frmMain.AutoSaveAddDate     := chkAutoSaveAddDate.Checked;
  frmMain.AutoSaveDateFormat  := fldAutoSaveDateFormat.Text;
  frmMain.AutoSaveActive      := chkAutoSaveActive.Checked;
  case outlisAutoSaveFormat.ItemIndex of
    0: frmMain.AutoSaveFormat := 'bmp';
    1: frmMain.AutoSaveFormat := 'jpeg';
    2: frmMain.AutoSaveFormat := 'gif';
    3: frmMain.AutoSaveFormat := 'png';
    4: frmMain.AutoSaveFormat := 'tiff';
  end;

  // Fixed sizes
  frmMain.RectSizes.Clear;
  for i := 0 to lis_fixSiz.Items.Count - 1 do
  begin
    frmMain.RectSizes.Add(lis_fixSiz.Items[i]);
  end;

  // Sounds
  frmMain.SoundOn := chkSoundOn.Checked;
  for iSnd := sndNONE to LastSound do
  begin
    SoundsAry[iSnd].Active      := TmpSoundsAry[iSnd].Active;
    SoundsAry[iSnd].UseInternal := TmpSoundsAry[iSnd].UseInternal;
    SoundsAry[iSnd].Path        := TmpSoundsAry[iSnd].Path;
  end;

  frmMain.UpdateUI;
end;
//------------------------------------------------------------------------------
procedure TfrmSettings.chkUseTrayClick(Sender: TObject);
begin
  UpdateUI;
end;
//------------------------------------------------------------------------------
procedure TfrmSettings.UpdateUI;
begin
  pnlBackStyle1.Color := pnlCloBkg.Color;
  pnlBackStyle2.Color := pnlCloBkg.Color;
  pnlBackStyle3.Color := pnlCloBkg.Color;
  pnlBackStyle4.Color := pnlCloBkg.Color;
  pnlBackStyle5.Color := pnlCloBkg.Color;
  pnlBackStyle6.Color := pnlCloBkg.Color;
  pnlBackStyle7.Color := pnlCloBkg.Color;

  pnlBackStyle1.Brush.Style := bsSolid;
  pnlBackStyle2.Brush.Style := bsHorizontal;
  pnlBackStyle3.Brush.Style := bsVertical;
  pnlBackStyle4.Brush.Style := bsFDiagonal;
  pnlBackStyle5.Brush.Style := bsBDiagonal;
  pnlBackStyle6.Brush.Style := bsCross;
  pnlBackStyle7.Brush.Style := bsDiagCross;

  chkStartMinimized.Enabled := chkUseTray.Checked;
  if not chkUseTray.Checked then
    chkStartMinimized.Checked := False;
end;
//------------------------------------------------------------------------------
procedure TfrmSettings.pnlBackStyleClick(Sender: TObject);
begin
  case TControl(Sender).Tag of
    1: rdiBackStyle1.Checked := True;
    2: rdiBackStyle2.Checked := True;
    3: rdiBackStyle3.Checked := True;
    4: rdiBackStyle4.Checked := True;
    5: rdiBackStyle5.Checked := True;
    6: rdiBackStyle6.Checked := True;
    7: rdiBackStyle7.Checked := True;
  end;
end;
//------------------------------------------------------------------------------
// Fixed sizes handling
procedure TfrmSettings.lis_fixSizClick(Sender: TObject);
var
  idx: Integer;
begin
  idx := lis_fixSiz.ItemIndex;
  btnfs_up.Enabled := idx > 0;
  btnfs_dn.Enabled := (idx >= 0) and (idx < lis_fixSiz.Items.Count-1);
  btnfs_del.Enabled := idx >= 0;
end;
//------------------------------------------------------------------------------
// Add a new fixed size
procedure TfrmSettings.btnfs_addClick(Sender: TObject);
var
  sBff: String;
  dx, dy: Integer;
begin
  if InputQuery('', ilMiscStr(rsEnterNewSize, 'rsEnterNewSize'), sBff) then
  begin
    SplitSizeString(sBff, dx, dy);
    if (dx > 0) and (dy > 0) then
    begin
      sBff := IntToStr(dx) + 'x' + IntToStr(dy);
      if lis_fixSiz.Items.IndexOf(sBff) < 0 then
        lis_fixSiz.Items.Add(sBff);
      // activate the new item
      lis_fixSiz.ItemIndex := lis_fixSiz.Items.IndexOf(sBff);
    end;
  end;
  lis_fixSizClick(Nil); // update buttons activity
end;
//------------------------------------------------------------------------------
// Delete current fixed size
procedure TfrmSettings.btnfs_delClick(Sender: TObject);
begin
  if lis_fixSiz.ItemIndex >= 0 then
    lis_fixSiz.Items.Delete(lis_fixSiz.ItemIndex);
  lis_fixSizClick(Nil); // update buttons activity
end;
//------------------------------------------------------------------------------
// Move the item up
procedure TfrmSettings.btnfs_upClick(Sender: TObject);
var
  idx: Integer;
begin
  idx := lis_fixSiz.ItemIndex;
  if idx > 0 then
  begin
    lis_fixSiz.Items.Move(idx, idx-1);
    lis_fixSiz.ItemIndex := idx-1;
  end;
  lis_fixSizClick(Nil); // update buttons activity
end;
//------------------------------------------------------------------------------
// Move the item down
procedure TfrmSettings.btnfs_dnClick(Sender: TObject);
var
  idx: Integer;
begin
  idx := lis_fixSiz.ItemIndex;
  if (idx >= 0) and (idx < lis_fixSiz.Items.Count-1) then
  begin
    lis_fixSiz.Items.Move(idx, idx+1);
    lis_fixSiz.ItemIndex := idx+1;
  end;
  lis_fixSizClick(Nil); // update buttons activity
end;
//------------------------------------------------------------------------------
// Restore default items
procedure TfrmSettings.btnfs_defClick(Sender: TObject);
begin
  with lis_fixSiz do
  begin
    Clear;
    Items.Add('16x16');
    Items.Add('32x32');
    Items.Add('48x48');
    Items.Add('64x64');
    Items.Add('96x72');
    ItemIndex := 0;
  end;
  lis_fixSizClick(Nil); // update buttons activity
end;
//------------------------------------------------------------------------------
// Customize the background color
procedure TfrmSettings.pnlCloBkgClick(Sender: TObject);
begin
  try
    dlgClo.Color := pnlCloBkg.Color;
    if dlgClo.Execute then
    begin
      pnlCloBkg.Color := dlgClo.Color;
    end;
  except
    frmMain.CstShowMessage(ilMiscStr(rsErrorColorDialog, 'rsErrorColorDialog'));
  end;
  UpdateUI;
end;
//------------------------------------------------------------------------------
// Customize the ruler color
procedure TfrmSettings.pnlCloRulerClick(Sender: TObject);
begin
  try
    dlgClo.Color := pnlCloRuler.Color;
    if dlgClo.Execute then
    begin
      pnlCloRuler.Color := dlgClo.Color;
    end;
  except
    frmMain.CstShowMessage(ilMiscStr(rsErrorColorDialog, 'rsErrorColorDialog'));
  end;
end;
//------------------------------------------------------------------------------
// Select a default folder for auto-saved images
procedure TfrmSettings.outbtnPickAutoSaveFolderClick(Sender: TObject);
begin
  dlgBrowseFolder.Directory := fldAutoSaveFolder.Text;
  dlgBrowseFolder.Title := ilMiscStr(rsSelectAutosaveFolder, 'rsSelectAutosaveFolder');
  if dlgBrowseFolder.Execute then
    fldAutoSaveFolder.Text := dlgBrowseFolder.Directory;
end;
//------------------------------------------------------------------------------
// Update the Auto-save user interface
procedure TfrmSettings.rdiAutoSaveNameClick(Sender: TObject);
begin
  fldAutoSaveName.Enabled       := rdiAutoSaveNameFixed.Checked;
  chkAutoSaveAddSuffix.Enabled  := rdiAutoSaveNameFixed.Checked;
  lblAutoSaveNumFrom.Enabled    := rdiAutoSaveNameFixed.Checked;
  fldAutoSaveNumFrom.Enabled    := rdiAutoSaveNameFixed.Checked;
  spnAutoSaveNumFrom.Enabled    := rdiAutoSaveNameFixed.Checked;
  lblAutoSaveNumTo.Enabled      := rdiAutoSaveNameFixed.Checked;
  fldAutoSaveNumTo.Enabled      := rdiAutoSaveNameFixed.Checked;
  spnAutoSaveNumTo.Enabled      := rdiAutoSaveNameFixed.Checked;
  chkAutoSaveAddDate.Enabled    := rdiAutoSaveNameFixed.Checked;
  lblAutoSaveDateFormat.Enabled := rdiAutoSaveNameFixed.Checked;
  fldAutoSaveDateFormat.Enabled := rdiAutoSaveNameFixed.Checked;
end;
//------------------------------------------------------------------------------
// Show help on settings
procedure TfrmSettings.btnHelpClick(Sender: TObject);
var
  sPage: String;
begin
  sPage := 'dlgsettings.htm';
  case tabOptions.ActivePage.PageIndex of
    0: sPage := 'dlgsettings_general.htm';
    1: sPage := 'dlgsettings_snapping.htm';
    2: sPage := 'dlgsettings_autosaving.htm';
    3: sPage := 'dlgsettings_fixedsizes.htm';
    4: sPage := 'dlgsettings_appearance.htm';
    5: sPage := 'dlgsettings_sounds.htm';
  end;
  frmMain.ShowHelpPage(sPage, Handle);
end;
//------------------------------------------------------------------------------
// Convert the list index to the TSnapSounds item
function ListIndexToSound(idx: Integer): TSounds;
begin
  Result := sndNONE;
  case idx of
    0: Result := sndOK;
    1: Result := sndERROR;
    2: Result := sndSNAP;
    3: Result := sndSAVE;
    4: Result := sndCLIPCOPY;
    5: Result := sndCLIPPASTE;
  end;
end;
//------------------------------------------------------------------------------
// One sounds list item activated, show its details
procedure TfrmSettings.lisSoundsClick(Sender: TObject);
var
  iSnd: TSounds;
begin
  iSnd := ListIndexToSound(lisSounds.ItemIndex);
  if iSnd <> sndNONE then
  begin
    chkOneSoundActive.Checked := TmpSoundsAry[iSnd].Active;
    if TmpSoundsAry[iSnd].UseInternal then
      rdiSoundBuiltIn.Checked := True
    else
      rdiSoundWaveFile.Checked := True;
    fldSoundWavePath.Text := TmpSoundsAry[iSnd].Path;
  end;
end;
//------------------------------------------------------------------------------
// Double-click - play the sound
procedure TfrmSettings.lisSoundsDblClick(Sender: TObject);
begin
  btnSoundTestClick(nil);
end;
//------------------------------------------------------------------------------
// Play the sound
procedure TfrmSettings.btnSoundTestClick(Sender: TObject);
var
  iSnd: TSounds;
begin
  iSnd := ListIndexToSound(lisSounds.ItemIndex);
  if iSnd <> sndNONE then
  begin
    SoundsAry[sndTEST].Active      := True;
    SoundsAry[sndTEST].Sound       := TmpSoundsAry[iSnd].Sound;
    SoundsAry[sndTEST].UseInternal := rdiSoundBuiltIn.Checked;
    SoundsAry[sndTEST].Path        := fldSoundWavePath.Text;
    PlayOneSound(sndTEST);
  end;
end;
//------------------------------------------------------------------------------
// Save the possibly changed parameters of the active sound
procedure TfrmSettings.btnSoundSaveClick(Sender: TObject);
var
  iSnd: TSounds;
begin
  iSnd := ListIndexToSound(lisSounds.ItemIndex);
  if iSnd <> sndNONE then
  begin
    TmpSoundsAry[iSnd].Active      := chkOneSoundActive.Checked;
    TmpSoundsAry[iSnd].UseInternal := rdiSoundBuiltIn.Checked;
    TmpSoundsAry[iSnd].Path        := fldSoundWavePath.Text;
  end;
end;
//------------------------------------------------------------------------------
// Select a wave file from the disk
procedure TfrmSettings.outcmdSoundWavePathClick(Sender: TObject);
begin
  dlgOpen.InitialDir := ExtractFilePath(fldSoundWavePath.Text);
  dlgOpen.Filter := ilMiscStr(rsSoundFiles, 'rsSoundFiles') +  ' (*.wav)|*.wav';
  if dlgOpen.Execute then
    fldSoundWavePath.Text := dlgOpen.FileName;
end;
//------------------------------------------------------------------------------
// Show available date/time templates
procedure TfrmSettings.outbtnAutoSaveDateFormatHelpClick(Sender: TObject);
var
  sMsg: String;
begin
  sMsg := ilMiscStr(rsDateTime_Legend, 'rsDateTime_Legend') + S_CRLF + S_CRLF;
  sMsg := sMsg + 'yyyy' + S_TAB + '- ' + ilMiscStr(rsDateTime_yyyy , 'rsDateTime_yyyy') + S_CRLF;
  sMsg := sMsg + 'yy'   + S_TAB + '- ' + ilMiscStr(rsDateTime_yy   , 'rsDateTime_yy'  ) + S_CRLF;
  sMsg := sMsg + 'mm'   + S_TAB + '- ' + ilMiscStr(rsDateTime_mm   , 'rsDateTime_mm'  ) + S_CRLF;
  sMsg := sMsg + 'm'    + S_TAB + '- ' + ilMiscStr(rsDateTime_m    , 'rsDateTime_m'   ) + S_CRLF;
  sMsg := sMsg + 'dd'   + S_TAB + '- ' + ilMiscStr(rsDateTime_dd   , 'rsDateTime_dd'  ) + S_CRLF;
  sMsg := sMsg + 'd'    + S_TAB + '- ' + ilMiscStr(rsDateTime_d    , 'rsDateTime_d'   ) + S_CRLF;

  sMsg := sMsg + 'hh'   + S_TAB + '- ' + ilMiscStr(rsDateTime_hh   , 'rsDateTime_hh'  ) + S_CRLF;
  sMsg := sMsg + 'h'    + S_TAB + '- ' + ilMiscStr(rsDateTime_h    , 'rsDateTime_h'   ) + S_CRLF;
  sMsg := sMsg + 'nn'   + S_TAB + '- ' + ilMiscStr(rsDateTime_nn   , 'rsDateTime_nn'  ) + S_CRLF;
  sMsg := sMsg + 'n'    + S_TAB + '- ' + ilMiscStr(rsDateTime_n    , 'rsDateTime_n'   ) + S_CRLF;
  sMsg := sMsg + 'ss'   + S_TAB + '- ' + ilMiscStr(rsDateTime_ss   , 'rsDateTime_ss'  ) + S_CRLF;
  sMsg := sMsg + 's'    + S_TAB + '- ' + ilMiscStr(rsDateTime_s    , 'rsDateTime_s'   ) + S_CRLF;

  sMsg := sMsg + 'am/pm'+ S_TAB + '- ' + ilMiscStr(rsDateTime_am_pm, 'rsDateTime_am_pm') + S_CRLF;

  sMsg := sMsg + S_CRLF;
  sMsg := sMsg + ilMiscStr(rsDateTime_Sample, 'rsDateTime_Sample') + ' "' + FormatDateTime(fldAutoSaveDateFormat.Text, Now()) + '"' + S_CRLF;

  frmMain.CstShowMessage(sMsg);
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------


end.
