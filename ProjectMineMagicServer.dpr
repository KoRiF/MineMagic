program ProjectMineMagicServer;

uses
  Vcl.Forms,
  UnitMain in 'UnitMain.pas' {FormMain},
  UnitCommander in 'UnitCommander.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
