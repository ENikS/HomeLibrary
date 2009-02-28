unit frm_NewCollectionWizard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,frm_BaseProgressForm, unit_WorkerThread, RzShellDialogs, ExtCtrls, StdCtrls, ComCtrls,
  frm_ImportProgressForm,dm_user, globals, database;

type
  TfrmNewCollectionWizard = class(TForm)
    Panel1: TPanel;
    lblCaption: TLabel;
    lblHint: TLabel;
    pcWizard: TPageControl;
    tsWelcome: TTabSheet;
    Label1: TLabel;
    tsTypeSelect: TTabSheet;
    Label2: TLabel;
    Label3: TLabel;
    rgCollType: TRadioGroup;
    edCollFolder: TEdit;
    btnLibraryPath: TButton;
    tsLibrusec: TTabSheet;
    cblibrusecType: TRadioGroup;
    tsProgress: TTabSheet;
    tsEmpty: TTabSheet;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    edCollName: TEdit;
    edCollFile: TEdit;
    btnNewFile: TButton;
    btnGenreList: TButton;
    edGenreList: TEdit;
    rgCollType2: TRadioGroup;
    tsExists: TTabSheet;
    Label6: TLabel;
    Label7: TLabel;
    edExistsPath: TEdit;
    edExistsTitle: TEdit;
    btnSelectExitsPath: TButton;
    tsFinish: TTabSheet;
    Label5: TLabel;
    Bevel1: TBevel;
    btnForward: TButton;
    btnBackward: TButton;
    dlgSelectFolder: TRzSelectFolderDialog;
    txtComment: TLabel;
    ProgressBar: TProgressBar;
    btnCancel: TButton;
    tsXML: TTabSheet;
    Label4: TLabel;
    EdXMLFileName: TEdit;
    btnSelectXML: TButton;
    cbImportXML: TCheckBox;
    procedure btnLibraryPathClick(Sender: TObject);
    procedure btnNewFileClick(Sender: TObject);
    procedure btnSelectExitsPathClick(Sender: TObject);
    procedure btnForwardClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure rgCollType2Click(Sender: TObject);
    procedure btnSelectXMLClick(Sender: TObject);
    procedure btnBackwardClick(Sender: TObject);
  protected
    procedure OpenProgress;
    procedure ShowProgress(Percent: Integer);
    procedure ShowTeletype(const Msg: string; Severity: TTeletypeSeverity);
    procedure SetComment(const Comment: string);
    function ShowMessage(const Text: string; Flags: Longint = MB_OK): Integer;
    procedure CloseProgress;

  private
    FCollectionType: TCollectionType;
    FCollectionMode: (cmNew, cmExists);
    FWorkerStarted: boolean;
    FB2: boolean;
    FLibrary: TMHLLibrary;

    procedure ShowPage(Page: TTabSheet);
    procedure CreateCollection;
    procedure ImportXML;
  public

  end;

var
  frmNewCollectionWizard: TfrmNewCollectionWizard;

implementation

uses MHL_xml, unit_ImportXMLThread, unit_Settings, StrUtils, unit_Helpers;

{$R *.dfm}
//--------------------------------------------------------
//              ����������� ProgressForm
//--------------------------------------------------------

procedure TfrmNewCollectionWizard.OpenProgress;
begin
  ProgressBar.Position := 0;
end;

procedure TfrmNewCollectionWizard.ShowProgress(Percent: Integer);
begin
  ProgressBar.Position := Percent;
end;

procedure TfrmNewCollectionWizard.ShowTeletype(const Msg: string; Severity: TTeletypeSeverity);
begin
  // ������ �� ������
end;

function TfrmNewCollectionWizard.ShowMessage(const Text: string; Flags: Longint = MB_OK): Integer;
begin
  Result := Application.MessageBox(PAnsiChar(Text), PAnsiChar(Application.Title), Flags);
end;

procedure TfrmNewCollectionWizard.SetComment(const Comment: string);
begin
  txtComment.Caption := Comment;
end;

procedure TfrmNewCollectionWizard.CloseProgress;
begin
  // ���� ������ �� ������
end;

procedure TfrmNewCollectionWizard.rgCollType2Click(Sender: TObject);
begin
  if rgCollType2.ItemIndex = 1 then
  begin
    edGenreList.Enabled := True;
    btnGenreList.Enabled := True;
  end
  else
  begin
    edGenreList.Enabled := False;
    btnGenreList.Enabled := False;
  end;
end;

//------------------------------------------------------------
//            ������ �����
//--------------------------------------------------------------
procedure TfrmNewCollectionWizard.FormShow(Sender: TObject);
var
  i: integer;
begin
  // ������ ��������. � �������� ��� �������� ����� ���������
  // � � ���������� ��������, �� ��� ����� ����� ������������
  for i := 0 to pcWizard.PageCount - 1 do
      pcWizard.Pages[i].TabVisible := false;

  // ������ �������� (�������) ������ ��������
  pcWizard.ActivePage := tsWelcome;
  btnForward.Caption := '������ >';
  FWorkerStarted := False;
end;

procedure TfrmNewCollectionWizard.ImportXML;
var
  worker: TImportXMLThread;
begin
  FWorkerStarted := True;
  Worker := TImportXMLThread.Create;
  try
    Worker.XMLFileName := edXMLFileName.Text;
    Worker.DBFileName := edCollFile.Text;
    Worker.CollectionName := edCollName.Text;
    Worker.CollectionType := Ord(FCollectionType);

    Worker.OnOpenProgress := OpenProgress;
    Worker.OnProgress := ShowProgress;
    Worker.OnCloseProgress := CloseProgress;
    Worker.OnTeletype := ShowTeletype;
    Worker.OnSetComment := SetComment;
    Worker.OnShowMessage := ShowMessage;

    //WorkerThread := worker;

    Worker.Start;
  finally
    Worker.Free;
    FWorkerStarted := False;
  end;
end;

procedure TfrmNewCollectionWizard.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := True;
end;

procedure TfrmNewCollectionWizard.FormDestroy(Sender: TObject);
begin
  //
end;

procedure TfrmNewCollectionWizard.CreateCollection;
begin
  if CollectionStatus = csNew then
  begin
    if edGenreList.Text = '' then
      edGenreList.Text := Settings.SystemFileName[sfGenresNonFB2];

    FLibrary := TMHLLibrary.Create(nil);
    try
      FLibrary.CreateCollectionTables(edCollFile.Text,
                  IfThen(FB2, Settings.SystemFileName[sfGenresFB2], edGenreList.Text));
    finally
      FLibrary.Free;
    end;
  end;

  DMUser.tblBases.Insert;

  DMUser.ActiveCollection.CollectionType := FCollectionType;
  if FCollectionMode = cmNew then
  begin
    DMUser.ActiveCollection.Name := edCollName.Text;
    DMUser.ActiveCollection.DBFileName := edCollFile.Text;
  end
  else
  begin
    DMUser.ActiveCollection.Name := edExistsTitle.Text;
    DMUser.ActiveCollection.DBFileName := edExistsPath.Text;
  end;

  DMUser.ActiveCollection.RootFolder := edCollFolder.Text;
  DMUser.ActiveCollection.CreationDate := Now;

  if FileExists(edCollFile.Text) then
  begin
    DMUser.tblBases.Post;
  end
  else
  begin
    DMUser.tblBases.Cancel;
    ShowMessage('�� ������� ������� ����!');
    Exit;
  end;
end;

procedure TfrmNewCollectionWizard.ShowPage(Page: TTabSheet);
begin
  // ��������� ���������
  pcWizard.ActivePage := Page;

  // ��������� ���������� ���������
  lblCaption.Caption := Page.Caption;
  lblHint.Caption := Page.Hint;

  // ����������� ������ "�����"
  btnBackward.Visible := (Page <> tsWelcome) and (Page <> tsFinish) and (Page <> tsProgress);

  // ����������� ������ "������"
  btnForward.Visible := Page <> tsProgress;

  if Page= tsFinish then
    btnForward.Caption := '������'
  else
    btnForward.Caption := '������ >';

  // ����������� ������ "������"
  btnCancel.Enabled := (Page <> tsFinish);
end;

//------------------------------------------------------------
//            ����������� �������
//--------------------------------------------------------------

procedure TfrmNewCollectionWizard.btnBackwardClick(Sender: TObject);
begin
  // ��� �������� �����������?
  if pcWizard.ActivePage = tsWelcome then
  begin
    // ��������
    Exit;
  end;

  // ��� �������� ������ ���� ���������?
  if pcWizard.ActivePage = tsTypeSelect then
  begin
    ShowPage(tsWelcome);
    Exit;
  end;

  // ��� ����� ���� ��������� ��������?
  if pcWizard.ActivePage = tsLibrusec then
  begin
    ShowPage(tsTypeSelect);
    Exit;
  end;

  // ��� ������ ���������?
  if pcWizard.ActivePage = tsEmpty then
  begin
    ShowPage(tsTypeSelect);
    Exit;
  end;

  // ��� ������ ���������� ������������ ���������?
  if pcWizard.ActivePage = tsExists then
  begin
    ShowPage(tsTypeSelect);
    Exit;
  end;

  // ��� �������� ������� XML?
  if pcWizard.ActivePage = tsXML then
  begin
    ShowPage(tsEmpty);
    Exit;
  end;

end;

procedure TfrmNewCollectionWizard.btnForwardClick(Sender: TObject);
begin
  // ��� �������� �����������?
  if pcWizard.ActivePage = tsWelcome then
  begin
    // ���� ������
    ShowPage(tsTypeSelect);
    Exit;
  end;

  // ��� �������� ������ ���� ���������?
  if pcWizard.ActivePage = tsTypeSelect then
  begin
    // �������� ����� � �������
    if Trim(edCollFolder.Text) = '' then
    begin
      edCollFolder.SetFocus;
      Application.MessageBox('������� �����  � �������', PChar(Caption), MB_OK or MB_ICONWARNING);
      Exit;
    end;

    // ���������� ��������������� ��������
    case rgCollType.ItemIndex of
      0: ShowPage(tsLibrusec);
      1: ShowPage(tsEmpty);
      2: ShowPage(tsExists);
    end;
    Exit;
  end;

  // ��� ����� ���� ��������� ��������?
  if pcWizard.ActivePage = tsLibrusec then
  begin
    case cbLibrusecType.ItemIndex of
     -1:Exit;
      0:FCollectionType := ctFBLocal;
      1:FCollectionType := ctFBOnline;
    end;
    ShowPage(tsProgress);
    Exit;
  end;

  // ��� ������ ���������?
  if pcWizard.ActivePage = tsEmpty then
  begin
    // �������� ����� �����
    if Trim(edCollFile.Text) = '' then
    begin
      edCollFile.SetFocus;
      Application.MessageBox('������� ��� ����� ���������', PChar(Caption), MB_OK or MB_ICONWARNING);
      Exit;
    end;
    // �������� �������� ���������
    if Trim(edCollName.Text) = '' then
    begin
      edCollName.SetFocus;
      Application.MessageBox('������� �������� ���������', PChar(Caption), MB_OK or MB_ICONWARNING);
      Exit;
    end;

    if rgCollType2.ItemIndex = 0 then
      FCollectionType := ctFBLocal
    else
      FCollectionType := ctNonFBLocal;
    FCollectionMode := cmNew;

    if cbImportXML.Checked then
      ShowPage(tsXML)
    else
    begin
      CreateCollection;
      ShowPage(tsFinish);
    end;
    Exit;
  end;

  // ��� ������ ���������� ������������ ���������?
  if pcWizard.ActivePage = tsExists then
  begin
    // �������� ����� �����
    if Trim(edExistsPath.Text) = '' then
    begin
      edExistsPath.SetFocus;
      Application.MessageBox('������� ��� ����� ���������', PChar(Caption), MB_OK or MB_ICONWARNING);
      Exit;
    end;
    // �������� �������� ���������
    if Trim(edExistsTitle.Text) = '' then
    begin
      edExistsTitle.SetFocus;
      Application.MessageBox('������� �������� ���������', PChar(Caption), MB_OK or MB_ICONWARNING);
      Exit;
    end;
    if rgCollType2.ItemIndex = 0 then
      FCollectionType := ctFBLocal
    else
      FCollectionType := ctNonFBLocal;
    FCollectionMode := cmExists;

    CreateCollection;

    ShowPage(tsFinish);
    Exit;
  end;

  // ��� �������� ������� XML?
  if pcWizard.ActivePage = tsXML then
  begin
    if Trim(edXMLFileName.Text) = '' then
    begin
      edXMLFileName.SetFocus;
      Application.MessageBox('������� ��� XML-�����', PChar(Caption), MB_OK or MB_ICONWARNING);
      Exit;
    end;
    // ������� ������� ���������
    ShowPage(tsFinish);

    // ����� ��������� ������� �� XML

    ImportXML;

    ShowPage(tsFinish);
    Exit;
  end;

  // ��� �������� �������� ��������?
  if pcWizard.ActivePage = tsProgress then
  begin
    // ��������� ���������������
    ShowPage(tsFinish);
    Exit;
  end;

  // ��� ��������� ��������?
  if pcWizard.ActivePage = tsFinish then
  begin
    ModalResult := mrOK;
    Exit;
  end;
end;

procedure TfrmNewCollectionWizard.btnLibraryPathClick(Sender: TObject);
begin
  if dlgSelectFolder.Execute then
    edCollFolder.Text := dlgSelectFolder.SelectedPathName;
end;

procedure TfrmNewCollectionWizard.btnNewFileClick(Sender: TObject);
var
  AFileName: string;
begin
  if GetFileName(fnSaveCollection, AFileName) then
    edCollFile.Text := AFileName;
end;

procedure TfrmNewCollectionWizard.btnSelectExitsPathClick(Sender: TObject);
var
  AFileName: string;
begin
  if GetFileName(fnOpenCollection, AFileName) then
    edExistsPath.Text := AFileName;
end;

procedure TfrmNewCollectionWizard.btnSelectXMLClick(Sender: TObject);
var
  AFileName: string;
begin
  if GetFileName(fnOpenImportFile, AFileName) then
    edXMLFileName.Text := AFileName;
end;

end.

