unit sard_parser;

{$mode objfpc}{$H+}{$J-}

interface

uses
  SysUtils, sard_lexer, sard_ast, sard_errors;

type
  TSardParser = class
  private
    FTokens: TSardTokenArray;
    FCount: Integer;
    FPos: Integer;
    function Current: TSardToken;
    function Peek(AOffset: Integer = 0): TSardToken;
    function Advance: TSardToken;
    function Expect(AType: TSardTokenType): TSardToken;
    function Match(AType: TSardTokenType): TSardToken;
    function AtEnd: Boolean;
    function ParseProgram: PSardNode;
    function ParseStatement: PSardNode;
    function ParseIdentifierStmt: PSardNode;
    function TryParseDeclaration: PSardNode;
    function ParseType: PSardNode;
    function ParseParamList: PSardNode;
    function TryParseAssignment: PSardNode;
    function ParseLValue: PSardNode;
    function ParseReturnStmt: PSardNode;
    function ParseExpressionStmt: PSardNode;
    function ParseBlockStmt: PSardNode;
    function ParseBlockExpr: PSardNode;
    function ParseExpression: PSardNode;
    function ParseOr: PSardNode;
    function ParseAnd: PSardNode;
    function ParseComparison: PSardNode;
    function ParseTypeCheck: PSardNode;
    function ParseAdditive: PSardNode;
    function ParseMultiplicative: PSardNode;
    function ParsePower: PSardNode;
    function ParseUnary: PSardNode;
    function ParseLValueExpr: PSardNode;
    function ParsePostfix: PSardNode;
    function ParseArgList: PSardNode;
    function ParsePrimary: PSardNode;
    function ParseArrayLiteral: PSardNode;
  public
    constructor Create(const ATokens: TSardTokenArray);
    function Parse: PSardNode;
  end;

implementation

const
  AssignmentOps: TSardTokenSet = [tokEq, tokPlusAssign, tokMinusAssign];
  ComparisonOps: TSardTokenSet = [tokEq, tokNeq, tokNNeq, tokLT, tokGT, tokLTE, tokGTE];
  AdditiveOps: TSardTokenSet = [tokPlus, tokMinus];
  MultiplicativeOps: TSardTokenSet = [tokStar, tokSlash, tokMod];
  UnaryOps: TSardTokenSet = [tokMinus, tokPlus, tokBang, tokNot];

constructor TSardParser.Create(const ATokens: TSardTokenArray);
begin
  inherited Create;
  FTokens := ATokens;
  FCount := Length(ATokens);
  FPos := 0;
end;

function TSardParser.Current: TSardToken;
begin
  if FPos < FCount then
    Result := FTokens[FPos]
  else
    Result := FTokens[FCount - 1];
end;

function TSardParser.Peek(AOffset: Integer): TSardToken;
var
  Idx: Integer;
begin
  Idx := FPos + AOffset;
  if Idx < FCount then
    Result := FTokens[Idx]
  else
    Result := FTokens[FCount - 1];
end;

function TSardParser.Advance: TSardToken;
begin
  Result := Current;
  if FPos < FCount then
    Inc(FPos);
end;

function TSardParser.Expect(AType: TSardTokenType): TSardToken;
begin
  Result := Current;
  if Result.TokenType <> AType then
    raise ESardParseError.Create(
      Format('Expected %s, got %s (%s) at line %d',
        [TokenTypeToString(AType), TokenTypeToString(Result.TokenType),
         Result.Value, Result.Line]),
      Result.Line, Result.Column);
  Inc(FPos);
  Result := FTokens[FPos - 1];
end;

function TSardParser.Match(AType: TSardTokenType): TSardToken;
begin
  if Current.TokenType = AType then
    Result := Advance
  else
    Result := nil;
end;

function TSardParser.AtEnd: Boolean;
begin
  Result := Current.TokenType = tokEOF;
end;

function TSardParser.Parse: PSardNode;
begin
  Result := ParseProgram;
end;

function TSardParser.ParseProgram: PSardNode;
var
  Stmt: PSardNode;
begin
  Result := CreateNode(ntProgram);
  while not AtEnd do
  begin
    Stmt := ParseStatement;
    if Stmt <> nil then
      AddChild(Result, Stmt);
  end;
end;

function TSardParser.ParseStatement: PSardNode;
var
  Tok: TSardToken;
begin
  Tok := Current;
  if Tok.TokenType = tokSemi then
  begin
    Advance;
    Result := CreateNode(ntEmptyStmt, '', Tok.Line, Tok.Column);
    Exit;
  end;
  if Tok.TokenType = tokLBrace then
  begin
    Result := ParseBlockStmt;
    Exit;
  end;
  if Tok.TokenType = tokEq then
  begin
    Result := ParseReturnStmt;
    Exit;
  end;
  if Tok.TokenType = tokIdentifier then
  begin
    Result := ParseIdentifierStmt;
    Exit;
  end;
  Result := ParseExpressionStmt;
end;

function TSardParser.ParseIdentifierStmt: PSardNode;
var
  Saved: Integer;
  DeclResult, AssignResult: PSardNode;
begin
  Saved := FPos;
  if Peek(1).TokenType = tokColon then
  begin
    DeclResult := TryParseDeclaration;
    if DeclResult <> nil then
      Exit(DeclResult);
  end;
  FPos := Saved;
  if Current.TokenType = tokIdentifier then
  begin
    AssignResult := TryParseAssignment;
    if AssignResult <> nil then
      Exit(AssignResult);
  end;
  FPos := Saved;
  Result := ParseExpressionStmt;
end;

function TSardParser.TryParseDeclaration: PSardNode;
var
  NameTok: TSardToken;
  Node: PSardNode;
  HasParams, HasBlock: Boolean;
  TypeNode: PSardNode;
begin
  NameTok := Advance;
  Expect(tokColon);
  Node := CreateNode(ntDeclaration, NameTok.Value, NameTok.Line, NameTok.Column);
  HasParams := False;
  HasBlock := False;

  if Current.TokenType = tokLParen then
  begin
    AddChild(Node, ParseParamList);
    HasParams := True;
  end;

  if Current.TokenType = tokLBrace then
  begin
    AddChild(Node, ParseBlockExpr);
    HasBlock := True;
  end;

  if (not HasParams) and (not HasBlock) then
  begin
    if Current.TokenType = tokIdentifier then
    begin
      TypeNode := ParseType;
      AddChild(Node, TypeNode);
      if Current.TokenType = tokLParen then
      begin
        AddChild(Node, ParseParamList);
        HasParams := True;
      end;
      if Current.TokenType = tokLBrace then
      begin
        AddChild(Node, ParseBlockExpr);
        HasBlock := True;
      end
      else if Current.TokenType = tokEq then
      begin
        Advance;
        AddChild(Node, ParseExpression);
        Match(tokSemi);
      end
      else if not HasParams then
        Match(tokSemi);
    end
    else
      Match(tokSemi);
  end
  else
    Match(tokSemi);

  Result := Node;
end;

function TSardParser.ParseType: PSardNode;
var
  Node: PSardNode;
  IdTok: TSardToken;
begin
  IdTok := Expect(tokIdentifier);
  Node := CreateNode(ntTypeAnnotation, IdTok.Value, IdTok.Line, IdTok.Column);
  while Current.TokenType = tokDot do
  begin
    Advance;
    IdTok := Expect(tokIdentifier);
    AddChild(Node, CreateNode(ntIdentifier, IdTok.Value, IdTok.Line, IdTok.Column));
  end;
  Result := Node;
end;

function TSardParser.ParseParamList: PSardNode;
var
  Node, ParamNode: PSardNode;
  IdTok: TSardToken;
begin
  Expect(tokLParen);
  Node := CreateNode(ntParamList);
  if Current.TokenType <> tokRParen then
  begin
    IdTok := Expect(tokIdentifier);
    ParamNode := CreateNode(ntParameter, IdTok.Value, IdTok.Line, IdTok.Column);
    if Match(tokColon) <> nil then
      AddChild(ParamNode, ParseType);
    AddChild(Node, ParamNode);
    while Match(tokComma) <> nil do
    begin
      IdTok := Expect(tokIdentifier);
      ParamNode := CreateNode(ntParameter, IdTok.Value, IdTok.Line, IdTok.Column);
      if Match(tokColon) <> nil then
        AddChild(ParamNode, ParseType);
      AddChild(Node, ParamNode);
    end;
  end;
  Expect(tokRParen);
  Result := Node;
end;

function TSardParser.TryParseAssignment: PSardNode;
var
  SavedPos: Integer;
  LV, Expr: PSardNode;
  OpTok: TSardToken;
  Node: PSardNode;
begin
  SavedPos := FPos;
  LV := ParseLValue;
  if LV = nil then
  begin
    FPos := SavedPos;
    Result := nil;
    Exit;
  end;
  if Current.TokenType in AssignmentOps then
  begin
    OpTok := Advance;
    Expr := ParseExpression;
    Match(tokSemi);
    if OpTok.TokenType = tokEq then
      Node := CreateNode(ntAssignment, '=', OpTok.Line, OpTok.Column)
    else if OpTok.TokenType = tokPlusAssign then
      Node := CreateNode(ntCompoundAssignment, '+=', OpTok.Line, OpTok.Column)
    else
      Node := CreateNode(ntCompoundAssignment, '-=', OpTok.Line, OpTok.Column);
    AddChild(Node, LV);
    AddChild(Node, Expr);
    Result := Node;
    Exit;
  end;
  FPos := SavedPos;
  Result := nil;
end;

function TSardParser.ParseLValue: PSardNode;
var
  NameTok, MemberTok: TSardToken;
  Node, Access: PSardNode;
  Idx: PSardNode;
begin
  if Current.TokenType <> tokIdentifier then
  begin
    Result := nil;
    Exit;
  end;
  NameTok := Advance;
  Node := CreateNode(ntIdentifier, NameTok.Value, NameTok.Line, NameTok.Column);
  while True do
  begin
    if Current.TokenType = tokDot then
    begin
      Advance;
      MemberTok := Expect(tokIdentifier);
      Access := CreateNode(ntMemberAccess, MemberTok.Value, MemberTok.Line, MemberTok.Column);
      AddChild(Access, Node);
      Node := Access;
    end
    else if Current.TokenType = tokLBracket then
    begin
      Advance;
      Idx := ParseExpression;
      Expect(tokRBracket);
      Access := CreateNode(ntIndexAccess, '', Idx^.Line, Idx^.Column);
      AddChild(Access, Node);
      AddChild(Access, Idx);
      Node := Access;
    end
    else
      Break;
  end;
  Result := Node;
end;

function TSardParser.ParseReturnStmt: PSardNode;
var
  Tok: TSardToken;
  Node: PSardNode;
begin
  Tok := Advance;
  Node := CreateNode(ntReturnStmt, '=', Tok.Line, Tok.Column);
  AddChild(Node, ParseExpression);
  Match(tokSemi);
  Result := Node;
end;

function TSardParser.ParseExpressionStmt: PSardNode;
var
  Expr: PSardNode;
  Node: PSardNode;
begin
  Expr := ParseExpression;
  Match(tokSemi);
  Node := CreateNode(ntExpressionStmt, '', Expr^.Line, Expr^.Column);
  AddChild(Node, Expr);
  Result := Node;
end;

function TSardParser.ParseBlockStmt: PSardNode;
var
  Block, Node: PSardNode;
begin
  Block := ParseBlockExpr;
  Node := CreateNode(ntBlockStmt, '', Block^.Line, Block^.Column);
  AddChild(Node, Block);
  Result := Node;
end;

function TSardParser.ParseBlockExpr: PSardNode;
var
  LBrace: TSardToken;
  Node, Stmt: PSardNode;
begin
  LBrace := Expect(tokLBrace);
  Node := CreateNode(ntBlockExpr, '', LBrace.Line, LBrace.Column);
  while (Current.TokenType <> tokRBrace) and (not AtEnd) do
  begin
    Stmt := ParseStatement;
    if Stmt <> nil then
      AddChild(Node, Stmt);
  end;
  Expect(tokRBrace);
  Result := Node;
end;

function TSardParser.ParseExpression: PSardNode;
begin
  Result := ParseOr;
end;

function TSardParser.ParseOr: PSardNode;
var
  Left, Right: PSardNode;
  OpTok: TSardToken;
  Node: PSardNode;
begin
  Left := ParseAnd;
  while Current.TokenType in [tokBar, tokOr] do
  begin
    OpTok := Advance;
    Right := ParseAnd;
    Node := CreateNode(ntBinaryOp, OpTok.Value, OpTok.Line, OpTok.Column);
    AddChild(Node, Left);
    AddChild(Node, Right);
    Left := Node;
  end;
  Result := Left;
end;

function TSardParser.ParseAnd: PSardNode;
var
  Left, Right: PSardNode;
  OpTok: TSardToken;
  Node: PSardNode;
begin
  Left := ParseComparison;
  while Current.TokenType in [tokAmpersand, tokAnd] do
  begin
    OpTok := Advance;
    Right := ParseComparison;
    Node := CreateNode(ntBinaryOp, OpTok.Value, OpTok.Line, OpTok.Column);
    AddChild(Node, Left);
    AddChild(Node, Right);
    Left := Node;
  end;
  Result := Left;
end;

function TSardParser.ParseComparison: PSardNode;
var
  Left: PSardNode;
  Ops: array of TSardToken;
  Operands: array of PSardNode;
  Node: PSardNode;
  I: Integer;
begin
  Left := ParseTypeCheck;
  SetLength(Ops, 0);
  SetLength(Operands, 0);
  while Current.TokenType in ComparisonOps do
  begin
    SetLength(Ops, Length(Ops) + 1);
    Ops[Length(Ops) - 1] := Advance;
    SetLength(Operands, Length(Operands) + 1);
    Operands[Length(Operands) - 1] := ParseTypeCheck;
  end;
  if Length(Ops) = 0 then
  begin
    Result := Left;
    Exit;
  end;
  if Length(Ops) = 1 then
  begin
    Node := CreateNode(ntBinaryOp, Ops[0].Value, Ops[0].Line, Ops[0].Column);
    AddChild(Node, Left);
    AddChild(Node, Operands[0]);
    Result := Node;
    Exit;
  end;
  Node := CreateNode(ntComparisonChain, '', Ops[0].Line, Ops[0].Column);
  for I := 0 to Length(Ops) - 1 do
    AddChild(Node, CreateNode(ntIdentifier, Ops[I].Value, Ops[I].Line, Ops[I].Column));
  AddChild(Node, Left);
  for I := 0 to Length(Operands) - 1 do
    AddChild(Node, Operands[I]);
  Result := Node;
end;

function TSardParser.ParseTypeCheck: PSardNode;
var
  Left, Right: PSardNode;
  Node: PSardNode;
  LLine, LCol: Integer;
begin
  Left := ParseAdditive;
  if Current.TokenType = tokTypeEq then
  begin
    LLine := Left^.Line;
    LCol := Left^.Column;
    Advance;
    Right := ParseAdditive;
    Node := CreateNode(ntTypeCheck, '', LLine, LCol);
    AddChild(Node, Left);
    AddChild(Node, Right);
    Result := Node;
    Exit;
  end;
  Result := Left;
end;

function TSardParser.ParseAdditive: PSardNode;
var
  Left, Right: PSardNode;
  OpTok: TSardToken;
  Node: PSardNode;
begin
  Left := ParseMultiplicative;
  while Current.TokenType in AdditiveOps do
  begin
    OpTok := Advance;
    Right := ParseMultiplicative;
    Node := CreateNode(ntBinaryOp, OpTok.Value, OpTok.Line, OpTok.Column);
    AddChild(Node, Left);
    AddChild(Node, Right);
    Left := Node;
  end;
  Result := Left;
end;

function TSardParser.ParseMultiplicative: PSardNode;
var
  Left, Right: PSardNode;
  OpTok: TSardToken;
  Node: PSardNode;
begin
  Left := ParsePower;
  while Current.TokenType in MultiplicativeOps do
  begin
    OpTok := Advance;
    Right := ParsePower;
    Node := CreateNode(ntBinaryOp, OpTok.Value, OpTok.Line, OpTok.Column);
    AddChild(Node, Left);
    AddChild(Node, Right);
    Left := Node;
  end;
  Result := Left;
end;

function TSardParser.ParsePower: PSardNode;
var
  Left, Node: PSardNode;
  OpTok: TSardToken;
  Operands: array of PSardNode;
  Ops: array of TSardToken;
  I: Integer;
begin
  Result := nil;
  SetLength(Operands, 0);
  SetLength(Ops, 0);
  repeat
    Left := ParseUnary;
    SetLength(Operands, Length(Operands) + 1);
    Operands[Length(Operands) - 1] := Left;
    if Current.TokenType = tokCaret then
    begin
      SetLength(Ops, Length(Ops) + 1);
      Ops[Length(Ops) - 1] := Advance;
    end
    else
      Break;
  until False;

  Result := Operands[Length(Operands) - 1];
  for I := Length(Operands) - 2 downto 0 do
  begin
    OpTok := Ops[I];
    Node := CreateNode(ntBinaryOp, '^', OpTok.Line, OpTok.Column);
    AddChild(Node, Operands[I]);
    AddChild(Node, Result);
    Result := Node;
  end;
end;

function TSardParser.ParseUnary: PSardNode;
var
  Tok: TSardToken;
  LVal: PSardNode;
  Node: PSardNode;
  OpStack: array of TSardToken;
  I: Integer;
begin
  SetLength(OpStack, 0);
  Tok := Current;
  while Tok.TokenType in UnaryOps do
  begin
    SetLength(OpStack, Length(OpStack) + 1);
    OpStack[Length(OpStack) - 1] := Tok;
    Advance;
    Tok := Current;
  end;

  if Tok.TokenType = tokInc then
  begin
    Advance;
    LVal := ParseLValueExpr;
    Node := CreateNode(ntPrefixInc, '', Tok.Line, Tok.Column);
    AddChild(Node, LVal);
    Result := Node;
  end
  else if Tok.TokenType = tokDec then
  begin
    Advance;
    LVal := ParseLValueExpr;
    Node := CreateNode(ntPrefixDec, '', Tok.Line, Tok.Column);
    AddChild(Node, LVal);
    Result := Node;
  end
  else
    Result := ParsePostfix;

  for I := Length(OpStack) - 1 downto 0 do
  begin
    Node := CreateNode(ntUnaryOp, OpStack[I].Value, OpStack[I].Line, OpStack[I].Column);
    AddChild(Node, Result);
    Result := Node;
  end;
end;

function TSardParser.ParseLValueExpr: PSardNode;
var
  Tok, MemberTok: TSardToken;
  Node, Access: PSardNode;
  Idx: PSardNode;
begin
  Tok := Current;
  if Tok.TokenType <> tokIdentifier then
    raise ESardParseError.Create(
      Format('Expected identifier for lvalue, got %s at line %d',
        [TokenTypeToString(Tok.TokenType), Tok.Line]),
      Tok.Line, Tok.Column);
  Advance;
  Node := CreateNode(ntIdentifier, Tok.Value, Tok.Line, Tok.Column);
  while True do
  begin
    if Current.TokenType = tokDot then
    begin
      Advance;
      MemberTok := Expect(tokIdentifier);
      Access := CreateNode(ntMemberAccess, MemberTok.Value, MemberTok.Line, MemberTok.Column);
      AddChild(Access, Node);
      Node := Access;
    end
    else if Current.TokenType = tokLBracket then
    begin
      Advance;
      Idx := ParseExpression;
      Expect(tokRBracket);
      Access := CreateNode(ntIndexAccess, '', Idx^.Line, Idx^.Column);
      AddChild(Access, Node);
      AddChild(Access, Idx);
      Node := Access;
    end
    else
      Break;
  end;
  Result := Node;
end;

function TSardParser.ParsePostfix: PSardNode;
var
  Node, Access, Call, Named: PSardNode;
  Tok, MemberTok: TSardToken;
  Block: PSardNode;
  Args: PSardNode;
begin
  Node := ParsePrimary;
  while True do
  begin
    Tok := Current;
    if Tok.TokenType = tokDot then
    begin
      Advance;
      MemberTok := Expect(tokIdentifier);
      Access := CreateNode(ntMemberAccess, MemberTok.Value, MemberTok.Line, MemberTok.Column);
      AddChild(Access, Node);
      Node := Access;
    end
    else if Tok.TokenType = tokLBracket then
    begin
      Advance;
      Args := ParseExpression;
      Expect(tokRBracket);
      Access := CreateNode(ntIndexAccess, '', Tok.Line, Tok.Column);
      AddChild(Access, Node);
      AddChild(Access, Args);
      Node := Access;
    end
    else if Tok.TokenType = tokLParen then
    begin
      Call := CreateNode(ntCall, '', Tok.Line, Tok.Column);
      AddChild(Call, Node);
      AddChild(Call, ParseArgList);
      if Current.TokenType = tokLBrace then
        AddChild(Call, ParseBlockExpr);
      Node := Call;
    end
    else if Tok.TokenType = tokIdentifier then
    begin
      if (Peek(1).TokenType in [tokLParen, tokLBrace]) then
      begin
        Advance;
        Named := CreateNode(ntNamedBlock, Tok.Value, Tok.Line, Tok.Column);
        AddChild(Named, Node);
        if Current.TokenType = tokLParen then
          AddChild(Named, ParseArgList);
        if Current.TokenType = tokLBrace then
          AddChild(Named, ParseBlockExpr);
        Node := Named;
      end
      else
        Break;
    end
    else if Tok.TokenType = tokLBrace then
    begin
      Block := ParseBlockExpr;
      Call := CreateNode(ntCall, '', Tok.Line, Tok.Column);
      AddChild(Call, Node);
      AddChild(Call, Block);
      Node := Call;
    end
    else if Tok.TokenType = tokPercent then
    begin
      Advance;
      Access := CreateNode(ntPostfixPercent, '', Tok.Line, Tok.Column);
      AddChild(Access, Node);
      Node := Access;
    end
    else if Tok.TokenType = tokInc then
    begin
      Advance;
      Access := CreateNode(ntPostfixInc, '', Tok.Line, Tok.Column);
      AddChild(Access, Node);
      Node := Access;
    end
    else if Tok.TokenType = tokDec then
    begin
      Advance;
      Access := CreateNode(ntPostfixDec, '', Tok.Line, Tok.Column);
      AddChild(Access, Node);
      Node := Access;
    end
    else
      Break;
  end;
  Result := Node;
end;

function TSardParser.ParseArgList: PSardNode;
var
  Node: PSardNode;
begin
  Expect(tokLParen);
  Node := CreateNode(ntArgList);
  if Current.TokenType <> tokRParen then
  begin
    AddChild(Node, ParseExpression);
    while Match(tokComma) <> nil do
      AddChild(Node, ParseExpression);
  end;
  Expect(tokRParen);
  Result := Node;
end;

function TSardParser.ParsePrimary: PSardNode;
var
  Tok, IdTok, NameTok: TSardToken;
  Node, Qualified, Expr: PSardNode;
begin
  Tok := Current;

  if Tok.TokenType = tokInteger then
  begin
    Advance;
    Result := CreateNodeInt(ntLiteral, Tok.IntValue, Tok.Line, Tok.Column);
    Result^.StrValue := Tok.Value;
    Result^.LiteralKind := LIT_INTEGER;
    Exit;
  end;
  if Tok.TokenType = tokNumber then
  begin
    Advance;
    Result := CreateNodeFloat(ntLiteral, Tok.FloatValue, Tok.Line, Tok.Column);
    Result^.StrValue := Tok.Value;
    Result^.LiteralKind := LIT_NUMBER;
    Exit;
  end;
  if Tok.TokenType = tokHex then
  begin
    Advance;
    Result := CreateNodeInt(ntLiteral, Tok.IntValue, Tok.Line, Tok.Column);
    Result^.StrValue := Tok.Value;
    Result^.LiteralKind := LIT_HEX;
    Exit;
  end;
  if Tok.TokenType = tokString then
  begin
    Advance;
    Result := CreateNode(ntLiteral, Tok.Value, Tok.Line, Tok.Column);
    Result^.LiteralKind := LIT_STRING;
    Exit;
  end;
  if Tok.TokenType = tokColor then
  begin
    Advance;
    Result := CreateNodeInt(ntLiteral, Tok.IntValue, Tok.Line, Tok.Column);
    Result^.StrValue := Tok.Value;
    Result^.LiteralKind := LIT_COLOR;
    Exit;
  end;
  if Tok.TokenType = tokCurrency then
  begin
    Advance;
    Result := CreateNodeInt(ntLiteral, Tok.IntValue, Tok.Line, Tok.Column);
    Result^.StrValue := Tok.Value;
    Result^.LiteralKind := LIT_CURRENCY;
    Exit;
  end;
  if Tok.TokenType = tokTrue then
  begin
    Advance;
    Result := CreateNodeBool(ntLiteral, True, Tok.Line, Tok.Column);
    Result^.LiteralKind := LIT_BOOLEAN;
    Exit;
  end;
  if Tok.TokenType = tokFalse then
  begin
    Advance;
    Result := CreateNodeBool(ntLiteral, False, Tok.Line, Tok.Column);
    Result^.LiteralKind := LIT_BOOLEAN;
    Exit;
  end;
  if Tok.TokenType = tokIdentifier then
  begin
    Advance;
    Node := CreateNode(ntIdentifier, Tok.Value, Tok.Line, Tok.Column);
    if Current.TokenType = tokDot then
    begin
      Qualified := CreateNode(ntQualifiedId, '', Tok.Line, Tok.Column);
      AddChild(Qualified, Node);
      while Current.TokenType = tokDot do
      begin
        Advance;
        IdTok := Expect(tokIdentifier);
        AddChild(Qualified, CreateNode(ntIdentifier, IdTok.Value, IdTok.Line, IdTok.Column));
      end;
      Result := Qualified;
      Exit;
    end;
    Result := Node;
    Exit;
  end;
  if Tok.TokenType = tokLParen then
  begin
    Advance;
    Expr := ParseExpression;
    Expect(tokRParen);
    Result := Expr;
    Exit;
  end;
  if Tok.TokenType = tokLBrace then
  begin
    Result := ParseBlockExpr;
    Exit;
  end;
  if Tok.TokenType = tokTilde then
  begin
    Advance;
    NameTok := Expect(tokIdentifier);
    Result := CreateNode(ntObjectNew, NameTok.Value, Tok.Line, Tok.Column);
    Exit;
  end;
  if Tok.TokenType = tokTildeTilde then
  begin
    Advance;
    NameTok := Expect(tokIdentifier);
    Result := CreateNode(ntObjectCopy, NameTok.Value, Tok.Line, Tok.Column);
    Exit;
  end;
  if Tok.TokenType = tokAt then
  begin
    Advance;
    Expr := ParseExpression;
    Node := CreateNode(ntReference, '', Tok.Line, Tok.Column);
    AddChild(Node, Expr);
    Result := Node;
    Exit;
  end;
  if Tok.TokenType = tokLBracket then
  begin
    Result := ParseArrayLiteral;
    Exit;
  end;

  raise ESardParseError.Create(
    Format('Unexpected token %s (%s) at line %d',
      [TokenTypeToString(Tok.TokenType), Tok.Value, Tok.Line]),
    Tok.Line, Tok.Column);
end;

function TSardParser.ParseArrayLiteral: PSardNode;
var
  Tok: TSardToken;
  Node: PSardNode;
begin
  Tok := Expect(tokLBracket);
  Node := CreateNode(ntArrayLiteral, '', Tok.Line, Tok.Column);
  Match(tokSemi);
  if Current.TokenType <> tokRBracket then
  begin
    AddChild(Node, ParseExpression);
    while True do
    begin
      Match(tokSemi);
      if Match(tokComma) <> nil then
      begin
        Match(tokSemi);
        AddChild(Node, ParseExpression);
      end
      else if Current.TokenType <> tokRBracket then
        AddChild(Node, ParseExpression)
      else
        Break;
    end;
  end;
  Expect(tokRBracket);
  Result := Node;
end;

end.