unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, DateUtils, jpeg;

type
  TForm5 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
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
    Timer1: TTimer;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    BitBtn2: TBitBtn;
    BitBtn1: TBitBtn;
    Image1: TImage;
    Zeichen1: TSpeedButton;
    Zeichen10: TSpeedButton;
    Zeichen11: TSpeedButton;
    Zeichen12: TSpeedButton;
    Zeichen13: TSpeedButton;
    Zeichen14: TSpeedButton;
    Zeichen2: TSpeedButton;
    Zeichen3: TSpeedButton;
    Zeichen4: TSpeedButton;
    Zeichen5: TSpeedButton;
    Zeichen6: TSpeedButton;
    Zeichen7: TSpeedButton;
    Zeichen8: TSpeedButton;
    Zeichen9: TSpeedButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Zeichen1Click(Sender: TObject);
    procedure Zeichen2Click(Sender: TObject);
    procedure Zeichen8Click(Sender: TObject);
    procedure Zeichen3Click(Sender: TObject);
    procedure Zeichen12Click(Sender: TObject);
    procedure Zeichen13Click(Sender: TObject);
    procedure Zeichen4Click(Sender: TObject);
    procedure Zeichen5Click(Sender: TObject);
    procedure Zeichen6Click(Sender: TObject);
    procedure Zeichen7Click(Sender: TObject);
    procedure Zeichen11Click(Sender: TObject);
    procedure Zeichen9Click(Sender: TObject);
    procedure Zeichen10Click(Sender: TObject);
    procedure Zeichen14Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    FileName:String;
    FileCache:String;
    Path:String;
  end;

var
  Form5: TForm5;

implementation
 uses Unit1, Unit2, Unit3, Unit4;
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

procedure TForm5.BitBtn1Click(Sender: TObject);
begin
Edit1.Text:=Memo2.Lines[0];
end;

procedure TForm5.BitBtn2Click(Sender: TObject);
begin
        Memo1.Text:='';
        Memo2.Text:='';
    Memo2.Lines.Add('');
    Memo2.Lines.Add('');
    Memo2.Lines.Add('');
        Edit1.Text:='';
        StaticText7.Caption:='0';
        StaticText8.Caption:='1';
        StaticText9.Caption:='0';
        Form4.Top:=Form5.Top;
        Form4.Left:=Form5.Left;
        Form4.Show;
        Form5.Hide;
end;
procedure TForm5.Button1Click(Sender: TObject);
 var   str, tmp, ch, f_l, fl, a, b, ab:TStringlist;
        loesung, frage, cache, e,f, tar,ttt: TArray;
        fals: String;
        i, zeile, c,d,z:Integer;
begin
    tmp := TStringList.Create;
    f_l:= TSTringList.Create;
    fl:=TStringList.Create;
    str := TStringList.Create;
    ch := TStringList.Create;
    a:=TStringlist.Create;
    b:=TStringlist.Create;
    ab:=TStringlist.Create;
    str.LoadFromFile(FileName);
    loesung:=explode('|', str[0],3);
    
if (edit2.text = '1') and (StaticText8.Caption = '1') then label5.caption:=inttostr(strtoint(label5.caption)+2);

 //if StringReplace(loesung[0], ' ','',[rfReplaceAll, rfIgnoreCase]) = StringReplace(Edit1.Text, ' ','',[rfReplaceAll, rfIgnoreCase]) then
  // if loesung[0] = Edit1.Text  then
  tar := explode('[]',loesung[0]+'[]-[]-',0);
   if (InArray(Edit1.Text, tar))AND(Edit1.Text <> '-')  then
    begin

if Edit2.Text = '0' then StaticText7.Caption:=inttostr(strtoint(StaticText7.Caption)-1);

 if (Edit2.Text = '0') and (Statictext8.Caption = '1') then begin

   a.LoadFromFile(path+':fehler_'+loesung[2]+'.csv');
   for c := 0 to a.Count - 1 do begin
    e:=explode('|', a[c], 5);
    b.add(e[0]+'|'+e[1]+'|'+loesung[2]);
   end;
   if b.IndexOf(str[0]) <> -1 then begin
      z:=b.IndexOf(str[0]);
      f:=explode('|', a[z], 3);
      d:=strtoint(f[2])-1;
      a.delete(z);
      if d <> 0 then begin a.Add(f[0]+'|'+f[1]+'|'+inttostr(d));end;
   end;
      a.SaveToFile(path+':fehler_'+loesung[2]+'.csv');
 end;

      if strtoint(Edit2.Text) <> 0 then
        begin
           if form1.ende=true then begin ttt := explode('|', str[0], 0);
            str[0]:=ttt[1]+'|'+ttt[0]+'|'+ttt[2];  end;
        tmp.LoadFromFile(path+':fehler_'+loesung[2]+'.csv');
          for i := 0 to tmp.Count - 1 do   begin
          // EN|DE|F
           cache := explode('|', tmp[i], 3);
           f_l.Add(cache[0]+'|'+cache[1]+'|'+loesung[2]);
           fl.Add(cache[0]+'|'+cache[1]+'|'+cache[2]);
          end;
          if Statictext8.Caption = '1' then    begin
          
         if f_l.IndexOf(str[0]) <> -1 then
          begin
          Zeile:=f_l.IndexOf(str[0]);
          cache:=explode('|', fl[zeile],5);
          fals:=cache[0]+'|'+cache[1]+'|'+inttostr(strtoint(cache[2])+2);
          fl.delete(zeile);
          fl.Add(fals);
          end else begin
             if form1.ende=true then begin fl.add(loesung[1]+'|'+loesung[0]+'|2');end
             else fl.add(loesung[0]+'|'+loesung[1]+'|2');
          end;
          tmp.Clear;
        tmp:=fl;
        tmp.SaveToFile(path+':fehler_'+loesung[2]+'.csv');
        tmp.Clear;    end;

        ch.LoadFromFile(FileCache);
        if ch.IndexOf(str[0])=-1 then ch.Add(str[0]);
        ch.SaveToFile(FileCache);
        
        str.Add(str[0]);
           if form1.ende=true then begin ttt := explode('|', str[0], 0);
            str[0]:=ttt[0]+'|'+ttt[1]+'|'+ttt[2];  end;
      end;

     Edit2.Text:='0';
     str.Delete(0);
     str.SaveToFile(FileName);
      if str.Count-1 <> 0 then
      begin

      str.Clear;
      tmp.Clear;
      tmp.LoadFromFile(FileName);

      frage:=explode('|', tmp[0],0);
     // Memo1.Text:=frage[1];
     ttt:=explode('[]', frage[1]+'[][]', 0);
    Memo1.Text:=''; memo1.Lines.add('');memo1.Lines.add('');memo1.Lines.add('');
    Memo1.Lines[0]:=ttt[0];Memo1.Lines[1]:=ttt[1];Memo1.Lines[2]:=ttt[2];
     // label5.Caption:=frage[2];
  a.LoadFromFile(path+':fehler_'+frage[2]+'.csv');

   for c := 0 to a.Count - 1 do begin
    e:=explode('|', a[c], 5);
    b.add(e[0]+'|'+e[1]+'|'+frage[2]);
   end;

   if b.IndexOf(tmp[0]) <> -1 then begin
      z:=b.IndexOf(tmp[0]);
      f:=explode('|', a[z], 3);
      d:=strtoint(f[2]);
      Label5.Caption:=inttostr(d);
      a.clear;
      b.clear;
   end;
     // Memo1.Lines[2]:='Lektion: '+frage[2];
      Memo2.Text:='';
    Memo2.Lines.Add('');
    Memo2.Lines.Add('');
    Memo2.Lines.Add('');
      Edit1.Text:='';
      Label1.Font.Color:=clBlack;
      Label1.Caption:='Richtig!';
      label2.Caption:=datetimetostr(Date+incsecond(Time,strtoint(label3.Caption)));Timer1.Enabled:=True;

       if StaticText7.Caption = StaticText9.Caption then
       begin
       StaticText9.Caption:='0';
       StaticText8.Caption:=inttostr(strtoint(StaticText8.Caption)+1);
       end;

      end
       else
        begin
        Memo1.Text:='';
        Memo2.Text:='';
    Memo2.Lines.Add('');
    Memo2.Lines.Add('');
    Memo2.Lines.Add('');
        Edit1.Text:='';
        StaticText7.Caption:='0';
        StaticText8.Caption:='1';
        StaticText9.Caption:='0';
        Form4.Top:=Form5.Top;
        Form4.Left:=Form5.Left;
        Form4.Show;
        Form5.Hide;
        end;
    end
     else
      begin
      Edit2.Text:=inttostr((StrToint(Edit2.Text)+1));
       //if loesung[0] <> Memo2.Text then
     tar := explode('[]',loesung[0]+'[]-[]-',0);
    if (Memo2.Lines[0] ='')OR(not InArray(Memo2.Lines[0], tar)) then
       begin
    if tar[0] <> '' then begin
        case strtoint(Edit2.Text)  of
         0: Memo2.Lines[0]:=Memo2.Lines[0]+tar[0][strtoint(Edit2.Text)];
         1: Memo2.Lines[0]:=Memo2.Lines[0]+tar[0][strtoint(Edit2.Text)]+tar[0][strtoint(Edit2.Text)+1];
         2: Memo2.Lines[0]:=Memo2.Lines[0]+tar[0][strtoint(Edit2.Text)+1]+tar[0][strtoint(Edit2.Text)+2]+tar[0][strtoint(Edit2.Text)+3];
         3: Memo2.Lines[0]:=Memo2.Lines[0]+tar[0][strtoint(Edit2.Text)+3]+tar[0][strtoint(Edit2.Text)+4]+tar[0][strtoint(Edit2.Text)+5];
         4: Memo2.Lines[0]:=tar[0];
         
        end;end;
        
      if tar[1] <> '-' then begin
        case strtoint(Edit2.Text)  of
         0: Memo2.Lines[1]:=Memo2.Lines[1]+tar[1][strtoint(Edit2.Text)];
         1: Memo2.Lines[1]:=Memo2.Lines[1]+tar[1][strtoint(Edit2.Text)]+tar[1][strtoint(Edit2.Text)+1];
         2: Memo2.Lines[1]:=Memo2.Lines[1]+tar[1][strtoint(Edit2.Text)+1]+tar[1][strtoint(Edit2.Text)+2]+tar[1][strtoint(Edit2.Text)+3];
         3: Memo2.Lines[1]:=Memo2.Lines[1]+tar[1][strtoint(Edit2.Text)+3]+tar[1][strtoint(Edit2.Text)+4]+tar[1][strtoint(Edit2.Text)+5];
         4: Memo2.Lines[1]:=tar[1];
         
        end;end;
        
             if tar[2] <> '-' then begin
        case strtoint(Edit2.Text)  of
         0: Memo2.Lines[2]:=Memo2.Lines[2]+tar[2][strtoint(Edit2.Text)];
         1: Memo2.Lines[2]:=Memo2.Lines[2]+tar[2][strtoint(Edit2.Text)]+tar[2][strtoint(Edit2.Text)+1];
         2: Memo2.Lines[2]:=Memo2.Lines[2]+tar[2][strtoint(Edit2.Text)+1]+tar[2][strtoint(Edit2.Text)+2]+tar[2][strtoint(Edit2.Text)+3];
         3: Memo2.Lines[2]:=Memo2.Lines[2]+tar[2][strtoint(Edit2.Text)+3]+tar[2][strtoint(Edit2.Text)+4]+tar[2][strtoint(Edit2.Text)+5];
         4: Memo2.Lines[2]:=tar[2];
         
        end;end;
       end;
      if Edit2.Text = '1' then
      begin
      statictext9.Caption:=inttostr(strtoint(statictext9.caption)+1);
      end;

      Label1.Font.Color:=clRed;
      Label1.Caption:='Falsch!';
      label2.Caption:=datetimetostr(Date+incsecond(Time,strtoint(label3.Caption)));
      end;
       tmp.Free;
       str.Free;
       ch.Free;
    Label1.Font.Size:=16;
end;
procedure TForm5.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
if Key = #13 then begin
Key := #0;
Button1.Click;
end;
end;

procedure TForm5.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Form1.Close;
end;
procedure TForm5.FormCreate(Sender: TObject);
begin
Memo1.Text:='';
Memo2.Text:='';
FileName:=Form1.FileName;
FileCache:=Form1.FileCache;
Path:=Form1.Path;
end;
procedure TForm5.FormShow(Sender: TObject);
var tmp, ch, a, b:TStringlist;
    frage, e, f,ttt:TArray;
    c, d, z:Integer;
begin
    tmp := TStringList.Create;
    tmp.LoadFromFile(FileName);
    ch:=TStringList.Create;
    a:=TStringlist.Create;
    b:=TStringlist.Create;
    ch.SaveToFile(FileCache);
    frage:=explode('|', tmp[0], 3);
   // Memo1.Text:=frage[1];
   ttt:=explode('[]', frage[1]+'[][]', 0);
    Memo1.Text:=''; memo1.Lines.add('');memo1.Lines.add('');memo1.Lines.add('');
    Memo1.Lines[0]:=ttt[0];Memo1.Lines[1]:=ttt[1];Memo1.Lines[2]:=ttt[2];
    StaticText7.Caption:=inttostr(tmp.Count-1);

       a.LoadFromFile(path+':fehler_'+frage[2]+'.csv');

   for c := 0 to a.Count - 1 do begin
    e:=explode('|', a[c], 5);
    b.add(e[0]+'|'+e[1]+'|'+frage[2]);
   end;

   if b.IndexOf(tmp[0]) <> -1 then begin
      z:=b.IndexOf(tmp[0]);
      f:=explode('|', a[z], 3);
      d:=strtoint(f[2]);
      Label5.Caption:=inttostr(d);
      a.Free;
      b.Free;
   end;

   
    tmp.Free;
    ch.Free;
    Memo2.Text:='';
    Memo2.Lines.Add('');
    Memo2.Lines.Add('');
    Memo2.Lines.Add('');
end;
procedure TForm5.Timer1Timer(Sender: TObject);
var
  stopTime: TDateTime;
begin

 stopTime := strtodatetime(label2.caption);
 if Now >= stopTime then begin
 label2.caption:='2';
 label1.Caption:='';
 end;





end;


procedure TForm5.Zeichen5Click(Sender: TObject);
begin
Edit1.Text:=Edit1.Text+'û';
end;

procedure TForm5.Zeichen6Click(Sender: TObject);
begin
Edit1.Text:=Edit1.Text+'ù';
end;

procedure TForm5.Zeichen10Click(Sender: TObject);
begin
Edit1.Text:=Edit1.Text+'ô';
end;



procedure TForm5.Zeichen11Click(Sender: TObject);
begin
Edit1.Text:=Edit1.Text+'ê';
end;

procedure TForm5.Zeichen14Click(Sender: TObject);
begin
Edit1.Text:=Edit1.Text+'ë';
end;

procedure TForm5.Zeichen7Click(Sender: TObject);
begin
Edit1.Text:=Edit1.Text+'''';
end;

procedure TForm5.Zeichen1Click(Sender: TObject);
begin
Edit1.Text:=Edit1.Text+'ç';
end;

procedure TForm5.Zeichen2Click(Sender: TObject);
begin
Edit1.Text:=Edit1.Text+'Ç';
end;



procedure TForm5.Zeichen12Click(Sender: TObject);
begin
Edit1.Text:=Edit1.Text+'é';
end;

procedure TForm5.Zeichen9Click(Sender: TObject);
begin
Edit1.Text:=Edit1.Text+'î';
end;

procedure TForm5.Zeichen13Click(Sender: TObject);
begin
Edit1.Text:=Edit1.Text+'è';
end;



procedure TForm5.Zeichen8Click(Sender: TObject);
begin
Edit1.Text:=Edit1.Text+'ï';
end;



procedure TForm5.Zeichen3Click(Sender: TObject);
begin
Edit1.Text:=Edit1.Text+'â';
end;

procedure TForm5.Zeichen4Click(Sender: TObject);
begin
Edit1.Text:=Edit1.Text+'à';
end;


end.
