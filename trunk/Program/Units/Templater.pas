(* *****************************************************************************
  *
  * MyHomeLib
  *
  * Copyright (C) 2008-2010 Aleksey Penkov
  *
  * Created             12.02.2010
  * Description
  * Author(s)           Nick Rymanov (nrymanov@gmail.com)
  *
  ****************************************************************************** *)

unit Templater;

interface

uses
  Classes,
  Generics.Defaults,
  Generics.Collections,
  TemplaterInternal,
  unit_Globals;

type
  TStringsTemplater = class(TBlockTemplateElement<TStrings>)
  private type
    TParamsParser = class(TBaseParamsParser<TStrings>)
      function GetValue(const params: TStrings; const paramName: string): string; override;
    end;

  public
    constructor Create;
  end;

  TBookTemplater = class(TBlockTemplateElement<TBookRecord>)
  public type
    TTemplateType = (ttFile, ttPath, ttText);

  private type
    TParamsParser = class(TBaseParamsParser<TBookRecord>)
    strict private
      class var
        FComparer: IComparer<string>;
        FParamNames: TArray<string>;

    public
      class constructor Create;

    strict private
      FTemplateType: TTemplateType;

    public
      constructor Create(templateType: TTemplateType);

      function CheckLiteral(const literalValue: string): Boolean; override;
      function CheckParam(const paramName: string): Boolean; override;
      function GetValue(const params: TBookRecord; const paramName: string): string; override;
    end;

  strict private
    FTemplateType: TTemplateType;

  public
    constructor Create(templateType: TTemplateType);

    procedure SetTemplate(const strTemplate: string);
    function Value(const params: TBookRecord): string; //override;
  end;

implementation

uses
  SysUtils,
  IOUtils,
  Character,
  ///unit_MHLTypes,
  unit_Consts,
  unit_MHLHelpers,
  unit_Helpers;

{ TStringsTemplater }

constructor TStringsTemplater.Create;
begin
  inherited Create(TParamsParser.Create);
end;

{ TStringsTemplater.TStringsParamsParser }

function TStringsTemplater.TParamsParser.GetValue(const params: TStrings; const paramName: string): string;
begin
  Result := params.Values[paramName];
end;

{ TBookTemplater }

constructor TBookTemplater.Create(templateType: TTemplateType);
begin
  inherited Create(TParamsParser.Create(templateType));
  FTemplateType := templateType;
end;

procedure TBookTemplater.SetTemplate(const strTemplate: string);
begin
  inherited SetTemplate(strTemplate);
end;

function TBookTemplater.Value(const params: TBookRecord): string;
begin
  Result := inherited Value(params);
  //
  //
end;

{ TBookTemplater.TParamsParser }

class constructor TBookTemplater.TParamsParser.Create;
begin
  FComparer := TComparer<string>.Construct(SysUtils.CompareText);
  //
  // NOTE!!! - ������ ������ ���� ������������ !!!
  //
  FParamNames := TArray<string>.Create(
    'f',       // 'f',         - ������ ��� ������� ������
    'fa',      // 'fa',        - ����������� ��� ���� �������
    'ff',      // 'ff',        - ������ ����� ��� ������� ������
    'fl',
    'g',       // 'g',         - ����� ������� �����
    'ga',      // 'ga',        - ������ ������� ���� ������
    'id',      // 'id',        - ID �����
    'n',       // 'n',         - ����� ����� � �����
    'rg',      // 'rg',        - ����� ��������� �����
    's',       // 's',         - ����� �����
    't'        // 't'          - �������� �����
  );
end;

constructor TBookTemplater.TParamsParser.Create(templateType: TTemplateType);
begin
  inherited Create;
  FTemplateType := templateType;
end;

function TBookTemplater.TParamsParser.CheckLiteral(const literalValue: string): Boolean;
begin
  case FTemplateType of
    ttFile: Result := TPath.HasValidFileNameChars(literalValue, False);
    ttPath: Result := TPath.HasValidPathChars(literalValue, False);
  else
    Result := True;
  end;
end;

function TBookTemplater.TParamsParser.CheckParam(const paramName: string): Boolean;
var
  nIndex: Integer;
begin
  Result := TArray.BinarySearch<string>(FParamNames, paramName, nIndex, FComparer);
end;

function TBookTemplater.TParamsParser.GetValue(const params: TBookRecord; const paramName: string): string;
var
  nIndex: Integer;
  i: Integer;
begin
  if not TArray.BinarySearch<string>(FParamNames, paramName, nIndex, FComparer) then
  begin
    //
    // ����������� ��������
    //
    Assert(False);
    Result := '';
    Exit;
  end;

  case nIndex of
    0: // 'f' - ������ ��� ������� ������
      begin
        if params.AuthorCount > 0 then
          Result := Trim(params.Authors[0].GetFullName)
      end;

    1: // 'fa' - ����������� ��� ���� �������
      begin
        Result := TArrayUtils.Join<TAuthorData>(
          params.Authors,
          ', ',
          function(const author: TAuthorData): string
          begin
            Result := author.GetFullName(True);
          end
        );
      end;

    2, 3: // 'ff', 'fl' - ������ ����� ��� ������� ������
      begin
        if params.AuthorCount > 0 then
          Result := Character.ToUpper(params.Authors[0].FLastName[1]);
      end;

    4: // 'g' - ����� ������� �����
      begin
        if params.GenreCount > 0 then
          Result := Trim(params.Genres[0].GenreAlias)
      end;

    5: // 'ga' - ������ ������� ���� ������
      begin
        Result := TArrayUtils.Join<TGenreData>(
          params.Genres,
          ', ',
          function(const genre: TGenreData): string
          begin
            Result := genre.GenreAlias;
          end
        );
      end;

    6:
      begin // 'id',        - ID �����
        Result := IntToStr(params.LibID);
        Exit;
      end;

    7: // 'n' - ����� ����� � �����
      begin
        if params.SeqNumber <> 0 then
          Result := IntToStr(params.SeqNumber);
        Exit;
      end;

    8: // 'rg' - ����� ��������� �����
      begin
        Result := Trim(params.RootGenre.GenreAlias);
      end;

    9: // 's' - ����� �����
      begin
        if params.Serie <> NO_SERIES_TITLE then
          Result := Trim(params.Serie);
      end;

    10: // 't' - �������� �����
      begin
        Result := Trim(params.Title);
      end;
  end;

  //
  // ��������� �� ���������� �������. ��� �����, �� �� ������
  //
  if FTemplateType in [ttFile, ttPath] then
  begin
    for i := 1 to Length(Result) do
    begin
      if not TPath.IsValidFileNameChar(Result[i]) then
        Result[i] := ' ';
    end;
  end;

  if Character.IsUpper(paramName, 1) then
  begin
    //
    // �������������
    //
    Result := Transliterate(Result);
  end;
end;

end.
