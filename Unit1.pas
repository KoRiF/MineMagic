unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TForm1 = class(TForm)
    GridLayout1: TGridLayout;
    ButtonVoice: TButton;
    CheckBoxUseClientRecording: TCheckBox;
    procedure ButtonVoiceMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure ButtonVoiceMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
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

end.
