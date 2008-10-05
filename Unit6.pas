unit Unit6;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FastStrings, Buttons, ExtCtrls, jpeg, ActnList;

type
  TForm6 = class(TForm)
    Edit1: TEdit;
    Button1: TBitBtn;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Memo1: TMemo;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    Image1: TImage;
    ActionList1: TActionList;
    Action1: TAction;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Action1Execute(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    path:String;
  end;

var
  Form6: TForm6;

implementation

uses Unit1, Unit2, Unit3, Unit4, Unit7;

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

procedure TForm6.Action1Execute(Sender: TObject);
begin
Form1.Button4.Click;
end;

procedure TForm6.BitBtn2Click(Sender: TObject);
begin
Form1.Top:=Form6.Top;
Form1.Left:=Form6.Left;
Form1.Show;
Form6.Hide;
end;

procedure TForm6.Button1Click(Sender: TObject);
var StringList:TStringList;
    posi,i,le, medit0:integer;
    t:string;
    medit1, medit2, medit3:TEdit;
    tar:TArray;
    i2:Word;
begin
  path:=Form1.Path;
  StringList := TStringList.Create;
  { Medit1.Free;
   Medit2.Free;
   Medit3.Free;  }

  if(Edit1.Text = '') then begin showmessage('Bitte eine Eingabe machen...'); exit;end;

  if(Edit1.Text = '''') then begin showmessage('Bitte eine Eingabe machen...'); exit;end;

  try

  for i2:=ComponentCount-1 downto 0 do If SmartPos('medit',Components[i2].Name, false)<>0 Then Components[i2].Free;
  medit0:=Edit2.Top;

  for le := strtoint(Form1.edit1.Items[0]) to strtoint(Form1.edit1.Items[Form1.edit2.Items.Count-1]) do begin
    StringList.LoadFromFile(path+':'+inttostr(le)+'.csv');
    //delete(s, 1, pos('<Startwort>', s) + length('<Startwort>') - 1);

   for i := 0 to stringlist.Count-1  do  begin
     t:=StringList[i];

     posi := SmartPos(Edit1.Text, t, False);

     if (posi <> 0) then begin

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
  MEdit1.Parent:=Form6; // fehlt bei dir, daher kann dein Edit sonstwo sein
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
  MEdit2.Parent:=Form6; // fehlt bei dir, daher kann dein Edit sonstwo sein


  MEdit3:=TEdit.Create(Self); // damit erstellst du dein Editfeld erst...
  MEdit3.Color:=edit4.color;
  MEdit3.ReadOnly:=True;
  MEdit3.Width:=Edit4.Width;
  Medit3.Height:=Edit4.Height;
  MEdit3.Name:='Medit3_'+inttostr(le)+'_'+inttostr(i);
  Medit3.Top:=Medit0+25;         // und nun die einzelnen Eigenschaften setzen
  Medit3.Left:=Edit4.Left;
  Medit3.Text:=inttostr(le);
  MEdit3.Font.Name:='Arial';
  Medit3.Font.Size:=10;
  MEdit3.Parent:=Form6; // fehlt bei dir, daher kann dein Edit sonstwo sein
  //Medit.Free;
  Medit0:=Medit0+25;
        end;
  end;
   end; 
  finally
   StringList.Free;
  end;

 end;

procedure TForm6.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
if Key = #13 then begin
Button1Click(SENDER);
Key := #0; 
end;
end;

procedure TForm6.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Form1.Close;
end;

procedure TForm6.FormCreate(Sender: TObject);
begin
Memo1.Text:='';
Memo1.Lines.Add('Gib den Suchbegriff (Deutsch oder '+Form1.lng+') in das');
Memo1.Lines.Add('Textfeld unten ein und klicke auf das Lupensymbol');
Memo1.Lines.Add('');
Memo1.Lines.Add('Es werden dann alle Einträge durchsucht.');
Memo1.Lines.Add('Hinweis: Der Vorgang kann bis zu 10 Sekunden dauern.');
Edit2.Text:='                              '+Form1.lng;
Image1.Picture:=Form1.Image1.Picture;
end;

end.
