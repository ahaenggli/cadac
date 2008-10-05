unit Unit13;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls;

type
  TForm13 = class(TForm)
    RichEdit1: TRichEdit;
    BitBtn1: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form13: TForm13;

implementation

{$R *.dfm}

procedure TForm13.BitBtn1Click(Sender: TObject);
begin
RichEdit1.Print('Cadac Wörter');
Close;
end;

end.
