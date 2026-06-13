unit sard_ast;

{$mode objfpc}{$H+}{$J-}

interface

type
  TSardNodeType = (
    ntProgram,
    ntDeclaration,
    ntAssignment,
    ntCompoundAssignment,
    ntReturnStmt,
    ntExpressionStmt,
    ntBlockStmt,
    ntEmptyStmt,
    ntBinaryOp,
    ntUnaryOp,
    ntTypeCheck,
    ntComparisonChain,
    ntLiteral,
    ntIdentifier,
    ntQualifiedId,
    ntMemberAccess,
    ntIndexAccess,
    ntCall,
    ntNamedBlock,
    ntBlockExpr,
    ntObjectNew,
    ntObjectCopy,
    ntReference,
    ntArrayLiteral,
    ntPostfixPercent,
    ntPostfixInc,
    ntPostfixDec,
    ntPrefixInc,
    ntPrefixDec,
    ntTypeAnnotation,
    ntParamList,
    ntParameter,
    ntArgList
  );

const
  LIT_INTEGER  = 0;
  LIT_NUMBER   = 1;
  LIT_HEX      = 2;
  LIT_STRING   = 3;
  LIT_COLOR    = 4;
  LIT_CURRENCY = 5;
  LIT_BOOLEAN  = 6;

type
  PSardNode = ^TSardNode;
  TSardNode = record
    NodeType: TSardNodeType;
    StrValue: string;
    IntValue: Int64;
    FloatValue: Double;
    BoolValue: Boolean;
    LiteralKind: Integer;
    Line: Integer;
    Column: Integer;
    Name: string;
    Children: array of PSardNode;
    ChildCount: Integer;
  end;

function CreateNode(AType: TSardNodeType; const AValue: string = '';
  ALine: Integer = 0; ACol: Integer = 0): PSardNode;
function CreateNodeInt(AType: TSardNodeType; AValue: Int64;
  ALine: Integer = 0; ACol: Integer = 0): PSardNode;
function CreateNodeFloat(AType: TSardNodeType; AValue: Double;
  ALine: Integer = 0; ACol: Integer = 0): PSardNode;
function CreateNodeBool(AType: TSardNodeType; AValue: Boolean;
  ALine: Integer = 0; ACol: Integer = 0): PSardNode;
procedure AddChild(Parent, Child: PSardNode);
procedure FreeNode(Node: PSardNode);

implementation

uses
  SysUtils;

function CreateNode(AType: TSardNodeType; const AValue: string;
  ALine: Integer; ACol: Integer): PSardNode;
begin
  New(Result);
  FillChar(Result^, SizeOf(TSardNode), 0);
  Result^.NodeType := AType;
  Result^.StrValue := AValue;
  Result^.Line := ALine;
  Result^.Column := ACol;
  Result^.ChildCount := 0;
  Result^.LiteralKind := -1;
  SetLength(Result^.Children, 0);
end;

function CreateNodeInt(AType: TSardNodeType; AValue: Int64;
  ALine: Integer; ACol: Integer): PSardNode;
begin
  Result := CreateNode(AType, '', ALine, ACol);
  Result^.IntValue := AValue;
  Result^.LiteralKind := -1;
end;

function CreateNodeFloat(AType: TSardNodeType; AValue: Double;
  ALine: Integer; ACol: Integer): PSardNode;
begin
  Result := CreateNode(AType, '', ALine, ACol);
  Result^.FloatValue := AValue;
  Result^.LiteralKind := -1;
end;

function CreateNodeBool(AType: TSardNodeType; AValue: Boolean;
  ALine: Integer; ACol: Integer): PSardNode;
begin
  Result := CreateNode(AType, '', ALine, ACol);
  Result^.BoolValue := AValue;
  Result^.LiteralKind := -1;
end;

procedure AddChild(Parent, Child: PSardNode);
begin
  if Child = nil then
    raise Exception.Create('AddChild called with nil child');
  if Parent^.ChildCount >= Length(Parent^.Children) then
    SetLength(Parent^.Children, Parent^.ChildCount * 2 + 4);
  Parent^.Children[Parent^.ChildCount] := Child;
  Inc(Parent^.ChildCount);
end;

procedure FreeNode(Node: PSardNode);
var
  I: Integer;
begin
  if Node = nil then Exit;
  for I := 0 to Node^.ChildCount - 1 do
    FreeNode(Node^.Children[I]);
  SetLength(Node^.Children, 0);
  Dispose(Node);
end;

end.