unit UnitCommander;

interface

uses UnitVoiceRecorder, UnitSpeechRecognizer, UnitTelegrammer,
  System.Generics.Collections, System.SysUtils, System.Classes;
type
  TRPCMineCommands = (rpcMagic, rpcStartRecord, rpcStopRecord, rpcRecognize);

  IMineCommandline = Interface
    ['{7D6BFCB5-8B50-47F7-9D11-E3B37F52542B}']
    function GetObject: TObject;
    function getKeyword: String;
    function getCommandline: String;
    function getParametersline: String;
    property KeyWord: String read getKeyword;
    property Cmdline: String read getCommandline;
    property Paramsline: String read getParametersline;
  End;

  TCommandRec = Record
    Keyword: String;
    InstatinationScript: String;
    _ref: IMineCommandLine;
    function ParseCommand(cmdline: string): IMineCommandline;
  End;

  TMineCommandline = Class(TInterfacedObject, IMineCommandline)
  private
    _CommandRecord: TCommandRec;
    constructor Create(commandline: String);
  public // for memory leaks debugging
    destructor Destroy(); override;
  private
    _cmdline: String;
    _parampos: Integer;

  public
    function GetObject: TObject;
    function getKeyword: String;
    function getCommandline: String;
    function getParametersline: String;
    property KeyWord: String read getKeyword;
    property Cmdline: String read getCommandline;
    property Paramsline: String read getParametersline;
  End;

  TMineCommander = Class
    Recorder: TVoiceRecorder;
    Recognizer: TSpeechRecognizer;
    TgBot: TTelegramBot;
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
    function GetLocality(): Boolean;
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
    _WillList: TThreadList;
    _RunMagic: TProc<String>;
    _ProcessMagic: TProc<String>;
    _SendCommandProc: TProc<Integer, TArray<System.Byte>>;
    _MagicCommands: TDictionary<String, TCommandRec>;
    function ParseCommand(command: String; out key: String; out args: String): IMineCommandline;

  public
    property Locality: Boolean read FLocality write SetLocality;
    property SendCommandProc: TProc<Integer, TArray<System.Byte>> write _SendCommandProc;
    property ProcessMagic: TProc<String> read _ProcessMagic write _ProcessMagic;
    property RunMagic: TProc<String> read _RunMagic write _RunMagic;

    procedure LoadCommands(Commands: TStrings);
    function ListKeywords(Prefix: Char = '['; delimiter: String = ', '; Postfix: Char = ']'): String;

    procedure NoteWill(command: string);
    function PerformWill(): IMineCommandLine;
    function InstantiateScript(keyword: String): String;
  protected
    procedure EstablishLocalProcessingLoop();
  private
    var _InitScriptingProc: TProc;
  public
    type TRole =  (AsServer, AsClient);
    procedure Configure(role: TRole);
    property InitScriptingProc: TProc write _InitScriptingProc;
  private
    procedure ConfigureAsServer;
  private
    function getTgBotActive(): Boolean;
    procedure setTgBotActive(Active: Boolean);
  public
    property TgBotActive: Boolean read getTgBotActive write setTgBotActive;
  End;

var MineCommander: TMineCommander;

implementation

uses IniFiles;

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
  if Assigned(_InitScriptingProc) then
    _InitScriptingProc();
end;

constructor TMineCommander.Create;
begin
  Recorder := TVoiceRecorder.CreateInstance();

  UnitSpeechRecognizer.filenameini := 'minecommander.ini';
  Recognizer := TSpeechRecognizer.ObtainRecognizer(asrAzure);

  UnitTelegrammer.filenameini := 'minecommander.ini';
  TgBot := TTelegramBot.InstantinateBot();
  TgBot.ProcessVoiceFile := (
    procedure (voiceFileName: String; Reply: TProc<string>)
    begin
      var voice := RecognizeMineVoice(voiceFileName);
      Reply('Accepted: ' + voice);
        PassCommand('MAGIC', voice);
    end
  );
  TgBot.ProcessTextMessage :=  (
    procedure (text: String; Reply: TProc<string>)
    begin
      Reply('Accepted: ' + text);
        PassCommand('MAGIC', text);
    end
  );

  _MagicCommands := TDictionary<String, TCommandRec>.Create();
  _WillList := TThreadList.Create();
  InitKeymapping();
end;

destructor TMineCommander.Destroy;
begin
  _WillList.Free;
  _MagicCommands.Free;
  Recognizer := nil;
  Recorder := nil;
  inherited;
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

function TMineCommander.InstantiateScript(keyword: String): String;
begin
  keyword := keyword.ToUpper;
  if _MagicCommands.ContainsKey(keyword) then
    RESULT := _MagicCommands[keyword].InstatinationScript
  else
    RESULT := '';
end;

function TMineCommander.getTgBotActive: Boolean;
begin
  RESULT := Self.TgBot.Active;
end;

function TMineCommander.ListKeywords(Prefix: Char; delimiter: String; Postfix: Char): String;
const STR_QOUTA = '"';
var Builder: TStringBuilder;
begin
 Builder := TStringBuilder.Create(Prefix);
 var keywords := _MagicCommands.Keys.ToArray();
 for var keyword in keywords do
   Builder.AppendFormat('%s%s%s',[STR_QOUTA,keyword,STR_QOUTA]).Append(delimiter);

  var L := Builder.Length;
  var dl := Length(delimiter);
  if L > dl then
    Builder.Remove(L - dl, dl);

  RESULT := Builder.Append(Postfix).ToString();
end;

procedure TMineCommander.LoadCommands(Commands: TStrings);
var IniFile: TIniFile;
  cmdRec : TCommandRec;
begin
  var CommandList := TStringList.Create;
  var filenameini := 'minecommander.ini';
  var path := IncludeTrailingPathDelimiter(GetCurrentDir());
  var iniFilename := path + filenameini;
  IniFile := TIniFile.Create(iniFilename);

  try
    IniFile.ReadSection('COMMANDS', Commands);

    IniFile.ReadSectionValues('COMMANDS', CommandList);
    for var command in  Commands do
    begin
      cmdRec.Keyword := command;
      cmdRec.InstatinationScript := CommandList.Values[command];
      _MagicCommands.Add(command, cmdRec);
    end;

  finally

    IniFile.Free();
    CommandList.Free();
  end;

end;

procedure TMineCommander.NoteWill(command: string);
var  key: String;
  args: String;

  cmdRec: TCommandRec;
begin
  command := Trim(command);
  if command.StartsWith(MAGIC_KEY, True) then
  begin
    command := Trim(UpperCase(command.Substring(Length(MAGIC_KEY))));
    var CmdObj := ParseCommand(command, key, args);
    if CmdObj <> nil then
    begin
      var Wills := _WillList.LockList();
      try
        Wills.Add(CmdObj);
      finally
        _WillList.UnlockList;
      end;
    end;
  end;




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

function TMineCommander.ParseCommand(command: String; out key: String; out args: String): IMineCommandline;
begin
  var argsbuilder := TStringBuilder.Create('');
  var ss := command.Split([' ', '.']);
  for var s in ss do
  begin
    if _MagicCommands.ContainsKey(s) then
    begin
      key := s;
      var CmdRec := _MagicCommands[key];
      RESULT := CmdRec.ParseCommand(command);
      cmdRec._ref := RESULT;
      _MagicCommands[key] := cmdRec;
      CONTINUE;
    end;
    argsbuilder := argsbuilder.AppendFormat(' %s', [s]);
  end;
  args := argsbuilder.ToString();
end;

procedure TMineCommander.PassCommand(Cmd: Integer; ArgData: String = '');
begin
  var CommandBytes := StringToByteArray(ArgData);
  Self._SendCommandProc(Cmd, CommandBytes);
end;

function TMineCommander.PerformWill: IMineCommandLine;
begin
  var Wills := _WillList.LockList();
  try
    if Wills.Count > 0 then
    begin
      RESULT := IMineCommandLine(Wills[0]);
      Wills.Delete(0);
    end
    else
      RESULT := nil;
  finally
    _WillList.UnlockList;
  end;
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


procedure TMineCommander.setTgBotActive(Active: Boolean);
begin
  if Active <> Self.TgBot.Active then
    if Active then
      Self.TgBot.Run()
    else
      Self.TgBot.Terminate();
end;



{ TMineCommandline }


constructor TMineCommandline.Create(commandline: String);
begin
  Self._cmdline := commandline;
end;

destructor TMineCommandline.Destroy;
begin
  //
  inherited;
end;


function TMineCommandline.getCommandline: String;
begin
  RESULT := Self._cmdline;
end;

function TMineCommandline.getKeyword: String;
begin
  RESULT := Self._CommandRecord.Keyword;
end;

function TMineCommandline.GetObject: TObject;
begin
  RESULT := Self;
end;

function TMineCommandline.getParametersline: String;
begin
  RESULT := Self._cmdline.Substring(_parampos);
end;

{ TCommandRec }

function TCommandRec.ParseCommand(cmdline: string): IMineCommandline;
begin
  var Commandline := TMineCommandline.Create(cmdline);
  if cmdline.StartsWith(Keyword, True) then
  begin
    Commandline._parampos := Length(Keyword) + 1;
    //self._ref := RESULT;
  end
  else
    Commandline._parampos := 0;
  Commandline._CommandRecord := self;
  RESULT := Commandline;
end;

initialization

  MineCommander := TMineCommander.Create();

finalization

  FreeAndNil(MineCommander);

end.
