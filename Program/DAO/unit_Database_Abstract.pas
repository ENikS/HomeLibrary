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

unit unit_Database_Abstract;

interface

uses
  Classes,
  Generics.Collections,
  UserData,
  unit_Globals,
  unit_Interfaces;

type
  TBookCollection = class abstract (TInterfacedObject, IBookCollection)
  public // virtual
    //
    // IBookCollection
    //

    // Iterators:
    function GetAuthorIterator(const Mode: TAuthorIteratorMode; const FilterValue: PFilterValue = nil): IAuthorIterator; virtual; abstract;
    function GetGenreIterator(const Mode: TGenreIteratorMode; const FilterValue: PFilterValue = nil): IGenreIterator; virtual; abstract;
    function GetSeriesIterator(const Mode: TSeriesIteratorMode): ISeriesIterator; virtual; abstract;
    function GetBookIterator(const Mode: TBookIteratorMode; const LoadMemos: Boolean; const FilterValue: PFilterValue = nil): IBookIterator; virtual; abstract;
    function Search(const SearchCriteria: TBookSearchCriteria; const LoadMemos: Boolean): IBookIterator; virtual; abstract;

    //
    //
    //
    function InsertBook(BookRecord: TBookRecord; const CheckFileName: Boolean; const FullCheck: Boolean): Integer; virtual; abstract;
    procedure GetBookRecord(const BookKey: TBookKey; out BookRecord: TBookRecord; const LoadMemos: Boolean); virtual; abstract;
    procedure UpdateBook(const BookRecord: TBookRecord); virtual; abstract;
    procedure DeleteBook(const BookKey: TBookKey); virtual; abstract;
    procedure AddBookToGroup(const BookKey: TBookKey; const GroupID: Integer);

    function GetLibID(const BookKey: TBookKey): string; virtual; abstract; // deprecated;
    function GetReview(const BookKey: TBookKey): string; virtual; abstract;

    function SetReview(const BookKey: TBookKey; const Review: string): Integer; virtual; abstract;
    procedure SetProgress(const BookKey: TBookKey; const Progress: Integer); virtual; abstract;
    procedure SetRate(const BookKey: TBookKey; const Rate: Integer); virtual; abstract;
    procedure SetLocal(const BookKey: TBookKey; const AState: Boolean); virtual; abstract;
    procedure SetFolder(const BookKey: TBookKey; const Folder: string); virtual; abstract;
    procedure SetFileName(const BookKey: TBookKey; const FileName: string); virtual; abstract;
    procedure SetSeriesID(const BookKey: TBookKey; const SeriesID: Integer); virtual; abstract;

    procedure CleanBookGenres(const BookID: Integer); virtual; abstract;
    procedure InsertBookGenres(const BookID: Integer; var Genres: TBookGenres); virtual; abstract;

    function FindOrCreateSeries(const Title: string): Integer; virtual; abstract;
    procedure SetSeriesTitle(const SeriesID: Integer; const NewTitle: string); virtual; abstract;
    procedure ChangeBookSeriesID(const OldID: Integer; const NewID: Integer; const DatabaseID: Integer); virtual; abstract;

    procedure SetStringProperty(const PropID: Integer; const Value: string); virtual; abstract;
    procedure SetIntProperty(const PropID: Integer; const Value: Integer);

    procedure ImportUserData(data: TUserData; guiUpdateCallback: TGUIUpdateExtraProc); virtual; abstract;
    procedure ExportUserData(data: TUserData); virtual; abstract;

    function CheckFileInCollection(const FileName: string; const FullNameSearch: Boolean; const ZipFolder: Boolean): Boolean; virtual; abstract;
    function GetTopGenreAlias(const FB2Code: string): string; virtual; abstract;

    //
    // Bulk operation
    //
    procedure BeginBulkOperation; virtual; abstract;
    procedure EndBulkOperation(Commit: Boolean = True); virtual; abstract;

    procedure CompactDatabase; virtual; abstract;
    procedure RepairDatabase; virtual; abstract;
    procedure ReloadGenres(const FileName: string); virtual; abstract;
    procedure GetStatistics(out AuthorsCount: Integer; out BooksCount: Integer; out SeriesCount: Integer); virtual; abstract;

    procedure TruncateTablesBeforeImport; virtual; abstract;

  protected // virtual
    procedure InsertGenreIfMissing(const GenreData: TGenreData); virtual; abstract;

  public
    procedure VerifyCurrentCollection(const DatabaseID: Integer);
    procedure LoadGenres(const GenresFileName: string);

  protected
    constructor Create;
    destructor Destroy; override;

    procedure FilterDuplicateAuthorsByID(var Authors: TBookAuthors);
    procedure FilterDuplicateGenresByCode(var Genres: TBookGenres);

    procedure GetGenre(const GenreCode: string; var Genre: TGenreData);
    procedure GetBookGenres(BookID: Integer; var BookGenres: TBookGenres; RootGenre: PGenreData = nil);
    procedure GetBookAuthors(BookID: Integer; var BookAuthors: TBookAuthors);

  strict protected
    FAuthorFilterType: string;
    FSeriesFilterType: string;
    FShowLocalOnly: Boolean;
    FHideDeleted: Boolean;
    FGenreCache: TDictionary<string, TGenreData>;

  public
    property HideDeleted: Boolean read FHideDeleted write FHideDeleted;
    property ShowLocalOnly: Boolean read FShowLocalOnly write FShowLocalOnly;
    property SeriesFilterType: string read FSeriesFilterType write FSeriesFilterType;
    property AuthorFilterType: string read FAuthorFilterType write FAuthorFilterType;
  end;

resourcestring
  rstrFavoritesGroupName = '���������';
  rstrToReadGroupName = '� ���������';

const
  DATABASE_VERSION = '1000';

implementation

uses
  SysUtils,
  dm_user,
  unit_Errors,
  unit_Consts;

{ TBookCollection }

procedure TBookCollection.SetIntProperty(const PropID: Integer; const Value: Integer);
begin
  if Value = 0 then
    Exit;

  SetStringProperty(PropID, IntToStr(Value));
end;

procedure TBookCollection.LoadGenres(const GenresFileName: string);
var
  FS: TStringList;
  i: Integer;
  p: Integer;
  S: string;
  Genre: TGenreData;
begin
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
      Genre.GenreCode := Copy(S, 1, p - 1);
      Delete(S, 1, p);

      //
      // � ��� ������������� �������� (0)
      //
      p := LastDelimiter('.', Genre.GenreCode);
      if 0 = p then
        Continue;
      Genre.ParentCode := Copy(Genre.GenreCode, 1, p - 1);

      //
      // fb2 ���. ����� �������������! (sf)
      //
      Genre.FB2GenreCode := '';
      p := AnsiPos(';', S);
      if 0 <> p then
      begin
        Genre.FB2GenreCode := Copy(S, 1, p - 1);
        Delete(S, 1, p);
      end;

      Genre.GenreAlias := S;

      //
      // ���� ����� ���� ��� ���������� => ��������� ���
      //
      InsertGenreIfMissing(Genre);
    end;
  finally
    FS.Free;
  end;
end;

// Filter out duplicates by author ID
constructor TBookCollection.Create;
begin
  inherited Create;
  FGenreCache := TDictionary<string, TGenreData>.Create;
end;

destructor TBookCollection.Destroy;
begin
  FreeAndNil(FGenreCache);
  inherited Destroy;
end;

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

procedure TBookCollection.GetBookGenres(BookID: Integer; var BookGenres: TBookGenres; RootGenre: PGenreData = nil);
var
  i: Integer;
  GenreIterator: IGenreIterator;
  Genre: TGenreData;
  FilterValue: TFilterValue;
begin
  FilterValue.ValueInt := BookID;
  GenreIterator := GetGenreIterator(gmByBook, @FilterValue); //Format('gl.%s = %d', [BOOK_ID_FIELD, BookID])
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

procedure TBookCollection.GetGenre(const GenreCode: string; var Genre: TGenreData);
begin
  if not FGenreCache.TryGetValue(GenreCode, Genre) then
    Genre.Clear;
end;

procedure TBookCollection.GetBookAuthors(BookID: Integer; var BookAuthors: TBookAuthors);
var
  AuthorIterator: IAuthorIterator;
  i: Integer;
  FilterValue: TFilterValue;
  Author: TAuthorData;
begin
  FilterValue.ValueInt := BookID;
  AuthorIterator := GetAuthorIterator(amByBook, @FilterValue);
  i := Length(BookAuthors);
  while AuthorIterator.Next(Author) do
  begin
    SetLength(BookAuthors, i + 1);
    BookAuthors[i] := Author;
    Inc(i);
  end;
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

procedure TBookCollection.AddBookToGroup(const BookKey: TBookKey; const GroupID: Integer);
var
  BookRecord: TBookRecord;
begin
  VerifyCurrentCollection(BookKey.DatabaseID);

  GetBookRecord(BookKey, BookRecord, True);

  DMUser.AddBookToGroup(BookKey, GroupID, BookRecord);
end;

end.
