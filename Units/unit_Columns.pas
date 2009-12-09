{******************************************************************************}
{                                                                              }
{ MyHomeLib                                                                    }
{                                                                              }
{ Version 2.0                                                                  }
{                                                                              }
{ Copyright (c) 2009 Aleksey Penkov  alex.penkov@gmail.com                     }
{                                                                              }
{                                                                              }
{******************************************************************************}

unit unit_Columns;

interface

uses
  Windows,
  Classes,
  SysUtils,
  VirtualTrees,
  IniFiles,
  unit_Globals;

type


  TColumnDesc = class (TCollectionItem)
  private
    FCaption: string;
    FTag: integer;
    FWidth: integer;
    FMaxWidth: integer;
    FMinWidth: Integer;
    FAlignment: TAlignment;
    FOptions: TVTColumnOptions;
    FPosition: integer;
  public
    property Caption: string read FCaption write FCaption;
    property Tag: integer read FTag write FTag;
    property Width: integer read FWidth write FWidth;
    property MaxWidth: integer read FMaxWidth write FMaxWidth;
    property MinWidth: Integer read FMinWidth write FMinWidth;
    property Alignment: TAlignment read FAlignment write FAlignment;
    property Options: TVTColumnOptions read FOptions write FOptions;
    property Position:integer read FPosition write FPosition;
  end;

  TColumns = class(TCollection)
  private

    FIniFile: TIniFile;
    FMode: TTreeMode;

    function GetColumn(Index: Integer): TColumnDesc;
    procedure SetColumn(Index: Integer; const Value: TColumnDesc);

    function AddColumn:TColumnDesc;

  public
    constructor Create(FileName: string);

    procedure Add(const Tag: integer;
                  const Width: integer;
                  const Position: integer);

    // procedure Insert
    // procedure Delete

    procedure Load(const Section:string; Mode:TTreeMode);
    procedure LoadDefault(Section: string);
    procedure Save(const Section: string);

    procedure SetColumns(Obj: TVirtualTreeColumns);
    procedure GetColumns(Obj: TVirtualTreeColumns);

    property Mode: TTreeMode read FMode write FMode;
    property Items[Index: integer]:TColumnDesc read GetColumn write SetColumn; default;

  end;

  procedure GetDefaultColumnProperties(Mode: TTreeMode;
                                 Tag: integer;
                                 out Caption: string;
                                 out MinWidth: integer;
                                 out MaxWidth: integer;
                                 out Alignment: TAlignment;
                                 out Options : TVTColumnOptions);




implementation

uses
  unit_Consts,
  unit_TreeUtils;

const

    //
    // ������ ����� ��� ���������� � ������������ �������
    //
    ResibleColumnOptions = [coDraggable,coEnabled,coParentColor,coResizable,coShowDropMark,coVisible,coAutoSpring];
    ResClickColumnOptions = [coAllowClick,coDraggable,coEnabled,coParentColor,coResizable,coShowDropMark,coVisible];

    FixedColumnOptions = [coDraggable,coEnabled,coParentColor,coShowDropMark,coVisible];
    FixedClickColumnOptions = [coAllowClick,coDraggable,coEnabled,coParentColor,coShowDropMark,coVisible];



{ TColumns }

procedure GetDefaultColumnProperties(Mode: TTreeMode; Tag: integer; out Caption: string;
  out MinWidth, MaxWidth: integer; out Alignment: TAlignment;
  out Options: TVTColumnOptions);
var
  Fix,Rez:TVTColumnOptions;

begin
  if Mode = tmTree then
  begin
    Rez := ResibleColumnOptions;
    Fix := FixedColumnOptions;
  end
  else
  begin
    Rez := ResClickColumnOptions;
    Fix := FixedClickColumnOptions;
  end;

  case Tag of
        COL_AUTHOR:begin
                   Caption   := '�����';
                   MaxWidth  := 900;
                   MinWidth  := 30;
                   Alignment := taLeftJustify;
                   Options   := Rez;
                 end;
        COL_TITLE:begin
                   Caption   := '��������';
                   MaxWidth  := 900;
                   MinWidth  := 30;
                   Alignment := taLeftJustify;
                   Options    := Rez;
                 end;
        COL_SERIES:begin
                   Caption   := '�����';
                   MaxWidth  := 900;
                   MinWidth  := 30;
                   Alignment := taLeftJustify;
                   Options    := Rez;
                 end;
        COL_NO:begin
                   Caption   := '�';
                   MaxWidth  := 900;
                   MinWidth  := 20;
                   Alignment := taRightJustify;
                   Options    := Rez;
                 end;
        COL_SIZE:begin
                   Caption   := '������';
                   MaxWidth  := 900;
                   MinWidth  := 20;
                   Alignment := taRightJustify;
                   Options    := Rez;
                 end;
        COL_RATE:begin
                   Caption   := '�������';
                   MaxWidth  := 65;
                   MinWidth  := 65;
                   Alignment := taCenter;
                   Options    := Rez;
                 end;
        COL_DATE:begin
                   Caption   := '���������';
                   MaxWidth  := 900;
                   MinWidth  := 40;
                   Alignment := taLeftJustify;
                   Options    := Rez;
                 end;
        COL_GENRE:begin
                   Caption   := '����';
                   MaxWidth  := 900;
                   MinWidth  := 30;
                   Alignment := taLeftJustify;
                   Options    := Rez;
                 end;

        COL_COLLECTION:begin
                   Caption   := '���������';
                   MaxWidth  := 900;
                   MinWidth  := 30;
                   Alignment := taLeftJustify;
                   Options   := Rez;
                 end;

        COL_TYPE:begin
                   Caption   := '���';
                   MaxWidth  := 55;
                   MinWidth  := 55;
                   Alignment := taCenter;
                   Options    := Fix;
                 end;

        COL_LANG:begin
                   Caption   := '����';
                   MaxWidth  := 55;
                   MinWidth  := 55;
                   Alignment := taCenter;
                   Options    := Fix;
                end;

        COL_LIBRATE:begin
                   Caption   := 'N';
                   MaxWidth  := 55;
                   MinWidth  := 55;
                   Alignment := taCenter;
                   Options    := Fix;
                end;


        COL_STATE:begin
                   Caption   := '';
                   MaxWidth  := 35;
                   MinWidth  := 35;
                   Alignment := taCenter;
                   Options    := Fix - [coDraggable] + [coFixed];
                 end;

      end;

end;



procedure TColumns.Add(const Tag: integer;
                       const Width: integer;
                       const Position: integer);
var
  Column: TColumnDesc;
begin
  BeginUpdate;
  try
    Column := AddColumn;
    try
      Column.Tag := Tag;
      Column.Width := Width;
      Column.Position := Position;
      // �� ���������� ������������� ��������
      GetDefaultColumnProperties(FMode,Tag,
                           Column.FCaption,
                           Column.FMinWidth,
                           Column.FMaxWidth,
                           Column.FAlignment,
                           Column.FOptions);
    except
      Column.Free;
      raise;
    end;
  finally
    EndUpdate;
  end;
end;

function TColumns.AddColumn: TColumnDesc;
begin
  Result := TColumnDesc(inherited Add);
end;

constructor TColumns.Create(FileName: string);
begin
  inherited Create(TColumnDesc);
  FIniFile := TIniFile.Create(FileName);
end;

function TColumns.GetColumn(Index: Integer): TColumnDesc;
begin
  Result := TColumnDesc(inherited Items[Index]);
end;

procedure TColumns.GetColumns(Obj: TVirtualTreeColumns);
var
  I: Integer;
  Column : TColumnDesc;
begin
  Clear;
  for I := 0 to Obj.Count - 1 do
  begin
    BeginUpdate;
    try
      Column := AddColumn;
      Column.Caption := Obj.Items[i].Text;
      Column.Width :=  Obj.Items[i].Width;
      Column.MaxWidth := Obj.Items[i].MaxWidth;
      Column.MinWidth := Obj.Items[i].MinWidth;
      Column.Alignment := Obj.Items[i].Alignment;
      Column.Options := Obj.Items[i].Options;
      Column.Tag := Obj.Items[i].Tag;
      Column.Position := Obj.Items[i].Position;
    finally
      EndUpdate;
    end;
  end;
end;


procedure TColumns.Load(const Section: string; Mode:TTreeMode);
var
  sl: TStringList;
  slHelper: TStringList;
  i: integer;
begin
  Clear;
  FMode := Mode;
  sl := TStringList.Create;
  try
    FiniFile.ReadSection(Section, sl);
    if sl.Count > 0 then
    begin
      slHelper := TStringList.Create;
      try
        slHelper.QuoteChar := '"';
        slHelper.Delimiter := ';';
        for i := 0 to sl.Count - 1 do
        begin
          if Pos('Column', sl[i]) = 1 then
          begin
            slHelper.DelimitedText := FiniFile.ReadString(Section, sl[i], '');
            if slHelper.Count = 3 then
              Add(StrToInt(slHelper[0]), StrToInt(slHelper[1]),StrToInt(slHelper[2]));
          end;
        end;
        finally
          slHelper.Free;
        end;
      end
      else
        LoadDefault(Section);
  finally
    sl.Free;
  end;
end;

procedure TColumns.LoadDefault(Section: string);
begin
  if Section = SECTION_A_FLAT then
  begin
    Add(COL_STATE,15,0); Add(COL_TITLE,200,1);
    Add(COL_SERIES,200,2); Add(COL_NO,30,3);
    Add(COL_SIZE,70,4);   Add(COL_RATE,80,5);
    Add(COL_DATE,200,6); Add(COL_GENRE,200,7);
  end;

  if Section = SECTION_A_TREE then
  begin
    Add(COL_STATE,15,0);
    Add(COL_TITLE,200,1); Add(COL_NO,30,2);
    Add(COL_SIZE,70,3);   Add(COL_RATE,80,4);
    Add(COL_DATE,200,5); Add(COL_GENRE,200,6);
  end;


  if Section = SECTION_S_FLAT then
  begin
    Add(COL_STATE,15,0);  Add(COL_AUTHOR,200,1);
    Add(COL_TITLE,200,2); Add(COL_NO,40,3);
    Add(COL_SIZE,70,4);   Add(COL_RATE,80,5);
    Add(COL_DATE,200,7); Add(COL_GENRE,200,6);
  end;

  if Section = SECTION_S_TREE then
  begin
    Add(COL_STATE,15,0);  Add(COL_AUTHOR,200,1);
    Add(COL_TITLE,200,2); Add(COL_NO,40,3);
    Add(COL_SIZE,70,4);   Add(COL_RATE,80,5);
    Add(COL_DATE,200,7); Add(COL_GENRE,200,6);
  end;

  if Section = SECTION_G_FLAT then
  begin
    Add(COL_STATE,15,0);
    Add(COL_AUTHOR,200,1); Add(COL_TITLE,200,2);
    Add(COL_SERIES,200,3); Add(COL_NO,30,4);
    Add(COL_SIZE,70,5);   Add(COL_RATE,80,6);
    Add(COL_DATE,200,8); Add(COL_GENRE,200,7);
  end;
  if Section = SECTION_G_TREE then
  begin
    Add(COL_STATE,15,0);
    Add(COL_TITLE,300,1); Add(COL_NO,30,2);
    Add(COL_SIZE,70,3);   Add(COL_RATE,80,4);
    Add(COL_GENRE,200,5);
  end;

  if Section = SECTION_F_FLAT then
  begin
    Add(COL_STATE,15,0);
    Add(COL_AUTHOR,200,1); Add(COL_TITLE,200,2);
    Add(COL_SERIES,200,3); Add(COL_NO,30,4);
    Add(COL_SIZE,70,5);   Add(COL_RATE,80,6);
    Add(COL_DATE,200,8); Add(COL_GENRE,200,7);
  end;
  if Section = SECTION_F_TREE then
  begin
    Add(COL_STATE,15,0);
    Add(COL_TITLE,300,1); Add(COL_NO,30,2);
    Add(COL_SIZE,70,3);   Add(COL_RATE,80,4);
    Add(COL_DATE,200,6); Add(COL_GENRE,200,5);
    Add(COL_COLLECTION,200,7);
  end;

  if Section = SECTION_SR_FLAT then
  begin
    Add(COL_STATE,15,0);
    Add(COL_AUTHOR,200,1); Add(COL_TITLE,200,2);
    Add(COL_SERIES,200,3); Add(COL_NO,30,4);
    Add(COL_SIZE,70,5);   Add(COL_RATE,80,6);
    Add(COL_DATE,200,8); Add(COL_GENRE,200,7);
  end;

  if Section = SECTION_SR_TREE then
  begin
    Add(COL_STATE,15,0);
    Add(COL_TITLE,300,1); Add(COL_NO,30,2);
    Add(COL_SIZE,70,3);   Add(COL_RATE,80,4);
    Add(COL_DATE,200,6); Add(COL_GENRE,200,5);
  end;

  if Section = SECTION_FL_FLAT then
  begin
    Add(COL_STATE,15,0);
    Add(COL_AUTHOR,200,1); Add(COL_TITLE,200,2);
    Add(COL_SERIES,200,3); Add(COL_NO,30,4);
    Add(COL_SIZE,70,5);   Add(COL_RATE,80,6);
    Add(COL_DATE,200,8); Add(COL_GENRE,200,7);
  end;

  if Section = SECTION_FL_TREE then
  begin
    Add(COL_STATE,15,0);
    Add(COL_TITLE,300,1); Add(COL_NO,30,2);
    Add(COL_SIZE,70,3);   Add(COL_RATE,80,4);
    Add(COL_DATE,200,6); Add(COL_GENRE,200,5);
  end;

end;

procedure TColumns.Save(const Section: string);
var
  i: Integer;
  sl: TStringList;
begin
  FiniFile.EraseSection(Section);
  if Count > 0 then
  begin
    sl := TStringList.Create;
    try
      sl.QuoteChar := '"';
      sl.Delimiter := ';';
      for i := 0 to Count - 1 do
      begin
        sl.Clear;
        sl.Add(IntToStr(Items[i].Tag));
        sl.Add(IntToStr(Items[i].Width));
        sl.Add(IntToStr(Items[i].Position));

        FiniFile.WriteString(Section, Format('%s%u', ['Column', i]), sl.DelimitedText);
      end;
     finally
      sl.Free;
    end;
  end;
end;

procedure TColumns.SetColumn(Index: Integer; const Value: TColumnDesc);
begin
  inherited Items[Index] := Value;
end;

procedure TColumns.SetColumns(Obj: TVirtualTreeColumns);
var
  i: integer;
  Column: TVirtualTreeColumn;
begin
  Obj.Clear;
  for I := 0 to Count - 1 do
  begin
    Column := TVirtualTreeColumn.Create(Obj);
    Column.Text  := Items[i].Caption;
    Column.Position := i;
    Column.Width :=  Items[i].Width;
    Column.MaxWidth := Items[i].MaxWidth;
    Column.MinWidth := Items[i].MinWidth;
    Column.Alignment := Items[i].Alignment;
    Column.Options := Items[i].Options;
    Column.Tag := Items[i].Tag;
    Column.Position := Items[i].Position;
  end;
end;

end.
