unit Unit12;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TForm12 = class(TForm)
    Label4: TLabel;
    Label1: TLabel;
    StaticText1: TStaticText;
    BitBtn2: TBitBtn;
    BitBtn1: TBitBtn;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    Button1: TBitBtn;
    StaticText7: TStaticText;
    StaticText8: TStaticText;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    StaticText9: TStaticText;
    StaticText10: TStaticText;
    StaticText11: TStaticText;
    StaticText12: TStaticText;
    StaticText13: TStaticText;
    StaticText14: TStaticText;
    StaticText15: TStaticText;
    StaticText16: TStaticText;
    StaticText17: TStaticText;
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form12: TForm12;

implementation

{$R *.dfm}

procedure TForm12.BitBtn2Click(Sender: TObject);
begin
Hide;
end;

procedure TForm12.FormCreate(Sender: TObject);
begin
Constraints.MaxHeight:=Constraints.MinHeight;
Constraints.MaxWidth:=Constraints.MinWidth;
end;

end.
