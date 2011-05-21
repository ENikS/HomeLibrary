(* *****************************************************************************
  *
  * MyHomeLib
  *
  * Copyright (C) 2008-2010 Aleksey Penkov
  *
  * Author(s)           eg
  *                     Nick Rymanov    nrymanov@gmail.com
  * Created             04.09.2010
  * Description
  *
  * $Id$
  *
  * History
  *
  ****************************************************************************** *)

unit unit_SQLiteUtils;

interface

uses
  Classes;

  function ReadResourceAsStringList(const ResourceName: string): TStringList;

implementation

uses
  Windows,
  unit_Consts,
  SysUtils,
  StrUtils;

const
  SQL_COMMENT = '--';
  SCRIPT_NEXT = SQL_COMMENT + '@@';

//
// Read provided resource file as a string list (split by '--@@')
// This is done as ExecSQL works with only one statement at a time
//
function ReadResourceAsStringList(const ResourceName: string): TStringList;
var
  rStream: TStream;
  rScript: TStringList;
  i: Integer;
  strStatement: string;
begin
  Result := TStringList.Create;
  try
    rStream := TResourceStream.Create(HInstance, ResourceName, RT_RCDATA);
    try
      rScript := TStringList.Create;
      try
        rScript.LoadFromStream(rStream);

        strStatement := '';
        for i := 0 to rScript.Count - 1 do
        begin
          //
          // ��������� ������ ������
          //
          if Trim(rScript[i]) = '' then
            Continue;

          //
          // ����� ����� �������. �������� � ������ ��������� ����.
          //
          if StartsText(SCRIPT_NEXT, rScript[i]) then
          begin
            if strStatement <> '' then
              Result.Add(strStatement);
            strStatement := '';
            Continue;
          end;

          //
          // ��������� ����������
          //
          if StartsText(SQL_COMMENT, TrimLeft(rScript[i])) then
            Continue;

          strStatement := strStatement + rScript[i] + CRLF;
        end;

        //
        // ��������� ������� ����� �� ����� ������� ����������.
        //
        if strStatement <> '' then
          Result.Add(strStatement);
      finally
        rScript.Free;
      end;
    finally
      rStream.Free;
    end;
  except
    FreeAndNil(Result);
    raise;
  end;
end;


end.
