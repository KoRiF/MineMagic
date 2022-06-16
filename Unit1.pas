unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, ncSources;

type
  TForm1 = class(TForm)
    GridLayout1: TGridLayout;
    ButtonVoice: TButton;
    CheckBoxUseClientRecording: TCheckBox;
    ncClientSource1: TncClientSource;
    procedure ButtonVoiceMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure ButtonVoiceMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses
 UnitCommander;



procedure TForm1.ButtonVoiceMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  var DoRecordingLocally := CheckBoxUseClientRecording.IsChecked;
  MineCommander.RecordVoiceCommand(DoRecordingLocally);
end;

procedure TForm1.ButtonVoiceMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  var DoRecordingLocally := CheckBoxUseClientRecording.IsChecked;
  MineCommander.ProcessVoiceCommand(DoRecordingLocally);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Self.CheckBoxUseClientRecording.IsChecked := MineCommander.Locality;
  MineCommander.SendCommandProc := procedure (cmd: Integer; bytes: TArray<System.Byte>)
    begin
      Self.ncClientSource1.ExecCommand(cmd, bytes);
    end;
end;

end.
