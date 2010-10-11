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
  *
  ****************************************************************************** *)

unit unit_DownloadBooksThread;

interface

uses
  Classes,
  unit_WorkerThread,
  unit_globals,
  Dialogs,
  Forms,
  unit_Interfaces,
  unit_Downloader;

type
  TProgressEvent2 = procedure(Current, Total: Integer) of object;
  TSetCommentEvent2 = procedure(const Current, Total: string) of object;

  TDownloadBooksThread = class(TWorker)
  private
    FDownloader : TDownloader;

    FBookIdList: TBookIdList;

    FOnSetProgress2: TProgressEvent2;
    FOnSetComment2: TSetCommentEvent2;

    FCurrentComment: string;
    FTotalComment: string;
    FCurrentProgress: Integer;
    FTotalProgress: Integer;

    FIgnoreErrors: boolean;

    FNoPause: boolean;

    procedure DoSetComment2;
    procedure SetComment2(const Current, Total: string);

    procedure DoSetProgress2;
    procedure SetProgress2(Current, Total: integer);
    //procedure SetCancelledOperation;

  protected
    procedure WorkFunction; override;

  public
    property BookIdList: TBookIdList read FBookIdList write FBookIdList;

    property OnProgress2: TProgressEvent2 read FOnSetProgress2 write FOnSetProgress2;
    property OnSetComment2: TSetCommentEvent2 read FOnSetComment2 write FOnSetComment2;
  end;

implementation

uses
  Windows,
  SysUtils,
  dm_user,
  frm_main;

resourcestring
  rstrDownloaded = '������� ������: %u �� %u';
  rstrConnecting = '�����������...';
  rstrIgnoreDownloadErrors = '������������ ������ �������� ?';
  rstrDone = '������';
  rstrOperationCompleted = '���������� �������� ...';

procedure TDownloadBooksThread.WorkFunction;
var
  i: Integer;
  totalBooks: Integer;
  Res: integer;
  FSystemDB: ISystemData;
begin
  FSystemDB := DMUser.GetSystemDBConnection;
  try
    Canceled := False;
    FIgnoreErrors := False;

    FDownloader := TDownloader.Create;
    try
      FDownloader.OnSetComment := SetComment2;
      FDownloader.OnProgress := SetProgress2;

      totalBooks := High(FBookIdList) + 1;
      SetComment2(' ', Format(rstrDownloaded, [0, totalBooks]));

      for i := 0 to totalBooks - 1 do
      begin
        SetComment2(rstrConnecting, '');

        FBookIdList[i].Res := FDownloader.Download(FSystemDB, FBookIdList[i].BookKey);
        if
          (not Canceled) and                // ��� �������� ������, � �� ������ �������� �������������
          (not FBookIdList[i].Res) and      //
          (i < totalBooks - 1) and          // ��� ��������� ����� ������ ������ �� �����
          (not Settings.ErrorLog) and       //
          (not FIgnoreErrors)               //
        then
        begin
          Res := ShowMessage(rstrIgnoreDownloadErrors, MB_ICONQUESTION or MB_YESNO);
          FIgnoreErrors := (Res = IDYES);
        end;

        SetComment2(rstrDone, Format(rstrDownloaded, [i + 1, totalBooks]));
        SetProgress2(100, (i + 1) * 100 div totalBooks);

        if Canceled then
        begin
          SetComment2(' ', rstrOperationCompleted);
          Break;
        end;

        if FNoPause then
          Sleep(Settings.DwnldInterval);
      end;
    finally
      FreeAndNil(FDownloader);
    end;
  finally
    FSystemDB.ClearCollectionCache;
    FSystemDB := nil;
  end;
end;

//------------------------------------------------------------------------------

procedure TDownloadBooksThread.DoSetComment2;
begin
  if Assigned(FOnSetComment2) then
    FOnSetComment2(FCurrentComment, FTotalComment);
end;

{
procedure TDownloadBooksThread.SetCancelledOperation;
begin
  frmMain.FCancelled := True;
end;
}

procedure TDownloadBooksThread.SetComment2(const Current, Total: string);
begin
  FCurrentComment := Current;
  FTotalComment := Total;
  Synchronize(DoSetComment2);
end;

procedure TDownloadBooksThread.SetProgress2(Current, Total: integer);
begin
  FCurrentProgress := Current;
  FTotalProgress := Total;
  Synchronize(DoSetProgress2);
end;


procedure TDownloadBooksThread.DoSetProgress2;
begin
  if Assigned(FOnSetProgress2) then
    FOnSetProgress2(FCurrentProgress, FTotalProgress);
end;

end.
