(* *****************************************************************************
  *
  * MyHomeLib
  *
  * Copyright (C) 2008-2010 Aleksey Penkov
  *
  * Authors Aleksey Penkov   alex.penkov@gmail.com
  *         Nick Rymanov     nrymanov@gmail.com
  *
  * History
  * NickR 02.03.2010    ��� ����������������
  *                     ��������� �������� ��� ������� �����
  *
  ****************************************************************************** *)

unit frm_book_info;

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
  xmldom,
  XMLIntf,
  msxmldom,
  XMLDoc,
  ExtCtrls,
  StdCtrls,
  ComCtrls,
  unit_Globals,
  Menus,
  ActnList;

type
  TfrmBookDetails = class(TForm)
    pcBookInfo: TPageControl;
    tsInfo: TTabSheet;
    tsReview: TTabSheet;
    mmShort: TMemo;
    imgCover: TImage;
    pnButtons: TPanel;
    btnClose: TButton;
    btnLoadReview: TButton;
    mmReview: TMemo;
    btnClearReview: TButton;
    pnTitle: TPanel;
    lblAuthors: TLabel;
    lvInfo: TListView;
    lblTitle: TLabel;
    pnReviewButtons: TPanel;
    tsFileInfo: TTabSheet;
    lvFileInfo: TListView;
    pmBookInfo: TPopupMenu;
    alBookInfo: TActionList;
    acCopyValue: TAction;
    miCopyValue: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mmReviewChange(Sender: TObject);
    procedure btnLoadReviewClick(Sender: TObject);
    procedure btnClearReviewClick(Sender: TObject);
    procedure acCopyValueExecute(Sender: TObject);
    procedure acCopyValueUpdate(Sender: TObject);

  private
    FUrl: string;
    FReviewChanged: Boolean;
    function GetReview: string;
    procedure SetReview(const Value: string);

  public
    procedure AllowOnlineReview(URL: string);
    procedure Download;

    procedure FillBookInfo(bookInfo: TBookRecord; bookStream: TMemoryStream);

    property Review: string read GetReview write SetReview;
    property ReviewChanged: Boolean read FReviewChanged write FReviewChanged;
    property URL: string read FUrl write FUrl;
  end;

  TReviewDownloadThread = class(TThread)
  private
    FForm: TfrmBookDetails;
    FReview: TStringList;
    FUrl: string;

    procedure StartDownload;
    procedure Finish;
  protected
    procedure Execute; override;
    property Form: TfrmBookDetails read FForm write FForm;
  public
    property URL: string write FUrl;
  end;

procedure DownloadReview(Form: TfrmBookDetails; URL: string);

var
  frmBookDetails: TfrmBookDetails;

implementation

uses
  Clipbrd,
  FictionBook_21,
  unit_Settings,
  unit_ReviewParser,
  dm_user,
  CommCtrl,
  StrUtils,
  unit_MHLHelpers,
  unit_FB2Utils;

{$R *.dfm}

procedure TfrmBookDetails.FormCreate(Sender: TObject);
begin
  lvFileInfo.ShowColumnHeaders := False;
  lvInfo.ShowColumnHeaders := False;
  FReviewChanged := False;
end;

procedure TfrmBookDetails.acCopyValueExecute(Sender: TObject);
begin
  if pcBookInfo.ActivePage = tsFileInfo then
  begin
    Assert(Assigned(lvFileInfo.Selected));
    Clipboard.AsText := lvFileInfo.Selected.SubItems[0];
  end
  else if pcBookInfo.ActivePage = tsInfo then
  begin
    Assert(Assigned(lvInfo.Selected));
    Clipboard.AsText := lvInfo.Selected.SubItems[0];
  end;
end;

procedure TfrmBookDetails.acCopyValueUpdate(Sender: TObject);
begin
  if pcBookInfo.ActivePage = tsFileInfo then
  begin
    acCopyValue.Enabled := Assigned(lvFileInfo.Selected);
  end
  else if pcBookInfo.ActivePage = tsInfo then
  begin
    acCopyValue.Enabled := Assigned(lvInfo.Selected);
  end
  else
    acCopyValue.Enabled := False;
end;

procedure TfrmBookDetails.AllowOnlineReview(URL: string);
begin
  FUrl := URL;

  pnReviewButtons.Visible := True;
end;

procedure TfrmBookDetails.Download;
var
  reviewParser: TReviewParser;
  Review: TStringList;
begin
  btnLoadReview.Enabled := False;
  Screen.Cursor := crHourGlass;
  try
    reviewParser := TReviewParser.Create;
    try
      Review := TStringList.Create;
      try
        reviewParser.Parse(FUrl, Review);
        mmReview.Lines.Assign(Review);

        FReviewChanged := True;
      finally
        Review.Free;
      end;
    finally
      reviewParser.Free;
    end;
  finally
    Screen.Cursor := crDefault;
    btnLoadReview.Enabled := True;
  end;
end;

procedure TfrmBookDetails.FormShow(Sender: TObject);
begin
  // TODO ��������� ��� ����� ���������� ?
  ListView_SetColumnWidth(lvFileInfo.Handle, 0, LVSCW_AUTOSIZE);
  ListView_SetColumnWidth(lvFileInfo.Handle, 1, LVSCW_AUTOSIZE);
  ListView_SetColumnWidth(lvInfo.Handle, 0, LVSCW_AUTOSIZE);
  ListView_SetColumnWidth(lvInfo.Handle, 1, LVSCW_AUTOSIZE);
end;

function TfrmBookDetails.GetReview: string;
begin
  Result := mmReview.Lines.Text;
end;

procedure TfrmBookDetails.mmReviewChange(Sender: TObject);
begin
  FReviewChanged := True;
end;

procedure TfrmBookDetails.btnClearReviewClick(Sender: TObject);
begin
  mmReview.Clear;
  FReviewChanged := True;
end;

procedure TfrmBookDetails.btnLoadReviewClick(Sender: TObject);
begin
  Download;
end;

procedure TfrmBookDetails.SetReview(const Value: string);
begin
  mmReview.Lines.Text := Value;
end;

procedure TfrmBookDetails.FillBookInfo(bookInfo: TBookRecord; bookStream: TMemoryStream);
var
  book: IXMLFictionBook;
  i: integer;
  imgBookCover: TGraphic;
  tmpStr: string;

  procedure AddItem(listView: TListView; const Field: string; const Value: string; GroupID: integer = -1);
  var
    item: TListItem;
  begin
    if Trim(Value) <> '' then
    begin
      item := listView.Items.Add;
      item.Caption := Field;
      item.SubItems.Add(Value);
      item.GroupID := GroupID;
    end;
  end;

begin
  //
  // ������� ���������� �� TBookRecord
  //
  lblTitle.Caption := bookInfo.Title;
  lblAuthors.Caption := bookInfo.Authors[0].GetFullName;

  with lvFileInfo.Groups.Add do
  begin
    Header := '���������� � �����';
    AddItem(lvFileInfo, '�����', bookInfo.Folder, GroupID);
    AddItem(lvFileInfo, '����', bookInfo.FileName, GroupID);
    AddItem(lvFileInfo, '������', GetFormattedSize(bookInfo.Size, True), GroupID);
    AddItem(lvFileInfo, '��������', DateToStr(bookInfo.Date), GroupID);
  end;
  { TODO -oNickR -cUsability : ��� ������ ��������� ���������� ���������� ��������� ���� }
  // libID: Integer;    ???
  // LibRate: Integer;  ???
  // URI: string;       ???

  //
  // ������� ���������� �� �����
  // TODO : ����� �� ����� ���� ����� ����� ����� �������. ����� �� �������� �� �������� ����������� ���� �� pdf � ������ ��������
  //
  if not Assigned(bookStream) or (bookStream.Size = 0) then
  begin
    tsInfo.TabVisible := False;
    Exit;
  end;

  // FS.SaveToFile('C:\temp\book.xml');
  try
    book := LoadFictionbook(bookStream);

    //
    // ������� ������� (���� ����)
    //
    imgBookCover := GetBookCover(book);
    if Assigned(imgBookCover) then
    begin
      try
        imgCover.Picture.Assign(imgBookCover);
        imgCover.Visible := True;
      finally
        imgBookCover.Free;
      end;
    end
    else
      imgCover.Visible := False;

    // ---------------------------------------------
    with book.Description.Titleinfo, lvInfo.Groups.Add do
    begin
      Header := '����� ����������';

      AddItem(lvInfo, '��������', Booktitle.Text, GroupID);

      for i := 0 to Author.Count - 1 do
      begin
        with Author[i] do
          tmpStr := TAuthorRecord.FormatName(Lastname.Text, Firstname.Text, Middlename.Text, NickName.Text);
        AddItem(lvInfo, IfThen(i = 0, '�����(�)'), tmpStr, GroupID);
      end;

      { TODO -oNickR -cUsability : ���������� ����� � ����� }
      for i := 0 to Sequence.Count - 1 do
      begin
        AddItem(lvInfo, IfThen(i = 0, '�����'), Sequence[i].Name, GroupID);
      end;

      { TODO -oNickR -cUsability : ���������� ������ ������ ���������� ���� }
      for i := 0 to Genre.Count - 1 do
      begin
        AddItem(lvInfo, IfThen(i = 0, '����'), Genre[i], GroupID);
      end;

      AddItem(lvInfo, '�������� �����', Keywords.Text, GroupID);
      AddItem(lvInfo, '����', Date.Text, GroupID);
      AddItem(lvInfo, '���� �����', Lang, GroupID);
      AddItem(lvInfo, '���� ���������', Srclang, GroupID);

      for i := 0 to Translator.Count - 1 do
      begin
        with Translator[i] do
          tmpStr := TAuthorRecord.FormatName(Lastname.Text, Firstname.Text, Middlename.Text, NickName.Text);
        AddItem(lvInfo, IfThen(i = 0, '����������(�)'), tmpStr, GroupID);
      end;
    end;

    // ---------------------------------------------
    with book.Description.Publishinfo, lvInfo.Groups.Add do
    begin
      Header := '������������ ����������';

      AddItem(lvInfo, '��������', Bookname.Text, GroupID);

      AddItem(lvInfo, '������������', Publisher.Text, GroupID);
      AddItem(lvInfo, '�����', City.Text, GroupID);
      AddItem(lvInfo, '���', Year, GroupID);
      AddItem(lvInfo, 'ISBN', Isbn.Text, GroupID);

      { TODO -oNickR -cUsability : ���������� ����� � ����� }
      for i := 0 to Sequence.Count - 1 do
      begin
        AddItem(lvInfo, IfThen(i = 0, '�����'), Sequence[i].Name, GroupID);
      end;
    end;

    // ---------------------------------------------
    with book.Description.Documentinfo, lvInfo.Groups.Add do
    begin
      Header := '���������� � ��������� (OCR)';
      for i := 0 to Author.Count - 1 do
      begin
        with Author[i] do
          tmpStr := TAuthorRecord.FormatName(Lastname.Text, Firstname.Text, Middlename.Text, NickName.Text);
        AddItem(lvInfo, IfThen(i = 0, '������'), tmpStr, GroupID);
      end;

      AddItem(lvInfo, '���������', Programused.Text, GroupID);
      AddItem(lvInfo, '����', Date.Text, GroupID);
      AddItem(lvInfo, 'ID', book.Description.Documentinfo.Id, GroupID);
      AddItem(lvInfo, '������', Version, GroupID);

      for i := 0 to Srcurl.Count - 1 do
      begin
        AddItem(lvInfo, IfThen(i = 0, '��������'), Srcurl[i], GroupID);
      end;
      AddItem(lvInfo, '����� ���������', Srcocr.Text, GroupID);

      for i := 0 to History.p.Count - 1 do
        AddItem(lvInfo, IfThen(i = 0, '�������'), History.p[i].OnlyText, GroupID);
    end;

    // ---------------------------------------------
    { TODO -oNickR -cUsability : ����� ����� ��������� ��������� ��� ����? }
    with book.Description.Titleinfo do
    begin
      for i := 0 to Annotation.p.Count - 1 do
        mmShort.Lines.Add(Annotation.p[i].OnlyText);
    end;
  except
    //
    Assert(False);
  end;
end;

{ -------------------- TReviewDownloadThread ----------------------------------- }

procedure TReviewDownloadThread.Execute;
var
  reviewParser: TReviewParser;
begin
  Synchronize(StartDownload);
  FReview := TStringList.Create;
  try
    reviewParser := TReviewParser.Create;
    try
      reviewParser.Parse(FUrl, FReview);
    finally
      reviewParser.Free;
    end;
  finally
    Synchronize(Finish);
    FreeAndNil(FReview);
  end;
end;

procedure TReviewDownloadThread.StartDownload;
begin
  FForm.btnLoadReview.Enabled := False;
end;

procedure TReviewDownloadThread.Finish;
begin
  if FForm.mmReview = nil then
    Exit; // FForm ������-�� �� ����� nil ����� �����������.
  // ���� ���������� ����������, ������� �������� �� ���

  FForm.mmReview.Lines := FReview;
  FForm.btnLoadReview.Enabled := True;
  FForm.ReviewChanged := True;
  // FForm.RzPageControl1.ActivePageIndex := 1;
end;

// ------------------------------------------------------------------------------

procedure DownloadReview(Form: TfrmBookDetails; URL: string);
var
  Worker: TReviewDownloadThread;
begin
  Worker := TReviewDownloadThread.Create(True);
  Worker.Form := Form;
  Worker.URL := URL;
  Worker.Priority := tpLower;
  Worker.FreeOnTerminate := True;
  Worker.Resume;
end;

end.
