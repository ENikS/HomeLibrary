(* *****************************************************************************
  *
  * MyHomeLib
  *
  * Copyright (C) 2008-2010 Aleksey Penkov
  *
  * Authors             Aleksey Penkov   alex.penkov@gmail.com
  *                     Nick Rymanov     nrymanov@gmail.com
  * Created             
  * Description         
  *
  * $Id$
  *
  * History
  * NickR 02.03.2010    ��� ����������������
  *
  ****************************************************************************** *)

unit dm_user;

interface

uses
  Classes,
  DB,
  ABSMain,
  unit_Globals,
  ImgList,
  Controls,
  unit_Consts,
  UserData;

type
  TCollectionProp = (cpDisplayName, cpFileName, cpRootFolder);

  TMHLActiveCollection = class;
  TMHLCollection = class;

  TDMUser = class(TDataModule)
    DBUser: TABSDatabase;

    tblBases: TABSTable;
    tblBasesID: TAutoIncField;
    tblBasesBaseName: TWideStringField;
    tblBasesRootFolder: TWideStringField;
    tblBasesDBFileName: TWideStringField;
    tblBasesNotes: TWideStringField;
    tblBasesDate: TDateField;
    tblBasesVersion: TIntegerField;
    tblBasesCode: TIntegerField;
    tblBasesAllowDelete: TBooleanField;
    tblBasesSettings: TWideMemoField;
    tblBasesIcon: TBlobField;
    tblBasesURL: TWideStringField;
    tblBasesUser: TWideStringField;
    tblBasesPass: TWideStringField;
    tblBasesConnection: TWideMemoField;

    Groups: TABSTable;
    GroupsGroupID: TAutoIncField;
    GroupsGroupName: TWideStringField;
    GroupsAllowDelete: TBooleanField;
    GroupsNotes: TMemoField;
    GroupsIcon: TBlobField;
    dsGroups: TDataSource;

    GroupBooks: TABSTable;
    GroupBooksGroupID: TIntegerField;
    GroupBooksBookID: TIntegerField;
    GroupBooksDatabaseID: TIntegerField;
    dsBookGroups: TDataSource;

    BooksByGroup: TABSTable;
    BooksByGroupBookID: TIntegerField;
    BooksByGroupDatabaseID: TIntegerField;
    BooksByGroupFolder: TWideStringField;
    BooksByGroupFileName: TWideStringField;
    BooksByGroupInsideNo: TIntegerField;
    BooksByGroupExt: TWideStringField;
    BooksByGroupLibID: TIntegerField;

    AllBooks: TABSTable;
    AllBooksBookID: TIntegerField;
    AllBooksDatabaseID: TIntegerField;
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
    AllBooksAnnotation: TWideMemoField;
    AllBooksReview: TWideMemoField;
    AllBooksRate: TIntegerField;
    AllBooksProgress: TSmallintField;

    ClearQuery: TABSQuery;

    AllBookGroups: TABSTable;
    AllBookGroupsBookID: TIntegerField;
    AllBookGroupsDatabaseID: TIntegerField;
    AllBookGroupsGroupID: TIntegerField;
    AllBooksExtraInfo: TBlobField;

    SeverityImages: TImageList;
    SeverityImagesBig: TImageList;

  private
    FActiveCollection: TMHLActiveCollection;
    FCollection: TMHLCollection;

  private
    function InternalFindGroup(const GroupName: string): Boolean; overload; inline;
    function InternalFindGroup(GroupID: Integer): Boolean; overload; inline;
    function InternalAddGroup(const GroupName: string; out GroupID: Integer): Boolean;
    procedure InternalClearGroup(GroupID: Integer; RemoveGroup: Boolean);

  public const
    INVALID_COLLECTION_ID = -1;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function SelectCollection(CollectionID: Integer): Boolean;
    function ActivateCollection(CollectionID: Integer): Boolean;

    procedure RegisterCollection(
      const DisplayName: string;
      const RootFolder: string;
      const DBFileName: string;
      CollectionType: COLLECTION_TYPE;
      AllowDelete: Boolean;
      Version: Integer = UNVERSIONED_COLLECTION;
      const Notes: string = '';
      const URL: string = '';
      const Script: string = '';
      const User: string = '';
      const Password: string = ''
    );

    function FindCollectionWithProp(
      PropID: TCollectionProp;
      const Value: string;
      IgnoreID: Integer = INVALID_COLLECTION_ID
    ): Boolean;

    procedure DeleteCollection(CollectionID: Integer);

    procedure SetTableState(State: Boolean);

  public
    procedure GetBookLibID(BookID: Integer; DatabaseID: Integer; out ARes: string); deprecated;

    //
    // Active Collection
    //
    property ActiveCollection: TMHLActiveCollection read FActiveCollection;
    property CurrentCollection: TMHLCollection read FCollection;

    function FindFirstExternalCollection: Boolean;
    function FindNextExternalCollection: Boolean;

    function FindFirstCollection: Boolean;
    function FindNextCollection: Boolean;

    function ActivateGroup(const ID: Integer): Boolean;

    procedure CorrectExtra(OldID, NewID: Integer);

    //
    //
    //
    procedure GetBookRecord(BookID: Integer; DatabaseID: Integer; var BookRecord: TBookRecord);

    procedure SetExtra(BookID: Integer; DatabaseID: Integer; extra: TBookExtra);
    procedure SetRate(BookID: Integer; DatabaseID: Integer; Rate: Integer);
    procedure SetProgress(BookID: Integer; DatabaseID: Integer; Progress: Integer);
    function GetAnnotation(BookID: Integer; DatabaseID: Integer): string;
    procedure SetAnnotation(BookID: Integer; DatabaseID: Integer; const Annotation: string);
    function GetReview(BookID: Integer; DatabaseID: Integer): string;
    function SetReview(BookID: Integer; DatabaseID: Integer; const Review: string): Integer;
    procedure SetLocal(BookID: Integer; DatabaseID: Integer; Value: Boolean);

    //
    // ������ � ��������
    //
    function AddGroup(const GroupName: string): Boolean;
    function RenameGroup(GroupID: Integer; const NewName: string): Boolean;
    procedure DeleteGroup(GroupID: Integer);
    procedure ClearGroup(GroupID: Integer);

    procedure AddBookToGroup(BookID: Integer; DatabaseID: Integer; GroupID: Integer; const BookRecord: TBookRecord);
    procedure DeleteFromGroup(BookID: Integer; DatabaseID: Integer; GroupID: Integer);
    procedure RemoveUnusedBooks;
    procedure CopyBookToGroup(
      BookID: Integer; DatabaseID: Integer;
      SourceGroupID: Integer;
      TargetGroupID: Integer;
      MoveBook: Boolean
    );

    //
    // ���������������� ������
    //
    procedure ExportUserData(data: TUserData);
    procedure ImportUserData(data: TUserData);
  end;

  TMHLCollection = class
  private
    FSysDataModule: TDMUser;

    function GetActive: Boolean;

    function GetID: Integer;

    function GetName: string;
    procedure SetName(const Value: string);

    function GetRootFolder: string;
    procedure SetRootFolder(const Value: string);

    function GetDBFileName: string;
    procedure SetDBFileName(const Value: string);

    function GetNotes: string;
    procedure SetNotes(const Value: string);

    function GetUser: string;
    procedure SetUser(const Value: string);

    function GetPassword: string;
    procedure SetPassword(const Value: string);

    function GetCreationDate: TDateTime;
    procedure SetCreationDate(const Value: TDateTime);

    function GetVersion: Integer;
    procedure SetVersion(const Value: Integer);

    function GetCollectionType: COLLECTION_TYPE;
    procedure SetCollectionType(const Value: COLLECTION_TYPE);

    function GetAllowDelete: Boolean;
    procedure SetAllowDelete(const Value: Boolean);

    function GetURL: string;
    procedure SetURL(const Value: string);

    function GetScript: string;
    procedure SetScript(const Value: string);

  public
    procedure Edit;
    procedure Save;
    procedure Cancel;

    property Active: Boolean read GetActive;

    property ID: Integer read GetID;
    property Name: string read GetName write SetName;
    property RootFolder: string read GetRootFolder write SetRootFolder;
    property DBFileName: string read GetDBFileName write SetDBFileName;
    property Notes: string read GetNotes write SetNotes;
    property CreationDate: TDateTime read GetCreationDate {write SetCreationDate};
    property Version: Integer read GetVersion write SetVersion;
    property CollectionType: COLLECTION_TYPE read GetCollectionType {write SetCollectionType};
    property AllowDelete: Boolean read GetAllowDelete {write SetAllowDelete};
    property User: string read GetUser write SetUser;
    property Password: string read GetPassword write SetPassword;
    property URL: string read GetURL write SetURL;
    property Script: string read GetScript write SetScript;
  end;

  TMHLActiveCollection = class(TObject)
  private
    FID: Integer;
    FName: string;
    FRootFolder: string;
    FDBFileName: string;
    FNotes: string;
    FUser: string;
    FPassword: string;
    FCreationDate: TDateTime;
    FVersion: Integer;
    FCollectionType: COLLECTION_TYPE;
    FAllowDelete: Boolean;
    FURL: string;
    FScript: string;
    function GetRootPath: string;

  public
    constructor Create;

    procedure Clear;

    property ID: Integer read FID;
    property Name: string read FName;
    property RootFolder: string read FRootFolder;
    property RootPath: string read GetRootPath;
    property DBFileName: string read FDBFileName;
    property Notes: string read FNotes;
    property CreationDate: TDateTime read FCreationDate;
    property Version: Integer read FVersion;
    property CollectionType: COLLECTION_TYPE read FCollectionType;
    property AllowDelete: Boolean read FAllowDelete;
    property User: string read FUser;
    property Password: string read FPassword;
    property URL: string read FURL;
    property Script: string read FScript;
  end;

var
  DMUser: TDMUser;

implementation

uses
  SysUtils,
  StrUtils,
  IOUtils,
  Variants,
  dm_Collection;

resourcestring
  rstrNamelessColection = '���������� ���������';
  rstrUnknownCollection = '����������� ���������';

{$R *.dfm}

{ TDMUser }

procedure TDMUser.GetBookLibID(BookID: Integer; DatabaseID: Integer; out ARes: String);
begin
  Assert(AllBooks.Active);

  if not AllBooks.Locate(BOOK_ID_FIELD, BookID, []) then
  begin
    Assert(False);
    Exit;
  end;

  ARes := AllBooksLibID.AsString;
end;

function TDMUser.ActivateGroup(const ID: Integer): Boolean;
begin
  Result := Groups.Locate(GROUP_ID_FIELD, ID, []);
end;

procedure TDMUser.CorrectExtra(OldID, NewID: Integer);
begin
  if BooksByGroup.Locate(BOOK_ID_DB_ID_FIELDS, VarArrayOf([OldID, CurrentCollection.GetID]), []) then
  begin
    BooksByGroup.Edit;
    BooksByGroupBookID.Value := NewID;
    BooksByGroup.Post;
  end;
end;

constructor TDMUser.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FActiveCollection := TMHLActiveCollection.Create;

  FCollection := TMHLCollection.Create;
  FCollection.FSysDataModule := Self;
end;

destructor TDMUser.Destroy;
begin
  FreeAndNil(FCollection);
  FreeAndNil(FActiveCollection);
  inherited Destroy;
end;

procedure TDMUser.RegisterCollection(
  const DisplayName: string;
  const RootFolder: string;
  const DBFileName: string;
  CollectionType: COLLECTION_TYPE;
  AllowDelete: Boolean;
  Version: Integer;
  const Notes: string;
  const URL: string;
  const Script: string;
  const User: string;
  const Password: string
  );
begin
  //
  // ������������ ���������
  //
  tblBases.Insert;
  tblBasesBaseName.Value := DisplayName;
  tblBasesRootFolder.Value := RootFolder;
  tblBasesDBFileName.Value := DBFileName;
  tblBasesCode.Value := CollectionType;
  tblBasesDate.Value := Now;
  tblBasesVersion.Value := Version;
  tblBasesAllowDelete.Value := AllowDelete;
  tblBasesNotes.Value := Notes;
  tblBasesUser.Value := User;
  tblBasesPass.Value := Password;
  tblBasesURL.Value := URL;
  tblBasesConnection.Value := Script;
  tblBases.Post;
end;

function TDMUser.SelectCollection(CollectionID: Integer): Boolean;
begin
  Result := tblBases.Locate(ID_FIELD, CollectionID, []);
end;

function TDMUser.ActivateCollection(CollectionID: Integer): Boolean;
begin
  Result := SelectCollection(CollectionID);
  if Result then
  begin
    FActiveCollection.FID := CollectionID;
    FActiveCollection.FName := tblBasesBaseName.Value;
    FActiveCollection.FRootFolder := tblBasesRootFolder.Value;
    FActiveCollection.FDBFileName := tblBasesDBFileName.Value;
    FActiveCollection.FNotes := tblBasesNotes.Value;
    FActiveCollection.FUser := tblBasesUser.Value;
    FActiveCollection.FPassword := tblBasesPass.Value;
    FActiveCollection.FCreationDate := tblBasesDate.Value;
    if tblBasesVersion.IsNull then
      FActiveCollection.FVersion := UNVERSIONED_COLLECTION
    else
      FActiveCollection.FVersion := tblBasesVersion.Value;
    FActiveCollection.FCollectionType := tblBasesCode.Value;
    if tblBasesAllowDelete.IsNull then
      FActiveCollection.FAllowDelete := True
    else
      FActiveCollection.FAllowDelete := tblBasesAllowDelete.Value;
    FActiveCollection.FURL := tblBasesURL.Value;
    FActiveCollection.FScript := tblBasesConnection.Value;
  end
  else
    FActiveCollection.Clear;
end;

function TDMUser.FindCollectionWithProp(PropID: TCollectionProp; const Value: string; IgnoreID: Integer): Boolean;
const
  Fields: array [TCollectionProp] of string = (BASE_NAME_FIELD, 'DBFileName', 'RootFolder');
begin
  Result := False;
  if tblBases.IsEmpty then
    Exit;

  tblBases.First;
  while not tblBases.Eof do
  begin
    if tblBases.FieldByName(Fields[PropID]).AsString = Value then
    begin
      if (IgnoreID = INVALID_COLLECTION_ID) or (IgnoreID <> tblBasesID.Value) then
      begin
        Result := True;
        Exit;
      end;
    end;

    tblBases.Next;
  end;
end;

function TDMUser.FindFirstCollection: Boolean;
begin
  Result := False;
  if tblBases.IsEmpty then
    Exit;

  tblBases.First;
end;

function TDMUser.FindFirstExternalCollection: Boolean;
begin
  Result := False;
  if tblBases.IsEmpty then
    Exit;

  tblBases.First;
  while not tblBases.Eof do
  begin
    if isExternalCollection(CurrentCollection.CollectionType) then
    begin
      Result := True;
      Exit;
    end;

    tblBases.Next;
  end;
end;

function TDMUser.FindNextCollection: Boolean;
begin
  tblBases.Next;
  Result := not tblBases.Eof;
end;

function TDMUser.FindNextExternalCollection: Boolean;
begin
  tblBases.Next;

  while not tblBases.Eof do
  begin
    if isExternalCollection(CurrentCollection.CollectionType) then
    begin
      Result := True;
      Exit;
    end;

    tblBases.Next;
  end;

  Result := False;
end;

procedure TDMUser.DeleteCollection(CollectionID: Integer);
begin
  Assert(False, 'Not implemented yet!');
  //
  // 1. ������� ��� ����� ���� ��������� �� �����
  // 2. ������� ���������
  //
end;

procedure TDMUser.SetTableState(State: Boolean);
begin
  tblBases.Active := State;
  Groups.Active := State;
  GroupBooks.Active := State;
  BooksByGroup.Active := State;
  AllBooks.Active := State;
  AllBookGroups.Active := State;
end;

procedure TDMUser.GetBookRecord(BookID: Integer; DatabaseID: Integer; var BookRecord: TBookRecord);
var
  Stream: TABSBlobStream;
  Reader: TReader;
  Author: TAuthorData;
  Genre: TGenreData;
begin
  Assert(AllBooks.Active);
  if AllBooks.Locate(BOOK_ID_DB_ID_FIELDS, VarArrayOf([BookID, DatabaseID]), []) then
  begin
    BookRecord.Title := AllBooksTitle.Value;
    BookRecord.Folder := AllBooksFolder.Value;
    BookRecord.FileName := AllBooksFileName.Value;
    BookRecord.FileExt := AllBooksExt.Value;
    BookRecord.InsideNo := AllBooksInsideNo.Value;
    BookRecord.SerieID := AllBooksSerieID.Value;
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

    BookRecord.Review := AllBooksReview.Value;
    BookRecord.Annotation := AllBooksAnnotation.Value;
    BookRecord.Rate := AllBooksRate.Value;
    BookRecord.Progress := AllBooksProgress.Value;

    Stream := TABSBlobStream.Create(AllBooksExtraInfo, bmRead);
    try
      Reader := TReader.Create(Stream, 4096);
      try
        BookRecord.Serie := Reader.ReadString;

        Reader.ReadListBegin;
        while not Reader.EndOfList do
        begin
          Author.LastName := Reader.ReadString;
          Author.FirstName := Reader.ReadString;
          Author.MiddleName := Reader.ReadString;
          Author.AuthorID := Reader.ReadInteger;

          TAuthorsHelper.Add(
            BookRecord.Authors,
            Author.LastName,
            Author.FirstName,
            Author.MiddleName,
            Author.AuthorID
          );
        end;
        Reader.ReadListEnd;

        Reader.ReadListBegin;
        while not Reader.EndOfList do
        begin
          Genre.GenreCode := Reader.ReadString;
          Genre.FB2GenreCode := Reader.ReadString;
          Genre.GenreAlias := Reader.ReadString;

          TGenresHelper.Add(
            BookRecord.Genres,
            Genre.GenreCode,
            Genre.GenreAlias,
            Genre.FB2GenreCode
          );
        end;
        Reader.ReadListEnd;
      finally
        Reader.Free;
      end;
    finally
      Stream.Free;
    end;

    if SelectCollection(DatabaseID) then
    begin
      BookRecord.CollectionName := CurrentCollection.Name;
      BookRecord.CollectionRootFolder := CurrentCollection.RootFolder;
    end
    else
      BookRecord.CollectionName := rstrUnknownCollection;
  end
  else
    Assert(False);
end;

procedure TDMUser.SetExtra(BookID: Integer; DatabaseID: Integer; extra: TBookExtra);
begin
  Assert(AllBooks.Active);
  if AllBooks.Locate(BOOK_ID_DB_ID_FIELDS, VarArrayOf([BookID, DatabaseID]), []) then
  begin
    AllBooks.Edit;
    if extra.Rating <> 0 then
      AllBooksRate.Value := extra.Rating;
    if extra.Progress <> 0 then
      AllBooksProgress.Value := extra.Progress;
    if extra.Review <> '' then
      AllBooksAnnotation.Value := extra.Review;
    AllBooks.Post;
  end;
end;

procedure TDMUser.SetRate(BookID: Integer; DatabaseID: Integer; Rate: Integer);
begin
  Assert(AllBooks.Active);
  if AllBooks.Locate(BOOK_ID_DB_ID_FIELDS, VarArrayOf([BookID, DatabaseID]), []) then
  begin
    AllBooks.Edit;
    AllBooksRate.Value := Rate;
    AllBooks.Post;
  end;
end;

procedure TDMUser.SetProgress(BookID: Integer; DatabaseID: Integer; Progress: Integer);
begin
  Assert(AllBooks.Active);
  if AllBooks.Locate(BOOK_ID_DB_ID_FIELDS, VarArrayOf([BookID, DatabaseID]), []) then
  begin
    AllBooks.Edit;
    AllBooksProgress.Value := Progress;
    AllBooks.Post;
  end;
end;

function TDMUser.GetAnnotation(BookID: Integer; DatabaseID: Integer): string;
begin
  Assert(AllBooks.Active);
  if AllBooks.Locate(BOOK_ID_DB_ID_FIELDS, VarArrayOf([BookID, DatabaseID]), []) then
    Result := AllBooksAnnotation.Value
  else
    Result := '';
end;

procedure TDMUser.SetAnnotation(BookID: Integer; DatabaseID: Integer; const Annotation: string);
begin
  Assert(AllBooks.Active);
  if AllBooks.Locate(BOOK_ID_DB_ID_FIELDS, VarArrayOf([BookID, DatabaseID]), []) then
  begin
    AllBooks.Edit;
    if Annotation = '' then
      AllBooksAnnotation.Clear
    else
      AllBooksAnnotation.Value := Annotation;
    AllBooks.Post;
  end;
end;

function TDMUser.GetReview(BookID: Integer; DatabaseID: Integer): string;
begin
  Assert(AllBooks.Active);
  if AllBooks.Locate(BOOK_ID_DB_ID_FIELDS, VarArrayOf([BookID, DatabaseID]), []) then
    Result := AllBooksReview.Value
  else
    Result := '';
end;

function TDMUser.SetReview(BookID: Integer; DatabaseID: Integer; const Review: string): Integer;
begin
  Assert(AllBooks.Active);
  Result := 0;
  if AllBooks.Locate(BOOK_ID_DB_ID_FIELDS, VarArrayOf([BookID, DatabaseID]), []) then
  begin
    AllBooks.Edit;
    if Review = '' then
    begin
      AllBooksReview.Clear;
      AllBooksCode.Value := 0;
    end
    else
    begin
      AllBooksReview.Value := Review;
      AllBooksCode.Value := 1;
      Result := 1;
    end;
    AllBooks.Post;
  end;
end;

procedure TDMUser.SetLocal(BookID: Integer; DatabaseID: Integer; Value: Boolean);
begin
  Assert(AllBooks.Active);
  if AllBooks.Locate(BOOK_ID_DB_ID_FIELDS, VarArrayOf([BookID, DatabaseID]), []) then
  begin
    AllBooks.Edit;
    AllBooksLocal.Value := Value;
    AllBooks.Post;
  end;
end;

//
// ������� ������
//
function TDMUser.AddGroup(const GroupName: string): Boolean;
var
  GroupID: Integer;
begin
  Result := InternalAddGroup(GroupName, GroupID);
end;

function TDMUser.RenameGroup(GroupID: Integer; const NewName: string): Boolean;
begin
  Result := False;
  if InternalFindGroup(GroupID) then
  begin
    Groups.Edit;
    try
      GroupsGroupName.Value := NewName;
      Groups.Post;

      Result := True;
    except
      Groups.Cancel;
    end;
  end;
end;

function TDMUser.InternalFindGroup(const GroupName: string): Boolean;
begin
  Result := Groups.Locate(GROUP_NAME_FIELD, GroupName, []);
end;

function TDMUser.InternalFindGroup(GroupID: Integer): Boolean;
begin
  Result := Groups.Locate(GROUP_ID_FIELD, GroupID, []);
end;

//
// ������� ������� ������
//
function TDMUser.InternalAddGroup(const GroupName: string; out GroupID: Integer): Boolean;
begin
  Result := not InternalFindGroup(GroupName);
  if Result then
  begin
    Groups.Append;
    GroupsGroupName.Value := GroupName;
    GroupsAllowDelete.Value := True;
    Groups.Post;
  end;
  GroupID := GroupsGroupID.Value;
end;

procedure TDMUser.InternalClearGroup(GroupID: Integer; RemoveGroup: Boolean);
begin
  if InternalFindGroup(GroupID) then
  begin
    //
    // ������� ����� �� ������
    //
    GroupBooks.First;
    while not GroupBooks.Eof do
      GroupBooks.Delete;
    //
    // ������� �������������� �����
    //
    RemoveUnusedBooks;

    //
    // ������� ������
    //
    if RemoveGroup then
    begin
      Assert(GroupsAllowDelete.Value);
      Groups.Delete;
    end;
  end;
end;

//
// ������� ������
//
procedure TDMUser.DeleteGroup(GroupID: Integer);
begin
  InternalClearGroup(GroupID, True);
end;

//
// ��������
//
procedure TDMUser.ClearGroup(GroupID: Integer);
begin
  InternalClearGroup(GroupID, False);
end;

procedure TDMUser.AddBookToGroup(
  BookID: Integer;
  DatabaseID: Integer;
  GroupID: Integer;
  const BookRecord: TBookRecord
  );
var
  Stream: TABSBlobStream;
  Writer: TWriter;
  Author: TAuthorData;
  Genre: TGenreData;
begin
  Assert(AllBooks.Active);
  if not AllBooks.Locate(BOOK_ID_DB_ID_FIELDS, VarArrayOf([BookID, DatabaseID]), []) then
  begin
    AllBooks.Append;

    AllBooksBookID.Value := BookID;
    AllBooksDatabaseID.Value := DatabaseID;

    AllBooksLibID.Value := BookRecord.LibID;
    AllBooksTitle.Value := BookRecord.Title;
    AllBooksSerieID.Value := BookRecord.SerieID;
    AllBooksSeqNumber.Value := BookRecord.SeqNumber;
    AllBooksDate.Value := BookRecord.Date;
    AllBooksLibRate.Value := BookRecord.LibRate;
    AllBooksLang.Value := BookRecord.Lang;
    AllBooksFolder.Value := TPath.Combine(ActiveCollection.RootFolder, BookRecord.Folder);
    AllBooksFileName.Value := BookRecord.FileName;
    AllBooksInsideNo.Value := BookRecord.InsideNo;
    AllBooksExt.Value := BookRecord.FileExt;
    AllBooksSize.Value := BookRecord.Size;
    AllBooksCode.Value := BookRecord.Code;
    AllBooksLocal.Value := BookRecord.Local;
    AllBooksDeleted.Value := BookRecord.Deleted;
    AllBooksKeyWords.Value := BookRecord.KeyWords;

    AllBooksAnnotation.Value := BookRecord.Annotation;
    AllBooksReview.Value := BookRecord.Review;
    AllBooksRate.Value := BookRecord.Rate;
    AllBooksProgress.Value := BookRecord.Progress;

    Stream := TABSBlobStream.Create(AllBooksExtraInfo, bmWrite);
    try
      Writer := TWriter.Create(Stream, 4096);
      try
        Writer.WriteString(BookRecord.Serie);

        Writer.WriteListBegin;
        for Author in BookRecord.Authors do
        begin
          Writer.WriteString(Author.LastName);
          Writer.WriteString(Author.FirstName);
          Writer.WriteString(Author.MiddleName);
          Writer.WriteInteger(Author.AuthorID);
        end;
        Writer.WriteListEnd;

        Writer.WriteListBegin;
        for Genre in BookRecord.Genres do
        begin
          Writer.WriteString(Genre.GenreCode);
          Writer.WriteString(Genre.FB2GenreCode);
          Writer.WriteString(Genre.GenreAlias);
        end;
        Writer.WriteListEnd;
      finally
        Writer.Free;
      end;
    finally
      Stream.Free;
    end;

    AllBooks.Post;
  end;

  //
  // ��������� ����� � ������ ������
  //
  CopyBookToGroup(BookID, DatabaseID, 0, GroupID, False);
end;

//
// ������� ��������� ����� �� ��������� ������.
// NOTE: ���� ����� �� ������� �������������� ����� !!! ����� ��� ������ ����������� ����� ������� RemoveUnusedBooks
//
procedure TDMUser.DeleteFromGroup(BookID: Integer; DatabaseID: Integer; GroupID: Integer);
begin
  if InternalFindGroup(GroupID) then
  begin
    if GroupBooks.Locate(BOOK_ID_DB_ID_FIELDS, VarArrayOf([BookID, DatabaseID]), []) then
      GroupBooks.Delete;
  end;
end;

//
// ������� �����, �� �������� � ������
//
procedure TDMUser.RemoveUnusedBooks;
begin
  ClearQuery.ExecSQL;
end;

procedure TDMUser.CopyBookToGroup(
  BookID: Integer; DatabaseID: Integer;
  SourceGroupID: Integer;
  TargetGroupID: Integer;
  MoveBook: Boolean
);
begin
  Assert(AllBookGroups.Active);

  if MoveBook then
  begin
    if AllBookGroups.Locate(GROUP_ID_BOOK_ID_DB_ID_FIELDS, VarArrayOf([SourceGroupID, BookID, DatabaseID]), []) then
    begin
      AllBookGroups.Edit;
      try
        AllBookGroupsGroupID.Value := TargetGroupID;
        AllBookGroups.Post;
      except
        AllBookGroups.Cancel;
      end;
    end;
  end
  else
  begin
    AllBookGroups.Append;
    try
      AllBookGroupsGroupID.Value := TargetGroupID;
      AllBookGroupsBookID.Value := BookID;
      AllBookGroupsDatabaseID.Value := DatabaseID;
      AllBookGroups.Post;
    except
      AllBookGroups.Cancel;
    end;
  end;
end;

procedure TDMUser.ExportUserData(data: TUserData);
var
  CollectionID: Integer;
  group: TBookGroup;
begin
  Assert(Assigned(data));

  CollectionID := ActiveCollection.ID;

  Groups.First;
  while not Groups.Eof do
  begin
    group := data.Groups.AddGroup(GroupsGroupID.Value, GroupsGroupName.Value);

    GroupBooks.First;
    while not GroupBooks.Eof do
    begin
      if BooksByGroupDatabaseID.Value = CollectionID then
        group.AddBook(BooksByGroupBookID.Value, BooksByGroupLibID.Value);

      GroupBooks.Next;
    end;

    Groups.Next;
  end;
end;

procedure TDMUser.ImportUserData(data: TUserData);
var
  group: TBookGroup;
  GroupID: Integer;
begin
  Assert(Assigned(data));

  for group in data.Groups do
  begin
    InternalAddGroup(group.GroupName, GroupID);
    group.GroupID := GroupID;
  end;
end;

{ TMHLCollection }

procedure TMHLCollection.Edit;
begin
  FSysDataModule.tblBases.Edit;
end;

procedure TMHLCollection.Save;
begin
  FSysDataModule.tblBases.Post;
end;

procedure TMHLCollection.Cancel;
begin
  FSysDataModule.tblBases.Cancel;
end;

function TMHLCollection.GetActive: Boolean;
begin
  Assert(Assigned(FSysDataModule));
  Result := FSysDataModule.tblBases.Active and not FSysDataModule.tblBasesID.IsNull;
end;

function TMHLCollection.GetID: Integer;
begin
  Assert(Assigned(FSysDataModule));
  if FSysDataModule.tblBasesID.IsNull then
    Result := NO_ACTIVECOLLECTION_ID
  else
    Result := FSysDataModule.tblBasesID.Value;
end;

function TMHLCollection.GetName: string;
begin
  Assert(Assigned(FSysDataModule));
  if FSysDataModule.tblBasesBaseName.IsNull then
    Result := rstrNamelessColection
  else
    Result := FSysDataModule.tblBasesBaseName.Value;
end;

procedure TMHLCollection.SetName(const Value: string);
begin
  Assert(Assigned(FSysDataModule));
  FSysDataModule.tblBasesBaseName.Value := Value;
end;

function TMHLCollection.GetRootFolder: string;
begin
  Assert(Assigned(FSysDataModule));
  Result := FSysDataModule.tblBasesRootFolder.Value;
end;

function TMHLCollection.GetScript: string;
begin
  Result := FSysDataModule.tblBasesConnection.Value;
end;

procedure TMHLCollection.SetRootFolder(const Value: string);
begin
  Assert(Assigned(FSysDataModule));
  FSysDataModule.tblBasesRootFolder.Value := ExcludeTrailingPathDelimiter(Value);
end;

procedure TMHLCollection.SetScript(const Value: string);
begin
  FSysDataModule.tblBasesConnection.Value := Value;
end;

function TMHLCollection.GetDBFileName: string;
begin
  Assert(Assigned(FSysDataModule));
  Result := FSysDataModule.tblBasesDBFileName.Value;
end;

procedure TMHLCollection.SetDBFileName(const Value: string);
begin
  Assert(Assigned(FSysDataModule));
  FSysDataModule.tblBasesDBFileName.Value := Value;
end;

function TMHLCollection.GetNotes: string;
begin
  Assert(Assigned(FSysDataModule));
  Result := FSysDataModule.tblBasesNotes.Value;
end;

procedure TMHLCollection.SetNotes(const Value: string);
begin
  Assert(Assigned(FSysDataModule));
  FSysDataModule.tblBasesNotes.Value := Value;
end;

function TMHLCollection.GetURL: string;
begin
  Result := FSysDataModule.tblBasesURL.Value;
end;

function TMHLCollection.GetUser: string;
begin
  Assert(Assigned(FSysDataModule));
  Result := FSysDataModule.tblBasesUser.Value;
end;

procedure TMHLCollection.SetURL(const Value: string);
begin
  FSysDataModule.tblBasesURL.Value := Value;
end;

procedure TMHLCollection.SetUser(const Value: string);
begin
  Assert(Assigned(FSysDataModule));
  FSysDataModule.tblBasesUser.Value := Value;
end;

function TMHLCollection.GetPassword: string;
begin
  Assert(Assigned(FSysDataModule));
  Result := FSysDataModule.tblBasesPass.Value;
end;

procedure TMHLCollection.SetPassword(const Value: string);
begin
  Assert(Assigned(FSysDataModule));
  FSysDataModule.tblBasesPass.Value := Value;
end;

function TMHLCollection.GetCreationDate: TDateTime;
begin
  Assert(Assigned(FSysDataModule));
  Result := FSysDataModule.tblBasesDate.Value;
end;

procedure TMHLCollection.SetCreationDate(const Value: TDateTime);
begin
  Assert(Assigned(FSysDataModule));
  FSysDataModule.tblBasesDate.Value := Value;
end;

function TMHLCollection.GetVersion: Integer;
begin
  Assert(Assigned(FSysDataModule));
  if FSysDataModule.tblBasesVersion.IsNull then
    Result := UNVERSIONED_COLLECTION
  else
    Result := FSysDataModule.tblBasesVersion.Value;
end;

procedure TMHLCollection.SetVersion(const Value: Integer);
begin
  Assert(Assigned(FSysDataModule));
  FSysDataModule.tblBasesVersion.Value := Value;
end;

function TMHLCollection.GetCollectionType: COLLECTION_TYPE;
begin
  Assert(Assigned(FSysDataModule));
  Result := FSysDataModule.tblBasesCode.Value;

  if Result = CT_DEPRICATED_ONLINE_FB then
    Result := CT_LIBRUSEC_ONLINE_FB;
end;

procedure TMHLCollection.SetCollectionType(const Value: COLLECTION_TYPE);
begin
  Assert(Assigned(FSysDataModule));
  FSysDataModule.tblBasesCode.Value := Value;
end;

function TMHLCollection.GetAllowDelete: Boolean;
begin
  Assert(Assigned(FSysDataModule));
  if FSysDataModule.tblBasesAllowDelete.IsNull then
    Result := True
  else
    Result := FSysDataModule.tblBasesAllowDelete.Value;
end;

procedure TMHLCollection.SetAllowDelete(const Value: Boolean);
begin
  Assert(Assigned(FSysDataModule));
  FSysDataModule.tblBasesAllowDelete.Value := Value;
end;

{ TMHLActiveCollection }

constructor TMHLActiveCollection.Create;
begin
  inherited Create;
  Clear;
end;

function TMHLActiveCollection.GetRootPath: string;
begin
  Result := IncludeTrailingPathDelimiter(FRootFolder);
end;

procedure TMHLActiveCollection.Clear;
begin
  FID := DMUser.INVALID_COLLECTION_ID;
  FName := '';
  FRootFolder := '';
  FDBFileName := '';
  FNotes := '';
  FCreationDate := 0;
  FVersion := UNVERSIONED_COLLECTION;
  FCollectionType := CT_PRIVATE_FB;
  FAllowDelete := False;
  FUser := '';
  FPassword := '';
  FURL := '';
  FScript := '';
end;

end.

