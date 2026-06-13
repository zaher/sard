unit SardTypes;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Classes, Contnrs;

type
  ESardError = class(Exception);

  { Token kinds }
  TTokenKind = (
    tkEOF,
    tkInteger, tkNumber, tkHex, tkString, tkColor, tkCurrency,
    tkIdentifier,
    tkColon, tkSemicolon, tkComma, tkDot,
    tkAssign, tkTypeCheck,
    tkLessGreater, tkBangEqual, tkLess, tkGreater, tkLessEqual, tkGreaterEqual,
    tkPlus, tkMinus, tkStar, tkSlash, tkCaret, tkPercent,
    tkMod, tkAmp, tkBar, tkAnd, tkOr, tkNot,
    tkBang, tkTilde, tkTildeTilde, tkAt,
    tkIncrement, tkDecrement, tkPlusEqual, tkMinusEqual,
    tkLParen, tkRParen, tkLBrace, tkRBrace, tkLBracket, tkRBracket,
    tkNewLine
  );

  { AST node kinds }
  TNodeKind = (
    nkLiteral, nkIdentifier,
    nkBinary, nkUnary, nkPrefixIncDec, nkPostfixIncDec,
    nkBlock, nkArray,
    nkAssign, nkDeclare, nkReturn,
    nkMemberAccess, nkIndexAccess, nkCall,
    nkObjectNew, nkObjectCopy, nkReference,
    nkStatements
  );

  { Runtime value kinds }
  TValueKind = (
    vkNull, vkInteger, vkNumber, vkString, vkBoolean,
    vkColor, vkCurrency, vkArray, vkObject, vkLazy
  );

  TASTNode = class;

  { AST Node }
  TASTNode = class
  public
    Kind: TNodeKind;
    TokenText: string;
    TokenLine, TokenCol: Integer;
    StrValue: string;
    IntValue: Int64;
    FloatValue: Double;
    ColorValue: LongWord;
    CurrencyValue: Int64;
    BoolValue: Boolean;
    Name: string;
    Op: string;
    Children: array of TASTNode;
    Left, Right: TASTNode;
    Typ: string;
    Params: array of string;
    ParamTypes: array of string;
    ReturnType: string;
    HasParamList: Boolean;
    constructor Create(AKind: TNodeKind; const AText: string; ALine, ACol: Integer);
    destructor Destroy; override;
    procedure AddChild(Child: TASTNode);
    function IsLValue: Boolean;
    function DeepClone: TASTNode;
  end;

  TSardValue = class;

  { Runtime Value Object }
  TSardValue = class
  public
    RefCount: Integer;
    Kind: TValueKind;
    IntValue: Int64;
    FloatValue: Double;
    StrValue: string;
    BoolValue: Boolean;
    ColorValue: LongWord;
    CurrencyValue: Int64;
    ArrayItems: TList;      // TSardValue pointers
    Members: TStringList;   // name -> TSardValue
    Parent: TSardValue;
    Callable: Boolean;
    Params: TStringList;
    ParamTypes: TStringList;
    ReturnType: string;
    Body: TASTNode;
    DeclaredType: string;
    BuiltinName: string;
    IsScope: Boolean;
    LazyNode: TASTNode; { for vkLazy values: condition expression to re-evaluate }
    constructor Create;
    destructor Destroy; override;
    procedure AddRef;
    procedure Release;
    procedure SetParent(P: TSardValue);
    function Clone(Deep: Boolean = True): TSardValue;
    procedure SetMember(const Name: string; Value: TSardValue);
    function GetMember(const Name: string): TSardValue;
    function HasLocalMember(const Name: string): Boolean;
    function KindName: string;
    function AsString: string;
  end;

  { Token record }
  TToken = record
    Kind: TTokenKind;
    Text: string;
    Line, Col: Integer;
  end;

function LowerName(const S: string): string;
function TryHexToLongWord(const S: string; out Value: LongWord): Boolean;
function IsSpaceChar(C: Char): Boolean;
function KindToString(K: TTokenKind): string;
procedure DumpAST(Node: TASTNode; Indent: Integer);

implementation

function LowerName(const S: string): string;
begin
  Result := LowerCase(S);
end;

function TryHexToLongWord(const S: string; out Value: LongWord): Boolean;
var
  Code: Integer;
begin
  Val('$' + S, Value, Code);
  Result := Code = 0;
end;

function IsSpaceChar(C: Char): Boolean;
begin
  Result := (C = ' ') or (C = #9) or (C = #13);
end;

function KindToString(K: TTokenKind): string;
begin
  Str(K, Result);
end;

{ TASTNode }

constructor TASTNode.Create(AKind: TNodeKind; const AText: string; ALine, ACol: Integer);
begin
  inherited Create;
  Kind := AKind;
  TokenText := AText;
  TokenLine := ALine;
  TokenCol := ACol;
  StrValue := '';
  IntValue := 0;
  FloatValue := 0;
  ColorValue := 0;
  CurrencyValue := 0;
  BoolValue := False;
  Name := '';
  Op := '';
  Typ := '';
  ReturnType := '';
end;

destructor TASTNode.Destroy;
var
  I: Integer;
begin
  for I := 0 to High(Children) do
    Children[I].Free;
  Left.Free;
  Right.Free;
  inherited;
end;

procedure TASTNode.AddChild(Child: TASTNode);
var
  N: Integer;
begin
  N := Length(Children);
  SetLength(Children, N + 1);
  Children[N] := Child;
end;

function TASTNode.IsLValue: Boolean;
begin
  Result := (Kind = nkIdentifier) or (Kind = nkMemberAccess) or (Kind = nkIndexAccess);
end;

function TASTNode.DeepClone: TASTNode;
var
  I: Integer;
begin
  Result := TASTNode.Create(Kind, TokenText, TokenLine, TokenCol);
  Result.StrValue := StrValue;
  Result.IntValue := IntValue;
  Result.FloatValue := FloatValue;
  Result.ColorValue := ColorValue;
  Result.CurrencyValue := CurrencyValue;
  Result.BoolValue := BoolValue;
  Result.Name := Name;
  Result.Op := Op;
  Result.Typ := Typ;
  Result.ReturnType := ReturnType;
  SetLength(Result.Params, Length(Params));
  for I := 0 to High(Params) do
    Result.Params[I] := Params[I];
  SetLength(Result.ParamTypes, Length(ParamTypes));
  for I := 0 to High(ParamTypes) do
    Result.ParamTypes[I] := ParamTypes[I];
  if Left <> nil then Result.Left := Left.DeepClone;
  if Right <> nil then Result.Right := Right.DeepClone;
  SetLength(Result.Children, Length(Children));
  for I := 0 to High(Children) do
    Result.Children[I] := Children[I].DeepClone;
end;

procedure DumpAST(Node: TASTNode; Indent: Integer);
var
  I: Integer;
  Prefix: string;
  Info: string;
  K: string;
begin
  if Node = nil then Exit;
  Prefix := StringOfChar(' ', Indent * 2);
  case Node.Kind of
    nkStatements: K := 'Statements';
    nkBlock: K := 'Block';
    nkLiteral: K := 'Literal';
    nkIdentifier: K := 'Identifier';
    nkBinary: K := 'Binary';
    nkUnary: K := 'Unary';
    nkPrefixIncDec: K := 'PrefixIncDec';
    nkPostfixIncDec: K := 'PostfixIncDec';
    nkMemberAccess: K := 'MemberAccess';
    nkIndexAccess: K := 'IndexAccess';
    nkCall: K := 'Call';
    nkAssign: K := 'Assign';
    nkDeclare: K := 'Declare';
    nkReturn: K := 'Return';
    nkArray: K := 'Array';
    nkObjectNew: K := 'ObjectNew';
    nkObjectCopy: K := 'ObjectCopy';
    nkReference: K := 'Reference';
  else
    K := 'Unknown';
  end;
  Info := K;
  if Node.Name <> '' then Info := Info + ' name=' + Node.Name;
  if Node.Op <> '' then Info := Info + ' op=' + Node.Op;
  if Node.Typ <> '' then Info := Info + ' type=' + Node.Typ;
  if Node.ReturnType <> '' then Info := Info + ' ret=' + Node.ReturnType;
  if Length(Node.Params) > 0 then Info := Info + ' params=' + IntToStr(Length(Node.Params));
  WriteLn(Prefix, Info);
  if Node.Left <> nil then
  begin
    WriteLn(Prefix, '  Left:');
    DumpAST(Node.Left, Indent + 2);
  end;
  if Node.Right <> nil then
  begin
    WriteLn(Prefix, '  Right:');
    DumpAST(Node.Right, Indent + 2);
  end;
  for I := 0 to High(Node.Children) do
    DumpAST(Node.Children[I], Indent + 1);
end;

{ TSardValue }

constructor TSardValue.Create;
begin
  inherited;
  RefCount := 1;
  Kind := vkNull;
  ArrayItems := TList.Create;
    Members := TStringList.Create;
    Members.CaseSensitive := False;
  Params := TStringList.Create;
  ParamTypes := TStringList.Create;
  Parent := nil;
  Callable := False;
  Body := nil;
  DeclaredType := '';
  IsScope := False;
  LazyNode := nil;
end;

procedure TSardValue.AddRef;
begin
  Inc(RefCount);
end;

procedure TSardValue.Release;
begin
  Dec(RefCount);
  if RefCount <= 0 then
    Free;
end;

procedure TSardValue.SetParent(P: TSardValue);
begin
  Parent := P;
end;

destructor TSardValue.Destroy;
var
  I: Integer;
  V: TSardValue;
begin
  for I := 0 to Members.Count - 1 do
  begin
    V := TSardValue(Members.Objects[I]);
    if V <> nil then V.Release;
  end;
  Members.Free;
  for I := 0 to ArrayItems.Count - 1 do
  begin
    V := TSardValue(ArrayItems[I]);
    if V <> nil then V.Release;
  end;
  ArrayItems.Free;
  Params.Free;
  ParamTypes.Free;
  Body.Free;
  inherited;
end;

function TSardValue.Clone(Deep: Boolean): TSardValue;
var
  I: Integer;
  V: TSardValue;
begin
  Result := TSardValue.Create;
  Result.Kind := Kind;
  Result.IntValue := IntValue;
  Result.FloatValue := FloatValue;
  Result.StrValue := StrValue;
  Result.BoolValue := BoolValue;
  Result.ColorValue := ColorValue;
  Result.CurrencyValue := CurrencyValue;
  Result.Callable := Callable;
  Result.Params.Text := Params.Text;
  Result.ParamTypes.Text := ParamTypes.Text;
    Result.ReturnType := ReturnType;
    Result.DeclaredType := DeclaredType;
    Result.BuiltinName := BuiltinName;
    Result.IsScope := IsScope;
    Result.Parent := nil;
  if Body <> nil then
    Result.Body := Body.DeepClone;
  if Deep then
  begin
    for I := 0 to ArrayItems.Count - 1 do
    begin
      V := TSardValue(ArrayItems[I]);
      if V <> nil then
        Result.ArrayItems.Add(V.Clone(True));
    end;
    for I := 0 to Members.Count - 1 do
    begin
      V := TSardValue(Members.Objects[I]);
      if V <> nil then
        Result.Members.AddObject(Members[I], V.Clone(True));
    end;
  end
  else
  begin
    for I := 0 to ArrayItems.Count - 1 do
    begin
      V := TSardValue(ArrayItems[I]);
      if V <> nil then V.AddRef;
      Result.ArrayItems.Add(V);
    end;
    for I := 0 to Members.Count - 1 do
    begin
      V := TSardValue(Members.Objects[I]);
      if V <> nil then V.AddRef;
      Result.Members.AddObject(Members[I], V);
    end;
  end;
end;

procedure TSardValue.SetMember(const Name: string; Value: TSardValue);
var
  Idx: Integer;
  Old: TSardValue;
begin
  Idx := Members.IndexOf(LowerName(Name));
  if Idx >= 0 then
  begin
    Old := TSardValue(Members.Objects[Idx]);
    if Old <> nil then Old.Release;
    Members.Objects[Idx] := Value;
  end
  else
    Members.AddObject(LowerName(Name), Value);
  if Value <> nil then Value.AddRef;
end;

function TSardValue.GetMember(const Name: string): TSardValue;
var
  Idx: Integer;
  Curr: TSardValue;
begin
  Curr := Self;
  while Curr <> nil do
  begin
    Idx := Curr.Members.IndexOf(LowerName(Name));
    if Idx >= 0 then
    begin
      Result := TSardValue(Curr.Members.Objects[Idx]);
      Exit;
    end;
    Curr := Curr.Parent;
  end;
  Result := nil;
end;

function TSardValue.HasLocalMember(const Name: string): Boolean;
begin
  Result := Members.IndexOf(LowerName(Name)) >= 0;
end;

function TSardValue.KindName: string;
begin
  case Kind of
    vkNull: Result := 'null';
    vkInteger: Result := 'integer';
    vkNumber: Result := 'number';
    vkString: Result := 'string';
    vkBoolean: Result := 'boolean';
    vkColor: Result := 'color';
    vkCurrency: Result := 'currency';
    vkArray: Result := 'array';
    vkObject: Result := 'object';
    vkLazy: Result := 'lazy';
  else
    Result := 'unknown';
  end;
end;

function TSardValue.AsString: string;
var
  I: Integer;
  S: string;
  V: TSardValue;
begin
  case Kind of
    vkNull: Result := 'null';
    vkInteger: Result := IntToStr(IntValue);
    vkNumber:
      begin
        if Frac(FloatValue) = 0 then
          Result := FormatFloat('0', FloatValue)
        else
          Result := FloatToStrF(FloatValue, ffGeneral, 15, 0);
      end;
    vkString: Result := StrValue;
    vkBoolean: Result := BoolToStr(BoolValue, 'true', 'false');
    vkColor: Result := '#' + IntToHex(ColorValue, 6);
    vkCurrency: Result := FormatFloat('0.000000', CurrencyValue / 1000000);
    vkArray:
      begin
        S := '[';
        for I := 0 to ArrayItems.Count - 1 do
        begin
          if I > 0 then S := S + ', ';
          V := TSardValue(ArrayItems[I]);
          if V <> nil then S := S + V.AsString;
        end;
        S := S + ']';
        Result := S;
      end;
    vkObject:
      begin
        if Callable then
          Result := '<callable>'
        else
          Result := '<object>';
      end;
  else
    Result := '?';
  end;
end;

end.
