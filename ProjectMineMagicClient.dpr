program ProjectMineMagicClient;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  UnitVoiceRecorder in 'UnitVoiceRecorder.pas',
  UnitCommander in 'UnitCommander.pas',
  UnitSpeechRecognizer in 'UnitSpeechRecognizer.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
