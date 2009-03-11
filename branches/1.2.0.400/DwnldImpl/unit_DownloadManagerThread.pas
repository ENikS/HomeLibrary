unit unit_DownloadManagerThread;

interface

uses
  Classes,
  IdHTTP,
  Forms,
  IdComponent,
  IdHTTPHeaderInfo,
  VirtualTrees,
  unit_Globals;

type
  TDownloadManagerThread = class(TThread)
  private
    FidHTTP:TidHTTP;

    FCanceled : boolean;
    FFinished : boolean;
    FIgnoreErrors : boolean;

    FDownloadSize : integer;
    FProgress: integer;
    FWorkCount: integer;

    FStartDate : TDateTime;

    FCurrentFile: string;
    FCurrentUrl: string;
    FID: integer;
    FCurrentNode : PVirtualNode;
    FCurrentData : PDownloadData;

    FError : boolean;

  protected
    procedure UpdateProgress;
    procedure GetCurrentFile;
    procedure Finished;
    procedure Download;
    procedure Canceled;
    procedure Execute; override;
    procedure HTTPWorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax:Int64);
    procedure HTTPWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
    procedure HTTPWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
    procedure WorkFunction;
  public
    procedure Stop;

  end;

implementation

uses
  frm_main,
  SysUtils,
  DateUtils,
  dm_main,
  IdStack,
  Windows;


procedure TDownloadManagerThread.Canceled;
begin
  FCurrentData.State := dsError;
  frmMain.tvDownloadList.RepaintNode(FCurrentNode);

  frmMain.pbDownloadProgress.Percent := 0;
  frmMain.lblDownloadState.Caption := '������';
  frmMain.lblDnldAuthor.Caption := '';
  frmMain.lblDnldTitle.Caption :=  '';

  frmMain.btnPauseDownload.Enabled := False;
  frmMain.btnStartDownload.Enabled := True;

end;

procedure TDownloadManagerThread.Download;
var
  FS: TMemoryStream;
  SL: TStringList;
begin
  FError := True;
  FS := TMemoryStream.Create;
  try
//    if FileExists(FN) then
//    begin
//      FS.LoadFromFile(FN);
//      FS.Position := FS.Size;
//      //FidHTTP.Request.Range := IntToStr(FS.Position);
//      FidHTTP.Request.ContentRangeStart := FS.Size;
//      FidHTTP.Request.ContentRangeEnd := 0;
//      FWorkCount := FS.Size;
//    end;
    try
      FidHTTP.Get(FCurrentURL, FS);

      if FCanceled then
        Exit;
      CreateFolders('', ExtractFileDir(FCurrentFile));

      FS.Position := 0;

      SL := TStringList.Create;
      try
        SL.LoadFromStream(FS);
        if SL.Count > 0 then
        begin
          if
              (Pos('DOCTYPE', SL[0]) <> 0)
              or (Pos('overload', SL[0]) <> 0)
              or (Pos('not found', SL[0]) <> 0) then
          begin
             if not FIgnoreErrors then Application.MessageBox('�������� ����� ������������� ��������!'
                             + #13 +
                             ' ����� ������� ����� ���������� � ����� "server_error.html"'
                             ,'',MB_OK);
            FError := True;
          end
          else
          begin
            FS.SaveToFile(FCurrentFile);
            FError := False;
          end;
        end;
      finally
        SL.Free;
      end;


      except
        on E: EIdSocketError do

            if E.LastError = 11001 then
              if not FIgnoreErrors then Application.MessageBox(PChar('������� �� �������! ������ �� ������.'+
                           #13+'��� ������: '+IntToStr(E.LastError)),'',mb_IconExclamation)
            else
              if not FIgnoreErrors then Application.MessageBox(PChar('������� �� �������! ������ �����������.'+
                           #13+'��� ������: '+IntToStr(E.LastError)),'',mb_IconExclamation);
        on E: Exception do
             if not FIgnoreErrors then Application.MessageBox(PChar('������� �� �������! ������ �������� �� ������ '+
                          #13+'��� ������: '+IntToStr(FidHTTP.ResponseCode)),'',mb_IconExclamation);

      end;
  finally
    FS.Free;
  end;
end;

procedure TDownloadManagerThread.Execute;
begin
  WorkFunction;
end;

procedure TDownloadManagerThread.Finished;
begin
  if FCurrentData <> nil then
  begin
    if Not Ferror then
    begin
      FCurrentData.State := dsOK ;
      DMMain.SetLocalStatus(FID,True);
    end
    else
      FCurrentData.State := dsError;
    frmMain.tvDownloadList.RepaintNode(FCurrentNode);
  end;

  frmMain.pbDownloadProgress.Percent := 0;
  frmMain.lblDownloadState.Caption := '������';
  frmMain.lblDnldAuthor.Caption := '';
  frmMain.lblDnldTitle.Caption :=  '';

  frmMain.pbDownloadProgress.Visible := False;
  frmMain.btnPauseDownload.Enabled := False;
  frmMain.btnStartDownload.Enabled := True;
end;

procedure TDownloadManagerThread.GetCurrentFile;
begin
  FFinished := True;
  if FCanceled then Exit;

  if FCurrentNode <> nil then
    FCurrentNode := frmMain.tvDownloadList.GetNext(FCurrentNode);
  if FCurrentNode = nil then FCurrentNode := frmMain.tvDownloadList.GetFirst;

  while FCurrentNode <> nil do
  begin
    FCurrentData := frmMain.tvDownloadList.GetNodeData(FCurrentNode);
    if FCurrentData.State <> dsOK then
    begin
      FCurrentUrl := FCurrentData.URL;
      FCurrentFile := FCurrentData.FileName;
      FID := FCurrentData.ID;

      FCurrentData.State := dsRun;
      frmMain.tvDownloadList.RepaintNode(FCurrentNode);

      if frmMain.Visible then
      begin
        frmMain.lblDownloadState.Caption := '����������� ...';
        frmMain.lblDnldAuthor.Caption := FCurrentData.Author;
        frmMain.lblDnldTitle.Caption := FCurrentData.Title;
        frmMain.pbDownloadProgress.Visible := True;
      end
      else
        frmMain.TrayIcon.Hint := Format('%s %s %s ����������� ...',
                                            [FCurrentData.Author,
                                             FCurrentData.Title,
                                             #13]);
      frmMain.btnPauseDownload.Enabled := True;
      frmMain.btnStartDownload.Enabled := False;

      frmMain.TrayIcon.Hint := 'MyHomeLib';

      FFinished := False;
      Break;
    end;
    FCurrentNode := frmMain.tvDownloadList.GetNext(FCurrentNode);
  end;
end;

procedure TDownloadManagerThread.HTTPWork(ASender: TObject;
  AWorkMode: TWorkMode; AWorkCount: Int64);
begin
  if FCanceled then
  begin
    FidHTTP.Disconnect;
    Exit;
  end;


  if FDownloadSize <> 0 then
  begin
    FWorkCount := AWorkCount;
    FProgress := AWorkCount * 100 div FDownloadSize;
    Synchronize(UpdateProgress);
  end;
end;

procedure TDownloadManagerThread.HTTPWorkBegin(ASender: TObject;
  AWorkMode: TWorkMode; AWorkCountMax: Int64);

begin
  FDownloadSize := AWorkCountMax;
  FProgress := FWorkCount * 100 div FDownloadSize;
  FStartDate := Now;
  Synchronize(UpdateProgress);
end;

procedure TDownloadManagerThread.HTTPWorkEnd(ASender: TObject;
  AWorkMode: TWorkMode);
begin
end;


procedure TDownloadManagerThread.Stop;
begin
  FCanceled := True;
  Synchronize(Canceled);
  Terminate;
end;

procedure TDownloadManagerThread.UpdateProgress;
var
  ElapsedTime : Cardinal;
  Speed: string;
begin
  ElapsedTime := SecondsBetween(Now,FStartDate);
  if ElapsedTime>0 then
  begin
    Speed := FormatFloat('0.00', FWorkCount/1024/ElapsedTime);
    if frmMain.Visible then
    begin
      frmMain.lblDownloadState.Caption := Format('��������: %s Kb/s',[Speed]);
      frmMain.pbDownloadProgress.Percent := FProgress;
    end
    else
     frmMain.TrayIcon.Hint := Format('%s. %s %s ��������: %s Kb/s    %d %%',
                                    [FCurrentData.Author,
                                     FCurrentData.Title,
                                     #13,
                                     Speed,FProgress])
  end;
end;

procedure TDownloadManagerThread.WorkFunction;
var
  Res: integer;
begin
  FCanceled := False;
  FIgnoreErrors := False;
  FError := False;

  FidHTTP := TidHTTP.Create(nil);
  SetProxySettings(FidHTTP);

  FidHTTP.OnWork := HTTPWork;
  FidHTTP.OnWorkBegin := HTTPWorkBegin;
  FidHTTP.OnWorkEnd := HTTPWorkEnd;
  FidHTTP.HandleRedirects := True;

  try
    Synchronize(GetCurrentFile);
    repeat
      if FError then Sleep(30000);
      Download;
      Synchronize(Finished);
      Synchronize(GetCurrentFile);
      if FError and not FIgnoreErrors and not FCanceled then
      begin
        Res := Application.MessageBox('������������ ������ �������� ?','', MB_YESNOCANCEL);
        FCanceled := (Res = IDCANCEL);
        FIgnoreErrors := (Res = IDYES);
      end;
    until FFinished or FCanceled;
    Synchronize(Finished);
  finally
    FidHTTP.Free;
  end;

end;

end.
