object frmP3Editor: TfrmP3Editor
  Left = 0
  Top = 0
  AlphaBlendValue = 50
  Caption = 'P3Ed - R1 - '#35760#24471#20808#25913#33337#21517' - by alphax'
  ClientHeight = 716
  ClientWidth = 1001
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object pcMain: TPageControl
    Left = 0
    Top = 0
    Width = 1001
    Height = 716
    ActivePage = TabSheet6
    Align = alClient
    TabOrder = 0
    TabPosition = tpBottom
    object TabSheet4: TTabSheet
      Caption = #33337#21482#25968#25454
      object Panel3: TPanel
        Left = 422
        Top = 0
        Width = 571
        Height = 626
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 0
        object PageControl1: TPageControl
          Left = 0
          Top = 134
          Width = 571
          Height = 492
          ActivePage = TabSheet10
          Align = alClient
          TabOrder = 0
          object TabSheet1: TTabSheet
            Caption = #36135#29289
            object GoodsGrid: TVirtualStringTree
              Left = 0
              Top = 0
              Width = 392
              Height = 465
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
              TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning]
              TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowHorzGridLines, toShowVertGridLines, toThemeAware, toUseBlendedImages]
              TreeOptions.SelectionOptions = [toExtendedFocus, toFullRowSelect, toMultiSelect]
              OnGetText = GoodsGridGetText
              Columns = <
                item
                  Position = 0
                  Width = 80
                  WideText = #36135#29289
                end
                item
                  Position = 1
                  WideText = #21333#20301
                end
                item
                  Position = 2
                  Width = 70
                  WideText = #25968#37327
                end>
              WideDefaultText = ''
            end
            object Panel5: TPanel
              Left = 392
              Top = 0
              Width = 171
              Height = 465
              Align = alRight
              TabOrder = 1
              object Label16: TLabel
                Left = 144
                Top = 136
                Width = 12
                Height = 12
                Caption = #21253
              end
              object Label18: TLabel
                Left = 18
                Top = 17
                Width = 150
                Height = 12
                Caption = #36135#29289'+'#22478#24066#27494#22120#24635#36733#37325'('#26742')'#65306
              end
              object btnSetAllGoodsQtyTo: TButton
                Left = 16
                Top = 69
                Width = 140
                Height = 25
                Caption = #20840#37096'4500'#21253
                TabOrder = 0
                OnClick = btnSetAllGoodsQtyToClick
              end
              object btnSetSelectedGoodsQtyTo: TButton
                Left = 16
                Top = 100
                Width = 140
                Height = 25
                Caption = #35813#36873#20013#30340#20026'4500'#21253
                TabOrder = 1
                OnClick = btnSetSelectedGoodsQtyToClick
              end
              object btnSetGoodsDirect: TButton
                Left = 16
                Top = 131
                Width = 84
                Height = 25
                Caption = #35774#32622#36873#20013#30340#20026
                TabOrder = 2
                OnClick = btnSetGoodsDirectClick
              end
              object btnClearAllGoods: TButton
                Left = 16
                Top = 162
                Width = 140
                Height = 25
                Caption = #28165#31354#20840#37096#36135#29289
                TabOrder = 3
                OnClick = btnClearAllGoodsClick
              end
              object btnSetBuildingMaterialQtyTo: TButton
                Left = 89
                Top = 346
                Width = 38
                Height = 25
                Caption = #24314#26448
                Enabled = False
                TabOrder = 4
                Visible = False
              end
              object btnSetFoodsQtyTo: TButton
                Left = 44
                Top = 346
                Width = 38
                Height = 25
                Caption = #39135#29289
                Enabled = False
                TabOrder = 5
                Visible = False
                OnClick = btnSetFoodsQtyToClick
              end
              object edGoodsQty: TEdit
                Left = 104
                Top = 133
                Width = 38
                Height = 20
                TabOrder = 6
                Text = '4500'
              end
              object gbCityWeapon: TGroupBox
                Left = 16
                Top = 198
                Width = 141
                Height = 141
                Caption = #22478#24066#25163#25345#27494#22120
                TabOrder = 7
                object Label17: TLabel
                  Left = 8
                  Top = 16
                  Width = 24
                  Height = 12
                  Caption = #20992#65306
                end
                object lblCW1: TLabel
                  Left = 64
                  Top = 16
                  Width = 36
                  Height = 12
                  Caption = 'lblCW1'
                end
                object Label19: TLabel
                  Left = 8
                  Top = 34
                  Width = 24
                  Height = 12
                  Caption = #24339#65306
                end
                object lblCW2: TLabel
                  Left = 64
                  Top = 34
                  Width = 36
                  Height = 12
                  Caption = 'lblCW2'
                end
                object Label21: TLabel
                  Left = 8
                  Top = 53
                  Width = 48
                  Height = 12
                  Caption = #21313#23383#24339#65306
                end
                object lblCW3: TLabel
                  Left = 64
                  Top = 53
                  Width = 36
                  Height = 12
                  Caption = 'lblCW3'
                end
                object Label23: TLabel
                  Left = 8
                  Top = 72
                  Width = 48
                  Height = 12
                  Caption = #21345#23486#26538#65306
                end
                object lblCW4: TLabel
                  Left = 64
                  Top = 72
                  Width = 36
                  Height = 12
                  Caption = 'lblCW4'
                end
                object Bevel6: TBevel
                  Left = 10
                  Top = 93
                  Width = 121
                  Height = 2
                end
                object btnFillCityWeapon: TButton
                  Left = 9
                  Top = 101
                  Width = 72
                  Height = 25
                  Caption = #20840#37096'10000'
                  TabOrder = 0
                  OnClick = btnFillCityWeaponClick
                end
                object btnClearCityWeapon: TButton
                  Left = 88
                  Top = 101
                  Width = 44
                  Height = 25
                  Caption = #28165#31354
                  TabOrder = 1
                  OnClick = btnClearCityWeaponClick
                end
              end
              object edTotalLoad: TEdit
                Left = 43
                Top = 35
                Width = 70
                Height = 20
                ReadOnly = True
                TabOrder = 8
              end
              object btnSetTotalLoad: TButton
                Left = 120
                Top = 32
                Width = 36
                Height = 25
                Caption = #35774#32622
                TabOrder = 9
                Visible = False
                OnClick = btnSetTotalLoadClick
              end
            end
          end
          object TabSheet3: TTabSheet
            Caption = #20869#23384#35270#22270
            ImageIndex = 2
            object MemGrid: TVirtualStringTree
              Left = 0
              Top = 0
              Width = 563
              Height = 446
              Align = alClient
              Colors.FocusedSelectionColor = clWhite
              Colors.FocusedSelectionBorderColor = clWhite
              Colors.SelectionRectangleBlendColor = clWhite
              Colors.SelectionRectangleBorderColor = clWhite
              Colors.UnfocusedSelectionColor = clWhite
              Colors.UnfocusedSelectionBorderColor = clWhite
              Colors.HighlightTextColor = clWindowText
              Header.AutoSizeIndex = 0
              Header.Font.Charset = DEFAULT_CHARSET
              Header.Font.Color = clWindowText
              Header.Font.Height = -11
              Header.Font.Name = 'Tahoma'
              Header.Font.Style = []
              Header.Options = [hoColumnResize, hoDrag, hoVisible]
              Header.Style = hsXPStyle
              PopupMenu = pmShipMemGrid
              TabOrder = 0
              TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning]
              TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowHorzGridLines, toShowVertGridLines, toThemeAware, toUseBlendedImages]
              TreeOptions.SelectionOptions = [toExtendedFocus]
              OnBeforeCellPaint = MemGridBeforeCellPaint
              OnChange = MemGridChange
              OnFocusChanged = MemGridFocusChanged
              OnGetText = MemGridGetText
              OnPaintText = MemGridPaintText
              OnGetSelectionBkColor = MemGridGetSelectionBkColor
              Columns = <
                item
                  Position = 0
                  Width = 90
                  WideText = 'Addr'
                end
                item
                  Margin = 0
                  Position = 1
                  Spacing = 0
                  Width = 28
                  WideText = '00'
                end
                item
                  Margin = 0
                  Position = 2
                  Spacing = 0
                  Width = 28
                  WideText = '01'
                end
                item
                  Margin = 0
                  Position = 3
                  Spacing = 0
                  Width = 28
                  WideText = '02'
                end
                item
                  Margin = 0
                  Position = 4
                  Spacing = 0
                  Width = 28
                  WideText = '03'
                end
                item
                  Margin = 0
                  Position = 5
                  Spacing = 0
                  Width = 28
                  WideText = '04'
                end
                item
                  Margin = 0
                  Position = 6
                  Spacing = 0
                  Width = 28
                  WideText = '05'
                end
                item
                  Margin = 0
                  Position = 7
                  Spacing = 0
                  Width = 28
                  WideText = '06'
                end
                item
                  Margin = 0
                  Position = 8
                  Spacing = 0
                  Width = 28
                  WideText = '07'
                end
                item
                  Margin = 0
                  Position = 9
                  Spacing = 0
                  Width = 28
                  WideText = '08'
                end
                item
                  Margin = 0
                  Position = 10
                  Spacing = 0
                  Width = 28
                  WideText = '09'
                end
                item
                  Margin = 0
                  Position = 11
                  Spacing = 0
                  Width = 28
                  WideText = '0A'
                end
                item
                  Margin = 0
                  Position = 12
                  Spacing = 0
                  Width = 28
                  WideText = '0B'
                end
                item
                  Margin = 0
                  Position = 13
                  Spacing = 0
                  Width = 28
                  WideText = '0C'
                end
                item
                  Margin = 0
                  Position = 14
                  Spacing = 0
                  Width = 28
                  WideText = '0D'
                end
                item
                  Margin = 0
                  Position = 15
                  Spacing = 0
                  Width = 28
                  WideText = '0E'
                end
                item
                  Margin = 0
                  Position = 16
                  Spacing = 0
                  Width = 28
                  WideText = '0F'
                end>
              WideDefaultText = ''
            end
            object memValue: TStatusBar
              Left = 0
              Top = 446
              Width = 563
              Height = 19
              Panels = <
                item
                  Width = 40
                end
                item
                  Width = 80
                end
                item
                  Width = 160
                end
                item
                  Width = 50
                end>
              SizeGrip = False
              OnDblClick = memValueDblClick
            end
          end
          object TabSheet2: TTabSheet
            Caption = #31508#35760
            ImageIndex = 2
            object Panel8: TPanel
              Left = 0
              Top = 0
              Width = 563
              Height = 112
              Align = alTop
              TabOrder = 0
              object GroupBox3: TGroupBox
                Left = 1
                Top = 1
                Width = 561
                Height = 110
                Align = alClient
                Caption = #35745#31639
                TabOrder = 0
                object edCalcExpr: TEdit
                  Left = 16
                  Top = 13
                  Width = 177
                  Height = 20
                  TabOrder = 0
                end
                object btnCalc: TButton
                  Left = 199
                  Top = 11
                  Width = 33
                  Height = 25
                  Caption = '='
                  TabOrder = 1
                  OnClick = btnCalcClick
                end
                object btnIntToHex: TButton
                  Left = 239
                  Top = 11
                  Width = 57
                  Height = 25
                  Caption = 'int->hex'
                  TabOrder = 2
                  OnClick = btnIntToHexClick
                end
                object btnHexToInt: TButton
                  Left = 304
                  Top = 11
                  Width = 57
                  Height = 25
                  Caption = 'hex->int'
                  TabOrder = 3
                  OnClick = btnHexToIntClick
                end
                object edCalcResult: TEdit
                  Left = 367
                  Top = 14
                  Width = 178
                  Height = 20
                  TabOrder = 4
                end
                object rgShiftBits: TRadioGroup
                  Left = 238
                  Top = 37
                  Width = 139
                  Height = 31
                  Caption = 'rgShiftBits'
                  Columns = 4
                  ItemIndex = 0
                  Items.Strings = (
                    '4'
                    '5'
                    '6'
                    '7')
                  TabOrder = 5
                end
                object btnShl: TButton
                  Left = 184
                  Top = 42
                  Width = 46
                  Height = 25
                  Caption = 'shl'
                  TabOrder = 6
                  OnClick = btnShlClick
                end
                object btnCalcF1: TButton
                  Left = 384
                  Top = 40
                  Width = 75
                  Height = 25
                  Caption = 'F1'
                  TabOrder = 7
                  OnClick = btnCalcF1Click
                end
                object rgF1Delta: TRadioGroup
                  Left = 373
                  Top = 68
                  Width = 185
                  Height = 39
                  Caption = 'rgF1Delta'
                  Columns = 3
                  ItemIndex = 0
                  Items.Strings = (
                    '+$0'
                    '+$134'
                    '+$160')
                  TabOrder = 8
                end
                object btnF2: TButton
                  Left = 464
                  Top = 40
                  Width = 75
                  Height = 25
                  Caption = 'F2'
                  TabOrder = 9
                  OnClick = btnF2Click
                end
              end
            end
            object Note: TMemo
              Left = 0
              Top = 112
              Width = 563
              Height = 353
              Align = alClient
              TabOrder = 1
              OnChange = NoteChange
            end
          end
          object TabSheet10: TTabSheet
            Caption = 'TabSheet10'
            ImageIndex = 3
            object Label49: TLabel
              Left = 16
              Top = 8
              Width = 72
              Height = 12
              Caption = 'Trade route:'
            end
            object Label51: TLabel
              Left = 296
              Top = 83
              Width = 36
              Height = 12
              Caption = 'Pos X:'
            end
            object Label52: TLabel
              Left = 296
              Top = 123
              Width = 36
              Height = 12
              Caption = 'Pos Y:'
            end
            object lblGroupFirstShipIndex: TLabel
              Left = 422
              Top = 343
              Width = 132
              Height = 12
              Caption = 'lblGroupFirstShipIndex'
            end
            object Label57: TLabel
              Left = 296
              Top = 343
              Width = 120
              Height = 12
              Caption = 'GroupFirstShipIndex:'
            end
            object lblShipGroupIndex: TLabel
              Left = 371
              Top = 312
              Width = 102
              Height = 12
              Caption = 'lblShipGroupIndex'
            end
            object Label59: TLabel
              Left = 296
              Top = 312
              Width = 66
              Height = 12
              Caption = 'GroupIndex:'
            end
            object Label62: TLabel
              Left = 296
              Top = 368
              Width = 54
              Height = 12
              Caption = 'Index 3C:'
            end
            object lblShipIndex3C: TLabel
              Left = 368
              Top = 368
              Width = 84
              Height = 12
              Caption = 'lblShipIndex3C'
            end
            object Label63: TLabel
              Left = 296
              Top = 392
              Width = 90
              Height = 12
              Caption = 'Group info ptr:'
            end
            object lblShipGroupInfoPtr: TLabel
              Left = 400
              Top = 392
              Width = 114
              Height = 12
              Caption = 'lblShipGroupInfoPtr'
            end
            object memTradeRoute: TMemo
              Left = 16
              Top = 32
              Width = 257
              Height = 393
              ScrollBars = ssBoth
              TabOrder = 0
            end
            object btnDump: TButton
              Left = 299
              Top = 30
              Width = 75
              Height = 25
              Caption = 'btnDump'
              TabOrder = 1
              OnClick = btnDumpClick
            end
            object edShipPosX: TEdit
              Left = 360
              Top = 80
              Width = 121
              Height = 20
              TabOrder = 2
            end
            object edShipPosY: TEdit
              Left = 360
              Top = 120
              Width = 121
              Height = 20
              TabOrder = 3
            end
            object btnSetDest: TButton
              Left = 296
              Top = 168
              Width = 75
              Height = 25
              Caption = 'SetDest'
              TabOrder = 4
              OnClick = btnSetDestClick
            end
            object GroupBox1: TGroupBox
              Left = 296
              Top = 208
              Width = 264
              Height = 89
              Caption = #33337#38271
              TabOrder = 5
              object Label56: TLabel
                Left = 16
                Top = 24
                Width = 60
                Height = 12
                Caption = #20986#29983#26085#26399#65306
              end
              object Label58: TLabel
                Left = 16
                Top = 53
                Width = 48
                Height = 12
                Caption = 'Pointer:'
              end
              object edPtrOfCaptain: TEdit
                Left = 88
                Top = 50
                Width = 121
                Height = 20
                TabOrder = 0
                Text = 'edPtrOfCaptain'
              end
              object edCaptainBirthday: TEdit
                Left = 88
                Top = 24
                Width = 121
                Height = 20
                TabOrder = 1
                Text = 'edCaptainBirthday'
              end
              object btnSetCaptainBirthday: TButton
                Left = 215
                Top = 19
                Width = 50
                Height = 25
                Caption = 'btnSetCaptainBirthday'
                TabOrder = 2
                OnClick = btnSetCaptainBirthdayClick
              end
            end
          end
        end
        object Panel4: TPanel
          Left = 0
          Top = 0
          Width = 571
          Height = 134
          Align = alTop
          TabOrder = 1
          object Bevel7: TBevel
            Left = 286
            Top = 79
            Width = 270
            Height = 48
            Style = bsRaised
          end
          object Bevel5: TBevel
            Left = 464
            Top = 99
            Width = 80
            Height = 24
          end
          object Bevel4: TBevel
            Left = 381
            Top = 99
            Width = 80
            Height = 24
          end
          object Bevel2: TBevel
            Left = 299
            Top = 99
            Width = 80
            Height = 24
          end
          object Label1: TLabel
            Left = 16
            Top = 13
            Width = 36
            Height = 12
            Caption = #21517#31216#65306
          end
          object Label3: TLabel
            Left = 16
            Top = 61
            Width = 36
            Height = 12
            Caption = #23481#37327#65306
          end
          object Label7: TLabel
            Left = 16
            Top = 37
            Width = 36
            Height = 12
            Caption = #32423#21035#65306
          end
          object Label8: TLabel
            Left = 16
            Top = 85
            Width = 36
            Height = 12
            Caption = #32784#20037#65306
          end
          object Label2: TLabel
            Left = 16
            Top = 109
            Width = 36
            Height = 12
            Caption = #33337#38271#65306
          end
          object Label4: TLabel
            Left = 286
            Top = 13
            Width = 36
            Height = 12
            Caption = #29366#24577#65306
          end
          object Label5: TLabel
            Left = 286
            Top = 61
            Width = 36
            Height = 12
            Caption = #27700#25163#65306
          end
          object Label9: TLabel
            Left = 432
            Top = 11
            Width = 36
            Height = 12
            Caption = #30701#21073#65306
          end
          object Label11: TLabel
            Left = 321
            Top = 83
            Width = 36
            Height = 12
            Caption = #22987#21457#22320
          end
          object lblFrom: TLabel
            Left = 301
            Top = 105
            Width = 74
            Height = 12
            AutoSize = False
            Caption = '00'
          end
          object Label13: TLabel
            Left = 409
            Top = 83
            Width = 24
            Height = 12
            Caption = #24403#21069
          end
          object lblCurrPlace: TLabel
            Left = 384
            Top = 105
            Width = 74
            Height = 12
            AutoSize = False
            Caption = '00'
          end
          object Label15: TLabel
            Left = 486
            Top = 83
            Width = 36
            Height = 12
            Caption = #30446#30340#22320
          end
          object lblTo: TLabel
            Left = 467
            Top = 105
            Width = 74
            Height = 12
            AutoSize = False
            Caption = '00'
          end
          object lblUnit: TLabel
            Left = 144
            Top = 61
            Width = 24
            Height = 12
            Caption = '('#26742')'
          end
          object Label12: TLabel
            Left = 433
            Top = 63
            Width = 36
            Height = 12
            Caption = #22763#27668#65306
          end
          object lblShiQi: TLabel
            Left = 471
            Top = 63
            Width = 48
            Height = 12
            Caption = 'lblShiQi'
          end
          object lblShipWeapon: TLabel
            Left = 471
            Top = 10
            Width = 78
            Height = 12
            Caption = 'lblShipWeapon'
          end
          object Label14: TLabel
            Left = 286
            Top = 37
            Width = 36
            Height = 12
            Caption = #28779#21147#65306
          end
          object lblPower: TLabel
            Left = 328
            Top = 37
            Width = 48
            Height = 12
            Caption = 'lblPower'
          end
          object Bevel3: TBevel
            Left = 384
            Top = 136
            Width = 50
            Height = 50
          end
          object Image1: TImage
            Left = 374
            Top = 81
            Width = 16
            Height = 16
            AutoSize = True
            Picture.Data = {
              07544269746D6170F6000000424DF60000000000000076000000280000001000
              0000100000000100040000000000800000000000000000000000100000000000
              0000000000000000800000800000008080008000000080008000808000008080
              8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
              FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2FF
              FFFFFFFFFFFFF22FFFFFFFFFFFFFF222FFFFFF22222222222FFFFF2222222222
              22FFFF2222222222222FFF222222222222FFFF22222222222FFFFFFFFFFFF222
              FFFFFFFFFFFFF22FFFFFFFFFFFFFF2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFF}
            Transparent = True
          end
          object Image2: TImage
            Left = 456
            Top = 81
            Width = 16
            Height = 16
            AutoSize = True
            Picture.Data = {
              07544269746D6170F6000000424DF60000000000000076000000280000001000
              0000100000000100040000000000800000000000000000000000100000000000
              0000000000000000800000800000008080008000000080008000808000008080
              8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
              FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2FF
              FFFFFFFFFFFFF22FFFFFFFFFFFFFF222FFFFFF22222222222FFFFF2222222222
              22FFFF2222222222222FFF222222222222FFFF22222222222FFFFFFFFFFFF222
              FFFFFFFFFFFFF22FFFFFFFFFFFFFF2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFF}
            Transparent = True
          end
          object btnSetLoad: TButton
            Left = 171
            Top = 58
            Width = 40
            Height = 20
            Caption = #35774#32622
            TabOrder = 0
            OnClick = btnSetLoadClick
          end
          object btnMaxStrong: TButton
            Left = 217
            Top = 82
            Width = 48
            Height = 20
            Caption = #39044#35774#20540
            TabOrder = 1
            OnClick = btnMaxStrongClick
          end
          object btnSetCaptain: TButton
            Left = 171
            Top = 106
            Width = 40
            Height = 20
            Caption = #35774#32622
            TabOrder = 2
            OnClick = btnSetCaptainClick
          end
          object btnFullCannons: TButton
            Left = 433
            Top = 33
            Width = 123
            Height = 20
            Caption = #20840#37096#21152#20892#28846
            TabOrder = 3
            OnClick = btnFullCannonsClick
          end
          object btnState0: TButton
            Left = 375
            Top = 8
            Width = 40
            Height = 20
            Caption = #35774#32622
            TabOrder = 4
            OnClick = btnState0Click
          end
          object btnSetShuiShou: TButton
            Left = 375
            Top = 55
            Width = 40
            Height = 20
            Caption = #35774#32622
            TabOrder = 5
            OnClick = btnSetShuiShouClick
          end
          object edState: TEdit
            Left = 328
            Top = 10
            Width = 42
            Height = 20
            TabOrder = 6
          end
          object edShuiShou: TEdit
            Left = 328
            Top = 57
            Width = 42
            Height = 20
            TabOrder = 7
          end
          object edLoadLimit: TEdit
            Left = 58
            Top = 59
            Width = 79
            Height = 20
            TabOrder = 8
          end
          object btnMaxLoad: TButton
            Left = 217
            Top = 58
            Width = 48
            Height = 20
            Caption = #39044#35774#20540
            TabOrder = 9
            OnClick = btnMaxLoadClick
          end
          object btnMaxShiQi: TButton
            Left = 517
            Top = 58
            Width = 39
            Height = 20
            Caption = #26368#22823
            TabOrder = 10
            OnClick = btnMaxShiQiClick
          end
          object btnMaxShipWeapon: TButton
            Left = 516
            Top = 8
            Width = 40
            Height = 20
            Caption = #39044#35774#20540
            TabOrder = 11
            OnClick = btnMaxShipWeaponClick
          end
          object cbCaptain: TComboBox
            Left = 58
            Top = 105
            Width = 108
            Height = 20
            ItemHeight = 12
            TabOrder = 12
          end
          object btnFavCaptain: TButton
            Left = 217
            Top = 107
            Width = 48
            Height = 19
            Caption = #39044#35774#20540
            TabOrder = 13
            OnClick = btnFavCaptainClick
          end
          object edShipName: TEdit
            Left = 58
            Top = 10
            Width = 108
            Height = 20
            TabOrder = 14
          end
          object btnSetShipName: TButton
            Left = 171
            Top = 8
            Width = 40
            Height = 20
            Caption = #35774#32622
            TabOrder = 15
            OnClick = btnSetShipNameClick
          end
          object btnSetShipNameToOthers: TButton
            Left = 217
            Top = 8
            Width = 48
            Height = 20
            Caption = #20854#20182
            TabOrder = 16
            OnClick = btnSetShipNameToOthersClick
          end
          object cbShipType: TComboBox
            Left = 58
            Top = 34
            Width = 63
            Height = 20
            Style = csDropDownList
            ItemHeight = 12
            TabOrder = 17
            Items.Strings = (
              #21490#22856#20811
              #20811#38647#23572
              #20811#26684
              #38669#20811#23572)
          end
          object cbShipLevel: TComboBox
            Left = 123
            Top = 34
            Width = 43
            Height = 20
            Style = csDropDownList
            ItemHeight = 12
            TabOrder = 18
            Items.Strings = (
              '1'
              '2'
              '3'
              '4')
          end
          object btnSetShipClass: TButton
            Left = 171
            Top = 34
            Width = 40
            Height = 20
            Caption = #35774#32622
            TabOrder = 19
            OnClick = btnSetShipClassClick
          end
          object edShipCurrPoint: TEdit
            Left = 56
            Top = 80
            Width = 74
            Height = 20
            TabOrder = 20
          end
          object edShipMaxPoint: TEdit
            Left = 132
            Top = 79
            Width = 79
            Height = 20
            TabOrder = 21
          end
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 422
        Height = 626
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object Panel6: TPanel
          Left = 0
          Top = 0
          Width = 422
          Height = 626
          Align = alClient
          Caption = 'Panel6'
          TabOrder = 0
          object ShipGrid: TVirtualStringTree
            Left = 1
            Top = 24
            Width = 420
            Height = 509
            Align = alClient
            CheckImageKind = ckXP
            Colors.FocusedSelectionColor = 15849415
            Colors.FocusedSelectionBorderColor = 15849415
            Colors.SelectionRectangleBlendColor = 15849415
            Colors.SelectionRectangleBorderColor = 15849415
            Header.AutoSizeIndex = 0
            Header.Font.Charset = DEFAULT_CHARSET
            Header.Font.Color = clWindowText
            Header.Font.Height = -11
            Header.Font.Name = 'Tahoma'
            Header.Font.Style = []
            Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
            Header.Style = hsXPStyle
            Images = ImageList1
            PopupMenu = pmShipGrid
            TabOrder = 0
            TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning]
            TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowHorzGridLines, toShowVertGridLines, toThemeAware, toUseBlendedImages]
            TreeOptions.SelectionOptions = [toExtendedFocus, toFullRowSelect]
            OnChange = ShipGridChange
            OnCompareNodes = ShipGridCompareNodes
            OnGetText = ShipGridGetText
            OnPaintText = ShipGridPaintText
            OnGetImageIndex = ShipGridGetImageIndex
            OnHeaderClick = ShipGridHeaderClick
            Columns = <
              item
                Position = 0
                Width = 120
                WideText = #33337#21517
              end
              item
                Position = 1
                WideText = 'Index'
              end
              item
                Position = 2
                Width = 80
                WideText = #32423#21035
              end
              item
                Position = 3
                Width = 44
                WideText = #32784#20037
              end
              item
                Position = 4
                WideText = #33337#38271
              end
              item
                Position = 5
                Width = 46
                WideText = #28779#21147
              end
              item
                Position = 6
                WideText = #22763#27668
              end
              item
                Position = 7
                Width = 80
                WideText = #20869#23384#22320#22336
              end>
            WideDefaultText = ''
          end
          object Panel7: TPanel
            Left = 1
            Top = 533
            Width = 420
            Height = 92
            Align = alBottom
            BevelOuter = bvNone
            TabOrder = 1
            object btnFillAll: TButton
              Left = 100
              Top = 62
              Width = 75
              Height = 25
              Caption = #35774#32622#20840#37096
              TabOrder = 0
              OnClick = btnFillAllClick
            end
            object btnFillSelected: TButton
              Left = 190
              Top = 63
              Width = 75
              Height = 25
              Caption = #35774#32622#21246#36873#30340
              TabOrder = 1
              OnClick = btnFillSelectedClick
            end
            object GroupBox2: TGroupBox
              Left = 7
              Top = 1
              Width = 258
              Height = 58
              TabOrder = 2
              object cbEnsureShuiShou: TCheckBox
                Left = 11
                Top = 13
                Width = 114
                Height = 17
                Caption = #30830#20445#26368#20302#27700#25163#25968
                Checked = True
                State = cbChecked
                TabOrder = 0
              end
              object cbEnsureMaxPower: TCheckBox
                Left = 11
                Top = 36
                Width = 71
                Height = 17
                Caption = #26368#22823#28779#21147
                Checked = True
                State = cbChecked
                TabOrder = 1
              end
              object cbEnsureGoodsFull: TCheckBox
                Left = 90
                Top = 36
                Width = 78
                Height = 17
                Caption = #36135#29289#20840#28385
                TabOrder = 2
              end
              object edEnsureShuiShou: TEdit
                Left = 123
                Top = 11
                Width = 36
                Height = 20
                TabOrder = 3
                Text = '25'
              end
              object cbEnsureShiQiFull: TCheckBox
                Left = 173
                Top = 13
                Width = 76
                Height = 17
                Caption = #22763#27668#20840#28385
                Checked = True
                State = cbChecked
                TabOrder = 4
              end
              object cbEnsurePointFull: TCheckBox
                Left = 173
                Top = 36
                Width = 76
                Height = 17
                Caption = #32784#20037#20840#28385
                Checked = True
                State = cbChecked
                TabOrder = 5
              end
            end
            object btnLockSelected: TButton
              Left = 9
              Top = 63
              Width = 75
              Height = 25
              Caption = #38145#23450#36873#20013#30340
              TabOrder = 3
              OnClick = btnLockSelectedClick
            end
            object btnAutoFillCaptain: TButton
              Left = 280
              Top = 16
              Width = 121
              Height = 25
              Caption = 'AutoFillCaptain'
              TabOrder = 4
              OnClick = btnAutoFillCaptainClick
            end
            object btnTestSetShipDest: TButton
              Left = 288
              Top = 48
              Width = 75
              Height = 25
              Caption = 'Goto $17'
              TabOrder = 5
              OnClick = btnTestSetShipDestClick
            end
          end
          object TabControl1: TTabControl
            Left = 1
            Top = 1
            Width = 420
            Height = 23
            Align = alTop
            TabOrder = 2
            Tabs.Strings = (
              '('#20840#37096')'
              '('#36152#26131')'
              '('#31354#38386')'
              '('#20854#20182')')
            TabIndex = 0
            OnChange = TabControl1Change
          end
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 626
        Width = 993
        Height = 65
        Align = alBottom
        BevelOuter = bvLowered
        TabOrder = 2
        object Label54: TLabel
          Left = 368
          Top = 16
          Width = 18
          Height = 12
          Caption = 't1:'
        end
        object lblGameTime1: TLabel
          Left = 392
          Top = 16
          Width = 72
          Height = 12
          Caption = 'lblGameTime1'
        end
        object Label55: TLabel
          Left = 368
          Top = 40
          Width = 18
          Height = 12
          Caption = 't2:'
        end
        object lblGameTime2: TLabel
          Left = 392
          Top = 40
          Width = 72
          Height = 12
          Caption = 'lblGameTime2'
        end
        object btnRefresh: TBitBtn
          Left = 15
          Top = 12
          Width = 82
          Height = 43
          Caption = #21047#26032'(&R)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -14
          Font.Name = #23435#20307
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = btnRefreshClick
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            0400000000008000000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FF0000000000
            000FFF0FFFFFFFFFFF0FFF0FFFFF2FFFFF0FFF0FFFF22FFFFF0FFF0FFF22222F
            FF0FFF0FFFF22FF2FF0FFF0FFFFF2FF2FF0FFF0FF2FFFFF2FF0FFF0FF2FF2FFF
            FF0FFF0FF2FF22FFFF0FFF0FFF22222FFF0FFF0FFFFF22FFFF0FFF0FFFFF2F00
            000FFF0FFFFFFF0FF0FFFF0FFFFFFF0F0FFFFF0000000000FFFF}
        end
        object btnHide: TBitBtn
          Left = 103
          Top = 12
          Width = 82
          Height = 43
          Caption = #20851#38381'(&X)'
          TabOrder = 1
          OnClick = btnHideClick
          Glyph.Data = {
            42020000424D4202000000000000420000002800000010000000100000000100
            1000030000000002000000000000000000000000000000000000007C0000E003
            00001F0000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C0000000000001F7C1F7C1F7C1F7C00000000
            00001F7C1F7C1F7C1F7C1F7C0000007C007C004000001F7C1F7C000000400040
            004000001F7C1F7C1F7C1F7C0000FF7F007C007C0040000000000040007C007C
            004000001F7C1F7C1F7C1F7C1F7C0000FF7F007C007C00400040007C007C0040
            00001F7C1F7C1F7C1F7C1F7C1F7C1F7C0000007C007C007C007C007C00400000
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C0000007C007C007C004000001F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C0000007C007C007C007C007C00400000
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C0000007C007C007C007C007C007C007C0040
            00001F7C1F7C1F7C1F7C1F7C0000FF7F007C007C007C00000000007C007C007C
            004000001F7C1F7C1F7C0000FF7F007C007C007C00001F7C1F7C0000007C007C
            004000001F7C1F7C1F7C0000007C007C007C00001F7C1F7C1F7C1F7C0000007C
            004000001F7C1F7C1F7C1F7C0000000000001F7C1F7C1F7C1F7C1F7C1F7C0000
            00001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C}
        end
        object btnKillProcess: TButton
          Left = 224
          Top = 16
          Width = 75
          Height = 25
          Caption = 'KillProcess'
          TabOrder = 2
          OnClick = btnKillProcessClick
        end
      end
    end
    object TabSheet5: TTabSheet
      Caption = #20869#23384#25628#32034
      ImageIndex = 1
      object Panel9: TPanel
        Left = 0
        Top = 0
        Width = 993
        Height = 75
        Align = alTop
        TabOrder = 0
        object Label24: TLabel
          Left = 16
          Top = 10
          Width = 90
          Height = 12
          Caption = 'Curr Page Base:'
        end
        object lblCurrPageBase: TLabel
          Left = 112
          Top = 10
          Width = 90
          Height = 12
          Caption = 'lblCurrPageBase'
        end
        object Label25: TLabel
          Left = 16
          Top = 32
          Width = 60
          Height = 12
          Caption = 'Page Size:'
        end
        object lblCurrPageSize: TLabel
          Left = 112
          Top = 32
          Width = 90
          Height = 12
          Caption = 'lblCurrPageSize'
        end
        object GroupBox5: TGroupBox
          Left = 540
          Top = 1
          Width = 452
          Height = 73
          Align = alRight
          Caption = 'Search'
          TabOrder = 0
          object Label33: TLabel
            Left = 12
            Top = 16
            Width = 42
            Height = 12
            Caption = 'Target:'
          end
          object btnMemInspSearch: TButton
            Left = 367
            Top = 13
            Width = 75
            Height = 20
            Caption = '&Search'
            TabOrder = 0
            OnClick = btnMemInspSearchClick
          end
          object btnMemInspRset: TButton
            Left = 399
            Top = 35
            Width = 43
            Height = 20
            Caption = 'Reset'
            TabOrder = 1
            OnClick = btnMemInspRsetClick
          end
          object edMemInspSearchTarget: TEdit
            Left = 64
            Top = 13
            Width = 207
            Height = 20
            TabOrder = 2
          end
          object rgMemInspSearchDataType: TRadioGroup
            Left = 12
            Top = 36
            Width = 259
            Height = 34
            Caption = 'Data type'
            Columns = 5
            ItemIndex = 0
            Items.Strings = (
              'Text'
              'Byte'
              'Word'
              'DWord'
              'Bin')
            TabOrder = 3
          end
          object rgSearchCodePage: TRadioGroup
            Left = 277
            Top = 8
            Width = 84
            Height = 61
            Caption = 'Code page'
            ItemIndex = 0
            Items.Strings = (
              'GB2312'
              'UTF8'
              'UTF16')
            TabOrder = 4
          end
        end
      end
      object Panel10: TPanel
        Left = 0
        Top = 634
        Width = 993
        Height = 57
        Align = alBottom
        TabOrder = 1
        object RadioGroup2: TRadioGroup
          Left = 540
          Top = 1
          Width = 452
          Height = 55
          Align = alRight
          Caption = 'RadioGroup2'
          ItemIndex = 0
          Items.Strings = (
            #40120#40060'($2cc)'
            '$848'
            '$6F1')
          TabOrder = 0
        end
        object btnHide2: TBitBtn
          Left = 1
          Top = 5
          Width = 82
          Height = 43
          Caption = #20851#38381'(&X)'
          TabOrder = 1
          OnClick = btnHideClick
          Glyph.Data = {
            42020000424D4202000000000000420000002800000010000000100000000100
            1000030000000002000000000000000000000000000000000000007C0000E003
            00001F0000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C0000000000001F7C1F7C1F7C1F7C00000000
            00001F7C1F7C1F7C1F7C1F7C0000007C007C004000001F7C1F7C000000400040
            004000001F7C1F7C1F7C1F7C0000FF7F007C007C0040000000000040007C007C
            004000001F7C1F7C1F7C1F7C1F7C0000FF7F007C007C00400040007C007C0040
            00001F7C1F7C1F7C1F7C1F7C1F7C1F7C0000007C007C007C007C007C00400000
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C0000007C007C007C004000001F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C0000007C007C007C007C007C00400000
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C0000007C007C007C007C007C007C007C0040
            00001F7C1F7C1F7C1F7C1F7C0000FF7F007C007C007C00000000007C007C007C
            004000001F7C1F7C1F7C0000FF7F007C007C007C00001F7C1F7C0000007C007C
            004000001F7C1F7C1F7C0000007C007C007C00001F7C1F7C1F7C1F7C0000007C
            004000001F7C1F7C1F7C1F7C0000000000001F7C1F7C1F7C1F7C1F7C1F7C0000
            00001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C}
        end
        object ListBox2: TListBox
          Left = 288
          Top = 1
          Width = 252
          Height = 55
          Align = alRight
          Columns = 2
          ItemHeight = 12
          Items.Strings = (
            '$6DFB8C')
          TabOrder = 2
          OnDblClick = ListBox2DblClick
        end
      end
      object Panel11: TPanel
        Left = 0
        Top = 75
        Width = 568
        Height = 559
        Align = alClient
        Caption = 'Panel11'
        TabOrder = 2
        object MemInspectGrid: TVirtualStringTree
          Left = 1
          Top = 1
          Width = 566
          Height = 557
          Align = alClient
          Header.AutoSizeIndex = 0
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'Tahoma'
          Header.Font.Style = []
          Header.Options = [hoColumnResize, hoDrag, hoVisible]
          Header.Style = hsXPStyle
          PopupMenu = pmMemInsp
          TabOrder = 0
          TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning]
          TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowHorzGridLines, toShowVertGridLines, toThemeAware, toUseBlendedImages]
          TreeOptions.SelectionOptions = [toExtendedFocus]
          OnChange = MemInspectGridChange
          OnFocusChanged = MemInspectGridFocusChanged
          OnGetText = MemInspectGridGetText
          OnPaintText = MemInspectGridPaintText
          OnGetHighlightTextColor = MemInspectGridGetHighlightTextColor
          OnGetSelectionBkColor = MemInspectGridGetSelectionBkColor
          OnAcceptNewText = MemInspectGridAcceptNewText
          Columns = <
            item
              Position = 0
              Width = 90
              WideText = 'Address'
            end
            item
              Color = 15198183
              Margin = 0
              Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible]
              Position = 1
              Spacing = 0
              Width = 28
              WideText = '00'
            end
            item
              Color = 15198183
              Margin = 0
              Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible]
              Position = 2
              Spacing = 0
              Width = 28
              WideText = '01'
            end
            item
              Color = 15198183
              Margin = 0
              Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible]
              Position = 3
              Spacing = 0
              Width = 28
              WideText = '02'
            end
            item
              Color = 15198183
              Margin = 0
              Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible]
              Position = 4
              Spacing = 0
              Width = 28
              WideText = '03'
            end
            item
              Margin = 0
              Position = 5
              Spacing = 0
              Width = 28
              WideText = '04'
            end
            item
              Margin = 0
              Position = 6
              Spacing = 0
              Width = 28
              WideText = '05'
            end
            item
              Margin = 0
              Position = 7
              Spacing = 0
              Width = 28
              WideText = '06'
            end
            item
              Margin = 0
              Position = 8
              Spacing = 0
              Width = 28
              WideText = '07'
            end
            item
              Color = 15198183
              Margin = 0
              Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible]
              Position = 9
              Spacing = 0
              Width = 28
              WideText = '08'
            end
            item
              Color = 15198183
              Margin = 0
              Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible]
              Position = 10
              Spacing = 0
              Width = 28
              WideText = '09'
            end
            item
              Color = 15198183
              Margin = 0
              Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible]
              Position = 11
              Spacing = 0
              Width = 28
              WideText = '0A'
            end
            item
              Color = 15198183
              Margin = 0
              Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible]
              Position = 12
              Spacing = 0
              Width = 28
              WideText = '0B'
            end
            item
              Margin = 0
              Position = 13
              Spacing = 0
              Width = 28
              WideText = '0C'
            end
            item
              Margin = 0
              Position = 14
              Spacing = 0
              Width = 28
              WideText = '0D'
            end
            item
              Margin = 0
              Position = 15
              Spacing = 0
              Width = 28
              WideText = '0E'
            end
            item
              Margin = 0
              Position = 16
              Spacing = 0
              Width = 28
              WideText = '0F'
            end>
          WideDefaultText = ''
        end
      end
      object Panel12: TPanel
        Left = 568
        Top = 75
        Width = 425
        Height = 559
        Align = alRight
        TabOrder = 3
        object Label22: TLabel
          Left = 150
          Top = 42
          Width = 36
          Height = 12
          Caption = 'Value:'
        end
        object Label20: TLabel
          Left = 150
          Top = 14
          Width = 42
          Height = 12
          Caption = 'Addr: $'
        end
        object Label43: TLabel
          Left = 8
          Top = 312
          Width = 30
          Height = 12
          Caption = 'size:'
        end
        object Label44: TLabel
          Left = 104
          Top = 312
          Width = 30
          Height = 12
          Caption = 'bytes'
        end
        object lblMemInspCurrPosOfs: TLabel
          Left = 16
          Top = 384
          Width = 24
          Height = 12
          Caption = 'Ofs:'
        end
        object lblMemInspCurrPosAddr: TLabel
          Left = 16
          Top = 360
          Width = 30
          Height = 12
          Caption = 'Addr:'
        end
        object ListBox1: TListBox
          Left = 150
          Top = 73
          Width = 120
          Height = 75
          ItemHeight = 12
          Items.Strings = (
            '$71CDA8'
            '$71CDF0')
          TabOrder = 0
          OnDblClick = ListBox1DblClick
        end
        object edAddrNote: TEdit
          Left = 210
          Top = 39
          Width = 161
          Height = 20
          TabOrder = 1
        end
        object btnAddBookmark: TButton
          Left = 357
          Top = 12
          Width = 22
          Height = 18
          Caption = '+'
          TabOrder = 2
        end
        object btnRemoveBookmark: TButton
          Left = 383
          Top = 73
          Width = 22
          Height = 18
          Caption = '-'
          TabOrder = 3
        end
        object btnGotoCurrBookmark: TButton
          Left = 382
          Top = 12
          Width = 22
          Height = 18
          Caption = 'Go'
          TabOrder = 4
          OnClick = btnMemInspGotoAddrClick
        end
        object rbShowBMAddrAsOffset: TRadioButton
          Left = 149
          Top = 232
          Width = 81
          Height = 17
          Caption = 'As offset'
          Checked = True
          TabOrder = 5
          TabStop = True
        end
        object rbShowBMAddrAbsolute: TRadioButton
          Left = 245
          Top = 232
          Width = 73
          Height = 17
          Caption = 'Absolute'
          TabOrder = 6
        end
        object GroupBox4: TGroupBox
          Left = 146
          Top = 331
          Width = 248
          Height = 198
          Caption = 'Selected Value'
          TabOrder = 7
          object Label26: TLabel
            Left = 16
            Top = 42
            Width = 12
            Height = 12
            Caption = 'B:'
          end
          object Label27: TLabel
            Left = 120
            Top = 42
            Width = 12
            Height = 12
            Caption = 'W:'
          end
          object Label28: TLabel
            Left = 16
            Top = 64
            Width = 12
            Height = 12
            Caption = 'D:'
          end
          object Label29: TLabel
            Left = 16
            Top = 86
            Width = 12
            Height = 12
            Caption = 'Q:'
          end
          object Label30: TLabel
            Left = 16
            Top = 111
            Width = 42
            Height = 12
            Caption = 'Single:'
          end
          object Label31: TLabel
            Left = 16
            Top = 134
            Width = 42
            Height = 12
            Caption = 'Double:'
          end
          object Label32: TLabel
            Left = 16
            Top = 153
            Width = 30
            Height = 12
            Caption = 'Text:'
          end
          object rbSignaled: TRadioButton
            Left = 16
            Top = 16
            Width = 113
            Height = 17
            Caption = 'Signaled'
            Checked = True
            TabOrder = 0
            TabStop = True
            OnClick = rbSignaledClick
          end
          object rbUnsignaled: TRadioButton
            Left = 111
            Top = 16
            Width = 82
            Height = 17
            Caption = 'Unsignaled'
            TabOrder = 1
            OnClick = rbUnsignaledClick
          end
          object edMemInspValue_B: TEdit
            Left = 40
            Top = 38
            Width = 25
            Height = 20
            TabOrder = 2
          end
          object edMemInspValue_W: TEdit
            Left = 144
            Top = 38
            Width = 49
            Height = 20
            TabOrder = 3
          end
          object edMemInspValue_D: TEdit
            Left = 40
            Top = 61
            Width = 121
            Height = 20
            TabOrder = 4
          end
          object edMemInspValue_Q: TEdit
            Left = 40
            Top = 85
            Width = 121
            Height = 20
            TabOrder = 5
          end
          object edMemInspValue_Single: TEdit
            Left = 72
            Top = 108
            Width = 121
            Height = 20
            TabOrder = 6
          end
          object edMemInspValue_Double: TEdit
            Left = 72
            Top = 131
            Width = 121
            Height = 20
            TabOrder = 7
          end
          object edMemInspValueAsText: TEdit
            Left = 16
            Top = 172
            Width = 217
            Height = 20
            TabOrder = 8
          end
        end
        object edMemInspGotoTargetAddr: TEdit
          Left = 210
          Top = 11
          Width = 141
          Height = 20
          TabOrder = 8
        end
        object Button2: TButton
          Left = 276
          Top = 72
          Width = 106
          Height = 25
          Caption = 'Get City Addr'
          TabOrder = 9
          OnClick = Button2Click
        end
        object RadioGroup1: TRadioGroup
          Left = 147
          Top = 152
          Width = 259
          Height = 173
          Caption = 'RadioGroup1'
          Columns = 2
          ItemIndex = 0
          Items.Strings = (
            '0'
            '1'
            '2'
            '3'
            '4'
            '5'
            '6'
            '7'
            '8'
            '9'
            '10'
            '11'
            '12'
            '13'
            '14'
            '15'
            '16'
            '17'
            '18'
            '19'
            '20'
            '21'
            '22'
            '23')
          TabOrder = 10
        end
        object rgCityAddrDelta: TRadioGroup
          Left = 276
          Top = 99
          Width = 121
          Height = 52
          Caption = 'City Addr Delta'
          Items.Strings = (
            '+0'
            '+$2cc'
            '+$848')
          TabOrder = 11
        end
        object btnAnchor: TButton
          Left = 8
          Top = 17
          Width = 121
          Height = 25
          Caption = 'Set Anchor'
          TabOrder = 12
          OnClick = btnAnchorClick
        end
        object btnRemoveAnchor: TButton
          Left = 8
          Top = 48
          Width = 121
          Height = 25
          Caption = 'Remove Anchor'
          TabOrder = 13
          OnClick = btnRemoveAnchorClick
        end
        object edGotoOffset: TEdit
          Left = 8
          Top = 128
          Width = 73
          Height = 20
          TabOrder = 14
        end
        object btnGotoOffsetToCurrSelect: TButton
          Left = 8
          Top = 160
          Width = 121
          Height = 25
          Caption = 'Go ofs(curr select)'
          TabOrder = 15
          OnClick = btnGotoOffsetToCurrSelectClick
        end
        object btnGotoOfsToAnchor: TButton
          Left = 8
          Top = 191
          Width = 121
          Height = 25
          Caption = 'Go ofs(anchor)'
          TabOrder = 16
          OnClick = btnGotoOfsToAnchorClick
        end
        object cbDumpSize: TComboBox
          Left = 42
          Top = 308
          Width = 55
          Height = 20
          ItemHeight = 12
          TabOrder = 17
        end
        object btnDumpFromCurrPos: TButton
          Left = 8
          Top = 277
          Width = 126
          Height = 25
          Caption = 'DumpFromCurrPos'
          TabOrder = 18
          OnClick = btnDumpFromCurrPosClick
        end
      end
    end
    object TabSheet6: TTabSheet
      Caption = #22478#38215
      ImageIndex = 2
      object Panel13: TPanel
        Left = 0
        Top = 0
        Width = 993
        Height = 64
        Align = alTop
        TabOrder = 0
        object lblHomeCity: TLabel
          Left = 232
          Top = 13
          Width = 66
          Height = 12
          Caption = 'lblHomeCity'
        end
        object lblPlayerName: TLabel
          Left = 378
          Top = 39
          Width = 78
          Height = 12
          Caption = 'lblPlayerName'
        end
        object lblIsInSeaView: TLabel
          Left = 259
          Top = 46
          Width = 84
          Height = 12
          Caption = 'lblIsInSeaView'
        end
        object cbCity: TComboBox
          Left = 16
          Top = 10
          Width = 145
          Height = 20
          Style = csDropDownList
          ItemHeight = 12
          TabOrder = 0
          OnChange = cbCityChange
        end
        object btnGotoHomeCity: TButton
          Left = 167
          Top = 10
          Width = 58
          Height = 20
          Caption = #23478#20065
          TabOrder = 1
          OnClick = btnGotoHomeCityClick
        end
        object cbPlayer: TComboBox
          Left = 378
          Top = 10
          Width = 111
          Height = 20
          Style = csDropDownList
          ItemHeight = 12
          TabOrder = 2
          OnChange = cbPlayerChange
        end
        object edPlayerMoney: TEdit
          Left = 495
          Top = 10
          Width = 154
          Height = 20
          TabOrder = 3
        end
        object btnSetPlayerMoney: TButton
          Left = 656
          Top = 10
          Width = 27
          Height = 21
          Caption = 'Set'
          TabOrder = 4
          OnClick = btnSetPlayerMoneyClick
        end
        object btnPlayerMoneyX100: TButton
          Left = 696
          Top = 8
          Width = 41
          Height = 25
          Caption = 'X100'
          TabOrder = 5
          OnClick = btnPlayerMoneyX100Click
        end
        object btnPlayerMoneyX1000: TButton
          Left = 743
          Top = 8
          Width = 75
          Height = 25
          Caption = 'X1000'
          TabOrder = 6
          OnClick = btnPlayerMoneyX1000Click
        end
        object edPlayerPtr: TEdit
          Left = 496
          Top = 32
          Width = 154
          Height = 20
          TabOrder = 7
        end
        object BitBtn1: TBitBtn
          Left = 837
          Top = 5
          Width = 82
          Height = 31
          Caption = #20851#38381'(&X)'
          TabOrder = 8
          OnClick = btnHideClick
          Glyph.Data = {
            42020000424D4202000000000000420000002800000010000000100000000100
            1000030000000002000000000000000000000000000000000000007C0000E003
            00001F0000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C0000000000001F7C1F7C1F7C1F7C00000000
            00001F7C1F7C1F7C1F7C1F7C0000007C007C004000001F7C1F7C000000400040
            004000001F7C1F7C1F7C1F7C0000FF7F007C007C0040000000000040007C007C
            004000001F7C1F7C1F7C1F7C1F7C0000FF7F007C007C00400040007C007C0040
            00001F7C1F7C1F7C1F7C1F7C1F7C1F7C0000007C007C007C007C007C00400000
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C0000007C007C007C004000001F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C0000007C007C007C007C007C00400000
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C0000007C007C007C007C007C007C007C0040
            00001F7C1F7C1F7C1F7C1F7C0000FF7F007C007C007C00000000007C007C007C
            004000001F7C1F7C1F7C0000FF7F007C007C007C00001F7C1F7C0000007C007C
            004000001F7C1F7C1F7C0000007C007C007C00001F7C1F7C1F7C1F7C0000007C
            004000001F7C1F7C1F7C1F7C0000000000001F7C1F7C1F7C1F7C1F7C1F7C0000
            00001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C}
        end
        object cbFastForward: TCheckBox
          Left = 744
          Top = 40
          Width = 97
          Height = 17
          Caption = 'cbFastForward'
          TabOrder = 9
          OnClick = cbFastForwardClick
        end
      end
      object PageControl2: TPageControl
        Left = 0
        Top = 64
        Width = 993
        Height = 627
        ActivePage = TabSheet12
        Align = alClient
        TabOrder = 1
        object TabSheet7: TTabSheet
          Caption = #22478#38215#25968#25454
          object Bevel8: TBevel
            Left = 658
            Top = 64
            Width = 257
            Height = 177
          end
          object lblTestResult: TLabel
            Left = 425
            Top = 378
            Width = 78
            Height = 12
            Caption = 'lblTestResult'
          end
          object Label34: TLabel
            Left = 662
            Top = 16
            Width = 30
            Height = 12
            Caption = 'Date:'
          end
          object lblGameDate: TLabel
            Left = 705
            Top = 16
            Width = 66
            Height = 12
            Caption = 'lblGameDate'
          end
          object Label35: TLabel
            Left = 666
            Top = 72
            Width = 48
            Height = 12
            Caption = #22478#24314#22768#26395
          end
          object Label36: TLabel
            Left = 666
            Top = 104
            Width = 48
            Height = 12
            Caption = #20844#20247#22768#26126
          end
          object Label37: TLabel
            Left = 666
            Top = 136
            Width = 48
            Height = 12
            Caption = #36152#26131#22768#26395
          end
          object Label38: TLabel
            Left = 666
            Top = 464
            Width = 60
            Height = 12
            Caption = 'PlayerID: '
          end
          object lblPlayerID: TLabel
            Left = 730
            Top = 464
            Width = 66
            Height = 12
            Caption = 'lblPlayerID'
          end
          object Label39: TLabel
            Left = 666
            Top = 168
            Width = 54
            Height = 12
            Caption = #36152#26131#22768#26395'2'
          end
          object Label40: TLabel
            Left = 668
            Top = 298
            Width = 30
            Height = 12
            Caption = '+$15:'
          end
          object Label41: TLabel
            Left = 668
            Top = 327
            Width = 30
            Height = 12
            Caption = '+$1B:'
          end
          object lblBirthday: TLabel
            Left = 666
            Top = 262
            Width = 54
            Height = 12
            Caption = 'Birthday:'
          end
          object Label42: TLabel
            Left = 666
            Top = 205
            Width = 54
            Height = 12
            Caption = #36152#26131#22768#26395'3'
          end
          object Label6: TLabel
            Left = 666
            Top = 489
            Width = 90
            Height = 12
            Caption = 'View Port City:'
          end
          object lblViewPortCityCode: TLabel
            Left = 762
            Top = 489
            Width = 114
            Height = 12
            Caption = 'lblViewPortCityCode'
          end
          object Label10: TLabel
            Left = 666
            Top = 511
            Width = 36
            Height = 12
            Caption = 'Class:'
          end
          object lblPlayerClass: TLabel
            Left = 730
            Top = 511
            Width = 84
            Height = 12
            Caption = 'lblPlayerClass'
          end
          object Label46: TLabel
            Left = 666
            Top = 351
            Width = 84
            Height = 12
            Caption = '+$464(float)'#65306
          end
          object Label47: TLabel
            Left = 666
            Top = 434
            Width = 36
            Height = 12
            Caption = '+$2C6:'
          end
          object lblBusinessOfficePtr: TLabel
            Left = 748
            Top = 535
            Width = 120
            Height = 12
            Caption = 'lblBusinessOfficePtr'
          end
          object Label48: TLabel
            Left = 664
            Top = 535
            Width = 78
            Height = 12
            Caption = 'Business Off:'
          end
          object Label50: TLabel
            Left = 666
            Top = 561
            Width = 36
            Height = 12
            Caption = #37329#24211#65306
          end
          object Label45: TLabel
            Left = 665
            Top = 376
            Width = 30
            Height = 12
            Caption = 'CityX'
          end
          object Label53: TLabel
            Left = 665
            Top = 409
            Width = 30
            Height = 12
            Caption = 'CityY'
          end
          object lblCityX: TLabel
            Left = 728
            Top = 376
            Width = 48
            Height = 12
            Caption = 'lblCityX'
          end
          object lblCityY: TLabel
            Left = 728
            Top = 408
            Width = 48
            Height = 12
            Caption = 'lblCityY'
          end
          object Panel14: TPanel
            Left = 0
            Top = 0
            Width = 393
            Height = 600
            Align = alLeft
            BevelOuter = bvNone
            Caption = 'Panel14'
            TabOrder = 0
            object CityStoreGrid: TVirtualStringTree
              Left = 0
              Top = 27
              Width = 393
              Height = 573
              Align = alClient
              Header.AutoSizeIndex = 0
              Header.Font.Charset = DEFAULT_CHARSET
              Header.Font.Color = clWindowText
              Header.Font.Height = -11
              Header.Font.Name = 'Tahoma'
              Header.Font.Style = []
              Header.Options = [hoColumnResize, hoDrag, hoVisible]
              Header.Style = hsXPStyle
              LineStyle = lsSolid
              TabOrder = 0
              TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning]
              TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowHorzGridLines, toShowVertGridLines, toThemeAware, toUseBlendedImages]
              TreeOptions.SelectionOptions = [toExtendedFocus]
              OnDblClick = CityStoreGridDblClick
              OnEditing = CityStoreGridEditing
              OnGetText = CityStoreGridGetText
              OnAcceptNewText = CityStoreGridAcceptNewText
              Columns = <
                item
                  Position = 0
                  Width = 80
                  WideText = #36135#29289
                end
                item
                  Alignment = taRightJustify
                  Position = 1
                  Width = 65
                  WideText = #24211#23384#25968#37327
                end
                item
                  Position = 2
                  Width = 40
                  WideText = #21333#20301
                end
                item
                  Position = 3
                  Width = 70
                  WideText = #21407#20135#22320
                end
                item
                  Alignment = taRightJustify
                  Position = 4
                  Width = 65
                  WideText = #21608#28040#32791
                end
                item
                  Alignment = taRightJustify
                  Position = 5
                  Width = 65
                  WideText = #21608#20135#37327
                end
                item
                  Position = 6
                  Width = 70
                  WideText = #21806#20215
                end
                item
                  Position = 7
                  Width = 70
                  WideText = #20080#20215
                end>
              WideDefaultText = ''
            end
            object Panel15: TPanel
              Left = 0
              Top = 0
              Width = 393
              Height = 27
              Align = alTop
              Alignment = taLeftJustify
              BevelOuter = bvLowered
              Caption = '  '#24211#23384
              TabOrder = 1
              object btnDecCityStore: TButton
                Left = 180
                Top = 2
                Width = 69
                Height = 21
                Caption = #24211#23384#20943#21322
                TabOrder = 0
                OnClick = btnDecCityStoreClick
              end
              object btnClearCityGoods: TButton
                Left = 255
                Top = 2
                Width = 69
                Height = 21
                Caption = #24211#23384#28165#31354
                TabOrder = 1
                OnClick = btnClearCityGoodsClick
              end
              object edCityPtr: TEdit
                Left = 46
                Top = 4
                Width = 121
                Height = 20
                TabOrder = 2
              end
            end
          end
          object Panel16: TPanel
            Left = 407
            Top = 7
            Width = 233
            Height = 162
            Caption = 'Panel16'
            Padding.Left = 5
            Padding.Top = 5
            Padding.Right = 5
            Padding.Bottom = 5
            TabOrder = 1
            object Panel17: TPanel
              Left = 6
              Top = 6
              Width = 221
              Height = 27
              Align = alTop
              Alignment = taLeftJustify
              BevelOuter = bvLowered
              Caption = '  '#20154#21475
              TabOrder = 0
              object lblPopTotal: TLabel
                Left = 56
                Top = 7
                Width = 78
                Height = 12
                Caption = '('#24120#20303#21512#35745': 0)'
              end
              object btnCityAddQiGai: TButton
                Left = 140
                Top = 3
                Width = 75
                Height = 22
                Caption = #20062#19984'+50'
                TabOrder = 0
                OnClick = btnCityAddQiGaiClick
              end
            end
            object PopGrid: TVirtualStringTree
              Left = 6
              Top = 33
              Width = 221
              Height = 123
              Align = alClient
              Header.AutoSizeIndex = 0
              Header.Font.Charset = DEFAULT_CHARSET
              Header.Font.Color = clWindowText
              Header.Font.Height = -11
              Header.Font.Name = 'Tahoma'
              Header.Font.Style = []
              Header.Options = [hoColumnResize, hoDrag, hoVisible]
              Header.Style = hsXPStyle
              TabOrder = 1
              TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning]
              TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowHorzGridLines, toShowVertGridLines, toThemeAware, toUseBlendedImages]
              TreeOptions.SelectionOptions = [toExtendedFocus]
              OnGetText = PopGridGetText
              OnAcceptNewText = PopGridAcceptNewText
              Columns = <
                item
                  Position = 0
                  Width = 55
                  WideText = #38454#32423
                end
                item
                  Position = 1
                  WideText = #20154#25968
                end
                item
                  Position = 2
                  Width = 55
                  WideText = #27604#20363
                end
                item
                  Position = 3
                  WideText = #28385#24847#24230
                end>
              WideDefaultText = ''
            end
          end
          object btnHide3: TBitBtn
            Left = 568
            Top = 330
            Width = 66
            Height = 31
            Caption = #20851#38381'(&X)'
            TabOrder = 2
            OnClick = btnHideClick
            Glyph.Data = {
              42020000424D4202000000000000420000002800000010000000100000000100
              1000030000000002000000000000000000000000000000000000007C0000E003
              00001F0000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C0000000000001F7C1F7C1F7C1F7C00000000
              00001F7C1F7C1F7C1F7C1F7C0000007C007C004000001F7C1F7C000000400040
              004000001F7C1F7C1F7C1F7C0000FF7F007C007C0040000000000040007C007C
              004000001F7C1F7C1F7C1F7C1F7C0000FF7F007C007C00400040007C007C0040
              00001F7C1F7C1F7C1F7C1F7C1F7C1F7C0000007C007C007C007C007C00400000
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C0000007C007C007C004000001F7C
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C0000007C007C007C007C007C00400000
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C0000007C007C007C007C007C007C007C0040
              00001F7C1F7C1F7C1F7C1F7C0000FF7F007C007C007C00000000007C007C007C
              004000001F7C1F7C1F7C0000FF7F007C007C007C00001F7C1F7C0000007C007C
              004000001F7C1F7C1F7C0000007C007C007C00001F7C1F7C1F7C1F7C0000007C
              004000001F7C1F7C1F7C1F7C0000000000001F7C1F7C1F7C1F7C1F7C1F7C0000
              00001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
              1F7C1F7C1F7C}
          end
          object Panel19: TPanel
            Left = 407
            Top = 169
            Width = 233
            Height = 155
            Caption = 'Panel19'
            Padding.Left = 5
            Padding.Top = 5
            Padding.Right = 5
            Padding.Bottom = 5
            TabOrder = 3
            object Panel20: TPanel
              Left = 6
              Top = 6
              Width = 221
              Height = 27
              Align = alTop
              Alignment = taLeftJustify
              Caption = '  '#20891#38431
              TabOrder = 0
              object lblSoldierTotal: TLabel
                Left = 50
                Top = 8
                Width = 90
                Height = 12
                Caption = 'lblSoldierTotal'
              end
            end
            object SoldierGrid: TVirtualStringTree
              Left = 6
              Top = 33
              Width = 221
              Height = 116
              Align = alClient
              Header.AutoSizeIndex = 0
              Header.Font.Charset = DEFAULT_CHARSET
              Header.Font.Color = clWindowText
              Header.Font.Height = -11
              Header.Font.Name = 'Tahoma'
              Header.Font.Style = []
              Header.Options = [hoColumnResize, hoDrag, hoVisible]
              Header.Style = hsXPStyle
              TabOrder = 1
              TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning]
              TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowHorzGridLines, toShowVertGridLines, toThemeAware, toUseBlendedImages]
              TreeOptions.SelectionOptions = [toExtendedFocus]
              OnDblClick = SoldierGridDblClick
              OnEditing = SoldierGridEditing
              OnGetText = SoldierGridGetText
              OnAcceptNewText = SoldierGridAcceptNewText
              Columns = <
                item
                  Position = 0
                  WideText = #31867#22411
                end
                item
                  Position = 1
                  WideText = #26381#24441#20013
                end
                item
                  Position = 2
                  WideText = #35757#32451#20013
                end>
              WideDefaultText = ''
            end
          end
          object btnTest: TButton
            Left = 526
            Top = 373
            Width = 54
            Height = 25
            Caption = 'Test'
            TabOrder = 4
            OnClick = btnTestClick
          end
          object edGameDataAddr: TEdit
            Left = 666
            Top = 32
            Width = 121
            Height = 20
            TabOrder = 5
          end
          object edShengWang1: TEdit
            Left = 730
            Top = 69
            Width = 121
            Height = 20
            TabOrder = 6
          end
          object edShengWang2: TEdit
            Left = 730
            Top = 101
            Width = 121
            Height = 20
            TabOrder = 7
          end
          object edShengWang3: TEdit
            Left = 730
            Top = 133
            Width = 121
            Height = 20
            TabOrder = 8
          end
          object btnSetShengWang: TButton
            Left = 858
            Top = 68
            Width = 37
            Height = 23
            Caption = 'Set'
            TabOrder = 9
            OnClick = btnSetShengWangClick
          end
          object edShengWang4: TEdit
            Left = 730
            Top = 165
            Width = 121
            Height = 20
            TabOrder = 10
          end
          object edPlayer_15: TEdit
            Left = 730
            Top = 295
            Width = 121
            Height = 20
            TabOrder = 11
          end
          object edPlayer_1B: TEdit
            Left = 730
            Top = 326
            Width = 121
            Height = 20
            TabOrder = 12
          end
          object edBirthday: TEdit
            Left = 730
            Top = 259
            Width = 121
            Height = 20
            TabOrder = 13
          end
          object btnSetPlayerExtraInfo: TButton
            Left = 857
            Top = 321
            Width = 37
            Height = 25
            Caption = 'Set'
            TabOrder = 14
            OnClick = btnSetPlayerExtraInfoClick
          end
          object edShengWang5: TEdit
            Left = 730
            Top = 202
            Width = 121
            Height = 20
            TabOrder = 15
          end
          object rgConvertDWSingle1: TRadioGroup
            Left = 899
            Top = 330
            Width = 79
            Height = 53
            Caption = 'Convert'
            ItemIndex = 0
            Items.Strings = (
              'DWORD'
              'Single')
            TabOrder = 16
            OnClick = rgConvertDWSingle1Click
          end
          object edPlayer_464: TEdit
            Left = 728
            Top = 348
            Width = 121
            Height = 20
            TabOrder = 17
          end
          object btnSetPlayer_464: TButton
            Left = 856
            Top = 348
            Width = 37
            Height = 25
            Caption = 'Set'
            TabOrder = 18
          end
          object edCityTreasury: TEdit
            Left = 724
            Top = 555
            Width = 121
            Height = 20
            TabOrder = 19
          end
          object edTestInput: TEdit
            Left = 424
            Top = 336
            Width = 121
            Height = 20
            TabOrder = 20
          end
          object memTestResult: TMemo
            Left = 425
            Top = 409
            Width = 215
            Height = 80
            Lines.Strings = (
              'memTestResult')
            TabOrder = 21
          end
          object edPlayer_2C6: TEdit
            Left = 728
            Top = 432
            Width = 121
            Height = 20
            TabOrder = 22
          end
          object btnSetPlayer_2C6: TButton
            Left = 855
            Top = 432
            Width = 36
            Height = 25
            Caption = 'Set'
            Enabled = False
            TabOrder = 23
          end
          object btnDumpAllCityPos: TButton
            Left = 816
            Top = 392
            Width = 124
            Height = 25
            Caption = 'DumpAllCityPos'
            TabOrder = 24
            OnClick = btnDumpAllCityPosClick
          end
          object GroupBox6: TGroupBox
            Left = 424
            Top = 485
            Width = 135
            Height = 112
            Caption = 'Build ship'
            TabOrder = 25
            object Label60: TLabel
              Left = 10
              Top = 19
              Width = 24
              Height = 12
              Caption = 'lvl:'
            end
            object Label61: TLabel
              Left = 10
              Top = 42
              Width = 30
              Height = 12
              Caption = 'type:'
            end
            object lblBuildShipResult: TLabel
              Left = 21
              Top = 93
              Width = 108
              Height = 12
              Caption = 'lblBuildShipResult'
            end
            object cbBuildTypeA1: TComboBox
              Left = 45
              Top = 16
              Width = 79
              Height = 20
              Style = csDropDownList
              ItemHeight = 12
              ItemIndex = 0
              TabOrder = 0
              Text = '0'
              Items.Strings = (
                '0'
                '1'
                '2'
                '3')
            end
            object cbBuildShipType: TComboBox
              Left = 44
              Top = 40
              Width = 80
              Height = 20
              Style = csDropDownList
              ItemHeight = 12
              ItemIndex = 0
              TabOrder = 1
              Text = '0'
              Items.Strings = (
                '0'
                '1'
                '2'
                '3')
            end
            object btnBuildShip: TButton
              Left = 31
              Top = 66
              Width = 75
              Height = 21
              Caption = 'BuildShip'
              TabOrder = 2
              OnClick = btnBuildShipClick
            end
          end
        end
        object TabSheet8: TTabSheet
          Caption = #20869#23384#35270#22270
          ImageIndex = 1
          object Panel18: TPanel
            Left = 800
            Top = 0
            Width = 185
            Height = 600
            Align = alRight
            Caption = 'Panel18'
            TabOrder = 0
          end
          object CityMemGrid: TVirtualStringTree
            Left = 0
            Top = 0
            Width = 800
            Height = 600
            Align = alClient
            Header.AutoSizeIndex = 0
            Header.Font.Charset = DEFAULT_CHARSET
            Header.Font.Color = clWindowText
            Header.Font.Height = -11
            Header.Font.Name = 'Tahoma'
            Header.Font.Style = []
            Header.Options = [hoColumnResize, hoDrag, hoVisible]
            Header.Style = hsXPStyle
            TabOrder = 1
            TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning]
            TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowHorzGridLines, toShowVertGridLines, toThemeAware, toUseBlendedImages]
            TreeOptions.SelectionOptions = [toExtendedFocus]
            Columns = <
              item
                Position = 0
                Width = 90
                WideText = 'Address'
              end
              item
                Color = 15198183
                Margin = 0
                Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible]
                Position = 1
                Spacing = 0
                Width = 28
                WideText = '00'
              end
              item
                Color = 15198183
                Margin = 0
                Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible]
                Position = 2
                Spacing = 0
                Width = 28
                WideText = '01'
              end
              item
                Color = 15198183
                Margin = 0
                Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible]
                Position = 3
                Spacing = 0
                Width = 28
                WideText = '02'
              end
              item
                Color = 15198183
                Margin = 0
                Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible]
                Position = 4
                Spacing = 0
                Width = 28
                WideText = '03'
              end
              item
                Margin = 0
                Position = 5
                Spacing = 0
                Width = 28
                WideText = '04'
              end
              item
                Margin = 0
                Position = 6
                Spacing = 0
                Width = 28
                WideText = '05'
              end
              item
                Margin = 0
                Position = 7
                Spacing = 0
                Width = 28
                WideText = '06'
              end
              item
                Margin = 0
                Position = 8
                Spacing = 0
                Width = 28
                WideText = '07'
              end
              item
                Color = 15198183
                Margin = 0
                Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible]
                Position = 9
                Spacing = 0
                Width = 28
                WideText = '08'
              end
              item
                Color = 15198183
                Margin = 0
                Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible]
                Position = 10
                Spacing = 0
                Width = 28
                WideText = '09'
              end
              item
                Color = 15198183
                Margin = 0
                Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible]
                Position = 11
                Spacing = 0
                Width = 28
                WideText = '0A'
              end
              item
                Color = 15198183
                Margin = 0
                Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible]
                Position = 12
                Spacing = 0
                Width = 28
                WideText = '0B'
              end
              item
                Margin = 0
                Position = 13
                Spacing = 0
                Width = 28
                WideText = '0C'
              end
              item
                Margin = 0
                Position = 14
                Spacing = 0
                Width = 28
                WideText = '0D'
              end
              item
                Margin = 0
                Position = 15
                Spacing = 0
                Width = 28
                WideText = '0E'
              end
              item
                Margin = 0
                Position = 16
                Spacing = 0
                Width = 28
                WideText = '0F'
              end>
            WideDefaultText = ''
          end
        end
        object TabSheet9: TTabSheet
          Caption = #20107#21153#25152
          ImageIndex = 2
          object Panel21: TPanel
            Left = 0
            Top = 0
            Width = 679
            Height = 600
            Align = alLeft
            BevelOuter = bvNone
            Caption = 'Panel21'
            TabOrder = 0
            object pnlBusinessHeader: TPanel
              Left = 0
              Top = 0
              Width = 679
              Height = 25
              Align = alTop
              BevelOuter = bvLowered
              TabOrder = 0
              object Label64: TLabel
                Left = 168
                Top = 8
                Width = 66
                Height = 12
                Caption = 'Storehouse:'
              end
              object lblStoreHouseMaxCap: TLabel
                Left = 248
                Top = 8
                Width = 114
                Height = 12
                Caption = 'lblStoreHouseMaxCap'
              end
              object edBusinessOfsPtr: TEdit
                Left = 16
                Top = 2
                Width = 121
                Height = 20
                TabOrder = 0
              end
            end
            object BusinessOfficeGrid: TVirtualStringTree
              Left = 0
              Top = 25
              Width = 679
              Height = 575
              Align = alClient
              Header.AutoSizeIndex = 0
              Header.Font.Charset = DEFAULT_CHARSET
              Header.Font.Color = clWindowText
              Header.Font.Height = -11
              Header.Font.Name = 'Tahoma'
              Header.Font.Style = []
              Header.Options = [hoColumnResize, hoDrag, hoVisible]
              Header.Style = hsXPStyle
              TabOrder = 1
              TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning]
              TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowHorzGridLines, toShowVertGridLines, toThemeAware, toUseBlendedImages]
              TreeOptions.SelectionOptions = [toExtendedFocus]
              OnGetText = BusinessOfficeGridGetText
              Columns = <
                item
                  Position = 0
                  Width = 80
                  WideText = #21830#21697
                end
                item
                  Color = 16119285
                  Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible]
                  Position = 1
                  Width = 40
                  WideText = #21333#20301
                end
                item
                  Alignment = taRightJustify
                  Position = 2
                  Width = 80
                  WideText = #24211#23384
                end
                item
                  Alignment = taRightJustify
                  Position = 3
                  Width = 80
                  WideText = #24037#21378#38656#27714
                end
                item
                  Alignment = taRightJustify
                  Position = 4
                  Width = 80
                  WideText = #24037#21378#20135#20986
                end
                item
                  Position = 5
                  Width = 80
                  WideText = #20107#21153#25152#36152#26131
                end
                item
                  Alignment = taRightJustify
                  Position = 6
                  Width = 55
                  WideText = #20215#26684
                end
                item
                  Alignment = taRightJustify
                  Position = 7
                  Width = 90
                  WideText = #20445#30041'/'#26368#22823#25968#37327
                end
                item
                  Position = 8
                  Width = 40
                  WideText = #38480#21046
                end>
              WideDefaultText = ''
            end
          end
          object Panel22: TPanel
            Left = 679
            Top = 0
            Width = 306
            Height = 600
            Align = alClient
            Caption = 'Panel22'
            TabOrder = 1
            object BusinessOfficeG2: TVirtualStringTree
              Left = 1
              Top = 1
              Width = 304
              Height = 544
              Align = alTop
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
              OnGetText = BusinessOfficeG2GetText
              Columns = <
                item
                  Position = 0
                  Width = 120
                  WideText = #23646#24615
                end
                item
                  Position = 1
                  Width = 160
                  WideText = #20540
                end>
              WideDefaultText = ''
            end
          end
        end
        object TabSheet11: TTabSheet
          Caption = #24314#31569
          ImageIndex = 3
          object BuildingGrid: TVirtualStringTree
            Left = 0
            Top = 0
            Width = 985
            Height = 600
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
            TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning]
            TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowHorzGridLines, toShowVertGridLines, toThemeAware, toUseBlendedImages]
            TreeOptions.SelectionOptions = [toExtendedFocus]
            OnGetText = BuildingGridGetText
            Columns = <
              item
                Position = 0
                Width = 55
                WideText = 'Index'
              end
              item
                Position = 1
                WideText = 'CoorX'
              end
              item
                Position = 2
                WideText = 'CoorY'
              end
              item
                Position = 3
                Width = 80
                WideText = 'Owner'
              end
              item
                Position = 4
                WideText = 'Type'
              end
              item
                Position = 5
                Width = 60
                WideText = 'Next'
              end
              item
                Position = 6
                Width = 80
                WideText = 'DaysToComp'
              end
              item
                Position = 7
                Width = 80
                WideText = 'Direction'
              end>
            WideDefaultText = ''
          end
        end
        object TabSheet12: TTabSheet
          Caption = #22320#22270
          ImageIndex = 4
          object PaintBox1: TPaintBox
            Left = 12
            Top = 48
            Width = 128
            Height = 226
            OnPaint = PaintBox1Paint
          end
          object btnDraw: TButton
            Left = 8
            Top = 8
            Width = 75
            Height = 25
            Caption = 'Draw map'
            TabOrder = 0
            OnClick = btnDrawClick
          end
          object memMapData: TMemo
            Left = 491
            Top = 48
            Width = 478
            Height = 529
            ScrollBars = ssBoth
            TabOrder = 1
          end
          object btnTest2: TButton
            Left = 492
            Top = 17
            Width = 133
            Height = 25
            Caption = 'TEST 2'
            TabOrder = 2
            OnClick = btnTest2Click
          end
          object memCity: TMemo
            Left = 146
            Top = 3
            Width = 327
            Height = 574
            ScrollBars = ssBoth
            TabOrder = 3
          end
        end
      end
    end
  end
  object ActionList1: TActionList
    Left = 160
    Top = 208
    object acSearch: TAction
      Caption = #25628#32034
    end
  end
  object pmShipGrid: TPopupMenu
    Left = 104
    Top = 216
    object miCheckAll: TMenuItem
      Caption = #20840#36873
      OnClick = miCheckAllClick
    end
    object miToggleChecked: TMenuItem
      Caption = #21453#36873
      OnClick = miToggleCheckedClick
    end
    object miClearChecked: TMenuItem
      Caption = #28165#38500#36873#25321
      OnClick = miClearCheckedClick
    end
  end
  object Timer1: TTimer
    Interval = 500
    OnTimer = Timer1Timer
    Left = 568
    Top = 320
  end
  object ImageList1: TImageList
    Left = 160
    Top = 296
    Bitmap = {
      494C010105000900040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B1C9DF00B3CCE100AFC9E300B0CD
      E500B0CDE300AFC9E30038495D002341770041547100BCD2EC00B0C9DF00A6BB
      D10099B1C4008DA5B500889BAC007F96A7000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B9D1E400B6CDE500B8D4E800BAD2
      EA00B4D0E800B3CDE50039485D0026447B0054677D006B7985001B1F23000304
      0500050708000A0C100012171B00161C23000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B4D2E800B7D3EA00B1CDE800B0CD
      E300B1C9DF00B5D0E20035455C00314D7C003B47550019242F001E2634002D38
      4C003D4F630040546C0042597500455E82000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B4D4E800B0D0E600B2CBE300B5CF
      E500B4CFE600B1D2E70034435B0035507E0034404E003A526E003C516D003848
      5E002A3A4F00293A4C00202D3B001A2531000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B2D0E600B3CCE600B3D2E700B6D3
      EA00B5D5EE00B3D0E90031435B002C4C86005365780048545F00161C2100151B
      20000E1014000101030001010100010101000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B1CDE800B1D2E600B4D0EA00B0CC
      E600B0CFE500A9C6DD002F405A002A4D8C004C627E00B6D2EA00A3BCCE001315
      17007E868E00717A8300717D84008C96A0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B4D4E800B0D2E800BAD5ED00B2D2
      E500B0CEE400A6C2D9002B3A53002C529500495F7E00B2CEE600B2CADE001A1E
      21008B949E00AFBCC60098A3AE00A7B2B9000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B3CEE600B6D3E600BAD6E800ADC4
      D70090A7B800A4B9CD001E252E00183465004D607E00BBD4EB00A9C4D9001F22
      2600717B8200B3C0CA00ACB5BD009DA8B1000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B5CFE600A8BFD600677685003338
      3D0069696B008A8C8F0066666800484B4E00545D67009FB7CB00AEC6DC002328
      2C00586169009EAAB300ACB8C100919EA8000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BAD4E80073829000252527002626
      27006F6F7000989899009393940092919100888888007E808200747B84003F42
      45003B4245009AA7B000A5B1BC0094A0A9000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BBD2EA006C7A8700262627002727
      28007474750099999B00919193008E8E8F008B8B8D008A8A8C0089898B007778
      790036393B00B5C4CF00A7B2BB00A0ACB7000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B3CAE30067738000272728002828
      29007A7A7B009E9E9F0095959600929293008F8F90008B8B8D00878789006D6E
      700035373900D9E4EF00B7C7D300839098000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B5CFE600616E7800272728002D2D
      2E007E7E7F00A1A1A2009D9D9E009B9A9A0095959600909092008C8C8D006C6C
      6E0040444600A9B0B500343A4200121C29000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BAD5EB00677582003D3D3E005353
      5600656567006D6D6E0074757B007E838E0087898D008E8E8F008F8F90008283
      85005B6066006A7B89005B697400313C46000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B8D5EB00B0CDE1009AB3C5007F92
      A1006C7A86005A636B00283A590027467D003D4A64005E5D5C00656567006B6C
      6E00727A8000AFC6DE00B0CCE300A8C4DA000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000AECDE200AEC9E000ADCAE200B0CB
      E200B0C9E200B4CFE800A7BFD400A0B4C6008CA0B10074808E0077879500A0B9
      CB00BFD5EC00BAD6EB00BED7ED00B0CCE6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A7D7E9009BCDE400A0D6
      F40095CCF1006EAAD4004280B00064A3D5006AA5D700326A9B0092C5F0009AC7
      ED00AFD6F600B8DBF500B3D0E500BAD5E90000000000A7C1DA00A9C6DC00A8C3
      D500ADC2D600A7BDD500ADC6DD00AFCDE000AECCE000A7C7DD00A9C3DC00ADC9
      DE00AFC9DD00A6C4DB00AFC7DC00B1C8DD00000000000A0500000A060100FBF5
      EE000000000000000000000000000000000000000000000000000D0700000804
      000000000000FDFAF6000A0500000A050000000000008080800000FFFF0000FF
      FF000000000000FFFF000000000000FFFF000000000000FFFF000000000000FF
      FF00008080000000000000000000000000009CC8D900A4D2E4009FCFE700B4E8
      FF0096CCEF0093CEF60079B4E20089C4F50079B3E4007EB4E3008FC1EB00AFDB
      FF00A4CBEB00AECFE900B5D4E900B0CBDF00BFD9EF00BAD7ED00AAC6DC00A0B8
      CD0097ABBE008699AA008193A4007F96A5007F93A4008197A8007E92A3007C90
      A0008396A7009FB8CE00ABC6DD00B0CAE100000000000000000000000000FBF5
      EE000A06010000000000000000000000000000000000000000000A050000FDFA
      F600FDFAF600FDFAF600FDFAF6000A050000000000008080800000FFFF000000
      000000FFFF0000000000000000000080800000FFFF000000000000FFFF000000
      000000808000008080000000000000000000709AAD008CB7CC008DBBD3005B8B
      A7002D60810083B7DF008EC4ED0095CAF50092C7F2008FC1EB0038668F009AC4
      E700A8CEEC00A5C6E000B4D3EA00BBD8ED00AEC8DE00798C9D00292F34000A0C
      0E00040405000A0D0E0011141600090E0E00050608000E1213001A2129001C23
      2C0037465800363E4500A6C2D600B9D4EA00000000000A050000F8F4EE000000
      000000000000F8F4EE0000000000000000000000000000000000FDFAF600FDFA
      F600FDFAF60008040000FDFAF60000000000000000008080800000FFFF0000FF
      FF000000000000FFFF0000000000008080000000000000FFFF000000000000FF
      FF00008080000080800000000000000000000A31470097C0D600D3FCFF00C8F4
      FF00B8E5FF00174469005685AB0037688E0025537C0087B4DA00B1DDFF00AAD3
      F400B4D8F600C4E5FF00A4C3DA00BBDAEF0072849500070B0E000F151C002028
      35002D384800313F510033465F003D5470003F5976004D6687004F658500546A
      8D004C617D00435A7300414D5600A4BFD400000000000A0500000A0500000A05
      0000000000000000000000000000000000000000000000000000FBF6F1000000
      0000000000000A0500000000000000000000000000008080800000FFFF000000
      000000FFFF0000000000000000000000000000FFFF000000000000FFFF000000
      000000808000008080000000000000000000B1D5ED0052768E00375C76003B62
      7E0010385500AFD6F600B3DCFD0007305100032B4E0095BEDF007BA2C200244A
      68005479950011324C00ADCCE500BDDDF4004E5A6500283A5100394D69003948
      5F002E3F54002A3B4D00222E3F00212E3D001F2D3C00273546003A4B5F002E3D
      500032415300323F53003E536600859AAA000000000000000000000000000000
      0000000000000000000000000000000000000000000008040000000000000000
      0000000000000A0500000D07000000000000000000008080800000FFFF0000FF
      FF000000000000FFFF0000000000000000000000000000FFFF000000000000FF
      FF0000808000008080000000000000000000B2D1EA0092B4CC00B7D8F20087A8
      C200A9CBE800ACCEEB00A3C7E5000F33510000224000C0E4FF003A5C7900ADCF
      EC00AACDE7006C8DA700AED0E8009FC1D9008DA1B300343C430006070900161C
      23000405070000000000000000000000000000000000131719001B2125000000
      000000000000000000002B333A0090A6BB000000000000000000000000000000
      0000000000000804000008040000080400000000000000000000000000000000
      0000000000000A0500000A0500000A050000000000008080800000FFFF000000
      000000FFFF000000000000FFFF000000000000FFFF000000000000FFFF000000
      000000808000008080000000000000000000A8C5E0009AB8D300A6C4DF004B69
      84009FBDD800CDEBFF00A5C3DE0012304B001937520095B3CE00A6C7E1005D7E
      9800A5C6E000AACBE500B2D3ED00B1D4EE00B1CCE100AEC7DD008DA2B5000808
      08008E98A200717C8500919EA700909CA700AAB7C000656A6F0000000000B7C0
      C800ACB6BF006C7379006A7A8700B2CEE5000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000F6F2EE00000000000D0701000000000000000000808080000000000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000808000008080000000000000000000B7D4EF00B3D0EB004E6B86004F6C
      8700B7D4EF00A8C6DF00B9D6F1001F3E57002B486300BAD9F200A6C4DF0085A3
      BE009ABBD500B3D4EE00A5C8E200AFD2EC00B3CEE700B3D0E700A5BBD1001113
      14009DA8B200A1ABB600A1ACB400A1ACB50084919C0069737B0000000000C9D5
      DC00B5BEC60039414600AEC7DC00B9D5EA0000000000FBF8F600FBF8F600FBF8
      F600000000000000000000000000000000000000000000000000000000000000
      00000A05000000000000FBF5EE00000000000000000080808000008080000080
      8000008080000080800000808000008080000080800000808000008080000080
      800000808000008080000000000000000000AEC9E400B1CCE700233F5D00526E
      8C00ADCBE800C8E6FF00A4C2DF004869830049678400B5D6F000B6D6F3007797
      B4004C6C8900B3D3F000A3C4DE00B2D3ED00B3CFE900B6D3EA00A6BDD0002225
      280087939B00A9B2BB00ACB8BF0099A4B00089939D007C868C0000000000F6FE
      FF0070777C008CA0B400B7D3E900B5D1E9000000000000000000FBF8F6000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000D070100000000000000000000000000808080000080
      800000FFFF0000000000808080008080800080808000808080000000000000FF
      FF0000000000000000000000000000000000BFDAF500C7E4FF001A3855005976
      9500B7D6F500A3C4E500A8CBEC001F4263002A4D6E00A8CBEC00B6D7F800B3D5
      F300385776009DBDDA00BBDCF600B4D5EF00B9D5EA00B1CFEA00A9C0D6004E58
      6100626A7100A3B0B9009BA6B10088959E0092A0AE0050575C0029303800E6E6
      E6003B475100B7CFE500B9D7EB00B5D3E9000000000000000000000000000000
      00000000000000000000FBF7F3000000000000000000FBF7F300000000000000
      000000000000FBF6F100FBF6F100000000000000000000000000000000008080
      800000FFFF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B7D5EE009FBDD8003D5D7A001F42
      6300567A9E00A8CFF500B4DDFF00163F66001E476E00ADD4FB009DC2E800577B
      9F00193A5B00B2D2EF00B9D7F200B2D1EA00B1D0E600B0CEE700B0CBE2008DA0
      B0006C757B00A5B3BF0098A2AA008D98A400CCDDEA0004040600A0ABB800454B
      4F0096AEC200B2D1E500B2CFE500B4D1E7000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      800000FFFF0000000000000000000000000000000000000000000000000000FF
      FF0000000000000000000000000000000000B8D7F000AECFE9005D819F00769C
      BE00325D840039669100315F8E001E4F7D00002B5B002F5D8C0037628D00264D
      7400395E8000A1C0DF00B6D3EE00AFCAE400BCD3ED00B6D5EB00BCDAF10093AA
      BD005C656E00A9B4BE00C2D2DD00B0C1D10069737C00283037005B636A006273
      8000AECDE300B1CDE500B4D0E500B9D1E8000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      800000FFFF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000A4C6DD00ACD1EB003C6481007BA8
      CA0016477300A6DBFF00094276004E87BE006DA4DD0010467B0072A3D5003863
      8E001B406600B6D5F400BDD8F300C4DEF600B0CDE500B0CBE300B0CEE500859A
      AA0081828200BFCDDC00333B4400000000005864710073889800444E570098B5
      C900B6D0E900B8D4EC00B3CDE800B5CDE6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      800000FFFF0000FFFF00000000000000000000000000000000000000000000FF
      FF0000000000000000000000000000000000BFE4FA0094BDD400A6D2F1004978
      9E0076ACDB00003C72008FCEFF004686C6000029690092CEFF002A6097003C6A
      9A0094BBE200B0CFF000BDD6F000B2CAE200B7D1E800B3CEE400B7D1E7009DB2
      C300545F69002025290012161E0042515D00A5BED4009EB8CE0090A7BA00A9C7
      DF00B2CEE600B5D3E700B0CDE300AFCCE4000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008080800000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000000
      000000000000000000000000000000000000A0C8DB00B1DBF200A1CFEE00A1D5
      FD003671A20069A9E3006AAEEF001C63A700377CC1005C9CDD003971AC0089BA
      EC00A7CDF700A0BFE000C1DAF400B2C9DF00B4CFE500B4D0E500B7D2EA00B0CB
      E200A7BFD400A6BCD2007E93A20093A6B800BBD4EB00B6D0E800B3CFE800B2CF
      E700B0CEE500B7D1E800B7D3EA00B5D1E8000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000808080008080800080808000808080000000
      000000000000000000000000000000000000B4DCEF00A0CAE1009ECDEC008BC2
      E900A0DDFF002F73AE002168AC00529CE4004388D1000040850093CCFF0096C8
      FC00A8CEF800C8E7FF00A6BDD700BFD4EA00ABC9DE00ABCCE600ACCFE300A2BE
      D400A3BED100A5BBD300A1C2D500A3C5DA00A8C8DD00A5C2DC00A3BFDA00B8D2
      E400B1C9E000A8C7DB00ADC4DF00B2C7E0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000C0078000800000008AA1000000006000
      945100000000180088A1000000000400945100000000038088A10000000018E0
      9551000000003014A0010000000082C480010000000003C4C001000000000C30
      E3D7000000001FF8E3C7000000001998E3D7000000001998E027000000000FF0
      F00F0000000003C0F81F00000000000000000000000000000000000000000000
      000000000000}
  end
  object pmShipMemGrid: TPopupMenu
    Left = 440
    Top = 344
    object miShipMemGridGotoAddress: TMenuItem
      Caption = 'Goto Address'
      OnClick = miShipMemGridGotoAddressClick
    end
  end
  object pmMemInsp: TPopupMenu
    Left = 352
    Top = 360
    object miMemInspGotoAddr: TMenuItem
      Caption = 'Goto Address'
      OnClick = miMemInspGotoAddrClick
    end
  end
end
