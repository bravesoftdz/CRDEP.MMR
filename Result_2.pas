unit Result_2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Rtti,
  Data.Bind.Controls, FMX.StdCtrls, FMX.Layouts, Fmx.Bind.Navigator, FMX.Grid,
  FMX.Controls.Presentation, FMX.Objects, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope,
  CRDEP_Unit,Unit5,Result_1,System.IOUtils,Math, FMX.Ani, FireDAC.FMXUI.Wait;

type
  TResult2 = class(TForm)
    Image1: TImage;
    ScrollBox1: TScrollBox;
    ScrollBox2: TScrollBox;
    GroupBox2: TGroupBox;
    StringGrid3: TStringGrid;
    ScrollBox3: TScrollBox;
    GroupBox1: TGroupBox;
    StringGrid1: TStringGrid;
    ToolBar1: TToolBar;
    Label1: TLabel;
    back: TButton;
    Calcul: TButton;
    btn_Nouvelle_Iteration: TButton;
    btn_retablir_all: TButton;
    btn_EnrgistreExcel: TButton;
    btn_start: TButton;
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    FDQuery2: TFDQuery;
    FDQuery3: TFDQuery;
    FDQuery4: TFDQuery;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    BindSourceDB2: TBindSourceDB;
    BindSourceDB3: TBindSourceDB;
    LinkGridToDataSourceBindSourceDB3: TLinkGridToDataSource;
    ScrollBox4: TScrollBox;
    GroupBox4: TGroupBox;
    StringGrid2: TStringGrid;
    BindNavigator2: TBindNavigator;
    LinkGridToDataSourceBindSourceDB2: TLinkGridToDataSource;
    Rectangle1: TRectangle;
    Rectangle11: TRectangle;
    Button2: TButton;
    ColorAnimation2: TColorAnimation;
    ColorAnimation5: TColorAnimation;
    Button3: TButton;
    ColorAnimation3: TColorAnimation;
    ColorAnimation6: TColorAnimation;
    Rectangle13: TRectangle;
    Rectangle2: TRectangle;
    procedure btn_retablir_allClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure backClick(Sender: TObject);
    procedure AutoSizeGrid(Grid: TStringGrid; Query : TFDQuery);
    procedure btn_EnrgistreExcelClick(Sender: TObject);
    procedure btn_Nouvelle_IterationClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure CalculClick(Sender: TObject);
    procedure btn_startClick(Sender: TObject);
    procedure Rectangle1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Result2: TResult2;
  Iteration : Integer;
implementation

{$IF DEFINED(Win32)or DEFINED(Win64)}
uses Rapport;
{$ENDIF}

//---------------------------------------------
function Diameter_Normalize(Dcal : Real;TC : String;Query:TFDQuery):Real;
var Query1 :TFDQuery;
    I : Integer;
    Diametre,Def,min,max,DN : real;
begin
  Query1 := TFDQuery.Create(Form5);
  Query1.Connection := Query.Connection;
  Query1.Close;
  Query1.SQL.Add('select * from Diametres');
  Query1.Active := true;
  Query1.First;
  I := 1;
  while not(Query1.Eof) do
  begin
    Diametre := Query1.FieldByName(TC).AsFloat;
    if Diametre <> 0 then
    begin
      Def := abs(Diametre - Dcal);
      if (I = 1) then
      begin
        min := Def;
        DN := Diametre;
        I:= 0;
      end
      else
      if (min > Def) then
      begin
        min := Def;
        DN := Diametre;
      end;
    end;
    Query1.Next;
  end;
  if I = 0 then Result := DN
  else
  begin
    Query1.First;
    max := Query1.FieldByName(TC).AsFloat;
    while not(Query1.Eof) do
    begin
      if max < Query1.FieldByName(TC).AsFloat then max := Query1.FieldByName(TC).AsFloat;
      Query1.Next;
    end;
    Result := max;
  end;
end;

//---------------------------------------------
function Calcul_DNTrancons(Query :TFDQuery):boolean;
var NT,NAmont,NAval,TC : String;
    Sens : Integer;
    Q,Long,Reguosite : Real;
    CPAmont,CPAval,CTNAmont,CTNAval,PSAmont,PSAval,Delta_Ht,J1,D,R,Psi,F,J2,PDCTv,V,PDCT,PDCT2 : Real;
    Dcal,DN : Real;
    Query2 :TFDQuery;
    ValRound : Integer;
begin
  Query2 := TFDQuery.Create(Form5);
  Query2.Connection := Query.Connection;
  try
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from Trancons where NT > 0 and ID_Project = '+Form2.ID_Project);
  Query.Active := true;
  finally
  while not(Query.Eof) do
  begin
    //donner
    NT := Query.FieldByName('NT').AsString;
    CTNAmont := Query.FieldByName('CTNAmont').AsFloat;
    CTNAval := Query.FieldByName('CTNAval').AsFloat;
    PSAmont := Query.FieldByName('PSAmont').AsFloat;
    PSAval := Query.FieldByName('PSAval').AsFloat;
    Q := Query.FieldByName('Q2').AsFloat;
    Long := Query.FieldByName('Long').AsFloat;
    Reguosite := Query.FieldByName('Reguosite').AsFloat;
    Sens := Query.FieldByName('Sens').AsInteger;

    Query2.Close;
    Query2.SQL.Clear;
    Query2.SQL.Add('select TC,DC,DN from DNTrancons where NT='+NT+' and ID_Project = '+Form2.ID_Project);
    Query2.Active := true;
    TC := Query2.Fields[0].AsString;
    Dcal := Query2.Fields[1].AsFloat;
    DN := Query2.Fields[2].AsFloat;
    //calcul
    CPAmont := CTNAmont + PSAmont;
    CPAval :=  CTNAval + PSAval;
    ValRound := -5;
    Delta_Ht := RoundTo(CPAmont - CPAval,ValRound);
    J1 := Abs(Delta_Ht / Long);
    D := Power(2*Pi*Pi,-0.2) * Power(Q*Q/9.81/J1,0.2);
    R := 4 * abs(Q)/(Pi * D * 0.000001);
    Psi := 1.35 * Power(-Log10((Reguosite/D/4.75)+(8.5/R)),-0.4);
    {Dcal := Psi * D;
    DN :=Diameter_Normalize(Dcal,TC,Query);}
    F := Power(Psi,5)/16;
    J2 := (8*F*Q*Q)/(9.81*Pi*Pi*Power(DN,5));
    if NT = '0' then
      PDCT := J2*Long
         else
      PDCT := J2*Long*Sens;
         V := 4*abs(Q)/3.14/(DN*DN);
     if NT = '0' then
           PDCT2 := abs(J2*Long)
    else
         PDCT2 := abs(J2*Long*Sens);
    V := 4*abs(Q)/3.14/(DN*DN);

    //update valeur DNTrancon
    Query2.Close;
    Query2.SQL.Clear;
    Query2.SQL.Add('update DNTrancons set DC='+FloatToStr(Dcal)+',DN='+FloatToStr(DN)+',D='+FloatToStr(D)+',R='+FloatToStr(R)+',Psi='+FloatToStr(Psi)+',F='+FloatToStr(F)+',J2='+FloatToStr(J2)+',PDCT='+FloatToStr(PDCT)+',PDCT2='+FloatToStr(PDCT2)+',V='+FloatToStr(V)+' where NT='+NT+' and ID_Project = '+Form2.ID_Project);
    Query2.ExecSQL;
    Query.Next;
  end;
  end;
  Result := true;
end;


//---------------------------------------------
//---------------------------------------------
function ResultTrancons(Query :TFDQuery):boolean;
var NT,MP,NAmont,NAval : String;
    Q,QCorrige,Dq : Real;
    Query2,Query3 :TFDQuery;
begin
  Query2 := TFDQuery.Create(Form5);
  Query2.Connection := Query.Connection;
  Query3 := TFDQuery.Create(Form5);
  Query3.Connection := Query.Connection;

  try
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select NT,MP,Q2 from Trancons where NT > 0 and ID_Project = '+Form2.ID_Project);
  Query.Active := true;
  finally
  while not(Query.Eof) do
  begin
    //donner
    NT := Query.FieldByName('NT').AsString;
    MP := Query.FieldByName('MP').AsString;
    Q := Query.FieldByName('Q2').AsFloat;
    Query2.Close;
    Query2.SQL.Clear;
    Query2.SQL.Add('select [D q(m3/s)] from Erreur_mailles where MP='+MP+' and ID_Project = '+Form2.ID_Project);
    try
      Query2.Active := true;
    Except
      ShowMessage('Re-entrer des valeurs le trançon NT :'+NT);
    end;
    Dq := Query2.Fields[0].AsFloat;
    //calcul
    QCorrige := Q + Dq;
    //update Table DNTrancons
    Query2.Close;
    Query2.SQL.Clear;
    Query2.SQL.Add('Update DNTrancons set QCorrige='+FloatToStr(QCorrige)+' where NT = '+NT+' and ID_Project = '+Form2.ID_Project+';');
    try
      Query2.ExecSQL;
    Except
      ShowMessage('requate invalide');
      Result := false;
    end;
    Query.Next;
  end;
  Result := true;
  end;
end;


//---------------------------------------------
//---------------------------------------------



{$R *.fmx}
{$R *.Windows.fmx MSWINDOWS}
{$R *.Surface.fmx MSWINDOWS}
{$R *.Macintosh.fmx MACOS}

procedure TResult2.backClick(Sender: TObject);
begin
  Rectangle1.Visible := true;
  Rectangle11.Visible := true;
end;

procedure TResult2.btn_EnrgistreExcelClick(Sender: TObject);
begin
{$IF DEFINED(Win32)or DEFINED(Win64)}
  TForm1.Create(self);
  TForm1.Create(self).PrintClick(Sender);
{$ENDIF}
end;

procedure TResult2.btn_Nouvelle_IterationClick(Sender: TObject);
var QCorrige : Real;
    NT : String;
begin
  FDQuery4.Close;
  FDQuery4.SQL.Clear;
  FDQuery3.First;
  while not(FDQuery3.Eof) do
  begin
    NT := FDQuery3.FieldByName('NT').AsString;
    QCorrige := FDQuery3.Fields[10].AsFloat;
    {if abs(QCorrige) < 0.5 then
    begin

    end;}
    //update Table DNTrancons
    FDQuery4.SQL.Add('Update Trancons set Q2='+FloatToStr(QCorrige)+' where NT = '+NT+' and ID_Project = '+Form2.ID_Project+';');
    FDQuery3.Next;
  end;

  try
    FDQuery4.ExecSQL;
    Calcul_DNTrancons(FDQuery4);
    ResultTrancons(FDQuery4);
    FDQuery4.Close;
    FDQuery4.SQL.Clear;
    FDQuery4.SQL.Add('update Logins set Status = Status + 1 where ID='+Form2.ID_Project);
    FDQuery4.ExecSQL;
    Form2.Status := Form2.Status + 1;

    FDQuery2.Close;
    FDQuery3.Close;
    FDQuery2.Active := true;
    AutoSizeGrid(StringGrid2,FDQuery2);
    FDQuery3.Active := true;
    AutoSizeGrid(StringGrid3,FDQuery3);
    Iteration := Iteration + 1;
    btn_Nouvelle_Iteration.Text := 'Nouvelle Itération ('+IntToStr(Iteration)+')';

  Except
    ShowMessage('Stop process iteration');
  end;



end;

procedure TResult2.btn_retablir_allClick(Sender: TObject);
begin
  FDQuery4.Close;
  FDQuery4.SQL.Clear;
  FDQuery4.SQL.Add('update Logins set Status = 1 where ID='+Form2.ID_Project);
  FDQuery4.ExecSQL;
  Form2.Status := 1;
  TForm5.Create(Owner).Show;
  self.Release;
end;

procedure TResult2.btn_startClick(Sender: TObject);
begin
  btn_Nouvelle_IterationClick(Sender);
  btn_start.Text := 'Nouvelle Itération ('+IntToStr(Iteration)+')';
end;

procedure TResult2.Button3Click(Sender: TObject);
begin
  btn_retablir_allClick(Sender);
end;

procedure TResult2.CalculClick(Sender: TObject);
begin
  Form2.Show;
  Self.Release;
end;

procedure TResult2.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
{$IF DEFINED(Win32)or DEFINED(Win64)}
  Form2.Show;
  Self.Release;
{$ENDIF}
end;

procedure TResult2.FormCreate(Sender: TObject);
begin
{$IF DEFINED(Win32)or DEFINED(Win64)}
  btn_Nouvelle_Iteration.Visible := true;
  btn_retablir_all.Visible := true;
  btn_EnrgistreExcel.Visible := true;
{$ENDIF}

  if Form2.Type_Reseau = 'Ramifie' then
  begin
    ScrollBox4.Visible := false;
  {$IF DEFINED(Win32)or DEFINED(Win64)}
    btn_Nouvelle_Iteration.Visible := false;
    ScrollBox3.Width := 1020;
    ScrollBox2.Width := 1020;
    ScrollBox2.Position.Y := 240;
  {$ENDIF}
  {$IF DEFINED(iOS)or DEFINED(ANDROID)}
    btn_start.Visible := false;
  {$ENDIF}
  end;

{$IF DEFINED(Win32)or DEFINED(Win64)}
  FDConnection1.Close;
  FDConnection1.Params.Values['ColumnMetadataSupported']:='False';
  FDConnection1.Params.Values['Database']:='test.db';
{$ENDIF}
{$IF DEFINED(iOS)or DEFINED(ANDROID)}
  FDConnection1.Close;
  FDConnection1.Params.Values['ColumnMetadataSupported']:='False';
  FDConnection1.Params.Values['Database']:=TPath.Combine(TPath.GetDocumentsPath,'test.db');
{$ENDIF}
  try
    FDConnection1.Connected := true;
    try
      FDQuery1.SQL.Clear;
      if Form2.Type_Reseau = 'Maille' then
        FDQuery1.SQL.Add('Select NAmont,NAval,[DC(m)],TC,[DN(m)],[V(m/s)],[PDCT(m)],[CPR(m)],[CP1(m)],[PSAmont(m.c.e)],[PSAval(m.c.e)] from VResulta_TReservoir where ID_Project = '+Form2.ID_Project+';')
      else
        FDQuery1.SQL.Add('Select NAmont,NAval,[Qp(m3/s)],[DC(m)],TC,[DN(m)],[V(m/s)],[PDCT(m)],[CPR(m)],[CP1(m)],[PSAmont(m.c.e)],[PSAval(m.c.e)] from VResulta_TReservoir where ID_Project = '+Form2.ID_Project+';');
      FDQuery1.Active := true;
      AutoSizeGrid(StringGrid1,FDQuery1);

      if Form2.Type_Reseau = 'Maille' then
      begin
        FDQuery2.SQL.Clear;
        FDQuery2.SQL.Add('select MP,printf("%.5f",[Som DH]) AS [Som DH],printf("%.5f",[Som DH/Q]) AS [Som DH/Q],printf("%.5f",[D q(m3/s)]) AS [Dq(m3/s)] from Erreur_mailles where ID_Project='+Form2.ID_Project);
        FDQuery2.Active := true;
        AutoSizeGrid(StringGrid2,FDQuery2);
      end
      else
        ScrollBox4.Visible := false;

      FDQuery3.SQL.Clear;
      if Form2.Type_Reseau = 'Maille' then
        FDQuery3.SQL.Add('select NT,MP,MA,NAmont,NAval,[DC(m)],TC,[DN(m)],[V(m/s)],[PDCT(m)],[Q Corrige(m3/s)],[CPAmont(m)],[CPAval(m)],[PSAmont(m.c.e)],[PSAval(m.c.e)] from VResulta_TranconMaille where ID_Project = '+Form2.ID_Project+';')
      else
        FDQuery3.SQL.Add('select NT,NAmont,NAval,[Qp(m3/s)],[DC(m)],TC,[DN(m)],[V(m/s)],[PDCT(m)],[CPAmont(m)],[CPAval(m)],[PSAmont(m.c.e)],[PSAval(m.c.e)] from VResulta_TranconRamifie where ID_Project = '+Form2.ID_Project+';');

      FDQuery3.Active := true;
      AutoSizeGrid(StringGrid3,FDQuery3);
    Except
      ShowMessage('Requate invalide');
    end;

  Except
    ShowMessage('Connection échouée');
    Close;
  end;
  Iteration := Form2.Status-3;
  btn_Nouvelle_Iteration.Text := 'Nouvelle Itération ('+IntToStr(Form2.Status-3)+')';
  btn_start.Text := 'Nouvelle Itération ('+IntToStr(Form2.Status-3)+')';


end;
procedure TResult2.Rectangle1Click(Sender: TObject);
begin
  if Rectangle11.Visible then
  begin
    Rectangle1.Visible := false;
    Rectangle11.Visible := false;
  end;

end;

procedure TResult2.AutoSizeGrid(Grid: TStringGrid; Query : TFDQuery);
var
  C : integer;
begin
  //ShowMessage('Column name :'+Grid.Columns[C].Header+' lenght : '+IntToStr(Grid.Columns[C].Header.Length)+' Display Width : '+IntToStr(Query.FieldByName(Grid.Columns[C].Header).DisplayWidth));
  for C := 0 to Grid.ColumnCount - 1 do begin
    if Grid.Columns[C].Header.Length >= Query.FieldByName(Grid.Columns[C].Header).DisplayWidth then
      Grid.Columns[C].Width := Grid.Columns[C].Header.Length * 8
    else
      Grid.Columns[C].Width := Query.FieldByName(Grid.Columns[C].Header).DisplayWidth * 6 + 10;

    if Grid.Columns[C].Width > 120 then Grid.Columns[C].Width := 100;

  end;

end;


end.
