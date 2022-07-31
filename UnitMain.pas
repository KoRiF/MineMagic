unit UnitMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ncSources, PythonEngine,
  Vcl.PythonGUIInputOutput, SynEdit, WrapDelphi, SynEditHighlighter,
  SynEditCodeFolding, SynHighlighterPython, Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TFormMain = class(TForm)
    ncServerSource1: TncServerSource;
    ButtonAct: TButton;
    SynEdit1: TSynEdit;
    PythonEngine1: TPythonEngine;
    Memo1: TMemo;
    PythonGUIInputOutput1: TPythonGUIInputOutput;
    PythonDelphiVar1: TPythonDelphiVar;
    ButtonRunScript: TButton;
    SynPythonSyn1: TSynPythonSyn;
    PageControl1: TPageControl;
    TabSheetCmdServer: TTabSheet;
    TabSheetScripts: TTabSheet;
    Panel1: TPanel;
    procedure ButtonActClick(Sender: TObject);
    function ncServerSource1HandleCommand(Sender: TObject; aLine: TncLine;
      aCmd: Integer; const aData: TArray<System.Byte>; aRequiresResult: Boolean;
      const aSenderComponent, aReceiverComponent: string): TArray<System.Byte>;
    procedure ButtonRunScriptClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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
  TThread.CreateAnonymousThread(procedure
    begin
    PythonDelphiVar1.Value := 'hello world of minecraft!';
    PythonEngine1.ExecString(SynEdit1.Text);
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
begin
  MineCommander.ProcessMagic :=
    procedure (command: String)
    begin
      PythonDelphiVar1.Value := command;
      PythonEngine1.ExecString(SynEdit1.Text);
    end;
  MineCommander.EstablishLocalProcessingLoop;
end;

function TFormMain.ncServerSource1HandleCommand(Sender: TObject; aLine: TncLine;
  aCmd: Integer; const aData: TArray<System.Byte>; aRequiresResult: Boolean;
  const aSenderComponent, aReceiverComponent: string): TArray<System.Byte>;
begin
  MineCommander.ReceiveCommand(aCmd, aData);

  //ShowMessage('Command: #' + IntToStr(aCmd) + '' + command + '');

end;

end.
