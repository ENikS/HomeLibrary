{******************************************************************************}
{                                                                              }
{                                 MyHomeLib                                    }
{                                                                              }
{                                Version 0.9                                   }
{                                20.08.2008                                    }
{                    Copyright (c) Aleksey Penkov  alex.penkov@gmail.com       }
{                                                                              }
{******************************************************************************}

unit unit_Database;

interface

uses
  DB,
  DBTables,
  Classes,
  Variants,
  SysUtils,
  ABSMain,
  unit_globals;

type
  TAbsTableHelper = class helper for TAbsTable
     constructor Create(AOwner: TComponent);
   end;

  TMHLLibrary = class(TComponent)
  private
    procedure CheckActive;
    procedure CheckInactive;

    function GetDatabaseFileName: string;
    procedure SetDatabaseFileName(const Value: string);

    function GetActive: Boolean;
    procedure SetActive(const Value: Boolean);

    procedure LoadGenres(const GenresFileName: string);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    //
    // Database creation & management
    //
    class procedure CreateSystemTables(const DBFile: string);
    procedure CreateCollectionTables(const DBFile: string; const GenresFileName: string);
    procedure ReloadDefaultGenres(const FileName: string);

    //
    // Content management
    //
    function CheckFileInCollection(const FileName: string; const Ext: string): Boolean;

    procedure InsertBook(BookRecord: TBookRecord);
    procedure DeleteBook(BookID: Integer);

    procedure AddBookGenre(BookID: Integer; const GenreCode: string);
    procedure CleanBookGenres(BookID: Integer);

    procedure GetSeries(SeriesList: TStrings);

    //
    // Bulk operation
    //
    procedure BeginBulkOperation;
    procedure EndBulkOperation(Commit: Boolean = True);

  public
    property DatabaseFileName: string read GetDatabaseFileName write SetDatabaseFileName;
    property Active: Boolean read GetActive write SetActive;

  private
    FDatabase: TAbsDataBase;
    FAuthors: TAbsTable;
    FAuthorList: TAbsTable;
    FBooks: TAbsTable;
    FSeriesList: TAbsTable;
    FSeries: TAbsTable;
    FGenres: TAbsTable;
    FGenreList: TAbsTable;
    FExtra: TAbsTable;
  end;

implementation

uses
  StrUtils, bdeconst, unit_Consts;

const
  TEMP_DATABASE = 'TempDB';
  USER_DATABASE = 'UserDB';

type
  TFieldDesc = record
    Name: string;
    DataType: TFieldType;
    Size: Integer;
    Required: Boolean;
  end;

  TIndexDesc = record
    Name: string;
    Fields: string;
    Options: TIndexOptions;
  end;

  TTableFields = array of TFieldDesc;
  TTableIndexes = array of TIndexDesc;

const
//-----------------------------------------------------------------------------
//                                 ���������
//-----------------------------------------------------------------------------
//
// Author List
//
AuthorListTableFields: array [1 .. 5] of TFieldDesc = (
  (Name: 'ID';     DataType: ftAutoInc;    Size: 0;  Required: true),
  (Name: 'AuthID'; DataType: ftInteger;    Size: 0;  Required: false),
  (Name: 'BookID'; DataType: ftInteger;    Size: 0;  Required: false),
  (Name: 'Series'; DataType: ftWideString; Size: 10; Required: false),
  (Name: 'Title';  DataType: ftWideString; Size: 10; Required: false)
);

AuthorListTableIndexes: array [1..3] of TIndexDesc = (
  (Name: 'ID_Index';  Fields: 'ID';                  Options: [ixPrimary, ixUnique]),
  (Name: 'BookIndex'; Fields: 'BookID';              Options: []),
  (Name: 'AuthIndex'; Fields: 'AuthID;Series;Title'; Options: [ixCaseInsensitive])
);

//
//  Authors
//
AuthorsTableFields: array [1 .. 5] of TFieldDesc = (
  (Name: 'ID';       DataType: ftAutoInc;    Size: 0;   Required: true),
  (Name: 'Family';   DataType: ftWideString; Size: 128; Required: true),
  (Name: 'Name';     DataType: ftWideString; Size: 128; Required: false),
  (Name: 'Middle';   DataType: ftWideString; Size: 128; Required: false),
  (Name: 'FullName'; DataType: ftWideString; Size: 255; Required: true)
);

AuthorsTableIndexes: array [1..2] of TIndexDesc = (
  (Name: 'ID_Index';      Fields: 'ID';          Options: [ixPrimary, ixUnique]),
  (Name: 'AlphabetIndex'; Fields: 'Family;Name;Middle'; Options: [])
);

//
//  NickNames
//
//NickNamesTableFields: array [1 .. 2] of TFieldDesc = (
//  (Name: 'BadID';       DataType: ftInteger;     Size: 0;   Required: true),
//  (Name: 'GoodID';       DataType: ftInteger;    Size: 0;   Required: true)
//);

//NickNamesTableIndexes: array [1..1] of TIndexDesc = (
//  (Name: 'ID_Index';      Fields: 'BadID';          Options: [ixPrimary, ixUnique])
//);



//
// Books table
//
BooksTableFields: array [1 .. 21] of TFieldDesc = (
  (Name: 'ID';         DataType: ftAutoInc;     Size: 0;   Required: true ),
  (Name: 'DatabaseID'; DataType: ftInteger;     Size: 0;   Required: false),
  (Name: 'LibID';      DataType: ftInteger;     Size: 0;   Required: false),
  (Name: 'Title';      DataType: ftWideString;  Size: 100; Required: false),
  (Name: 'FullName';   DataType: ftWideString;  Size: 255; Required: false),
  (Name: 'SerID';      DataType: ftInteger;     Size: 0;   Required: false),
  (Name: 'SeqNumber';  DataType: ftSmallInt;    Size: 0;   Required: false),
  (Name: 'Date';       DataType: ftDate;        Size: 0;   Required: false),
  (Name: 'LibRate';    DataType: ftInteger;     Size: 0;   Required: false),
  (Name: 'Lang';       DataType: ftWideString;  Size: 2;   Required: false),
  //
  (Name: 'DiscID';     DataType: ftInteger;     Size: 0;   Required: false),
  (Name: 'Folder';     DataType: ftWideString;  Size: 255; Required: false),
  (Name: 'FileName';   DataType: ftWideString;  Size: 255; Required: true ),
  (Name: 'InsideNo';   DataType: ftInteger;     Size: 0;   Required: true ),
  (Name: 'Ext';        DataType: ftWideString;  Size: 10;  Required: false),
  (Name: 'Size';       DataType: ftinteger;     Size: 0;   Required: false),
  //
  (Name: 'URI';        DataType: ftWideString;  Size: 255; Required: false),
  //
  (Name: 'Code';       DataType: ftSmallInt;    Size: 0;   Required: false),
  (Name: 'Local';      DataType: ftBoolean;     Size: 0;   Required: false),
  (Name: 'Deleted';    DataType: ftBoolean;     Size: 0;   Required: false),
  (Name: 'KeyWords';   DataType: ftWideString; Size: 255; Required: false)
);

BooksTableIndexes: array [1..6] of TIndexDesc = (
  (Name: 'ID_Index';       Fields: 'ID';                    Options: [ixPrimary, ixUnique]),
  (Name: 'Series_Index';   Fields: 'SerID;SeqNumber';       Options: []),
  (Name: 'FullName_Index'; Fields: 'Fullname;Title';        Options: []),
  (Name: 'Title_Index';    Fields: 'Title';                 Options: []),
  (Name: 'File_Index';     Fields: 'FileName';              Options: []),
  (Name: 'Folder_Index';   Fields: 'DiscID;Folder';         Options: [])
);

//
// Series List
//
SeriesListTableFields: array [1 .. 5] of TFieldDesc = (
  (Name: 'ID';     DataType: ftAutoInc;    Size: 0;  Required: true),
  (Name: 'SerID';  DataType: ftInteger;    Size: 0;  Required: true),
  (Name: 'BookID'; DataType: ftInteger;    Size: 0;  Required: true),
  (Name: 'Number'; DataType: ftInteger;    Size: 0;  Required: true),
  (Name: 'Title';  DataType: ftWideString; Size: 10; Required: true)
);

SeriesListTableIndexes: array [1..3] of TIndexDesc = (
  (Name: 'ID_Index';    Fields: 'ID';                  Options: [ixPrimary, ixUnique]),
  (Name: 'BookIndex';   Fields: 'BookID';              Options: []),
  (Name: 'SeriesIndex'; Fields: 'SerID;Title;Number'; Options: [ixCaseInsensitive])
);

//
// Series
//
SeriesTableFields: array [1 .. 4] of TFieldDesc = (
  (Name: 'ID';        DataType: ftAutoInc;    Size: 0;  Required: true),
  (Name: 'AuthID';    DataType: ftInteger;    Size: 0;  Required: true),
  (Name: 'GenreCode'; DataType: ftWideString; Size: 20; Required: true),
  (Name: 'Title';     DataType: ftWideString; Size: 80; Required: true)
);

SeriesTableIndexes: array [1..4] of TIndexDesc = (
  (Name: 'ID_Index';    Fields: 'ID';           Options: [ixPrimary, ixUnique]),
  (Name: 'TiteIndex';   Fields: 'Title;AuthID'; Options: []),
  (Name: 'AuthorIndex'; Fields: 'AuthID;Title'; Options: []),
  (Name: 'SeqTitle';    Fields: 'Title';        Options: [])
);
//
// Genres
//
GenresTableFields: array [1 .. 5] of TFieldDesc = (
  (Name: 'ID';         DataType: ftAutoInc;    Size: 0;  Required: true),
  (Name: 'Code';       DataType: ftWideString; Size: 20; Required: false),
  (Name: 'ParentCode'; DataType: ftWideString; Size: 20; Required: false),
  (Name: 'FB2Code';    DataType: ftWideString; Size: 20; Required: false),
  (Name: 'Alias';      DataType: ftWideString; Size: 50; Required: false)
);

GenresTableIndexes: array [1..4] of TIndexDesc = (
  (Name: 'ID_Index';     Fields: 'Code';            Options: [ixPrimary, ixUnique]),
  (Name: 'CodeIndex';    Fields: 'ParentCode;Code'; Options: []),
  (Name: 'FB2CodeIndex'; Fields: 'FB2Code';         Options: []),
  (Name: 'AliasIndex';   Fields: 'Alias';           Options: [])
);

//
// Genre List
//
GenreListTableFields: array [1 .. 6] of TFieldDesc = (
  (Name: 'ID';        DataType: ftAutoInc;    Size: 0;  Required: true),
  (Name: 'GenreCode'; DataType: ftWideString; Size: 30; Required: false),
  (Name: 'BookID';    DataType: ftInteger;    Size: 0;  Required: false),
  (Name: 'Family';    DataType: ftWideString; Size: 10; Required: false),
  (Name: 'Series';    DataType: ftWideString; Size: 10; Required: false),
  (Name: 'Title';     DataType: ftWideString; Size: 10; Required: false)
);

GenreListTableIndexes: array [1..3] of TIndexDesc = (
  (Name: 'ID_Index';   Fields: 'ID';                            Options: [ixPrimary, ixUnique]),
  (Name: 'BookIndex';  Fields: 'BookID';                        Options: []),
  (Name: 'GenreIndex'; Fields: 'GenreCode;Family;Series;Title'; Options: [ixCaseInsensitive])
);

//
// Extra
//
ExtraTableFields: array [1 .. 5] of TFieldDesc = (
  (Name: 'ID';        DataType: ftAutoInc;    Size: 0;   Required: true),
  (Name: 'BookID';    DataType: ftInteger;    Size: 0;   Required: false),
  (Name: 'Annotation';DataType: ftMemo;       Size: 0;   Required: false),
  (Name: 'Cover';     DataType: ftBlob;       Size: 0;   Required: false),
  (Name: 'Data';      DataType: ftMemo;       Size: 0;   Required: false)
);

ExtraTableIndexes: array [1..2] of TIndexDesc = (
  (Name: 'ID_Index';   Fields: 'ID';                   Options: [ixPrimary, ixUnique]),
  (Name: 'BookIndex';  Fields: 'BookID';               Options: [])
);

//-----------------------------------------------------------------------------
//                                 User.dbsx
//-----------------------------------------------------------------------------
//
//   Bases table
//
BasesTableFields: array [1 .. 14] of TFieldDesc = (
  (Name: 'ID';           DataType: ftInteger;    Size: 0;   Required: true),
  (Name: 'Name';         DataType: ftWideString; Size: 64;  Required: true),
  (Name: 'RootFolder';   DataType: ftWideString; Size: 128; Required: true),
  (Name: 'DBFileName';   DataType: ftWideString; Size: 128; Required: true),
  (Name: 'Notes';        DataType: ftWideString; Size: 255; Required: false),
  (Name: 'User';         DataType: ftWideString; Size: 50;  Required: false),
  (Name: 'Pass';         DataType: ftWideString; Size: 50;  Required: false),
  (Name: 'Date';         DataType: ftDate;       Size: 0;   Required: false),
  (Name: 'Version';      DataType: ftInteger;    Size: 0;   Required: false),
  (Name: 'Code';         DataType: ftInteger;    Size: 0;   Required: false),
  (Name: 'AllowDelete';  DataType: ftBoolean;    Size: 0;   Required: false),
  (Name: 'Settings';     DataType: ftMemo;       Size: 0;  Required: false),
  (Name: 'Icon';         DataType: ftBlob;       Size: 0;  Required: false),
  (Name: 'URL';          DataType: ftWideString; Size: 255; Required: false)

);

BasesTableIndexes: array [1..2] of TIndexDesc = (
  (Name: 'ID_Index';   Fields: 'ID';   Options: [ixPrimary]),
  (Name: 'Name_Index'; Fields: 'Name'; Options: [])
);

//
//  Groups List (������: ���������, �����������, � ��������� � �.�.)
//
GroupsListTableFields: array [1..5] of TFieldDesc = (
  (Name: 'ID';          DataType: ftAutoInc;    Size: 0;   Required: true),
  (Name: 'Name';        DataType: ftWideString; Size: 255; Required: false),
  (Name: 'AllowDelete'; DataType: ftBoolean;    Size: 0;   Required: false),
  (Name: 'Notes';       DataType: ftMemo;       Size: 0;   Required: false),
  (Name: 'Icon';        DataType: ftBlob;       Size: 0;   Required: false)
);

GroupsListTableIndexes: array [1..2] of TIndexDesc = (
  (Name: 'ID_Index';   Fields: 'ID';   Options: [ixPrimary, ixUnique]),
  (Name: 'NameIndex';  Fields: 'Name'; Options: [])
);

//
//  Groups table
//
GroupsTableFields: array [1 .. 25] of TFieldDesc = (
  (Name: 'ID';         DataType: ftAutoInc;    Size: 0;   Required: true),  // ��������� ���������� ID � ���� �������
  (Name: 'GroupID';    DataType: ftInteger;    Size: 0;   Required: true),  // id ������������ ������
  (Name: 'OuterID';    DataType: ftInteger;     Size: 0;   Required: false),// ������� ID ����� � ���������
  (Name: 'SerID';      DataType: ftInteger;    Size: 0;   Required: false),
  (Name: 'SeqNumber';  DataType: ftSmallInt;   Size: 0;   Required: false),
  (Name: 'DatabaseID'; DataType: ftInteger;    Size: 0;   Required: false),
  (Name: 'LibID';      DataType: ftInteger;    Size: 0;   Required: false),
  (Name: 'Date';       DataType: ftDate;       Size: 0;   Required: false),
  (Name: 'Title';      DataType: ftWideString; Size: 100; Required: false),
  (Name: 'FullName';   DataType: ftWideString; Size: 255; Required: false),
  (Name: 'InsideNo';   DataType: ftInteger;    Size: 0;   Required: true),
  (Name: 'FileName';   DataType: ftWideString; Size: 255; Required: true),
  (Name: 'Ext';        DataType: ftWideString; Size: 10;  Required: false),
  (Name: 'Size';       DataType: ftinteger;    Size: 0;   Required: false),
  (Name: 'Code';       DataType: ftSmallInt;   Size: 0;   Required: false),
  (Name: 'Folder';     DataType: ftWideString; Size: 128; Required: false),
  (Name: 'DiscID';     DataType: ftInteger;    Size: 0;   Required: false),
  (Name: 'Local';      DataType: ftBoolean;    Size: 0;   Required: false),
  (Name: 'Deleted';    DataType: ftBoolean;    Size: 0;   Required: false),
  (Name: 'Genres';     DataType: ftWideString; Size: 128; Required: false),
  (Name: 'Series';     DataType: ftWideString; Size: 128; Required: false),
  (Name: 'Rate';       DataType: ftInteger;    Size: 0;   Required: false),
  (Name: 'Progress';   DataType: ftSmallInt;   Size: 0;   Required: false),
  (Name: 'LibRate';    DataType: ftInteger;     Size: 0;   Required: false),
  (Name: 'Lang';       DataType: ftWideString;  Size: 2;   Required: false)
);

GroupsTableIndexes: array [1..4] of TIndexDesc = (
  (Name: 'ID_Index';       Fields: 'ID';               Options: [ixPrimary]),
  (Name: 'OuterID_Index'; Fields: 'GroupID;OuterID';   Options: []),
  (Name: 'FullName_Index'; Fields: 'GroupID;FullName;Series;Title'; Options: []),
  (Name: 'File_Index';     Fields: 'FileName';              Options: [])
);

//
// Rates table
//
RatesTableFields: array [1 .. 5] of TFieldDesc = (
  (Name: 'ID';         DataType: ftAutoInc; Size: 0; Required: true),
  (Name: 'BookID';     DataType: ftInteger; Size: 0; Required: true),
  (Name: 'DataBaseID'; DataType: ftInteger; Size: 0; Required: true),
  (Name: 'Rate';       DataType: ftInteger; Size: 0; Required: true),
  (Name: 'Date';       DataType: ftDate;    Size: 0; Required: false)
);

RatesTableIndexes: array [1..2] of TIndexDesc = (
  (Name: 'ID_Index';   Fields: 'ID';                Options: [ixPrimary]),
  (Name: 'Book_Index'; Fields: 'DatabaseID,BookID'; Options: [])
);

//
// finished books table
//
FinishedTableFields: array [1 .. 5] of TFieldDesc = (
  (Name: 'ID';         DataType: ftAutoInc; Size: 0; Required: true),
  (Name: 'BookID';     DataType: ftInteger; Size: 0; Required: true),
  (Name: 'DataBaseID'; DataType: ftInteger; Size: 0; Required: true),
  (Name: 'Progress';   DataType: ftSmallInt; Size: 0; Required: false),
  (Name: 'Date';       DataType: ftDate;    Size: 0; Required: false)
);

FinishedTableIndexes: array [1..2] of TIndexDesc = (
  (Name: 'ID_Index';   Fields: 'ID';                Options: [ixPrimary]),
  (Name: 'Book_Index'; Fields: 'DatabaseID,BookID,Progress'; Options: [])
);


//------------------------------------------------------------------------------


procedure CreateTable(
  ADatabase: TAbsDataBase;
  const TableName: string;
  FieldDesc: array of TFieldDesc;
  IndexDesc: array of TIndexDesc
  );
var
  TempTable: TAbsTable;
  i: Integer;
begin
  TempTable := TAbsTable.Create(ADatabase);
  try
    TempTable.TableName := TableName;

    for i := 0 to High(FieldDesc) do
      TempTable.FieldDefs.Add(
        FieldDesc[i].Name,
        FieldDesc[i].DataType,
        FieldDesc[i].Size,
        FieldDesc[i].Required
      );

    for i := 0 to High(IndexDesc) do
      TempTable.IndexDefs.Add(
        IndexDesc[i].Name,
        IndexDesc[i].Fields,
        IndexDesc[i].Options
      );

    TempTable.CreateTable;
  finally
    TempTable.Free;
  end;
end;

{ TMHLLibrary }

procedure TMHLLibrary.CheckActive;
begin
  if not Active then
     DatabaseError(SDatabaseClosed, Self);
end;

procedure TMHLLibrary.CheckInactive;
begin
  if Active then
    DatabaseError(SDatabaseOpen, Self);
end;

constructor TMHLLibrary.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FDatabase := TAbsDataBase.Create(Self);
  FDatabase.DatabaseName := TEMP_DATABASE;
  FDatabase.MaxConnections := 5;
  FDatabase.PageSize := 65535;

  FAuthors := TAbsTable.Create(FDatabase);
  FAuthors.TableName := 'Authors';

  FAuthorList := TAbsTable.Create(FDatabase);
  FAuthorList.TableName := 'Author_list';

  FBooks := TAbsTable.Create(FDatabase);
  FBooks.TableName := 'Books';

  FSeriesList := TAbsTable.Create(FDatabase);
  FSeriesList.TableName := 'SeriesList';

  FSeries := TAbsTable.Create(FDatabase);
  FSeries.TableName := 'Series';

  FGenres := TAbsTable.Create(FDatabase);
  FGenres.TableName := 'Genres';

  FGenreList := TAbsTable.Create(FDatabase);
  FGenreList.TableName := 'Genre_list';

  FExtra := TAbsTable.Create(FDatabase);
  FExtra.TableName := 'Extra';

end;

destructor TMHLLibrary.Destroy;
begin
  Active := False;
  inherited Destroy;
end;

function TMHLLibrary.GetActive: Boolean;
begin
  Result := FDatabase.Connected;
end;

procedure TMHLLibrary.SetActive(const Value: Boolean);
begin
  FDatabase.Connected := Value;

  FAuthors.Active := Value;
  FAuthorList.Active := Value;
  FBooks.Active := Value;
  FSeries.Active := Value;
  FGenres.Active := Value;
  FGenreList.Active := Value;
end;

function TMHLLibrary.GetDatabaseFileName: string;
begin
  Result := FDatabase.DatabaseFileName;
end;

procedure TMHLLibrary.SetDatabaseFileName(const Value: string);
begin
  CheckInactive;
  FDatabase.DatabaseFileName := Value;
end;

class procedure TMHLLibrary.CreateSystemTables(const DBFile: string);
var
  ADataBase: TAbsDataBase;

  Groups: TAbsTable;

begin
  ADataBase := TAbsDataBase.Create(nil);
  try
    ADataBase.DatabaseFileName := DBFile;
    ADataBase.DatabaseName := USER_DATABASE;
    ADataBase.MaxConnections := 5;
    ADataBase.PageSize := 65535;
    ADataBase.CreateDatabase;

    CreateTable(ADataBase, 'Bases',        BasesTableFields,      BasesTableIndexes);
    CreateTable(ADataBase, 'GroupsList',   GroupsListTableFields, GroupsListTableIndexes);
    CreateTable(ADataBase, 'GroupedBooks', GroupsTableFields,     GroupsTableIndexes);
    CreateTable(ADataBase, 'Rates',        RatesTableFields,      RatesTableIndexes);
    CreateTable(ADataBase, 'Finished',     FinishedTableFields,   FinishedTableIndexes);
    ADataBase.Connected := False;

    //
    // ������� ��������� ������
    //

    Groups := TAbsTable.Create(ADataBase);
    Groups.TableName := 'GroupsList';
    Groups.Active := True;

    Groups.Insert;
    Groups['Name'] := '���������';
    Groups['AllowDelete'] := False;
    Groups.Post;

    Groups.Insert;
    Groups['Name'] := '� ���������';
    Groups['AllowDelete'] := False;
    Groups.Post;
  finally
    ADataBase.Free;
  end;
end;

procedure TMHLLibrary.CreateCollectionTables(const DBFile: string; const GenresFileName: string);
begin
//  CheckInactive;

  DatabaseFileName := DBFile;
  FDatabase.CreateDatabase;

  //
  // �������� �������
  //
  CreateTable(FDatabase, 'Books',       BooksTableFields,      BooksTableIndexes);
  CreateTable(FDatabase, 'Authors',     AuthorsTableFields,    AuthorsTableIndexes);
  CreateTable(FDatabase, 'SeriesList',  SeriesListTableFields, SeriesListTableIndexes);
  CreateTable(FDatabase, 'Series',      SeriesTableFields,     SeriesTableIndexes);
  CreateTable(FDatabase, 'Genres',      GenresTableFields,     GenresTableIndexes);
  CreateTable(FDatabase, 'Genre_List',  GenreListTableFields,  GenreListTableIndexes);
  CreateTable(FDatabase, 'Author_List', AuthorListTableFields, AuthorListTableIndexes);
  CreateTable(FDatabase, 'Extra',       ExtraTableFields,      ExtraTableIndexes);

  Active := True;

  //
  // �������� ������� ������
  //
  LoadGenres(GenresFileName);

  //
  // �������� ��������� �����
  //
  FSeries.Insert;
  FSeries['Title'] := NO_SERIES_TITLE;
  FSeries['GenreCode'] := '0';
  FSeries['AuthID'] := 0;
  FSeries.Post;


end;

procedure TMHLLibrary.LoadGenres(const GenresFileName: string);
var
  FS: TStringList;
  i: Integer;
  p: Integer;
  S: string;
  ParentCode: String;
  Code: String;
  Fb2Code: String;
begin
  CheckActive;

  FS := TStringList.Create;
  try
    FS.LoadFromFile(GenresFileName,TEncoding.UTF8);

    for i := 0 to FS.Count - 1 do
    begin
      S := FS[i];
      //
      // ��������� ������ ������
      //
      if s = '' then
        Continue;

      //
      // ... � �����������
      //
      if s[1] = '#' then
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
      if FGenres.Locate('Code', Code, []) then
        Continue;

      //
      // ��� ������ => ��������� � ����
      //
      FGenres.Insert;
      FGenres['Code'] := Code;
      FGenres['ParentCode'] := ParentCode;
      FGenres['FB2Code'] := FB2Code;
      FGenres['Alias'] := S;
      FGenres.Post;
    end;
  finally
    FS.Free;
  end;
end;

procedure TMHLLibrary.ReloadDefaultGenres(const FileName: string);
begin
  CheckActive;

  //
  // ��������� ������� Genres
  //
  FGenres.Active := False;
  FGenres.EmptyTable;
  FGenres.Active := True;

  LoadGenres(FileName);
end;


{ TODO 5 -oNickR -cRefactoring :
����� ����� (� �������������� ����� ������) ���������� � �������� ���������� ���� ��� ��������.
��� ���� �������� FileName ������ ��������� ������ �������� ��� ������

Warning!  � ����� ���� �� �������� ��� ������� �� fb2!!!!
}

//function TMHLLibrary.CheckFileInCollection(const FileName: string; const Ext: string): Boolean;
//begin
//  CheckActive;
//
//  Result := FBooks.Locate(IfThen(Ext = ZIP_EXTENSION, 'Folder', 'FileName'), FileName, [])
//end;

function TMHLLibrary.CheckFileInCollection(const FileName: string; const Ext: string): Boolean;
var
  s: string;
begin
  CheckActive;

  if Ext = ZIP_EXTENSION then
    Result := FBooks.Locate('Folder', FileName, [])
  else
  begin
    s := ExtractFileName(FileName);
    s := Copy(s, 1, Length(s) - Length(Ext));
    Result := FBooks.Locate('FileName', s, []);
  end;
end;

procedure TMHLLibrary.InsertBook(BookRecord: TBookRecord);
var
  i: integer;
  ASeqNumber: Integer;
  AFullName: string;
  Genre: TGenreRecord;
  Author: TAuthorRecord;
begin
  CheckActive;

  if BookRecord.FileName = '' then
    Exit;

  BookRecord.Normalize;

  //
  // �������� ������������� �������
  //
  Assert(BookRecord.AuthorCount > 0);
  for i := 0 to BookRecord.AuthorCount - 1 do
  begin
    if not FAuthors.Locate('Family;Name;Middle', VarArrayOf([BookRecord.Authors[i].LastName, BookRecord.Authors[i].FirstName, BookRecord.Authors[i].MiddleName]), []) then
    begin
      FAuthors.Insert;
      FAuthors['Name'] := BookRecord.Authors[i].FirstName;
      FAuthors['Family'] := BookRecord.Authors[i].LastName;
      FAuthors['Middle'] := BookRecord.Authors[i].MiddleName;
      FAuthors['FullName'] := BookRecord.Authors[i].GetFullName;
      FAuthors.Post;
    end;

    //
    // � �������� ID-��
    //
    BookRecord.Authors[i].ID := FAuthors['ID'];
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
    if BookRecord.Genres[i].GenreFb2Code <> '' then
    begin
      //
      // ����� fb2-��� ����� => �������� ���������� ���
      //
      if FGenres.Locate('FB2Code', BookRecord.Genres[i].GenreFB2Code, []) then
        BookRecord.Genres[i].GenreCode := FGenres['Code']
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
      (not FGenres.Locate('Code', BookRecord.Genres[i].GenreCode,[]))  // ���������� ��� ����������
    then
      BookRecord.Genres[i].GenreCode := UNKNOWN_GENRE_CODE;
  end;

  //
  // �������� ������������� �����
  // DONE -oNickR : ����� ����� ��������� �� ������ Title, �� � AuthID?
  // � � � ����� ����� ����� ���� ����� ������ �������, �� _����_ ������� ��� ����
  // ��������, �� ������ ������ �������� � ����� �������.
  //
  // TODO -cRelease2.0 : ��������� ��������� ����� ��� ������� ������, � ������������ �� �����������
  //
  if (not FSeries.Locate('Title', BookRecord.Series, [loCaseInsensitive])) then
  begin
    FSeries.Insert;
    FSeries['Title'] := BookRecord.Series;
    FSeries['GenreCode'] := BookRecord.Genres[0].GenreCode;
    FSeries['AuthID'] := BookRecord.Authors[0].ID;
    FSeries.Post;
  end;

  //
  // ���������� �������� ���������� � �����
  //
  if not FBooks.Locate('FileName', BookRecord.FileName, []) then
  begin
    ASeqNumber := BookRecord.SeqNumber;
    if ASeqNumber > 1000 then
      ASeqNumber := 0;

    AFullName := BookRecord.Authors[0].GetFullName;

    FBooks.Insert;
    FBooks['FileName'] := BookRecord.FileName;
    FBooks['ext'] := BookRecord.FileExt;
    FBooks['Code'] := BookRecord.Code;
    FBooks['InsideNo'] := BookRecord.InsideNo;
    FBooks['Size'] := BookRecord.Size;
    FBooks['Folder'] := BookRecord.Folder;
    FBooks['DiscID'] := 0;
    FBooks['Local'] := BookRecord.Local;
    FBooks['SerID'] := FSeries['ID'];
    FBooks['Title'] := BookRecord.Title;
    FBooks['Date'] := BookRecord.Date;
    FBooks['SeqNumber'] := ASeqNumber;
    FBooks['FullName'] := AFullName;
    FBooks['LibID'] := BookRecord.LibID;
    FBooks['Date'] := BookRecord.Date;
    FBooks['Deleted'] := BookRecord.Deleted;
    FBooks['Lang'] := BookRecord.Lang;
    FBooks['LibRate'] := BookRecord.LibRate;
    FBooks['KeyWords'] := BookRecord.KeyWords;

    FBooks.Post;

    for Genre in BookRecord.Genres do
    begin
      FGenreList.Insert;
      FGenreList['BookID'] := FBooks['ID'];
      FGenreList['GenreCode'] := Genre.GenreCode;
      //
      //  ������������ ��������� ����� (�������������� �� ������ 10-�� ��������)
      //
      FGenreList['Family'] := Copy(BookRecord.Authors[0].LastName, 1, 10);
      FGenreList['Title'] := Copy(BookRecord.Title, 1, 10);
      FGenreList['Series'] := Copy(BookRecord.Series, 1, 10);
      FGenreList.Post;
    end;

    for Author in BookRecord.Authors do
    begin
      FAuthorList.Insert;
      FAuthorList['BookID'] := FBooks['ID'];
      FAuthorList['AuthID'] := Author.ID;
      //
      //  ������������ ��������� ����� (�������������� �� ������ 10-�� ��������)
      //
      FAuthorList['Title'] := Copy(BookRecord.Title, 1, 10);
      FAuthorList['Series'] := Copy(BookRecord.Series, 1, 10);
      FAuthorList.Post;
    end;
  end;
end;

procedure TMHLLibrary.DeleteBook(BookID: Integer);
var
  SerID: integer;
begin
  CheckActive;

  if FBooks.Locate('ID', BookID, []) then
  begin
    SerID := FBooks['SerID'];
    FBooks.Delete;

    { TODO -oNickR : �������� ��� ������ �� DELETE FROM query }

    while FGenreList.Locate('BookID', BookID, []) do
      FGenreList.Delete;
    while FAuthorList.Locate('BookID', BookID, []) do
      FAuthorList.Delete;

    //
    // ���� ����� ������� � ����� (SerID <> 1) ��������, �� ���� �� ������� �����.
    //
    if SerID <> 1 then
    begin
      if not FBooks.Locate('SerID', SerID, []) then
      begin
        //
        // ������ ���� �� ���� ����� ��� => ������ �����
        //
        FSeries.Locate('ID', SerID, []);
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
      if FAuthorList.Locate('AuthID', FAuthors['ID'], []) then
        FAuthors.Next
      else
        FAuthors.Delete;
    end;

    { TODO 5 -oNickR -cBug : ���������� ��������� ������� Favorites � Rates }
  end;
end;



procedure TMHLLibrary.AddBookGenre(BookID: Integer; const GenreCode: string);
begin
  CheckActive;

  if FBooks.Locate('ID', BookID, []) then
  begin
    FGenreList.Insert;
    FGenreList['BookID'] := BookID;
    FGenreList['GenreCode'] := GenreCode;
    FGenreList['Family'] := Copy(FBooks['FullName'], 1, 10);
    FGenreList['Title'] := Copy(FBooks['Title'], 1, 10);
    { TODO -oNickR -cBug : ��� ���������� ���������� ���������� ��������� ���� Series }
    //FGenreList['Series'] := Copy(Series, 1, 10);
    FGenreList.Post;
  end;
end;

procedure TMHLLibrary.CleanBookGenres(BookID: Integer);
begin
  CheckActive;

  while FGenreList.Locate('BookID', BookID, []) do
    FGenreList.Delete;
end;

procedure TMHLLibrary.GetSeries(SeriesList: TStrings);
begin
  FSeries.First;
  while not FSeries.Eof do
  begin
    if FSeries['ID'] <> 1 then
      SeriesList.Add(FSeries['Title']);
    FSeries.Next;
  end;
end;

procedure TMHLLibrary.BeginBulkOperation;
begin
  CheckActive;
  Assert(not FDatabase.InTransaction);

  FDatabase.StartTransaction;
end;

procedure TMHLLibrary.EndBulkOperation(Commit: Boolean = True);
begin
  CheckActive;
  Assert(FDatabase.InTransaction);

  if Commit then
    FDatabase.Commit(False)
  else
    FDatabase.Rollback;
end;

{ TAbsTableHelper }

constructor TAbsTableHelper.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //
  // TABSDatabase �� ����������� �� TDatabase. ��� ���������, ����������� TDataset-�
  // (�������� ������ TAbsTable) �� ����� ���������� �������� "DatabaseName".
  // ����������� ��� ���������.
  //
  if AOwner is TABSDatabase then
    DatabaseName := TABSDatabase(AOwner).DatabaseName;
end;

end.


