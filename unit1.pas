unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, XPMan,
  ShlObj, SHFolder,WinInet,    ComObj,    
  jpeg, IniFiles, ShellApi, UrlMon, Activex, Registry, ComCtrls, ActnList, DB,
  ADODB;

    type db = record
       lektion:String;
       ID: string;
       Franz: string;
       Deutsch: string;
       Fehler: string;
     end;
     type voci = Array of db;
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
    ado: TADOTable;
    Timer1: TTimer;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private-Deklarationen }
    showupdate:BOolean;
  public
    { Public-Deklarationen }
    FileName:String;
    FileCache,lockm:String;
    Path, installed:String;
    ischanged,lock,lock2:Boolean;
    from,tom,max:Integer;
    h,w,t,l:Integer;
    Name,lng:String;
    vocis:voci;
    VersionNr : Integer;
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
     Unit7, Unit8,  Unit10, Unit11, Unit12, Unit9;
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
    str: TStringlist;
    a,b: String;
    z,u,z2,i2: Integer;
begin

if lock then   begin  showmessage(lockm); exit; end;
if lock2 then   begin  showmessage(lockm); end;
statictext4.Caption:='';
statictext4.Height:=0;
DeleteFile(FileName);
DeleteFile(FileCache);

if installed = '0' then begin showmessage('Zuerst installieren!'); exit; end;

if ((Edit1.Text = '') OR (Edit2.Text = '')) or (strtoint(Edit2.Text) < strtoint(Edit1.Text)) then
  begin
    showmessage('Bitte w'+char(ae)+'hle die Lektionen aus!'+#10+'Bsp: von 1 bis 3'+#10+'(Kleinere zuerst)');
  exit;
  end;

if CheckBox1.Checked = false then  begin
str := TStringList.Create;

for i2 := 0 to high(vocis) do begin
  if  (strtoint(vocis[i2].lektion) >= strtoint(edit1.text)) and(strtoint(vocis[i2].lektion) <= strtoint(edit2.text)) then begin
  str.add(Vocis[i2].Franz+'|'+Vocis[i2].Deutsch+'|'+Vocis[i2].Lektion+'|'+Vocis[i2].Fehler+'|'+Vocis[i2].ID);
  end;
end;
//showmessage(str.text);exit;

//exit;
//asl.Free;
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
  //tmp.Free;
end;

if CheckBox1.Checked = true then  begin
str := TStringList.Create;

                for i2 := 0 to high(vocis) do
    if (strtoint(edit1.text)<=strtoint(vocis[i2].lektion))  and
       (strtoint(vocis[i2].lektion) <= strtoint(edit2.text))then begin
    if strtoint(Vocis[i2].Fehler)>0 then
    str.add(Vocis[i2].Franz+'|'+Vocis[i2].Deutsch+'|'+Vocis[i2].Lektion+'|'+Vocis[i2].Fehler+'|'+Vocis[i2].ID);
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
 // tmp.Free;
end;

str:=TStringlist.Create;
str.LoadFromFile(FileName);
str:=clearstlist(str);
if (str.Text = '')or(str.count=0)or(StringReplace(str.Text, #13, '', [rfReplaceAll]) = '') then begin
  showmessage('Keine W'+char(oe)+'rter in der/den ausgew'+char(ae)+'hlten Lektion/en!');
  exit;
  exit;
  exit;end;
 // showmessage(str.text);
  str.Free;


  

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
  Form11.Show;
  Hide;
end;
if ComboBox1.Text = 'Deutsch -------> '+lng then begin
  isChanged := False;
  Form9.Top:=Top;
  Form9.Left:=Left;
  Form9.Caption := Name+' [Galerie]';
  Form9.Show;
  Hide;
end;
if ComboBox1.Text = lng+' -------> Deutsch' then begin
  isChanged := true;
  Form9.Top:=Top;
  Form9.Left:=Left;
  Form9.Caption := Name+' [Galerie]';
  Form9.Show;
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
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
     sb:String;
begin
if FileExists(form1.path+'Voci.mdb') then begin
ado.active:=False;
ado.TableName:='settings';
ado.active:=true;
if   CheckBox1.Checked=False then begin sb := '0' end;
if   CheckBox1.Checked=true then begin sb := '1' end;
  ado.edit;
Ado.Next;ado.edit;
ado.fields[3].Value:=Edit1.ItemIndex;Ado.Next;ado.edit;
ado.fields[3].Value:=Edit2.ItemIndex;Ado.Next;ado.edit;
Ado.Next;          ado.edit;
ado.fields[3].AsInteger:=ComBoBox1.ItemIndex;Ado.Next;ado.edit;
ado.fields[3].Value:=sb;

 end;
Form3.Timer3.Enabled:=True;

showMessage('Au revoir!');
end;

procedure TForm1.FormCreate(Sender: TObject);
var
    di,sb,s:String;
    i,i2:Integer;
begin
versionNR:=2;
lock:=False;
lock2:=False;
image1.Parent:=Form1;
h:=height;
w:=width;
lng:='Französisch';
Name:='Cadac';


GetDir(0, s);

Path:=GetSpecialFolder(Handle, CSIDL_PERSONAL)+'\'+Name+'\'+Name+'.txt:';


//Path:=ParamStr(0);
//Path:='C:\WINDOWS\system32\notepad.exe';
FileName:=path+'Datei.csv';
FileCache:=path+'cache.csv';

 if ParamSTr(1) = 'Update' then begin


      if(FileExists(s+'\Up'+Name+'.exe')) then begin
         DeleteFile(s+'\Up'+Name+'.exe');
     end;
showMessage('Update installiert!');
 end;

if FileExists(path+'update.txt' ) then begin deletefile(path+'update.txt'); end else begin end;
if FileExists(form1.path+'Voci.mdb') then
 begin
form1.Ado.ConnectionString:='Provider=Microsoft.Jet.OLEDB.4.0;Data Source='+form1.path+'Voci.mdb;Persist Security Info=False';

ado.active:=False;
ado.TableName:='settings';
ado.active:=true;



VersionNr:=ado.fields[3].AsInteger;Ado.Next;
Edit1.ItemIndex:=ado.fields[3].Value;Ado.Next;
Edit2.ItemIndex:=ado.fields[3].Value;Ado.Next;
if varisnull(ado.fields[3].value) then di:='0'
else di:=ado.fields[3].value;
Ado.Next;


ComBoBox1.ItemIndex:=ado.fields[3].AsInteger;Ado.Next;
sb:=ado.fields[3].Value; Ado.Next;
max:=ado.fields[3].asInteger;
edit1.Items.Text:='';edit2.Items.Text:='';
for I := 1 to max do begin
edit1.Items.Add(inttostr(i));
edit2.Items.Add(inttostr(i)) ;
end;
if sb = '0' then begin CheckBox1.Checked:=False;end;
if sb = '1' then begin CheckBox1.Checked:=True; end;

if di = '1' then  begin



if s <> GetSpecialFolder(Handle, CSIDL_DESKTOPDIRECTORY) then begin

desktopicon(paramstr(0), Name, s);
end;
end;
ado.active:=False;
ado.TableName:='1';
ado.EnableBCD:=True;
ado.active:=true;
i:=0;
for i2 := 1 to max do begin

   ado.active:=false;
      ado.TableName:=inttostr(i2);
      ado.active:=True;
     repeat
    SetLength(vocis, i+1);
      vocis[i].Lektion := ado.TableName;
      vocis[i].ID := ado.Fields[0].Value;
      vocis[i].Franz := ado.Fields[1].Value;
      vocis[i].Deutsch := ado.Fields[2].Value;
      if varIsNull(ado.Fields[3].value)or(strtoint(ado.Fields[3].value)<0) then begin
      ado.edit; ado.Fields[3].value:='0';  end;
      vocis[i].Fehler := ado.Fields[3].value;
      inc(i);
      ado.next;
    until ado.eof;
end;
installed:='1';


 end else installed:='0';
if installed='0' then Button2.Caption:='Installieren'
else Button2.Caption:='Deinstallieren';

if (form3.muri=true) and (installed='0') then Button2.Click;

if ComBoBox1.Text = '' then ComboBox1.Text:='Deutsch ------> '+lng;

//if installed = '0' then  begin Button2Click(Sender);    { showMessage('Erfolgreich installiert!'); }  end;

 if Edit1.ItemIndex = -1 then Edit1.ItemIndex:=1;
if Edit2.ItemIndex = -1 then Edit2.ItemIndex:=1;
if ComboBox1.ItemIndex = -1 then ComboBox1.ItemIndex:=1;
 form3.Hide;
 timer1.Enabled:=true;
  end;

procedure TForm1.FormShow(Sender: TObject);
begin
Form3.Hide;
end;


procedure TForm1.Timer1Timer(Sender: TObject);
var erg:Integer;
  Datei: string;
  Ziel: string;
  cDownStatus:cDownloadStatusCallBack;
begin
if (installed = '1') then begin
  timer1.Enabled:=false;
    Datei := 'http://cadac.trachtengruppe-merenschwand.ch/'+Name+'V2/update2.txt?Version='+inttostr(VersionNr);
    Ziel  := path+'update.txt';

    cDownStatus := cDownloadStatusCallBack.Create;
    URLDownloadToFIle(nil,PCHar(Datei+'&var='+inttostr(zs(0,9999))),PCHAR(Ziel),0,CDownStatus);
    cDownStatus.Free;
    Memo1.Lines.LoadFromFile(Ziel);
    if strtoint(memo1.lines[0]) > VersionNr then showupdate:=True
    else showupdate:=False;

    if Memo1.Lines[5]='0' then begin lock :=True; lockm:=memo1.lines[6]; end else lock :=False;
    if Memo1.Lines[5]='3' then begin lock2:=True; lockm:=memo1.lines[6]; end else lock2:=False;
  label1.Caption:='Von';
  //showmessage(memo1.lines[0]+'=='+inttostr(VersionNr));
   if showupdate = true then begin
// showupdate:=False;
          erg := xMessageDlg('Hinweis: Es ist ein Update vorhanden!',// + chr($0D) + 'Lege die CD ein und warte ca. 10 sec.',
                      mtConfirmation,
                      [mbYes, mbNo],        // benutzte Schaltflächen
                      ['Abbrechen', 'Installieren']); // zugehörige Texte
                      if erg = mrNo then begin BitBtn1.Click;   end;

end;

end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var 
 s:String;
 i,i2:Integer;
   rStream: TResourceStream;
  fStream: TFileStream;
 begin

 {
CSIDL_COOKIES              Cookies
CSIDL_DESKTOPDIRECTORY     Desktop
CSIDL_FAVORITES            Favoriten
CSIDL_HISTORY              Internet-Verlauf
CSIDL_INTERNET_CACHE       "Temporary Internet Files"
CSIDL_PERSONAL             Eigene Dateien
CSIDL_PROGRAMS             "Programme" im Startmenü
CSIDL_RECENT               "Dokumente" im Startmenü
CSIDL_SENDTO               "Senden an" im Kontextmenü
CSIDL_STARTMENU            Startmenü
CSIDL_STARTUP              Autostart
}
Memo1.Text:='';
if installed = '0' then begin


if not DirectoryExists(GetSpecialFolder(Handle, CSIDL_PERSONAL)+'\'+Name) then MkDir(GetSpecialFolder(Handle, CSIDL_PERSONAL)+'\'+Name);
 GetDir(0, s);

if not FileExists(form1.path+'Voci.mdb') then UrlDownloadToFile(nil, PChar('http://cadac.trachtengruppe-merenschwand.ch/CadacV2/Voci.mdb'), PChar(form1.path+'Voci.mdb'), 0, nil);

  if not FileExists(form1.path+'Voci.mdb') then begin
  {this part extracts the voci from exe}

  rStream := TResourceStream.Create(hInstance, 'voci', RT_RCDATA) ;
  try
   fStream := TFileStream.Create(form1.path+'Voci.mdb', fmCreate) ;
   try
    fStream.CopyFrom(rStream, 0) ;
   finally
    fStream.Free;
   end;
  finally
   rStream.Free;
  end;
 end;

form1.Ado.ConnectionString:='Provider=Microsoft.Jet.OLEDB.4.0;Data Source='+form1.path+'Voci.mdb;Persist Security Info=False';

if s <> GetSpecialFolder(Handle, CSIDL_DESKTOPDIRECTORY) then begin
 if MessageDlg('Desktopicon erstellen?', mtConfirmation, [mbyes, mbno], 0) = mrYes then
begin
GetDir(0, s);
if s <> GetSpecialFolder(Handle, CSIDL_DESKTOPDIRECTORY) then begin
desktopicon(paramstr(0), Name, s);
ado.active:=False;
ado.TableName:='settings';
ado.active:=true;
Ado.Next;
Ado.Next;
Ado.Next;    ado.edit;
ado.fields[3].value:=1;

end;   end else begin
ado.active:=False;
ado.TableName:='settings';
ado.active:=true;
Ado.Next;
Ado.Next;
Ado.Next;    ado.edit;
ado.fields[3].value:=0;
end;

end;
sleep(1000);

//for i := 0 to 6 do Memo1.Lines.SaveToFile(path+'fehler_'+inttostr(i)+'.csv');

Memo1.Lines.SaveToFile(FileName);
Memo1.Lines.SaveToFile(FileCache);
ado.active:=False;
ado.TableName:='settings';
ado.EnableBCD:=True;
ado.active:=true;

ado.Last;
max:=ado.fields[3].asInteger;
edit1.Items.Text:='';edit2.Items.Text:='';
for I := 1 to max do begin
edit1.Items.Add(inttostr(i));
edit2.Items.Add(inttostr(i)) ;
end;
Button2.Caption:='Deinstallieren';

 if FileExists(form1.path+'Voci.mdb') then
 begin
ado.active:=false;
ado.EnableBCD:=false;
ado.close;
form1.Ado.ConnectionString:='Provider=Microsoft.Jet.OLEDB.4.0;Data Source='+form1.path+'Voci.mdb;Persist Security Info=False';
ado.TableName:='1';
ado.EnableBCD:=True;
ado.active:=true;
i:=0;
for i2 := 1 to max do begin

   ado.active:=false;
      ado.TableName:=inttostr(i2);
      ado.active:=True;
          ai:=0;
     repeat
    SetLength(vocis, i+1);
      vocis[i].Lektion := ado.TableName;
      vocis[i].ID := ado.Fields[0].Value;
      vocis[i].Franz := ado.Fields[1].Value;
      vocis[i].Deutsch := ado.Fields[2].Value;
      if varIsNull(ado.Fields[3].value) then begin
      ado.edit; ado.Fields[3].value:='0';  end;
      vocis[i].Fehler := ado.Fields[3].value;
      inc(i);
      inc(ai);
      ado.next;
    until ado.RecordCount=ai-1;
end;
 end;
installed:='1';
exit;
end;


 if installed = '1' then begin
  ado.Connection:=NIL;
  ado.active:=false;
  ado.EnableBCD:=false;
  ado.Close;
  ado.Free;
   sleep(1000);

DeleteFile(GetSpecialFolder(Handle, CSIDL_DESKTOPDIRECTORY)+'\'+Name+'.lnk');
DeleteFile(path+'Datei.csv');DeleteFile(path+'cache.csv');DeleteFile(path);
Button2.Caption:='Installieren';
if DeleteDir(GetSpecialFolder(Handle, CSIDL_PERSONAL)+'\'+Name) then begin
if paramstr(1) <> 'Update' then begin showmessage('Deinstallation erfolgreich!'); end;
 ado:=TADOTAble.Create(self);
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
