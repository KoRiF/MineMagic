unit UnitMain;

interface

uses
  System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.PythonGUIInputOutput, SynEdit, SynEditHighlighter,
  SynEditCodeFolding, SynHighlighterPython, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.Samples.Spin, Vcl.CheckLst, PythonEngine;

type
  TFormMain = class(TForm)
    ButtonAct: TButton;
    SynEdit1: TSynEdit;
    Memo1: TMemo;
    PythonGUIInputOutput1: TPythonGUIInputOutput;
    ButtonRunScript: TButton;
    ComboBoxBlocks: TComboBox;
    SynPythonSyn1: TSynPythonSyn;
    PageControl1: TPageControl;
    TabSheetCmdServer: TTabSheet;
    TabSheetScripting: TTabSheet;
    Panel1: TPanel;
    TabSheetTools: TTabSheet;
    SpinEditLoopCountdown: TSpinEdit;
    LabelLoopCountdown: TLabel;
    LabelLoopDelay: TLabel;
    SpinEditLoopDelay: TSpinEdit;
    CheckBoxLoop: TCheckBox;
    CheckListBoxCommands: TCheckListBox;
    EditMagicTest: TEdit;
    ButtonTestMagic: TButton;
    ButtonTgBot: TButton;
    procedure ButtonActClick(Sender: TObject);
    procedure ButtonRunScriptClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonTestMagicClick(Sender: TObject);
    procedure ButtonTgBotClick(Sender: TObject);
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

uses UnitMineModule;
{$R *.dfm}

procedure TFormMain.ButtonRunScriptClick(Sender: TObject);
begin
  MineModule.StartPythonMagicThread();
end;

procedure TFormMain.ButtonTestMagicClick(Sender: TObject);
begin
  MineModule.PassMagicCommand(EditMagicTest.Text)
end;

procedure TFormMain.ButtonTgBotClick(Sender: TObject);
var caption: string;
begin
  if MineModule.BreakTgBotActivity() then
    caption := 'Stop Telegram Bot'
  else
    caption := 'Start Telegram Bot';

  Self.ButtonTgBot.Caption := caption;
end;

procedure TFormMain.ButtonActClick(Sender: TObject);
begin
  with MineModule do
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
end;

procedure TFormMain.FormCreate(Sender: TObject);
const
  SCRIPTFILE_PY = 'minescript.py';
begin
  if FileExists(SCRIPTFILE_PY) then
    SynEdit1.Lines.LoadFromFile(SCRIPTFILE_PY);

  MineModule.UpdatePySharedVariables :=
    procedure
    begin
      with MineModule do
      begin
        PythonDelphiVarLoop.Value := CheckBoxLoop.Checked;
        PythonDelphiVarLoopCountdown.Value := SpinEditLoopCountdown.Value;
        PythonDelphiVarLoopDelay.Value := SpinEditLoopDelay.Value/1000;

        PyScript := SynEdit1.Text;
      end;

    end;

  MineModule.UpdateCommandItemsListCallbackProc :=
    procedure (cmdlist: string)
    begin
      var keywords := cmdlist.Split([' ']);
      CheckListBoxCommands.CheckAll(TCheckBoxState.cbUnchecked);
      for var keyword in keywords do
      begin
        var ix := CheckListBoxCommands.Items.IndexOf(keyword);
        if ix < 0 then
          CONTINUE;
        CheckListBoxCommands.Checked[ix] := True;
      end;
    end;

  MineModule.CommandItemsList := Self.CheckListBoxCommands.Items;

  Self.SpinEditLoopCountdown.Value := 3000;
  Self.SpinEditLoopDelay.Value := 200;
end;

end.
