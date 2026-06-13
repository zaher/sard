unit sard_lexer;

{$mode objfpc}{$H+}{$J-}

interface

uses
  SysUtils, sard_errors;

type
  TSardTokenType = (
    tokEOF,
    tokAnd, tokOr, tokNot, tokMod,
    tokTrue, tokFalse,
    tokPlus, tokMinus, tokStar, tokSlash, tokCaret, tokPercent,
    tokAmpersand, tokBar, tokBang, tokTilde, tokTildeTilde,
    tokAt, tokInc, tokDec,
    tokEq, tokTypeEq, tokNeq, tokNNeq,
    tokLT, tokGT, tokLTE, tokGTE,
    tokPlusAssign, tokMinusAssign,
    tokLParen, tokRParen, tokLBrace, tokRBrace,
    tokLBracket, tokRBracket,
    tokColon, tokSemi, tokComma, tokDot,
    tokPreprocessor,
    tokInteger, tokNumber, tokHex, tokString,
    tokColor, tokCurrency, tokEscapeSeq,
    tokIdentifier
  );

  TSardTokenSet = set of TSardTokenType;

  TSardToken = class
  public
    TokenType: TSardTokenType;
    Value: string;
    IntValue: Int64;
    FloatValue: Double;
    Line: Integer;
    Column: Integer;
    constructor Create(AType: TSardTokenType; const AValue: string; AInt: Int64; AFloat: Double; ALine, ACol: Integer);
  end;

  TSardTokenArray = array of TSardToken;

  TSardLexer = class
  private
    FSource: string;
    FSourceName: string;
    FPos: Integer;
    FLine: Integer;
    FColumn: Integer;
    FTokens: array of TSardToken;
    FTokenCount: Integer;
    procedure Error(const AMsg: string);
    function Peek(AOffset: Integer = 0): Char;
    function AtEnd: Boolean;
    function Advance: Char;
    procedure AddToken(AType: TSardTokenType; const AValue: string; ALine, ACol: Integer);
    procedure AddTokenInt(AType: TSardTokenType; const AValue: string; AInt: Int64; ALine, ACol: Integer);
    procedure AddTokenFloat(AType: TSardTokenType; const AValue: string; AFloat: Double; ALine, ACol: Integer);
    procedure MaybeInsertSemi(ALine, ACol: Integer);
    function SkipWsAndComments: Boolean;
    procedure SkipLineCommentRaw;
    procedure SkipBlockComment;
    procedure SkipCurlyBlockComment;
    procedure ReadPreprocessor(ALine, ACol: Integer);
    procedure ReadColor(ALine, ACol: Integer);
    procedure ReadCurrency(ALine, ACol: Integer);
    procedure ReadString(AQuote: Char; ALine, ACol: Integer);
    procedure ReadEscape(ALine, ACol: Integer);
    procedure ReadHex(ALine, ACol: Integer);
    procedure ReadNumber(ALine, ACol: Integer);
    procedure ReadIdentifier(ALine, ACol: Integer);
    procedure ConcatStringEscapes;
    procedure Tokenize;
  public
    constructor Create(const ASource: string; const ASourceName: string = '<script>');
    destructor Destroy; override;
    function GetTokens: TSardTokenArray;
    function GetTokenCount: Integer;
  end;

function TokenTypeToString(T: TSardTokenType): string;

implementation

const
  NoSemiAfterTokens: TSardTokenSet = [
    tokLParen, tokLBracket, tokLBrace,
    tokDot, tokComma,
    tokAnd, tokOr, tokNot, tokMod,
    tokAmpersand, tokBar,
    tokEq, tokNeq, tokNNeq,
    tokLT, tokGT, tokLTE, tokGTE,
    tokPlus, tokMinus, tokStar, tokSlash,
    tokCaret, tokPercent,
    tokPlusAssign, tokMinusAssign,
    tokTilde, tokAt, tokSemi,
    tokTypeEq
  ];

var
  GFormatSettings: TFormatSettings;

function TokenTypeToString(T: TSardTokenType): string;
begin
  WriteStr(Result, T);
end;

function FindKeywordType(const ALower: string): TSardTokenType;
begin
  Result := tokIdentifier;
  if ALower = 'and' then Result := tokAnd
  else if ALower = 'or' then Result := tokOr
  else if ALower = 'not' then Result := tokNot
  else if ALower = 'mod' then Result := tokMod
  else if ALower = 'true' then Result := tokTrue
  else if ALower = 'false' then Result := tokFalse;
end;

function IsHexDigit(C: Char): Boolean;
begin
  Result := C in ['0'..'9', 'a'..'f', 'A'..'F'];
end;

constructor TSardLexer.Create(const ASource: string; const ASourceName: string);
begin
  inherited Create;
  FSource := ASource;
  FSourceName := ASourceName;
  FPos := 1;
  FLine := 1;
  FColumn := 1;
  FTokenCount := 0;
  SetLength(FTokens, 256);
  Tokenize;
end;

destructor TSardLexer.Destroy;
var
  I: Integer;
begin
  for I := 0 to FTokenCount - 1 do
    FTokens[I].Free;
  SetLength(FTokens, 0);
  inherited Destroy;
end;

constructor TSardToken.Create(AType: TSardTokenType; const AValue: string; AInt: Int64; AFloat: Double; ALine, ACol: Integer);
begin
  inherited Create;
  TokenType := AType;
  Value := AValue;
  IntValue := AInt;
  FloatValue := AFloat;
  Line := ALine;
  Column := ACol;
end;

procedure TSardLexer.Error(const AMsg: string);
begin
  raise ESardLexerError.Create(
    Format('%s:%d:%d: %s', [FSourceName, FLine, FColumn, AMsg]),
    FLine, FColumn);
end;

function TSardLexer.Peek(AOffset: Integer): Char;
var
  Idx: Integer;
begin
  Idx := FPos + AOffset;
  if (Idx < 1) or (Idx > Length(FSource)) then
    Result := #0
  else
    Result := FSource[Idx];
end;

function TSardLexer.AtEnd: Boolean;
begin
  Result := FPos > Length(FSource);
end;

function TSardLexer.Advance: Char;
begin
  if FPos <= Length(FSource) then
  begin
    Result := FSource[FPos];
    Inc(FPos);
    if Result = #10 then
    begin
      Inc(FLine);
      FColumn := 1;
    end
    else
      Inc(FColumn);
  end
  else
    Result := #0;
end;

procedure TSardLexer.AddToken(AType: TSardTokenType; const AValue: string; ALine, ACol: Integer);
begin
  if FTokenCount >= Length(FTokens) then
    SetLength(FTokens, Length(FTokens) * 2);
  FTokens[FTokenCount] := TSardToken.Create(AType, AValue, 0, 0.0, ALine, ACol);
  Inc(FTokenCount);
end;

procedure TSardLexer.AddTokenInt(AType: TSardTokenType; const AValue: string; AInt: Int64; ALine, ACol: Integer);
begin
  if FTokenCount >= Length(FTokens) then
    SetLength(FTokens, Length(FTokens) * 2);
  FTokens[FTokenCount] := TSardToken.Create(AType, AValue, AInt, 0.0, ALine, ACol);
  Inc(FTokenCount);
end;

procedure TSardLexer.AddTokenFloat(AType: TSardTokenType; const AValue: string; AFloat: Double; ALine, ACol: Integer);
begin
  if FTokenCount >= Length(FTokens) then
    SetLength(FTokens, Length(FTokens) * 2);
  FTokens[FTokenCount] := TSardToken.Create(AType, AValue, 0, AFloat, ALine, ACol);
  Inc(FTokenCount);
end;

procedure TSardLexer.MaybeInsertSemi(ALine, ACol: Integer);
begin
  if FTokenCount = 0 then
  begin
    AddToken(tokSemi, ';', ALine, ACol);
    Exit;
  end;
  if not (FTokens[FTokenCount - 1].TokenType in NoSemiAfterTokens) then
    AddToken(tokSemi, ';', ALine, ACol);
end;

function TSardLexer.SkipWsAndComments: Boolean;
var
  HadNewline: Boolean;
begin
  HadNewline := False;
  while not AtEnd do
  begin
    case Peek of
      ' ', #9, #13: Advance;
      #10:
      begin
        Advance;
        if not HadNewline then HadNewline := True;
      end;
      '/':
        if Peek(1) = '/' then
        begin
          SkipLineCommentRaw;
          HadNewline := True;
        end
        else if Peek(1) = '*' then
          SkipBlockComment
        else
          Break;
      '{':
        if Peek(1) = '*' then
          SkipCurlyBlockComment
        else
          Break;
    else
      Break;
    end;
  end;
  Result := HadNewline;
end;

procedure TSardLexer.SkipLineCommentRaw;
begin
  Advance; Advance;
  while not AtEnd and (Peek <> #10) and (Peek <> #0) do
    Advance;
end;

procedure TSardLexer.SkipBlockComment;
var
  Depth: Integer;
begin
  Advance; Advance;
  Depth := 1;
  while not AtEnd and (Depth > 0) do
  begin
    if (Peek = '*') and (Peek(1) = '/') then
    begin
      Advance; Advance;
      Dec(Depth);
    end
    else
      Advance;
  end;
  if Depth > 0 then
    Error('Unterminated block comment');
end;

procedure TSardLexer.SkipCurlyBlockComment;
begin
  Advance; Advance;
  while not AtEnd do
  begin
    if (Peek = '*') and (Peek(1) = '}') then
    begin
      Advance; Advance;
      Exit;
    end;
    Advance;
  end;
  Error('Unterminated {* *} block comment');
end;

procedure TSardLexer.ReadPreprocessor(ALine, ACol: Integer);
var
  Text: string;
begin
  Advance; Advance;
  Text := '';
  while not AtEnd do
  begin
    if (Peek = '?') and (Peek(1) = '}') then
    begin
      Advance; Advance;
      AddToken(tokPreprocessor, Text, ALine, ACol);
      Exit;
    end;
    Text := Text + Advance;
  end;
  Error('Unterminated preprocessor region');
end;

procedure TSardLexer.ReadColor(ALine, ACol: Integer);
var
  HexDigits, Expanded: string;
  Value: Int64;
  Ch: Char;
begin
  Advance;
  HexDigits := '';
  while not AtEnd and (Length(HexDigits) < 6) do
  begin
    Ch := Peek;
    if IsHexDigit(Ch) then
      HexDigits := HexDigits + Advance
    else
      Break;
  end;
  if Length(HexDigits) = 3 then
  begin
    Expanded := HexDigits[1] + HexDigits[1] + HexDigits[2] + HexDigits[2] + HexDigits[3] + HexDigits[3];
    Value := StrToInt64('$' + Expanded);
  end
  else if Length(HexDigits) = 6 then
    Value := StrToInt64('$' + HexDigits)
  else
  begin
    Error('Invalid color literal: #' + HexDigits);
    Exit;
  end;
  AddTokenInt(tokColor, '#' + HexDigits, Value, ALine, ACol);
end;

procedure TSardLexer.ReadCurrency(ALine, ACol: Integer);
var
  Digits, Frac: string;
  IntPart, FracPart, Value: Int64;
  FracLen: Integer;
begin
  Advance;
  Digits := '';
  while not AtEnd and (Peek in ['0'..'9']) do
    Digits := Digits + Advance;
  Frac := '';
  if not AtEnd and (Peek = '.') then
  begin
    Advance;
    FracLen := 0;
    while not AtEnd and (Peek in ['0'..'9']) and (FracLen < 6) do
    begin
      Frac := Frac + Advance;
      Inc(FracLen);
    end;
    if not AtEnd and (Peek in ['0'..'9']) then
      Error('Currency literal has more than 6 fractional digits');
  end;
  if Digits = '' then IntPart := 0 else IntPart := StrToInt64(Digits);
  if Frac = '' then FracPart := 0
  else
  begin
    while Length(Frac) < 6 do Frac := Frac + '0';
    FracPart := StrToInt64(Frac);
  end;
  Value := IntPart * 1000000 + FracPart;
  if Frac <> '' then
    AddTokenInt(tokCurrency, '$' + Digits + '.' + Frac, Value, ALine, ACol)
  else
    AddTokenInt(tokCurrency, '$' + Digits, Value, ALine, ACol);
end;

procedure TSardLexer.ReadString(AQuote: Char; ALine, ACol: Integer);
var
  Text: string;
  Ch: Char;
begin
  Advance;
  Text := '';
  while not AtEnd do
  begin
    Ch := Peek;
    if Ch = AQuote then
    begin
      Advance;
      AddToken(tokString, Text, ALine, ACol);
      Exit;
    end;
    Text := Text + Advance;
  end;
  Error('Unterminated string literal');
end;

procedure TSardLexer.ReadEscape(ALine, ACol: Integer);
const
  EscapeChars: array[0..4] of record Ch: Char; Val: Char; end = (
    (Ch: 'n'; Val: #10),
    (Ch: 'r'; Val: #13),
    (Ch: 't'; Val: #9),
    (Ch: '\'; Val: '\'),
    (Ch: '0'; Val: #0)
  );
var
  Ch: Char;
  I: Integer;
  Found: Boolean;
  EscVal: Char;
begin
  Advance;
  if AtEnd then begin Error('Unexpected end after backslash'); Exit; end;
  Ch := Advance;
  Found := False;
  for I := Low(EscapeChars) to High(EscapeChars) do
  begin
    if EscapeChars[I].Ch = Ch then
    begin
      EscVal := EscapeChars[I].Val;
      AddToken(tokEscapeSeq, EscVal, ALine, ACol);
      Found := True;
      Break;
    end;
  end;
  if not Found then
    Error('Invalid escape sequence: \' + Ch);
end;

procedure TSardLexer.ReadHex(ALine, ACol: Integer);
var
  Digits: string;
  Value: Int64;
begin
  Advance; Advance;
  Digits := '';
  while not AtEnd and IsHexDigit(Peek) do
    Digits := Digits + Advance;
  if Digits = '' then begin Error('Invalid hex literal'); Exit; end;
  Value := StrToInt64('$' + Digits);
  AddTokenInt(tokHex, '0x' + Digits, Value, ALine, ACol);
end;

procedure TSardLexer.ReadNumber(ALine, ACol: Integer);
var
  Digits, Frac: string;
  FloatVal: Double;
  IntVal: Int64;
begin
  Digits := '';
  while not AtEnd and (Peek in ['0'..'9']) do
    Digits := Digits + Advance;
  if not AtEnd and (Peek = '.') and ((FPos <= Length(FSource)) and (FSource[FPos + 1] in ['0'..'9'])) then
  begin
    Advance;
    Frac := '';
    while not AtEnd and (Peek in ['0'..'9']) do
      Frac := Frac + Advance;
    FloatVal := StrToFloat(Digits + '.' + Frac, GFormatSettings);
    AddTokenFloat(tokNumber, Digits + '.' + Frac, FloatVal, ALine, ACol);
  end
  else
  begin
    IntVal := StrToInt64(Digits);
    AddTokenInt(tokInteger, Digits, IntVal, ALine, ACol);
  end;
end;

procedure TSardLexer.ReadIdentifier(ALine, ACol: Integer);
var
  Text, Lower: string;
  KwType: TSardTokenType;
  Ch: Char;
begin
  Text := '';
  while not AtEnd do
  begin
    Ch := Peek;
    if Ch in ['a'..'z', 'A'..'Z', '0'..'9', '_'] then
      Text := Text + Advance
    else if Ord(Ch) > 127 then
      Text := Text + Advance
    else
      Break;
  end;
  Lower := LowerCase(Text);
  KwType := FindKeywordType(Lower);
  if KwType <> tokIdentifier then
  begin
    if KwType = tokTrue then
      AddToken(tokTrue, 'true', ALine, ACol)
    else if KwType = tokFalse then
      AddToken(tokFalse, 'false', ALine, ACol)
    else
      AddToken(KwType, Lower, ALine, ACol);
  end
  else
    AddToken(tokIdentifier, Lower, ALine, ACol);
end;

procedure TSardLexer.ConcatStringEscapes;
var
  Result: TSardTokenArray;
  RIdx, I: Integer;
  Parts: string;
  StartLine, StartCol: Integer;
begin
  SetLength(Result, FTokenCount);
  RIdx := 0;
  I := 0;
  while I < FTokenCount do
  begin
    if FTokens[I].TokenType in [tokString, tokEscapeSeq] then
    begin
      Parts := '';
      StartLine := FTokens[I].Line;
      StartCol := FTokens[I].Column;
      while (I < FTokenCount) and (FTokens[I].TokenType in [tokString, tokEscapeSeq]) do
      begin
        Parts := Parts + FTokens[I].Value;
        FTokens[I].Free;
        Inc(I);
      end;
      Result[RIdx] := TSardToken.Create(tokString, Parts, 0, 0.0, StartLine, StartCol);
      Inc(RIdx);
    end
    else
    begin
      Result[RIdx] := FTokens[I];
      Inc(RIdx);
      Inc(I);
    end;
  end;
  FTokens := Result;
  FTokenCount := RIdx;
end;

procedure TSardLexer.Tokenize;
var
  Ch: Char;
  SL, SC: Integer;
begin
  while not AtEnd do
  begin
    if SkipWsAndComments then
      MaybeInsertSemi(FLine, FColumn);
    if AtEnd then Break;
    Ch := Peek;
    SL := FLine;
    SC := FColumn;

    case Ch of
      '{':
      begin
        if Peek(1) = '?' then ReadPreprocessor(SL, SC)
        else if Peek(1) = '*' then SkipCurlyBlockComment
        else begin Advance; AddToken(tokLBrace, '{', SL, SC); end;
      end;
      '}': begin Advance; AddToken(tokRBrace, '}', SL, SC); end;
      '(': begin Advance; AddToken(tokLParen, '(', SL, SC); end;
      ')': begin Advance; AddToken(tokRParen, ')', SL, SC); end;
      '[': begin Advance; AddToken(tokLBracket, '[', SL, SC); end;
      ']': begin Advance; AddToken(tokRBracket, ']', SL, SC); end;
      ':': begin Advance; AddToken(tokColon, ':', SL, SC); end;
      ';': begin Advance; AddToken(tokSemi, ';', SL, SC); end;
      ',': begin Advance; AddToken(tokComma, ',', SL, SC); end;
      '.':
      begin
        if (FPos <= Length(FSource)) and (FSource[FPos + 1] in ['0'..'9']) then
          ReadNumber(SL, SC)
        else
        begin
          Advance;
          AddToken(tokDot, '.', SL, SC);
        end;
      end;
      '+':
      begin
        if Peek(1) = '+' then begin Advance; Advance; AddToken(tokInc, '++', SL, SC); end
        else if Peek(1) = '=' then begin Advance; Advance; AddToken(tokPlusAssign, '+=', SL, SC); end
        else begin Advance; AddToken(tokPlus, '+', SL, SC); end;
      end;
      '-':
      begin
        if Peek(1) = '-' then begin Advance; Advance; AddToken(tokDec, '--', SL, SC); end
        else if Peek(1) = '=' then begin Advance; Advance; AddToken(tokMinusAssign, '-=', SL, SC); end
        else begin Advance; AddToken(tokMinus, '-', SL, SC); end;
      end;
      '*': begin Advance; AddToken(tokStar, '*', SL, SC); end;
      '/':
      begin
        if Peek(1) = '/' then SkipLineCommentRaw
        else if Peek(1) = '*' then SkipBlockComment
        else begin Advance; AddToken(tokSlash, '/', SL, SC); end;
      end;
      '^': begin Advance; AddToken(tokCaret, '^', SL, SC); end;
      '%': begin Advance; AddToken(tokPercent, '%', SL, SC); end;
      '&': begin Advance; AddToken(tokAmpersand, '&', SL, SC); end;
      '|': begin Advance; AddToken(tokBar, '|', SL, SC); end;
      '~':
      begin
        if Peek(1) = '~' then begin Advance; Advance; AddToken(tokTildeTilde, '~~', SL, SC); end
        else begin Advance; AddToken(tokTilde, '~', SL, SC); end;
      end;
      '@': begin Advance; AddToken(tokAt, '@', SL, SC); end;
      '!':
      begin
        if Peek(1) = '=' then begin Advance; Advance; AddToken(tokNNeq, '!=', SL, SC); end
        else begin Advance; AddToken(tokBang, '!', SL, SC); end;
      end;
      '=':
      begin
        if Peek(1) = '=' then begin Advance; Advance; AddToken(tokTypeEq, '==', SL, SC); end
        else begin Advance; AddToken(tokEq, '=', SL, SC); end;
      end;
      '<':
      begin
        if Peek(1) = '>' then begin Advance; Advance; AddToken(tokNeq, '<>', SL, SC); end
        else if Peek(1) = '=' then begin Advance; Advance; AddToken(tokLTE, '<=', SL, SC); end
        else begin Advance; AddToken(tokLT, '<', SL, SC); end;
      end;
      '>':
      begin
        if Peek(1) = '=' then begin Advance; Advance; AddToken(tokGTE, '>=', SL, SC); end
        else begin Advance; AddToken(tokGT, '>', SL, SC); end;
      end;
      '#': ReadColor(SL, SC);
      '$': ReadCurrency(SL, SC);
      '"', '''': ReadString(Ch, SL, SC);
      '\': ReadEscape(SL, SC);
      '0'..'9':
      begin
        if (Ch = '0') and (Peek(1) in ['x', 'X']) then
          ReadHex(SL, SC)
        else
          ReadNumber(SL, SC);
      end;
      'a'..'z', 'A'..'Z', '_': ReadIdentifier(SL, SC);
    else
      if Ord(Ch) > 127 then
        ReadIdentifier(SL, SC)
      else
        Error(Format('Unexpected character: %s', [QuotedStr(Ch)]));
    end;
  end;

  ConcatStringEscapes;
  AddToken(tokEOF, '', FLine, FColumn);
end;

function TSardLexer.GetTokens: TSardTokenArray;
begin
  Result := FTokens;
end;

function TSardLexer.GetTokenCount: Integer;
begin
  Result := FTokenCount;
end;

initialization
  GFormatSettings := DefaultFormatSettings;
  GFormatSettings.DecimalSeparator := '.';

end.
