unit SardParser;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, SardTypes, SardLexer;

type
  TParser = class
  private
    FLexer: TLexer;
    FCurrent: TToken;
    FLookahead: TToken;
    FHasLookahead: Boolean;
    procedure Advance;
    function Peek: TToken;
    function Match(Kind: TTokenKind): Boolean;
    function Expect(Kind: TTokenKind): string;
    procedure ConsumeIf(Kind: TTokenKind);
    function ParseStatement: TASTNode;
    function ParseStatementTerm: Boolean;
    function ParseReturn: TASTNode;
    function ParseBlock: TASTNode;
    function ParseExpression(StartNode: TASTNode = nil): TASTNode;
    function ParseLogicalOr(StartNode: TASTNode = nil): TASTNode;
    function ParseLogicalAnd(StartNode: TASTNode = nil): TASTNode;
    function ParseComparison(StartNode: TASTNode = nil): TASTNode;
    function ParseTypeComparison(StartNode: TASTNode = nil): TASTNode;
    function ParseAdditive(StartNode: TASTNode = nil): TASTNode;
    function ParseMultiplicative(StartNode: TASTNode = nil): TASTNode;
    function ParsePower(StartNode: TASTNode = nil): TASTNode;
    function ParseUnary(StartNode: TASTNode = nil): TASTNode;
    function ParsePrefixIncDec: TASTNode;
    function ParsePostfix(StartNode: TASTNode = nil): TASTNode;
    function ParsePrimary: TASTNode;
    function ParseLValue: TASTNode;
    function ParseArgumentList: TASTNode;
    function ParseArrayLiteral: TASTNode;
    procedure ParseTypedParameterList(out Names, Types: TStringArray; out Defaults: TASTNodeArray; out OpenIndex: Integer; out RetType: string);
    function ParsePostfixChain(StartNode: TASTNode): TASTNode;
    function MakeError(const Msg: string): ESardError;
    function NewNode(AKind: TNodeKind): TASTNode;
    function NewLiteralInt(V: Int64): TASTNode;
    function NewLiteralNum(V: Double): TASTNode;
    function NewLiteralStr(const V: string): TASTNode;
    function NewIdent(const V: string): TASTNode;
    function CloneLValue(Node: TASTNode): TASTNode;
    function IsTypeName(const Name: string): Boolean;
  public
    constructor Create(Lexer: TLexer);
    function ParseProgram: TASTNode;
  end;

implementation

constructor TParser.Create(Lexer: TLexer);
begin
  inherited Create;
  FLexer := Lexer;
  FHasLookahead := False;
  Advance;
end;

procedure TParser.Advance;
begin
  if FHasLookahead then
  begin
    FCurrent := FLookahead;
    FHasLookahead := False;
  end
  else
  begin
    FCurrent.Kind := FLexer.NextToken;
    FCurrent.Text := FLexer.CurrentText;
    FCurrent.Line := FLexer.CurrentLine;
    FCurrent.Col := FLexer.CurrentCol;
  end;
end;

function TParser.Peek: TToken;
begin
  if not FHasLookahead then
  begin
    FLookahead.Kind := FLexer.NextToken;
    FLookahead.Text := FLexer.CurrentText;
    FLookahead.Line := FLexer.CurrentLine;
    FLookahead.Col := FLexer.CurrentCol;
    FHasLookahead := True;
  end;
  Result := FLookahead;
end;

function TParser.Match(Kind: TTokenKind): Boolean;
begin
  Result := FCurrent.Kind = Kind;
  if Result then Advance;
end;

function TParser.Expect(Kind: TTokenKind): string;
begin
  if FCurrent.Kind <> Kind then
    raise MakeError(Format('Expected %s but got %s', [KindToString(Kind), KindToString(FCurrent.Kind)]));
  Result := FCurrent.Text;
  Advance;
end;

procedure TParser.ConsumeIf(Kind: TTokenKind);
begin
  if FCurrent.Kind = Kind then Advance;
end;

function TParser.MakeError(const Msg: string): ESardError;
begin
  Result := ESardError.CreateFmt('Parse error at line %d col %d: %s', [FCurrent.Line, FCurrent.Col, Msg]);
end;

function TParser.NewNode(AKind: TNodeKind): TASTNode;
begin
  Result := TASTNode.Create(AKind, FCurrent.Text, FCurrent.Line, FCurrent.Col);
end;

function TParser.NewLiteralInt(V: Int64): TASTNode;
begin
  Result := NewNode(nkLiteral);
  Result.IntValue := V;
end;

function TParser.NewLiteralNum(V: Double): TASTNode;
begin
  Result := NewNode(nkLiteral);
  Result.FloatValue := V;
end;

function TParser.NewLiteralStr(const V: string): TASTNode;
begin
  Result := NewNode(nkLiteral);
  Result.StrValue := V;
end;

function TParser.NewIdent(const V: string): TASTNode;
begin
  Result := NewNode(nkIdentifier);
  Result.Name := V;
end;

function TParser.CloneLValue(Node: TASTNode): TASTNode;
begin
  if Node = nil then Exit(nil);
  Result := TASTNode.Create(Node.Kind, Node.TokenText, Node.TokenLine, Node.TokenCol);
  Result.Name := Node.Name;
  Result.Op := Node.Op;
  Result.Typ := Node.Typ;
  if Node.Left <> nil then Result.Left := CloneLValue(Node.Left);
  if Node.Right <> nil then Result.Right := CloneLValue(Node.Right);
end;

function TParser.IsTypeName(const Name: string): Boolean;
var
  N: string;
begin
  N := LowerName(Name);
  Result := (N = 'integer') or (N = 'number') or (N = 'string') or (N = 'boolean') or
            (N = 'color') or (N = 'currency') or (N = 'array') or (N = 'object');
end;

function TParser.ParseProgram: TASTNode;
var
  Stmt: TASTNode;
begin
  Result := NewNode(nkStatements);
  while FCurrent.Kind <> tkEOF do
  begin
    Stmt := ParseStatement();
    if Stmt <> nil then
      Result.AddChild(Stmt);
  end;
end;

function TParser.ParseStatementTerm: Boolean;
begin
  if (FCurrent.Kind = tkSemicolon) or (FCurrent.Kind = tkNewLine) or (FCurrent.Kind = tkRBrace) or (FCurrent.Kind = tkEOF) then
  begin
    if FCurrent.Kind = tkSemicolon then
      Advance
    else if FCurrent.Kind = tkNewLine then
      Advance;
    Result := True;
  end
  else
    Result := False;
end;

function TParser.ParseStatement: TASTNode;
var
  LVal, Expr, Node, Bin, BlockNode: TASTNode;
  Name, TypeName: string;
  Saved: TToken;
  ParamNames, ParamTypes: TStringArray;
  ParamDefaults: TASTNodeArray;
  OpenIndex: Integer;
  RetType: string;
  HasType, HasParams: Boolean;
  IsLVal: Boolean;
  Count: Integer;
begin
  Result := nil;

  { Empty statement }
  if FCurrent.Kind = tkSemicolon then begin Advance; Exit(nil); end;
  if FCurrent.Kind = tkNewLine then begin Advance; Exit(nil); end;
  if FCurrent.Kind = tkRBrace then Exit(nil);
  if FCurrent.Kind = tkEOF then Exit(nil);

  { Block statement }
  if FCurrent.Kind = tkLBrace then
  begin
    Result := ParseBlock();
    ParseStatementTerm;
    Exit;
  end;

  { Return statement: bare '=' at statement level }
  if FCurrent.Kind = tkAssign then
  begin
    Result := ParseReturn();
    if not ParseStatementTerm then
      raise MakeError('Expected statement terminator after return');
    Exit;
  end;

  { Anything else: try to parse as declaration, assignment, or expression }
  if FCurrent.Kind <> tkIdentifier then
  begin
    Expr := ParseExpression();
    Result := Expr;
    if not ParseStatementTerm then
      raise MakeError('Expected statement terminator after expression');
    Exit;
  end;

  Saved := FCurrent;
  Name := FCurrent.Text;
  Advance;

  { Type cast at statement level: type-name ( expression ) }
  if (FCurrent.Kind = tkLParen) and IsTypeName(Name) then
  begin
    Node := NewNode(nkTypeCast);
    Node.Name := Name;
    Expect(tkLParen);
    Node.Left := ParseExpression();
    Expect(tkRParen);
    Result := ParseExpression(Node);
    if not ParseStatementTerm then
      raise MakeError('Expected statement terminator after type cast');
    Exit;
  end;

  { Declaration: name : ... }
  if FCurrent.Kind = tkColon then
  begin
    Advance;
    SetLength(ParamNames, 0);
    SetLength(ParamTypes, 0);
    RetType := '';

    { Callable declaration with no type/params: name : { ... } }
    if FCurrent.Kind = tkLBrace then
    begin
      BlockNode := ParseBlock();
      Result := NewNode(nkDeclare);
      Result.Name := Name;
      Result.HasParamList := False;
      Result.AddChild(BlockNode);
      ParseStatementTerm;
      Exit;
    end;

    { Callable with params: name : (params) ... }
    if FCurrent.Kind = tkLParen then
    begin
      ParseTypedParameterList(ParamNames, ParamTypes, ParamDefaults, OpenIndex, RetType);
      Result := NewNode(nkDeclare);
      Result.Name := Name;
      Result.HasParamList := True;
      Result.ReturnType := RetType;
      Result.Params := ParamNames;
      Result.ParamTypes := ParamTypes;
      Result.ParamDefaults := ParamDefaults;
      Result.OpenParamIndex := OpenIndex;
      SetLength(Result.ParamOpen, Length(ParamNames));
      if OpenIndex >= 0 then
        Result.ParamOpen[OpenIndex] := True;
      if FCurrent.Kind = tkLBrace then
        Result.AddChild(ParseBlock);
      ParseStatementTerm;
      Exit;
    end;

    { At this point must be a type identifier }
    if FCurrent.Kind <> tkIdentifier then
      raise MakeError('Expected type or parameter list after :');
    TypeName := FCurrent.Text;
    Advance;

    { Callable with return type and (optional) params: name : type { } or name : type (params) { } }
    if (FCurrent.Kind = tkLBrace) or (FCurrent.Kind = tkLParen) then
    begin
      RetType := TypeName;
      if FCurrent.Kind = tkLParen then
      begin
        ParseTypedParameterList(ParamNames, ParamTypes, ParamDefaults, OpenIndex, RetType);
        { param list consumed; RetType stays as TypeName because ParseTypedParameterList does not modify it when already set? It is out param so it will be cleared. Restore below. }
        RetType := TypeName;
      end;
      Result := NewNode(nkDeclare);
      Result.Name := Name;
      Result.HasParamList := True;
      Result.ReturnType := RetType;
      Result.Params := ParamNames;
      Result.ParamTypes := ParamTypes;
      Result.ParamDefaults := ParamDefaults;
      Result.OpenParamIndex := OpenIndex;
      SetLength(Result.ParamOpen, Length(ParamNames));
      if OpenIndex >= 0 then
        Result.ParamOpen[OpenIndex] := True;
      if FCurrent.Kind = tkLBrace then
        Result.AddChild(ParseBlock);
      ParseStatementTerm;
      Exit;
    end;

    { Variable declaration: name : type (= expr)? }
    Result := NewNode(nkDeclare);
    Result.Name := Name;
    Result.HasParamList := False;
    Result.Typ := TypeName;
    if FCurrent.Kind = tkAssign then
    begin
      Advance;
      Result.AddChild(ParseExpression);
    end;
    if not ParseStatementTerm then
      raise MakeError('Expected statement terminator after declaration');
    Exit;
  end;

  { Build lvalue from identifier, then check for . chain }
  LVal := NewIdent(Name);
  while FCurrent.Kind = tkDot do
  begin
    Advance;
    if FCurrent.Kind <> tkIdentifier then
      raise MakeError('Expected identifier after .');
    Node := NewNode(nkMemberAccess);
    Node.Left := LVal;
    Node.Right := NewIdent(FCurrent.Text);
    LVal := Node;
    Advance;
  end;

  { Index access can be part of lvalue }
  while FCurrent.Kind = tkLBracket do
  begin
    Advance;
    Node := NewNode(nkIndexAccess);
    Node.Left := LVal;
    Node.Right := ParseExpression();
    LVal := Node;
    Expect(tkRBracket);
  end;

  IsLVal := LVal.IsLValue;

  { Bare builtin call: break (and similar zero-arg builtins) }
  if (LVal.Kind = nkIdentifier) and (LowerName(LVal.Name) = 'break') and
     ((FCurrent.Kind = tkSemicolon) or (FCurrent.Kind = tkNewLine) or
      (FCurrent.Kind = tkRBrace) or (FCurrent.Kind = tkEOF)) then
  begin
    Result := NewNode(nkCall);
    Result.Left := LVal;
    if not ParseStatementTerm then
      raise MakeError('Expected statement terminator after break');
    Exit;
  end;

  { Assignment }
  if FCurrent.Kind = tkAssign then
  begin
    if not IsLVal then
      raise MakeError('Invalid assignment target');
    Advance;
    Expr := ParseExpression();
    Result := NewNode(nkAssign);
    Result.Left := LVal;
    Result.Right := Expr;
    if not ParseStatementTerm then
      raise MakeError('Expected statement terminator after assignment');
    Exit;
  end;

  { Compound assignment += }
  if FCurrent.Kind = tkPlusEqual then
  begin
    if not IsLVal then
      raise MakeError('Invalid compound assignment target');
    Advance;
    Expr := ParseExpression();
    Result := NewNode(nkAssign);
    Result.Left := CloneLValue(LVal);
    Bin := NewNode(nkBinary);
    Bin.Op := '+';
    Bin.Left := LVal;
    Bin.Right := Expr;
    Result.Right := Bin;
    if not ParseStatementTerm then
      raise MakeError('Expected statement terminator after compound assignment');
    Exit;
  end;

  { Compound assignment -= }
  if FCurrent.Kind = tkMinusEqual then
  begin
    if not IsLVal then
      raise MakeError('Invalid compound assignment target');
    Advance;
    Expr := ParseExpression();
    Result := NewNode(nkAssign);
    Result.Left := CloneLValue(LVal);
    Bin := NewNode(nkBinary);
    Bin.Op := '-';
    Bin.Left := LVal;
    Bin.Right := Expr;
    Result.Right := Bin;
    if not ParseStatementTerm then
      raise MakeError('Expected statement terminator after compound assignment');
    Exit;
  end;

  { Expression statement: continue parsing full expression from LVal }
  Expr := ParseExpression(LVal);
  Result := Expr;
  if not ParseStatementTerm then
    raise MakeError('Expected statement terminator after expression');
end;

function TParser.ParseReturn: TASTNode;
begin
  Result := NewNode(nkReturn);
  Advance; { '=' }
  if (FCurrent.Kind <> tkSemicolon) and (FCurrent.Kind <> tkNewLine) and
     (FCurrent.Kind <> tkRBrace) and (FCurrent.Kind <> tkEOF) then
    Result.AddChild(ParseExpression);
end;

function TParser.ParseBlock: TASTNode;
var
  Stmt: TASTNode;
begin
  Result := NewNode(nkBlock);
  Expect(tkLBrace);
  while (FCurrent.Kind <> tkRBrace) and (FCurrent.Kind <> tkEOF) do
  begin
    Stmt := ParseStatement();
    if Stmt <> nil then
      Result.AddChild(Stmt);
  end;
  Expect(tkRBrace);
end;

function TParser.ParseArgumentList: TASTNode;
begin
  Result := NewNode(nkStatements);
  Result.Name := 'args';
  Expect(tkLParen);
  while FCurrent.Kind <> tkRParen do
  begin
    if FCurrent.Kind = tkComma then
      Result.AddChild(nil)
    else
      Result.AddChild(ParseExpression);
    if FCurrent.Kind = tkComma then
      Advance
    else
      Break;
  end;
  Expect(tkRParen);
end;

function TParser.ParseArrayLiteral: TASTNode;
var
  Node: TASTNode;
begin
  Result := NewNode(nkArray);
  Expect(tkLBracket);
  while FCurrent.Kind = tkNewLine do Advance;
  if FCurrent.Kind <> tkRBracket then
  begin
    Result.AddChild(ParseExpression);
    while (FCurrent.Kind = tkComma) or (FCurrent.Kind = tkNewLine) do
    begin
      Advance;
      while FCurrent.Kind = tkNewLine do Advance;
      if FCurrent.Kind = tkRBracket then Break;
      Result.AddChild(ParseExpression);
    end;
  end;
  Expect(tkRBracket);
  { Array multiplication: [expr] * n }
  if FCurrent.Kind = tkStar then
  begin
    Advance;
    if FCurrent.Kind <> tkInteger then
      raise MakeError('Expected integer after * for array multiplication');
    Node := NewLiteralInt(StrToInt64(FCurrent.Text));
    Node.Name := 'repeat';
    Result.AddChild(Node);
    Advance;
  end;
end;

procedure TParser.ParseTypedParameterList(out Names, Types: TStringArray; out Defaults: TASTNodeArray; out OpenIndex: Integer; out RetType: string);
var
  N, T: string;
  D: TASTNode;

  procedure AddParam(const AName, AType: string; ADefault: TASTNode; IsOpen: Boolean);
  var
    L: Integer;
  begin
    L := Length(Names);
    SetLength(Names, L + 1);
    SetLength(Types, L + 1);
    SetLength(Defaults, L + 1);
    Names[L] := AName;
    Types[L] := AType;
    Defaults[L] := ADefault;
    if IsOpen then
      OpenIndex := L;
  end;

  function ParseOneParam: Boolean;
  var
    IsOpen: Boolean;
  begin
    Result := False;
    N := Expect(tkIdentifier);
    IsOpen := False;
    if FCurrent.Kind = tkEllipsis then
    begin
      Advance;
      IsOpen := True;
      T := '';
      D := nil;
    end
    else
    begin
      T := '';
      D := nil;
      if FCurrent.Kind = tkColon then
      begin
        Advance;
        T := Expect(tkIdentifier);
      end;
      if FCurrent.Kind = tkAssign then
      begin
        Advance;
        D := ParseExpression;
      end;
    end;
    AddParam(N, T, D, IsOpen);
    Result := IsOpen;
  end;

begin
  RetType := '';
  OpenIndex := -1;
  SetLength(Names, 0);
  SetLength(Types, 0);
  SetLength(Defaults, 0);
  Expect(tkLParen);
  if FCurrent.Kind <> tkRParen then
  begin
    if ParseOneParam then
    begin
      if FCurrent.Kind = tkComma then
        raise MakeError('Open parameter must be the last parameter');
    end
    else
    begin
      while FCurrent.Kind = tkComma do
      begin
        Advance;
        if ParseOneParam then
        begin
          if FCurrent.Kind = tkComma then
            raise MakeError('Open parameter must be the last parameter');
          Break;
        end;
      end;
    end;
  end;
  Expect(tkRParen);
end;

function TParser.ParseExpression(StartNode: TASTNode): TASTNode;
begin
  Result := ParseLogicalOr(StartNode);
end;

function TParser.ParseLogicalOr(StartNode: TASTNode): TASTNode;
var
  Left, Node: TASTNode;
  Op: string;
begin
  Left := ParseLogicalAnd(StartNode);
  while (FCurrent.Kind = tkBar) or (FCurrent.Kind = tkOr) do
  begin
    Op := FCurrent.Text;
    Advance;
    Node := NewNode(nkBinary);
    Node.Op := Op;
    Node.Left := Left;
    Node.Right := ParseLogicalAnd();
    Left := Node;
  end;
  Result := Left;
end;

function TParser.ParseLogicalAnd(StartNode: TASTNode): TASTNode;
var
  Left, Node: TASTNode;
  Op: string;
begin
  Left := ParseComparison(StartNode);
  while (FCurrent.Kind = tkAmp) or (FCurrent.Kind = tkAnd) do
  begin
    Op := FCurrent.Text;
    Advance;
    Node := NewNode(nkBinary);
    Node.Op := Op;
    Node.Left := Left;
    Node.Right := ParseComparison();
    Left := Node;
  end;
  Result := Left;
end;

function TParser.ParseComparison(StartNode: TASTNode): TASTNode;
var
  Left, Node, Root, Curr: TASTNode;
  Ops: array of string;
  Rights: array of TASTNode;
  I, N: Integer;
  IsChain: Boolean;

  procedure AddOp(const Op: string);
  begin
    N := Length(Ops);
    SetLength(Ops, N + 1);
    Ops[N] := Op;
  end;

  procedure AddRight(R: TASTNode);
  begin
    N := Length(Rights);
    SetLength(Rights, N + 1);
    Rights[N] := R;
  end;

begin
  Left := ParseTypeComparison(StartNode);
  IsChain := False;
  SetLength(Ops, 0);
  SetLength(Rights, 0);

  while FCurrent.Kind in [tkAssign, tkLessGreater, tkBangEqual, tkLess, tkGreater, tkLessEqual, tkGreaterEqual] do
  begin
    IsChain := True;
    AddOp(FCurrent.Text);
    Advance;
    AddRight(ParseTypeComparison);
  end;

  if not IsChain then
  begin
    Result := Left;
    Exit;
  end;

  if Length(Ops) = 1 then
  begin
    Node := NewNode(nkBinary);
    Node.Op := Ops[0];
    Node.Left := Left;
    Node.Right := Rights[0];
    Result := Node;
  end
  else
  begin
    { Build left-leaning tree of ANDs with pairwise comparisons }
    Node := NewNode(nkBinary);
    Node.Op := Ops[0];
    Node.Left := Left;
    Node.Right := Rights[0];
    Root := NewNode(nkBinary);
    Root.Op := 'and';
    Root.Left := Node;
    Curr := Root;
    for I := 1 to High(Ops) do
    begin
      Node := NewNode(nkBinary);
      Node.Op := Ops[I];
      Node.Left := Rights[I-1].DeepClone;
      Node.Right := Rights[I];
      if I = High(Ops) then
        Curr.Right := Node
      else
      begin
        Curr.Right := NewNode(nkBinary);
        Curr.Right.Op := 'and';
        Curr.Right.Left := Node;
        Curr := Curr.Right;
      end;
    end;
    Result := Root;
  end;
end;

function TParser.ParseTypeComparison(StartNode: TASTNode): TASTNode;
var
  Left, Node: TASTNode;
begin
  Left := ParseAdditive(StartNode);
  if FCurrent.Kind = tkTypeCheck then
  begin
    Advance;
    Node := NewNode(nkBinary);
    Node.Op := '==';
    Node.Left := Left;
    Node.Right := ParseAdditive();
    Result := Node;
  end
  else
    Result := Left;
end;

function TParser.ParseAdditive(StartNode: TASTNode): TASTNode;
var
  Left, Node: TASTNode;
  Op: string;
begin
  Left := ParseMultiplicative(StartNode);
  while (FCurrent.Kind = tkPlus) or (FCurrent.Kind = tkMinus) do
  begin
    Op := FCurrent.Text;
    Advance;
    Node := NewNode(nkBinary);
    Node.Op := Op;
    Node.Left := Left;
    Node.Right := ParseMultiplicative();
    Left := Node;
  end;
  Result := Left;
end;

function TParser.ParseMultiplicative(StartNode: TASTNode): TASTNode;
var
  Left, Node: TASTNode;
  Op: string;
begin
  Left := ParsePower(StartNode);
  while (FCurrent.Kind = tkStar) or (FCurrent.Kind = tkSlash) or (FCurrent.Kind = tkMod) do
  begin
    Op := FCurrent.Text;
    Advance;
    Node := NewNode(nkBinary);
    Node.Op := Op;
    Node.Left := Left;
    Node.Right := ParsePower();
    Left := Node;
  end;
  Result := Left;
end;

function TParser.ParsePower(StartNode: TASTNode): TASTNode;
var
  Left, Node: TASTNode;
begin
  Left := ParseUnary(StartNode);
  if FCurrent.Kind = tkCaret then
  begin
    Advance;
    Node := NewNode(nkBinary);
    Node.Op := '^';
    Node.Left := Left;
    Node.Right := ParsePower();
    Result := Node;
  end
  else
    Result := Left;
end;

function TParser.ParseUnary(StartNode: TASTNode): TASTNode;
var
  Node: TASTNode;
  Op: string;
begin
  if StartNode <> nil then
    Result := ParsePostfix(StartNode)
  else if (FCurrent.Kind = tkMinus) or (FCurrent.Kind = tkPlus) or (FCurrent.Kind = tkBang) or (FCurrent.Kind = tkNot) then
  begin
    Op := FCurrent.Text;
    Advance;
    Node := NewNode(nkUnary);
    Node.Op := Op;
    Node.Left := Self.ParseUnary();
    Result := Node;
  end
  else if (FCurrent.Kind = tkIncrement) or (FCurrent.Kind = tkDecrement) then
    Result := ParsePrefixIncDec()
  else
    Result := ParsePostfix();
end;

function TParser.ParsePrefixIncDec: TASTNode;
var
  Node: TASTNode;
  Op: string;
begin
  Op := FCurrent.Text;
  Advance;
  Node := NewNode(nkPrefixIncDec);
  Node.Op := Op;
  Node.Left := ParseLValue();
  Result := Node;
end;

function TParser.ParseLValue: TASTNode;
begin
  Result := ParsePostfix();
  if not Result.IsLValue then
    raise MakeError('Expected lvalue');
end;

function TParser.ParsePostfix(StartNode: TASTNode): TASTNode;
begin
  if StartNode = nil then
    Result := ParsePostfixChain(ParsePrimary())
  else
    Result := ParsePostfixChain(StartNode);
end;

function TParser.ParsePostfixChain(StartNode: TASTNode): TASTNode;
var
  Node, ArgNode, BlockNode: TASTNode;
  Saved: TToken;
  HasArgs: Boolean;
  HasBlock: Boolean;
  HasNamedBlock: Boolean;

  function IsContinuation(CurrNode: TASTNode): Boolean;
  begin
    Result := (FCurrent.Kind = tkLBracket) or (FCurrent.Kind = tkLParen) or
              (FCurrent.Kind = tkLBrace) or (FCurrent.Kind = tkIncrement) or
              (FCurrent.Kind = tkDecrement) or (FCurrent.Kind = tkPercent) or
              (FCurrent.Kind = tkDot);
    if (not Result) and (FCurrent.Kind = tkIdentifier) and (CurrNode.Kind = nkCall) and
       (LowerName(FCurrent.Text) = 'else') then
      Result := True;
  end;

begin
  Result := StartNode;

  while IsContinuation(Result) do
  begin
    case FCurrent.Kind of
      tkLBracket:
        begin
          Advance;
          Node := NewNode(nkIndexAccess);
          Node.Left := Result;
          Node.Right := ParseExpression();
          Expect(tkRBracket);
          Result := Node;
        end;
      tkDot:
        begin
          Advance;
          if FCurrent.Kind <> tkIdentifier then
            raise MakeError('Expected identifier after .');
          Node := NewNode(nkMemberAccess);
          Node.Left := Result;
          Node.Right := NewIdent(FCurrent.Text);
          Result := Node;
          Advance;
        end;
      tkLParen:
        begin
          Node := NewNode(nkCall);
          Node.Left := Result;
          Node.AddChild(ParseArgumentList);
          (* optional anonymous block - allow newline before { }
             This lets control-flow calls like for(a, v)\n{ ... } span lines. *)
          if FCurrent.Kind = tkNewLine then
          begin
            Saved := FCurrent;
            while FCurrent.Kind = tkNewLine do Advance;
            if FCurrent.Kind <> tkLBrace then
            begin
              FLookahead := FCurrent;
              FHasLookahead := True;
              FCurrent := Saved;
            end;
          end;
          if FCurrent.Kind = tkLBrace then
            Node.AddChild(ParseBlock);
          { named blocks - allow newline before else }
          if FCurrent.Kind = tkNewLine then
          begin
            Saved := FCurrent;
            while FCurrent.Kind = tkNewLine do Advance;
            if not ((FCurrent.Kind = tkIdentifier) and (LowerName(FCurrent.Text) = 'else')) then
            begin
              FLookahead := FCurrent;
              FHasLookahead := True;
              FCurrent := Saved;
            end;
          end;
          { named blocks }
          while FCurrent.Kind = tkIdentifier do
          begin
            Saved := FCurrent;
            Advance;
            if FCurrent.Kind = tkLBrace then
            begin
              BlockNode := ParseBlock();
              BlockNode.Name := Saved.Text;
              Node.AddChild(BlockNode);
            end
            else if FCurrent.Kind = tkLParen then
            begin
              ArgNode := ParseArgumentList();
              BlockNode := ParseBlock();
              BlockNode.Name := Saved.Text;
              BlockNode.AddChild(ArgNode);
              Node.AddChild(BlockNode);
            end
            else
              raise MakeError('Expected block or argument list after named block');
          end;
          Result := Node;
        end;
      tkLBrace:
        begin
          Node := NewNode(nkCall);
          Node.Left := Result;
          Node.AddChild(ParseBlock);
          { named blocks - allow newline before else }
          if FCurrent.Kind = tkNewLine then
          begin
            Saved := FCurrent;
            while FCurrent.Kind = tkNewLine do Advance;
            if not ((FCurrent.Kind = tkIdentifier) and (LowerName(FCurrent.Text) = 'else')) then
            begin
              FLookahead := FCurrent;
              FHasLookahead := True;
              FCurrent := Saved;
            end;
          end;
          Result := Node;
        end;
      tkIncrement, tkDecrement:
        begin
          Node := NewNode(nkPostfixIncDec);
          Node.Op := FCurrent.Text;
          Node.Left := Result;
          Result := Node;
          Advance;
        end;
      tkPercent:
        begin
          Node := NewNode(nkPostfixIncDec);
          Node.Op := '%';
          Node.Left := Result;
          Result := Node;
          Advance;
        end;
      tkIdentifier:
        begin
          { named block }
          Saved := FCurrent;
          Advance;
          if FCurrent.Kind = tkLBrace then
          begin
            BlockNode := ParseBlock();
            BlockNode.Name := Saved.Text;
            Node := NewNode(nkCall);
            Node.Left := Result;
            Node.AddChild(BlockNode);
            Result := Node;
          end
          else
            raise MakeError('Expected block after identifier in postfix chain');
        end;
    else
      Break;
    end;
  end;
end;

function TParser.ParsePrimary: TASTNode;
var
  Node: TASTNode;
  Code: Integer;
  S: string;
  DotPos, FracCount, I: Integer;
begin
  case FCurrent.Kind of
    tkInteger:
      begin
        Node := NewNode(nkLiteral);
        Node.IntValue := StrToInt64(FCurrent.Text);
        Result := Node;
        Advance;
      end;
    tkNumber:
      begin
        Node := NewNode(nkLiteral);
        Val(FCurrent.Text, Node.FloatValue, Code);
        Result := Node;
        Advance;
      end;
    tkHex:
      begin
        Node := NewNode(nkLiteral);
        Node.IntValue := StrToInt64('$' + FCurrent.Text);
        Result := Node;
        Advance;
      end;
    tkString:
      begin
        Node := NewNode(nkLiteral);
        Node.StrValue := FCurrent.Text;
        Result := Node;
        Advance;
      end;
    tkColor:
      begin
        Node := NewNode(nkLiteral);
        TryHexToLongWord(FCurrent.Text, Node.ColorValue);
        Result := Node;
        Advance;
      end;
    tkCurrency:
      begin
        Node := NewNode(nkLiteral);
        S := FCurrent.Text;
        { S already normalized to XXXXXX.YYYYYY by lexer }
        DotPos := Pos('.', S);
        if DotPos > 0 then
          S := Copy(S, 1, DotPos - 1) + Copy(S, DotPos + 1, 6);
        Node.CurrencyValue := StrToInt64(S);
        Result := Node;
        Advance;
      end;
    tkIdentifier:
      begin
        if IsTypeName(FCurrent.Text) and (Peek.Kind = tkLParen) then
        begin
          Node := NewNode(nkTypeCast);
          Node.Name := FCurrent.Text;
          Advance;
          Expect(tkLParen);
          Node.Left := ParseExpression();
          Expect(tkRParen);
          Result := Node;
        end
        else
        begin
          Node := NewNode(nkIdentifier);
          Node.Name := FCurrent.Text;
          Result := Node;
          Advance;
        end;
      end;
    tkLParen:
      begin
        Advance;
        Node := ParseExpression();
        Expect(tkRParen);
        Result := Node;
      end;
    tkLBrace:
      Result := ParseBlock();
    tkLBracket:
      Result := ParseArrayLiteral();
    tkTilde:
      begin
        Advance;
        if FCurrent.Kind <> tkIdentifier then
          raise MakeError('Expected identifier after ~');
        Node := NewNode(nkObjectNew);
        Node.Name := FCurrent.Text;
        Result := Node;
        Advance;
      end;
    tkTildeTilde:
      begin
        Advance;
        if FCurrent.Kind <> tkIdentifier then
          raise MakeError('Expected identifier after ~~');
        Node := NewNode(nkObjectCopy);
        Node.Name := FCurrent.Text;
        Result := Node;
        Advance;
      end;
    tkAt:
      begin
        Advance;
        Node := NewNode(nkReference);
        Node.Left := ParseUnary();
        Result := Node;
      end;
  else
    raise MakeError('Unexpected token in expression: ' + KindToString(FCurrent.Kind));
  end;
end;

end.
