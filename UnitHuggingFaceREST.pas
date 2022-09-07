unit UnitHuggingFaceREST;

interface
uses System.Classes, REST.Client;
  type
    THuggingFaceREST = Class
      //;
    private
      _RESTClient: TRESTClient;
      _RESTRequest: TRESTRequest;
      _RESTResponse: TRESTResponse;
      _Token: string;
    public
      constructor Create();
      destructor Destroy; override;
      property RESTClient: TRESTClient read _RESTClient;
      property RESTRequest: TRESTRequest read _RESTRequest write _RESTRequest;
      property RESTResponse: TRESTResponse read _RESTResponse;

      property Token: string read _Token write _Token;

    End;
implementation
uses  REST.Types, System.SysUtils;
{ THuggingFaceREST }

constructor THuggingFaceREST.Create();
begin
  _RESTClient := TRESTClient.Create(nil);
  _RESTClient.ContentType := CONTENTTYPE_APPLICATION_JSON;
  //_RESTClient.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
  //_RESTClient.AcceptCharset :=  'utf-8, *;q=0.8';
  _RESTClient.HandleRedirects := True;
  _RESTClient.RaiseExceptionOn500 := False;

  _RESTResponse := TRESTResponse.Create(nil);
  //_RESTResponse.ContentType := CONTENTTYPE_APPLICATION_JSON;

  _RESTRequest := TRESTRequest.Create(nil);
  _RESTRequest.Response := _RESTResponse;
  _RESTRequest.Client := _RESTClient;
  _RESTRequest.AutoCreateParams := True;

  _RESTRequest.Method := TRestRequestMethod.rmPOST;
  //_RESTRequest.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
  //_RESTRequest.AcceptCharset :=  'utf-8, *;q=0.8';
  _RESTRequest.Timeout := 60000;
  _RESTRequest.AssignedValues := [TCustomRESTRequest.TAssignedValue.rvConnectTimeout,TCustomRESTRequest.TAssignedValue.rvHandleRedirects];

  _RESTClient.BaseURL := 'https://api-inference.huggingface.co';
  //_RESTRequest.AddParameter('Authorization', 'Bearer '+ _Token, TRESTRequestParameterKind.pkHTTPHEADER);
end;

destructor THuggingFaceREST.Destroy;
begin
  _RESTClient.Free;
  _RESTResponse.Free;
  _RESTRequest.Free;
  inherited;
end;

end.
