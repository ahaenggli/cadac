unit Unit14;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm14 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Printer: TForm14;

implementation

{$R *.dfm}

procedure TForm14.Button1Click(Sender: TObject);
var
xspalte, zeilenhoehe, yzeile:Integer;
begin
xspalte:=10;
zeilenhoehe:=10;
yzeile:=10;
 Printer.Canvas.MoveTo (20+XSpalte,20+YZeile+3);
 Printer.Canvas.LineTo (20+XSpalte,37+YZeile+zeilenhoehe-3);
 Printer.Canvas.MoveTo (100+XSpalte,20+YZeile+3);
 Printer.Canvas.LineTo (100+XSpalte,37+YZeile+zeilenhoehe-3);
//////////////////////////
 Printer.Canvas.MoveTo (20+XSpalte,20+YZeile+3);
 Printer.Canvas.LineTo (100+XSpalte,20+YZeile+3);
 Printer.Canvas.MoveTo (20+XSpalte,20+YZeile+zeilenhoehe+3+10);
 Printer.Canvas.LineTo (100+XSpalte,20+YZeile+zeilenhoehe+3+10);
end;

end.
