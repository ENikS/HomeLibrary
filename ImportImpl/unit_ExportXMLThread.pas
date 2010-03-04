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

unit unit_ExportXMLThread;

interface

uses
  Classes,
  SysUtils,
  unit_WorkerThread,
  unit_MHL_xml;

type
  TExport2XMLThread = class(TWorker)
  private
    FXMLFileName: string;

  protected
    procedure WorkFunction; override;

  public
    property XMLFileName: string read FXMLFileName write FXMLFileName;
  end;

implementation

uses
  dm_collection,
  dm_user,
  unit_Globals,
  unit_MHL_strings;

{ TImportXMLThread }

(*

������ ������, ������������ �������� ��������� ���������� � ������ �� ����� ���������.
��!, 1) �� �� ���������� �������-��������, 2) ��� ������������� ���������� ��� �������� ��������� �����.
��������, ����� ��������� ����� ���������, �� ���� ��������� � ���.

*)

procedure TExport2XMLThread.WorkFunction;
var
  FCollection: IXMLCollection;
  FBook: IXMLBook;
  FAuthor: IXMLAuthor;
  FGenre: IXMLGenre;
  totalBooks: Integer;
  processedBooks: Integer;
  R: TBookRecord;
  AuthorRecord: TAuthorRecord;
  GenreRecord: TGenreRecord;
begin
  SetComment('������������ ���������.');

  FCollection := NewCollection();

  FCollection.OwnerDocument.Encoding := 'UTF-8';

  FCollection.Info.Name := DMUser.ActiveCollection.Name;
  FCollection.Info.Code := Ord(DMUser.ActiveCollection.CollectionType);

  totalBooks := dmCollection.tblBooks.RecordCount;
  processedBooks := 0;

  dmCollection.tblAuthor_Master.Active := True;
  try
    dmCollection.tblAuthor_Detail.Active := True;
    try
      dmCollection.tblBooks.First;
      while not dmCollection.tblBooks.Eof do
      begin
        if Canceled then
          Exit;

        dmCollection.GetCurrentBook(R);

        FBook := FCollection.BookList.Add;
        FBook.Title := R.Title;
        FBook.Series := R.Series;
        FBook.File_.Inside_no := R.InsideNo;
        FBook.No := R.SeqNumber;
        FBook.File_.Folder := R.Folder;
        FBook.File_.Ext := R.FileExt;
        FBook.File_.Size := R.Size;
        FBook.File_. Name := R.FileName;
        FBook.Date := DateToStr(R.Date);

        for AuthorRecord in R.Authors do
        begin
          FAuthor := FBook.AuthorList.Add;
          FAuthor.Name := AuthorRecord.FirstName;
          FAuthor.Family := AuthorRecord.LastName;
          FAuthor.Middle := AuthorRecord.MiddleName;
        end;

        for GenreRecord in R.Genres do
        begin
          FGenre := FBook.GenreList.Add;
          FGenre.MHL_Code := GenreRecord.GenreCode;
          FGenre.Fb2_Code := GenreRecord.GenreFb2Code;
          FGenre.Alias := GenreRecord.Alias;
        end;

        dmCollection.tblBooks.Next;

        Inc(processedBooks);
        if (processedBooks mod ProcessedItemThreshold) = 0 then
          SetComment(Format(rstrBookProcessedMsg2, [processedBooks, totalBooks]));
        SetProgress(processedBooks * 100 div totalBooks);
      end;

      SetComment(Format(rstrBookProcessedMsg2, [processedBooks, totalBooks]));

    finally
      dmCollection.tblAuthor_Detail.Active := False;
    end;
  finally
    dmCollection.tblAuthor_Master.Active := False;
  end;

  SetComment('��������� ��������. ���������, ����������.');
  FCollection.OwnerDocument.SaveToFile(FXMLFileName);
end;

end.

