(* *****************************************************************************
  *
  * MyHomeLib
  *
  * Copyright (C) 2008-2010 Aleksey Penkov
  *
  * Authors Aleksey Penkov   alex.penkov@gmail.com
  *         Nick Rymanov     nrymanov@gmail.com
  * Created                  20.08.2008
  * Description              
  *
  * $Id$
  *
  * History
  *
  ****************************************************************************** *)

{
Note: � ���� ����� ������� ������� ����������� �� ������� �����. ���� �� ������� �� ����� ���������.
}

unit frm_edit_book_info;

interface

uses
  Windows,
  Messages,
  Classes,
  Graphics,
  Controls,
  StdCtrls,
  ExtCtrls,
  ComCtrls,
  Forms,
  Dialogs,
  unit_Globals;

type
  TfrmEditBookInfo = class(TForm)
    edSN: TEdit;
    edT: TEdit;
    lvAuthors: TListView;
    btnADelete: TButton;
    btnAChange: TButton;
    btnAddAuthor: TButton;
    lblGenre: TEdit;
    btnGenres: TButton;
    cbSeries: TComboBox;
    edKeyWords: TEdit;
    cbLang: TComboBox;
    btnNextBook: TButton;
    btnPrevBook: TButton;
    pnButtons: TPanel;
    btnOk: TButton;
    btnCancel: TButton;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    gbAuthors: TGroupBox;
    gbExtraInfo: TGroupBox;
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnGenresClick(Sender: TObject);
    procedure btnAddAuthorClick(Sender: TObject);
    procedure btnAChangeClick(Sender: TObject);
    procedure btnADeleteClick(Sender: TObject);
    procedure edTChange(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnNextBookClick(Sender: TObject);
    procedure btnPrevBookClick(Sender: TObject);

  private
    FChanged: Boolean;

    procedure FillLists;
    function SaveData: Boolean;
  public
    function GetGenres: TBookGenres;
  end;

var
  frmEditBookInfo: TfrmEditBookInfo;

implementation

uses
  dm_collection,
  dm_user,
  frm_genre_tree,
  frm_main,
  frm_edit_author,
  unit_TreeUtils,
  VirtualTrees,
  unit_Consts;

resourcestring
  rstrProvideAtLeastOneAuthor = '������� ������� ������ ������!';
  rstrProvideBookTitle = '������� �������� �����!';

{$R *.dfm}

procedure TfrmEditBookInfo.FormShow(Sender: TObject);
begin
  FChanged := False;
  if frmGenreTree.tvGenresTree.GetFirstSelected = nil then
    FillGenresTree(frmGenreTree.tvGenresTree);
  FillLists;
end;

procedure TfrmEditBookInfo.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  Dummy: boolean;
begin
  if Key = VK_F1 then
    frmMain.HH(0, 0, Dummy);
end;

procedure TfrmEditBookInfo.btnGenresClick(Sender: TObject);
var
  Genres: TBookGenres;
begin
  if frmGenreTree.ShowModal = mrOk then
  begin
    Genres := GetGenres;
    lblGenre.Text := TGenresHelper.GetList(Genres);
    FChanged := True;
  end;
end;

procedure TfrmEditBookInfo.btnAddAuthorClick(Sender: TObject);
var
  Family: TListItem;
  frmEditAuthor: TfrmEditAuthorData;
begin
  frmEditAuthor := TfrmEditAuthorData.Create(Self);
  try
    if frmEditAuthor.ShowModal = mrOk then
    begin
      Family := lvAuthors.Items.Add;
      Family.Caption := frmEditAuthor.LastName;
      Family.SubItems.Add(frmEditAuthor.FirstName);
      Family.SubItems.Add(frmEditAuthor.MidName);

      FChanged := True;
    end;
  finally
    frmEditAuthor.Free;
  end;
end;

procedure TfrmEditBookInfo.btnAChangeClick(Sender: TObject);
var
  Family: TListItem;
  frmEditAuthor: TfrmEditAuthorData;
begin
  Family := lvAuthors.Selected;
  if not Assigned(Family) then
    Exit;

  frmEditAuthor := TfrmEditAuthorData.Create(Self);
  try
    frmEditAuthor.LastName := Family.Caption;
    frmEditAuthor.FirstName := Family.SubItems[0];
    frmEditAuthor.MidName := Family.SubItems[1];

    if frmEditAuthor.ShowModal = mrOk then
    begin
      Family.Caption := frmEditAuthor.LastName;
      Family.SubItems[0] := frmEditAuthor.FirstName;
      Family.SubItems[1] := frmEditAuthor.MidName;

      FChanged := True;
    end;
  finally
    frmEditAuthor.Free;
  end;
end;

procedure TfrmEditBookInfo.btnADeleteClick(Sender: TObject);
begin
  lvAuthors.DeleteSelected;
end;

procedure TfrmEditBookInfo.edTChange(Sender: TObject);
begin
  FChanged := True;
end;

procedure TfrmEditBookInfo.btnSaveClick(Sender: TObject);
begin
  if SaveData then
    ModalResult := mrOk;
end;

procedure TfrmEditBookInfo.btnNextBookClick(Sender: TObject);
begin
  if SaveData then
  begin
    frmMain.SelectNextBook(FChanged, True);
    FChanged := False;
  end;
end;

procedure TfrmEditBookInfo.btnPrevBookClick(Sender: TObject);
begin
  if SaveData then
  begin
    frmMain.SelectNextBook(FChanged, False);
    FChanged := False;
  end;
end;

procedure TfrmEditBookInfo.FillLists;
var
  FFiltered: Boolean;
begin
  cbSeries.Items.Clear;

  DMCollection.Series.DisableControls;
  try
    FFiltered := DMCollection.Series.Filtered;
    DMCollection.Series.Filtered := False;
    try
      DMCollection.Series.First;
      while not DMCollection.Series.Eof do
      begin
        cbSeries.Items.Add(DMCollection.Series[SERIE_TITLE_FIELD]);
        DMCollection.Series.Next;
      end;
    finally
      DMCollection.Series.Filtered := FFiltered;
    end;
  finally
    DMCollection.Series.EnableControls;
  end;
end;

function TfrmEditBookInfo.SaveData: boolean;
begin
  Result := False;

  if not FChanged then
  begin
    Result := True;
    Exit;
  end;

  if lvAuthors.Items.Count = 0 then
  begin
    MessageDlg(rstrProvideAtLeastOneAuthor, mtError, [mbOk], 0);
    Exit;
  end;

  if edT.Text = '' then
  begin
    MessageDlg(rstrProvideBookTitle, mtError, [mbOk], 0);
    Exit;
  end;

  Result := True;
end;

function TfrmEditBookInfo.GetGenres: TBookGenres;
var
  Data: PGenreData;
  Node: PVirtualNode;
  Idx: Integer;
begin
  Node := frmGenreTree.tvGenresTree.GetFirstSelected;
  Idx := 0;
  while Assigned(Node) do
  begin
    Data := frmGenreTree.tvGenresTree.GetNodeData(Node);

    TGenresHelper.Add(Result, Data.GenreCode, Data.GenreAlias, Data.FB2GenreCode);
    Result[Idx].ParentCode := Data.ParentCode;

    Node := frmGenreTree.tvGenresTree.GetNextSelected(Node);
    Inc(Idx);
  end;
end;

end.
