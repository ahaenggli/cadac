unit Unit8;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, jpeg, DateUtils, IdHttp, ActnList;

type
  TArray = Array of string;
  TForm8 = class(TForm)
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Memo1: TMemo;
    Edit2: TEdit;
    Memo2: TMemo;
    Button1: TBitBtn;
    StaticText1: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    StaticText7: TStaticText;
    StaticText8: TStaticText;
    StaticText9: TStaticText;
    BitBtn2: TBitBtn;
    Timer1: TTimer;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    Image1: TImage;
    Label1: TLabel;
    Button2: TButton;
    ActionList1: TActionList;
    Action1: TAction;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private-Deklarationen }
FileName,Filecache,Path:String;
isc,isc2:Integer;
str:TStringlist;
words:TArray;
HTTP:TIdHttp;
FileCacheSL:TStringList;
    FWndProc  : TWndMethod;
    FWndProc2  : TWndMethod;
    procedure MemoWndProc(var Msg: TMessage);
    procedure Memo2WndProc(var Msg: TMessage);
  public
    { Public-Deklarationen }
  end;

var
  Form8: TForm8;

implementation

uses FastStrings, Unit1, Unit2, Unit3, Unit4, Unit6, Unit7, Unit10;

{$R *.dfm}
procedure TForm8.MemoWndProc(var Msg: TMessage);
begin
  if Msg.Msg = WM_SETFOCUS then
  begin
    HideCaret(Memo1.Handle); // Cursor verstecken
    Msg.Result := 0;
  end else
    FWndProc(Msg); // alte Fensterproceure aufrufen
end;
procedure TForm8.Timer1Timer(Sender: TObject);
var
t,t2:Boolean;
begin
t:=True;t2:=True;
 label2.canvas.font.Size:=memo1.font.size;

if (abs( label2.Canvas.TextWidth(Memo1.Lines[0])+8) >= abs(memo1.width)) then
    Memo1.ScrollBars:=ssHorizontal else
       t:=False;

       if Memo1.Height <= (Memo1.Lines.Count) * abs(Memo1.Font.Height) then
    Memo1.ScrollBars := ssVertical else
         t2:=False;

if (t2=False) and (t=False) then     Memo1.ScrollBars := ssNone;

    
end;
procedure TForm8.Memo2WndProc(var Msg: TMessage);
begin
  if Msg.Msg = WM_SETFOCUS then
  begin
    HideCaret(Memo2.Handle); // Cursor verstecken
    Msg.Result := 0;
  end else
    FWndProc2(Msg); // alte Fensterproceure aufrufen
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
function InArray(text:string;strings:array of string):boolean;
      var
        i:integer;
      begin
      result := false;
        For i := 0 to High(Strings) do begin
              If strings[i] = text then
                begin
                result := true;
                exit;
                end
              else
                result := false;
          end;
      end;
function clearSTlist(sl:TStringlist):TSTringlist;
var i:Integer;
     sl2:TStringlist;
begin
sl2:=TStringlist.Create;
  for i := 0 to sl.Count - 1 do begin
    if sl[i]<>'' then sl2.Add(sl[i]);
  end;
result:=sl2;
end;

procedure TForm8.Action1Execute(Sender: TObject);
begin
Form1.Button4.Click;
end;

procedure TForm8.BitBtn1Click(Sender: TObject);
 var   asl:TStringlist;
 ttt,f:TArray;
        aslnr:Integer;
begin
if statictext8.Caption = '1' then  begin

asl:=Tstringlist.Create;
   asl.LoadFromFile(path+':fehler_'+words[2]+'.csv');
    for aslnr := 0 to asl.Count - 1 do begin
     if (smartpos(words[0]+'|'+words[1]+'|'+words[3], asl[aslnr], false) = 1) then begin
      asl[aslnr]:=words[0]+'|'+words[1]+'|'+inttostr((strtoint(words[3])-1));
      if ((strtoint(words[3])-1) = 0) then begin asl[aslnr]:=''; end;
    end;
    end;                        
   asl.SaveToFile(path+':fehler_'+words[2]+'.csv');
   asl.Free;   end;
   str.delete(0);
   str.SaveToFile(FileName);

    if str.Text <> '' then
      begin

    str.Clear;
    str.LoadFromFile(FileName);
    words:=explode('|', str[0], 0);
    ttt:=explode('[]', words[isc]+'[][]', 0);
    Memo1.Text:='';
   Memo1.Lines[0]:=ttt[0];
   Memo1.lines.add(ttt[1]);
   Memo1.lines.add(ttt[2]);

    StaticText7.Caption:=inttostr(str.Count);
       asl:=Tstringlist.Create;
   asl.LoadFromFile(path+':fehler_'+words[2]+'.csv');
   asl:=clearstlist(asl);
   words[3]:='0';
   for aslnr := 0 to asl.Count-1 do begin
       if smartpos(words[0]+'|'+words[1], asl[aslnr], false) = 1 then begin
          f:=explode('|', asl[aslnr], 3);
          words[3]:=f[2];
       end;
   end;
   asl.Free;
    Label5.Caption := words[3];
    Button2.Enabled:=True;
    Label1.Caption := 'Lektion '+words[2];
    Memo2.Text:='';
    Memo2.Lines.Add('');
    Memo2.Lines.Add('');
    Memo2.Lines.Add('');

       if StaticText7.Caption = StaticText9.Caption then
       begin
       StaticText9.Caption:='0';
       StaticText8.Caption:=inttostr(strtoint(StaticText8.Caption)+1);
       end;

      end;
      str:=clearSTlist(str);
       if str.Text = '' then

        begin
        Memo1.Text:='';
        Memo2.Text:='';

        StaticText7.Caption:='0';
        StaticText8.Caption:='1';
        StaticText9.Caption:='0';
        Form4.Top:=Top;
        Form4.Left:=Left;
        filecachesl.SaveToFile(Filecache);
        Button2.Enabled:=True;
        Form4.Show;
        Hide;
        end;
 BitBtn1.Visible:=False;
             BitBtn3.Visible:=False;
             Button1.Visible:=True;

end;

procedure TForm8.BitBtn2Click(Sender: TObject);
begin
filecachesl.SaveToFile(Filecache);
        Memo1.Text:='';
        Memo2.Text:='';
            Memo2.Lines.Add('');
      Memo2.Lines.Add('');
        Memo2.Lines.Add('');
        StaticText7.Caption:='0';
        StaticText8.Caption:='1';
        StaticText9.Caption:='0';
        Form4.Top:=Form8.Top;
        Form4.Left:=Form8.Left;
                Button1.Visible:=True;
        BitBtn1.Visible:=False;
        BitBtn3.Visible:=False;
        Form4.Show;
        Form8.Hide;

end;

procedure TForm8.BitBtn3Click(Sender: TObject);
 var   asl:TStringlist;
        ttt,f: TArray;
        tmpstr:String;
        aslnr:Integer;
        found:boolean;
begin

if (Statictext8.Caption = '1') then
   begin
   found:=false;
   asl:=Tstringlist.Create;
   asl.LoadFromFile(path+':fehler_'+words[2]+'.csv');
       for aslnr := 0 to asl.Count - 1 do begin
     if (smartpos(words[0]+'|'+words[1]+'|'+words[3], asl[aslnr], false) = 1) then begin
      asl[aslnr]:=words[0]+'|'+words[1]+'|'+inttostr((strtoint(words[3])+2));
          tmpstr:=words[0]+'|'+words[1]+'|'+inttostr((strtoint(words[3])+2));
      found:=true;
    end;
    end;

       if (found=false) then begin
       tmpstr:=words[0]+'|'+words[1]+'|2';
       asl.add(tmpstr);
       end;

   
   asl.SaveToFile(path+':fehler_'+words[2]+'.csv');

   asl.Free;
   if found = false then tmpstr:=words[0]+'|'+words[1]+'|'+words[2]+'|2'
   else tmpstr:=words[0]+'|'+words[1]+'|'+words[2]+'|'+inttostr((strtoint(words[3])+2));

   str.Add(tmpstr);

   filecachesl.add(tmpstr);

    str.Delete(0);
   end;
  if (Statictext8.Caption <> '1') then
   begin
   tmpstr:=str[0];
   str.Add(tmpstr);
   str.Delete(0);
   end;
     str.SaveToFile(FileName);
     str:=clearSTlist(str);
   if str.Text = '' then
        begin
        Memo1.Text:='';
        Memo2.Text:='';

        StaticText7.Caption:='0';
        StaticText8.Caption:='1';
        StaticText9.Caption:='0';
        Form4.Top:=Top;
        Form4.Left:=Left;
        filecachesl.SaveToFile(Filecache);
        Button2.Enabled:=True;
        Form4.Show;
        Hide;
        end;

    statictext9.Caption:=inttostr(strtoint(statictext9.Caption)+1);
 if str.Text <> '' then
      begin

    str.Clear;
    str.LoadFromFile(FileName);
    words:=explode('|', str[0], 0);
    ttt:=explode('[]', words[isc]+'[][]', 0);
    Memo1.Text:='';
   Memo1.Lines[0]:=ttt[0];
   Memo1.lines.add(ttt[1]);
   Memo1.lines.add(ttt[2]);
    StaticText7.Caption:=inttostr(str.Count);
       asl:=Tstringlist.Create;
   asl.LoadFromFile(path+':fehler_'+words[2]+'.csv');
   asl:=clearstlist(asl);
   words[3]:='0';
   for aslnr := 0 to asl.Count-1 do begin
       if smartpos(words[0]+'|'+words[1], asl[aslnr], false) = 1 then begin
          f:=explode('|', asl[aslnr], 3);
          words[3]:=f[2];
       end;
   end;
   asl.Free;
    Label5.Caption := words[3];
    Button2.Enabled:=True;
    Label1.Caption := 'Lektion '+words[2];
    Memo2.Text:='';

       if StaticText7.Caption = StaticText9.Caption then
       begin
       StaticText9.Caption:='0';
       StaticText8.Caption:=inttostr(strtoint(StaticText8.Caption)+1);
       end;

      end;
       if str.Text = '' then
       
        begin
        Memo1.Text:='';
        Memo2.Text:='';

        StaticText7.Caption:='0';
        StaticText8.Caption:='1';
        StaticText9.Caption:='0';
        filecachesl.SaveToFile(Filecache);
        Form4.Top:=Top;
        Form4.Left:=Left;
        Form4.Show;
        Hide;
        Button2.Enabled:=True;
        end;

 BitBtn1.Visible:=False;
 BitBtn3.Visible:=False;
 Button1.Visible:=True;
end;
procedure TForm8.Button2Click(Sender: TObject);
var
  tmpstr,strn,url: String;
begin
HTTP := TIdHTTP.Create;
  try
  

   //möglicherweise wird noch ein Parameter erwartet, hab ich nicht im Kopf ;-)

  words:=explode('|', str[0], 0);
  words[0]:=stringreplace(words[0],' ', '%20',  [rfReplaceAll]);
  words[1]:=stringreplace(words[1],' ', '%20',  [rfReplaceAll]);
   sleep(100);


  if inputquery('Bericht', 'Danke fürs Fehlermelden! Gib mir doch noch einen Hinweis, was falsch ist:', strn)
  then begin
  strn:=stringreplace(strn,' ', '%20',  [rfReplaceAll]);
  url:='http://cadac.trachtengruppe-merenschwand.ch/mail.php?prog='+Form1.Name+'&&lektion='+words[2]+'&&de='+words[1]+'&&en='+words[0]+'&&iwas&&tmpstr='+strn;
 //showmessage(url);
  tmpstr:= HTTP.Get(url);

   if tmpstr = '1' then showmessage('Fehler gemeldet!');
   if tmpstr = '2' then showmessage('Fehler wurde bereits gemeldet.');
   if tmpstr = '0' then   begin end;
       end;
  except
    //beep();
  end;
   Button2.Enabled:=False;
   words:=explode('|', str[0], 0);
   HTTP.Free;
end;

procedure TForm8.Button1Click(Sender: TObject);
 var
        tar: TArray;
begin
     tar := explode('[]',words[isc2]+'[]-[]-',0);
      if tar[0] <> '' then Memo2.Lines[0]:=tar[0];
      if tar[1] <> '-' then Memo2.Lines[1]:=tar[1];
      if tar[2] <> '-' then Memo2.Lines[2]:=tar[2];

             BitBtn1.Visible:=True;
             BitBtn3.Visible:=True;
             Button1.Visible:=False;
     if StaticText7.Caption = StaticText9.Caption then
       begin
       StaticText9.Caption:='0';
       StaticText8.Caption:=inttostr(strtoint(StaticText8.Caption)+1);
       end;
    end;




procedure TForm8.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Form1.Close;
end;

procedure TForm8.FormCreate(Sender: TObject);
begin
Memo1.Text:='';
Memo2.Text:='';
Constraints.MaxHeight:=Constraints.MinHeight;
Constraints.MaxWidth:=Constraints.MinWidth;
FileName:=Form1.FileName;
Filecache:=Form1.FileCache;
Path:=Form1.Path;
str:=Tstringlist.Create;
filecachesl:=Tstringlist.Create;
  FWndProc := Memo1.WindowProc; // alte Fensterproceure merken
  Memo1.WindowProc := MemoWndProc; // Fensterproceure auf eigene Fensterprocedure umbiegen
   FWndProc2 := Memo2.WindowProc; // alte Fensterproceure merken
  Memo2.WindowProc := Memo2WndProc; // Fensterproceure auf eigene Fensterprocedure umbiegen
  Image1.Picture:=Form1.Image1.Picture;
end;

procedure TForm8.FormHide(Sender: TObject);
begin
timer1.enabled:=false;
end;

procedure TForm8.FormShow(Sender: TObject);
var ch,asl:TStringlist;
    ttt,f:TArray;
    aslnr:Integer;
begin
if form1.ischanged=True then begin isc:=0; isc2:=1;end
   else begin isc := 1;isc2:=0;  end;
    str.LoadFromFile(FileName);
    words:=explode('|', str[0], 0);
    ttt:=explode('[]', words[isc]+'[][]', 0);
    Memo1.Text:='';
    memo1.Lines.add('');       Memo1.Lines[0]:=ttt[0];
    memo1.Lines.add('');       Memo1.Lines[1]:=ttt[1];
    memo1.Lines.add('');       Memo1.Lines[2]:=ttt[2];
    StaticText7.Caption:=inttostr(str.Count);
       asl:=Tstringlist.Create;
   asl.LoadFromFile(path+':fehler_'+words[2]+'.csv');
   asl:=clearstlist(asl);
   words[3]:='0';
   for aslnr := 0 to asl.Count-1 do begin
       if smartpos(words[0]+'|'+words[1], asl[aslnr], false) = 1 then begin
          f:=explode('|', asl[aslnr], 3);
          words[3]:=f[2];
       end;
   end;
   asl.Free;
    Label5.Caption := words[3];
    Label1.Caption := 'Lektion '+words[2];
    Memo2.Text:='';
    Memo2.Lines.Add('');
    Memo2.Lines.Add('');
    Memo2.Lines.Add('');
    timer1.enabled:=true;

        ch:=TStringList.Create;
    ch.Text:='';
    ch.SaveToFile(Filecache);
    ch.Free;FileCacheSL.Text:='';
                     end;

end.
