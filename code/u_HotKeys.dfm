object frmHotkeys: TfrmHotkeys
  Left = 431
  Top = 220
  BorderStyle = bsDialog
  Caption = 'System-wide Hotkeys'
  ClientHeight = 289
  ClientWidth = 439
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 12
    Width = 345
    Height = 269
  end
  object lblRect: TLabel
    Left = 52
    Top = 44
    Width = 93
    Height = 13
    Alignment = taRightJustify
    Caption = 'Fixed-size rectangle'
  end
  object lblArea: TLabel
    Left = 100
    Top = 68
    Width = 42
    Height = 13
    Alignment = taRightJustify
    Caption = 'Any area'
  end
  object lblWind: TLabel
    Left = 75
    Top = 92
    Width = 68
    Height = 13
    Alignment = taRightJustify
    Caption = 'Window.menu'
  end
  object lblDesk: TLabel
    Left = 88
    Top = 116
    Width = 57
    Height = 13
    Alignment = taRightJustify
    Caption = 'Full desktop'
  end
  object lblLast: TLabel
    Left = 52
    Top = 140
    Width = 93
    Height = 13
    Alignment = taRightJustify
    Caption = 'Repeat last capture'
  end
  object lblAlt: TLabel
    Left = 180
    Top = 20
    Width = 16
    Height = 13
    Caption = 'Alt'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblShift: TLabel
    Left = 204
    Top = 20
    Width = 27
    Height = 13
    Caption = 'Shift'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblCtrl: TLabel
    Left = 148
    Top = 20
    Width = 20
    Height = 13
    Caption = 'Ctrl'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblKey: TLabel
    Left = 240
    Top = 20
    Width = 22
    Height = 13
    Caption = 'Key'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblActive: TLabel
    Left = 300
    Top = 20
    Width = 37
    Height = 13
    Alignment = taCenter
    Caption = 'Active'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Bevel2: TBevel
    Left = 20
    Top = 32
    Width = 321
    Height = 6
    Shape = bsBottomLine
  end
  object Bevel3: TBevel
    Left = 20
    Top = 164
    Width = 321
    Height = 5
    Shape = bsBottomLine
  end
  object lblRulr: TLabel
    Left = 98
    Top = 180
    Width = 45
    Height = 13
    Alignment = taRightJustify
    Caption = 'Ruler tool'
  end
  object lblZoom: TLabel
    Left = 98
    Top = 204
    Width = 47
    Height = 13
    Alignment = taRightJustify
    Caption = 'Zoom tool'
  end
  object lblInfo: TLabel
    Left = 66
    Top = 252
    Width = 79
    Height = 13
    Alignment = taRightJustify
    Caption = 'Window info tool'
  end
  object lblClop: TLabel
    Left = 69
    Top = 228
    Width = 76
    Height = 13
    Alignment = taRightJustify
    Caption = 'Color picker tool'
  end
  object chkRect_Ctrl: TCheckBox
    Left = 152
    Top = 44
    Width = 21
    Height = 17
    TabOrder = 0
  end
  object chkRect_Alt: TCheckBox
    Left = 180
    Top = 44
    Width = 21
    Height = 17
    TabOrder = 1
  end
  object chkRect_Shift: TCheckBox
    Left = 208
    Top = 44
    Width = 21
    Height = 17
    TabOrder = 2
  end
  object outcmbRect_Key: TComboBox
    Left = 240
    Top = 40
    Width = 49
    Height = 21
    ItemHeight = 13
    TabOrder = 3
    Text = 'outcmbRect_Key'
  end
  object chkRect_Active: TCheckBox
    Left = 312
    Top = 44
    Width = 21
    Height = 17
    TabOrder = 4
  end
  object chkArea_Ctrl: TCheckBox
    Left = 152
    Top = 68
    Width = 21
    Height = 17
    TabOrder = 5
  end
  object chkArea_Alt: TCheckBox
    Left = 180
    Top = 68
    Width = 21
    Height = 17
    TabOrder = 6
  end
  object chkArea_Shift: TCheckBox
    Left = 208
    Top = 68
    Width = 21
    Height = 17
    TabOrder = 7
  end
  object outcmbArea_Key: TComboBox
    Left = 240
    Top = 64
    Width = 49
    Height = 21
    ItemHeight = 13
    TabOrder = 8
    Text = 'ComboBox1'
  end
  object chkArea_Active: TCheckBox
    Left = 312
    Top = 68
    Width = 21
    Height = 17
    TabOrder = 9
  end
  object chkWind_Ctrl: TCheckBox
    Left = 152
    Top = 92
    Width = 21
    Height = 17
    TabOrder = 10
  end
  object chkWind_Alt: TCheckBox
    Left = 180
    Top = 92
    Width = 21
    Height = 17
    TabOrder = 11
  end
  object chkWind_Shift: TCheckBox
    Left = 208
    Top = 92
    Width = 21
    Height = 17
    TabOrder = 12
  end
  object outcmbWind_Key: TComboBox
    Left = 240
    Top = 88
    Width = 49
    Height = 21
    ItemHeight = 13
    TabOrder = 13
    Text = 'ComboBox1'
  end
  object chkWind_Active: TCheckBox
    Left = 312
    Top = 92
    Width = 21
    Height = 17
    TabOrder = 14
  end
  object chkDesk_Ctrl: TCheckBox
    Left = 152
    Top = 116
    Width = 21
    Height = 17
    TabOrder = 15
  end
  object chkDesk_Alt: TCheckBox
    Left = 180
    Top = 116
    Width = 21
    Height = 17
    TabOrder = 16
  end
  object chkDesk_Shift: TCheckBox
    Left = 208
    Top = 116
    Width = 21
    Height = 17
    TabOrder = 17
  end
  object outcmbDesk_Key: TComboBox
    Left = 240
    Top = 112
    Width = 49
    Height = 21
    ItemHeight = 13
    TabOrder = 18
    Text = 'ComboBox1'
  end
  object chkDesk_Active: TCheckBox
    Left = 312
    Top = 116
    Width = 21
    Height = 17
    TabOrder = 19
  end
  object chkLast_Ctrl: TCheckBox
    Left = 152
    Top = 140
    Width = 21
    Height = 17
    TabOrder = 20
  end
  object chkLast_Alt: TCheckBox
    Left = 180
    Top = 140
    Width = 21
    Height = 17
    TabOrder = 21
  end
  object chkLast_Shift: TCheckBox
    Left = 208
    Top = 140
    Width = 21
    Height = 17
    TabOrder = 22
  end
  object outcmbLast_Key: TComboBox
    Left = 240
    Top = 136
    Width = 49
    Height = 21
    ItemHeight = 13
    TabOrder = 23
    Text = 'ComboBox1'
  end
  object chkLast_Active: TCheckBox
    Left = 312
    Top = 140
    Width = 21
    Height = 17
    TabOrder = 24
  end
  object btnOk: TButton
    Left = 364
    Top = 12
    Width = 69
    Height = 25
    Caption = '&Ok'
    ModalResult = 1
    TabOrder = 45
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 364
    Top = 68
    Width = 69
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 47
  end
  object btnApply: TButton
    Left = 364
    Top = 40
    Width = 69
    Height = 25
    Caption = '&Apply'
    TabOrder = 46
    OnClick = btnApplyClick
  end
  object btnDefault: TButton
    Left = 364
    Top = 96
    Width = 69
    Height = 25
    Caption = '&Default'
    TabOrder = 48
    OnClick = btnDefaultClick
  end
  object btnHelp: TButton
    Left = 364
    Top = 128
    Width = 69
    Height = 25
    Caption = '&Help'
    TabOrder = 49
    OnClick = btnHelpClick
  end
  object chkRulr_Ctrl: TCheckBox
    Left = 152
    Top = 180
    Width = 21
    Height = 17
    TabOrder = 25
  end
  object chkRulr_Alt: TCheckBox
    Left = 180
    Top = 180
    Width = 21
    Height = 17
    TabOrder = 26
  end
  object chkRulr_Shift: TCheckBox
    Left = 208
    Top = 180
    Width = 21
    Height = 17
    TabOrder = 27
  end
  object outcmbRulr_Key: TComboBox
    Left = 240
    Top = 176
    Width = 49
    Height = 21
    ItemHeight = 13
    TabOrder = 28
    Text = 'outcmbRulr_Key'
  end
  object chkRulr_Active: TCheckBox
    Left = 312
    Top = 180
    Width = 21
    Height = 17
    TabOrder = 29
  end
  object chkZoom_Ctrl: TCheckBox
    Left = 152
    Top = 204
    Width = 21
    Height = 17
    TabOrder = 30
  end
  object chkZoom_Alt: TCheckBox
    Left = 180
    Top = 204
    Width = 21
    Height = 17
    TabOrder = 31
  end
  object chkZoom_Shift: TCheckBox
    Left = 208
    Top = 204
    Width = 21
    Height = 17
    TabOrder = 32
  end
  object outcmbZoom_Key: TComboBox
    Left = 240
    Top = 200
    Width = 49
    Height = 21
    ItemHeight = 13
    TabOrder = 33
    Text = 'ComboBox1'
  end
  object chkZoom_Active: TCheckBox
    Left = 312
    Top = 204
    Width = 21
    Height = 17
    TabOrder = 34
  end
  object chkInfo_Ctrl: TCheckBox
    Left = 152
    Top = 252
    Width = 21
    Height = 17
    TabOrder = 40
  end
  object chkInfo_Alt: TCheckBox
    Left = 180
    Top = 252
    Width = 21
    Height = 17
    TabOrder = 41
  end
  object chkInfo_Shift: TCheckBox
    Left = 208
    Top = 252
    Width = 21
    Height = 17
    TabOrder = 42
  end
  object outcmbInfo_Key: TComboBox
    Left = 240
    Top = 248
    Width = 49
    Height = 21
    ItemHeight = 13
    TabOrder = 43
    Text = 'ComboBox1'
  end
  object chkInfo_Active: TCheckBox
    Left = 312
    Top = 252
    Width = 21
    Height = 17
    TabOrder = 44
  end
  object chkClop_Ctrl: TCheckBox
    Left = 152
    Top = 228
    Width = 21
    Height = 17
    TabOrder = 35
  end
  object chkClop_Alt: TCheckBox
    Left = 180
    Top = 228
    Width = 21
    Height = 17
    TabOrder = 36
  end
  object chkClop_Shift: TCheckBox
    Left = 208
    Top = 228
    Width = 21
    Height = 17
    TabOrder = 37
  end
  object outcmbClop_Key: TComboBox
    Left = 240
    Top = 224
    Width = 49
    Height = 21
    ItemHeight = 13
    TabOrder = 38
    Text = 'outcmbClop_Key'
  end
  object chkClop_Active: TCheckBox
    Left = 312
    Top = 228
    Width = 21
    Height = 17
    TabOrder = 39
  end
end
