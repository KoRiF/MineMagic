object MineModule: TMineModule
  OnCreate = DataModuleCreate
  Height = 360
  Width = 802
  PixelsPerInch = 96
  object PythonEngine1: TPythonEngine
    AutoLoad = False
    Left = 32
    Top = 16
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
    Left = 28
    Top = 82
  end
  object PyDelphiWrapper1: TPyDelphiWrapper
    Engine = PythonEngine1
    Left = 28
    Top = 146
  end
  object PythonDelphiVarMessage: TPythonDelphiVar
    Engine = PythonEngine1
    Module = '__main__'
    VarName = 'mine_message'
    Left = 197
    Top = 16
  end
  object PythonDelphiVarLoop: TPythonDelphiVar
    Engine = PythonEngine1
    Module = '__main__'
    VarName = 'mine_loop'
    Left = 189
    Top = 82
  end
  object PythonDelphiVarLoopCountdown: TPythonDelphiVar
    Engine = PythonEngine1
    Module = '__main__'
    VarName = 'mine_countdown'
    Left = 188
    Top = 154
  end
  object PythonDelphiVarLoopDelay: TPythonDelphiVar
    Engine = PythonEngine1
    Module = '__main__'
    VarName = 'mine_loopdelay'
    Left = 188
    Top = 226
  end
  object SynPythonSyn1: TSynPythonSyn
    Options.AutoDetectEnabled = False
    Options.AutoDetectLineLimit = 0
    Options.Visible = False
    KeyAttri.Foreground = clOlive
    SystemAttri.Style = [fsBold, fsUnderline]
    Left = 586
    Top = 48
  end
  object PythonGUIInputOutput1: TPythonGUIInputOutput
    DelayWrites = True
    UnicodeIO = True
    RawOutput = False
    Left = 594
    Top = 144
  end
end
