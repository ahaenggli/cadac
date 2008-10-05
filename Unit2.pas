unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, DateUtils, Unit1, jpeg,IdHttp, ActnList;

type
  TArray= array of string;
  TForm2 = class(TForm)
    Memo1: TMemo;
    Edit1: TEdit;
    Edit2: TEdit;
    Memo2: TMemo;
    Button1: TBitBtn;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    StaticText7: TStaticText;
    StaticText8: TStaticText;
    StaticText9: TStaticText;
    Label1: TLabel;
    Timer1: TTimer;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    BitBtn2: TBitBtn;
    BitBtn1: TBitBtn;
    Image1: TImage;
    Label7: TLabel;
    Button2: TButton;
    Zeichen1: TSpeedButton;
    Zeichen2: TSpeedButton;
    Zeichen3: TSpeedButton;
    Zeichen4: TSpeedButton;
    Zeichen5: TSpeedButton;
    Zeichen6: TSpeedButton;
    Zeichen7: TSpeedButton;
    Zeichen8: TSpeedButton;
    Zeichen9: TSpeedButton;
    Zeichen10: TSpeedButton;
    Zeichen11: TSpeedButton;
    Zeichen12: TSpeedButton;
    Zeichen13: TSpeedButton;
    Zeichen14: TSpeedButton;
    ActionList1: TActionList;
    Action1: TAction;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure BitBtn1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Zeichen1Click(Sender: TObject);
    procedure Zeichen2Click(Sender: TObject);
    procedure Zeichen3Click(Sender: TObject);
    procedure Zeichen4Click(Sender: TObject);
    procedure Zeichen5Click(Sender: TObject);
    procedure Zeichen6Click(Sender: TObject);
    procedure Zeichen7Click(Sender: TObject);
    procedure Zeichen8Click(Sender: TObject);
    procedure Zeichen9Click(Sender: TObject);
    procedure Zeichen10Click(Sender: TObject);
    procedure Zeichen11Click(Sender: TObject);
    procedure Zeichen12Click(Sender: TObject);
    procedure Zeichen13Click(Sender: TObject);
    procedure Zeichen14Click(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
  private
    { Private-Deklarationen }
    str:TStringList;
    words:TArray;
        FWndProc  : TWndMethod;
    FWndProc2  : TWndMethod;
    procedure MemoWndProc(var Msg: TMessage);
    procedure Memo2WndProc(var Msg: TMessage);
  public
    { Public-Deklarationen }
    FileName:String;
    Filecache:String;
    FileCacheSL:TStringlist;
    //Path:String;
    Path:String;
    HTTP:TidHttp;
  end;

var
  Form2: TForm2;
implementation
uses Unit3, Unit4, FastStrings, Unit10, Unit6, Unit7, Unit8;
{$R *.dfm}
procedure TForm2.MemoWndProc(var Msg: TMessage);
begin
  if Msg.Msg = WM_SETFOCUS then
  begin
    HideCaret(Memo1.Handle); // Cursor verstecken
    Msg.Result := 0;
  end else
    FWndProc(Msg); // alte Fensterproceure aufrufen
end;
procedure TForm2.Memo2WndProc(var Msg: TMessage);
begin
  if Msg.Msg = WM_SETFOCUS then
  begin
    HideCaret(Memo2.Handle); // Cursor verstecken
    Msg.Result := 0;
  end else
    FWndProc2(Msg); // alte Fensterproceure aufrufen
end;

function textwrap(textstr:String; onum:Integer; BOOL:Boolean=true; zs:String=''; tr:Boolean=False)  :String;
var
again:Boolean;
tmpa, tmpb:String;
i:Integer;
begin



again:=True;
while((again=true)and(onum<>0))   do begin

if textstr[onum] = ' ' then begin
textstr[onum] := #13;
//textstr:=StringReplace(textstr, #13, #13+zs,  [rfReplaceAll, rfIgnoreCase]);
again:=false;
end else onum:=onum-1;

end;
tmpa:='';
for i := 1 to onum do  begin
tmpa:=tmpa+textstr[i];
//showmessage(tmpa);
end;

//tmpa:=textstr[1]+textstr[2]+textstr[3]+textstr[4]+textstr[5]+textstr[6];

for i := onum+1 to length(textstr)-1 do  begin
tmpb:=tmpb+textstr[i];
end;


if tr = true  then result:=tmpb;
if tr = false then result:=tmpa;


 if BOOL = FALSE then begin
 result:=inttostr(length(textstr)-onum);
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

procedure TForm2.Action1Execute(Sender: TObject);
begin
Form1.Button4.Click;
end;

procedure TForm2.BitBtn1Click(Sender: TObject);
begin
Edit1.Text:=Memo2.Lines[0];
end;

procedure TForm2.BitBtn2Click(Sender: TObject);
begin
filecachesl.savetofile(filecache);


    Memo1.Text:='';
        Memo2.Text:='';
            Memo2.Lines.Add('');
      Memo2.Lines.Add('');
        Memo2.Lines.Add('');
        Edit1.Text:='';
        StaticText7.Caption:='0';
        StaticText8.Caption:='1';
        StaticText9.Caption:='0';
        Form4.Top:=Form2.Top;
        Form4.Left:=Form2.Left;
        Form4.Show;
        Form2.Hide;
        Button2.Enabled:=True;
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
Function ReduceMultiples(Const S: String; C: Char): String;
  Var Pi, Po, Pe: PChar;
    Cm: Char;

  Begin
    Result := S;
    If Result = '' Then Exit;
    Pi := @Result[1];
    Pe := Pi + Length(Result);
    Inc(Pi);
    Po := Pi;
    Cm := Result[1];
    While Pi < Pe do Begin
      If (Pi^ <> Cm) or (Pi^ <> C) Then Begin
        Inc(Po);
        Cm := Pi^;
      End;
      Inc(Pi);
      Po^ := Pi^;
    End;
    SetLength(Result, Po - @Result[1] + 1);
  End;
procedure TForm2.Button1Click(Sender: TObject);
 var    asl:TStringlist;
        tar,ttt,f:TArray;
        tmpstr: String;
        isc,isc2,aslnr,itmp:Integer;
        found:Boolean;
begin
edit1.Text:=Trim(Edit1.Text);
edit1.Text:=ReduceMultiples(edit1.Text, ' ');
if (edit2.text = '1') and (StaticText8.Caption = '1') then label5.caption:=inttostr(strtoint(label5.caption)+2);

if form1.ischanged=true then begin isc:=0;isc2:=1;  end
   else begin isc := 1;  isc2:=0;  end;

   tar := explode('[]',words[isc2]+'[][][]',0);
   if (InArray(Edit1.Text, tar) )AND(Edit1.Text <> '')  then
    begin

if (Edit2.Text = '0') and (Statictext8.Caption = '1') then begin
   asl:=Tstringlist.Create;
   asl.LoadFromFile(path+':fehler_'+words[2]+'.csv');
    for aslnr := 0 to asl.Count - 1 do begin
    if (smartpos(words[0]+'|'+words[1]+'|'+words[3], asl[aslnr], false) = 1) then begin
      asl[aslnr]:=words[0]+'|'+words[1]+'|'+inttostr((strtoint(words[3])-1));
      if ((strtoint(words[3])-1) = 0) then begin asl[aslnr]:=''; end;
    end;                          
    end;                        
   asl.SaveToFile(path+':fehler_'+words[2]+'.csv');
   asl.Free;
   str.delete(0);
   end;

if (strtoint(Edit2.Text) <> 0)And(Statictext8.Caption = '1') then
   begin
   found:=false;
   asl:=Tstringlist.Create;
   asl.LoadFromFile(path+':fehler_'+words[2]+'.csv');
       for aslnr := 0 to asl.Count - 1 do begin
     if (smartpos(words[0]+'|'+words[1]+'|'+words[3], asl[aslnr], false) = 1) then begin
      asl[aslnr]:=words[0]+'|'+words[1]+'|'+inttostr((strtoint(words[3])+2));
          tmpstr:=words[0]+'|'+words[1]+'|'+inttostr((strtoint(words[3])+2));
     // showmessage(tmpstr);

      found:=true;
    end;
    end;

       if (asl.Count-1 <= 0)or(found=false) then begin
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
  if (strtoint(Edit2.Text) <> 0)And(Statictext8.Caption <> '1') then
   begin
   tmpstr:=str[0];
   str.Add(tmpstr);
   str.Delete(0);
   end;
     if (strtoint(Edit2.Text) = 0)And(Statictext8.Caption <> '1') then
   begin
   str.Delete(0);
   end;
     Edit2.Text:='0';
     str.SaveToFile(FileName);
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
      if str.Text <> '' then
      begin

    str.Clear;
    str.LoadFromFile(FileName);
    words:=explode('|', str[0], 0);
    ttt:=explode('[]', words[isc]+'[][][]', 0);
    Memo1.Text:='';
 for Itmp := 0 to high(ttt) do if (ttt[itmp]<>'')then Memo1.Lines.add(ttt[itmp]);



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
    Edit1.Text:='';
   Memo2.Text:='';
    Label7.Caption := 'Lektion '+words[2];
      Label1.Font.Color:=clBlack;
      Label1.Caption:='Richtig!';
      Button2.Enabled:=True;
      label2.Caption:=datetimetostr(Date+incsecond(Time,strtoint(label3.Caption)));Timer1.Enabled:=True;
      Button2.Enabled:=True;
       if StaticText7.Caption = StaticText9.Caption then
       begin
       StaticText9.Caption:='0';
       StaticText8.Caption:=inttostr(strtoint(StaticText8.Caption)+1);
       end;

      end;
    end
     else
      begin
      Edit2.Text:=inttostr((StrToint(Edit2.Text)+1));

     tar := explode('[]',words[isc2],0);
    Memo2.Text:='';
 for Itmp := 0 to high(tar) do if (tar[itmp]<>'-')then

 begin
  Memo2.Lines.Add('');
  
  Memo2.Lines[Itmp]:=Copy(tar[Itmp], 1, strtoint(Edit2.Text)*4+2);//Memo2.Lines[Itmp]+tar[Itmp][strtoint(Edit2.Text)];
  if  strtoint(Edit2.Text) >=4 then  Memo2.Lines[Itmp]:=tar[Itmp];
          end;

      if Edit2.Text = '1' then
      begin
      statictext9.Caption:=inttostr(strtoint(statictext9.caption)+1);
      end;

      Label1.Font.Color:=clRed;
      Label1.Caption:='Falsch!';
      label2.Caption:=datetimetostr(Date+incsecond(Time,strtoint(label3.Caption)));
      end;
    Label1.Font.Size:=16;
           if str.Text = '' then
       
        begin
        Memo1.Text:='';
        Memo2.Text:='';
        Edit1.Text:='';
        StaticText7.Caption:='0';
        StaticText8.Caption:='1';
        StaticText9.Caption:='0';
        Form4.Top:=Form2.Top;
        Form4.Left:=Form2.Left;
        filecachesl.SaveToFile(Filecache);
        Button2.Enabled:=True;
        Form4.Show;
        Form2.Hide;
        end;
end;
procedure TForm2.Button2Click(Sender: TObject);
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


procedure TForm2.Edit1KeyPress(Sender: TObject; var Key: Char);
begin         
if Key = #13 then begin
Button1Click(Sender);
Key := #0; 
end;      
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Form1.Close;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
SendMessage(Memo1.Handle,WM_VSCROLL,SB_Bottom,0);
Memo1.Text:='';
Memo2.Text:='';
Constraints.MaxHeight:=Constraints.MinHeight;
Constraints.MaxWidth:=Constraints.MinWidth;
FileName:=Form1.FileName;
Filecache:=Form1.FileCache;
Path:=Form1.Path;
str:=TStringList.Create;
filecachesl:=Tstringlist.create;
  FWndProc := Memo1.WindowProc; // alte Fensterproceure merken
  Memo1.WindowProc := MemoWndProc; // Fensterproceure auf eigene Fensterprocedure umbiegen
   FWndProc2 := Memo2.WindowProc; // alte Fensterproceure merken
  Memo2.WindowProc := Memo2WndProc; // Fensterproceure auf eigene Fensterprocedure umbiegen
Image1.Picture:=Form1.Image1.Picture;
end;

procedure TForm2.FormShow(Sender: TObject);
var ch,asl:TStringlist;
    ttt,f:TArray;
    isc,aslnr:Integer;
begin
Timer1.Enabled:=True;
if form1.ischanged=True then begin isc:=0; end
   else begin isc := 1;  end;
    str.LoadFromFile(FileName);
    ch:=TStringList.Create;
    ch.Text:='';
    ch.SaveToFile(Filecache);
    ch.Free;
    //str[0]:='aaaaaaaaaaaaaaaaaaaaaaaaaabbbbbbbbbbbbbbbbbbbbcccccccc DHDHDHDHDHDHDHDH';
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
    Label7.Caption := 'Lektion '+words[2];
    Memo2.Text:='';
    Memo2.Lines.Add('');
    Memo2.Lines.Add('');
    Memo2.Lines.Add('');
    FileCacheSL.Text:='';
end;

procedure TForm2.Timer1Timer(Sender: TObject);
var
  stopTime: TDateTime;
  ttt:TArray; t,t2,t3,t4:Boolean;
begin

 stopTime := strtodatetime(label2.caption);
 if Now >= stopTime then begin
 label2.caption:='2';
 label1.Caption:='';
 end;
                  t:=True;t2:=True;
 label2.canvas.font.Size:=memo1.font.size;

if (abs( label2.Canvas.TextWidth(Memo1.Lines[0])+8) >= abs(memo1.width)) then
    Memo1.ScrollBars:=ssHorizontal else t:=False;

if Memo1.Height <= (Memo1.Lines.Count) * abs(Memo1.Font.Height) then
   Memo1.ScrollBars := ssVertical else t2:=False;

if (t2=False) and (t=False) then     Memo1.ScrollBars := ssNone;

if (abs( label2.Canvas.TextWidth(Memo2.Lines[0])+8) >= abs(memo2.width)) then
    Memo2.ScrollBars:=ssHorizontal else t3:=False;

if Memo2.Height <= (Memo2.Lines.Count) * abs(Memo2.Font.Height) then
   Memo2.ScrollBars := ssVertical else t4:=False;

if (t3=False) and (t4=False) then     Memo2.ScrollBars := ssNone;


SendMessage(Memo1.Handle,WM_VSCROLL,SB_TOP,0);
SendMessage(Memo2.Handle,WM_VSCROLL,SB_TOP,0);
end;


procedure TForm2.Zeichen5Click(Sender: TObject);
begin
Edit1.SelLength:=0;
Edit1.selText:='û';

end;

procedure TForm2.Zeichen6Click(Sender: TObject);
begin
Edit1.SelLength:=0;
Edit1.selText:='ù';

end;

procedure TForm2.Zeichen10Click(Sender: TObject);
begin
Edit1.SelLength:=0;
Edit1.selText:='ô';

end;

procedure TForm2.Zeichen11Click(Sender: TObject);
begin
Edit1.SelLength:=0;
Edit1.selText:='ê';

end;

procedure TForm2.Zeichen14Click(Sender: TObject);
begin
Edit1.SelLength:=0;
Edit1.selText:='ë';

end;

procedure TForm2.Zeichen7Click(Sender: TObject);
begin
Edit1.SelLength:=0;
Edit1.selText:='''';

end;

procedure TForm2.Zeichen1Click(Sender: TObject);
begin
Edit1.SelLength:=0;
Edit1.selText:='ç';
end;

procedure TForm2.Zeichen2Click(Sender: TObject);
begin
Edit1.SelLength:=0;Edit1.selText:='Ç';

end;

procedure TForm2.Zeichen12Click(Sender: TObject);
begin
Edit1.SelLength:=0;Edit1.selText:='é';

end;

procedure TForm2.Zeichen9Click(Sender: TObject);
begin
Edit1.SelLength:=0;Edit1.selText:='î';

end;

procedure TForm2.Zeichen13Click(Sender: TObject);
begin
Edit1.SelLength:=0;Edit1.selText:='è';

end;

procedure TForm2.Zeichen8Click(Sender: TObject);
begin
Edit1.SelLength:=0;Edit1.selText:='ï';

end;

procedure TForm2.Zeichen3Click(Sender: TObject);
begin
Edit1.SelLength:=0;Edit1.selText:='â';

end;

procedure TForm2.Zeichen4Click(Sender: TObject);
begin
Edit1.SelLength:=0;Edit1.selText:='à';

end;



end.
