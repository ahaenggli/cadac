program Cadac;
uses
  Forms,
  unit1 in 'unit1.pas' {Form1},
  Unit3 in 'Unit3.pas' {Form3},
  Unit7 in 'Unit7.pas' {Form7},
  FastStrings in '..\Units\FastStrings.pas',
  Unit2 in '..\Units\Unit2.pas' {Form2},
  Unit4 in '..\Units\Unit4.pas' {Form4},
  Unit6 in '..\Units\Unit6.pas' {Form6},
  Unit8 in '..\Units\Unit8.pas' {Form8},
  Unit9 in '..\Units\Unit9.pas' {Form9},
  Unit10 in '..\Units\Unit10.pas' {Form10},
  Unit11 in '..\Units\Unit11.pas' {Form11},
  Unit12 in '..\Units\Unit12.pas' {Form12},
  Unit13 in '..\Units\Unit13.pas' {Form13};

{$R *.res}
{$R res.res}
begin
  Application.Initialize;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
