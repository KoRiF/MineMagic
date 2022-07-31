unit UnitSpeechRecognizer;

interface

uses Azure.API3.Speech.SpeechToText;

type

  TSpeechRecognizer = Class
    function RecognizeVoice(filename: string): string; virtual; abstract;
    function InitRecognizer(): Boolean; virtual; abstract;
    class function ObtainRecognizer(): TSpeechRecognizer;
  private
    class var _Recognizer: TSpeechRecognizer;
  End;

  TAzureSpeechRecognizer = Class(TSpeechRecognizer)
    function RecognizeVoice(filename: string): string; override;
    function InitRecognizer(): Boolean; override;
  private
    _AzureRegionPrefix: string;
    _AzureKey: string;
    AzureS2T: TAzureSpeechToText;
    procedure InitAzureKey();
  End;
var filenameini: string;

implementation

uses Azure.API3.Connection, IniFiles, System.SysUtils;

{ TAzureSpeechRecognizer }

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
  var  recognized := AzureS2T.SpeechToText(filename);
  RESULT := recognized[0].DisplayText;
end;

{ TSpeechRecognizer }

class function TSpeechRecognizer.ObtainRecognizer: TSpeechRecognizer;
var Recognizer: TSpeechRecognizer;
begin
  if _Recognizer <> nil then
    EXIT(Recognizer);

  Recognizer := TAzureSpeechRecognizer.Create();
  if Recognizer.InitRecognizer() then
    _Recognizer := Recognizer
  else
    FreeAndNil(Recognizer);
  RESULT := _Recognizer;
end;

initialization
  filenameini := 'recognizing.ini';
end.
