unit UnitCommander;

interface

uses UnitVoiceRecorder, Azure.API3.Speech.SpeechToText;

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
    _AzureKey: string;
    AzureS2T: TAzureSpeechToText;
    procedure InitAzureKey();
  public
    function InitRecognizer(): boolean;
  End;

var MineCommander: TMineCommander;

implementation

uses System.SysUtils, IniFiles, Azure.API3.Connection;
type
  TGetAzureTokenProc = reference to function():TAzureToken;
{ TMineCommander }

constructor TMineCommander.Create;
begin
  Recorder := TVoiceRecorder.Create();
  InitAzureKey();  { DONE : define Azure recognition prefix }
end;

destructor TMineCommander.Destroy;
begin
  Recorder.Free;
end;

procedure TMineCommander.InitAzureKey;
var ini: TIniFile;
begin
  var path := IncludeTrailingPathDelimiter(GetCurrentDir());
  var iniFilename := path + 'minecommander.ini';
  ini := TIniFile.Create(iniFilename);
  try
    _AzureKey := ini.ReadString('Azure', 'Key', _AzureKey);
    _AzureRegionPrefix := ini.ReadString('AZURE', 'Region', _AzureRegionPrefix);
  finally
    ini.Free();
  end;
end;

function TMineCommander.InitRecognizer: boolean;
begin
  if _AzureKey <> '' then
  begin
    AzureS2T := TAzureSpeechToText.Create(nil, _AzureRegionPrefix);
    var AzToken := TAzureToken.Create(nil, _AzureRegionPrefix);
    AzToken.SubscriptionKey := _AzureKey;
    AzureS2T.AccessToken :=  AzToken;
  end
  else
    FreeAndNil(AzureS2T);

  RESULT := AzureS2T <> nil;
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
begin
  var  recognized := AzureS2T.SpeechToText(filename);
  RESULT := recognized[0].DisplayText;
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
