unit Unit9;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, jpeg;

type
  TForm9 = class(TForm)
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
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private-Deklarationen }
FileName,Filecache,Path:String;
  public
    { Public-Deklarationen }
  end;

var
  Form9: TForm9;

implementation

uses FastStrings, Unit1, Unit2, Unit3, Unit4, Unit5, Unit6, Unit7;

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

procedure TForm9.BitBtn1Click(Sender: TObject);
 var   str, tmp, ch, f_l, fl, a, b, ab:TStringlist;
        loesung, frage, cache, e, f,tar,ttt: TArray;
        fals: String;
        i, zeile, z, c, d:Integer;
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

 a.LoadFromFile(path+':fehler_'+loesung[2]+'.csv');
   for c := 0 to a.Count - 1 do begin
    e:=explode('|', a[c], 5);
    b.add(e[0]+'|'+e[1]+'|'+loesung[2]);
   end;
   if b.IndexOf(str[0]) <> -1 then begin
      z:=b.IndexOf(str[0]);
      f:=explode('|', a[z], 3);
           if statictext8.caption='1'then begin d:=strtoint(f[2])-1; end  else begin d:=strtoint(f[2]); end;
      a.delete(z);
      if d <> 0 then begin a.Add(f[0]+'|'+f[1]+'|'+inttostr(d));end;
   end;
      a.SaveToFile(path+':fehler_'+loesung[2]+'.csv');
    Edit2.Text:='0';
     str.Delete(0);
     str.SaveToFile(FileName);

      if str.Count <> 0 then
      begin

      str.Clear;
      tmp.Clear;
      tmp.LoadFromFile(FileName);

    frage:=explode('|', tmp[0], 3);
    ttt:=explode('[]', frage[0]+'[][]', 0);
    Memo1.Text:=''; memo1.Lines.add('');memo1.Lines.add('');memo1.Lines.add('');
    Memo1.Lines[0]:=ttt[0];Memo1.Lines[1]:=ttt[1];Memo1.Lines[2]:=ttt[2];
     // Memo1.Text:=frage[1];
      Memo2.Text:='';            Memo2.Lines.Add('');
      Memo2.Lines.Add('');
      Memo2.Lines.Add('');

       label5.caption:='0';

    a:=TStringlist.Create;
    b:=TStringlist.Create;
    tmp.LoadFromFile(FileName);
    frage:=explode('|', tmp[0], 3);
  //  Memo1.Text:=frage[1];
        ttt:=explode('[]', frage[0]+'[][]', 0);
    Memo1.Text:=''; memo1.Lines.add('');memo1.Lines.add('');memo1.Lines.add('');
    Memo1.Lines[0]:=ttt[0];Memo1.Lines[1]:=ttt[1];Memo1.Lines[2]:=ttt[2];
    StaticText7.Caption:=inttostr(tmp.Count);

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
    if StaticText7.Caption = StaticText9.Caption then
       begin
       StaticText9.Caption:='0';
       StaticText8.Caption:=inttostr(strtoint(StaticText8.Caption)+1);
       end;
end
       else
        begin
        Memo1.Text:='';
        Memo2.Text:='';          Memo2.Lines.Add('');
      Memo2.Lines.Add('');
        Memo2.Lines.Add('');
        StaticText7.Caption:='0';
        StaticText8.Caption:='1';
        StaticText9.Caption:='0';
        Form4.Top:=Form9.Top;
        Form4.Left:=Form9.Left;
        Form4.Show;
        Form9.Hide;
        end;
 BitBtn1.Visible:=False;
             BitBtn3.Visible:=False;
             Button1.Visible:=True;

end;

procedure TForm9.BitBtn2Click(Sender: TObject);
begin
        Memo1.Text:='';
        Memo2.Text:='';
            Memo2.Lines.Add('');
      Memo2.Lines.Add('');
        Memo2.Lines.Add('');
        StaticText7.Caption:='0';
        StaticText8.Caption:='1';
        StaticText9.Caption:='0';
        Form4.Top:=Form9.Top;
        Form4.Left:=Form9.Left;
                Button1.Visible:=True;
        BitBtn1.Visible:=False;
        BitBtn3.Visible:=False;
        Form4.Show;
        Form9.Hide;
end;

procedure TForm9.BitBtn3Click(Sender: TObject);
 var   str, tmp, ch, f_l, fl, a, b, ab:TStringlist;
        loesung, frage, cache, e, f,tar,ttt: TArray;
        fals: String;
        i, zeile, z, c, d:Integer;
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

   if form1.ende=true then begin ttt := explode('|', str[0], 0);
            str[0]:=ttt[1]+'|'+ttt[0]+'|'+ttt[2];  end;
        tmp.LoadFromFile(path+':fehler_'+loesung[2]+'.csv');
       // showmessage(tmp.text);
          for i := 0 to tmp.Count - 1 do   begin
          // EN|DE|F
           cache := explode('|', tmp[i], 3);
           f_l.Add(cache[0]+'|'+cache[1]+'|'+loesung[2]);
           fl.Add(cache[0]+'|'+cache[1]+'|'+cache[2]);
          end;
          // showmessage(f_l.text);
          // showmessage(fl.text);
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
        //showmessage(fl.text);
        tmp.SaveToFile(path+':fehler_'+loesung[2]+'.csv');
        tmp.Clear;
       
         end;


        ch.LoadFromFile(Filecache);
        if ch.IndexOf(str[0])=-1 then ch.Add(str[0]);
        ch.SaveToFile(Filecache);
        if form1.ende = true then begin ttt := explode('|', str[0], 0);
            str[0]:=ttt[0]+'|'+ttt[1]+'|'+ttt[2]; end;
        str.Add(str[0]);


     Edit2.Text:='0';
     str.Delete(0);
     str.SaveToFile(FileName);

      if str.Count <> 0 then
      begin

      str.Clear;
      tmp.Clear;
      tmp.LoadFromFile(FileName);

    frage:=explode('|', tmp[0], 3);
    ttt:=explode('[]', frage[0]+'[][]', 0);
    Memo1.Text:=''; memo1.Lines.add('');memo1.Lines.add('');memo1.Lines.add('');
    Memo1.Lines[0]:=ttt[0];Memo1.Lines[1]:=ttt[1];Memo1.Lines[2]:=ttt[2];
     // Memo1.Text:=frage[1];
      Memo2.Text:='';            Memo2.Lines.Add('');
      Memo2.Lines.Add('');
      Memo2.Lines.Add('');

       label5.caption:='0';

    a:=TStringlist.Create;
    b:=TStringlist.Create;
    tmp.LoadFromFile(FileName);
    frage:=explode('|', tmp[0], 3);
  //  Memo1.Text:=frage[1];
        ttt:=explode('[]', frage[0]+'[][]', 0);
    Memo1.Text:=''; memo1.Lines.add('');memo1.Lines.add('');memo1.Lines.add('');
    Memo1.Lines[0]:=ttt[0];Memo1.Lines[1]:=ttt[1];Memo1.Lines[2]:=ttt[2];
    StaticText7.Caption:=inttostr(tmp.Count);

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

StaticText9.Caption:=inttostr(strtoint(StaticText9.Caption)+1);
 if StaticText7.Caption = StaticText9.Caption then
       begin
       StaticText9.Caption:='0';
       StaticText8.Caption:=inttostr(strtoint(StaticText8.Caption)+1);
       end;
 end
       else
        begin
        Memo1.Text:='';
        Memo2.Text:='';          Memo2.Lines.Add('');
      Memo2.Lines.Add('');
        Memo2.Lines.Add('');
        StaticText7.Caption:='0';
        StaticText8.Caption:='1';
        StaticText9.Caption:='0';
        Form4.Top:=Form9.Top;
        Form4.Left:=Form9.Left;
        Form4.Show;
        Form9.Hide;
        end;
 BitBtn1.Visible:=False;
             BitBtn3.Visible:=False;
             Button1.Visible:=True;
end;

procedure TForm9.Button1Click(Sender: TObject);
 var   str, tmp, ch, f_l, fl, a, b, ab:TStringlist;
        loesung, frage, cache, e, f,tar,ttt: TArray;
        fals: String;
        i, zeile, z, c, d:Integer;
begin
    str := TStringList.Create;
    str.LoadFromFile(FileName);
    loesung:=explode('|', str[0],3);
     tar := explode('[]',loesung[1]+'[]-[]-',0);
     if tar[0] <> '' then begin
     Memo2.Lines[0]:=tar[0];
     end;
      if tar[1] <> '-' then begin
      Memo2.Lines[1]:=tar[1];
      end;
             if tar[2] <> '-' then begin
             Memo2.Lines[2]:=tar[2];
             end;

             BitBtn1.Visible:=True;
             BitBtn3.Visible:=True;
             Button1.Visible:=False;
              if StaticText7.Caption = StaticText9.Caption then
       begin
       StaticText9.Caption:='0';
       StaticText8.Caption:=inttostr(strtoint(StaticText8.Caption)+1);
       end;
    end;

procedure TForm9.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Form1.Close;
end;

procedure TForm9.FormCreate(Sender: TObject);
begin
Memo1.Text:='';
Memo2.Text:='';
FileName:=Form1.FileName;
Filecache:=Form1.FileCache;
Path:=Form1.Path;
end;

procedure TForm9.FormShow(Sender: TObject);
var tmp, ch, a, b:TStringlist;
    frage, e, f, ttt:TArray;
    c, d, z:Integer;
begin
    tmp := TStringList.Create;
    a:=TStringlist.Create;
    b:=TStringlist.Create;
    tmp.LoadFromFile(FileName);
    ch:=TStringList.Create;
    ch.SaveToFile(Filecache);
    frage:=explode('|', tmp[0], 3);
    ttt:=explode('[]', frage[0]+'[][]', 0);
    Memo1.Text:=''; memo1.Lines.add('');memo1.Lines.add('');memo1.Lines.add('');
    Memo1.Lines[0]:=ttt[0];
    Memo1.Lines[1]:=ttt[1];
    Memo1.Lines[2]:=ttt[2];
    StaticText7.Caption:=inttostr(tmp.Count);

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

end.
