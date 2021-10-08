object frmColorInfo: TfrmColorInfo
  Left = 274
  Top = 146
  BorderStyle = bsSingle
  Caption = 'Color info'
  ClientHeight = 147
  ClientWidth = 377
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object lblCloRGB: TLabel
    Left = 16
    Top = 28
    Width = 52
    Height = 13
    Caption = 'RGB color:'
  end
  object lblCloHTML: TLabel
    Left = 16
    Top = 56
    Width = 59
    Height = 13
    Caption = 'HTML color:'
  end
  object lblCloDelphi: TLabel
    Left = 16
    Top = 84
    Width = 59
    Height = 13
    Caption = 'Delphi color:'
  end
  object lblCloSystem: TLabel
    Left = 16
    Top = 112
    Width = 63
    Height = 13
    Caption = 'System color:'
  end
  object pnlClo: TPanel
    Left = 312
    Top = 96
    Width = 37
    Height = 37
    BevelInner = bvLowered
    BorderWidth = 2
    TabOrder = 5
  end
  object btnClose: TButton
    Left = 292
    Top = 20
    Width = 75
    Height = 25
    Caption = '&Close'
    ModalResult = 1
    TabOrder = 0
  end
  object outfldCloRGB: TEdit
    Left = 128
    Top = 24
    Width = 125
    Height = 21
    ReadOnly = True
    TabOrder = 1
    Text = 'outfldCloRGB'
  end
  object outfldCloHTML: TEdit
    Left = 128
    Top = 52
    Width = 125
    Height = 21
    ReadOnly = True
    TabOrder = 2
    Text = 'outfldCloHTML'
  end
  object outfldCloDelphi: TEdit
    Left = 128
    Top = 80
    Width = 125
    Height = 21
    ReadOnly = True
    TabOrder = 3
    Text = 'outfldCloDelphi'
  end
  object outfldCloSystem: TEdit
    Left = 128
    Top = 108
    Width = 125
    Height = 21
    ReadOnly = True
    TabOrder = 4
    Text = 'outfldCloSystem'
  end
  object btnCloRGB: TBitBtn
    Left = 259
    Top = 25
    Width = 22
    Height = 24
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    TabStop = False
    OnClick = btnCloRGBClick
    Glyph.Data = {
      F6000000424DF600000000000000760000002800000010000000100000000100
      04000000000080000000120B0000120B00001000000010000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF00C0C0C00000FFFF00FF000000C0C0C000FFFF0000FFFFFF00DADADADADADA
      DADAADADADADADADADADDADADA444444444AADADAD4FFFFFFF4DDADADA4F0000
      0F4A0000004FFFFFFF4D0FFFFF4F00000F4A0F00004FFFFFFF4D0FFFFF4F00F4
      444A0F00004FFFF4F4AD0FFFFF4FFFF44ADA0F00F0444444ADAD0FFFF0F0DADA
      DADA0FFFF00DADADADAD000000DADADADADAADADADADADADADAD}
  end
  object btnCloHTML: TBitBtn
    Left = 259
    Top = 53
    Width = 22
    Height = 24
    ParentShowHint = False
    ShowHint = True
    TabOrder = 7
    TabStop = False
    OnClick = btnCloHTMLClick
    Glyph.Data = {
      F6000000424DF600000000000000760000002800000010000000100000000100
      04000000000080000000120B0000120B00001000000010000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF00C0C0C00000FFFF00FF000000C0C0C000FFFF0000FFFFFF00DADADADADADA
      DADAADADADADADADADADDADADA444444444AADADAD4FFFFFFF4DDADADA4F0000
      0F4A0000004FFFFFFF4D0FFFFF4F00000F4A0F00004FFFFFFF4D0FFFFF4F00F4
      444A0F00004FFFF4F4AD0FFFFF4FFFF44ADA0F00F0444444ADAD0FFFF0F0DADA
      DADA0FFFF00DADADADAD000000DADADADADAADADADADADADADAD}
  end
  object btnCloDelphi: TBitBtn
    Left = 259
    Top = 81
    Width = 22
    Height = 24
    ParentShowHint = False
    ShowHint = True
    TabOrder = 8
    TabStop = False
    OnClick = btnCloDelphiClick
    Glyph.Data = {
      F6000000424DF600000000000000760000002800000010000000100000000100
      04000000000080000000120B0000120B00001000000010000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF00C0C0C00000FFFF00FF000000C0C0C000FFFF0000FFFFFF00DADADADADADA
      DADAADADADADADADADADDADADA444444444AADADAD4FFFFFFF4DDADADA4F0000
      0F4A0000004FFFFFFF4D0FFFFF4F00000F4A0F00004FFFFFFF4D0FFFFF4F00F4
      444A0F00004FFFF4F4AD0FFFFF4FFFF44ADA0F00F0444444ADAD0FFFF0F0DADA
      DADA0FFFF00DADADADAD000000DADADADADAADADADADADADADAD}
  end
  object btnCloSystem: TBitBtn
    Left = 259
    Top = 109
    Width = 22
    Height = 24
    ParentShowHint = False
    ShowHint = True
    TabOrder = 9
    TabStop = False
    OnClick = btnCloSystemClick
    Glyph.Data = {
      F6000000424DF600000000000000760000002800000010000000100000000100
      04000000000080000000120B0000120B00001000000010000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF00C0C0C00000FFFF00FF000000C0C0C000FFFF0000FFFFFF00DADADADADADA
      DADAADADADADADADADADDADADA444444444AADADAD4FFFFFFF4DDADADA4F0000
      0F4A0000004FFFFFFF4D0FFFFF4F00000F4A0F00004FFFFFFF4D0FFFFF4F00F4
      444A0F00004FFFF4F4AD0FFFFF4FFFF44ADA0F00F0444444ADAD0FFFF0F0DADA
      DADA0FFFF00DADADADAD000000DADADADADAADADADADADADADAD}
  end
end
