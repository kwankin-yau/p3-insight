object frmExeBinEd: TfrmExeBinEd
  Left = 0
  Top = 0
  Caption = 'EXE editor'
  ClientHeight = 634
  ClientWidth = 932
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 932
    Height = 615
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Image'
      ExplicitTop = 24
      ExplicitHeight = 587
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 705
        Height = 588
        Align = alLeft
        Caption = 'Panel1'
        TabOrder = 0
        ExplicitHeight = 587
        object ImageGrid: TVirtualStringTree
          Left = 1
          Top = 30
          Width = 703
          Height = 458
          Align = alClient
          Header.AutoSizeIndex = 0
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'Tahoma'
          Header.Font.Style = []
          Header.Options = [hoColumnResize, hoDrag, hoOwnerDraw, hoVisible]
          Header.Style = hsXPStyle
          TabOrder = 0
          TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning]
          TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowHorzGridLines, toShowVertGridLines, toThemeAware, toUseBlendedImages]
          TreeOptions.SelectionOptions = [toExtendedFocus]
          OnBeforeCellPaint = ImageGridBeforeCellPaint
          OnChange = ImageGridChange
          OnFocusChanged = ImageGridFocusChanged
          OnFocusChanging = ImageGridFocusChanging
          OnGetText = ImageGridGetText
          OnPaintText = ImageGridPaintText
          OnHeaderDraw = ImageGridHeaderDraw
          ExplicitHeight = 457
          Columns = <
            item
              Color = clBtnFace
              Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible]
              Position = 0
              Style = vsOwnerDraw
              Width = 90
              WideText = 'Offset'
            end
            item
              Margin = 0
              Position = 1
              Spacing = 0
              Style = vsOwnerDraw
              Width = 36
              WideText = '00'
            end
            item
              Margin = 0
              Position = 2
              Spacing = 0
              Style = vsOwnerDraw
              Width = 36
              WideText = '01'
            end
            item
              Margin = 0
              Position = 3
              Spacing = 0
              Style = vsOwnerDraw
              Width = 36
              WideText = '02'
            end
            item
              Margin = 0
              Position = 4
              Spacing = 0
              Style = vsOwnerDraw
              Width = 36
              WideText = '03'
            end
            item
              Color = 15198183
              Margin = 0
              Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible]
              Position = 5
              Spacing = 0
              Style = vsOwnerDraw
              Width = 36
              WideText = '04'
            end
            item
              Color = 15198183
              Margin = 0
              Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible]
              Position = 6
              Spacing = 0
              Style = vsOwnerDraw
              Width = 36
              WideText = '05'
            end
            item
              Color = 15198183
              Margin = 0
              Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible]
              Position = 7
              Spacing = 0
              Style = vsOwnerDraw
              Width = 36
              WideText = '06'
            end
            item
              Color = 15198183
              Margin = 0
              Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible]
              Position = 8
              Spacing = 0
              Style = vsOwnerDraw
              Width = 36
              WideText = '07'
            end
            item
              Margin = 0
              Position = 9
              Spacing = 0
              Style = vsOwnerDraw
              Width = 36
              WideText = '08'
            end
            item
              Margin = 0
              Position = 10
              Spacing = 0
              Style = vsOwnerDraw
              Width = 36
              WideText = '09'
            end
            item
              Margin = 0
              Position = 11
              Spacing = 0
              Style = vsOwnerDraw
              Width = 36
              WideText = '0A'
            end
            item
              Margin = 0
              Position = 12
              Spacing = 0
              Style = vsOwnerDraw
              Width = 36
              WideText = '0B'
            end
            item
              Color = 15198183
              Margin = 0
              Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible]
              Position = 13
              Spacing = 0
              Style = vsOwnerDraw
              Width = 36
              WideText = '0C'
            end
            item
              Color = 15198183
              Margin = 0
              Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible]
              Position = 14
              Spacing = 0
              Style = vsOwnerDraw
              Width = 36
              WideText = '0D'
            end
            item
              Color = 15198183
              Margin = 0
              Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible]
              Position = 15
              Spacing = 0
              Style = vsOwnerDraw
              Width = 36
              WideText = '0E'
            end
            item
              Color = 15198183
              Margin = 0
              Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible]
              Position = 16
              Spacing = 0
              Style = vsOwnerDraw
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
            Width = 48
            Height = 12
            Caption = 'Section:'
          end
          object lblSectionInfo: TLabel
            Left = 232
            Top = 8
            Width = 84
            Height = 12
            Caption = 'lblSectionInfo'
          end
          object cbSections: TComboBox
            Left = 64
            Top = 5
            Width = 161
            Height = 20
            Style = csDropDownList
            ItemHeight = 12
            TabOrder = 0
            OnChange = cbSectionsChange
          end
        end
        object Panel3: TPanel
          Left = 1
          Top = 488
          Width = 703
          Height = 99
          Align = alBottom
          TabOrder = 2
          ExplicitTop = 487
          object Label2: TLabel
            Left = 102
            Top = 8
            Width = 12
            Height = 12
            Caption = 'B:'
          end
          object Label3: TLabel
            Left = 215
            Top = 8
            Width = 12
            Height = 12
            Caption = 'W:'
          end
          object Label4: TLabel
            Left = 350
            Top = 8
            Width = 12
            Height = 12
            Caption = 'D:'
          end
          object Label5: TLabel
            Left = 102
            Top = 32
            Width = 30
            Height = 12
            Caption = 'Text:'
          end
          object Label6: TLabel
            Left = 520
            Top = 8
            Width = 24
            Height = 12
            Caption = 'Ofs:'
          end
          object lblOfs: TLabel
            Left = 586
            Top = 6
            Width = 76
            Height = 14
            Caption = '$0000 0000'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label111: TLabel
            Left = 520
            Top = 29
            Width = 36
            Height = 12
            Caption = 'Delta:'
          end
          object lblDelta: TLabel
            Left = 586
            Top = 28
            Width = 76
            Height = 14
            Caption = '$0000 0000'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object edByteValue: TEdit
            Left = 118
            Top = 5
            Width = 41
            Height = 20
            TabOrder = 0
          end
          object btnSet: TButton
            Left = 166
            Top = 5
            Width = 31
            Height = 21
            Caption = 'Set'
            TabOrder = 1
          end
          object Button1: TButton
            Left = 304
            Top = 5
            Width = 31
            Height = 21
            Caption = 'Set'
            TabOrder = 2
          end
          object edWordValue: TEdit
            Left = 234
            Top = 5
            Width = 61
            Height = 20
            TabOrder = 3
          end
          object edDWordValue: TEdit
            Left = 367
            Top = 5
            Width = 107
            Height = 20
            TabOrder = 4
          end
          object Button2: TButton
            Left = 480
            Top = 5
            Width = 31
            Height = 21
            Caption = 'Set'
            TabOrder = 5
          end
          object cbUnsigned: TCheckBox
            Left = 8
            Top = 6
            Width = 67
            Height = 17
            Caption = 'Unsigned'
            TabOrder = 6
            OnClick = cbUnsignedClick
          end
          object edTextValue: TMemo
            Left = 136
            Top = 31
            Width = 375
            Height = 63
            ScrollBars = ssBoth
            TabOrder = 7
          end
          object gbCodePage: TGroupBox
            Left = 8
            Top = 28
            Width = 88
            Height = 63
            Caption = 'Code page'
            TabOrder = 8
            object rgCP_GB2312: TRadioButton
              Left = 8
              Top = 16
              Width = 74
              Height = 18
              Caption = 'GB2312'
              Checked = True
              TabOrder = 0
              TabStop = True
            end
            object rgUnicode: TRadioButton
              Left = 8
              Top = 40
              Width = 74
              Height = 17
              Caption = 'rgUnicode'
              TabOrder = 1
            end
          end
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Sections'
      ImageIndex = 1
      ExplicitTop = 24
      ExplicitHeight = 587
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 615
    Width = 932
    Height = 19
    Panels = <
      item
        Text = 'File'
        Width = 40
      end
      item
        Width = 28
      end
      item
        Width = 50
      end>
  end
  object MainMenu1: TMainMenu
    Left = 232
    Top = 368
    object File1: TMenuItem
      Caption = '&File'
      object miOpen: TMenuItem
        Caption = '&Open...'
        OnClick = miOpenClick
      end
      object miBackupFile: TMenuItem
        Caption = '&Backup...'
        OnClick = miBackupFileClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object miExit: TMenuItem
        Caption = 'E&xit'
        OnClick = miExitClick
      end
    end
    object Search1: TMenuItem
      Caption = '&Search'
      object miGoto: TMenuItem
        Caption = '&Go to...'
        OnClick = miGotoClick
      end
    end
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'EXE'
    Filter = 'Exe files(*.exe)|*.exe'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Open'
    Left = 456
    Top = 320
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'EXE'
    Filter = 'Exe files(*.exe)|*.exe'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Save'
    Left = 280
    Top = 280
  end
end
