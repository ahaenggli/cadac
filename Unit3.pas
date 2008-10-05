unit Unit3;

interface

uses
  Windows, Graphics, Forms, Classes, Controls, StdCtrls, Buttons,
  ComCtrls, ExtCtrls, ImgList, DateUtils, SysUtils,
    ShlObj, SHFolder,     ComObj,
      jpeg, UrlMon, Activex,
  MMSystem, Dialogs, IniFiles, tlhelp32,
  Registry, ShellAPI, Messages;

type
  TForm3 = class(TForm)
    Timer1: TTimer;
    Label1: TLabel;
    Image1: TImage;
    Timer3: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer3Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    muri:Boolean;
  end;

var
  Form3: TForm3;
  mHandle: THandle;
implementation

uses Unit1, Unit2, Unit4, FastStrings, Unit10, Unit11, Unit6, Unit7, Unit8,
  Unit12, Unit13;

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
function GetProcessID(Exename: string): DWORD;
var
  hProcSnap: THandle;
  pe32: TProcessEntry32;
begin
  result := 0;
  hProcSnap := CreateToolHelp32SnapShot(TH32CS_SNAPPROCESS, 0);
  if hProcSnap <> INVALID_HANDLE_VALUE then
  begin
    pe32.dwSize := SizeOf(ProcessEntry32);
    if Process32First(hProcSnap, pe32) = true then
    begin
      while Process32Next(hProcSnap, pe32) = true do
      begin
        if pos(Exename, pe32.szExeFile) <> 0 then
          result := pe32.th32ProcessID;
      end;
    end;
    CloseHandle(hProcSnap);
  end;
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
function GetName(const ADrive: Char): String;
var
  unused: Cardinal; //oder Integer (Delphi 3)
  buffer: array[0..19] of Char;
begin
  Result:='';
  if (GetDriveType(PChar(Format('%S:\',[ADrive]) ) ) >1) and
     (GetVolumeInformation(PChar(ADrive+':\'),
                           @buffer[0], SizeOf(buffer),
                           nil,
                           unused,
                           unused,
                           nil,
                           0)) then
    Result := buffer;
  //else
    //RaiseLastOSError;// Bis D5 RaiseLastWin32Error;
end;
function GetDiskIn(Drive: Char): Boolean;
var
  ErrorMode: word;
  DriveNumber: Integer;
begin
  {Meldung eines kritischen Systemfehlers vehindern}
  ErrorMode := SetErrorMode(SEM_FailCriticalErrors);
  try
    DriveNumber := Ord(Drive) - 64;
    if DiskSize(DriveNumber) = -1 then
      Result := False
    else
      Result := True;
  finally
    {ErrorMode auf den alten Wert setzen}
    SetErrorMode(ErrorMode);
  end;
end;


procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Application.Terminate;
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

procedure TForm3.FormCreate(Sender: TObject);
var
  ErrorMode: word;
  Drive: Char;
  Flag: Integer;
  erg : integer;
   ini:TiniFile;
    dat:string;
    exepath:String;
    Snap: THandle;
    ProcessE: TProcessEntry32;
    modh: THandle;
    ModuleE: TModuleEntry32;
begin
Constraints.MaxHeight:=Constraints.MinHeight;
Constraints.MaxWidth:=Constraints.MinWidth;
muri:=False;
 { label1.Caption:=datetimetostr(Date+incsecond(Time,-10));

  Timer1.Enabled:=True;
  exit;


  {Meldung eines kritischen Systemfehlers vehindern}
  ErrorMode := SetErrorMode(SEM_FailCriticalErrors);
  try

  IF fileexists('GemeindeMuri.lic') then begin
  muri:=True;
  label1.Caption:=datetimetostr(Date+incsecond(Time,-10));
  Timer1.Enabled:=True;
  exit;
  end;

 label1.Caption:=datetimetostr(Date+incsecond(Time,2));
   flag:=0;

   while(flag = 0) do begin
     for Drive := 'A' to 'Z' do

         begin
              if((ParamStr(0) = GetSpecialFolder(Handle, 38)+'\Cadac\Cadac_cd.exe'))
              then begin
                    Application.Title:='Cadac';
                    Timer1.Enabled:=True;
                    label1.Caption:=datetimetostr(Date+incsecond(Time,2));
                    exit;
                    end;

   if(((getname(Drive) = 'CADAC') )or(((getname(Drive) = '_VOGGI_')))or(((getname(Drive) = 'ADRIANO')))  ) then begin
             if((fileexists(Drive+':\tmp.txt'))or(fileexists(Drive+':\Setup_Cadac.exe'))
             or(fileexists(Drive+':\Cadac.exe'))or(fileexists(Drive+':\Cadac\Cadac.exe')))
                then begin
                    flag:=1;
                    Timer1.Enabled:=True;
                    label1.Caption:=datetimetostr(Date+incsecond(Time,2));
                    exit;
                end else begin
                      Timer1.Enabled:=false;
                     // erg := xMessageDlg('Entweder die CD ist beschädigt, oder sie ist eine Kopie!',// + chr($0D) + 'Lege die CD ein und warte ca. 10 sec.',
                      //mtConfirmation,
                      //[mbNo],        // benutzte Schaltflächen
                      //['Schliessen']); // zugehörige Texte
                      //if erg = mrNo then begin Application.Terminate;   exit;exit;   end;
                flag:=0;
                end;
             end else begin
             end;

         end;
         if flag=0 then begin
         
                    Timer1.Enabled:=false;
                      erg := xMessageDlg('Bitte lege die richtige CD ins Laufwerk!',// + chr($0D) + 'Lege die CD ein und warte ca. 10 sec.',
                      mtConfirmation,
                      [mbYes, mbNo],        // benutzte Schaltflächen
                      ['OK', 'Schliessen']); // zugehörige Texte
                      if erg = mrNo then begin Application.Terminate;   exit;exit;   end;
                end;
  end;
  //  label1.Caption:=datetimetostr(Date+incsecond(Time,1));//löschen für CD
    //Timer1.Enabled:=True;// löschen für CD
  finally
    {ErrorMode auf den alten Wert setzen}
    SetErrorMode(ErrorMode);
  end;

end;

procedure TForm3.Timer1Timer(Sender: TObject);
var
  stopTime: TDateTime;
  ini:TIniFile;
begin
 stopTime := strtodatetime(label1.caption);

 if Now >= stopTime then begin   {
 Timer1.Enabled:=false;
 Form1.Top:=Form3.Top;
 Form1.Left:=Form3.Left;}
 Timer1.Enabled:=False;


  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm6, Form6);
  Application.CreateForm(TForm7, Form7);
  Application.CreateForm(TForm8, Form8);
  Application.CreateForm(TForm10, Form10);
 Application.CreateForm(TForm11, Form11);
  Application.CreateForm(TForm12, Form12);
  Application.CreateForm(TForm13, Form13);
  

 Form1.Show;
 Form3.Hide;
 end;

end;



procedure TForm3.Timer3Timer(Sender: TObject);
begin
Application.Terminate;
end;

Initialization //Verhindern, dass das Programm mehrmals gestartet wird
   mHandle := CreateMutex(nil, True, 'Cadac.exe');
     if GetLastError = ERROR_ALREADY_EXISTS then
     begin
       Halt;
end;
finalization
   if mHandle <> 0 then
     CloseHandle(mHandle);
end. //Programmende
