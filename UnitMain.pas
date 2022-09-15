unit UnitMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ncSources, PythonEngine,
  Vcl.PythonGUIInputOutput, SynEdit, WrapDelphi, SynEditHighlighter,
  SynEditCodeFolding, SynHighlighterPython, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.Samples.Spin, Vcl.CheckLst;

type
  TFormMain = class(TForm)
    ncServerSource1: TncServerSource;
    ButtonAct: TButton;
    SynEdit1: TSynEdit;
    //PythonEngine1: TPythonEngine;
    Memo1: TMemo;
    PythonGUIInputOutput1: TPythonGUIInputOutput;
    //PythonDelphiVarMessage: TPythonDelphiVar;
    ButtonRunScript: TButton;
    ComboBoxBlocks: TComboBox;
    SynPythonSyn1: TSynPythonSyn;
    PageControl1: TPageControl;
    TabSheetCmdServer: TTabSheet;
    TabSheetScripting: TTabSheet;
    Panel1: TPanel;
    TabSheetTools: TTabSheet;
    //PythonDelphiVarLoop: TPythonDelphiVar;
    //PythonDelphiVarLoopCountdown: TPythonDelphiVar;
    //PythonDelphiVarLoopDelay: TPythonDelphiVar;
    SpinEditLoopCountdown: TSpinEdit;
    LabelLoopCountdown: TLabel;
    LabelLoopDelay: TLabel;
    SpinEditLoopDelay: TSpinEdit;
    CheckBoxLoop: TCheckBox;
    CheckListBoxCommands: TCheckListBox;
    //PythonModule1: TPythonModule;
    ///PyDelphiWrapper1: TPyDelphiWrapper;
    EditMagicTest: TEdit;
    ButtonTestMagic: TButton;
    ButtonTgBot: TButton;
    procedure ButtonActClick(Sender: TObject);
    function ncServerSource1HandleCommand(Sender: TObject; aLine: TncLine;
      aCmd: Integer; const aData: TArray<System.Byte>; aRequiresResult: Boolean;
      const aSenderComponent, aReceiverComponent: string): TArray<System.Byte>;
    procedure ButtonRunScriptClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
//    procedure PythonModule1Events0Execute(Sender: TObject; PSelf,
//      Args: PPyObject; var Result: PPyObject);
//    procedure PythonModule1Events1Execute(Sender: TObject; PSelf,
//      Args: PPyObject; var Result: PPyObject);
//    procedure PythonModule1Events2Execute(Sender: TObject; PSelf,
//      Args: PPyObject; var Result: PPyObject);
//    procedure PythonModule1Events3Execute(Sender: TObject; PSelf,
//      Args: PPyObject; var Result: PPyObject);
    procedure ButtonTestMagicClick(Sender: TObject);
    procedure ButtonTgBotClick(Sender: TObject);
  private
    { Private declarations }
    const
      TABIX_SERVER = 0;
      TABIX_SCRIPT = 1;
      //procedure InitPython(fileini: string);
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

uses UnitCommander,  UnitMineModule;  // IniFiles,
{$R *.dfm}

procedure TFormMain.ButtonRunScriptClick(Sender: TObject);
begin

  TThread.CreateAnonymousThread(procedure
    begin
      MineCommander.RunMagic('hello world of minecraft!');
    end
  ).Start();

end;

procedure TFormMain.ButtonTestMagicClick(Sender: TObject);
begin
  MineCommander.PassCommand('MAGIC', EditMagicTest.Text);
end;

procedure TFormMain.ButtonTgBotClick(Sender: TObject);
var caption: string;
begin
  MineCommander.TgBotActive := not MineCommander.TgBotActive;
  if MineCommander.TgBotActive then
    caption := 'Stop Telegram Bot'
  else
    caption := 'Start Telegram Bot';

  Self.ButtonTgBot.Caption := caption;
end;

procedure TFormMain.ButtonActClick(Sender: TObject);
begin
  ncServerSource1.Active := not ncServerSource1.Active;

  if ncServerSource1.Active then
  begin
    ButtonAct.Caption := 'Stop MineServer';
    PageControl1.ActivePageIndex := TABIX_SCRIPT;
  end
  else
    ButtonAct.Caption := 'Start MineServer';
end;

procedure TFormMain.FormCreate(Sender: TObject);
const
  SCRIPTFILE_PY = 'minescript.py';
begin
//  Self.InitPython('minecommander.ini');

  if FileExists(SCRIPTFILE_PY) then
    SynEdit1.Lines.LoadFromFile(SCRIPTFILE_PY);

  //MineCommander.RunMagic :=
  MineModule.UpdatePySharedVariables :=
    procedure //(command: String)
    begin
      with MineModule do
      begin
        //PythonDelphiVarMessage.Value := command;
        PythonDelphiVarLoop.Value := CheckBoxLoop.Checked;
        PythonDelphiVarLoopCountdown.Value := SpinEditLoopCountdown.Value;
        PythonDelphiVarLoopDelay.Value := SpinEditLoopDelay.Value/1000;

        PyScript := SynEdit1.Text;   //PythonEngine1.ExecString(SynEdit1.Text);
      end;

    end;

//  MineCommander.ProcessMagic :=
//    procedure (command: String)
//    begin
//      PythonDelphiVarMessage.Value := command;
//      MineCommander.NoteWill(command);
//    end;

//  MineCommander.RunScriptProc :=
//    procedure (script: String)
//    begin
//      PythonEngine1.ExecString(script);
//    end;
//  MineCommander.Configure(AsServer);

//  MineCommander.LoadCommands(Self.CheckListBoxCommands.Items);
  MineModule.CommandItemsList := Self.CheckListBoxCommands.Items;
//
//  PythonModule1.Initialize();
  Self.SpinEditLoopCountdown.Value := 3000;
  Self.SpinEditLoopDelay.Value := 200;
end;

//procedure TFormMain.InitPython(fileini: string);
//const PYSECTION = 'Python';
//var IniFile: TIniFile;
//  dllName, dllPath, pythonHome, regVersion: string;
//begin
//  var path := IncludeTrailingPathDelimiter(GetCurrentDir());
//  var iniFilename := path + fileini;
//  IniFile := TIniFile.Create(iniFilename);
//  try
//
//    dllName := IniFile.ReadString(PYSECTION, 'DllName', '');
//    if dllName > '' then
//      Self.PythonEngine1.DllName := dllName;
//
//    dllPath := IniFile.ReadString(PYSECTION, 'DllPath', '');
//    if dllPath > '' then
//      Self.PythonEngine1.DllPath := dllPath;
//
//    pythonHome := IniFile.ReadString(PYSECTION, 'Home', dllPath);
//    if pythonHome > '' then
//      Self.PythonEngine1.SetPythonHome(pythonHome);
//
//    regVersion := IniFile.ReadString(PYSECTION, 'RegVersion', '');
//    if regVersion > '' then
//    begin
//      Self.PythonEngine1.UseLastKnownVersion := False;
//      Self.PythonEngine1.RegVersion := regVersion;
//    end;
//
//    Self.PythonEngine1.LoadDll();
//  finally
//    IniFile.Free();
//  end;
//end;

function TFormMain.ncServerSource1HandleCommand(Sender: TObject; aLine: TncLine;
  aCmd: Integer; const aData: TArray<System.Byte>; aRequiresResult: Boolean;
  const aSenderComponent, aReceiverComponent: string): TArray<System.Byte>;
begin
  MineCommander.ReceiveCommand(aCmd, aData);

  //ShowMessage('Command: #' + IntToStr(aCmd) + '' + command + '');

end;

{ procedure TFormMain.PythonModule1Events0Execute(Sender: TObject; PSelf,
  Args: PPyObject; var Result: PPyObject);
begin

  var CmdsListStr := MineCommander.ListKeywords();
  RESULT := PythonEngine1.EvalString(CmdsListStr);

  PythonEngine1.Py_INCREF(Result);
  //Result:=PythonEngine1.Py_None;
end; }

{ procedure TFormMain.PythonModule1Events1Execute(Sender: TObject; PSelf,
  Args: PPyObject; var Result: PPyObject);
begin
{ TODO : implement loop callback }
{  var command := MineCommander.PerformWill();
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

end; }

{ procedure TFormMain.PythonModule1Events2Execute(Sender: TObject; PSelf,
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
end; }

{ procedure TFormMain.PythonModule1Events3Execute(Sender: TObject; PSelf,
  Args: PPyObject; var Result: PPyObject);
begin
  var arglines := TStringList.Create();
  try
    PythonEngine1.PyTupleToStrings(Args, arglines);
    if arglines.Count > 0 then
    begin
      var list := arglines[0];
      var keywords := list.Split([' ']);
      CheckListBoxCommands.CheckAll(TCheckBoxState.cbUnchecked);
      for var keyword in keywords do
      begin
        var ix := CheckListBoxCommands.Items.IndexOf(keyword);
        if ix < 0 then
          CONTINUE;
        CheckListBoxCommands.Checked[ix] := True;
      end;
    end;
    Result := PythonEngine1.Py_None;
    PythonEngine1.Py_INCREF(Result);
  finally
    arglines.Free;
  end;
end; }

end.
