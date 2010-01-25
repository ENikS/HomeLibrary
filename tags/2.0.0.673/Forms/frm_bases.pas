
{******************************************************************************}
{                                                                              }
{                                 MyHomeLib                                    }
{                                                                              }
{                                Version 0.9                                   }
{                                20.08.2008                                    }
{                    Copyright (c) Aleksey Penkov  alex.penkov@gmail.com       }
{                                                                              }
{******************************************************************************}

unit frm_bases;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  Mask,
  ExtCtrls,
  unit_StaticTip,
  RzEdit,
  RzBtnEdt,
  RzPanel,
  RzRadGrp, unit_AutoCompleteEdit, RzLabel, RzTabs;

type
  TfrmBases = class(TForm)
    RzPageControl1: TRzPageControl;
    TabSheet1: TRzTabSheet;
    TabSheet2: TRzTabSheet;
    RzPanel1: TRzPanel;
    btnCancel: TButton;
    btnSave: TButton;
    cbRelativePath: TCheckBox;
    MHLStaticTip1: TMHLStaticTip;
    edDescription: TRzEdit;
    Label1: TLabel;
    Label5: TLabel;
    edCollectionRoot: TMHLAutoCompleteEdit;
    edCollectionFile: TMHLAutoCompleteEdit;
    edCollectionName: TEdit;
    Label9: TLabel;
    Label8: TLabel;
    btnNewFile: TButton;
    btnSelectRoot: TButton;
    RzLabel5: TRzLabel;
    edUser: TRzEdit;
    edPass: TRzMaskEdit;
    RzLabel6: TRzLabel;
    edURL: TRzEdit;
    RzLabel1: TRzLabel;
    RzLabel2: TRzLabel;
    mmScript: TMemo;
    procedure FormShow(Sender: TObject);
    procedure edDBFileButtonClick(Sender: TObject);
    procedure edDBFolderButtonClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);

  private
    CollectionID: Integer;

    function GetDisplayName: string;
    procedure SetDisplayName(const Value: string);
    function GetDBFileName: string;
    procedure SetDBFileName(const Value: string);
    function GetRootFolder: string;
    procedure SetRootFolder(const Value: string);
    function GetDescription: string;
    procedure SetDescription(const Value: string);
    function GetPass: string;
    function GetScript: string;
    function GetURL: string;
    function GetUser: string;
    procedure SetPass(const Value: string);
    procedure SetScript(const Value: string);
    procedure SetURL(const Value: string);
    procedure SetUser(const Value: string);

    property DisplayName: string read GetDisplayName write SetDisplayName;
    property DBFileName: string read GetDBFileName write SetDBFileName;
    property RootFolder: string read GetRootFolder write SetRootFolder;
    property Description: string read GetDescription write SetDescription;
    property URL: string read GetURL write SetURL;
    property User: string read GetUser write SetUser;
    property Pass: string read GetPass write SetPass;
    property Script: string read GetScript write SetScript;
  public

  end;

var
  frmBases: TfrmBases;

implementation

uses
  DB,
  dm_user,
  unit_globals,
  unit_database,
  dm_collection,
  StrUtils,
  unit_Settings,
  unit_Helpers,
  unit_Consts,
  unit_Errors;

{$R *.dfm}

procedure TfrmBases.FormShow(Sender: TObject);
begin
  CollectionID := DMUser.ActiveCollection.ID;

  DisplayName := DMUser.ActiveCollection.Name;
  DBFileName := DMUser.ActiveCollection.DBFileName;
  RootFolder := DMUser.ActiveCollection.RootFolder;
  Description := DMUser.ActiveCollection.Notes;
  URL := DMUser.ActiveCollection.URL;
  Pass := DMUser.ActiveCollection.Password;
  User := DMUser.ActiveCollection.User;
  Script := DMUser.ActiveCollection.Script;

end;

function TfrmBases.GetDisplayName: string;
begin
  Result := Trim(edCollectionName.Text);
end;

function TfrmBases.GetPass: string;
begin
  Result := edPass.Text;
end;

procedure TfrmBases.SetDisplayName(const Value: string);
begin
  edCollectionName.Text := Value;
end;

procedure TfrmBases.SetPass(const Value: string);
begin
  edPass.Text := Value;
end;

function TfrmBases.GetDBFileName: string;
begin
  Result := Trim(edCollectionFile.Text);
end;

function TfrmBases.GetDescription: string;
begin
  Result := Trim(edDescription.Text);
end;

procedure TfrmBases.SetDBFileName(const Value: string);
begin
  edCollectionFile.Text := Value;
end;

procedure TfrmBases.SetDescription(const Value: string);
begin
  edDescription.Text := Value;
end;

function TfrmBases.GetRootFolder: string;
begin
  Result := Trim(edCollectionRoot.Text);
end;

function TfrmBases.GetScript: string;
begin
  Result := mmScript.Lines.Text;
end;

function TfrmBases.GetURL: string;
begin
  Result := edURL.Text;
end;

function TfrmBases.GetUser: string;
begin
  Result := edUser.Text;
end;

procedure TfrmBases.SetRootFolder(const Value: string);
begin
  edCollectionRoot.Text := Value;
end;

procedure TfrmBases.SetScript(const Value: string);
begin
  mmScript.Lines.Clear;
  mmscript.Lines.Text := Value;
end;

procedure TfrmBases.SetURL(const Value: string);
begin
  edURL.Text := Value;
end;

procedure TfrmBases.SetUser(const Value: string);
begin
  edUser.Text := Value;
end;

procedure TfrmBases.edDBFileButtonClick(Sender: TObject);
var
  AFileName: string;
begin
  if GetFileName(fnOpenCollection, AFileName) then
    edCollectionFile.Text := AFileName;
end;

procedure TfrmBases.edDBFolderButtonClick(Sender: TObject);
var
  AFolder: string;
begin
  if GetFolderName(Handle, '�������� ����� ��� ���������� ������', AFolder) then
    edCollectionRoot.Text := AFolder;
end;

procedure TfrmBases.btnSaveClick(Sender: TObject);
var
  ADBFileName: string;
  ARootFolder: string;
begin

  if (DisplayName = '') or (DBFileName = '') or (RootFolder = '') then
  begin
    MessageDlg(rstrAllFieldsShouldBeFilled, mtError, [mbOk], 0);
    Exit;
  end;

  //
  // �������� �������� ���������
  //
  if DMUser.FindCollectionWithProp(cpDisplayName, DisplayName, CollectionID) then
  begin
    MessageDlg(Format(rstrCollectionAlreadyExists, [DisplayName]), mtError, [mbOk], 0);
    Exit;
  end;

  //
  // TODO -oNickR -cBug: � �������� �������� �������� ���������� ������������ DataPath
  //
  if not cbRelativePath.Checked then
  begin
    ADBFileName := ExpandFileName(DBFileName);
    if '' = ExtractFileExt(ADBFileName) then
      ADBFileName := ChangeFileExt(ADBFileName, COLLECTION_EXTENSION);

    ARootFolder := ExcludeTrailingPathDelimiter(ExpandFileName(RootFolder));
  end
  else
  begin
    ADBFileName := DBFileName;
    if '' = ExtractFileExt(ADBFileName) then
      ADBFileName := ChangeFileExt(ADBFileName, COLLECTION_EXTENSION);
    ARootFolder := ExcludeTrailingPathDelimiter(RootFolder);
  end;

  //
  // �������� �������� � ������������� �����
  //
  if not FileExists(ADBFileName) then
  begin
    MessageDlg(Format(rstrFileDoesntExists, [ADBFileName]), mtError, [mbOk], 0);
    Exit;
  end;

  if DMUser.FindCollectionWithProp(cpFileName, ADBFileName, CollectionID) then
  begin
    MessageDlg(Format(rstrFileAlreadyExistsInDB, [ADBFileName]), mtError, [mbOk], 0);
    Exit;
  end;

  DMUser.UpdateCollectionProps(CollectionID,
                               DisplayName,
                               ARootFolder,
                               ADBFileName,
                               Description,
                               URL,
                               User,
                               Pass,
                               Script);

  ModalResult := mrOk;
end;

end.

