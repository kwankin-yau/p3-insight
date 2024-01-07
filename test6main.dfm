object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 495
  ClientWidth = 681
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = BcBarPopupMenu1
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 16
    Top = 8
    Width = 657
    Height = 306
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object btnSelftTest: TButton
    Left = 16
    Top = 320
    Width = 75
    Height = 25
    Caption = 'Self test'
    TabOrder = 1
    OnClick = btnSelftTestClick
  end
  object Button2: TButton
    Left = 112
    Top = 320
    Width = 193
    Height = 25
    Caption = 'BringOllydbgToSecondMonitor'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Edit1: TEdit
    Left = 24
    Top = 376
    Width = 121
    Height = 26
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    Text = 'Edit1'
  end
  object btnSingle: TButton
    Left = 160
    Top = 376
    Width = 75
    Height = 25
    Caption = 'btnSingle'
    TabOrder = 4
    OnClick = btnSingleClick
  end
  object Edit2: TEdit
    Left = 248
    Top = 376
    Width = 417
    Height = 26
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    Text = 'Edit2'
  end
  object btnConvert: TButton
    Left = 160
    Top = 408
    Width = 75
    Height = 25
    Caption = 'btnConvert'
    TabOrder = 6
    OnClick = btnConvertClick
  end
  object btnConvertUtf8: TButton
    Left = 146
    Top = 439
    Width = 89
    Height = 25
    Caption = 'btnConvertUtf8'
    TabOrder = 7
    OnClick = btnConvertUtf8Click
  end
  object btnHexToStr: TButton
    Left = 160
    Top = 470
    Width = 75
    Height = 25
    Caption = '<-'
    TabOrder = 8
    OnClick = btnHexToStrClick
  end
  object btnConvertUnicode: TButton
    Left = 163
    Top = 346
    Width = 75
    Height = 25
    Caption = 'to unicode'
    TabOrder = 9
    OnClick = btnConvertUnicodeClick
  end
  object btnTestLoadConf: TButton
    Left = 328
    Top = 320
    Width = 115
    Height = 25
    Caption = 'TestLoadConf'
    TabOrder = 10
    OnClick = btnTestLoadConfClick
  end
  object btnplaywave: TButton
    Left = 464
    Top = 352
    Width = 75
    Height = 25
    Caption = 'btnplaywave'
    TabOrder = 11
    OnClick = btnplaywaveClick
  end
  object BcBarPopupMenu1: TBcBarPopupMenu
    OwnerDraw = True
    Bar.BarCaption.Font.Charset = DEFAULT_CHARSET
    Bar.BarCaption.Font.Color = clWhite
    Bar.BarCaption.Font.Height = -19
    Bar.BarCaption.Font.Name = 'Tahoma'
    Bar.BarCaption.Font.Style = [fsBold, fsItalic]
    Separators.Font.Charset = DEFAULT_CHARSET
    Separators.Font.Color = clWindowText
    Separators.Font.Height = -11
    Separators.Font.Name = 'Tahoma'
    Separators.Font.Style = []
    MenuFont.Charset = DEFAULT_CHARSET
    MenuFont.Color = clWindowText
    MenuFont.Height = -11
    MenuFont.Name = 'Tahoma'
    MenuFont.Style = []
    DrawModule = BcXPMenuDrawModule1
    Left = 560
    Top = 120
    object N1: TMenuItem
      Caption = '-'
      Hint = 'abc'
    end
    object test1: TMenuItem
      Caption = 'test'
      OnClick = test1Click
    end
  end
  object BcXPMenuDrawModule1: TBcXPMenuDrawModule
    Left = 568
    Top = 352
  end
  object JvWavePlayer1: TJvWavePlayer
    FileName = 
      'V:\temp\p3info\inject\test6\sound\3659__NoiseCollector__SYKOFONE' +
      '.wav'
    Left = 512
    Top = 176
  end
end
