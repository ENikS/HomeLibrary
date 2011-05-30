(* *****************************************************************************
  *
  * MyHomeLib
  *
  * Copyright (C) 2008-2010 Aleksey Penkov
  *
  * Authors Aleksey Penkov   alex.penkov@gmail.com
  *         Nick Rymanov     nrymanov@gmail.com
  * Created                  20.08.2008
  * Description              
  *
  * $Id$
  *
  * History
  *
  ****************************************************************************** *)

unit frm_EditAuthorEx;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, frm_edit_author, StdCtrls, ExtCtrls;

type
  TfrmEditAuthorDataEx = class(TfrmEditAuthorData)
    gbAddNew: TGroupBox;
    cbAddNew: TCheckBox;
    cbSaveLinks: TCheckBox;
  private
    function GetAddNewState: Boolean;
    function GetSaveLinks: Boolean;
  public
    property AddNew: Boolean read GetAddNewState;
    property SaveLinks: Boolean read GetSaveLinks;
  end;

var
  frmEditAuthorDataEx: TfrmEditAuthorDataEx;

implementation

{$R *.dfm}

function TfrmEditAuthorDataEx.GetAddNewState: boolean;
begin
  Result := cbAddNew.Checked;
end;

function TfrmEditAuthorDataEx.GetSaveLinks: boolean;
begin
  Result := cbSaveLinks.Checked;
end;

end.
