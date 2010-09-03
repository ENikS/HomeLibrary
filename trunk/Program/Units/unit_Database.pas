(* *****************************************************************************
  *
  * MyHomeLib
  *
  * Copyright (C) 2008-2010 Aleksey Penkov
  *
  * Author(s)           Aleksey Penkov  alex.penkov@gmail.com
  *                     Nick Rymanov (nrymanov@gmail.com)
  * Created             12.02.2010
  * Description
  *
  * $Id$
  *
  * History
  * NickR 15.02.2010    ��� ����������������
  *
  ****************************************************************************** *)

unit unit_Database;

interface

uses
  Classes,
  Generics.Collections,
  ABSMain,
  DB,
  UserData,
  unit_Globals,
  unit_Interfaces;

type
  //
  // ��������������� ������ ��� ���������� ������ � ���������� ������.
  //
  TABSQueryEx = class(TABSQuery)
  public
    constructor Create(ADatabase: TABSDatabase; const AQueryText: string);
  end;

  TABSTableEx = class(TABSTable)
  public
    constructor Create(ADatabase: TABSDatabase; const ATableName: string);
  end;

  TBookCollection = class
  strict private
  type
    //-------------------------------------------------------------------------
    TBookIteratorImpl = class(TInterfacedObject, IBookIterator)
    public
      constructor Create(
        Collection: TBookCollection;
        const Mode: TBookIteratorMode;
        const LoadMemos: Boolean;
        const Filter: string;
        const SearchCriteria: TBookSearchCriteria
      );
      destructor Destroy; override;

    protected
      // IBookIterator
      function Next(out BookRecord: TBookRecord): Boolean;
      function GetNumRecords: Integer;

    strict private
      FCollection: TBookCollection;
      FBooks: TABSQuery;
      FBookID: TIntegerField;

      FCollectionID: Integer; // Active collection's ID at the time the iterator was created
      FLoadMemos: Boolean;

      function CreateSQL(const Mode: TBookIteratorMode; const Filter: string; const SearchCriteria: TBookSearchCriteria): string;
      function CreateSearchSQL(const SearchCriteria: TBookSearchCriteria): string;
    end;
    // << TBookIteratorImpl

    //-------------------------------------------------------------------------
    TAuthorIteratorImpl = class(TInterfacedObject, IAuthorIterator)
    public
      constructor Create(
        Collection: TBookCollection;
        const Mode: TAuthorIteratorMode;
        const Filter: string
      );
      destructor Destroy; override;

    protected
      // IAuthorIterator
      function Next(out AuthorData: TAuthorData): Boolean;
      function GetNumRecords: Integer;

    strict private
      FCollection: TBookCollection;
      FAuthors: TABSQuery;
      FAuthorID: TIntegerField;
      FCollectionID: Integer; // Active collection's ID at the time the iterator was created

      function CreateSQL(const Mode: TAuthorIteratorMode; const Filter: string): string;
    end;
    // << TAuthorIteratorImpl

    //-------------------------------------------------------------------------
    TGenreIteratorImpl = class(TInterfacedObject, IGenreIterator)
    public
      constructor Create(Collection: TBookCollection; const Mode: TGenreIteratorMode; const Filter: string);
      destructor Destroy; override;

    protected
      // IGenreIterator
      function Next(out GenreData: TGenreData): Boolean;
      function GetNumRecords: Integer;

    strict private
      FCollection: TBookCollection;
      FGenres: TABSQuery;
      FGenreCode: TWideStringField;
      FCollectionID: Integer; // Active collection's ID at the time the iterator was created

      function CreateSQL(const Mode: TGenreIteratorMode; const Filter: string): string;
    end;
    // << TGenreIteratorImpl

    //-------------------------------------------------------------------------
    TSeriesIteratorImpl = class(TInterfacedObject, ISeriesIterator)
    public
      constructor Create(Collection: TBookCollection; const Mode: TSeriesIteratorMode; const Filter: string);
      destructor Destroy; override;

    protected
      //
      // ISeriesIterator
      //
      function Next(out SeriesData: TSeriesData): Boolean;
      function GetNumRecords: Integer;

    strict private
      FCollection: TBookCollection;
      FSeries: TABSQuery;
      FSeriesID: TIntegerField;
      FSeriesTitle: TWideStringField;
      FCollectionID: Integer; // Active collection's ID at the time the iterator was created

      function CreateSQL(const Mode: TSeriesIteratorMode; const Filter: string): string;
    end;
    // << TSeriesIteratorImpl

  public type
    TGUIUpdateExtraProc = reference to procedure(
      const BookKey: TBookKey;
      extra: TBookExtra
    );

  private
    procedure LoadGenres(const GenresFileName: string);

  protected
    constructor Create(const DBCollectionFile: string; ADefaultSession: Boolean = True);

  public
    destructor Destroy; override;

    procedure ReloadDefaultGenres(const FileName: string);

    procedure SetProperty(PropID: Integer; const Value: string); overload;
    procedure SetProperty(PropID: Integer; const Value: Integer); overload;

    //
    // Content management
    //
    function CheckFileInCollection(const FileName: string; const FullNameSearch: Boolean; const ZipFolder: Boolean): Boolean;

    function InsertBook(BookRecord: TBookRecord; CheckFileName, FullCheck: Boolean): Integer;
    procedure DeleteBook(const BookKey: TBookKey);
    procedure GetBookRecord(const BookKey: TBookKey; var BookRecord: TBookRecord; LoadMemos: Boolean);

    function GetTopGenreAlias(const FB2Code: string): string;
    procedure CleanBookGenres(BookID: Integer);
    procedure InsertBookGenres(const BookID: Integer; var Genres: TBookGenres);

    procedure GetSeries(SeriesList: TStrings);

    //
    // Bulk operation
    //
    procedure BeginBulkOperation;
    procedure EndBulkOperation(Commit: Boolean = True);

    // Iterators:
    function GetBookIterator(const Mode: TBookIteratorMode; const LoadMemos: Boolean; const Filter: string = ''): IBookIterator; overload;
    function GetBookIterator(const LoadMemos: Boolean; const SearchCriteria: TBookSearchCriteria): IBookIterator; overload;
    function GetAuthorIterator(const Mode: TAuthorIteratorMode; const Filter: string = ''): IAuthorIterator;
    function GetGenreIterator(const Mode: TGenreIteratorMode; const Filter: string = ''): IGenreIterator;
    function GetSeriesIterator(const Mode: TSeriesIteratorMode; const Filter: string = ''): ISeriesIterator;

    procedure VerifyCurrentCollection(const DatabaseID: Integer);
    procedure SetSeriesTitle(const SeriesID: Integer; const NewSeriesTitle: string);
    function AddOrLocateSeriesIDBySeriesTitle(const SeriesTitle: string): Integer;
    procedure ChangeBookSeriesID(const OldSeriesID: Integer; const NewSeriesID: Integer; const DatabaseID: Integer);
    procedure AddBookToGroup(const BookKey: TBookKey; GroupID: Integer);
    procedure ImportUserData(data: TUserData; guiUpdateCallback: TGUIUpdateExtraProc);
    procedure ExportUserData(data: TUserData);
    procedure GetStatistics(out AuthorsCount: Integer; out BooksCount: Integer; out SeriesCount: Integer);
    procedure UpdateBook(const BookRecord: TBookRecord);
    function SetReview(const BookKey: TBookKey; const Review: string): Integer;
    function GetReview(const BookKey: TBookKey): string;
    procedure SetProgress(const BookKey: TBookKey; Progress: Integer);
    procedure SetRate(const BookKey: TBookKey; Rate: Integer);
    procedure SetBookSeriesID(const BookKey: TBookKey; const SeriesID: Integer);
    procedure SetFolder(const BookKey: TBookKey; const Folder: string);
    procedure SetFileName(const BookKey: TBookKey; const FileName: string);
    procedure SetLocal(const BookKey: TBookKey; AState: Boolean);
    procedure GetBookLibID(const BookKey: TBookKey; out ARes: string); deprecated;
    procedure TruncateTablesBeforeImport;
    procedure MountTables(const Mounted: Boolean);

    procedure CompactDatabase;
    procedure RepairDatabase;

  private
    FDefaultSession: Boolean;
    FSession: TABSSession;
    FDatabase: TABSDatabase;

    FSettings: TABSTable;
    FSettingsID: TIntegerField;
    FSettingsValue: TWideMemoField;

    FAuthors: TABSTable;
    FAuthorsID: TIntegerField;
    FAuthorsLastName: TWideStringField;
    FAuthorsFirstName: TWideStringField;
    FAuthorsMiddleName: TWideStringField;

    FAuthorList: TABSTable;
    FAuthorListAuthorID: TIntegerField;
    FAuthorListBookID: TIntegerField;

    FBooks: TABSTable;
    FBooksBookID: TIntegerField;
    FBooksLibID: TIntegerField;
    FBooksTitle: TWideStringField;
    FBooksSeriesID: TIntegerField;
    FBooksSeqNumber: TSmallintField;
    FBooksDate: TDateField;
    FBooksLibRate: TIntegerField;
    FBooksLang: TWideStringField;
    FBooksFolder: TWideStringField;
    FBooksFileName: TWideStringField;
    FBooksInsideNo: TIntegerField;
    FBooksExt: TWideStringField;
    FBooksSize: TIntegerField;
    FBooksCode: TSmallintField;
    FBooksIsLocal: TBooleanField;
    FBooksIsDeleted: TBooleanField;
    FBooksKeyWords: TWideStringField;
    FBooksRate: TIntegerField;
    FBooksProgress: TIntegerField;
    FBooksAnnotation: TWideMemoField;
    FBooksReview: TWideMemoField;

    FSeries: TABSTable;
    FSeriesSeriesID: TIntegerField;
    FSeriesSeriesTitle: TWideStringField;

    FGenres: TABSTable;
    FGenresGenreCode: TWideStringField;
    FGenresParentCode: TWideStringField;
    FGenresFB2Code: TWideStringField;
    FGenresAlias: TWideStringField;

    FGenreList: TABSTable;
    FGenreListGenreCode: TWideStringField;
    FGenreListBookID: TIntegerField;

  strict private
    FAuthorFilterType: string;
    FSeriesFilterType: string;
    FShowLocalOnly: Boolean;
    FHideDeleted: Boolean;

    procedure FilterDuplicateAuthorsByID(var Authors: TBookAuthors);
    procedure FilterDuplicateGenresByCode(var Genres: TBookGenres);

    procedure GetBookGenres(BookID: Integer; var BookGenres: TBookGenres; RootGenre: PGenreData = nil);
    procedure GetBookAuthors(BookID: Integer; var BookAuthors: TBookAuthors);
    procedure GetGenre(const GenreCode: string; var Genre: TGenreData);
    procedure GetAuthor(AuthorID: Integer; var Author: TAuthorData);
    function GetSeriesTitle(SeriesID: Integer): string;

  public
    property HideDeleted: Boolean read FHideDeleted write FHideDeleted;
    property ShowLocalOnly: Boolean read FShowLocalOnly write FShowLocalOnly;
    property SeriesFilterType: string read FSeriesFilterType write FSeriesFilterType;
    property AuthorFilterType: string read FAuthorFilterType write FAuthorFilterType;
  end;

  function CreateBookCollection(const DBCollectionFile: string; ADefaultSession: Boolean = True): TBookCollection;
  function GetBookCollection(const DBCollectionFile: string): TBookCollection;
  function GetActiveBookCollection: TBookCollection;
  procedure FreeBookCollectionMap;

  procedure CreateSystemTables(const DBUserFile: string);
  procedure CreateCollectionTables(const DBCollectionFile: string; const GenresFileName: string);
  procedure DropCollectionDatabase(const DBCollectionFile: string);

implementation

uses
  Variants,
  Types,
  SysUtils,
  IOUtils,
  DateUtils,
  Character,
  bdeconst,
  unit_Consts,
  unit_Logger,
  unit_SearchUtils,
  unit_Errors,
  dm_user;

resourcestring
  rstrFavoritesGroupName = '���������';
  rstrToReadGroupName = '� ���������';

const
  COLLECTION_DATABASE = 'CollectionDB';
  USER_DATABASE = 'UserDB';
  DATABASE_VERSION = '1000';

type
  TBookCollectionMap = TObjectDictionary<string, TBookCollection>;

var
  BookCollectionMap: TBookCollectionMap;

// ------------------------------------------------------------------------------

procedure FreeBookCollectionMap;
begin
  FreeAndNil(BookCollectionMap);
end;

function GetBookCollection(const DBCollectionFile: string): TBookCollection;
begin
  Assert(DBCollectionFile <> '');
  if not Assigned(BookCollectionMap) then
    BookCollectionMap := TBookCollectionMap.Create([doOwnsValues]);

  if not BookCollectionMap.TryGetValue(DBCollectionFile, Result) then
  begin
    Result := CreateBookCollection(DBCollectionFile);
    BookCollectionMap.Add(DBCollectionFile, Result);
  end;
end;

function CreateBookCollection(const DBCollectionFile: string; ADefaultSession: Boolean = True): TBookCollection;
begin
  Result := TBookCollection.Create(DBCollectionFile, ADefaultSession);
end;

function GetActiveBookCollection: TBookCollection;
begin
  Result := GetBookCollection(DMUser.ActiveCollectionInfo.DBFileName);
end;

procedure DropCollectionDatabase(const DBCollectionFile: string);
begin
  if Assigned(BookCollectionMap) then
  begin
    if BookCollectionMap.ContainsKey(DBCollectionFile) then
      BookCollectionMap.Remove(DBCollectionFile);
  end;
  DeleteFile(DBCollectionFile);
end;

procedure CreateSystemTables(const DBUserFile: string);
var
  ADatabase: TABSDatabase;
  createScript: TStream;
  createQuery: TABSQuery;
  Groups: TABSTable;
begin
  ADatabase := TABSDatabase.Create(nil);
  try
    ADatabase.DatabaseName := USER_DATABASE;
    ADatabase.DatabaseFileName := DBUserFile;
    ADatabase.MaxConnections := 5;

    ADatabase.CreateDatabase;

    createScript := TResourceStream.Create(HInstance, 'CreateSystemDB', RT_RCDATA);
    try
      createQuery := TABSQueryEx.Create(ADatabase, '');
      try
        createQuery.SQL.LoadFromStream(createScript);
        createQuery.ExecSQL;
      finally
        FreeAndNil(createQuery);
      end;
    finally
      FreeAndNil(createScript);
    end;

    //
    // ������� ��������� ������
    //
    Groups := TABSTableEx.Create(ADatabase, 'Groups');
    try
      Groups.Active := True;

      Groups.AppendRecord([FAVORITES_GROUP_ID, rstrFavoritesGroupName, False]);
      Groups.AppendRecord([FAVORITES_GROUP_ID + 1, rstrToReadGroupName, False]);
    finally
      FreeAndNil(Groups);
    end;
  finally
    FreeAndNil(ADatabase);
  end;
end;

procedure CreateCollectionTables(const DBCollectionFile: string; const GenresFileName: string);
var
  ADatabase: TABSDatabase;
  createScript: TStream;
  createQuery: TABSQuery;

  ALibrary: TBookCollection;
begin
  ADatabase := TABSDatabase.Create(nil);
  try
    ADatabase.DatabaseFileName := DBCollectionFile;
    ADatabase.DatabaseName := COLLECTION_DATABASE + '_' + IntToStr(Integer(Pointer(ADatabase)));
    ADatabase.MaxConnections := 5;
    ADatabase.PageSize := 65535;
    ADatabase.PageCountInExtent := 16;

    ADatabase.CreateDatabase;

    createScript := TResourceStream.Create(HInstance, 'CreateCollectionDB', RT_RCDATA);
    try
      createQuery := TABSQueryEx.Create(ADatabase, '');
      try
        createQuery.SQL.LoadFromStream(createScript);
        createQuery.ExecSQL;
      finally
        FreeAndNil(createQuery);
      end;
    finally
      FreeAndNil(createScript);
    end;
  finally
    FreeAndNil(ADatabase);
  end;

  // Now that we have the DB structure in place for DBCollectionFile, we can create an instance of the library for it:
  ALibrary := CreateBookCollection(DBCollectionFile);
  try
    //
    // ������� ������ ����������, � ���� ��������
    //
    Assert(ALibrary.FSettings.Active);
    ALibrary.FSettings.AppendRecord([SETTING_VERSION, DATABASE_VERSION]);
    ALibrary.FSettings.AppendRecord([SETTING_CREATION_DATE, FormatDateTime('yyyy-mm-dd hh:nn:ss', Now)]);

    //
    // �������� ������� ������
    //
    ALibrary.LoadGenres(GenresFileName);
  finally
    FreeAndNil(ALibrary);
  end;
end;

// ------------------------------------------------------------------------------
{ TABSTableEx }

constructor TABSTableEx.Create(ADatabase: TABSDatabase; const ATableName: string);
begin
  inherited Create(ADatabase);
  Assert(Assigned(ADatabase));
  SessionName := ADatabase.SessionName;
  DatabaseName := ADatabase.DatabaseName;
  TableName := ATableName;
end;

{ TABSQueryEx }

constructor TABSQueryEx.Create(ADatabase: TABSDatabase; const AQueryText: string);
begin
  inherited Create(ADatabase);
  Assert(Assigned(ADatabase));
  SessionName := ADatabase.SessionName;
  DatabaseName := ADatabase.DatabaseName;
  SQL.Text := AQueryText;
end;

// ------------------------------------------------------------------------------

{ TBookIteratorImpl }

constructor TBookCollection.TBookIteratorImpl.Create(
  Collection: TBookCollection;
  const Mode: TBookIteratorMode;
  const LoadMemos: Boolean;
  const Filter: string;
  const SearchCriteria: TBookSearchCriteria
);
var
  pLogger: IIntervalLogger;
begin
  inherited Create;

  Assert(Assigned(Collection));

  FCollectionID := DMUser.ActiveCollectionInfo.ID;
  FLoadMemos := LoadMemos;
  FCollection := Collection;

  FBooks := TABSQueryEx.Create(FCollection.FDatabase, CreateSQL(Mode, Filter, SearchCriteria));
  FBooks.ReadOnly := True;
  FBooks.RequestLive := True;

  pLogger := GetIntervalLogger('TBookIteratorImpl.Create', FBooks.SQL.Text);
  FBooks.Active := True;
  pLogger := nil;

  FBookID := FBooks.FieldByName(BOOK_ID_FIELD) as TIntegerField;
end;

destructor TBookCollection.TBookIteratorImpl.Destroy;
begin
  FreeAndNil(FBooks);

  inherited Destroy;
end;

// Read next record (if present), return True if read
function TBookCollection.TBookIteratorImpl.Next(out BookRecord: TBookRecord): Boolean;
begin
  Result := not FBooks.Eof;

  if Result then
  begin
    Assert(DMUser.ActiveCollectionInfo.ID = FCollectionID); // shouldn't happen
    FCollection.GetBookRecord(CreateBookKey(FBookID.Value, FCollectionID), BookRecord, FLoadMemos);
    FBooks.Next;
  end;
end;

function TBookCollection.TBookIteratorImpl.GetNumRecords: Integer;
begin
  Result := FBooks.RecordCount;
end;

function TBookCollection.TBookIteratorImpl.CreateSQL(
  const Mode: TBookIteratorMode;
  const Filter: string;
  const SearchCriteria: TBookSearchCriteria
): string;
var
  Where: string;
begin
  Where := '';

  case Mode of
    bmAll:
      Result := 'SELECT b.' + BOOK_ID_FIELD + ' FROM Books b ';
    bmByGenre:
      Result :=
        'SELECT b.' + BOOK_ID_FIELD + ' FROM Genre_List gl INNER JOIN Books b ON gl.' + BOOK_ID_FIELD + ' = b.' + BOOK_ID_FIELD + ' ';
    bmByAuthor:
      Result :=
        'SELECT b.' + BOOK_ID_FIELD + ' FROM Author_List al INNER JOIN Books b ON al.' + BOOK_ID_FIELD + ' = b.' + BOOK_ID_FIELD + ' ';
    bmBySeries:
      Result :=
        'SELECT b.' + BOOK_ID_FIELD + ' FROM Books b ';
    bmSearch:
    begin
      Assert(Filter = '');
      Result := CreateSearchSQL(SearchCriteria);
    end
    else
      Assert(False);
  end;

  if Filter <> '' then
    AddToWhere(Where, Filter);

  if Mode in [bmByGenre, bmByAuthor, bmBySeries] then
  begin
    if FCollection.FHideDeleted then
      AddToWhere(Where, ' b.' + BOOK_DELETED_FIELD + ' = False ');
    if FCollection.FShowLocalOnly then
      AddToWhere(Where, ' b.' + BOOK_LOCAL_FIELD + ' = True ');
  end;

  Result := Result + Where;
  // + ' ORDER BY ' + BOOK_ID_FIELD; // Order fo result consistency
end;

// Original code was extracted from TfrmMain.DoApplyFilter
function TBookCollection.TBookIteratorImpl.CreateSearchSQL(const SearchCriteria: TBookSearchCriteria): string;
var
  FilterString: string;
const
  SQLStartStr = 'SELECT DISTINCT b.' + BOOK_ID_FIELD;
begin
  Result := '';
  try
    // ------------------------ ������ ----------------------------------------
    FilterString := '';
    if SearchCriteria.FullName <> '' then
    begin
      AddToFilter('a.' + AUTHOR_LASTTNAME_FIELD + ' + ' + 'CASE WHEN a.' +
          AUTHOR_FIRSTNAME_FIELD + ' IS NULL THEN '''' ELSE '' '' END + a.' +
          AUTHOR_FIRSTNAME_FIELD + ' + ' + 'CASE WHEN a.' +
          AUTHOR_MIDDLENAME_FIELD + ' IS NULL THEN '''' ELSE '' '' END + a.' +
          AUTHOR_MIDDLENAME_FIELD, PrepareQuery(SearchCriteria.FullName, True),
        True, FilterString);
      if FilterString <> '' then
      begin
        FilterString := SQLStartStr +
          ' FROM Authors a INNER JOIN Author_List b ON (a.' + AUTHOR_ID_FIELD + ' = b.' + AUTHOR_ID_FIELD + ') WHERE '
          + FilterString;

        Result := Result + FilterString;
      end;
    end;

    // ------------------------ ����� -----------------------------------------
    FilterString := '';
    if SearchCriteria.Series <> '' then
    begin
      AddToFilter('s.' + SERIES_TITLE_FIELD, PrepareQuery(SearchCriteria.Series, True), True, FilterString);

      if FilterString <> '' then
      begin
        FilterString := SQLStartStr +
          ' FROM Series s JOIN Books b ON b.' + SERIES_ID_FIELD + ' = s.' + SERIES_ID_FIELD + ' WHERE ' +
          FilterString;

        if Result <> '' then
          Result := Result + ' INTERSECT ';

        Result := Result + FilterString;
      end;
    end;

    // -------------------------- ���� ----------------------------------------
    FilterString := '';
    if (SearchCriteria.Genre <> '') then
    begin
      FilterString := SQLStartStr +
        ' FROM Genre_List g JOIN Books b ON b.' + BOOK_ID_FIELD + ' = g.' + BOOK_ID_FIELD + ' WHERE (' +
        SearchCriteria.Genre + ')';

      if Result <> '' then
        Result := Result + ' INTERSECT ';

      Result := Result + FilterString;
    end;

    // -------------------  ��� ���������   -----------------------------------
    FilterString := '';
    AddToFilter('b.' + BOOK_ANNOTATION_FIELD, PrepareQuery(SearchCriteria.Annotation, True), True, FilterString);
    AddToFilter('b.' + BOOK_TITLE_FIELD, PrepareQuery(SearchCriteria.Title, True), True, FilterString);
    AddToFilter('b.' + BOOK_FILENAME_FIELD, PrepareQuery(SearchCriteria.FileName, False), False, FilterString);
    AddToFilter('b.' + BOOK_FOLDER_FIELD, PrepareQuery(SearchCriteria.Folder, False), False, FilterString);
    AddToFilter('b.' + BOOK_EXT_FIELD, PrepareQuery(SearchCriteria.FileExt, False), False, FilterString);
    AddToFilter('b.' + BOOK_LANG_FIELD, PrepareQuery(SearchCriteria.Lang, True, False), True, FilterString);
    AddToFilter('b.' + BOOK_KEYWORDS_FIELD, PrepareQuery(SearchCriteria.KeyWord, True), True, FilterString);
    //
    if SearchCriteria.DateIdx = -1 then
      AddToFilter('b.' + BOOK_DATE_FIELD, PrepareQuery(SearchCriteria.DateText, False), False, FilterString)
    else
      case SearchCriteria.DateIdx of
        0: AddToFilter('b.' + BOOK_DATE_FIELD, Format('> "%s"', [DateToStr(IncDay(Now, -1))]), False, FilterString);
        1: AddToFilter('b.' + BOOK_DATE_FIELD, Format('> "%s"', [DateToStr(IncDay(Now, -3))]), False, FilterString);
        2: AddToFilter('b.' + BOOK_DATE_FIELD, Format('> "%s"', [DateToStr(IncDay(Now, -7))]), False, FilterString);
        3: AddToFilter('b.' + BOOK_DATE_FIELD, Format('> "%s"', [DateToStr(IncDay(Now, -14))]), False, FilterString);
        4: AddToFilter('b.' + BOOK_DATE_FIELD, Format('> "%s"', [DateToStr(IncDay(Now, -30))]), False, FilterString);
        5: AddToFilter('b.' + BOOK_DATE_FIELD, Format('> "%s"', [DateToStr(IncDay(Now, -90))]), False, FilterString);
      end;

    case SearchCriteria.DownloadedIdx of
      1: AddToFilter('b.' + BOOK_LOCAL_FIELD, '= True', False, FilterString);
      2: AddToFilter('b.' + BOOK_LOCAL_FIELD, '= False', False, FilterString);
    end;

    if SearchCriteria.Deleted then
      AddToFilter('b.' + BOOK_DELETED_FIELD, '= False', False, FilterString);

    if FilterString <> '' then
    begin
      if Result <> '' then
        Result := Result + ' INTERSECT ';
      Result := Result + SQLStartStr + ' FROM Books b WHERE ' + FilterString;
    end;
  except
    on E: Exception do
      raise Exception.Create(rstrFilterParamError);
  end;

  if Result = '' then
    raise Exception.Create(rstrCheckFilterParams);
end;

{ TAuthorIteratorImpl }

constructor TBookCollection.TAuthorIteratorImpl.Create(
  Collection: TBookCollection;
  const Mode: TAuthorIteratorMode;
  const Filter: string
);
var
  pLogger: IIntervalLogger;
begin
  inherited Create;

  Assert(Assigned(Collection));

  FCollectionID := DMUser.ActiveCollectionInfo.ID;
  FCollection := Collection;

  FAuthors := TABSQueryEx.Create(FCollection.FDatabase, CreateSQL(Mode, Filter));
  FAuthors.ReadOnly := True;
  FAuthors.RequestLive := True;

  pLogger := GetIntervalLogger('TAuthorIteratorImpl.Create', FAuthors.SQL.Text);
  FAuthors.Active := True;
  pLogger := nil;

  FAuthorID := FAuthors.FieldByName(AUTHOR_ID_FIELD) as TIntegerField;
end;

destructor TBookCollection.TAuthorIteratorImpl.Destroy;
begin
  FreeAndNil(FAuthors);

  inherited Destroy;
end;

// Read next record (if present), return True if read
function TBookCollection.TAuthorIteratorImpl.Next(out AuthorData: TAuthorData): Boolean;
begin
  Result := not FAuthors.Eof;

  if Result then
  begin
    Assert(DMUser.ActiveCollectionInfo.ID = FCollectionID); // shouldn't happen
    FCollection.GetAuthor(FAuthorID.Value, AuthorData);
    FAuthors.Next;
  end;
end;

function TBookCollection.TAuthorIteratorImpl.GetNumRecords: Integer;
begin
  Result := FAuthors.RecordCount;
end;

function TBookCollection.TAuthorIteratorImpl.CreateSQL(
  const Mode: TAuthorIteratorMode;
  const Filter: string
): string;
var
  Where: string;
begin
  Where := '';

  case Mode of
    amAll:
      Result := 'SELECT a.' + AUTHOR_ID_FIELD + ' FROM Authors a ';

    amByBook:
      Result := 'SELECT DISTINCT a.' + AUTHOR_ID_FIELD + ' FROM Author_List a ';

    amFullFilter:
      begin
        Result := 'SELECT DISTINCT a.' + AUTHOR_ID_FIELD + ' FROM Authors a ';
        if FCollection.FHideDeleted or FCollection.FShowLocalOnly then
        begin
          Result := Result + ' INNER JOIN Author_List al ON a.' + AUTHOR_ID_FIELD + ' = al.' + AUTHOR_ID_FIELD + ' INNER JOIN Books b ON al.' + BOOK_ID_FIELD + ' = b.' + BOOK_ID_FIELD + ' ';
          if FCollection.FHideDeleted then
            AddToWhere(Where, ' b.' + BOOK_DELETED_FIELD + ' = False ');
          if FCollection.FShowLocalOnly then
            AddToWhere(Where, ' b.' + BOOK_LOCAL_FIELD + ' = True ');
        end;

        // Add an author type filter:
        if FCollection.FAuthorFilterType <> '' then
        begin
          if FCollection.FAuthorFilterType = ALPHA_FILTER_NON_ALPHA then
          begin
            AddToWhere(Where, Format(
              '(POS(UPPER(SUBSTRING(a.%0:s, 1, 1)), "%1:s") = 0) AND (POS(UPPER(SUBSTRING(a.%0:s, 1, 1)), "%2:s") = 0)',
              [AUTHOR_LASTTNAME_FIELD, ENGLISH_ALPHABET, RUSSIAN_ALPHABET]
            ));
          end
          else if FCollection.FAuthorFilterType <> ALPHA_FILTER_ALL then
          begin
            Assert(Length(FCollection.FAuthorFilterType) = 1);
            Assert(TCharacter.IsUpper(FCollection.FAuthorFilterType, 1));
            AddToWhere(Where, Format(
              'UPPER(a.%0:s) LIKE "%1:s%%"',                                // ���������� �� �������� �����
              [AUTHOR_LASTTNAME_FIELD, FCollection.FAuthorFilterType]
            ));
          end;
        end;
      end;

    else
      Assert(False);
  end;

  if Filter <> '' then
    AddToWhere(Where, Filter);

  Result := Result + Where;

  if Mode in [amAll, amFullFilter] then
    Result := Result + ' ORDER BY a.' + AUTHOR_LASTTNAME_FIELD + ', a.' + AUTHOR_FIRSTNAME_FIELD + ', a.' + AUTHOR_MIDDLENAME_FIELD + ' ';
end;

{ TGenreIteratorImpl }

constructor TBookCollection.TGenreIteratorImpl.Create(Collection: TBookCollection; const Mode: TGenreIteratorMode; const Filter: string);
var
  pLogger: IIntervalLogger;
begin
  inherited Create;

  Assert(Assigned(Collection));

  FCollectionID := DMUser.ActiveCollectionInfo.ID;
  FCollection := Collection;

  FGenres := TABSQueryEx.Create(FCollection.FDatabase, CreateSQL(Mode, Filter));
  FGenres.ReadOnly := True;
  FGenres.RequestLive := True;

  pLogger := GetIntervalLogger('TGenreIteratorImpl.Create', FGenres.SQL.Text);
  FGenres.Active := True;
  pLogger := nil;

  FGenreCode := FGenres.FieldByName(GENRE_CODE_FIELD) as TWideStringField;
end;

destructor TBookCollection.TGenreIteratorImpl.Destroy;
begin
  FreeAndNil(FGenres);

  inherited Destroy;
end;

// Read next record (if present), return True if read
function TBookCollection.TGenreIteratorImpl.Next(out GenreData: TGenreData): Boolean;
begin
  Result := not FGenres.Eof;

  if Result then
  begin
    Assert(DMUser.ActiveCollectionInfo.ID = FCollectionID); // shouldn't happen
    FCollection.GetGenre(FGenreCode.Value, GenreData);
    FGenres.Next;
  end;
end;

function TBookCollection.TGenreIteratorImpl.GetNumRecords: Integer;
begin
  Result := FGenres.RecordCount;
end;

function TBookCollection.TGenreIteratorImpl.CreateSQL(const Mode: TGenreIteratorMode; const Filter: string): string;
var
  Where: string;
begin
  Where := '';

  case Mode of
    gmAll:
      Result := 'SELECT g.' + GENRE_CODE_FIELD + ' FROM Genres g ';
    gmByBook:
      Result := 'SELECT gl.' + GENRE_CODE_FIELD + ' FROM Genre_List gl ';
    else
      Assert(False);
  end;

  if Filter <> '' then
    AddToWhere(Where, Filter);
  Result := Result + Where;
end;

{ TSeriesIteratorImpl }

constructor TBookCollection.TSeriesIteratorImpl.Create(Collection: TBookCollection; const Mode: TSeriesIteratorMode; const Filter: string);
var
  pLogger: IIntervalLogger;
begin
  inherited Create;

  Assert(Assigned(Collection));

  FCollectionID := DMUser.ActiveCollectionInfo.ID;
  FCollection := Collection;

  FSeries := TABSQueryEx.Create(FCollection.FDatabase, CreateSQL(Mode, Filter));
  FSeries.ReadOnly := True;
  FSeries.RequestLive := True;

  pLogger := GetIntervalLogger('TSeriesIteratorImpl.Create', FSeries.SQL.Text);
  FSeries.Active := True;
  pLogger := nil;

  FSeriesID := FSeries.FieldByName(SERIES_ID_FIELD) as TIntegerField;
  FSeriesTitle := FSeries.FieldByName(SERIES_TITLE_FIELD) as TWideStringField;
end;

destructor TBookCollection.TSeriesIteratorImpl.Destroy;
begin
  FreeAndNil(FSeries);

  inherited Destroy;
end;

// Read next record (if present), return True if read
function TBookCollection.TSeriesIteratorImpl.Next(out SeriesData: TSeriesData): Boolean;
begin
  Result := not FSeries.Eof;

  if Result then
  begin
    Assert(DMUser.ActiveCollectionInfo.ID = FCollectionID); // shouldn't happen
    SeriesData.SeriesID := FSeriesID.Value;
    SeriesData.SeriesTitle := FSeriesTitle.Value;
    FSeries.Next;
  end;
end;

function TBookCollection.TSeriesIteratorImpl.GetNumRecords: Integer;
begin
  Result := FSeries.RecordCount;
end;

function TBookCollection.TSeriesIteratorImpl.CreateSQL(const Mode: TSeriesIteratorMode; const Filter: string): string;
var
  Where: string;
begin
  Where := '';
  case Mode of
    smAll:
      Result := 'SELECT s.' + SERIES_ID_FIELD + ', s.' + SERIES_TITLE_FIELD + ' FROM Series s ';
    smFullFilter:
    begin
      Result := 'SELECT DISTINCT s.' + SERIES_ID_FIELD + ', s.' + SERIES_TITLE_FIELD + ' FROM Series s ';
      if FCollection.FHideDeleted or FCollection.FShowLocalOnly then
      begin
        Result := Result + ' INNER JOIN Books b ON s.' + SERIES_ID_FIELD + ' = b.' + SERIES_ID_FIELD + ' ';
        if FCollection.FHideDeleted then
          AddToWhere(Where, ' b.' + BOOK_DELETED_FIELD + ' = False ');
        if FCollection.FShowLocalOnly then
          AddToWhere(Where, ' b.' + BOOK_LOCAL_FIELD + ' = True ');
      end;

      // Series type filter
      if FCollection.FSeriesFilterType <> '' then
      begin
        if FCollection.FSeriesFilterType = ALPHA_FILTER_NON_ALPHA then
          AddToWhere(Where, Format(
            '(POS(UPPER(SUBSTRING(s.%0:s, 1, 1)), "%1:s") = 0) AND (POS(UPPER(SUBSTRING(s.%0:s, 1, 1)), "%2:s") = 0)',
            [SERIES_TITLE_FIELD, ENGLISH_ALPHABET, RUSSIAN_ALPHABET]
          ))
        else if FCollection.FSeriesFilterType <> ALPHA_FILTER_ALL then
        begin
          Assert(Length(FCollection.FSeriesFilterType) = 1);
          Assert(TCharacter.IsUpper(FCollection.FSeriesFilterType, 1));
          AddToWhere(Where, Format(
            'UPPER(s.%0:s) LIKE "%1:s%%"',                                // ���������� �� �������� �����
            [SERIES_TITLE_FIELD, FCollection.FSeriesFilterType]
          ));
        end;
      end;
    end
    else
      Assert(False);
  end;

  if Filter <> '' then
    AddToWhere(Where, Filter);
  Result := Result + Where;
  Result := Result + ' ORDER BY s.' + SERIES_TITLE_FIELD;
end;

{ TBookCollection }

constructor TBookCollection.Create(const DBCollectionFile: string; ADefaultSession: Boolean = True);
begin
  inherited Create;

  FDefaultSession := ADefaultSession;

  //
  // TODO: ���� ��������� ��������� � ��������� ������, �� ���������� ������� ��������� ��������� � DMUser
  //

  if not FDefaultSession then
  begin
    FSession := TABSSession.Create(nil);
    FSession.AutoSessionName := True;
  end;

  FDatabase := TABSDatabase.Create(nil);
  FDatabase.DatabaseName := COLLECTION_DATABASE + '_' + IntToStr(Integer(Pointer(Self)));
  FDatabase.DatabaseFileName := DBCollectionFile;
  FDatabase.MultiUser := True;
  if not FDefaultSession then
    FDatabase.SessionName := FSession.SessionName;

  FDatabase.Connected := True;

  FSettings := TABSTableEx.Create(FDatabase, 'Settings');
  FSettings.DatabaseName := FDatabase.DatabaseName;

  FAuthors := TABSTableEx.Create(FDatabase, 'Authors');
  FAuthorList := TABSTableEx.Create(FDatabase, 'Author_list');
  FBooks := TABSTableEx.Create(FDatabase, 'Books');
  FSeries := TABSTableEx.Create(FDatabase, 'Series');
  FGenres := TABSTableEx.Create(FDatabase, 'Genres');
  FGenreList := TABSTableEx.Create(FDatabase, 'Genre_list');

  MountTables(True);
end;

destructor TBookCollection.Destroy;
begin
  FreeAndNil(FSettings);
  FreeAndNil(FAuthors);
  FreeAndNil(FAuthorList);
  FreeAndNil(FBooks);
  FreeAndNil(FSeries);
  FreeAndNil(FGenres);
  FreeAndNil(FGenreList);

  FreeAndNil(FDatabase);
  FreeAndNil(FSession);

  inherited Destroy;
end;

procedure TBookCollection.SetProperty(PropID: Integer; const Value: Integer);
begin
  if Value = 0 then
    Exit;

  SetProperty(PropID, IntToStr(Value));
end;

procedure TBookCollection.SetProperty(PropID: Integer; const Value: string);
begin
  Assert(FSettings.Active);

  if Value = '' then
    Exit;

  if FSettings.Locate(ID_FIELD, PropID, []) then
    FSettings.Edit
  else
    FSettings.Append;

  try
    FSettingsID.Value := PropID;
    FSettingsValue.Value := Value;

    FSettings.Post;
  except
    FSettings.Cancel;
  end;
end;

procedure TBookCollection.LoadGenres(const GenresFileName: string);
var
  FS: TStringList;
  i: Integer;
  p: Integer;
  S: string;
  ParentCode: string;
  Code: string;
  FB2Code: string;
begin
  Assert(FGenres.Active);

  FS := TStringList.Create;
  try
    FS.LoadFromFile(GenresFileName, TEncoding.UTF8);

    for i := 0 to FS.Count - 1 do
    begin
      S := FS[i];
      //
      // ��������� ������ ������
      //
      if S = '' then
        Continue;

      //
      // ... � �����������
      //
      if S[1] = '#' then
        Continue;

      //
      // ������ ���� ������ � ��������� �������
      // -------------------------------------
      // 0.1 ���������� (������� ���������� � �������)
      // 0.2 ��������� � ��������
      // ...
      // 0.1.0 sf;������� ����������
      // 0.1.1 sf_history;�������������� �������
      // ...
      // -------------------------------------

      //
      // �������� ��� (0.1)
      //
      p := AnsiPos(' ', S);
      if 0 = p then
        Continue;
      Code := Copy(S, 1, p - 1);
      Delete(S, 1, p);

      //
      // � ��� ������������� �������� (0)
      //
      p := LastDelimiter('.', Code);
      if 0 = p then
        Continue;
      ParentCode := Copy(Code, 1, p - 1);

      //
      // fb2 ���. ����� �������������! (sf)
      //
      FB2Code := '';
      p := AnsiPos(';', S);
      if 0 <> p then
      begin
        FB2Code := Copy(S, 1, p - 1);
        Delete(S, 1, p);
      end;

      //
      // ���� ����� ���� ��� ���������� => ��������� ���
      //
      { TODO -oNickR : ����� ����� ��������� � ��������� ����? }
      if FGenres.Locate(GENRE_CODE_FIELD, Code, []) then
        Continue;

      //
      // ��� ������ => ��������� � ����
      //
      FGenres.Insert;
      try
        FGenresGenreCode.Value := Code;
        FGenresParentCode.Value := ParentCode;
        FGenresFB2Code.Value := FB2Code;
        FGenresAlias.Value := S;
        FGenres.Post;
      except
        FGenres.Cancel;
        raise;
      end;
    end;
  finally
    FS.Free;
  end;
end;

procedure TBookCollection.ReloadDefaultGenres(const FileName: string);
begin
  Assert(FGenres.Active);

  //
  // ��������� ������� Genres
  //
  FGenres.Active := False;
  FGenres.EmptyTable;
  FGenres.Active := True;

  LoadGenres(FileName);
end;

function TBookCollection.GetTopGenreAlias(const FB2Code: string): string;
var
  Code: string;
  p: Integer;
begin
  Assert(FGenres.Active);

  FGenres.Locate(GENRE_FB2CODE_FIELD, FB2Code, []);
  Code := FGenresGenreCode.Value;

  Delete(Code, 1, 2); // "0."
  p := Pos('.', Code);
  Code := '0.' + Copy(Code, 1, p - 1);

  FGenres.Locate(GENRE_CODE_FIELD, Code, []);
  Result := FGenresAlias.Value;
end;

function TBookCollection.CheckFileInCollection(const FileName: string; const FullNameSearch: Boolean; const ZipFolder: Boolean): Boolean;
var
  S: string;
begin
  Assert(FBooks.Active);

  if ZipFolder then
    Result := FBooks.Locate(BOOK_FOLDER_FIELD, FileName, [loCaseInsensitive])
  else
  begin
    if FullNameSearch then
      S := ExtractFileName(FileName)
    else
      S := TPath.GetFileNameWithoutExtension(FileName);
    Result := FBooks.Locate(BOOK_FILENAME_FIELD, S, [loCaseInsensitive]);
  end;
end;

function TBookCollection.InsertBook(BookRecord: TBookRecord; CheckFileName, FullCheck: Boolean): Integer;
var
  i: Integer;
  Author: TAuthorData;

  Res: Boolean;

begin
  Assert(FAuthors.Active);
  Assert(FAuthorList.Active);
  Assert(FBooks.Active);
  Assert(FSeries.Active);
  Assert(FGenres.Active);

  Result := 0;

  if BookRecord.FileName = '' then
    Exit;

  BookRecord.Normalize;

  //
  // �������� ������������� �������
  //
  Assert(BookRecord.AuthorCount > 0);
  for i := 0 to BookRecord.AuthorCount - 1 do
  begin
    if not FAuthors.Locate(AUTHOR_FULLNAME_FIELDS, VarArrayOf([BookRecord.Authors[i].LastName, BookRecord.Authors[i].FirstName, BookRecord.Authors[i].MiddleName]), [loCaseInsensitive]) then
    begin
      FAuthors.Insert;
      try
        FAuthorsLastName.Value := BookRecord.Authors[i].LastName;
        FAuthorsFirstName.Value := BookRecord.Authors[i].FirstName;
        FAuthorsMiddleName.Value := BookRecord.Authors[i].MiddleName;
        FAuthors.Post;
      except
        FAuthors.Cancel;
        raise;
      end;
    end;

    //
    // � �������� ID-��
    //
    BookRecord.Authors[i].AuthorID := FAuthorsID.Value;
  end;

  // Filter out duplicate authors by AuthorID:
  FilterDuplicateAuthorsByID(BookRecord.Authors);

  //
  // ���������� ��� �����
  //
  Assert(BookRecord.GenreCount > 0);
  for i := 0 to BookRecord.GenreCount - 1 do
  begin
    //
    // ���� fb2 ��� ������, ��������� ��� � ������������� ���
    //
    if BookRecord.Genres[i].FB2GenreCode <> '' then
    begin
      //
      // ����� fb2-��� ����� => �������� ���������� ���
      //
      if FGenres.Locate(GENRE_FB2CODE_FIELD, BookRecord.Genres[i].FB2GenreCode, [loCaseInsensitive]) then
        BookRecord.Genres[i].GenreCode := FGenresGenreCode.Value
      else
        //
        // fb2-��� ����������� - ��� � �������
        //
        BookRecord.Genres[i].GenreCode := UNKNOWN_GENRE_CODE;
    end
    else
    //
    // ���� �� ������ fb2-���, ��������� ������� ����������� ����.
    // ���� ���������� ��� ���������� ��� �� ������ => "��� � �������"
    //
    if
      (BookRecord.Genres[i].GenreCode = '') or                         // ���������� ��� �� ������
      (not FGenres.Locate(GENRE_CODE_FIELD, BookRecord.Genres[i].GenreCode, [loCaseInsensitive]))  // ���������� ��� ����������
    then
      BookRecord.Genres[i].GenreCode := UNKNOWN_GENRE_CODE;
  end;

  //
  // �������� ������������� �����
  //
  if NO_SERIES_TITLE = BookRecord.Series then
  begin
    BookRecord.SeriesID := NO_SERIE_ID;
  end
  else
  begin
    if not FSeries.Locate(SERIES_TITLE_FIELD, BookRecord.Series, [loCaseInsensitive]) then
    begin
      FSeries.Append;
      try
        FSeriesSeriesTitle.Value := BookRecord.Series;
        FSeries.Post;
      except
        FSeries.Cancel;
        raise;
      end;
    end;
    BookRecord.SeriesID := FSeriesSeriesID.AsInteger;
  end;

  //
  // ���������� �������� ���������� � �����
  //
  if CheckFileName then
    if FullCheck then
      Res := FBooks.Locate('Folder;FileName', VarArrayOf([BookRecord.Folder, BookRecord.FileName]), [loCaseInsensitive])
    else
      Res := FBooks.Locate(BOOK_FILENAME_FIELD, BookRecord.FileName, [loCaseInsensitive])
    else
      Res := False;

  if not Res then
  begin
    if BookRecord.SeqNumber > 5000 then
      BookRecord.SeqNumber := 0;

    FBooks.Append;
    try
      FBooksLibID.Value := BookRecord.LibID;
      FBooksTitle.Value := BookRecord.Title;
      if NO_SERIE_ID <> BookRecord.SeriesID then
      begin
        FBooksSeriesID.Value := BookRecord.SeriesID;
        FBooksSeqNumber.Value := BookRecord.SeqNumber;
      end;
      FBooksDate.Value := BookRecord.Date;
      FBooksLibRate.Value := BookRecord.LibRate;
      FBooksLang.Value := BookRecord.Lang;
      FBooksFolder.Value := BookRecord.Folder;
      FBooksFileName.Value := BookRecord.FileName;
      FBooksInsideNo.Value := BookRecord.InsideNo;
      FBooksExt.Value := BookRecord.FileExt;
      FBooksSize.Value := BookRecord.Size;
      FBooksCode.Value := BookRecord.Code;
      FBooksIsLocal.Value := BookRecord.IsLocal;
      FBooksIsDeleted.Value := BookRecord.IsDeleted;
      FBooksKeyWords.Value := BookRecord.KeyWords;
      FBooksRate.Value := BookRecord.Rate;
      FBooksProgress.Value := BookRecord.Progress;
      if BookRecord.Annotation <> '' then
        FBooksAnnotation.Value := BookRecord.Annotation;
      if BookRecord.Review <> '' then
        FBooksReview.Value := BookRecord.Review;
      FBooks.Post;
    except
      FBooks.Cancel;
      raise;
    end;

    InsertBookGenres(FBooksBookID.Value, BookRecord.Genres);

    for Author in BookRecord.Authors do
    begin
      FAuthorList.Append;
      try
        FAuthorListAuthorID.Value := Author.AuthorID;
        FAuthorListBookID.Value := FBooksBookID.Value;

        FAuthorList.Post;
      except
        FAuthorList.Cancel;
        raise;
      end;
    end;

    Result := FBooksBookID.Value;
  end;
end;

procedure TBookCollection.DeleteBook(const BookKey: TBookKey);
var
  SeriesID: Integer;
begin
  Assert(FAuthors.Active);
  Assert(FAuthorList.Active);
  Assert(FBooks.Active);
  Assert(FSeries.Active);
  Assert(FGenreList.Active);

  if FBooks.Locate(BOOK_ID_FIELD, BookKey.BookID, []) then
  begin
    SeriesID := FBooksSeriesID.Value;
    FBooks.Delete;

    { TODO -oNickR : �������� ��� ������ �� DELETE FROM query }

    while FGenreList.Locate(BOOK_ID_FIELD, BookKey.BookID, []) do
      FGenreList.Delete;
    while FAuthorList.Locate(BOOK_ID_FIELD, BookKey.BookID, []) do
      FAuthorList.Delete;

    //
    // ���� ����� ������� � ����� (SeriesID <> 1) ��������, �� ���� �� ������� �����.
    //
    if SeriesID <> NO_SERIE_ID then
    begin
      if not FBooks.Locate(SERIES_ID_FIELD, SeriesID, []) then
      begin
        //
        // ������ ���� �� ���� ����� ��� => ������ �����
        //
        FSeries.Locate(SERIES_ID_FIELD, SeriesID, []);
        FSeries.Delete;
      end;
    end;

    //
    // � ������� ������ ������ ���� ���� ���� �����.
    // TODO -oNickR -cUsability : ��������, ����� �������� ��� ���������� � ������� �������� �������, ���� ������� ��� � ����������
    //
    FAuthors.First;
    while not FAuthors.Eof do
    begin
      if FAuthorList.Locate(AUTHOR_ID_FIELD, FAuthorsID.Value, []) then
        FAuthors.Next
      else
        FAuthors.Delete;
    end;

    DMUser.DeleteBook(BookKey);
  end;
end;

procedure TBookCollection.GetBookRecord(const BookKey: TBookKey; var BookRecord: TBookRecord; LoadMemos: Boolean);
begin
  BookRecord.Clear;

  if BookKey.DatabaseID = DMUser.ActiveCollectionInfo.ID then
  begin
    Assert(FBooks.Active);

    if not FBooks.Locate(BOOK_ID_FIELD, BookKey.BookID, []) then
    begin
      Assert(False);
      Exit;
    end;

    BookRecord.BookKey.BookID := FBooksBookID.Value;
    BookRecord.BookKey.DatabaseID := DMUser.ActiveCollectionInfo.ID;
    BookRecord.Title := FBooksTitle.Value;
    BookRecord.Folder := FBooksFolder.Value;
    BookRecord.FileName := FBooksFileName.Value;
    BookRecord.FileExt := FBooksExt.Value;
    BookRecord.InsideNo := FBooksInsideNo.Value;
    if not FBooksSeriesID.IsNull then
    begin
      BookRecord.SeriesID := FBooksSeriesID.Value;
      BookRecord.Series := GetSeriesTitle(FBooksSeriesID.Value);
      BookRecord.SeqNumber := FBooksSeqNumber.Value;
    end;
    BookRecord.Code := FBooksCode.Value;
    BookRecord.Size := FBooksSize.Value;
    BookRecord.LibID := FBooksLibID.Value;
    BookRecord.IsDeleted := FBooksIsDeleted.Value;
    BookRecord.IsLocal := FBooksIsLocal.Value;
    BookRecord.Date := FBooksDate.Value;
    BookRecord.Lang := FBooksLang.Value;
    BookRecord.LibRate := FBooksLibRate.Value;
    BookRecord.KeyWords := FBooksKeyWords.Value;
    BookRecord.NodeType := ntBookInfo;
    BookRecord.Rate := FBooksRate.Value;
    BookRecord.Progress := FBooksProgress.Value;
    BookRecord.CollectionRoot := DMUser.ActiveCollectionInfo.RootPath;
    BookRecord.CollectionName := DMUser.ActiveCollectionInfo.Name;

    GetBookGenres(BookRecord.BookKey.BookID, BookRecord.Genres, @(BookRecord.RootGenre));
    GetBookAuthors(BookRecord.BookKey.BookID, BookRecord.Authors);

    if LoadMemos then
    begin
      // TODO - rethink when to load the memo fields.
      //
      // ��� ���� ����� ���������� ������ ��� ����������� ����� � ������ ���������.
      // �� ���� ��������� ������� ��� �� ������������.
      //
      BookRecord.Review := FBooksReview.Value;
      BookRecord.Annotation := FBooksAnnotation.Value;
    end;
  end
  else
    DMUser.GetBookRecord(BookKey, BookRecord);
end;

procedure TBookCollection.CleanBookGenres(BookID: Integer);
begin
  Assert(FGenreList.Active);

  while FGenreList.Locate(BOOK_ID_FIELD, BookID, []) do
    FGenreList.Delete;
end;

// Add book genres for the book specified by BookID
// Please notice that Genres could be altered by the method if it contains genres with duplicate codes
procedure TBookCollection.InsertBookGenres(const BookID: Integer; var Genres: TBookGenres);
var
  Genre: TGenreData;
begin
  Assert(FGenreList.Active);

  FilterDuplicateGenresByCode(Genres);

  for Genre in Genres do
  begin
    FGenreList.Append;
    try
      FGenreListBookID.Value := BookID;
      FGenreListGenreCode.Value := Genre.GenreCode;

      FGenreList.Post;
    except
      FGenreList.Cancel;
      raise;
    end;
  end;
end;

procedure TBookCollection.GetSeries(SeriesList: TStrings);
begin
  Assert(FSeries.Active);

  FSeries.First;
  while not FSeries.Eof do
  begin
    SeriesList.Add(FSeriesSeriesTitle.Value);
    FSeries.Next;
  end;
end;

// Filter out duplicates by author ID
procedure TBookCollection.FilterDuplicateAuthorsByID(var Authors: TBookAuthors);
var
  MapId: TList<Integer>;
  NewAuthors: TBookAuthors;
  AuthorData: TAuthorData;
  Len: Integer;
begin
  Len := 0;

  MapId := TList<Integer>.Create;
  try
    for AuthorData in Authors do
    begin
      if -1 = MapId.IndexOf(AuthorData.AuthorID) then
      begin
        SetLength(NewAuthors, Len + 1);
        NewAuthors[Len] := AuthorData;
        Inc(Len);
        MapId.Add(AuthorData.AuthorID);
      end;
    end;
  finally
    FreeAndNil(MapId);
  end;
  Authors := NewAuthors;
end;

// Filter out duplicates by genre code
procedure TBookCollection.FilterDuplicateGenresByCode(var Genres: TBookGenres);
var
  MapId: TList<string>;
  NewGenres: TBookGenres;
  GenreData: TGenreData;
  Len: Integer;
begin
  Len := 0;

  MapId := TList<string>.Create;
  try
    for GenreData in Genres do
    begin
      if -1 = MapId.IndexOf(GenreData.GenreCode) then
      begin
        SetLength(NewGenres, Len + 1);
        NewGenres[Len] := GenreData;
        Inc(Len);
        MapId.Add(GenreData.GenreCode);
      end;
    end;
  finally
    FreeAndNil(MapId);
  end;
  Genres := NewGenres;
end;

procedure TBookCollection.BeginBulkOperation;
begin
  Assert(not FDatabase.InTransaction);

  FDatabase.StartTransaction;
end;

procedure TBookCollection.EndBulkOperation(Commit: Boolean = True);
begin
  Assert(FDatabase.InTransaction);

  if Commit then
    FDatabase.Commit(False)
  else
    FDatabase.Rollback;
end;

// Return an iterator working on the active collection
// but having its own Books dataset (the rest of the tables are from the active collection).
// No need to free the iterator when done as it's a TInterfacedObject
// and knows to self destroy when no longer referenced.
function TBookCollection.GetBookIterator(const Mode: TBookIteratorMode; const LoadMemos: Boolean; const Filter: string): IBookIterator;
var
  EmptySearchCriteria: TBookSearchCriteria;
begin
  Result := TBookIteratorImpl.Create(Self, Mode, LoadMemos, Filter, EmptySearchCriteria);
end;

function TBookCollection.GetBookIterator(const LoadMemos: Boolean; const SearchCriteria: TBookSearchCriteria): IBookIterator;
begin
  Result := TBookIteratorImpl.Create(Self, bmSearch, LoadMemos, '', SearchCriteria);
end;

function TBookCollection.GetAuthorIterator(const Mode: TAuthorIteratorMode; const Filter: string): IAuthorIterator;
begin
  Result := TAuthorIteratorImpl.Create(Self, Mode, Filter);
end;

function TBookCollection.GetGenreIterator(const Mode: TGenreIteratorMode; const Filter: string): IGenreIterator;
begin
  Result := TGenreIteratorImpl.Create(Self, Mode, Filter);
end;

function TBookCollection.GetSeriesIterator(const Mode: TSeriesIteratorMode; const Filter: string = ''): ISeriesIterator;
begin
  Result := TSeriesIteratorImpl.Create(Self, Mode, Filter);
end;

procedure TBookCollection.GetBookGenres(BookID: Integer; var BookGenres: TBookGenres; RootGenre: PGenreData = nil);
var
  i: Integer;
  GenreIterator: IGenreIterator;
  Genre: TGenreData;
begin
  GenreIterator := GetGenreIterator(gmByBook, Format('gl.%s = %d', [BOOK_ID_FIELD, BookID]));
  i := Length(BookGenres);
  while GenreIterator.Next(Genre) do
  begin
    SetLength(BookGenres, i + 1);
    BookGenres[i] := Genre;
    Inc(i);
  end;

  if Assigned(RootGenre) then
  begin
    if Length(BookGenres) > 0 then
      GetGenre(BookGenres[0].ParentCode, RootGenre^)
    else
      RootGenre^.Clear;
  end;
end;

procedure TBookCollection.GetBookAuthors(BookID: Integer; var BookAuthors: TBookAuthors);
var
  AuthorIterator: IAuthorIterator;
  i: Integer;
begin
  AuthorIterator := GetAuthorIterator(amByBook, Format('a.%s = %u', [BOOK_ID_FIELD, BookID]));
  SetLength(BookAuthors, AuthorIterator.GetNumRecords + 1); // an extra dummy element
  i := 0;
  while AuthorIterator.Next(BookAuthors[i]) do
    Inc(i);
  SetLength(BookAuthors, AuthorIterator.GetNumRecords); // remove the dummy element
end;

procedure TBookCollection.GetGenre(const GenreCode: string; var Genre: TGenreData);
begin
  Assert(FGenres.Active);
  if FGenres.Locate(GENRE_CODE_FIELD, GenreCode, []) then
  begin
    Genre.GenreCode := GenreCode;
    Genre.ParentCode := FGenresParentCode.Value;
    Genre.FB2GenreCode := FGenresFB2Code.Value;
    Genre.GenreAlias := FGenresAlias.Value;
  end
  else
    Genre.Clear;
end;

procedure TBookCollection.GetAuthor(AuthorID: Integer; var Author: TAuthorData);
begin
  Assert(FAuthors.Active);
  if FAuthors.Locate(AUTHOR_ID_FIELD, AuthorID, []) then
  begin
    Author.AuthorID := AuthorID;
    Author.LastName := FAuthorsLastName.Value;
    Author.FirstName := FAuthorsFirstName.Value;
    Author.MiddleName := FAuthorsMiddleName.Value;
  end
  else
    Author.Clear;
end;

function TBookCollection.GetSeriesTitle(SeriesID: Integer): string;
begin
  if (NO_SERIE_ID <> SeriesID) and FSeries.Locate(SERIES_ID_FIELD, SeriesID, []) then
    Result := FSeriesSeriesTitle.Value
  else
    Result := NO_SERIES_TITLE;
end;

procedure TBookCollection.VerifyCurrentCollection(const DatabaseID: Integer);
var
  BookCollectionName: string;
  CurrentCollectionName: string;
begin
  if DatabaseID <> DMUser.ActiveCollectionInfo.ID then
  begin
    if (DMUser.SelectCollection(DatabaseID)) then
      BookCollectionName := DMUser.CurrentCollectionInfo.Name
    else
      BookCollectionName := '';
    raise ENotSupportedException.Create(Format(rstrErrorOnlyForCurrentCollection, [DMUser.ActiveCollectionInfo.Name, BookCollectionName]));
  end;
end;

procedure TBookCollection.SetSeriesTitle(const SeriesID: Integer; const NewSeriesTitle: string);
begin
  Assert(FSeries.Active);
  Assert(SeriesID <> NO_SERIE_ID);
  Assert(NewSeriesTitle <> NO_SERIES_TITLE);

  if (FSeries.Locate(SERIES_ID_FIELD, SeriesID, [])) then
  begin
    FSeries.Edit;
    try
      FSeriesSeriesTitle.Value := NewSeriesTitle;
      FSeries.Post;
    except
      FSeries.Cancel;
      raise ;
    end;
  end;
end;

// If the series title is already in DB - locate it and return the SeriesID
// If the title is not in DB - add and returned the ID of the added row
function TBookCollection.AddOrLocateSeriesIDBySeriesTitle(const SeriesTitle: string): Integer;
begin
  Assert(FSeries.Active);

  if NO_SERIES_TITLE = SeriesTitle then
  begin
    Result := NO_SERIE_ID;
    Exit;
  end;

  if not FSeries.Locate(SERIES_TITLE_FIELD, SeriesTitle, []) then
  begin
    FSeries.Append;
    try
      FSeriesSeriesTitle.Value := SeriesTitle;
      FSeries.Post;
    except
      FSeries.Cancel;
      raise ;
    end;
  end;
  Result := FSeriesSeriesID.Value;
end;

// Change SeriesID value for all books in the current database with old SeriesID value
procedure TBookCollection.ChangeBookSeriesID(const OldSeriesID: Integer; const NewSeriesID: Integer; const DatabaseID: Integer);
const
  UPDATE_SQL = 'UPDATE Books SET ' + SERIES_ID_FIELD + ' = %s WHERE ' + SERIES_ID_FIELD + ' %s';
var
  Query: TABSQuery;
  newSerie: string;
  oldSerie: string;
var
  pLogger: IIntervalLogger;
begin
  Assert(OldSeriesID <> NewSeriesID);

  VerifyCurrentCollection(DatabaseID);

  if NO_SERIE_ID = NewSeriesID then
    newSerie := 'NULL'
  else
    newSerie := Format('%u', [NewSeriesID]);

  if NO_SERIE_ID = OldSeriesID then
    oldSerie := 'IS NULL'
  else
    oldSerie := Format('= %u', [NewSeriesID]);

  Query := TABSQueryEx.Create(FDatabase, Format(UPDATE_SQL, [newSerie, oldSerie]));
  try
    pLogger := GetIntervalLogger('TBookCollection.ChangeBookSeriesID', Query.SQL.Text);
    Query.ExecSQL;
    pLogger := nil;
  finally
    FreeAndNil(Query);
  end;

  // ������� ���������� � �������
  DMUser.ChangeBookSeriesID(OldSeriesID, NewSeriesID, DatabaseID);
end;

procedure TBookCollection.ImportUserData(data: TUserData; guiUpdateCallback: TGUIUpdateExtraProc);
var
  extra: TBookExtra;
  group: TBookGroup;
  groupBook: TGroupBook;

  BookKey: TBookKey;

  function GetBookKey(bookInfo: TBookInfo; out BookKey: TBookKey): Boolean;
  begin
    if bookInfo.LibID = 0 then
      Result := FBooks.Locate(BOOK_ID_FIELD, bookInfo.BookID, [])
    else
      Result := FBooks.Locate(BOOK_LIBID_FIELD, bookInfo.LibID, []);

    if Result then
    begin
      BookKey := CreateBookKey(FBooksBookID.Value, DMUser.ActiveCollectionInfo.ID);
    end;
  end;

begin
  Assert(Assigned(data));
  Assert(Assigned(guiUpdateCallback));
  Assert(FBooks.Active);

  //
  // �������� ��������, review � ������� �������������
  //
  for extra in data.Extras do
  begin
    if GetBookKey(extra, BookKey) then
    begin
      FBooks.Edit;
      try
        if extra.Rating <> 0 then
          FBooksRate.Value := extra.Rating;
        if extra.Progress <> 0 then
          FBooksProgress.Value := extra.Progress;
        if extra.Review <> '' then
          FBooksReview.Value := extra.Review;
        FBooks.Post;
      except
        FBooks.Cancel;
        raise ;
      end;
    end;

    //
    // ������� ���������� � �������
    //
    DMUser.SetExtra(BookKey, extra);

    //
    // ����� ����������� �������� ���� �������� ���������� ����
    //
    guiUpdateCallback(BookKey, extra);
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
      if GetBookKey(groupBook, BookKey) then
      begin
        AddBookToGroup(BookKey, group.GroupID);
      end;
    end;
  end;
end;

procedure TBookCollection.AddBookToGroup(const BookKey: TBookKey; GroupID: Integer);
var
  BookRecord: TBookRecord;
begin
  VerifyCurrentCollection(BookKey.DatabaseID);
  Assert(FBooks.Active);

  GetBookRecord(BookKey, BookRecord, True);

  DMUser.AddBookToGroup(BookKey, GroupID, BookRecord);
end;

procedure TBookCollection.ExportUserData(data: TUserData);
begin
  Assert(Assigned(data));
  Assert(FBooks.Active);

  FBooks.First;
  while not FBooks.Eof do
  begin
    if
      (FBooksRate.Value <> 0) or
      (FBooksProgress.Value <> 0) or
      (not FBooksReview.IsNull)
    then
      data.Extras.AddExtra(
        FBooksBookID.Value,
        FBooksLibID.Value,
        FBooksRate.Value,
        FBooksProgress.Value,
        FBooksReview.Value
      );

    FBooks.Next;
  end;

  DMUser.ExportUserData(data);
end;

procedure TBookCollection.GetStatistics(out AuthorsCount: Integer; out BooksCount: Integer; out SeriesCount: Integer);
begin
  (* ***************************************************************************
    *
    * ����� ��������������� ������������ 3 ������� �������,
    * �� ���� ������� ��� ����
    *
    *************************************************************************** *)
  AuthorsCount := FAuthors.RecordCount;
  BooksCount := FBooks.RecordCount;
  SeriesCount := FSeries.RecordCount;
end;

// ��������� ��������� ���������� � ����� � ����������� BookID:
procedure TBookCollection.UpdateBook(const BookRecord: TBookRecord);
begin
  VerifyCurrentCollection(BookRecord.BookKey.DatabaseID);
  Assert(FBooks.Active);

  if FBooks.Locate(BOOK_ID_FIELD, BookRecord.BookKey.BookID, []) then
  begin

  end;

  DMUser.UpdateBook(BookRecord);
end;

function TBookCollection.SetReview(const BookKey: TBookKey; const Review: string): Integer;
var
  NewReview: string;
begin
  VerifyCurrentCollection(BookKey.DatabaseID);
  Assert(FBooks.Active);

  Result := 0;
  NewReview := Trim(Review);

  Result := 0;
  if FBooks.Locate(BOOK_ID_FIELD, BookKey.BookID, []) then
  begin
    FBooks.Edit;
    try
      if Review = '' then
      begin
        FBooksReview.Clear;
        FBooksCode.Value := 0;
      end
      else
      begin
        FBooksReview.Value := Review;
        FBooksCode.Value := 1;
        Result := 1;
      end;
      FBooks.Post;
    except
      FBooks.Cancel;
      raise ;
    end;
  end;

  //
  // ������� ���������� � �������
  //
  Result := Result or DMUser.SetReview(BookKey, NewReview);
end;

function TBookCollection.GetReview(const BookKey: TBookKey): string;
begin
  if BookKey.DatabaseID = DMUser.ActiveCollectionInfo.ID then
  begin
    Assert(FBooks.Active);
    if FBooks.Locate(BOOK_ID_FIELD, BookKey.BookID, []) then
      Result := FBooksReview.Value
    else
      Result := '';
  end
  else
    Result := DMUser.GetReview(BookKey);
end;

procedure TBookCollection.SetProgress(const BookKey: TBookKey; Progress: Integer);
begin
  VerifyCurrentCollection(BookKey.DatabaseID);
  Assert(FBooks.Active);

  if FBooks.Locate(BOOK_ID_FIELD, BookKey.BookID, []) then
  begin
    FBooks.Edit;
    try
      FBooksProgress.Value := Progress;
      FBooks.Post;
    except
      FBooks.Cancel;
      raise ;
    end;
  end;

  //
  // ������� ���������� � �������
  //
  DMUser.SetProgress(BookKey, Progress);
end;

procedure TBookCollection.SetRate(const BookKey: TBookKey; Rate: Integer);
begin
  VerifyCurrentCollection(BookKey.DatabaseID);
  Assert(FBooks.Active);

  if FBooks.Locate(BOOK_ID_FIELD, BookKey.BookID, []) then
  begin
    FBooks.Edit;
    try
      FBooksRate.Value := Rate;
      FBooks.Post;
    except
      FBooks.Cancel;
      raise ;
    end;
  end;

  //
  // ������� ���������� � �������
  //
  DMUser.SetRate(BookKey, Rate);
end;

procedure TBookCollection.SetBookSeriesID(const BookKey: TBookKey; const SeriesID: Integer);
begin
  VerifyCurrentCollection(BookKey.DatabaseID);
  Assert(FBooks.Active);

  FBooks.Locate(BOOK_ID_FIELD, BookKey.BookID, []);
  FBooks.Edit;
  try
    if NO_SERIE_ID = SeriesID then
      FBooksSeriesID.Clear
    else
      FBooksSeriesID.Value := SeriesID;
    FBooks.Post;
  except
    FBooks.Cancel;
    raise ;
  end;

  // ������� ���������� � �������
  DMUser.SetBookSeriesID(BookKey, SeriesID);
end;

procedure TBookCollection.SetFolder(const BookKey: TBookKey; const Folder: string);
begin
  VerifyCurrentCollection(BookKey.DatabaseID);
  Assert(FBooks.Active);

  if FBooks.Locate(BOOK_ID_FIELD, BookKey.BookID, []) then
  begin
    FBooks.Edit;
    try
      FBooksFolder.Value := Folder;
      FBooks.Post;
    except
      FBooks.Cancel;
      raise ;
    end;
  end;

  // ������� ���������� � �������
  DMUser.SetFolder(BookKey, Folder);
end;

procedure TBookCollection.SetFileName(const BookKey: TBookKey; const FileName: string);
begin
  VerifyCurrentCollection(BookKey.DatabaseID);
  Assert(FBooks.Active);

  if FBooks.Locate(BOOK_ID_FIELD, BookKey.BookID, []) then
  begin
    FBooks.Edit;
    try
      FBooksFileName.Value := FileName;
      FBooks.Post;
    except
      FBooks.Cancel;
      raise ;
    end;
  end;

  // ������� ���������� � �������
  DMUser.SetFileName(BookKey, FileName);
end;

procedure TBookCollection.SetLocal(const BookKey: TBookKey; AState: Boolean);
begin
  VerifyCurrentCollection(BookKey.DatabaseID);

  if FBooks.Locate(BOOK_ID_FIELD, BookKey.BookID, []) then
  begin
    FBooks.Edit;
    try
      FBooksIsLocal.Value := AState;
      FBooks.Post;
    except
      FBooks.Cancel;
      raise ;
    end;
  end;

  DMUser.SetLocal(BookKey, AState);
end;

procedure TBookCollection.GetBookLibID(const BookKey: TBookKey; out ARes: String);
begin
  if BookKey.DatabaseID = DMUser.ActiveCollectionInfo.ID then
  begin
    Assert(FBooks.Active);

    if not FBooks.Locate(BOOK_ID_FIELD, BookKey.BookID, []) then
    begin
      Assert(False);
      Exit;
    end;

    ARes := FBooksLibID.AsString;
  end
  else
    DMUser.GetBookLibID(BookKey, ARes);
end;

// Clear contents of collection tables (except for Settings and Genres)
procedure TBookCollection.TruncateTablesBeforeImport;
const
  SQL_TRUNCATE = 'TRUNCATE TABLE %s';
  TABLE_NAMES: array [0 .. 4] of string = ('Author_List', 'Genre_List', 'Books', 'Authors', 'Series');
var
  Query: TABSQuery;
  TableName: string;
begin
  try
    MountTables(False);

    Query := TABSQueryEx.Create(FDatabase, '');
    try
      for TableName in TABLE_NAMES do
      begin
        Query.SQL.Text := Format(SQL_TRUNCATE, [TableName]);
        Query.ExecSQL;
      end;
    finally
      FreeAndNil(Query);
    end;
  finally
    MountTables(True);
  end;
end;

procedure TBookCollection.CompactDatabase;
begin
  MountTables(False);
  FDatabase.Close;

  FDatabase.CompactDatabase;

  FDatabase.Open;
  MountTables(True);

  // After this the collection is unusable and has to be reloaded
end;

procedure TBookCollection.RepairDatabase;
begin
  MountTables(False);
  FDatabase.Close;

  FDatabase.RepairDatabase;

  FDatabase.Open;
  MountTables(True);

  // After this the collection is unusable and has to be reloaded
end;

// This operation is needed, as some operations cause the datasets and field mappings to become invalid
procedure TBookCollection.MountTables(const Mounted: Boolean);
begin
  FSettings.Active := Mounted;
  FAuthors.Active := Mounted;
  FAuthorList.Active := Mounted;
  FBooks.Active := Mounted;
  FSeries.Active := Mounted;
  FGenres.Active := Mounted;
  FGenreList.Active := Mounted;

  if Mounted then
  begin
    FSettingsID := FSettings.FieldByName(ID_FIELD) as TIntegerField;
    FSettingsValue := FSettings.FieldByName(SETTING_VALIE_FIELD) as TWideMemoField;

    FAuthorsID := FAuthors.FieldByName(AUTHOR_ID_FIELD) as TIntegerField;
    FAuthorsLastName := FAuthors.FieldByName(AUTHOR_LASTTNAME_FIELD) as TWideStringField;
    FAuthorsFirstName := FAuthors.FieldByName(AUTHOR_FIRSTNAME_FIELD) as TWideStringField;
    FAuthorsMiddleName := FAuthors.FieldByName(AUTHOR_MIDDLENAME_FIELD) as TWideStringField;

    FAuthorListAuthorID := FAuthorList.FieldByName(AUTHOR_ID_FIELD) as TIntegerField;
    FAuthorListBookID := FAuthorList.FieldByName(BOOK_ID_FIELD) as TIntegerField;

    FBooksBookID := FBooks.FieldByName(BOOK_ID_FIELD) as TIntegerField;
    FBooksLibID := FBooks.FieldByName(BOOK_LIBID_FIELD) as TIntegerField;
    FBooksTitle := FBooks.FieldByName(BOOK_TITLE_FIELD) as TWideStringField;
    FBooksSeriesID := FBooks.FieldByName(SERIES_ID_FIELD) as TIntegerField;
    FBooksSeqNumber := FBooks.FieldByName(BOOK_SEQNUMBER_FIELD) as TSmallintField;
    FBooksDate := FBooks.FieldByName(BOOK_DATE_FIELD) as TDateField;
    FBooksLibRate := FBooks.FieldByName(BOOK_LIBRATE_FIELD) as TIntegerField;
    FBooksLang := FBooks.FieldByName(BOOK_LANG_FIELD) as TWideStringField;
    FBooksFolder := FBooks.FieldByName(BOOK_FOLDER_FIELD) as TWideStringField;
    FBooksFileName := FBooks.FieldByName(BOOK_FILENAME_FIELD) as TWideStringField;
    FBooksInsideNo := FBooks.FieldByName(BOOK_INSIDENO_FIELD) as TIntegerField;
    FBooksExt := FBooks.FieldByName(BOOK_EXT_FIELD) as TWideStringField;
    FBooksSize := FBooks.FieldByName(BOOK_SIZE_FIELD) as TIntegerField;
    FBooksCode := FBooks.FieldByName(BOOK_CODE_FIELD) as TSmallintField;
    FBooksIsLocal := FBooks.FieldByName(BOOK_LOCAL_FIELD) as TBooleanField;
    FBooksIsDeleted := FBooks.FieldByName(BOOK_DELETED_FIELD) as TBooleanField;
    FBooksKeyWords := FBooks.FieldByName(BOOK_KEYWORDS_FIELD) as TWideStringField;
    FBooksRate := FBooks.FieldByName(BOOK_RATE_FIELD) as TIntegerField;
    FBooksProgress := FBooks.FieldByName(BOOK_PROGRESS_FIELD) as TIntegerField;
    FBooksAnnotation := FBooks.FieldByName(BOOK_ANNOTATION_FIELD) as TWideMemoField;
    FBooksReview := FBooks.FieldByName(BOOK_REVIEW_FIELD) as TWideMemoField;

    FSeriesSeriesID := FSeries.FieldByName(SERIES_ID_FIELD) as TIntegerField;
    FSeriesSeriesTitle := FSeries.FieldByName(SERIES_TITLE_FIELD) as TWideStringField;

    FGenresGenreCode := FGenres.FieldByName(GENRE_CODE_FIELD) as TWideStringField;
    FGenresParentCode := FGenres.FieldByName(GENRE_PARENTCODE_FIELD) as TWideStringField;
    FGenresFB2Code := FGenres.FieldByName(GENRE_FB2CODE_FIELD) as TWideStringField;
    FGenresAlias := FGenres.FieldByName(GENRE_ALIAS_FIELD) as TWideStringField;

    FGenreListGenreCode := FGenreList.FieldByName(GENRE_CODE_FIELD) as TWideStringField;
    FGenreListBookID := FGenreList.FieldByName(BOOK_ID_FIELD) as TIntegerField;
  end;
end;

initialization
  BookCollectionMap := nil;

end.
