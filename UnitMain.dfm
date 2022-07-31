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
  object ButtonAct: TButton
    Left = 88
    Top = 8
    Width = 129
    Height = 25
    Caption = 'Start MineServer'
    TabOrder = 0
    OnClick = ButtonActClick
  end
  object SynEdit1: TSynEdit
    Left = 8
    Top = 56
    Width = 683
    Height = 289
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    TabOrder = 1
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
  object Memo1: TMemo
    Left = 8
    Top = 351
    Width = 683
    Height = 120
    TabOrder = 2
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
    Left = 520
    Top = 8
  end
end
