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

unit unit_ImportFBDThread;

interface

uses
  Classes,
  SysUtils,
  unit_WorkerThread,
  unit_ImportFB2ThreadBase,
  ZipForge;

type
  TImportFBDThread = class(TImportFB2ThreadBase)
  private
    FZipper: TZipForge;
  protected
    procedure AddFile2List(Sender: TObject; const F: TSearchRec); override;
    procedure ProcessFileList; override;

  public

  end;
implementation

uses
  unit_globals,
  FictionBook_21,
  unit_Helpers,
  unit_Consts,
  unit_Settings;

{ TImportFB2Thread }

procedure TImportFBDThread.AddFile2List(Sender: TObject; const F: TSearchRec);
begin
  if ExtractFileExt(F.Name) = ZIP_EXTENSION  then
  begin
    if FCheckExistsFiles then
    begin
      if FLibrary.CheckFileInCollection(F.Name, true, true) then
        Exit;
    end;

    FFiles.Add(FFilesList.LastDir + F.Name);
  end;

  //
  // ������� ������ ������ ���������� => �������� ��������
  //
  SetProgress(FFiles.Count mod 100);

  if Canceled then
    Abort;
end;

procedure TImportFBDThread.ProcessFileList;
var
  i: Integer;
  j: Integer;
  R: TBookRecord;
  AZipFileName, Ext: string;
  BookFileName, FBDFileName: string;
  book: IXMLFictionBook;
  FS: TMemoryStream;
  AddCount:Integer;
  DefectCount:Integer;
  IsValid : boolean;
  ArchiveItem: TZFArchiveItem;

begin
  AddCount := 0;
  DefectCount := 0;

  SetProgress(0);
  Teletype(Format('���������� ����� �������: %u', [FFiles.Count]));

  FZipper := TZipForge.Create(nil);
//  FZipper.Options.OEMFileNames := False;
  try

    for i := 0 to FFiles.Count - 1 do
    begin
      if Canceled then
        Break;
      IsValid := False;
      //
      // �������������� ����: H:\eBooks\�\������ ������\������������ ���� ���������� ����������.fb2.zip
      //

      //
      // �\������ ������\������������ ���� ���������� ����������.fb2.zip
      //


      AZipFileName := FFiles[i];

      Assert(ExtractFileExt(AZipFileName) = ZIP_EXTENSION);

      //
      // H:\eBooks\�\������ ������\������������ ���� ���������� ����������.fb2.zip
      //
      FZipper.FileName := AZipFileName;
      try
        FZipper.OpenArchive(fmOpenRead);
        j := 0;
        R.Clear;
        if (FZipper.FindFirst('*.*',ArchiveItem,faAnyFile-faDirectory)) then
        repeat
          Ext := ExtractFileExt(ArchiveItem.FileName);
          if  Ext = '.fbd' then
          try
            FS := TMemoryStream.Create;
            R.Folder := ExtractRelativePath(FRootPath,ExtractFilePath(FFiles[i]));
            R.FileName := ExtractFilename(FFiles[i]);
            R.Size := ArchiveItem.UncompressedSize;

            R.Date := Now;
            FZipper.ExtractToStream(ArchiveItem.FileName,FS);
            if not Assigned(FS) then
              Continue;
            try
              book := LoadFictionBook(FS);
              GetBookInfo(Book, R);
              IsValid := True;
              FBDFileName := ExtractShortFileName(ArchiveItem.FileName);
            except
              on e: Exception do
              begin
                Teletype('������ ��������� fb2: ' + AZipFileName + ' -> ' + R.FileName + '.fbd', tsError);
                //Teletype(e.Message, tsError);
                Inc(DefectCount);
              end;
            end; //try
          finally
            FS.Free;
          end
          else
            begin
              R.InsideNo := j;
              R.FileExt := Ext;
              BookFileName := ExtractShortFileName(ArchiveItem.FileName);
            end;
          inc(j);
        until (not FZipper.FindNext(ArchiveItem));
        if IsValid and (BookFileName = FBDFileName)
           and (FLibrary.InsertBook(R, True, True)<>0)
            Then Inc(AddCount)
            else Teletype('������ FBD: ' + AZipFileName, tsError);

        FZipper.CloseArchive;
      except
        on e: Exception do
           Teletype('������ ���������� ������: ' + AZipFileName, tsError);
      end;
      if (i mod ProcessedItemThreshold) = 0 then
        SetComment(Format('���������� �������: %u �� %u', [i + 1, FFiles.Count]));
      SetProgress((i + 1) * 100 div FFiles.Count);
    end;
  finally
    FreeAndNil(FZipper);
  end;

  SetComment(Format('���������� �������: %u �� %u', [FFiles.Count, FFiles.Count]));

  if FFiles.Count > 0 then
    Teletype(Format('��������o ����: %u, ��������� ����: %u', [AddCount, DefectCount]));
end;

end.

