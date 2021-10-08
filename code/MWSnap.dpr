program MWSnap;

uses
  Forms,
  Windows,
  SysUtils,
  u_Main in 'u_Main.pas' {frmMain},
  u_Snap in 'u_Snap.pas' {frmSnap},
  uMWTools in '..\DLibrary\uMWTools.pas',
  uMWStrings in '..\DLibrary\uMWStrings.pas',
  uMWErrorLog in '..\DLibrary\uMWErrorLog.pas',
  u_Language in '..\DLibrary\u_Language.pas' {frmLanguage},
  u_Settings in 'u_Settings.pas' {frmSettings},
  u_SnapTools in 'u_SnapTools.pas',
  u_HotKeys in 'u_HotKeys.pas' {frmHotkeys},
  u_Ruler in 'u_Ruler.pas' {frmRuler},
  u_SaveDlg in 'u_SaveDlg.pas',
  u_About in 'u_About.pas' {frmAbout},
  u_FlipRotate in '..\DLibrary\u_FlipRotate.pas',
  u_Print in 'u_Print.pas' {frmPrint},
  u_Sounds in 'u_Sounds.pas',
  u_GrxPrinter in 'u_GrxPrinter.pas',
  u_ColorInfo in 'u_ColorInfo.pas' {frmColorInfo},
  u_AddFrame in 'u_AddFrame.pas' {frmAddFrame},
  u_Undo in 'u_Undo.pas',
  u_SoftwareCheck in '..\DLibrary\u_SoftwareCheck.pas' {frmSoftwareCheck},
  u_ProxySettings in '..\DLibrary\u_ProxySettings.pas' {frmProxySettings};

{$R *.RES}

begin
{
  ErrLog := TMWErrorLog.Create;
  ErrLog.Init(MakePath(ExtractFilePath(ParamStr(0)), 'MWSnap.log'), True);
  ErrLog.Activate(True);
  ErrLog.TimeStamp := True;
}

//ErrLog.WriteString('Creating Mutex');
  // Attempt to create a named mutex
  CreateMutex(nil, false, 'MWSnap');
  // if it failed then there is another instance
  if GetLastError = ERROR_ALREADY_EXISTS then begin
    // Send all windows our custom message - only our other
    // instance will recognise it, and restore itself
    //SendMessage(HWND_BROADCAST,
    //		RegisterWindowMessage('MyApp'),
    //		0,
    //		0);
    Halt(0); // lets quit
  end;

//ErrLog.WriteString('Application.Initialize...');
  Application.Initialize;
  Application.Title := 'MWSnap';
  Application.HelpFile := '';

//ErrLog.WriteString('CreateForm(TfrmMain)...');
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmLanguage, frmLanguage);
  Application.CreateForm(TfrmSettings, frmSettings);
  Application.CreateForm(TfrmHotkeys, frmHotkeys);
  Application.CreateForm(TfrmSnap, frmSnap);
  Application.CreateForm(TfrmRuler, frmRuler);
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.CreateForm(TfrmPrint, frmPrint);
  Application.CreateForm(TfrmColorInfo, frmColorInfo);
  Application.CreateForm(TfrmAddFrame, frmAddFrame);
  Application.CreateForm(TfrmSoftwareCheck, frmSoftwareCheck);
  Application.CreateForm(TfrmProxySettings, frmProxySettings);
  if frmMain.ProcessCmdParams then // command line parameters?
    frmMain.Close
  else
  begin
    frmMain.PostCreate;
    Application.Run;
  end;
end.
