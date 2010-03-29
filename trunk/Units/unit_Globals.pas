(* *****************************************************************************
  *
  * MyHomeLib
  *
  * Copyright (C) 2008-2010 Aleksey Penkov
  *
  * Created             12.02.2010
  * Description
  * Author(s)           Aleksey Penkov  alex.penkov@gmail.com
  *                     Nick Rymanov (nrymanov@gmail.com)
  *
  * History
  * NickR 15.02.2010    ��� ����������������
  *
  ****************************************************************************** *)

unit unit_Globals;

interface

uses
  Classes,
  SysUtils,
  VirtualTrees,
  IdHTTP,
  ZipForge;

type
  TTXTEncoding = (enUTF8, en1251, enUnicode, enUnknown);

  TTreeMode = (tmTree, tmFlat);

  TGenresType = (gtFb2, gtAny);

  TBookIdStruct = record
    BookID: Integer;
    DatabaseID: Integer;
    Res: Boolean;
  end;

  TBookIdList = array of TBookIdStruct;

type
  EInvalidLogin = class(Exception);

//
// Global consts
//
// -----------------------------------------------------------------------------
const
  {
  0000 0000
   \ /   |
    |    - 0 - fb2, 1 - non-fb2
    |
    |-- 00 - ����������������, 10 - ������� ���������, 11 - ������� ������

  ������� ����� - ��� �����������
  ���� ���������� ��������� ����:
    0000        : ����� � fb2
    0001        : ����� �� � fb2

  ������� ����� - ��� ���������
  ���������� ��������� ���������:
    0000        : ���������������� ��������� (������ ���������)
    0001 - 07FF : ������� ��������� ���������
    0800 - 0FFF : ������� ������ ���������

    Note: ������������� ������� ��� ��������� �� ������ ���������
  }

  //
  // ��� �����������
  //
  CONTENT_FB               = $0000;
  CONTENT_NONFB            = $0001;

  //
  // ������������ ����������
  //
  LOCATION_LOCAL           = $00000000;
  LOCATION_ONLINE          = $08000000;

  //
  // ���������������� ����������
  //
  LIBRARY_PRIVATE          = $00000000;
  LIBRARY_LIBRUSEC         = $00010000;
  LIBRARY_GENESIS          = $00020000;

  //
  // ��������� �����
  //
  CT_CONTENT_MASK          = $00000001;
  CT_LOCATION_MASK         = $08000000;
  CT_TYPE_MASK             = $08030000;
  CT_MASK                  = CT_CONTENT_MASK or CT_TYPE_MASK;

  //
  // ��������� ���������������� �����
  //
  CT_PRIVATE_FB           = LIBRARY_PRIVATE or CONTENT_FB;                              // 0000 0000 -
  CT_PRIVATE_NONFB        = LIBRARY_PRIVATE or CONTENT_NONFB;                           // 0000 0001 -
  CT_LIBRUSEC_LOCAL_FB    = LOCATION_LOCAL or LIBRARY_LIBRUSEC or CONTENT_FB;           // 0001 0000 - local lib.rus.ec
  CT_LIBRUSEC_ONLINE_FB   = LOCATION_ONLINE or LIBRARY_LIBRUSEC or CONTENT_FB;          // 0801 0000 - online lib.rus.ec
  CT_GENESIS_LOCAL_NONFB  = LOCATION_LOCAL or LIBRARY_GENESIS or CONTENT_NONFB;         // 0002 0001 - local Genesis
  CT_GENESIS_ONLINE_NONFB = LOCATION_ONLINE or LIBRARY_GENESIS or CONTENT_NONFB;        // 0802 0001 - online Genesis
  CT_LIBRUSEC_USR         = LOCATION_LOCAL or LIBRARY_LIBRUSEC or CONTENT_NONFB;        // 0001 0001 - online Genesis

  CT_DEPRICATED_ONLINE_FB = 99;

type
  COLLECTION_TYPE = Integer;

function isPrivateCollection(t: COLLECTION_TYPE): Boolean; inline;
function isExternalCollection(t: COLLECTION_TYPE): Boolean; inline;
function isLocalCollection(t: COLLECTION_TYPE): Boolean; inline;
function isOnlineCollection(t: COLLECTION_TYPE): Boolean; inline;
function isFB2Collection(t: COLLECTION_TYPE): Boolean; inline;
function isNonFB2Collection(t: COLLECTION_TYPE): Boolean; inline;

  // -----------------------------------------------------------------------------
function Transliterate(const Input: string): string;
function CheckSymbols(const Input: string): string;
function EncodePassString(const Input: string): string;
function DecodePassString(const Input: string): string;
procedure StrReplace(const s1: string; const s2: string; var s3: string);

function ClearDir(const DirectoryName: string): Boolean;
function IsRelativePath(const FileName: string): Boolean;
function CreateFolders(Root: string; const Path: string): Boolean;
procedure CopyFile(const SourceFileName: string; const DestFileName: string);
procedure ConvertToTxt(const SourceFileName: string; DestFileName: string; Enc: TTXTEncoding);
procedure ZipFile(const FileName: string; const ZipFileName: string);

function InclideUrlSlash(const S: string): string;

function PosChr(aCh: Char; const S: string): Integer;
function CompareInt(i1, i2: Integer): Integer;
function CompareDate(d1, d2: TDateTime): Integer;

function GenerateBookLocation(const FullName: string): string;
function GenerateFileName(const Title: string; libID: Integer): string;

procedure DebugOut(const DebugMessage: string); overload;
procedure DebugOut(const DebugMessage: string; const Args: array of const ); overload;

procedure SetProxySettings(var IdHTTP: TidHTTP);

function GetSpecialPath(CSIDL: word): string;
function GetLibUpdateVersion(Full: Boolean): Integer;
function ExecAndWait(const FileName, Params: string; const WinState: word): Boolean;

function CleanExtension(const Ext: string): string;

function TestArchive(const FileName: string): Boolean;

type
  TAppLanguage = (alEng, alRus);
  TExportMode = (emFB2, emFB2Zip, emLrf, emTxt, emEpub, emPDF);

  TDownloadState = (dsWait, dsRun, dsOk, dsError);

  //
  // TreeView data records
  //
  PDownloadData = ^TDownloadData;
  TDownloadData = record
    BookID: Integer;
    DataBaseID: Integer;
    Author: string;
    Title: string;
    Size: Integer;
    FileName: string;
    URL: string;
    State: TDownloadState;
  end;

  PAuthorData = ^TAuthorData;
  TAuthorData = record
    AuthorID: Integer;
    Text: string;
    First, Last, Middle: string;
  end;

  PSerieData = ^TSerieData;
  TSerieData = record
    SerieID: Integer;
    Text: string;
  end;

  TBookNodeType = (ntAuthorInfo = 1, ntSeriesInfo, ntBookInfo);
  PBookData = ^TBookData;
  TBookData = record
    nodeType: TBookNodeType;

    BookID: Integer;
    DatabaseID: Integer;
    SerieID: Integer;

    Title: string;
    Series: string;
    Genre: string;
    FullName: string;
    CollectionName: string;
    FileType: string;
    Lang: string;
    Size: Integer;
    Rate: Integer;
    No: Integer;
    Progress: Integer;
    LibRate: Integer;
    Code: Integer;
    Locale: Boolean;
    Deleted: Boolean;
    Date: TDateTime;
  end;

  PGenreData = ^TGenreData;
  TGenreData = record
    ID: Integer;
    Text: string;
    Code: string;
    FB2Code: string;
    ParentCode: string;
  end;

  PGroupData = ^TGroupData;
  TGroupData = record
    GroupID: Integer;
    Text: string;
    CanDelete: Boolean;
  end;

  //
  //
  //
  TGenreRecord = record
    GenreCode: string;
    GenreFb2Code: string;
    Alias: string;
  end;

  TAuthorRecord = record
    ID: Integer;
    FFirstName: string;
    FMiddleName: string;
    FLastName: string;

    procedure SetFirstName(const Value: string); inline;
    procedure SetLastName(const Value: string); inline;
    procedure SetMiddleName(const Value: string); inline;

    function GetFullName(onlyInitials: Boolean = False): string; inline;

    property FirstName: string read FFirstName write SetFirstName;
    property MiddleName: string read FMiddleName write SetMiddleName;
    property LastName: string read FLastName write SetLastName;

    class function FormatName(
      const lastName: string;
      const firstName: string;
      const middleName: string;
      const nickName: string = '';
      onlyInitials: Boolean = False
    ): string; static;
  end;

  TBookRecord = record
    //
    // TODO : �������� ��������� ���� ��� ID �����, SeriesID � ��� ���������
    //
    Title: string;

    Folder: string;
    FileName: string;
    FileExt: string;
    InsideNo: Integer;

    Series: string;
    SeqNumber: Integer;

    Authors: array of TAuthorRecord;
    Genres: array of TGenreRecord;
    RootGenre: TGenreRecord;

    Code: Integer;
    Size: Integer;

    LibID: Integer;

    //
    // ������������� � ��������� (set)
    //
    Deleted: Boolean;
    Local: Boolean;

    Date: TDateTime;

    Lang: string[2];
    LibRate: Integer;

    //
    // TODO : ��������� ������������� ���� �����
    //
    KeyWords: string;
    URI: string;
    Annotation: string;

    procedure Normalize;
    procedure Clear;
    function GenerateLocation: string;

    procedure ClearAuthors;
    procedure AddAuthor(const LastName: string; const FirstName: string; const MiddleName: string; id: Integer = 0);
    function GetAuthorCount: Integer;
    function GetAutorsList: string;
    property AuthorCount: Integer read GetAuthorCount;
    property AutorsList: string read GetAutorsList;

    procedure ClearGenres;
    procedure AddGenreFB2(const GenreCode: string; const GenreFb2Code: string; const Alias: string);
    procedure AddGenreAny(const GenreCode: string; const Alias: string);
    function GetGenreCount: Integer;
    property GenreCount: Integer read GetGenreCount;
  end;

  PFileData = ^TFileData;

  TFileData = record
    FullPath, FileName, Folder, Ext, Title: string;
    Size: Integer;
    DataType: (dtFolder, dtFile);
    Date: TDateTime;
  end;

  TColumnData = record
    Text: string;
    Position, Width, MaxWidth, MinWidth: Integer;
    Alignment: TAlignment;
    Options: TVTColumnOptions;
  end;

implementation

uses
  Forms,
  Windows,
  StrUtils,
  IOUtils,
  Character,
  unit_Settings,
  unit_Consts,
  ShlObj,
  unit_fb2ToText,
  unit_Helpers;

const
  lat: set of Char = ['A' .. 'Z', 'a' .. 'z', '\', '-', ':', '`', ',', '.', '0' .. '9', '_', ' ', '(', ')', '[', ']', '{', '}'];

const
  denied: set of Char = ['<', '>', ':', '"', '/', '|', '*', '?'];

const
  TransL: array [0 .. 31] of string = ('a', 'b', 'v', 'g', 'd', 'e', 'zh', 'z', 'i', 'y', 'k', 'l', 'm', 'n', 'o', 'p', 'r', 's', 't', 'u', 'f', 'h', 'c', 'ch', 'sh', 'sch', '''', 'i', '''', 'e', 'yu', 'ya');

const
  TransU: array [0 .. 31] of string = ('A', 'B', 'V', 'G', 'D', 'E', 'Zh', 'Z', 'I', 'Y', 'K', 'L', 'M', 'N', 'O', 'P', 'R', 'S', 'T', 'U', 'F', 'H', 'C', 'Ch', 'Sh', 'Sch', '''', 'I', '''', 'E', 'Yu', 'Ya');

  // -----------------------------------------------------------------------------
  // ��������� ���������� � ���������
  // -----------------------------------------------------------------------------
function isPrivateCollection(t: COLLECTION_TYPE): Boolean;
begin
  Result := (t and CT_TYPE_MASK) = LIBRARY_PRIVATE;
end;

function isExternalCollection(t: COLLECTION_TYPE): Boolean;
begin
  Result := (t and CT_TYPE_MASK) <> LIBRARY_PRIVATE;
end;

function isLocalCollection(t: COLLECTION_TYPE): Boolean;
begin
  Result := (t and CT_LOCATION_MASK) = LOCATION_LOCAL;
end;

function isOnlineCollection(t: COLLECTION_TYPE): Boolean;
begin
  Result := (t and CT_LOCATION_MASK) = LOCATION_ONLINE;
end;

function isFB2Collection(t: COLLECTION_TYPE): Boolean; inline;
begin
  Result := (t and CT_CONTENT_MASK) = CONTENT_FB;
end;

function isNonFB2Collection(t: COLLECTION_TYPE): Boolean; inline;
begin
  Result := (t and CT_CONTENT_MASK) = CONTENT_NONFB;
end;

// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------

function PosChr(aCh: Char; const S: string): Integer;
var
  i, max: Integer;
begin
  Result := 0;
  max := Length(S);
  for i := 1 to max do
    if S[i] = aCh then
    begin
      Result := i;
      Exit;
    end;
end;

procedure StrReplace(const s1: string; const s2: string; var s3: string);
var
  p: Integer;
begin
  p := Pos(s1, s3);
  while p > 0 do
  begin
    s3 := Copy(s3, 1, p - 1) + s2 + Copy(s3, p + Length(s1));
    p := Pos(s1, s3);
  end;
end;

function IsRelativePath(const FileName: string): Boolean;
var
  L: Integer;
begin
  Result := True;
  L := Length(FileName);
  if
    ((L >= 1) and IsPathDelimiter(FileName, 1)) or // \dir\subdir or /dir/subdir
    ((L >= 2) and (FileName[1] in ['A' .. 'Z', 'a' .. 'z']) and (FileName[2] = ':')) // C:, D:, etc.
  then
    Result := False;
end;

function CreateFolders(Root: string; const Path: string): Boolean;
var
  FullPath: string;
begin
  if Path = '\' then
  begin
    Assert(False);
    FullPath := Root;
  end
  else
    FullPath := TPath.Combine(Root, Path);

  Assert(TPath.IsPathRooted(FullPath));

  Result := SysUtils.ForceDirectories(FullPath);
end;

{$WARNINGS OFF}
procedure CopyFile(const SourceFileName: string; const DestFileName: string);
var
  SourceFile: TFileStream;
  DestFile: TFileStream;
begin
  SourceFile := TFileStream.Create(SourceFileName, fmOpenRead or fmShareDenyWrite);
  try
    DestFile := TFileStream.Create(DestFileName, fmCreate or fmShareDenyRead);
    try
      if SourceFile.Size <> DestFile.CopyFrom(SourceFile, 0) then
        RaiseLastOSError;
    finally
      DestFile.Free;
    end;
  finally
    SourceFile.Free;
  end;
end;
{$WARNINGS ON}

procedure ConvertToTxt(const SourceFileName: string; DestFileName: string; Enc: TTXTEncoding);
var
  Converter: TFb2ToText;
begin
  Converter := TFb2ToText.Create;
  try
    DestFileName := ChangeFileExt(DestFileName, '.txt');
    Converter.Convert(SourceFileName, DestFileName, Enc);
  finally
    Converter.Free;
  end;
end;

procedure ZipFile(const FileName: string; const ZipFileName: string);
var
  ziper: TZipForge;
begin
  ziper := TZipForge.Create(nil);
  try
    ziper.FileName := ZipFileName;
    ziper.OpenArchive(fmCreate);
    ziper.BaseDir := ExtractFilePath(FileName);
    ziper.AddFiles(ExtractFileName(FileName));
    ziper.CloseArchive;
  finally
    ziper.Free;
  end;
end;

function EncodePassString(const Input: string): string;
var
  i: Integer;
begin
  Result := Input;
  for i := 1 to Length(Input) do
    Result[i] := Chr(Ord(Input[i]) + 5);
end;

function DecodePassString(const Input: string): string;
var
  i: Integer;
begin
  Result := Input;
  for i := 1 to Length(Input) do
    Result[i] := Chr(Ord(Input[i]) - 5);
end;

{$WARNINGS OFF}
function ClearDir(const DirectoryName: string): Boolean;
var
  SearchRec: TSearchRec;
  ACurrentDir: string;
begin
  ACurrentDir := IncludeTrailingPathDelimiter(DirectoryName);

  try
    if FindFirst(ACurrentDir + '*.*', faAnyFile, SearchRec) = 0 then
    try
      repeat
        if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
          SysUtils.DeleteFile(ACurrentDir + SearchRec.Name);
      until FindNext(SearchRec) <> 0;
    finally
      SysUtils.FindClose(SearchRec);
    end;
  except
    Result := False;
  end;
end;
{$WARNINGS ON}

function Transliterate(const Input: string): string;
var
  S, conv: string;
  f, o: Integer;
begin
  conv := '';
  for f := 1 to Length(Input) do
  begin
    o := Ord(Input[f]);
    if (o >= 1072) and (o <= 1104) then
      S := TransL[o - 1072]
    else if (o >= 1040) and (o <= 1071) then
      S := TransU[o - 1040]
    else if CharInSet(Input[f], lat) then
      S := Input[f]
    else
      S := '_';
    conv := conv + S;
  end;
  Result := conv;
end;

function CheckSymbols(const Input: string): string;
var
  S, conv: string;
  f: Integer;
begin
  conv := '';
  for f := 1 to Length(Input) do
  begin
    if CharInSet(Input[f], denied) then
      S := ' '
    else
      S := Input[f];
    conv := conv + S;
  end;

  // ��������� ����� � ����� �����
  if Length(conv) > 0 then
    while conv[Length(conv)] = '.' do
      Delete(conv, Length(conv), 1);
  Result := conv;
end;

function GenerateBookLocation(const FullName: string): string;
var
  Letter: Char;
  AuthorName: string;
begin
  //
  // �� �������� ������� �����!!! �� �� ������� ������� ������������ ����� - �� ����� ��� � �������� '_'
  //
  AuthorName := CheckSymbols(FullName); // �.�.�. - ���������!

  Letter := AuthorName[1];
  if not IsLetterOrDigit(Letter) then
    Letter := '_';

  AuthorName := Trim(AuthorName);
  if AuthorName = '' then
    AuthorName := UNKNOWN_AUTHOR_LASTNAME;

  Result := IncludeTrailingPathDelimiter(Letter) + IncludeTrailingPathDelimiter(AuthorName);
end;

function GenerateFileName(const Title: string; libID: Integer): string;
var
  BookTitle: string;
begin
  BookTitle := Trim(CheckSymbols(Title));
  if BookTitle = '' then
    BookTitle := BOOK_NO_TITLE;
  Result := IntToStr(libID) + ' ' + BookTitle;
end;

{ TAuthorRecord }

class function TAuthorRecord.FormatName(
  const lastName: string;
  const firstName: string;
  const middleName: string;
  const nickName: string = '';
  onlyInitials: Boolean = False
  ): string;
begin
  Result := lastName;

  if firstName <> '' then
    Result := Result + ' ' + IfThen(onlyInitials, firstName[1] + '.', firstName);

  if middleName <> '' then
    Result := Result + ' ' + IfThen(onlyInitials, middleName[1] + '.', middleName);

  if nickName <> '' then
  begin
    if Result = '' then
      Result := nickName
    else
      Result := Result +  '(' + nickName + ')';
  end;
end;

function TAuthorRecord.GetFullName(onlyInitials: Boolean = False): string;
begin
  Assert(LastName <> '');

  Result := FormatName(LastName, FirstName, MiddleName, '', onlyInitials);
end;

procedure TAuthorRecord.SetFirstName(const Value: string);
begin
  FFirstName := Trim(Value);
end;

procedure TAuthorRecord.SetLastName(const Value: string);
begin
  FLastName := Trim(Value);
end;

procedure TAuthorRecord.SetMiddleName(const Value: string);
begin
  FMiddleName := Trim(Value);
end;

procedure TBookRecord.Clear;
begin
  Title := '';
  Series := '';

  Folder := '';
  FileName := '';
  FileExt := '';

  ClearAuthors;
  ClearGenres;

  Code := 0;
  Size := 0;
  InsideNo := 0;
  SeqNumber := 0;
  libID := 0;

  Deleted := False;
  Local := False;
  Date := 0;

  Annotation := '';
end;

//
// ��������� ������������� ���������� � �����, �������� ���� �������� �� ���������
//
procedure TBookRecord.Normalize;
var
  i: Integer;
begin
  if Title = '' then
    Title := BOOK_NO_TITLE;
  if Series = '' then
    Series := NO_SERIES_TITLE;

  for i := 0 to AuthorCount - 1 do
    if Authors[i].LastName = '' then
      Authors[i].LastName := UNKNOWN_AUTHOR_LASTNAME;
  if AuthorCount = 0 then
    AddAuthor(UNKNOWN_AUTHOR_LASTNAME, '', '');

  for i := 0 to GenreCount - 1 do
    if Genres[i].GenreCode = '' then
      Genres[i].GenreCode := UNKNOWN_GENRE_CODE;
  if GenreCount = 0 then
    AddGenreFB2(UNKNOWN_GENRE_CODE, '', '');
end;

//
// ��������� �\������ ���� ��������\������ �����
//
function TBookRecord.GenerateLocation: string;
begin
  Assert(AuthorCount > 0);
  Result := Copy(GenerateBookLocation(Authors[0].GetFullName) + GenerateFileName(Title, libID), 1, MAXFOLDERLENGTH - 10);
end;

procedure TBookRecord.ClearAuthors;
begin
  SetLength(Authors, 0);
end;

procedure TBookRecord.AddAuthor(const LastName: string; const FirstName: string; const MiddleName: string; id: Integer = 0);
var
  i: Integer;
begin
  i := AuthorCount;
  SetLength(Authors, i + 1);

  Authors[i].LastName := LastName;
  Authors[i].FirstName := FirstName;
  Authors[i].MiddleName := MiddleName;
  Authors[i].ID := id;
end;

function TBookRecord.GetAuthorCount: Integer;
begin
  Result := Length(Authors);
end;

function TBookRecord.GetAutorsList: string;
begin
  Result := TArrayUtils.Join<TAuthorRecord>(
    Authors,
    ', ',
    function(const author: TAuthorRecord): string
    begin
      Result := author.GetFullName;
    end
  );
end;

procedure TBookRecord.ClearGenres;
begin
  SetLength(Genres, 0);
end;

procedure TBookRecord.AddGenreFB2(const GenreCode: string; const GenreFb2Code: string; const Alias: string);
var
  i: Integer;
begin
  i := GenreCount;
  SetLength(Genres, i + 1);

  Genres[i].GenreCode := GenreCode;
  Genres[i].GenreFb2Code := GenreFb2Code;
  Genres[i].Alias := Alias;
end;

procedure TBookRecord.AddGenreAny(const GenreCode: string; const Alias: string);
var
  i: Integer;
begin
  i := GenreCount;
  SetLength(Genres, i + 1);

  Genres[i].GenreCode := GenreCode;
  Genres[i].GenreFb2Code := '';
  Genres[i].Alias := Alias;
end;

function TBookRecord.GetGenreCount: Integer;
begin
  Result := Length(Genres);
end;

function InclideUrlSlash(const S: string): string;
begin
  Result := S;
  if Result[Length(Result)] <> '/' then
    Result := Result + '/';
end;

function CompareDate(d1, d2: TDateTime): Integer;
begin
  if d1 > d2 then
    Result := 1
  else if d1 < d2 then
    Result := -1
  else // if d1 = d2 then
    Result := 0;
end;

function CompareInt(i1, i2: Integer): Integer;
begin
  if i1 > i2 then
    Result := 1
  else if i1 < i2 then
    Result := -1
  else // if i1 = i2 then
    Result := 0;
end;

procedure DebugOut(const DebugMessage: string);
begin
{$IFOPT D+}
  DebugOut(DebugMessage, []);
{$ENDIF}
end;

procedure DebugOut(const DebugMessage: string; const Args: array of const);
begin
{$IFOPT D+}
  OutputDebugString(PChar(Format(DebugMessage, Args)));
{$ENDIF}
end;

function GetSpecialPath(CSIDL: word): string;
var
  S: string;
begin
  SetLength(S, MAX_PATH);
  if not SHGetSpecialFolderPath(0, PChar(S), CSIDL, True) then
    S := '';
  Result := IncludeTrailingPathDelimiter(PChar(S));
end;

procedure SetProxySettings(var IdHTTP: TidHTTP);
begin
  with IdHTTP.ProxyParams do
  begin
    if Settings.UseIESettings then
    begin
      ProxyServer := Settings.IEProxyServer;
      ProxyPort := Settings.IEProxyPort;
    end
    else
    begin
      ProxyServer := Settings.ProxyServer;
      ProxyPort := Settings.ProxyPort;
      ProxyUsername := Settings.ProxyUsername;
      ProxyPassword := Settings.ProxyPassword;
    end;
    BasicAuthentication := True;
  end;

  IdHTTP.Request.UserAgent := 'MyHomeLib/2.0 (compatible; Indy Library)';

  IdHTTP.ConnectTimeout := Settings.TimeOut;
  IdHTTP.ReadTimeout := Settings.ReadTimeout;

  // idHTTP.CookieManager := frmMain.IdCookieManager;
  IdHTTP.AllowCookies := True;

  IdHTTP.HandleRedirects := True;
end;

function CheckLibVersion(ALocalVersion: Integer; Full: Boolean; out ARemoteVersion: Integer): Boolean;
var
  HTTP: TidHTTP;
  LF: TMemoryStream;
  SL: TStringList;

  URL: string;
begin
  Result := False;

  URL :=
    InclideUrlSlash(Settings.UpdateURL) +
    IfThen(Full, LIBRUSEC_UPDATEVERINFO_FILENAME, EXTRA_UPDATEVERINFO_FILENAME);

  HTTP := TidHTTP.Create(nil);
  SetProxySettings(HTTP);
  try
    LF := TMemoryStream.Create;
    try
      HTTP.Get(URL, LF);
      SL := TStringList.Create;
      try
        LF.Seek(0, soFromBeginning);
        SL.LoadFromStream(LF);
        if SL.Count > 0 then
        begin
          ARemoteVersion := StrToInt(SL[0]);
          Result := (ALocalVersion < ARemoteVersion);
        end;
      finally
        SL.Free;
      end;
    finally
      LF.Free;
    end;
  finally
    HTTP.Free;
  end;
end;

function GetLibUpdateVersion(Full: Boolean): Integer;
var
  f: Text;
  S: string;
begin
  Result := 0;
  S := Settings.SystemFileName[sfCollectionVerInfo];

  if FileExists(S) then
  begin
    AssignFile(f, S);
    try
      Reset(f);
      Readln(f, S);
      CloseFile(f);
      Result := StrToIntDef(S, 0);
    except
      on EInOutError do
        { �� ������ ������� ���� } ;
    end;
  end
  else
    Result := UNVERSIONED_COLLECTION;
end;

function ExecAndWait(const FileName, Params: string; const WinState: Word): Boolean;
var
  StartInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
  CmdLine: string;
begin
  CmdLine := '' + FileName + ' ' + Params;
  FillChar(StartInfo, Sizeof(StartInfo), #0);
  with StartInfo do
  begin
    cb := Sizeof(StartInfo);
    dwFlags := STARTF_USESHOWWINDOW;
    wShowWindow := WinState;
  end;

  Result := CreateProcess(
    nil,
    PChar(CmdLine),
    nil,
    nil,
    False,
    CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS,
    nil,
    PChar(ExtractFilePath(FileName)),
    StartInfo,
    ProcInfo
  );

  if Result then
  begin
    WaitForSingleObject(ProcInfo.hProcess, INFINITE);
    { Free the Handles }
    CloseHandle(ProcInfo.hProcess);
    CloseHandle(ProcInfo.hThread);
  end
  else
  begin
    // { TODO -oNickR -cRefactoring : �� ����� ������ ���� ���������� ������� ����� �� ���� �������. ��� ����� ���� ������� �� �������� ������. }
    Application.MessageBox(PChar(Format(' �� ������� ��������� %s ! ', [FileName])), '', mb_IconExclamation)
  end;
end;

function GetFileNameZip(Zip: TZipForge; No: Integer): string;
var
  i: Integer;
  ArchItem: TZFArchiveItem;
begin
  i := 0;
  if (Zip.FindFirst('*.*', ArchItem, faAnyFile - faDirectory)) then
  while i <> No do
  begin
    Zip.FindNext(ArchItem);
    Inc(i);
  end;
  Result := ArchItem.FileName;
end;

function CleanExtension(const Ext: string): string;
begin
  Result := Trim(Ext);
  if (Result <> '') and (Result[1] = '.') then
    Delete(Result, 1, 1);
end;

function TestArchive(const FileName: string): Boolean;
var
  Zip: TZipForge;
begin
  Zip := TZipForge.Create(nil);
  try
    Zip.FileName := FileName;
    Zip.TempDir := Settings.TempDir;
    try
      Zip.OpenArchive;
      Zip.TestFiles('*.*');
      Zip.CloseArchive;
      Result := True;
    except
      Result := False;
    end;
  finally
    Zip.Free;
  end;
end;

end.
