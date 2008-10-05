unit Unit10;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,Printers, Controls, Forms,
  Dialogs, StdCtrls, FastStrings, Buttons, ExtCtrls, jpeg, IDHTTP, ActnList,
  ComCtrls;

type
  TForm10 = class(TForm)
    Edit4: TEdit;
    Memo1: TMemo;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    Image1: TImage;
    ActionList1: TActionList;
    Action1: TAction;
    BitBtn1: TBitBtn;
    Memo2: TRichEdit;
    Edit2: TMemo;
    Edit3: TMemo;
    procedure BitBtn2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private-Deklarationen }
    from, tom :Integer;
    old:Boolean;
    StringList,stringlist2:TStringList;
  public
    { Public-Deklarationen }
    path:String;
  end;

var
  Form10: TForm10;

implementation

uses Unit1, Unit2, Unit3, Unit4, Unit7, Unit13;

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

procedure TForm10.Action1Execute(Sender: TObject);
begin
Form1.Button4.Click;
end;

procedure TForm10.BitBtn1Click(Sender: TObject);
var MyMS: TMemoryStream;
    MyRTFList : TStringList;
    i:Integer;
    tar,ttt,ttt2:TArray;
begin

  MyRTFList := TStringList.Create;
  MyMS := TMemoryStream.Create;
  try
   MyRTFList.Add('{\rtf1'         //Datei-Kopf-Definition
                +'{\fonttbl{'     //Schrift-Tabelle
                +'\f0 Arial;'     //Farbe Nr. 6 aus der Farbtabelle
                +'\f1 Courier;'
                +'\f2 Verdana;'
                +'\f3 Times New Roman;'
                +'}}');           //schließen
   MyRTFList.Add('{\colortbl;'             //Farben-Tabelle (RGB)
                +'\red0\green0\blue0;'       // \cf1 > clBlack
                +'\red255\green0\blue0;'     // \cf2 > clRed
                +'\red0\green128\blue0;'     // \cf3 > clGreen
                +'\red0\green0\blue255;'     // \cf4 > clBlue
                +'\red255\green128\blue0;'   // \cf5 > DE-Orange
                +'\red\green182\blue255;'    // \cf6 > DE-Blau
                +'}');                     //schließen
                //Werte in Twips, Schrifthöhen in 1/2 Punkt
                //1 twip = 1/1440 inch oder 1/20 Punkt.
                //1 Punkt = 20 Twips
                //Round(Tips/1440*PixelsPerInch) = Pixel
   MyRTFList.Add('\sb165'         //Abstand vor(über) dem Text
                +'\sa75'          //Abstand nach(unter)    "
                +'\ri160'         //Einzug rechts (v. Rand)
                +'\f3'            //Schrift Nr. 3 aus der Farbtabelle
                +'\fs18'          //Schriftgröße in 1/2 Punkten > 18/2 = 9 Punkte = 180 Twips
                +'\qr '+DateToStr(Date())+'' // \qr > rechts ausgerichtet
                +'\par');         //Zeilenumbruch
    MyRTFList.Add('\li560'         //Einzug links (v. Rand)
                +'\f0'            //Schrift zurückgesetzt (\f0 Vorgabeschrift)
                +'\fs28\b'        // \b > Fettschrift
                +'\ql'            //links ausgerichtet
                +'\cf0'           //Farbe Nr. 6 aus der Farbtabelle
                +'Lektionen '+inttostr(from)+' bis '+inttostr(tom)
                +'\par'
                  +'\par');
   MyRTFList.Add('\pard'     //Absatzformatierung zurücksetzen
                +'\plain');  //Zeichenformatierung zurücksetzen
   MyRTFList.Add('\trowd'         //Tabellenabsatz-Definition (in diesem Fall nur eine Zelle)
                +'\trleft160'     //Tabellenabstand zum linken Rand
                +'\trgaph60'      //Abstand zw. linkem Rand und Text in den Zellen
                +'\sb75\sa75'
                +'\cellx8000');   //rechter Rand der Zelle (8000-160 = 7840 Twips Zellenbreite)

   {MyRTFList.Add('\fs20\b\intbl'  // \intbl > Textabsatz liegt in Tabellenzelle
                +' Fundamentale Integer-Typen' //Leerzeichen vor dem String !!!
                +'\cell'          //Zellenende
                +'\row');         //Z e i l e n ende    }
   MyRTFList.Add('\trowd\trleft160\trgaph60\sb75\sa75'
                +'\cellx1000'     //1000-160  =  840 Twips Zellenbreite
                +'\cellx6000'     //4100-1000 = 3100   "         "
                +'\cellx11000');   //8000-4100 = 3900   "         "
   MyRTFList.Add('\fs20\b\intbl'
                +' Lektion\cell'
                +' Deutsch\cell'
                +' '+form1.lng+'\cell\row'
                +'\b0');          //Fettschrift aus



 for I := 0 to stringlist2.Count - 1 do  begin

     tar := explode('|', stringlist2[I], 0);

ttt:=explode('[]', tar[0]+'[]', 0);
ttt2:=explode('[]', tar[1]+'[]', 0);
    MyRTFList.Add('\intbl '+tar[2]+'\cell'
                +'\f0'
                +'\cf1'
                +' '+ttt[0]
             //   +' '+ttt[1]
                +'\cf0'
                +'\f0\cell'
                +' '+ttt2[0]
             //   +' '+ttt2[1]
                +'\cell\row');


     end;
                //  es folgen Block-Formatierungen
                //  geöffnete Klammern immer schließen !!!
                //   {\cf2       -32768}     ist identisch mit:
                //    \cf2       -32768\cf0
                //   {\f1{\cf2  -2147483648}..2147483647}       ist identisch mit
                //     \f1\cf2  -2147483648\cf0..2147483647\f0
   MyRTFList.Add('\pard\fs1\par');
   MyRTFList.Add('\pard\trowd\trleft5450\trgaph60\sb0\sa0\cellx7000');
  // MyRTFList.Add('\fs16\cf5\f2\intbl Auszug aus der Delphi 3-Hilfe\cell\row');
                //Text-Ausrichtung nur über Leerzeichen möglich   }
  // MyRTFList.Add('\fs16\cf1\f0\intbl   Adriano Hänggli   \cell\row');
   MyRTFList.Add('');
   MyRTFList.Add('}');
   MyRtfList.SaveToStream(MyMS);
   MyMS.Seek(soFromBeginning,0);
   Form13.RichEdit1.PlainText := False;
   Form13.RichEdit1.Lines.LoadFromStream(MyMS);
  finally
    MyRTFList.Free;
    MyMS.Free;
  end;

    if (printer.Printers.count = 0) then begin
    showmessage('Kein Drucker vorhanden!') ;
    exit;exit;
  end;
  Form13.ShowModal;
end;
{
var i:Integer;
    tar,ttt,ttt2:TArray;
     TabWidth, COLWIDTH : Integer;
     m:TStringlist;
begin
m:=STringlist;

 for I := 0 to m.Count - 1 do  begin

     tar := explode('|', m[I], 0);

ttt2:=explode('[]', tar[0]+'[][]', 0);
ttt:=explode('[]', tar[1]+'[][]', 0);
Memo2.Lines.Add(ttt[0]+#9+ttt2[0]);
Memo2.Lines.Add(ttt[1]+#9+ttt2[1]);

     end;
  COLWIDTH := 200;
  TabWidth := ColWidth shl 3;
  Memo2.Perform(EM_SETTABSTOPS, 1, Integer(@TabWidth));
end;
                                       }
procedure TForm10.BitBtn2Click(Sender: TObject);
begin
Form1.Top:=Form10.Top;
Form1.Left:=Form10.Left;
Form1.Show;
Form10.Hide;
end;


procedure TForm10.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Form1.Close;
end;

procedure TForm10.FormCreate(Sender: TObject);
begin
Edit2.Text:=Form1.lng;
memo1.Text:='';
 edit4.Height:=24;
 Image1.Picture:=Form1.Image1.Picture;
end;

procedure TForm10.FormHide(Sender: TObject);
begin
StringList.Free;
stringlist2.free;
end;

procedure TForm10.FormShow(Sender: TObject);
var
    posi,i,le, medit0,tmp:integer;
    s,t:string;
    medit1, medit2, medit3:TEdit;
    tar:TArray;
    i2:Word;
begin
old:=Form1.checkbox1.checked;
from:=Form1.from;
tom:=form1.tom;   

   if tom < from then begin
   tmp:=tom;
   tom:=from;
   from:=tmp;
   end;
   
  path:=Form1.Path;
  StringList := TStringList.Create;
  Stringlist2:= TStringlist.Create;
  { Medit1.Free;
   Medit2.Free;
   Medit3.Free;  }
   Memo1.Text:='';

    try

 
  for i2:=ComponentCount-1 downto 0 do If SmartPos('medit',Components[i2].Name, false)<>0 Then Components[i2].Free;

  medit0:=Edit2.Top;
    if old = false then begin
  Memo1.Lines.Add('Hier ist die Liste aller Wörter von Lektion '+inttostr(from)+' bis '+inttostr(tom)+'.');

    end else begin
    Memo1.Lines.Add('Hier ist die Liste aller Wörter von Lektion '+inttostr(from)+' bis '+inttostr(tom)+',');
    Memo1.Lines.Add('die du falsch geschrieben hast.');
    end;
    StringList.Text:='';
  for le := from to tom do begin

  if old = false then begin StringList.LoadFromFile(path+':'+inttostr(le)+'.csv');
      end else begin StringList.LoadFromFile(path+':fehler_'+inttostr(le)+'.csv');end;
    //delete(s, 1, pos('<Startwort>', s) + length('<Startwort>') - 1);

   for i := 1 to stringlist.Count  do  begin
     t:=StringList[i-1];
     tar:=explode('|', t+'| | ', 0);

  MEdit1:=TEdit.Create(Self); // damit erstellst du dein Editfeld erst...
  MEdit1.Color:=edit2.color;
  MEdit1.ReadOnly:=True;
  MEdit1.Width:=Edit2.Width;
  Medit1.Height:=Edit2.Height;
  MEdit1.Name:='Medit1_'+inttostr(le)+'_'+inttostr(i);
  Medit1.Top:=Medit0+25;         // und nun die einzelnen Eigenschaften setzen
  Medit1.Left:=Edit2.Left;
  Medit1.Text:=StringReplace(tar[0], '[]', ' // ', [rfReplaceAll]);
  MEdit1.Font.Name:='Arial';
  Medit1.Font.Size:=10;
  MEdit1.Parent:=Form10; // fehlt bei dir, daher kann dein Edit sonstwo sein
  //Medit.Free;

  MEdit2:=TEdit.Create(Self); // damit erstellst du dein Editfeld erst...
  MEdit2.Color:=edit3.color;
  MEdit2.ReadOnly:=True;
  MEdit2.Width:=edit3.width;
  Medit2.Height:=edit3.height;
  MEdit2.Name:='Medit2_'+inttostr(le)+'_'+inttostr(i);
  Medit2.Top:=Medit0+25;         // und nun die einzelnen Eigenschaften setzen
  Medit2.Left:=Edit3.Left;
  Medit2.Text:=StringReplace(tar[1], '[]', ' // ', [rfReplaceAll]);
  MEdit2.Font.Name:='Arial';
  Medit2.Font.Size:=10;
  Medit2.Font.Color:=clWhite;
  MEdit2.Parent:=Form10; // fehlt bei dir, daher kann dein Edit sonstwo sein

  MEdit3:=TEdit.Create(Self); // damit erstellst du dein Editfeld erst...
  MEdit3.Color:=edit4.color;
  MEdit3.ReadOnly:=True;
  MEdit3.Width:=Edit4.Width;
  Medit3.Height:=Edit4.Height;
  MEdit3.Name:='Medit3_'+inttostr(le)+'_'+inttostr(i);
  Medit3.Top:=Medit0+25;         // und nun die einzelnen Eigenschaften setzen
  Medit3.Left:=Edit4.Left;
  Medit3.Text:=inttostr(le);
  StringList2.add(tar[0]+'|'+tar[1]+'|'+inttostr(le));//StringList[i-1]+'|omgomg|'+inttostr(le)+'.';

  MEdit3.Font.Name:='Arial';
  Medit3.Font.Size:=10;
  MEdit3.Parent:=Form10; // fehlt bei dir, daher kann dein Edit sonstwo sein
  //Medit.Free;
  Medit0:=Medit0+25;

        end;
  end;
   //end; 
  finally
   
  end;
    edit2.SelStart:=0;
    edit2.seltext:='';
 end;



end.
