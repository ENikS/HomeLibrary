(* *****************************************************************************
  *
  * MyHomeLib
  *
  * Copyright (C) 2008-2010 Aleksey Penkov
  *
  * Created             12.02.2010
  * Description         ��������� �� �������
  * Author(s)           Nick Rymanov (nrymanov@gmail.com)
  *
  * History
  * NickR 15.02.2010    ��� ����������������
  *
  ****************************************************************************** *)

unit unit_Errors;

interface

uses
  SysUtils,
  Dialogs;

type
  EMHLError = class(Exception);

resourcestring
  rstrErrorInvalidArgument = 'Invalid argument';

  rstrAllFieldsShouldBeFilled = '��� ���� ������ ���� ���������!';

  rstrCollectionAlreadyExists = '��������� "%s" ��� ����������!';
  rstrFileDoesntExists = '���� "%s" �� ����������!';
  rstrFileAlreadyExistsInDB = '���� "%s" ������������ ������ ����������!';

function MHLShowInfo(
  const InfoMessage: string;
  Buttons: TMsgDlgButtons = [mbOK]
  ): Integer; overload; inline;

function MHLShowInfo(
  const MessageFormat: string;
  const Args: array of const;
  Buttons: TMsgDlgButtons = [mbOK]
  ): Integer; overload;

function MHLShowWarning(
  const WarningMessage: string;
  Buttons: TMsgDlgButtons = [mbOK]
  ): Integer; overload; inline;

function MHLShowWarning(
  const MessageFormat: string;
  const Args: array of const;
  Buttons: TMsgDlgButtons = [mbOK]
  ): Integer; overload;

function MHLShowError(
  const ErrorMessage: string;
  Buttons: TMsgDlgButtons = [mbOK]
  ): Integer; overload; inline;

function MHLShowError(
  const MessageFormat: string;
  const Args: array of const;
  Buttons: TMsgDlgButtons = [mbOK]
  ): Integer; overload;

implementation

function MHLShowInfo(const InfoMessage: string; Buttons: TMsgDlgButtons {= [mbOK]}): Integer;
begin
  Result := MessageDlg(InfoMessage, mtInformation, Buttons, 0);
end;

function MHLShowInfo(const MessageFormat: string; const Args: array of const; Buttons: TMsgDlgButtons {= [mbOK]}): Integer;
begin
  Result := MHLShowInfo(Format(MessageFormat, Args), Buttons);
end;

function MHLShowWarning(const WarningMessage: string; Buttons: TMsgDlgButtons {= [mbOK]}): Integer;
begin
  Result := MessageDlg(WarningMessage, mtWarning, Buttons, 0);
end;

function MHLShowWarning(const MessageFormat: string; const Args: array of const; Buttons: TMsgDlgButtons {= [mbOK]}): Integer;
begin
  Result := MHLShowWarning(Format(MessageFormat, Args), Buttons);
end;

function MHLShowError(const ErrorMessage: string; Buttons: TMsgDlgButtons {= [mbOK]}): Integer;
begin
  Result := MessageDlg(ErrorMessage, mtError, Buttons, 0);
end;

function MHLShowError(const MessageFormat: string; const Args: array of const; Buttons: TMsgDlgButtons {= [mbOK]}): Integer;
begin
  Result := MHLShowError(Format(MessageFormat, Args), Buttons);
end;

end.

