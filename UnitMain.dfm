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
  OldCreateOrder = True
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
        Left = 264
        Top = 96
        Width = 129
        Height = 25
        Caption = 'Start MineServer'
        TabOrder = 0
        OnClick = ButtonActClick
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
          TabOrder = 0
          CodeFolding.GutterShapeSize = 11
          CodeFolding.CollapsedLineColor = clGrayText
          CodeFolding.FolderBarLinesColor = clGrayText
          CodeFolding.IndentGuidesColor = clGray
          CodeFolding.IndentGuides = True
          CodeFolding.ShowCollapsedLine = False
          CodeFolding.ShowHintMark = True
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
          FontSmoothing = fsmNone
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
      object ComboBoxBlocks: TComboBox
        Left = 3
        Top = 42
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
    end
  end
  object ncServerSource1: TncServerSource
    EncryptionKey = 'SetEncryptionKey'
    OnHandleCommand = ncServerSource1HandleCommand
    Left = 24
    Top = 8
  end
  object PythonEngine1: TPythonEngine
    IO = PythonGUIInputOutput1
    Left = 272
    Top = 8
  end
  object PythonGUIInputOutput1: TPythonGUIInputOutput
    UnicodeIO = True
    RawOutput = False
    Output = Memo1
    Left = 608
    Top = 8
  end
  object PythonDelphiVar1: TPythonDelphiVar
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
end
