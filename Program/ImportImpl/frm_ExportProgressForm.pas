(* *****************************************************************************
  *
  * MyHomeLib
  *
  * Copyright (C) 2008-2010 Aleksey Penkov
  *
  * Author(s)           Aleksey Penkov   alex.penkov@gmail.com
  *                     Nick Rymanov     nrymanov@gmail.com
  * Created             
  * Description         
  *
  * $Id$
  *
  * History
  *
  ****************************************************************************** *)

unit frm_ExportProgressForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, frm_ImportProgressForm, StdCtrls, ComCtrls;

type
  TExportProgressForm = class(TImportProgressForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ExportProgressForm: TExportProgressForm;

implementation

{$R *.dfm}

end.

