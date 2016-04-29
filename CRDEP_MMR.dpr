program CRDEP_MMR;

uses
  System.StartUpCopy,
  FMX.Forms,
  CRDEP_Unit in 'CRDEP_Unit.pas' {Form2},
  Unit3 in 'Unit3.pas' {Form3},
  Unit5 in 'Unit5.pas' {Form5},
  Unit7 in 'Unit7.pas' {Form7},
  Result_1 in 'Result_1.pas' {Result1},
  Result_2 in 'Result_2.pas' {Result2},
  Rapport in 'Rapport.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
