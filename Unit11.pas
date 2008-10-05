unit Unit11;

interface

uses
  Printers,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Math, jpeg, ExtCtrls, ActnList;

type
  TForm11 = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    StaticText1: TStaticText;
    Edit1: TEdit;
    CB1: TComboBox;
    CB2: TComboBox;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    Button3: TButton;
    BitBtn2: TBitBtn;
    PrintDialog: TPrintDialog;
    ActionList1: TActionList;
    Action1: TAction;
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Action1Execute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
        BlattBreite, BlattHoehe,
    EtikettBreite, EtikettHoehe,
    Rand, ZeilenHoehe,i : INTEGER;
    str:TStringlist;
  public
    { Public-Deklarationen }
  end;

var
  Form11: TForm11;

implementation

uses FastStrings, Unit1, Unit10, Unit2, Unit3, Unit4, Unit6, Unit7, Unit8;

{$R *.dfm}
function Zs(Von, Bis: Integer): Integer;
begin
Randomize;
  Result := Random(Succ(Bis - Von)) + Von;
end;
function textwrap(textstr:String; onum:Integer; BOOL:Boolean; zs:String; tr:Boolean=False)  :String;
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
function IsNumeric(value: string): boolean;
var iDummy: integer;
begin
result := true;
try
idummy := StrToInt(value);
except
result := false;
end;
end;

procedure TForm11.Action1Execute(Sender: TObject);
begin
Form1.Button4.Click;
end;

procedure TForm11.BitBtn2Click(Sender: TObject);
var vs:Boolean;
begin
vs:=true;
Memo1.Visible:=not vs;
Button2.Visible:=not vs;
Button3.Visible:=not vs;
Statictext1.Visible:=vs;

Statictext3.Visible:=vs;
Statictext4.Visible:=vs;
Memo1.Text:='';
CB1.Visible:=vs;
CB2.Visible:=VS;
Edit1.Visible:=VS;
Button1.Visible:=VS;
Form1.Top:=Top;
Form1.Left:=Left;
Form1.Show;
Hide;
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

procedure TForm11.Button1Click(Sender: TObject);
var vs:Boolean;
    tmp:TStringlist;
    m,z,z2,u:Integer;
    path,strtmp,a,b:String;
    tar:TArray;
begin

if (not IsNumeric(Edit1.Text))or(edit1.Text = '') then begin showmessage('Bitte eine Zahl eingeben!'); exit; end;

vs:=false;
path:=Form1.Path;
Memo1.Visible:=not vs;
Button2.Visible:=not vs;
Button3.Visible:=not vs;
Statictext1.Visible:=vs;

Statictext3.Visible:=vs;
Statictext4.Visible:=vs;
CB1.Visible:=vs;
CB2.Visible:=VS;
Edit1.Visible:=VS;
Button1.Visible:=VS;

str := TStringList.Create;
tmp := TStringList.Create;


for z:=strtoint(CB1.text) to strtoint(CB2.text) do begin
tmp.LoadFromFile(path+':'+inttostr(z)+'.csv');


   for m := 0 to tmp.Count - 1 do  begin

   strtmp:=tmp[m];
   str.add(strtmp);
   end;

    
    end;

for z2 := 0 to ZS(1, 100) do         begin

for z := 0 to str.Count-1 do begin
 u := random(str.Count-1);
 a := str[z];
 b := str[u];
str[z]:=b;
str[u]:=a;
end;
        end;
i:=0;
if strtoint(Edit1.text) > str.count-1 then i:=str.count-1
else i:=strtoint(Edit1.text)-1;

for z := 0 to i do begin
     tar := explode('|', str[z], 0);

tar[0]:=StringReplace(tar[0], '[]', ' // ', [rfReplaceAll]);
tar[1]:=StringReplace(tar[1], '[]', ' // ', [rfReplaceAll]);
Memo1.Lines.Add(''+tar[1]+#10+'     _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _');
memo1.Lines.add('');

//tar:=explode('|', Str[z],0);
//Memo1.lines.add(tar[0]);
end;
 tmp.Free;

end;


function loesungsblatt(loesung:Boolean):Boolean;
var
    XX,yy,tmp,ii,al,seitenzahl : INTEGER;
    sts:TStringlist;
    letters,txt,s,dan:String;
    tar:TArray;
begin
if loesung = true then  begin
with Form11 do begin


sts:=TStringList.Create;
sts.Add(' _-$-_ ');

for al:=0 to str.count-1 do begin
  sts.add(str[al]);
end;

Seitenzahl:= (strtoint(Edit1.Text) div 23);
xx :=  ((Printer.PageWidth DIV 3)div 10);

   Printer.Canvas.Font.Name := 'Times New Roman';//'Arial';
   BlattBreite := Printer.PageWidth;
   BlattHoehe := Printer.PageHeight;
   ZeilenHoehe := ((Printer.PageHeight DIV 6) DIV 8);
   Printer.Canvas.Font.Color := clblack;
   Printer.Canvas.Font.Size := 12;
   Printer.Title:='Cadac - Test';

         PrintDialog.Copies:=1;
         PrintDialog.Options:=[poPageNums];

if PrintDialog.Execute then begin
 tmp:=1;
 Printer.BeginDoc;   WITH Printer.Canvas DO BEGIN

 for ii := 0 to strtoint(edit1.text) do begin
if sts[ii]=' _-$-_ ' then    begin
dan:='Lektion '+cb1.Text+' bis '+cb2.Text+'         LOESUNGEN ---- LOESUNGEN ---- LOESUNGEN';
TextOut (BlattBreite-Printer.Canvas.TextWidth(dan),Yy+Zeilenhoehe div 2, dan);
end;  if (sts[ii]<>' _-$-_ ')and(sts[ii]<>'') then begin

 if(tmp<ceil(ii/23)) then begin Printer.NewPage; Yy:=rand;          end;
 tmp:=ceil(ii/23);
    letters:='-------------------------------';
    letters:=letters+'---------------------------------------------------------------';
             tar:=explode('|', sts[ii], 0);
             tar[1]:=StringReplace(tar[1], '[]', ' // ', [rfReplaceAll]);
             tar[1]:=StringReplace(tar[1], #13, '', [rfReplaceAll]);

yy:=Yy+ZeilenHoehe; TextOut (Xx,Yy+ZeilenHoehe, inttostr(ii)+') '+tar[1]);
yy:=Yy+ZeilenHoehe; TextOut (12*Xx,Yy+ZeilenHoehe, letters);
                    TextOut (12*Xx,Yy+ZeilenHoehe-20, tar[0]);

Printer.Canvas.MoveTo (0, Yy+ZeilenHoehe+ZeilenHoehe div 2+5);
Printer.Canvas.LineTo (BlattBreite, Yy+ZeilenHoehe+ZeilenHoehe div 2+45);


   end;
 end;


end;Printer.EndDoc;

end;



end;
               end;   


end;
procedure TForm11.Button2Click(Sender: TObject);
   VAR
    XSpalte, YZeile,
    Sp, Zl,nr,al,seitenzahl,x,non,nan,ca,ii,nombre,

    Xx,Yy,szaktuell,tmp: INTEGER;
    sts:TStringlist;
    letters,txt,s,dan:String;
    tar:TArray;
    loesung:Boolean;
begin


sts:=TStringList.Create;
sts.Add(' _-$-_ ');

for al:=0 to str.count-1 do begin
  sts.add(str[al]);
end;


if PrintDialog.Execute then begin
Seitenzahl:= (strtoint(Edit1.Text) div 23);
xx :=  ((Printer.PageWidth DIV 3)div 10);

   Printer.Canvas.Font.Name := 'Times New Roman';//'Arial';
   BlattBreite := Printer.PageWidth;
   BlattHoehe := Printer.PageHeight;
   ZeilenHoehe := ((Printer.PageHeight DIV 6) DIV 8);
   Printer.Canvas.Font.Color := clblack;
   Printer.Canvas.Font.Size := 12;
   Printer.Title:='Cadac - Test';


       s := InputBox('Kopien', 'Wie viele Male soll der Test gedruckt werden?','1');

    if(isnumeric(s)) then   PrintDialog.Copies:=strtoint(s)
    else PrintDialog.Copies:=1;
         PrintDialog.Options:=[poPageNums];

 tmp:=1;
 Printer.BeginDoc;   WITH Printer.Canvas DO BEGIN

 for ii := 0 to strtoint(edit1.text) do begin
if sts[ii]=' _-$-_ ' then    begin
dan:='Lektion '+cb1.Text+' bis '+cb2.Text+'         Datum:________________ Name:_______________ Klasse:____';
TextOut (BlattBreite-Printer.Canvas.TextWidth(dan),Yy+Zeilenhoehe div 2, dan);
end;  if (sts[ii]<>' _-$-_ ')and(sts[ii]<>'') then begin

 if(tmp<ceil(ii/23)) then begin Printer.NewPage; Yy:=rand;          end;
 tmp:=ceil(ii/23);
    letters:='-------------------------------';
    letters:=letters+'---------------------------------------------------------------';
             tar:=explode('|', sts[ii], 0);
             tar[1]:=StringReplace(tar[1], '[]', ' // ', [rfReplaceAll]);
             tar[1]:=StringReplace(tar[1], #13, '', [rfReplaceAll]);

yy:=Yy+ZeilenHoehe; TextOut (Xx,Yy+ZeilenHoehe, inttostr(ii)+') '+tar[1]);
yy:=Yy+ZeilenHoehe; TextOut (8*Xx,Yy+ZeilenHoehe, letters);

Printer.Canvas.MoveTo (0, Yy+ZeilenHoehe+ZeilenHoehe div 2+5);
Printer.Canvas.LineTo (BlattBreite, Yy+ZeilenHoehe+ZeilenHoehe div 2+45);

 {Printer.Canvas.MoveTo (BlattBreite-210-10,(Yy+ZeilenHoehe+ZeilenHoehe div 2+5)-20);
 Printer.Canvas.LineTo (BlattBreite-10-10, (Yy+ZeilenHoehe+ZeilenHoehe div 2+5)-20);
 Printer.Canvas.MoveTo (BlattBreite-210-10,(Yy+ZeilenHoehe+ZeilenHoehe div 2+5)-20-180);
 Printer.Canvas.LineTo (BlattBreite-10-10, (Yy+ZeilenHoehe+ZeilenHoehe div 2+5)-20-180);{}
///////////////////////////////////////

{ Printer.Canvas.MoveTo (BlattBreite-210-9,(Yy+ZeilenHoehe+ZeilenHoehe div 2+5)-20-179);
 Printer.Canvas.LineTo (BlattBreite-210-9, (Yy+ZeilenHoehe+ZeilenHoehe div 2+5)-19);
 Printer.Canvas.MoveTo (BlattBreite-10-9,(Yy+ZeilenHoehe+ZeilenHoehe div 2+5)-20-179);
 Printer.Canvas.LineTo (BlattBreite-10-9, (Yy+ZeilenHoehe+ZeilenHoehe div 2+5)-19);{ }


   end;
 end;


end;Printer.EndDoc;

              loesung:=False;
if MessageDlg('Soll ein Lösungsblatt gedruckt werden?', mtConfirmation, [mbyes, mbno], 0) = mrYes then
begin
loesung:=True;
end;
               loesungsblatt(loesung);
              end;


end;


procedure TForm11.Button3Click(Sender: TObject);
var vs:Boolean;
begin
vs:=true;
Memo1.Text:='';
Memo1.Visible:=not vs;
Button2.Visible:=not vs;
//Button3.Visible:=not vs;
Statictext1.Visible:=vs;

Statictext3.Visible:=vs;
Statictext4.Visible:=vs;
CB1.Visible:=vs;
CB2.Visible:=VS;
Edit1.Visible:=VS;
Button1.Visible:=VS;
end;

procedure TForm11.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
if Key=#13 then Button1.Click;
end;

procedure TForm11.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Form1.Close;
end;

procedure TForm11.FormCreate(Sender: TObject);
begin
Constraints.MaxHeight:=Constraints.MinHeight;
Constraints.MaxWidth:=Constraints.MinWidth;
Image1.Picture:=Form1.Image1.Picture;
end;

procedure TForm11.FormShow(Sender: TObject);
begin
CB1.Itemindex:=Form1.Edit1.Itemindex;
CB2.ItemIndex:=Form1.Edit2.Itemindex;
Memo1.Text:='';
end;

end.
