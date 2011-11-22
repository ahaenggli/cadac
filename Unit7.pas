unit Unit7;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,ADODB, StdCtrls, URLMon, SHellApi, ActiveX, ComCtrls, ExtCtrls, jpeg;

type
 TForm7 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Label1: TLabel;
    Gauge1: TProgressBar;
    Image1: TImage;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
    url:String;
  public
    { Public-Deklarationen }
  end;
type
  cDownloadStatusCallback = class(TObject,IUnknown,IBindStatusCallback)
  private
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    function OnStartBinding(dwReserved: DWORD; pib: IBinding): HResult; stdcall;
    function GetPriority(out nPriority): HResult; stdcall;
    function OnLowResource(reserved: DWORD): HResult; stdcall;
    function OnProgress(ulProgress, ulProgressMax, ulStatusCode: ULONG; szStatusText: LPCWSTR): HResult; stdcall;
    function OnStopBinding(hresult: HResult; szError: LPCWSTR): HResult; stdcall;
    function GetBindInfo(out grfBINDF: DWORD; var bindinfo: TBindInfo): HResult; stdcall;
    function OnDataAvailable(grfBSCF: DWORD; dwSize: DWORD; formatetc: PFormatEtc; stgmed: PStgMedium): HResult; stdcall;
    function OnObjectAvailable(const iid: TGUID; punk: IUnknown): HResult; stdcall;
  end;
var
  Form7: TForm7;
  usercancel: Boolean = False;

implementation

uses Unit6, FastStrings, Unit1, Unit3, Unit10, Unit2, Unit4, Unit8;

{$R *.dfm}
function cDownloadStatusCallback._AddRef: Integer;
begin
  Result := 0;
end;
function cDownloadStatusCallback._Release: Integer;
begin
  Result := 0;
end;
function cDownloadStatusCallback.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if(GetInterface(IID,Obj)) then
  begin
    Result := 0
  end else
  begin
    Result := E_NOINTERFACE;
  end; 
end;
function cDownloadStatusCallback.OnStartBinding(dwReserved: DWORD; pib: IBinding): HResult;
begin
  Result := S_OK;
end;
function cDownloadStatusCallback.GetPriority(out nPriority): HResult;
begin
  Result := S_OK;
end;
function cDownloadStatusCallback.OnLowResource(reserved: DWORD): HResult;
begin
  Result := S_OK;
end;
function cDownloadStatusCallback.OnStopBinding(hresult: HResult; szError: LPCWSTR): HResult; stdcall;
begin
  Result := S_OK;
end;
function cDownloadStatusCallback.GetBindInfo(out grfBINDF: DWORD; var bindinfo: TBindInfo): HResult; stdcall;
begin
  Result := S_OK;
end;
function cDownloadStatusCallback.OnDataAvailable(grfBSCF: DWORD; dwSize: DWORD; formatetc: PFormatEtc; stgmed: PStgMedium): HResult;
begin
  Result := S_OK;
end;
function cDownloadStatusCallback.OnObjectAvailable(const iid: TGUID; punk: IUnknown): HResult; stdcall;
begin
  Result := S_OK;
end;
function cDownloadStatusCallback.OnProgress(ulProgress, ulProgressMax, ulStatusCode: ULONG; szStatusText: LPCWSTR): HResult;
begin
  case ulStatusCode of
    BINDSTATUS_FINDINGRESOURCE:
    begin
      Form7.Label1.Caption := 'Datei wurde gefunden...';
      if (usercancel) then
      begin
        Result := E_ABORT;
        exit;
      end;
    end;
    BINDSTATUS_CONNECTING:
    begin
      form7.Label1.Caption := 'Es wird verbunden...';
      if (usercancel) then
      begin
        Result := E_ABORT;
        exit;
      end;
    end;
    BINDSTATUS_BEGINDOWNLOADDATA:
    begin
      Form7.Gauge1.Position := 0;
      Form7.Label1.Caption := 'Der Download wurde gestartet...';
      if (UserCancel) then
      begin
        Result := E_ABORT;
        exit;
      end;
    end;
    BINDSTATUS_DOWNLOADINGDATA:
    begin
      Form7.Gauge1.Position := MulDiv(ulProgress,100,ulProgressMax);
      Form7.Label1.Caption := 'Datei wird heruntergeladen...';
      if (UserCancel) then
      begin
        Result := E_ABORT; exit;
      end;
    end;
    BINDSTATUS_ENDDOWNLOADDATA:
    begin
      Form7.Label1.Caption := 'Download wurde beendet...';
    end;
  end;
  Application.ProcessMessages;

  Result := S_OK;
end;

procedure TForm7.Button1Click(Sender: TObject);
var      Datei, Ziel:PChar;
       cDownStatus : cDownloadStatusCallback;
  status,i2,ai,i: integer;
  s:String;
begin


form1.ado.Connection:=NIL;
  form1.ado.active:=false;
  form1.ado.EnableBCD:=false;
  form1.ado.Close;
  form1.ado.Free;
     cDownStatus := cDownloadStatusCallBack.Create;
  form1.ado:=TADOTAble.Create(self);
DeleteFile(form1.path+'Voci.mdb');
if not FileExists(form1.path+'Voci.mdb') then
UrlDownloadToFile(nil, PChar('http://cadac.trachtengruppe-merenschwand.ch/CadacV2/Voci.mdb'), PChar(form1.path+'Voci.mdb'), 0, CDownStatus)
else showmessage('error 1001');
CDownStatus.free;
with form1 do begin

Ado.ConnectionString:='Provider=Microsoft.Jet.OLEDB.4.0;Data Source='+form1.path+'Voci.mdb;Persist Security Info=False';
ado.TableName:='1';
ado.EnableBCD:=True;
ado.active:=true;
i:=0;
for i2 := 1 to 5 do begin

   ado.active:=false;
      ado.TableName:=inttostr(i2);
      ado.active:=True;
          ai:=0;
        //  showmessage('error 1001');
     repeat
  if i > high(vocis) then SetLength(vocis, i+1);
    if (vocis[i].ID = ado.Fields[0].asString) and (strtoint(vocis[i].Fehler)>0)  then begin
     ado.edit;
     ado.Fields[3].AsString :=vocis[i].Fehler;
    end;
      
      
      vocis[i].Lektion := ado.TableName;
      vocis[i].ID := ado.Fields[0].Value;
      vocis[i].Franz := ado.Fields[1].Value;
      vocis[i].Deutsch := ado.Fields[2].Value;


      if varIsNull(ado.Fields[3].value) then begin
      ado.edit; ado.Fields[3].asString:='0';  end;

      vocis[i].Fehler := ado.Fields[3].value;

      inc(i);
      inc(ai);
      ado.next;
    until ado.RecordCount=ai-1;
end;
end;



if (form1.Memo1.Lines[5]='1')then begin

GetDir(0,s);
    Datei := PChar('http://'+url);

    Ziel  := PChar(s+'\UpCadac.exe');
 cDownStatus := cDownloadStatusCallBack.Create;

   status := URLDownloadToFIle(nil,Datei,Ziel,0,CDownStatus);
    cDownStatus.Free;

   if (status <> 0) then Label1.Caption:='Es gab einen Fehler beim Herunterladen!'
        else begin    
        ShellExecute(0, 'open', Ziel, PCHAR(0), PChar(0), SW_SHOW);
        Form3.Close;
        Application.Terminate;
        end;

end;
   form1.Show;
 hide;
end;

procedure TForm7.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Form1.Close;
end;

procedure TForm7.FormCreate(Sender: TObject);
begin
  Image1.Picture:=Form1.Image1.Picture;
end;

procedure TForm7.FormShow(Sender: TObject);
var desc, ver:String;
begin
try
refresh;
refresh;
memo1.lines.loadfromfile(form1.path+'update.txt');

    desc:=Memo1.Lines[3];
    url:=Memo1.Lines[2];
    ver:=Memo1.Lines[1];

Memo1.Text:='';
Memo1.Lines.Add('Version: '+ver);
Memo1.lines.Add('Beschreibung:');
Memo1.lines.Add(desc);
except

end;
end;

end.
