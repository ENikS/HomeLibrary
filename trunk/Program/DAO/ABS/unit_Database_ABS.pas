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

unit unit_Database_ABS;

interface

uses
  Classes,
  Generics.Collections,
  ABSMain,
  DB,
  UserData,
  unit_Globals,
  unit_Interfaces,
  unit_Database_Abstract;

type
  TBookCollection_ABS = class(TBookCollection)
  strict private
  type
    //-------------------------------------------------------------------------
    TBookIteratorImpl = class(TInterfacedObject, IBookIterator)
    public
      constructor Create(
        Collection: TBookCollection_ABS;
        const SystemData: ISystemData;
        const Mode: TBookIteratorMode;
        const LoadMemos: Boolean;
        const FilterValue: PFilterValue;
        const SearchCriteria: TBookSearchCriteria
      );
      destructor Destroy; override;

    protected
      // IBookIterator
      function Next(out BookRecord: TBookRecord): Boolean;
      function RecordCount: Integer;

    strict private
      FCollection: TBookCollection_ABS;
      FSystemData: ISystemData;
      FBooks: TABSQuery;
      FBookID: TIntegerField;

      FCollectionID: Integer; // Active collection's ID at the time the iterator was created
      FLoadMemos: Boolean;

      function CreateSQL(const Mode: TBookIteratorMode; const FilterValue: PFilterValue; const SearchCriteria: TBookSearchCriteria): string;
      function CreateSearchSQL(const SearchCriteria: TBookSearchCriteria): string;
    end;
    // << TBookIteratorImpl

    //-------------------------------------------------------------------------
    TAuthorIteratorImpl = class(TInterfacedObject, IAuthorIterator)
    public
      constructor Create(
        Collection: TBookCollection_ABS;
        SystemData: ISystemData;
        const Mode: TAuthorIteratorMode;
        const FilterValue: PFilterValue
      );
      destructor Destroy; override;

    protected
      // IAuthorIterator
      function Next(out AuthorData: TAuthorData): Boolean;
      function RecordCount: Integer;

    strict private
      FCollection: TBookCollection_ABS;
      FSystemData: ISystemData;
      FAuthors: TABSQuery;
      FAuthorID: TIntegerField;
      FCollectionID: Integer; // Active collection's ID at the time the iterator was created

      function CreateSQL(const Mode: TAuthorIteratorMode; const FilterValue: PFilterValue): string;
    end;
    // << TAuthorIteratorImpl

    //-------------------------------------------------------------------------
    TGenreIteratorImpl = class(TInterfacedObject, IGenreIterator)
    public
      constructor Create(Collection: TBookCollection_ABS; const SystemData: ISystemData; const Mode: TGenreIteratorMode; const FilterValue: PFilterValue);
      destructor Destroy; override;

    protected
      // IGenreIterator
      function Next(out GenreData: TGenreData): Boolean;
      function RecordCount: Integer;

    strict private
      FCollection: TBookCollection_ABS;
      FSystemData: ISystemData;
      FGenres: TABSQuery;
      FGenreCode: TWideStringField;
      FCollectionID: Integer; // Active collection's ID at the time the iterator was created

      function CreateSQL(const Mode: TGenreIteratorMode; const FilterValue: PFilterValue): string;
    end;
    // << TGenreIteratorImpl

    //-------------------------------------------------------------------------
    TSeriesIteratorImpl = class(TInterfacedObject, ISeriesIterator)
    public
      constructor Create(Collection: TBookCollection_ABS; const SystemData: ISystemData; const Mode: TSeriesIteratorMode);
      destructor Destroy; override;

    protected
      //
      // ISeriesIterator
      //
      function Next(out SeriesData: TSeriesData): Boolean;
      function RecordCount: Integer;

    strict private
      FCollection: TBookCollection_ABS;
      FSystemData: ISystemData;
      FSeries: TABSQuery;
      FSeriesID: TIntegerField;
      FSeriesTitle: TWideStringField;
      FCollectionID: Integer; // Active collection's ID at the time the iterator was created

      function CreateSQL(const Mode: TSeriesIteratorMode): string;
    end;
    // << TSeriesIteratorImpl

  protected
    procedure InsertGenreIfMissing(const GenreData: TGenreData); override;
    procedure InternalLoadGenres;

  public
    constructor Create(const DBCollectionFile: string; const SystemData: ISystemData; ADefaultSession: Boolean = True);
    destructor Destroy; override;

    procedure ReloadGenres(const FileName: string); override;

    procedure SetStringProperty(const PropID: Integer; const Value: string); override;

    //
    // Content management
    //
    function CheckFileInCollection(const FileName: string; const FullNameSearch: Boolean; const ZipFolder: Boolean): Boolean; override;

    function InsertBook(BookRecord: TBookRecord; const CheckFileName: Boolean; const FullCheck: Boolean): Integer; override;
    procedure DeleteBook(const BookKey: TBookKey); override;
    procedure GetBookRecord(const BookKey: TBookKey; out BookRecord: TBookRecord; const LoadMemos: Boolean); override;

    //
    // ����������� � �������� �����
    //
    procedure CleanBookAuthors(const BookID: Integer); override;
    procedure InsertBookAuthors(const BookID: Integer; const Authors: TBookAuthors); override;

    //
    // ����������� � ������� �����
    //
    procedure CleanBookGenres(const BookID: Integer); override;
    procedure InsertBookGenres(const BookID: Integer; const Genres: TBookGenres); override;

    //
    // Bulk operation
    //
    procedure BeginBulkOperation; override;
    procedure EndBulkOperation(Commit: Boolean = True); override;

    // Iterators:
    function GetBookIterator(const Mode: TBookIteratorMode; const LoadMemos: Boolean; const FilterValue: PFilterValue = nil): IBookIterator; override;
    function Search(const SearchCriteria: TBookSearchCriteria; const LoadMemos: Boolean): IBookIterator; override;
    function GetAuthorIterator(const Mode: TAuthorIteratorMode; const FilterValue: PFilterValue = nil): IAuthorIterator; override;
    function GetGenreIterator(const Mode: TGenreIteratorMode; const FilterValue: PFilterValue = nil): IGenreIterator; override;
    function GetSeriesIterator(const Mode: TSeriesIteratorMode): ISeriesIterator; override;

    procedure SetSeriesTitle(const SeriesID: Integer; const NewSeriesTitle: string); override;
    function FindOrCreateSeries(const Title: string): Integer; override;
    procedure ChangeBookSeriesID(const OldSeriesID: Integer; const NewSeriesID: Integer; const DatabaseID: Integer); override;
    procedure ImportUserData(data: TUserData; guiUpdateCallback: TGUIUpdateExtraProc); override;
    procedure ExportUserData(data: TUserData); override;
    procedure GetStatistics(out AuthorsCount: Integer; out BooksCount: Integer; out SeriesCount: Integer); override;
    procedure UpdateBook(BookRecord: TBookRecord); override;
    function SetReview(const BookKey: TBookKey; const Review: string): Integer; override;
    function GetReview(const BookKey: TBookKey): string; override;
    procedure SetProgress(const BookKey: TBookKey; const Progress: Integer); override;
    procedure SetRate(const BookKey: TBookKey; const Rate: Integer); override;
    procedure SetSeriesID(const BookKey: TBookKey; const SeriesID: Integer); override;
    procedure SetFolder(const BookKey: TBookKey; const Folder: string); override;
    procedure SetFileName(const BookKey: TBookKey; const FileName: string); override;
    procedure SetLocal(const BookKey: TBookKey; const AState: Boolean); override;
    function GetLibID(const BookKey: TBookKey): string; override; // deprecated;
    procedure TruncateTablesBeforeImport; override;

    procedure CompactDatabase; override;
    procedure RepairDatabase; override;

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
    procedure MountTables(const Mounted: Boolean);
    procedure GetAuthor(AuthorID: Integer; var Author: TAuthorData);
    function GetSeriesTitle(SeriesID: Integer): string;
  end;

  procedure CreateCollectionTables_ABS(const DBCollectionFile: string; const GenresFileName: string);

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
  unit_Settings,
  unit_ABSUtils,
  unit_Database,
  unit_SystemDatabase;

const
  COLLECTION_DATABASE = 'CollectionDB';

// ------------------------------------------------------------------------------

procedure CreateCollectionTables_ABS(const DBCollectionFile: string; const GenresFileName: string);
var
  ADatabase: TABSDatabase;
  createScript: TStream;
  createQuery: TABSQuery;

  ALibrary: IBookCollection;
begin
  ADatabase := TABSDatabase.Create(nil);
  try
    ADatabase.DatabaseFileName := DBCollectionFile;
    ADatabase.DatabaseName := COLLECTION_DATABASE + '_' + IntToStr(Integer(Pointer(ADatabase)));
    ADatabase.MaxConnections := 5;
    ADatabase.PageSize := 65535;
    ADatabase.PageCountInExtent := 16;

    ADatabase.CreateDatabase;

    createScript := TResourceStream.Create(HInstance, 'CreateCollectionDB_ABS', RT_RCDATA);
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
  ALibrary := TBookCollection_ABS.Create(DBCollectionFile, GetSystemData);

  // Fill metadata version and creation date:
  ALibrary.SetStringProperty(SETTING_VERSION, DATABASE_VERSION);
  ALibrary.SetStringProperty(SETTING_CREATION_DATE, FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now));

  //
  // �������� ������� ������
  //
  ALibrary.LoadGenres(GenresFileName);
end;

// ------------------------------------------------------------------------------

{ TBookIteratorImpl }

constructor TBookCollection_ABS.TBookIteratorImpl.Create(
  Collection: TBookCollection_ABS;
  const SystemData: ISystemData;
  const Mode: TBookIteratorMode;
  const LoadMemos: Boolean;
  const FilterValue: PFilterValue;
  const SearchCriteria: TBookSearchCriteria
);
var
  pLogger: IIntervalLogger;
begin
  inherited Create;

  Assert(Assigned(Collection));
  Assert(Assigned(SystemData));

  FLoadMemos := LoadMemos;
  FCollection := Collection;
  FSystemData := SystemData;
  FCollectionID := FSystemData.GetActiveCollectionInfo.ID;

  FBooks := TABSQueryEx.Create(FCollection.FDatabase, CreateSQL(Mode, FilterValue, SearchCriteria));
  FBooks.ReadOnly := True;
  FBooks.RequestLive := True;

  pLogger := GetIntervalLogger('TBookIteratorImpl.Create', FBooks.SQL.Text);
  FBooks.Active := True;
  pLogger := nil;

  FBookID := FBooks.FieldByName(BOOK_ID_FIELD) as TIntegerField;
end;

destructor TBookCollection_ABS.TBookIteratorImpl.Destroy;
begin
  FreeAndNil(FBooks);

  inherited Destroy;
end;

// Read next record (if present), return True if read
function TBookCollection_ABS.TBookIteratorImpl.Next(out BookRecord: TBookRecord): Boolean;
begin
  Result := not FBooks.Eof;

  if Result then
  begin
    Assert(FSystemData.GetActiveCollectionInfo.ID = FCollectionID); // shouldn't happen
    FCollection.GetBookRecord(CreateBookKey(FBookID.Value, FCollectionID), BookRecord, FLoadMemos);
    FBooks.Next;
  end;
end;

function TBookCollection_ABS.TBookIteratorImpl.RecordCount: Integer;
begin
  Result := FBooks.RecordCount;
end;

function TBookCollection_ABS.TBookIteratorImpl.CreateSQL(
  const Mode: TBookIteratorMode;
  const FilterValue: PFilterValue;
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
    begin
      Assert(Assigned(FilterValue));
      Result :=
        'SELECT b.' + BOOK_ID_FIELD + ' FROM Genre_List gl INNER JOIN Books b ON gl.' + BOOK_ID_FIELD + ' = b.' + BOOK_ID_FIELD + ' ';
      if isFB2Collection(FSystemData.GetActiveCollectionInfo.CollectionType) or not Settings.ShowSubGenreBooks then
        AddToWhere(Where, Format('gl.GenreCode = ''%s''', [FilterValue^.ValueString]))
      else
        AddToWhere(Where, Format('gl.GenreCode LIKE ''%s%''', [FilterValue^.ValueString]));
    end;

    bmByAuthor:
    begin
      Assert(Assigned(FilterValue));
      Result :=
        'SELECT b.' + BOOK_ID_FIELD + ' FROM Author_List al INNER JOIN Books b ON al.' + BOOK_ID_FIELD + ' = b.' + BOOK_ID_FIELD + ' ';
      AddToWhere(Where, Format('al.AuthorID = %d ', [FilterValue^.ValueInt]));
    end;

    bmBySeries:
    begin
      Assert(Assigned(FilterValue));
      Result := 'SELECT b.' + BOOK_ID_FIELD + ' FROM Books b ';
      AddToWhere(Where, Format('b.SeriesID = %d ', [FilterValue^.ValueInt]));
    end;

    bmSearch:
    begin
      Assert(not Assigned(FilterValue));
      Result := CreateSearchSQL(SearchCriteria);
    end
    else
      Assert(False);
  end;

  if Mode in [bmByGenre, bmByAuthor, bmBySeries] then
  begin
    if FCollection.GetHideDeleted then
      AddToWhere(Where, ' b.' + BOOK_DELETED_FIELD + ' = False ');
    if FCollection.GetShowLocalOnly then
      AddToWhere(Where, ' b.' + BOOK_LOCAL_FIELD + ' = True ');
  end;

  Result := Result + Where;
  // + ' ORDER BY ' + BOOK_ID_FIELD; // Order fo result consistency
end;

// Original code was extracted from TfrmMain.DoApplyFilter
function TBookCollection_ABS.TBookIteratorImpl.CreateSearchSQL(const SearchCriteria: TBookSearchCriteria): string;
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

constructor TBookCollection_ABS.TAuthorIteratorImpl.Create(
  Collection: TBookCollection_ABS;
  SystemData: ISystemData;
  const Mode: TAuthorIteratorMode;
  const FilterValue: PFilterValue
);
var
  pLogger: IIntervalLogger;
begin
  inherited Create;

  Assert(Assigned(Collection));
  Assert(Assigned(SystemData));

  FCollection := Collection;
  FSystemData := SystemData;
  FCollectionID := FSystemData.GetActiveCollectionInfo.ID;


  FAuthors := TABSQueryEx.Create(FCollection.FDatabase, CreateSQL(Mode, FilterValue));
  FAuthors.ReadOnly := True;
  FAuthors.RequestLive := True;

  pLogger := GetIntervalLogger('TAuthorIteratorImpl.Create', FAuthors.SQL.Text);
  FAuthors.Active := True;
  pLogger := nil;

  FAuthorID := FAuthors.FieldByName(AUTHOR_ID_FIELD) as TIntegerField;
end;

destructor TBookCollection_ABS.TAuthorIteratorImpl.Destroy;
begin
  FreeAndNil(FAuthors);

  inherited Destroy;
end;

// Read next record (if present), return True if read
function TBookCollection_ABS.TAuthorIteratorImpl.Next(out AuthorData: TAuthorData): Boolean;
begin
  Result := not FAuthors.Eof;

  if Result then
  begin
    Assert(FSystemData.GetActiveCollectionInfo.ID = FCollectionID); // shouldn't happen
    FCollection.GetAuthor(FAuthorID.Value, AuthorData);
    FAuthors.Next;
  end;
end;

function TBookCollection_ABS.TAuthorIteratorImpl.RecordCount: Integer;
begin
  Result := FAuthors.RecordCount;
end;

function TBookCollection_ABS.TAuthorIteratorImpl.CreateSQL(
  const Mode: TAuthorIteratorMode;
  const FilterValue: PFilterValue
): string;
var
  Where: string;
begin
  Where := '';

  case Mode of
    amAll:
      Result := 'SELECT a.' + AUTHOR_ID_FIELD + ' FROM Authors a ';

    amByBook:
      begin
        Assert(Assigned(FilterValue));
        Result := 'SELECT DISTINCT a.' + AUTHOR_ID_FIELD + ' FROM Author_List a ';
        AddToWhere(Where, Format('a.%s = %u', [BOOK_ID_FIELD, FilterValue^.ValueInt]));
      end;

    amFullFilter:
      begin
        Result := 'SELECT DISTINCT a.' + AUTHOR_ID_FIELD + ' FROM Authors a ';
        if FCollection.GetHideDeleted or FCollection.GetShowLocalOnly then
        begin
          Result := Result + ' INNER JOIN Author_List al ON a.' + AUTHOR_ID_FIELD + ' = al.' + AUTHOR_ID_FIELD + ' INNER JOIN Books b ON al.' + BOOK_ID_FIELD + ' = b.' + BOOK_ID_FIELD + ' ';
          if FCollection.GetHideDeleted then
            AddToWhere(Where, ' b.' + BOOK_DELETED_FIELD + ' = False ');
          if FCollection.GetShowLocalOnly then
            AddToWhere(Where, ' b.' + BOOK_LOCAL_FIELD + ' = True ');
        end;

        // Add an author type filter:
        if FCollection.GetAuthorFilterType <> '' then
        begin
          if FCollection.GetAuthorFilterType = ALPHA_FILTER_NON_ALPHA then
          begin
            AddToWhere(Where, Format(
              '(POS(UPPER(SUBSTRING(a.%0:s, 1, 1)), "%1:s") = 0) AND (POS(UPPER(SUBSTRING(a.%0:s, 1, 1)), "%2:s") = 0)',
              [AUTHOR_LASTTNAME_FIELD, ENGLISH_ALPHABET, RUSSIAN_ALPHABET]
            ));
          end
          else if FCollection.GetAuthorFilterType <> ALPHA_FILTER_ALL then
          begin
            Assert(Length(FCollection.GetAuthorFilterType) = 1);
            Assert(TCharacter.IsUpper(FCollection.GetAuthorFilterType, 1));
            AddToWhere(Where, Format(
              'UPPER(a.%0:s) LIKE "%1:s%%"',                                // ���������� �� �������� �����
              [AUTHOR_LASTTNAME_FIELD, FCollection.GetAuthorFilterType]
            ));
          end;
        end;
      end;

    else
      Assert(False);
  end;

  Result := Result + Where;

  if Mode in [amAll, amFullFilter] then
    Result := Result + ' ORDER BY a.' + AUTHOR_LASTTNAME_FIELD + ', a.' + AUTHOR_FIRSTNAME_FIELD + ', a.' + AUTHOR_MIDDLENAME_FIELD + ' ';
end;

{ TGenreIteratorImpl }

constructor TBookCollection_ABS.TGenreIteratorImpl.Create(Collection: TBookCollection_ABS; const SystemData: ISystemData; const Mode: TGenreIteratorMode; const FilterValue: PFilterValue);
var
  pLogger: IIntervalLogger;
begin
  inherited Create;

  Assert(Assigned(Collection));
  Assert(Assigned(SystemData));

  FCollection := Collection;
  FSystemData := SystemData;
  FCollectionID := FSystemData.GetActiveCollectionInfo.ID;

  FGenres := TABSQueryEx.Create(FCollection.FDatabase, CreateSQL(Mode, FilterValue));
  FGenres.ReadOnly := True;
  FGenres.RequestLive := True;

  pLogger := GetIntervalLogger('TGenreIteratorImpl.Create', FGenres.SQL.Text);
  FGenres.Active := True;
  pLogger := nil;

  FGenreCode := FGenres.FieldByName(GENRE_CODE_FIELD) as TWideStringField;
end;

destructor TBookCollection_ABS.TGenreIteratorImpl.Destroy;
begin
  FreeAndNil(FGenres);

  inherited Destroy;
end;

// Read next record (if present), return True if read
function TBookCollection_ABS.TGenreIteratorImpl.Next(out GenreData: TGenreData): Boolean;
begin
  Result := not FGenres.Eof;

  if Result then
  begin
    Assert(FSystemData.GetActiveCollectionInfo.ID = FCollectionID); // shouldn't happen
    FCollection.GetGenre(FGenreCode.Value, GenreData);
    FGenres.Next;
  end;
end;

function TBookCollection_ABS.TGenreIteratorImpl.RecordCount: Integer;
begin
  Result := FGenres.RecordCount;
end;

function TBookCollection_ABS.TGenreIteratorImpl.CreateSQL(const Mode: TGenreIteratorMode; const FilterValue: PFilterValue): string;
var
  Where: string;
begin
  Where := '';

  case Mode of
    gmAll:
      Result := 'SELECT g.GenreCode FROM Genres g ';
    gmByBook:
    begin
      Assert(Assigned(FilterValue));
      Result := 'SELECT gl.GenreCode FROM Genre_List gl ';
      AddToWhere(Where, Format('gl.BookID = %d',[FilterValue^.ValueInt]) );
    end
    else
      Assert(False);
  end;

  Result := Result + Where;
end;

{ TSeriesIteratorImpl }

constructor TBookCollection_ABS.TSeriesIteratorImpl.Create(Collection: TBookCollection_ABS; const SystemData: ISystemData; const Mode: TSeriesIteratorMode);
var
  pLogger: IIntervalLogger;
begin
  inherited Create;

  Assert(Assigned(Collection));
  Assert(Assigned(SystemData));

  FCollection := Collection;
  FSystemData := SystemData;
  FCollectionID := FSystemData.GetActiveCollectionInfo.ID;

  FSeries := TABSQueryEx.Create(FCollection.FDatabase, CreateSQL(Mode));
  FSeries.ReadOnly := True;
  FSeries.RequestLive := True;

  pLogger := GetIntervalLogger('TSeriesIteratorImpl.Create', FSeries.SQL.Text);
  FSeries.Active := True;
  pLogger := nil;

  FSeriesID := FSeries.FieldByName(SERIES_ID_FIELD) as TIntegerField;
  FSeriesTitle := FSeries.FieldByName(SERIES_TITLE_FIELD) as TWideStringField;
end;

destructor TBookCollection_ABS.TSeriesIteratorImpl.Destroy;
begin
  FreeAndNil(FSeries);

  inherited Destroy;
end;

// Read next record (if present), return True if read
function TBookCollection_ABS.TSeriesIteratorImpl.Next(out SeriesData: TSeriesData): Boolean;
begin
  Result := not FSeries.Eof;

  if Result then
  begin
    Assert(FSystemData.GetActiveCollectionInfo.ID = FCollectionID); // shouldn't happen
    SeriesData.SeriesID := FSeriesID.Value;
    SeriesData.SeriesTitle := FSeriesTitle.Value;
    FSeries.Next;
  end;
end;

function TBookCollection_ABS.TSeriesIteratorImpl.RecordCount: Integer;
begin
  Result := FSeries.RecordCount;
end;

function TBookCollection_ABS.TSeriesIteratorImpl.CreateSQL(const Mode: TSeriesIteratorMode): string;
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
      if FCollection.GetHideDeleted or FCollection.GetShowLocalOnly then
      begin
        Result := Result + ' INNER JOIN Books b ON s.' + SERIES_ID_FIELD + ' = b.' + SERIES_ID_FIELD + ' ';
        if FCollection.GetHideDeleted then
          AddToWhere(Where, ' b.' + BOOK_DELETED_FIELD + ' = False ');
        if FCollection.GetShowLocalOnly then
          AddToWhere(Where, ' b.' + BOOK_LOCAL_FIELD + ' = True ');
      end;

      // Series type filter
      if FCollection.GetSeriesFilterType <> '' then
      begin
        if FCollection.GetSeriesFilterType = ALPHA_FILTER_NON_ALPHA then
          AddToWhere(Where, Format(
            '(POS(UPPER(SUBSTRING(s.%0:s, 1, 1)), "%1:s") = 0) AND (POS(UPPER(SUBSTRING(s.%0:s, 1, 1)), "%2:s") = 0)',
            [SERIES_TITLE_FIELD, ENGLISH_ALPHABET, RUSSIAN_ALPHABET]
          ))
        else if FCollection.GetSeriesFilterType <> ALPHA_FILTER_ALL then
        begin
          Assert(Length(FCollection.GetSeriesFilterType) = 1);
          Assert(TCharacter.IsUpper(FCollection.GetSeriesFilterType, 1));
          AddToWhere(Where, Format(
            'UPPER(s.%0:s) LIKE "%1:s%%"',                                // ���������� �� �������� �����
            [SERIES_TITLE_FIELD, FCollection.GetSeriesFilterType]
          ));
        end;
      end;
    end
    else
      Assert(False);
  end;

  Result := Result + Where;
  Result := Result + ' ORDER BY s.' + SERIES_TITLE_FIELD;
end;

{ TABSBookCollection }

constructor TBookCollection_ABS.Create(const DBCollectionFile: string; const SystemData: ISystemData; ADefaultSession: Boolean = True);
begin
  inherited Create(SystemData);

  FDefaultSession := ADefaultSession;

  //
  // TODO: ���� ��������� ��������� � ��������� ������, �� ���������� ������� ��������� ��������� � SystemData
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

destructor TBookCollection_ABS.Destroy;
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

procedure TBookCollection_ABS.SetStringProperty(const PropID: Integer; const Value: string);
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

procedure TBookCollection_ABS.InsertGenreIfMissing(const GenreData: TGenreData);
begin
  Assert(FGenres.Active);

  //
  // ���� ����� ���� ��� ���������� => ��������� ���
  //
  { TODO -oNickR : ����� ����� ��������� � ��������� ����? }
  if FGenreCache.HasGenre(GenreData.GenreCode) then
    Exit;

  //
  // ��� ������ => ��������� � ����
  //
  FGenres.Insert;
  try
    FGenresGenreCode.Value := GenreData.GenreCode;
    FGenresParentCode.Value := GenreData.ParentCode;
    FGenresFB2Code.Value := GenreData.FB2GenreCode;
    FGenresAlias.Value := GenreData.GenreAlias;
    FGenres.Post;

    FGenreCache.Add(GenreData);
  except
    FGenres.Cancel;
    raise;
  end;
end;

procedure TBookCollection_ABS.ReloadGenres(const FileName: string);
begin
  Assert(FGenres.Active);

  //
  // ��������� ������� Genres
  //
  FGenres.Active := False;
  FGenres.EmptyTable;
  FGenreCache.Clear;
  FGenres.Active := True;

  LoadGenres(FileName);
end;

function TBookCollection_ABS.CheckFileInCollection(const FileName: string; const FullNameSearch: Boolean; const ZipFolder: Boolean): Boolean;
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

function TBookCollection_ABS.InsertBook(BookRecord: TBookRecord; const CheckFileName: Boolean; const FullCheck: Boolean): Integer;
var
  i: Integer;
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
      BookRecord.Genres[i] := FGenreCache.ByFB2Code[BookRecord.Genres[i].FB2GenreCode]
    else
      BookRecord.Genres[i] := FGenreCache[BookRecord.Genres[i].GenreCode];
  end;

  //
  // �������� ������������� �����
  //
  if NO_SERIES_TITLE = BookRecord.Series then
  begin
    BookRecord.SeriesID := NO_SERIES_ID;
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
      if NO_SERIES_ID <> BookRecord.SeriesID then
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
    InsertBookAuthors(FBooksBookID.Value, BookRecord.Authors);

    Result := FBooksBookID.Value;
  end;
end;

procedure TBookCollection_ABS.DeleteBook(const BookKey: TBookKey);
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
    CleanBookGenres(BookKey.BookID);
    CleanBookAuthors(BookKey.BookID);

    //
    // ���� ����� ������� � ����� (SeriesID <> 1) ��������, �� ���� �� ������� �����.
    //
    if SeriesID <> NO_SERIES_ID then
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

    FSystemData.DeleteBook(BookKey);
  end;
end;

procedure TBookCollection_ABS.GetBookRecord(const BookKey: TBookKey; out BookRecord: TBookRecord; const LoadMemos: Boolean);
begin
  BookRecord.Clear;

  if BookKey.DatabaseID = FSystemData.GetActiveCollectionInfo.ID then
  begin
    Assert(FBooks.Active);

    if not FBooks.Locate(BOOK_ID_FIELD, BookKey.BookID, []) then
    begin
      Assert(False);
      Exit;
    end;

    BookRecord.BookKey.BookID := FBooksBookID.Value;
    BookRecord.BookKey.DatabaseID := FSystemData.GetActiveCollectionInfo.ID;
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
    BookRecord.CollectionRoot := FSystemData.GetActiveCollectionInfo.RootPath;
    BookRecord.CollectionName := FSystemData.GetActiveCollectionInfo.Name;

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
    FSystemData.GetBookRecord(BookKey, BookRecord);
end;

procedure TBookCollection_ABS.CleanBookAuthors(const BookID: Integer);
begin
  Assert(FAuthorList.Active);

  while FAuthorList.Locate(BOOK_ID_FIELD, BookID, []) do
    FAuthorList.Delete;
end;

procedure TBookCollection_ABS.InsertBookAuthors(const BookID: Integer; const Authors: TBookAuthors);
var
  insertedIds: TList<Integer>;
  Author: TAuthorData;
begin
  insertedIds := TList<Integer>.Create;
  try
    for Author in Authors do
    begin
      if -1 = insertedIds.IndexOf(Author.AuthorID) then
      begin
        FAuthorList.Append;
        try
          FAuthorListAuthorID.Value := Author.AuthorID;
          FAuthorListBookID.Value := FBooksBookID.Value;

          FAuthorList.Post;
          insertedIds.Add(Author.AuthorID);
        except
          FAuthorList.Cancel;
          raise;
        end;
      end;
    end;
  finally
    insertedIds.Free;
  end;
end;

procedure TBookCollection_ABS.CleanBookGenres(const BookID: Integer);
begin
  Assert(FGenreList.Active);

  while FGenreList.Locate(BOOK_ID_FIELD, BookID, []) do
    FGenreList.Delete;
end;

// Add book genres for the book specified by BookID
procedure TBookCollection_ABS.InsertBookGenres(const BookID: Integer; const Genres: TBookGenres);
var
  insertedCodes: TList<string>;
  Genre: TGenreData;
begin
  Assert(FGenreList.Active);

  insertedCodes := TList<string>.Create;
  try
    for Genre in Genres do
    begin
      if -1 = insertedCodes.IndexOf(Genre.GenreCode) then
      begin
        FGenreList.Append;
        try
          FGenreListBookID.Value := BookID;
          FGenreListGenreCode.Value := Genre.GenreCode;

          FGenreList.Post;
          insertedCodes.Add(Genre.GenreCode);
        except
          FGenreList.Cancel;
          raise;
        end;
      end;
    end;
  finally
    insertedCodes.Free;
  end;
end;

procedure TBookCollection_ABS.BeginBulkOperation;
begin
  Assert(not FDatabase.InTransaction);

  FDatabase.StartTransaction;
end;

procedure TBookCollection_ABS.EndBulkOperation(Commit: Boolean = True);
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
function TBookCollection_ABS.GetBookIterator(const Mode: TBookIteratorMode; const LoadMemos: Boolean; const FilterValue: PFilterValue = nil): IBookIterator;
var
  EmptySearchCriteria: TBookSearchCriteria;
begin
  Result := TBookIteratorImpl.Create(Self, FSystemData, Mode, LoadMemos, FilterValue, EmptySearchCriteria);
end;

function TBookCollection_ABS.Search(const SearchCriteria: TBookSearchCriteria; const LoadMemos: Boolean): IBookIterator;
begin
  Result := TBookIteratorImpl.Create(Self, FSystemData, bmSearch, LoadMemos, nil, SearchCriteria);
end;

function TBookCollection_ABS.GetAuthorIterator(const Mode: TAuthorIteratorMode; const FilterValue: PFilterValue): IAuthorIterator;
begin
  Result := TAuthorIteratorImpl.Create(Self, FSystemData, Mode, FilterValue);
end;

function TBookCollection_ABS.GetGenreIterator(const Mode: TGenreIteratorMode; const FilterValue: PFilterValue = nil): IGenreIterator;
begin
  Result := TGenreIteratorImpl.Create(Self, FSystemData, Mode, FilterValue);
end;

function TBookCollection_ABS.GetSeriesIterator(const Mode: TSeriesIteratorMode): ISeriesIterator;
begin
  Result := TSeriesIteratorImpl.Create(Self, FSystemData, Mode);
end;

procedure TBookCollection_ABS.InternalLoadGenres;
var
  Genre: TGenreData;
begin
  FGenreCache.Clear;

  FGenres.First;
  while not FGenres.Eof do
  begin
    Genre.GenreCode := FGenresGenreCode.Value;
    Genre.ParentCode := FGenresParentCode.Value;
    Genre.FB2GenreCode := FGenresFB2Code.Value;
    Genre.GenreAlias := FGenresAlias.Value;

    FGenreCache.Add(Genre);

    FGenres.Next;
  end;
end;

procedure TBookCollection_ABS.GetAuthor(AuthorID: Integer; var Author: TAuthorData);
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

function TBookCollection_ABS.GetSeriesTitle(SeriesID: Integer): string;
begin
  if (NO_SERIES_ID <> SeriesID) and FSeries.Locate(SERIES_ID_FIELD, SeriesID, []) then
    Result := FSeriesSeriesTitle.Value
  else
    Result := NO_SERIES_TITLE;
end;

procedure TBookCollection_ABS.SetSeriesTitle(const SeriesID: Integer; const NewSeriesTitle: string);
begin
  Assert(FSeries.Active);
  Assert(SeriesID <> NO_SERIES_ID);
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
function TBookCollection_ABS.FindOrCreateSeries(const Title: string): Integer;
begin
  Assert(FSeries.Active);

  if NO_SERIES_TITLE = Title then
  begin
    Result := NO_SERIES_ID;
    Exit;
  end;

  if not FSeries.Locate(SERIES_TITLE_FIELD, Title, []) then
  begin
    FSeries.Append;
    try
      FSeriesSeriesTitle.Value := Title;
      FSeries.Post;
    except
      FSeries.Cancel;
      raise ;
    end;
  end;
  Result := FSeriesSeriesID.Value;
end;

// Change SeriesID value for all books in the current database with old SeriesID value
procedure TBookCollection_ABS.ChangeBookSeriesID(const OldSeriesID: Integer; const NewSeriesID: Integer; const DatabaseID: Integer);
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

  if NO_SERIES_ID = NewSeriesID then
    newSerie := 'NULL'
  else
    newSerie := Format('%u', [NewSeriesID]);

  if NO_SERIES_ID = OldSeriesID then
    oldSerie := 'IS NULL'
  else
    oldSerie := Format('= %u', [NewSeriesID]);

  Query := TABSQueryEx.Create(FDatabase, Format(UPDATE_SQL, [newSerie, oldSerie]));
  try
    pLogger := GetIntervalLogger('TABSBookCollection.ChangeBookSeriesID', Query.SQL.Text);
    Query.ExecSQL;
    pLogger := nil;
  finally
    FreeAndNil(Query);
  end;

  // ������� ���������� � �������
  FSystemData.ChangeBookSeriesID(OldSeriesID, NewSeriesID, DatabaseID);
end;

procedure TBookCollection_ABS.ImportUserData(data: TUserData; guiUpdateCallback: TGUIUpdateExtraProc);
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
      BookKey := CreateBookKey(FBooksBookID.Value, FSystemData.GetActiveCollectionInfo.ID);
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
    FSystemData.SetExtra(BookKey, extra);

    //
    // ����� ����������� �������� ���� �������� ���������� ����
    //
    guiUpdateCallback(BookKey, extra);
  end;

  //
  // �������� ���������������� ������
  //
  FSystemData.ImportUserData(data);

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

procedure TBookCollection_ABS.ExportUserData(data: TUserData);
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

  FSystemData.ExportUserData(data);
end;

procedure TBookCollection_ABS.GetStatistics(out AuthorsCount: Integer; out BooksCount: Integer; out SeriesCount: Integer);
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
procedure TBookCollection_ABS.UpdateBook(BookRecord: TBookRecord);
begin
  VerifyCurrentCollection(BookRecord.BookKey.DatabaseID);
  Assert(FBooks.Active);

  if FBooks.Locate(BOOK_ID_FIELD, BookRecord.BookKey.BookID, []) then
  begin

  end;

  FSystemData.UpdateBook(BookRecord);
end;

function TBookCollection_ABS.SetReview(const BookKey: TBookKey; const Review: string): Integer;
var
  NewReview: string;
begin
  VerifyCurrentCollection(BookKey.DatabaseID);
  Assert(FBooks.Active);

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
  Result := Result or FSystemData.SetReview(BookKey, NewReview);
end;

function TBookCollection_ABS.GetReview(const BookKey: TBookKey): string;
begin
  if BookKey.DatabaseID = FSystemData.GetActiveCollectionInfo.ID then
  begin
    Assert(FBooks.Active);
    if FBooks.Locate(BOOK_ID_FIELD, BookKey.BookID, []) then
      Result := FBooksReview.Value
    else
      Result := '';
  end
  else
    Result := FSystemData.GetReview(BookKey);
end;

procedure TBookCollection_ABS.SetProgress(const BookKey: TBookKey; const Progress: Integer);
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
  FSystemData.SetProgress(BookKey, Progress);
end;

procedure TBookCollection_ABS.SetRate(const BookKey: TBookKey; const Rate: Integer);
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
  FSystemData.SetRate(BookKey, Rate);
end;

procedure TBookCollection_ABS.SetSeriesID(const BookKey: TBookKey; const SeriesID: Integer);
begin
  VerifyCurrentCollection(BookKey.DatabaseID);
  Assert(FBooks.Active);

  FBooks.Locate(BOOK_ID_FIELD, BookKey.BookID, []);
  FBooks.Edit;
  try
    if NO_SERIES_ID = SeriesID then
      FBooksSeriesID.Clear
    else
      FBooksSeriesID.Value := SeriesID;
    FBooks.Post;
  except
    FBooks.Cancel;
    raise ;
  end;

  // ������� ���������� � �������
  FSystemData.SetBookSeriesID(BookKey, SeriesID);
end;

procedure TBookCollection_ABS.SetFolder(const BookKey: TBookKey; const Folder: string);
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
  FSystemData.SetFolder(BookKey, Folder);
end;

procedure TBookCollection_ABS.SetFileName(const BookKey: TBookKey; const FileName: string);
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
  FSystemData.SetFileName(BookKey, FileName);
end;

procedure TBookCollection_ABS.SetLocal(const BookKey: TBookKey; const AState: Boolean);
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

  FSystemData.SetLocal(BookKey, AState);
end;

function TBookCollection_ABS.GetLibID(const BookKey: TBookKey): string;
begin
  if BookKey.DatabaseID = FSystemData.GetActiveCollectionInfo.ID then
  begin
    Assert(FBooks.Active);

    if not FBooks.Locate(BOOK_ID_FIELD, BookKey.BookID, []) then
    begin
      Assert(False);
      Result := '';
      Exit;
    end;

    Result := FBooksLibID.AsString;
  end
  else
    FSystemData.GetBookLibID(BookKey, Result);
end;

// Clear contents of collection tables (except for Settings and Genres)
procedure TBookCollection_ABS.TruncateTablesBeforeImport;
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

procedure TBookCollection_ABS.CompactDatabase;
begin
  MountTables(False);
  FDatabase.Close;

  FDatabase.CompactDatabase;

  FDatabase.Open;
  MountTables(True);

  // After this the collection is unusable and has to be reloaded
end;

procedure TBookCollection_ABS.RepairDatabase;
begin
  MountTables(False);
  FDatabase.Close;

  FDatabase.RepairDatabase;

  FDatabase.Open;
  MountTables(True);

  // After this the collection is unusable and has to be reloaded
end;

// This operation is needed, as some operations cause the datasets and field mappings to become invalid
procedure TBookCollection_ABS.MountTables(const Mounted: Boolean);
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

    InternalLoadGenres;
  end
  else
  begin
    FGenreCache.Clear;
  end;
end;

end.
