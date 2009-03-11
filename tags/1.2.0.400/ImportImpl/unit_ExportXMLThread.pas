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

uses dm_main, dm_user, unit_globals;

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

  totalBooks := DMMain.tblBooks.RecordCount;
  processedBooks := 0;

  DMMain.tblAuthor_Master.Active := True;
  try
    DMMain.tblAuthor_Detail.Active := True;
    try
      DMMain.tblBooks.First;
      while not DMMain.tblBooks.Eof do
      begin
        if Canceled then
          Exit;

        DMMain.GetCurrentBook(R);

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

        DMMain.tblBooks.Next;

        Inc(processedBooks);
        if (processedBooks mod ProcessedItemThreshold) = 0 then
          SetComment(Format('���������� ����: %u �� %u', [processedBooks, totalBooks]));
        SetProgress(processedBooks * 100 div totalBooks);
      end;

      SetComment(Format('���������� ����: %u �� %u', [processedBooks, totalBooks]));

    finally
      DMMain.tblAuthor_Detail.Active := False;
    end;
  finally
    DMMain.tblAuthor_Master.Active := False;
  end;

  SetComment('��������� ��������. ���������, ����������.');
  FCollection.OwnerDocument.SaveToFile(FXMLFileName);
end;

end.

