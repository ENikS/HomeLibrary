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

  TLibUpdateThread = class(TImportLibRusEcThread)
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
    property Updated: boolean read FUpdated;
  end;

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
    SetComment(Format('��������: %s Kb/s',[Speed]));
  end;
end;

procedure TLibUpdateThread.HTTPWorkBegin(ASender: TObject;
  AWorkMode: TWorkMode; AWorkCountMax: Int64);
begin
  SetComment('����������� � ������� ...');
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
  DeleteFile(Settings.SystemFileName[sfLibRusEcinpx]);
  CopyFile(Settings.SystemFileName[sfLibRusEcUpdate],Settings.SystemFileName[sfLibRusEcinpx]);
  DeleteFile(Settings.SystemFileName[sfLibRusEcUpdate]);
end;

procedure TLibUpdateThread.WorkFunction;
var
  ALibrary: TMHLLibrary;
  i: integer;
begin
  FidHTTP := TidHTTP.Create(nil);
  FidHTTP.OnWork := HTTPWork;
  FidHTTP.OnWorkBegin := HTTPWorkBegin;
  FidHTTP.OnWorkEnd := HTTPWorkEnd;
  FidHTTP.HandleRedirects := True;
  SetProxySettings(FidHTTP);

  SetComment(rstrCheckingUpdate);

  try
    for I := 0 to Settings.Updates.Count - 1 do
    begin
      if not Settings.Updates[i].Available then
        Continue;

      DMUser.ActivateCollection(Settings.Updates[i].CollectionID);
      Teletype(Format('���������� ��������� "%s" �� ������ %d:', [Settings.Updates[i].Name, Settings.Updates[i].ExternalVersion]), tsInfo);

      if Settings.Updates[i].Local then
        Teletype('���������� �� ���������� ������', tsInfo)
      else
      begin
        Teletype('�������� ���������� ...', tsInfo);
        if not Settings.Updates.DownloadUpdate(I, FidHTTP) then
        begin
            Teletype('�������� ���������� �� �������.', tsInfo);
            Continue;
        end;
      end;

      if Canceled then
      begin
        DeleteFile(Settings.WorkPath + Settings.Updates.Items[i].UpdateFile);
        Teletype('�������� �������� �������������.', tsInfo);
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
        ALibrary := TMHLLibrary.Create(nil);
        try
          ALibrary.CreateCollectionTables(DBFileName, GENRES_FB2_FILENAME);
        finally
          ALibrary.Free;
        end;
      end; //if FULL

      //  ���������� ������
      Teletype('������ ������ � ���������:', tsInfo);

      Import(not Settings.Updates[i].Full);

      DMUser.CurrentCollection.Edit;
      DMUser.CurrentCollection.Version := GetLibUpdateVersion(True);
      DMUser.CurrentCollection.Save;

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
end;

end.
