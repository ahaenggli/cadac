object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Cadac Updater'
  ClientHeight = 245
  ClientWidth = 472
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 192
    Top = 218
    Width = 3
    Height = 13
  end
  object Button1: TButton
    Left = 176
    Top = 164
    Width = 97
    Height = 25
    Caption = 'Update installieren'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 32
    Top = 24
    Width = 393
    Height = 121
    Lines.Strings = (
      'Memo1')
    ReadOnly = True
    TabOrder = 1
  end
  object Gauge1: TProgressBar
    Left = 112
    Top = 195
    Width = 233
    Height = 17
    TabOrder = 2
  end
end
