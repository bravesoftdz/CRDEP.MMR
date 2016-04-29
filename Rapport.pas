unit Rapport;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FMX.Controls.Presentation, FMX.StdCtrls, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.frxClass, FMX.frxDBSet,
  FireDAC.FMXUI.Wait, FireDAC.Comp.UI, FMX.frxExportPDF, FMX.frxExportRTF,
  FMX.frxExportHTML, FMX.frxExportCSV, FMX.frxExportImage, FMX.frxExportText;

type
  TForm1 = class(TForm)
    frxReport1: TfrxReport;
    frxDBDataset1: TfrxDBDataset;
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    print: TButton;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDQuery2: TFDQuery;
    FDQuery3: TFDQuery;
    frxDBDataset2: TfrxDBDataset;
    frxDBDataset3: TfrxDBDataset;
    frxBMPExport1: TfrxBMPExport;
    frxRTFExport1: TfrxRTFExport;
    frxHTMLExport1: TfrxHTMLExport;
    frxReport2: TfrxReport;
    procedure FormCreate(Sender: TObject);
    procedure printClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses System.IOUtils,CRDEP_Unit;
{$R *.fmx}

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  Self.Release;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FDConnection1.Close;
  FDConnection1.Params.Values['ColumnMetadataSupported']:='False';
  FDConnection1.Params.Values['Database']:='test.db';
  try
    FDConnection1.Connected := true;
    FDQuery1.Close;
    FDQuery1.SQL.Clear;
      if Form2.Type_Reseau = 'Maille' then
        FDQuery1.SQL.Add('Select NAmont,NAval,[DC(m)],TC,[DN(m)],[V(m/s)],[PDCT(m)],[CPR(m)],[CP1(m)],[PSAmont(m.c.e)],[PSAval(m.c.e)] from VResulta_TReservoir where ID_Project = '+Form2.ID_Project+';')
      else
        FDQuery1.SQL.Add('Select NAmont,NAval,[Qp(m3/s)],[DC(m)],TC,[DN(m)],[V(m/s)],[PDCT(m)],[CPR(m)],[CP1(m)],[PSAmont(m.c.e)],[PSAval(m.c.e)] from VResulta_TReservoir where ID_Project = '+Form2.ID_Project+';');

    FDQuery1.Active := true;
    if Form2.Type_Reseau = 'Maille' then
    begin
      FDQuery2.Close;
      FDQuery2.SQL.Clear;
      FDQuery2.SQL.Add('select MP,printf("%.5f",[Som DH]) AS [Som DH],printf("%.5f",[Som DH/Q]) AS [Som DH/Q],printf("%.5f",[D q(m3/s)]) AS [Dq(m3/s)] from Erreur_mailles where ID_Project='+Form2.ID_Project);
      FDQuery2.Active := true;
    end;

    FDQuery3.Close;
    FDQuery3.SQL.Clear;
      if Form2.Type_Reseau = 'Maille' then
        FDQuery3.SQL.Add('select NT,MP,MA,NAmont,NAval,[DC(m)],TC,[DN(m)],[V(m/s)],[PDCT(m)],[Q Corrige(m3/s)],[CPAmont(m)],[CPAval(m)],[PSAmont(m.c.e)],[PSAval(m.c.e)] from VResulta_TranconMaille where ID_Project = '+Form2.ID_Project+';')
      else
        FDQuery3.SQL.Add('select NT,NAmont,NAval,[Qp(m3/s)],[DC(m)],TC,[DN(m)],[V(m/s)],[PDCT(m)],[CPAmont(m)],[CPAval(m)],[PSAmont(m.c.e)],[PSAval(m.c.e)] from VResulta_TranconRamifie where ID_Project = '+Form2.ID_Project+';');
    FDQuery3.Active := true;
  Except
    ShowMessage('Connection échouée');
    Close;
  end;

end;

procedure TForm1.printClick(Sender: TObject);
begin
  if Form2.Type_Reseau = 'Maille' then
  begin
    frxReport1.PrepareReport(true);
    frxReport1.ShowPreparedReport;
  end
  else
  begin
    frxReport2.PrepareReport(true);
    frxReport2.ShowPreparedReport;
  end;
  Close;
end;

end.
