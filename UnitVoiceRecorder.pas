unit UnitVoiceRecorder;

interface

uses
 FMX.Media;

type
  TVoiceRecorder = Class
      Mic: TAudioCaptureDevice;
    public
      constructor Create();
      destructor Destroy(); virtual;
      procedure StartRec();
      procedure StopRec();
    private
      _recordPath: String;
      _recordName: String;
      function getRecordFile(): String;

      function GenerateRecName(): String;
    public
      property RecordFile: String read getRecordFile;
      property RecordPath: String read _recordPath write _recordPath;
  End;

implementation

uses System.SysUtils, System.IOUtils;

{ TVoiceRecorder }

constructor TVoiceRecorder.Create;
begin
  _recordPath := IncludeTrailingPathDelimiter(TPath.GetHomePath); // TODO: debug on Andriod
  Mic := TCaptureDeviceManager.Current.DefaultAudioCaptureDevice;
end;

destructor TVoiceRecorder.Destroy;
begin
  Mic.Free;
end;

function TVoiceRecorder.GenerateRecName: String;
const MOMENT_FORMAT = 'yyyymmddhhnnsszzz';
var momentTag: String;
begin
  var momentnow := Now();
  DateTimeToString(momentTag, MOMENT_FORMAT, momentnow);
  RESULT := RecordPath + momentTag + '.wav';
end;

function TVoiceRecorder.getRecordFile: String;
begin
  if Mic = nil then
    EXIT('');

  RESULT := _recordName;
end;

procedure TVoiceRecorder.StartRec;
begin
  _recordName := '';
  if Assigned(Mic) then
  begin
    Mic.FileName := GenerateRecName();
    Mic.StartCapture;
  end;
end;

procedure TVoiceRecorder.StopRec;
begin
  if Assigned(Mic) then
  begin
    Mic.StopCapture;
    _recordName := Mic.FileName;
  end;
end;

end.
