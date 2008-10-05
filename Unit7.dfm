object Form7: TForm7
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Cadac Update'
  ClientHeight = 319
  ClientWidth = 568
  Color = clBtnFace
  Constraints.MaxHeight = 479
  Constraints.MaxWidth = 769
  Constraints.MinHeight = 364
  Constraints.MinWidth = 586
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 17
  object Image1: TImage
    Left = -30
    Top = -31
    Width = 659
    Height = 387
    Center = True
    Enabled = False
    Stretch = True
  end
  object Label1: TLabel
    Left = 73
    Top = 187
    Width = 4
    Height = 18
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Memo1: TMemo
    Left = 73
    Top = 31
    Width = 389
    Height = 148
    Lines.Strings = (
      'Memo1')
    ReadOnly = True
    TabOrder = 0
    WordWrap = False
  end
  object Button1: TButton
    Left = 322
    Top = 230
    Width = 140
    Height = 33
    Caption = 'Update Runterladen'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Gauge1: TProgressBar
    Left = 73
    Top = 241
    Width = 196
    Height = 22
    TabOrder = 2
  end
end
