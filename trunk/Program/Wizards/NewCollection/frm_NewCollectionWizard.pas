(* *****************************************************************************
  *
  * MyHomeLib
  *
  * Copyright (C) 2008-2010 Aleksey Penkov
  *
  * Author(s)           Nick Rymanov (nrymanov@gmail.com)
  *                     Aleksey Penkov alex.penkov@gmail.com
  * Created             20.08.2008
  * Description
  *
  * $Id$
  *
  * History
  * NickR 03.09.2010    ������ �� XML ������ �� ��������������. ������ ��������������� �������� �������.
  *
  ****************************************************************************** *)

unit frm_NewCollectionWizard;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  unit_WorkerThread,
  unit_NCWParams,
  frame_WizardPageBase,
  frame_NCWWelcom,
  frame_NCWOperation,
  frame_NCWInpxSource,
  frame_NCWDownload,
  frame_NCWCollectionNameAndLocation,
  frame_NCWCollectionFileTypes,
  frame_NCWSelectGenreFile,
  frame_NCWProgress,
  frame_NCWFinish,
  frm_MHLWizardBase;

type
  TNewCollectionWizard = class(TMHLWizardBase)
  private const
    WELCOM_PAGE_ID = 0;
    OPERATION_PAGE_ID = 1;
    INPXSOURCE_PAGE_ID = 2;
    DOWNLOAD_PAGE_ID = 3;
    NAMEANDLOCATION_PAGE_ID = 4;
    FILETYPES_PAGE_ID = 5;
    GENREFILE_PAGE_ID = 6;
    PROGRESS_PAGE_ID = 7;
    FINISH_PAGE_ID = 8;

  private
    FWelcomPage: TframeNCWWelcom;
    FCollectionTypePage: TframeNCWOperation;
    FInpxSourcePage: TframeNCWInpxSource;
    FDownloadPage: TframeNCWDownload;
    FNameAndLocationPage: TframeNCWNameAndLocation;
    FFileTypesPage: TframeNCWCollectionFileTypes;
    FSelectGenreFilePage: TframeNCWSelectGenreFile;
    FProgressPage: TframeNCWProgress;
    FFinishPage: TframeNCWFinish;

    FParams: TNCWParams;
    FWorker: TWorker;

    procedure CorrectParams;
    function CreateCollection: Boolean;
    function StartImportData: Boolean;
    procedure RegisterCollection;

    procedure CloseWorker;
    procedure CancelWorker;

    function ShowMessage(const Text: string; Flags: Longint = MB_OK): Integer;

  protected
    procedure PMWorkerDone(var Message: TMessage); message PM_WORKERDONE;

    procedure InitWizard; override;
    function IsPageVisible(PageIndex: Integer): Boolean; override;
    procedure AfterShowPage; override;
    function CanCloseWizard: Boolean; override;
    procedure CancelWizard; override;

  public
    destructor Destroy; override;
  end;

var
  NewCollectionWizard: TNewCollectionWizard;

implementation

uses
  Math,
  unit_MHL_strings,
  unit_Globals,
  unit_Settings,
  unit_Interfaces,
  unit_SystemDatabase,
  unit_ImportInpxThread;

{$R *.dfm}

resourcestring
  rstrCreationCollection = '�������� ���������';
  rstrDataImport = '������ �����x';
  rstrDataImporting = '����������� ������';
  rstrRegistration = '������������ ���������';
  rstrDownloadFailed = '������� �� �������. ������ �������� �� ������.';
  rstrImportDoneWithErrors = '������ �������� � ��������. ���������� ����������� ��������� ?';

destructor TNewCollectionWizard.Destroy;
begin
  CloseWorker;
  inherited;
end;

procedure TNewCollectionWizard.InitWizard;
var
  frame: TWizardPageBase;
begin
  //
  // ����������������� ��������� �� ���������
  //
  FParams.Operation := otNew;
  FParams.CollectionType := ltUser;
  FParams.FileTypes := ftFB2;
  FParams.DefaultGenres := True;

  FWelcomPage := AddPage(TframeNCWWelcom) as TframeNCWWelcom;
  FCollectionTypePage := AddPage(TframeNCWOperation) as TframeNCWOperation;
  FInpxSourcePage := AddPage(TframeNCWInpxSource) as TframeNCWInpxSource;
  FDownloadPage := AddPage(TframeNCWDownload) as TframeNCWDownload;
  FNameAndLocationPage := AddPage(TframeNCWNameAndLocation) as TframeNCWNameAndLocation;
  FFileTypesPage := AddPage(TframeNCWCollectionFileTypes) as TframeNCWCollectionFileTypes;
  FSelectGenreFilePage := AddPage(TframeNCWSelectGenreFile) as TframeNCWSelectGenreFile;
  FProgressPage := AddPage(TframeNCWProgress) as TframeNCWProgress;
  FFinishPage := AddPage(TframeNCWFinish) as TframeNCWFinish;

  for frame in FPages do
    frame.Initialize(@FParams);

  SetProxySettings(FDownloadPage.HTTP);

  { TODO -oAlex -cRefactoring : �������! ����� ���� ��� ���������� � ������ �����? }
  FFinishPage.lblPageHint.Caption := '';
end;

function TNewCollectionWizard.IsPageVisible(PageIndex: Integer): Boolean;
begin
  case PageIndex of
    WELCOM_PAGE_ID:
      Result := True;

    OPERATION_PAGE_ID:
      Result := True;

    INPXSOURCE_PAGE_ID:
      Result := (FParams.Operation = otInpx);

    DOWNLOAD_PAGE_ID:
      Result := (FParams.Operation = otInpxDownload);

    NAMEANDLOCATION_PAGE_ID:
      Result := True;

    FILETYPES_PAGE_ID:
      Result := (FParams.Operation = otNew);

    GENREFILE_PAGE_ID:
      Result := (FParams.Operation = otNew) and (FParams.FileTypes = ftAny);

    PROGRESS_PAGE_ID:
      Result := True;

    FINISH_PAGE_ID:
      Result := True;
  else
    Assert(False);
    Result := True;
  end;
end;

procedure TNewCollectionWizard.AfterShowPage;
begin
  Assert(IsValidPageIndex(FCurrentPage));

  if DOWNLOAD_PAGE_ID = FCurrentPage then
  begin
    AdjustButtons([wbCancel], [wbCancel]);
    try
      if FDownloadPage.Download then
        DoChangePage(btnForward);
    except
      on E: Exception do
      begin
        MessageDlg(rstrDownloadFailed, mtError, [mbOK], 0);
        DoChangePage(btnBackward);
      end;
    end;
  end
  else if PROGRESS_PAGE_ID = FCurrentPage then
  begin
    CorrectParams;

    if not CreateCollection then
    begin
      //
      // �� �� ������ �������/���������������� ���������,
      // CancelToClose � �������� �����������
      //
      FProgressPage.ShowSaveLogPanel(True);
      AdjustButtons([wbFinish], [wbFinish]);
      Exit;
    end;

    FModalResult := mrOk;

    if not StartImportData then
    begin
      //
      // ������ ����� �� �����, ������ �������������
      // ����� ���������� �� ��������� ��������
      //
      RegisterCollection;
      DoChangePage(btnForward);
    end;
  end;
end;

function TNewCollectionWizard.CanCloseWizard: Boolean;
begin
  //
  // ���������� ������������� ������� INPX ���� ��� �������
  //
  if Assigned(FWorker) and not FWorker.Finished then
  begin
    //
    // ������� ������� ����� -> ��������� ���.
    //
    CancelWorker;
    Result := False;
    Exit;
  end;

  Result := inherited CanCloseWizard;
end;

procedure TNewCollectionWizard.CancelWizard;
begin
  if DOWNLOAD_PAGE_ID = FCurrentPage then
  begin
    FDownloadPage.Stop;
  end;

  if Assigned(FWorker) then
  begin
    //
    // ������� ������� ����� -> ��������� ���.
    //
    CancelWorker;
    Exit;
  end;

  inherited CancelWizard;
end;

procedure TNewCollectionWizard.CorrectParams;
begin
  //
  // ��������� �������� ��� ���������
  //
  if FParams.CollectionCode = 0 then
  begin
    case FParams.CollectionType of
      ltUser:              FParams.CollectionCode := IfThen(FParams.FileTypes = ftFB2, CT_PRIVATE_FB, CT_PRIVATE_NONFB);
      ltUserFB:            FParams.CollectionCode := CT_PRIVATE_FB;
      ltUserAny:           FParams.CollectionCode := CT_PRIVATE_NONFB;
      ltExternalLocalFB:   FParams.CollectionCode := CT_EXTERNAL_LOCAL_FB;
      ltExternalOnlineFB:  FParams.CollectionCode := CT_EXTERNAL_ONLINE_FB;
      ltExternalLocalAny:  FParams.CollectionCode := CT_EXTERNAL_LOCAL_NONFB;
      ltExternalOnlineAny: FParams.CollectionCode := CT_EXTERNAL_ONLINE_NONFB;
    end;
  end;

  //
  // ��� ����������� ��������� ��������� ��������� ��������� �� ���������
  //
  case FParams.CollectionType of
    ltUser: ; // ������ �� �������, ��� ������ ������ ������������

    ltUserFB, ltExternalLocalFB, ltExternalOnlineFB:
    begin
      FParams.DefaultGenres := True;
      FParams.FileTypes := ftFB2;
    end;

    ltUserAny, ltExternalLocalAny, ltExternalOnlineAny:
    begin
      FParams.FileTypes := ftAny;
    end;
  end;

  //
  // �������� ���� ������
  //
  if FParams.DefaultGenres then
  begin
    if FParams.FileTypes = ftFB2 then
      FParams.GenreFile := Settings.SystemFileName[sfGenresFB2]
    else
      FParams.GenreFile := Settings.SystemFileName[sfGenresNonFB2];
  end
  else
  begin
    //
    // ������������ �������� ��������
    //
    FParams.GenreFile := ExpandFileName(FParams.GenreFile);
  end;

  Assert(FileExists(FParams.GenreFile));
end;

function TNewCollectionWizard.CreateCollection: Boolean;
//var
//  Collection: IBookCollection;
begin
  Assert(Assigned(FProgressPage));

  Result := False;

  FProgressPage.OpenProgress;
  FProgressPage.SetComment(rstrCreationCollection);

  try
    //
    // ������� ���������
    //
    if FParams.Operation <> otExisting then
    begin
      FProgressPage.ShowTeletype(rstrCreationCollection, tsInfo);
      { TODO -oNickR -cUsability : ��������� ������������� �� ��������������� �������� � ������� �������������� }
      //Assert(not FileExists(FParams.CollectionFile));
      Assert(FileExists(FParams.GenreFile));
      {* FParams.CollectionID := *} GetSystemData.CreateCollectionDatabase(FParams.CollectionFile, FParams.GenreFile);

      //
      // ���������� �������� ���������
      //
      //Collection := GetSystemData.GetBookCollection(FParams.CollectionFile);
      //Collection.SetStringProperty(SETTING_NOTES, FParams.Notes);
      //Collection.SetIntProperty(SETTING_DATA_VERSION, UNVERSIONED_COLLECTION);
      //Collection.SetIntProperty(SETTING_CODE, FParams.CollectionCode);
      //Collection.SetStringProperty(SETTING_URL, FParams.URL);
      //Collection.SetStringProperty(SETTING_DOWNLOAD_SCRIPT, FParams.Script);
      //FProgressPage.ShowProgress(60);
    end;

    FProgressPage.ShowProgress(100);

    Result := True;
  except
    on e: Exception do
    begin
      FProgressPage.ShowTeletype(e.Message, tsError);
      if FileExists(FParams.CollectionFile) then
        DeleteFile(FParams.CollectionFile);
    end;
  end;
end;

function TNewCollectionWizard.StartImportData: Boolean;
begin
  Assert(Assigned(FProgressPage));

  if FParams.Operation in [otNew, otExisting] then
  begin
    Result := False;
    Exit;
  end;

  Assert(FParams.CollectionType <> ltUser);
  Assert(FParams.INPXFile <> '');

  Assert(not Assigned(FWorker));
  FWorker := nil;

  FWorker := TImportInpxThread.Create;
  with FWorker as TImportInpxThread do
  begin
    {* CollectionID := FParams.CollectionID; *}
    DBFileName := FParams.CollectionFile;
    CollectionRoot := FParams.CollectionRoot;
    CollectionType := FParams.CollectionCode;
    InpxFileName := FParams.INPXFile;

    case FParams.CollectionType of
      ltUserFB, ltExternalLocalFB, ltExternalOnlineFB:
        GenresType := gtFb2;

      ltUserAny, ltExternalLocalAny, ltExternalOnlineAny:
        GenresType := gtAny;

      else
        Assert(False);
    end;
  end;

  Assert(Assigned(FWorker));

  FProgressPage.SetComment(rstrDataImport);
  FProgressPage.ShowTeletype(rstrDataImporting, tsInfo);

  //
  // ���������� � ��������� ��������
  //
  FWorker.OnOpenProgress := FProgressPage.OpenProgress;
  FWorker.OnProgress := FProgressPage.ShowProgress;
  FWorker.OnCloseProgress := FProgressPage.CloseProgress;
  FWorker.OnTeletype := FProgressPage.ShowTeletype;
  FWorker.OnSetComment := FProgressPage.SetComment;
  FWorker.OnShowMessage := ShowMessage;

  FWorker.Start;

  Result := True;
end;

procedure TNewCollectionWizard.RegisterCollection;
var
  FVersion: Integer;
begin
  FProgressPage.ShowTeletype(rstrRegistration, tsInfo);

  //
  // TODO -oNickR: BUG ������ ��������� ������ �� ��������� � ���� �����.
  // ������ ������ ��������� ������ ��������������� ��� ������� �� INPX ��� ��� ���������� ���������
  //
  FVersion := 0; // GetLibUpdateVersion(True);

  //
  // TODO -oNickR -cRO Mode Support: ��������� ������������� ����
  //
  GetSystemData.RegisterCollection(
    FParams.DisplayName,
    FParams.CollectionRoot,
    FParams.CollectionFile,
    FParams.CollectionCode,
    FVersion,
    FParams.Notes,
    FParams.URL,
    FParams.Script
  );
end;

function TNewCollectionWizard.ShowMessage(const Text: string; Flags: Integer): Integer;
begin
  Result := Application.MessageBox(PChar(Text), PChar(Application.Title), Flags);
end;

procedure TNewCollectionWizard.CancelWorker;
begin
  if Assigned(FWorker) then
  begin
    if FWorker.Finished then
      Exit;

    if not FWorker.Canceled then
      if ShowMessage(rstrCancelOperationWarningMsg, MB_OKCANCEL or MB_ICONEXCLAMATION) = IDCANCEL then
        Exit;

    FWorker.Cancel;
    AdjustButtons([], []);
  end;
end;

procedure TNewCollectionWizard.CloseWorker;
begin
  if Assigned(FWorker) then
  begin
    FWorker.WaitFor;
    FreeAndNil(FWorker);
  end;
end;

//
// ������� ����� �������� ���� ������
//
procedure TNewCollectionWizard.PMWorkerDone(var Message: TMessage);
var
  DontChangePage: Boolean;
  IgnoreErrors : Boolean;
begin
  //
  // ���� �� ����� ������ ������ ������ � ����� ����� ���������� �������������
  //
  if FProgressPage.HasErrors then
    IgnoreErrors := (MessageDlg(rstrImportDoneWithErrors, mtWarning, [mbYes,mbNo], 0) = mrYes);

  DontChangePage := (not IgnoreErrors) or FWorker.Canceled;

  //
  // ������� � ���������� ������� �����
  //
  CloseWorker;

  //
  // ��� � ������� -> ��������� �� ��������� ��������
  //
  if DontChangePage then
  begin
    //
    // TODO: ������������ ��������� �� �����������, ���� ���������� _���������_ ���������
    //
    if FProgressPage.HasErrors then
    begin
      FProgressPage.ShowSaveLogPanel(True);
      AdjustButtons([wbFinish], [wbFinish]);
    end
    else
    begin
      //
      // ������� ����� ��� ���������� �������������, ������ ��� -> ��������� �����
      //
      ModalResult := FModalResult;
    end;
  end
  else
  begin
    RegisterCollection;
    DoChangePage(btnForward);
  end;
end;

end.
