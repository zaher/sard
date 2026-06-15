unit SardLexer;

{$ifdef FPC}
{$mode objfpc}{$H+}
{$endif}

interface

uses
  SysUtils, SardTypes;

type
  TLexer = class
  private
    FSource: string;
    FPos: Integer;
    FLine, FCol: Integer;
    FLength: Integer;
    FTokenText: string;
    FTokenLine: Integer;
    FTokenCol: Integer;
    function Peek: Char;
    function PeekAt(Offset: Integer): Char;
    function Advance: Char;
    procedure SkipWhitespace;
    procedure SkipComment;
    function ReadIdentifier: string;
    function ReadString(Quote: Char): string;
    function ReadNumber: string;
    function ReadHex: string;
    function ReadColor: string;
    function ReadCurrency: string;
    function ReadDate: string;
    function ReadEscape: string;
    function IsIdStart(C: Char): Boolean;
    function IsIdContinue(C: Char): Boolean;
    function IsAlpha(C: Char): Boolean;
    function IsDigit(C: Char): Boolean;
    procedure NewLine;
  public
    constructor Create(const Source: string);
    function NextToken: TTokenKind;
    function CurrentText: string;
    function CurrentLine: Integer;
    function CurrentCol: Integer;
  end;

implementation

constructor TLexer.Create(const Source: string);
begin
  inherited Create;
  FSource := Source;
  FPos := 1;
  FLine := 1;
  FCol := 1;
  FLength := Length(Source);
end;

function TLexer.Peek: Char;
begin
  if FPos <= FLength then
    Result := FSource[FPos]
  else
    Result := #0;
end;

function TLexer.PeekAt(Offset: Integer): Char;
begin
  if (FPos + Offset >= 1) and (FPos + Offset <= FLength) then
    Result := FSource[FPos + Offset]
  else
    Result := #0;
end;

function TLexer.Advance: Char;
begin
  if FPos <= FLength then
  begin
    Result := FSource[FPos];
    Inc(FPos);
    Inc(FCol);
  end
  else
    Result := #0;
end;

procedure TLexer.NewLine;
begin
  Inc(FLine);
  FCol := 1;
end;

procedure TLexer.SkipWhitespace;
var
  C: Char;
begin
  while True do
  begin
    C := Peek;
    if C = #0 then Break;
    if (C = ' ') or (C = #9) or (C = #13) then
      Advance
    else
      Break;
  end;
end;

procedure TLexer.SkipComment;
var
  C: Char;
begin
  if (Peek = '/') and (PeekAt(1) = '/') then
  begin
    while (Peek <> #0) and (Peek <> #10) do Advance;
  end
  else if (Peek = '/') and (PeekAt(1) = '*') then
  begin
    Advance; Advance;
    while FPos <= FLength do
    begin
      C := Advance;
      if C = '*' then
      begin
        if Peek = '/' then
        begin
          Advance;
          Break;
        end;
      end
      else if C = #10 then NewLine;
    end;
  end;
end;

function TLexer.IsAlpha(C: Char): Boolean;
begin
  Result := ((C >= 'a') and (C <= 'z')) or ((C >= 'A') and (C <= 'Z'));
end;

function TLexer.IsDigit(C: Char): Boolean;
begin
  Result := (C >= '0') and (C <= '9');
end;

function TLexer.IsIdStart(C: Char): Boolean;
begin
  Result := IsAlpha(C) or (C = '_') or (Ord(C) > 127);
end;

function TLexer.IsIdContinue(C: Char): Boolean;
begin
  Result := IsIdStart(C) or IsDigit(C);
end;

function TLexer.ReadIdentifier: string;
var
  Start: Integer;
begin
  Start := FPos;
  while IsIdContinue(Peek) do Advance;
  Result := Copy(FSource, Start, FPos - Start);
end;

function TLexer.ReadString(Quote: Char): string;
var
  Start: Integer;
  C: Char;
begin
  Advance; { opening quote }
  Start := FPos;
  while (Peek <> #0) and (Peek <> Quote) do
  begin
    C := Advance;
    if C = #10 then NewLine;
  end;
  Result := Copy(FSource, Start, FPos - Start);
  if Peek = Quote then
    Advance
  else
    raise ESardError.CreateFmt('Unterminated string at line %d col %d', [FLine, FCol]);
end;

function TLexer.ReadNumber: string;
var
  Start: Integer;
begin
  Start := FPos;
  while IsDigit(Peek) or (Peek = '_') do Advance;
  if (Peek = '.') and (IsDigit(PeekAt(1)) or (PeekAt(1) = '_')) then
  begin
    Advance;
    while IsDigit(Peek) or (Peek = '_') do Advance;
  end;
  Result := Copy(FSource, Start, FPos - Start);
  Result := StringReplace(Result, '_', '', [rfReplaceAll]);
end;

function TLexer.ReadHex: string;
var
  Start: Integer;
begin
  Advance; { '0' }
  Advance; { 'x' }
  Start := FPos;
  while IsDigit(Peek) or ((Peek >= 'a') and (Peek <= 'f')) or ((Peek >= 'A') and (Peek <= 'F')) or (Peek = '_') do
    Advance;
  Result := Copy(FSource, Start, FPos - Start);
  Result := StringReplace(Result, '_', '', [rfReplaceAll]);
  if Result = '' then
    raise ESardError.CreateFmt('Invalid hex literal at line %d col %d', [FLine, FCol]);
end;

function TLexer.ReadColor: string;
var
  Start: Integer;
  Len: Integer;
  R, G, B: string;
  S: string;
begin
  Advance; { '#' }
  Start := FPos;
  while IsDigit(Peek) or ((Peek >= 'a') and (Peek <= 'f')) or ((Peek >= 'A') and (Peek <= 'F')) or (Peek = '_') do
    Advance;
  S := Copy(FSource, Start, FPos - Start);
  S := StringReplace(S, '_', '', [rfReplaceAll]);
  Len := Length(S);
  if Len = 3 then
  begin
    R := S[1] + S[1];
    G := S[2] + S[2];
    B := S[3] + S[3];
    Result := R + G + B;
  end
  else if Len = 6 then
    Result := S
  else
    raise ESardError.CreateFmt('Invalid color literal length %d at line %d col %d', [Len, FLine, FCol]);
end;

function TLexer.ReadCurrency: string;
var
  Start: Integer;
  FracCount: Integer;
  HasDot: Boolean;
  S: string;
  DotPos: Integer;
  I: Integer;
begin
  Advance; { '$' }
  Start := FPos;
  while IsDigit(Peek) or (Peek = '_') do Advance;
  HasDot := False;
  FracCount := 0;
  if Peek = '.' then
  begin
    HasDot := True;
    Advance;
    while IsDigit(Peek) or (Peek = '_') do
    begin
      if IsDigit(Peek) then
        Inc(FracCount);
      Advance;
    end;
    if FracCount > 6 then
      raise ESardError.CreateFmt('Currency literal has too many fractional digits at line %d col %d', [FLine, FCol]);
  end;
  S := Copy(FSource, Start, FPos - Start);
  S := StringReplace(S, '_', '', [rfReplaceAll]);
  { Normalize to 6 fractional digits for parser }
  if HasDot then
  begin
    DotPos := Pos('.', S);
    FracCount := Length(S) - DotPos;
    for I := 1 to (6 - FracCount) do
      S := S + '0';
    Result := S;
  end
  else
    Result := S + '.000000';
end;

function TLexer.ReadDate: string;
var
  Start: Integer;
  S: string;
  Year, Month, Day: Integer;
  Hour, Min, Sec: Integer;
  DateValue, TimeValue: TDateTime;
  Len: Integer;
  FS: TFormatSettings;
begin
  Advance; { '0' }
  Advance; { 't' }
  Start := FPos;
  while IsDigit(Peek) or (Peek = '_') do
    Advance;
  S := Copy(FSource, Start, FPos - Start);
  S := StringReplace(S, '_', '', [rfReplaceAll]);
  Len := Length(S);
  if (Len <> 8) and (Len <> 10) and (Len <> 12) and (Len <> 14) then
    raise ESardError.CreateFmt('Invalid date literal at line %d col %d: expected 8, 10, 12, or 14 digits', [FLine, FCol]);

  Year := StrToInt(Copy(S, 1, 4));
  Month := StrToInt(Copy(S, 5, 2));
  Day := StrToInt(Copy(S, 7, 2));
  try
    DateValue := EncodeDate(Year, Month, Day);
  except
    raise ESardError.CreateFmt('Invalid date literal at line %d col %d', [FLine, FCol]);
  end;

  Hour := 0;
  Min := 0;
  Sec := 0;
  if Len >= 10 then Hour := StrToInt(Copy(S, 9, 2));
  if Len >= 12 then Min := StrToInt(Copy(S, 11, 2));
  if Len >= 14 then Sec := StrToInt(Copy(S, 13, 2));

  try
    TimeValue := EncodeTime(Hour, Min, Sec, 0);
  except
    raise ESardError.CreateFmt('Invalid date literal at line %d col %d: invalid time', [FLine, FCol]);
  end;

  DateValue := DateValue + TimeValue;

  {$ifdef FPC}
  FS := DefaultFormatSettings;
  {$else}
  FS := FormatSettings;
  {$endif}
  FS.DecimalSeparator := '.';
  Result := FloatToStrF(DateValue, ffGeneral, 17, 0, FS);
end;

function TLexer.ReadEscape: string;
var
  C: Char;
begin
  Advance; { '\' }
  C := Advance;
  case C of
    'n': Result := #10;
    'r': Result := #13;
    't': Result := #9;
    '\': Result := '\';
    '0': Result := #0;
  else
    raise ESardError.CreateFmt('Invalid escape sequence \\%s at line %d col %d', [C, FLine, FCol]);
  end;
end;

function TLexer.CurrentText: string;
begin
  Result := FTokenText;
end;

function TLexer.CurrentLine: Integer;
begin
  Result := FTokenLine;
end;

function TLexer.CurrentCol: Integer;
begin
  Result := FTokenCol;
end;

function TLexer.NextToken: TTokenKind;
var
  C, C2: Char;
  S: string;
  Collected: string;
  IsString: Boolean;
  Parts: array of string;
  I: Integer;

  procedure AddPart(const P: string);
  var
    N: Integer;
  begin
    N := Length(Parts);
    SetLength(Parts, N + 1);
    Parts[N] := P;
  end;

begin
  Collected := '';
  IsString := False;
  SetLength(Parts, 0);

  repeat
    SkipWhitespace;
    if FPos > FLength then
    begin
      FTokenText := '';
      Result := tkEOF;
      Exit;
    end;

    C := Peek;

    { Comments }
    if (C = '/') and ((PeekAt(1) = '/') or (PeekAt(1) = '*')) then
    begin
      SkipComment;
      Continue;
    end;

    { Newline as statement terminator }
    if C = #10 then
    begin
      FTokenLine := FLine;
      FTokenCol := FCol;
      Advance;
      NewLine;
      FTokenText := '\n';
      Result := tkNewLine;
      Exit;
    end;

    Break;
  until False;

  FTokenLine := FLine;
  FTokenCol := FCol;

  { String/escape collection: consecutive strings and escapes are concatenated }
  while True do
  begin
    C := Peek;
    if (C = '"') or (C = '''') then
    begin
      IsString := True;
      AddPart(ReadString(C));
    end
    else if C = '\' then
    begin
      IsString := True;
      AddPart(ReadEscape);
    end
    else
      Break;
    SkipWhitespace;
  end;

  if IsString then
  begin
    Collected := '';
    for I := 0 to High(Parts) do
      Collected := Collected + Parts[I];
    FTokenText := Collected;
    Result := tkString;
    Exit;
  end;

  C := Peek;
  C2 := PeekAt(1);

  { Two-char operators }
  if (C = '=') and (C2 = '=') then begin Advance; Advance; FTokenText := '=='; Result := tkTypeCheck; Exit; end;
  if (C = '<') and (C2 = '>') then begin Advance; Advance; FTokenText := '<>'; Result := tkLessGreater; Exit; end;
  if (C = '!') and (C2 = '=') then begin Advance; Advance; FTokenText := '!='; Result := tkBangEqual; Exit; end;
  if (C = '<') and (C2 = '=') then begin Advance; Advance; FTokenText := '<='; Result := tkLessEqual; Exit; end;
  if (C = '>') and (C2 = '=') then begin Advance; Advance; FTokenText := '>='; Result := tkGreaterEqual; Exit; end;
  if (C = '+') and (C2 = '=') then begin Advance; Advance; FTokenText := '+='; Result := tkPlusEqual; Exit; end;
  if (C = '-') and (C2 = '=') then begin Advance; Advance; FTokenText := '-='; Result := tkMinusEqual; Exit; end;
  if (C = '+') and (C2 = '+') then begin Advance; Advance; FTokenText := '++'; Result := tkIncrement; Exit; end;
  if (C = '-') and (C2 = '-') then begin Advance; Advance; FTokenText := '--'; Result := tkDecrement; Exit; end;
  if (C = '~') and (C2 = '~') then begin Advance; Advance; FTokenText := '~~'; Result := tkTildeTilde; Exit; end;

  { Single-char operators and punctuation }
  case C of
    ':': begin Advance; FTokenText := ':'; Result := tkColon; Exit; end;
    ';': begin Advance; FTokenText := ';'; Result := tkSemicolon; Exit; end;
    ',': begin Advance; FTokenText := ','; Result := tkComma; Exit; end;
    '.':
      begin
        if (PeekAt(1) = '.') and (PeekAt(2) = '.') then
        begin
          Advance; Advance; Advance;
          FTokenText := '...';
          Result := tkEllipsis;
          Exit;
        end;
        Advance; FTokenText := '.'; Result := tkDot; Exit;
      end;
    '=': begin Advance; FTokenText := '='; Result := tkAssign; Exit; end;
    '<': begin Advance; FTokenText := '<'; Result := tkLess; Exit; end;
    '>': begin Advance; FTokenText := '>'; Result := tkGreater; Exit; end;
    '+': begin Advance; FTokenText := '+'; Result := tkPlus; Exit; end;
    '-': begin Advance; FTokenText := '-'; Result := tkMinus; Exit; end;
    '*': begin Advance; FTokenText := '*'; Result := tkStar; Exit; end;
    '/': begin Advance; FTokenText := '/'; Result := tkSlash; Exit; end;
    '^': begin Advance; FTokenText := '^'; Result := tkCaret; Exit; end;
    '%': begin Advance; FTokenText := '%'; Result := tkPercent; Exit; end;
    '&': begin Advance; FTokenText := '&'; Result := tkAmp; Exit; end;
    '|': begin Advance; FTokenText := '|'; Result := tkBar; Exit; end;
    '!': begin Advance; FTokenText := '!'; Result := tkBang; Exit; end;
    '~': begin Advance; FTokenText := '~'; Result := tkTilde; Exit; end;
    '@': begin Advance; FTokenText := '@'; Result := tkAt; Exit; end;
    '(': begin Advance; FTokenText := '('; Result := tkLParen; Exit; end;
    ')': begin Advance; FTokenText := ')'; Result := tkRParen; Exit; end;
    '{': begin Advance; FTokenText := '{'; Result := tkLBrace; Exit; end;
    '}': begin Advance; FTokenText := '}'; Result := tkRBrace; Exit; end;
    '[': begin Advance; FTokenText := '['; Result := tkLBracket; Exit; end;
    ']': begin Advance; FTokenText := ']'; Result := tkRBracket; Exit; end;
  end;

  { Date }
  if (C = '0') and ((C2 = 't') or (C2 = 'T')) then
  begin
    FTokenText := ReadDate;
    Result := tkDate;
    Exit;
  end;

  { Hex }
  if (C = '0') and ((C2 = 'x') or (C2 = 'X')) then
  begin
    FTokenText := ReadHex;
    Result := tkHex;
    Exit;
  end;

  { Number }
  if IsDigit(C) then
  begin
    S := ReadNumber;
    if Pos('.', S) > 0 then
    begin
      FTokenText := S;
      Result := tkNumber;
    end
    else
    begin
      FTokenText := S;
      Result := tkInteger;
    end;
    Exit;
  end;

  { Color }
  if C = '#' then
  begin
    FTokenText := ReadColor;
    Result := tkColor;
    Exit;
  end;

  { Currency }
  if C = '$' then
  begin
    FTokenText := ReadCurrency;
    Result := tkCurrency;
    Exit;
  end;

  { Identifier or named operator }
  if IsIdStart(C) then
  begin
    S := ReadIdentifier;
    FTokenText := S;
    if LowerName(S) = 'mod' then Result := tkMod
    else if LowerName(S) = 'and' then Result := tkAnd
    else if LowerName(S) = 'or' then Result := tkOr
    else if LowerName(S) = 'not' then Result := tkNot
    else Result := tkIdentifier;
    Exit;
  end;

  raise ESardError.CreateFmt('Unexpected character ''%s'' at line %d col %d', [C, FLine, FCol]);
end;

end.
