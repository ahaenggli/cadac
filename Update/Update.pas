unit Update;

interface
     {
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, UrlMon, ActiveX, ComCtrls, shellapi;     }

  uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, XPMan,
  ShlObj, SHFolder,     ComObj,
  jpeg, IniFiles, ShellApi, UrlMon, Activex, Registry, ComCtrls;

type
  TForm2 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Label1: TLabel;
    Gauge1: TProgressBar;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private-Deklarationen }
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
  Form2: TForm2;
  usercancel: Boolean = False;

implementation

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
      Form2.Label1.Caption := 'Datei wurde gefunden...';
      if (usercancel) then
      begin
        Result := E_ABORT;
        exit;
      end;
    end;
    BINDSTATUS_CONNECTING:
    begin
      form2.Label1.Caption := 'Es wird verbunden...';
      if (usercancel) then
      begin
        Result := E_ABORT;
        exit;
      end;
    end;
    BINDSTATUS_BEGINDOWNLOADDATA:
    begin
      Form2.Gauge1.Position := 0;
      Form2.Label1.Caption := 'Der Download wurde gestartet...';
      if (UserCancel) then
      begin
        Result := E_ABORT;
        exit;
      end;
    end;
    BINDSTATUS_DOWNLOADINGDATA:
    begin
      Form2.Gauge1.Position := MulDiv(ulProgress,100,ulProgressMax);
      Form2.Label1.Caption := 'Datei wird heruntergeladen...';
      if (UserCancel) then
      begin
        Result := E_ABORT; exit;
      end;
    end;
    BINDSTATUS_ENDDOWNLOADDATA:
    begin
      Form2.Label1.Caption := 'Download wurde beendet...';
    end;
  end;
  Application.ProcessMessages;

  Result := S_OK;
end;

procedure TForm2.Button1Click(Sender: TObject);
var      Datei, Ziel:PChar;
       cDownStatus : cDownloadStatusCallback;
  status: integer;
  s:String;
begin

GetDir(0,s);
    Datei := PCHar('http:\\cadac.trachtengruppe-merenschwand.ch\Cadac\Cadac.exe');

      if(FileExists(s+'\Cadac.exe')) then begin
       DeleteFile(s+'\Cadac.exe');
       Ziel  := PChar(s+'\Cadac.exe');    // showmessage('12');
      end;

       if(FileExists(s+'\Cadac_cd.exe')) then begin
       DeleteFile(s+'\Cadac_cd.exe');
       Ziel  := PChar(s+'\Cadac_cd.exe'); // showmessage('13');
       end;


 cDownStatus := cDownloadStatusCallBack.Create;

   status := URLDownloadToFIle(nil,Datei,Ziel,0,CDownStatus);
    cDownStatus.Free;
    
   if (status <> 0) then
      Label1.Caption:='Es gab einen Fehler beim Herunterladen!'
        else begin
        ShellExecute(0, 'open', Ziel, PChar('Update'), PChar(0), SW_SHOW);
        Form2.Close;
        end;


end;
function GetSpecialFolder(hWindow: HWND; Folder: Integer): String;
var
  pMalloc: IMalloc;
  pidl: PItemIDList;
  Path: PChar;
begin
  // get IMalloc interface pointer
  if (SHGetMalloc(pMalloc) <> S_OK) then
  begin
    MessageBox(hWindow, 'Couldn''t get pointer to IMalloc interface.',
               'SHGetMalloc(pMalloc)', 16);
    Exit;
  end;

  // retrieve path
  SHGetSpecialFolderLocation(hWindow, Folder, pidl);
  GetMem(Path, MAX_PATH);
  SHGetPathFromIDList(pidl, Path);
  Result := Path;
  FreeMem(Path);

  // free memory allocated by SHGetSpecialFolderLocation
  pMalloc.Free(pidl);
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//showmessage('OK?');
end;

procedure TForm2.FormCreate(Sender: TObject);
var Datei, Ziel:PChar;
int:IBindStatusCallback;
Path,text:String;
begin

    Path:=GetSpecialFolder(Handle, CSIDL_PERSONAL)+'\Cadac\Cadac.txt';
    Datei := 'http:\\cadac.trachtengruppe-merenschwand.ch/Cadac/desc.txt';
    Ziel  := PChar(path+':desc.txt');
    URLDownloadToFIle(nil,Datei,Ziel,0,int);
    
memo1.lines.loadfromfile(string(ziel));
text:=memo1.Text;
Memo1.Text:='Cadac Update-Grund:';
memo1.lines.add('');
Memo1.Lines.Add(text);
end;

end.
