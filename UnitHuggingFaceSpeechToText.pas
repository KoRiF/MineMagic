unit UnitHuggingFaceSpeechToText;

interface
uses UnitHuggingFaceREST, System.Classes;
type
    TSpeechToTextResult = Record
      JSON: string;
      text: string;
    End;

    TSpeechToTextResults = TArray<TSpeechToTextResult>;
    THuggingFaceSpeechToText = Class(THuggingFaceREST)
      function SpeechToText(AudioStream : TStream): TSpeechToTextResults; overload;
      function SpeechToText(fileAudio: string): TSpeechToTextResults; overload;
    End;

implementation
uses REST.Types, JSON.Types, SysUtils;
{ THuggingFaceSpeechToText }

function THuggingFaceSpeechToText.SpeechToText(AudioStream : TStream): TSpeechToTextResults;
begin
  RESTRequest.AutoCreateParams := True;
  RESTRequest.Method := TRESTRequestMethod.rmPOST;
  RESTRequest.Resource := '/models/facebook/wav2vec2-base-960h';//facebook/wav2vec2-large-960h-lv60-self';//facebook/wav2vec2-base-960h';
  var h := RESTRequest.Params.AddHeader('Authorization', 'Bearer '+ Token);
  h.Options := [TRESTRequestParameterOption.poDoNotEncode];

  var Param := RESTRequest.Params.AddHeader('Content-Type', 'audio/wave');
  Param.Options := [TRESTRequestParameterOption.poDoNotEncode];


  //AssignTokenToRequest(RESTRequest);

  //if aAudioLanguageCode > '' then
  //  RESTRequest.Params.ParameterByName('Language').Value := aAudioLanguageCode;

  //RESTRequest.Params.ParameterByName('format').Value := GetEnumName(TypeInfo(TSpeechToTextFormat),Integer(aFormat));
  //RESTRequest.Params.ParameterByName('profanity').Value :=  GetEnumName(TypeInfo(TSpeechToTextProfanity),Integer(aProfanity));

  //Assert(AInputStream <> nil,'Invalid Stream');


  if AudioStream <> nil then
    if AudioStream is TStringStream then begin
      var SS := TStringStream(AudioStream);
      //var len := SS.DataString.Length;
      //var par := RESTRequest.Params.AddHeader('Content-Length', IntToStr(len));
      RESTRequest.AddBody(AudioStream, 'audio/wave');//RESTRequest.Body.JSONWriter.WriteRaw(SS.DataString);



    end
    else begin
    var SS := TStringStream.Create('');
      try
        SS.CopyFrom(AudioStream,0);
        RESTRequest.Body.JSONWriter.WriteRaw(SS.DataString);
      finally
        SS.Free;
      end;
    end;

  RESTRequest.Execute;

  var Reader := RESTResponse.JSONReader;
  var CurrProperty : string := '';

  SetLength(RESULT,1);
  RESULT[0].JSON := RESTResponse.Content;
  while Reader.Read do begin
    case Reader.TokenType of
      TJsonToken.PropertyName : begin
                                  CurrProperty := Reader.Value.ToString;
                                end;
      TJsonToken.Integer,
      TJsonToken.String     :   begin
                                  if SameText(CurrProperty,'Text') then
                                    Result[0].Text := Reader.Value.ToString
                                end;
    end;
  end;
end;

function THuggingFaceSpeechToText.SpeechToText(fileAudio: string): TSpeechToTextResults;
begin
  //RESTRequest.AddFile('', fileAudio, 'audio/wave');
  //EXIT(SpeechToText(nil));
  var MS := TStringStream.Create;
  try
    MS.LoadFromFile(fileAudio);
    Result := SpeechToText(MS);
  finally
    MS.Free
  end;
end;

end.
