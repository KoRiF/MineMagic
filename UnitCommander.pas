unit UnitCommander;

interface

uses UnitVoiceRecorder;

type

  TMineCommander = Class
    Recorder: TVoiceRecorder;
  private
    const MAGIC_KEY = 'magic';
  protected
    constructor Create();
    destructor Destroy();virtual;
  public

    procedure RecordVoiceCommand(locally: Boolean = True);
    procedure ProcessVoiceCommand(locally: Boolean = True);
    procedure PassCommand(CommandKey: String);
  private
    function RecognizeMineVoice(filename: String): String;
    function RecognizeMineCommand(sentence: String): String;
  private
    _AzureRegionPrefix: string;
  public
    property AzureRegionPrefix: String write _AzureRegionPrefix;
  End;

var MineCommander: TMineCommander;

implementation

uses System.SysUtils, Azure.API3.Speech.SpeechToText;

{ TMineCommander }

constructor TMineCommander.Create;
begin
  Recorder := TVoiceRecorder.Create();
  _AzureRegionPrefix := '';  { TODO : define Azure recognition prefix }
end;

destructor TMineCommander.Destroy;
begin
  Recorder.Free;
end;

procedure TMineCommander.PassCommand(CommandKey: String);
begin
  if CommandKey = '' then
    Exit;
       { TODO : implement send command key to the server }
end;

procedure TMineCommander.ProcessVoiceCommand(locally: Boolean);
begin
  if locally then
  begin
    Recorder.StopRec();
    //.. pass audio to Azure
    if Recorder.RecordFile = '' then
      Exit();
    var voiceText := Self.RecognizeMineVoice(Recorder.RecordFile);//.. receive text from Azure
    var commandLine := Self.RecognizeMineCommand(voiceText);
    PassCommand(commandLine);
  end
  else
    Self.PassCommand('EXEC PROCESSING');
end;

function TMineCommander.RecognizeMineCommand(sentence: String): String;
begin
  RESULT := '';  { DONE : implement separation of key command }
  if sentence.StartsWith(MAGIC_KEY) then
    RESULT := sentence.Substring(1 + Length(MAGIC_KEY));

end;

function TMineCommander.RecognizeMineVoice(filename: String): String;
var AzureS2T: TAzureSpeechToText;
  //rectext: TAzureSpeechToText.TSpeechToTextResults;
begin
  AzureS2T := TAzureSpeechToText.Create(nil, _AzureRegionPrefix);
  try
    //...
    var  recognized := AzureS2T.SpeechToText(filename);
    RESULT := recognized[0].DisplayText;
  finally

  end;
end;

procedure TMineCommander.RecordVoiceCommand(locally: Boolean);
begin
  if locally then
    Recorder.StartRec()
  else
    Self.PassCommand('EXEC RECORD');
end;

initialization

  MineCommander := TMineCommander.Create();

finalization

  FreeAndNil(MineCommander);

end.
