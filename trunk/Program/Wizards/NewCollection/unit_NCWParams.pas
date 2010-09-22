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

unit unit_NCWParams;

interface

uses unit_globals;

type
  TNCWOperation = (
    otNew,              // ������� ����� ���������������� ���������
    otExisting,         // ���������� ������������ ���������
    otInpx,             // ������� ��������� �� INPX
    otInpxDownload      // ������� ��������� �� �������������� ���������� INPX
  );

  TNCWCollectionType = (
    ltUser,             // ����� ���������������� ���������. ��� ���� ������������ TNCWFileTypes
    ltUserFB,           // ���������������� ��������� FB2 ���� �� INPX
    ltUserAny,          // ���������������� ��������� ��-FB2 ���� �� INPX
    ltExternalLocalFB,  // ������� ��������� ��������� FB2 ���� �� INPX
    ltExternalOnlineFB, // ������� ������ ��������� FB2 ���� �� INPX
    ltExternalLocalAny, // ������� ��������� ��������� ��-FB2 ���� �� INPX
    ltExternalOnlineAny // ������� ������ ��������� ��-FB2 ���� �� INPX
  );

  TNCWFileTypes = (
    ftFB2,              // � ��������� �������� ����� � ������� FB2
    ftAny               // � ��������� �������� ����� � ������������ �������
  );

  PNCWParams = ^TNCWParams;
  TNCWParams = record
    Operation: TNCWOperation;
    CollectionType: TNCWCollectionType;
    FileTypes: TNCWFileTypes;
    DefaultGenres: Boolean;
    GenreFile: string;

    DisplayName: string;
    CollectionFile: string;
    CollectionRoot: string;
    RelativePaths: Boolean;

    INPXFile: string;

    //
    // ���������� ��������� �������� � ��������� ���� �������� � TImportInpxThread
    //
    Notes: string;
    URL: string;
    Script: string;
    INPXUrl: string;

    //
    // �������� ��� ���������
    //
    CollectionCode: COLLECTION_TYPE;
  end;

implementation

end.

