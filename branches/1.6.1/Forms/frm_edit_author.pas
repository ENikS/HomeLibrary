
{******************************************************************************}
{                                                                              }
{                                 MyHomeLib                                    }
{                                                                              }
{                                Version 0.9                                   }
{                                20.08.2008                                    }
{                    Copyright (c) Aleksey Penkov  alex.penkov@gmail.com       }
{                                                                              }
{******************************************************************************}


unit frm_edit_author;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, RzEdit, RzButton, RzRadChk, ExtCtrls, RzPanel;

type
  TfrmEditAuthorData = class(TForm)
    RzGroupBox1: TRzGroupBox;
    btnSave: TRzBitBtn;
    RzBitBtn2: TRzBitBtn;
    RzGroupBox2: TRzGroupBox;
    edFamily: TRzEdit;
    Label1: TLabel;
    edName: TRzEdit;
    Label2: TLabel;
    edMiddle: TRzEdit;
    Label3: TLabel;
    gbAddNew: TRzGroupBox;
    cbAddNew: TRzCheckBox;
    cbSaveLinks: TRzCheckBox;
    procedure FormShow(Sender: TObject);
  private
    function GetAddNewState: boolean;
    function GetSaveLinks: boolean;
    procedure SetShowCheckBoxes(const Value: boolean);
    { Private declarations }
  public
    { Public declarations }
    property ShowCheckBoxes: boolean write SetShowCheckBoxes default False;
    property AddNew: boolean read GetAddNewState;
    property SaveLinks: boolean read GetSaveLinks;

  end;

var
  frmEditAuthorData: TfrmEditAuthorData;

implementation

{$R *.dfm}

{ TfrmEditAuthor }

procedure TfrmEditAuthorData.FormShow(Sender: TObject);
begin
  ActiveControl := edFamily;
end;

function TfrmEditAuthorData.GetAddNewState: boolean;
begin
  Result := cbAddNew.Checked;
end;

function TfrmEditAuthorData.GetSaveLinks: boolean;
begin
  Result := cbSaveLinks.Checked;
end;

procedure TfrmEditAuthorData.SetShowCheckBoxes(const Value: boolean);
begin
  gbAddNew.Visible := Value;
end;

end.