{******************************************************************************}
{                                                                              }
{ MyHomeLib                                                                    }
{                                                                              }
{ Version 0.9                                                                  }
{ 20.08.2008                                                                   }
{ Copyright (c) Aleksey Penkov  alex.penkov@gmail.com                          }
{                                                                              }
{ @author Nick Rymanov nrymanov@gmail.com                                      }
{                                                                              }
{******************************************************************************}

unit unit_ImportLibRusEcThread;

interface

uses
  Classes,
  SysUtils,
  StrUtils,
  unit_WorkerThread,
  unit_MHL_xml,
  unit_globals;

type
  TImportLibRusEcThread = class(TWorker)
  private
    FDBFileName: string;
    FCollectionRoot: string;
    FCollectionType: Integer;
    FInpxFileName: string;

    FVersion: integer;

    procedure SetCollectionRoot(const Value: string);


  protected
    procedure WorkFunction; override;

  public
    function Import:integer;

    property DBFileName: string read FDBFileName write FDBFileName;
    property CollectionRoot: string read FCollectionRoot write SetCollectionRoot;
    property CollectionType: COLLECTION_TYPE read FCollectionType write FCollectionType;
    property InpxFileName: string read FInpxFileName write FInpxFileName;
  end;

implementation

uses
  unit_database,
  unit_Settings,
  unit_Consts,
  unit_Helpers,
  ZipForge;

type
  INPXType = (inpUnknown, inpFormat_10, inpFormat_11);

{ TImportLibRusEcThread }

function ParseString(const InputStr: String; const DelimiterChar: Char;
  var slParams: TStringList): Boolean;
//const
//  DelimiterChar = Chr(4);
var
  nPos : integer;
  cParam: String;
  nParamsCount : Integer;
begin
  nParamsCount := 0;
  slParams.Clear;
  //
  // �������������� �������� ���������� slParams
  // � ����� ������������ ������, ���� ������ ����� ����������� - ��������� �������� � ����������,
  // ����� - ���������� ������ �� ��������� ����������
  //
  cParam := '';
  for nPos := 1 to Length(InputStr) do begin
    if InputStr[nPos] <> DelimiterChar  then
      cParam := cParam + InputStr[nPos]
    else begin
      slParams.Add(cParam);
      cParam := '';
      inc(nParamsCount);
    end;
  end;
  //
  // ���� ��������� ���������� �� �����, ��������� � � ����������.
  //
  if cParam <> '' then begin
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


function ParseData(input: WideString; var R: TBookRecord): INPXType;
const
  DelimiterChar = Chr(4);
var
  p: integer;
  slParams: TStringList;
  nParamsCount : Integer;
  AuthorList: string;
  strLastName: string;
  strFirstName: string;
  strMidName: string;
  GenreList: string;
  s: string;
  mm, dd, yy: word;
  inpType : INPXType;
begin
  Result := inpUnknown;

  R.Clear;

  slParams := TStringList.Create;
  try
    nParamsCount := 0;
    if ParseString(input, DelimiterChar, slParams) then
      nParamsCount := slParams.Count
    else
      nParamsCount := -1;

//    slParams.Delimiter := DelimiterChar;
//    slParams.StrictDelimiter := True;
//    slParams.DelimitedText := input;

    //
    // ������������� ������� ���-����� ����������� ���������
    //
    inpType := inpUnknown;
    //
    // ����� 11 �����, �� (!!!) ��� ������� � ������ ������� ��� ���� (12-�) ��������,
    // � � ������ ������������ ������������
    //
    if slParams.Count in [11,12] then
      inpType := inpFormat_10;
    if slParams.Count in [13,14] then
      inpType := inpFormat_11;

    if inpType <> inpUnknown then
    begin
      //
      // ������ �������
      //
      AuthorList := slParams[0];
      p := PosChr(':', AuthorList);
      while p <> 0 do
      begin
        s := Copy(AuthorList, 1, p - 1);
        Delete(AuthorList, 1, p);

        p := PosChr(',', s);
        strLastName := Copy(s, 1, p - 1);
        Delete(S, 1, p);

        p := PosChr(',', s);
        strFirstName := Copy(s, 1, p - 1);
        Delete(S, 1, p);

        strMidName := S;

        R.AddAuthor(strLastName, strFirstName, strMidName);

        p := PosChr(':', AuthorList);
      end;

      //
      // ������ ������
      //
      GenreList := slParams[1];
      p := PosChr(':', GenreList);
      while p <> 0 do
      begin
        R.AddGenre('', Copy(GenreList, 1, p - 1), '');
        Delete(GenreList, 1, p);

        p := PosChr(':', GenreList);
      end;

      //
      // ��������
      //
      R.Title := slParams[2];

      //
      // �����
      //
      R.Series := slParams[3];

      //
      // ����� ������ �����
      //
      R.SeqNumber := StrToIntDef(slParams[4], 0);

      //
      // ��� �����, ������, ????, ������� ��������� �����
      //
      R.FileName := CheckSymbols(Trim(slParams[5]));
      R.Size := StrToIntDef(slParams[6], 0);
      R.LibID := StrToIntDef(slParams[7], 0);
      R.Deleted := (slParams[8] = '1');

      R.FileExt := '.' + slParams[9];

      //
      //
      //
      if slParams[10] <> '' then
      begin
        yy := StrToInt(Copy(slParams[10], 1, 4));
        mm := StrToInt(Copy(slParams[10], 6, 2));
        dd := StrToInt(Copy(slParams[10], 9, 2));
        R.Date := EncodeDate(yy, mm, dd);
      end;
      // else R.Date:=now;

      //
      // �������������� ��� ����, �������� � ������
      //
      if inpType = inpFormat_11 then begin
        //
        // ���������� ������ ����� � ������
        //
        R.InsideNo := StrToInt(slParams[11]);
        //
        // ��� �����/��������� ������ ����� �����
        // ����� ���� �������, � ���� ������ ��� ����������� �� ������� ���������
        //
        if slParams[12] <> '' then
          R.Folder := slParams[12];
      end;

      R.Normalize;

      Result := inpType;
    end;
  finally
    slParams.Free;
  end;
end;

function TImportLibRusEcThread.Import:integer;
var
  FLibrary: TMHLLibrary;
  BookList: TStringList;
  i: Integer;
  j: Integer;
  R: TBookRecord;
  filesProcessed: Integer;
  unZip:TZipForge;
  CurrentFile: string;
  ArchItem: TZFArchiveItem;

  FileStream : TMemoryStream;

begin
  filesProcessed := 0;
  i := 0;
  FLibrary := TMHLLibrary.Create(nil);
  try
    FLibrary.DatabaseFileName := DBFileName;

    FLibrary.Active := True;

    FLibrary.BeginBulkOperation;
    try
      unZip := TZipForge.Create(Nil);
      unZip.BaseDir := Settings.TempPath;
      unZip.FileName := FInpxFileName;
      unZip.OpenArchive;
      unZip.ExtractFiles('*.*');
      try
        BookList := TStringListEx.Create;
        if (unZip.FindFirst('*.*',ArchItem,faAnyFile-faDirectory)) then
        repeat
          //
          // ���������� TStringListEx ��� ������ UTF8 �����
          //

          CurrentFile:= ArchItem.FileName;

          if not(isOnlineCollection(CollectionType)) and
            ( CurrentFile = 'extra.inp')
            then Continue;

          Teletype(Format('������������ ���� %s', [CurrentFile]), tsInfo);
          BookList.LoadFromFile(Settings.TempPath + CurrentFile,TEncoding.UTF8);
          for j := 0 to BookList.Count - 1 do
          begin
            case ParseData(BookList[j], R) of
              inpFormat_10: begin
                if isOnlineCollection(CollectionType) then
                begin
                  //
                  // �\������ ����\1234 ������ �����.fb2.zip
                  //
                  R.Folder := R.GenerateLocation + FB2ZIP_EXTENSION;

                  //
                  // �������� ������� � ������������� �����
                  //
                  R.Local := FileExists(FCollectionRoot + R.Folder);
                end
                else
                begin
                  //
                  // 98058-98693.inp -> 98058-98693.zip
                  //
                  R.Folder := ChangeFileExt(CurrentFile, ZIP_EXTENSION);
                  //
                  // ����� ����� ������ zip-�
                  //
                  R.InsideNo := j;
                end;

                FLibrary.InsertBook(R);
              end;
              inpFormat_11: begin
                if isOnlineCollection(CollectionType) then
                begin
                  //
                  // �\������ ����\1234 ������ �����.fb2.zip
                  //
                  R.Folder := R.GenerateLocation + FB2ZIP_EXTENSION;

                  //
                  // �������� ������� � ������������� �����
                  //
                  R.Local := FileExists(FCollectionRoot + R.Folder);
                end;

                //
                // ��� ��������� ��������� ������ �� ����� ������ � ������� ����� � ��
                // ��������� � ������� ParseData.
                // ���� � INPX-����� ������� ���� Folder, ���������� ��� �� ������� ���������
                //
                if R.Folder = '' then
                  R.Folder := ChangeFileExt(CurrentFile, ZIP_EXTENSION);

                FLibrary.InsertBook(R);
              end;
            else
              ; // ���� ��������� ������� - inpUnknown, �� ������ ������
            end;

            Inc(filesProcessed);
            if (filesProcessed mod ProcessedItemThreshold) = 0 then
                SetComment(Format('��������� %u ����', [filesProcessed]));
          end; // for
          inc(i);
          SetProgress((i + 1) * 100 div unZip.FileCount);
          if Canceled then
            Break;
        until (not unZip.FindNext(ArchItem));
      finally
        BookList.Free;
      end;
      SetComment(Format('��������� %u ����', [filesProcessed]));
    finally
      unZip.Free;
    end;
  finally
    FLibrary.EndBulkOperation;
    FLibrary.Free;
  end;
end;

procedure TImportLibRusEcThread.SetCollectionRoot(const Value: string);
begin
  FCollectionRoot := IncludeTrailingPathDelimiter(Value);
end;

procedure TImportLibRusEcThread.WorkFunction;
begin
  Import;
end;

end.

