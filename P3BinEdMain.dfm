object frmExeBinEd: TfrmExeBinEd
  Left = 0
  Top = 0
  Caption = 'EXE editor'
  ClientHeight = 614
  ClientWidth = 932
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 932
    Height = 614
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Image'
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 705
        Height = 586
        Align = alLeft
        Caption = 'Panel1'
        TabOrder = 0
        object ImageGrid: TVirtualStringTree
          Left = 1
          Top = 30
          Width = 703
          Height = 525
          Align = alClient
          Header.AutoSizeIndex = 0
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'Tahoma'
          Header.Font.Style = []
          Header.Options = [hoColumnResize, hoDrag, hoVisible]
          Header.Style = hsXPStyle
          TabOrder = 0
          TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning]
          TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowHorzGridLines, toShowVertGridLines, toThemeAware, toUseBlendedImages]
          TreeOptions.SelectionOptions = [toExtendedFocus]
          Columns = <
            item
              Position = 0
              Width = 80
              WideText = 'Offset'
            end
            item
              Margin = 0
              Position = 1
              Spacing = 0
              Width = 36
              WideText = '00'
            end
            item
              Margin = 0
              Position = 2
              Spacing = 0
              Width = 36
              WideText = '01'
            end
            item
              Margin = 0
              Position = 3
              Spacing = 0
              Width = 36
              WideText = '02'
            end
            item
              Margin = 0
              Position = 4
              Spacing = 0
              Width = 36
              WideText = '03'
            end
            item
              Margin = 0
              Position = 5
              Spacing = 0
              Width = 36
              WideText = '04'
            end
            item
              Margin = 0
              Position = 6
              Spacing = 0
              Width = 36
              WideText = '05'
            end
            item
              Margin = 0
              Position = 7
              Spacing = 0
              Width = 36
              WideText = '06'
            end
            item
              Margin = 0
              Position = 8
              Spacing = 0
              Width = 36
              WideText = '07'
            end
            item
              Margin = 0
              Position = 9
              Spacing = 0
              Width = 36
              WideText = '08'
            end
            item
              Margin = 0
              Position = 10
              Spacing = 0
              Width = 36
              WideText = '09'
            end
            item
              Margin = 0
              Position = 11
              Spacing = 0
              Width = 36
              WideText = '0A'
            end
            item
              Margin = 0
              Position = 12
              Spacing = 0
              Width = 36
              WideText = '0B'
            end
            item
              Margin = 0
              Position = 13
              Spacing = 0
              Width = 36
              WideText = '0C'
            end
            item
              Margin = 0
              Position = 14
              Spacing = 0
              Width = 36
              WideText = '0D'
            end
            item
              Margin = 0
              Position = 15
              Spacing = 0
              Width = 36
              WideText = '0E'
            end
            item
              Margin = 0
              Position = 16
              Spacing = 0
              Width = 36
              WideText = '0F'
            end>
          WideDefaultText = ''
        end
        object Panel2: TPanel
          Left = 1
          Top = 1
          Width = 703
          Height = 29
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
          object Label1: TLabel
            Left = 8
            Top = 8
            Width = 39
            Height = 13
            Caption = 'Section:'
          end
          object cbSections: TComboBox
            Left = 64
            Top = 5
            Width = 161
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            TabOrder = 0
          end
        end
        object Panel3: TPanel
          Left = 1
          Top = 555
          Width = 703
          Height = 30
          Align = alBottom
          TabOrder = 2
          object Label2: TLabel
            Left = 8
            Top = 8
            Width = 10
            Height = 13
            Caption = 'B:'
          end
          object Label3: TLabel
            Left = 121
            Top = 8
            Width = 14
            Height = 13
            Caption = 'W:'
          end
          object Label4: TLabel
            Left = 256
            Top = 8
            Width = 11
            Height = 13
            Caption = 'D:'
          end
          object Edit1: TEdit
            Left = 24
            Top = 5
            Width = 41
            Height = 21
            TabOrder = 0
            Text = 'Edit1'
          end
          object btnSet: TButton
            Left = 72
            Top = 5
            Width = 31
            Height = 21
            Caption = 'Set'
            TabOrder = 1
          end
          object Button1: TButton
            Left = 210
            Top = 5
            Width = 31
            Height = 21
            Caption = 'Set'
            TabOrder = 2
          end
          object Edit2: TEdit
            Left = 140
            Top = 5
            Width = 61
            Height = 21
            TabOrder = 3
            Text = 'Edit1'
          end
          object Edit3: TEdit
            Left = 273
            Top = 5
            Width = 107
            Height = 21
            TabOrder = 4
            Text = 'Edit1'
          end
          object Button2: TButton
            Left = 386
            Top = 5
            Width = 31
            Height = 21
            Caption = 'Set'
            TabOrder = 5
          end
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Sections'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
  end
  object MainMenu1: TMainMenu
    Left = 232
    Top = 368
    object File1: TMenuItem
      Caption = '&File'
      object miOpen: TMenuItem
        Caption = '&Open'
        OnClick = miOpenClick
      end
      object miExit: TMenuItem
        Caption = 'E&xit'
        OnClick = miExitClick
      end
    end
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'EXE'
    Filter = 'Exe files(*.exe)|*.exe'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 456
    Top = 320
  end
end
