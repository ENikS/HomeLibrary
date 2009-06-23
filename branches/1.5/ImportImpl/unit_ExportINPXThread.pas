unit unit_ExportINPXThread;

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

interface

uses
  Classes,
  SysUtils,
  unit_WorkerThread,
  unit_Globals,
  unit_Settings;

type
  TExport2INPXThread = class(TWorker)
  private
    FINPXFileName: string;

  protected
    procedure WorkFunction; override;
    function INPRecordCreate(const R: TBookRecord; var INPData: String;
      const NewINPFormat : Boolean = False): Boolean;
    function INPXPack(const INPXFileName: string; const FileList: TStrings): Boolean;
  public
    property INPXFileName: string read FINPXFileName write FINPXFileName;
  end;

implementation

uses
  Forms,
  StrUtils,
  dm_collection,
  dm_user,
  ZipForge
  ;

const
  BOOKS_INFO_FILE = 'books.inp';
  VERSION_INFO_FILE = 'version.info';

{ TImportXMLThread }

(*

������ ������, ������������ �������� ��������� ���������� � ������ �� ����� ���������.
��!, 1) �� �� ���������� �������-��������, 2) ��� ������������� ���������� ��� �������� ��������� �����.
��������, ����� ��������� ����� ���������, �� ���� ��������� � ���.

*)

procedure TExport2INPXThread.WorkFunction;
var
  slBooksInfo: TStringList;
  slFileList : TStringList;
  cINPRecord : String;

  bCorrect : Boolean;

  nCollectionVersion: integer;
  cVersion: string;

  totalBooks: Integer;
  processedBooks: Integer;
  R: TBookRecord;
  AuthorRecord: TAuthorRecord;
  GenreRecord: TGenreRecord;
begin
  SetComment('������������ ���������.');

  totalBooks := DMCollection.tblBooks.RecordCount;
  processedBooks := 0;

  DMCollection.tblAuthor_Master.Active := True;
  try
    DMCollection.tblAuthor_Detail.Active := True;

    slFileList := TStringList.Create;
    slFileList.Clear;
    try
      slBooksInfo := TStringList.Create;
      slBooksInfo.Clear;

      DMCollection.tblBooks.First;
      while not DMCollection.tblBooks.Eof do
      begin
        if Canceled then
          Exit;

        DMCollection.GetCurrentBook(R);

        bCorrect := INPRecordCreate(R, cINPRecord, True);
        if not bCorrect then
          Exit;

        if cINPRecord <> '' then
          slBooksInfo.Add(cINPRecord);

        DMCollection.tblBooks.Next;

        Inc(processedBooks);
        if (processedBooks mod ProcessedItemThreshold) = 0 then
          SetComment(Format('���������� ����: %u �� %u', [processedBooks, totalBooks]));
        SetProgress(processedBooks * 100 div totalBooks);
      end;

      slBooksInfo.SaveToFile(Settings.TempPath + BOOKS_INFO_FILE,TEncoding.UTF8);
      slFileList.Add(Settings.TempPath + BOOKS_INFO_FILE);

      SetComment(Format('���������� ����: %u �� %u', [processedBooks, totalBooks]));
    finally
      DMCollection.tblAuthor_Detail.Active := False;
      slBooksInfo.Free;         slBooksInfo := nil;
    end;

    //������ ���� version.info
    nCollectionVersion := DMUser.ActiveCollection.Version;
    cVersion := IntToStr(nCollectionVersion); //�������� ���� � ������� '20091231'
    if Length(cVersion) <> 8 then begin       //���� ����� ������ �� ����� 8, �� �������� ������� ����
      cVersion := DateToStr(Date());          //�������� ���� � ������� '2009-12-31'
      Delete(cVersion,5,1);                   //�������� ���� � ������� '200912-31'
      Delete(cVersion,7,1);                   //�������� ���� � ������� '20091231'
    end;

    //���������� ���� version.info ����� slBooksInfo (�� ��� �� ������������)
    slBooksInfo := TStringList.Create;
    slBooksInfo.Clear;

    slBooksInfo.Add(cVersion);
    slBooksInfo.SaveToFile(Settings.TempPath + VERSION_INFO_FILE);
    slFileList.Add(Settings.TempPath + VERSION_INFO_FILE);

    slBooksInfo.Free;         slBooksInfo := nil;

    //����������� ����� � zip-����� � ������������� �����������
    INPXPack(INPXFileName, slFileList);

  finally
    slFileList.Free;          slFileList := nil;
    DMCollection.tblAuthor_Master.Active := False;
  end;

  SetComment('��������� ��������. ���������, ����������.');
end;

function TExport2INPXThread.INPXPack(const INPXFileName: string; const FileList: TStrings): Boolean;
var
  CollectionName : string;
  CollectionDBFileName :string;
  CollectionType: Integer;
  CollectionNotes : String;

  nCollectionVersion: Integer;
  cVersion: String;

  cComment : String;

  slVersion: TStringList;

  ZIP: TZipForge;
  nIndex : Integer;
begin
  Result := False;

  try
    //
    // ������� INPX-����, ���� �� ��� ����������
    //
    if FileExists(INPXFileName) then
      DeleteFile(INPXFileName);
    //
    // ������� ��������� TZipForge, �������������� � ��������� ���
    //
    ZIP := TZipForge.Create(Application.MainForm);
    ZIP.FileName := INPXFileName;
    ZIP.BaseDir := Settings.TempPath;
    ZIP.OpenArchive;
    //
    // ���������� ����� � ����� �������� ������ FileList
    //
    for nIndex := 0 to FileList.Count - 1 do
      ZIP.MoveFiles(FileList[nIndex]);
    //
    // ������������� ����������� ��� INPX-�����
    //
    CollectionName := DMUSer.ActiveCollection.Name;
    CollectionDBFileName := DMUser.ActiveCollection.DBFileName;
    CollectionType := DMUser.ActiveCollection.CollectionType;

    if DMUSer.ActiveCollection.Notes <> '' then
        CollectionNotes := DMUSer.ActiveCollection.Notes
      else
        CollectionNotes := '������ �� ' + DateToStr(Now);

    cComment := CollectionName + #13 + #10 +
      ExtractFileName(CollectionDBFileName) + #13 + #10 +
      IntToStr(CollectionType) + #13 + #10 +
      CollectionNotes;

    ZIP.Comment := cComment;
    ZIP.CloseArchive;

    Result := True;
  finally
    ZIP.Free;           ZIP := nil;
  end;
end;

function TExport2INPXThread.INPRecordCreate(const R: TBookRecord;
  var INPData: string; const NewINPFormat : Boolean = False): Boolean;
const
  FieldDelimiterChar = Chr(4);
  ItemDelimiterChar = ':';
  SubItemDelimiterChar = ',';
var
  nIndex : integer;
  nParamIndex: integer;

  slParams: TStringList;
  cParam: String;
  cFileExt : string;
begin
  Result := False;

  slParams := TStringList.Create;
  try
    slParams.Clear;
    nParamIndex := -1;
    //
    // ������ �������
    //
    cParam := '';
    for nIndex := 0 to R.AuthorCount - 1 do begin
      cParam :=  cParam +
        Trim(R.Authors[nIndex].FLastName) + SubItemDelimiterChar +
        Trim(R.Authors[nIndex].FFirstName) + SubItemDelimiterChar +
        Trim(R.Authors[nIndex].FMiddleName) + ItemDelimiterChar;
    end;
    slParams.Add(cParam);  //parameter index 0 - authors list

    if cParam = '' then
      cParam := ItemDelimiterChar;
    //
    // ������ ������
    //
    cParam := '';
    for nIndex := 0 to R.GenreCount - 1 do begin
      cParam := cParam +
        R.Genres[nIndex].GenreFb2Code +
        ItemDelimiterChar;
    end;
    if cParam = '' then
      cParam := ItemDelimiterChar;
    slParams.Add(cParam);  //parameter index 1 - genres list
    //
    // ��������
    //
    cParam := Trim(R.Title);
//    StringCodePage('dfg');
    slParams.Add(cParam);   //parameter index 2 - book title

    //
    // �����
    //
    cParam := Trim(R.Series);
    slParams.Add(cParam);   //parameter index 3 - book serie title
    //
    // ����� ������ �����
    //
    cParam := IntToStr(R.SeqNumber);
    slParams.Add(cParam);   //parameter index 4 - book serie no

    //
    // ��� �����, ������, ????, ������� ��������� �����
    //
    cParam := CheckSymbols(Trim(R.FileName));
    slParams.Add(cParam);   //parameter index 5 - book filename

    cParam := IntToStr(R.Size);
    slParams.Add(cParam);   //parameter index 6 - unpacked book filesize

    cParam := IntToStr(R.LibID);
    slParams.Add(cParam);   //parameter index 7 - book LibID

    cParam := IfThen(R.Deleted, '1', '0');
    slParams.Add(cParam);   //parameter index 8 - book deleted flag

    cFileExt := R.FileExt;
    Delete(string(cFileExt),1,1);
    cParam := cFileExt;
    slParams.Add(cParam);   //parameter index 9 - book fileext

    DateSeparator := '-';
    ShortDateFormat := 'yyyy-mm-dd';
    cParam := DateToStr(R.Date);
    slParams.Add(cParam);   //parameter index 10 - book data added

    if NewINPFormat then begin // New parameters block
      cParam := IntToStr(R.InsideNo);
      slParams.Add(cParam); //parameter index 11 - File InsideNo in archive

      cParam := R.Folder;
      slParams.Add(cParam); //parameter index 12 - Base folder/base archive name
    end;

    INPData := '';
    for nIndex := 0 to (slParams.Count - 1) do
      INPData := INPData + slParams[nIndex] + FieldDelimiterChar;

    Result := True;
  finally
    slParams.Free;        slParams := nil;
  end;
end;


end.

