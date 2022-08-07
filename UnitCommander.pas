unit UnitCommander;

interface

uses UnitVoiceRecorder, UnitSpeechRecognizer, UnitMineScripter,
  System.Generics.Collections, System.SysUtils;
type
  TRPCMineCommands = (rpcMagic, rpcStartRecord, rpcStopRecord, rpcRecognize);

  TMineCommander = Class
    Recorder: TVoiceRecorder;
    Recognizer: TSpeechRecognizer;
    Scripter: TMineScripter;
  private
    const MAGIC_KEY = 'MAGIC';
    RPC_MAGIC = 0;
    RPC_RECORD_START = 1;
    RPC_RECORD_STOP = 2;
    RPC_RECOGNIZE = 3;

    var COMMANDKEYMAP: TDictionary<String, Integer>;
    procedure InitKeymapping();
  private
    FLocality: Boolean;
    procedure SetLocality(const Value: Boolean);
  protected
    constructor Create();
    destructor Destroy();virtual;
  public

    procedure RecordVoiceCommand(locally: Boolean = True);
    procedure ProcessVoiceCommand(locally: Boolean = True);
    procedure PassCommand(CommandKey: String; Commandline: String = ''); overload;
    procedure PassCommand(Cmd: Integer; ArgData: String = ''); overload;
    procedure ReceiveCommand(Cmd: Integer; ArgData: TArray<System.Byte>);
  private
    function RecognizeMineVoice(filename: String): String;
    function RecognizeMineCommand(sentence: String): String;
  private
    _RunScriptProc: TProc<String>;
    _ProcessMagic: TProc<String>;
    _SendCommandProc: TProc<Integer, TArray<System.Byte>>;
    function GetLocality(): Boolean;
  public
    property Locality: Boolean read FLocality write SetLocality;
    property SendCommandProc: TProc<Integer, TArray<System.Byte>> write _SendCommandProc;
    property ProcessMagic: TProc<String> read _ProcessMagic write _ProcessMagic;
    property RunScriptProc: TProc<String> write _RunScriptProc;
  protected
    procedure EstablishLocalProcessingLoop();
    procedure InitScripting();
  public
    type TRole =  (AsServer, AsClient);
    procedure Configure(role: TRole);

  private
    procedure ConfigureAsServer;

  End;

var MineCommander: TMineCommander;

implementation

function StringToByteArray(const s: string): TArray<System.Byte>;
begin
  var CommandChars := s.ToCharArray();
  var CommandBytes := TArray<System.Byte>.Create();

  SetLength(CommandBytes, Length(CommandChars));
  for var i := Low(CommandChars) to High(CommandChars) do
  begin
    CommandBytes[i] := Byte(AnsiChar(CommandChars[i]));
  end;
  RESULT := CommandBytes;
end;

function ByteArrayToString(const bb: TArray<System.Byte>): string;
begin
  var s := '';
  for var i := Low(bb) to High(bb) do
  begin
    s := s + Char(AnsiChar(bb[i]));
  end;
  RESULT := s;
end;

{ TMineCommander }

procedure TMineCommander.Configure(role: TRole);
begin
  case role of
    AsServer: ConfigureAsServer();
    AsClient: EXIT;
  end;
end;

procedure TMineCommander.ConfigureAsServer;
begin
  EstablishLocalProcessingLoop();
  InitScripting;
end;

constructor TMineCommander.Create;
begin
  Recorder := TVoiceRecorder.CreateInstance();

  UnitSpeechRecognizer.filenameini := 'minecommander.ini';
  Recognizer := TSpeechRecognizer.ObtainRecognizer();

  InitKeymapping();
end;

destructor TMineCommander.Destroy;
begin
  Recorder.Free;
end;

procedure TMineCommander.EstablishLocalProcessingLoop;
begin
  Self._SendCommandProc := Self.ReceiveCommand; // simulate remote processing
end;

function TMineCommander.GetLocality: Boolean;
begin
  RESULT := Assigned(Recorder.Mic) and Assigned(Self.Recognizer);
end;

procedure TMineCommander.InitKeymapping;
begin
  COMMANDKEYMAP := TDictionary<String, Integer>.Create();
  COMMANDKEYMAP.Add(MAGIC_KEY, RPC_MAGIC);
end;

procedure TMineCommander.InitScripting;
begin
  UnitMineScripter.filenameini := 'minecommander.ini';
  Self.Scripter := TMineScripter.ObtainScripter(_RunScriptProc);

  Self.Scripter.InitScripts()
end;

procedure TMineCommander.PassCommand(CommandKey: String; Commandline: String = '');
var CmdCode: Integer;
begin

  //if CommandKey = '' then
  //  Exit;
  { DONE : implement send command key to the server }
  var CommandUp := CommandKey.ToUpper;

  if COMMANDKEYMAP.TryGetValue(CommandUp, CmdCode) then
    PassCommand(CmdCode, Commandline)
  else
    PassCommand(0, Commandline);

end;

procedure TMineCommander.PassCommand(Cmd: Integer; ArgData: String = '');
begin
  var CommandBytes := StringToByteArray(ArgData);
  Self._SendCommandProc(Cmd, CommandBytes);
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

    var commandKey := Self.RecognizeMineCommand(voiceText);
    PassCommand(commandKey, voiceText);
  end
  else
  begin
    Self.PassCommand(RPC_RECORD_STOP);
    Self.PassCommand(RPC_RECOGNIZE);
  end;
end;

procedure TMineCommander.ReceiveCommand(Cmd: Integer;
  ArgData: TArray<System.Byte>);
begin

  case Cmd of
  RPC_MAGIC:
    begin
      var command := ByteArrayToString(ArgData);
      _ProcessMagic(command);
    end;
  RPC_RECORD_START:
    Self.RecordVoiceCommand();
  RPC_RECORD_STOP:
    Self.ProcessVoiceCommand();
  //RPC_RECOGNIZE:
  end;
end;

function TMineCommander.RecognizeMineCommand(sentence: String): String;
begin
  RESULT := '';  { DONE : implement separation of key command }
  if UpperCase(sentence).StartsWith(MAGIC_KEY) then
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
    Self.PassCommand(RPC_RECORD_START);
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
