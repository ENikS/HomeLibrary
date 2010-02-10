(* *****************************************************************************
  *
  * MyHomeLib
  *
  * ����� ������ � ���������
  *
  * Version 1.0
  * 31.01.2010
  * Copyright (c) Aleksey Penkov  alex.penkov@gmail.com
  * Author        Matvienko Sergei  matv84@mail.ru
  *
  ****************************************************************************** *)

unit unit_Templater;

interface

uses dm_Collection, FictionBook_21, unit_Database, unit_Globals;

const
  mask_elements = 10;

type
  TErrorType = (ErFine, ErTemplate, ErBlocks, ErElements);
  TTemplateType = (TpFile, TpPath, TpText);

  TElement = record
    name: string;
    BegBlock, EndBlock: integer;
  end;

  TTemplater = class
  private
    FTemplate: string;
    FParsedString: string;
    FBlocksMap: array of TElement;

  public
    constructor Create;
    function GetFB2BookInfo(book: IXMLFictionBook): TBookRecord;
    procedure ParseString(R: TBookRecord; TemplType: TTemplateType;
      ALibrary: TMHLLibrary = nil);
    function ValidateTemplate(Template: string; TemplType: TTemplateType)
      : TErrorType;
    function SetTemplate(Template: string; TemplType: TTemplateType)
      : TErrorType;
    function GetParsedString: string;
  end;

implementation

uses
  SysUtils, unit_Consts, dm_user;

constructor TTemplater.Create;
begin
  inherited;
  FParsedString := '';
  FTemplate := '';
end;

function TTemplater.GetFB2BookInfo(book: IXMLFictionBook): TBookRecord;
var
  i: integer;
  R: TBookRecord;
begin
  with book.Description.Titleinfo do
  begin
    for i := 0 to Author.Count - 1 do
      R.AddAuthor(Author[i].Lastname.Text, Author[i].Firstname.Text,
        Author[i].MiddleName.Text);

    if Booktitle.IsTextElement then
      R.Title := Booktitle.Text;

    for i := 0 to Genre.Count - 1 do
      R.AddGenreFB2('', Genre[i], '');

    R.Lang := Lang;
    R.KeyWords := KeyWords.Text;

    if Sequence.Count > 0 then
    begin
      try
        R.Series := Sequence[0].Name;
        R.SeqNumber := Sequence[0].Number;
      except
      end;
    end;

    for i := 0 to Annotation.P.Count - 1 do
      if Annotation.P.Items[i].IsTextElement then
        R.Annotation := R.Annotation + #10#13 + Annotation.P.Items[i].OnlyText;

  end;
  Result := R;
end;

function TTemplater.ValidateTemplate(Template: string; TemplType: TTemplateType)
  : TErrorType;
const
  mask_elements: array [1 .. 8] of string =
    ('f', 't', 's', 'n', 'id', 'g', 'fl', 'rg');
var
  stack: array of TElement;
  h, k, i, j, StackPos, ElementPos, ColElements, last_char,
    last_col_elements: integer;
  bol, TemplEnd: boolean;
  TemplatePart: string;
begin
  if Template = '' then
  begin
    Result := ErTemplate;
    exit;
  end;

  // �������� �� ���������� ������ ���� � ����� ��������� � ������ (������������ ��� ������� �����)
  last_col_elements := 0;
  last_char := 0;

  // ����������� ���������� ��������� � �������
  ColElements := 0;
  for i := 1 to Length(Template) do
    if Template[i] = '%' then
      Inc(ColElements);

  // ��������� ����������� ����������� � ������������� ��������
  SetLength(stack, ColElements);
  SetLength(FBlocksMap, ColElements);
  for i := 0 to ColElements - 1 do
  begin
    stack[i].name := '';
    FBlocksMap[i].name := '';
  end;

  TemplEnd := false;
  k := 1;
  while not(TemplEnd) do
  begin
    i := 1;
    TemplatePart := '';

    // ������ ���� � ����� �� ������������
    while (not(Template[k] = '\')) and (k <= Length(Template)) do
    begin
      TemplatePart := TemplatePart + Template[k];
      Inc(k);
    end;
    Inc(k);
    // ���� ������ ��� ��������� ����, �� ��������� �������
    if k > Length(Template) then
      TemplEnd := true;

    // ������������� �������� ������� ����� � ��������� �������
    StackPos := 0;
    ElementPos := 0;
    while i <= Length(TemplatePart) do
    begin
      // ����� ����������� ������ ����� ��������
      if TemplatePart[i] = '[' then
      begin
        Inc(StackPos);
        stack[StackPos].BegBlock := i;
        stack[StackPos].name := '';
      end;

      // ����� �������� �������
      if TemplatePart[i] = '%' then
      begin
        // ���� ������ ����� ������� ����� ������ ��������, �� ������ ������������
        if (stack[StackPos].name <> '') and (StackPos > 0) then
        begin
          Result := ErTemplate; // � ����� �� ����� ���� ����� ������ ��������
          exit;
        end;

        // �������� �������� ��������
        Inc(i);
        stack[StackPos].name := '';
        while CharInSet(TemplatePart[i], ['a' .. 'z', 'A' .. 'Z']) do
        begin
          stack[StackPos].name := stack[StackPos].name + TemplatePart[i];
          Inc(i);
        end;
        if stack[StackPos].name = '' then
        begin
          Result := ErElements;
          exit;
        end;
        Dec(i);

        // ��������� ������� � ����� ������ ���������
        if StackPos = 0 then
        begin
          FBlocksMap[ElementPos + last_col_elements].name := stack[StackPos]
            .name;
          FBlocksMap[ElementPos + last_col_elements].BegBlock := 0;
          FBlocksMap[ElementPos + last_col_elements].EndBlock := 0;
          Inc(ElementPos);
        end;
      end;

      // ����� ��������� ����� ��������
      if TemplatePart[i] = ']' then
      begin
        // ���� �� ������� ������ ����� ��� �������� ��� ������� �� 0-� ������
        // �� ������ ������������
        if (stack[StackPos].name = '') or (StackPos <= 0) then
        begin
          Result := ErBlocks; // ��������� ������������ ����������� � ����������� ������ ������ ���������
          exit;
        end;
        stack[StackPos].EndBlock := i;

        // ��������� ������� � ����� ������ ���������
        FBlocksMap[ElementPos + last_col_elements].name := stack[StackPos].name;
        FBlocksMap[ElementPos + last_col_elements].BegBlock := stack[StackPos]
          .BegBlock + last_char;
        FBlocksMap[ElementPos + last_col_elements].EndBlock := stack[StackPos]
          .EndBlock + last_char;
        Inc(ElementPos);

        Dec(StackPos);
      end;

      // ������� � ���������� ������� � �������
      Inc(i);
    end;

    // ������� ���������� ������ ������
    if StackPos > 0 then
    begin
      Result := ErBlocks; // ��������� ������������ ����������� � ����������� ������ ������ ���������
      exit;
    end;

    // �������� ���� ��������� �� ������������ ���������
    for h := Low(FBlocksMap) to High(FBlocksMap) do
    begin
      if FBlocksMap[h].name <> '' then
      begin
        bol := false;
        for j := 1 to High(mask_elements) do
          if UpperCase(FBlocksMap[h].name) = UpperCase(mask_elements[j]) then
          begin
            bol := true;
            Break;
          end;

        if not(bol) then
          Break;
      end;
    end;

    // ������� �������� �������� �������
    if not(bol) then
    begin
      Result := ErElements; // �������� �������� �������
      exit;
    end;

    Inc(last_col_elements, ElementPos);

    // �������� �� ���������� �������� � ������ ������ ������� �
    // ����� ��������� � ������ (������������ ��� ������� �����)
    last_char := last_char + k - 1;

    // ������� � ���������� ������� � ������� � ����� ��������� ��������� ����� ���� � �����
    Inc(i);
  end;

  // ���� ��������� ������ ����� �����, �� ������� �� ��������
  if TemplType = TpFile then
    for i := 1 to Length(Template) do
      if Template[i] = '\' then
      begin
        Result := ErTemplate;
        exit;
      end;

  // ���� ��������� ���, �� ������ �������
  Result := ErFine;
end;

function TTemplater.SetTemplate(Template: String; TemplType: TTemplateType)
  : TErrorType;
var
  i: integer;
begin
  Result := ValidateTemplate(Template, TemplType);
  // ����������� ������ ������ ��� ����� ����� ��� ���� � �����
  if TemplType in [TpFile, TpPath] then
    Template := CheckSymbols(Template);

  if Result = ErFine then
  begin

    FTemplate := Trim(Template);
  end;
end;

procedure TTemplater.ParseString(R: TBookRecord; TemplType: TTemplateType;
  ALibrary: TMHLLibrary = nil);
type
  TMaskElement = record
    templ, value: string;
  end;

  TMaskElements = array [1 .. mask_elements] of TMaskElement;
var
  AuthorName, Firstname, MiddleName, Lastname: string;
  i, j: integer;
  RootGenre, Folder: string;
  MaskElements: TMaskElements;
begin
  FParsedString := FTemplate;

  // ������������ ������� �������� ��������� �����
  MaskElements[1].templ := 's';
  if R.Series <> NO_SERIES_TITLE then
    MaskElements[1].value := Trim(R.Series)
  else
    MaskElements[1].value := '';

  MaskElements[2].templ := 'n';
  if R.SeqNumber <> 0 then
    MaskElements[2].value := IntToStr(R.SeqNumber)
  else
    MaskElements[2].value := '';

  MaskElements[3].templ := 't';
  MaskElements[3].value := Trim(R.Title);

  MaskElements[4].templ := 'fa';
  AuthorName := '';
  for i := Low(R.Authors) to High(R.Authors) do
  begin
    Lastname := R.Authors[i].FLastName;
    if R.Authors[i].FFirstName <> '' then
      Firstname := ' ' + R.Authors[i].FFirstName[1] + '.';
    if R.Authors[i].FMiddleName <> '' then
      MiddleName := ' ' + R.Authors[i].FMiddleName[1] + '.';
    AuthorName := AuthorName + Lastname + Firstname + MiddleName;
    if i < High(R.Authors) then
      AuthorName := AuthorName + ', ';
  end;
  MaskElements[4].value := AuthorName;

  MaskElements[5].templ := 'id';
  MaskElements[5].value := IntToStr(R.LibID);

  MaskElements[6].templ := 'fl';
  MaskElements[6].value := R.Authors[ Low(R.Authors)].FLastName[1];

  MaskElements[7].templ := 'f';
  MaskElements[7].value := Trim(R.Authors[0].GetFullName);

  if ALibrary = nil then
  begin
    MaskElements[8].templ := 'ga';
    for i := Low(R.Genres) to High(R.Genres) do
    begin
      MaskElements[8].value := MaskElements[8].value + R.Genres[i].Alias;
      if i < High(R.Genres) then
        MaskElements[8].value := MaskElements[8].value + ', ';
    end;

    MaskElements[9].templ := 'g';
    MaskElements[9].value := Trim(R.Genres[0].Alias);

    MaskElements[10].templ := 'rg';
    MaskElements[10].value := Trim(DMCollection.GetRootGenre(R.LibID));
  end
  else
  begin
    MaskElements[8].templ := 'ga';
    for i := Low(R.Genres) to High(R.Genres) do
    begin
      MaskElements[8].value := MaskElements[8].value + R.Genres[i].Alias;
      if i < High(R.Genres) then
        MaskElements[8].value := MaskElements[8].value + ', ';
    end;

    MaskElements[9].templ := 'g';
    MaskElements[9].value := Trim(ALibrary.GetGenreAlias
        (R.Genres[0].GenreFb2Code));

    MaskElements[10].templ := 'rg';
    MaskElements[10].value := Trim(ALibrary.GetTopGenreAlias
        (R.Genres[0].GenreFb2Code));
  end;

  // ���� �������� "������" ������
  for i := Low(MaskElements) to High(MaskElements) do
    for j := Low(FBlocksMap) to High(FBlocksMap) do
      if (MaskElements[i].templ = FBlocksMap[j].name) and
        (MaskElements[i].value = '') then
        if (FBlocksMap[j].BegBlock <> 0) and (FBlocksMap[j].EndBlock <> 0) then
        begin
          Delete(FParsedString, FBlocksMap[j].BegBlock,
            FBlocksMap[j].EndBlock - FBlocksMap[j].BegBlock + 1);
          // ����� ��� �������� ������� �������� ������� � ��������� ��������� ��� ���������
          ValidateTemplate(FParsedString, TemplType);
        end;

  // ���� �������� ���������� ������
  for i := Length(FParsedString) downto 1 do
    if CharInSet(FParsedString[i], ['[', ']']) then
      Delete(FParsedString, i, 1);

  // ���� ������ ��������� ������� �� ����������
  for i := 1 to mask_elements do
  begin
    if MaskElements[i].templ[1] = UpCase(MaskElements[i].templ[1]) then
      StrReplace('%' + MaskElements[i].templ, Transliterate
          (MaskElements[i].value), FParsedString)
    else
      StrReplace('%' + MaskElements[i].templ, MaskElements[i].value,
        FParsedString);
  end;

end;

function TTemplater.GetParsedString: string;
begin
  Result := FParsedString;
end;

end.
