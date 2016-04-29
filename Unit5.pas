unit Unit5;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.Objects, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.FMXUI.Wait, FireDAC.FMXUI.Error, FireDAC.Comp.UI, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, System.Rtti, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope, FMX.Layouts, FMX.Grid,
  Data.Bind.Controls, Fmx.Bind.Navigator, FMX.EditBox, FMX.NumberBox,
  FMX.ListBox;

type
  TForm5 = class(TForm)
    ToolBar1: TToolBar;
    Label1: TLabel;
    back: TButton;
    Calcul: TButton;
    Image1: TImage;
    FDConnection1: TFDConnection;
    StringGrid1: TStringGrid;
    FDQuery1: TFDQuery;
    NumberBox1 : TNumberBox;
    NumberBox2 : TNumberBox;
    Button1: TButton;
    Label2 : TLabel;
    Label3 : TLabel;
    ScrollBox1: TScrollBox;
    GroupBox1: TGroupBox;
    GroupBox3: TGroupBox;
    StringGrid2: TStringGrid;
    BindNavigator2: TBindNavigator;
    ScrollBox3: TScrollBox;
    ScrollBox4: TScrollBox;
    FDQuery2: TFDQuery;
    FDQuery3: TFDQuery;
    btn_calcul: TButton;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    BindNavigator1: TBindNavigator;
    BindSourceDB2: TBindSourceDB;
    LinkGridToDataSourceBindSourceDB2: TLinkGridToDataSource;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    Button2: TButton;
    procedure backClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AutoSizeGrid(Grid: TStringGrid ; Query: TFDQuery);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure CalculClick(Sender: TObject);
    procedure btn_calculClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; const ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure StringGrid2SelectCell(Sender: TObject; const ACol, ARow: Integer;
      var CanSelect: Boolean);
    function WidthCol(Grid: TStringGrid; Col : Integer): Real;
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;
  X_Scroll : Real;

implementation

uses CRDEP_Unit,System.IOUtils,Result_1,Math;

//---------------------------------------------
// Calcul Dcal Reseau Maille et Ramifier
//---------------------------------------------
function Calcul_DNTrancons(Query :TFDQuery):boolean;
var NT,NAmont,NAval : String;
    Sens : Integer;
    Q,Long,Reguosite : Real;
    CPAmont,CPAval,CTNAmont,CTNAval,PSAmont,PSAval,Delta_Ht,J1,D,R,Psi,F,J2,PDCT,PDCT2 : Real;
    Dcal : Real;
    Query2 :TFDQuery;
begin
  Query2 := TFDQuery.Create(Form5);
  Query2.Connection := Query.Connection;
  try
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from Trancons where NT >= 0 and ID_Project='+Form2.ID_Project+';');
  Query.Active := true;
  Query2.SQL.Add('delete from DNTrancons where NT >= 0 and ID_Project='+Form2.ID_Project+';');
  finally
  while not(Query.Eof) do
  begin
    //donner
    NT := Query.FieldByName('NT').AsString;
    NAmont := Query.FieldByName('NAmont').AsString;
    NAval :=  Query.FieldByName('NAval').AsString;
    CTNAmont := Query.FieldByName('CTNAmont').AsFloat;
    CTNAval := Query.FieldByName('CTNAval').AsFloat;
    PSAmont := Query.FieldByName('PSAmont').AsFloat;
    PSAval := Query.FieldByName('PSAval').AsFloat;
    Q := Query.FieldByName('Q').AsFloat;
    Long := Query.FieldByName('Long').AsFloat;
    Reguosite := Query.FieldByName('Reguosite').AsFloat;
    //calcul
    CPAmont := CTNAmont + PSAmont;
    //ShowMessage('CPAmont='+FloatToStr(CPAmont));
    CPAval :=  CTNAval + PSAval;
    //ShowMessage('CPAval='+FloatToStr(CPAval));
    Delta_Ht := CPAmont - CPAval;
    //ShowMessage('Delta_Ht='+FloatToStr(Delta_Ht));
    J1 := Abs(Delta_Ht / Long);
    //ShowMessage('J1='+FloatToStr(J1));
    D := Power(2*Pi*Pi,-0.2) * Power(Q*Q/9.81/J1,0.2);
    //ShowMessage('D='+FloatToStr(D));
    R := 4 * abs(Q)/(Pi * D * 0.000001);
    //SowMessage('R='+FloatToStr(R));
    Psi := 1.35 * Power(-Log10((Reguosite/D/4.75)+(8.5/R)),-0.4);
    //ShowMessage('Psi='+FloatToStr(Psi));
    Dcal := Psi * D;
    //ShowMessage('Dcal='+FloatToStr(Dcal));
    F := Power(Psi,5)/16;
    //ShowMessage('F='+FloatToStr(F));

    Query2.SQL.Add('insert into DNTrancons(ID_Project,NT,NAmont,NAval,DC,CPAmont,CPAval,DHT,J1,D,R,Psi,F)values('+Form2.ID_Project+','+NT+','+QuotedStr(NAmont)+','+QuotedStr(NAval)+','+FloatToStr(Dcal)+','+FloatToStr(CPAmont)+','+FloatToStr(CPAval)+','+FloatToStr(Delta_Ht)+','+FloatToStr(J1)+','+FloatToStr(D)+','+FloatToStr(R)+','+FloatToStr(Psi)+','+FloatToStr(F)+');');
    Query.Next;
  end;
  end;

  try
    Query2.ExecSQL;
    Result := true;
  Except
    ShowMessage('Re-entrer des valeurs le trançons');
    Result := false;
  end;
end;


//---------------------------------------------

//---------------------------------------------

{$R *.fmx}
{$R *.Windows.fmx MSWINDOWS}
{$R *.SmXhdpiPh.fmx ANDROID}
{$R *.LgXhdpiTb.fmx ANDROID}

procedure TForm5.backClick(Sender: TObject);
begin
  Form2.Show;
  Self.Release;
end;

procedure TForm5.btn_calculClick(Sender: TObject);
begin
    if Calcul_DNTrancons(FDQuery3) then
    begin
      FDQuery3.Close;
      FDQuery3.SQL.Clear;
      FDQuery3.SQL.Add('update Logins set Status = 2 where ID='+Form2.ID_Project);
      FDQuery3.ExecSQL;
      Form2.Status := 2;
      TResult1.Create(Owner).Show;
      self.Hide;
    end;
end;

procedure TForm5.Button1Click(Sender: TObject);
var I : integer;
begin
  try
    FDQuery3.Close;
    FDQuery3.SQL.Clear;
    FDQuery3.SQL.Add('delete from Trancons where NT > 0 and ID_Project='+Form2.ID_Project+';');
    for I := 1 to StrToInt(NumberBox1.Text) do
      FDQuery3.SQL.Add('insert into Trancons(ID_Project,NT) values ('+Form2.ID_Project+','+IntToStr(I)+');');
    FDQuery3.ExecSQL;
    FDQuery2.Close;
    FDQuery2.Active := true;
    AutoSizeGrid(StringGrid2,FDQuery2);
    if StrToInt(NumberBox1.Text) > 4 then
    begin
     GroupBox3.Height := StringGrid2.RowHeight * StrToInt(NumberBox1.Text) + 100;
    {$IF DEFINED(iOS)or DEFINED(ANDROID)}
      ScrollBox4.Height := GroupBox3.Height + 10;
    {$ENDIF}
    end
    else
    begin
     GroupBox3.Height := StringGrid2.RowHeight * 4 + 100;
    {$IF DEFINED(iOS)or DEFINED(ANDROID)}
      ScrollBox4.Height := GroupBox3.Height + 10;
    {$ENDIF}
    end;
    ShowMessage('initialisation de donner');
  Except
    ShowMessage('Error Query');
  end;
end;

procedure TForm5.Button2Click(Sender: TObject);

begin
  Form2.Show;
  Self.Release;
end;


procedure TForm5.CalculClick(Sender: TObject);
begin
  if Calcul_DNTrancons(FDQuery3) then
  begin
    FDQuery3.Close;
    FDQuery3.SQL.Clear;
    FDQuery3.SQL.Add('update Logins set Status = 2 where ID='+Form2.ID_Project);
    FDQuery3.ExecSQL;
    Form2.Status := 2;
    TResult1.Create(Owner).Show;
    self.Hide;
  end;
end;


procedure TForm5.ComboBox1Change(Sender: TObject);
begin
  if (ComboBox1.ItemIndex <> -1) then
  begin
    BindSourceDB1.DataSet.Edit;
    BindSourceDB1.DataSet.FieldByName('Reguosite Abs').AsFloat := StrToFloat(ComboBox1.Items.Strings[ComboBox1.ItemIndex]);
    BindSourceDB1.DataSet.Post;
    //ComboBox1.Visible := false;
  end;
end;

procedure TForm5.ComboBox2Change(Sender: TObject);
begin
  if (ComboBox2.ItemIndex <> -1) then
  begin
    BindSourceDB2.DataSet.Edit;
    BindSourceDB2.DataSet.FieldByName('Reguosite Abs').AsFloat := StrToFloat(ComboBox2.Items.Strings[ComboBox2.ItemIndex]);
    BindSourceDB2.DataSet.Post;
    //ComboBox2.Visible := false;
  end;

end;

procedure TForm5.ComboBox3Change(Sender: TObject);
begin
  if (ComboBox3.ItemIndex <> -1) then
  begin
    BindSourceDB2.DataSet.Edit;
    BindSourceDB2.DataSet.FieldByName('Sens').AsInteger := StrToInt(ComboBox3.Items.Strings[ComboBox3.ItemIndex]);
    BindSourceDB2.DataSet.Post;
    //ComboBox3.Visible := false;
  end;

end;

procedure TForm5.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
{$IF DEFINED(Win32)or DEFINED(Win64)}
  Form2.Show;
  Self.Release;
{$ENDIF}
end;

procedure TForm5.FormCreate(Sender: TObject);
begin
{$IF DEFINED(Win32)or DEFINED(Win64)}
  btn_calcul.Visible := true;
  ScrollBox3.Margins.Bottom := 0;
  ScrollBox4.Margins.Bottom := 0;
  ScrollBox4.Margins.Top := 0;
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
      FDQuery1.Close;
      FDQuery1.SQL.Clear;
      FDQuery1.SQL.Add('select ID_Project,NT,NAmont,NAval,Q as [Qp],CTNAmont,CTNAval,PSAmont,PSAval,Long,Reguosite as [Reguosite Abs] from Trancons where NT = 0 and ID_Project='+Form2.ID_Project);
      FDQuery1.Active := true;
      AutoSizeGrid(StringGrid1,FDQuery1);
      FDQuery2.Close;
      FDQuery2.SQL.Clear;
      if Form2.Type_Reseau = 'Maille' then
        FDQuery2.SQL.Add('select ID_Project,NT,MP,MA,NAmont,NAval,Sens,Q as [Qr],CTNAmont,CTNAval,PSAmont,PSAval,Long,Reguosite as [Reguosite Abs] from Trancons where NT > 0 and ID_Project='+Form2.ID_Project)
      else
        FDQuery2.SQL.Add('select ID_Project,NT,NAmont,NAval,Q as [Qr],CTNAmont,CTNAval,PSAmont,PSAval,Long,Reguosite as [Reguosite Abs] from Trancons where NT > 0 and ID_Project='+Form2.ID_Project);
      FDQuery2.Active := true;
      AutoSizeGrid(StringGrid2,FDQuery2);
      if StringGrid2.RowCount > 4 then
      begin
        GroupBox3.Height := StringGrid2.RowHeight * StringGrid2.RowCount + 100;
        {$IF DEFINED(iOS)or DEFINED(ANDROID)}
          ScrollBox4.Height := GroupBox3.Height + 10;
        {$ENDIF}
      end;
    Except
      ShowMessage('Requate invalide');
    end;

  Except
    ShowMessage('Connection échouée');
    Close;
  end;
end;
procedure TForm5.StringGrid1SelectCell(Sender: TObject; const ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if (ACol = 10) and (ARow <= StringGrid1.RowCount) then
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
    CanSelect := true;
  end
  else
    ComboBox1.Visible := False;

end;

procedure TForm5.StringGrid2SelectCell(Sender: TObject; const ACol,
  ARow: Integer; var CanSelect: Boolean);
var Col : integer;
begin
  if Form2.Type_Reseau = 'Maille' then
    Col := 13
  else
    Col := 10;
  if (ACol = 6) and (ARow <= StringGrid2.RowCount) and (Form2.Type_Reseau = 'Maille') then
    begin
      ComboBox3.ItemIndex := -1;
      {$IF DEFINED(Win32)or DEFINED(Win64)}

        ComboBox3.Position.X := StringGrid2.Position.X+StringGrid2.Columns[ACol].Position.X+2;
        ComboBox3.Position.Y := StringGrid2.Position.Y+(StringGrid2.RowHeight*ARow)+22;
        ComboBox3.Width := StringGrid2.Columns[ACol].Width;
        ComboBox3.Height := StringGrid2.RowHeight;
      {$ENDIF}
      {$IF DEFINED(iOS)or DEFINED(ANDROID)}
        ComboBox3.Position.X := StringGrid2.Position.X+StringGrid2.Columns[ACol].Position.X-4;
        ComboBox3.Position.Y := StringGrid2.Position.Y+(StringGrid2.RowHeight*ARow)+32;
        ComboBox3.Width := StringGrid2.Columns[ACol].Width+5;
        ComboBox3.Height := StringGrid2.RowHeight+5;
      {$ENDIF}
      ComboBox3.Visible := True;
      //StringGrid2.SelectRow(ARow);
      CanSelect := true;
    end
  else
    if (ACol = Col) and (ARow <= StringGrid2.RowCount) then
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
      //StringGrid2.SelectRow(ARow);
      CanSelect := true;
    end
  else
  begin
    ComboBox2.Visible := False;
    ComboBox3.Visible := False;
  end;
end;

procedure TForm5.AutoSizeGrid(Grid: TStringGrid; Query : TFDQuery);
var
  C : integer;
begin
  for C := 0 to Grid.ColumnCount - 1 do begin
    if Grid.Columns[C].Header.Length > Query.FieldByName(Grid.Columns[C].Header).DisplayWidth then
      Grid.Columns[C].Width := Grid.Columns[C].Header.Length * 8
    else
      Grid.Columns[C].Width := Query.FieldByName(Grid.Columns[C].Header).DisplayWidth * 8;
    if Grid.Equals(StringGrid1) and ((C = 0)or(C = 1)) then Grid.Columns[C].Visible := false;
    if Grid.Equals(StringGrid2) and (C = 0) then Grid.Columns[C].Visible := false;

  end;

end;
function TForm5.WidthCol(Grid: TStringGrid; Col : Integer): Real;
var
  C : integer;
  Sum : Real;
begin
  Sum := 0;
  for C := 0 to Col do
  begin
    Sum := Sum + Grid.Columns[C].Width;
  end;
  Result := Sum;
end;


end.
