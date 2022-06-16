unit UnitCommander;

interface

uses UnitVoiceRecorder, UnitSpeechRecognizer, System.SysUtils;
type
  TRPCMineCommands = (rpcMagic, rpcStartRecord, rpcStopRecord, rpcRecognize);

  TMineCommander = Class
    Recorder: TVoiceRecorder;
    Recognizer: TSpeechRecognizer;
  private
    const MAGIC_KEY = 'magic';
  private
    FLocality: Boolean;
    procedure SetLocality(const Value: Boolean);
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
    _SendCommandProc: TProc<Integer, TArray<System.Byte>>;
    function GetLocality(): Boolean;
  public
    property Locality: Boolean read FLocality write SetLocality;
    property SendCommandProc: TProc<Integer, TArray<System.Byte>> write _SendCommandProc;
  private

  End;

var MineCommander: TMineCommander;

implementation


{ TMineCommander }

constructor TMineCommander.Create;
begin
  Recorder := TVoiceRecorder.Create();
  Recognizer := TSpeechRecognizer.ObtainRecognizer();
end;

destructor TMineCommander.Destroy;
begin
  Recorder.Free;
end;

function TMineCommander.GetLocality: Boolean;
begin
  RESULT := Assigned(Recorder.Mic) and Assigned(Self.Recognizer);
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
  RESULT := Recognizer.RecognizeVoice(filename);
end;

procedure TMineCommander.RecordVoiceCommand(locally: Boolean);
begin
  if locally then
    Recorder.StartRec()
  else
    Self.PassCommand('EXEC RECORD');
end;

procedure TMineCommander.SetLocality(const Value: Boolean);
begin
  FLocality := Value;
end;

initialization

  MineCommander := TMineCommander.Create();

finalization

  FreeAndNil(MineCommander);

end.
