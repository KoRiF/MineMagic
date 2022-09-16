program ProjectMineMagicServer;

uses
  Vcl.Forms,
  UnitMain in 'UnitMain.pas' {FormMain},
  UnitCommander in 'UnitCommander.pas',
  UnitMineScripter in 'UnitMineScripter.pas',
  UnitTelegrammer in 'UnitTelegrammer.pas',
  UnitMineModule in 'UnitMineModule.pas' {MineModule: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMineModule, MineModule); //reordered creation!
  Application.CreateForm(TFormMain, FormMain);

  Application.Run;
end.
