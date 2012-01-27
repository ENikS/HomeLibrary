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
  unit_Interfaces,
  unit_MHLArchiveHelpers;
  
procedure ImportFB2(const CollectionID: Integer; const ArchiveFormat: TArchiveFormat);

procedure ImportFBD(const CollectionID: Integer);

implementation

uses
  Forms,
  unit_ImportFB2Thread,
  unit_ImportFB2ArchiveThread,
  unit_ImportFBDThread,
  frm_ImportProgressForm,
  frm_ImportProgressFormEx,
  unit_Consts;

procedure ImportFB2;
var
  worker: TImportFB2Thread;
  frmProgress: TImportProgressFormEx;
begin
  worker := TImportFB2Thread.Create(CollectionID, ArchiveFormat);
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

