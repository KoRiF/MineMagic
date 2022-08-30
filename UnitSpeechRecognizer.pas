unit UnitSpeechRecognizer;

interface

uses Azure.API3.Speech.SpeechToText, UnitHuggingFaceSpeechToText;

type
  TRecognizerKind = (asrHuggingFace, asrAzure);

  TSpeechRecognizer = Class
    function RecognizeVoice(filename: string): string; virtual; abstract;
    function InitRecognizer(): Boolean; virtual; abstract;
    class function ObtainRecognizer(kind: TRecognizerKind = asrAzure): TSpeechRecognizer;
  private
    class var _Recognizer: TSpeechRecognizer;
  End;

  THuggingFaceRecognizer = Class(TSpeechRecognizer)
    function RecognizeVoice(filename: string): string; override;
    function InitRecognizer(): Boolean; override;
  private
    _HuggingFaceToken: String;
    procedure InitHuggingFaceToken();
  private
    HuggingFaceS2T: THuggingFaceSpeechToText;
  End;

  TAzureSpeechRecognizer = Class(TSpeechRecognizer)
    function RecognizeVoice(filename: string): string; override;
    function InitRecognizer(): Boolean; override;
  private
    _AzureRegionPrefix: string;
    _AzureKey: string;
    AzureS2T: TAzureSpeechToText;
    procedure InitAzureKey();
    procedure CheckAudioFormat(var filename: string);
  End;
var filenameini: string;

implementation

uses Azure.API3.Connection, IniFiles, System.SysUtils
{$IFDEF MSWINDOWS}
, WinApi.ShellAPI, WinApi.Windows
{$ENDIF}
;

{ TAzureSpeechRecognizer }

procedure TAzureSpeechRecognizer.CheckAudioFormat(var filename: string);
const FORMAT_CMD_FILEARGS = '-i "%s" -ar 16000 -ac 1 -ab 256 -f wav "%s"';
var filemappingArg: string;
begin
{$IFDEF MSWINDOWS}
  var ext := ExtractFileExt(filename);
  if ext <> '.wav' then
  begin
    var filenamewav := ChangeFileExt(filename, '.wav');
    filemappingArg := Format(FORMAT_CMD_FILEARGS, [filename, filenamewav]);
    var res := ShellExecute(0, nil, 'ffmpeg.exe', PChar(filemappingArg), nil, SW_HIDE);
    Sleep(500);
    if res > $20 then
    begin
      filename := filenamewav;
    end;

  end;
{$ENDIF}
end;

procedure TAzureSpeechRecognizer.InitAzureKey;
var ini: TIniFile;
begin
  var path := IncludeTrailingPathDelimiter(GetCurrentDir());
  var iniFilename := path + filenameini;
  ini := TIniFile.Create(iniFilename);
  try
    _AzureKey := ini.ReadString('Azure', 'Key', '');
    _AzureRegionPrefix := ini.ReadString('AZURE', 'Region', '');
  finally
    ini.Free();
  end;
end;

function TAzureSpeechRecognizer.InitRecognizer: Boolean;
begin
  InitAzureKey();
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

function TAzureSpeechRecognizer.RecognizeVoice(filename: string): string;
begin
  CheckAudioFormat(filename);
  var  recognized := AzureS2T.SpeechToText(filename);
  RESULT := recognized[0].DisplayText;
end;

{ TSpeechRecognizer }

class function TSpeechRecognizer.ObtainRecognizer(kind: TRecognizerKind = asrAzure): TSpeechRecognizer;
var Recognizer: TSpeechRecognizer;
begin
  if _Recognizer <> nil then
    EXIT(Recognizer);
  case kind of     { TODO : implement auto-select recognizer type }
    asrHuggingFace: Recognizer := THuggingFaceRecognizer.Create();
    asrAzure: Recognizer := TAzureSpeechRecognizer.Create();
  end;

  if Recognizer.InitRecognizer() then
    _Recognizer := Recognizer
  else
    FreeAndNil(Recognizer);
  RESULT := _Recognizer;
end;

{ THuggingFaceRecognizer }

procedure THuggingFaceRecognizer.InitHuggingFaceToken;
var ini: TIniFile;
begin
  var path := IncludeTrailingPathDelimiter(GetCurrentDir());
  var iniFilename := path + filenameini;
  ini := TIniFile.Create(iniFilename);
  try
    _HuggingFaceToken := ini.ReadString('HuggingFace', 'Token', '');
  finally
    ini.Free();
  end;

end;

function THuggingFaceRecognizer.InitRecognizer: Boolean;
begin
  InitHuggingFaceToken();

  if _HuggingFaceToken <> '' then
  begin
    HuggingFaceS2T := THuggingFaceSpeechToText.Create;
    HuggingFaceS2T.Token := _HuggingFaceToken;
  end;
  RESULT := Self._HuggingFaceToken <> '';
end;

function THuggingFaceRecognizer.RecognizeVoice(filename: string): string;
begin
  var recognized := HuggingFaceS2T.SpeechToText(filename);
  { TODO : Check for recognition success }
  RESULT := recognized[0].text;
end;

initialization
  filenameini := 'recognizing.ini';
end.
