unit Unit3;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.Layouts, FMX.ExtCtrls;

type
  TForm3 = class(TForm)
    Button2: TButton;
    ToolBar1: TToolBar;
    Label1: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation
uses CRDEP_Unit;
{$R *.fmx}
{$R *.Windows.fmx MSWINDOWS}
{$R *.SmXhdpiPh.fmx ANDROID}

procedure TForm3.Button2Click(Sender: TObject);
begin
  Form2.Show;
  Self.Release;
end;

procedure TForm3.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
{$IF DEFINED(Win32)or DEFINED(Win64)}
  Form2.Show;
  Self.Release;
{$ENDIF}
end;

end.
