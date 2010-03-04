(* *****************************************************************************
  *
  * MyHomeLib
  *
  * Copyright (C) 2008-2010 Aleksey Penkov
  *
  * Created             12.02.2010
  * Description
  * Author(s)           Nick Rymanov (nrymanov@gmail.com)
  *                     Aleksey Penkov  alex.penkov@gmail.com
  *
  * History
  * NickR 02.03.2010    ��� ����������������
  *
  ****************************************************************************** *)

{ TODO -oNickR : �����, ����� ����������� �� ������������� ����� �� ����, � ������������� ������ ���� �������� � Stream }

unit unit_ImportInpxThread;

interface

uses
  Windows,
  unit_WorkerThread,
  unit_Globals;

type
  TFields = (
    flNone,
    flAuthor,
    flTitle,
    flSeries,
    flSerNo,
    flGenre,
    flLibID,
    flInsideNo,
    flFile,
    flFolder,
    flExt,
    flSize,
    flLang,
    flDate,
    flCode,
    flDeleted,
    flRate,
    flURI,
    flLibRate,
    flKeyWords
  );

  TFieldDescr = record
    Code: string;
    FType: TFields;
  end;

  TImportLibRusEcThread = class(TWorker)
  private
    FDBFileName: string;
    FCollectionRoot: string;
    FCollectionType: Integer;
    FInpxFileName: string;

    FFields: array of TFields;

    FPersonalFolder: boolean;

    FGenresType: TGenresType;

    procedure SetCollectionRoot(const Value: string);
    procedure ParseData(const input: string; var R: TBookRecord);

  protected
    procedure WorkFunction; override;
    procedure GetFields;

  public
    function Import(CheckFiles: boolean): Integer;

    property DBFileName: string read FDBFileName write FDBFileName;
    property CollectionRoot: string read FCollectionRoot write SetCollectionRoot;
    property CollectionType: COLLECTION_TYPE read FCollectionType write FCollectionType;
    property InpxFileName: string read FInpxFileName write FInpxFileName;
    property GenresType: TGenresType write FGenresType;
  end;

implementation

uses
  Classes,
  SysUtils,
  unit_database,
  unit_Settings,
  unit_Consts,
  unit_Helpers,
  ZipForge;

//type
//  INPXType = (inpUnknown, inpFormat_10, inpFormat_11);

const
  FieldsDescr: array [1 .. 20] of TFieldDescr = (
    (Code: 'AUTHOR';   FType: flAuthor),
    (Code: 'TITLE';    FType: flTitle),
    (Code: 'SERIES';   FType: flSeries),
    (Code: 'SERNO';    FType: flSerNo),
    (Code: 'GENRE';    FType: flGenre),
    (Code: 'LIBID';    FType: flLibID),
    (Code: 'INSNO';    FType: flInsideNo),
    (Code: 'FILE';     FType: flFile),
    (Code: 'FOLDER';   FType: flFolder),
    (Code: 'EXT';      FType: flExt),
    (Code: 'SIZE';     FType: flSize),
    (Code: 'LANG';     FType: flLang),
    (Code: 'DATE';     FType: flDate),
    (Code: 'CODE';     FType: flCode),
    (Code: 'DEL';      FType: flDeleted),
    (Code: 'RATE';     FType: flRate),
    (Code: 'URI';      FType: flURI),
    (Code: 'LIBRATE';  FType: flLibRate),
    (Code: 'KEYWORDS'; FType: flKeyWords),
    (Code: 'URL';      FType: flURI)
  );

  { TImportLibRusEcThread }

function ParseString(const InputStr: string; const DelimiterChar: Char; var slParams: TStringList): Boolean;
// const
// DelimiterChar = Chr(4);
var
  nPos: Integer;
  cParam: string;
  nParamsCount: Integer;
begin
  nParamsCount := 0;
  slParams.Clear;
  //
  // �������������� �������� ���������� slParams
  // � ����� ������������ ������, ���� ������ ����� ����������� - ��������� �������� � ����������,
  // ����� - ���������� ������ �� ��������� ����������
  //
  cParam := '';
  for nPos := 1 to Length(InputStr) do
  begin
    if InputStr[nPos] <> DelimiterChar then
      cParam := cParam + InputStr[nPos]
    else
    begin
      slParams.Add(cParam);
      cParam := '';
      Inc(nParamsCount);
    end;
  end;
  //
  // ���� ��������� ���������� �� �����, ��������� � � ����������.
  //
  if cParam <> '' then
  begin
    slParams.Add(cParam);
    Inc(nParamsCount);
    cParam := '';
  end;

  //
  // ��������� ������������ ���������� ���������� � ����������� ��������
  // � ������� ���������� �������� ��� ��������� ������� �������
  //
  Result := slParams.Count = nParamsCount;
end;

procedure TImportLibRusEcThread.ParseData(const input: string; var R: TBookRecord);
const
  DelimiterChar = Chr(4);

var
  p, i: Integer;
  slParams: TStringList;
  //nParamsCount: Integer;
  AuthorList: string;
  strLastName: string;
  strFirstName: string;
  strMidName: string;
  GenreList: string;
  s: string;
  mm, dd, yy: word;

  Max: Integer;

begin

  R.Clear;
  slParams := TStringList.Create;
  try
    ParseString(input, DelimiterChar, slParams);

    // -- �������
    if slParams.Count < High(FFields) then
      Max := slParams.Count - 1
    else
      Max := High(FFields);
    // --

    for i := 0 to Max do
    begin
      case FFields[i] of
        flAuthor:
          begin // ������ �������
            AuthorList := slParams[i];
            p := PosChr(':', AuthorList);
            while p <> 0 do
            begin
              s := Copy(AuthorList, 1, p - 1);
              Delete(AuthorList, 1, p);

              p := PosChr(',', s);
              strLastName := Copy(s, 1, p - 1);
              Delete(s, 1, p);

              p := PosChr(',', s);
              strFirstName := Copy(s, 1, p - 1);
              Delete(s, 1, p);

              strMidName := s;

              R.AddAuthor(strLastName, strFirstName, strMidName);

              p := PosChr(':', AuthorList);
            end;
          end;

        flGenre:
          begin // ������ ������
            GenreList := slParams[i];
            p := PosChr(':', GenreList);
            while p <> 0 do
            begin
              if FGenresType = gtFb2 then
                R.AddGenreFB2('', Copy(GenreList, 1, p - 1), '')
              else
                R.AddGenreAny(Copy(GenreList, 1, p - 1), '');

              Delete(GenreList, 1, p);
              p := PosChr(':', GenreList);
            end;
          end;

        flTitle:
          R.Title := slParams[i]; // ��������

        flSeries:
          R.Series := slParams[i]; // �����

        flSerNo:
          R.SeqNumber := StrToIntDef(slParams[i], 0); // ����� ������ �����

        flFile:
          R.FileName := CheckSymbols(Trim(slParams[i])); // ��� �����

        flExt:
          R.FileExt := '.' + slParams[i]; // ���

        flSize:
          R.Size := StrToIntDef(slParams[i], 0); // ������

        flLibID:
          R.LibID := StrToIntDef(slParams[i], 0); // �����. �����

        flDeleted:
          R.Deleted := (slParams[i] = '1'); // �������

        flDate:
          begin // ����
            if slParams[i] <> '' then
            begin
              yy := StrToInt(Copy(slParams[i], 1, 4));
              mm := StrToInt(Copy(slParams[i], 6, 2));
              dd := StrToInt(Copy(slParams[i], 9, 2));
              R.Date := EncodeDate(yy, mm, dd);
            end
            else
              R.Date := EncodeDate(70, 01, 01);
          end;

        flInsideNo:
          R.InsideNo := StrToInt(slParams[i]); // ����� � ������

        flFolder:
          R.Folder := slParams[i]; // �����

        flLibRate:
          R.LibRate := StrToIntDef(slParams[i], 0); // ������� �������

        flLang:
          R.Lang := slParams[i]; // ����

        flKeyWords:
          R.KeyWords := slParams[i]; // �������� �����

        flURI:
          R.URI := slParams[i]; // �������� �����
      end; // case, for
    end;

    R.Normalize;
  finally
    slParams.Free;
  end;
end;

procedure TImportLibRusEcThread.GetFields;
const
  del = ';';
  Default = 'AUTHOR;GENRE;TITLE;SERIES;SERNO;FILE;SIZE;LIBID;DEL;EXT;DATE;LANG;LIBRATE;KEYWORDS';
  FN = 'structure.info';

var
  s: string;
  p, i: Integer;
  F: text;

  function FindType(const s: string): TFields;
  var
    F: TFieldDescr;
  begin
    for F in FieldsDescr do
      if F.Code = s then
      begin
        Result := F.FType;
        Exit;
      end;
    Result := flNone;
  end;

begin
  s := '';
  if FileExists(Settings.TempPath + FN) then
  begin
    AssignFile(F, Settings.TempPath + FN);
    Reset(F);
    Read(F, s);
    CloseFile(F);

    DeleteFile(Settings.TempPath + FN);
  end;

  if s = '' then
    s := Default;

  // ���
  SetLength(FFields, 0);
  i := 0;
  p := Pos(del, s);
  while p <> 0 do
  begin
    SetLength(FFields, i + 1);
    FFields[i] := FindType(Copy(s, 1, p - 1));
    Delete(s, 1, p);
    p := Pos(del, s);

    if not FPersonalFolder then
      FPersonalFolder := (FFields[i] = flFolder);

    Inc(i);
  end;
end;

function TImportLibRusEcThread.Import(CheckFiles: boolean): Integer;
var
  FLibrary: TMHLLibrary;
  BookList: TStringList;
  i: Integer;
  j: Integer;
  R: TBookRecord;
  filesProcessed: Integer;
  unZip: TZipForge;
  CurrentFile: string;
  ArchItem: TZFArchiveItem;
  //FileStream: TMemoryStream;
begin
  filesProcessed := 0;
  i := 0;
  SetProgress(0);

  FLibrary := TMHLLibrary.Create(nil);
  try
    FLibrary.DatabaseFileName := DBFileName;
    FLibrary.Active := True;
    FLibrary.BeginBulkOperation;
    try
      unZip := TZipForge.Create(nil);
      try
        unZip.BaseDir := Settings.TempPath;
        unZip.FileName := FInpxFileName;
        unZip.OpenArchive;
        unZip.ExtractFiles('*.*');

        GetFields;

        BookList := TStringListEx.Create; { TODO -oNickR -cunused code : ��������� � �������, ���� ����� ������ ������� }
        try
          if (unZip.FindFirst('*.inp', ArchItem, faAnyFile - faDirectory)) then
          begin
            repeat
              CurrentFile := ArchItem.FileName;

              if not isOnlineCollection(CollectionType) and (CurrentFile = 'extra.inp') then
                Continue;

              Teletype(Format('������������ ���� %s', [CurrentFile]), tsInfo);

              BookList.LoadFromFile(Settings.TempPath + CurrentFile, TEncoding.UTF8);

              for j := 0 to BookList.Count - 1 do
              begin
                try
                  ParseData(BookList[j], R);
                  if isOnlineCollection(CollectionType) then
                  begin
                    // �\������ ����\1234 ������ �����.fb2.zip
                    R.Folder := R.GenerateLocation + FB2ZIP_EXTENSION;
                    // �������� ������� � ������������� �����
                    R.Local := FileExists(FCollectionRoot + R.Folder);
                  end
                  else
                  begin
                    if not FPersonalFolder then
                    begin
                      // 98058-98693.inp -> 98058-98693.zip
                      R.Folder := ChangeFileExt(CurrentFile, ZIP_EXTENSION);
                      //
                      R.InsideNo := j;
                    end
                  end;

                  if FLibrary.InsertBook(R, CheckFiles, False) <> 0 then
                    Inc(filesProcessed);

                  if (filesProcessed mod ProcessedItemThreshold) = 0 then
                  begin
                    SetProgress(Round((i + j / BookList.Count) * 100 / unZip.FileCount));
                    SetComment(Format('��������� %u ����', [filesProcessed]));
                  end;
                except
                  on EConvertError do
                    Teletype(Format('������ ��������� inp. ���� %s, ������ %u ', [CurrentFile, j]), tsError);
                end;
              end;

              Inc(i);
              if Canceled then
                Break;
            until (not unZip.FindNext(ArchItem));
          end;
        finally
          BookList.Free;
        end;
        Teletype(Format('��������� %u ����', [filesProcessed]), tsInfo);
      finally
        unZip.Free;
      end;
    finally
      FLibrary.EndBulkOperation;
    end;
  finally
    FLibrary.Free;
  end;
end;

procedure TImportLibRusEcThread.SetCollectionRoot(const Value: string);
begin
  FCollectionRoot := IncludeTrailingPathDelimiter(Value);
end;

procedure TImportLibRusEcThread.WorkFunction;
begin
  Import(False);
end;

end.
