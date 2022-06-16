unit UnitMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ncSources;

type
  TFormMain = class(TForm)
    ncServerSource1: TncServerSource;
    ButtonAct: TButton;
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
  ShowMessage('Command: ' + IntToStr(aCmd));
end;

end.
