unit UnitTelegrammer;

interface

uses
  System.SysUtils,
  fastTelega.AvailableTypes,
  fastTelega.Bot,
  fastTelega.EventBroadcaster,
  fastTelega.LongPoll;

type
  TTelegramBot = Class(TftBot)
    const
      TG_URL_API = 'https://api.telegram.org';

    class function InstantinateBot(TgToken: string = ''; TgAPI: string = TG_URL_API): TTelegramBot;
  private
    _OnAnyMessage: TProc;
    _ProcessVoiceFile: TProc<string, TProc<string>>;
    function getBotUri(): string;
  public
    property BotUri: string read getBotUri;
    property ProcessVoiceFile: TProc<string, TProc<string>> write _ProcessVoiceFile;
    procedure Run();
    procedure ReplyMessage(ChatId: Integer; text: string);
  private
    function DownloadMessageFile(fileId: string): string;
    procedure ProcessMessageVoice(TgMsg: TftMessage);


  private
    class var url_TgAPI: string;

    constructor Create(botToken: string = '');

    class function ReadBotToken(): string;
  End;

var
  filenameini: string = 'tgbot.ini';
implementation

uses IniFiles, Classes, JSON;

{ TTelegramBot }

constructor TTelegramBot.Create(botToken: string);
begin
  if botToken = '' then
    botToken := ReadBotToken();
  inherited Create(botToken, url_TgAPI);
end;

function TTelegramBot.DownloadMessageFile(fileId: string): string;
begin
  var uriFileId := Self.BotUri +  Format('/getFile?%s=%s', ['file_id', fileId]) ;
  var response := Self.HttpClient.makeRequest(uriFileId, nil, 'GET');


  var ResponseJSON := TJSONObject.ParseJSONValue(response);
  const JSONPATH_FILEPATH = 'result.file_path';
  var filepath := ResponseJSON.GetValue<string>(JSONPATH_FILEPATH);

  var tmpfilepath := Self.API.downloadFile(filepath, nil);
  filepath := ChangeFileExt(tmpfilepath, ExtractFileExt(filepath));
  RenameFile(tmpfilepath, filepath);

  RESULT := filepath;
end;

function TTelegramBot.getBotUri: string;
begin
  RESULT := TG_URL_API + '/bot' + Self.Token;
end;

class function TTelegramBot.InstantinateBot(TgToken: string; TgAPI: string): TTelegramBot;
begin
  url_TgAPI := TgAPI;
  var Bot := TTelegramBot.Create(TgToken);

  Bot.Events.OnAnyMessage(
      procedure(const FTMessage: TObject)
      begin
        var msg := TftMessage(FTMessage);

        if (Pos('/start', msg.text) > 0) or
          (Pos('/layout', msg.text) > 0) then
          Exit;
        Bot.ProcessMessageVoice(msg)
      end
      );
  RESULT := Bot;
end;

procedure TTelegramBot.ProcessMessageVoice(TgMsg: TftMessage);
var Reply: TProc<string>;
begin
  if (TgMsg.Voice = nil) or (TgMsg.Voice.Duration = 0) then
    Exit;

  var fileId := TgMsg.Voice.FileId;
  var filename := Self.DownloadMessageFile(fileId);

  Reply := (
    procedure (text: string)
    begin
      Self.ReplyMessage(TgMsg.Chat.Id, text)
    end
    );

  Self._ProcessVoiceFile(filename, Reply);

end;

class function TTelegramBot.ReadBotToken: string;
var Ini: TIniFile;
begin
  var path := IncludeTrailingPathDelimiter(GetCurrentDir());
  var iniFilename := path + filenameini;
  Ini := TIniFile.Create(iniFilename);
  try
    RESULT := Ini.ReadString('TgBot', 'Token', '');
  finally
    Ini.Free();
  end;
end;

procedure TTelegramBot.ReplyMessage(ChatId: Integer; text: string);
begin
  Self.API.sendMessage(ChatId, text);
end;

procedure TTelegramBot.Run;
begin
  TThread.CreateAnonymousThread(
    procedure()
    begin
      Self.API.deleteWebhook();
      var LongPoll := TftLongPoll.Create(Self);
      while (True) do
      begin
        LongPoll.start();
      end
    end
  ).Start();
end;

end.
