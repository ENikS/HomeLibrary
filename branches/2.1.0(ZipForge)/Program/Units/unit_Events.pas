(* *****************************************************************************
  *
  * MyHomeLib
  *
  * Copyright (C) 2008-2010 Aleksey Penkov
  *
  * Author(s)           eg
  * Created             08.10.2010
  * Description
  *
  * $Id$
  *
  * History
  *
  ****************************************************************************** *)

unit unit_Events;

interface

uses
  Windows,
  ComCtrls,
  unit_Globals;

type
  TBookEvent = procedure(const BookRecord: TBookRecord; const CurrentBookOnly: boolean = false) of object;
  TSelectBookEvent = procedure(MoveForward: Boolean) of object;
  TGetBookEvent = procedure(var BookRecord: TBookRecord) of object;
  TChangeStateEvent = procedure(State: Boolean) of object;
  TOnLocateBookEvent = procedure(const Text: string; MoveForward: Boolean) of object;
  TOnHelpEvent = function(Command: Word; Data: Integer; var CallHelp: Boolean): Boolean of object;

  TProgressOpenEvent = procedure of object;
  TProgressHintEvent = procedure (Style: TProgressBarStyle; State: TProgressBarState) of object;
  TProgressEvent = procedure (Percent: Integer) of object;
  TProgressCloseEvent = procedure of object;
  TProgressTeletypeEvent = procedure (const Msg: string; Severity: TTeletypeSeverity) of object;
  TProgressSetCommentEvent = procedure (const Msg: string) of object;
  TProgressShowMessageEvent = function (const Text: string; Flags: Longint = MB_OK): Integer of object;

  TProgressEvent2 = procedure(Current, Total: Integer) of object;
  TProgressSetCommentEvent2 = procedure(const Current, Total: string) of object;

implementation

end.
