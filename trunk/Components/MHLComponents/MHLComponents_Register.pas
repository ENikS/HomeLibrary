(* *****************************************************************************
  *
  * MyHomeLib
  *
  * Copyright (C) 2008-2010 Aleksey Penkov
  *
  * Author(s)           Nick Rymanov (nrymanov@gmail.com)
  * Created             15.04.2010
  * Description
  *
  * $Id$
  *
  * History
  *
  ****************************************************************************** *)

unit MHLComponents_Register;

interface

uses
  Classes;

procedure Register;

implementation

uses
  files_list,
  unit_StaticTip,
  unit_AutoCompleteEdit,
  MHLLinkLabel,
  MHLSplitter,
  BookTreeView,
  BookInfoPanel,
  MHLSimplePanel,
  MHLButtonedEdit,
  FBDAuthorTable,
  FBDDocument;

const
  PAGE_NAME = 'MHLComponents';

procedure Register;
begin
  RegisterComponents(
    PAGE_NAME,
    [
    TFilesList,
    TMHLStaticTip,
    TMHLAutoCompleteEdit,
    TMHLLinkLabel,
    TMHLSplitter,
    TMHLSimplePanel,
    TBookTree,
    TInfoPanel,
    TMHLButtonedEdit,
    TFBDAuthorTable,
    TFBDDocument
    ]
  );
end;

end.

