object frmExeEdGoto: TfrmExeEdGoto
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Go to'
  ClientHeight = 182
  ClientWidth = 267
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 42
    Height = 12
    Caption = '&Offset:'
    FocusControl = edOffset
  end
  object edOffset: TEdit
    Left = 64
    Top = 13
    Width = 193
    Height = 20
    TabOrder = 0
  end
  object rgRelative: TRadioGroup
    Left = 8
    Top = 39
    Width = 249
    Height = 97
    Caption = 'Relative to'
    ItemIndex = 0
    Items.Strings = (
      'Absolute'
      'Offset to current SECTION'
      'Offset to current POSITION')
    TabOrder = 1
  end
  object btnOk: TButton
    Left = 55
    Top = 144
    Width = 75
    Height = 25
    Caption = #30830#23450
    TabOrder = 2
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 136
    Top = 144
    Width = 75
    Height = 25
    Cancel = True
    Caption = #21462#28040
    ModalResult = 2
    TabOrder = 3
  end
end
