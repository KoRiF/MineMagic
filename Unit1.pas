unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, ncSources, FMX.Edit;

type
  TForm1 = class(TForm)
    GridLayout1: TGridLayout;
    ButtonVoice: TButton;
    CheckBoxUseClientRecording: TCheckBox;
    ncClientSource1: TncClientSource;
    EditHostIp: TEdit;
    CheckBoxConnect: TCheckBox;
    procedure ButtonVoiceMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure ButtonVoiceMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure FormCreate(Sender: TObject);
    procedure CheckBoxConnectChange(Sender: TObject);
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

function checkIPAddressFormat(ipStr: string): boolean;
begin
    var hh := ipStr.Split(['.']);

    var digits := Length(hh);
    if digits <> 4 then
      EXIT(False);

    for var i := Low(hh) to High(hh) do
    begin
      var h: Integer;
      if not TryStrToInt(hh[i], h) then
        EXIT(False);

      if (h < 0) or (h > 255) then
        EXIT(False);
    end;
    RESULT := True;
end;

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

procedure TForm1.CheckBoxConnectChange(Sender: TObject);
begin
  if CheckBoxConnect.IsChecked then
  begin
    var mineIP := Trim(EditHostIp.Text);
    
    if checkIPAddressFormat(mineIP) then
    begin
      ncClientSource1.Host := mineIP;
    end
    else
    begin
      ncClientSource1.Host := 'LocalHost';
      EditHostIp.Text := '';
    end;


  end;

  EditHostIp.Enabled := not CheckBoxConnect.IsChecked;
  ncClientSource1.Active := CheckBoxConnect.IsChecked;
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
