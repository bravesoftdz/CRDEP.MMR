unit Result_1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Objects, System.Rtti, Data.Bind.Controls, Fmx.Bind.Navigator, FMX.Grid,
  FMX.StdCtrls, FMX.Controls.Presentation, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, Data.DB,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope, FMX.ListBox,
  FireDAC.FMXUI.Wait;

type
  TResult1 = class(TForm)
    Image1: TImage;
    ScrollBox1: TScrollBox;
    ToolBar1: TToolBar;
    Label1: TLabel;
    back: TButton;
    Calcul: TButton;
    ScrollBox2: TScrollBox;
    GroupBox2: TGroupBox;
    ScrollBox3: TScrollBox;
    GroupBox1: TGroupBox;
    StringGrid1: TStringGrid;
    ScrollBox4: TScrollBox;
    GroupBox3: TGroupBox;
    StringGrid3: TStringGrid;
    BindNavigator3: TBindNavigator;
    StringGrid2: TStringGrid;
    BindNavigator2: TBindNavigator;
    btn_calcul: TButton;
    FDQuery1: TFDQuery;
    FDConnection1: TFDConnection;
    FDQuery2: TFDQuery;
    FDQuery3: TFDQuery;
    BindNavigator1: TBindNavigator;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    BindSourceDB2: TBindSourceDB;
    LinkGridToDataSourceBindSourceDB2: TLinkGridToDataSource;
    BindSourceDB3: TBindSourceDB;
    LinkGridToDataSourceBindSourceDB3: TLinkGridToDataSource;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    FDQuery4: TFDQuery;
    ComboBox3: TComboBox;
    Label2: TLabel;
    Button1: TButton;
    btn_start: TButton;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    procedure backClick(Sender: TObject);
    procedure btn_calculClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CalculClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AutoSizeGrid(Grid: TStringGrid ; Query: TFDQuery);
    procedure StringGrid2SelectCell(Sender: TObject; const ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; const ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure ComboBox3Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btn_startClick(Sender: TObject);
    procedure FDQuery2AfterPost(DataSet: TDataSet);
    procedure FDQuery1AfterPost(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Result1: TResult1;
  Row2,Col2,Col1,Row1: Integer;
  C1,C2 : boolean;
implementation

uses CRDEP_Unit,Unit5,Result_2,System.IOUtils,Math;
{$R *.fmx}
{$R *.Windows.fmx MSWINDOWS}
{$R *.SmXhdpiPh.fmx ANDROID}

//---------------------------------------------
//---------------------------------------------
function ResultTrancons(Query :TFDQuery):boolean;
var NT,MP,NAmont,NAval : String;
    Q,QCorrige,Dq : Real;
    Query2 :TFDQuery;
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
    MP := Query.FieldByName('MP').AsString;
    Q := Query.FieldByName('Q').AsFloat;
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

//------------------------------------------------------
// Calcul Diameter Normalize
//-------------------------------------------------------
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
      Def := (Diametre - Dcal);
      if (I = 1) and (Def > 0)then
      begin
        min := Def;
        DN := Diametre;
        I:= 0;
      end
      else
      if (min > Def) and (Def > 0) then
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
//------------------------------------------------------
// Calcul CPAmont et CPAval dun reseau Maille et Ramifier
//-------------------------------------------------------
//---------------------------------------------
function Separe(S,Pos1,Pos2:String):String;
begin
  Result := S.Substring(S.IndexOf(Pos1)+Pos1.Length,S.IndexOf(Pos2)-(S.IndexOf(Pos1)+Pos1.Length));
end;

procedure Calcul_CPAmontETAval(Query:TFDQuery);
var O,C:TStringList;
    S1,S2,NT,ID : String;
    I,J,H,K,L: Integer;
    Max_CPAmont :Real;

begin
//initialization
  ID := Form2.ID_Project;
  O := TStringList.Create;
  C := TStringList.Create;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select NAval,[CP1(m)] from VResulta_TReservoir where ID_Project='+ID);
  Query.Active := true;
  O.Add('<AV>'+Query.Fields[0].AsString+'</AV><CP>'+Query.Fields[1].AsString+'</CP>');
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select NT,NAmont,NAval from DNTrancons where NT > 0 and ID_Project='+ID);
  Query.Active := true;
  while(not(Query.Eof)) do
  begin
    C.Add('<NT>'+Query.Fields[0].AsString+'</NT><AM>'+Query.Fields[1].AsString+'</AM><AV>'+Query.Fields[2].AsString+'</AV>');
    Query.Next;
  end;
  Query.Close;

//Calcul
  I := 0;
  while not(C.Count = 0) do
  begin
  //Extraction Valeur Max de CPAmont dans le Group Overture
    S1 := Separe(C.Strings[I],'<AM>','</AM>');
    NT := Separe(C.Strings[I],'<NT>','</NT>');
    H := 0;
    for J := 0 to O.Count-1 do
    begin
      S2 := Separe(O.Strings[J],'<AV>','</AV>');
      if S1 = S2 then
      begin
        if H = 0 then
        begin
          Max_CPAmont := Separe(O.Strings[J],'<CP>','</CP>').ToDouble();
          H := 1;
        end
        else if Max_CPAmont < Separe(O.Strings[J],'<CP>','</CP>').ToDouble() then
          Max_CPAmont := Separe(O.Strings[J],'<CP>','</CP>').ToDouble();
      end;
    end;
    L := 0;
    for K := 0 to C.Count-1 do
    begin
      S2 := Separe(C.Strings[K],'<AV>','</AV>');
      if S1 = S2 then L := L+1;
    end;
    //update tracons par le valeur CPAmont
    if (H = 1) and (L = 0) then
    begin
      Query.Close;
      Query.SQL.Clear;
      Query.SQL.Add('Update DNTrancons Set CPAmont_Result = '+FloatToStr(Max_CPAmont)+' where NT='+NT+' and ID_Project='+ID);
      Query.ExecSQL;
      Query.Close;
      Query.SQL.Clear;
      Query.SQL.Add('Select NAval,(CPAmont_Result-PDCT2) from DNTrancons where NT='+NT+' and ID_Project='+ID);
      Query.Active := true;
      O.Add('<AV>'+Query.Fields[0].AsString+'</AV><CP>'+Query.Fields[1].AsString+'</CP>');
      C.Delete(I);
      I := 0;
    end
    else
      I := I + 1;
    //-------------------------------------
  end;

end;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

procedure TResult1.backClick(Sender: TObject);
begin
  FDQuery4.Close;
  FDQuery4.SQL.Clear;
  FDQuery4.SQL.Add('update Logins set Status = 1 where ID='+Form2.ID_Project);
  FDQuery4.ExecSQL;
  Form2.Status := 1;
  TForm5.Create(Owner).Show;
  self.Release;
end;

procedure TResult1.btn_calculClick(Sender: TObject);
var b : boolean;
begin
  Calcul_CPAmontETAval(FDQuery4);
  if Form2.Type_Reseau = 'Maille' then
  begin
    try
      b := ResultTrancons(FDQuery4);

      if b then
      begin
        FDQuery4.Close;
        FDQuery4.SQL.Clear;
        FDQuery4.SQL.Add('update Logins set Status = 3 where ID='+Form2.ID_Project);
        FDQuery4.ExecSQL;
        Form2.Status := 3;
        TResult2.Create(self).Show;
        self.Hide;
      end
      else
        ShowMessage('il faut choisir une valeur TC pour chaque Traçons');
    Except
      ShowMessage('il faut choisir une valeur TC pour chaque Traçons');
    end;
  end
  else
  begin
      FDQuery4.Close;
      FDQuery4.SQL.Clear;
      FDQuery4.SQL.Add('update Logins set Status = 3 where ID='+Form2.ID_Project);
      FDQuery4.ExecSQL;
      Form2.Status := 3;
      TResult2.Create(self).Show;
      self.Hide;
  end;
end;

procedure TResult1.btn_startClick(Sender: TObject);
var b : boolean;
begin
  Calcul_CPAmontETAval(FDQuery4);
  if Form2.Type_Reseau = 'Maille' then
  begin
    try
      b := ResultTrancons(FDQuery4);
      if b then
      begin
        FDQuery4.Close;
        FDQuery4.SQL.Clear;
        FDQuery4.SQL.Add('update Logins set Status = 3 where ID='+Form2.ID_Project);
        FDQuery4.ExecSQL;
        Form2.Status := 3;
        TResult2.Create(self).Show;
        self.Hide;
      end
      else
        ShowMessage('il faut choisir une valeur TC pour chaque Traçons');
    Except
      ShowMessage('il faut choisir une valeur TC pour chaque Traçons');
    end;
  end
  else
  begin
      FDQuery4.Close;
      FDQuery4.SQL.Clear;
      FDQuery4.SQL.Add('update Logins set Status = 3 where ID='+Form2.ID_Project);
      FDQuery4.ExecSQL;
      Form2.Status := 3;
      TResult2.Create(self).Show;
      self.Hide;
  end;
end;

procedure TResult1.Button1Click(Sender: TObject);
begin
  FDQuery4.Close;
  FDQuery4.SQL.Clear;
  FDQuery4.SQL.Add('update Logins set Status = 1 where ID='+Form2.ID_Project);
  FDQuery4.ExecSQL;
  Form2.Status := 1;
  TForm5.Create(Owner).Show;
  Self.Release;
end;

procedure TResult1.CalculClick(Sender: TObject);
begin
  Form2.Show;
  Self.Release;
end;

procedure TResult1.ComboBox1Change(Sender: TObject);
var TC,NAmont,NAval :String;
    I : Integer;
    Diametre,Dcal,DN :Real;
    Def,min,max : Real;
    Long,Q,F,J2,PDCT,V,PDCT2,Vcal : Real;
begin
  if (Row1 < StringGrid1.RowCount) and (ComboBox1.ItemIndex <> -1) then
  begin
    TC := ComboBox1.Items.Strings[ComboBox1.ItemIndex];
    NAmont := StringGrid1.Cells[2,Row1];
    NAval := StringGrid1.Cells[3,Row1];
    Dcal := StrToFloat(StringGrid1.Cells[4,Row1]);
    //Calcul DN
    DN := Diameter_Normalize(Dcal,TC,FDQuery4);


    //recuper le donner
    FDQuery4.Close;
    FDQuery4.SQL.Clear;
    FDQuery4.SQL.Add('select Long,Q from Trancons where NT=0  and ID_Project = '+Form2.ID_Project);
    FDQuery4.Active := true;
    Q := FDQuery4.FieldByName('Q').AsFloat;
    Long := FDQuery4.FieldByName('Long').AsFloat;
    FDQuery4.Close;
    FDQuery4.SQL.Clear;
    FDQuery4.SQL.Add('select F from DNTrancons where NT=0  and ID_Project = '+Form2.ID_Project);
    FDQuery4.Active := true;
    F := FDQuery4.FieldByName('F').AsFloat;
    //Calcul
    J2 := (8*F*Q*Q)/(9.81*Pi*Pi*Power(DN,5));
    //ShowMessage('J2='+FloatToStr(J2));
    PDCT := J2*Long;
    PDCT2 := abs(J2*Long);
   // ShowMessage('PDCT='+FloatToStr(PDCT));
    V := Q/(3.14*(DN*DN)/4);
    Vcal := Q/(3.14*(Dcal*Dcal)/4);
    //ShowMessage('V='+FloatToStr(V));
    //update valeur in table DNTrancons
    FDQuery4.Close;
    FDQuery4.SQL.Clear;
    FDQuery4.SQL.Add('update DNTrancons set TC = '+QuotedStr(TC)+',DN='+FloatToStr(DN)+',J2='+FloatToStr(J2)+',PDCT='+FloatToStr(PDCT)+',PDCT2='+FloatToStr(PDCT2)+',V='+FloatToStr(V)+',Vcal='+FloatToStr(Vcal)+' where NT=0 and ID_Project = '+Form2.ID_Project);
    try
      FDQuery4.ExecSQL;
    Except
      ShowMessage('error entre valeur de tracons');
    end;
    FDQuery1.Refresh;

  end;

end;

procedure TResult1.ComboBox2Change(Sender: TObject);
var TC,NT :String;
    I : Integer;
    Diametre,Dcal,DN :Real;
    Def,min,max : Real;
    Long,Q,F,J2,PDCT,V,PDCT2,Vcal : Real;
    Sens : Integer;
begin
  if (Row2 < StringGrid2.RowCount) and (ComboBox2.ItemIndex <> -1) then
  begin
    //ComboBox2.Visible := false;
    TC := ComboBox2.Items.Strings[ComboBox2.ItemIndex];
    NT := StringGrid2.Cells[1,Row2];
    Dcal := StrToFloat(StringGrid2.Cells[4,Row2]);
    //Calcul DN
    DN := Diameter_Normalize(Dcal,TC,FDQuery4);
    {FDQuery2.Edit;
    FDQuery2.Fields[5].Value := TC;
    FDQuery2.Fields[6].Value := DN;
    FDQuery2.Post;}

    //donner
    FDQuery4.Close;
    FDQuery4.SQL.Clear;
    FDQuery4.SQL.Add('select Long,Q,Sens from Trancons where NT='+NT+' and ID_Project = '+Form2.ID_Project);
    FDQuery4.Active := true;
    Q := FDQuery4.FieldByName('Q').AsFloat;
    Long := FDQuery4.FieldByName('Long').AsFloat;
    if Form2.Type_Reseau = 'Maille' then Sens := FDQuery4.FieldByName('Sens').AsInteger;
    FDQuery4.Close;
    FDQuery4.SQL.Clear;
    FDQuery4.SQL.Add('select F from DNTrancons where NT='+NT+' and ID_Project = '+Form2.ID_Project);
    FDQuery4.Active := true;
    F := FDQuery4.FieldByName('F').AsFloat;
    //Calcul
    J2 := (8*F*Q*Q)/(9.81*Pi*Pi*Power(DN,5));
    //ShowMessage('J2='+FloatToStr(J2));
    if Form2.Type_Reseau = 'Maille' then
      PDCT := J2*Long*Sens
        else
      PDCT := J2*Long;
               if Form2.Type_Reseau = 'Maille' then
        PDCT2 := abs(J2*Long*Sens)
    else
         PDCT2 := abs(J2*Long);

    V := Q/(3.14*(DN*DN)/4);
    Vcal := Q/(3.14*(Dcal*Dcal)/4);
    //ShowMessage('V='+FloatToStr(V));
    //update valeur in table DNTrancons
    FDQuery4.Close;
    FDQuery4.SQL.Clear;
    FDQuery4.SQL.Add('update DNTrancons set TC = '+QuotedStr(TC)+',DN='+FloatToStr(DN)+',J2='+FloatToStr(J2)+',PDCT='+FloatToStr(PDCT)+',PDCT2='+FloatToStr(PDCT2)+',V='+FloatToStr(V)+',Vcal='+FloatToStr(Vcal)+' where NT='+NT+' and ID_Project = '+Form2.ID_Project);
    try
      FDQuery4.ExecSQL;
      C2 := true;
    Except
      C2 := false;
      ShowMessage('error entre valeur de tracons');
    end;
    FDQuery2.Refresh;

  end;

end;

procedure TResult1.ComboBox3Change(Sender: TObject);
var I : Integer;
begin
  for I := 0 to StringGrid2.RowCount - 1 do
  begin
    Row2 := I;
    ComboBox2.ItemIndex := ComboBox3.ItemIndex;
    ComboBox2Change(Sender);
  end;
  FDQuery2.Close;
  FDQuery2.Active := true;
  AutoSizeGrid(StringGrid2,FDQuery2);
end;

procedure TResult1.FDQuery1AfterPost(DataSet: TDataSet);
var TC:String;
    I : Integer;
    Diametre,Dcal,DN :Real;
    Def,min,max : Real;
    Long,Q,F,J2,PDCT,V,PDCT2,Vcal : Real;

begin
    Dcal := DataSet.Fields[4].AsFloat;
    TC := DataSet.Fields[5].AsString;
    DN := DataSet.Fields[6].AsFloat;
    //recuper le donner
    FDQuery4.Close;
    FDQuery4.SQL.Clear;
    FDQuery4.SQL.Add('select Long,Q from Trancons where NT=0  and ID_Project = '+Form2.ID_Project);
    FDQuery4.Active := true;
    Q := FDQuery4.FieldByName('Q').AsFloat;
    Long := FDQuery4.FieldByName('Long').AsFloat;
    FDQuery4.Close;
    FDQuery4.SQL.Clear;
    FDQuery4.SQL.Add('select F from DNTrancons where NT=0  and ID_Project = '+Form2.ID_Project);
    FDQuery4.Active := true;
    F := FDQuery4.FieldByName('F').AsFloat;
    //Calcul
    J2 := (8*F*Q*Q)/(9.81*Pi*Pi*Power(DN,5));
    PDCT := J2*Long;
    PDCT2 := abs(J2*Long);
    V := Q/(3.14*(DN*DN)/4);
    Vcal := Q/(3.14*(Dcal*Dcal)/4);
    //update valeur in table DNTrancons
    FDQuery4.Close;
    FDQuery4.SQL.Clear;
    FDQuery4.SQL.Add('update DNTrancons set TC = '+QuotedStr(TC)+',DN='+FloatToStr(DN)+',J2='+FloatToStr(J2)+',PDCT='+FloatToStr(PDCT)+',PDCT2='+FloatToStr(PDCT2)+',V='+FloatToStr(V)+',Vcal='+FloatToStr(Vcal)+' where NT=0 and ID_Project = '+Form2.ID_Project);
    try
      FDQuery4.ExecSQL;
    Except
      ShowMessage('error entre valeur de tracons');
    end;
    FDQuery1.Refresh;

end;

procedure TResult1.FDQuery2AfterPost(DataSet: TDataSet);
var TC,NT :String;
    I : Integer;
    Diametre,Dcal,DN :Real;
    Def,min,max : Real;
    Long,Q,F,J2,PDCT,V,PDCT2,Vcal : Real;
    Sens : Integer;

begin
  NT := DataSet.FieldByName('NT').AsString;
  Dcal := DataSet.Fields[4].AsFloat;
  TC := DataSet.Fields[5].AsString;
  DN := DataSet.Fields[6].AsFloat;

  //donner
  FDQuery4.Close;
  FDQuery4.SQL.Clear;
  FDQuery4.SQL.Add('select Long,Q,Sens from Trancons where NT='+NT+' and ID_Project = '+Form2.ID_Project);
  FDQuery4.Active := true;
  Q := FDQuery4.FieldByName('Q').AsFloat;
  Long := FDQuery4.FieldByName('Long').AsFloat;
  if Form2.Type_Reseau = 'Maille' then Sens := FDQuery4.FieldByName('Sens').AsInteger;
  FDQuery4.Close;
  FDQuery4.SQL.Clear;
  FDQuery4.SQL.Add('select F from DNTrancons where NT='+NT+' and ID_Project = '+Form2.ID_Project);
  FDQuery4.Active := true;
  F := FDQuery4.FieldByName('F').AsFloat;
  //Calcul
  J2 := (8*F*Q*Q)/(9.81*Pi*Pi*Power(DN,5));
  if Form2.Type_Reseau = 'Maille' then
    PDCT := J2*Long*Sens
      else
    PDCT := J2*Long;
  if Form2.Type_Reseau = 'Maille' then
    PDCT2 := abs(J2*Long*Sens)
      else
    PDCT2 := abs(J2*Long);

  V := Q/(3.14*(DN*DN)/4);
  Vcal := Q/(3.14*(Dcal*Dcal)/4);
  //update valeur in table DNTrancons
  FDQuery4.Close;
  FDQuery4.SQL.Clear;
  FDQuery4.SQL.Add('update DNTrancons set TC = '+QuotedStr(TC)+',DN='+FloatToStr(DN)+',J2='+FloatToStr(J2)+',PDCT='+FloatToStr(PDCT)+',PDCT2='+FloatToStr(PDCT2)+',V='+FloatToStr(V)+',Vcal='+FloatToStr(Vcal)+' where NT='+NT+' and ID_Project = '+Form2.ID_Project);
  try
    FDQuery4.ExecSQL;
  Except
    ShowMessage('error entre valeur de tracons NT : '+NT);
  end;
  FDQuery2.Refresh;
end;

procedure TResult1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
{$IF DEFINED(Win32)or DEFINED(Win64)}
  Form2.Show;
  Self.Release;
{$ENDIF}
end;

procedure TResult1.FormCreate(Sender: TObject);
begin
{$IF DEFINED(Win32)or DEFINED(Win64)}
  btn_calcul.Visible := true;
  Button1.Visible := true;
{$ENDIF}
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
      FDQuery1.SQL.Add('select ID_Project,NT,NAmont,NAval,printf("%.5f",DC) as [DC(m)],TC,DN as [DN(m)],Vcal from DNTrancons where NT = 0 and ID_Project='+Form2.ID_Project);
      FDQuery1.Active := true;
      AutoSizeGrid(StringGrid1,FDQuery1);
      FDQuery2.SQL.Clear;
      FDQuery2.SQL.Add('select ID_Project,NT,NAmont,NAval,printf("%.5f",DC) as [DC(m)],TC,DN as [DN(m)],Vcal from DNTrancons where NT > 0 and ID_Project = '+Form2.ID_Project);
      FDQuery2.Active := true;
      AutoSizeGrid(StringGrid2,FDQuery2);
      if StringGrid2.RowCount > 4 then
      begin
        GroupBox2.Height := StringGrid2.RowHeight * StringGrid2.RowCount + 100;
        {$IF DEFINED(iOS)or DEFINED(ANDROID)}
          ScrollBox2.Height := GroupBox2.Height + 10;
        {$ENDIF}

      end;
      FDQuery3.Active := true;
      AutoSizeGrid(StringGrid3,FDQuery3);
    Except
      ShowMessage('Requate invalide');
    end;

  Except
    ShowMessage('Connection échouée');
    Close;
  end;

end;

procedure TResult1.StringGrid1SelectCell(Sender: TObject; const ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if (ACol = 5) and (ARow <= StringGrid1.RowCount) then
    begin
      ComboBox1.ItemIndex := -1;
      {$IF DEFINED(Win32)or DEFINED(Win64)}
        ComboBox1.Position.X := StringGrid1.Position.X+StringGrid1.Columns[ACol].Position.X+2;
        ComboBox1.Position.Y := StringGrid1.Position.Y+(StringGrid1.RowHeight*ARow)+22;
        ComboBox1.Width := StringGrid1.Columns[ACol].Width;
        ComboBox1.Height := StringGrid1.RowHeight;
      {$ENDIF}
      {$IF DEFINED(iOS)or DEFINED(ANDROID)}
        ComboBox1.Position.X := StringGrid1.Position.X+StringGrid1.Columns[ACol].Position.X-4;
        ComboBox1.Position.Y := StringGrid1.Position.Y+(StringGrid1.RowHeight*ARow)+32;
        ComboBox1.Width := StringGrid1.Columns[ACol].Width+5;
        ComboBox1.Height := StringGrid1.RowHeight+5;
      {$ENDIF}
      ComboBox1.Visible := True;
      Row1 := ARow;
      Col1 := ACol;
      CanSelect := true;
    end
  else
    ComboBox1.Visible := False;


end;

procedure TResult1.StringGrid2SelectCell(Sender: TObject; const ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if (ACol = 5) and (ARow <= StringGrid2.RowCount)  then
    begin
      ComboBox2.ItemIndex := -1;
      {$IF DEFINED(Win32)or DEFINED(Win64)}
        ComboBox2.Position.X := StringGrid2.Position.X+StringGrid2.Columns[ACol].Position.X+2;
        ComboBox2.Position.Y := StringGrid2.Position.Y+(StringGrid2.RowHeight*ARow)+22;
        ComboBox2.Width := StringGrid2.Columns[ACol].Width;
        ComboBox2.Height := StringGrid2.RowHeight;
      {$ENDIF}
      {$IF DEFINED(iOS)or DEFINED(ANDROID)}
        ComboBox2.Position.X := StringGrid2.Position.X+StringGrid2.Columns[ACol].Position.X-4;
        ComboBox2.Position.Y := StringGrid2.Position.Y+(StringGrid2.RowHeight*ARow)+32;
        ComboBox2.Width := StringGrid2.Columns[ACol].Width+5;
        ComboBox2.Height := StringGrid2.RowHeight+5;
      {$ENDIF}
      ComboBox2.Visible := True;
      Row2 := ARow;
      Col2 := ACol;
      //StringGrid2.SelectRow(ARow);
      CanSelect := true;
    end
  else
    ComboBox2.Visible := False;

end;


procedure TResult1.AutoSizeGrid(Grid: TStringGrid; Query : TFDQuery);
var
  C : integer;
begin
  for C := 0 to Grid.ColumnCount - 1 do begin
    if Grid.Columns[C].Header.Length >= Query.FieldByName(Grid.Columns[C].Header).DisplayWidth then
      Grid.Columns[C].Width := Grid.Columns[C].Header.Length * 8
    else
      Grid.Columns[C].Width := Query.FieldByName(Grid.Columns[C].Header).DisplayWidth * 8;

    if Grid.Columns[C].Width > 130 then Grid.Columns[C].Width := 130;
    if Grid.Equals(StringGrid1) and ( (C=0) or (C=1) ) then Grid.Columns[C].Visible := false;
    if Grid.Equals(StringGrid2) and (C=0) then Grid.Columns[C].Visible := false;
  end;

end;


end.
