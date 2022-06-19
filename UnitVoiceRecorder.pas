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
      procedure StartRec(); virtual;
      procedure StopRec();  virtual;
    private
      _recordPath: String;
      _recordName: String;
      function getRecordFile(): String;

      function GenerateRecName(): String;
    public
      property RecordFile: String read getRecordFile;
      property RecordPath: String read _recordPath write _recordPath;
    public
      class function CreateInstance(): TVoiceRecorder;
  End;



implementation

uses System.SysUtils, System.IOUtils
{$IFDEF MSWINDOWS}
, FAudioCS
, System.Types, System.Classes
{$ENDIF}
;

type
{$IFDEF MSWINDOWS}
  TWinWaveRecorder = Class(TVoiceRecorder)
    FWaveRecorder: TFRecorder;
  private
  type
  TBuffer = array [0..65535] of Byte;

  var
    Buffers: TList; // audio data stored as list of buffers
    RecordSize: Integer; // lengh of recorded audio data

    procedure ClearBuffers();



  public
    constructor Create();
    destructor Destroy(); override;
    procedure StartRec(); override;
    procedure StopRec();  override;
  private
    procedure AllocBuffer(Sender: TObject; var Buffer: Pointer; var Size: Cardinal);
    procedure ArchBuffer(Sender: TObject; Buffer: Pointer; Size: Cardinal);
    procedure SaveRecord();
  End;
{$ENDIF}
{ TVoiceRecorder }

constructor TVoiceRecorder.Create;
begin
  _recordPath := IncludeTrailingPathDelimiter(TPath.GetHomePath); // TODO: debug on Andriod
  Mic := TCaptureDeviceManager.Current.DefaultAudioCaptureDevice;
end;

class function TVoiceRecorder.CreateInstance: TVoiceRecorder;
begin
{$IFDEF MSWINDOWS}
  RESULT := TWinWaveRecorder.Create();
  EXIT;
{$ELSE}
  RESULT := TVoiceRecorder.Create();
{$ENDIF}
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

{$IFDEF MSWINDOWS}
{ TWinWaveRecorder }

procedure TWinWaveRecorder.AllocBuffer(Sender: TObject; var Buffer: Pointer; var Size: Cardinal);
var MyBuffer: ^TBuffer;
begin
  New(MyBuffer);
  Buffers.Add(MyBuffer);

  Buffer := MyBuffer;
  Size := SizeOf(TBuffer);
end;


procedure TWinWaveRecorder.ArchBuffer(Sender: TObject; Buffer: Pointer;
  Size: Cardinal);
begin
  Inc(RecordSize, Size);
end;

procedure TWinWaveRecorder.ClearBuffers;
  var
  i: Integer;
  Buffer: ^TBuffer;
begin
  for i := 0 to Buffers.Count - 1 do
  begin
    Buffer := Buffers[i];
    Dispose(Buffer);
  end;
  Buffers.Clear;
end;

constructor TWinWaveRecorder.Create;
begin
  inherited Create;

  FWaveRecorder := TFRecorder.Create(nil);
  With FWaveRecorder.DataFormat do
  begin
    BitsPerSample := 16;
    SamplesPerSecond := 16000;
    Channels := 1;
  end;

  FWaveRecorder.OnBufferNeeded := AllocBuffer;
  FWaveRecorder.OnBufferReleased := ArchBuffer;

  Buffers := TList.Create();
end;

destructor TWinWaveRecorder.Destroy;
begin
  ClearBuffers;
	Buffers.Free;

  FWaveRecorder.Free;

  inherited;
end;

procedure TWinWaveRecorder.SaveRecord;
var
  Data: TByteDynArray;
  i, Index, Count: Integer;
begin
    if RecordSize = 0 then
      EXIT;

    // copy data from buffers
    SetLength(Data, RecordSize);
    Index := 0;
    for i := 0 to Buffers.Count - 1 do
    begin
      Count := RecordSize - Index;
      if Count < 0  then
        break;
      if Count > SizeOf(TBuffer) then
        Count := SizeOf(TBuffer);

      Move(Buffers[i]^, Data[Index], Count);
      Inc(Index, SizeOf(TBuffer));
    end;

    _recordName := GenerateRecName();
    Save(Self.RecordFile, 16000, 16, 1, Data);

    ClearBuffers();
end;

procedure TWinWaveRecorder.StartRec;
begin
  RecordSize := 0;
  
  FWaveRecorder.Open;
  FWaveRecorder.Start();
end;

procedure TWinWaveRecorder.StopRec;
begin
  FWaveRecorder.Stop();

  SaveRecord();
end;
{$ENDIF}
end.
