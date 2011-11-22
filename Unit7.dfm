object Form7: TForm7
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Cadac Update'
  ClientHeight = 244
  ClientWidth = 434
  Color = clBtnFace
  Constraints.MaxHeight = 282
  Constraints.MaxWidth = 450
  Constraints.MinHeight = 280
  Constraints.MinWidth = 450
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = -23
    Top = -24
    Width = 504
    Height = 296
    Center = True
    Enabled = False
    Stretch = True
  end
  object Label1: TLabel
    Left = 56
    Top = 143
    Width = 3
    Height = 13
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Memo1: TMemo
    Left = 56
    Top = 24
    Width = 297
    Height = 113
    Lines.Strings = (
      'Memo1')
    ReadOnly = True
    TabOrder = 0
    WordWrap = False
  end
  object Button1: TButton
    Left = 246
    Top = 176
    Width = 107
    Height = 25
    Caption = 'Update Runterladen'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Gauge1: TProgressBar
    Left = 56
    Top = 184
    Width = 150
    Height = 17
    TabOrder = 2
  end
end
