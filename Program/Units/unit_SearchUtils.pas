(* *****************************************************************************
  *
  * MyHomeLib
  *
  * Copyright (C) 2008-2010 Aleksey Penkov
  *
  * Created             12.02.2010
  * Description
  * Author(s)           Aleksey Penkov  alex.penkov@gmail.com
  *
  * $Id$
  *
  * History
  * NickR 15.02.2010    ��� ����������������
  *
  ****************************************************************************** *)

unit unit_SearchUtils;

interface

procedure AddToFilter(const Field: string; Value: string; UP: Boolean; var FilterString: string);
function PrepareQuery(S: string; UP: Boolean; ConverToFull: Boolean = True): string;

implementation

uses
  StrUtils,
  SysUtils,
  unit_Globals,
  unit_Consts;

procedure AddToFilter(const Field: string; Value: string; UP: Boolean; var FilterString: string);
var
  FixedField: string;
begin
  if Value = '' then
    Exit;

  if UP then
    FixedField := 'UPPER(' + Field + ')'
  else
    FixedField := Field;

  Value := ' ' + Value; // this way the search for ' LIKE' and such is possible for the first expression as well
  StrReplace(CRLF, ' ', Value);
  StrReplace(LF, ' ', Value);
  StrReplace(' LIKE ', ' ' + FixedField + #7 + 'LIKE ', Value);
  StrReplace(' =', ' ' + FixedField + #7 + '=', Value);
  StrReplace(' <>', ' ' + FixedField + #7 + '<>', Value);
  StrReplace(' <', ' ' + FixedField + #7 + '<', Value);
  StrReplace(' >', ' ' + FixedField + #7 + '>', Value);
  StrReplace(#7, ' ', Value);

  if FilterString <> '' then
    FilterString := FilterString + ' AND (' + Value + ')'
  else
    FilterString := '(' + Value + ')';
end;

function Clear(const S: string): string; inline;
begin
  Result := S;
  StrReplace(CRLF, ' ', Result);
  Trim(Result);
end;

// ��������� ������, ���� �������� - �������������� � SQL
function PrepareQuery(S: string; UP: Boolean; ConverToFull: Boolean = True): string;
begin
  if UP then
    S := Trim(AnsiUpperCase(S));

  if S = '' then
  begin
    Result := '';
    Exit;
  end;

  if ConverToFull and (Pos('%', S) = 0) and (Pos('=', S) = 0) and (Pos('"', S) = 0) and (Pos('LIKE', S) = 0) then
    S := Format('%%%s%%', [S]);

  if (Pos('=', S) = 0) and (Pos('LIKE', S) = 0) and (Pos('"', S) = 0) then
  begin
    if Pos('%', S) = 0 then
      S := '="' + S + '"'
    else
      S := 'LIKE "' + S + '"';
  end;

  Result := Clear(S);
end;

end.
