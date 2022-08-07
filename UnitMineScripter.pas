unit UnitMineScripter;

interface
uses Classes, SysUtils;
type
  TMineScripter = Class
  public
    class function ObtainScripter(RunScriptProc: TProc<String>): TMineScripter;
    procedure LoadScripts();
    procedure InitScripts();
  private
    constructor Create(RunScriptProc: TProc<String>);
    destructor Destroy(); virtual;
    class var _Scripter: TMineScripter;
    var
    _ScriptsList: TStringList;
    _RunScriptProc: TProc<String>;
  public
    property RunScriptProc: TProc<String> write _RunScriptProc;
  End;

var filenameini: string;
implementation
uses IniFiles;
{ TMineScripter }

constructor TMineScripter.Create(RunScriptProc: TProc<String>);
begin
  Self._ScriptsList := TStringList.Create;
  Self._RunScriptProc := RunScriptProc;
end;

destructor TMineScripter.Destroy;
begin
  if Assigned(_ScriptsList) then
    for var k := _ScriptsList.Count - 1 downto 0 do
      FreeAndNil(_ScriptsList.Objects[k]);
  FreeAndNil(_ScriptsList);
end;

procedure TMineScripter.InitScripts;
begin
  for var  k:= 0 to _ScriptsList.Count - 1 do
  begin
    var o := _ScriptsList.Objects[k];
    if Assigned(o) then
    begin
      var script := TStringList(o);
      _RunScriptProc(script.Text);
    end;
  end;
end;

procedure TMineScripter.LoadScripts;
var ini: TIniFile;
  IniScriptsList: TStringList;
begin
  var path := IncludeTrailingPathDelimiter(GetCurrentDir());
  var iniFilename := path + filenameini;
  ini := TIniFile.Create(iniFilename);
  try
    IniScriptsList := TStringList.Create;
    ini.ReadSection('SCRIPTS', IniScriptsList);
    for var  k:= 0 to IniScriptsList.Count - 1 do
    begin
      var scriptkey := IniScriptsList.KeyNames[k];
      var scriptpy := ini.ReadString('SCRIPTS', scriptkey, '');
      Self._ScriptsList.Values[scriptkey] := scriptpy;

      var script := TStringList.Create();
      script.LoadFromFile(scriptpy);

      Self._ScriptsList.Objects[k] := script;
    end;
  finally
    ini.Free();
  end;

end;

class function TMineScripter.ObtainScripter(RunScriptProc: TProc<String>): TMineScripter;
begin
  if Assigned(_Scripter) then
    EXIT(_Scripter);
  _Scripter := TMineScripter.Create(RunScriptProc);
  _Scripter.LoadScripts();
  RESULT := _Scripter;
end;

end.
