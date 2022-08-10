unit UnitMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ncSources, PythonEngine,
  Vcl.PythonGUIInputOutput, SynEdit, WrapDelphi, SynEditHighlighter,
  SynEditCodeFolding, SynHighlighterPython, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.Samples.Spin;

type
  TFormMain = class(TForm)
    ncServerSource1: TncServerSource;
    ButtonAct: TButton;
    SynEdit1: TSynEdit;
    PythonEngine1: TPythonEngine;
    Memo1: TMemo;
    PythonGUIInputOutput1: TPythonGUIInputOutput;
    PythonDelphiVarMessage: TPythonDelphiVar;
    ButtonRunScript: TButton;
    ComboBoxBlocks: TComboBox;
    SynPythonSyn1: TSynPythonSyn;
    PageControl1: TPageControl;
    TabSheetCmdServer: TTabSheet;
    TabSheetScripting: TTabSheet;
    Panel1: TPanel;
    TabSheetTools: TTabSheet;
    PythonDelphiVarLoop: TPythonDelphiVar;
    PythonDelphiVarLoopCountdown: TPythonDelphiVar;
    PythonDelphiVarLoopDelay: TPythonDelphiVar;
    SpinEditLoopCountdown: TSpinEdit;
    LabelLoopCountdown: TLabel;
    LabelLoopDelay: TLabel;
    SpinEditLoopDelay: TSpinEdit;
    CheckBoxLoop: TCheckBox;
    PythonModule1: TPythonModule;
    procedure ButtonActClick(Sender: TObject);
    function ncServerSource1HandleCommand(Sender: TObject; aLine: TncLine;
      aCmd: Integer; const aData: TArray<System.Byte>; aRequiresResult: Boolean;
      const aSenderComponent, aReceiverComponent: string): TArray<System.Byte>;
    procedure ButtonRunScriptClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PythonModule1Events0Execute(Sender: TObject; PSelf,
      Args: PPyObject; var Result: PPyObject);
  private
    { Private declarations }
    const
      TABIX_SERVER = 0;
      TABIX_SCRIPT = 1;
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

uses UnitCommander;
{$R *.dfm}

procedure TFormMain.ButtonRunScriptClick(Sender: TObject);
begin
  MineCommander.ProcessMagic('hello world of minecraft!');
  EXIT;
  TThread.CreateAnonymousThread(procedure
    begin
    MineCommander.ProcessMagic('hello world of minecraft!');
    end
  ).Start();
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
  if FileExists(SCRIPTFILE_PY) then
    SynEdit1.Lines.LoadFromFile(SCRIPTFILE_PY);

  MineCommander.RunMagic :=
    procedure (command: String)
    begin
      PythonDelphiVarMessage.Value := command;
      PythonDelphiVarLoop.Value := CheckBoxLoop.Checked;
      PythonDelphiVarLoopCountdown.Value := SpinEditLoopCountdown.Value;
      PythonDelphiVarLoopDelay.Value := SpinEditLoopDelay.Value/1000;

      PythonEngine1.ExecString(SynEdit1.Text);
    end;

  MineCommander.ProcessMagic :=
    procedure (command: String)
    begin
      PythonDelphiVarMessage.Value := command;
      var script := MineCommander.GenerateMagicScript(command);
      PythonEngine1.ExecString(script);
    end;

  MineCommander.RunScriptProc :=
    procedure (script: String)
    begin
      PythonEngine1.ExecString(script);
    end;
  MineCommander.Configure(AsServer);
end;

function TFormMain.ncServerSource1HandleCommand(Sender: TObject; aLine: TncLine;
  aCmd: Integer; const aData: TArray<System.Byte>; aRequiresResult: Boolean;
  const aSenderComponent, aReceiverComponent: string): TArray<System.Byte>;
begin
  MineCommander.ReceiveCommand(aCmd, aData);

  //ShowMessage('Command: #' + IntToStr(aCmd) + '' + command + '');

end;

procedure TFormMain.PythonModule1Events0Execute(Sender: TObject; PSelf,
  Args: PPyObject; var Result: PPyObject);
begin
         { TODO : implement loop callback }
end;

end.
