unit UnitMineModule;

interface

uses
  System.SysUtils, System.Classes, PythonEngine, WrapDelphi, ncSources
  , UnitTelegrammer;

type
  TMineModule = class(TDataModule)
    PythonEngine1: TPythonEngine;
    PythonModule1: TPythonModule;
    PyDelphiWrapper1: TPyDelphiWrapper;
    PythonDelphiVarMessage: TPythonDelphiVar;
    PythonDelphiVarLoop: TPythonDelphiVar;
    PythonDelphiVarLoopCountdown: TPythonDelphiVar;
    PythonDelphiVarLoopDelay: TPythonDelphiVar;
    ncServerSource1: TncServerSource;
    procedure DataModuleCreate(Sender: TObject);
    procedure PythonModule1Events0Execute(Sender: TObject; PSelf,
      Args: PPyObject; var Result: PPyObject);
    procedure PythonModule1Events1Execute(Sender: TObject; PSelf,
      Args: PPyObject; var Result: PPyObject);
    procedure PythonModule1Events2Execute(Sender: TObject; PSelf,
      Args: PPyObject; var Result: PPyObject);
    procedure PythonModule1Events3Execute(Sender: TObject; PSelf,
      Args: PPyObject; var Result: PPyObject);
    function ncServerSource1HandleCommand(Sender: TObject; aLine: TncLine;
      aCmd: Integer; const aData: TArray<System.Byte>; aRequiresResult: Boolean;
      const aSenderComponent, aReceiverComponent: string): TArray<System.Byte>;

  private
    { Private declarations }
    TgBot: TTelegramBot;
    _UpdatePySharedVariablesProc: TProc;
    _UpdateCommandItemsListCallbackProc: TProc<string>;
    _PyScript: string;

    procedure setCommandItemsList(CommandItemsList: TStrings);

    procedure InitPython(fileini: string);

    function getTgBotActive(): Boolean;
    procedure setTgBotActive(Active: Boolean);
  public
    { Public declarations }

    property TgBotActive: Boolean read getTgBotActive write setTgBotActive;
    property UpdatePySharedVariables: TProc write _UpdatePySharedVariablesProc;
    property UpdateCommandItemsListCallbackProc: TProc<string> write _UpdateCommandItemsListCallbackProc;
    property PyScript: string write _PyScript;
    property CommandItemsList: TStrings write setCommandItemsList;


    procedure StartPythonMagicThread();
    procedure PassMagicCommand(commandline: string);
    function BreakTgBotActivity(): Boolean;
  end;

var
  MineModule: TMineModule;

implementation
uses UnitCommander, UnitMineScripter, IniFiles;
{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

function TMineModule.BreakTgBotActivity: Boolean;
begin
  TgBotActive := not TgBotActive;
  RESULT := TgBotActive;
end;

procedure TMineModule.DataModuleCreate(Sender: TObject);
begin
  Self.InitPython('minecommander.ini');


  UnitMineScripter.filenameini := 'minecommander.ini';
  var Scripter := TMineScripter.ObtainScripter(
    procedure (script: String)
    begin
      PythonEngine1.ExecString(script);
    end
  );
  Scripter.LoadScripts();

  MineCommander.InitScriptingProc :=
    procedure
    begin
      Scripter.InitScripts();
    end;

  MineCommander.Configure(AsServer);

  MineCommander.RunMagic :=
    procedure (command: String)
    begin
      if Assigned(_UpdatePySharedVariablesProc) then
        _UpdatePySharedVariablesProc();
      Self.PythonDelphiVarMessage.Value := command;

      PythonEngine1.ExecString(_PyScript);
    end;


  MineCommander.ProcessMagic :=
    procedure (command: String)
    begin
      PythonDelphiVarMessage.Value := command;
      MineCommander.NoteWill(command);
    end;

  UnitTelegrammer.filenameini := 'minecommander.ini';
  TgBot := TTelegramBot.InstantinateBot();
  TgBot.ProcessVoiceFile := (
    procedure (voiceFileName: String; Reply: TProc<string>)
    begin
      var voice := MineCommander.RecognizeMineVoice(voiceFileName);
      Reply('Accepted: ' + voice);
        MineCommander.PassCommand('MAGIC', voice);
    end
  );
  TgBot.ProcessTextMessage :=  (
    procedure (text: String; Reply: TProc<string>)
    begin
      Reply('Accepted: ' + text);
        MineCommander.PassCommand('MAGIC', text);
    end
  );

  PythonModule1.Initialize();
end;

function TMineModule.getTgBotActive: Boolean;
begin
  RESULT := Self.TgBot.Active;
end;

procedure TMineModule.InitPython(fileini: string);
const PYSECTION = 'Python';
var IniFile: TIniFile;
  dllName, dllPath, pythonHome, regVersion: string;
begin
  var path := IncludeTrailingPathDelimiter(GetCurrentDir());
  var iniFilename := path + fileini;
  IniFile := TIniFile.Create(iniFilename);
  try

    dllName := IniFile.ReadString(PYSECTION, 'DllName', '');
    if dllName > '' then
      Self.PythonEngine1.DllName := dllName;

    dllPath := IniFile.ReadString(PYSECTION, 'DllPath', '');
    if dllPath > '' then
      Self.PythonEngine1.DllPath := dllPath;

    pythonHome := IniFile.ReadString(PYSECTION, 'Home', dllPath);
    if pythonHome > '' then
      Self.PythonEngine1.SetPythonHome(pythonHome);

    regVersion := IniFile.ReadString(PYSECTION, 'RegVersion', '');
    if regVersion > '' then
    begin
      Self.PythonEngine1.UseLastKnownVersion := False;
      Self.PythonEngine1.RegVersion := regVersion;
    end;

    Self.PythonEngine1.LoadDll();
  finally
    IniFile.Free();
  end;
end;

function TMineModule.ncServerSource1HandleCommand(Sender: TObject;
  aLine: TncLine; aCmd: Integer; const aData: TArray<System.Byte>;
  aRequiresResult: Boolean; const aSenderComponent,
  aReceiverComponent: string): TArray<System.Byte>;
begin
  MineCommander.ReceiveCommand(aCmd, aData);
end;

procedure TMineModule.PassMagicCommand(commandline: string);
begin
  MineCommander.PassCommand('MAGIC', commandline);
end;

procedure TMineModule.PythonModule1Events0Execute(Sender: TObject; PSelf,
  Args: PPyObject; var Result: PPyObject);
begin

  var CmdsListStr := MineCommander.ListKeywords();
  RESULT := PythonEngine1.EvalString(CmdsListStr);

  PythonEngine1.Py_INCREF(Result);
end;

procedure TMineModule.PythonModule1Events1Execute(Sender: TObject; PSelf,
  Args: PPyObject; var Result: PPyObject);
begin
  var command := MineCommander.PerformWill();
  if Assigned(command) then
  begin
    var PyObj := PyDelphiWrapper1.Wrap(command.GetObject);
    Result := PyObj;
    //! PythonEngine1.Py_DECREF(PyObj);
  end
  else
  begin
    Result := PythonEngine1.Py_None;
    PythonEngine1.Py_INCREF(Result);
  end;
end;

procedure TMineModule.PythonModule1Events2Execute(Sender: TObject; PSelf,
  Args: PPyObject; var Result: PPyObject);
begin
  var arglines := TStringList.Create();
  try
    PythonEngine1.PyTupleToStrings(Args, arglines);
    if arglines.Count > 0 then
    begin
      var keyword := arglines[0];
      var instantiateScript := MineCommander.InstantiateScript(keyword);
      if instantiateScript > '' then
        Result := PythonEngine1.EvalString(instantiateScript)
      else
        Result := PythonEngine1.Py_None;
       PythonEngine1.Py_INCREF(Result);
    end;
  finally
    arglines.Free;
  end;
end;

procedure TMineModule.PythonModule1Events3Execute(Sender: TObject; PSelf,
  Args: PPyObject; var Result: PPyObject);
begin
  var arglines := TStringList.Create();
  try
    PythonEngine1.PyTupleToStrings(Args, arglines);
    if arglines.Count > 0 then
    begin
      var list := arglines[0];
      _UpdateCommandItemsListCallbackProc(list);
    end;
    Result := PythonEngine1.Py_None;
    PythonEngine1.Py_INCREF(Result);
  finally
    arglines.Free;
  end;
end;

procedure TMineModule.setCommandItemsList(CommandItemsList: TStrings);
begin
  MineCommander.LoadCommands(CommandItemsList);
end;

procedure TMineModule.setTgBotActive(Active: Boolean);
begin
  if Active <> Self.TgBot.Active then
    if Active then
      Self.TgBot.Run()
    else
      Self.TgBot.Terminate();
end;

procedure TMineModule.StartPythonMagicThread;
begin
  TThread.CreateAnonymousThread(procedure
    begin
      MineCommander.RunMagic('hello world of minecraft!');
    end
  ).Start();
end;

initialization

finalization

end.
