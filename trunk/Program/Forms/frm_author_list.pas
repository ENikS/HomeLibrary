(* *****************************************************************************
  *
  * MyHomeLib
  *
  * Copyright (C) 2008-2010 Aleksey Penkov
  *
  * Authors Aleksey Penkov   alex.penkov@gmail.com
  *         Nick Rymanov     nrymanov@gmail.com
  *
  * $Id$
  *
  * History
  *
  ****************************************************************************** *)

unit frm_author_list;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, VirtualTrees, ExtCtrls, StdCtrls;

type
  TfrmAuthorList = class(TForm)
    tvAuthorList: TVirtualStringTree;
    pnButtons: TPanel;
    btnOk: TButton;
    btnCancel: TButton;
    procedure tvAuthorListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType; var CellText: string);
    procedure tvAuthorListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure tvAuthorListFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
  private

  public

  end;

var
  frmAuthorList: TfrmAuthorList;

implementation

uses
  unit_Globals;

  {$R *.dfm}

procedure TfrmAuthorList.tvAuthorListFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PAuthorData;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then
    Finalize(Data^);
end;

procedure TfrmAuthorList.tvAuthorListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TAuthorData);
end;

procedure TfrmAuthorList.tvAuthorListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  Data: PAuthorData;
begin
  Data := tvAuthorList.GetNodeData(Node);
  CellText := Data^.GetFullName;
end;

end.
