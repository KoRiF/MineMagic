object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'Mine Server'
  ClientHeight = 479
  ClientWidth = 699
  Color = clBtnFace
  CustomTitleBar.CaptionAlignment = taCenter
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 699
    Height = 479
    ActivePage = TabSheetCmdServer
    Align = alClient
    TabOrder = 0
    object TabSheetCmdServer: TTabSheet
      Caption = 'Mine Commands Server'
      object ButtonAct: TButton
        Left = 0
        Top = 32
        Width = 129
        Height = 25
        Caption = 'Start MineServer'
        TabOrder = 0
        OnClick = ButtonActClick
      end
      object ButtonTgBot: TButton
        Left = 3
        Top = 80
        Width = 126
        Height = 25
        Caption = 'Start Telegram Bot'
        TabOrder = 1
        OnClick = ButtonTgBotClick
      end
    end
    object TabSheetScripting: TTabSheet
      Caption = 'Mine Scripting'
      ImageIndex = 1
      object Memo1: TMemo
        Left = 8
        Top = 329
        Width = 683
        Height = 120
        TabOrder = 0
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 691
        Height = 323
        Align = alTop
        TabOrder = 1
        object SynEdit1: TSynEdit
          Left = 8
          Top = 34
          Width = 683
          Height = 263
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Font.Quality = fqClearTypeNatural
          TabOrder = 0
          UseCodeFolding = False
          Gutter.Font.Charset = DEFAULT_CHARSET
          Gutter.Font.Color = clWindowText
          Gutter.Font.Height = -11
          Gutter.Font.Name = 'Courier New'
          Gutter.Font.Style = []
          Highlighter = SynPythonSyn1
          Lines.Strings = (
            'from mcpi.minecraft import Minecraft'
            'mc = Minecraft.create()'
            ''
            'mc.postToChat(mine_message.Value)'
            '')
        end
        object ButtonRunScript: TButton
          Left = 1
          Top = 297
          Width = 689
          Height = 25
          Align = alBottom
          Caption = 'Run Script'
          TabOrder = 1
          OnClick = ButtonRunScriptClick
        end
      end
    end
    object TabSheetTools: TTabSheet
      Caption = 'Mine Tools'
      ImageIndex = 2
      object LabelLoopCountdown: TLabel
        Left = 168
        Top = 99
        Width = 132
        Height = 15
        Caption = 'Initital Loop Countdown '
      end
      object LabelLoopDelay: TLabel
        Left = 168
        Top = 139
        Width = 84
        Height = 15
        Caption = 'Loop Delay, ms '
      end
      object ComboBoxBlocks: TComboBox
        Left = 543
        Top = 58
        Width = 145
        Height = 23
        TabOrder = 0
        Text = 'Select block...'
        Items.Strings = (
          'AIR                  '
          'STONE                '
          'GRASS                '
          'DIRT                 '
          'COBBLESTONE          '
          'WOOD PLANKS          '
          'SAPLING              '
          'BEDROCK              '
          'WATER FLOWING        '
          'WATER STATIONARY     '
          'LAVA FLOWING         '
          'LAVA STATIONARY      '
          'SAND                 '
          'GRAVEL               '
          'GOLD ORE             '
          'IRON ORE             '
          'COAL ORE             '
          'WOOD                 '
          'LEAVES               '
          'GLASS                '
          'LAPIS LAZULI ORE     '
          'LAPIS LAZULI BLOCK   '
          'SANDSTONE            '
          'BED                  '
          'COBWEB               '
          'GRASS TALL           '
          'WOOL                 '
          'FLOWER YELLOW        '
          'FLOWER CYAN          '
          'MUSHROOM BROWN       '
          'MUSHROOM RED         '
          'GOLD BLOCK           '
          'IRON BLOCK           '
          'STONE SLAB DOUBLE    '
          'STONE SLAB           '
          'BRICK BLOCK          '
          'TNT                  '
          'BOOKSHELF            '
          'MOSS STONE           '
          'OBSIDIAN             '
          'TORCH                '
          'FIRE                 '
          'STAIRS WOOD          '
          'CHEST                '
          'DIAMOND ORE          '
          'DIAMOND BLOCK        '
          'CRAFTING TABLE       '
          'FARMLAND             '
          'FURNACE INACTIVE     '
          'FURNACE ACTIVE       '
          'DOOR WOOD            '
          'LADDER               '
          'STAIRS COBBLESTONE   '
          'DOOR IRON            '
          'REDSTONE ORE         '
          'SNOW                 '
          'ICE                  '
          'SNOW BLOCK           '
          'CACTUS               '
          'CLAY                 '
          'SUGAR CANE           '
          'FENCE                '
          'GLOWSTONE BLOCK      '
          'BEDROCK INVISIBLE    '
          'STONE BRICK          '
          'GLASS PANE           '
          'MELON                '
          'FENCE GATE           '
          'GLOWING OBSIDIAN     '
          'NETHER REACTOR CORE  ')
      end
      object SpinEditLoopCountdown: TSpinEdit
        Left = 306
        Top = 96
        Width = 105
        Height = 24
        MaxValue = 1000
        MinValue = 0
        TabOrder = 1
        Value = 1000
      end
      object SpinEditLoopDelay: TSpinEdit
        Left = 306
        Top = 136
        Width = 105
        Height = 24
        MaxValue = 60000
        MinValue = 10
        TabOrder = 2
        Value = 500
      end
      object CheckBoxLoop: TCheckBox
        Left = 168
        Top = 61
        Width = 113
        Height = 17
        Caption = 'Run Magic Loop'
        Checked = True
        State = cbChecked
        TabOrder = 3
      end
      object CheckListBoxCommands: TCheckListBox
        Left = 0
        Top = 309
        Width = 201
        Height = 137
        ItemHeight = 15
        TabOrder = 4
      end
      object EditMagicTest: TEdit
        Left = 376
        Top = 384
        Width = 265
        Height = 23
        TabOrder = 5
        Text = 'MAGIC _'
      end
      object ButtonTestMagic: TButton
        Left = 376
        Top = 421
        Width = 75
        Height = 25
        Caption = 'Test Magic'
        TabOrder = 6
        OnClick = ButtonTestMagicClick
      end
    end
  end
  object ncServerSource1: TncServerSource
    EncryptionKey = 'SetEncryptionKey'
    OnHandleCommand = ncServerSource1HandleCommand
    Left = 24
    Top = 8
  end
  object PythonEngine1: TPythonEngine
    DllName = 'python37.dll'
    DllPath = 'c:\Python37\'
    APIVersion = 1013
    RegVersion = '3.7'
    UseLastKnownVersion = False
    IO = PythonGUIInputOutput1
    Left = 272
    Top = 8
  end
  object PythonGUIInputOutput1: TPythonGUIInputOutput
    DelayWrites = True
    UnicodeIO = True
    RawOutput = False
    Output = Memo1
    Left = 608
    Top = 8
  end
  object PythonDelphiVarMessage: TPythonDelphiVar
    Engine = PythonEngine1
    Module = '__main__'
    VarName = 'mine_message'
    Left = 448
    Top = 8
  end
  object SynPythonSyn1: TSynPythonSyn
    Options.AutoDetectEnabled = False
    Options.AutoDetectLineLimit = 0
    Options.Visible = False
    KeyAttri.Foreground = clOlive
    SystemAttri.Style = [fsBold, fsUnderline]
    Left = 520
    Top = 8
  end
  object PythonDelphiVarLoop: TPythonDelphiVar
    Engine = PythonEngine1
    Module = '__main__'
    VarName = 'mine_loop'
    Left = 444
    Top = 66
  end
  object PythonDelphiVarLoopCountdown: TPythonDelphiVar
    Engine = PythonEngine1
    Module = '__main__'
    VarName = 'mine_countdown'
    Left = 436
    Top = 114
  end
  object PythonDelphiVarLoopDelay: TPythonDelphiVar
    Engine = PythonEngine1
    Module = '__main__'
    VarName = 'mine_loopdelay'
    Left = 436
    Top = 162
  end
  object PythonModule1: TPythonModule
    Engine = PythonEngine1
    Events = <
      item
        Name = 'delphi_define_commands'
        OnExecute = PythonModule1Events0Execute
      end
      item
        Name = 'delphi_request_loop_command'
        OnExecute = PythonModule1Events1Execute
      end
      item
        Name = 'delphi_request_instance'
        OnExecute = PythonModule1Events2Execute
      end
      item
        Name = 'delphi_synchronize_activities'
        OnExecute = PythonModule1Events3Execute
      end>
    ModuleName = 'delphi_module'
    Errors = <>
    Left = 268
    Top = 74
  end
  object PyDelphiWrapper1: TPyDelphiWrapper
    Engine = PythonEngine1
    Module = PythonModule1
    Left = 268
    Top = 146
  end
end
