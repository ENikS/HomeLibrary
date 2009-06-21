unit unit_libupdateThread;
interface

uses
  Classes,
  SysUtils,
  unit_ImportLibRusEcThread,
  unit_Globals,
  Dialogs,
  ABSMain,
  IdHTTP,
  Forms,
  IdComponent,
  IdHTTPHeaderInfo;



type

  TDownloadProgressEvent = procedure (Current,Total: Integer) of object;
  TDownloadSetCommentEvent = procedure (const Current, Total: string) of object;

  TLibUpdateThread = class(TImportLibRusEcThread)
  private
    FidHTTP:TidHTTP;

    FDownloadSize: integer;

    FOnSetProgress: TDownloadProgressEvent;
    FOnSetComment: TDownloadSetCommentEvent;

    FCurrentComment: string;
    FTotalComment: string;
    FCurrentProgress: Integer;
    FTotalProgress: Integer;

    FStartDate : TDateTime;
    FIgnoreErrors: boolean;

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
  dm_collection,
  dm_user,
  unit_Consts,
  unit_Settings,
  unit_WorkerThread,
  unit_Database,
  StrUtils;

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
  RenameFile(Settings.SystemFileName[sfLibRusEcUpdate],Settings.SystemFileName[sfLibRusEcinpx]);
end;

procedure TLibUpdateThread.WorkFunction;
var
  Version : integer;
  DelOld: boolean;
  ALibrary: TMHLLibrary;
  i,j: integer;
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
    with  Settings.Updates.Items[i] do
    begin
      if not Available then Continue;
      DMUser.ActivateCollection(CollectionID);
      Teletype(Format('���������� ��������� "%s" �� ������ %d:',[Name,Version]),tsInfo);
      Teletype('�������� ���������� ...',tsInfo);

      if not Settings.Updates.DownloadUpdate(I, FidHTTP) then
      begin
        Teletype('�������� ���������� �� �������.',tsInfo);
        Continue;
      end;

      InpxFileName := Settings.WorkPath + FileName;

      DBFileName := DMUser.ActiveCollection.DBFileName;
      CollectionRoot :=  IncludeTrailingPathDelimiter(DMUser.ActiveCollection.RootFolder);
      CollectionType := DMUser.ActiveCollection.CollectionType;

      if Full then
      begin
        Teletype(Format(rstrRemovingOldCollection, [Name]),tsInfo);

        // ������� ������ ���� ���������
        dmCollection.DBCollection.Close;
        dmCollection.DBCollection.DatabaseFileName := DBFileName;
        dmCollection.DBCollection.DeleteDatabase;

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
      Teletype('������ ...',tsInfo);

      Import;
      DMUser.ActiveCollection.Version := GetLibUpdateVersion(True);
      Teletype(rstrReady,tsInfo);
    end; //for .. with

  Teletype(rstrUpdateComplete,tsInfo);

  finally
    for I := 0 to Settings.Updates.Count - 1 do
    with Settings.Updates.Items[i] do
      if FileExists(Settings.WorkPath + FileName) then
        if FileName <> 'librusec_update.zip' then
          DeleteFile(Settings.WorkPath + FileName)
        else
          ReplaceFiles;
  end;

  SetComment(rstrReady);
end;

end.
