(* *****************************************************************************
  *
  * MyHomeLib
  *
  * Copyright (C) 2008-2010 Aleksey Penkov
  *
  * Authors             Nick Rymanov     nrymanov@gmail.com
  * Created             20.08.2008
  * Description
  *
  * $Id$
  *
  * History
  *
  ****************************************************************************** *)

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

    INPXFile: string;

    AutoImport: boolean;

    //
    // ���������� ��������� �������� � ��������� ���� �������� � TImportInpxThread
    //
    //Notes: string;
    //URL: string;
    //Script: string;
    INPXUrl: string;

    //
    // �������� ��� ���������
    //
    CollectionCode: COLLECTION_TYPE;

    //
    // ID ����� ��������� (��������� ��� ������������)
    //
    CollectionID: Integer;
  end;

implementation

end.

