object P3InsightSetup: TP3InsightSetup
  Left = 0
  Top = 0
  Caption = 'P3Insight '#35774#32622
  ClientHeight = 699
  ClientWidth = 839
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 660
    Width = 839
    Height = 39
    Align = alBottom
    TabOrder = 0
    ExplicitTop = 524
    ExplicitWidth = 670
    DesignSize = (
      839
      39)
    object btnOk: TButton
      Left = 674
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Ok'
      TabOrder = 0
      ExplicitLeft = 505
    end
    object btnCancel: TButton
      Left = 755
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 1
      ExplicitLeft = 586
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 839
    Height = 660
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 670
    ExplicitHeight = 524
    object TabSheet1: TTabSheet
      Caption = #20195#30721#20462#25913
      ExplicitLeft = 8
      ExplicitTop = 28
      object GroupBox1: TGroupBox
        Left = 16
        Top = 40
        Width = 169
        Height = 113
        Caption = #25151#23627#23481#32435#20154#25968
        TabOrder = 0
        object cbHouseCap1: TCheckBox
          Left = 16
          Top = 24
          Width = 76
          Height = 17
          Caption = #21830#20154#25151#23627
          TabOrder = 0
        end
        object edHouseCap1: TEdit
          Left = 92
          Top = 22
          Width = 56
          Height = 21
          TabOrder = 1
        end
        object cbHouseCap2: TCheckBox
          Left = 16
          Top = 53
          Width = 76
          Height = 17
          Caption = #30707#30732#25151#23627
          TabOrder = 2
        end
        object edHouseCap2: TEdit
          Left = 93
          Top = 51
          Width = 55
          Height = 21
          TabOrder = 3
        end
        object cbHouseCap3: TCheckBox
          Left = 16
          Top = 82
          Width = 76
          Height = 17
          Caption = #26408#21046#25151#23627
          TabOrder = 4
        end
        object edHouseCap3: TEdit
          Left = 93
          Top = 78
          Width = 55
          Height = 21
          TabOrder = 5
        end
      end
      object cbMod_GlobalEnabled: TCheckBox
        Left = 16
        Top = 8
        Width = 97
        Height = 17
        Caption = #21551#29992#20195#30721#20462#25913
        TabOrder = 1
      end
      object GroupBox4: TGroupBox
        Left = 357
        Top = 42
        Width = 310
        Height = 139
        Caption = #33337#21482#23481#37327'('#21253')'
        TabOrder = 2
        object Label1: TLabel
          Left = 76
          Top = 16
          Width = 30
          Height = 13
          Caption = #31561#32423'1'
        end
        object Label2: TLabel
          Left = 130
          Top = 16
          Width = 30
          Height = 13
          Caption = #31561#32423'2'
        end
        object Label3: TLabel
          Left = 184
          Top = 16
          Width = 30
          Height = 13
          Caption = #31561#32423'3'
        end
        object Label4: TLabel
          Left = 241
          Top = 16
          Width = 30
          Height = 13
          Caption = #31561#32423'4'
        end
        object cbShip1Cap: TCheckBox
          Left = 16
          Top = 34
          Width = 55
          Height = 17
          Caption = #23567#21490
          TabOrder = 0
        end
        object edShip1CapL1: TEdit
          Left = 67
          Top = 32
          Width = 48
          Height = 21
          TabOrder = 1
        end
        object cbShip2Cap: TCheckBox
          Left = 16
          Top = 58
          Width = 55
          Height = 17
          Caption = #23567#20811
          TabOrder = 5
        end
        object cbShip3Cap: TCheckBox
          Left = 16
          Top = 82
          Width = 55
          Height = 17
          Caption = #22823#20811
          TabOrder = 10
        end
        object cbShip4Cap: TCheckBox
          Left = 16
          Top = 106
          Width = 55
          Height = 17
          Caption = #22823#38669
          TabOrder = 15
        end
        object edShip2CapL1: TEdit
          Left = 67
          Top = 56
          Width = 48
          Height = 21
          TabOrder = 6
        end
        object edShip3CapL1: TEdit
          Left = 67
          Top = 80
          Width = 48
          Height = 21
          TabOrder = 11
        end
        object edShip4CapL1: TEdit
          Left = 68
          Top = 104
          Width = 48
          Height = 21
          TabOrder = 16
        end
        object edShip1CapL2: TEdit
          Left = 121
          Top = 32
          Width = 48
          Height = 21
          TabOrder = 2
        end
        object edShip2CapL2: TEdit
          Left = 121
          Top = 56
          Width = 48
          Height = 21
          TabOrder = 7
        end
        object edShip3CapL2: TEdit
          Left = 121
          Top = 80
          Width = 48
          Height = 21
          TabOrder = 12
        end
        object edShip4CapL2: TEdit
          Left = 122
          Top = 104
          Width = 48
          Height = 21
          TabOrder = 17
        end
        object edShip1CapL3: TEdit
          Left = 175
          Top = 32
          Width = 48
          Height = 21
          TabOrder = 3
        end
        object edShip2CapL3: TEdit
          Left = 175
          Top = 56
          Width = 48
          Height = 21
          TabOrder = 8
        end
        object edShip3CapL3: TEdit
          Left = 175
          Top = 80
          Width = 48
          Height = 21
          TabOrder = 13
        end
        object edShip4CapL3: TEdit
          Left = 176
          Top = 104
          Width = 48
          Height = 21
          TabOrder = 18
        end
        object edShip1CapL4: TEdit
          Left = 232
          Top = 32
          Width = 48
          Height = 21
          TabOrder = 4
        end
        object edShip2CapL4: TEdit
          Left = 232
          Top = 56
          Width = 48
          Height = 21
          TabOrder = 9
        end
        object edShip3CapL4: TEdit
          Left = 232
          Top = 80
          Width = 48
          Height = 21
          TabOrder = 14
        end
        object edShip4CapL4: TEdit
          Left = 232
          Top = 104
          Width = 48
          Height = 21
          TabOrder = 19
        end
      end
      object GroupBox5: TGroupBox
        Left = 681
        Top = 45
        Width = 141
        Height = 572
        Caption = #24037#21378#38656#35201#30340#24037#20154#25968
        TabOrder = 3
        object cbHunterHouseWorkers: TCheckBox
          Left = 16
          Top = 26
          Width = 65
          Height = 17
          Caption = #25429#29454
          TabOrder = 0
        end
        object edHunterHouseWorkers: TEdit
          Left = 83
          Top = 24
          Width = 43
          Height = 21
          TabOrder = 1
        end
        object cbPiscaryWorkers: TCheckBox
          Left = 16
          Top = 57
          Width = 65
          Height = 17
          Caption = #25429#40060#22330
          TabOrder = 2
        end
        object edPiscaryWorkers: TEdit
          Left = 83
          Top = 55
          Width = 43
          Height = 21
          TabOrder = 3
        end
        object cbBeerFactory: TCheckBox
          Left = 16
          Top = 89
          Width = 65
          Height = 17
          Caption = #21860#37202#21378
          TabOrder = 4
        end
        object edBeerFactory: TEdit
          Left = 83
          Top = 87
          Width = 43
          Height = 21
          TabOrder = 5
        end
        object cbFactoryWorkers: TCheckBox
          Left = 16
          Top = 121
          Width = 65
          Height = 17
          Caption = #24037#21378
          TabOrder = 6
        end
        object edFactoryWorkers: TEdit
          Left = 83
          Top = 119
          Width = 43
          Height = 21
          TabOrder = 7
        end
        object cbApiary: TCheckBox
          Left = 16
          Top = 153
          Width = 65
          Height = 17
          Caption = #20859#34562#22330
          TabOrder = 8
        end
        object edApiary: TEdit
          Left = 83
          Top = 151
          Width = 43
          Height = 21
          TabOrder = 9
        end
        object cbGrainField: TCheckBox
          Left = 16
          Top = 185
          Width = 65
          Height = 17
          Caption = #31291#30000
          TabOrder = 10
        end
        object edGrainField: TEdit
          Left = 83
          Top = 183
          Width = 43
          Height = 21
          TabOrder = 11
        end
        object cbCowFarm: TCheckBox
          Left = 16
          Top = 217
          Width = 65
          Height = 17
          Caption = #20859#29275#22330
          TabOrder = 12
        end
        object edCowFarm: TEdit
          Left = 83
          Top = 215
          Width = 43
          Height = 21
          TabOrder = 13
        end
        object cbLoggingCamp: TCheckBox
          Left = 16
          Top = 249
          Width = 65
          Height = 17
          Caption = #38191#26408#21378
          TabOrder = 14
        end
        object edLoggingCamp: TEdit
          Left = 83
          Top = 247
          Width = 43
          Height = 21
          TabOrder = 15
        end
        object cbTextileMill: TCheckBox
          Left = 16
          Top = 281
          Width = 65
          Height = 17
          Caption = #32442#32455#21378
          TabOrder = 16
        end
        object edTextileMill: TEdit
          Left = 83
          Top = 279
          Width = 43
          Height = 21
          TabOrder = 17
        end
        object cbSaltern: TCheckBox
          Left = 16
          Top = 312
          Width = 65
          Height = 17
          Caption = #21046#30416#21378
          TabOrder = 18
        end
        object edSaltern: TEdit
          Left = 83
          Top = 310
          Width = 43
          Height = 21
          TabOrder = 19
        end
        object cbIronMill: TCheckBox
          Left = 16
          Top = 344
          Width = 65
          Height = 17
          Caption = #28860#38081#21378
          TabOrder = 20
        end
        object edIronMill: TEdit
          Left = 83
          Top = 342
          Width = 43
          Height = 21
          TabOrder = 21
        end
        object cbSheepFarm: TCheckBox
          Left = 16
          Top = 376
          Width = 65
          Height = 17
          Caption = #29287#32650#22330
          TabOrder = 22
        end
        object edSheepFarm: TEdit
          Left = 83
          Top = 374
          Width = 43
          Height = 21
          TabOrder = 23
        end
        object cbWineyard: TCheckBox
          Left = 16
          Top = 408
          Width = 65
          Height = 17
          Caption = #33889#33796#22253
          TabOrder = 24
        end
        object edWineyard: TEdit
          Left = 83
          Top = 406
          Width = 43
          Height = 21
          TabOrder = 25
        end
        object cbCeramicFactory: TCheckBox
          Left = 16
          Top = 440
          Width = 65
          Height = 17
          Caption = #38518#22120#21378
          TabOrder = 26
        end
        object edCeramicFactory: TEdit
          Left = 83
          Top = 438
          Width = 43
          Height = 21
          TabOrder = 27
        end
        object cbBrickyard: TCheckBox
          Left = 16
          Top = 472
          Width = 65
          Height = 17
          Caption = #30742#21378
          TabOrder = 28
        end
        object edBrickyard: TEdit
          Left = 83
          Top = 470
          Width = 43
          Height = 21
          TabOrder = 29
        end
        object cbAsphaltFactory: TCheckBox
          Left = 16
          Top = 504
          Width = 65
          Height = 17
          Caption = #27813#38738#21378
          TabOrder = 30
        end
        object edAsphaltFactory: TEdit
          Left = 83
          Top = 502
          Width = 43
          Height = 21
          TabOrder = 31
        end
        object cbHempField: TCheckBox
          Left = 16
          Top = 536
          Width = 65
          Height = 17
          Caption = #40635#30000
          TabOrder = 32
        end
        object edHempField: TEdit
          Left = 83
          Top = 534
          Width = 43
          Height = 21
          TabOrder = 33
        end
      end
      object GroupBox6: TGroupBox
        Left = 16
        Top = 322
        Width = 651
        Height = 295
        Caption = #23621#27665#36135#29289#38656#27714'('#21253'/'#26742')'
        TabOrder = 4
        object Label5: TLabel
          Left = 107
          Top = 24
          Width = 24
          Height = 13
          Caption = #23500#20154
        end
        object Label6: TLabel
          Left = 179
          Top = 24
          Width = 24
          Height = 13
          Caption = #30334#22995
        end
        object Label7: TLabel
          Left = 251
          Top = 24
          Width = 24
          Height = 13
          Caption = #31351#20154
        end
        object Label8: TLabel
          Left = 435
          Top = 24
          Width = 24
          Height = 13
          Caption = #23500#20154
        end
        object Label9: TLabel
          Left = 507
          Top = 24
          Width = 24
          Height = 13
          Caption = #30334#22995
        end
        object Label10: TLabel
          Left = 579
          Top = 24
          Width = 24
          Height = 13
          Caption = #31351#20154
        end
        object cbGrainReq: TCheckBox
          Left = 27
          Top = 45
          Width = 65
          Height = 17
          Caption = #35895#29289
          TabOrder = 0
        end
        object edGrainReqRich: TEdit
          Left = 90
          Top = 43
          Width = 65
          Height = 21
          TabOrder = 1
        end
        object cbMeatReq: TCheckBox
          Left = 27
          Top = 68
          Width = 65
          Height = 17
          Caption = #32905
          TabOrder = 2
        end
        object edMeatReqRich: TEdit
          Left = 90
          Top = 66
          Width = 65
          Height = 21
          TabOrder = 3
        end
        object cbFishReq: TCheckBox
          Left = 27
          Top = 92
          Width = 65
          Height = 17
          Caption = #40060
          TabOrder = 4
        end
        object edFishReqRich: TEdit
          Left = 90
          Top = 90
          Width = 65
          Height = 21
          TabOrder = 5
        end
        object cbBeerReq: TCheckBox
          Left = 27
          Top = 115
          Width = 65
          Height = 17
          Caption = #21860#37202
          TabOrder = 6
        end
        object edBeerReqRich: TEdit
          Left = 90
          Top = 113
          Width = 65
          Height = 21
          TabOrder = 7
        end
        object cbSaltReq: TCheckBox
          Left = 27
          Top = 139
          Width = 65
          Height = 17
          Caption = #30416
          TabOrder = 8
        end
        object edSaltReqRich: TEdit
          Left = 90
          Top = 137
          Width = 65
          Height = 21
          TabOrder = 9
        end
        object cbHoneyReq: TCheckBox
          Left = 27
          Top = 162
          Width = 65
          Height = 17
          Caption = #34562#34588
          TabOrder = 10
        end
        object edHoneyReqRich: TEdit
          Left = 90
          Top = 160
          Width = 65
          Height = 21
          TabOrder = 11
        end
        object cbSpiceReq: TCheckBox
          Left = 27
          Top = 186
          Width = 65
          Height = 17
          Caption = #39321#26009
          TabOrder = 12
        end
        object edSpiceReqRich: TEdit
          Left = 90
          Top = 184
          Width = 65
          Height = 21
          TabOrder = 13
        end
        object cbWineReq: TCheckBox
          Left = 27
          Top = 209
          Width = 65
          Height = 17
          Caption = #33889#33796#37202
          TabOrder = 14
        end
        object edWineReqRich: TEdit
          Left = 90
          Top = 207
          Width = 65
          Height = 21
          TabOrder = 15
        end
        object cbClothReq: TCheckBox
          Left = 27
          Top = 233
          Width = 65
          Height = 17
          Caption = #24067
          TabOrder = 16
        end
        object edClothReqRich: TEdit
          Left = 90
          Top = 231
          Width = 65
          Height = 21
          TabOrder = 17
        end
        object cbAnimalSkinReq: TCheckBox
          Left = 27
          Top = 256
          Width = 65
          Height = 17
          Caption = #20861#30382
          TabOrder = 18
        end
        object edAnimalSkinReqRich: TEdit
          Left = 90
          Top = 254
          Width = 65
          Height = 21
          TabOrder = 19
        end
        object cbWhaleOilReq: TCheckBox
          Left = 350
          Top = 43
          Width = 65
          Height = 17
          Caption = #40120#27833
          TabOrder = 20
        end
        object edWhaleOilReqRich: TEdit
          Left = 413
          Top = 41
          Width = 65
          Height = 21
          TabOrder = 21
        end
        object cbWoodReq: TCheckBox
          Left = 350
          Top = 66
          Width = 65
          Height = 17
          Caption = #26408#26448
          TabOrder = 22
        end
        object edWoodReqRich: TEdit
          Left = 413
          Top = 64
          Width = 65
          Height = 21
          TabOrder = 23
        end
        object cbIronGoodsReq: TCheckBox
          Left = 350
          Top = 90
          Width = 65
          Height = 17
          Caption = #38081#21046#21697
          TabOrder = 24
        end
        object edIronGoodsReqRich: TEdit
          Left = 413
          Top = 88
          Width = 65
          Height = 21
          TabOrder = 25
        end
        object cbLeatherReq: TCheckBox
          Left = 350
          Top = 113
          Width = 65
          Height = 17
          Caption = #30382#38761
          TabOrder = 26
        end
        object edLeatherReqRich: TEdit
          Left = 413
          Top = 111
          Width = 65
          Height = 21
          TabOrder = 27
        end
        object cbWoolReq: TCheckBox
          Left = 350
          Top = 137
          Width = 65
          Height = 17
          Caption = #32650#27611
          TabOrder = 28
        end
        object edWoolReqRich: TEdit
          Left = 413
          Top = 135
          Width = 65
          Height = 21
          TabOrder = 29
        end
        object cbAsphaltReq: TCheckBox
          Left = 350
          Top = 160
          Width = 65
          Height = 17
          Caption = #27813#38738
          TabOrder = 30
        end
        object edAsphaltReqRich: TEdit
          Left = 413
          Top = 158
          Width = 65
          Height = 21
          TabOrder = 31
        end
        object cbIronReq: TCheckBox
          Left = 350
          Top = 184
          Width = 65
          Height = 17
          Caption = #29983#38081
          TabOrder = 32
        end
        object edIronReqRich: TEdit
          Left = 413
          Top = 182
          Width = 65
          Height = 21
          TabOrder = 33
        end
        object cbHempReq: TCheckBox
          Left = 350
          Top = 207
          Width = 65
          Height = 17
          Caption = #40635
          TabOrder = 34
        end
        object edHempReqRich: TEdit
          Left = 413
          Top = 205
          Width = 65
          Height = 21
          TabOrder = 35
        end
        object cbPotteryReq: TCheckBox
          Left = 350
          Top = 231
          Width = 65
          Height = 17
          Caption = #38518#22120
          TabOrder = 36
        end
        object edPotteryReqRich: TEdit
          Left = 413
          Top = 229
          Width = 65
          Height = 21
          TabOrder = 37
        end
        object cbBrickReq: TCheckBox
          Left = 350
          Top = 254
          Width = 65
          Height = 17
          Caption = #30742
          TabOrder = 38
        end
        object edBrickReqRich: TEdit
          Left = 413
          Top = 252
          Width = 65
          Height = 21
          TabOrder = 39
        end
        object edGrainReqCommon: TEdit
          Left = 161
          Top = 43
          Width = 65
          Height = 21
          TabOrder = 40
        end
        object edMeatReqCommon: TEdit
          Left = 161
          Top = 66
          Width = 65
          Height = 21
          TabOrder = 41
        end
        object edFishReqCommon: TEdit
          Left = 161
          Top = 90
          Width = 65
          Height = 21
          TabOrder = 42
        end
        object edBeerReqCommon: TEdit
          Left = 161
          Top = 113
          Width = 65
          Height = 21
          TabOrder = 43
        end
        object edSaltReqCommon: TEdit
          Left = 161
          Top = 137
          Width = 65
          Height = 21
          TabOrder = 44
        end
        object edHoneyReqCommon: TEdit
          Left = 161
          Top = 160
          Width = 65
          Height = 21
          TabOrder = 45
        end
        object edSpiceReqCommon: TEdit
          Left = 161
          Top = 184
          Width = 65
          Height = 21
          TabOrder = 46
        end
        object edWineReqCommon: TEdit
          Left = 161
          Top = 207
          Width = 65
          Height = 21
          TabOrder = 47
        end
        object edClothReqCommon: TEdit
          Left = 161
          Top = 231
          Width = 65
          Height = 21
          TabOrder = 48
        end
        object edAnimalSkinReqCommon: TEdit
          Left = 161
          Top = 254
          Width = 65
          Height = 21
          TabOrder = 49
        end
        object edGrainReqPoor: TEdit
          Left = 232
          Top = 43
          Width = 65
          Height = 21
          TabOrder = 50
        end
        object edMeatReqPoor: TEdit
          Left = 232
          Top = 66
          Width = 65
          Height = 21
          TabOrder = 51
        end
        object edFishReqPoor: TEdit
          Left = 232
          Top = 90
          Width = 65
          Height = 21
          TabOrder = 52
        end
        object edBeerReqPoor: TEdit
          Left = 232
          Top = 113
          Width = 65
          Height = 21
          TabOrder = 53
        end
        object edSaltReqPoor: TEdit
          Left = 232
          Top = 137
          Width = 65
          Height = 21
          TabOrder = 54
        end
        object edHoneyReqPoor: TEdit
          Left = 232
          Top = 160
          Width = 65
          Height = 21
          TabOrder = 55
        end
        object edSpiceReqPoor: TEdit
          Left = 232
          Top = 184
          Width = 65
          Height = 21
          TabOrder = 56
        end
        object edWineReqPoor: TEdit
          Left = 232
          Top = 207
          Width = 65
          Height = 21
          TabOrder = 57
        end
        object edClothReqPoor: TEdit
          Left = 232
          Top = 231
          Width = 65
          Height = 21
          TabOrder = 58
        end
        object edAnimalSkinReqPoor: TEdit
          Left = 232
          Top = 254
          Width = 65
          Height = 21
          TabOrder = 59
        end
        object edWhaleOilReqCommon: TEdit
          Left = 486
          Top = 41
          Width = 65
          Height = 21
          TabOrder = 60
        end
        object edWoodReqCommon: TEdit
          Left = 486
          Top = 64
          Width = 65
          Height = 21
          TabOrder = 61
        end
        object edIronGoodsReqCommon: TEdit
          Left = 486
          Top = 88
          Width = 65
          Height = 21
          TabOrder = 62
        end
        object edLeatherReqCommon: TEdit
          Left = 486
          Top = 111
          Width = 65
          Height = 21
          TabOrder = 63
        end
        object edWoolReqCommon: TEdit
          Left = 486
          Top = 135
          Width = 65
          Height = 21
          TabOrder = 64
        end
        object edAsphaltReqCommon: TEdit
          Left = 486
          Top = 158
          Width = 65
          Height = 21
          TabOrder = 65
        end
        object edIronReqCommon: TEdit
          Left = 486
          Top = 182
          Width = 65
          Height = 21
          TabOrder = 66
        end
        object edHempReqCommon: TEdit
          Left = 486
          Top = 205
          Width = 65
          Height = 21
          TabOrder = 67
        end
        object edPotteryReqCommon: TEdit
          Left = 486
          Top = 229
          Width = 65
          Height = 21
          TabOrder = 68
        end
        object edBrickReqCommon: TEdit
          Left = 486
          Top = 252
          Width = 65
          Height = 21
          TabOrder = 69
        end
        object edWhaleOilReqPoor: TEdit
          Left = 557
          Top = 41
          Width = 65
          Height = 21
          TabOrder = 70
        end
        object edWoodReqPoor: TEdit
          Left = 557
          Top = 64
          Width = 65
          Height = 21
          TabOrder = 71
        end
        object edIronGoodsReqPoor: TEdit
          Left = 557
          Top = 88
          Width = 65
          Height = 21
          TabOrder = 72
        end
        object edLeatherReqPoor: TEdit
          Left = 557
          Top = 111
          Width = 65
          Height = 21
          TabOrder = 73
        end
        object edWoolReqPoor: TEdit
          Left = 557
          Top = 135
          Width = 65
          Height = 21
          TabOrder = 74
        end
        object edAsphaltReqPoor: TEdit
          Left = 557
          Top = 158
          Width = 65
          Height = 21
          TabOrder = 75
        end
        object edIronReqPoor: TEdit
          Left = 557
          Top = 182
          Width = 65
          Height = 21
          TabOrder = 76
        end
        object edHempReqPoor: TEdit
          Left = 557
          Top = 205
          Width = 65
          Height = 21
          TabOrder = 77
        end
        object edPotteryReqPoor: TEdit
          Left = 557
          Top = 229
          Width = 65
          Height = 21
          TabOrder = 78
        end
        object edBrickReqPoor: TEdit
          Left = 557
          Top = 252
          Width = 65
          Height = 21
          TabOrder = 79
        end
      end
      object GroupBox7: TGroupBox
        Left = 192
        Top = 40
        Width = 154
        Height = 90
        Caption = #20179#24211#23481#37327'('#21253')'
        TabOrder = 5
        object cbBOCap: TCheckBox
          Left = 8
          Top = 24
          Width = 65
          Height = 17
          Caption = #20107#21153#25152
          TabOrder = 0
        end
        object edBOCap: TEdit
          Left = 78
          Top = 22
          Width = 64
          Height = 21
          TabOrder = 1
        end
        object cbSHCap: TCheckBox
          Left = 8
          Top = 56
          Width = 65
          Height = 17
          Caption = #20179#24211
          TabOrder = 2
        end
        object edSHCap: TEdit
          Left = 78
          Top = 54
          Width = 64
          Height = 21
          TabOrder = 3
        end
      end
      object GroupBox8: TGroupBox
        Left = 357
        Top = 187
        Width = 154
        Height = 129
        Caption = #33337#21482#24517#35201#27700#25163
        TabOrder = 6
        object cbShip1Seaman: TCheckBox
          Left = 16
          Top = 24
          Width = 55
          Height = 17
          Caption = #23567#21490
          TabOrder = 0
        end
        object edShip1Seaman: TEdit
          Left = 67
          Top = 22
          Width = 70
          Height = 21
          TabOrder = 1
        end
        object cbShip2Seaman: TCheckBox
          Left = 16
          Top = 48
          Width = 55
          Height = 17
          Caption = #23567#20811
          TabOrder = 2
        end
        object cbShip3Seaman: TCheckBox
          Left = 16
          Top = 72
          Width = 55
          Height = 17
          Caption = #22823#20811
          TabOrder = 3
        end
        object cbShip4Seaman: TCheckBox
          Left = 16
          Top = 96
          Width = 55
          Height = 17
          Caption = #22823#38669
          TabOrder = 4
        end
        object edShip2Seaman: TEdit
          Left = 67
          Top = 46
          Width = 70
          Height = 21
          TabOrder = 5
        end
        object edShip3Seaman: TEdit
          Left = 67
          Top = 70
          Width = 70
          Height = 21
          TabOrder = 6
        end
        object edShip4Seaman: TEdit
          Left = 68
          Top = 94
          Width = 70
          Height = 21
          TabOrder = 7
        end
      end
      object GroupBox9: TGroupBox
        Left = 513
        Top = 187
        Width = 154
        Height = 129
        Caption = #33337#21482#36895#24230
        TabOrder = 7
        object cbShip1Speed: TCheckBox
          Left = 16
          Top = 24
          Width = 55
          Height = 17
          Caption = #23567#21490
          TabOrder = 0
        end
        object edShip1Speed: TEdit
          Left = 67
          Top = 22
          Width = 70
          Height = 21
          TabOrder = 1
        end
        object cbShip2Speed: TCheckBox
          Left = 16
          Top = 48
          Width = 55
          Height = 17
          Caption = #23567#20811
          TabOrder = 2
        end
        object cbShip3Speed: TCheckBox
          Left = 16
          Top = 72
          Width = 55
          Height = 17
          Caption = #22823#20811
          TabOrder = 3
        end
        object cbShip4Speed: TCheckBox
          Left = 16
          Top = 96
          Width = 55
          Height = 17
          Caption = #22823#38669
          TabOrder = 4
        end
        object edShip2Speed: TEdit
          Left = 67
          Top = 46
          Width = 70
          Height = 21
          TabOrder = 5
        end
        object edShip3Speed: TEdit
          Left = 67
          Top = 70
          Width = 70
          Height = 21
          TabOrder = 6
        end
        object edShip4Speed: TEdit
          Left = 68
          Top = 94
          Width = 70
          Height = 21
          TabOrder = 7
        end
      end
      object GroupBox2: TGroupBox
        Left = 16
        Top = 163
        Width = 169
        Height = 153
        Caption = #19981#20943#32784#20037
        TabOrder = 8
        object cbWear1: TCheckBox
          Left = 8
          Top = 16
          Width = 97
          Height = 17
          Caption = #26085#24120#19981#20943#32784#20037
          TabOrder = 0
        end
        object cbWear2: TCheckBox
          Left = 8
          Top = 50
          Width = 97
          Height = 17
          Caption = #28023#25112#19981#20943#32784#20037
          TabOrder = 1
        end
        object cbWear3: TCheckBox
          Left = 8
          Top = 85
          Width = 97
          Height = 17
          Caption = #38647#20987#19981#20943#32784#20037
          TabOrder = 2
        end
        object cbWear4: TCheckBox
          Left = 8
          Top = 120
          Width = 121
          Height = 17
          Caption = #26292#39118#38632#19981#20943#32784#20037
          TabOrder = 3
        end
      end
      object GroupBox3: TGroupBox
        Left = 192
        Top = 140
        Width = 154
        Height = 74
        Caption = #19981#20943#22763#27668
        TabOrder = 9
        object cbMorale1: TCheckBox
          Left = 8
          Top = 16
          Width = 97
          Height = 17
          Caption = #26085#24120#19981#20943#22763#27668
          TabOrder = 0
        end
        object cbMorale2: TCheckBox
          Left = 8
          Top = 44
          Width = 121
          Height = 17
          Caption = #37257#37202#20107#20214#19981#20943#22763#27668
          TabOrder = 1
        end
      end
      object GroupBox10: TGroupBox
        Left = 192
        Top = 223
        Width = 154
        Height = 93
        Caption = #19981#20943#27700#25163
        TabOrder = 10
        object cbSeaman1: TCheckBox
          Left = 8
          Top = 16
          Width = 97
          Height = 17
          Caption = #32905#25615#19981#20943#27700#25163
          TabOrder = 0
        end
        object cbSeaman2: TCheckBox
          Left = 8
          Top = 41
          Width = 97
          Height = 17
          Caption = #28846#20987#19981#20943#27700#25163
          TabOrder = 1
        end
        object cbSeaman3: TCheckBox
          Left = 8
          Top = 66
          Width = 129
          Height = 17
          Caption = #20440#34383#25932#33337#27700#25163#19981#20943
          TabOrder = 2
        end
      end
    end
  end
end
