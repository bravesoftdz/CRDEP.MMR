unit CRDEP_Unit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Menus, FMX.Controls.Presentation, FMX.Edit,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Error, FireDAC.FMXUI.Wait,
  FireDAC.Comp.UI, FMX.Effects, FMX.Ani, System.Rtti, FMX.Layouts, FMX.Grid,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope,
  FMX.ListBox, FMX.ComboEdit, FireDAC.FMXUI.Script, FireDAC.FMXUI.Async;

type
  TForm2 = class(TForm)
    Image1: TImage;
    FDConnection1: TFDConnection;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    FDGUIxErrorDialog1: TFDGUIxErrorDialog;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    btn_start: TButton;
    ToolBar1: TToolBar;
    Label1: TLabel;
    btn_exit: TButton;
    btn_Setting: TButton;
    Rectangle1: TRectangle;
    Rectangle11: TRectangle;
    Button2: TButton;
    Button3: TButton;
    Button1: TButton;
    Rectangle12: TRectangle;
    Rectangle13: TRectangle;
    Rectangle2: TRectangle;
    Rectangle5: TRectangle;
    Label3: TLabel;
    Pwd: TEdit;
    Rectangle6: TRectangle;
    Cancel: TButton;
    Confirmer: TButton;
    Rectangle7: TRectangle;
    CheckBox1: TCheckBox;
    ShadowEffect2: TShadowEffect;
    Rectangle8: TRectangle;
    Label4: TLabel;
    Rectangle9: TRectangle;
    close_chois: TButton;
    btn_chois: TButton;
    Rectangle10: TRectangle;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    ShadowEffect3: TShadowEffect;
    ColorAnimation2: TColorAnimation;
    ColorAnimation3: TColorAnimation;
    ColorAnimation1: TColorAnimation;
    ColorAnimation4: TColorAnimation;
    ColorAnimation5: TColorAnimation;
    ColorAnimation6: TColorAnimation;
    FDQuery1: TFDQuery;
    MenuBar1: TMenuBar;
    fichier: TMenuItem;
    Option: TMenuItem;
    Help: TMenuItem;
    Nouveau_projet: TMenuItem;
    Exit: TMenuItem;
    Mod_pass: TMenuItem;
    propos: TMenuItem;
    Aide: TMenuItem;
    MenuItem2: TMenuItem;
    Button4: TButton;
    ColorAnimation7: TColorAnimation;
    ColorAnimation8: TColorAnimation;
    Rectangle14: TRectangle;
    MenuItem3: TMenuItem;
    Button5: TButton;
    ColorAnimation9: TColorAnimation;
    ColorAnimation10: TColorAnimation;
    Rectangle15: TRectangle;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit4: TEdit;
    Text1: TText;
    Text2: TText;
    Text3: TText;
    Text4: TText;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    ComboEdit1: TComboEdit;
    procedure loginClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure ConfirmerClick(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure btn_SettingClick(Sender: TObject);
    procedure btn_exitClick(Sender: TObject);
    procedure close_choisClick(Sender: TObject);
    procedure btn_choisClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure Rectangle1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Nouveau_projetClick(Sender: TObject);
    procedure ExitClick(Sender: TObject);
    procedure Mod_passClick(Sender: TObject);
    procedure proposClick(Sender: TObject);
    procedure AideClick(Sender: TObject);
    procedure btn_startClick(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure CheckBox3Change(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);

  private
    show_keyboard : boolean;
  public
    ID_Project,Type_Reseau : String;
    Status : Integer;

  end;

var
  Form2: TForm2;


implementation

uses System.IOUtils,Unit5,Unit3,Unit7,Result_1,Result_2; // Automatically added by IDE

{$R *.fmx}
{$R *.iPhone.fmx IOS}
{$R *.Windows.fmx MSWINDOWS}
{$R *.SmXhdpiPh.fmx ANDROID}
{$R *.Macintosh.fmx MACOS}
{$R *.XLgXhdpiTb.fmx ANDROID}
{$R *.NmXhdpiPh.fmx ANDROID}
{$R *.LgXhdpiPh.fmx ANDROID}
{$R *.Surface.fmx MSWINDOWS}

procedure TForm2.AideClick(Sender: TObject);
var aid : TForm7;
begin
  aid := TForm7.Create(Owner);
  aid.Show;
  Self.Hide;
end;

procedure TForm2.btn_choisClick(Sender: TObject);
var Form_Debut : TForm5;
begin
  Rectangle1.Visible := false;
  Rectangle8.Visible := false;
  btn_start.TintColor := TAlphaColorRec.Green;
  FDQuery1.Close;
  FDQuery1.SQL.Clear;
  if RadioButton1.IsChecked then
  begin
    FDQuery1.SQL.Add('update Logins set Status=1,Type='+QuotedStr('Maille')+' where ID = '+ID_Project);
    Type_Reseau := 'Maille';
  end
  else
  begin
    FDQuery1.SQL.Add('update Logins set Status=1,Type='+QuotedStr('Ramifie')+' where ID = '+ID_Project);
    Type_Reseau := 'Ramifie';
  end;
  FDQuery1.ExecSQL;
  Status := 1;
  Form_Debut := TForm5.Create(Owner);
  Form_Debut.Show;
  Self.Hide;
end;

procedure TForm2.btn_CloseClick(Sender: TObject);
begin
  if (Edit2.Text.IndexOf(Edit1.Text) = -1) and (Edit2.Text <> '') then
  begin
    FDQuery1.Close;
    FDQuery1.SQL.Clear;
    FDQuery1.SQL.Add('insert into Logins(Password,Project,Status)Values('+QuotedStr(Edit2.Text)+','+QuotedStr(Edit2.Text)+',0)');
    FDQuery1.ExecSQL;
    ShowMessage('Create');

    FDQuery1.Close;
    FDQuery1.SQL.Clear;
    FDQuery1.SQL.Add('select * from logins where Project='+QuotedStr(Edit2.Text));
    FDQuery1.Active := true;
    ID_Project := FDQuery1.FieldByName('ID').AsString;
    Status := 0;

    FDQuery1.Close;
    FDQuery1.SQL.Clear;
    FDQuery1.SQL.Add('insert into Trancons(ID_Project,NT)values('+ID_Project+',0)');
    FDQuery1.ExecSQL;

    Rectangle1.Visible := false;
    Rectangle2.Visible := false;
    {$IF DEFINED(Win32)or DEFINED(Win64)}
      MenuBar1.Enabled := true;
    {$ENDIF}

  end
  else
    ShowMessage('Re-saisissez le nom du projet');
end;

procedure TForm2.btn_exitClick(Sender: TObject);
begin
  ShowMessage('Merci pour votre vésite');
  Sleep(1000);
  Close;
end;

procedure TForm2.btn_SettingClick(Sender: TObject);
begin
  Rectangle1.Opacity := 0;
  Rectangle1.Visible := true;
  Rectangle11.Visible := true;
end;

procedure TForm2.btn_startClick(Sender: TObject);
begin
  if Status = 0 then
  begin
    //btn_start.Text := 'Choisie un type de réseau'
    btn_chois.Width := Rectangle9.Width / 2;
    close_chois.Width := Rectangle9.Width / 2;
    Rectangle1.Visible := true;
    Rectangle8.Visible := true;
    FormResize(sender);
  end
  else if Status = 1 then
  begin
   //btn_start.Text := 'Entre le donner'
    TForm5.Create(Owner).Show;
    Self.Hide;
  end
  else if Status = 2 then
  begin
   //btn_start.Text := 'Choix Diameter'
    TResult1.Create(Owner).Show;
    Self.Hide;
  end
  else if Status >= 3 then
  begin
    //btn_start.Text := 'Résulta & Itération';
    TResult2.Create(Owner).Show;
    Self.Hide;
  end;
  btn_start.TintColor := TAlphaColorRec.Green;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
  Rectangle1.Visible := false;
  Rectangle11.Visible := false;
  Rectangle1.Opacity := 0.5;
  try
    FDQuery1.Active := true;
    pwd.Text := FDQuery1.FieldByName('Password').Text;
    Cancel.Width := Rectangle6.Width / 2;
    Confirmer.Width := Rectangle6.Width / 2;
    Rectangle1.Visible := true;
    Rectangle5.Visible := true;
    FormResize(sender);
  Except
    ShowMessage('Connection échouée');
  end;

end;

procedure TForm2.Button2Click(Sender: TObject);
var propos : TForm3;
begin
  Rectangle1.Visible := false;
  Rectangle11.Visible := false;
  Rectangle1.Opacity := 0.5;
  propos := TForm3.Create(Owner);
  propos.Show;
  Self.Hide;
end;

procedure TForm2.Button3Click(Sender: TObject);
var aid : TForm7;
begin
  Rectangle1.Visible := false;
  Rectangle11.Visible := false;
  Rectangle1.Opacity := 0.5;

  aid := TForm7.Create(Owner);
  aid.Show;
  Self.Hide;
end;

procedure TForm2.Button4Click(Sender: TObject);
begin
    try
      Rectangle11.Visible := false;
      Rectangle1.Opacity := 0.5;
      Rectangle1.Visible := true;
      Rectangle2.Visible := true;
      FDQuery1.Close;
      FDQuery1.SQL.Clear;
      FDQuery1.SQL.Add('select Project from Logins order by ID');
      FDQuery1.Active := true;
      ComboEdit1.Items.Clear;
      while not(FDQuery1.Eof) do
      begin
        ComboEdit1.Items.Add(FDQuery1.Fields[0].AsString);
        FDQuery1.Next;
      end;
    Except
      Close;
    end;
    show_keyboard := true;

end;

procedure TForm2.Button5Click(Sender: TObject);
var mes :String;
begin
  Rectangle11.Visible := false;
  Rectangle1.Visible := false;
  Rectangle1.Opacity := 0.5;

  mes := 'ATTENTION vous allez suprimer un projet,Etes-vous sur de vouloir le suprimer?';
  MessageDlg(mes, System.UITypes.TMsgDlgType.mtConfirmation,
    [
      System.UITypes.TMsgDlgBtn.mbOK,
      System.UITypes.TMsgDlgBtn.mbCancel
    ], 0,
    // Use an anonymous method to make sure the acknowledgment appears as expected.
    procedure(const AResult: TModalResult)
    begin
      case AResult of
        mrOk:
        begin
          FDQuery1.Close;
          FDQuery1.SQL.Clear;
          FDQuery1.SQL.Add('delete from Logins where ID ='+ID_Project+' ; ');
          FDQuery1.SQL.Add('delete from Trancons where ID_Project ='+ID_Project+' ; ');
          FDQuery1.SQL.Add('delete from DNTrancons where ID_Project ='+ID_Project+' ; ');
          try
            FDQuery1.ExecSQL;
            ShowMessage('Le Projet est Supprimer');
            Rectangle1.Visible := true;
            Rectangle2.Visible := true;
            FDQuery1.Close;
            FDQuery1.SQL.Clear;
            FDQuery1.SQL.Add('select Project from Logins order by ID');
            FDQuery1.Active := true;
            ComboEdit1.Items.Clear;
            while not(FDQuery1.Eof) do
            begin
              ComboEdit1.Items.Add(FDQuery1.Fields[0].AsString);
              FDQuery1.Next;
            end;
            show_keyboard := true;
          Except
            ShowMessage('Requate invalide');
          end;
        end;
        mrCancel:
      end;

    end

  )


end;

procedure TForm2.Button6Click(Sender: TObject);
begin
begin
  if (Edit2.Text.IndexOf(Edit1.Text) = -1) and (Edit2.Text <> '') then
  begin
    FDQuery1.Close;
    FDQuery1.SQL.Clear;
    FDQuery1.SQL.Add('insert into Logins(Password,Project,Status)Values('+QuotedStr(Edit2.Text)+','+QuotedStr(Edit2.Text)+',0)');
    FDQuery1.ExecSQL;
    ShowMessage('Create');

    FDQuery1.Close;
    FDQuery1.SQL.Clear;
    FDQuery1.SQL.Add('select * from logins where Project='+QuotedStr(Edit2.Text));
    FDQuery1.Active := true;
    ID_Project := FDQuery1.FieldByName('ID').AsString;
    Status := 0;

    FDQuery1.Close;
    FDQuery1.SQL.Clear;
    FDQuery1.SQL.Add('insert into Trancons(ID_Project,NT)values('+ID_Project+',0)');
    FDQuery1.ExecSQL;

    Rectangle1.Visible := false;
    Rectangle2.Visible := false;
    {$IF DEFINED(Win32)or DEFINED(Win64)}
      MenuBar1.Enabled := true;
    {$ENDIF}

  end
  else
    ShowMessage('Re-saisissez le nom du projet');
end;
end;

procedure TForm2.Button7Click(Sender: TObject);
begin
begin
  ShowMessage('Merci pour votre visite');
  Sleep(1000);
  Close;
end;
end;

procedure TForm2.Button8Click(Sender: TObject);
begin
 if ComboEdit1.ItemIndex <> -1 then
  begin
  try
    FDQuery1.Close;
    FDQuery1.SQL.Clear;
    FDQuery1.SQL.Add('select * from Logins where Project = '+QuotedStr(ComboEdit1.Items[ComboEdit1.ItemIndex]));
    FDQuery1.Active := true;
    if FDQuery1.FieldByName('Password').Text = Edit4.Text then
    begin
      ID_Project := FDQuery1.FieldByName('ID').AsString;
      Status := FDQuery1.FieldByName('Status').AsInteger;
      Type_Reseau := FDQuery1.FieldByName('Type').AsString;
      Rectangle1.Visible := false;
      Rectangle2.Visible := false;
      {$IF DEFINED(Win32)or DEFINED(Win64)}
        MenuBar1.Enabled := true;
      {$ENDIF}
    end
    else
    begin
      ShowMessage('mot de passe incorrect');
    end;
  Except
    ShowMessage('Erreur inconnu');
  end;
  end
  else
    ShowMessage('Choisir un project ou create nouveau project!');


end;


procedure TForm2.Button9Click(Sender: TObject);
begin
begin
  ShowMessage('Merci pour votre visite');
  Sleep(1000);
  Close;
end;
end;

procedure TForm2.CancelClick(Sender: TObject);
begin
  CheckBox1.IsChecked := false;
  Rectangle1.Visible := false;
  Rectangle5.Visible := false;
end;

procedure TForm2.CheckBox1Change(Sender: TObject);
begin
  Pwd.Password := not(CheckBox1.IsChecked);
end;

procedure TForm2.CheckBox2Change(Sender: TObject);
begin
    edit1.Password := not(CheckBox1.IsChecked);
end;

procedure TForm2.CheckBox3Change(Sender: TObject);
begin
Edit1.Password := not(CheckBox1.IsChecked);
end;

procedure TForm2.close_choisClick(Sender: TObject);
begin
  Rectangle1.Visible := false;
  Rectangle8.Visible := false;
  btn_start.TintColor := TAlphaColorRec.Green;

end;

procedure TForm2.ConfirmerClick(Sender: TObject);
begin
  FDQuery1.Close;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('update logins set Password = '+QuotedStr(Pwd.Text)+' where ID = 1');
  FDQuery1.ExecSQL;
  ShowMessage('Le mot de passe est modifié');
  FDQuery1.Close;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('select * from logins');
  Rectangle1.Visible := false;
  Rectangle5.Visible := false;
end;

procedure TForm2.ExitClick(Sender: TObject);
begin
  Close;
end;

procedure TForm2.loginClick(Sender: TObject);
begin
  if ComboEdit1.ItemIndex <> -1 then
  begin
  try
    FDQuery1.Close;
    FDQuery1.SQL.Clear;
    FDQuery1.SQL.Add('select * from Logins where Project = '+QuotedStr(ComboEdit1.Items[ComboEdit1.ItemIndex]));
    FDQuery1.Active := true;
    if FDQuery1.FieldByName('Password').Text = Edit1.Text then
    begin
      ID_Project := FDQuery1.FieldByName('ID').AsString;
      Status := FDQuery1.FieldByName('Status').AsInteger;
      Type_Reseau := FDQuery1.FieldByName('Type').AsString;
      Rectangle1.Visible := false;
      Rectangle2.Visible := false;
      {$IF DEFINED(Win32)or DEFINED(Win64)}
        MenuBar1.Enabled := true;
      {$ENDIF}
    end
    else
    begin
      ShowMessage('mot de passe incorrect');
    end;
  Except
    ShowMessage('Erreur inconnu');
  end;
  end
  else
    ShowMessage('Choisir un project ou create nouveau project!');


end;

procedure TForm2.MenuItem2Click(Sender: TObject);
var mes :String;
begin
  mes := 'ATTENTION vous allez suprimer un projet,Etes-vous sur de vouloir le suprimer?';
if MessageDlg(mes, System.UITypes.TMsgDlgType.mtConfirmation,[System.UITypes.TMsgDlgBtn.mbCancel, System.UITypes.TMsgDlgBtn.mbOK],1) = mrOk then
begin
  FDQuery1.Close;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('delete from Logins where ID = '+ID_Project+';');
  FDQuery1.SQL.Add('delete from Trancons where ID_Project = '+ID_Project+';');
  FDQuery1.SQL.Add('delete from DNTrancons where ID_Project = '+ID_Project+';');
  try
    FDQuery1.ExecSQL;
    ShowMessage('Le Projet est Supprimer');
    try
      Rectangle1.Visible := true;
      Rectangle2.Visible := true;
      FDQuery1.Close;
      FDQuery1.SQL.Clear;
      FDQuery1.SQL.Add('select Project from Logins order by ID');
      FDQuery1.Active := true;
      ComboEdit1.Items.Clear;
      while not(FDQuery1.Eof) do
      begin
        ComboEdit1.Items.Add(FDQuery1.Fields[0].AsString);
        FDQuery1.Next;
      end;
    Except
      Close;
    end;
    show_keyboard := true;
  Except
    ShowMessage('Requate invalide');
  end;
end;
end;

procedure TForm2.MenuItem3Click(Sender: TObject);
begin

    try
      Rectangle1.Visible := true;
      Rectangle2.Visible := true;
      FDQuery1.Close;
      FDQuery1.SQL.Clear;
      FDQuery1.SQL.Add('select Project from Logins order by ID');
      FDQuery1.Active := true;
      ComboEdit1.Items.Clear;
      while not(FDQuery1.Eof) do
      begin
        ComboEdit1.Items.Add(FDQuery1.Fields[0].AsString);
        FDQuery1.Next;
      end;
    Except
      Close;
    end;
    show_keyboard := true;

end;

procedure TForm2.Mod_passClick(Sender: TObject);
begin
  try
    FDQuery1.Active := true;
    pwd.Text := FDQuery1.FieldByName('Password').Text;
    Rectangle1.Visible := true;
    Rectangle5.Visible := true;
  Except
    ShowMessage('Connection échouée');
  end;

end;

procedure TForm2.Nouveau_projetClick(Sender: TObject);
begin
  if Status = 0 then
  begin
    //btn_start.Text := 'Choisie un type de réseau'
    Rectangle1.Visible := true;
    Rectangle8.Visible := true;
  end
  else if Status = 1 then
  begin
   //btn_start.Text := 'Entre le donner'
    TForm5.Create(Owner).Show;
    Self.Hide;
  end
  else if Status = 2 then
  begin
   //btn_start.Text := 'Choix Diameter'
    TResult1.Create(Owner).Show;
    Self.Hide;
  end
  else if Status >= 3 then
  begin
    //btn_start.Text := 'Résulta & Itération';
    TResult2.Create(Owner).Show;
    Self.Hide;
  end;
end;


procedure TForm2.proposClick(Sender: TObject);
var propos : TForm3;
begin
  propos := TForm3.Create(Owner);
  propos.Show;
  Self.Hide;
end;

procedure TForm2.Rectangle1Click(Sender: TObject);
begin
  if Rectangle11.Visible then
  begin
    Rectangle1.Visible := false;
    Rectangle11.Visible := false;
    Rectangle1.Opacity := 0.5;
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
{$IF DEFINED(Win32)or DEFINED(Win64)}
  MenuBar1.Visible := true;
  MenuBar1.Enabled := false;
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
    Rectangle1.Opacity := 0.5;
    Rectangle1.Visible := true;
    Rectangle2.Visible := true;
    FDQuery1.Close;
    FDQuery1.SQL.Clear;
    FDQuery1.SQL.Add('select Project from Logins order by ID');
    FDQuery1.Active := true;
    while not(FDQuery1.Eof) do
    begin
      ComboEdit1.Items.Add(FDQuery1.Fields[0].AsString);
      FDQuery1.Next;
    end;

  Except
    ShowMessage('Connection échouée');
    Close;
  end;
  show_keyboard := true;
end;



procedure TForm2.FormResize(Sender: TObject);
begin
{$IF DEFINED(iOS)or DEFINED(ANDROID)}
  if Rectangle2.Visible then
  begin
    btn_Close.Width := Rectangle3.Width / 2;
    login.Width := Rectangle3.Width / 2;
  end;
  if Rectangle5.Visible then
  begin
    Confirmer.Width := Rectangle6.Width / 2;
    Cancel.Width := Rectangle6.Width / 2;
  end;
  if Rectangle8.Visible then
  begin
    btn_chois.Width := Rectangle9.Width / 2;
    close_chois.Width := Rectangle9.Width / 2;
  end;
{$ENDIF}
end;

procedure TForm2.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
{$IF DEFINED(iOS)or DEFINED(ANDROID)}
  Rectangle2.Margins.Bottom := 0;
  Rectangle5.Margins.Bottom := 0;
  Rectangle8.Margins.Bottom := 0;
  show_keyboard := true;
{$ENDIF}
end;

procedure TForm2.FormVirtualKeyboardShown(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
{$IF DEFINED(iOS)or DEFINED(ANDROID)}
  if show_keyboard then
  begin
    if Rectangle2.Visible then
      if Bounds.Height+50 >= Rectangle2.Position.Y then
        Rectangle2.Margins.Bottom := Bounds.Height+50 - Rectangle2.Position.Y;

    if Rectangle5.Visible then
      if Bounds.Height+50 >= Rectangle5.Position.Y then
        Rectangle5.Margins.Bottom := Bounds.Height+50 - Rectangle5.Position.Y;

    if Rectangle8.Visible then
      if Bounds.Height+50 >= Rectangle8.Position.Y then
        Rectangle8.Margins.Bottom := Bounds.Height+50 - Rectangle8.Position.Y;
    show_keyboard := false;
  end;
{$ENDIF}
end;

end.
