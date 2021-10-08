unit u_Main;

// Revision history
// ================
//
//
// 3.00.0.74, 06 Jul 2002
//   - Release version
//
// 3.00.0.73 Beta RC2, 03 Jul 2002
//   - Repaired and restored the "Start minimized" option.
//   - A new option "Minimize on Close".
//   - Clicking the icon in the tray restores minimized program and
//     minimizes the restored program.
//
// 3.00.0.71 Beta RC1, 28 Jun 2002
//   - A new color picker tool.
//   - More sound effects: confirmations, clipboard actions
//   - Preview panel can be hatched to improve the image visibility.
//   - A new configuration option - restore MWSnap after snapping.
//   - A new configuration option - always show program icon in tray.
//   - All dialog boxes save and restore their last screen positions.
//   - An error with the preview window appearing on the captured images removed.
//   - Repaired errors with minimizing and restoring.
//   - Repaired bug with repeating the last capture.
//   - Minor bugs removed.
//   - The option "Start minimized" has been temporarily removed!
//
// 3.00.0.66 Beta, 18 Jun 2002
//   - Accept files dropped on the program window.
//   - Repaired bug in saving transparent GIFs.
//   - The ruler tool no longer causes MWSnap window to minimize.
//
// 3.00.0.62 Beta, 12 Jun 2002
//   - An option for automatic checking if a new version of the program
//     is available.
//   - A new version of the ruler tool, featuring higher accuracy,
//     dynamic readings, and a bi-directional scale.
//   - Many minor bugs and translation problems removed.
//
// 3.00.0.60 Beta, 6 Jun 2002
//   - Adding mouse cursor pointers to snapped images.
//   - Adding configurable frames to snapped images.
//   - Multilevel configurable undo and redo.
//   - Improved capturing engine.
//   - Color picker - F4 key opens a dialog box with color details
//     and several popular color notations (RGB, HTML, Delphi, and System).
//   - A new Window info tool, showing dynamically details of a window
//     below the cursor.
//   - Ruler, Zoom and Window info tools are available in the local menu
//     of the program's icon in the system tray.
//   - Ruler, Zoom and Window info tools can be invoked using
//     system-wide hotkeys.
//   - Dialog windows restore their last positions on the screen.
//   - Reorganized menus and toolbars.
//   - Minor bugs removed.
//
// 2.60.0.56 Beta, 23 May 2002
//   - Auto-printing (shortcut: <Ctrl+Alt+P>).
//   - Viewing and Opening picture files, with support for
//     gif, png, jpg, bmp, ico, emf and wmf formats.
//   - Picture Viewer panel, with options for opening, starting,
//     renaming and deleting pictures.
//   - Pasting images from the clipboard.
//   - New Zoom in/out tools.
//   - Zoom step menu.
//   - Numeric pad '+' and '-' keys perform zooming in/out.
//   - Ruler tool - right-clicking the ruler pops up a local menu.
//   - Auto-saving shortcut remapped to <Ctrl+Alt+S>.
//   - Removed the obsolete 'stretch preview' option.
//   - Repaired bug with repeating the last capture.
//   - Other minor bugs removed.
//
// 2.50.0.50 Beta, 04 Apr 2002
//   - Support for PNG images format.
//   - Improved color reduction algorithms in saving .bmp and .gif images.
//   - Repaired bug that could cause the marking rectangle to go into
//     the snapped image.
//   - Support for multiple versions of the same language.
//   - Many minor improvements.
//
// 2.20.0.48 Beta, 27 Mar 2002
//   - Possibility to translate user interface to any number of languages.
//   - Window snapping - possibility to capture child windows.
//   - Configurable sounds.
//   - Configurable displaying of the snap preview window.
//   - Printing - possibility to specify the count of copies.
//   - Windows XP Themes Manager compatibility.
//   - Enhanced visibility of the selection window.
//   - Improved error handling.
//   - Repaired bug causing settings not to be saved.
//   - Repaired bug with rotating snapped images.
//   - Corrected snapping of maximized windows.
//
// 2.00
//   - Auto-saving after making a snap.
//   - Printing with optional scaling.
//   - Basic transformations: flipping and rotating.
//   - Show/hide preview window (F6 while making a capture).
//   - Preview box, zoomer box - an additional marker showing an exact
//     cursor location.
//   - Minimize to system tray.
//   - Autostart with Windows.
//   - Start in minimized mode.
//   - Ruler with scale markings on both sides.
//   - Application title bar shows the name of the last saved image.
//   - Other minor improvements.
//
// 1.10, 01 Oct 2001
//   - First public version
//
// 1.00, 12 Feb 2000
//   - Initial version, for internal use only.
//

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus, ComCtrls, ExtDlgs, Buttons, u_Snap, ImgList,
  ToolWin, jpeg, Bmp2Tiff, GifImage, PNGImage, VerView, raylightAutostart,
  Registry, HtmlHlp, MsgDlg, uMWErrorLog, FileCtrl, CoolTrayIcon;

resourcestring
  rsCaptureRectHint='Snap fixed area (%s)|Snap a fixed rectangular area';
  rsAutoSaveON='Auto-saving is ON';
  rsAutoSaveOFF='Auto-saving is OFF';
  rsAutoSaveNamePromptON='Prompting for file name is ON';
  rsAutoSaveNextName='Next file name';
  rsFolder='Folder';
  rsFileName='File name';
  rsEnterFileNameNoPath='Enter the file name (without path)';
  rsAutoSavedTo='Auto-saved to';
  rsOptCancel='&Cancel';
  rsNoname='Noname';
  rsSaveAsQuality='JPG quality (1..100)';
  rsSaveAsParameters='Saving parameters';
  rsSaveAsColorBits='Color depth (bits per pixel)';
  rsSaveAsTransparent='Transparent';
  rsSaveAsTranspPixel='Transparent pixel';
  rsSaveAsLeftTop='Left-top';
  rsSaveAsRightTop='Right-top';
  rsSaveAsLeftBottom='Left-bottom';
  rsSaveAsRightBottom='Right-bottom';
  rsSaveAsCenter='Center';
  rsSaveAs1bit='1 bit';
  rsSaveAs4bits='4 bits';
  rsSaveAs8bits='8 bits';
  rsSaveAs15bits='15 bits';
  rsSaveAs16bits='16 bits';
  rsSaveAs24bits='24 bits';
  rsSaveAs32bits='32 bits';
  rsErrFileSave='Error saving file*|*[%s]*|**|*System report: %s';
  rsDontShowMessage='Don''t show this message again';
  rsNever='Never';
  rsBtnAccept='&Accept';
  rsBtnClose='&Close';
  rsBtnYes='&Yes';
  rsBtnNo='&No';
  rsBtnOk='&OK';
  rsBtnCancel='&Cancel';
  rsBtnAbort='&Abort';
  rsBtnRetry='&Retry';
  rsBtnIgnore='&Ignore';
  rsBtnAll='&All';
  rsBtnNoToAll='N&o to All';
  rsBtnYesToAll='Yes to &All';
  rsBtnHelp='Help';
  rsMsgWarning='Warning';
  rsMsgError='Error';
  rsMsgInformation='Information';
  rsMsgConfirm='Confirm';
  rsFileExistsOverwrite='File %s*|*already exists.*|*Do you want to overwrite it?';
  rsFileTypeBMP='Bitmaps';
  rsFileTypeJPEG='JPEG files';
  rsFileTypeGIF='GIF files';
  rsFileTypePNG='PNG files';
  rsFileTypeTIFF='TIFF files';
  rsFileTypeWMF='WMF files';
  rsFileTypeICO='Icon files';
  rsAllFormats='All formats';
  rsAutoPrintON='Auto-printing is ON';
  rsAutoPrintOFF='Auto-printing is OFF';
  rsNoBmpOnClip='There is no bitmap on the Clipboard';
  rsFileRenameTitle='Rename the file';
  rsFileRenamePrompt='Enter the new name:';
  rsFileCantRename='File [%s]*|*couldn''t be renamed to*|*[%s].';
  rsFileSureDelete='Are you sure you want to delete the file*|*[%s]?';
  rsFileCantDelete='File [%s]*|*couldn''t be deleted.';
  rsDynStateNormal='Ready';
  rsDynStateCursor='Define the cursor image insertion point, <Esc> to cancel...';
  rsMsgChkClose='You''ve selected the Close button, but, according to the program settings, MWSnap will continue to run minimized.';

//ilMiscStr(

const
  TRF_FLIPX  = 1;
  TRF_FLIPY  = 2;
  TRF_ROTL   = 3;
  TRF_ROTR   = 4;
  TRF_FSTIDX = 1;
  TRF_LSTIDX = 4;

  S_INIROOT = 'SOFTWARE\MirWoj\MWSnap';

type
  // the application's dynamic state
  TDynState = (
               DS_NORMAL, // default state
               DS_CURSOR  // appending a cursor image
              );

  TfrmMain = class(TForm)
    pnlLeft: TPanel;
    mnuMain: TMainMenu;
    mnuFile: TMenuItem;
    optExit: TMenuItem;
    sttBar: TStatusBar;
    Splitter1: TSplitter;
    pnlPreview: TPanel;
    pnlPreviewButtons: TPanel;
    mnuHelp: TMenuItem;
    optAbout: TMenuItem;
    mnuCapture: TMenuItem;
    optCaptureRect: TMenuItem;
    optCaptureArea: TMenuItem;
    optCaptureLast: TMenuItem;
    mnuEdit: TMenuItem;
    optCopy: TMenuItem;
    optSaveAs: TMenuItem;
    N2: TMenuItem;
    popupRectSizes: TPopupMenu;
    optSettings: TMenuItem;
    optCaptureWind: TMenuItem;
    N3: TMenuItem;
    optCaptureDesk: TMenuItem;
    tlbPicture: TToolBar;
    ToolButton2: TToolButton;
    imgLis16: TImageList;
    btnCopy: TToolButton;
    mnuTools: TMenuItem;
    N1: TMenuItem;
    optSetHotkeys: TMenuItem;
    scrBoxPreview: TScrollBox;
    imgPreview: TImage;
    mnuView: TMenuItem;
    optViewCaptPanel: TMenuItem;
    optViewSttBar: TMenuItem;
    tlbMain: TToolBar;
    btnSaveAs: TToolButton;
    ToolButton3: TToolButton;
    tbtnCaptureRect: TToolButton;
    tbtnCaptureArea: TToolButton;
    tbtnCaptureWind: TToolButton;
    tbtnCaptureDesktop: TToolButton;
    tbtnCaptureLast: TToolButton;
    optViewTlbMain: TMenuItem;
    optViewTlbPicture: TMenuItem;
    N4: TMenuItem;
    ToolButton1: TToolButton;
    tbtnSetHotkeys: TToolButton;
    tbtnSettings: TToolButton;
    tbtnRuler: TToolButton;
    ToolButton5: TToolButton;
    tbtnZoomer: TToolButton;
    optRuler: TMenuItem;
    N6: TMenuItem;
    optZoomer: TMenuItem;
    dlgSave: TSaveDialog;
    optViewAll: TMenuItem;
    optViewNone: TMenuItem;
    N7: TMenuItem;
    tmrDelayedCapture: TTimer;
    lblVsn: TVersionView;
    ToolButton7: TToolButton;
    optFlipX: TMenuItem;
    optFlipY: TMenuItem;
    dlgOpenPicture: TOpenPictureDialog;
    popupSystem: TPopupMenu;
    popoptRestore: TMenuItem;
    N8: TMenuItem;
    outpopoptExit: TMenuItem;
    rlAutostart: TRaylightAutostart;
    btnAddFixedSize: TToolButton;
    optAddFixedSize: TMenuItem;
    N9: TMenuItem;
    outtbtnAutoSave: TToolButton;
    ToolButton6: TToolButton;
    optAutoSave: TMenuItem;
    outpopoptCaptureRect: TMenuItem;
    outpopoptCaptureArea: TMenuItem;
    outpopoptCaptureWind: TMenuItem;
    outpopoptCaptureDesk: TMenuItem;
    N10: TMenuItem;
    outpopoptCaptureLast: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    optRotateLeft: TMenuItem;
    optRotateRight: TMenuItem;
    optPrint: TMenuItem;
    N13: TMenuItem;
    tbtnPrint: TToolButton;
    optHelp: TMenuItem;
    optLanguage: TMenuItem;
    N14: TMenuItem;
    dlgMessage: TMessageDlg;
    tbtnExit: TToolButton;
    ToolButton4: TToolButton;
    outtbtnAutoPrint: TToolButton;
    optAutoPrint: TMenuItem;
    optPaste: TMenuItem;
    N15: TMenuItem;
    optOpen: TMenuItem;
    tbtnOpen: TToolButton;
    tabCtlLeft: TPageControl;
    tabSnap: TTabSheet;
    tabView: TTabSheet;
    pnlDelay: TPanel;
    spnDelayedCapture: TUpDown;
    fldDelayedCapture: TEdit;
    btnDelayedCapture: TSpeedButton;
    pnlSettings: TPanel;
    tabCtl: TPageControl;
    tabCaptureRect: TTabSheet;
    outlblX: TLabel;
    lblPmtCaptureRect: TLabel;
    btnRectSizes: TSpeedButton;
    btnCaptureRect: TButton;
    fldRectDX: TEdit;
    fldRectDY: TEdit;
    spnRectDX: TUpDown;
    spnRectDY: TUpDown;
    tabCaptureArea: TTabSheet;
    lblPmtCaptureArea: TLabel;
    btnCaptureArea: TButton;
    tabCaptureWind: TTabSheet;
    lblPmtCaptureWind: TLabel;
    btnCaptureWind: TButton;
    tabCaptureDesktop: TTabSheet;
    lblPmtCaptureDesktop: TLabel;
    btnCaptureDesktop: TButton;
    tabCaptureLast: TTabSheet;
    lblPmtCaptureLast: TLabel;
    btnCaptureLast: TButton;
    pnlLeftTop: TPanel;
    DirectoryListBox: TDirectoryListBox;
    pnlDrive: TPanel;
    DriveComboBox: TDriveComboBox;
    Splitter2: TSplitter;
    pnlLeftBottom: TPanel;
    FMFileListBox: TFileListBox;
    pnlFilter: TPanel;
    FilterComboBox: TFilterComboBox;
    popOpen: TPopupMenu;
    optFMFileOpen: TMenuItem;
    N25: TMenuItem;
    optFMStart: TMenuItem;
    optFMRename: TMenuItem;
    optFMDelete: TMenuItem;
    N38: TMenuItem;
    optFMCancel: TMenuItem;
    btnZoomIn: TToolButton;
    btnZoomOut: TToolButton;
    btnZoomReset: TToolButton;
    popupZoom: TPopupMenu;
    outpopoptZoom10: TMenuItem;
    outpopoptZoom25: TMenuItem;
    outpopoptZoom50: TMenuItem;
    outpopoptZoom75: TMenuItem;
    outpopoptZoom100: TMenuItem;
    outpopoptZoom150: TMenuItem;
    outpopoptZoom200: TMenuItem;
    outpopoptZoom300: TMenuItem;
    outpopoptZoom500: TMenuItem;
    outpopoptZoom750: TMenuItem;
    outpopoptZoom1000: TMenuItem;
    popoptZoomCancel: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    outpopoptZoom2000: TMenuItem;
    outpopoptRuler: TMenuItem;
    outpopoptZoomer: TMenuItem;
    N5: TMenuItem;
    optWdwInfo: TMenuItem;
    tbtnWdwInfo: TToolButton;
    outpopoptWdwInfo: TMenuItem;
    btnAddFrame: TToolButton;
    btnAddCursor: TToolButton;
    optAddFrame: TMenuItem;
    optAddFrameSmp: TMenuItem;
    btnUndo: TToolButton;
    ToolButton13: TToolButton;
    optUndo: TMenuItem;
    N20: TMenuItem;
    optAddCursor: TMenuItem;
    optAddCursorArrow: TMenuItem;
    optAddFrameShd: TMenuItem;
    optAddFrameBtn: TMenuItem;
    popupAddFrame: TPopupMenu;
    outpopoptAddFrameSmp: TMenuItem;
    outpopoptAddFrameShd: TMenuItem;
    outpopoptAddFrameBtn: TMenuItem;
    N21: TMenuItem;
    outpopoptAddFrameCancel: TMenuItem;
    popupAddCursor: TPopupMenu;
    optAddCursorCross: TMenuItem;
    optAddCursorBeam: TMenuItem;
    optAddCursorSizeNESW: TMenuItem;
    optAddCursorSizeNS: TMenuItem;
    optAddCursorSizeNWSE: TMenuItem;
    optAddCursorSizeWE: TMenuItem;
    optAddCursorUpArrow: TMenuItem;
    optAddCursorHourGlass: TMenuItem;
    optAddCursorDrag: TMenuItem;
    optAddCursorNoDrop: TMenuItem;
    optAddCursorHSplit: TMenuItem;
    optAddCursorVSplit: TMenuItem;
    optAddCursorMultiDrag: TMenuItem;
    optAddCursorSQLWait: TMenuItem;
    optAddCursorNo: TMenuItem;
    optAddCursorAppStart: TMenuItem;
    optAddCursorHelp: TMenuItem;
    optAddCursorHandPoint: TMenuItem;
    optAddCursorSizeAll: TMenuItem;
    outpopoptAddCursorArrow: TMenuItem;
    outpopoptAddCursorCross: TMenuItem;
    outpopoptAddCursorBeam: TMenuItem;
    outpopoptAddCursorSizeNESW: TMenuItem;
    outpopoptAddCursorSizeNS: TMenuItem;
    outpopoptAddCursorSizeNWSE: TMenuItem;
    outpopoptAddCursorSizeWE: TMenuItem;
    outpopoptAddCursorUpArrow: TMenuItem;
    outpopoptAddCursorHourGlass: TMenuItem;
    outpopoptAddCursorDrag: TMenuItem;
    outpopoptAddCursorNoDrop: TMenuItem;
    outpopoptAddCursorVSplit: TMenuItem;
    outpopoptAddCursorHSplit: TMenuItem;
    outpopoptAddCursorMultiDrag: TMenuItem;
    outpopoptAddCursorSQLWait: TMenuItem;
    outpopoptAddCursorNo: TMenuItem;
    outpopoptAddCursorAppStart: TMenuItem;
    outpopoptAddCursorHelp: TMenuItem;
    outpopoptAddCursorHandPoint: TMenuItem;
    outpopoptAddCursorSizeAll: TMenuItem;
    N22: TMenuItem;
    outpopoptAddCursorCancel: TMenuItem;
    btnRedo: TToolButton;
    optRedo: TMenuItem;
    optTransform: TMenuItem;
    outbtnTransform: TToolButton;
    popupTransform: TPopupMenu;
    outpopoptFlipX: TMenuItem;
    outpopoptFlipY: TMenuItem;
    outpopoptRotateLeft: TMenuItem;
    outpopoptRotateRight: TMenuItem;
    N19: TMenuItem;
    outpopoptTransformCancel: TMenuItem;
    N23: TMenuItem;
    N24: TMenuItem;
    N26: TMenuItem;
    N27: TMenuItem;
    optCheckNewVersion: TMenuItem;
    optVisitWebPage: TMenuItem;
    optDonate: TMenuItem;
    tbtnColorPicker: TToolButton;
    optColorPicker: TMenuItem;
    outpopoptColorPicker: TMenuItem;
    CoolTrayIcon: TCoolTrayIcon;
    procedure optExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure optAboutClick(Sender: TObject);
    procedure btnRectSizesClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure optSettingsClick(Sender: TObject);
    procedure optCaptureRectClick(Sender: TObject);
    procedure optCaptureAreaClick(Sender: TObject);
    procedure optCaptureWindClick(Sender: TObject);
    procedure optCaptureDeskClick(Sender: TObject);
    procedure optCaptureLastClick(Sender: TObject);
    procedure optSetHotkeysClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure optViewCaptPanelClick(Sender: TObject);
    procedure optViewSttBarClick(Sender: TObject);
    procedure optSaveAsClick(Sender: TObject);
    procedure optCopyClick(Sender: TObject);
    procedure optStretchedClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure optViewTlbMainClick(Sender: TObject);
    procedure optViewTlbPictureClick(Sender: TObject);
    procedure FixedSizeSelected(Sender: TObject);
    procedure optRulerClick(Sender: TObject);
    procedure optZoomerClick(Sender: TObject);
    procedure popupRectSizesPopup(Sender: TObject);
    procedure optViewAllClick(Sender: TObject);
    procedure optViewNoneClick(Sender: TObject);
    procedure tabCtlChange(Sender: TObject);
    procedure btnDelayedCaptureClick(Sender: TObject);
    procedure tmrDelayedCaptureTimer(Sender: TObject);
    procedure popoptRestoreClick(Sender: TObject);
    procedure optAddFixedSizeClick(Sender: TObject);
    procedure optAutoSaveClick(Sender: TObject);
    procedure optFlipXClick(Sender: TObject);
    procedure optFlipYClick(Sender: TObject);
    procedure optRotateLeftClick(Sender: TObject);
    procedure optRotateRightClick(Sender: TObject);
    procedure optPrintClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure optHelpClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure optLanguageClick(Sender: TObject);
    procedure optAutoPrintClick(Sender: TObject);
    procedure optPasteClick(Sender: TObject);
    procedure optOpenClick(Sender: TObject);
    procedure DirectoryListBoxClick(Sender: TObject);
    procedure FMFileListBoxClick(Sender: TObject);
    procedure FMFileListBoxDblClick(Sender: TObject);
    procedure pnlFilterResize(Sender: TObject);
    procedure pnlDriveResize(Sender: TObject);
    procedure FMFileListBoxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure optFMFileOpenClick(Sender: TObject);
    procedure optFMStartClick(Sender: TObject);
    procedure optFMRenameClick(Sender: TObject);
    procedure optFMDeleteClick(Sender: TObject);
    procedure FMFileListBoxKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnZoomInClick(Sender: TObject);
    procedure btnZoomOutClick(Sender: TObject);
    procedure btnZoomResetClick(Sender: TObject);
    procedure popoptZoomClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure optWdwInfoClick(Sender: TObject);
    procedure optAddFrameSmpClick(Sender: TObject);
    procedure optUndoClick(Sender: TObject);
    procedure optAddCursorClick(Sender: TObject);
    procedure optAddFrameShdClick(Sender: TObject);
    procedure optAddFrameBtnClick(Sender: TObject);
    procedure btnAddFrameClick(Sender: TObject);
    procedure btnAddCursorClick(Sender: TObject);
    procedure imgPreviewClick(Sender: TObject);
    procedure outbtnTransformClick(Sender: TObject);
    procedure btnRedoClick(Sender: TObject);
    procedure optCheckNewVersionClick(Sender: TObject);
    procedure optVisitWebPageClick(Sender: TObject);
    procedure optDonateClick(Sender: TObject);
    procedure optColorPickerClick(Sender: TObject);
    procedure CoolTrayIconClick(Sender: TObject);
    procedure CoolTrayIconStartup(Sender: TObject; var ShowMainForm: Boolean);

  private { Private declarations }
    m_IsBeta: Boolean; // is it a Beta version?
    m_sPgmDir: String;      // our home directory
    m_regFile: TRegIniFile; // registry handling
    m_DynState: TDynState;  // the application's dynamic state
    m_IsMinimized: Boolean; // is the application currently minimized?
    m_TrfType: Integer; // last used transformation
    m_SnapCount: Integer; // count of performed snaps
    m_SoundOn: Boolean; // sound signals?
    m_ZoomStep: Double; // Zoom step, 100% = 1.0
    m_DelayTime: Integer;
    m_SnapHidePgm: Boolean; // hide before snapping
    m_SnapRestPgm: Boolean; // restore after snapping
    m_AutoCopy: Boolean;
    m_ShowPreviewBox: Boolean; // show snap preview window
    m_WarnKeys: Boolean;  // warn at start about conflicting keys
    m_AskOverwrite: Boolean; // confirm files overwriting
    m_CloBkg: TColor;
    m_CloRuler: TColor;
    m_MarkCrsPos: Boolean; // mark the cursor position on snap preview
    m_CloseMinimizes: Boolean; // minimize on close?
    m_LastFilterIndex: Integer;
    m_LastJPEGQuality: Integer;
    m_LastColorBits: Integer;
    m_LastTransparent: Boolean;
    m_LastTranspPixel: Integer;
    m_LastSavePath: String; // last path for saving
    m_AutoSaveFolder: String;
    m_AutoSaveName: String;
    m_AutoSaveNamePrompt: Boolean;
    m_AutoSaveAddSuffix: Boolean;
    m_AutoSaveNumFrom: Integer;
    m_AutoSaveNumTo: Integer;
    m_AutoSaveAddDate: Boolean;
    m_AutoSaveDateFormat: String;
    m_AutoSaveActive: Boolean;
    m_AutoSaveFormat: String;
    m_StartMinimized: Boolean; // start in minimized mode?
    m_sLanguage: String; // language file
    m_AutoPrintActive: Boolean;
    m_AddCursorIdx: TCursor;
    m_InetUseProxy: Boolean;
    m_InetProxyAddress: String;
    m_InetProxyPort: Integer;
    m_SessionEnding: Boolean; // is Windows about to close?

    procedure WMHotKey(var Msg: TWMHotKey); message WM_HOTKEY;
    procedure WMDROPFILES(var Message: TWMDROPFILES); message WM_DROPFILES;
    procedure WMSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
    procedure WMQueryEndSession(var Msg: TMessage); message WM_QUERYENDSESSION;
    procedure CustMinimize(Sender: TObject);
    procedure CustRestore(Sender: TObject);
    procedure LoadSettings;
    procedure SaveSettings;
    procedure SetDynState(stt: TDynState);
    procedure SetTrfType(iTrf: Integer);
    procedure SetZoomStep(fZom: Double);
    procedure SetAddCursorIdx(crsIdx: TCursor);
    procedure RectSizeSelected(sText: String);
    procedure FillSizesPopup;
    procedure optRectSizeClick(Sender: TObject);
    procedure DoCapture(typ: TSnapMode);
    procedure DoAutoSave;
    function  CurrentRect: String;
    procedure AddFixedSize(dx, dy: Integer);
    procedure SetLastSavePath(sPath: String);
    procedure SetCloBkg(clo: TColor);
    function  GetBkgStyle: Integer;
    procedure SetBkgStyle(iStyle: Integer);
    procedure SetCloseMinimizes(iOn: Boolean);
    procedure SetAutoSaveActive(fAuto: Boolean);
    procedure SetAutoPrintActive(fAuto: Boolean);
    function  GetAutostart: Boolean;
    procedure SetAutostart(fAuto: Boolean);
    function  GetMinimizeToTray: Boolean;
    procedure SetMinimizeToTray(fUse: Boolean);
    function  GetAlwaysInTray: Boolean;
    procedure SetAlwaysInTray(fAlways: Boolean);
    procedure SaveJPEG(sFileName: String; iQuality: Integer);
    procedure SaveBMP(sFileName: String; iFormat: Integer);
    procedure SaveTIFF(sFileName: String; iFormat: Integer);
    procedure SaveGIF(sFileName: String; fTransp: Boolean; iTransPix: Integer);
    procedure SavePNG(sFileName: String; fTransp: Boolean; iTransPix: Integer);
    procedure TransformSnap(iTyp: Integer);
    procedure SetLanguage(sLanguage: String);
    procedure DoOpenPicture(sFileName: String);
    procedure UpdateFMFileListBox(fLocateCurrent: Boolean);

  published { Published declarations }
    property IsBeta      : Boolean read m_IsBeta;    // Is it a Beta-test version?
    property PgmDir      : String  read m_sPgmDir;   // our home directory
    property DynState    : TDynState read m_DynState write SetDynState;
    property TrfType     : Integer   read m_TrfType  write SetTrfType; // last used transformation
    property SnapCount   : Integer   read m_SnapCount write m_SnapCount; // count of performed snaps

    property SoundOn       : Boolean read m_SoundOn        write m_SoundOn; // sound signals?
    property LastSavePath  : String  read m_LastSavePath   write SetLastSavePath; // last path for saving
    property DelayTime     : Integer read m_DelayTime      write m_DelayTime;
    property SnapHidePgm   : Boolean read m_SnapHidePgm    write m_SnapHidePgm;
    property SnapRestPgm   : Boolean read m_SnapRestPgm    write m_SnapRestPgm;
    property AutoCopy      : Boolean read m_AutoCopy       write m_AutoCopy;
    property ShowPreviewBox: Boolean read m_ShowPreviewBox write m_ShowPreviewBox; // show snap preview window
    property WarnKeys      : Boolean read m_WarnKeys       write m_WarnKeys;  // warn at start about conflicting keys
    property AskOverwrite  : Boolean read m_AskOverwrite   write m_AskOverwrite; // confirm files overwriting
    property ZoomStep      : Double  read m_ZoomStep       write SetZoomStep; // Zoom step, 100% = 1.0
    property AddCursorIdx  : TCursor read m_AddCursorIdx   write SetAddCursorIdx;

    property CloBkg        : TColor  read m_CloBkg         write SetCloBkg;
    property CloRuler      : TColor  read m_CloRuler       write m_CloRuler;
    property BkgStyle      : Integer read GetBkgStyle      write SetBkgStyle; // background brush style
    property MarkCrsPos    : Boolean read m_MarkCrsPos     write m_MarkCrsPos; // mark the cursor position on snap preview

    property AutoSaveFolder     : String  read m_AutoSaveFolder     write m_AutoSaveFolder;
    property AutoSaveName       : String  read m_AutoSaveName       write m_AutoSaveName;
    property AutoSaveNamePrompt : Boolean read m_AutoSaveNamePrompt write m_AutoSaveNamePrompt;
    property AutoSaveAddSuffix  : Boolean read m_AutoSaveAddSuffix  write m_AutoSaveAddSuffix;
    property AutoSaveNumFrom    : Integer read m_AutoSaveNumFrom    write m_AutoSaveNumFrom;
    property AutoSaveNumTo      : Integer read m_AutoSaveNumTo      write m_AutoSaveNumTo;
    property AutoSaveAddDate    : Boolean read m_AutoSaveAddDate    write m_AutoSaveAddDate;
    property AutoSaveDateFormat : String  read m_AutoSaveDateFormat write m_AutoSaveDateFormat;
    property AutoSaveActive     : Boolean read m_AutoSaveActive     write SetAutoSaveActive;
    property AutoSaveFormat     : String  read m_AutoSaveFormat     write m_AutoSaveFormat;
    property Autostart          : Boolean read GetAutostart         write SetAutostart;
    property MinimizeToTray     : Boolean read GetMinimizeToTray    write SetMinimizeToTray;
    property AlwaysInTray       : Boolean read GetAlwaysInTray      write SetAlwaysInTray;
    property StartMinimized     : Boolean read m_StartMinimized     write m_StartMinimized;
    property CloseMinimizes     : Boolean read m_CloseMinimizes     write SetCloseMinimizes; // minimize on close?
    property Language           : String  read m_sLanguage          write SetLanguage; // language file
    property AutoPrintActive    : Boolean read m_AutoPrintActive    write SetAutoPrintActive;

    property InetUseProxy       : Boolean read m_InetUseProxy       write m_InetUseProxy;
    property InetProxyAddress   : String  read m_InetProxyAddress   write m_InetProxyAddress;
    property InetProxyPort      : Integer read m_InetProxyPort      write m_InetProxyPort;

  public { Public declarations }
    TheBmp: TBitmap; // a copy of the current picture
    RectSizes: TStringList; // list of predefined rectangle sizes
    procedure PostCreate;
    function  ReadBool(sSec, sKey: String; fDefault: Boolean): Boolean;
    function  ReadInteger(sSec, sKey: String; nDefault: Integer): Integer;
    function  ReadString(sSec, sKey: String; sDefault: String): String;
    procedure WriteBool(sSec, sKey: String; fVal: Boolean);
    procedure WriteInteger(sSec, sKey: String; nVal: Integer);
    procedure WriteString(sSec, sKey: String; sVal: String);
    procedure Delay(msecs:integer);
    procedure TranslateUI;
    procedure LocalizeMessageDlg(mb: TMessageDlg);
    function  CstMessageDlg(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint): Word;
    function  CstMessageDlgChk(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint; ChkSection: String): Word;
    procedure CstShowMessage(const Msg: string);
    procedure UpdateUI;
    function  ProcessCmdParams: Boolean;
    procedure ShowHelpPage(sTopic: String; hwndCaller: HWND);
    procedure SaveWindowPosition(frm: TForm; fSaveSize: Boolean);
    procedure ReadWindowPosition(frm: TForm; fRestoreSize: Boolean);
    function  CheckOverwriteFile(const sFileName: String): Boolean;
    procedure ResetDynState;
  end;

var
  frmMain: TfrmMain;
//  ErrLog: TMWErrorLog;

implementation

uses
  Clipbrd, uMWStrings, uMWTools, uMWForms, u_Settings, u_SnapTools,
  u_HotKeys, u_Ruler, u_Zoomer, u_SaveDlg, u_About, u_FlipRotate, u_Print,
  u_Language, IniLang, u_Sounds, u_GrxPrinter, ShellAPI, u_AddFrame,
  u_Undo, u_ColorInfo, u_SoftwareCheck, u_ProxySettings;

var
  fFstAct: Boolean;     // first activation?
  fInitDone: Boolean;   // is the program initialized?

{$R *.DFM}
{$R WindowsXP.res}
{$R MWSnapRes.res}


// #todo2 Add menu items tooltips

//------------------------------------------------------------------------------
// Called even before FormCreate
procedure TfrmMain.CoolTrayIconStartup(Sender: TObject; var ShowMainForm: Boolean);
begin
  m_regFile := TRegIniFile.Create(S_INIROOT); // 'SOFTWARE\MirWoj\MWSnap'

  StartMinimized := ReadBool('Options', 'StartMinimized', False); // start in minimized mode?
  MinimizeToTray := ReadBool('Options', 'MinimizeToTray', True);  // minimize to tray?
  AlwaysInTray   := ReadBool('Options', 'AlwaysInTray', True);  // always show icon in tray?

  if not MinimizeToTray then
    StartMinimized := False;

  ShowMainForm := not StartMinimized;
end;
//------------------------------------------------------------------------------
// Main initialization
procedure TfrmMain.FormCreate(Sender: TObject);
begin
  fInitDone  := False;
  m_sPgmDir  := ExtractFilePath(ParamStr(0)); // our home directory, with '\' at the end

//  ErrLog     := TMWErrorLog.Create;
//  ErrLog.Init(MakePath(PgmDir, 'MWSnap.log'), True);
//  ErrLog.Activate(True);
//  ErrLog.TimeStamp := True;
//  ErrLog.WriteString('Main form about to be created');

  // let Windows know that we accept dropped files
  DragAcceptFiles(frmMain.Handle, True);

  m_IsBeta      := False; // Beta?
  fFstAct       := True; // next OnActivate() will be the first one
  m_ZoomStep    := 1.0;
  m_IsMinimized := False;
  Application.HelpFile := m_sPgmDir + 'MWSnap.chm';
  InitializeSounds; // initialize the system of sounds
  DynState := DS_NORMAL; // no dynamic actions
  TheBmp := TBitmap.Create;
  GlbGrxPrinter := TGrxPrinter.Create;
  GlbAddFrame := TAddFrame.Create;
  GlbUndo := TUndoStack.Create;
  RectSizes := TStringList.Create;

  CoolTrayIcon.Icon.Assign(Icon);

  tabCtlLeft.ActivePageIndex := 0;
  DirectoryListBox.Align := alClient;
  FMFileListBox.Align := alClient;

  Application.OnMinimize := CustMinimize;
  Application.OnRestore  := CustRestore;

  LoadSettings;
end;
//------------------------------------------------------------------------------
// We were activated
procedure TfrmMain.FormActivate(Sender: TObject);
begin
  if fFstAct then // only once
  begin
    fInitDone := True;
  end
  else
  begin
    UpdateUI; // update all user interface elements
  end;
  fFstAct := False;
end;
//------------------------------------------------------------------------------
procedure TfrmMain.PostCreate;
begin
  TranslateUI;
  RegisterHotkeys(WarnKeys); // register system-wide hotkeys

  if StartMinimized then
    Application.Minimize;
//  Visible := True;
end;
//------------------------------------------------------------------------------
procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if not fInitDone then
    Exit;

  CanClose := ((not CloseMinimizes) or m_SessionEnding);

  if CanClose then
  begin
    GlbUndo.Clear;
    UnRegisterHotkeys;
    SaveSettings;
    TheBmp.Free;
  end
  else
  begin
    CstMessageDlgChk(ilMiscStr(rsMsgChkClose, 'rsMsgChkClose'), //  'You''ve selected the Close button, but, according to the program settings, MWSnap will continue to run minimized.',
                  mtInformation, [mbOk], 0, 'ChkCloseMinimizes');
    Application.Minimize;
//    CoolTrayIcon.HideMainForm;
//    CoolTrayIcon.IconVisible := True;
  end;
end;
//------------------------------------------------------------------------------
procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  ;
end;
//------------------------------------------------------------------------------
// Save settings
procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ;
end;
//------------------------------------------------------------------------------
// Handle system messages to trap minimizing
procedure TfrmMain.WMSysCommand;
begin
  case Msg.CmdType of
    SC_MINIMIZE:
                 m_IsMinimized := True;
    SC_RESTORE, SC_MAXIMIZE:
                 m_IsMinimized := False;
  end;
  inherited;
end;
//------------------------------------------------------------------------------
// Detect Windows closing, else Windows will be unable to shut down
procedure TfrmMain.WMQueryEndSession(var Msg: TMessage);
begin
  m_SessionEnding := True; // allow the program to terminate
  Msg.Result := 1;
end;
//------------------------------------------------------------------------------
procedure TfrmMain.CustMinimize(Sender: TObject);
begin
  m_IsMinimized := True;
end;
//------------------------------------------------------------------------------
procedure TfrmMain.CustRestore(Sender: TObject);
begin
  m_IsMinimized := False;
end;
//------------------------------------------------------------------------------
procedure TfrmMain.LoadSettings;
var
  i, iTmp: Integer;
  sTmp: String;
  iSnd: TSounds;
begin
  // Settings
  DelayTime        := ReadInteger('Settings', 'DelayTime', 800);
  SnapHidePgm      := ReadBool('Settings', 'SnapHidePgm', True);
  SnapRestPgm      := ReadBool('Settings', 'SnapRestPgm', True);
  AutoCopy         := ReadBool('Settings', 'AutoCopy', False);
  WarnKeys         := ReadBool('Settings', 'WarnKeys', True); // warn at start about conflicting keys
  AskOverwrite     := ReadBool('Settings', 'AskOverwrite', True); // confirm files overwriting
  Autostart        := ReadBool('Options', 'Autostart', False);  // autostart with Windows?
  MarkCrsPos       := ReadBool('Options', 'MarkCrsPos', True);  // mark the cursor position on snap preview
  ShowPreviewBox   := ReadBool('Options', 'ShowPreviewBox', True); // show snap preview window
  Language         := ReadString('Options', 'Language', '???');
  AddCursorIdx     := ReadInteger('Options', 'AddCursorIdx' , crArrow);
  TrfType          := ReadInteger('Options', 'TrfType', TRF_FLIPX); // last used transformation
  SnapCount        := ReadInteger('Options', 'SnapCount', 0); // count of performed snaps
  GlbUndo.MaxSteps := ReadInteger('Options', 'MaxUndoCount', 8); // Undo stack size
  CloseMinimizes   := ReadBool('Options', 'CloseMinimizes', False); // minimize on close?

  // Rectangles
  RectSizes.Duplicates := dupIgnore; // no duplicates, please
  RectSizeSelected(ReadString('Rectangles', 'LastRect', '32x32'));
  iTmp := ReadInteger('Rectangles', 'RectCnt', 0);
  if iTmp > 0 then
  begin
    for i := 1 to iTmp do
    begin
      sTmp := ReadString('Rectangles', 'Rect' + IntToStr(i), '');
      if Length(sTmp) > 2 then RectSizes.Add(sTmp);
    end;
  end
  else // no rectangles, set default ones
  begin
    RectSizes.Add('16x16');
    RectSizes.Add('32x32');
    RectSizes.Add('48x48');
    RectSizes.Add('64x64');
    RectSizes.Add('96x72');
  end;

  // Hotkeys
  HKFixd.SetFromString(ReadString('Hotkeys', 'Fixd', DFTKEY_FIXD));
  HKArea.SetFromString(ReadString('Hotkeys', 'Area', DFTKEY_AREA));
  HKWind.SetFromString(ReadString('Hotkeys', 'Wind', DFTKEY_WIND));
  HKDesk.SetFromString(ReadString('Hotkeys', 'Desk', DFTKEY_DESK));
  HKLast.SetFromString(ReadString('Hotkeys', 'Last', DFTKEY_LAST));

  HKRulr.SetFromString(ReadString('Hotkeys', 'Rulr', DFTKEY_RULR));
  HKZoom.SetFromString(ReadString('Hotkeys', 'Zoom', DFTKEY_ZOOM));
  HKClop.SetFromString(ReadString('Hotkeys', 'Clop', DFTKEY_CLOP));
  HKInfo.SetFromString(ReadString('Hotkeys', 'Info', DFTKEY_INFO));

  // UI
  pnlLeft.Visible    := IntToBool(ReadInteger('UI', 'ViewPanelCapt', 1));
  pnlPreview.Visible := IntToBool(ReadInteger('UI', 'ViewPanelPict', 1));
  sttBar.Visible     := IntToBool(ReadInteger('UI', 'ViewSttBar'   , 1));
  tlbMain.Visible    := IntToBool(ReadInteger('UI', 'ViewToolbMain', 1));
  tlbPicture.Visible := IntToBool(ReadInteger('UI', 'ViewToolbPict', 1));

  // colors
  CloBkg             := ReadInteger('Colors', 'Background', 12566400);
  CloRuler           := ReadInteger('Colors', 'Ruler', clYellow);
  BkgStyle           := ReadInteger('Colors', 'BkgStyle', 5);

  // saving
  m_LastSavePath     := ReadString('Saving' , 'LastSavePath', ''); // intentionally set to m_xxx
  m_LastFilterIndex  := ReadInteger('Saving', 'LastFilterIndex',  1);
  m_LastJPEGQuality  := ReadInteger('Saving', 'LastJPEGQuality', 75);
  m_LastColorBits    := ReadInteger('Saving', 'LastColorBits',   24);
  m_LastTransparent  := ReadBool('Saving'   , 'LastTransparent',   False);
  m_LastTranspPixel  := ReadInteger('Saving', 'LastTranspPixel',  0);

  // Auto-save
  AutoSaveFolder     := ReadString('AutoSave' , 'AutoSaveFolder'    , m_sPgmDir);
  AutoSaveName       := ReadString('AutoSave' , 'AutoSaveName'      , 'MWSnap');
  AutoSaveNamePrompt := ReadBool('AutoSave'   , 'AutoSaveNamePrompt', False);
  AutoSaveAddSuffix  := ReadBool('AutoSave'   , 'AutoSaveAddSuffix' , True);
  AutoSaveNumFrom    := ReadInteger('AutoSave', 'AutoSaveNumFrom'   , 1);
  AutoSaveNumTo      := ReadInteger('AutoSave', 'AutoSaveNumTo'     , 999);
  AutoSaveAddDate    := ReadBool('AutoSave'   , 'AutoSaveAddDate'   , False);
  AutoSaveDateFormat := ReadString('AutoSave' , 'AutoSaveDateFormat', ' yyyy-mm-dd, hh_nn_ss');
  AutoSaveActive     := ReadBool('AutoSave'   , 'AutoSaveActive'    , False);
  AutoSaveFormat     := ReadString('AutoSave' , 'AutoSaveFormat'    , 'bmp');

  // form size & placement
  frmMain.Width  := ReadInteger('Layout', 'FormWidth',  600);
  frmMain.Height := ReadInteger('Layout', 'FormHeight', 450);
  frmMain.Top    := ReadInteger('Layout', 'FormTop',     20);
  frmMain.Left   := ReadInteger('Layout', 'FormLeft',    20);
  iTmp := ReadInteger('Layout', 'WindowState', 1);
  case iTmp of
    1: frmMain.WindowState := wsNormal;
    2: frmMain.WindowState := wsMaximized;
  else
    frmMain.WindowState := wsNormal;
  end;

  // printing
  GlbGrxPrinter.PrintPos          := ReadInteger('Printing', 'PrintPos         ', 11);
  GlbGrxPrinter.PrintSizMode      := ReadInteger('Printing', 'PrintSizMode     ', 1);
  GlbGrxPrinter.PrintSizScale     := CvtStr2Dbl(ReadString('Printing' , 'PrintSizScale    ', '1.5'));
  GlbGrxPrinter.PrintScaleSmooth  := ReadBool('Printing'   , 'PrintScaleSmooth ', False);
  GlbGrxPrinter.PrintScaleMethod  := ReadInteger('Printing', 'PrintScaleMethod ', 5);
  GlbGrxPrinter.PrintOrtVert      := ReadBool('Printing'   , 'PrintOrtVert     ', True);
  GlbGrxPrinter.PrintHeader       := ReadBool('Printing'   , 'PrintHeader      ', True);
  GlbGrxPrinter.HeaderText        := ReadString('Printing' , 'HeaderText       ', '%n, %d, (%x x %y)');
  GlbGrxPrinter.HeaderOrientation := ReadInteger('Printing', 'HeaderOrientation', 0);
  GlbGrxPrinter.PrintFooter       := ReadBool('Printing'   , 'PrintFooter      ', False);
  GlbGrxPrinter.FooterText        := ReadString('Printing' , 'FooterText       ', '%p');
  GlbGrxPrinter.FooterOrientation := ReadInteger('Printing', 'FooterOrientation', 0);
  GlbGrxPrinter.Copies            := 1;
  AutoPrintActive              := ReadBool('Printing'   , 'AutoPrintActive'  , False);

  // sounds
  SoundOn := ReadBool('Sounds', 'SoundOn', True); // sound signals?
  for iSnd := FirstSound to LastSound do
    SoundsAry[iSnd].SetFromString(ReadString('Sounds', SoundsAry[iSnd].Sound, SoundsAry[iSnd].GetAsString));

  // frames
  GlbAddFrame.SetTypeFromInt(ReadInteger('Frames', 'FrameType', 1));
  GlbAddFrame.SetFromString(ADDFRM_SMP, ReadString('Frames', 'Simple', 'wdt=1, clo=0'));
  GlbAddFrame.SetFromString(ADDFRM_SHD, ReadString('Frames', 'Shaded', 'wdt=7, clo1=65535, clo2=255'));
  GlbAddFrame.SetFromString(ADDFRM_BTN, ReadString('Frames', 'Button', 'wdt=3, clo1=16777215, clo2=8421504'));

  // Internet
  InetUseProxy     := ReadBool   ('Internet', 'AutoSaveActive'  , False);
  InetProxyAddress := ReadString ('Internet', 'InetProxyAddress', '');
  InetProxyPort    := ReadInteger('Internet', 'InetProxyPort'   , 0);

  tabCtl.ActivePageIndex := 0;
end;
//------------------------------------------------------------------------------
procedure TfrmMain.SaveSettings;
var
  i: Integer;
  iSnd: TSounds;
begin
  // Settings
  WriteInteger('Settings', 'DelayTime', DelayTime);
  WriteBool('Settings', 'SnapHidePgm', SnapHidePgm);
  WriteBool('Settings', 'SnapRestPgm', SnapRestPgm);
  WriteBool('Settings', 'AutoCopy', AutoCopy);
  WriteBool('Settings', 'WarnKeys', WarnKeys); // warn at start about conflicting keys
  WriteBool('Settings', 'AskOverwrite', AskOverwrite); // confirm files overwriting
  WriteBool('Options', 'Autostart', Autostart);  // autostart with Windows?
  WriteBool('Options', 'MinimizeToTray', MinimizeToTray);  // minimize to tray?
  WriteBool('Options', 'AlwaysInTray', AlwaysInTray);  // always show icon in tray?
  WriteBool('Options', 'StartMinimized', StartMinimized);  // start in minimized mode?
  WriteBool('Options', 'MarkCrsPos', MarkCrsPos); // mark the cursor position on snap preview
  WriteBool('Options', 'ShowPreviewBox', ShowPreviewBox); // show snap preview window
  WriteString('Options', 'Language', Language);
  WriteInteger('Options', 'AddCursorIdx' , AddCursorIdx);
  WriteInteger('Options', 'TrfType', TrfType); // last used transformation
  WriteInteger('Options', 'SnapCount', SnapCount); // count of performed snaps
  WriteInteger('Options', 'MaxUndoCount', GlbUndo.MaxSteps); // Undo stack size
  WriteBool('Options', 'CloseMinimizes', CloseMinimizes); // minimize on close?

  // Rectangles
  WriteString('Rectangles', 'LastRect', CurrentRect);
  WriteInteger('Rectangles', 'RectCnt', RectSizes.Count);
  for i := 1 to RectSizes.Count do
  begin
    WriteString('Rectangles', 'Rect' + IntToStr(i), RectSizes[i-1]);
  end;

  // Hotkeys
  WriteString('Hotkeys', 'Fixd', HKFixd.GetAsString);
  WriteString('Hotkeys', 'Area', HKArea.GetAsString);
  WriteString('Hotkeys', 'Wind', HKWind.GetAsString);
  WriteString('Hotkeys', 'Desk', HKDesk.GetAsString);
  WriteString('Hotkeys', 'Last', HKLast.GetAsString);

  WriteString('Hotkeys', 'Rulr', HKRulr.GetAsString);
  WriteString('Hotkeys', 'Zoom', HKZoom.GetAsString);
  WriteString('Hotkeys', 'Clop', HKClop.GetAsString);
  WriteString('Hotkeys', 'Info', HKInfo.GetAsString);

  // UI
  WriteInteger('UI', 'ViewPanelCapt', BoolToInt(pnlLeft.Visible   ));
  WriteInteger('UI', 'ViewPanelPict', BoolToInt(pnlPreview.Visible));
  WriteInteger('UI', 'ViewSttBar'   , BoolToInt(sttBar.Visible    ));
  WriteInteger('UI', 'ViewToolbMain', BoolToInt(tlbMain.Visible   ));
  WriteInteger('UI', 'ViewToolbPict', BoolToInt(tlbPicture.Visible));

  // colors
  WriteInteger('Colors', 'Background', scrBoxPreview.Color);
  WriteInteger('Colors', 'Ruler', CloRuler);
  WriteInteger('Colors', 'BkgStyle', BkgStyle);

  // saving
  WriteString('Saving', 'LastSavePath',     LastSavePath);
  WriteInteger('Saving', 'LastFilterIndex', m_LastFilterIndex);
  WriteInteger('Saving', 'LastJPEGQuality', m_LastJPEGQuality);
  WriteInteger('Saving', 'LastColorBits',   m_LastColorBits);
  WriteBool('Saving', 'LastTransparent',    m_LastTransparent);
  WriteInteger('Saving', 'LastTranspPixel', m_LastTranspPixel);

  // Auto-save
  WriteString('AutoSave' , 'AutoSaveFolder'    , AutoSaveFolder    );
  WriteString('AutoSave' , 'AutoSaveName'      , AutoSaveName      );
  WriteBool('AutoSave'   , 'AutoSaveNamePrompt', AutoSaveNamePrompt);
  WriteBool('AutoSave'   , 'AutoSaveAddSuffix' , AutoSaveAddSuffix );
  WriteInteger('AutoSave', 'AutoSaveNumFrom'   , AutoSaveNumFrom   );
  WriteInteger('AutoSave', 'AutoSaveNumTo'     , AutoSaveNumTo     );
  WriteBool('AutoSave'   , 'AutoSaveAddDate'   , AutoSaveAddDate   );
  WriteString('AutoSave' , 'AutoSaveDateFormat', AutoSaveDateFormat);
  WriteBool('AutoSave'   , 'AutoSaveActive'    , AutoSaveActive    );
  WriteString('AutoSave' , 'AutoSaveFormat'    , AutoSaveFormat    );

  // form size
  case frmMain.WindowState of
    wsNormal:
        begin
          WriteInteger('Layout', 'WindowState', 1);
          WriteInteger('Layout', 'FormWidth', frmMain.Width);
          WriteInteger('Layout', 'FormHeight', frmMain.Height);
          WriteInteger('Layout', 'FormTop', frmMain.Top);
          WriteInteger('Layout', 'FormLeft', frmMain.Left);
        end;
    wsMaximized:  // don't save the window size in maximized mode!
        begin
          WriteInteger('Layout', 'WindowState', 2);
        end;
  end;

  // printing
  WriteInteger('Printing', 'PrintPos         ', GlbGrxPrinter.PrintPos);
  WriteInteger('Printing', 'PrintSizMode     ', GlbGrxPrinter.PrintSizMode);
  WriteString('Printing' , 'PrintSizScale    ', FloatToStr(GlbGrxPrinter.PrintSizScale));
  WriteBool('Printing'   , 'PrintScaleSmooth ', GlbGrxPrinter.PrintScaleSmooth);
  WriteInteger('Printing', 'PrintScaleMethod ', GlbGrxPrinter.PrintScaleMethod);
  WriteBool('Printing'   , 'PrintOrtVert     ', GlbGrxPrinter.PrintOrtVert);
  WriteBool('Printing'   , 'PrintHeader      ', GlbGrxPrinter.PrintHeader);
  WriteString('Printing' , 'HeaderText       ', GlbGrxPrinter.HeaderText);
  WriteInteger('Printing', 'HeaderOrientation', GlbGrxPrinter.HeaderOrientation);
  WriteBool('Printing'   , 'PrintFooter      ', GlbGrxPrinter.PrintFooter);
  WriteString('Printing' , 'FooterText       ', GlbGrxPrinter.FooterText);
  WriteInteger('Printing', 'FooterOrientation', GlbGrxPrinter.FooterOrientation);
  WriteBool('Printing'   , 'AutoPrintActive'  , AutoPrintActive);

  // sounds
  WriteBool('Sounds', 'SoundOn', SoundOn); // sound signals?
  for iSnd := FirstSound to LastSound do
    WriteString('Sounds', SoundsAry[iSnd].Sound, SoundsAry[iSnd].GetAsString);

  // frames
  WriteInteger('Frames', 'FrameType', Ord(GlbAddFrame.FrameType));
  WriteString('Frames', 'Simple', GlbAddFrame.GetAsString(ADDFRM_SMP));
  WriteString('Frames', 'Shaded', GlbAddFrame.GetAsString(ADDFRM_SHD));
  WriteString('Frames', 'Button', GlbAddFrame.GetAsString(ADDFRM_BTN));

  // Internet
  WriteBool   ('Internet', 'AutoSaveActive'  , InetUseProxy    );
  WriteString ('Internet', 'InetProxyAddress', InetProxyAddress);
  WriteInteger('Internet', 'InetProxyPort'   , InetProxyPort   );
end;
//------------------------------------------------------------------------------
// Translate the user interface
procedure TfrmMain.TranslateUI;
var
  sBff: String;
begin
  if Language = '???' then // first run - ask for the language
    if DirectoryExists(MakePath(PgmDir, S_LANGDIR)) then
      optLanguageClick(nil);

  CL := loadIni(S_LANGDIR + '\' + Language);
  if CL <> nil then
    fillProps(
               [frmMain, frmSnap, frmSettings, frmHotkeys, frmRuler, frmAbout,
                frmPrint, frmLanguage, frmAddFrame, frmColorInfo, frmSoftwareCheck,
                frmProxySettings],
               CL);
  FixedSizeSelected(nil);
  tbtnCaptureRect.Hint    := btnCaptureRect.Hint;
  tbtnCaptureArea.Hint    := btnCaptureArea.Hint;
  tbtnCaptureWind.Hint    := btnCaptureWind.Hint;
  tbtnCaptureDesktop.Hint := btnCaptureDesktop.Hint;
  tbtnCaptureLast.Hint    := btnCaptureLast.Hint;

  outpopoptCaptureRect.Caption := optCaptureRect.Caption;
  outpopoptCaptureArea.Caption := optCaptureArea.Caption;
  outpopoptCaptureWind.Caption := optCaptureWind.Caption;
  outpopoptCaptureDesk.Caption := optCaptureDesk.Caption;
  outpopoptCaptureLast.Caption := optCaptureLast.Caption;
  outpopoptRuler.Caption       := optRuler.Caption;
  outpopoptZoomer.Caption      := optZoomer.Caption;
  outpopoptColorPicker.Caption := optColorPicker.Caption;
  outpopoptWdwInfo.Caption     := optWdwInfo.Caption;
  outpopoptExit.Caption        := optExit.Caption;

  outpopoptFlipX.Caption       := optFlipX.Caption;
  outpopoptFlipY.Caption       := optFlipY.Caption;
  outpopoptRotateLeft.Caption  := optRotateLeft.Caption;
  outpopoptRotateRight.Caption := optRotateRight.Caption;

  outpopoptFlipX.Hint       := optFlipX.Hint;
  outpopoptFlipY.Hint       := optFlipY.Hint;
  outpopoptRotateLeft.Hint  := optRotateLeft.Hint;
  outpopoptRotateRight.Hint := optRotateRight.Hint;

  outpopoptAddFrameSmp.Caption    := optAddFrameSmp.Caption;
  outpopoptAddFrameShd.Caption    := optAddFrameShd.Caption;
  outpopoptAddFrameBtn.Caption    := optAddFrameBtn.Caption;
  outpopoptAddFrameCancel.Caption := ilMiscStr(rsBtnCancel, 'rsBtnCancel');

  outpopoptAddCursorArrow.Caption     := optAddCursorArrow.Caption;
  outpopoptAddCursorCross.Caption     := optAddCursorCross.Caption;
  outpopoptAddCursorBeam.Caption      := optAddCursorBeam.Caption;
  outpopoptAddCursorSizeNESW.Caption  := optAddCursorSizeNESW.Caption;
  outpopoptAddCursorSizeNS.Caption    := optAddCursorSizeNS.Caption;
  outpopoptAddCursorSizeNWSE.Caption  := optAddCursorSizeNWSE.Caption;
  outpopoptAddCursorSizeWE.Caption    := optAddCursorSizeWE.Caption;
  outpopoptAddCursorUpArrow.Caption   := optAddCursorUpArrow.Caption;
  outpopoptAddCursorHourGlass.Caption := optAddCursorHourGlass.Caption;
  outpopoptAddCursorDrag.Caption      := optAddCursorDrag.Caption;
  outpopoptAddCursorNoDrop.Caption    := optAddCursorNoDrop.Caption;
  outpopoptAddCursorVSplit.Caption    := optAddCursorVSplit.Caption;
  outpopoptAddCursorHSplit.Caption    := optAddCursorHSplit.Caption;
  outpopoptAddCursorMultiDrag.Caption := optAddCursorMultiDrag.Caption;
  outpopoptAddCursorSQLWait.Caption   := optAddCursorSQLWait.Caption;
  outpopoptAddCursorNo.Caption        := optAddCursorNo.Caption;
  outpopoptAddCursorAppStart.Caption  := optAddCursorAppStart.Caption;
  outpopoptAddCursorHelp.Caption      := optAddCursorHelp.Caption;
  outpopoptAddCursorHandPoint.Caption := optAddCursorHandPoint.Caption;
  outpopoptAddCursorSizeAll.Caption   := optAddCursorSizeAll.Caption;
  outpopoptAddCursorCancel.Caption    := ilMiscStr(rsBtnCancel, 'rsBtnCancel');

  sBff := ilMiscStr(rsAllFormats, 'rsAllFormats') + '|*.gif;*.jpg;*.jpeg;*.bmp;*.png;*.ico;*.emf;*.wmf' +
  '|' + ilMiscStr(rsFileTypeGIF , 'rsFileTypeGIF' ) +  ' (*.gif)|*.gif' +
  '|' + ilMiscStr(rsFileTypeJPEG, 'rsFileTypeJPEG') +  ' (*.jpg)|*.jpg;*.jpeg' +
  '|' + ilMiscStr(rsFileTypeBMP , 'rsFileTypeBMP' ) +  ' (*.bmp)|*.bmp' +
  '|' + ilMiscStr(rsFileTypePNG , 'rsFileTypePNG' ) +  ' (*.png)|*.png' +
  '|' + ilMiscStr(rsFileTypeWMF , 'rsFileTypeWMF' ) +  ' (*.wmf)|*.wmf' +
  '|' + ilMiscStr(rsFileTypeICO , 'rsFileTypeICO' ) +  ' (*.ico)|*.ico';
  FilterComboBox.Filter := sBff;

  TrfType := TrfType; // update button hint
  outpopoptTransformCancel.Caption    := ilMiscStr(rsBtnCancel, 'rsBtnCancel');

  // localized message boxes
  LocalizeMessageDlg(dlgMessage);

  UpdateUI; // Update user-interface elements
end;
//------------------------------------------------------------------------------
procedure TfrmMain.LocalizeMessageDlg(mb: TMessageDlg);
var
  tmpLis: TStringList;
begin
  tmpLis := TStringList.Create;
  with tmpLis do
  begin
    Add(ilMiscStr(rsBtnYes,      'rsBtnYes'));
    Add(ilMiscStr(rsBtnNo,       'rsBtnNo'));
    Add(ilMiscStr(rsBtnOk,       'rsBtnOk'));
    Add(ilMiscStr(rsBtnCancel,   'rsBtnCancel'));
    Add(ilMiscStr(rsBtnAbort,    'rsBtnAbort'));
    Add(ilMiscStr(rsBtnRetry,    'rsBtnRetry'));
    Add(ilMiscStr(rsBtnIgnore,   'rsBtnIgnore'));
    Add(ilMiscStr(rsBtnAll,      'rsBtnAll'));
    Add(ilMiscStr(rsBtnNoToAll,  'rsBtnNoToAll'));
    Add(ilMiscStr(rsBtnYesToAll, 'rsBtnYesToAll'));
    Add(ilMiscStr(rsBtnHelp,     'rsBtnHelp'));
  end;
  mb.CustomButtonCaptions := tmpLis;

  tmpLis.Clear;
  with tmpLis do
  begin
    Add(ilMiscStr(rsMsgWarning,     'rsMsgWarning'));
    Add(ilMiscStr(rsMsgError,       'rsMsgError'));
    Add(ilMiscStr(rsMsgInformation, 'rsMsgInformation'));
    Add(ilMiscStr(rsMsgConfirm,     'rsMsgConfirm'));
    Add('');
  end;
  mb.CustomDialogCaptions := tmpLis;
  mb.CheckBoxCaption := ilMiscStr(rsDontShowMessage, 'rsDontShowMessage');
end;
//------------------------------------------------------------------------------
// Localized version of the MessageDlg
function TfrmMain.CstMessageDlg(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint): Word;
begin
  dlgMessage.CheckBox := False;
  Result := dlgMessage.Execute(Msg, DlgType, Buttons, HelpCtx);
end;
//------------------------------------------------------------------------------
// Localized version of the MessageDlg with a checkbox
function TfrmMain.CstMessageDlgChk(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint; ChkSection: String): Word;
begin
  dlgMessage.CheckBox := True;
  dlgMessage.UseRegistry := True;
  dlgMessage.IniFile := S_INIROOT;
  dlgMessage.IniSection := 'DlgCheck';
  dlgMessage.IniItem := ChkSection;
  Result := dlgMessage.Execute(Msg, DlgType, Buttons, HelpCtx);
end;
//------------------------------------------------------------------------------
// Localized version of the ShowMessage
procedure TfrmMain.CstShowMessage(const Msg: string);
begin
  dlgMessage.Execute(Msg, mtInformation, [mbOK], 0);
end;
//------------------------------------------------------------------------------
// Process command line parameters
// Return 'Must terminate' flag.
function TfrmMain.ProcessCmdParams: Boolean;
var
  sPrm: String;
  Params: TStringList;
  i: Integer;
  fTerminate: Boolean;
begin
  fTerminate := False;
  Params := TStringList.Create;
  try
    for i := 1 to ParamCount do
    begin
      sPrm := Trim(ParamStr(i));
      if sPrm[1] in ['-', '/'] then
        sPrm := Copy(sPrm, 2, MaxInt);
      if Length(sPrm) > 0 then
        Params.Add(sPrm);
    end;

    if AnsiCompareText(Params.Values['snap'], 'DESKTOP') = 0 then
    begin
      Application.Minimize;
      DoCapture(SNAP_DESK);
      fTerminate := True;
    end;
  finally
    Params.Free;
  end;

  Result := fTerminate;
end;
//------------------------------------------------------------------------------
// A file is dropped!
procedure TfrmMain.WMDROPFILES(var Message: TWMDROPFILES);
var
  buffer: array[0..255] of Char;
begin
  DragQueryFile(Message.Drop, 0, @buffer, sizeof(buffer)); // only the first one
  DoOpenPicture(buffer);
end;
//------------------------------------------------------------------------------
// LastSavePath property handling
procedure TfrmMain.SetLastSavePath(sPath: String);
begin
  m_LastSavePath := sPath;
  UpdateUI; // Update user-interface elements
end;
//------------------------------------------------------------------------------
// CloBkg property handling
procedure TfrmMain.SetCloBkg(clo: TColor);
begin
  m_CloBkg := clo;
  scrBoxPreview.Color := clo;
end;
//------------------------------------------------------------------------------
// BkgStyle property - background brush style
function TfrmMain.GetBkgStyle: Integer;
var
  iStyle: Integer;
begin
  case scrBoxPreview.Brush.Style of
    bsHorizontal: iStyle := 2;
    bsVertical  : iStyle := 3;
    bsFDiagonal : iStyle := 4;
    bsBDiagonal : iStyle := 5;
    bsCross     : iStyle := 6;
    bsDiagCross : iStyle := 7;
  else
    iStyle := 1;
  end;
  Result := iStyle;
end;
//------------------------------------------------------------------------------
procedure TfrmMain.SetBkgStyle(iStyle: Integer);
begin
  case iStyle of
    2: scrBoxPreview.Brush.Style := bsHorizontal;
    3: scrBoxPreview.Brush.Style := bsVertical;
    4: scrBoxPreview.Brush.Style := bsFDiagonal;
    5: scrBoxPreview.Brush.Style := bsBDiagonal;
    6: scrBoxPreview.Brush.Style := bsCross;
    7: scrBoxPreview.Brush.Style := bsDiagCross;
  else
       scrBoxPreview.Brush.Style := bsSolid;
  end;
  scrBoxPreview.Repaint;
end;
//------------------------------------------------------------------------------
procedure TfrmMain.SetCloseMinimizes(iOn: Boolean);
begin
  m_CloseMinimizes := iOn;
  if m_CloseMinimizes then
    BorderIcons := BorderIcons - [biMinimize]
  else
    BorderIcons := BorderIcons + [biMinimize];
end;
//------------------------------------------------------------------------------
procedure TfrmMain.SetAutoSaveActive(fAuto: Boolean);
begin
  Application.HintHidePause := 5000;
  m_AutoSaveActive := fAuto;
  optAutoSave.Checked := m_AutoSaveActive;
  outtbtnAutoSave.Down := m_AutoSaveActive;
  UpdateUI; // Update user-interface elements
end;
//------------------------------------------------------------------------------
procedure TfrmMain.SetAutoPrintActive(fAuto: Boolean);
begin
  Application.HintHidePause := 5000;
  m_AutoPrintActive := fAuto;
  optAutoPrint.Checked := m_AutoPrintActive;
  outtbtnAutoPrint.Down := m_AutoPrintActive;
  UpdateUI; // Update user-interface elements
end;
//------------------------------------------------------------------------------
// Activate the given language
procedure TfrmMain.SetLanguage(sLanguage: String);
begin
  m_sLanguage := ExtractFileName(sLanguage);
  if fInitDone then
    TranslateUI;
end;
//------------------------------------------------------------------------------
procedure TfrmMain.optAutoSaveClick(Sender: TObject);
begin
  AutoSaveActive := not AutoSaveActive;
  SaveSettings;
end;
//------------------------------------------------------------------------------
procedure TfrmMain.optAutoPrintClick(Sender: TObject);
begin
  AutoPrintActive := not AutoPrintActive;
  SaveSettings;
end;
//------------------------------------------------------------------------------
function TfrmMain.GetAutostart: Boolean;
begin
  Result := rlAutostart.autostart;
end;
//------------------------------------------------------------------------------
procedure TfrmMain.SetAutostart(fAuto: Boolean);
begin
  rlAutostart.autostart := fAuto;
end;
//------------------------------------------------------------------------------
function TfrmMain.GetMinimizeToTray: Boolean;
begin
  Result := CoolTrayIcon.MinimizeToTray;
end;
//------------------------------------------------------------------------------
procedure TfrmMain.SetMinimizeToTray(fUse: Boolean);
begin
  CoolTrayIcon.MinimizeToTray := fUse;
end;
//------------------------------------------------------------------------------
function TfrmMain.GetAlwaysInTray: Boolean;
begin
  Result := CoolTrayIcon.IconVisible;
end;
//------------------------------------------------------------------------------
procedure TfrmMain.SetAlwaysInTray(fAlways: Boolean);
begin
  CoolTrayIcon.IconVisible := fAlways;
end;
//------------------------------------------------------------------------------
// Handle resizing
procedure TfrmMain.FormResize(Sender: TObject);
begin
  with sttBar do
    Panels[0].Width := Width - Panels[1].Width - Panels[2].Width;
end;
//------------------------------------------------------------------------------
// Update user-interface elements
procedure TfrmMain.UpdateUI;
var
  sHint: String;
begin
  // buttons activity
  optSaveAs.Enabled := (imgPreview.Picture.Bitmap.Width > 0);

  btnZoomIn.Enabled := optSaveAs.Enabled;
  btnZoomOut.Enabled := optSaveAs.Enabled;
  btnZoomReset.Enabled := optSaveAs.Enabled;

  btnSaveAs.Enabled := optSaveAs.Enabled;
  optPrint.Enabled := optSaveAs.Enabled;
  tbtnPrint.Enabled := optSaveAs.Enabled;
  optCopy.Enabled := optSaveAs.Enabled;
  btnCopy.Enabled := optSaveAs.Enabled;
  optAddFixedSize.Enabled := optSaveAs.Enabled;
  btnAddFixedSize.Enabled := optSaveAs.Enabled;

  optTransform.Enabled := optSaveAs.Enabled;
  outbtnTransform.Enabled := optSaveAs.Enabled;

  optAddFrame.Enabled := optSaveAs.Enabled;
  optAddCursor.Enabled := optSaveAs.Enabled;
  btnAddFrame.Enabled := optSaveAs.Enabled;
  btnAddCursor.Enabled := optSaveAs.Enabled;

  optUndo.Enabled := GlbUndo.UndoPossible;
  btnUndo.Enabled := optUndo.Enabled;

  optRedo.Enabled := GlbUndo.RedoPossible;
  btnRedo.Enabled := optRedo.Enabled;

  case GlbAddFrame.FrameType of
    ADDFRM_SMP: optAddFrame.ImageIndex := optAddFrameSmp.ImageIndex; // simple frame
    ADDFRM_SHD: optAddFrame.ImageIndex := optAddFrameShd.ImageIndex; // shaded frame
    ADDFRM_BTN: optAddFrame.ImageIndex := optAddFrameBtn.ImageIndex; // buttonize
  end;
  btnAddFrame.ImageIndex := optAddFrame.ImageIndex;

  // UI items visibility
  optViewCaptPanel.Checked  := pnlLeft.Visible;
  optViewSttBar.Checked     := sttBar.Visible;
  optViewTlbMain.Checked    := tlbMain.Visible;
  optViewTlbPicture.Checked := pnlPreviewButtons.Visible;

  // show form caption
  if optSaveAs.Enabled then
    Caption := 'MWSnap - ' + ExtractFileName(m_LastSavePath)
  else
    Caption := 'MWSnap ' + lblVsn.GetLabelText + iifs(IsBeta, ' Beta', '');
  CoolTrayIcon.Hint := Caption;
  Application.Hint := Caption;
  Application.Title := Caption;

  // update autosaving tooltip
  if m_AutoSaveActive then
  begin
    sHint := ilMiscStr(rsAutoSaveON, 'rsAutoSaveON') + ' (' + AutoSaveFormat + ')' + S_CRLF;
    sHint := sHint + ilMiscStr(rsFolder, 'rsFolder') + ': ' + AutoSaveFolder + S_CRLF;
    if AutoSaveNamePrompt then
      sHint := sHint + ilMiscStr(rsAutoSaveNamePromptON, 'rsAutoSaveNamePromptON') + S_CRLF
    else
    begin
      sHint := sHint + ilMiscStr(rsAutoSaveNextName, 'rsAutoSaveNextName') + ': ' + AutoSaveName;
      if AutoSaveAddSuffix then
      begin
        sHint := sHint + LPad(IntToStr(AutoSaveNumFrom), Length(IntToStr(AutoSaveNumTo)), '0');
      end;
      if AutoSaveAddDate then
      begin
        sHint := sHint + FormatDateTime(AutoSaveDateFormat, Now());
      end;
    end;

    sHint := sHint + '|' + ilMiscStr(rsAutoSaveON, 'rsAutoSaveON');
    outtbtnAutoSave.Hint := sHint;
  end
  else
  begin
    outtbtnAutoSave.Hint := ilMiscStr(rsAutoSaveOFF, 'rsAutoSaveOFF') + '|' + ilMiscStr(rsAutoSaveOFF, 'rsAutoSaveOFF');
  end;

  // update autoprinting tooltip
  if m_AutoPrintActive then
    outtbtnAutoPrint.Hint := ilMiscStr(rsAutoPrintON, 'rsAutoPrintON')
  else
    outtbtnAutoPrint.Hint := ilMiscStr(rsAutoPrintOFF, 'rsAutoPrintOFF');

  // the status bar
  sttBar.Panels[1].Text := FloatToStr(Round(ZoomStep * 100)) + '%';
  sttBar.Panels[2].Text := IntToStr(imgPreview.Picture.Bitmap.Width) + 'x' +
                           IntToStr(imgPreview.Picture.Bitmap.Height);

  case DynState of
    DS_NORMAL: sttBar.Panels[0].Text := ilMiscStr(rsDynStateNormal, 'rsDynStateNormal'); // Ready
    DS_CURSOR: sttBar.Panels[0].Text := ilMiscStr(rsDynStateCursor, 'rsDynStateCursor'); // Define the cursor image insertion point, <Esc> to cancel...
  end;

end;
//------------------------------------------------------------------------------
// handle hotkeys
procedure TfrmMain.WMHotKey(var Msg: TWMHotKey);
begin
  case (Msg.HotKey) of
    100 + Ord(SNAP_RECT): optCaptureRectClick(Nil);
    100 + Ord(SNAP_AREA): optCaptureAreaClick(Nil);
    100 + Ord(SNAP_DESK): optCaptureDeskClick(Nil);
    100 + Ord(SNAP_WIND): optCaptureWindClick(Nil);
    100 + Ord(SNAP_LAST): optCaptureLastClick(Nil);

    100 + Ord(SNAP_RULR): optRulerClick(Nil);
    100 + Ord(SNAP_ZOOM): optZoomerClick(Nil);
    100 + Ord(SNAP_CLOP): optColorPickerClick(Nil);
    100 + Ord(SNAP_INFO): optWdwInfoClick(Nil);
  end;
end;
//------------------------------------------------------------------------------
// Return the current rectangle size as a string
function TfrmMain.CurrentRect: String;
begin
  CurrentRect := IntToStr(spnRectDX.Position) + 'x' + IntToStr(spnRectDY.Position);
end;
//------------------------------------------------------------------------------
// Any rectangle size selected
procedure TfrmMain.RectSizeSelected(sText: String);
var
  dx, dy: Integer;
begin
  SplitSizeString(sText, dx, dy);
  if (dx > 0) and (dy > 0) then
  begin
    spnRectDX.Position := dx;
    spnRectDY.Position := dy;
  end;
end;
//------------------------------------------------------------------------------
// That's all, folks!
procedure TfrmMain.optExitClick(Sender: TObject);
begin
  m_SessionEnding := True; // allow the program to terminate
//  Application.Terminate;
  Close; // calls OnClose which saves settings
end;
//------------------------------------------------------------------------------
// Copy the bitmap to the clipboard
procedure TfrmMain.optCopyClick(Sender: TObject);
begin
  Clipboard.Assign(TheBmp);
  PlayOneSound(sndCLIPCOPY);
end;
//------------------------------------------------------------------------------
// Paste the bitmap from the clipboard
procedure TfrmMain.optPasteClick(Sender: TObject);
begin
  if Clipboard.HasFormat(CF_BITMAP) then
  begin
    try
      TheBmp.Assign(Clipboard);
      imgPreview.Picture.Assign(TheBmp);
      ZoomStep := 1.0;
      PlayOneSound(sndCLIPPASTE);
    finally
      ;
    end;
  end
  else
    CstMessageDlg(ilMiscStr(rsNoBmpOnClip, 'rsNoBmpOnClip'),
                  mtInformation, [mbOK], 0);
end;
//------------------------------------------------------------------------------
// In case a file exists confirm overwriting
function TfrmMain.CheckOverwriteFile(const sFileName: String): Boolean;
begin
  Result := True;
  if AskOverwrite and FileExists(sFileName) then
    Result := CstMessageDlg(Format(ilMiscStr(rsFileExistsOverwrite, 'rsFileExistsOverwrite'), [sFileName]),
                            mtConfirmation, [mbYes,mbNo,mbCancel], 0) = mrYes;
end;
//------------------------------------------------------------------------------
// Save snapped graphics to the disk file as a JPEG file with the
// specified quality
procedure TfrmMain.SaveJPEG(sFileName: String; iQuality: Integer);
var
  jpg: TJpegImage;
begin
  if not CheckOverwriteFile(sFileName) then
    Exit;

  jpg := TJpegImage.Create;
  try
    jpg.Assign(TheBmp);
    jpg.CompressionQuality := iQuality;
    jpg.Compress;
    jpg.SaveToFile(sFileName);
    if FileExists(sFileName) then
    begin
      LastSavePath := sFileName; // last path for saving
      PlayOneSound(sndSAVE);
      UpdateFMFileListBox(True); // refresh the list of files
    end;
  finally
    jpg.Free;
  end;
end;
//------------------------------------------------------------------------------
// Save snapped graphics to the disk file as a BMP file with the
// specified color depth
procedure TfrmMain.SaveBMP(sFileName: String; iFormat: Integer);
var
  bmp: TBitmap;
  jpeg : TJPEGImage;
begin
  if not CheckOverwriteFile(sFileName) then
    Exit;

  bmp := TBitmap.Create;
  jpeg := TJPEGImage.Create;

  try
    if (iFormat = 8) then // 256 colors
    begin
      bmp.PixelFormat := pf8bit;
      jpeg.CompressionQuality := 100;
      jpeg.Assign(TheBmp);
      jpeg.JPEGNeeded;
      jpeg.PixelFormat := jf8bit;
      jpeg.DibNeeded;
      bmp.Assign(jpeg);
    end
    else
    begin
      bmp.Assign(TheBmp);
      case iFormat of
         1: bmp.PixelFormat := pf1bit;
         4: bmp.PixelFormat := pf4bit;
         8: bmp.PixelFormat := pf8bit;
        15: bmp.PixelFormat := pf15bit;
        16: bmp.PixelFormat := pf15bit; // there is a bug in Delphi 5 with pf16bit
        24: bmp.PixelFormat := pf24bit;
        32: bmp.PixelFormat := pf32bit;
      else
        bmp.PixelFormat := pf24bit;
      end;
    end;

    bmp.SaveToFile(sFileName);
    if FileExists(sFileName) then
    begin
      LastSavePath := sFileName; // last path for saving
      PlayOneSound(sndSAVE);
      UpdateFMFileListBox(True); // refresh the list of files
    end;

  finally
    bmp.Free;
    jpeg.Free;
  end;

{
  try
    bmp.Assign(TheBmp);
    case iFormat of
       1: bmp.PixelFormat := pf1bit;
       4: bmp.PixelFormat := pf4bit;
       8: bmp.PixelFormat := pf8bit;
      15: bmp.PixelFormat := pf15bit;
      16: bmp.PixelFormat := pf16bit;
      24: bmp.PixelFormat := pf24bit;
      32: bmp.PixelFormat := pf32bit;
    else
      bmp.PixelFormat := pf24bit;
    end;
    bmp.SaveToFile(sFileName);
    if FileExists(sFileName) then
      PlayOneSound(sndSAVE);
  finally
    bmp.Free;
  end;
}
end;
//------------------------------------------------------------------------------
// Save snapped graphics to the disk file as a TIFF file with the
// specified color depth
procedure TfrmMain.SaveTIFF(sFileName: String; iFormat: Integer);
var
  bmp: TBitmap;
begin
  if not CheckOverwriteFile(sFileName) then
    Exit;

  bmp := TBitmap.Create;
  try
    bmp.Assign(TheBmp);
    case iFormat of
       1: bmp.PixelFormat := pf1bit;
       4: bmp.PixelFormat := pf4bit;
       8: bmp.PixelFormat := pf8bit;
      16: bmp.PixelFormat := pf16bit;
      24: bmp.PixelFormat := pf24bit;
      32: bmp.PixelFormat := pf32bit;
    else
      bmp.PixelFormat := pf24bit;
    end;
    WriteTiffToFile(sFileName, bmp);
    if FileExists(sFileName) then
    begin
      LastSavePath := sFileName; // last path for saving
      PlayOneSound(sndSAVE);
      UpdateFMFileListBox(True); // refresh the list of files
    end;
  finally
    bmp.Free;
  end;
end;
//------------------------------------------------------------------------------
// Save snapped graphics to the disk file as a GIF file
procedure TfrmMain.SaveGIF(sFileName: String; fTransp: Boolean; iTransPix: Integer);
var
  GIFImage: TGIFImage;
  Ext: TGIFGraphicControlExtension;
  idx: Integer;
begin
  if not CheckOverwriteFile(sFileName) then
    Exit;

  GIFImage := TGIFImage.Create;
  try
    GIFImage.ColorReduction := rmQuantizeWindows;
    GIFImage.DitherMode := dmFloydSteinberg;

    idx := GIFImage.Add(TheBmp); // Convert the bitmap to a GIF
    GIFImage.Transparent := fTransp;
    // Optimize palette to remove unused entries from windows palette
    GIFImage.Images[idx].ColorMap.Optimize;
    if (fTransp) then
    begin
      Ext := TGIFGraphicControlExtension.Create(GIFImage.Images[idx]);
      GIFImage.Images[idx].Extensions.Add(Ext);
      Ext.Transparent := True;
      Ext.Disposal := dmBackground;

      case iTransPix of
        1:   Ext.TransparentColor := TheBmp.Canvas.Pixels[TheBmp.Width-1, 0]; // right top
        2:   Ext.TransparentColor := TheBmp.Canvas.Pixels[0, TheBmp.Height-1]; // left bottom
        3:   Ext.TransparentColor := TheBmp.Canvas.Pixels[TheBmp.Width-1, TheBmp.Height-1]; // right bottom
        else Ext.TransparentColor := TheBmp.Canvas.Pixels[0, 0]; // left top or error
      end;
    end;

    GIFImage.SaveToFile(sFileName); // Save the GIF
    if FileExists(sFileName) then
    begin
      LastSavePath := sFileName; // last path for saving
      PlayOneSound(sndSAVE);
      UpdateFMFileListBox(True); // refresh the list of files
    end;
  finally
    GIFImage.Free;
  end;
end;
//------------------------------------------------------------------------------
// Save snapped graphics to the disk file as a PNG file
procedure TfrmMain.SavePNG(sFileName: String; fTransp: Boolean; iTransPix: Integer);
var
  png: TPNGImage;
begin
  if not CheckOverwriteFile(sFileName) then
    Exit;

  png := TPNGImage.Create;
  try
    png.Assign(TheBmp); // Convert the bitmap to a PNG
{
    if (fTransp) then
    begin
      png.Transparent := True;
      case iTransPix of
        1:   png.TransparentColor := TheBmp.Canvas.Pixels[TheBmp.Width-1, 0]; // right top
        2:   png.TransparentColor := TheBmp.Canvas.Pixels[0, TheBmp.Height-1]; // left bottom
        3:   png.TransparentColor := TheBmp.Canvas.Pixels[TheBmp.Width-1, TheBmp.Height-1]; // right bottom
        else png.TransparentColor := TheBmp.Canvas.Pixels[0, 0]; // left top or error
      end;
    end;
}
    png.SaveToFile(sFileName); // Save the PNG
    if FileExists(sFileName) then
    begin
      LastSavePath := sFileName; // last path for saving
      PlayOneSound(sndSAVE);
      UpdateFMFileListBox(True); // refresh the list of files
    end;
  finally
    png.Free;
  end;
end;
//------------------------------------------------------------------------------
// Save snapped graphics to the disk file
procedure TfrmMain.optSaveAsClick(Sender: TObject);
var
  savDlg: TMySaveDlg;
  sBff: String;
begin
  savDlg := TMySaveDlg.Create(frmMain);
  savDlg.Filter :=       ilMiscStr(rsFileTypeBMP , 'rsFileTypeBMP' ) +  ' (*.bmp)|*.bmp' +
                   '|' + ilMiscStr(rsFileTypeJPEG, 'rsFileTypeJPEG') +  ' (*.jpg)|*.jpg' +
                   '|' + ilMiscStr(rsFileTypeGIF , 'rsFileTypeGIF' ) +  ' (*.gif)|*.gif' +
                   '|' + ilMiscStr(rsFileTypePNG , 'rsFileTypePNG' ) +  ' (*.png)|*.png' +
                   '|' + ilMiscStr(rsFileTypeTIFF, 'rsFileTypeTIFF') +  ' (*.tif)|*.tif';

  savDlg.FilterIndex := m_LastFilterIndex;
  savDlg.Quality     := m_LastJPEGQuality;
  savDlg.ColorBits   := m_LastColorBits;
  savDlg.Transparent := m_LastTransparent;
  savDlg.TranspPixel := m_LastTranspPixel;

  savDlg.txtParameters  := ilMiscStr(rsSaveAsParameters, 'rsSaveAsParameters');
  savDlg.txtQuality     := ilMiscStr(rsSaveAsQuality, 'rsSaveAsQuality') + ':';
  savDlg.txtColorBits   := ilMiscStr(rsSaveAsColorBits, 'rsSaveAsColorBits');
  savDlg.txtTransparent := ilMiscStr(rsSaveAsTransparent, 'rsSaveAsTransparent');
  savDlg.txtTranspPixel := ilMiscStr(rsSaveAsTranspPixel, 'rsSaveAsTranspPixel') + ':';

  savDlg.txt1bit   := ilMiscStr(rsSaveAs1bit  , 'rsSaveAs1bit');
  savDlg.txt4bits  := ilMiscStr(rsSaveAs4bits , 'rsSaveAs4bits');
  savDlg.txt8bits  := ilMiscStr(rsSaveAs8bits , 'rsSaveAs8bits');
  savDlg.txt15bits := ilMiscStr(rsSaveAs15bits, 'rsSaveAs15bits');
  savDlg.txt16bits := ilMiscStr(rsSaveAs16bits, 'rsSaveAs16bits');
  savDlg.txt24bits := ilMiscStr(rsSaveAs24bits, 'rsSaveAs24bits');
  savDlg.txt32bits := ilMiscStr(rsSaveAs32bits, 'rsSaveAs32bits');

  savDlg.txtLeftTop     := ilMiscStr(rsSaveAsLeftTop    , 'rsSaveAsLeftTop');
  savDlg.txtRightTop    := ilMiscStr(rsSaveAsRightTop   , 'rsSaveAsRightTop');
  savDlg.txtLeftBottom  := ilMiscStr(rsSaveAsLeftBottom , 'rsSaveAsLeftBottom');
  savDlg.txtRightBottom := ilMiscStr(rsSaveAsRightBottom, 'rsSaveAsRightBottom');
  savDlg.txtCenter      := ilMiscStr(rsSaveAsCenter     , 'rsSaveAsCenter');


  savDlg.InitialDir := ExtractFilePath(LastSavePath); // last path for saving
  savDlg.FileName := ExtractFileName(LastSavePath); // default name
  if savDlg.Execute then
  begin
    m_LastFilterIndex := savDlg.FilterIndex;
    m_LastJPEGQuality := savDlg.Quality;
    m_LastColorBits := savDlg.ColorBits;
    m_LastTranspPixel := savDlg.TranspPixel;
    m_LastTransparent := savDlg.Transparent;
    try
      case savDlg.FilterIndex of
        1: // bmp
           SaveBMP(ChangeFileExt(savDlg.FileName, '.bmp'), savDlg.ColorBits);
        2: // jpeg
           SaveJPEG(ChangeFileExt(savDlg.FileName, '.jpg'), savDlg.Quality);
        3: // gif
           SaveGIF(ChangeFileExt(savDlg.FileName, '.gif'), savDlg.Transparent, savDlg.TranspPixel);
        4: // png
           SavePNG(ChangeFileExt(savDlg.FileName, '.png'), savDlg.Transparent, savDlg.TranspPixel);
        5: // tiff
           SaveTIFF(ChangeFileExt(savDlg.FileName, '.tif'), savDlg.ColorBits);
      else
        SaveBMP(ChangeFileExt(savDlg.FileName, '.bmp'), savDlg.ColorBits);
      end;
    except
      on E: Exception do
      begin
        PlayOneSound(sndERROR);
        sBff := Format(ilMiscStr(rsErrFileSave, 'rsErrFileSave'), [savDlg.FileName, E.Message]);
        CstShowMessage(sBff);
      end;
    end;
  end;
end;
//------------------------------------------------------------------------------
// Perform auto-save
procedure TfrmMain.DoAutoSave;
var
  sNum, sPath, sName, sBff: String;
begin
  if AutoSaveNamePrompt then  // ask for the name
  begin
    sName := ExtractFileName(LastSavePath); // default name
    sName := ChangeFileExt(sName, '');
    if not InputQuery(AutoSaveFolder,
                      ilMiscStr(rsEnterFileNameNoPath, 'rsEnterFileNameNoPath'),
                      sName) then
      Exit;
  end
  else // use the predefined name
  begin
    sName := AutoSaveName;

    if AutoSaveAddSuffix then
    begin
      if AutoSaveNumFrom >= AutoSaveNumTo then
        AutoSaveNumFrom := 1;
      sNum := IntToStr(AutoSaveNumFrom);
      sNum := LPad(sNum, Length(IntToStr(AutoSaveNumTo)), '0');
      sName := sName + sNum;
      AutoSaveNumFrom := AutoSaveNumFrom + 1;
    end;

    if AutoSaveAddDate then
    begin
      sName := sName + FormatDateTime(AutoSaveDateFormat, Now());
    end;
  end;

  sName := ValidFileName(sName);
  if Length(sName) > 0 then
  begin
    try
      sPath := MakePath(AutoSaveFolder, sName);

      if frmMain.AutoSaveFormat = 'jpeg' then
      begin
        sPath := ChangeFileExt(sPath, '.jpg');
        SaveJPEG(sPath, m_LastJPEGQuality);
      end
      else if frmMain.AutoSaveFormat = 'tiff' then
      begin
        sPath := ChangeFileExt(sPath, '.tif');
        SaveTIFF(sPath, m_LastColorBits);
      end
      else if frmMain.AutoSaveFormat = 'gif' then
      begin
        sPath := ChangeFileExt(sPath, '.gif');
        SaveGIF(sPath, m_LastTransparent, m_LastTranspPixel);
      end
      else if frmMain.AutoSaveFormat = 'png' then
      begin
        sPath := ChangeFileExt(sPath, '.png');
        SavePNG(sPath, m_LastTransparent, m_LastTranspPixel);
      end
      else
      begin
        sPath := ChangeFileExt(sPath, '.bmp');
        SaveBMP(sPath, m_LastColorBits);
      end;

      LastSavePath := sPath; // last path for saving
      sttBar.Panels[0].Text := ilMiscStr(rsAutoSavedTo, 'rsAutoSavedTo') + ' ' + sPath;
    except
      on E: Exception do
      begin
        sBff := Format(ilMiscStr(rsErrFileSave, 'rsErrFileSave'), [sPath, E.Message]);
        CstShowMessage(sBff);
      end;
    end;
  end;
end;
//------------------------------------------------------------------------------
// Load the picture from the specified disk file
procedure TfrmMain.DoOpenPicture(sFileName: String);
var
  tmpIcon: TIcon;
begin
  try
    GlbUndo.Add(TheBmp, False); // add to undo

    imgPreview.Picture.Graphic := nil;
    imgPreview.Left := 0;
    imgPreview.Top  := 0;

    if (AnsiUpperCase(ExtractFileExt(sFileName)) = '.ICO') then
    begin
      tmpIcon := TIcon.Create;
      try
        tmpIcon.LoadFromFile(sFileName);
        TheBmp.Width := tmpIcon.Width;
        TheBmp.Height := tmpIcon.Height;
        TheBmp.Canvas.FillRect(Rect(0, 0, TheBmp.Width, TheBmp.Height));
        TheBmp.Canvas.Draw(0, 0, tmpIcon);
      finally
        tmpIcon.Free;
      end;
    end
    else if (    (AnsiUpperCase(ExtractFileExt(sFileName)) = '.WMF')
              or (AnsiUpperCase(ExtractFileExt(sFileName)) = '.EMF')) then
    begin
      imgPreview.Picture.LoadFromFile(sFileName);
      TheBmp.Width := imgPreview.Picture.Metafile.Width;
      TheBmp.Height := imgPreview.Picture.Metafile.Height;
      TheBmp.Canvas.FillRect(Rect(0, 0, TheBmp.Width, TheBmp.Height));
      TheBmp.Canvas.Draw(0, 0, imgPreview.Picture.Metafile);
    end
    else // all other formats contain a bitmap
    begin
      imgPreview.Picture.LoadFromFile(sFileName);
      TheBmp.Assign(imgPreview.Picture.Graphic);
    end;
    imgPreview.Picture.Bitmap.Assign(TheBmp);
    SetZoomStep(1.0);

    LastSavePath := sFileName; // last path for saving
  except
    on EInvalidGraphic do
      imgPreview.Picture.Graphic := nil;
  end;
end;
//------------------------------------------------------------------------------
// Open a picture from a disk file
procedure TfrmMain.optOpenClick(Sender: TObject);
begin
  if dlgOpenPicture.Execute then
    DoOpenPicture(dlgOpenPicture.FileName);
end;
//------------------------------------------------------------------------------
// Print
procedure TfrmMain.optPrintClick(Sender: TObject);
begin
  frmPrint.ShowModal;
end;
//------------------------------------------------------------------------------
procedure TfrmMain.optAboutClick(Sender: TObject);
begin
  frmAbout.ShowModal;
end;
//------------------------------------------------------------------------------
// Prepare the sizes popup menu
procedure TfrmMain.popupRectSizesPopup(Sender: TObject);
begin
  FillSizesPopup; // update the popup menu
end;
//------------------------------------------------------------------------------
// Update the sizes menu items
procedure TfrmMain.FillSizesPopup;
var
  mnu: TMenuItem;
  i: Integer;
begin
    while popupRectSizes.Items.Count > 0 do
      popupRectSizes.Items.Delete(0);

    for i := 0 to RectSizes.Count - 1 do
    begin
      mnu := TMenuItem.Create(Self);
      mnu.OnClick := optRectSizeClick;
      mnu.Caption := RectSizes.Strings[i];
      mnu.Tag := i;
      if RectSizes.Strings[i] = CurrentRect() then
        mnu.Checked := True;
      popupRectSizes.Items.Add(mnu);
    end;

    mnu := TMenuItem.Create(Self);
    mnu.Caption := '-';
    popupRectSizes.Items.Add(mnu);

    mnu := TMenuItem.Create(Self);
    mnu.Caption := ilMiscStr(rsOptCancel, 'rsOptCancel');
    popupRectSizes.Items.Add(mnu);
end;
//------------------------------------------------------------------------------
// Pop the rect sizes menu
procedure TfrmMain.btnRectSizesClick(Sender: TObject);
begin
  popupRectSizes.Popup(Mouse.CursorPos.x, Mouse.CursorPos.y);
end;
//------------------------------------------------------------------------------
// One fixed size has been selected from the list
procedure TfrmMain.optRectSizeClick(Sender: TObject);
begin
  RectSizeSelected(TMenuItem(Sender).Caption);
end;
//------------------------------------------------------------------------------
// Fixed size has changed, update the tooltip
procedure TfrmMain.FixedSizeSelected(Sender: TObject);
begin
  btnCaptureRect.Hint := Format(ilMiscStr(rsCaptureRectHint, 'rsCaptureRectHint'), [CurrentRect()]);
  tbtnCaptureRect.Hint := btnCaptureRect.Hint;
end;
//------------------------------------------------------------------------------
// Delay
procedure TfrmMain.Delay(msecs:integer);
var
  FirstTickCount:longint;
begin
  FirstTickCount:=GetTickCount;
  repeat
    Application.ProcessMessages;
  until (Longint(GetTickCount)-FirstTickCount >= Longint(msecs));
end;
//------------------------------------------------------------------------------
// Add a new fixed size to the list. Place it at the top.
procedure TfrmMain.AddFixedSize(dx, dy: Integer);
var
  idx: Integer;
begin
  // set the new size to both x,y fields
  spnRectDX.Position := dx;
  spnRectDY.Position := dy;

  // check, if this size has already existed
  idx := RectSizes.IndexOf(CurrentRect);
  if idx >= 0 then RectSizes.Delete(idx);

  // now add it at the beginning
  RectSizes.Insert(0, CurrentRect);
end;
//------------------------------------------------------------------------------
// Snap a fixed-size rectangular area
procedure TfrmMain.optCaptureRectClick(Sender: TObject);
begin
  // add/move this size to the top of the list
  AddFixedSize(spnRectDX.Position, spnRectDY.Position);

  // now perform snapping
  frmSnap.dx := spnRectDX.Position;
  frmSnap.dy := spnRectDY.Position;
  DoCapture(SNAP_RECT);
end;
//------------------------------------------------------------------------------
// Perform the specified capture
procedure TfrmMain.DoCapture(typ: TSnapMode);
var
  didHide: Boolean;
  dc: HDC;
begin
  didHide := False;
  if (not IsIconic(Application.Handle)) and SnapHidePgm then // hide before snapping
  begin
    didHide := True;
    CoolTrayIcon.HideMainForm;
    Delay(DelayTime);
    Application.ProcessMessages;
  end
  else
  begin
    Delay(100);
    Application.ProcessMessages;
  end;

  if typ in [SNAP_WIND, SNAP_INFO] then
  begin
    EnumAllWindows; // we need a list of all windows
  end;
  frmSnap.mode := typ;

  // get the bitmap out of the whole desktop
  TheBmp.Width  := Screen.Width;
  TheBmp.Height := Screen.Height;
  dc := GetDC(0);
  BitBlt(frmMain.TheBmp.Canvas.handle, 0, 0, Screen.Width, Screen.Height, dc, 0, 0, srcCopy);
  ReleaseDC(0, dc);

  if frmSnap.Visible then
    frmSnap.Close;

  if (typ = SNAP_DESK) or (frmSnap.ShowModal = mrOk) then // snap it
  begin
    SnapCount := SnapCount + 1;
    GlbUndo.Add(imgPreview.Picture.Bitmap, False); // add to undo

    PlayOneSound(sndSNAP);
    imgPreview.Picture.Bitmap.Assign(TheBmp);
    SetZoomStep(1.0);

    btnCaptureLast.Enabled := True;

    // check, if it's a new size
    optAddFixedSize.Enabled := RectSizes.IndexOf(sttBar.Panels[1].Text) < 0;
    btnAddFixedSize.Enabled := optAddFixedSize.Enabled;

    if AutoCopy then     // auto copy to clipboard
      optCopyClick(Nil);

    if AutoSaveActive then // auto save
      DoAutoSave
    else
      LastSavePath := MakePath(ExtractFilePath(LastSavePath), ilMiscStr(rsNoname, 'rsNoname'));

    if AutoPrintActive then // auto print
      GlbGrxPrinter.DoPrint;
  end;

  if didHide or SnapRestPgm then
  begin
    CoolTrayIcon.ShowMainForm;
    Application.BringToFront;
    BringToFront;
    m_IsMinimized := False;
  end;

end;
//------------------------------------------------------------------------------
// Snap an area of any size
procedure TfrmMain.optCaptureAreaClick(Sender: TObject);
begin
  DoCapture(SNAP_AREA);
end;
//------------------------------------------------------------------------------
procedure TfrmMain.optCaptureWindClick(Sender: TObject);
begin
  DoCapture(SNAP_WIND);
end;
//------------------------------------------------------------------------------
// Capture the whole desktop
procedure TfrmMain.optCaptureDeskClick(Sender: TObject);
begin
  DoCapture(SNAP_DESK);
end;
//------------------------------------------------------------------------------
// Repeat last capture
procedure TfrmMain.optCaptureLastClick(Sender: TObject);
begin
  DoCapture(SNAP_LAST);
end;
//------------------------------------------------------------------------------
// Open the Hotkeys dialog
procedure TfrmMain.optSetHotkeysClick(Sender: TObject);
begin
  frmHotkeys.ShowModal;
  SaveSettings;
end;
//------------------------------------------------------------------------------
// Open the settings dialog
procedure TfrmMain.optSettingsClick(Sender: TObject);
begin
  frmSettings.ShowModal;
  SaveSettings;
end;
//------------------------------------------------------------------------------
// View menu items
procedure TfrmMain.optViewCaptPanelClick(Sender: TObject);
begin
  pnlLeft.Visible := not pnlLeft.Visible;
  UpdateUI; // update menu option checked status
end;
procedure TfrmMain.optViewSttBarClick(Sender: TObject);
begin
  sttBar.Visible := not sttBar.Visible;
  UpdateUI; // update menu option checked status
end;
procedure TfrmMain.optViewTlbMainClick(Sender: TObject);
begin
  tlbMain.Visible := not tlbMain.Visible;
  UpdateUI; // update menu option checked status
end;
procedure TfrmMain.optViewTlbPictureClick(Sender: TObject);
begin
  pnlPreviewButtons.Visible := not pnlPreviewButtons.Visible;
  UpdateUI; // update menu option checked status
end;
procedure TfrmMain.optViewAllClick(Sender: TObject);
begin
  sttBar.Visible := True;
  tlbMain.Visible := True;
  pnlLeft.Visible := True;
  pnlPreviewButtons.Visible := True;
  UpdateUI; // update menu option checked status
end;
procedure TfrmMain.optViewNoneClick(Sender: TObject);
begin
  sttBar.Visible := False;
  tlbMain.Visible := False;
  pnlLeft.Visible := False;
  pnlPreviewButtons.Visible := False;
  UpdateUI; // update menu option checked status
end;
//------------------------------------------------------------------------------
// Toggle the 'stretched' mode
procedure TfrmMain.optStretchedClick(Sender: TObject);
begin
//  imgPreview.Stretch := not imgPreview.Stretch;
//  if imgPreview.Stretch then // fit it inside the box
//  begin
//    imgPreview.AutoSize := False;
//    imgPreview.Width    := scrBoxPreview.Width;
//    imgPreview.Height   := scrBoxPreview.Height;
//  end
//  else // show full size
//  begin
//    imgPreview.AutoSize := True;
//  end;
//  scrBoxPreview.HorzScrollBar.Visible := not imgPreview.Stretch;
//  scrBoxPreview.VertScrollBar.Visible := not imgPreview.Stretch;
  UpdateUI; // update menu option checked status
end;
//------------------------------------------------------------------------------
// Zoom in/out
procedure TfrmMain.SetZoomStep(fZom: Double);
begin
  fZom := RoundIt(fZom, 2);
  m_ZoomStep := fZom;
  imgPreview.Height := Trunc(ZoomStep * imgPreview.Picture.Height);
  imgPreview.Width := Trunc(ZoomStep * imgPreview.Picture.Width);
  UpdateUI; // update the status bar
end;
procedure TfrmMain.btnZoomInClick(Sender: TObject);
begin
       if ZoomStep <  0.10 then ZoomStep :=  0.10
  else if ZoomStep <  0.25 then ZoomStep :=  0.25
  else if ZoomStep <  0.50 then ZoomStep :=  0.50
  else if ZoomStep <  0.75 then ZoomStep :=  0.75
  else if ZoomStep <  1.00 then ZoomStep :=  1.00
  else if ZoomStep <  1.50 then ZoomStep :=  1.50
  else if ZoomStep <  2.00 then ZoomStep :=  2.00
  else if ZoomStep <  3.00 then ZoomStep :=  3.00
  else if ZoomStep <  5.00 then ZoomStep :=  5.00
  else if ZoomStep <  7.50 then ZoomStep :=  7.50
  else if ZoomStep < 10.00 then ZoomStep := 10.50
  else                          ZoomStep := 20.00;
end;
procedure TfrmMain.btnZoomOutClick(Sender: TObject);
begin
       if ZoomStep > 20.00 then ZoomStep := 20.00
  else if ZoomStep > 10.00 then ZoomStep := 10.00
  else if ZoomStep >  7.50 then ZoomStep :=  7.50
  else if ZoomStep >  5.00 then ZoomStep :=  5.00
  else if ZoomStep >  3.00 then ZoomStep :=  3.00
  else if ZoomStep >  2.00 then ZoomStep :=  2.00
  else if ZoomStep >  1.50 then ZoomStep :=  1.50
  else if ZoomStep >  1.00 then ZoomStep :=  1.00
  else if ZoomStep >  0.75 then ZoomStep :=  0.75
  else if ZoomStep >  0.50 then ZoomStep :=  0.50
  else if ZoomStep >  0.25 then ZoomStep :=  0.25
  else                          ZoomStep :=  0.10;
end;
procedure TfrmMain.btnZoomResetClick(Sender: TObject);
begin
  ZoomStep := 1.0;
end;
procedure TfrmMain.popoptZoomClick(Sender: TObject);
begin
  ZoomStep := TToolButton(Sender).Tag / 100;
end;
//------------------------------------------------------------------------------
// Extended keyboard handling
procedure TfrmMain.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ADD     : btnZoomInClick(nil);
    VK_SUBTRACT: btnZoomOutClick(nil);
    VK_ESCAPE  : ResetDynState; // no dynamic actions
  end;
end;
//------------------------------------------------------------------------------
// The Ruler tool
procedure TfrmMain.optRulerClick(Sender: TObject);
begin
  frmRuler.ShowModal;
end;
//------------------------------------------------------------------------------
// The Zoomer tool
procedure TfrmMain.optZoomerClick(Sender: TObject);
begin
  DoCapture(SNAP_ZOOM);
end;
procedure TfrmMain.optColorPickerClick(Sender: TObject);
begin
  DoCapture(SNAP_CLOP);
end;
procedure TfrmMain.optWdwInfoClick(Sender: TObject);
begin
  DoCapture(SNAP_INFO);
end;
//------------------------------------------------------------------------------
procedure TfrmMain.tabCtlChange(Sender: TObject);
var
  fEnabled: Boolean;
begin
  if (tabCtl.ActivePageIndex < 4) then
    fEnabled := True
  else
    fEnabled := btnCaptureLast.Enabled;

  btnDelayedCapture.Enabled := fEnabled;
  fldDelayedCapture.Enabled := fEnabled;
  spnDelayedCapture.Enabled := fEnabled;
end;
//------------------------------------------------------------------------------
// Enable delayed capture
procedure TfrmMain.btnDelayedCaptureClick(Sender: TObject);
begin
  tmrDelayedCapture.Interval := spnDelayedCapture.Position * 1000;
  tmrDelayedCapture.Enabled := True;
end;
//------------------------------------------------------------------------------
// Perform delayed capture
procedure TfrmMain.tmrDelayedCaptureTimer(Sender: TObject);
begin
  tmrDelayedCapture.Enabled := False;
  case tabCtl.ActivePageIndex of
    0: DoCapture(SNAP_RECT);
    1: DoCapture(SNAP_AREA);
    2: DoCapture(SNAP_DESK);
    3: DoCapture(SNAP_WIND);
    4: DoCapture(SNAP_LAST);
  end;
end;
//------------------------------------------------------------------------------
procedure TfrmMain.popoptRestoreClick(Sender: TObject);
begin
  CoolTrayIcon.ShowMainForm;
//  Application.Restore;
end;
procedure TfrmMain.CoolTrayIconClick(Sender: TObject);
begin
  if IsIconic(Application.Handle) then
    popoptRestoreClick(nil)
  else
  begin
    Application.Minimize;
//    CoolTrayIcon.HideMainForm;
//    CoolTrayIcon.IconVisible := True;
  end;
end;
//------------------------------------------------------------------------------
// Add the size of this captured image to fixed sizes
procedure TfrmMain.optAddFixedSizeClick(Sender: TObject);
begin
  AddFixedSize(imgPreview.Picture.Bitmap.Width, imgPreview.Picture.Bitmap.Height);
  PlayOneSOund(sndOK);
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// Transformations
procedure TfrmMain.SetTrfType(iTrf: Integer);
begin
  if iTrf in [TRF_FSTIDX..TRF_LSTIDX] then
    m_TrfType := iTrf
  else
    m_TrfType := TRF_FLIPX;

  case m_TrfType of
    TRF_FLIPX:
               begin
                 optTransform.ImageIndex := 12;
                 outbtnTransform.Hint := optFlipX.Hint;
               end;
    TRF_FLIPY:
               begin
                 optTransform.ImageIndex := 13;
                 outbtnTransform.Hint := optFlipY.Hint;
               end;
    TRF_ROTL :
               begin
                 optTransform.ImageIndex := 18;
                 outbtnTransform.Hint := optRotateLeft.Hint;
               end;
    TRF_ROTR :
               begin
                 optTransform.ImageIndex := 19;
                 outbtnTransform.Hint := optRotateRight.Hint;
               end;
  end;
  outbtnTransform.ImageIndex := optTransform.ImageIndex;
end;
//------------------------------------------------------------------------------
// Perform one of basic transformations
procedure TfrmMain.TransformSnap(iTyp: Integer);
var
  tmpBmp: TBitmap;
begin
  TrfType := iTyp; // register last used transformation
  GlbUndo.Add(TheBmp, False); // add to undo
  tmpBmp := TBitmap.Create;
  tmpBmp.Assign(imgPreview.Picture.Bitmap);
  if tmpBmp.PixelFormat <> pf24Bit then
    tmpBmp.Pixelformat := pf24bit;

  case iTyp of
    TRF_FLIPX:
                SpiegelnHorizontal(tmpBmp);
    TRF_FLIPY:
                SpiegelnVertikal(tmpBmp);
    TRF_ROTL:
                Drehen270Grad(tmpBmp);
    TRF_ROTR:
                Drehen90Grad(tmpBmp);
  end;
  imgPreview.Picture.Bitmap.Assign(tmpBmp);
  TheBmp.Assign(tmpBmp);
  tmpBmp.Free;
  ZoomStep := ZoomStep;
  PlayOneSound(sndOK);
end;
//------------------------------------------------------------------------------
procedure TfrmMain.outbtnTransformClick(Sender: TObject);
begin
  case TrfType of
    TRF_FLIPX: optFlipXClick(nil);
    TRF_FLIPY: optFlipYClick(nil);
    TRF_ROTL:  optRotateLeftClick(nil);
    TRF_ROTR:  optRotateRightClick(nil);
  end;
end;
//------------------------------------------------------------------------------
procedure TfrmMain.optFlipXClick(Sender: TObject);
begin
  TransformSnap(TRF_FLIPX);
end;
//------------------------------------------------------------------------------
procedure TfrmMain.optFlipYClick(Sender: TObject);
begin
  TransformSnap(TRF_FLIPY);
end;
//------------------------------------------------------------------------------
procedure TfrmMain.optRotateLeftClick(Sender: TObject);
begin
  TransformSnap(TRF_ROTL);
end;
//------------------------------------------------------------------------------
procedure TfrmMain.optRotateRightClick(Sender: TObject);
begin
  TransformSnap(TRF_ROTR);
end;
//------------------------------------------------------------------------------
procedure TfrmMain.ShowHelpPage(sTopic: String; hwndCaller: HWND);
begin
  if (hwndCaller <> 0) then
    HtmlHelp(hwndCaller, Pchar(Application.HelpFile), 0, Longint(PChar(sTopic)))
  else
    HtmlHelp(Handle, Pchar(Application.HelpFile), 0, Longint(PChar(sTopic)));
end;
//------------------------------------------------------------------------------
// Restore the window placement
procedure TfrmMain.ReadWindowPosition(frm: TForm; fRestoreSize: Boolean);
begin
  ReadWindowPos(m_regFile, frm, frm.Name, fRestoreSize);
end;
//------------------------------------------------------------------------------
// Store the window placement
procedure TfrmMain.SaveWindowPosition(frm: TForm; fSaveSize: Boolean);
begin
  SaveWindowPos(m_regFile, frm, frm.Name, fSaveSize);
end;
//------------------------------------------------------------------------------
// Show the main page of the help file
procedure TfrmMain.optHelpClick(Sender: TObject);
begin
  ShowHelpPage('index.htm', Handle);
end;
//------------------------------------------------------------------------------
// Check for a new version
procedure TfrmMain.optCheckNewVersionClick(Sender: TObject);
begin
  frmSoftwareCheck.ThisProgram := 'MWSnap';
  frmSoftwareCheck.ThisVersion := lblVsn.GetLabelText + iifs(IsBeta, ' Beta', '');
  frmSoftwareCheck.ThisID      := '#MWSNAP';
  frmSoftwareCheck.VersionFile := 'http://www.mirekw.com/versions.txt';

  frmSoftwareCheck.InetProxyAddress := InetProxyAddress;
  frmSoftwareCheck.InetProxyPort    := InetProxyPort;
  frmSoftwareCheck.InetUseProxy     := InetUseProxy;
  frmSoftwareCheck.ShowModal;
  InetProxyAddress := frmSoftwareCheck.InetProxyAddress;
  InetProxyPort    := frmSoftwareCheck.InetProxyPort;
  InetUseProxy     := frmSoftwareCheck.InetUseProxy;
end;
//------------------------------------------------------------------------------
// Home page
procedure TfrmMain.optVisitWebPageClick(Sender: TObject);
begin
  ShellExecute(Handle,'open','http://www.mirekw.com/','','',sw_Normal);
end;
//------------------------------------------------------------------------------
procedure TfrmMain.optDonateClick(Sender: TObject);
begin
  ShellExecute(Handle,'open','http://www.mirekw.com/donate/donate.html ','','',sw_Normal);
end;
//------------------------------------------------------------------------------
// Select another language
procedure TfrmMain.optLanguageClick(Sender: TObject);
begin
  if frmLanguage <> nil then
  begin
    frmLanguage.RootDir := PgmDir;
    frmLanguage.InitLanguage := Language;
    frmLanguage.ShowModal;
    if Length(frmLanguage.SelectedLanguage) > 0 then
      Language := frmLanguage.SelectedLanguage;
    UpdateUI; // update menu option checked status
  end;
end;
//------------------------------------------------------------------------------
function TfrmMain.ReadBool(sSec, sKey: String; fDefault: Boolean): Boolean;
begin
  Result := m_regFile.ReadBool(sSec, sKey, fDefault)
end;
function  TfrmMain.ReadInteger(sSec, sKey: String; nDefault: Integer): Integer;
begin
  Result := m_regFile.ReadInteger(sSec, sKey, nDefault)
end;
function  TfrmMain.ReadString(sSec, sKey: String; sDefault: String): String;
begin
  Result := m_regFile.ReadString(sSec, sKey, sDefault)
end;
procedure TfrmMain.WriteBool(sSec, sKey: String; fVal: Boolean);
begin
  m_regFile.WriteBool(sSec, sKey, fVal)
end;
procedure TfrmMain.WriteInteger(sSec, sKey: String; nVal: Integer);
begin
  m_regFile.WriteInteger(sSec, sKey, nVal)
end;
procedure TfrmMain.WriteString(sSec, sKey: String; sVal: String);
begin
  m_regFile.WriteString(sSec, sKey, sVal)
end;
//------------------------------------------------------------------------------
// Refresh the files list.
// fLocateCurrent - locate the current file in the list
procedure TfrmMain.UpdateFMFileListBox(fLocateCurrent: Boolean);
var
  sPth: String;
begin
  if fLocateCurrent then // use current file
    sPth := LastSavePath
  else // use highlighted file
    sPth := FMFileListBox.FileName;

  FMFileListBox.Update; // refresh the files list
  if (Length(sPth) > 0) and (sPth <> rsNoname) then
    if FileExists(sPth) then
    begin
      FMFileListBox.ApplyFilePath(sPth); // go to the file
    end;
end;
//------------------------------------------------------------------------------
// Implement file manager single click
procedure TfrmMain.DirectoryListBoxClick(Sender: TObject);
begin
    DirectoryListBox.OpenCurrent;
end;
procedure TfrmMain.FMFileListBoxClick(Sender: TObject);
begin
  FMFileListBoxDblClick(Sender);
end;
procedure TfrmMain.FMFileListBoxDblClick(Sender: TObject);
begin
  DoOpenPicture(FMFileListBox.Filename);
end;
//------------------------------------------------------------------------------
// File Manager resizing
procedure TfrmMain.pnlFilterResize(Sender: TObject);
begin
  FilterComboBox.Width := pnlFilter.Width;
end;
procedure TfrmMain.pnlDriveResize(Sender: TObject);
begin
  DriveComboBox.Width := pnlDrive.Width;
end;
//------------------------------------------------------------------------------
// File manager: right button - show popup
procedure TfrmMain.FMFileListBoxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  pnt: TPoint;
begin
  if Button = mbRight then
  begin
    if FMFileListBox.ItemAtPos(Point(X, Y), True) >= 0 then
    begin
      FMFileListBox.ItemIndex := FMFileListBox.ItemAtPos(Point(X, Y), True);
      if Length(FMFileListBox.Filename) > 0 then
      begin
        pnt := FMFileListBox.ClientToScreen(Point(X, Y));
        popOpen.Popup(pnt.x, pnt.y);
      end;
    end;
  end
//  else
//    FMFileListBox.BeginDrag(False, 3);

end;
//------------------------------------------------------------------------------
// Open the picture
procedure TfrmMain.optFMFileOpenClick(Sender: TObject);
begin
  DoOpenPicture(FMFileListBox.Filename);
end;
//------------------------------------------------------------------------------
// Execute the given program
// Requires ShellAPI
function ExecuteFile(const FileName, Params, DefaultDir: string; ShowCmd: Integer): THandle;
var
  zFileName, zParams, zDir: array[0..179] of Char;
begin
  Result := ShellExecute(Application.MainForm.Handle, nil,
    StrPCopy(zFileName, FileName), StrPCopy(zParams, Params),
    StrPCopy(zDir, DefaultDir), ShowCmd);
end;
//------------------------------------------------------------------------------
procedure TfrmMain.optFMStartClick(Sender: TObject);
begin
  ExecuteFile(FMFileListBox.Filename, '', '', SW_SHOW);
end;
//------------------------------------------------------------------------------
// Rename the selected file
procedure TfrmMain.optFMRenameClick(Sender: TObject);
var
  sFilNam: String;
  sBff: String;
begin
  sFilNam := ExtractFilename(FMFileListBox.Filename);

  if InputQuery(ilMiscStr(rsFileRenameTitle, 'rsFileRenameTitle'),
                ilMiscStr(rsFileRenamePrompt, 'rsFileRenamePrompt'), sFilNam) then
  begin
    if RenameFile(FMFileListBox.Filename, sFilNam) then
    begin
      UpdateFMFileListBox(False); // refresh the list of files
      FMFileListBox.Filename := sFilNam // locate
    end
    else
    begin
      sBff := Format(ilMiscStr(rsFileCantRename, 'rsFileCantRename'), [FMFileListBox.Filename, sFilNam]);
      CstMessageDlg(sBff, mtError, [mbOk], 0);
    end;
  end;
end;
//------------------------------------------------------------------------------
// Delete the selected file
procedure TfrmMain.optFMDeleteClick(Sender: TObject);
var
  sBff: String;
begin
  sBff := Format(ilMiscStr(rsFileSureDelete, 'rsFileSureDelete'), [FMFileListBox.Filename]);
  if CstMessageDlg(sBff, mtConfirmation, [mbYES,mbNO], 0) = ID_YES then
    if DeleteFile(FMFileListBox.Filename) then
    begin
      if FMFileListBox.ItemIndex < FMFileListBox.Items.Count - 1 then
        FMFileListBox.Filename := FMFileListBox.Items[FMFileListBox.ItemIndex + 1];
      UpdateFMFileListBox(False); // refresh the list of files
    end
    else
    begin
      sBff := Format(ilMiscStr(rsFileCantDelete, 'rsFileCantDelete'), [FMFileListBox.Filename]);
      CstMessageDlg(sBff, mtError, [mbOk], 0);
    end;
end;
//------------------------------------------------------------------------------
procedure TfrmMain.FMFileListBoxKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_DELETE: optFMDeleteClick(nil);
  end;
end;
//------------------------------------------------------------------------------
// Add a frame
procedure TfrmMain.btnAddFrameClick(Sender: TObject);
begin
  GlbUndo.Add(TheBmp, False); // add to undo
  GlbAddFrame.Perform(TheBmp, True); // add the last used frame type
  imgPreview.Picture.Bitmap.Assign(TheBmp);
  ZoomStep := ZoomStep;     // refresh
end;
procedure TfrmMain.optAddFrameSmpClick(Sender: TObject);
begin
  GlbAddFrame.FrameType := ADDFRM_SMP; // simple frame
  if frmAddFrame.ShowModal = mrOK then
  begin
    GlbUndo.Add(TheBmp, False); // add to undo
    GlbAddFrame.Perform(TheBmp, True); // add the frame
    imgPreview.Picture.Bitmap.Assign(TheBmp);
    ZoomStep := ZoomStep;     // refresh
  end;
end;
procedure TfrmMain.optAddFrameShdClick(Sender: TObject);
begin
  GlbAddFrame.FrameType := ADDFRM_SHD; // shaded frame
  if frmAddFrame.ShowModal = mrOK then
  begin
    GlbUndo.Add(TheBmp, False); // add to undo
    GlbAddFrame.Perform(TheBmp, True); // add the frame
    imgPreview.Picture.Bitmap.Assign(TheBmp);
    ZoomStep := ZoomStep;     // refresh
  end;
end;
procedure TfrmMain.optAddFrameBtnClick(Sender: TObject);
begin
  GlbAddFrame.FrameType := ADDFRM_BTN; // button frame
  if frmAddFrame.ShowModal = mrOK then
  begin
    GlbUndo.Add(TheBmp, False); // add to undo
    GlbAddFrame.Perform(TheBmp, True); // add the frame
    imgPreview.Picture.Bitmap.Assign(TheBmp);
    ZoomStep := ZoomStep;     // refresh
  end;
end;
//------------------------------------------------------------------------------
// Undo last changes
procedure TfrmMain.optUndoClick(Sender: TObject);
begin
  if (GlbUndo.UndoPossible) then
  begin
    TheBmp.Assign(GlbUndo.Undo(TheBmp));
    imgPreview.Picture.Bitmap.Assign(TheBmp);
    ZoomStep := ZoomStep;
    PlayOneSound(sndOK);
  end;
end;
//------------------------------------------------------------------------------
// Redo last undo
procedure TfrmMain.btnRedoClick(Sender: TObject);
begin
  if (GlbUndo.RedoPossible) then
  begin
    TheBmp.Assign(GlbUndo.Redo);
    imgPreview.Picture.Bitmap.Assign(TheBmp);
    ZoomStep := ZoomStep;
    PlayOneSound(sndOK);
  end;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// DynState property handling
procedure TfrmMain.SetDynState(stt: TDynState);
begin
  m_DynState := stt;
  sttBar.AutoHint := (DynState = DS_NORMAL);
end;
//------------------------------------------------------------------------------
// Reset eventual dynamic actions
procedure TfrmMain.ResetDynState;
begin
  case DynState of
    DS_NORMAL: ;
    DS_CURSOR: ClipCursor(nil);
  end;
  DynState := DS_NORMAL; // no dynamic actions
  Screen.Cursor := crDefault;
  UpdateUI; // Update user-interface elements
end;
//------------------------------------------------------------------------------
// Add the cursor image
procedure TfrmMain.btnAddCursorClick(Sender: TObject);
var
  imgRect: TRect;
  p: TPoint;
begin
  ZoomStep := 1.0; // reset eventual zoom

  // jump to the center of the picture
  imgRect := imgPreview.BoundsRect;
  with imgRect do begin
    p := scrBoxPreview.ClientToScreen(Point(Left, Top));
    Left := p.x;
    Top  := p.y;
    p := scrBoxPreview.ClientToScreen(Point(Right,Bottom));
    Right  := p.x;
    Bottom := p.y;

    SetCursorPos((Right + Left) div 2, (Bottom + Top) div 2);
  end;

  // restrict mouse movement
  imgRect := scrBoxPreview.BoundsRect;
  with imgRect do begin
    p := scrBoxPreview.ClientToScreen(Point(Left, Top));
    Left := p.x;
    Top  := p.y;
    p := scrBoxPreview.ClientToScreen(Point(Right,Bottom));
    Right  := p.x;
    Bottom := p.y;
  end;
  ClipCursor(@imgRect);

  DynState := DS_CURSOR; // appending a cursor image
  Screen.Cursor := AddCursorIdx;
  UpdateUI; // Update user-interface elements
end;
//------------------------------------------------------------------------------
// Draw a specified cursor image on aCanvas at the p point
procedure DrawCursor(aCanvas: TCanvas; p: TPoint; crsIdx: Integer);
var
  IconInfo: TIconInfo;
  hCursor : THandle;
begin
  try
    hCursor := Screen.Cursors[crsIdx];
    GetIconInfo(hCursor, IconInfo);

    Dec(p.x, IconInfo.xHotSpot);
    Dec(p.y, IconInfo.yHotSpot);
    DrawIconEx(ACanvas.Handle,
               p.x, p.y,
               hCursor, 32, 32, 0, 0, DI_NORMAL);
    PlayOneSound(sndOK);
  finally
    DeleteObject(IconInfo.hbmMask);
    DeleteObject(IconInfo.hbmColor)
  end;
end;
//------------------------------------------------------------------------------
// The picture has been clicked, determine what to do
procedure TfrmMain.imgPreviewClick(Sender: TObject);
var
  p: TPoint;
  tmpBmp: TBitmap;
  crsIdx: Integer;
begin
  if (DynState = DS_CURSOR) then
  begin
    GlbUndo.Add(TheBmp, False); // add to undo
    crsIdx := AddCursorIdx;
    tmpBmp := TBitmap.Create;
    try
      tmpBmp.PixelFormat := pf24bit;  // to avoid working with palettes
      tmpBmp.Assign(imgPreview.Picture.Bitmap);

      GetCursorPos(p);
      p := imgPreview.ScreenToClient(p);
      DrawCursor(tmpBmp.Canvas, p, crsIdx);
      imgPreview.Picture.Bitmap.Assign(tmpBmp);
      TheBmp.Assign(tmpBmp);
    finally
      tmpBmp.Free;
    end;

    ResetDynState; // stop
  end;
end;
//------------------------------------------------------------------------------
// Add the cursor image of type specified in menu option .Tag property
procedure TfrmMain.optAddCursorClick(Sender: TObject);
begin
  AddCursorIdx := TControl(Sender).Tag;
  btnAddCursorClick(nil);
end;
//------------------------------------------------------------------------------
procedure TfrmMain.SetAddCursorIdx(crsIdx: TCursor);
begin
  m_AddCursorIdx := crsIdx;
  case m_AddCursorIdx of
    crArrow    : optAddCursor.ImageIndex := 35;
    crCross    : optAddCursor.ImageIndex := 36;
    crIBeam    : optAddCursor.ImageIndex := 37;
    crSizeNESW : optAddCursor.ImageIndex := 38;
    crSizeNS   : optAddCursor.ImageIndex := 39;
    crSizeNWSE : optAddCursor.ImageIndex := 40;
    crSizeWE   : optAddCursor.ImageIndex := 41;
    crUpArrow  : optAddCursor.ImageIndex := 42;
    crHourGlass: optAddCursor.ImageIndex := 43;
    crDrag     : optAddCursor.ImageIndex := 44;
    crNoDrop   : optAddCursor.ImageIndex := 45;
    crHSplit   : optAddCursor.ImageIndex := 46;
    crVSplit   : optAddCursor.ImageIndex := 47;
    crMultiDrag: optAddCursor.ImageIndex := 48;
    crSQLWait  : optAddCursor.ImageIndex := 49;
    crNo       : optAddCursor.ImageIndex := 50;
    crAppStart : optAddCursor.ImageIndex := 51;
    crHelp     : optAddCursor.ImageIndex := 52;
    crHandPoint: optAddCursor.ImageIndex := 53;
    crSizeAll  : optAddCursor.ImageIndex := 54;
  end;
  btnAddCursor.ImageIndex := optAddCursor.ImageIndex;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------


end.

