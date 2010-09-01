unit unit_libupdateThread;

interface

uses
  Windows,
  Classes,
  SysUtils,
  unit_ImportInpxThread,
  ABSMain,
  IdHTTP,
  IdComponent;

type
  TDownloadProgressEvent = procedure (Current, Total: Integer) of object;
  TDownloadSetCommentEvent = procedure (const Current, Total: string) of object;

  TLibUpdateThread = class(TImportInpxThread)
  private
    FidHTTP: TidHTTP;
    FDownloadSize: Integer;
    FStartDate : TDateTime;
    FUpdated: Boolean;

    function ReplaceFiles: Boolean;

  protected
    procedure WorkFunction; override;
    procedure HTTPWorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: int64);
    procedure HTTPWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
    procedure HTTPWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: int64);

  public
    property Updated: Boolean read FUpdated;
  end;

implementation

uses
  DateUtils,
  unit_Globals,
  dm_collection,
  dm_user,
  unit_Consts,
  unit_Settings,
  unit_WorkerThread,
  unit_Database;

resourcestring
  rstrDownloadProgress = '���������: %u%% �� %u ����';
  rstrCheckingUpdate = '��������� ������� ���������� �������� ���� ...';
  rstrCheckingExtraUpdate = '��������� ������� ���������� ��� on-line ...';
  rstrErrorCheckingUpdate = '������. �� ������� ��������� ����������.';
  rstrErrorDownloadUpdate = '������. �� ������� ������� ����������.';
  rstrReady = '������';
  rstrDownloadingUpdates = '�������� ���������� ...';
  rstrYouHaveLatestListsVersion = '� ��� ����� ������ ������ �������.';
  rstrUpdatingFromLocalArchive = '���������� �� ���������� ������';
  rstrListsUpdateIsAvailable = '�������� ���������� ������� �� ������ %d';
  rstrListsExtraUpdateIsAvailable = '�������� ���������� on-line ������� �� ������ %d';
  rstrNothingToUpdate = '������ ���������!';
  rstrUpdateComplete = '���������� ���������.';
  rstrRemovingOldCollection = '�������� ������ ��������� "%s"...';
  rstrCreatingCollection = '�������� ����� ���������  "%s"...';
  rstrSpeed = '��������: %s Kb/s';
  rstrConnectingToServer = '����������� � ������� ...';
  rstrCollectionUpdate = '���������� ��������� "%s" �� ������ %d:';
  rstrUpdateFailedDownload = '�������� ���������� �� �������.';
  rstrCancelledByUser = '�������� �������� �������������.';
  rstrImportIntoCollection = '������ ������ � ���������:';

{ TDownloadBooksThread }


procedure TLibUpdateThread.HTTPWork(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
var
  ElapsedTime : Cardinal;
  Speed: string;
begin

  if Canceled then
  begin
    FidHTTP.Disconnect;
    Exit;
  end;

  if FDownloadSize <> 0 then
    SetProgress(AWorkCount * 100 div FDownloadSize);

  ElapsedTime := SecondsBetween(Now,FStartDate);
  if ElapsedTime>0 then
  begin
    Speed := FormatFloat('0.00',AWorkCount/1024/ElapsedTime);
    SetComment(Format(rstrSpeed,[Speed]));
  end;
end;

procedure TLibUpdateThread.HTTPWorkBegin(ASender: TObject;
  AWorkMode: TWorkMode; AWorkCountMax: Int64);
begin
  SetComment(rstrConnectingToServer);
  FDownloadSize := AWorkCountMax;
  FStartDate := Now;
  SetProgress(0);
end;

procedure TLibUpdateThread.HTTPWorkEnd(ASender: TObject;
  AWorkMode: TWorkMode);
begin
  SetProgress(100);
  SetComment(rstrReady);
end;

function TLibUpdateThread.ReplaceFiles: boolean;
begin
  DeleteFile(Settings.SystemFileName[sfLibRusEcInpx]);
  CopyFile(Settings.SystemFileName[sfLibRusEcUpdate], Settings.SystemFileName[sfLibRusEcInpx]);
  DeleteFile(Settings.SystemFileName[sfLibRusEcUpdate]);
end;

procedure TLibUpdateThread.WorkFunction;
var
  ALibrary: TMHLLibrary;
  i: integer;
begin
  FidHTTP := TidHTTP.Create(nil);
  try
    FidHTTP.OnWork := HTTPWork;
    FidHTTP.OnWorkBegin := HTTPWorkBegin;
    FidHTTP.OnWorkEnd := HTTPWorkEnd;
    FidHTTP.HandleRedirects := True;
    SetProxySettings(FidHTTP);

    SetComment(rstrCheckingUpdate);

    try
      for i := 0 to Settings.Updates.Count - 1 do
      begin
        if not Settings.Updates[i].Available then
          Continue;

        DMUser.ActivateCollection(Settings.Updates[i].CollectionID);
        Teletype(Format(rstrCollectionUpdate, [Settings.Updates[i].Name, Settings.Updates[i].ExternalVersion]), tsInfo);

        if Settings.Updates[i].Local then
          Teletype(rstrUpdatingFromLocalArchive, tsInfo)
        else
        begin
          Teletype(rstrDownloadingUpdates, tsInfo);
          if not Settings.Updates.DownloadUpdate(i, FidHTTP) then
          begin
            Teletype(rstrUpdateFailedDownload, tsInfo);
            Continue;
          end;
        end;

        if Canceled then
        begin
          DeleteFile(Settings.WorkPath + Settings.Updates.Items[i].UpdateFile);
          Teletype(rstrCancelledByUser, tsInfo);
          Exit;
        end;

        InpxFileName := Settings.UpdatePath + Settings.Updates[i].UpdateFile;

        DBFileName := DMUser.CurrentCollection.DBFileName;
        CollectionRoot :=  IncludeTrailingPathDelimiter(DMUser.CurrentCollection.RootFolder);
        CollectionType := DMUser.CurrentCollection.CollectionType;

        if Settings.Updates[i].Full then
        begin
          //
          // TODO : �� ��������, ��� ������ �����.
          // ����� ���������� ������������, ������ �� ������...
          //
          Teletype(Format(rstrRemovingOldCollection, [Settings.Updates[i].Name]),tsInfo);

          // ������� ������ ���� ���������
          DMCollection.DBCollection.Close;
          DMCollection.DBCollection.DatabaseFileName := DBFileName;
          DMCollection.DBCollection.DeleteDatabase;

          // ������� ��� ������
          Teletype(Format(rstrCreatingCollection, [Settings.Updates[i].Name]),tsInfo);
          TMHLLibrary.CreateCollectionTables(DBFileName, GENRES_FB2_FILENAME);
        end; //if FULL

        //  ���������� ������
        Teletype(rstrImportIntoCollection, tsInfo);

        Import(not Settings.Updates[i].Full);

        DMUser.CurrentCollection.Edit;
        try
          DMUser.CurrentCollection.Version := GetLibUpdateVersion(True);
          DMUser.CurrentCollection.Save;
        except
          DMUser.CurrentCollection.Cancel;
          raise;
        end;

        Teletype(rstrReady,tsInfo);
      end; //for .. with

      Teletype(rstrUpdateComplete,tsInfo);
      for i := 0 to Settings.Updates.Count - 1 do
      begin
        if FileExists(Settings.UpdatePath + Settings.Updates[i].UpdateFile) then
          if Settings.Updates[i].UpdateFile <> 'librusec_update.zip' then
            DeleteFile(Settings.UpdatePath + Settings.Updates[i].UpdateFile)
          else
            ReplaceFiles;
       end;

       SetComment(rstrReady);
    except
      on E: Exception do
        DeleteFile(Settings.WorkPath + Settings.Updates.Items[i].UpdateFile);
    end;
  finally
    FreeAndNil(FidHTTP);
  end;
end;

end.
