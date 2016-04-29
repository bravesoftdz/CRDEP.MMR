
unit Unit_Rapport;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FMX.frxClass, FMX.frxDBSet, FMX.frxExportPDF,
  FMX.Controls.Presentation, FMX.StdCtrls;
type
  TForm1 = class(TForm)
    frxReport1: TfrxReport;
    frxDBDataset1: TfrxDBDataset;
    FDQuery1: TFDQuery;
    FDConnection1: TFDConnection;
    Print: TButton;
    procedure PrintClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses  System.IOUtils;

{$R *.fmx}
{$R *.Windows.fmx MSWINDOWS}

procedure TForm1.PrintClick(Sender: TObject);
begin
  frxReport1.PrepareReport(true);
  frxReport1.ShowPreparedReport;
  Close;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  Self.Release;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FDConnection1.Close;
  FDConnection1.Params.Values['ColumnMetadataSupported']:='False';
  FDConnection1.Params.Values['Database']:=TPath.Combine(TPath.GetDocumentsPath,'test.db');
  try
    FDConnection1.Connected := true;
    FDQuery1.Active := true;
  Except
    ShowMessage('Connection échouée');
    Close;
  end;

end;

end.

