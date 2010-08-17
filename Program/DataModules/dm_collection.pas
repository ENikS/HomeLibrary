(* *****************************************************************************
  *
  * MyHomeLib
  *
  * Copyright (C) 2008-2010 Aleksey Penkov
  *
  * Authors             Aleksey Penkov   alex.penkov@gmail.com
  *                     Nick Rymanov     nrymanov@gmail.com
  * Created             30.06.2010
  * Description         
  *
  * $Id$
  *
  * History
  * NickR 02.03.2010    ��� ����������������
  *
  ****************************************************************************** *)

unit dm_collection;

interface

uses
  Classes,
  ABSMain,
  DB,
  unit_Globals,
  UserData;

type
  TThreeState = (tsTrue, tsFalse, tsUnknown);

  TDMCollection = class(TDataModule)
    DBCollection: TABSDatabase;

    Authors: TABSQuery;
    AuthorsID: TAutoIncField;
    AuthorsFamily: TWideStringField;
    AuthorsName: TWideStringField;
    AuthorsMiddle: TWideStringField;

    dsAuthors: TDataSource;

    AuthorBooks: TABSTable;
    AuthorBooksAuthorID: TIntegerField;
    AuthorBooksBookID: TIntegerField;

    dsAuthorBooks: TDataSource;

    BooksByAuthor: TABSTable;
    BooksByAuthorID: TAutoIncField;

    Series: TABSQuery;
    SeriesSerieID: TAutoIncField;
    SeriesTitle: TWideStringField;

    dsSeries: TDataSource;

    BooksBySerie: TABSTable;
    BooksBySerieID: TAutoIncField;
    BooksBySerieSerieID: TIntegerField;

    Genres: TABSTable;
    GenresGenreCode: TWideStringField;
    GenresParentCode: TWideStringField;
    GenresFB2Code: TWideStringField;
    GenresGenreAlias: TWideStringField;

    dsGenres: TDataSource;

    GenreBooks: TABSTable;
    GenreBooksGenreCode: TWideStringField;
    GenreBooksBookID: TIntegerField;
    dsGenreBooks: TDataSource;

    BooksByGenre: TABSTable;
    BooksByGenreID: TAutoIncField;

    BookAuthors: TABSTable;
    BookAuthorsAuthorID: TIntegerField;
    BookAuthorsBookID: TIntegerField;

    BookGenres: TABSTable;
    BookGenresGenreCode: TWideStringField;
    BookGenresBookID: TIntegerField;

    AllBooks: TABSTable;
    AllBooksBookID: TAutoIncField;
    AllBooksLibID: TIntegerField;
    AllBooksTitle: TWideStringField;
    AllBooksSerieID: TIntegerField;
    AllBooksSeqNumber: TSmallintField;
    AllBooksDate: TDateField;
    AllBooksLibRate: TIntegerField;
    AllBooksLang: TWideStringField;
    AllBooksFolder: TWideStringField;
    AllBooksFileName: TWideStringField;
    AllBooksInsideNo: TIntegerField;
    AllBooksExt: TWideStringField;
    AllBooksSize: TIntegerField;
    AllBooksCode: TSmallintField;
    AllBooksLocal: TBooleanField;
    AllBooksDeleted: TBooleanField;
    AllBooksKeyWords: TWideStringField;

    AllAuthors: TABSTable;
    AllAuthorsAuthorID: TAutoIncField;
    AllAuthorsLastName: TWideStringField;
    AllAuthorsFirstName: TWideStringField;
    AllAuthorsMiddleName: TWideStringField;

    AllSeries: TABSTable;
    AllSeriesSerieID: TAutoIncField;
    AllSeriesSerieTitle: TWideStringField;

    AllExtra: TABSTable;
    AllExtraBookID: TIntegerField;
    AllExtraAnnotation: TWideMemoField;
    AllExtraReview: TWideMemoField;
    AllExtraRate: TIntegerField;
    AllExtraProgress: TIntegerField;

    AllGenres: TABSTable;
    AllGenresGenreCode: TWideStringField;
    AllGenresParentCode: TWideStringField;
    AllGenresFB2Code: TWideStringField;
    AllGenresAlias: TWideStringField;

    sqlBooks: TABSQuery;
    sqlBooksID: TIntegerField;

    tblBooks: TABSTable;
    tblBooksID: TAutoIncField;
    tblBooksSerieID: TIntegerField;
    tblBooksSeqNumber: TSmallintField;
    tblBooksLibID: TIntegerField;
    tblBooksDate: TDateField;
    tblBooksTitle: TWideStringField;
    tblBooksInsideNo: TIntegerField;
    tblBooksFileName: TWideStringField;
    tblBooksExt: TWideStringField;
    tblBooksSize: TIntegerField;
    tblBooksCode: TSmallintField;
    tblBooksFolder: TWideStringField;
    tblBooksLocal: TBooleanField;
    tblBooksDeleted: TBooleanField;
    tblBooksLibRate: TIntegerField;
    tblBooksLang: TWideStringField;
    tblBooksKeyWords: TWideStringField;
    tblBooksSeries: TWideStringField;

    tblSeriesB1: TABSTable;
    tblSeriesB1SerieID: TAutoIncField;
    tblSeriesB1SerieTitle: TWideStringField;

  strict private
    // GetCurrentBook(var R: TBookRecord);
    // SetActiveTable
    FIsFavorites: Boolean;
    FActiveTable: TABSTable;

  private type
    TUpdateExtraProc = reference to procedure;

  public type
    TGUIUpdateExtraProc = reference to procedure(
      BookID: Integer; DatabaseID: Integer;
      extra: TBookExtra
      );

  strict private
    procedure UpdateExtra(BookID: Integer; DatabaseID: Integer; UpdateProc: TUpdateExtraProc);
    procedure ClearExtra(BookID: Integer; DatabaseID: Integer; UpdateProc: TUpdateExtraProc);

    procedure GetAuthor(AuthorID: Integer; var Author: TAuthorData);
    procedure GetBookAuthors(BookID: Integer; var BookAuthors: TBookAuthors);

    function GetBookSerie(SerieID: Integer): string;

    procedure GetGenre(const GenreCode: string; var Genre: TGenreData);
    procedure GetBookGenres(BookID: Integer; var BookGenres: TBookGenres; RootGenre: PGenreData = nil); overload;

  public
    // TfrmMain.FormCreate
    // TfrmMain.pgControlChange
    procedure SetActiveTable(Tag: Integer); deprecated;

    // TDownloader.DoDownload
    procedure GetBookLibID(BookID: Integer; DatabaseID: Integer; out ARes: string); deprecated;

    // TExport2XMLThread.WorkFunction
    // TExport2INPXThread.WorkFunction
    // WriteFb2InfoToFile
    // TfrmConvertToFBD.PrepareForm
    procedure GetCurrentBook(var R: TBookRecord); overload; deprecated;

    procedure SetTableState(State: Boolean);

  public
    //
    // ����� ������, ����������� DatabaseID
    //

    //
    // ��������� ������ ���������� � �����
    //
    procedure GetBookRecord(BookID: Integer; DatabaseID: Integer; var BookRecord: TBookRecord; LoadExtra: Boolean); overload;

    //
    // ���������� �����
    //
    procedure SetLocal(BookID: Integer; DatabaseID: Integer; AState: Boolean);

    //
    // ���������� ����� �� ������� Extra
    //
    procedure SetRate(BookID: Integer; DatabaseID: Integer; Rate: Integer);
    procedure SetProgress(BookID: Integer; DatabaseID: Integer; Progress: Integer);

    //
    // NOTE: ��� ������ ������ �� ������������.
    //
    function GetAnnotation(BookID: Integer; DatabaseID: Integer): string;
    procedure SetAnnotation(BookID: Integer; DatabaseID: Integer; const Annotation: string);

    function GetReview(BookID: Integer; DatabaseID: Integer): string;
    function SetReview(BookID: Integer; DatabaseID: Integer; const Review: string): Integer;

    //
    // ������ � ��������
    //
    procedure AddBookToGroup(BookID: Integer; DatabaseID: Integer; GroupID: Integer);

    //
    // ���������� �� ������� ���������
    //
    procedure GetStatistics(out AuthorsCount: Integer; out BooksCount: Integer; out SeriesCount: Integer);

    //
    // ��������� �������.
    //
    procedure SetAuthorFilter(const Value: string);
    procedure SetSerieFilter(const Value: string);
    procedure SetStateFilter(LocalState: TThreeState; HideDeletedState: TThreeState);

    //
    // ���������������� ������
    //
    procedure ExportUserData(data: TUserData);
    procedure ImportUserData(data: TUserData; guiUpdateCallback: TGUIUpdateExtraProc);
  end;

var
  DMCollection: TDMCollection;

implementation

uses
  Windows,
  Forms,
  SysUtils,
  StrUtils,
  IOUtils,
  Variants,
  dm_user,
  unit_Consts,
  unit_Messages,
  unit_Helpers;

{$R *.dfm}

{ TDMMain }

procedure TDMCollection.GetBookLibID(BookID: Integer; DatabaseID: Integer; out ARes: String);
begin
  if DatabaseID = DMUser.ActiveCollection.ID then
  begin
    Assert(AllBooks.Active);

    if not AllBooks.Locate(BOOK_ID_FIELD, BookID, []) then
    begin
      Assert(False);
      Exit;
    end;

    ARes := AllBooksLibID.AsString;
  end
  else
    DMUser.GetBookLibID(BookID, DatabaseID, ARes);
end;

procedure TDMCollection.GetStatistics(out AuthorsCount: Integer; out BooksCount: Integer; out SeriesCount: Integer);
var
  FilterStateA: Boolean;
  FilterStringA: string;

  BM1: TBookMark;
begin
  (* ***************************************************************************
    *
    * ����� ��������������� ������������ 3 ������� �������,
    * �� ���� ������� ��� ����
    *
    *************************************************************************** *)

  BM1 := Authors.GetBookmark;
  try
    FilterStateA := Authors.Filtered;
    FilterStringA := Authors.Filter;
    Authors.Filtered := False;

    AuthorsCount := Authors.RecordCount;
    BooksCount := AllBooks.RecordCount;
    SeriesCount := AllSeries.RecordCount;

    Authors.Filter := FilterStringA;
    Authors.Filtered := FilterStateA;

    Authors.GotoBookmark(BM1);
  finally
    Authors.FreeBookmark(BM1);
  end;
end;

procedure TDMCollection.SetActiveTable(Tag: Integer);
begin
  if Tag = PAGE_FAVORITES then
  begin
    FActiveTable := DMUser.BooksByGroup;
    FIsFavorites := True;
  end
  else
  begin
    FActiveTable := tblBooks;
    FIsFavorites := False;
  end;
end;

procedure TDMCollection.SetTableState(State: Boolean);
begin
  Authors.Active := State;
  AuthorBooks.Active := State;
  BooksByAuthor.Active := State;

  Series.Active := State;
  BooksBySerie.Active := State;

  Genres.Active := State;
  GenreBooks.Active := State;
  BooksByGenre.Active := State;

  BookGenres.Active := State;
  BookAuthors.Active := State;

  tblBooks.Active := State;
  tblSeriesB1.Active := State;

  AllAuthors.Active := State;
  AllSeries.Active := State;
  AllBooks.Active := State;
  AllExtra.Active := State;
  AllGenres.Active := State;
end;

// ============================================================================
//
// ����� ������
//
// ============================================================================

function TDMCollection.GetBookSerie(SerieID: Integer): string;
begin
  if AllSeries.Locate(SERIE_ID_FIELD, SerieID, []) then
    Result := AllSeriesSerieTitle.Value
  else
    Result := '';
end;

procedure TDMCollection.GetGenre(const GenreCode: string; var Genre: TGenreData);
begin
  Assert(AllGenres.Active);
  if AllGenres.Locate(GENRE_CODE_FIELD, GenreCode, []) then
  begin
    Genre.GenreCode := GenreCode;
    Genre.ParentCode := AllGenresParentCode.Value;
    Genre.FB2GenreCode := AllGenresFB2Code.Value;
    Genre.GenreAlias := AllGenresAlias.Value;
  end
  else
    Genre.Clear;
end;

procedure TDMCollection.GetAuthor(AuthorID: Integer; var Author: TAuthorData);
begin
  Assert(AllAuthors.Active);
  if AllAuthors.Locate(AUTHOR_ID_FIELD, AuthorID, []) then
  begin
    Author.AuthorID := AuthorID;
    Author.LastName := AllAuthorsLastName.Value;
    Author.FirstName := AllAuthorsFirstName.Value;
    Author.MiddleName := AllAuthorsMiddleName.Value;
  end
  else
    Author.Clear;
end;

procedure TDMCollection.GetBookAuthors(BookID: Integer; var BookAuthors: TBookAuthors);
var
  i: Integer;
begin
  Assert(Self.BookAuthors.Active);
  Self.BookAuthors.SetRange([BookID], [BookID]);
  try
    i := Length(BookAuthors);
    Self.BookAuthors.First;
    while not Self.BookAuthors.Eof do
    begin
      SetLength(BookAuthors, i + 1);
      GetAuthor(Self.BookAuthorsAuthorID.Value, BookAuthors[i]);

      Inc(i);
      Self.BookAuthors.Next;
    end;
  finally
    Self.BookAuthors.CancelRange;
  end;
end;

procedure TDMCollection.GetBookGenres(BookID: Integer; var BookGenres: TBookGenres; RootGenre: PGenreData = nil);
var
  i: Integer;
begin
  Assert(Self.BookGenres.Active);

  Self.BookGenres.SetRange([BookID], [BookID]);
  try
    i := Length(BookGenres);
    Self.BookGenres.First;

    while not Self.BookGenres.Eof do
    begin
      SetLength(BookGenres, i + 1);
      GetGenre(BookGenresGenreCode.Value, BookGenres[i]);

      Inc(i);
      Self.BookGenres.Next;
    end;

    if Assigned(RootGenre) then
    begin
      if Length(BookGenres) > 0 then
        GetGenre(BookGenres[0].ParentCode, RootGenre^)
      else
        RootGenre^.Clear;
    end;
  finally
    Self.BookGenres.CancelRange;
  end;
end;

procedure TDMCollection.GetCurrentBook(var R: TBookRecord);
var
  BookID: Integer;
  DatabaseID: Integer;
begin
  BookID := FActiveTable.FieldByName(BOOK_ID_FIELD).Value;
  if FActiveTable = tblBooks then
    DatabaseID := DMUser.ActiveCollection.ID
  else
    DatabaseID := FActiveTable.FieldByName(DB_ID_FIELD).AsInteger;

  GetBookRecord(BookID, DatabaseID, R, True);
end;

procedure TDMCollection.GetBookRecord(BookID: Integer; DatabaseID: Integer; var BookRecord: TBookRecord; LoadExtra: Boolean);
begin
  BookRecord.Clear;

  if DatabaseID = DMUser.ActiveCollection.ID then
  begin
    Assert(AllBooks.Active);

    if not AllBooks.Locate(BOOK_ID_FIELD, BookID, []) then
    begin
      Assert(False);
      Exit;
    end;

    BookRecord.Title := AllBooksTitle.Value;
    BookRecord.Folder := AllBooksFolder.Value;
    BookRecord.FileName := AllBooksFileName.Value;
    BookRecord.FileExt := AllBooksExt.Value;
    BookRecord.InsideNo := AllBooksInsideNo.Value;
    BookRecord.SerieID := AllBooksSerieID.Value;
    BookRecord.Serie := GetBookSerie(AllBooksSerieID.Value);
    BookRecord.SeqNumber := AllBooksSeqNumber.Value;
    BookRecord.Code := AllBooksCode.Value;
    BookRecord.Size := AllBooksSize.Value;
    BookRecord.LibID := AllBooksLibID.Value;
    BookRecord.Deleted := AllBooksDeleted.Value;
    BookRecord.Local := AllBooksLocal.Value;
    BookRecord.Date := AllBooksDate.Value;
    BookRecord.Lang := AllBooksLang.Value;
    BookRecord.LibRate := AllBooksLibRate.Value;
    BookRecord.KeyWords := AllBooksKeyWords.Value;

    //
    // ������ �� ������� Extra
    //
    Assert(AllExtra.Active);
    if LoadExtra and AllExtra.Locate(BOOK_ID_FIELD, BookID, []) then
    begin
      //
      // ��� ���� ����� ���������� ������ ��� ����������� ����� � ������ ���������.
      // �� ���� ��������� ������� ��� �� ������������.
      //
      BookRecord.Review := AllExtraReview.Value;
      BookRecord.Annotation := AllExtraAnnotation.Value;
      BookRecord.Rate := AllExtraRate.Value;
      BookRecord.Progress := AllExtraProgress.Value;
    end;

    GetBookGenres(BookID, BookRecord.Genres, @(BookRecord.RootGenre));
    GetBookAuthors(BookID, BookRecord.Authors);

    BookRecord.CollectionName := DMUser.ActiveCollection.Name;
  end
  else
    DMUser.GetBookRecord(BookID, DatabaseID, BookRecord);
end;

procedure TDMCollection.SetLocal(BookID: Integer; DatabaseID: Integer; AState: Boolean);
begin
  Assert(DatabaseID = DMUser.ActiveCollection.ID);

  if AllBooks.Locate(BOOK_ID_FIELD, BookID, []) then
  begin
    AllBooks.Edit;
    AllBooksLocal.Value := AState;
    AllBooks.Post;
  end;

  DMUser.SetLocal(BookID, DatabaseID, AState);
end;

procedure TDMCollection.UpdateExtra(BookID, DatabaseID: Integer; UpdateProc: TUpdateExtraProc);
begin
  Assert(DatabaseID = DMUser.ActiveCollection.ID);
  Assert(AllExtra.Active);

  if AllExtra.Locate(BOOK_ID_FIELD, BookID, []) then
    AllExtra.Edit
  else
  begin
    AllExtra.Append;
    AllExtraBookID.Value := BookID;
  end;

  UpdateProc;

  AllExtra.Post;
end;

procedure TDMCollection.ClearExtra(BookID: Integer; DatabaseID: Integer; UpdateProc: TUpdateExtraProc);
begin
  Assert(DatabaseID = DMUser.ActiveCollection.ID);
  Assert(AllExtra.Active);

  if AllExtra.Locate(BOOK_ID_FIELD, BookID, []) then
  begin
    AllExtra.Edit;
    UpdateProc;
    AllExtra.Post;

    //
    // ��� �������� ���� ������� ����� - ������ ������
    //
    if AllExtraAnnotation.IsNull and AllExtraReview.IsNull and AllExtraRate.IsNull and AllExtraProgress.IsNull then
      AllExtra.Delete;
  end;
end;

procedure TDMCollection.SetRate(BookID, DatabaseID, Rate: Integer);
begin
  Assert(DatabaseID = DMUser.ActiveCollection.ID);

  if Rate = 0 then
    ClearExtra(
      BookID, DatabaseID,
      procedure
      begin
        AllExtraRate.Clear;
      end
    )
  else
    UpdateExtra(
      BookID, DatabaseID,
      procedure
      begin
        AllExtraRate.Value := Rate;
      end
    );

  //
  // ������� ���������� � �������
  //
  DMUser.SetRate(BookID, DatabaseID, Rate);
end;

procedure TDMCollection.SetProgress(BookID, DatabaseID, Progress: Integer);
begin
  Assert(DatabaseID = DMUser.ActiveCollection.ID);

  if Progress = 0 then
    ClearExtra(
      BookID, DatabaseID,
      procedure
      begin
        AllExtraProgress.Clear;
      end
    )
  else
    UpdateExtra(
      BookID, DatabaseID,
      procedure
      begin
        AllExtraProgress.Value := Progress;
      end
    );

  //
  // ������� ���������� � �������
  //
  DMUser.SetProgress(BookID, DatabaseID, Progress);
end;

function TDMCollection.GetAnnotation(BookID: Integer; DatabaseID: Integer): string;
begin
  Assert(AllExtra.Active);

  if DatabaseID = DMUser.ActiveCollection.ID then
  begin
    if AllExtra.Locate(BOOK_ID_FIELD, BookID, []) then
    begin
      Result := AllExtraAnnotation.Value;
    end;
  end
  else
    Result := DMUser.GetAnnotation(BookID, DatabaseID);
end;

procedure TDMCollection.SetAnnotation(BookID: Integer; DatabaseID: Integer; const Annotation: string);
var
  NewAnnotation: string;
begin
  Assert(DatabaseID = DMUser.ActiveCollection.ID);

  NewAnnotation := Trim(Annotation);

  if AllBooks.Locate(BOOK_ID_FIELD, BookID, []) then
  begin
    AllBooks.Edit;

    if NewAnnotation = '' then
    begin
      ClearExtra(
        BookID, DatabaseID,
        procedure
        begin
          AllExtraAnnotation.Clear;
        end
      );
    end
    else
    begin
      UpdateExtra(
        BookID, DatabaseID,
        procedure
        begin
          AllExtraAnnotation.Value := NewAnnotation;
        end
      );
    end;

    AllBooks.Post;

    //
    // ������� ���������� � �������
    //
    DMUser.SetAnnotation(BookID, DatabaseID, NewAnnotation);
  end;
end;

function TDMCollection.GetReview(BookID: Integer; DatabaseID: Integer): string;
begin
  Assert(AllExtra.Active);

  if DatabaseID = DMUser.ActiveCollection.ID then
  begin
    if AllExtra.Locate(BOOK_ID_FIELD, BookID, []) then
    begin
      Result := AllExtraReview.Value;
    end;
  end
  else
    Result := DMUser.GetReview(BookID, DatabaseID);
end;

function TDMCollection.SetReview(BookID: Integer; DatabaseID: Integer; const Review: string): Integer;
var
  NewReview: string;
begin
  Assert(DatabaseID = DMUser.ActiveCollection.ID);

  Result := 0;
  NewReview := Trim(Review);

  if AllBooks.Locate(BOOK_ID_FIELD, BookID, []) then
  begin
    AllBooks.Edit;

    if NewReview = '' then
    begin
      ClearExtra(
        BookID, DatabaseID,
        procedure
        begin
          AllExtraReview.Clear;
        end
      );
      AllBooksCode.Value := 0;
    end
    else
    begin
      UpdateExtra(
        BookID, DatabaseID,
        procedure
        begin
          AllExtraReview.Value := NewReview;
        end
      );
      AllBooksCode.Value := 1;
      Result := 1;
    end;

    AllBooks.Post;

    //
    // ������� ���������� � �������
    //
    Result := Result or DMUser.SetReview(BookID, DatabaseID, NewReview);
  end;
end;

procedure TDMCollection.AddBookToGroup(BookID: Integer; DatabaseID: Integer; GroupID: Integer);
var
  BookRecord: TBookRecord;
begin
  Assert(DatabaseID = DMUser.ActiveCollection.ID);
  Assert(AllBooks.Active);
  Assert(AllExtra.Active);

  GetBookRecord(BookID, DatabaseID, BookRecord, True);

  DMUser.AddBookToGroup(BookID, DatabaseID, GroupID, BookRecord);
end;

procedure TDMCollection.SetAuthorFilter(const Value: string);
begin
  if Value = '' then
  begin
    Authors.Filter := '';
    Authors.Filtered := False;
  end
  else
  begin
    Authors.Filter := Format('%s = "%s"', [AUTHOR_LASTTNAME_FIELD, Value]);
    Authors.Filtered := True;
  end;
end;

procedure TDMCollection.SetSerieFilter(const Value: string);
begin
  if Value = '' then
  begin
    Series.Filter := '';
    Series.Filtered := False;
  end
  else
  begin
    Series.Filter := Format('%s = "%s"', [SERIE_TITLE_FIELD, Value]);
    Series.Filtered := True;
  end;
end;

procedure TDMCollection.SetStateFilter(LocalState: TThreeState; HideDeletedState: TThreeState);
const
  GetAuthorsBegin = 'SELECT a.AuthorID, a.LastName, a.FirstName, a.MiddleName FROM Authors a ';
  GetAuthorsQuery = 'WHERE (a.AuthorID IN (SELECT DISTINCT l.AuthorID FROM Author_List l INNER JOIN Books b ON l.BookID = b.BookID WHERE %s)) ';
  GetAuthorsEnd = 'ORDER BY a.LastName, a.FirstName, a.MiddleName ';

  GetSeriessBegin = 'SELECT s.SerieID, s.SerieTitle FROM Series s ';
  GetSeriessQuery = 'WHERE (s.SerieID <> 1) AND (s.SerieID IN (SELECT DISTINCT b.SerieID FROM Books b WHERE %s)) ';
  GetSeriessEnd = 'ORDER BY s.SerieTitle';

  // tsTrue, tsFalse, tsUnknown
  LocalFilters: array [TThreeState] of string = ('(`Local` = true)', '(`Local` = false)', '');
  HideDeletedFilters: array [TThreeState] of string = ('(`Deleted` = false)', '(`Deleted` = true)', '');

var
  SQLQuery: string;
  LocalFilter: string;
  HideDeletedFilter: string;
  TotalFilter: string;
  SetFilter: Boolean;
begin
  Assert(not Authors.Active);
  Assert(not Series.Active);

  LocalFilter := LocalFilters[LocalState];
  HideDeletedFilter := HideDeletedFilters[HideDeletedState];

  SetFilter := True;
  if (LocalFilter <> '') and (HideDeletedFilter <> '') then
    TotalFilter := LocalFilter + ' AND ' + HideDeletedFilter
  else if (LocalFilter <> '') then
    TotalFilter := LocalFilter
  else if (HideDeletedFilter <> '') then
    TotalFilter := HideDeletedFilter
  else
  begin
    TotalFilter := '';
    SetFilter := False;
  end;

  SQLQuery := GetAuthorsBegin;
  if SetFilter then
    SQLQuery := SQLQuery + Format(GetAuthorsQuery, [TotalFilter]);
  SQLQuery := SQLQuery + GetAuthorsEnd;
  Authors.SQL.Text := SQLQuery;

  SQLQuery := GetSeriessBegin;
  if SetFilter then
    SQLQuery := SQLQuery + Format(GetSeriessQuery, [TotalFilter]);
  SQLQuery := SQLQuery + GetSeriessEnd;
  Series.SQL.Text := SQLQuery;

  if SetFilter then
  begin
    BooksByAuthor.Filter := TotalFilter;
    BooksByGenre.Filter := TotalFilter;
    BooksBySerie.Filter := TotalFilter;
    DMUser.BooksByGroup.Filter := TotalFilter;
  end;

  BooksByAuthor.Filtered := SetFilter;
  BooksByGenre.Filtered := SetFilter;
  BooksBySerie.Filtered := SetFilter;
  DMUser.BooksByGroup.Filtered := SetFilter;
end;

procedure TDMCollection.ExportUserData(data: TUserData);
begin
  Assert(Assigned(data));
  Assert(AllBooks.Active);
  Assert(AllExtra.Active);

  AllExtra.First;
  while not AllExtra.Eof do
  begin
    if AllBooks.Locate(BOOK_ID_FIELD, AllExtraBookID.Value, []) then
    begin
      if
        (AllExtraRate.Value <> 0) or
        (AllExtraProgress.Value <> 0) or
        (AllExtraReview.Value <> '')
      then
        data.Extras.AddExtra(
          AllExtraBookID.Value,
          AllBooksLibID.Value,
          AllExtraRate.Value,
          AllExtraProgress.Value,
          AllExtraReview.Value
        );
    end;
    AllExtra.Next;
  end;

  DMUser.ExportUserData(data);
end;

procedure TDMCollection.ImportUserData(
  data: TUserData;
  guiUpdateCallback: TGUIUpdateExtraProc
  );
var
  extra: TBookExtra;
  group: TBookGroup;
  groupBook: TGroupBook;

  DatabaseID: Integer;
  BookID: Integer;

  function GetBookID(bookInfo: TBookInfo; out BookID: Integer): Boolean;
  begin
    if bookInfo.LibID = 0 then
      Result := AllBooks.Locate(BOOK_ID_FIELD, bookInfo.BookID, [])
    else
      Result := AllBooks.Locate(BOOK_LIBID_FIELD, bookInfo.LibID, []);

    if Result then
      BookID := AllBooksBookID.Value;
  end;

begin
  Assert(Assigned(data));
  Assert(Assigned(guiUpdateCallback));
  Assert(AllBooks.Active);
  Assert(AllExtra.Active);

  DatabaseID := DMUser.ActiveCollection.ID;

  //
  // �������� ��������, ��������� � ������� �������������
  //
  for extra in data.Extras do
  begin
    if GetBookID(extra, BookID) then
    begin
      UpdateExtra(
        BookID, DatabaseID,
        procedure
        begin
          if extra.Rating <> 0 then
            AllExtraRate.Value := extra.Rating;
          if extra.Progress <> 0 then
            AllExtraProgress.Value := extra.Progress;
          if extra.Review <> '' then
            AllExtraReview.Value := extra.Review;
        end
      );

      //
      // ������� ���������� � �������
      //
      DMUser.SetExtra(BookID, DatabaseID, extra);

      //
      // ����� ����������� �������� ���� �������� ���������� ����
      //
      guiUpdateCallback(BookID, DatabaseID, extra);
    end;
  end;

  //
  // �������� ���������������� ������
  //
  DMUser.ImportUserData(data);

  //
  // ������� ����� � ������
  //
  for group in data.Groups do
  begin
    for groupBook in group do
    begin
      if GetBookID(groupBook, BookID) then
      begin
        AddBookToGroup(BookID, DatabaseID, group.GroupID);
      end;
    end;
  end;
end;

end.
