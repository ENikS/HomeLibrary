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

