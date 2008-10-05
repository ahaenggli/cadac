unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Buttons, Printers, jpeg, ActnList;

type
  TForm4 = class(TForm)
    Label1: TLabel;
    Memo1: TRichEdit;
    BitBtn1: TBitBtn;
    Label2: TLabel;
    Label3: TLabel;
    BitBtn2: TBitBtn;
    Image1: TImage;
    ActionList1: TActionList;
    Action1: TAction;
    Timer1: TTimer;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form4: TForm4;

implementation

uses Unit1, Unit2, Unit3;

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

procedure TForm4.Action1Execute(Sender: TObject);
begin
Form1.Button4.Click;
end;

procedure TForm4.BitBtn1Click(Sender: TObject);
 var
   r: TRect;
begin

    if (printer.Printers.count = 0) then begin
    showmessage('Kein Drucker vorhanden!') ;
    exit;exit;
  end;
    r.left:=2;
    r.Top:=2;
    r.Right:=1;

    Memo1.Pagerect:=r;
    Memo1.Print('Cadac - Fehlerliste');
end;

procedure TForm4.BitBtn2Click(Sender: TObject);
begin
Memo1.Text:='';
Form1.Left:=Form4.Left;
Form1.Top:=Form4.Top;
Form1.Show;
Form4.Hide;
end;

procedure TForm4.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Form1.Close;
end;

procedure TForm4.FormCreate(Sender: TObject);
begin
       Caption:=Form1.name+' [Fehlerliste drucken]';
       Constraints.MaxHeight:=Constraints.MinHeight;
Constraints.MaxWidth:=Constraints.MinWidth;
Image1.Picture:=Form1.Image1.Picture;
end;

procedure TForm4.FormShow(Sender: TObject);
var m:TStringlist;
    tar: Tarray;
    I:integer;
 TabWidth, COLWIDTH : Integer;
begin
Memo1.Text:='';
m:=TStringlist.Create;
m.LoadFromFile(Form1.FileCache);
if m.Text='' then begin Timer1.Enabled:=True; end;

Memo1.Lines.Add('--------------------------------------- Datum: '+DateToStr(Date())+' -------------------------------------------');
     
     for I := 0 to m.Count - 1 do  begin

     tar := explode('|', m[I], 0);

tar[0]:=StringReplace(tar[0], '[]', ' // ', [rfReplaceAll]);
tar[1]:=StringReplace(tar[1], '[]', ' // ', [rfReplaceAll]);
Memo1.Lines.Add(''+tar[1]+#10+'     _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _'+#9+' | '+tar[0]);
memo1.Lines.add('');
     end;
  COLWIDTH := 15;
  TabWidth := ColWidth shl 2;
  Memo1.Perform(EM_SETTABSTOPS, 1, Integer(@TabWidth));

m.Free;
m:=TStringlist.Create;
m.SaveToFile(Form1.FileCache);
m.Free;
end;



procedure TForm4.Timer1Timer(Sender: TObject);
begin
Timer1.Enabled:=False;
BitBtn2.Click;
end;

end.
