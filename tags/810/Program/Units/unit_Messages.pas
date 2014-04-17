(* *****************************************************************************
  *
  * MyHomeLib
  *
  * Copyright (C) 2008-2010 Aleksey Penkov
  *
  * Author(s)           Nick Rymanov (nrymanov@gmail.com)
  * Created             12.02.2010
  * Description
  *
  * $Id$
  *
  * History
  * NickR 15.02.2010    ��� ����������������
  *
  ****************************************************************************** *)

unit unit_Messages;

interface

uses
  Windows,
  Messages,
  unit_Globals;

const
  WM_MHL_BASE = WM_APP + $0500;

  WM_MHL_CHANGELOCALSTATUS = WM_MHL_BASE + 0;

type
  PBookLocalStatus = ^TBookLocalStatus;
  TBookLocalStatus = record
    BookKey: TBookKey;
    LocalStatus: Boolean;
  end;

  TLocalStatusChangedMessage = packed record
    Msg: Cardinal;
    Unused: WPARAM;
    Params: PBookLocalStatus;
    Result: Longint;
  end;

procedure BookLocalStatusChanged(
  const BookKey: TBookKey;
  LocalStatus: Boolean
);

implementation

uses
  Forms;

procedure BookLocalStatusChanged(
  const BookKey: TBookKey;
  LocalStatus: Boolean
);
var
  Param: PBookLocalStatus;
begin
  New(Param);
  Param^.BookKey := BookKey;
  Param^.LocalStatus := LocalStatus;

  PostMessage(
    Application.MainFormHandle,
    WM_MHL_CHANGELOCALSTATUS,
    0,
    LPARAM(Param)
  );
end;

end.
