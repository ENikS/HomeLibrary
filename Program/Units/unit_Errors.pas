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
  SysUtils;

type
  EMHLError = class(Exception);

resourcestring
  rstrErrorInvalidArgument = 'Invalid argument';

  rstrAllFieldsShouldBeFilled = '��� ���� ������ ���� ���������!';

  rstrCollectionAlreadyExists = '��������� "%s" ��� ����������!';
  rstrFileDoesntExists = '���� "%s" �� ����������!';
  rstrFileAlreadyExistsInDB = '���� "%s" ������������ ������ ����������!';


implementation

end.

