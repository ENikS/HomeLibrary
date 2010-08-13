{******************************************************************************}
{                                                                              }
{ MyHomeLib                                                                    }
{                                                                              }
{ Version 0.9                                                                  }
{ 20.08.2008                                                                   }
{ Copyright (c) Aleksey Penkov  alex.penkov@gmail.com                          }
{                                                                              }
{ @author Nick Rymanov nrymanov@gmail.com                                      }
{                                                                              }
{******************************************************************************}

unit frame_NCWCollectionFileTypes;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  frame_InteriorPageBase,
  StdCtrls,
  ExtCtrls,
  unit_StaticTip;

type
  TframeNCWCollectionFileTypes = class(TInteriorPageBase)
    Panel3: TPanel;
    rbSoreAnyFiles: TRadioButton;
    rbSoreFB2Files: TRadioButton;
    pageHint: TMHLStaticTip;
    procedure OnSetFileType(Sender: TObject);

  private

  public
    function Activate(LoadData: Boolean): Boolean; override;
    function Deactivate(CheckData: Boolean): Boolean; override;
  end;

var
  frameNCWCollectionFileTypes: TframeNCWCollectionFileTypes;

implementation

uses
  dm_user,
  unit_NCWParams;

resourcestring
  rstrCollectionTypeFB2 = '����� � ������� fb2 (������ �������������� ����������). ����� ����� ���� ��������� � ����� �� ��������� ���� (zip) ��� �� �������� (fb2.zip). ';
  rstrCollectionTypeAny = '����� � ����� �������. �� ������ ���� ��������� ���������� � ����� ��� ���������� �� � ���������. �� ����� ������ ������� ���� � ��������� ������ �� ��������� ��������.';

{$R *.dfm}

{
TODO -oNickR -cRelease2.0: � ����� ������� ���������� ��������� ��� ���������� ������ � ������ �������������� ������.
������ ������, ����� ������ �������������� ������.
�������� � ���, ��� �� ���� ������������ ������� ��� ������ (fb/non-fb) ��� ������������ ���������.
}

function TframeNCWCollectionFileTypes.Activate(LoadData: Boolean): Boolean;
var
  rb: TRadioButton;
begin
  if LoadData then
  begin
    if ftFB2 = FPParams^.FileTypes then
      rb := rbSoreFB2Files
    else {if ftAny = FPParams^.FileTypes then}
      rb := rbSoreAnyFiles;

    rb.Checked := True;
    OnSetFileType(rb);
  end;

  Result := True;
end;

function TframeNCWCollectionFileTypes.Deactivate(CheckData: Boolean): Boolean;
begin
  if rbSoreFB2Files.Checked then
    FPParams^.FileTypes := ftFB2
  else {if rbSoreAnyFiles.Checked then}
    FPParams^.FileTypes := ftAny;

  Result := True;
end;

procedure TframeNCWCollectionFileTypes.OnSetFileType(Sender: TObject);
begin
  if Sender = rbSoreFB2Files then
    pageHint.Caption := rstrCollectionTypeFB2
  else if Sender = rbSoreAnyFiles  then
    pageHint.Caption := rstrCollectionTypeAny;
end;

end.

