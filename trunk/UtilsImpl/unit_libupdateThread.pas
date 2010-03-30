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
  TDownloadProgressEvent = procedure (Current,Total: Integer) of object;
  TDownloadSetCommentEvent = procedure (const Current, Total: string) of object;

  TLibUpdateThread = class(TImportLibRusEcThread)
  private
    FidHTTP:TidHTTP;

    FDownloadSize: Integer;

    FStartDate : TDateTime;

    FUpdated: boolean;

    function ReplaceFiles:boolean;

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
    with Settings.Updates.Items[i] do
    begin
      if not Available then
        Continue;

      DMUser.ActivateCollection(CollectionID);
      Teletype(Format('���������� ��������� "%s" �� ������ %d:', [Name, Version]), tsInfo);

      if Local then
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

      InpxFileName := Settings.UpdatePath + UpdateFile;

      DBFileName := DMUser.CurrentCollection.DBFileName;
      CollectionRoot :=  IncludeTrailingPathDelimiter(DMUser.CurrentCollection.RootFolder);
      CollectionType := DMUser.CurrentCollection.CollectionType;

      if Full then
      begin
        Teletype(Format(rstrRemovingOldCollection, [Name]),tsInfo);

        // ������� ������ ���� ���������
        DMCollection.DBCollection.Close;
        DMCollection.DBCollection.DatabaseFileName := DBFileName;
        DMCollection.DBCollection.DeleteDatabase;

        // ������� ��� ������
        Teletype(Format(rstrCreatingCollection, [Name]),tsInfo);
        ALibrary := TMHLLibrary.Create(nil);
        try
          ALibrary.CreateCollectionTables(DBFileName, GENRES_FB2_FILENAME);
        finally
          ALibrary.Free;
        end;
      end; //if FULL

      //  ���������� ������
      Teletype('������ ������ � ���������:',tsInfo);

      Import(not Full);

      DMUser.CurrentCollection.Edit;
      DMUser.CurrentCollection.Version := GetLibUpdateVersion(True);
      DMUser.CurrentCollection.Save;

      Teletype(rstrReady,tsInfo);
    end; //for .. with

    Teletype(rstrUpdateComplete,tsInfo);
    for I := 0 to Settings.Updates.Count - 1 do
    with Settings.Updates.Items[i] do
      if FileExists(Settings.UpdatePath + UpdateFile) then
        if UpdateFile <> 'librusec_update.zip' then
          DeleteFile(Settings.UpdatePath + UpdateFile)
        else
          ReplaceFiles;

     SetComment(rstrReady);
  except
    on E: Exception do
      DeleteFile(Settings.WorkPath + Settings.Updates.Items[i].UpdateFile);
  end;
end;

end.
