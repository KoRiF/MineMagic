unit UnitMineModule;

interface

uses
  System.SysUtils, System.Classes, PythonEngine, Vcl.PythonGUIInputOutput,
  SynEditHighlighter, SynEditCodeFolding, SynHighlighterPython, WrapDelphi;

type
  TMineModule = class(TDataModule)
    PythonEngine1: TPythonEngine;
    PythonModule1: TPythonModule;
    PyDelphiWrapper1: TPyDelphiWrapper;
    PythonDelphiVarMessage: TPythonDelphiVar;
    PythonDelphiVarLoop: TPythonDelphiVar;
    PythonDelphiVarLoopCountdown: TPythonDelphiVar;
    PythonDelphiVarLoopDelay: TPythonDelphiVar;
    SynPythonSyn1: TSynPythonSyn;
    PythonGUIInputOutput1: TPythonGUIInputOutput;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }

    _UpdatePySharedVariablesProc: TProc;
    _PyScript: string;
    //_CommandItemsList: TStrings;
    procedure setCommandItemsList(CommandItemsList: TStrings);

    procedure InitPython(fileini: string);
  public
    { Public declarations }
    property UpdatePySharedVariables: TProc write _UpdatePySharedVariablesProc;
    property PyScript: string write _PyScript;
    property CommandItemsList: TStrings write setCommandItemsList;
  end;

var
  MineModule: TMineModule;

implementation
uses UnitCommander, IniFiles;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TMineModule.DataModuleCreate(Sender: TObject);
begin
  Self.InitPython('minecommander.ini');

  MineCommander.RunMagic :=
    procedure (command: String)
    begin
      if Assigned(_UpdatePySharedVariablesProc) then
        _UpdatePySharedVariablesProc();
      Self.PythonDelphiVarMessage.Value := command;

      PythonEngine1.ExecString(_PyScript);
    end;

  MineCommander.RunScriptProc :=
    procedure (script: String)
    begin
      PythonEngine1.ExecString(script);
    end;

  MineCommander.ProcessMagic :=
    procedure (command: String)
    begin
      PythonDelphiVarMessage.Value := command;
      MineCommander.NoteWill(command);
    end;

  MineCommander.Configure(AsServer);
  //MineCommander.LoadCommands(Self.CheckListBoxCommands.Items);

  PythonModule1.Initialize();
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

procedure TMineModule.setCommandItemsList(CommandItemsList: TStrings);
begin
  MineCommander.LoadCommands(CommandItemsList);
end;
initialization

finalization

end.
