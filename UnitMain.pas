unit UnitMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ncSources, PythonEngine,
  Vcl.PythonGUIInputOutput, SynEdit, WrapDelphi;

type
  TFormMain = class(TForm)
    ncServerSource1: TncServerSource;
    ButtonAct: TButton;
    SynEdit1: TSynEdit;
    PythonEngine1: TPythonEngine;
    Memo1: TMemo;
    PythonGUIInputOutput1: TPythonGUIInputOutput;
    PythonDelphiVar1: TPythonDelphiVar;
    Button1: TButton;
    procedure ButtonActClick(Sender: TObject);
    function ncServerSource1HandleCommand(Sender: TObject; aLine: TncLine;
      aCmd: Integer; const aData: TArray<System.Byte>; aRequiresResult: Boolean;
      const aSenderComponent, aReceiverComponent: string): TArray<System.Byte>;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

uses UnitCommander;
{$R *.dfm}

procedure TFormMain.ButtonActClick(Sender: TObject);
begin
  ncServerSource1.Active := not ncServerSource1.Active;

  if ncServerSource1.Active then
    ButtonAct.Caption := 'Stop MineServer'
  else
    ButtonAct.Caption := 'Start MineServer';
end;

function TFormMain.ncServerSource1HandleCommand(Sender: TObject; aLine: TncLine;
  aCmd: Integer; const aData: TArray<System.Byte>; aRequiresResult: Boolean;
  const aSenderComponent, aReceiverComponent: string): TArray<System.Byte>;
begin
  var command := ByteArrayToString(aData);

  //ShowMessage('Command: #' + IntToStr(aCmd) + '' + command + '');
  PythonDelphiVar1.Value := command;
  PythonEngine1.ExecString(SynEdit1.Text);
end;

end.
