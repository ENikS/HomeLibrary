(* *****************************************************************************
  *
  * MyHomeLib
  *
  * Copyright (C) 2008-2010 Aleksey Penkov
  *
  * Author(s)           Nick Rymanov    nrymanov@gmail.com
  *                     Aleksey Penkov  alex.penkov@gmail.com
  * Created             22.02.2010
  * Description
  *
  * $Id$
  *
  * History
  * NickR 02.03.2010    ��� ����������������
  * NickR 08.04.2010    ������ �������� �����������
  *
  ****************************************************************************** *)

unit unit_Import;

interface

uses
  unit_Globals,
  unit_Interfaces;
  
procedure ImportFB2(const CollectionID: Integer);

procedure ImportFB2ZIP(const CollectionID: Integer);

procedure ImportFBD(const CollectionID: Integer);

implementation

uses
  Forms,
  unit_ImportFB2Thread,
  unit_ImportFB2ZIPThread,
  unit_ImportFBDThread,
  frm_ImportProgressForm,
  frm_ImportProgressFormEx,
  unit_Consts;

procedure ImportFB2(const CollectionID: Integer);
var
  worker: TImportFB2Thread;
  frmProgress: TImportProgressFormEx;
begin
  worker := TImportFB2Thread.Create(CollectionID);
  try
    frmProgress := TImportProgressFormEx.Create(Application);
    try
      frmProgress.WorkerThread := worker;
      frmProgress.btnSaveLog.Visible := True;
      frmProgress.ShowModal;
    finally
      frmProgress.Free;
    end;
  finally
    worker.Free;
  end;
end;

procedure ImportFB2ZIP(const CollectionID: Integer);
var
  worker: TImportFB2ZIPThread;
  frmProgress: TImportProgressFormEx;
begin
  worker := TImportFB2ZIPThread.Create(CollectionID);
  try
    frmProgress := TImportProgressFormEx.Create(Application);
    try
      frmProgress.WorkerThread := worker;
      frmProgress.btnSaveLog.Visible := True;
      frmProgress.ShowModal;
    finally
      frmProgress.Free;
    end;
  finally
    worker.Free;
  end;
end;

procedure ImportFBD(const CollectionID: Integer);
var
  worker: TImportFBDThread;
  frmProgress: TImportProgressFormEx;
begin
  worker := TImportFBDThread.Create(CollectionID);
  try
    frmProgress := TImportProgressFormEx.Create(Application);
    try
      frmProgress.WorkerThread := worker;
      frmProgress.btnSaveLog.Visible := True;
      frmProgress.ShowModal;
    finally
      frmProgress.Free;
    end;
  finally
    worker.Free;
  end;
end;

end.

