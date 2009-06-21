{******************************************************************************}
{                                                                              }
{ MyHomeLib                                                                    }
{                                                                              }
{ Version 0.9                                                                  }
{ 20.08.2008                                                                   }
{ Copyright (c) Aleksey Penkov  alex.penkov@gmail.com                          }
{                                                                              }
{                                                                              }
{******************************************************************************}

unit unit_SyncOnLineThread;

interface

uses
  Classes,
  SysUtils,
  unit_WorkerThread,
  Windows;

type
  TSyncOnLineThread = class(TWorker)
  private

  protected
    procedure WorkFunction; override;
  public

  end;

implementation

uses
  dm_user,
  dm_collection,
  unit_globals,
  unit_database,
  unit_Consts,
  Forms;

{ TImportXMLThread }

procedure TSyncOnLineThread.WorkFunction;
var
  totalBooks: Integer;
  processedBooks: Integer;
  Root: string;
  IDStr: string;
  TmpFolder: String;

  local: boolean;
begin
  totalBooks := dmCollection.tblBooks.RecordCount;
  processedBooks := 0;
  Root := IncludeTrailingPathDelimiter(DMUser.ActiveCollection.RootFolder);

  try
    dmCollection.tblBooks.First;
    while not dmCollection.tblBooks.Eof do
    begin
      if Canceled then
          Exit;

      //  ���������������� ������ ������
      //  ���������, ���� �� ���� � ������ ������� (��� ID � ����� �����)
      //
      { TODO -oAlex : ����� �����-�� ����� ���������������� ����� ����� ������ }
    try
      IDStr := dmCollection.tblBooksLibID.AsString + ' ';
      TmpFolder := dmCollection.tblBooksFolder.Value;
      StrReplace(IDStr, '', TmpFolder);              // ������� Id �� �����
      if FileExists(Root + TmpFolder)  then
      begin
          // ���� ����, ��������������� � ��������� ������� � ����
        dmCollection.SetLocalStatus(dmCollection.tblBooksId.Value, RenameFile(Root + TmpFolder, Root + dmCollection.tblBooksFolder.Value));
      end;
      //
      //  ��������� ��� �� ���� ������� ����� � ������ ������� � ����
      //


      Local := FileExists(Root + dmCollection.tblBooksFolder.Value);

      if dmCollection.tblBooksLocal.Value <> local then
        dmCollection.SetLocalStatus(dmCollection.tblBooksId.Value,Local);
    except
      on E:Exception do
        Application.MessageBox(PChar('�����-�� �������� � ������ ' + TmpFolder),'',MB_OK);
    end;

      dmCollection.tblBooks.Next;

      Inc(processedBooks);
      if (processedBooks mod ProcessedItemThreshold) = 0 then
          SetComment(Format('���������� ����: %u �� %u', [processedBooks, totalBooks]));
      SetProgress(processedBooks * 100 div totalBooks);
    end;
    SetComment(Format('���������� ����: %u �� %u', [processedBooks, totalBooks]));
//  except
//    on E:Exception do
//      Application.MessageBox(PChar(TmpFolder),'',MB_OK);
//
//  end;
  finally
  end;
end;

end.

