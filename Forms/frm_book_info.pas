(* *****************************************************************************
  *
  * MyHomeLib
  *
  * Copyright (C) 2008-2010 Aleksey Penkov
  *
  * Authors Aleksey Penkov   alex.penkov@gmail.com
  *         Nick Rymanov     nrymanov@gmail.com
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
  unit_Globals;

type
  TfrmBookDetails = class(TForm)
    RzPageControl1: TPageControl;
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
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mmReviewChange(Sender: TObject);
    procedure btnLoadReviewClick(Sender: TObject);
    procedure btnClearReviewClick(Sender: TObject);

  private
    FUrl: string;

    FReviewChanged: Boolean;
    //FBookRecord: TBookRecord;
    function GetReview: string;
    procedure SetReview(const Value: string);
    //procedure SetBookRecord(const Value: TBookRecord);

  public
    procedure AllowOnlineReview(URL: string);
    procedure Download;

    procedure FillBookInfo(bookInfo: TBookRecord; bookStream: TMemoryStream);

    property Review: string read GetReview write SetReview;
    property ReviewChanged: Boolean read FReviewChanged write FReviewChanged;
    property URL: string read FUrl write FUrl;
    //property Book: TBookRecord read FBookRecord write SetBookRecord;
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
  lvInfo.ShowColumnHeaders := False;
  FReviewChanged := False;
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

//procedure TfrmBookDetails.SetBookRecord(const Value: TBookRecord);
//begin
//  FBookRecord := Value;
//  lblTitle.Caption := FBookRecord.Title;
  { TODO -oNickR -cUsability : ����� ����� ���������� ���� �������? � ����������� ��� ������ ����� ������� ���������� }
//  lblAuthors.Caption := FBookRecord.Authors[0].GetFullName;
//end;

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

  procedure AddItem(const Field: string; const Value: string; GroupID: integer = -1);
  var
    item: TListItem;
  begin
    item := lvInfo.Items.Add;
    item.Caption := Field;
    item.SubItems.Add(Value);
    item.GroupID := GroupID;
  end;

begin
  //
  // ������� ���������� �� TBookRecord
  //
  lblTitle.Caption := bookInfo.Title;
  lblAuthors.Caption := bookInfo.Authors[0].GetFullName;

  with lvInfo.Groups.Add do
  begin
    Header := '���������� � �����';
    AddItem('�����', bookInfo.Folder, GroupID);
    AddItem('����', bookInfo.FileName, GroupID);
    AddItem('������', GetFormattedSize(bookInfo.Size, True), GroupID);
    AddItem('��������', DateToStr(bookInfo.Date), GroupID);
  end;
  { TODO -oNickR -cUsability : ��� ������ ��������� ���������� ���������� ��������� ���� }
  // libID: Integer;    ???
  // LibRate: Integer;  ???
  // URI: string;       ???

  //
  // ������� ���������� �� �����
  //
  if not Assigned(bookStream) or (bookStream.Size = 0) then
  begin
    imgCover.Visible := False;
    mmShort.Visible := False;
    Exit;
  end;

  //FS.SaveToFile('C:\temp\book.xml');
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

    with book.Description.Titleinfo do
    begin
      // ---------------------------------------------
      with lvInfo.Groups.Add do
      begin
        Header := '����� ����������';

        { TODO -oNickR -cUsability : ����� ����� ���������� ���� �������? � ����������� ��� ������ ����� ������� ���������� }
        //if Author.Count > 0 then
        //  lblAuthors.Caption := Author[0].Lastname.Text + ' ' + Author[0].Firstname.Text + ' ' + Author[0].MiddleName.Text;

        { TODO -oNickR -cUsability : ���������� ��� ����� + ����� � ����� }
        if Sequence.Count > 0 then
          AddItem('�����', Sequence[0].Name, GroupID);

        { TODO -oNickR -cUsability : ���������� ��� ����� + ������ ������ ���������� ���� }
        if Genre.Count > 0 then
          AddItem('����', Genre[0], GroupID);
      end;

      // ---------------------------------------------
      with lvInfo.Groups.Add, book.Description.Publishinfo do
      begin
        Header := '������������ ����������';
        AddItem('������������', Publisher.Text, GroupID);
        AddItem('�����', City.Text, GroupID);
        AddItem('���', Year, GroupID);
        AddItem('ISBN', Isbn.Text, GroupID);
      end;

      // ---------------------------------------------
      with lvInfo.Groups.Add, book.Description.Documentinfo do
      begin
        Header := '���������� � ��������� (OCR)';
        for i := 0 to Author.Count - 1 do
        begin
          { TODO -oNickR -cUsability : ����� ����� ����������� ��� ������ ����� ������� ���������� }
          tmpStr := Author[i].Firstname.Text + ' ' + Author[i].Lastname.Text + '(' + Author[i].NickName.Text + ')';
          AddItem(IfThen(i = 0, '������'), tmpStr, GroupID);
        end;

        AddItem('���������', Programused.Text, GroupID);
        AddItem('����', Date.Text, GroupID);
        AddItem('ID', Id, GroupID);
        AddItem('������', Version, GroupID);

        for i := 0 to History.p.Count - 1 do
          AddItem(IfThen(i = 0, '�������'), History.p[i].OnlyText, GroupID);
      end;

      // ---------------------------------------------
      { TODO -oNickR -cUsability : ����� ����� ��������� ��������� ��� ����? }
      for i := 0 to Annotation.p.Count - 1 do
        mmShort.Lines.Add(Annotation.p[i].OnlyText);
    end;
  except
    //
    Assert(False);
  end;
end;

{-------------------- TReviewDownloadThread ----------------------------------- }

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
  //FForm.RzPageControl1.ActivePageIndex := 1;
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
