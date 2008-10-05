unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, XPMan,
  ShlObj, SHFolder,     ComObj,     Printers, 
  jpeg, IniFiles, ShellApi, UrlMon, Activex, Registry, ComCtrls, ActnList;


type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    Splitter4: TSplitter;
    StaticText1: TStaticText;
    ComboBox1: TComboBox;
    Edit1: TComboBox;
    Edit2: TComboBox;
    Button1: TBitBtn;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    CheckBox1: TCheckBox;
    Label4: TLabel;
    Label5: TLabel;
    Button2: TButton;
    Memo1: TMemo;
    BitBtn1: TBitBtn;
    Label6: TLabel;
    Image1: TImage;
    Label7: TLabel;
    Button4: TButton;
    ActionList1: TActionList;
    Action1: TAction;
    StaticText4: TStaticText;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseNo;
    procedure CheckBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private-Deklarationen }
    showupdate:BOolean;
  public
    { Public-Deklarationen }
    FileName:String;
    FileCache,lockm:String;
    Path, installed:String;
    ischanged,lock,lock2:Boolean;
    from,tom:Integer;
    h,w,t,l:Integer;
    Name,lng:String;
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
  Form1: TForm1;
  usercancel: Boolean = False;
  VersionNr : Integer = 34;



aI:Integer=224;// = à
ae:Integer=228;// = '+char(ae)+'
cedi:Integer=231;// = ç
cedig:INteger=199;// = Ç
egra:Integer=232;// = è
egu:Integer=233;// = é
ee:Integer=234;// = ê
oe:Integer=246;// = '+char(oe)+'
ue:Integer=252;  //'+char(ue)+'
//235 = ë
{238 = î
239 = ï
242 = ò
243 = ó
244 = ô
251 = û   }




implementation



uses Unit2, Unit3, Unit4, Unit6, FastStrings,
     Unit7, Unit8,  Unit10, Unit11, Unit12;
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
      form1.Label1.Caption := 'Datei wurde gefunden...';
      if (usercancel) then
      begin
        Result := E_ABORT;
        exit;
      end;
    end;
    BINDSTATUS_CONNECTING:
    begin
      form1.Label1.Caption := 'Es wird verbunden...';
      if (usercancel) then
      begin
        Result := E_ABORT;
        exit;
      end;
    end;
    BINDSTATUS_BEGINDOWNLOADDATA:
    begin
      //Form1.Gauge1.Position := 0;
      Form1.Label1.Caption := 'Der Download wurde gestartet...';
      if (UserCancel) then
      begin
        Result := E_ABORT;
        exit;
      end;
    end;
    BINDSTATUS_DOWNLOADINGDATA:
    begin
     // Form1.Gauge1.Position := MulDiv(ulProgress,100,ulProgressMax);
      Form1.Label1.Caption := 'Datei wird heruntergeladen...';
      if (UserCancel) then
      begin
        Result := E_ABORT; exit;
      end;
    end;
    BINDSTATUS_ENDDOWNLOADDATA:
    begin
      Form1.Label1.Caption := 'Download wurde beendet...';
    end;
  end;
  Application.ProcessMessages;

  Result := S_OK;
end;

{$R *.dfm}
function xMessageDlg(const Msg: string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons; Captions: array of string) : Integer;
var
  aMsgDlg : TForm;
  CaptionIndex,
  i : integer;
  dlgButton : TButton;  // uses stdctrls
begin
  // Dlg erzeugen
  aMsgDlg := CreateMessageDialog(Msg, DlgType, buttons);
  CaptionIndex := 0;
  // alle Objekte des Dialoges testen
  for i := 0 to aMsgDlg.ComponentCount - 1 do begin
    // Schrift-Art Message ändern
    if (aMsgDlg.Components[i] is TLabel) then begin
      TLabel(aMsgDlg.Components[i]).Font.Style := [fsBold];
      TLabel(aMsgDlg.Components[i]).Font.Color := clBlack;
    end;
    // wenn es ein Button ist, dann...
    if (aMsgDlg.Components[i] is TButton) then begin
      dlgButton := TButton(aMsgDlg.Components[i]);
      if CaptionIndex > High(Captions) then Break;
      // Beschriftung entsprechend Captions-array ändern
      dlgButton.Caption := Captions[CaptionIndex];
      dlgButton.Font.Style := [fsBold];
      Inc(CaptionIndex);
    end;
  end;
  Result := aMsgDlg.ShowModal;
end;

function explode(cDelimiter,  sValue : string; iCount : integer) : TArray;
var
s : string; i,p : integer;
begin

        s := sValue; i := 0;
        while length(s) > 0 do
        begin
                inc(i);
                SetLength(result, i);
                p := pos(cDelimiter,s);

                if ( p > 0 ) and ( ( i < iCount ) OR ( iCount = 0) ) then
                begin

                        result[i - 1] := copy(s,0,p-1);

                        {updated, thanks Irfan}
                        s := copy(s,p + length(cDelimiter),length(s));
                end else
                begin result[i - 1] := s;
                        s :=  '';
                end;
        end;

end;
function GetPath: string;
const
  CSIDL_PROGRAM_FILES = $26;
var
  p: PItemIDLIst;
  Buf: array [0..MAX_PATH-1] of Char;
  ShellH: IMalloc;
begin
  if SHGetSpecialFolderLocation(Application.Handle, CSIDL_PROGRAM_FILES, p) = NOERROR   then
  try
    if SHGetPathFromIDList(p, Buf) then
      Result := Buf+'\Cadac\';
      //Result := ParamStr(0);
    finally
      if SHGetMalloc(ShellH) = NOERROR then
         ShellH.Free(P);
    end;
end;
function Zs(Von, Bis: Integer): Integer;
begin
Randomize;
  Result := Random(Succ(Bis - Von)) + Von;
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
function crypt(Text,Key:String;Crypt:Boolean):String;
var i,KeyIdx : Integer;
begin
  Result:='';
  KeyIdx:=0;
  for i:=1 to length(Text) do begin
    inc(KeyIdx);
    if KeyIdx>Length(Key) then KeyIdx:=1;
    if Crypt then Result:=Result+chr(ord(Text[i])+ord(Key[KeyIdx]))
             else Result:=Result+chr(ord(Text[i])-ord(Key[KeyIdx]))
    end;
end;
procedure desktopicon(Datei, Name, WorkingDir: String);
var Shortcut: IUnknown;
SLink: IShellLink;
PFile: IPersistFile;
Wdatei: WideString;
dir: string;
begin
shortCut := CreateComObject(CLSID_ShellLink);
SLink := ShortCut as IShellLink;
PFile := ShortCut as IPersistFile;
SLink.SetArguments('');
SLink.SetPath(Pchar(Datei));
SLink.SetWorkingDirectory(PChar(WorkingDir));



Dir := GetSpecialFolder(Form1.Handle, CSIDL_DESKTOPDIRECTORY);
WDatei := Dir + '\'+ Name + '.Lnk';
PFile.Save(PWChar(Wdatei), False);


end;

procedure TForm1.Action1Execute(Sender: TObject);
begin
form12.Top:=Top-50;
form12.Left:=Left+50;
form12.show;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
var Datei,Ziel:String;
    ver:Integer;
    ts:TStringList;
           cDownStatus : cDownloadStatusCallback;

begin
if installed = '0' then  begin showmessage('Bitte zuerst installieren!');exit;end;

  try
    Datei := 'http://cadac.trachtengruppe-merenschwand.ch/'+Name+'/update2_'+inttostr(VersionNr)+'.txt';
  //  Datei := 'http://127.0.0.1/Cadac/Cadac/update.txt';
    Ziel  := path+':update.txt';

    cDownStatus := cDownloadStatusCallBack.Create;
    URLDownloadToFIle(nil,PCHar(Datei+'?'+'var='+inttostr(zs(0,9999))),PCHAR(Ziel),0,CDownStatus);
    cDownStatus.Free;


    Memo1.Lines.LoadFromFile(Ziel);

    if (Memo1.Lines[5]='3') then begin lock2:=True; lockm:=memo1.lines[6]; end else lock2:=False;

    if (Memo1.Lines[5]='0') then begin lock:=True; lockm:=memo1.lines[6]; end else lock:=False;
    if lock then   begin  showmessage(lockm); exit; end;
    if lock2 then   begin  showmessage(lockm); end;
    if strtoint(memo1.lines[0]) > VersionNr then begin

    Memo1.Lines.SaveToFile(ziel);
    Form7.Top:=Form1.Top;
    Form7.Left:=Form1.Left;
    Form7.Show;
    Form1.Hide;

    end else showmessage('Kein Update vorhanden.');
 except
   ShowMessage('Ein Fehler ist aufgetreten! Bitte '+char(ue)+'berpr'+char(ue)+'fe, ob eine Internetverbindung besteht...');
   end;
  label1.Caption:='Von';

end;
function clearSTlist(sl:TStringlist):TSTringlist;
var i:Integer;
    sl2:TSTringList;
    tmp:String;
begin
  sl2:=TSTringlist.Create;
  tmp:='';
  for i := 0 to sl.Count - 1 do begin
    if ((sl[i]<>'')and(sl[i]<>tmp)) then begin tmp:=sl[i]; sl2.Add(sl[i]); end;
  end;
 result:=sl2;
//sl2.Free;
end;
procedure TForm1.Button1Click(Sender: TObject);
var
    str, tmp,asl: TStringlist;
    a,b,strtmp: String;
    u,z,i,m,z2,aslnr: Integer;
    f: TArray;
    ini:TIniFile;
    ex:Boolean;
begin        

if lock then   begin  showmessage(lockm); exit; end;
if lock2 then   begin  showmessage(lockm); end;
ex:=False;
statictext4.Caption:='';
statictext4.Height:=0;
DeleteFile(FileName);
DeleteFile(FileCache);

if FileExists(path+':install.ini') then begin ini:=TIniFile.create(path+':install.ini'); installed:=ini.ReadString('Installation','Installed',''); ini.Free; end
    else begin installed:='0'; end;

if installed = '0' then begin showmessage('Zuerst installieren!'); exit; end;
if ((Edit1.Text = '') OR (Edit2.Text = '')) or (strtoint(Edit2.Text) < strtoint(Edit1.Text)) then
  begin
    showmessage('Bitte w'+char(ae)+'hle die Lektionen aus!'+#10+'Bsp: von 1 bis 3'+#10+'(Kleinere zuerst)');
  exit; ex:=True;
  end;

if CheckBox1.Checked = false then  begin
str := TStringList.Create;
tmp := TStringList.Create;
tmp.SaveToFile(FileName);
tmp.SaveToFile(FileCache);
tmp.Clear;
asl:=TStringlist.Create;

for i:=strtoint(edit1.text) to strtoint(edit2.text) do begin
tmp.LoadFromFile(path+':'+inttostr(i)+'.csv');
asl.LoadFromFile(path+':fehler_'+inttostr(i)+'.csv');
asl:=clearstlist(asl);
   for m := 0 to tmp.Count - 1 do  begin

    for aslnr := 0 to asl.Count-1 do begin
       if smartpos(tmp[m], asl[aslnr]) <> -1 then begin
          f:=explode('|', asl[aslnr], 3);
          strtmp:=tmp[m]+'|'+inttostr(i)+'|'+f[2];
       end else begin strtmp:=tmp[m]+'|'+inttostr(i)+'|0'; end;


    end;
    if asl.Count-1 <= 0 then begin
     strtmp:=tmp[m]+'|'+inttostr(i)+'|0';
     //showmessage('m');
     end;

   str.add(strtmp);
   asl.Clear;
   end;

end;
//showmessage(str.text);exit;

//exit;
asl.Free;
for z2 := 0 to ZS(1, 100) do         begin

for z := 0 to str.Count-1 do begin
 u := random(str.Count-1);
 a := str[z];
 b := str[u];
str[z]:=b;
str[u]:=a;
end;
        end;
         str:=clearstlist(str);
str.SaveToFile(FileName);


  str.Free;
  tmp.Free;
end;

if CheckBox1.Checked = true then  begin
str := TStringList.Create;
tmp := TStringList.Create;
tmp.SaveToFile(FileName);
tmp.SaveToFile(FileCache);
tmp.Clear;

for i:=strtoint(edit1.text) to strtoint(edit2.text) do begin
tmp.LoadFromFile(path+':fehler_'+inttostr(i)+'.csv');

 //showmessage(tmp.text);

   for m := 0 to tmp.Count - 1 do  begin
         if tmp[m]<>'' then                 begin
          f:=explode('|', tmp[m], 0);
          strtmp:=f[0]+'|'+f[1]+'|'+inttostr(i)+'|'+f[2];

          end;
     str.add(strtmp);
    end;
   
   end;
 str:=clearstlist(str);
//showmessage(str.text);
str.SaveToFile(FileName);
//exit;
for z2 := 0 to ZS(1, 100) do         begin

for z := 0 to str.Count-1 do begin
 u := random(str.Count-1);
 a := str[z];
 b := str[u];
str[z]:=b;
str[u]:=a;
end;
        end;

str.SaveToFile(FileName);


  str.Free;
  tmp.Free;
end;

str:=TStringlist.Create;
str.LoadFromFile(FileName);
str:=clearstlist(str);
if (str.Text = '')or(str.count=0)or(StringReplace(str.Text, #13, '', [rfReplaceAll]) = '') then begin
  showmessage('Keine W'+char(oe)+'rter in der/den ausgew'+char(ae)+'hlten Lektion/en!');
  exit;
  exit;  ex:=True;
  exit;end;
 // showmessage(str.text);
  str.Free;

  if ex then exit;
  

if ComboBox1.Text = 'Deutsch ------> '+lng then begin
  IsChanged := False;
  Form2.Top:=Top;
  Form2.Left:=Left;
  Form2.Caption:=Name+' [Schriftlich: Deutsch - '+lng+']';
  if checkbox1.checked then Form2.Caption :=Form2.Caption+' [Alte Fehler]';
  Form2.Show;
  Form1.Hide;
end;
if ComboBox1.Text = lng+' ------> Deutsch' then begin
  IsChanged := True;
  Form2.Top:=Top;
  Form2.Left:=Left;
  Form2.Caption:=Name+' [Schriftlich: '+lng+' - Deutsch]';
  if checkbox1.checked then Form2.Caption :=Form2.Caption+' [Alte Fehler]';
  Form2.Show;
  Form1.Hide;
end;
if ComboBox1.Text = 'Deutsch ----> '+lng then begin
  IsChanged := False;
  Form8.Top:=Top;
  Form8.Left:=Left;
  Form8.Caption:=Name+' [Visuell: Deutsch - '+lng+']';
  if checkbox1.checked then Form8.Caption :=Form8.Caption+' [Alte Fehler]';
  Form8.Show;
  Form1.Hide;
end;
if ComboBox1.Text = lng+' ----> Deutsch' then begin
  IsChanged := true;
  Form8.Top:=Top;
  Form8.Left:=Left;
  Form8.Caption:=Name+' [Visuell: '+lng+' - Deutsch]';
  if checkbox1.checked then Form8.Caption :=Form8.Caption+' [Alte Fehler]';
  Form8.Show;
  Form1.Hide;
end;
if ComboBox1.Text = 'W'+char(oe)+'rterliste zeigen' then begin
   IsChanged := False;
   from:=strtoint(edit1.Text);
   tom:=strtoint(edit2.Text);
  Form10.Top:=Top;
  Form10.Left:=Left;
  Form10.Caption:=Name+' [W'+char(oe)+'rterliste]';
  if checkbox1.checked then Form10.Caption :=Form10.Caption+' [Alte Fehler]';

  Form10.Show;
  Form1.Hide;
end;
if ComboBox1.Text = 'W'+char(oe)+'rtersuche' then begin

  isChanged := False;
  Form6.Top:=Top;
  Form6.Left:=Left;
  Form6.Caption := Name+' [W'+char(oe)+'rtersuche]';
  Form6.Show;
  Hide;
end;
if ComboBox1.Text = 'Test drucken' then begin
  isChanged := False;
  Form11.Top:=Top;
  Form11.Left:=Left;
  Form11.Caption := Name+' [Test drucken]';

    if (printer.Printers.count = 0) then begin
    showmessage('Kein Drucker vorhanden!') ;
    exit;exit;
    end;
  Form11.Show;
  Hide;

end;


//Ende
end;

function DeleteDir(const AFile: string): boolean;
var
sh: SHFileOpStruct;
begin
ZeroMemory(@sh, sizeof(sh));
with sh do
   begin
   Wnd := Application.Handle;
   wFunc := fo_Delete;
   pFrom := PChar(AFile +#0);
   fFlags := fof_Silent or fof_NoConfirmation;
   end;
result := SHFileOperation(sh) = 0;
end;


procedure TForm1.CheckBox1Click(Sender: TObject);
begin
if CheckBox1.Checked = false then
begin
Label5.Caption:='Alle W'+char(oe)+'rter';
end;

if CheckBox1.Checked = true then  begin
Label5.Caption:='Alte Fehler';
end;

end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
StaticText4.Height:=50;
if ComboBox1.Text = 'Deutsch ------> '+lng then begin
statictext4.Caption:=('Schriftlich: Das Programm korrigiert dich'+#13
           +'                  und zeigt dir die L'+char(oe)+'sung St'+char(ue)+'ck f'+char(ue)+'r St'+char(ue)+'ck an.');
end
else if ComboBox1.Text = lng+' ------> Deutsch' then begin
statictext4.Caption:=('Schriftlich: Das Programm korrigiert dich'+#13
           +'                  und zeigt dir die L'+char(oe)+'sung St'+char(ue)+'ck f'+char(ue)+'r St'+char(ue)+'ck an.');
end else
if ComboBox1.Text = 'Deutsch ----> '+lng then begin
statictext4.Caption:=('Visuell: Nach dem Klick auf das Lupensymbol musst du selbst'
                          +#13+
                      '            entscheiden, ob deine Antwort richtig oder falsch ist.');
end else
if ComboBox1.Text = lng+' ----> Deutsch' then begin
statictext4.Caption:=('Visuell: Nach dem Klick auf das Lupensymbol musst du selbst'
                          +#13+
                      '            entscheiden, ob deine Antwort richtig oder falsch ist.');
end else begin statictext4.caption:=''; end;
StaticText4.Height:=50;
end;
procedure TForm1.FormCloseNo;
var ini:TiniFile;
     installed:String;
begin
if FileExists(path+':install.ini') then begin

ini:=TIniFile.create(path+':install.ini');
installed:=ini.ReadString('Installation','Installed','');
ini.Free;         end else begin installed:='0'; end;


if installed = '1' then  begin

ini:=TIniFile.create(path+':einstellungen.ini');
ini.WriteString('Config','von', Edit1.Text);
ini.WriteString('Config','bis', Edit2.Text);
ini.WriteString('Config', 'ComboBox', ComBoBox1.Text);
if CheckBox1.Checked = False then begin ini.WriteString('Config','chb', '0'); end;
if CheckBox1.Checked = True then begin ini.WriteString('Config','chb', '1');  end;
ini.Free;        end;// else begin showMessage('Installieren bitte nicht vergessen ;)'+#13+'Good-bye!'); end;

Form3.Close;
end;
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var ini:TiniFile;
     installed:String;
begin
if FileExists(path+':install.ini') then begin

ini:=TIniFile.create(path+':install.ini');
installed:=ini.ReadString('Installation','Installed','');
ini.Free;         end else begin installed:='0'; end;


if installed = '1' then  begin

ini:=TIniFile.create(path+':einstellungen.ini');
ini.WriteInteger('Config','von', Edit1.ItemIndex);
ini.WriteInteger('Config','bis', Edit2.ItemIndex);
ini.WriteInteger('Config', 'ComboBox', ComBoBox1.ItemIndex);
if CheckBox1.Checked = False then begin ini.WriteString('Config','chb', '0'); end;
if CheckBox1.Checked = True then begin ini.WriteString('Config','chb', '1');  end;
ini.Free;        end;// else begin showMessage('Installieren bitte nicht vergessen ;)'+#13+'Good-bye!'); end;
Form3.Timer3.Enabled:=True;
showMessage('Au revoir!');
end;
procedure TForm1.FormCreate(Sender: TObject);
var ini:TiniFile;
    sb,s,datei,ziel:String;
    di:Integer;
    f:TForm;
    cDownStatus:cDownloadStatusCallBack;
begin
lock:=False;
lock2:=False;
image1.Parent:=Form1;
h:=height;
w:=width;
Constraints.MaxHeight:=Constraints.MinHeight;
Constraints.MaxWidth:=Constraints.MinWidth;
lng:='Franz';
Name:='Cadac';
form3.Hide;
try

GetDir(0, s);

//IF FORM3.muri = false then
Path:=GetSpecialFolder(Handle, CSIDL_PERSONAL)+'\'+Name+'\'+Name+'.txt';
//Path:=ParamStr(0);
//Path:='C:\WINDOWS\system32\notepad.exe';
FileName:=path+':Datei.csv';
FileCache:=path+':cache.csv';

 if ParamSTr(1) = 'Update' then begin


      if(FileExists(s+'\Up'+Name+'.exe')) then begin DeleteFile(s+'\Up'+Name+'.exe');
    //  if(FileExists(s+'\Up'+Name+'.exe')) then begin DeleteFile(s+'\Up'+Name+'.exe');
    end;
   installed:='1';
   Button2.Click();
   installed:='0';
   Button2.Click();

//showMessage('Update installiert!');
 end;

//if FileExists(path+':update.txt' ) then begin deletefile(path+':update.txt'); end else begin end;

if FileExists(path+':einstellungen.ini') then begin

ini:=TIniFile.create(path+':einstellungen.ini');
Edit1.ItemIndex:=ini.ReadInteger('Config','von', 0);
Edit2.ItemIndex:=ini.ReadInteger('Config','bis', 0);
di:=ini.ReadInteger('Config', 'DesktopIcon', 0);
ComBoBox1.ItemIndex:=ini.ReadInteger('Config', 'ComboBox', 0);
sb:=ini.ReadString('Config', 'chb', '');
if sb = '0' then begin CheckBox1.Checked:=False;end;
if sb = '1' then begin CheckBox1.Checked:=True; end;
ini.Free; end else di:=0;

if di = 1 then  begin


if s <> GetSpecialFolder(Handle, CSIDL_DESKTOPDIRECTORY) then begin

desktopicon(paramstr(0), Name, s);
//ini:=TIniFile.create(path+':einstellungen.ini');ini.WriteInteger('Config','DesktopIcon', 1);ini.Free;
end; end;

if FileExists(path+':install.ini') then begin

ini:=TIniFile.create(path+':install.ini');
installed:=ini.ReadString('Installation','Installed','');
ini.Free;Button2.Caption:='Deinstallieren'; end else begin installed:='0'; Button2.Caption:='Installieren'; end;

if ComBoBox1.Text = '' then ComboBox1.Text:='Deutsch ------> '+lng;

if installed = '1' then begin

    Datei := 'http://cadac.trachtengruppe-merenschwand.ch/'+Name+'/update2_'+inttostr(VersionNr)+'.txt';
    Ziel  := path+':update.txt';
              showupdate:=False;
    cDownStatus := cDownloadStatusCallBack.Create;
    URLDownloadToFIle(nil,PCHar(Datei{+'?Manuel=Steck'}),PCHAR(Ziel),0,CDownStatus);
    cDownStatus.Free;
    Memo1.Lines.LoadFromFile(Ziel);
    if strtoint(memo1.lines[0]) > VersionNr then begin
showupdate:=True;
    end else showupdate:=False;
    if Memo1.Lines[5]='0' then begin lock :=True; lockm:=memo1.lines[6]; end else lock :=False;
    if Memo1.Lines[5]='3' then begin lock2:=True; lockm:=memo1.lines[6]; end else lock2:=False;
  label1.Caption:='Von';   end;



except

end;
//if installed = '0' then  begin Button2Click(Sender);    { showMessage('Erfolgreich installiert!'); }  end;

 if Edit1.ItemIndex = -1 then Edit1.ItemIndex:=0;
if Edit2.ItemIndex = -1 then Edit2.ItemIndex:=0;
if ComboBox1.ItemIndex = -1 then ComboBox1.ItemIndex:=1;

  end;

procedure TForm1.FormShow(Sender: TObject);
begin
Form3.Hide;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var erg:Integer;
begin
if showupdate = true then begin
 showupdate:=False;
          erg := xMessageDlg('Hinweis: Es ist ein Update vorhanden!',// + chr($0D) + 'Lege die CD ein und warte ca. 10 sec.',
                      mtConfirmation,
                      [mbYes, mbNo],        // benutzte Schaltflächen
                      ['Abbrechen', 'Installieren']); // zugehörige Texte
                      if erg = mrNo then begin BitBtn1.Click;   end;

end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var ini:TiniFile;
 s:String;
begin
 {
CSIDL_COOKIES              Cookies
CSIDL_DESKTOPDIRECTORY     Desktop
CSIDL_FAVORITES            Favoriten
CSIDL_HISTORY              Internet-Verlauf
CSIDL_INTERNET_CACHE       "Temporary Internet Files"
CSIDL_PERSONAL             Eigene Dateien
CSIDL_PROGRAMS             "Programme" im Startmen'+char(ue)+'
CSIDL_RECENT               "Dokumente" im Startmen'+char(ue)+'
CSIDL_SENDTO               "Senden an" im Kontextmen'+char(ue)+'
CSIDL_STARTMENU            Startmen'+char(ue)+'
CSIDL_STARTUP              Autostart
}
if installed = '0' then begin

if not DirectoryExists(GetSpecialFolder(Handle, CSIDL_PERSONAL)+'\Cadac') then MkDir(GetSpecialFolder(Handle, CSIDL_PERSONAL)+'\Cadac');
 GetDir(0, s);
if s <> GetSpecialFolder(Handle, CSIDL_DESKTOPDIRECTORY) then begin
 if MessageDlg('Desktopicon erstellen?', mtConfirmation, [mbyes, mbno], 0) = mrYes then
begin
GetDir(0, s);
if s <> GetSpecialFolder(Handle, CSIDL_DESKTOPDIRECTORY) then begin
desktopicon(paramstr(0), 'Cadac', s);
ini:=TIniFile.create(path+':einstellungen.ini');
ini.WriteInteger('Config','DesktopIcon', 1);
ini.Free;
end;   end else begin
ini:=TIniFile.create(path+':einstellungen.ini');
ini.WriteInteger('Config','DesktopIcon', 0);
ini.Free;
end;
end;
sleep(1000);
Memo1.Text:=''; if not FileExists(path+':1.csv') then begin Memo1.Text:='';
Memo1.Lines.Add('le crayon de couleur|der Farbstift');
Memo1.Lines.Add('C''est une gomme.|Das ist ein Gummi.');
Memo1.Lines.Add('Dans le sac '+char(ai)+' dos, il y a un livre.|Im Rucksack hat es ein Buch.');
Memo1.Lines.Add('le cahier|das Heft');
Memo1.Lines.Add('le crayon|der Bleistift');
Memo1.Lines.Add('le sac '+char(ai)+' dos|der Rucksack');
Memo1.Lines.Add('le livre|das Buch');
Memo1.Lines.Add('la gomme|der Gummi');
Memo1.Lines.Add('un '+char(egu)+'tui|ein Etui');
Memo1.Lines.Add('le stylo|der F'+char(ue)+'llfederhalter[]die F'+char(ue)+'llfeder');
Memo1.Lines.Add('la r'+char(egra)+'gle|der Massstab[]das Lineal');
Memo1.Lines.Add('le sandwich|das Sandwich');
Memo1.Lines.Add('la banane|die Banane');
Memo1.Lines.Add('Qu''est-ce que c''est?|Was ist das?');
Memo1.Lines.Add('Montre!|Zeig!');
Memo1.Lines.Add('Montrez le stylo!|Zeigt den F'+char(ue)+'llfederhalter!');
Memo1.Lines.Add('C''est un chapeau.|Das ist ein Hut.');
Memo1.Lines.Add('Prends!|Nimm!');
Memo1.Lines.Add('Prenez une gomme!|Nehmt einen Gummi!');
Memo1.Lines.Add('Voil'+char(ai)+' la r'+char(egra)+'gle|Da ist der Massstab.');
Memo1.Lines.Add('Tu parles fran'+char(cedi)+'ais?|Sprichst du Franz'+char(oe)+'sisch?');
Memo1.Lines.Add('oui|ja');
Memo1.Lines.Add('non|nein');
Memo1.Lines.Add('Ecoute!|H'+char(oe)+'re!');
Memo1.Lines.Add('Ecoutez!|H'+char(oe)+'rt zu!');
Memo1.Lines.Add('Viens!|Komm!');
Memo1.Lines.Add('Venez!|Kommt!');
Memo1.Lines.Add('Regarde!|Schau!');
Memo1.Lines.Add('Regardez!|Schaut!');
Memo1.Lines.Add('Salut!|Sal'+char(ue)+'!');
Memo1.Lines.Add('Bonjour, Madame|Guten Tag, Frau');
Memo1.Lines.Add('merci|danke');
Memo1.Lines.Add('Bonjour, Monsieur|Guten Tag, Herr');
Memo1.Lines.Add('le nombre|die Zahl');
Memo1.Lines.Add('les nombres|die Zahlen');
Memo1.Lines.Add('z'+char(egu)+'ro|null');
Memo1.Lines.Add('un|eins');
Memo1.Lines.Add('deux|zwei');
Memo1.Lines.Add('trois|drei');
Memo1.Lines.Add('quatre|vier');
Memo1.Lines.Add('cinq|f'+char(ue)+'nf');
Memo1.Lines.Add('six|sechs');
Memo1.Lines.Add('sept|sieben');
Memo1.Lines.Add('huit|acht');
Memo1.Lines.Add('neuf|neun');
Memo1.Lines.Add('dix|zehn');
Memo1.Lines.Add('onze|elf');
Memo1.Lines.Add('douze|zw'+char(oe)+'lf');
Memo1.Lines.Add('la salle de classe|das Klassenzimmer');
Memo1.Lines.Add('l'''+char(egu)+'cole|die Schule');
Memo1.Lines.Add('la table|der Tisch');
Memo1.Lines.Add('la chaise|der Stuhl');
Memo1.Lines.Add('le bureau|das Pult[]der Schreibtisch');
Memo1.Lines.Add('la biblioth'+char(egra)+'que|das B'+char(ue)+'chergestell[]die Bibliothek');
Memo1.Lines.Add('la porte|die T'+char(ue)+'re');
Memo1.Lines.Add('la fen'+char(ee)+'tre|das Fenster');
Memo1.Lines.Add('le tableau noir|die Wandtafel');
Memo1.Lines.Add('le lavabo|das Lavabo[]das Waschbecken');
Memo1.Lines.Add('la lampe|die Lampe');
Memo1.Lines.Add('la plante|die Pflanze');
Memo1.Lines.Add('la serviette|die Mappe[]die Schulmappe');
Memo1.Lines.Add('Sur la table il y a un '+char(egu)+'tui.|Auf dem Tisch hat es ein Etui.');
Memo1.Lines.Add('La serviette est sous la chaise.|Die Mappe ist unter dem Stuhl.');
Memo1.Lines.Add('l''h'+char(egu)+'licopt'+char(egra)+'re|der Helikopter');
Memo1.Lines.Add('la trompette|die Trompete');
Memo1.Lines.Add('le chat|die Katze');
Memo1.Lines.SaveToFile(path+':1.csv');Memo1.Text:='';end;
Memo1.Text:=''; if not FileExists(path+':2.csv') then begin Memo1.Text:='';
Memo1.Lines.Add('Je me pr'+char(egu)+'sente.|Ich stelle mich vor.');
Memo1.Lines.Add('Salut, '+char(cedi)+'a va?|Sal'+char(ue)+', wie gehts?');
Memo1.Lines.Add('Merci, '+char(cedi)+'a va, et toi?|Danke, es geht, und dir?');
Memo1.Lines.Add('Pas mal.|Nicht schlecht.');
Memo1.Lines.Add('Comment tu t''appelles?|Wie heisst du?');
Memo1.Lines.Add('Je m''appelle...|Ich heisse...');
Memo1.Lines.Add('J''habite rue de la gare.|Ich wohne an der Bahnhofstrasse.');
Memo1.Lines.Add('l''âge|das Alter');
Memo1.Lines.Add('Tu as quel âge?|Wie alt bist Du?');
Memo1.Lines.Add('J''ai treize ans.|Ich bin dreizehn Jahre alt.');
Memo1.Lines.Add('avoir|haben');
Memo1.Lines.Add('le fr'+char(egra)+'re|der Bruder');
Memo1.Lines.Add('la soeur|die Schwester');
Memo1.Lines.Add('les loisirs|die Freizeitbesch'+char(ae)+'ftigungen');
Memo1.Lines.Add('aimer|gern haben[]m'+char(oe)+'gen[]lieben');
Memo1.Lines.Add('Est-ce-que tu aimes la musique?|Hast du gerne Musik?');
Memo1.Lines.Add('la lecture|das Lesen[]die Lekt'+char(ue)+'re');
Memo1.Lines.Add('l''ordinateur|der Computer');
Memo1.Lines.Add('le cin'+char(egu)+'ma|das Kino');
Memo1.Lines.Add('le th'+char(egu)+'âtre|das Theater');
Memo1.Lines.Add('la t'+char(egu)+'l'+char(egu)+'|der Fernseher');
Memo1.Lines.Add('la danse|das Tanzen[]der Tanz');
Memo1.Lines.Add('le sport|der Sport');
Memo1.Lines.Add('le foot|Fussball');
Memo1.Lines.Add('le basket|Basketball');
Memo1.Lines.Add('le roller|das Inlineskating');
Memo1.Lines.Add('le hockey|Hockey');
Memo1.Lines.Add('le judo|Judo');
Memo1.Lines.Add('le volley|Volley');
Memo1.Lines.Add('le karat'+char(egu)+'|Karate');
Memo1.Lines.Add('le tennis|Tennis');
Memo1.Lines.Add('le v'+char(egu)+'lo|Velofahren[]das Velo');
Memo1.Lines.Add('C''est de quelle couleur?|Welche Farbe hat dies?');
Memo1.Lines.Add('la couleur|die Farbe');
Memo1.Lines.Add('vert[]verte|gr'+char(ue)+'n');
Memo1.Lines.Add('rouge|rot');
Memo1.Lines.Add('noir[]noire|schwarz');
Memo1.Lines.Add('bleu[]bleue|blau');
Memo1.Lines.Add('violet[]violette|violett');
Memo1.Lines.Add('jaune|gelb');
Memo1.Lines.Add('orange|orange');
Memo1.Lines.Add('blanc[]blanche|weiss');
Memo1.Lines.Add('la clarinette|die Klarinette');
Memo1.Lines.Add('la guitare|die Gitarre');
Memo1.Lines.Add('la radio|das Radio');
Memo1.Lines.Add('la cam'+char(egu)+'ra|die Kamera');
Memo1.Lines.Add('le bus|der Bus');
Memo1.Lines.Add('la panth'+char(egra)+'re|der Panther');
Memo1.Lines.Add('le camion|der Lastwagen');
Memo1.Lines.Add('le tram|das Tram');
Memo1.Lines.Add('Touche!|Ber'+char(ue)+'hre!');
Memo1.Lines.Add('Touchez!|Ber'+char(ue)+'hrt!');
Memo1.Lines.Add('treize|dreizehn');
Memo1.Lines.Add('quatorze|vierzehn');
Memo1.Lines.Add('quinze|f'+char(ue)+'nfzehn');
Memo1.Lines.Add('seize|sechzehn');
Memo1.Lines.Add('dix-sept|siebzehn');
Memo1.Lines.Add('dix-huit|achtzehn');
Memo1.Lines.Add('dix-neuf|neunzehn');
Memo1.Lines.Add('vingt|zwanzig');
Memo1.Lines.Add('le fichier|die Wortkartei');
Memo1.Lines.Add('les cartes|Die Wortschatzkarten[]die Karten');
Memo1.Lines.Add('Joue![]Jouez!|Spiel![]Spielt!');
Memo1.Lines.Add('Jette le d'+char(egu)+'![]Jetez le d'+char(egu)+'!|W'+char(ue)+'rfle![]W'+char(ue)+'rfelt!');
Memo1.Lines.SaveToFile(path+':2.csv');Memo1.Text:='';end;
Memo1.Text:=''; if not FileExists(path+':3.csv') then begin Memo1.Text:='';
Memo1.Lines.Add('la famille|die Familie');
Memo1.Lines.Add('le p'+char(egra)+'re|Der Vater');
Memo1.Lines.Add('la m'+char(egra)+'re|die Mutter');
Memo1.Lines.Add('l''oncle|der Onkel');
Memo1.Lines.Add('la tante|die Tante');
Memo1.Lines.Add('le grand-p'+char(egra)+'re|der Grossvater');
Memo1.Lines.Add('la grand-m'+char(egra)+'re|die Grossmutter');
Memo1.Lines.Add('le cousin[]la cousine|der Cousin[]die Cousine');
Memo1.Lines.Add('la fille|das M'+char(ae)+'dchen[]die Tochter');
Memo1.Lines.Add('le gar'+char(cedi)+'on|der Knabe');
Memo1.Lines.Add(''+char(ee)+'tre|sein');
Memo1.Lines.Add('Je suis la cousine de Paul.|Ich bin die Cousine von Paul.');
Memo1.Lines.Add('Comment s''appelle ton oncle?|Wie heisst dein Onkel?');
Memo1.Lines.Add('Mon oncle s''appelle Louis.|Mein Onkel heisst Louis.');
Memo1.Lines.Add('Quel est ton nom?|Wie ist dein Name?');
Memo1.Lines.Add('J''ai un cerf-volant.|Ich habe einen Drachen.');
Memo1.Lines.Add('Fais!|Mache!');
Memo1.Lines.Add('Faites une grimace!|Macht eine Grimasse!');
Memo1.Lines.Add('Lis!|Lies!');
Memo1.Lines.Add('Lisez le texte.|Lest den Text!');
Memo1.Lines.Add('Monte sur la chaise!|Steige auf den Stuhl!');
Memo1.Lines.Add('Montez sur la chaise!|Steigt auf den Stuhl!');
Memo1.Lines.Add('Compte les cahiers!|Z'+char(ae)+'hle die Hefte!');
Memo1.Lines.Add('Comptez les cahiers!|Z'+char(ae)+'hlt die Hefte!');
Memo1.Lines.Add('Change de place!|Wechsle den Platz!');
Memo1.Lines.Add('Changez de place!|Wechselt den Platz!');
Memo1.Lines.Add('Joue '+char(ai)+' la balle!|Spiele mit dem Ball!');
Memo1.Lines.Add('Jouez '+char(ai)+' la balle|Spielt mit dem Ball!');
Memo1.Lines.Add('Donne-moi la serviette!|Gib mir die Mappe!');
Memo1.Lines.Add('Donnez-moi la serviette!|Gebt mir die Mappe!');
Memo1.Lines.Add('la date|das Datum');
Memo1.Lines.Add('Aujourd''hui, c''est quelle date?|Welches Datum haben wir heute?');
Memo1.Lines.Add('Aujourd''hui, c''est quel jour?|Welcher Tag ist heute?');
Memo1.Lines.Add('C''est lundi.|Es ist Montag.');
Memo1.Lines.Add('mardi|Dienstag');
Memo1.Lines.Add('mercredi|Mittwoch');
Memo1.Lines.Add('jeudi|Donnerstag');
Memo1.Lines.Add('vendredi|Freitag');
Memo1.Lines.Add('samedi|Samstag');
Memo1.Lines.Add('dimanche|Sonntag');
Memo1.Lines.Add('le jour|der Tag');
Memo1.Lines.Add('la semaine|die Woche');
Memo1.Lines.Add('janvier|Januar');
Memo1.Lines.Add('f'+char(egu)+'vrier|Februar');
Memo1.Lines.Add('mars|M'+char(ae)+'rz');
Memo1.Lines.Add('avril|April');
Memo1.Lines.Add('mai|Mai');
Memo1.Lines.Add('juin|Juni');
Memo1.Lines.Add('juillet|Juli');
Memo1.Lines.Add('août|August');
Memo1.Lines.Add('septembre|September');
Memo1.Lines.Add('octobre|Oktober');
Memo1.Lines.Add('novembre|November');
Memo1.Lines.Add('d'+char(egu)+'cembre|Dezember');
Memo1.Lines.Add('les mois de l''ann'+char(egu)+'e|die Monate des Jahres');
Memo1.Lines.Add('Quand est-ce que tu as ton anniversaire?|Wann hast du Geburtstag?');
Memo1.Lines.Add('J''ai mon anniversaire le trente et un janvier.|Ich habe am einunddreissigsten Januar Geburtstag.');
Memo1.Lines.Add('Je t''invite '+char(ai)+' mon anniversaire.|Ich lade dich zu meinem Geburtstag ein.');
Memo1.Lines.Add('Merci pour l''invitation.|Danke f'+char(ue)+'r die Einladung.');
Memo1.Lines.Add('C''est chouette.|Es ist l'+char(ae)+'ssig.[]Es ist toll.');
Memo1.Lines.Add('A samedi prochain.|Bis n'+char(ae)+'chsten Samstag.');
Memo1.Lines.Add('Rendez-vous chez moi '+char(ai)+' huit heures.|Treffen bei mir um acht Uhr.[]Rendez-vous bei mir um acht Uhr.');
Memo1.Lines.Add('D''accord|Einverstanden');
Memo1.Lines.SaveToFile(path+':3.csv');Memo1.Text:='';end;
Memo1.Text:=''; if not FileExists(path+':4.csv') then begin Memo1.Text:='';
Memo1.Lines.Add('le corps|der K'+char(oe)+'rper');
Memo1.Lines.Add('la t'+char(ee)+'te|der Kopf');
Memo1.Lines.Add('le cou|der Hals');
Memo1.Lines.Add('le bras|der Arm');
Memo1.Lines.Add('la main|die Hand');
Memo1.Lines.Add('le doigt|der Finger');
Memo1.Lines.Add('le ventre|der Bauch');
Memo1.Lines.Add('la jambe|das Bein');
Memo1.Lines.Add('le genou|das Knie');
Memo1.Lines.Add('les genoux|die Knie[] (mz.)');
Memo1.Lines.Add('le pied|der Fuss');
Memo1.Lines.Add('Dessine![]Dessinez!|Zeichne![]Zeichnet!');
Memo1.Lines.Add('Passe le papier '+char(ai)+' ton camarade.|Übergib das Papier deinem Kameraden.');
Memo1.Lines.Add('le visage|das Gesicht');
Memo1.Lines.Add('l''oreille|das Ohr');
Memo1.Lines.Add('les cheveux|die Haare');
Memo1.Lines.Add('le front|die Stirne');
Memo1.Lines.Add('la joue|die Wange');
Memo1.Lines.Add('le nez|die Nase');
Memo1.Lines.Add('la bouche|der Mund');
Memo1.Lines.Add('les yeux|die Augen');
Memo1.Lines.Add('l''oeil|das Auge');
Memo1.Lines.Add('Montrez un objet!|Zeigt einen Gegenstand!');
Memo1.Lines.Add('C''est comment?|Wie ist es?');
Memo1.Lines.Add('C''est mou.|Es ist weich.');
Memo1.Lines.Add('grand[]grande|gross');
Memo1.Lines.Add('petit[]petite|klein');
Memo1.Lines.Add('rond[]ronde|rund');
Memo1.Lines.Add('carr'+char(egu)+'[]carr'+char(egu)+'e|quadratisch');
Memo1.Lines.Add('court[]courte|kurz');
Memo1.Lines.Add('long[]longue|lang');
Memo1.Lines.Add('dur[]dure|hart');
Memo1.Lines.Add('froid[]froide|kalt');
Memo1.Lines.Add('chaud[]chaude|warm');
Memo1.Lines.Add('un frapp'+char(egu)+' froid|ein kaltes Frapp'+char(egu)+'');
Memo1.Lines.Add('une limonade froide|eine kalte Limonade');
Memo1.Lines.Add('un chien chaud|ein Hot Dog');
Memo1.Lines.Add('le chien|der Hund');
Memo1.Lines.Add('une soupe chaude|eine warme Suppe');
Memo1.Lines.Add('le jus|der Saft');
Memo1.Lines.Add('la cr'+char(ee)+'pe|der Pfannkuchen');
Memo1.Lines.Add('le th'+char(egu)+'|der Tee');
Memo1.Lines.Add('la glace|das Eis[]die Glace');
Memo1.Lines.Add('la le'+char(cedi)+'on de gymnastique|die Turnstunde');
Memo1.Lines.Add('C''est bon pour la sant'+char(egu)+'.|Es ist gut f'+char(ue)+'r die Gesundheit.');
Memo1.Lines.Add('Plie les genoux!|Beuge die Knie!');
Memo1.Lines.Add('Sautez sur le pied gauche!|Springt auf den linken Fuss!');
Memo1.Lines.Add('L'+char(egra)+'ve la jambe gauche!|Hebe das linke Bein!');
Memo1.Lines.Add('Baissez les bras.|Senkt die Arme.');
Memo1.Lines.Add('Tourne la t'+char(ee)+'te '+char(ai)+' droite et puis '+char(ai)+' gauche.|Drehe den Kopf nach rechts und dann nach links.');
Memo1.Lines.Add('Bougez le pied droit.|Bewegt den rechten Fuss.');
Memo1.Lines.Add('Mettez la main droite sur la t'+char(ee)+'te!|Legt die rechte Hand auf den Kopf!');
Memo1.Lines.Add('L'+char(egra)+'ve-toi!|Steh auf!');
Memo1.Lines.Add('Assieds-toi!|Setze dich!');
Memo1.Lines.Add('Asseyez-vous!|Setzt euch!');
Memo1.Lines.Add('Continue!|Fahre fort!');
Memo1.Lines.Add('Continuez!|Fahrt fort!');
Memo1.Lines.Add('s''il te plaît|bitte[] (Du-Form) ');
Memo1.Lines.Add('s''il vous plaît|bitte[] (H'+char(oe)+'flichkeitsform) ');
Memo1.Lines.Add('Prends!|Nimm!');
Memo1.Lines.Add('Prenez une douche!|Nehmt eine Dusche!');
Memo1.Lines.SaveToFile(path+':4.csv');Memo1.Text:='';end;
Memo1.Text:=''; if not FileExists(path+':5.csv') then begin Memo1.Text:='';
Memo1.Lines.Add('les sports d''hiver|die Wintersportarten');
Memo1.Lines.Add('le ski|das Skilaufen[]der Ski');
Memo1.Lines.Add('la luge|das Schlitteln[]der Schlitten');
Memo1.Lines.Add('le snowboard|das Snowboarden[]das Snowboard');
Memo1.Lines.Add('le patin '+char(ai)+' glace|das Schlittschuhlaufen[]der Schlittschuh');
Memo1.Lines.Add('la patinoire|die Schlittschuhbahn');
Memo1.Lines.Add('la neige|der Schnee');
Memo1.Lines.Add('le t'+char(egu)+'l'+char(egu)+'ski|der Skilift');
Memo1.Lines.Add('la t'+char(egu)+'l'+char(egu)+'cabine|die Gondelbahn');
Memo1.Lines.Add('le t'+char(egu)+'l'+char(egu)+'si'+char(egra)+'ge|der Sessellift');
Memo1.Lines.Add('la montagne|der Berg');
Memo1.Lines.Add('la piscine couverte|das Hallenbad');
Memo1.Lines.Add('le magasin de sport|das Sportgesch'+char(ae)+'ft');
Memo1.Lines.Add('Il fait de la luge.|Er schlittelt.');
Memo1.Lines.Add('Je fais du ski.|Ich fahre Ski.');
Memo1.Lines.Add('Il ne joue pas.|Er spielt nicht.');
Memo1.Lines.Add('Je n''aime pas les sports d''hiver.|Ich habe Wintersport nicht gern.');
Memo1.Lines.Add('Où est...?|Wo ist...?');
Memo1.Lines.Add('devant|vor');
Memo1.Lines.Add('derri'+char(egra)+'re|hinter');
Memo1.Lines.Add('Je m''habille.|Ich ziehe mich an.[]Ich kleide mich.');
Memo1.Lines.Add('le v'+char(ee)+'tement|das Kleidungsst'+char(ue)+'ck');
Memo1.Lines.Add('le bonnet|die M'+char(ue)+'tze');
Memo1.Lines.Add('le gant|der Handschuh');
Memo1.Lines.Add('les lunettes de soleil|die Sonnenbrille');
Memo1.Lines.Add('l'''+char(egu)+'charpe|der Schal[]das Halstuch');
Memo1.Lines.Add('le pantalon|die Hose');
Memo1.Lines.Add('l''anorak|die Windjacke');
Memo1.Lines.Add('la chaussure|der Schuh');
Memo1.Lines.Add('la jupe|der Rock[]der Jupe');
Memo1.Lines.Add('la chemise|das Hemd');
Memo1.Lines.Add('le short|die Shorts[]die kurze Hose');
Memo1.Lines.Add('la casquette|die Schirmm'+char(ue)+'tze');
Memo1.Lines.Add('la chaussette|der Socken');
Memo1.Lines.Add('le jean|die Jeans');
Memo1.Lines.Add('la veste|die Jacke[]die Weste');
Memo1.Lines.Add('la robe|das Kleid');
Memo1.Lines.Add('le pull|der Pulli');
Memo1.Lines.Add('le tee-shirt|das T-Shirt');
Memo1.Lines.Add('la basket|der Turnschuh');
Memo1.Lines.Add('violet[]violette|violett');
Memo1.Lines.Add('blanc[]blanche|weiss');
Memo1.Lines.Add('Tu mets une casquette dans la valise.|Du legst eine Schirmm'+char(ue)+'tze in den Koffer.');
Memo1.Lines.Add('Je mets une chemise blanche.|Ich ziehe ein weisses Hemd an.');
Memo1.Lines.Add('porter|tragen');
Memo1.Lines.Add('Elle porte un pantalon blanc.|Sie tr'+char(ae)+'gt eine weisse Hose.');
Memo1.Lines.Add('le steak|das Steak');
Memo1.Lines.Add('le poulet|das Poulet');
Memo1.Lines.Add('les pommes frites|die Pommes frites');
Memo1.Lines.Add('les spaghettis|die Spaghetti');
Memo1.Lines.Add('la salade|der Salat');
Memo1.Lines.Add('la pizza|die Pizza');
Memo1.Lines.Add('la boisson|das Getr'+char(ae)+'nk');
Memo1.Lines.Add('Qu''est-ce que vous prenez?|Was nehmt ihr?[]Was nehmen Sie?');
Memo1.Lines.Add('Vous d'+char(egu)+'sirez?|Ihr w'+char(ue)+'nscht?[]Sie w'+char(ue)+'nschen?');
Memo1.Lines.Add('J''aimerais un th'+char(egu)+' au citron.|Ich m'+char(oe)+'chte einen Tee mit Zitrone.');
Memo1.Lines.Add('l''addition|die Rechnung');
Memo1.Lines.Add('Ça fait dix francs.|Das macht zehn Franken.');
Memo1.Lines.SaveToFile(path+':5.csv');Memo1.Text:='';end;
Memo1.Text:=''; if not FileExists(path+':6.csv') then begin Memo1.Text:='';
Memo1.Lines.Add('la ville|die Stadt');
Memo1.Lines.Add('le village|das Dorf');
Memo1.Lines.Add('la maison|das Haus');
Memo1.Lines.Add('le gratte-ciel|der Wolkenkratzer');
Memo1.Lines.Add('l'''+char(egu)+'glise|die Kirche');
Memo1.Lines.Add('la gare|der Bahnhof');
Memo1.Lines.Add('l''a'+char(egu)+'roport|der Flughafen');
Memo1.Lines.Add('le centre sportif|das Sportzentrum');
Memo1.Lines.Add('la boulangerie|die B'+char(ae)+'ckerei');
Memo1.Lines.Add('Le pain de cette boulangerie est bon.|Das Brot dieser B'+char(ae)+'ckerei ist gut.');
Memo1.Lines.Add('la discoth'+char(egra)+'que|die Discothek');
Memo1.Lines.Add('l''hôtel|das Hotel');
Memo1.Lines.Add('le garage|die Garage');
Memo1.Lines.Add('le cirque|der Zirkus');
Memo1.Lines.Add('l''animal|das Tier');
Memo1.Lines.Add('la pâtisserie|die Konditorei[]die Patisserie');
Memo1.Lines.Add('J''aime le gâteau au citron de cette pâtisserie.|Ich habe den Zitronenkuchen dieser Konditorei gern.');
Memo1.Lines.Add('l'''+char(egu)+'picerie|das Lebensmittelgesch'+char(ae)+'ft');
Memo1.Lines.Add('le supermarch'+char(egu)+'|der Supermarkt');
Memo1.Lines.Add('Va chercher une glace au chocolat au supermarch'+char(egu)+'!|Geh in den Supermarkt ein Schokoladeneis holen!');
Memo1.Lines.Add('la boucherie|die Metzgerei');
Memo1.Lines.Add('le march'+char(egu)+'|der Markt');
Memo1.Lines.Add('la poste|die Post');
Memo1.Lines.Add('la librairie|die Buchhandlung');
Memo1.Lines.Add('la vitrine|das Schaufenster[]die Vitrine');
Memo1.Lines.Add('la rue|die Strasse');
Memo1.Lines.Add('le chemin|der Weg');
Memo1.Lines.Add('le pont|die Br'+char(ue)+'cke');
Memo1.Lines.Add('l''arbre|der Baum');
Memo1.Lines.Add('la place|der Platz');
Memo1.Lines.Add('Je suis '+char(ai)+' la maison et je vais au march'+char(egu)+'.|Ich bin zu Hause und gehe zum Markt.');
Memo1.Lines.Add('Tu es '+char(ai)+' la boulangerie et tu vas '+char(ai)+' la poste.|Du bist in der B'+char(ae)+'ckerei und gehst zur Post.');
Memo1.Lines.Add('Nous sommes '+char(ai)+' l''hôtel et nous allons au th'+char(egu)+'âtre.|Wir sind im Hotel und gehen ins Theater.');
Memo1.Lines.Add('au milieu de la place|in der Mitte des Platzes');
Memo1.Lines.Add('en haut|oben');
Memo1.Lines.Add('en bas|unten');
Memo1.Lines.Add('entre la poste et le cin'+char(egu)+'ma|zwischen der Post und dem Kino');
Memo1.Lines.Add(''+char(ai)+' côt'+char(egu)+' de la gare|neben dem Bahnhof');
Memo1.Lines.Add('pr'+char(egra)+'s du cirque|in der N'+char(ae)+'he des Zirkus');
Memo1.Lines.Add('la moto|das Motorrad');
Memo1.Lines.Add('le train|der Zug');
Memo1.Lines.Add('la voiture[]l''auto|der Wagen[]das Auto');
Memo1.Lines.Add('le v'+char(egu)+'hicule|das Fahrzeug');
Memo1.Lines.Add('la planche '+char(ai)+' roulettes|das Rollbrett');
Memo1.Lines.Add('l''avion|das Flugzeug');
Memo1.Lines.Add('le bateau|das Schiff');
Memo1.Lines.Add('gris[]grise|grau');
Memo1.Lines.Add('brun[]brune|braun');
Memo1.Lines.Add('Pardon, je cherche la gare.|Entschuldigung, ich suche den Bahnhof.');
Memo1.Lines.Add('Où se cache ton chat?|Wo versteckt sich deine Katze?');
Memo1.Lines.Add('tourner '+char(ai)+' droite|rechts abbiegen');
Memo1.Lines.Add('tourner '+char(ai)+' gauche|links abbiegen');
Memo1.Lines.Add('habiter|wohnen');
Memo1.Lines.Add('aller tout droit|geradeaus gehen');
Memo1.Lines.Add('traverser|'+char(ue)+'berqueren');
Memo1.Lines.Add('avancer|vorw'+char(ae)+'rts gehen');
Memo1.Lines.Add('Sors!|Gehe hinaus!');
Memo1.Lines.Add('Sortez!|Geht hinaus!');
Memo1.Lines.SaveToFile(path+':6.csv');Memo1.Text:='';end;
Memo1.Text:=''; if not FileExists(path+':7.csv') then begin Memo1.Text:='';
Memo1.Lines.Add('la journ'+char(egu)+'e|der Tag[] (Zeitspanne) ');
Memo1.Lines.Add('commencer|beginnen[]anfangen');
Memo1.Lines.Add('Le r'+char(egu)+'veil sonne.|Der Wecker l'+char(ae)+'utet.');
Memo1.Lines.Add('se lever|aufstehen');
Memo1.Lines.Add('se laver|sich waschen');
Memo1.Lines.Add('se laver les dents|sich die Z'+char(ae)+'hne putzen');
Memo1.Lines.Add('s''habiller|sich anziehen[]sich kleiden');
Memo1.Lines.Add('se coiffer|sich k'+char(ae)+'mmen');
Memo1.Lines.Add('faire sa toilette|sich waschen[]sich pflegen');
Memo1.Lines.Add('se coucher|sich hinlegen[]zu Bett gehen');
Memo1.Lines.Add('le matin|der Morgen');
Memo1.Lines.Add('le midi|der Mittag');
Memo1.Lines.Add('l''apr'+char(egra)+'s-midi|der Nachmittag');
Memo1.Lines.Add('minuit|Mitternacht');
Memo1.Lines.Add('le soir|der Abend');
Memo1.Lines.Add('la nuit|die Nacht');
Memo1.Lines.Add('le petit d'+char(egu)+'jeuner|das Fr'+char(ue)+'hst'+char(ue)+'ck');
Memo1.Lines.Add('le d'+char(egu)+'jeuner|das Mittagessen');
Memo1.Lines.Add('le goûter|der Zvieri');
Memo1.Lines.Add('le dîner|das Abendessen');
Memo1.Lines.Add('Je bois une limonade.|Ich trinke eine Limonade.');
Memo1.Lines.Add('manger|essen');
Memo1.Lines.Add('d'+char(egu)+'jeuner|zu Mittag essen');
Memo1.Lines.Add('la tartine au beurre|das Butterbrot');
Memo1.Lines.Add('avoir soif|Durst haben');
Memo1.Lines.Add('avoir faim|Hunger haben');
Memo1.Lines.Add('avoir peur|Angst haben');
Memo1.Lines.Add('avoir envie|Lust haben');
Memo1.Lines.Add('avoir classe|Schule haben');
Memo1.Lines.Add('l''emploi du temps|der Stundenplan');
Memo1.Lines.Add('les mati'+char(egra)+'res scolaires|die Schulf'+char(ae)+'cher');
Memo1.Lines.Add('la le'+char(cedi)+'on de piano|die Klavierstunde');
Memo1.Lines.Add('l''histoire|die Geschichte');
Memo1.Lines.Add('les travaux manuels|das Werken');
Memo1.Lines.Add('heureusement|gl'+char(ue)+'cklicherweise');
Memo1.Lines.Add('maintenant|jetzt');
Memo1.Lines.Add('l''arriv'+char(egu)+'e|die Ankunft');
Memo1.Lines.Add('le d'+char(egu)+'part|die Abfahrt');
Memo1.Lines.Add('Quelle heure est-il?|Wie sp'+char(ae)+'t ist es?');
Memo1.Lines.Add('Il est midi.|Es ist Mittag.');
Memo1.Lines.Add('Il est une heure et demie.|Es ist halb zwei.');
Memo1.Lines.Add('Il est dix heures et quart.|Es ist Viertel nach zehn.');
Memo1.Lines.Add('Il est neuf heures moins le quart.|Es ist Viertel vor neun.');
Memo1.Lines.Add('Il est onze heures dix.|Es ist zehn nach elf.');
Memo1.Lines.Add('Il est trois heures moins vingt.|Es ist zwanzig vor drei.');
Memo1.Lines.Add('la profession|der Beruf');
Memo1.Lines.Add('le boulanger[]la boulang'+char(egra)+'re|der B'+char(ae)+'cker[]die B'+char(ae)+'ckerin');
Memo1.Lines.Add('le cuisinier[]la cuisini'+char(egra)+'re|die K'+char(oe)+'chin[]der Koch');
Memo1.Lines.Add('le musicien[]la musicienne|die Musikerin[]der Musiker');
Memo1.Lines.Add('le vendeur[]la vendeuse|der Verk'+char(ae)+'ufer[]die Verk'+char(ae)+'uferin');
Memo1.Lines.Add('l''informaticien[]l''informaticienne|der Informatiker[]die Informatikerin');
Memo1.Lines.Add('le professeur|der Professor[]die Professorin[]der Lehrer[]die Lehrerin');
Memo1.Lines.Add('le m'+char(egu)+'decin|der Arzt');
Memo1.Lines.SaveToFile(path+':7.csv');Memo1.Text:='';end;
Memo1.Text:=''; if not FileExists(path+':8.csv') then begin Memo1.Text:='';
Memo1.Lines.Add('trouver|finden');
Memo1.Lines.Add('voler|stehlen');
Memo1.Lines.Add('la route|der Weg[]die Strasse');
Memo1.Lines.Add('le voleur[]la voleuse|der Dieb[]die Diebin');
Memo1.Lines.Add('l''objet vol'+char(egu)+'|der gestohlene Gegenstand');
Memo1.Lines.Add('la lettre cod'+char(egu)+'e|der codierte Brief');
Memo1.Lines.Add('Ouvre![]Ouvrez!|Öffne![]Öffnet!');
Memo1.Lines.Add('D'+char(egu)+'code le message!|Entschl'+char(ue)+'ssle die Nachricht!');
Memo1.Lines.Add(''+char(ee)+'tre en panne|eine Panne haben');
Memo1.Lines.Add('la for'+char(ee)+'t de sapins|der Tannenwald');
Memo1.Lines.Add('le lac|der See');
Memo1.Lines.Add('au bord du lac|am Seeufer');
Memo1.Lines.Add('l'''+char(egu)+'tage|das Stockwerk[]die Etage');
Memo1.Lines.Add('le banc|die Bank');
Memo1.Lines.Add('la pomme|der Apfel');
Memo1.Lines.Add('l''oiseau|der Vogel');
Memo1.Lines.Add('la rivi'+char(egra)+'re|der Fluss');
Memo1.Lines.Add('l''ami[]l''amie|der Freund[]die Freundin');
Memo1.Lines.Add('jouer au foot|Fussball spielen');
Memo1.Lines.Add('l'''+char(egu)+'quipe|die Mannschaft[]das Team');
Memo1.Lines.Add('gagner|gewinnen');
Memo1.Lines.Add('le verre de limonade|das Glas Limonade');
Memo1.Lines.Add('Relis!|Lies nochmals!');
Memo1.Lines.Add('Relisez!|Lest nochmals!');
Memo1.Lines.Add('retourner|zur'+char(ue)+'ckgehen[]zur'+char(ue)+'ckkehren');
Memo1.Lines.Add('l''enqu'+char(ee)+'te polici'+char(egra)+'re|die polizeiliche Untersuchung');
Memo1.Lines.Add('poser une question|eine Frage stellen');
Memo1.Lines.Add('la police|die Polizei');
Memo1.Lines.Add('le policier|der Polizist');
Memo1.Lines.Add('l''enfant|das Kind');
Memo1.Lines.Add('courageux[]courageuse|mutig');
Memo1.Lines.Add('hier|gestern');
Memo1.Lines.Add('la semaine pass'+char(egu)+'e|die letzte Woche[]vergangene Woche');
Memo1.Lines.Add('ce matin|heute Morgen');
Memo1.Lines.Add('Il a entendu un bruit.|Er hat einen L'+char(ae)+'rm geh'+char(oe)+'rt.');
Memo1.Lines.Add('J''ai eu peur.|Ich habe Angst gehabt.');
Memo1.Lines.Add('Le voleur a perdu une lettre.|Der Dieb hat einen Brief verloren.');
Memo1.Lines.Add('Tu as ouvert la lettre?|Hast du den Brief ge'+char(oe)+'ffnet?');
Memo1.Lines.Add('Qu''est-ce que la police a fait?|Was hat die Polizei gemacht?');
Memo1.Lines.Add('crier|schreien');
Memo1.Lines.Add('casser|zerbrechen[]brechen');
Memo1.Lines.Add('travailler|arbeiten');
Memo1.Lines.Add('D'+char(egu)+'cris!|Beschreibe!');
Memo1.Lines.Add('D'+char(egu)+'crivez!|Beschreibt!');
Memo1.Lines.Add('Il a les yeux bleus.|Er hat blaue Augen.');
Memo1.Lines.Add('Il mesure environ 1m 80.|Er misst ungef'+char(ae)+'hr 1m 80.');
Memo1.Lines.Add('la moustache|der Schnauz[]der Schnurrbart');
Memo1.Lines.Add('la botte|der Stiefel');
Memo1.Lines.Add('ovale|oval');
Memo1.Lines.Add('en cuir|aus Leder');
Memo1.Lines.Add('la cravate|die Krawatte');
Memo1.Lines.Add('les lunettes|die Brille');
Memo1.Lines.Add('Apprends!|Lerne!');
Memo1.Lines.Add('Apprenez!|Lernt!');
Memo1.Lines.Add(''+char(egu)+'peler|buchstabieren');
Memo1.Lines.Add('C''est facile.|Es ist einfach.[]Es ist leicht.');
Memo1.Lines.Add('C''est difficile.|Es ist schwierig[]Es ist schwer.');
Memo1.Lines.Add('ce message|diese Nachricht[]diese Botschaft');
Memo1.Lines.SaveToFile(path+':8.csv');Memo1.Text:='';end;
Memo1.Text:=''; if not FileExists(path+':9.csv') then begin Memo1.Text:='';
Memo1.Lines.Add('la star|der Star');
Memo1.Lines.Add('la publicit'+char(egu)+'|die Werbung');
Memo1.Lines.Add('le film publicitaire|der Werbefilm');
Memo1.Lines.Add('l''annonce|das Inserat');
Memo1.Lines.Add('pr'+char(egu)+'senter|vorstellen');
Memo1.Lines.Add('habiter|wohnen');
Memo1.Lines.Add('l''anniversaire|der Geburtstag');
Memo1.Lines.Add('le nom|der Name');
Memo1.Lines.Add('le pr'+char(egu)+'nom|der Vorname');
Memo1.Lines.Add('le nom de famille|der Familienname');
Memo1.Lines.Add('la naissance|die Geburt');
Memo1.Lines.Add('la date de naissance|das Geburtsdatum');
Memo1.Lines.Add('le lieu de naissance|der Geburtsort');
Memo1.Lines.Add(''+char(ee)+'tre n'+char(egu)+'[]'+char(ee)+'tre n'+char(egu)+'e|geboren sein');
Memo1.Lines.Add('les loisirs|die Freizeitbesch'+char(ae)+'ftigung');
Memo1.Lines.Add('la profession|der Beruf');
Memo1.Lines.Add('la langue|die Sprache[]die Zunge');
Memo1.Lines.Add(''+char(ee)+'tre fort[]'+char(ee)+'tre forte|stark sein');
Memo1.Lines.Add('l''animal|das Tier');
Memo1.Lines.Add('les animaux|die Tiere');
Memo1.Lines.Add('l''animal domestique|das Haustier');
Memo1.Lines.Add('le p'+char(egra)+'re|der Vater');
Memo1.Lines.Add('la m'+char(egra)+'re|die Mutter');
Memo1.Lines.Add('le fr'+char(egra)+'re|der Bruder');
Memo1.Lines.Add('la soeur|die Schwester');
Memo1.Lines.Add('les parents|die Eltern');
Memo1.Lines.Add('les fr'+char(egra)+'res et soeurs|die Geschwister');
Memo1.Lines.Add('l''enfant|das Kind');
Memo1.Lines.Add('le gar'+char(cedi)+'on|der Knabe');
Memo1.Lines.Add('le fils|der Sohn');
Memo1.Lines.Add('la fille|die Tochter');
Memo1.Lines.Add('le grand-p'+char(egra)+'re|der Grossvater');
Memo1.Lines.Add('la grand-m'+char(egra)+'re|die Grossmutter');
Memo1.Lines.Add('les grands-parents|die Grosseltern');
Memo1.Lines.Add('l''homme|der Mann[]der Mensch');
Memo1.Lines.Add('la femme|die Frau[]die Ehefrau');
Memo1.Lines.Add('le mari|der Ehemann');
Memo1.Lines.Add('adulte|erwachsen');
Memo1.Lines.Add('l''adulte|der Erwachsene[]die Erwachsene');
Memo1.Lines.Add('le copain|der Freund[]Kumpel');
Memo1.Lines.Add('la copine|die Freundin');
Memo1.Lines.Add('parfait|sehr gut');
Memo1.Lines.Add('d''accord|einverstanden');
Memo1.Lines.Add('le boulanger|der B'+char(ae)+'cker');
Memo1.Lines.Add('C''est de la part de qui?|Wen darf ich melden?');
Memo1.Lines.Add('C''est occup'+char(egu)+'.|Es ist besetzt.');
Memo1.Lines.Add('Je t'+char(egu)+'l'+char(egu)+'phone pour l''annonce.|Ich telefoniere wegen des Inserats.');
Memo1.Lines.Add('Ne quittez pas.|Bleiben Sie am Apparat.');
Memo1.Lines.Add('Un instant, s''il vous plaît.|Einen Augenblick, bitte.');
Memo1.Lines.Add('Ah bon!|Aha![] (Erstaunen)');
Memo1.Lines.Add('Tout '+char(ai)+' fait.|Genau.');
Memo1.Lines.Add('le boulanger|der B'+char(ae)+'cker');
Memo1.Lines.Add('la boulang'+char(egra)+'re|die B'+char(ae)+'ckerin');
Memo1.Lines.Add('l'''+char(egu)+'l'+char(egra)+'ve|der Sch'+char(ue)+'ler');
Memo1.Lines.Add('l'''+char(egu)+'l'+char(egra)+'ve|die Sch'+char(ue)+'lerin');
Memo1.Lines.Add('l''acteur|der Schauspieler');
Memo1.Lines.Add('l''actrice|die Schauspielerin');
Memo1.Lines.Add('l''agriculteur|der Landwirt');
Memo1.Lines.Add('l''agricultrice|die Landwirtin');
Memo1.Lines.Add('l''artiste|der K'+char(ue)+'nstler');
Memo1.Lines.Add('l''artiste|die K'+char(ue)+'nstlerin');
Memo1.Lines.Add('l''athl'+char(egra)+'te|der Leichtathlet[]der Wettk'+char(ae)+'mpfer');
Memo1.Lines.Add('l''athl'+char(egra)+'te|die Leichtathletin[]die Wettk'+char(ae)+'mpferin');
Memo1.Lines.Add('le chanteur|der S'+char(ae)+'nger');
Memo1.Lines.Add('la chanteuse|die S'+char(ae)+'ngerin');
Memo1.Lines.Add('le directeur|der Direktor');
Memo1.Lines.Add('la directrice|die Direktorin');
Memo1.Lines.Add('l''employ'+char(egu)+'e|die Angestellte');
Memo1.Lines.Add('le fonctionnaire|der Beamte');
Memo1.Lines.Add('la fonctionnaire|die Beamtin');
Memo1.Lines.Add('le m'+char(egu)+'decin|der Arzt');
Memo1.Lines.Add('le m'+char(egu)+'decin|die Ärztin');
Memo1.Lines.Add('l''ouvrier|der Arbeiter');
Memo1.Lines.Add('l''ouvri'+char(egra)+'re|die Arbeiterin');
Memo1.Lines.SaveToFile(path+':9.csv');Memo1.Text:='';end;
Memo1.Text:=''; if not FileExists(path+':10.csv') then begin Memo1.Text:='';
Memo1.Lines.Add('les vacances|die Ferien');
Memo1.Lines.Add('le voyage|die Reise');
Memo1.Lines.Add('la randonn'+char(egu)+'e|die Wanderung');
Memo1.Lines.Add('la promenade|der Spaziergang');
Memo1.Lines.Add('le pays|das Land');
Memo1.Lines.Add('les bagages|das Gep'+char(ae)+'ck');
Memo1.Lines.Add('raconter|erz'+char(ae)+'hlen');
Memo1.Lines.Add('le matin|der Morgen[]am Morgen');
Memo1.Lines.Add(''+char(ai)+' midi|am Mittag[] (12.00)');
Memo1.Lines.Add('apr'+char(egra)+'s|nachher');
Memo1.Lines.Add('l''apr'+char(egra)+'s-midi|der Nachmittag[]am Nachmittag');
Memo1.Lines.Add('le soir|der Abend[]am Abend');
Memo1.Lines.Add('le dîner|das Abendessen');
Memo1.Lines.Add('le jour|der Tag');
Memo1.Lines.Add('la nuit|die Nacht[]in der Nacht');
Memo1.Lines.Add(''+char(ai)+' minuit|um Mitternacht');
Memo1.Lines.Add('la journ'+char(egu)+'e|der Tag[] (von morgens bis abends) ');
Memo1.Lines.Add('l''an|das Jahr');
Memo1.Lines.Add('l''ann'+char(egu)+'e|das Jahr[] (gesehen als Kalenderjahr) ');
Memo1.Lines.Add('le d'+char(egu)+'but|der Anfang');
Memo1.Lines.Add('d''abord|zuerst');
Memo1.Lines.Add('la mer|das Meer');
Memo1.Lines.Add('nager|schwimmen');
Memo1.Lines.Add('l''île|die Insel');
Memo1.Lines.Add('la plage|der Strand');
Memo1.Lines.Add('bronzer|sich br'+char(ae)+'unen');
Memo1.Lines.Add('le sable|der Sand');
Memo1.Lines.Add('le port|der Hafen');
Memo1.Lines.Add('la p'+char(ee)+'che|das Fischen[]die Fischerei');
Memo1.Lines.Add('le port de p'+char(ee)+'che|der Fischerhafen');
Memo1.Lines.Add('l''int'+char(egu)+'rieur|das Innere');
Memo1.Lines.Add('chercher|suchen');
Memo1.Lines.Add('trouver|finden');
Memo1.Lines.Add('l''argent|das Geld');
Memo1.Lines.Add('ensemble|zusammen[]miteinander');
Memo1.Lines.Add('visiter|besichtigen[]besuchen');
Memo1.Lines.Add('le mus'+char(egu)+'e|das Museum');
Memo1.Lines.Add('les gens|die Leute');
Memo1.Lines.Add('rencontrer|treffen');
Memo1.Lines.Add('la vieille ville|die Altstadt');
Memo1.Lines.Add('c'+char(egu)+'l'+char(egra)+'bre|ber'+char(ue)+'hmt');
Memo1.Lines.Add('louer|mieten[]wegnehmen[]vermieten');
Memo1.Lines.Add('le VTT|das Mountainbike');
Memo1.Lines.Add('changer|wechseln');
Memo1.Lines.Add('l''hôtel|das Hotel');
Memo1.Lines.Add('la tente|das Zelt');
Memo1.Lines.Add('travailler|arbeiten');
Memo1.Lines.Add('gagner|verdienen[]gewinnen');
Memo1.Lines.Add('la montagne|der Berg[]das Gebirge');
Memo1.Lines.Add('passer|verbringen');
Memo1.Lines.Add('la voile|das Segeln');
Memo1.Lines.Add('la planche '+char(ai)+' voile|das Surfbrett');
Memo1.Lines.Add('aller|gehen');
Memo1.Lines.Add('rester|bleiben');
Memo1.Lines.Add('arriver|ankommen');
Memo1.Lines.Add('partir|abfahren[]verreisen');
Memo1.Lines.Add('sortir|hinausgehen[]ausgehen');
Memo1.Lines.Add('entrer|hineingehen[]eintreten');
Memo1.Lines.Add('rentrer|heimkommen');
Memo1.Lines.Add('tomber|umfallen[]fallen');
Memo1.Lines.Add('retourner|zur'+char(ue)+'ckkehren');
Memo1.Lines.Add('monter|hinaufsteigen[]hineinsteigen');
Memo1.Lines.Add('le d'+char(egu)+'part|Abfahrt[]Weggang');
Memo1.Lines.SaveToFile(path+':10.csv');Memo1.Text:='';end;
Memo1.Text:=''; if not FileExists(path+':11.csv') then begin Memo1.Text:='';
Memo1.Lines.Add('manger|essen');
Memo1.Lines.Add(Char(cedig)+'a coûte combien?|Wie viel kostet das?');
Memo1.Lines.Add('apprendre|lernen');
Memo1.Lines.Add('comprendre|verstehen');
Memo1.Lines.Add('mettre|setzen[]legen[]stellen');
Memo1.Lines.Add('mettre la table|den Tisch decken');
Memo1.Lines.Add('mettre un v'+char(ee)+'tement|ein Kleidungsst'+char(ue)+'ck anziehen');
Memo1.Lines.Add('prendre|nehmen');
Memo1.Lines.Add('il faut|es braucht');
Memo1.Lines.Add('bienvenu[]bienvenue|willkommen');
Memo1.Lines.Add('aider|helfen');
Memo1.Lines.Add('inviter|einladen');
Memo1.Lines.Add('l''invit'+char(egu)+'|der Gast');
Memo1.Lines.Add('pr'+char(egu)+'parer|zubereiten[]vorbereiten');
Memo1.Lines.Add('aller chercher|holen gehen');
Memo1.Lines.Add('ajouter|hinzuf'+char(ue)+'gen');
Memo1.Lines.Add('m'+char(egu)+'langer|vermischen[]durcheinander bringen');
Memo1.Lines.Add('couper|schneiden[]zerschneiden');
Memo1.Lines.Add('le couvert|das Gedeck');
Memo1.Lines.Add('la nappe|das Tischtuch');
Memo1.Lines.Add('l''assiette|der Teller');
Memo1.Lines.Add('le couteau|das Messer');
Memo1.Lines.Add('la fourchette|die Gabel');
Memo1.Lines.Add('la cuill'+char(egra)+'re|der L'+char(oe)+'ffel');
Memo1.Lines.Add('le verre|das Glas[]das Trinkglas');
Memo1.Lines.Add('le kilo|das Kilo');
Memo1.Lines.Add('le litre|der Liter');
Memo1.Lines.Add('beaucoup de|viel von');
Memo1.Lines.Add('le gramme|das Gramm');
Memo1.Lines.Add('la bouteille|die Flasche');
Memo1.Lines.Add('peu de|wenig von');
Memo1.Lines.Add('un peu de|ein wenig von');
Memo1.Lines.Add('le morceau|das St'+char(ue)+'ck');
Memo1.Lines.Add('la rondelle|die Scheibe');
Memo1.Lines.Add('le lait|die Milch');
Memo1.Lines.Add('le fromage|der K'+char(ae)+'se');
Memo1.Lines.Add('la pâtisserie|das Feingeb'+char(ae)+'ck[]die Konditorei');
Memo1.Lines.Add('le gâteau|der Kuchen');
Memo1.Lines.Add('le citron|die Zitrone');
Memo1.Lines.Add('la salade|der Salat');
Memo1.Lines.Add('l''eau min'+char(egu)+'rale|das Mineralwasser');
Memo1.Lines.Add('le beurre|die Butter');
Memo1.Lines.Add('le pain|das Brot');
Memo1.Lines.Add('le chocolat|die Schokolade');
Memo1.Lines.Add('la pomme|der Apfel');
Memo1.Lines.Add('l''amande|die Mandel');
Memo1.Lines.Add('la carotte|die Karotte');
Memo1.Lines.Add('le poisson|der Fisch');
Memo1.Lines.Add('le jus|der Saft');
Memo1.Lines.Add('la viande|das Fleisch');
Memo1.Lines.Add('le l'+char(egu)+'gume|das Gem'+char(ue)+'se');
Memo1.Lines.Add('la pomme de terre|die Kartoffel');
Memo1.Lines.Add('la tomate|die Tomate');
Memo1.Lines.Add('les pâtes|die Teigwaren');
Memo1.Lines.Add('le sel|das Salz');
Memo1.Lines.Add('l''oeuf|das Ei');
Memo1.Lines.Add('le fruit|die Frucht');
Memo1.Lines.Add('la boisson|das Getr'+char(ae)+'nk');
Memo1.Lines.Add('le sirop|der Sirup');
Memo1.Lines.Add('le cidre|der Most');
Memo1.Lines.Add('le caf'+char(egu)+'|der Kaffee');
Memo1.Lines.Add('la menthe|die Pfefferminze');
Memo1.Lines.Add('la farine|das Mehl');
Memo1.Lines.Add('le sucre|der Zucker');
Memo1.Lines.Add('le riz|der Reis');
Memo1.Lines.Add('la noisette|die Haselnuss');
Memo1.Lines.Add('la levure|die Hefe');
Memo1.Lines.Add('la confiture|die Konfitüre');
Memo1.Lines.Add('la tarte|der Obstkuchen[]der Fr'+char(ue)+'chtekuchen');
Memo1.Lines.Add('saler|salzen');
Memo1.Lines.Add('le saladier|die Salatsch'+char(ue)+'ssel');
Memo1.Lines.Add('la laitue|der Kopfsalat');
Memo1.Lines.Add('la courgette|die Zucchetti');
Memo1.Lines.Add('l''artichaut|die Artischocke');
Memo1.Lines.Add('le poivre|der Pfeffer');
Memo1.Lines.Add('poivrer|pfeffern');
Memo1.Lines.Add('le vinaigre|der Essig[]der Weinessig');
Memo1.Lines.Add('la vinaigrette|die Salatsauce');
Memo1.Lines.Add('l''huile|das Öl');
Memo1.Lines.Add('la moutarde|der Senf');
Memo1.Lines.Add('utile|n'+char(ue)+'tzlich');
Memo1.Lines.Add('toujours|immer');
Memo1.Lines.Add('avant|vor[] (zeitlich) ');
Memo1.Lines.Add('apr'+char(egra)+'s|nach[] (zeitlich) ');
Memo1.Lines.Add('pendant|w'+char(ae)+'hrend');
Memo1.Lines.SaveToFile(path+':11.csv');Memo1.Text:='';end;
Memo1.Text:=''; if not FileExists(path+':12.csv') then begin Memo1.Text:='';
Memo1.Lines.Add('le sport pr'+char(egu)+'f'+char(egu)+'r'+char(egu)+'|der Lieblingssport');
Memo1.Lines.Add('la danse|der Tanz');
Memo1.Lines.Add('le roller|das Inlineskating');
Memo1.Lines.Add('jouer au volley|Volleyball spielen');
Memo1.Lines.Add('jouer au basket|Basketball spielen');
Memo1.Lines.Add('jouer au foot|Fussball spielen');
Memo1.Lines.Add('la balle|der Ball');
Memo1.Lines.Add('la planche '+char(ai)+' roulettes|das Rollbrett');
Memo1.Lines.Add('la patinoire|die Eisbahn');
Memo1.Lines.Add('la piscine|das Schwimmbad');
Memo1.Lines.Add('le centre sportif|das Sportzentrum');
Memo1.Lines.Add('le terrain de basket|das Basketballfeld');
Memo1.Lines.Add('la musculation|das Krafttraining');
Memo1.Lines.Add('la voile|das Segel[]das Segeln');
Memo1.Lines.Add('le terrain de sport|der Sportplatz');
Memo1.Lines.Add('pratiquer|praktizieren');
Memo1.Lines.Add('le sportif|der Sportler');
Memo1.Lines.Add('la sportive|die Sportlerin');
Memo1.Lines.Add('sportif[]sportive|sportlich');
Memo1.Lines.Add('l'''+char(egu)+'quipe|die Mannschaft');
Memo1.Lines.Add('seul[]seule|allein');
Memo1.Lines.Add('la pr'+char(egu)+'paration|die Vorbereitung');
Memo1.Lines.Add('participer '+char(ai)+'|teilnehmen an');
Memo1.Lines.Add('le jeu|das Spiel');
Memo1.Lines.Add('le tournoi|das Turnier');
Memo1.Lines.Add('le concours|der Wettkampf[]der Wettbewerb');
Memo1.Lines.Add('en forme|in Form');
Memo1.Lines.Add('svelte|schlank');
Memo1.Lines.Add('adorer|verehren[]sehr gerne haben');
Memo1.Lines.Add('d'+char(egu)+'tester|verabscheuen[]'+char(ue)+'berhaupt nicht gerne haben');
Memo1.Lines.Add('en '+char(egu)+'t'+char(egu)+'|im Sommer');
Memo1.Lines.Add('en hiver|im Winter');
Memo1.Lines.Add('le patinage|das Schlittschuhlaufen');
Memo1.Lines.Add('le patinage artistique|der Eiskunstlauf');
Memo1.Lines.Add('le hockey sur glace|das Eishockey');
Memo1.Lines.Add('la plong'+char(egu)+'e|das Tauchen');
Memo1.Lines.Add('le championnat|die Meisterschaft');
Memo1.Lines.Add('le champion|der Meister');
Memo1.Lines.Add('la championne|die Meisterin');
Memo1.Lines.Add('le d'+char(egu)+'butant|der Anf'+char(ae)+'nger');
Memo1.Lines.Add('la d'+char(egu)+'butante|die Anf'+char(ae)+'ngerin');
Memo1.Lines.Add('l''entraîneur|der Trainer');
Memo1.Lines.Add('l''entraînement|das Training');
Memo1.Lines.Add('le joueur|der Spieler');
Memo1.Lines.Add('la joueuse|die Spielerin');
Memo1.Lines.Add('la course|der Lauf[]das Rennen');
Memo1.Lines.Add('la course d''orientation|der Orientierungslauf');
Memo1.Lines.Add('le lac|der See');
Memo1.Lines.Add('la for'+char(ee)+'t|der Wald');
Memo1.Lines.Add('le village|das Dorf');
Memo1.Lines.Add('le village de r'+char(ee)+'ve|das Traumdorf');
Memo1.Lines.Add('la colline|der H'+char(ue)+'gel');
Memo1.Lines.Add('l''office de tourisme|das Verkehrsb'+char(ue)+'ro');
Memo1.Lines.Add('le touriste|der Tourist');
Memo1.Lines.Add('la touriste|die Touristin');
Memo1.Lines.Add('proposer|vorschlagen');
Memo1.Lines.Add('la pension|die Pension');
Memo1.Lines.Add('l''auberge de jeunesse|die Jugendherberge');
Memo1.Lines.Add('jeune|jung');
Memo1.Lines.Add('les jeunes|die jungen Leute');
Memo1.Lines.Add('le patron|der Besitzer eines kleinen Betriebes');
Memo1.Lines.Add('la patronne|die Besitzerin eines kleinen Betriebes');
Memo1.Lines.Add('la visite|der Besuch');
Memo1.Lines.Add('le courage|der Mut');
Memo1.Lines.Add('l''aventure|das Abenteuer');
Memo1.Lines.Add('la soir'+char(egu)+'e|der Abend[] (in seiner Dauer) ');
Memo1.Lines.Add('se coucher|sich hinlegen[]ins Bett gehen');
Memo1.Lines.Add('se lever|aufstehen');
Memo1.Lines.Add('se pr'+char(egu)+'senter|sich vorstellen');
Memo1.Lines.Add('se pr'+char(egu)+'parer|sich vorbereiten');
Memo1.Lines.Add('s''entraîner|trainieren');
Memo1.Lines.Add('se concentrer|sich konzentrieren');
Memo1.Lines.Add('se reposer|sich ausruhen');
Memo1.Lines.Add('utiliser|gebrauchen[]verwenden');
Memo1.Lines.Add('pourquoi|warum');
Memo1.Lines.Add('parce que|weil');
Memo1.Lines.Add('puis|dann');
Memo1.Lines.Add('trop|zu viel');
Memo1.Lines.Add('trop de|zu viel von');
Memo1.Lines.Add('tard|sp'+char(ae)+'t');
Memo1.Lines.Add('trop tard|zu sp'+char(ae)+'t');
Memo1.Lines.SaveToFile(path+':12.csv');Memo1.Text:='';end;
Memo1.Text:=''; if not FileExists(path+':13.csv') then begin Memo1.Text:='';
Memo1.Lines.Add('le corps|der K'+char(oe)+'rper');
Memo1.Lines.Add('le bras|der Arm');
Memo1.Lines.Add('le pied|der Fuss');
Memo1.Lines.Add('la main|die Hand');
Memo1.Lines.Add('le doigt|der Finger');
Memo1.Lines.Add('le ventre|der Bauch');
Memo1.Lines.Add('le genou|das Knie');
Memo1.Lines.Add('la jambe|das Bein');
Memo1.Lines.Add('l'''+char(egu)+'paule|die Schulter');
Memo1.Lines.Add('la t'+char(ee)+'te|der Kopf');
Memo1.Lines.Add('la bouche|der Mund');
Memo1.Lines.Add('le front|die Stirn');
Memo1.Lines.Add('l''oeil|das Auge');
Memo1.Lines.Add('l''oreille|das Ohr');
Memo1.Lines.Add('la joue|die Wange');
Memo1.Lines.Add('le cheveu|das Haar');
Memo1.Lines.Add('le visage|das Gesicht');
Memo1.Lines.Add('le cou|der Hals');
Memo1.Lines.Add('la cheville|der Kn'+char(oe)+'chel');
Memo1.Lines.Add('le dos|der R'+char(ue)+'cken');
Memo1.Lines.Add('l''accident|der Unfall');
Memo1.Lines.Add('la foulure|die Verstauchung');
Memo1.Lines.Add('la fracture|der Bruch');
Memo1.Lines.Add('le plâtre|der Gips');
Memo1.Lines.Add('avoir mal '+char(ai)+'[]avoir mal|Schmerzen haben');
Memo1.Lines.Add('faire mal|weh tun');
Memo1.Lines.Add('grave|schlimm');
Memo1.Lines.Add('la douleur|der Schmerz');
Memo1.Lines.Add('l''ambulance|der Krankenwagen');
Memo1.Lines.Add('fatigu'+char(egu)+'[]fatigu'+char(egu)+'e|m'+char(ue)+'de');
Memo1.Lines.Add('la toux|der Husten');
Memo1.Lines.Add('tousser|husten');
Memo1.Lines.Add('la gorge|der Hals[]die Kehle');
Memo1.Lines.Add('malade|krank');
Memo1.Lines.Add('la sant'+char(egu)+'|die Gesundheit');
Memo1.Lines.Add('prendre froid|sich erk'+char(ae)+'lten');
Memo1.Lines.Add('la bronchite|die Bronchitis');
Memo1.Lines.Add('le rhume|die Erk'+char(ae)+'ltung');
Memo1.Lines.Add('l''angine|die Angina');
Memo1.Lines.Add('la pharmacie|die Apotheke');
Memo1.Lines.Add('le comprime|die Tablette');
Memo1.Lines.Add('les gouttes|die Tropfen');
Memo1.Lines.Add('la tisane|der Kr'+char(ae)+'utertee');
Memo1.Lines.Add('le lit|das Bett');
Memo1.Lines.Add('le repos|die Ruhe');
Memo1.Lines.Add('l''ordonnance|das '+char(ae)+'rztliche Rezept');
Memo1.Lines.Add('le conseil|der Ratschlag');
Memo1.Lines.Add('bientôt|bald');
Memo1.Lines.Add('contre|gegen');
Memo1.Lines.Add('Assieds-toi!|Setz dich!');
Memo1.Lines.Add('s''habiller|sich anziehen');
Memo1.Lines.Add('se laver|sich waschen');
Memo1.Lines.Add('se blesser|sich verletzen');
Memo1.Lines.Add('se fouler qc.|sich etw. verstauchen');
Memo1.Lines.Add('se casser qc.|sich etw. brechen');
Memo1.Lines.Add('s''allonger|sich hinlegen[]ausstrecken');
Memo1.Lines.Add('se soigner|sich pflegen');
Memo1.Lines.Add('se mettre '+char(ai)+' faire|beginnen mit');
Memo1.Lines.SaveToFile(path+':13.csv');Memo1.Text:='';end;
Memo1.Text:=''; if not FileExists(path+':14.csv') then begin Memo1.Text:='';
Memo1.Lines.Add('jouer d''un instrument|ein Instrument spielen');
Memo1.Lines.Add('la lettre|der Brief');
Memo1.Lines.Add('l''activit'+char(egu)+'|die T'+char(ae)+'tigkeit[]Besch'+char(ae)+'ftigung');
Memo1.Lines.Add('collectionner|sammeln');
Memo1.Lines.Add('le collectionneur|der Sammler');
Memo1.Lines.Add('la collectionneuse|die Sammlerin');
Memo1.Lines.Add('le timbre[]le timbre-poste|die Briefmarke');
Memo1.Lines.Add('la bourse|die B'+char(oe)+'rse');
Memo1.Lines.Add('la carte postale|die Postkarte');
Memo1.Lines.Add('surtout|vor allem');
Memo1.Lines.Add('lire|lesen');
Memo1.Lines.Add(''+char(egu)+'crire|schreiben');
Memo1.Lines.Add('le journal|die Zeitung[]das Tagebuch');
Memo1.Lines.Add('faire les courses|einkaufen gehen');
Memo1.Lines.Add('garder|behalten[]h'+char(ue)+'ten');
Memo1.Lines.Add('la boîte|die Disco[]die Schachtel');
Memo1.Lines.Add('bricoler|basteln');
Memo1.Lines.Add('le bricolage|die Bastelei[]die Bastelarbeit');
Memo1.Lines.Add('le bricoleur|der Bastler');
Memo1.Lines.Add('la bricoleuse|die Bastlerin');
Memo1.Lines.Add('la d'+char(egu)+'tente|die Entspannung');
Memo1.Lines.Add('dormir|schlafen');
Memo1.Lines.Add('discuter qc.|besprechen');
Memo1.Lines.Add('avoir envie|Lust haben');
Memo1.Lines.Add('proposer|vorschlagen');
Memo1.Lines.Add('la proposition|der Vorschlag');
Memo1.Lines.Add('le projet|der Plan[]das Vorhaben');
Memo1.Lines.Add('avoir raison|recht haben');
Memo1.Lines.Add('moi non plus|ich auch nicht');
Memo1.Lines.Add('penser de|denken '+char(ue)+'ber');
Memo1.Lines.Add('permettre|erlauben[]gestatten');
Memo1.Lines.Add('la permission|die Erlaubnis');
Memo1.Lines.Add('demander|fragen');
Memo1.Lines.Add('demander la permission|um Erlaubnis bitten');
Memo1.Lines.Add('avec plaisir|mit Vergn'+char(ue)+'gen');
Memo1.Lines.Add('On pourrait aller au cin'+char(egu)+'ma.|Wir k'+char(oe)+'nnten ins Kino gehen.');
Memo1.Lines.Add('Je te propose d''aller au cin'+char(egu)+'ma.|Ich schlage dir vor, ins Kino zu gehen.');
Memo1.Lines.Add('Si tu veux, on peut aller au cin'+char(egu)+'ma.|Wenn du willst, k'+char(oe)+'nnen wir ins Kino gehen.');
Memo1.Lines.Add('Je veux bien.|Sehr gern.');
Memo1.Lines.Add('commencer|anfangen[]beginnen');
Memo1.Lines.Add('la fois|das Mal');
Memo1.Lines.Add('la premi'+char(egra)+'re fois|das erste Mal');
Memo1.Lines.Add('prochain[]prochaine|n'+char(ae)+'chste[]n'+char(ae)+'chster[]n'+char(ae)+'chstes');
Memo1.Lines.Add('nouveau[]nouvelle|neu');
Memo1.Lines.Add('vieille[]vieux|alt');
Memo1.Lines.Add('chaque|jede[]jeder[]jedes');
Memo1.Lines.Add('prendre des notes|Notizen machen');
Memo1.Lines.Add('la diff'+char(egu)+'rence|der Unterschied');
Memo1.Lines.Add('diff'+char(egu)+'rent[]diff'+char(egu)+'rente|verschieden');
Memo1.Lines.Add('jusqu'''+char(ai)+'|bis');
Memo1.Lines.SaveToFile(path+':14.csv');Memo1.Text:='';end;
Memo1.Text:=''; if not FileExists(path+':15.csv') then begin Memo1.Text:='';
Memo1.Lines.Add('observer|beobachten');
Memo1.Lines.Add(''+char(ee)+'tre en route|unterwegs sein');
Memo1.Lines.Add('la route|die Landstrasse');
Memo1.Lines.Add('le sommet|der Gipfel');
Memo1.Lines.Add('le glacier|der Gletscher');
Memo1.Lines.Add('le rocher|der Felsen');
Memo1.Lines.Add('le sapin|die Tanne');
Memo1.Lines.Add('le pr'+char(egu)+'|die Wiese');
Memo1.Lines.Add('la vue|die Aussicht');
Memo1.Lines.Add('voir|sehen');
Memo1.Lines.Add('admirer|bewundern');
Memo1.Lines.Add('planter|pflanzen');
Memo1.Lines.Add('la feuille|das Blatt');
Memo1.Lines.Add('le col|der Pass');
Memo1.Lines.Add('la vall'+char(egu)+'e|das Tal');
Memo1.Lines.Add('l''horizon|der Horizont');
Memo1.Lines.Add('le progr'+char(egra)+'s|der Fortschritt');
Memo1.Lines.Add('le château|das Schloss');
Memo1.Lines.Add('l''avis|die Meinung');
Memo1.Lines.Add('magnifique|wunderbar');
Memo1.Lines.Add('respecter|respektieren');
Memo1.Lines.Add('l''environnement|die Umwelt');
Memo1.Lines.Add('la r'+char(egu)+'serve naturelle|das Naturschutzgebiet');
Memo1.Lines.Add('le temps|das Wetter');
Memo1.Lines.Add('Il fait mauvais temps.|Es ist schlechtes Wetter.');
Memo1.Lines.Add('Il fait chaud.|Es ist warm.');
Memo1.Lines.Add('Il fait froid.|Es ist kalt.');
Memo1.Lines.Add('Quel beau temps!|Welch sch'+char(oe)+'nes Wetter!');
Memo1.Lines.Add('Il fait quel temps aujourd''hui?|Welches Wetter haben wir heute?');
Memo1.Lines.Add('l'''+char(egu)+'t'+char(egu)+'|der Sommer');
Memo1.Lines.Add('l''hiver|der Winter');
Memo1.Lines.Add('la neige|der Schnee');
Memo1.Lines.Add('clair[]claire|hell[]klar');
Memo1.Lines.Add('Il fait moins trois.|Es ist minus drei Grad.');
Memo1.Lines.Add('Il fait 28 degr'+char(egu)+'s.|Es ist 28 Grad.');
Memo1.Lines.Add('Il fait beau.|Es ist sch'+char(oe)+'n.');
Memo1.Lines.Add('Il pleut.|Es regnet.');
Memo1.Lines.Add('la saison|die Jahreszeit');
Memo1.Lines.Add('le printemps|der Fr'+char(ue)+'hling');
Memo1.Lines.Add('l''automne|der Herbst');
Memo1.Lines.Add('dehors|draussen');
Memo1.Lines.Add('le vent|der Wind');
Memo1.Lines.Add('le brouillard|der Nebel');
Memo1.Lines.Add('l''orage|das Gewitter');
Memo1.Lines.Add('le tonnerre|der Donner');
Memo1.Lines.Add('l'''+char(egu)+'clair|der Blitz');
Memo1.Lines.Add('le canon|die Kanone');
Memo1.Lines.Add('le haut-plateau[]le plateau|die Hochebene');
Memo1.Lines.Add('le po'+char(egra)+'me|das Gedicht');
Memo1.Lines.Add('dangereux[]dangereuse|gef'+char(ae)+'hrlich');
Memo1.Lines.Add('la vache|die Kuh');
Memo1.Lines.Add('le mouton|das Schaf');
Memo1.Lines.Add('la ch'+char(egra)+'vre|die Ziege');
Memo1.Lines.Add('le cheval|das Pferd');
Memo1.Lines.Add('rien|nichts');
Memo1.Lines.Add('ne ... rien|nichts[](in Verbindung mit einem Verb)');
Memo1.Lines.Add('toujours|immer');
Memo1.Lines.Add('encore|noch');
Memo1.Lines.Add('le travail|die Arbeit');
Memo1.Lines.Add('terminer|beenden');
Memo1.Lines.Add('cr'+char(egu)+'er|kreieren[]schaffen');
Memo1.Lines.Add(''+char(ee)+'tre pour ou contre|daf'+char(ue)+'r oder dagegen sein');
Memo1.Lines.Add('si|wenn[]falls');
Memo1.Lines.Add('Je ne suis pas tout '+char(ai)+' fait d''accord avec toi.|Ich bin mit dir nicht ganz einverstanden.');
Memo1.Lines.Add('Je ne suis pas d''accord avec vous.|Ich bin mit Ihnen nicht einverstanden.');
Memo1.Lines.SaveToFile(path+':15.csv');Memo1.Text:='';end;
Memo1.Text:=''; if not FileExists(path+':16.csv') then begin Memo1.Text:='';
Memo1.Lines.Add('le cadeau|das Geschenk');
Memo1.Lines.Add('le march'+char(egu)+'|der Markt');
Memo1.Lines.Add('le commerce|der Handel[]das Gesch'+char(ae)+'ft');
Memo1.Lines.Add('le commer'+char(cedi)+'ant[]la commer'+char(cedi)+'ante|der H'+char(ae)+'ndler[]der Kaufmann');
Memo1.Lines.Add('vendre|verkaufen');
Memo1.Lines.Add('le client[]la cliente|der Kunde[]die Kundin');
Memo1.Lines.Add('l'''+char(egu)+'picier[]l'''+char(egu)+'pici'+char(egra)+'re|der Lebensmittelh'+char(ae)+'ndler[]die Lebensmittelh'+char(ae)+'ndlerin');
Memo1.Lines.Add('le boucher[]la bouch'+char(egra)+'re|der Metzger[]die Metzgerin');
Memo1.Lines.Add('le service|der Service[]die Bedienung');
Memo1.Lines.Add('le produit|das Produkt');
Memo1.Lines.Add('l''article|der Artikel');
Memo1.Lines.Add('l''achat|der Kauf[]der Einkauf');
Memo1.Lines.Add('le pharmacien[]la pharmacienne|der Apotheker[]die Apothekerin');
Memo1.Lines.Add('l''apprenti[]l''apprentie|der Lehrling[]die Lehrtochter');
Memo1.Lines.Add('la caisse|die Kasse');
Memo1.Lines.Add('la monnaie|das Kleingeld');
Memo1.Lines.Add('rendre|zur'+char(ue)+'ckgeben');
Memo1.Lines.Add('le centre commercial|das Einkaufszentrum');
Memo1.Lines.Add('l''annonce publicitaire|die Werbeanzeige');
Memo1.Lines.Add('offrir|schenken[]anbieten');
Memo1.Lines.Add('le bureau de tabac|kiosk'+char(ae)+'hnliches Gesch'+char(ae)+'ft[](verkauft Zeitungen, Tabakwaren usw.) ');
Memo1.Lines.Add('la nouvelle|die Nachricht[]die Neuigkeit');
Memo1.Lines.Add('dernier[]derni'+char(egra)+'re|letzte[]letzter[]letztes');
Memo1.Lines.Add('la marchandise|die Ware');
Memo1.Lines.Add('la librairie|die Buchhandlung');
Memo1.Lines.Add('le fleuriste[]la fleuriste|der Blumenh'+char(ae)+'ndler[]die Blumenh'+char(ae)+'ndlerin');
Memo1.Lines.Add('le libre-service|die Selbstbedienung');
Memo1.Lines.Add('garer|parkieren');
Memo1.Lines.Add('le grand magasin|das Warenhaus');
Memo1.Lines.Add('l'''+char(egu)+'tage|das Stockwerk');
Memo1.Lines.Add('le rayon|die Abteilung');
Memo1.Lines.Add('l''alimentation|die Ern'+char(ae)+'hrung[]die Verpflegung');
Memo1.Lines.Add('le rayon alimentation|die Lebensmittelabteilung');
Memo1.Lines.Add('l''appareil photo|der Fotoapparat');
Memo1.Lines.Add('la pile|die Batterie');
Memo1.Lines.Add('apporter|bringen');
Memo1.Lines.Add('rapporter|zur'+char(ue)+'ckbringen');
Memo1.Lines.Add('le rez-de-chauss'+char(egu)+'e|das Erdgeschoss');
Memo1.Lines.Add('le sous-sol|das Untergeschoss');
Memo1.Lines.Add(''+char(ee)+'tre d'+char(egu)+'sol'+char(egu)+'[]'+char(ee)+'tre d'+char(egu)+'sol'+char(egu)+'e|Leid tun');
Memo1.Lines.Add('le guichet des renseignements|der Auskunftsschalter');
Memo1.Lines.Add('la fin|der Schluss[]das Ende');
Memo1.Lines.Add('m'+char(ee)+'me|derselbe[]dasselbe[]dieselbe');
Memo1.Lines.Add('attendre|warten');
Memo1.Lines.Add('la caract'+char(egu)+'ristique|das Merkmal');
Memo1.Lines.SaveToFile(path+':16.csv');Memo1.Text:='';end;
Memo1.Text:=''; if not FileExists(path+':17.csv') then begin Memo1.Text:='';
Memo1.Lines.Add('attribuer|zuordnen');
Memo1.Lines.Add('bavarder|schwatzen');
Memo1.Lines.Add('connaître|kennen');
Memo1.Lines.Add('couper|schneiden');
Memo1.Lines.Add('dire|sagen');
Memo1.Lines.Add('effacer|radieren[]auswischen');
Memo1.Lines.Add('expliquer|erkl'+char(ae)+'ren');
Memo1.Lines.Add('nommer|nennen');
Memo1.Lines.Add('oublier|vergessen');
Memo1.Lines.Add('porter|tragen');
Memo1.Lines.Add('ranger|aufr'+char(ae)+'umen');
Memo1.Lines.Add('traduire|'+char(ue)+'bersetzten');
Memo1.Lines.Add('s''amuser|sich am'+char(ue)+'sieren');
Memo1.Lines.Add('se brosser|sich b'+char(ue)+'rsten');
Memo1.Lines.Add('se coiffer|sich frisieren');
Memo1.Lines.Add('se d'+char(egu)+'p'+char(ee)+'cher|sich beeilen');
Memo1.Lines.Add('s''embrasser|sich k'+char(ue)+'ssen');
Memo1.Lines.Add('se r'+char(egu)+'veiller[]s'''+char(egu)+'veiller|aufwachen[]erwachen');
Memo1.Lines.Add('se frotter|sich reiben');
Memo1.Lines.Add('se maquiller|sich schminken');
Memo1.Lines.Add('se moucher|sich die Nase putzen');
Memo1.Lines.Add('se parfumer|sich parf'+char(ue)+'mieren');
Memo1.Lines.Add('se promener|spazieren');
Memo1.Lines.Add('se raser|sich rasieren');
Memo1.Lines.Add('se regarder|sich anschauen');
Memo1.Lines.Add('se reposer|sich erholen');
Memo1.Lines.Add('se saluer|sich begr'+char(ue)+'ssen');
Memo1.Lines.Add('la mati'+char(egra)+'re|das Schulfach');
Memo1.Lines.Add('la consigne|die Anweisung');
Memo1.Lines.Add('la solution|die L'+char(oe)+'sung');
Memo1.Lines.Add('la situation|die Situation');
Memo1.Lines.Add('la sc'+char(egra)+'ne vid'+char(egu)+'o|die Videoszene');
Memo1.Lines.Add('gronder|schimpfen');
Memo1.Lines.Add('facile|leicht[]einfach[] (T'+char(ae)+'tigkeit)');
Memo1.Lines.Add('difficile|schwierig');
Memo1.Lines.Add('la s'+char(egu)+'quence|die Szene[]Die Sequenz');
Memo1.Lines.Add('bruyant[]bruyante|l'+char(ae)+'rmig');
Memo1.Lines.Add('le miroir|der Spiegel');
Memo1.Lines.Add('le robinet|der Wasserhahn');
Memo1.Lines.Add('la r'+char(egu)+'cr'+char(egu)+'ation|die Pause');
Memo1.Lines.Add('le silence|die Ruhe');
Memo1.Lines.Add('l''ordre|die Ordnung');
Memo1.Lines.Add('le d'+char(egu)+'sordre|die Unordnung');
Memo1.Lines.Add('l''ambiance|die Stimmung[]die Atmosph'+char(ae)+'re');
Memo1.Lines.Add('l''habitude|die Gewohnheit');
Memo1.Lines.Add('la patience|die Geduld');
Memo1.Lines.Add('ambitieux[]ambitieuse|ehrgeizig[]ambiti'+char(oe)+'s');
Memo1.Lines.Add('amoureux[]amoureuse|verliebt');
Memo1.Lines.Add('content[]contente|zufrieden');
Memo1.Lines.Add('calme|ruhig');
Memo1.Lines.Add('fâch'+char(egu)+'[]fâch'+char(egu)+'e|ver'+char(ae)+'rgert');
Memo1.Lines.Add('poli[]polie|h'+char(oe)+'flich');
Memo1.Lines.Add('triste|traurig');
Memo1.Lines.Add('paresseux[]paresseuse|faul');
Memo1.Lines.Add('appliqu'+char(egu)+'[]appliqu'+char(egu)+'e|fleissig');
Memo1.Lines.Add('ainsi|so[]auf diese Art');
Memo1.Lines.Add('quelquefois|manchmal');
Memo1.Lines.Add(''+char(ai)+' tour de rôle|abwechslungsweise');
Memo1.Lines.Add('souvent|oft');
Memo1.Lines.Add('en retard|zu sp'+char(ae)+'t[]versp'+char(ae)+'tet');
Memo1.Lines.Add('tôt|fr'+char(ue)+'h');
Memo1.Lines.SaveToFile(path+':17.csv');Memo1.Text:='';end;
Memo1.Text:=''; if not FileExists(path+':18.csv') then begin Memo1.Text:='';
Memo1.Lines.Add('le v'+char(ee)+'tement|das Kleidungsst'+char(ue)+'ck');
Memo1.Lines.Add('la casquette|die Schirmm'+char(ue)+'tze');
Memo1.Lines.Add('la chaussure|der Schuh');
Memo1.Lines.Add('le costume|der Anzug');
Memo1.Lines.Add('l'''+char(egu)+'charpe|das Halstuch[]der Schal');
Memo1.Lines.Add('le gant|der Handschuh');
Memo1.Lines.Add('les lunettes[]|die Brille');
Memo1.Lines.Add('le pantalon|die Hose');
Memo1.Lines.Add('la robe|das Kleid');
Memo1.Lines.Add('le short|die Shorts');
Memo1.Lines.Add('le sac|die Tasche');
Memo1.Lines.Add('la veste|die Jacke');
Memo1.Lines.Add('la basket|der Turnschuh');
Memo1.Lines.Add('la botte|der Stiefel');
Memo1.Lines.Add('la pantoufle|der Pantoffel');
Memo1.Lines.Add('la sandale|die Sandale');
Memo1.Lines.Add('le blouson|die Jacke[]die Lederjacke');
Memo1.Lines.Add('le gilet|das Gilet[]die Weste');
Memo1.Lines.Add('l''anorak|die Windjacke');
Memo1.Lines.Add('le manteau|der Mantel');
Memo1.Lines.Add('le jean|die Jeans');
Memo1.Lines.Add('le cale'+char(cedi)+'on|die Leggins');
Memo1.Lines.Add('le chemisier|die Damenbluse');
Memo1.Lines.Add('le tailleur|das Damenkost'+char(ue)+'m');
Memo1.Lines.Add('la chaussette|der Socken');
Memo1.Lines.Add('le collant|die Strumpfhose');
Memo1.Lines.Add('le tee-shirt|das T-Shirt');
Memo1.Lines.Add('le maillot|das Leibchen');
Memo1.Lines.Add('le slip|der Slip');
Memo1.Lines.Add('le foulard|das Kopftuch[]das Foulard');
Memo1.Lines.Add('le b'+char(egu)+'ret|die Baskenm'+char(ue)+'tze');
Memo1.Lines.Add('les lunettes de soleil|die Sonnenbrille');
Memo1.Lines.Add('le sac '+char(ai)+' main|die Handtasche');
Memo1.Lines.Add('la broche|die Brosche');
Memo1.Lines.Add('la ceinture|der G'+char(ue)+'rtel');
Memo1.Lines.Add('le pyjama|der Schlafanzug');
Memo1.Lines.Add('les bretelles|die Hosentr'+char(ae)+'ger');
Memo1.Lines.Add('l''imperm'+char(egu)+'able|der Regenmantel');
Memo1.Lines.Add('la salopette|die Latzhose');
Memo1.Lines.Add('le soutien-gorge|der B'+char(ue)+'stenhalter');
Memo1.Lines.Add('chaud[]chaude|warm');
Memo1.Lines.Add('froid[]froide|kalt');
Memo1.Lines.Add('court[]courte|kurz');
Memo1.Lines.Add('long[]longue|lang');
Memo1.Lines.Add('sportif[]sportive|sportlich');
Memo1.Lines.Add('cher[]ch'+char(egra)+'re|teuer[]lieb');
Memo1.Lines.Add('beau[]bel[]belle|sch'+char(oe)+'n');
Memo1.Lines.Add('vieux[]vieil[]vieille|alt');
Memo1.Lines.Add('violet[]violette|violett');
Memo1.Lines.Add('clair[]claire|klar[]hell');
Memo1.Lines.Add('fonc'+char(egu)+'[]fonc'+char(egu)+'e|dunkel');
Memo1.Lines.Add('gai[]gaie|fr'+char(oe)+'hlich');
Memo1.Lines.Add('rose|rosa');
Memo1.Lines.Add('joli[]jolie|h'+char(ue)+'bsch');
Memo1.Lines.Add(''+char(egu)+'l'+char(egu)+'gant[]'+char(egu)+'l'+char(egu)+'gante|elegant');
Memo1.Lines.Add('neuf[]neuve|neu');
Memo1.Lines.Add('classique|klassisch[]zeitlos');
Memo1.Lines.Add('d'+char(egu)+'mod'+char(egu)+'[]d'+char(egu)+'mod'+char(egu)+'e|altmodisch');
Memo1.Lines.Add('us'+char(egu)+'[]us'+char(egu)+'e|abgenutzt');
Memo1.Lines.Add('solide|solid');
Memo1.Lines.Add('r'+char(egu)+'sistant[]r'+char(egu)+'sistante|widerstandsf'+char(ae)+'hig');
Memo1.Lines.Add('confortable|bequem[]komfortabel');
Memo1.Lines.Add('l'+char(egu)+'ger[]l'+char(egu)+'g'+char(egra)+'re|leicht[] (Gewicht)');
Memo1.Lines.Add('large|weit');
Memo1.Lines.Add('serr'+char(egu)+'[]serr'+char(egu)+'e|eng');
Memo1.Lines.Add('sp'+char(egu)+'cial[]sp'+char(egu)+'ciale|speziell');
Memo1.Lines.Add('propre|sauber');
Memo1.Lines.Add('gentil[]gentille|nett');
Memo1.Lines.Add('s''habiller|sich anziehen');
Memo1.Lines.Add('montrer|zeigen');
Memo1.Lines.Add('porter|tragen');
Memo1.Lines.Add('le prix|der Preis');
Memo1.Lines.Add('la boutique|das Modegesch'+char(ae)+'ft[]die Boutique');
Memo1.Lines.Add('mettre|anziehen');
Memo1.Lines.Add('d'+char(egu)+'sirer|w'+char(ue)+'nschen');
Memo1.Lines.Add('proposer|vorschlagen');
Memo1.Lines.Add('le vendeur|der Verk'+char(ae)+'ufer');
Memo1.Lines.Add('la vendeuse|die Verk'+char(ae)+'uferin');
Memo1.Lines.Add('la caisse|die Kasse');
Memo1.Lines.Add('acheter|kaufen');
Memo1.Lines.Add('aller avec|zu passen');
Memo1.Lines.Add('essayer|probieren');
Memo1.Lines.Add(''+char(ee)+'tre habill'+char(egu)+'[]'+char(ee)+'tre habill'+char(egu)+'e|bekleidet sein');
Memo1.Lines.Add('pr'+char(egu)+'f'+char(egu)+'rer|vorziehen');
Memo1.Lines.Add('trouver|finden');
Memo1.Lines.Add('le choix|die Wahl[]die Auswahl');
Memo1.Lines.Add('la cabine d''essayage|die Umkleidekabine');
Memo1.Lines.Add('le coton|die Baumwolle');
Memo1.Lines.Add('la laine|die Wolle');
Memo1.Lines.Add('le cuir|das Leder');
Memo1.Lines.Add('la soie|die Seide');
Memo1.Lines.Add('le motif|das Motiv[]das Muster');
Memo1.Lines.Add(''+char(ai)+' rayures|gestreift');
Memo1.Lines.Add(''+char(ai)+' carreaux|kariert');
Memo1.Lines.Add('de couleur|farbig');
Memo1.Lines.Add('de couleurs vives|mit lebhaften Farben');
Memo1.Lines.Add(''+char(ai)+' fleurs|gebl'+char(ue)+'mt');
Memo1.Lines.Add(''+char(ai)+' pois|getupft');
Memo1.Lines.Add('la coupe|der Schnitt');
Memo1.Lines.Add('le col|der Kragen');
Memo1.Lines.Add('le pull '+char(ai)+' col roul'+char(egu)+'|der Rollkragenpulli');
Memo1.Lines.Add('la manche|der Ärmel');
Memo1.Lines.Add('le bouton|der Knopf');
Memo1.Lines.Add('la fermeture '+char(egu)+'clair|der Reissverschluss');
Memo1.Lines.Add('la pointure|die Schuhgr'+char(oe)+'sse');
Memo1.Lines.Add('la taille|die Kleidergr'+char(oe)+'sse');
Memo1.Lines.Add('l''anniversaire|der Geburtstag');
Memo1.Lines.Add('la surprise-partie|die Überraschungsparty');
Memo1.Lines.Add('le cadeau|das Geschenk');
Memo1.Lines.SaveToFile(path+':18.csv');Memo1.Text:='';end;
Memo1.Text:=''; if not FileExists(path+':19.csv') then begin Memo1.Text:='';
Memo1.Lines.Add('un appartement|eine Wohnung');
Memo1.Lines.Add('un immeuble|ein Wohnblock');
Memo1.Lines.Add('le voisin|der Nachbar');
Memo1.Lines.Add('la voisine|die Nachbarin');
Memo1.Lines.Add('s''informer de|sich erkundigen');
Memo1.Lines.Add('s''installer|sich einrichten');
Memo1.Lines.Add('placer|stellen[]hinstellen');
Memo1.Lines.Add('la chambre '+char(ai)+' coucher|das Schlafzimmer');
Memo1.Lines.Add('la pi'+char(egra)+'ce|das Zimmer');
Memo1.Lines.Add('une entr'+char(egu)+'e|ein Eingangsraum');
Memo1.Lines.Add('la salle de bains|das Badezimmer');
Memo1.Lines.Add('la baignoire|die Badewanne');
Memo1.Lines.Add('la douche|die Dusche');
Memo1.Lines.Add('la cuisine|die K'+char(ue)+'che');
Memo1.Lines.Add('la cuisini'+char(egra)+'re|der Kochherd');
Memo1.Lines.Add('le placard|der Wandschrank');
Memo1.Lines.Add('la vaisselle|das Geschirr');
Memo1.Lines.Add('un '+char(egu)+'vier|ein Sp'+char(ue)+'lbecken');
Memo1.Lines.Add('la poubelle|der M'+char(ue)+'lleimer');
Memo1.Lines.Add('le frigo[]le r'+char(egu)+'frig'+char(egu)+'rateur|der K'+char(ue)+'hlschrank');
Memo1.Lines.Add('le four|der Backofen');
Memo1.Lines.Add('le lave-vaisselle|die Geschirrsp'+char(ue)+'lmaschine');
Memo1.Lines.Add('le micro-ondes|die Mikrowelle');
Memo1.Lines.Add('le meuble|das M'+char(oe)+'belst'+char(ue)+'ck');
Memo1.Lines.Add('la chaise|der Stuhl');
Memo1.Lines.Add('la lampe|die Lampe');
Memo1.Lines.Add('le buffet|das Buffet');
Memo1.Lines.Add('le lit|das Bett');
Memo1.Lines.Add('la table|der Tisch');
Memo1.Lines.Add('le fauteuil|der Sessel');
Memo1.Lines.Add('le canap'+char(egu)+'|das Kanapee');
Memo1.Lines.Add('une armoire|ein Schrank');
Memo1.Lines.Add('une '+char(egu)+'tag'+char(egra)+'re|ein Gestell');
Memo1.Lines.Add('le rideau|der Vorhang');
Memo1.Lines.Add('le tapis|der Teppich');
Memo1.Lines.Add('la moquette|der Spannteppich');
Memo1.Lines.Add('la penderie|die Garderobe');
Memo1.Lines.Add('le cadre|der Rahmen');
Memo1.Lines.Add('la pendule|die Pendeluhr');
Memo1.Lines.Add('la chaîne st'+char(egu)+'r'+char(egu)+'o|die Stereoanlage');
Memo1.Lines.Add('le disque|die Schallplatte');
Memo1.Lines.Add('une '+char(egu)+'chelle|eine Leiter');
Memo1.Lines.Add(''+char(ai)+' côt'+char(egu)+' de|neben');
Memo1.Lines.Add('au milieu de|mitten');
Memo1.Lines.Add('en face|gegen'+char(ue)+'ber');
Memo1.Lines.Add('pr'+char(egra)+'s de|in der N'+char(ae)+'he');
Memo1.Lines.Add('au-dessous de|unterhalb');
Memo1.Lines.Add('au-dessus de|oberhalb');
Memo1.Lines.Add('autour de|um herum');
Memo1.Lines.Add('neuf[]neuve|neu');
Memo1.Lines.Add('vieux[]vieil[]vieille|alt');
Memo1.Lines.Add('nouveau[]nouvel[]nouvelle|neu[]erstmalig');
Memo1.Lines.Add('ancien[]ancienne|antik');
Memo1.Lines.Add('us'+char(egu)+'[]us'+char(egu)+'e|gebraucht');
Memo1.Lines.Add('compliqu'+char(egu)+'[]compliqu'+char(egu)+'e|kompliziert');
Memo1.Lines.Add('possible|m'+char(oe)+'glich');
Memo1.Lines.Add('impossible|unm'+char(oe)+'glich');
Memo1.Lines.Add('pauvre|arm');
Memo1.Lines.Add('curieux[]curieuse|neugierig');
Memo1.Lines.Add('fr'+char(egu)+'quent[]fr'+char(egu)+'quente|h'+char(ae)+'ufig');
Memo1.Lines.Add('identique|identisch');
Memo1.Lines.Add('portable|tragbar');
Memo1.Lines.Add('couvrir|decken');
Memo1.Lines.Add('souffrir de|leiden');
Memo1.Lines.Add('tenir|halten');
Memo1.Lines.Add('appartenir|geh'+char(oe)+'ren');
Memo1.Lines.Add('venir|kommen');
Memo1.Lines.Add('devenir|werden');
Memo1.Lines.Add('se souvenir de|sich erinnern');
Memo1.Lines.Add('servir|bedienen');
Memo1.Lines.Add('servir '+char(ai)+'|dienen zu');
Memo1.Lines.Add('retenir|zur'+char(ue)+'ckhalten');
Memo1.Lines.Add('revenir|wiederkommen');
Memo1.Lines.Add('repartir|wieder verreisen');
Memo1.Lines.Add('promettre|versprechen');
Memo1.Lines.Add('croire|glauben');
Memo1.Lines.Add('savoir|wissen');
Memo1.Lines.Add('une affaire|eine Sache[]ein Gesch'+char(ae)+'ft');
Memo1.Lines.Add('une histoire|eine Geschichte');
Memo1.Lines.Add('la brocante|die Brockenstube');
Memo1.Lines.Add('le type|die Art');
Memo1.Lines.Add('assez de|genug');
Memo1.Lines.Add('sans|ohne');
Memo1.Lines.Add('une absence|eine Abwesenheit');
Memo1.Lines.Add('la pr'+char(egu)+'sence|die Anwesenheit');
Memo1.Lines.Add('la temp'+char(ee)+'te|der Sturm');
Memo1.Lines.Add('la technologie|die Technologie');
Memo1.Lines.Add('en effet|in der Tat');
Memo1.Lines.Add('en g'+char(egu)+'n'+char(egu)+'ral|generell');
Memo1.Lines.SaveToFile(path+':19.csv');Memo1.Text:='';end;
Memo1.Text:=''; if not FileExists(path+':20.csv') then begin Memo1.Text:='';
Memo1.Lines.Add('l''agriculteur|der Landwirt');
Memo1.Lines.Add('l''agricultrice|die Landwirtin');
Memo1.Lines.Add('le paysan|der Bauer');
Memo1.Lines.Add('la paysanne|die B'+char(ae)+'uerin');
Memo1.Lines.Add('le vigneron|der Rebbauer');
Memo1.Lines.Add('la vigneronne|die Rebb'+char(ae)+'uerin');
Memo1.Lines.Add('l''ing'+char(egu)+'nieur|der Ingenieur');
Memo1.Lines.Add('le ma'+char(cedi)+'on|der Maurer');
Memo1.Lines.Add('la ma'+char(cedi)+'onne|die Maurerin');
Memo1.Lines.Add('le menuisier|der Schreiner');
Memo1.Lines.Add('la menuisi'+char(egra)+'re|die Schreinerin');
Memo1.Lines.Add('le charpentier[]la charpenti'+char(egra)+'re|der Zimmermann[]die Zimmerin');
Memo1.Lines.Add('l'''+char(egu)+'lectricien|der Elektriker');
Memo1.Lines.Add('l'''+char(egu)+'lectricienne|die Elektrikerin');
Memo1.Lines.Add('le m'+char(egu)+'canicien|der Mechaniker');
Memo1.Lines.Add('la m'+char(egu)+'canicienne|die Mechanikerin');
Memo1.Lines.Add('le dessinateur|der Zeichner');
Memo1.Lines.Add('la dessinatrice|die Zeichnerin');
Memo1.Lines.Add('l''hôtelier[]l''hôteli'+char(egra)+'re|der Hotelier');
Memo1.Lines.Add('le serveur|der Kellner');
Memo1.Lines.Add('la serveuse|die Kellnerin');
Memo1.Lines.Add('le moniteur|der Leiter');
Memo1.Lines.Add('la monitrice|die Leiterin');
Memo1.Lines.Add('la blanchisseuse|die W'+char(ae)+'scherin');
Memo1.Lines.Add('l''employ'+char(egu)+' de banque|der Bankangestellte');
Memo1.Lines.Add('l''employ'+char(egu)+'e de banque|die Bankangestellte');
Memo1.Lines.Add('le secr'+char(egu)+'taire|der Sekret'+char(ae)+'r');
Memo1.Lines.Add('la secr'+char(egu)+'taire|die Sekret'+char(ae)+'rin');
Memo1.Lines.Add('l''informaticien|der Informatiker');
Memo1.Lines.Add('l''informaticienne|die Informatikerin');
Memo1.Lines.Add('le chômeur|der Arbeitslose');
Memo1.Lines.Add('la chômeuse|die Arbeitslose');
Memo1.Lines.Add('le m'+char(egu)+'decin|der Arzt');
Memo1.Lines.Add('le dentiste|der Zahnarzt');
Memo1.Lines.Add('l''assistante m'+char(egu)+'dicale|Medizinische Praxisassistentin');
Memo1.Lines.Add('l''infirmier|der Krankenpfleger');
Memo1.Lines.Add('l''infirmi'+char(egra)+'re|die Krankenschwester');
Memo1.Lines.Add('l''agriculture|die Landschaft');
Memo1.Lines.Add('le champ|das Feld');
Memo1.Lines.Add('la b'+char(ee)+'te|das Tier');
Memo1.Lines.Add('la vigne|die Rebe');
Memo1.Lines.Add('arroser|giessen');
Memo1.Lines.Add('cultiver|pflanzen[]kultivieren');
Memo1.Lines.Add('produire|produzieren');
Memo1.Lines.Add('l''industrie|die Industrie');
Memo1.Lines.Add('l''atelier|die Werkstatt');
Memo1.Lines.Add(''+char(egu)+'lectrique|elektrisch');
Memo1.Lines.Add('r'+char(egu)+'parer|reparieren');
Memo1.Lines.Add('le tourisme|der Tourismus');
Memo1.Lines.Add('l''hôtel|das Hotel');
Memo1.Lines.Add('la boisson|das Getr'+char(ae)+'nk');
Memo1.Lines.Add('commander|bestellen');
Memo1.Lines.Add('le cours|der Kurs');
Memo1.Lines.Add('accompagner|begleiten');
Memo1.Lines.Add('skier|Ski fahren');
Memo1.Lines.Add('les travaux m'+char(egu)+'nager|die Hausaltarbeit');
Memo1.Lines.Add('le linge|die W'+char(ae)+'sche');
Memo1.Lines.Add('s'+char(egu)+'cher|trocknen');
Memo1.Lines.Add('repasser|b'+char(ue)+'geln');
Memo1.Lines.Add('l''int'+char(egu)+'rieur|das Innere');
Memo1.Lines.Add('l''ext'+char(egu)+'rieur|das Äussere');
Memo1.Lines.Add(''+char(ai)+' l''int'+char(egu)+'rieur|drinnen');
Memo1.Lines.Add(''+char(ai)+' l''ext'+char(egu)+'rieur|draussen');
Memo1.Lines.Add('le bureau|das B'+char(ue)+'ro');
Memo1.Lines.Add('la banque|die Bank');
//Memo1.Lines.Add('l''employ'+char(egu)+' de banque|die Bankangestellte');
Memo1.Lines.Add('le guichet|der Schalter');
Memo1.Lines.Add('la queue|die Schlange');
Memo1.Lines.Add('le chômage|die Arbeitslosigkeit');
Memo1.Lines.Add('la dent|der Zahn');
Memo1.Lines.Add('le sang|das Blut');
Memo1.Lines.Add('soigner|pflegen');
Memo1.Lines.Add('ne... rien|nichts');
Memo1.Lines.Add('ne... personne|niemand');
Memo1.Lines.Add('ne...jamais|nie');
Memo1.Lines.Add('ne...plus|nicht mehr');
Memo1.Lines.Add('allumer|anz'+char(ue)+'nden');
Memo1.Lines.Add('fumer|rauchen');
Memo1.Lines.Add('savoir|wissen');
Memo1.Lines.Add('heureux[]heureuse|gl'+char(ue)+'cklich');
Memo1.Lines.Add('sale|schmutzig');
Memo1.Lines.Add('important[]importante|wichtig');
Memo1.Lines.Add('plein[]pleine|voll');
Memo1.Lines.Add('retard|Versp'+char(ae)+'tung');
Memo1.Lines.Add('rapidement|schnell');
Memo1.Lines.Add(''+char(ai)+' cause de|wegen');
Memo1.Lines.Add('une histoire|eine Geschichte');
Memo1.Lines.Add('le si'+char(egra)+'cle|das Jahrhundert');
Memo1.Lines.Add('au bout de|am Ende von');
Memo1.Lines.Add('un habitant|ein Bewohner');
Memo1.Lines.Add('la population|die Bev'+char(oe)+'lkerung');
Memo1.Lines.Add('la circulation|der Verkehr');
Memo1.Lines.Add(''+char(egu)+'migrer|auswandern');
Memo1.Lines.Add('occuper|besetzen');
Memo1.Lines.Add('s''occuper de|sich k'+char(ue)+'mmern um');
Memo1.Lines.Add('recevoir|bekommen[]erhalten');
Memo1.Lines.Add('battre|schlagen');
Memo1.Lines.Add('actuellement|heutzutage');
Memo1.Lines.Add('autrefois|fr'+char(ue)+'her[]ehemals');
Memo1.Lines.Add('longtemps|lange');
Memo1.Lines.Add('loin de|weit[]fern');
Memo1.Lines.Add('plaire|gefallen');
Memo1.Lines.Add('quelques|einige[]ein paar');
Memo1.Lines.SaveToFile(path+':20.csv');Memo1.Text:='';end;
Memo1.Text:=''; if not FileExists(path+':21.csv') then begin Memo1.Text:='';
Memo1.Lines.Add('la ville|die Stadt');
Memo1.Lines.Add('la banlieue|der Vorort');
Memo1.Lines.Add('le monument|das Monument[]das Denkmal');
Memo1.Lines.Add('la rue|die Strasse[] (innerorts)');
Memo1.Lines.Add('la rive|das Ufer');
Memo1.Lines.Add('l''habitant[]l''habitante|der Einwohner[]Die Einwohnerin');
Memo1.Lines.Add('habiter|wohnen');
Memo1.Lines.Add('le visiteur[]la visiteuse|der Besucher[]die Besucherin');
Memo1.Lines.Add('la majorit'+char(egu)+'|die Mehrheit');
Memo1.Lines.Add('r'+char(egu)+'sider|residieren[]wohnen');
Memo1.Lines.Add('border|s'+char(ae)+'umen');
Memo1.Lines.Add('longer|entlang gehen[]s'+char(ae)+'umen');
Memo1.Lines.Add('arriver|ankommen');
Memo1.Lines.Add('monter|einsteigen');
Memo1.Lines.Add('un avion|ein Flugzeug');
Memo1.Lines.Add('la voiture|das Auto');
Memo1.Lines.Add('un autocar|ein Autocar');
Memo1.Lines.Add('partir|verreisen[]abreisen');
Memo1.Lines.Add('descendre|aussteigen');
Memo1.Lines.Add('le train|der Zug');
Memo1.Lines.Add('le bateau|das Schiff');
Memo1.Lines.Add('l''autobus|der Autobus');
Memo1.Lines.Add('la camionnette|der Lieferwagen');
Memo1.Lines.Add('le parking|der Parkplatz[]das Parkhaus');
Memo1.Lines.Add('le permis|der Ausweis[]die Bewilligung');
Memo1.Lines.Add('se d'+char(egu)+'placer|sich fortbewegen');
Memo1.Lines.Add('stationner|parkieren');
Memo1.Lines.Add('s''arr'+char(ee)+'ter|anhalten');
Memo1.Lines.Add('relier '+char(ai)+'|verbinden mit');
Memo1.Lines.Add('un a'+char(egu)+'roport|ein Flughafen');
Memo1.Lines.Add('international[]internationale|international');
Memo1.Lines.Add('national[]nationale|national');
Memo1.Lines.Add('la ligne|die Linie');
Memo1.Lines.Add('le train souterrain|der unterirdische Zug');
Memo1.Lines.Add('le m'+char(egu)+'tro|die Untergrundbahn[]die Metro');
Memo1.Lines.Add('rapide|schnell');
Memo1.Lines.Add('le moyen de transport|das Transportmittel');
Memo1.Lines.Add('demander le chemin|nach dem Weg fragen');
Memo1.Lines.Add('indiquer le chemin|den Weg zeigen[]erkl'+char(ae)+'ren');
Memo1.Lines.Add('le carrefour|die Kreuzung');
Memo1.Lines.Add('l''escalier|die Treppe');
Memo1.Lines.Add('la direction|die Richtung');
Memo1.Lines.Add('le sens|der Sinn[]die Richtung');
Memo1.Lines.Add('la liaison|die Verbindung');
Memo1.Lines.Add('passer|vorbeigehen');
Memo1.Lines.Add('traverser|'+char(ue)+'berqueren');
Memo1.Lines.Add('rouler|fahren[]rollen');
Memo1.Lines.Add('aller tout droit|geradeaus gehen');
Memo1.Lines.Add('tourner|wenden[]abbiegen');
Memo1.Lines.Add('se diriger vers la ville|auf die Stadt zugehen');
Memo1.Lines.Add('autour de|um ... herum');
Memo1.Lines.Add('loin|entfernt');
Memo1.Lines.Add('le plombier|der Klempner[]die Klempnerin');
Memo1.Lines.Add('une entreprise|ein Unternehmen');
Memo1.Lines.Add('le chauffage|die Heizung');
Memo1.Lines.Add('le voleur|der Dieb[]die Diebin');
Memo1.Lines.Add('voler|stehlen');

Memo1.Lines.Add('le t'+char(egu)+'moin|der Zeuge[]die Zeugin');
Memo1.Lines.Add('le portrait robot|das Phantombild');
Memo1.Lines.Add('le gardien|der W'+char(ae)+'chter[]die W'+char(ae)+'chterin');
Memo1.Lines.Add('le complice|der Komplize[]die Komplizin');
Memo1.Lines.Add('disparaître|verschwinden');
Memo1.Lines.Add('paraître|erscheinen[]scheinen');
Memo1.Lines.Add('arr'+char(ee)+'ter|verhaften');
Memo1.Lines.Add('signaler|anzeigen[]melden');
Memo1.Lines.Add('suspecter|verd'+char(ae)+'chtigen');
Memo1.Lines.Add('poursuivre|verfolgen');
Memo1.Lines.Add('la taille|die Gr'+char(oe)+'sse');
Memo1.Lines.Add('pr'+char(egu)+'ciser|genau angeben[]bestimmen');
Memo1.Lines.Add('mesurer|messen');
Memo1.Lines.Add('le crâne ras'+char(egu)+'|der rasierte Sch'+char(ae)+'del');
Memo1.Lines.Add('mince|schlank');
Memo1.Lines.Add('corpulent[]corpulente|fest[]korpulent');
Memo1.Lines.Add('rond[]ronde|rund');
Memo1.Lines.Add('ovale|oval');
Memo1.Lines.Add('la joue|die Wange');
Memo1.Lines.Add('la cicatrice|die Narbe');
Memo1.Lines.Add('le bleu de travail|der Arbeitsanzug');
Memo1.Lines.Add('la boucle d''oreille|der Ohrring');
Memo1.Lines.Add('plutôt|eher');
Memo1.Lines.Add('la r'+char(egu)+'ception|der Empfang');
Memo1.Lines.Add('le concierge[]la concierge|der Hauswart[]die Hausw'+char(ae)+'rterin[]der Pf'+char(oe)+'rtner[]die Pf'+char(oe)+'rtnerin');
Memo1.Lines.Add('le renseignement|die Auskunft');
Memo1.Lines.Add('une excursion|der Ausflug');
Memo1.Lines.Add('finalement|endlich');
Memo1.Lines.Add('malheureusement|ungl'+char(ue)+'cklicherweise');
Memo1.Lines.Add('brusquement|br'+char(ue)+'sk[]pl'+char(oe)+'tzlich');
Memo1.Lines.Add('tout de suite|sofort');
Memo1.Lines.Add('malgr'+char(egu)+'|trotz');
Memo1.Lines.SaveToFile(path+':21.csv');Memo1.Text:='';end;
Memo1.Text:=''; if not FileExists(path+':22.csv') then begin Memo1.Text:='';
Memo1.Lines.Add('la publicit'+char(egu)+'[]la pub|die Werbung');
Memo1.Lines.Add('le cin'+char(egu)+'ma|das Kino');
Memo1.Lines.Add('le journal[] (pl. les – aux)|die Zeitung');
Memo1.Lines.Add('avoir envie de qc.|auf etw. Lust haben');
Memo1.Lines.Add('publicitaire|Werbe...');
Memo1.Lines.Add('le public|die Öffentlichkeit[]das Publikum');
Memo1.Lines.Add('les m'+char(egu)+'dias|die Medien');
Memo1.Lines.Add('la t'+char(egu)+'l'+char(egu)+'vision|das Fernsehen');
Memo1.Lines.Add('le magazine|die Zeitschrift');
Memo1.Lines.Add('une affiche|ein Plakat');
Memo1.Lines.Add('une enseigne lumineuse|eine Leuchtreklame');
Memo1.Lines.Add('varier|variieren[]abwechseln');
Memo1.Lines.Add('attirer|anziehen');
Memo1.Lines.Add(''+char(ai)+' travers|durch[]mittels');
Memo1.Lines.Add('l''attention|die Aufmerksamkeit');
Memo1.Lines.Add('la promesse|das Versprechen');
Memo1.Lines.Add('une '+char(egu)+'motion|eine Gem'+char(ue)+'tsregung');
Memo1.Lines.Add(''+char(egu)+'motionnel[]'+char(egu)+'motionnelle|emotional');
Memo1.Lines.Add('l''humour|der Humor');
Memo1.Lines.Add('la suggestion|die Anregung');
Memo1.Lines.Add('la beaut'+char(egu)+'|die Sch'+char(oe)+'nheit');
Memo1.Lines.Add('r'+char(ee)+'ver|tr'+char(ae)+'umen');
Memo1.Lines.Add('une information|eine Information');
Memo1.Lines.Add('informatif[]informative|informativ');
Memo1.Lines.Add('vendre|verkaufen');
Memo1.Lines.Add('la diff'+char(egu)+'rence|der Unterschied');
Memo1.Lines.Add('la promotion|die F'+char(oe)+'rderung[]die Verkaufsf'+char(oe)+'rderung');
Memo1.Lines.Add('la vente|der Verkauf');
Memo1.Lines.Add('augmenter|erh'+char(oe)+'hen[]steigen');
Memo1.Lines.Add('un effet de surprise|ein Überraschungseffekt');
Memo1.Lines.Add('inspirer|inspirieren[]ansprechen');
Memo1.Lines.Add('le sondage|die Umfrage');
Memo1.Lines.Add('le secret|das Geheimnis');
Memo1.Lines.Add('la ressemblance|die Ähnlichkeit');
Memo1.Lines.Add('ressembler '+char(ai)+'|'+char(ae)+'hnlich sein');
Memo1.Lines.Add('semblable|'+char(ae)+'hnlich');
Memo1.Lines.Add(''+char(egu)+'quivalent[]'+char(egu)+'quivalente|gleichwertig');
Memo1.Lines.Add('g'+char(egu)+'nial[]g'+char(egu)+'niale|genial');
Memo1.Lines.Add('magnifique|wunderbar');
Memo1.Lines.Add('stupide|dumm[]bl'+char(oe)+'d');
Memo1.Lines.Add('mauvais[]mauvaise|schlecht');
Memo1.Lines.Add('une appr'+char(egu)+'ciation|eine Wertsch'+char(ae)+'tzung[]eine W'+char(ue)+'rdigung');
Memo1.Lines.Add('appr'+char(egu)+'cier|sch'+char(ae)+'tzen[]w'+char(ue)+'rdigen');
Memo1.Lines.Add('une opinion|eine Meinung');
Memo1.Lines.Add('croire|glauben');
Memo1.Lines.Add('selon moi|meines Erachtens');
Memo1.Lines.Add(''+char(ee)+'tre convaincu[]'+char(ee)+'tre convaincue|'+char(ue)+'berzeugt sein');
Memo1.Lines.Add(''+char(ai)+' mon goût|nach meinem Geschmack');
Memo1.Lines.Add(''+char(ai)+' mon avis|meiner Meinung nach');
Memo1.Lines.Add('sans aucun doute|ohne jeden Zweifel');
Memo1.Lines.Add('l''efficacit'+char(egu)+'|die Wirksamkeit[]die Effizienz[] (f.) ');
Memo1.Lines.Add('efficace|wirksam[]effizient');
Memo1.Lines.Add('irr'+char(egu)+'sistible|unwiderstehlich');
Memo1.Lines.Add('superbe|grossartig');
Memo1.Lines.Add('merveilleux[]merveilleuse|prachtvoll');
Memo1.Lines.Add('attractif[]attractive|attraktiv[]anziehend');
Memo1.Lines.Add('attrayant[]attrayante|anziehend');
Memo1.Lines.Add(''+char(egu)+'mouvant[]'+char(egu)+'mouvante|bewegend');
Memo1.Lines.Add('sensible|empf'+char(ae)+'nglich[]sensibel');
Memo1.Lines.Add('subtil[]subtile|subtil[]scharfsinnig');
Memo1.Lines.Add('catastrophique|katastrophal');
Memo1.Lines.Add('repoussant[]repoussante|abstossend[]schrecklich');
Memo1.Lines.Add('le sommet|der Gipfel');
Memo1.Lines.Add('la montagne|der Berg');
Memo1.Lines.Add('le monde|die Welt');
Memo1.Lines.Add('la terre|die Erde');
Memo1.Lines.Add('la chaîne|die Kette');
Memo1.Lines.Add('l''altitude|die H'+char(oe)+'he');
Memo1.Lines.Add('le fleuve|der Strom');
Memo1.Lines.Add(''+char(egu)+'tendu[]'+char(egu)+'tendue|ausgedehnt[]weit');
Memo1.Lines.Add('partout|'+char(ue)+'berall');
Memo1.Lines.Add('entourer|umgeben');
Memo1.Lines.Add('le proverbe|das Sprichwort');
Memo1.Lines.Add('une exception|eine Ausnahme');
Memo1.Lines.Add('confirmer|best'+char(ae)+'tigen');
Memo1.Lines.Add('exister|existieren[]bestehen');
Memo1.Lines.Add('une impression|ein Eindruck');
Memo1.Lines.Add('le support|der Tr'+char(ae)+'ger[]die St'+char(ue)+'tze');
Memo1.Lines.Add('le cin'+char(egu)+'aste|der Filmemacher[]die Filmemacherin');
Memo1.Lines.Add('le r'+char(egu)+'alisateur[]la r'+char(egu)+'alisatrice|der Regisseur[]die Regisseurin');
Memo1.Lines.Add('la rentr'+char(egu)+'e scolaire|der Schulbeginn');
Memo1.Lines.Add('davantage|mehr');
Memo1.Lines.Add('certain[]sûr[]sûre[]certaine|sicher');
Memo1.Lines.Add('fier[]fi'+char(egra)+'re|stolz');
Memo1.Lines.Add('attentivement|aufmerksam');
Memo1.Lines.Add(''+char(egu)+'galement|ebenfalls');
Memo1.Lines.Add('la langue maternelle|die Muttersprache');
Memo1.Lines.Add('chacun[]chacune|jeder[]jede[]jedes');
Memo1.Lines.Add('celui-ci[]celle-ci[] (pl. ceux-ci, celles-ci) |dieser da[]diese da[]dieses da');
Memo1.Lines.Add('celui-l'+char(ai)+'[]celle-l'+char(ai)+'[] (pl. ceux-l'+char(ai)+', celles-l'+char(ai)+') |dieser hier[]diese hier[]dieses hier');
Memo1.Lines.SaveToFile(path+':22.csv');Memo1.Text:='';end;
Memo1.Text:=''; if not FileExists(path+':23.csv') then begin Memo1.Text:='';
Memo1.Lines.Add('les anc'+char(ee)+'tres|die Vorfahren');
Memo1.Lines.Add('la recherche|die Forschung');
Memo1.Lines.Add('l''invention|die Erfindung');
Memo1.Lines.Add('l''inventeur[]l''inventrice|der Erfinder[]die Erfinderin');
Memo1.Lines.Add('inventer|erfinden');
Memo1.Lines.Add('se d'+char(egu)+'velopper|sich entwickeln');
Memo1.Lines.Add('d'+char(egu)+'couvrir|entdecken');
Memo1.Lines.Add('la d'+char(egu)+'couverte|die Entdeckung');
Memo1.Lines.Add('consid'+char(egu)+'rer|betrachten[]finden');
Memo1.Lines.Add(''+char(ee)+'tre n'+char(egu)+'[]'+char(ee)+'tre n'+char(egu)+'e|geboren sein');
Memo1.Lines.Add('s''occuper de|sich k'+char(ue)+'mmern um');
Memo1.Lines.Add(''+char(ee)+'tre mort[]'+char(ee)+'tre morte|tot sein');
Memo1.Lines.Add('d'+char(egu)+'c'+char(egu)+'d'+char(egu)+'[]d'+char(egu)+'c'+char(egu)+'d'+char(egu)+'e|gestorben');
Memo1.Lines.Add('la partie|der Teil');
Memo1.Lines.Add('signifier|bedeuten');
Memo1.Lines.Add('marquer le d'+char(egu)+'but de|der Anfang sein von');
Memo1.Lines.Add('une '+char(egu)+'poque|eine Epoche[]eine Zeit');
Memo1.Lines.Add('l''ing'+char(egu)+'nieur|der Ingenieur[]die Ingenieurin');
Memo1.Lines.Add('construire|bauen');
Memo1.Lines.Add('la science|die Wissenschaft');
Memo1.Lines.Add('le scientifique[]la scientifique|der Wissenschaftler[]die Wissenschaftlerin');
Memo1.Lines.Add('le physicien[]la physicienne|der Physiker[]die Physikerin');
Memo1.Lines.Add('le chimiste[]la chimiste|der Chemiker[]die Chemikerin');
Memo1.Lines.Add('le biologiste[]la biologiste|der Biologe[]die Biologin');
Memo1.Lines.Add('l''apparition|das Erscheinen[]das Auftreten');
Memo1.Lines.Add('la t'+char(egu)+'l'+char(egu)+'communication|die Telekommunikation');
Memo1.Lines.Add('la t'+char(egu)+'l'+char(egu)+'commande|die Fernbedienung');
Memo1.Lines.Add('r'+char(egu)+'soudre|l'+char(oe)+'sen[]aufl'+char(oe)+'sen');
Memo1.Lines.Add('provenir de|herkommen von');
Memo1.Lines.Add('le t'+char(egu)+'l'+char(egu)+'graphe|der Fernschreiber[]der Telegraf');
Memo1.Lines.Add('envoyer|senden[]schicken');
Memo1.Lines.Add('le message|die Botschaft[]die Nachricht');
Memo1.Lines.Add('le messager|der Bote');
Memo1.Lines.Add('la transmission|die Übermittlung');
Memo1.Lines.Add('transmettre|'+char(ue)+'bermitteln[]'+char(ue)+'bertragen');
Memo1.Lines.Add('le signal[] (pl. les signaux) |das Signal[]das Zeichen');
Memo1.Lines.Add('identique|gleich[]identisch');
Memo1.Lines.Add('le fil|der Faden[]der Draht');
Memo1.Lines.Add('le fer|das Eisen');
Memo1.Lines.Add('le cuivre|das Kupfer');
Memo1.Lines.Add('le courant|der Strom[]die Str'+char(oe)+'mung');
Memo1.Lines.Add('une impulsion|ein Impuls[]ein Stromstoss');
Memo1.Lines.Add('l''amplificateur|der Verst'+char(ae)+'rker');
Memo1.Lines.Add('renforcer|verst'+char(ae)+'rken');
Memo1.Lines.Add('la touche|die Taste');
Memo1.Lines.Add('appuyer sur|dr'+char(ue)+'cken auf[]pressen auf');
Memo1.Lines.Add('imprimer|drucken');
Memo1.Lines.Add('combiner|kombinieren[]zusammensetzen');
Memo1.Lines.Add('la combinaison|die Kombination[]die Zusammensetzung');
Memo1.Lines.Add('le trait|der Strich[]die Linie');
Memo1.Lines.Add('circuler|zirkulieren[]umlaufen');
Memo1.Lines.Add('grâce '+char(ai)+'|dank');
Memo1.Lines.Add('l'''+char(egu)+'couteur|der H'+char(oe)+'rer');
Memo1.Lines.Add('le microphone|das Mikrophon');
Memo1.Lines.Add('la sonnerie|das Klingeln');
Memo1.Lines.Add('le r'+char(egu)+'cepteur|der H'+char(oe)+'rer[]das Empfangsger'+char(ae)+'t');
Memo1.Lines.Add('le haut-parleur|der Lautsprecher');
Memo1.Lines.Add('les frais|die Kosten[]die Spesen');
Memo1.Lines.Add('atteignable|erreichbar');
Memo1.Lines.Add('la tranquillit'+char(egu)+'|die Ruhe');
Memo1.Lines.Add('une urgence|eine Dringlichkeit[]ein Notfall');
Memo1.Lines.Add('contacter|Kontakt aufnehmen');
Memo1.Lines.Add('agir|handeln');
Memo1.Lines.Add('bâtir|bauen');
Memo1.Lines.Add('blanchir|weissen[]bleichen');
Memo1.Lines.Add('convertir|umwandeln[]konvertieren[]umrechnen');
Memo1.Lines.Add('d'+char(egu)+'finir|bestimmen');
Memo1.Lines.Add('d'+char(egu)+'molir|zerst'+char(oe)+'ren[]niederreissen');
Memo1.Lines.Add('faiblir|schwach werden');
Memo1.Lines.Add('finir|beenden[]fertig machen');
Memo1.Lines.Add('maigrir|abnehmen');
Memo1.Lines.Add('pâlir|bleich werden[]erbleichen');
Memo1.Lines.Add('punir|strafen[]bestrafen');
Memo1.Lines.Add('r'+char(egu)+'agir|reagieren');
Memo1.Lines.Add('r'+char(egu)+'fl'+char(egu)+'chir|'+char(ue)+'berlegen[]nachdenken');
Memo1.Lines.Add('se r'+char(egu)+'jouir de|sich freuen '+char(ue)+'ber');
Memo1.Lines.Add('r'+char(egu)+'unir|Vereinigen[]zusammenf'+char(ue)+'hren');
Memo1.Lines.Add('r'+char(egu)+'ussir|gelingen[]Erfolg haben');
Memo1.Lines.Add('suffire|gen'+char(ue)+'gen');
Memo1.Lines.Add('vieillir|altern[]alt werden');
Memo1.Lines.Add('l''humanit'+char(egu)+'|die Menschlichkeit');
Memo1.Lines.Add('humain[]humaine|menschlich');
Memo1.Lines.Add('se d'+char(egu)+'brouiller|sich zu helfen wissen');
Memo1.Lines.Add('quotidien[]quotidienne|t'+char(ae)+'glich');
Memo1.Lines.Add('injuste[] (m. et f. (adj.)) |ungerecht');
Memo1.Lines.Add('inutile[] (m. et f. (adj.)) |unn'+char(ue)+'tz[]nutzlos');
Memo1.Lines.Add('le baladeur|der Walkman');
Memo1.Lines.Add('la bougie|die Kerze');
Memo1.Lines.Add('la lumi'+char(egra)+'re|das Licht');
Memo1.Lines.Add('allumer|anz'+char(ue)+'nden[]einschalten');
Memo1.Lines.SaveToFile(path+':23.csv');Memo1.Text:='';end;
Memo1.Text:=''; if not FileExists(path+':24.csv') then begin Memo1.Text:='';
Memo1.Lines.Add('le journaliste|der Journalist');
Memo1.Lines.Add('l''article|der Artikel[]der Zeitungsartikel');
Memo1.Lines.Add('une annonce|eine Anzeige[]eine Annonce');
Memo1.Lines.Add('journalistique|journalistisch');
Memo1.Lines.Add('r'+char(egu)+'diger|verfassen[]redigieren');
Memo1.Lines.Add('le reportage|die Reportage');
Memo1.Lines.Add(''+char(ai)+' l''int'+char(egu)+'rieur|drinnen');
Memo1.Lines.Add('le titre|der Titel');
Memo1.Lines.Add('le gros titre|die Schlagzeile');
Memo1.Lines.Add('la publication|die Ver'+char(oe)+'ffentlichung');
Memo1.Lines.Add('la rubrique|die Rubrik');
Memo1.Lines.Add('traiter|behandeln[]verarbeiten');
Memo1.Lines.Add('le sport|der Sport');
Memo1.Lines.Add('le monde|die Welt');
Memo1.Lines.Add('l''immeuble|der Wohnblock');
Memo1.Lines.Add('l''image|das Bild');
Memo1.Lines.Add('l'''+char(egu)+'conomie|die Wirtschaft');
Memo1.Lines.Add('la politique|die Politik');
Memo1.Lines.Add('la m'+char(egu)+'t'+char(egu)+'o|der Wetterbericht');
Memo1.Lines.Add('la br'+char(egra)+'ve|die Kurznachricht');
Memo1.Lines.Add('l'''+char(egu)+'v'+char(egu)+'nement|das Ereignis');
Memo1.Lines.Add('l'''+char(egu)+'crivain|der Schriftsteller');
Memo1.Lines.Add('regarder|schauen[]anschauen');
Memo1.Lines.Add('expliquer|erkl'+char(ae)+'ren');
Memo1.Lines.Add('les gens|die Leute');
Memo1.Lines.Add('pr'+char(egu)+'senter|pr'+char(ae)+'sentieren');
Memo1.Lines.Add('la chaîne|die Kette[]der Fernsehkanal');
Memo1.Lines.Add('raconter|erz'+char(ae)+'hlen');
Memo1.Lines.Add('observer|beobachten');
Memo1.Lines.Add('le visiteur[]la visiteuse|der Besucher[]die Besucherin');
Memo1.Lines.Add('ordinaire|gew'+char(oe)+'hnlich');
Memo1.Lines.Add('produire|produzieren');
Memo1.Lines.Add('l'''+char(egu)+'mission|die Sendung');
Memo1.Lines.Add('le programme|das Programm');
Memo1.Lines.Add('l'''+char(egu)+'cran|der Bildschirm');
Memo1.Lines.Add('le producteur[]la productrice|der Produzent[]die Produzentin');
Memo1.Lines.Add('le pr'+char(egu)+'sentateur[]la pr'+char(egu)+'sentatrice|der Ansager[]die Ansagerin[]der Moderator[]die Moderatorin');
Memo1.Lines.Add('l''animateur[]l''animatrice|der Animator[]die Animatorin');
Memo1.Lines.Add('le t'+char(egu)+'l'+char(egu)+'spectateur[]la t'+char(egu)+'l'+char(egu)+'spectatrice|der Fernsehzuschauer[]die Fernsehzuschauerin');
Memo1.Lines.Add('le genre|die Art[]die Gattung');
Memo1.Lines.Add('le divertissement|die Unterhaltung');
Memo1.Lines.Add('se moquer de|sich lustig machen '+char(ue)+'ber');
Memo1.Lines.Add('le spectacle|das Spektakel[]das Schauspiel');
Memo1.Lines.Add('le spectateur[]la spectatrice|der Zuschauer[]die Zuschauerin');
Memo1.Lines.Add('l''organisateur[]l''organisatrice|der Organisator[]die Organisatorin');
Memo1.Lines.Add('la Guerre mondiale|der Weltkrieg');
Memo1.Lines.Add('le succ'+char(egra)+'s|der Erfolg');
Memo1.Lines.Add('grave[] (m. et f. (adj.)) |ernst[]schlimm[]ernsthaft');
Memo1.Lines.Add('important[]importante|wichtig');
Memo1.Lines.Add('int'+char(egu)+'ressant[]int'+char(egu)+'ressante|interessant');
Memo1.Lines.Add(''+char(egu)+'tonnant[]'+char(egu)+'tonnante|erstaunlich');
Memo1.Lines.Add('surprenant[]surprenante|'+char(ue)+'berraschend');
Memo1.Lines.Add('ennuyeux[]ennuyeuse|langweilig');
Memo1.Lines.Add('amusant[]amusante|am'+char(ue)+'sant[]lustig');
Memo1.Lines.Add('drôle|komisch[]lustig');
Memo1.Lines.Add('terrible|schrecklich[]furchtbar');
Memo1.Lines.Add('essentiel[]essentielle|wesentlich[]Haupt...');
Memo1.Lines.Add('passionnant[]passionnante|spannend[]aufregend');
Memo1.Lines.Add('sans int'+char(egu)+'r'+char(ee)+'t|uninteressant');
Memo1.Lines.Add('le journal[] (pl. les journaux)|die Zeitung');
Memo1.Lines.Add('national[]nationale[] (m. pl. nationaux) |national[]Landes...');
Memo1.Lines.Add('paraître|erscheinen[]scheinen');
Memo1.Lines.Add('l''opinion|die Meinung');
Memo1.Lines.Add('l''illustr'+char(egu)+'|die illustrierte Zeitschrift');
Memo1.Lines.Add('la revue|die Zeitschrift[]die Fachzeitschrift');
Memo1.Lines.Add('le quotidien|die Tageszeitung');
Memo1.Lines.Add('l''hebdomadaire|die Wochenzeitschrift');
Memo1.Lines.Add('r'+char(egu)+'gional[]r'+char(egu)+'gionale[] (m. pl. r'+char(egu)+'gionaux) |regional');
Memo1.Lines.Add('local[]locale[] (m. pl. locaux) |lokal[]'+char(oe)+'rtlich[]Orts...');
Memo1.Lines.Add('l'''+char(egu)+'ditorial|der Leitartikel');
Memo1.Lines.Add('la une|die Titelseite');
Memo1.Lines.Add('le chapeau|der Vorspann');
Memo1.Lines.Add('la caricature|die Karikatur');
Memo1.Lines.SaveToFile(path+':24.csv');Memo1.Text:='';end;


Memo1.Lines.SaveToFile(path+':fehler_1.csv');
Memo1.Lines.SaveToFile(path+':fehler_2.csv');
Memo1.Lines.SaveToFile(path+':fehler_3.csv');
Memo1.Lines.SaveToFile(path+':fehler_4.csv');
Memo1.Lines.SaveToFile(path+':fehler_5.csv');
Memo1.Lines.SaveToFile(path+':fehler_6.csv');
Memo1.Lines.SaveToFile(path+':fehler_7.csv');
Memo1.Lines.SaveToFile(path+':fehler_8.csv');
Memo1.Lines.SaveToFile(path+':fehler_9.csv');
Memo1.Lines.SaveToFile(path+':fehler_10.csv');
Memo1.Lines.SaveToFile(path+':fehler_11.csv');
Memo1.Lines.SaveToFile(path+':fehler_12.csv');
Memo1.Lines.SaveToFile(path+':fehler_13.csv');
Memo1.Lines.SaveToFile(path+':fehler_14.csv');
Memo1.Lines.SaveToFile(path+':fehler_15.csv');
Memo1.Lines.SaveToFile(path+':fehler_16.csv');
Memo1.Lines.SaveToFile(path+':fehler_17.csv');
Memo1.Lines.SaveToFile(path+':fehler_18.csv');
Memo1.Lines.SaveToFile(path+':fehler_19.csv');
Memo1.Lines.SaveToFile(path+':fehler_20.csv');
Memo1.Lines.SaveToFile(path+':fehler_21.csv');
Memo1.Lines.SaveToFile(path+':fehler_22.csv');
Memo1.Lines.SaveToFile(path+':fehler_23.csv');
Memo1.Lines.SaveToFile(path+':fehler_24.csv');

Memo1.Lines.SaveToFile(FileName);
Memo1.Lines.SaveToFile(FileCache);
ini:=TIniFile.create(path+':install.ini');
ini.WriteString('Installation','Installed','1');
Button2.Caption:='Deinstallieren';
ini.Free;
if paramstr(1) = 'Update' then showMessage('Update Erfolgreich installiert!')
 else begin//showMessage('Installation beendet!'+#13+'Hinweis: Du kannst diese Datei jederzeit verschieben :)');
        end;

installed:='1';exit;
end;

if installed = '1' then begin
 

DeleteFile(path+':1.csv');
DeleteFile(path+':2.csv');
DeleteFile(path+':3.csv');
DeleteFile(path+':4.csv');
DeleteFile(path+':5.csv');
DeleteFile(path+':6.csv');
DeleteFile(path+':7.csv');
DeleteFile(path+':8.csv');
DeleteFile(path+':9.csv');
DeleteFile(path+':10.csv');
DeleteFile(path+':11.csv');
DeleteFile(path+':12.csv');
DeleteFile(path+':13.csv');
DeleteFile(path+':14.csv');
DeleteFile(path+':15.csv');
DeleteFile(path+':16.csv');
DeleteFile(path+':17.csv');
DeleteFile(path+':18.csv');
DeleteFile(path+':19.csv');
DeleteFile(path+':20.csv');
DeleteFile(path+':21.csv');
DeleteFile(path+':22.csv');
DeleteFile(path+':23.csv');
DeleteFile(path+':24.csv');
DeleteFile(path+':fehler_0.csv');
DeleteFile(path+':fehler_1.csv');
DeleteFile(path+':fehler_2.csv');
DeleteFile(path+':fehler_3.csv');
DeleteFile(path+':fehler_4.csv');
DeleteFile(path+':fehler_5.csv');
DeleteFile(path+':fehler_6.csv');
DeleteFile(path+':fehler_7.csv');
DeleteFile(path+':fehler_8.csv');
DeleteFile(path+':fehler_9.csv');
DeleteFile(path+':fehler_10.csv');
DeleteFile(path+':fehler_11.csv');
DeleteFile(path+':fehler_12.csv');
DeleteFile(path+':fehler_13.csv');
DeleteFile(path+':fehler_14.csv');
DeleteFile(path+':fehler_15.csv');
DeleteFile(path+':fehler_16.csv');
DeleteFile(path+':fehler_17.csv');
DeleteFile(path+':fehler_18.csv');
DeleteFile(path+':fehler_19.csv');
DeleteFile(path+':fehler_20.csv');
DeleteFile(path+':fehler_21.csv');
DeleteFile(path+':fehler_22.csv');
DeleteFile(path+':fehler_23.csv');
DeleteFile(path+':fehler_24.csv');
DeleteFile(GetSpecialFolder(Handle, CSIDL_DESKTOPDIRECTORY)+'\Cadac.lnk');
DeleteFile(path+':Datei.csv');DeleteFile(path+':cache.csv');DeleteFile(path);
Button2.Caption:='Installieren';
if DeleteDir(GetSpecialFolder(Handle, CSIDL_PERSONAL)+'\Cadac') then begin
if paramstr(1) <> 'Update' then begin showmessage('Deinstallation erfolgreich!'); end;

end;

 installed:='0'; exit;
end;
end;
procedure TForm1.Button3Click(Sender: TObject);
begin
showmessage (
'Envol Pr'+char(egu)+'lude:                  Envol 7:             Envol 8:       '
 +#13+  ''
+#13+'Lektion 1 = 1              Lektion 1 =  9        Lektion   9 = 17'
+#13+'Lektion 2 = 2              Lektion 2 = 10       Lektion 10 = 18'
+#13+'Lektion 3 = 3              Lektion 3 = 11       Lektion 11 = 19'
+#13+'Lektion 4 = 4              Lektion 4 = 12       Lektion 12 = 20'
+#13+'Lektion 5 = 5              Lektion 5 = 13       Lektion 13 = 21'
+#13+'Lektion 6 = 6              Lektion 6 = 14       Lektion 14 = 22'
+#13+'Lektion 7 = 7              Lektion 7 = 15       Lektion 15 = 23'
+#13+'Lektion 8 = 8              Lektion 8 = 16       Lektion 16 = 24'

+#13+  ''

);
end;

end.
