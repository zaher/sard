unit SardInterp;

{$ifdef FPC}
{$mode objfpc}{$H+}
{$endif}

interface

uses
  SysUtils, Classes, Math, DateUtils, 
  {$ifndef fpc}
  Windows,
  {$endif}
  SardTypes;

type
  TInterpreter = class(TObject)
  private
    FRoot: TSardValue;
    FBreakDepth: Integer;
    FReturnValue: TSardValue;
    FHasReturn: Boolean;
    FExitValue: TSardValue;
    FHasExit: Boolean;
    FNoAutoCall: Boolean;
    function FindVariable(Scope: TSardValue; const Name: string; out Owner: TSardValue; out MemberIndex: Integer): TSardValue;
    function EvalNode(Node: TASTNode; Scope: TSardValue): TSardValue;
    function EvalLiteral(Node: TASTNode): TSardValue;
    function EvalIdentifier(Node: TASTNode; Scope: TSardValue): TSardValue;
    function EvalBinary(Node: TASTNode; Scope: TSardValue): TSardValue;
    function EvalUnary(Node: TASTNode; Scope: TSardValue): TSardValue;
    function EvalPrefixIncDec(Node: TASTNode; Scope: TSardValue): TSardValue;
    function EvalPostfixIncDec(Node: TASTNode; Scope: TSardValue): TSardValue;
    function EvalLValue(Node: TASTNode; Scope: TSardValue; out Owner: TSardValue; out Name: string; out Index: Integer; out IsIndexed: Boolean; out OwnerOwned: Boolean; out Existing: TSardValue; out MemberIndex: Integer): Boolean;
    function EvalMemberAccess(Node: TASTNode; Scope: TSardValue; ForCall: Boolean): TSardValue;
    function EvalActualValue(Node: TASTNode; Scope: TSardValue): TSardValue;
    function EvalIndexAccess(Node: TASTNode; Scope: TSardValue; ForAssign: Boolean): TSardValue;
    function CallUserCallable(Callable: TSardValue; Scope: TSardValue; CallBase: TSardValue; Args: TSardValueArray; Blocks: TASTNode): TSardValue;
    function EvalCall(Node: TASTNode; Scope: TSardValue): TSardValue;
    function EvalAssign(Node: TASTNode; Scope: TSardValue): TSardValue;
    function EvalDeclare(Node: TASTNode; Scope: TSardValue): TSardValue;
    function EvalReturn(Node: TASTNode; Scope: TSardValue): TSardValue;
    function EvalArray(Node: TASTNode; Scope: TSardValue): TSardValue;
    function EvalObjectNew(Node: TASTNode; Scope: TSardValue): TSardValue;
    function EvalObjectCopy(Node: TASTNode; Scope: TSardValue): TSardValue;
    function EvalReference(Node: TASTNode; Scope: TSardValue): TSardValue;
    function EvalTypeCast(Node: TASTNode; Scope: TSardValue): TSardValue;
    function ApplyOperator(const Op: string; Left, Right: TSardValue): TSardValue;
    function ApplyUnary(const Op: string; Operand: TSardValue): TSardValue;
    function ObjectsEqual(A, B: TSardValue): Boolean;
    function CompareValues(A, B: TSardValue): Integer;
    function GetArrayElement(Arr: TSardValue; Index: Integer): TSardValue;
    procedure SetArrayElement(Arr: TSardValue; Index: Integer; Value: TSardValue);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Execute(Node: TASTNode);

    { Registration ----------------------------------------------------------- }
    procedure RegisterBuiltin(const Name: string; Handler: TBuiltinHandler); overload;
    procedure RegisterBuiltin(const Name: string; Handler: TBuiltinHandler; const RawArgIndexes: TIntegerArray); overload;

    { Shared services exposed to libraries ----------------------------------- }
    function NewValue: TSardValue;
    function NewScope(Parent: TSardValue): TSardValue;
    function EvalExpression(Node: TASTNode; Scope: TSardValue): TSardValue;
    function EvalStatements(Node: TASTNode; Scope: TSardValue): TSardValue;
    function ExecuteBlock(Body: TASTNode; Scope: TSardValue): TSardValue;
    function CoerceValue(Value: TSardValue; const TargetType: string): TSardValue;
    function IsTruthy(Value: TSardValue): Boolean;

    { Execution state exposed to control-flow builtins ----------------------- }
    property BreakDepth: Integer read FBreakDepth write FBreakDepth;
    property ReturnValue: TSardValue read FReturnValue write FReturnValue;
    property HasReturn: Boolean read FHasReturn write FHasReturn;
    property ExitValue: TSardValue read FExitValue write FExitValue;
    property HasExit: Boolean read FHasExit write FHasExit;
  end;

function IsImmutableKind(K: TValueKind): Boolean; //inline;

implementation

{ Forward declarations of core built-in handlers }
function BuiltInPrint(Interp: TObject; Scope: TSardValue; Args: TSardValueArray; Blocks: TASTNode): TSardValue; forward;
function BuiltInIf(Interp: TObject; Scope: TSardValue; Args: TSardValueArray; Blocks: TASTNode): TSardValue; forward;
function BuiltInWhile(Interp: TObject; Scope: TSardValue; Args: TSardValueArray; Blocks: TASTNode): TSardValue; forward;
function BuiltInLoop(Interp: TObject; Scope: TSardValue; Args: TSardValueArray; Blocks: TASTNode): TSardValue; forward;
function BuiltInFor(Interp: TObject; Scope: TSardValue; Args: TSardValueArray; Blocks: TASTNode): TSardValue; forward;
function BuiltInBreak(Interp: TObject; Scope: TSardValue; Args: TSardValueArray; Blocks: TASTNode): TSardValue; forward;
function BuiltInExit(Interp: TObject; Scope: TSardValue; Args: TSardValueArray; Blocks: TASTNode): TSardValue; forward;
function BuiltInLen(Interp: TObject; Scope: TSardValue; Args: TSardValueArray; Blocks: TASTNode): TSardValue; forward;
function BuiltInNow(Interp: TObject; Scope: TSardValue; Args: TSardValueArray; Blocks: TASTNode): TSardValue; forward;
function BuiltInTimestamp(Interp: TObject; Scope: TSardValue; Args: TSardValueArray; Blocks: TASTNode): TSardValue; forward;
function BuiltInSleep(Interp: TObject; Scope: TSardValue; Args: TSardValueArray; Blocks: TASTNode): TSardValue; forward;
function BuiltInClock(Interp: TObject; Scope: TSardValue; Args: TSardValueArray; Blocks: TASTNode): TSardValue; forward;

{ TInterpreter }

constructor TInterpreter.Create;
begin
  inherited;
  FRoot := TSardValue.Create;
  FRoot.Kind := vkObject;
  FBreakDepth := 0;
  FReturnValue := nil;
  FHasReturn := False;
  FExitValue := nil;
  FHasExit := False;
  FNoAutoCall := False;

  { Constants }
  FRoot.SetMember('true', ValueTrue);
  FRoot.SetMember('false', ValueFalse);

  { Core builtins }
  RegisterBuiltin('print',     @BuiltInPrint);
  RegisterBuiltin('if',        @BuiltInIf);
  RegisterBuiltin('while',     @BuiltInWhile, [0]);
  RegisterBuiltin('loop',      @BuiltInLoop, [1]);
  RegisterBuiltin('for',       @BuiltInFor, [1]);
  RegisterBuiltin('break',     @BuiltInBreak);
  RegisterBuiltin('exit',      @BuiltInExit);
  RegisterBuiltin('len',       @BuiltInLen);
  RegisterBuiltin('now',       @BuiltInNow);
  RegisterBuiltin('timestamp', @BuiltInTimestamp);
  RegisterBuiltin('sleep',     @BuiltInSleep);
  RegisterBuiltin('clock',     @BuiltInClock);
end;

destructor TInterpreter.Destroy;
begin
  FRoot.Release;
  if FReturnValue <> nil then FReturnValue.Release;
  if FExitValue <> nil then FExitValue.Release;
  inherited;
end;

function TInterpreter.NewValue: TSardValue;
begin
  Result := TSardValue.Create;
end;

function TInterpreter.NewScope(Parent: TSardValue): TSardValue;
begin
  Result := TSardValue.Create;
  Result.Kind := vkObject;
  Result.IsScope := True;
  Result.SetParent(Parent);
end;

function TInterpreter.FindVariable(Scope: TSardValue; const Name: string; out Owner: TSardValue; out MemberIndex: Integer): TSardValue;
var
  Curr: TSardValue;
  Idx: Integer;
begin
  Curr := Scope;
  MemberIndex := -1;
  while Curr <> nil do
  begin
    if Curr.FindLocalMember(Name, Idx) then
    begin
      Owner := Curr;
      MemberIndex := Idx;
      Result := TSardValue(Curr.Members.Objects[Idx]);
      Exit;
    end;
    Curr := Curr.Parent;
  end;
  Owner := nil;
  Result := nil;
end;

procedure TInterpreter.Execute(Node: TASTNode);
var
  Ret: TSardValue;
begin
  if FExitValue <> nil then FExitValue.Release;
  FExitValue := nil;
  FHasExit := False;
  Ret := EvalStatements(Node, FRoot);
  if Ret <> nil then Ret.Release;
end;

procedure TInterpreter.RegisterBuiltin(const Name: string; Handler: TBuiltinHandler);
begin
  RegisterBuiltin(Name, Handler, []);
end;

procedure TInterpreter.RegisterBuiltin(const Name: string; Handler: TBuiltinHandler; const RawArgIndexes: TIntegerArray);
var
  Obj: TSardValue;
  I: Integer;
begin
  Obj := TSardValue.Create;
  Obj.Kind := vkObject;
  Obj.Callable := True;
  Obj.BuiltinHandler := Handler;
  SetLength(Obj.RawArgIndexes, Length(RawArgIndexes));
  for I := 0 to High(RawArgIndexes) do
    Obj.RawArgIndexes[I] := RawArgIndexes[I];
  FRoot.SetMember(Name, Obj);
  Obj.Release;
end;

function TInterpreter.ExecuteBlock(Body: TASTNode; Scope: TSardValue): TSardValue;
var
  NewScopeObj: TSardValue;
  SavedReturn: TSardValue;
  SavedHasReturn: Boolean;
begin
  Result := NullValue;
  if Body = nil then Exit;
  NewScopeObj := NewScope(Scope);
  SavedReturn := FReturnValue;
  SavedHasReturn := FHasReturn;
  FReturnValue := nil;
  FHasReturn := False;
  try
    Result := EvalStatements(Body, NewScopeObj);
  finally
    NewScopeObj.Release;
    if FReturnValue <> nil then FReturnValue.Release;
    FReturnValue := SavedReturn;
    FHasReturn := SavedHasReturn;
  end;
end;

function TInterpreter.EvalExpression(Node: TASTNode; Scope: TSardValue): TSardValue;
begin
  Result := EvalNode(Node, Scope);
end;

function TInterpreter.EvalStatements(Node: TASTNode; Scope: TSardValue): TSardValue;
var
  I: Integer;
  StartBreakDepth: Integer;
  CallNode: TASTNode;
begin
  Result := nil;
  FHasReturn := False;
  StartBreakDepth := FBreakDepth;
  for I := 0 to Node.ChildCount - 1 do
  begin
    if Result <> nil then Result.Release;
    Result := EvalNode(Node.Children[I], Scope);
    { Implicit call: a bare identifier statement that resolves to a callable
      object is invoked with no arguments (Grammar.md §4.7). }
    if (Node.Children[I].Kind = nkIdentifier) and (Result <> nil) and Result.Callable then
    begin
      Result.Release;
      CallNode := TASTNode.Create(nkCall, '', 0, 0);
      try
        CallNode.Left := Node.Children[I]; { borrow the original AST node }
        Result := EvalCall(CallNode, Scope);
      finally
        CallNode.Left := nil; { detach so freeing the synthetic node does not free the AST child }
        CallNode.Free;
      end;
    end;
    if FHasReturn then Break;
    if FHasExit then Break;
    if FBreakDepth < StartBreakDepth then Break;
  end;
  if Result = nil then
    Result := NullValue;
end;

function TInterpreter.EvalNode(Node: TASTNode; Scope: TSardValue): TSardValue;
var
  SavedReturn: TSardValue;
  SavedHasReturn: Boolean;
  BlockScope: TSardValue;
begin
  if Node = nil then
  begin
    Result := NullValue;
    Exit;
  end;

  case Node.Kind of
    nkStatements: Result := EvalStatements(Node, Scope);
    nkBlock:
      begin
        { A block's return statement sets the block's value; it must not
          propagate the return flag to the enclosing statement list. }
        SavedReturn := FReturnValue;
        SavedHasReturn := FHasReturn;
        FReturnValue := nil;
        FHasReturn := False;
        BlockScope := NewScope(Scope);
        try
          Result := EvalStatements(Node, BlockScope);
        finally
          BlockScope.Release;
          if FReturnValue <> nil then FReturnValue.Release;
          FReturnValue := SavedReturn;
          FHasReturn := SavedHasReturn;
        end;
      end;
    nkLiteral: Result := EvalLiteral(Node);
    nkIdentifier: Result := EvalIdentifier(Node, Scope);
    nkBinary: Result := EvalBinary(Node, Scope);
    nkUnary: Result := EvalUnary(Node, Scope);
    nkPrefixIncDec: Result := EvalPrefixIncDec(Node, Scope);
    nkPostfixIncDec: Result := EvalPostfixIncDec(Node, Scope);
    nkMemberAccess: Result := EvalMemberAccess(Node, Scope, False);
    nkIndexAccess: Result := EvalIndexAccess(Node, Scope, False);
    nkCall: Result := EvalCall(Node, Scope);
    nkAssign: Result := EvalAssign(Node, Scope);
    nkDeclare: Result := EvalDeclare(Node, Scope);
    nkReturn: Result := EvalReturn(Node, Scope);
    nkArray: Result := EvalArray(Node, Scope);
    nkObjectNew: Result := EvalObjectNew(Node, Scope);
    nkObjectCopy: Result := EvalObjectCopy(Node, Scope);
    nkReference: Result := EvalReference(Node, Scope);
    nkTypeCast: Result := EvalTypeCast(Node, Scope);
  else
    raise ESardError.Create('Unknown AST node kind');
  end;
end;

function TInterpreter.EvalLiteral(Node: TASTNode): TSardValue;
begin
  Result := NewValue;
  if Node.IsNone then
  begin
    Result.Kind := vkNull;
    Exit;
  end;
  if Node.CurrencyValue <> 0 then
  begin
    Result.Kind := vkCurrency;
    Result.CurrencyValue := Node.CurrencyValue;
  end
  else if Node.ColorValue <> 0 then
  begin
    Result.Kind := vkColor;
    Result.ColorValue := Node.ColorValue;
  end
  else if Node.StrValue <> '' then
  begin
    Result.Kind := vkString;
    Result.StrValue := Node.StrValue;
  end
  else if Node.IsDate then
  begin
    Result.Kind := vkDate;
    Result.FloatValue := Node.FloatValue;
  end
  else if Abs(Node.FloatValue) > 1e-15 then
  begin
    Result.Kind := vkNumber;
    Result.FloatValue := Node.FloatValue;
  end
  else
  begin
    Result.Kind := vkInteger;
    Result.IntValue := Node.IntValue;
  end;
end;

function TInterpreter.EvalIdentifier(Node: TASTNode; Scope: TSardValue): TSardValue;
var
  Obj: TSardValue;
  Owner: TSardValue;
  RootMem: TSardValue;
  CallNode: TASTNode;
  DummyIdx: Integer;
begin
  Obj := FindVariable(Scope, Node.Name, Owner, DummyIdx);
  if Obj = nil then
  begin
    RootMem := FRoot.GetMember(Node.Name);
    if RootMem <> nil then
      Obj := RootMem;
  end;
  if Obj = nil then
  begin
    { Auto-create undefined identifiers as null (matches demo expectations) }
    Obj := NewValue;
    Obj.Kind := vkNull;
    FRoot.SetMember(Node.Name, Obj);
    Obj.Release;
  end;
  Obj.AddRef;
  Result := Obj;

  { Parameterless callables can be invoked without parentheses, like in Pascal. }
  if (not FNoAutoCall) and Result.Callable and (Result.Params.Count = 0) then
  begin
    Result.Release;
    CallNode := TASTNode.Create(nkCall, '', Node.TokenLine, Node.TokenCol);
    try
      CallNode.Left := Node;
      Result := EvalCall(CallNode, Scope);
    finally
      CallNode.Left := nil;
      CallNode.Free;
    end;
  end;
end;

function TInterpreter.EvalBinary(Node: TASTNode; Scope: TSardValue): TSardValue;
var
  Left, Right: TSardValue;
  TypeName: string;

  function TypeMatches(Val: TSardValue; const TName: string): Boolean;
  begin
    Result := (Val.KindName = TName) or
              ((TName = 'integer') and (Val.Kind = vkInteger)) or
              ((TName = 'number') and (Val.Kind = vkNumber)) or
              ((TName = 'string') and (Val.Kind = vkString)) or
              ((TName = 'boolean') and (Val.Kind = vkBoolean)) or
              ((TName = 'color') and (Val.Kind = vkColor)) or
              ((TName = 'currency') and (Val.Kind = vkCurrency)) or
              ((TName = 'array') and (Val.Kind = vkArray)) or
              ((TName = 'object') and (Val.Kind = vkObject));
  end;

begin
  Left := EvalExpression(Node.Left, Scope);
  try
    if Node.Op = '==' then
    begin
      if Node.Right.Kind = nkIdentifier then
        TypeName := LowerCase(Node.Right.Name)
      else
      begin
        Right := EvalExpression(Node.Right, Scope);
        try
          TypeName := Right.KindName;
        finally
          Right.Release;
        end;
      end;
      Result := BooleanValue(TypeMatches(Left, TypeName));
      Exit;
    end;

    Right := EvalExpression(Node.Right, Scope);
    try
      if (Node.Op = 'and') or (Node.Op = '&') then
        Result := BooleanValue(IsTruthy(Left) and IsTruthy(Right))
      else if (Node.Op = 'or') or (Node.Op = '|') then
        Result := BooleanValue(IsTruthy(Left) or IsTruthy(Right))
      else if Node.Op = '=' then
        Result := BooleanValue(ObjectsEqual(Left, Right))
      else if (Node.Op = '<>') or (Node.Op = '!=') then
        Result := BooleanValue(not ObjectsEqual(Left, Right))
      else if Node.Op = '<' then
        Result := BooleanValue(CompareValues(Left, Right) < 0)
      else if Node.Op = '>' then
        Result := BooleanValue(CompareValues(Left, Right) > 0)
      else if Node.Op = '<=' then
        Result := BooleanValue(CompareValues(Left, Right) <= 0)
      else if Node.Op = '>=' then
        Result := BooleanValue(CompareValues(Left, Right) >= 0)
      else
        Result := ApplyOperator(Node.Op, Left, Right);
    finally
      Right.Release;
    end;
  finally
    Left.Release;
  end;
end;

function TInterpreter.EvalUnary(Node: TASTNode; Scope: TSardValue): TSardValue;
var
  Operand: TSardValue;
begin
  Operand := EvalExpression(Node.Left, Scope);
  try
    Result := ApplyUnary(Node.Op, Operand);
  finally
    Operand.Release;
  end;
end;

function TInterpreter.EvalPrefixIncDec(Node: TASTNode; Scope: TSardValue): TSardValue;
var
  Owner: TSardValue;
  Name: string;
  Index: Integer;
  IsIndexed: Boolean;
  OwnerOwned: Boolean;
  Existing: TSardValue;
  Target, NewVal: TSardValue;
  OldInt: Int64;
  NewInt: Int64;
  Arr: TSardValue;
  MemberIndex: Integer;
begin
  if not EvalLValue(Node.Left, Scope, Owner, Name, Index, IsIndexed, OwnerOwned, Existing, MemberIndex) then
    raise ESardError.Create('Prefix inc/dec requires lvalue');

  try
    if IsIndexed then
    begin
      Arr := Owner;
      if Arr.Kind <> vkArray then
        raise ESardError.Create('Cannot index non-array');
      Target := GetArrayElement(Arr, Index);
      OldInt := Target.IntValue;
      if Node.Op = '++' then NewInt := OldInt + 1 else NewInt := OldInt - 1;
      NewVal := NewValue;
      NewVal.Kind := vkInteger;
      NewVal.IntValue := NewInt;
      SetArrayElement(Arr, Index, NewVal);
      NewVal.Release;
      Result := NewValue;
      Result.Kind := vkInteger;
      Result.IntValue := NewInt;
    end
    else
    begin
      if Owner = nil then
      begin
        { auto-create variable with 0 in current scope }
        Target := NewValue;
        Target.Kind := vkInteger;
        Target.IntValue := 0;
        Scope.SetMember(Name, Target);
        Target.Release;
        Existing := Target;
      end;
      Target := Existing;
      if Target = nil then
        raise ESardError.CreateFmt('Internal error: lvalue not found: %s', [Name]);
      OldInt := Target.IntValue;
      if Node.Op = '++' then NewInt := OldInt + 1 else NewInt := OldInt - 1;
      Target.IntValue := NewInt;
      Result := NewValue;
      Result.Kind := vkInteger;
      Result.IntValue := NewInt;
    end;
  finally
    if OwnerOwned then Owner.Release;
  end;
end;

function TInterpreter.EvalPostfixIncDec(Node: TASTNode; Scope: TSardValue): TSardValue;
var
  Owner: TSardValue;
  Name: string;
  Index: Integer;
  IsIndexed: Boolean;
  OwnerOwned: Boolean;
  Existing: TSardValue;
  MemberIndex: Integer;
  Target: TSardValue;
  OldInt: Int64;
  NewInt: Int64;
  Arr: TSardValue;
  Operand: TSardValue;
begin
  if Node.Op = '%' then
  begin
    Operand := EvalExpression(Node.Left, Scope);
    try
      Result := NewValue;
      Result.Kind := vkNumber;
      if Operand.Kind = vkNumber then
        Result.FloatValue := Operand.FloatValue / 100.0
      else
        Result.FloatValue := Operand.IntValue / 100.0;
    finally
      Operand.Release;
    end;
    Exit;
  end;

  if not EvalLValue(Node.Left, Scope, Owner, Name, Index, IsIndexed, OwnerOwned, Existing, MemberIndex) then
    raise ESardError.Create('Postfix inc/dec requires lvalue');

  try
    if IsIndexed then
    begin
      Arr := Owner;
      if Arr.Kind <> vkArray then
        raise ESardError.Create('Cannot index non-array');
      Target := GetArrayElement(Arr, Index);
      OldInt := Target.IntValue;
      if Node.Op = '++' then NewInt := OldInt + 1 else NewInt := OldInt - 1;
      Target.IntValue := NewInt;
      Result := NewValue;
      Result.Kind := vkInteger;
      Result.IntValue := OldInt;
    end
    else
    begin
      if Owner = nil then
      begin
        { auto-create variable with 0 in current scope }
        Target := NewValue;
        Target.Kind := vkInteger;
        Target.IntValue := 0;
        Scope.SetMember(Name, Target);
        Target.Release;
        Existing := Target;
      end;
      Target := Existing;
      if Target = nil then
        raise ESardError.CreateFmt('Internal error: lvalue not found: %s', [Name]);
      OldInt := Target.IntValue;
      if Node.Op = '++' then NewInt := OldInt + 1 else NewInt := OldInt - 1;
      Target.IntValue := NewInt;
      Result := NewValue;
      Result.Kind := vkInteger;
      Result.IntValue := OldInt;
    end;
  finally
    if OwnerOwned then Owner.Release;
  end;
end;

function TInterpreter.EvalMemberAccess(Node: TASTNode; Scope: TSardValue; ForCall: Boolean): TSardValue;
var
  Base, Member: TSardValue;
  MemberName: string;
  Found: Boolean;
  Curr: TSardValue;
  Idx: Integer;
  CallNode: TASTNode;
  SavedNoAutoCall: Boolean;
begin
  Member := Default(TSardValue);
  { The base of a member access is used as an object, not invoked, even if it
    happens to be a parameterless callable. }
  SavedNoAutoCall := FNoAutoCall;
  FNoAutoCall := True;
  try
    if ForCall then
      Base := EvalActualValue(Node.Left, Scope)
    else
      Base := EvalExpression(Node.Left, Scope);
  finally
    FNoAutoCall := SavedNoAutoCall;
  end;
  try
    MemberName := Node.Right.Name;
    Found := False;
    Curr := Base;
    while Curr <> nil do
    begin
      Idx := Curr.Members.IndexOf(MemberName);
      if Idx >= 0 then
      begin
        Member := TSardValue(Curr.Members.Objects[Idx]);
        Found := True;
        Break;
      end;
      Curr := Curr.Parent;
    end;
    if not Found then
      raise ESardError.CreateFmt('Member not found: %s', [MemberName]);
    if ForCall then
    begin
      { Return actual member for a direct call. Caller (EvalCall) supplies the receiver. }
      Result := Member;
      Result.AddRef;
    end
    else
    begin
      Result := Member.Clone(False);
      Result.SetParent(Base);
      { Parameterless methods can be invoked without parentheses. }
      if (not FNoAutoCall) and Result.Callable and (Result.Params.Count = 0) then
      begin
        Result.Release;
        CallNode := TASTNode.Create(nkCall, '', Node.TokenLine, Node.TokenCol);
        try
          CallNode.Left := Node;
          Result := EvalCall(CallNode, Scope);
        finally
          CallNode.Left := nil;
          CallNode.Free;
        end;
      end;
    end;
  finally
    Base.Release;
  end;
end;

function TInterpreter.EvalActualValue(Node: TASTNode; Scope: TSardValue): TSardValue;
var
  Base, Member, Curr: TSardValue;
  MemberName: string;
  Idx: Integer;
  Found: Boolean;
  IndexObj: TSardValue;
  DummyIdx: Integer;
begin
  Member := Default(TSardValue);
  case Node.Kind of
    nkIdentifier:
      begin
        Result := FindVariable(Scope, Node.Name, Base, DummyIdx);
        if Result = nil then
          Result := FRoot.GetMember(Node.Name);
        if Result = nil then
          raise ESardError.CreateFmt('Undefined identifier: %s', [Node.Name]);
        Result.AddRef;
      end;
    nkMemberAccess:
      begin
        Base := EvalActualValue(Node.Left, Scope);
        try
          MemberName := Node.Right.Name;
          Found := False;
          Curr := Base;
          while Curr <> nil do
          begin
            Idx := Curr.Members.IndexOf(MemberName);
            if Idx >= 0 then
            begin
              Member := TSardValue(Curr.Members.Objects[Idx]);
              Found := True;
              Break;
            end;
            Curr := Curr.Parent;
          end;
          if not Found then
            raise ESardError.CreateFmt('Member not found: %s', [MemberName]);
          Result := Member;
          Result.AddRef;
        finally
          Base.Release;
        end;
      end;
    nkIndexAccess:
      begin
        Base := EvalActualValue(Node.Left, Scope);
        try
          if Base.Kind <> vkArray then
            raise ESardError.Create('Cannot index non-array');
          IndexObj := EvalExpression(Node.Right, Scope);
          try
            Idx := IndexObj.IntValue;
            Result := GetArrayElement(Base, Idx);
            Result.AddRef;
          finally
            IndexObj.Release;
          end;
        finally
          Base.Release;
        end;
      end;
  else
    Result := EvalExpression(Node, Scope);
  end;
end;

function TInterpreter.EvalIndexAccess(Node: TASTNode; Scope: TSardValue; ForAssign: Boolean): TSardValue;
var
  Base, IndexObj: TSardValue;
  Index: Integer;
  Arr: TSardValue;
  SavedNoAutoCall: Boolean;
begin
  { The base of an index access is used as a container, not invoked. }
  SavedNoAutoCall := FNoAutoCall;
  FNoAutoCall := True;
  try
    Base := EvalExpression(Node.Left, Scope);
  finally
    FNoAutoCall := SavedNoAutoCall;
  end;
  try
    if Base.Kind <> vkArray then
      raise ESardError.Create('Cannot index non-array');
    Arr := Base;
    IndexObj := EvalExpression(Node.Right, Scope);
    try
      Index := IndexObj.IntValue;
      if ForAssign then
      begin
        Result := Arr;
        Result.AddRef;
      end
      else
      begin
        Result := GetArrayElement(Arr, Index);
        Result.AddRef;
      end;
    finally
      IndexObj.Release;
    end;
  finally
    if not ForAssign then
      Base.Release;
  end;
end;

function TInterpreter.EvalCall(Node: TASTNode; Scope: TSardValue): TSardValue;
var
  Callee: TSardValue;
  Args: TSardValueArray;
  ArgNodes: TASTNodeArray;
  Blocks: TASTNode;
  I, J: Integer;
  ArgListNode: TASTNode;
  ArgNodeArr: TASTNodeArray;
  BlockArr: TASTNodeArray;
  BlockCount: Integer;
  RawArg: TSardValue;
  CallBase: TSardValue;

  function IsBuiltinCallable(Obj: TSardValue): Boolean;
  begin
    Result := (Obj <> nil) and Obj.Callable and Assigned(Obj.BuiltinHandler);
  end;

  function NeedsRawArg(const Callee: TSardValue; Index: Integer): Boolean;
  var
    K: Integer;
  begin
    Result := False;
    for K := 0 to High(Callee.RawArgIndexes) do
      if Callee.RawArgIndexes[K] = Index then
      begin
        Result := True;
        Exit;
      end;
  end;

begin
  Result := nil;
  BlockCount := 0;
  BlockArr := nil;
  ArgNodeArr := nil;
  SetLength(BlockArr, Node.ChildCount);
  SetLength(ArgNodeArr, 0);
  try
    { Separate argument lists and blocks from children }
    for I := 0 to Node.ChildCount - 1 do
    begin
      if Node.Children[I].Name = 'args' then
      begin
        ArgListNode := Node.Children[I];
        SetLength(ArgNodeArr, ArgListNode.ChildCount);
        for J := 0 to ArgListNode.ChildCount - 1 do
          ArgNodeArr[J] := ArgListNode.Children[J];
      end
      else
      begin
        BlockArr[BlockCount] := Node.Children[I];
        Inc(BlockCount);
      end;
    end;

    Blocks := nil;
    if BlockCount > 0 then
    begin
      Blocks := TASTNode.Create(nkStatements, '', 0, 0);
      Blocks.Name := 'blocks';
      for I := 0 to BlockCount - 1 do
        Blocks.AddChild(BlockArr[I]);
    end;

    { If the callee is a member access, evaluate its receiver once so the method
      body can resolve member names against the real object. }
    if Node.Left.Kind = nkMemberAccess then
      CallBase := EvalActualValue(Node.Left.Left, Scope)
    else
      CallBase := nil;

    { Evaluate callee. Suppress auto-calling of parameterless callables so that
      explicit calls like f() or obj.method() receive the callable object itself. }
    FNoAutoCall := True;
    try
      Callee := EvalExpression(Node.Left, Scope);
    finally
      FNoAutoCall := False;
    end;
    try
      if not Callee.Callable then
        raise ESardError.Create('Object is not callable');

      try
        { Build argument values; raw argument positions are passed as vkRawArg AST wrappers }
        ArgNodes := ArgNodeArr;

        Args := nil;
        SetLength(Args, Length(ArgNodes));
        for I := 0 to High(ArgNodes) do
        begin
          if ArgNodes[I] = nil then
            Args[I] := nil
          else if NeedsRawArg(Callee, I) then
          begin
            RawArg := NewValue;
            RawArg.Kind := vkRawArg;
            RawArg.RawNode := ArgNodes[I];
            Args[I] := RawArg;
          end
          else
            Args[I] := EvalExpression(ArgNodes[I], Scope);
        end;

        { Builtins cannot distinguish omitted arguments - supply null for empty slots }
        if IsBuiltinCallable(Callee) then
          for I := 0 to High(Args) do
            if Args[I] = nil then
            begin
              Args[I] := NewValue;
              Args[I].Kind := vkNull;
            end;

        if IsBuiltinCallable(Callee) then
          Result := Callee.BuiltinHandler(Self, Scope, Args, Blocks)
        else
          Result := CallUserCallable(Callee, Scope, CallBase, Args, Blocks);
      finally
        if CallBase <> nil then CallBase.Release;
      end;
    finally
      Callee.Release;
      for I := 0 to High(Args) do
        if Args[I] <> nil then
          Args[I].Release;
      if Blocks <> nil then
      begin
        { Blocks is a temporary wrapper; do not free the original AST children }
        Blocks.ClearChildren;
        Blocks.Free;
      end;
    end;
  finally
  end;
end;

function TInterpreter.EvalAssign(Node: TASTNode; Scope: TSardValue): TSardValue;
var
  Owner: TSardValue;
  Name: string;
  Index: Integer;
  IsIndexed: Boolean;
  OwnerOwned: Boolean;
  Existing: TSardValue;
  MemberIndex: Integer;
  Value, Coerced: TSardValue;
  TargetType: string;
  Arr: TSardValue;
  CloneValue: TSardValue;
  AccountantOp: string;
  PercentNode: TASTNode;
  LeftExpr: TASTNode;
  AccountantNode: TASTNode;
  AccountantMul: TASTNode;
  AccountantDiv: TASTNode;
  AccountantOne: TASTNode;

  function IsAccountantPattern(N: TASTNode; out Op: string; out PercentChild: TASTNode; out LeftSide: TASTNode): Boolean;
  begin
    Result := False;
    Op := '';
    PercentChild := nil;
    LeftSide := nil;
    if N = nil then Exit;
    if (N.Kind <> nkBinary) then Exit;
    if (N.Op <> '+') and (N.Op <> '-') then Exit;
    if N.Right = nil then Exit;
    if N.Right.Kind <> nkPostfixIncDec then Exit;
    if N.Right.Op <> '%' then Exit;
    Op := N.Op;
    PercentChild := N.Right;
    LeftSide := N.Left;
    Result := True;
  end;

begin
  if not EvalLValue(Node.Left, Scope, Owner, Name, Index, IsIndexed, OwnerOwned, Existing, MemberIndex) then
    raise ESardError.Create('Invalid assignment target');

  { Accountant calculator mode at top level: check RHS pattern }
  AccountantOp := '';
  PercentNode := nil;
  LeftExpr := nil;
  if IsAccountantPattern(Node.Right, AccountantOp, PercentNode, LeftExpr) then
  begin
    { Transform: Left +/- Right% => Left + Left * (Right/100) }
    AccountantMul := TASTNode.Create(nkBinary, '', 0, 0);
    AccountantMul.Op := '*';
    AccountantMul.Left := LeftExpr.DeepClone;
    AccountantDiv := TASTNode.Create(nkBinary, '', 0, 0);
    AccountantDiv.Op := '/';
    AccountantDiv.Left := PercentNode.Left.DeepClone;
    AccountantOne := TASTNode.Create(nkLiteral, '', 0, 0);
    AccountantOne.IntValue := 100;
    AccountantDiv.Right := AccountantOne;
    AccountantMul.Right := AccountantDiv;
    AccountantNode := TASTNode.Create(nkBinary, '', 0, 0);
    AccountantNode.Op := AccountantOp;
    AccountantNode.Left := LeftExpr.DeepClone;
    AccountantNode.Right := AccountantMul;
    try
      Value := EvalExpression(AccountantNode, Scope);
    finally
      AccountantNode.Free;
    end;
  end
  else
    Value := EvalExpression(Node.Right, Scope);

  try
    if IsIndexed then
    begin
      Arr := Owner;
      if Arr.Kind <> vkArray then
        raise ESardError.Create('Cannot assign to index of non-array');
      SetArrayElement(Arr, Index, Value);
      Result := Value;
      Result.AddRef;
    end
    else
    begin
      { Coerce to declared type if the existing variable has one }
      if (Existing <> nil) and (Existing.DeclaredType <> '') then
      begin
        TargetType := Existing.DeclaredType;
        Coerced := CoerceValue(Value, TargetType);
        Value.Release;
        Value := Coerced;
      end;

      { Store value. Use SetMemberAt fast path when we already know the index. }
      if IsImmutableKind(Value.Kind) then
      begin
        if MemberIndex >= 0 then
          Owner.SetMemberAt(MemberIndex, Value)
        else if Owner = nil then
          Scope.SetMember(Name, Value)
        else
          Owner.SetMember(Name, Value);
      end
      else
      begin
        CloneValue := Value.Clone(True);
        if MemberIndex >= 0 then
          Owner.SetMemberAt(MemberIndex, CloneValue)
        else if Owner = nil then
          Scope.SetMember(Name, CloneValue)
        else
          Owner.SetMember(Name, CloneValue);
        CloneValue.Release;
      end;

      Result := Value;
      Result.AddRef;
    end;
  finally
    if OwnerOwned then Owner.Release;
    if Value <> nil then Value.Release;
  end;
end;

function TInterpreter.EvalDeclare(Node: TASTNode; Scope: TSardValue): TSardValue;
var
  Value, Callable: TSardValue;
  I: Integer;
  BodyNode: TASTNode;
  ExecScope: TSardValue;
  ExecRet: TSardValue;
  SavedReturn: TSardValue;
  SavedHasReturn: Boolean;
begin
  if (Node.ChildCount = 0) and (Node.ReturnType = '') then
  begin
    { Variable declaration without initializer }
    Value := NewValue;
    Value.Kind := vkNull;
    Value.DeclaredType := LowerCase(Node.Typ);
    Scope.SetMember(Node.Name, Value);
    Value.Release;
    Result := NewValue;
    Exit;
  end;

  if Node.ChildCount > 0 then
  begin
    BodyNode := Node.Children[0];
    if BodyNode.Kind = nkBlock then
    begin
      { Callable / Object declaration }
      Callable := NewValue;
      Callable.Kind := vkObject;
      Callable.Callable := True;
      for I := 0 to High(Node.Params) do
        Callable.Params.Add(Node.Params[I]);
      for I := 0 to High(Node.ParamTypes) do
        Callable.ParamTypes.Add(Node.ParamTypes[I]);
      SetLength(Callable.ParamDefaults, Length(Node.ParamDefaults));
      for I := 0 to High(Node.ParamDefaults) do
        if Node.ParamDefaults[I] <> nil then
          Callable.ParamDefaults[I] := Node.ParamDefaults[I].DeepClone;
      SetLength(Callable.ParamOpen, Length(Node.ParamOpen));
      for I := 0 to High(Node.ParamOpen) do
        Callable.ParamOpen[I] := Node.ParamOpen[I];
      Callable.OpenParamIndex := Node.OpenParamIndex;
      Callable.ReturnType := Node.ReturnType;
      Callable.Body := BodyNode.DeepClone;
      Callable.Parent := Scope;

      { Parameterless block: execute it to initialize object members.
        A callable with explicit empty param list () is not executed at declaration. }
      if (Callable.Params.Count = 0) and not Node.HasParamList then
      begin
        ExecScope := NewScope(Scope);
        SavedReturn := FReturnValue;
        SavedHasReturn := FHasReturn;
        FReturnValue := nil;
        FHasReturn := False;
        try
          ExecRet := EvalStatements(Callable.Body, ExecScope);
          if ExecRet <> nil then ExecRet.Release;
          { Copy members from execution scope to callable object }
          for I := 0 to ExecScope.Members.Count - 1 do
          begin
            Callable.SetMember(ExecScope.Members[I], TSardValue(ExecScope.Members.Objects[I]).Clone(False));
          end;
        finally
          ExecScope.Release;
          if FReturnValue <> nil then FReturnValue.Release;
          FReturnValue := SavedReturn;
          FHasReturn := SavedHasReturn;
        end;
      end;

      Scope.SetMember(Node.Name, Callable);
      Callable.Release;
      Result := NewValue;
      Exit;
    end;
  end;

  { Variable declaration with initializer }
  Value := EvalExpression(Node.Children[0], Scope);
  Value.DeclaredType := LowerCase(Node.Typ);
  Scope.SetMember(Node.Name, Value);
  Value.Release;
  Result := NewValue;
end;

function TInterpreter.EvalReturn(Node: TASTNode; Scope: TSardValue): TSardValue;
begin
  if FReturnValue <> nil then FReturnValue.Release;
  if Node.ChildCount > 0 then
    FReturnValue := EvalExpression(Node.Children[0], Scope)
  else
    FReturnValue := NullValue;
  FHasReturn := True;
  Result := FReturnValue;
  Result.AddRef;
end;

function TInterpreter.EvalArray(Node: TASTNode; Scope: TSardValue): TSardValue;
var
  I, J, Count: Integer;
  RepeatCount: Integer;
  Elem: TSardValue;
  HasRepeat: Boolean;
  RepeatNode: TASTNode;
  ElemClone: TSardValue;
begin
  Result := NewValue;
  Result.Kind := vkArray;
  HasRepeat := False;
  RepeatCount := 1;
  if (Node.ChildCount > 0) and (Node.Children[Node.ChildCount - 1].Name = 'repeat') then
  begin
    HasRepeat := True;
    RepeatNode := Node.Children[Node.ChildCount - 1];
    RepeatCount := RepeatNode.IntValue;
    if RepeatCount < 0 then RepeatCount := 0;
  end;

  Count := Node.ChildCount;
  if HasRepeat then Dec(Count);

  for I := 0 to Count - 1 do
  begin
    Elem := EvalExpression(Node.Children[I], Scope);
    try
      if IsImmutableKind(Elem.Kind) then
      begin
        for J := 1 to RepeatCount do
        begin
          Elem.AddRef;
          Result.ArrayItems.Add(Elem);
        end;
      end
      else
      begin
        for J := 1 to RepeatCount do
        begin
          ElemClone := Elem.Clone(True);
          Result.ArrayItems.Add(ElemClone);
        end;
      end;
    finally
      Elem.Release;
    end;
  end;
end;

function TInterpreter.EvalObjectNew(Node: TASTNode; Scope: TSardValue): TSardValue;
var
  Proto: TSardValue;
  Owner: TSardValue;
  RootMem: TSardValue;
  I: Integer;
  DummyIdx: Integer;
begin
  Proto := FindVariable(Scope, Node.Name, Owner, DummyIdx);
  if Proto = nil then
  begin
    RootMem := FRoot.GetMember(Node.Name);
    if RootMem <> nil then Proto := RootMem;
  end;
  if Proto = nil then
    raise ESardError.CreateFmt('Undefined prototype: %s', [Node.Name]);
  Result := NewValue;
  Result.Kind := vkObject;
  Result.Parent := Proto;
  { Copy prototype members into instance so assignment clone preserves them }
  for I := 0 to Proto.Members.Count - 1 do
    Result.SetMember(Proto.Members[I], TSardValue(Proto.Members.Objects[I]).Clone(False));
end;

function TInterpreter.EvalObjectCopy(Node: TASTNode; Scope: TSardValue): TSardValue;
var
  Proto, Obj: TSardValue;
  Owner: TSardValue;
  RootMem: TSardValue;
  I: Integer;
  DummyIdx: Integer;
begin
  Proto := FindVariable(Scope, Node.Name, Owner, DummyIdx);
  if Proto = nil then
  begin
    RootMem := FRoot.GetMember(Node.Name);
    if RootMem <> nil then Proto := RootMem;
  end;
  if Proto = nil then
    raise ESardError.CreateFmt('Undefined prototype: %s', [Node.Name]);
  Result := NewValue;
  Result.Kind := vkObject;
  Result.Parent := nil;
  for I := 0 to Proto.Members.Count - 1 do
  begin
    Obj := TSardValue(Proto.Members.Objects[I]);
    if Obj <> nil then
      Result.SetMember(Proto.Members[I], Obj.Clone(False));
  end;
end;

function TInterpreter.EvalReference(Node: TASTNode; Scope: TSardValue): TSardValue;
var
  Owner: TSardValue;
  Name: string;
  Index: Integer;
  IsIndexed: Boolean;
  OwnerOwned: Boolean;
  Existing: TSardValue;
  MemberIndex: Integer;
  Target: TSardValue;
  Arr: TSardValue;
  Idx: Integer;
  Base: TSardValue;
  Member: TSardValue;
  MemberName: string;
  Curr: TSardValue;
  Found: Boolean;
begin
  Member := Default(TSardValue);
  { @expr: for lvalues, return the actual stored object reference; otherwise eval expression }
  if Node.Left = nil then
  begin
    Result := EvalExpression(Node.Left, Scope);
    Exit;
  end;

  if Node.Left.Kind = nkIdentifier then
  begin
    Target := FindVariable(Scope, Node.Left.Name, Owner, MemberIndex);
    if Target = nil then Target := FRoot.GetMember(Node.Left.Name);
    if Target = nil then
      raise ESardError.CreateFmt('Undefined identifier: %s', [Node.Left.Name]);
    Result := Target;
    Result.AddRef;
  end
  else if Node.Left.Kind = nkMemberAccess then
  begin
    Base := EvalExpression(Node.Left.Left, Scope);
    try
      MemberName := Node.Left.Right.Name;
      Found := False;
      Curr := Base;
      while Curr <> nil do
      begin
        Idx := Curr.Members.IndexOf(MemberName);
        if Idx >= 0 then
        begin
          Member := TSardValue(Curr.Members.Objects[Idx]);
          Found := True;
          Break;
        end;
        Curr := Curr.Parent;
      end;
      if not Found then
        raise ESardError.CreateFmt('Member not found: %s', [MemberName]);
      Result := Member;
      Result.AddRef;
      Result.Parent := Base;
      Base.AddRef; { keep base alive as parent? Risk of leak. For now accept. }
    finally
      Base.Release;
    end;
  end
  else if Node.Left.Kind = nkIndexAccess then
  begin
    if not EvalLValue(Node.Left, Scope, Owner, Name, Index, IsIndexed, OwnerOwned, Existing, MemberIndex) then
      raise ESardError.Create('Invalid reference target');
    try
      if not IsIndexed then
        raise ESardError.Create('Reference target not indexed');
      Arr := Owner;
      Result := GetArrayElement(Arr, Index);
      Result.AddRef;
    finally
      if OwnerOwned then Owner.Release;
    end;
  end
  else
    Result := EvalExpression(Node.Left, Scope);
end;

function TInterpreter.EvalTypeCast(Node: TASTNode; Scope: TSardValue): TSardValue;
var
  Val: TSardValue;
begin
  Val := EvalExpression(Node.Left, Scope);
  try
    Result := CoerceValue(Val, Node.Name);
  finally
    Val.Release;
  end;
end;

function TInterpreter.EvalLValue(Node: TASTNode; Scope: TSardValue; out Owner: TSardValue; out Name: string; out Index: Integer; out IsIndexed: Boolean; out OwnerOwned: Boolean; out Existing: TSardValue; out MemberIndex: Integer): Boolean;
var
  IndexObj: TSardValue;

  function EvalActual(ANode: TASTNode): TSardValue;
  var
    LBase, LMember, LCurr: TSardValue;
    LMemberName: string;
    LIdx: Integer;
    LFound: Boolean;
    LDummyIdx: Integer;
  begin
    LMember := Default(TSardValue);
    case ANode.Kind of
      nkIdentifier:
        begin
          Result := FindVariable(Scope, ANode.Name, LBase, LDummyIdx);
          if Result = nil then
            Result := FRoot.GetMember(ANode.Name);
          if Result = nil then
            raise ESardError.CreateFmt('Undefined identifier: %s', [ANode.Name]);
          Result.AddRef;
        end;
      nkMemberAccess:
        begin
          LBase := EvalActual(ANode.Left);
          try
            LMemberName := ANode.Right.Name;
            LFound := False;
            LCurr := LBase;
            while LCurr <> nil do
            begin
              LIdx := LCurr.Members.IndexOf(LMemberName);
              if LIdx >= 0 then
              begin
                LMember := TSardValue(LCurr.Members.Objects[LIdx]);
                LFound := True;
                Break;
              end;
              LCurr := LCurr.Parent;
            end;
            if not LFound then
              raise ESardError.CreateFmt('Member not found: %s', [LMemberName]);
            Result := LMember;
            Result.AddRef;
            Result.SetParent(LBase);
          finally
            LBase.Release;
          end;
        end;
      nkIndexAccess:
        begin
          LBase := EvalActual(ANode.Left);
          try
            if LBase.Kind <> vkArray then
              raise ESardError.Create('Cannot index non-array');
            IndexObj := EvalExpression(ANode.Right, Scope);
            try
              LIdx := IndexObj.IntValue;
              Result := GetArrayElement(LBase, LIdx);
              Result.AddRef;
            finally
              IndexObj.Release;
            end;
          finally
            LBase.Release;
          end;
        end;
    else
      Result := EvalExpression(ANode, Scope);
    end;
  end;

begin
  Result := False;
  Owner := nil;
  Name := '';
  Index := 0;
  IsIndexed := False;
  OwnerOwned := False;
  Existing := nil;
  MemberIndex := -1;

  if Node.Kind = nkIdentifier then
  begin
    Name := Node.Name;
    Existing := FindVariable(Scope, Name, Owner, MemberIndex);
    Result := True;
  end
  else if Node.Kind = nkMemberAccess then
  begin
    Owner := EvalActual(Node.Left);
    OwnerOwned := True;
    Name := Node.Right.Name;
    Existing := Owner.GetMember(Name);
    if Owner.FindLocalMember(Name, MemberIndex) then
    else
      MemberIndex := -1;
    Result := True;
  end
  else if Node.Kind = nkIndexAccess then
  begin
    Owner := EvalActual(Node.Left);
    OwnerOwned := True;
    IndexObj := EvalExpression(Node.Right, Scope);
    try
      Index := IndexObj.IntValue;
      IsIndexed := True;
      Result := True;
    finally
      IndexObj.Release;
    end;
  end;
end;

function TInterpreter.ApplyOperator(const Op: string; Left, Right: TSardValue): TSardValue;
var
  D1, D2: Double;
  I1, I2: Int64;
  CV1, CV2: Int64;
  IsCurr: Boolean;
  I: Integer;
  V: TSardValue;
begin
  Result := NewValue;

  IsCurr := (Left.Kind = vkCurrency) or (Right.Kind = vkCurrency);
  if IsCurr then
  begin
    if Left.Kind = vkCurrency then CV1 := Left.CurrencyValue else CV1 := Left.IntValue * 1000000;
    if Right.Kind = vkCurrency then CV2 := Right.CurrencyValue else CV2 := Right.IntValue * 1000000;
    Result.Kind := vkCurrency;
    if Op = '+' then Result.CurrencyValue := CV1 + CV2
    else if Op = '-' then Result.CurrencyValue := CV1 - CV2
    else if Op = '*' then Result.CurrencyValue := (CV1 * CV2) div 1000000
    else if Op = '/' then
        begin
          if CV2 = 0 then raise ESardError.Create('Division by zero');
          Result.CurrencyValue := (CV1 * 1000000) div CV2;
    end
    else if Op = 'mod' then Result.CurrencyValue := CV1 mod CV2
    else if Op = '^' then Result.CurrencyValue := Round(Power(CV1 / 1000000, CV2 / 1000000) * 1000000)
    else raise ESardError.CreateFmt('Unsupported operator %s for currency', [Op]);
    Exit;
  end;

  if (Left.Kind = vkString) or (Right.Kind = vkString) then
  begin
    if Op = '+' then
    begin
      Result.Kind := vkString;
      Result.StrValue := Left.AsString + Right.AsString;
      Exit;
    end
    else
      raise ESardError.CreateFmt('Unsupported operator %s for strings', [Op]);
  end;

  { Array + array appends }
  if (Left.Kind = vkArray) and (Right.Kind = vkArray) and (Op = '+') then
  begin
    Result.Kind := vkArray;
    for I := 0 to Left.ArrayItems.Count - 1 do
    begin
      V := TSardValue(Left.ArrayItems[I]);
      if V <> nil then
        Result.ArrayItems.Add(V.Clone(True));
    end;
    for I := 0 to Right.ArrayItems.Count - 1 do
    begin
      V := TSardValue(Right.ArrayItems[I]);
      if V <> nil then
        Result.ArrayItems.Add(V.Clone(True));
    end;
    Exit;
  end;

  if (Left.Kind = vkNumber) or (Right.Kind = vkNumber) then
  begin
    if Left.Kind = vkNumber then D1 := Left.FloatValue else D1 := Left.IntValue;
    if Right.Kind = vkNumber then D2 := Right.FloatValue else D2 := Right.IntValue;
    Result.Kind := vkNumber;
    if Op = '+' then Result.FloatValue := D1 + D2
    else if Op = '-' then Result.FloatValue := D1 - D2
    else if Op = '*' then Result.FloatValue := D1 * D2
    else if Op = '/' then
        begin
          if D2 = 0 then raise ESardError.Create('Division by zero');
          Result.FloatValue := D1 / D2;
    end
    else if Op = '^' then Result.FloatValue := Power(D1, D2)
    else if Op = 'mod' then Result.FloatValue := Round(D1) mod Round(D2)
    else raise ESardError.CreateFmt('Unsupported operator %s for numbers', [Op]);
    Exit;
  end;

  I1 := Left.IntValue;
  I2 := Right.IntValue;
  Result.Kind := vkInteger;
  if Op = '+' then Result.IntValue := I1 + I2
  else if Op = '-' then Result.IntValue := I1 - I2
  else if Op = '*' then Result.IntValue := I1 * I2
  else if Op = '/' then
      begin
        if I2 = 0 then raise ESardError.Create('Division by zero');
        Result.Kind := vkNumber;
        Result.FloatValue := I1 / I2;
  end
  else if Op = '^' then
      begin
        Result.Kind := vkNumber;
        Result.FloatValue := Power(I1, I2);
  end
  else if Op = 'mod' then Result.IntValue := I1 mod I2
  else raise ESardError.CreateFmt('Unsupported operator %s', [Op]);
      end;

function TInterpreter.ApplyUnary(const Op: string; Operand: TSardValue): TSardValue;
begin
  Result := NewValue;
  if Op = '-' then
  begin
    if Operand.Kind = vkNumber then
    begin
      Result.Kind := vkNumber;
      Result.FloatValue := -Operand.FloatValue;
    end
    else
    begin
      Result.Kind := vkInteger;
      Result.IntValue := -Operand.IntValue;
    end;
  end
  else if Op = '+' then
  begin
    Result.Kind := Operand.Kind;
    Result.IntValue := Operand.IntValue;
    Result.FloatValue := Operand.FloatValue;
    Result.StrValue := Operand.StrValue;
    Result.BoolValue := Operand.BoolValue;
    Result.ColorValue := Operand.ColorValue;
    Result.CurrencyValue := Operand.CurrencyValue;
  end
  else if (Op = '!') or (Op = 'not') then
  begin
    Result := BooleanValue(not IsTruthy(Operand));
    Exit;
  end
  else
    raise ESardError.CreateFmt('Unknown unary operator: %s', [Op]);
end;

function TInterpreter.CoerceValue(Value: TSardValue; const TargetType: string): TSardValue;
var
  I: Int64;
  Code: Integer;
  D: Double;
  S: string;
begin
  Result := NewValue;
  S := LowerCase(TargetType);
  if S = 'integer' then
  begin
    Result.Kind := vkInteger;
    if Value.Kind = vkInteger then Result.IntValue := Value.IntValue
    else if Value.Kind = vkNumber then Result.IntValue := Trunc(Value.FloatValue)
    else if Value.Kind = vkString then
    begin
      Val(Value.StrValue, I, Code);
      if Code <> 0 then
      begin
        Result.Release;
        raise ESardError.CreateFmt('Cannot convert string ''%s'' to integer', [Value.StrValue]);
      end;
      Result.IntValue := I;
    end
    else if Value.Kind = vkBoolean then Result.IntValue := Ord(Value.BoolValue)
    else
    begin
      Result.Release;
      raise ESardError.CreateFmt('Cannot convert %s to integer', [Value.KindName]);
    end;
  end
  else if S = 'number' then
  begin
    Result.Kind := vkNumber;
    if Value.Kind = vkNumber then Result.FloatValue := Value.FloatValue
    else if Value.Kind = vkInteger then Result.FloatValue := Value.IntValue
    else if Value.Kind = vkString then
    begin
      Val(Value.StrValue, D, Code);
      if Code <> 0 then
      begin
        Result.Release;
        raise ESardError.CreateFmt('Cannot convert string ''%s'' to number', [Value.StrValue]);
      end;
      Result.FloatValue := D;
    end
    else
    begin
      Result.Release;
      raise ESardError.CreateFmt('Cannot convert %s to number', [Value.KindName]);
    end;
  end
  else if S = 'string' then
  begin
    Result.Kind := vkString;
    Result.StrValue := Value.AsString;
  end
  else if S = 'boolean' then
  begin
    Result.Kind := vkBoolean;
    Result.BoolValue := IsTruthy(Value);
  end
  else if S = 'currency' then
  begin
    Result.Kind := vkCurrency;
    if Value.Kind = vkCurrency then Result.CurrencyValue := Value.CurrencyValue
    else if Value.Kind = vkInteger then Result.CurrencyValue := Value.IntValue * 1000000
    else if Value.Kind = vkNumber then Result.CurrencyValue := Round(Value.FloatValue * 1000000)
    else
    begin
      Result.Release;
      raise ESardError.CreateFmt('Cannot convert %s to currency', [Value.KindName]);
    end;
  end
  else if S = 'date' then
  begin
    Result.Kind := vkDate;
    if Value.Kind = vkDate then Result.FloatValue := Value.FloatValue
    else
    begin
      Result.Release;
      raise ESardError.CreateFmt('Cannot convert %s to date', [Value.KindName]);
    end;
  end
  else if S = 'color' then
  begin
    Result.Kind := vkColor;
    if Value.Kind = vkColor then Result.ColorValue := Value.ColorValue
    else if Value.Kind = vkInteger then Result.ColorValue := Value.IntValue
    else
    begin
      Result.Release;
      raise ESardError.CreateFmt('Cannot convert %s to color', [Value.KindName]);
    end;
  end
  else if S = 'array' then
  begin
    if Value.Kind <> vkArray then
    begin
      Result.Release;
      raise ESardError.CreateFmt('Cannot convert %s to array', [Value.KindName]);
    end;
    Result.Kind := vkArray;
    Result := Value.Clone(True);
  end
  else if S = 'object' then
  begin
    if Value.Kind <> vkObject then
    begin
      Result.Release;
      raise ESardError.CreateFmt('Cannot convert %s to object', [Value.KindName]);
    end;
    Result.Kind := vkObject;
    Result := Value.Clone(False);
  end
  else
  begin
    Result.Release;
    raise ESardError.CreateFmt('Unknown type: %s', [TargetType]);
  end;
end;

function TInterpreter.IsTruthy(Value: TSardValue): Boolean;
begin
  case Value.Kind of
    vkNull: Result := False;
    vkInteger: Result := Value.IntValue <> 0;
    vkNumber: Result := Value.FloatValue <> 0;
    vkString: Result := Value.StrValue <> '';
    vkBoolean: Result := Value.BoolValue;
    vkColor: Result := Value.ColorValue <> 0;
    vkCurrency: Result := Value.CurrencyValue <> 0;
    vkArray: Result := Value.ArrayItems.Count > 0;
    vkObject: Result := True;
  else
    Result := False;
  end;
end;

function TInterpreter.ObjectsEqual(A, B: TSardValue): Boolean;
var
  I: Integer;
  VA, VB: TSardValue;
begin
  if A.Kind <> B.Kind then
  begin
    Result := False;
    Exit;
  end;
  case A.Kind of
    vkNull: Result := True;
    vkInteger: Result := A.IntValue = B.IntValue;
    vkNumber: Result := Abs(A.FloatValue - B.FloatValue) < 1e-9;
    vkString: Result := A.StrValue = B.StrValue;
    vkBoolean: Result := A.BoolValue = B.BoolValue;
    vkColor: Result := A.ColorValue = B.ColorValue;
    vkCurrency: Result := A.CurrencyValue = B.CurrencyValue;
    vkArray:
      begin
        if A.ArrayItems.Count <> B.ArrayItems.Count then
        begin
          Result := False;
          Exit;
        end;
        for I := 0 to A.ArrayItems.Count - 1 do
        begin
          VA := TSardValue(A.ArrayItems[I]);
          VB := TSardValue(B.ArrayItems[I]);
          if not ObjectsEqual(VA, VB) then
          begin
            Result := False;
            Exit;
          end;
        end;
        Result := True;
      end;
    vkObject: Result := A = B;
  else
    Result := False;
  end;
end;

function TInterpreter.CompareValues(A, B: TSardValue): Integer;
var
  DA, DB: Double;
  SA, SB: string;
begin
  if A.Kind = vkString then
  begin
    SA := A.StrValue;
    SB := B.AsString;
    if SA < SB then Result := -1
    else if SA > SB then Result := 1
    else Result := 0;
    Exit;
  end;
  if A.Kind = vkNumber then DA := A.FloatValue else DA := A.IntValue;
  if B.Kind = vkNumber then DB := B.FloatValue else DB := B.IntValue;
  if DA < DB then Result := -1
  else if DA > DB then Result := 1
  else Result := 0;
end;

function TInterpreter.GetArrayElement(Arr: TSardValue; Index: Integer): TSardValue;
begin
  if Arr.Kind <> vkArray then
    raise ESardError.Create('Not an array');
  if (Index < 0) or (Index >= Arr.ArrayItems.Count) then
    raise ESardError.CreateFmt('Array index out of bounds: %d', [Index]);
  Result := TSardValue(Arr.ArrayItems[Index]);
end;

function IsImmutableKind(K: TValueKind): Boolean; inline;
begin
  Result := (K = vkNull) or (K = vkInteger) or (K = vkNumber) or
            (K = vkString) or (K = vkBoolean) or (K = vkColor) or
            (K = vkCurrency) or (K = vkDate) or (K = vkRawArg);
end;

procedure TInterpreter.SetArrayElement(Arr: TSardValue; Index: Integer; Value: TSardValue);
var
  Old: TSardValue;
  NewVal: TSardValue;
begin
  if Arr.Kind <> vkArray then
    raise ESardError.Create('Not an array');
  if (Index < 0) or (Index >= Arr.ArrayItems.Count) then
    raise ESardError.CreateFmt('Array index out of bounds: %d', [Index]);
  Old := TSardValue(Arr.ArrayItems[Index]);
  if Old <> nil then Old.Release;
  if IsImmutableKind(Value.Kind) then
  begin
    Value.AddRef;
    Arr.ArrayItems[Index] := Value;
  end
  else
  begin
    NewVal := Value.Clone(True);
    NewVal.AddRef; { array owns it }
    Arr.ArrayItems[Index] := NewVal;
  end;
end;

function TInterpreter.CallUserCallable(Callable: TSardValue; Scope: TSardValue; CallBase: TSardValue; Args: TSardValueArray; Blocks: TASTNode): TSardValue;
var
  CallableScope, BodyScope: TSardValue;
  I, J, OpenIdx: Integer;
  ParamName: string;
  ArgValue, Arr, V: TSardValue;
  BlockNode: TASTNode;
  BlocksArray: TSardValue;
  BlockVal: TSardValue;
  SavedReturn: TSardValue;
  SavedHasReturn: Boolean;
  SavedExitValue: TSardValue;
  SavedHasExit: Boolean;

begin
  Result := nil;
  if CallBase <> nil then
    CallableScope := NewScope(CallBase)
  else
    CallableScope := NewScope(Scope);
  try
    { Bind arguments; omitted arguments use the declared default or null }
    OpenIdx := Callable.OpenParamIndex;
    for I := 0 to Callable.Params.Count - 1 do
    begin
      ParamName := Callable.Params[I];
      if I = OpenIdx then
      begin
        { Open parameter collects all remaining arguments into an array }
        Arr := NewValue;
        Arr.Kind := vkArray;
        for J := I to High(Args) do
        begin
          if Args[J] <> nil then
          begin
            if IsImmutableKind(Args[J].Kind) then
            begin
              Args[J].AddRef;
              Arr.ArrayItems.Add(Args[J]);
            end
            else
              Arr.ArrayItems.Add(Args[J].Clone(True));
          end
          else
          begin
            V := NewValue;
            V.Kind := vkNull;
            Arr.ArrayItems.Add(V);
          end;
        end;
        ArgValue := Arr;
      end
      else if (I <= High(Args)) and (Args[I] <> nil) then
      begin
        if IsImmutableKind(Args[I].Kind) then
        begin
          Args[I].AddRef;
          ArgValue := Args[I];
        end
        else
          ArgValue := Args[I].Clone(True);
      end
      else if (I <= High(Callable.ParamDefaults)) and (Callable.ParamDefaults[I] <> nil) then
        ArgValue := EvalExpression(Callable.ParamDefaults[I], Scope)
      else
      begin
        ArgValue := NewValue;
        ArgValue.Kind := vkNull;
      end;
      CallableScope.SetMember(ParamName, ArgValue);
      ArgValue.Release;
    end;

    { Bind blocks as array of objects named by block name }
    if (Blocks <> nil) and (Blocks.ChildCount > 0) then
    begin
      BlocksArray := NewValue;
      BlocksArray.Kind := vkArray;
      for I := 0 to Blocks.ChildCount - 1 do
      begin
        BlockNode := Blocks.Children[I];
        BlockVal := NewValue;
        BlockVal.Kind := vkObject;
        BlockVal.Callable := False;
        if BlockNode.Name <> '' then
          BlockVal.SetMember('name', NewValue) { placeholder }
        else
          BlockVal.SetMember('name', NewValue);
        { Store AST in a custom way? We don't have a field. Skip for now. }
        BlocksArray.ArrayItems.Add(BlockVal);
        BlockVal.Release;
      end;
      CallableScope.SetMember('_blocks', BlocksArray);
      BlocksArray.Release;
    end;

    { Execute body }
    BodyScope := NewScope(CallableScope);
    SavedReturn := FReturnValue;
    SavedHasReturn := FHasReturn;
    SavedExitValue := FExitValue;
    SavedHasExit := FHasExit;
    FReturnValue := nil;
    FHasReturn := False;
    FExitValue := nil;
    FHasExit := False;
    try
      Result := EvalStatements(Callable.Body, BodyScope);
      if FHasExit then
      begin
        if Result <> nil then Result.Release;
        Result := FExitValue;
        FExitValue := nil;
        FHasExit := False;
      end;
    finally
      BodyScope.Release;
      if FReturnValue <> nil then FReturnValue.Release;
      FReturnValue := SavedReturn;
      FHasReturn := SavedHasReturn;
      if FExitValue <> nil then FExitValue.Release;
      FExitValue := SavedExitValue;
      FHasExit := SavedHasExit;
    end;
    if Result = nil then Result := NewValue;
  finally
    CallableScope.Release;
  end;
end;

function BuiltInPrint(Interp: TObject; Scope: TSardValue; Args: TSardValueArray; Blocks: TASTNode): TSardValue;
var
  I: Integer;
  S: string;
begin
  S := '';
  for I := 0 to High(Args) do
  begin
    if I > 0 then S := S + ' ';
    S := S + Args[I].AsString;
  end;
  WriteLn(S);
  Result := NullValue;
end;

function BuiltInIf(Interp: TObject; Scope: TSardValue; Args: TSardValueArray; Blocks: TASTNode): TSardValue;
var
  CondValue: Boolean;
  I: Integer;
  BlockNode: TASTNode;
  BodyBlock: TASTNode;
  ElseIfCond: TSardValue;
  InterpObj: TInterpreter;

  function ExecuteBody(Body: TASTNode): TSardValue;
  begin
    Result := InterpObj.ExecuteBlock(Body, Scope);
    if Result = nil then
      Result := InterpObj.NewValue;
  end;

begin
  InterpObj := TInterpreter(Interp);
  CondValue := True;
  if Length(Args) > 0 then
    CondValue := InterpObj.IsTruthy(Args[0]);

  BodyBlock := nil;
  if Blocks <> nil then
  begin
    for I := 0 to Blocks.ChildCount - 1 do
    begin
      BlockNode := Blocks.Children[I];
      if BlockNode.Name = '' then
        BodyBlock := BlockNode;
    end;
  end;

  Result := NullValue;

  if CondValue then
  begin
    if BodyBlock <> nil then
    begin
      Result.Release;
      Result := ExecuteBody(BodyBlock);
    end;
  end
  else if Blocks <> nil then
  begin
    for I := 0 to Blocks.ChildCount - 1 do
    begin
      BlockNode := Blocks.Children[I];
      if BlockNode.Name = '' then
        Continue;
      if LowerCase(BlockNode.Name) = 'else-if' then
      begin
        ElseIfCond := InterpObj.EvalExpression(BlockNode.Left, Scope);
        try
          if InterpObj.IsTruthy(ElseIfCond) then
          begin
            Result.Release;
            Result := ExecuteBody(BlockNode);
            Break;
          end;
        finally
          ElseIfCond.Release;
        end;
      end
      else if LowerCase(BlockNode.Name) = 'else' then
      begin
        Result.Release;
        Result := ExecuteBody(BlockNode);
        Break;
      end;
    end;
  end;
end;

function BuiltInWhile(Interp: TObject; Scope: TSardValue; Args: TSardValueArray; Blocks: TASTNode): TSardValue;
var
  CondValue: Boolean;
  I: Integer;
  BlockNode: TASTNode;
  BodyBlock, ElseBlock: TASTNode;
  Ret: TSardValue;
  HasCondition: Boolean;
  LoopDepth: Integer;
  BodyResult: TSardValue;
  InterpObj: TInterpreter;

  function EvalCondition: Boolean;
  var
    CondVal: TSardValue;
  begin
    if HasCondition then
    begin
      if (Length(Args) > 0) and (Args[0] <> nil) and (Args[0].Kind = vkRawArg) then
      begin
        CondVal := InterpObj.EvalExpression(Args[0].RawNode, Scope);
        try
          Result := InterpObj.IsTruthy(CondVal);
        finally
          CondVal.Release;
        end;
      end
      else if Length(Args) > 0 then
        Result := InterpObj.IsTruthy(Args[0])
      else
        Result := True;
    end
    else
      Result := True;
  end;

begin
  InterpObj := TInterpreter(Interp);
  HasCondition := Length(Args) > 0;
  BodyBlock := nil;
  ElseBlock := nil;
  if Blocks <> nil then
  begin
    for I := 0 to Blocks.ChildCount - 1 do
    begin
      BlockNode := Blocks.Children[I];
      if BlockNode.Name = '' then
        BodyBlock := BlockNode
      else if LowerCase(BlockNode.Name) = 'else' then
        ElseBlock := BlockNode;
    end;
  end;

  Result := InterpObj.NewValue;
  Result.Kind := vkNull;

  CondValue := EvalCondition;

  if not CondValue then
  begin
    if ElseBlock <> nil then
    begin
      Result.Release;
      Ret := InterpObj.ExecuteBlock(ElseBlock, Scope);
      if Ret <> nil then Result := Ret else Result := InterpObj.NewValue;
    end;
    Exit;
  end;

  if BodyBlock = nil then Exit;

  InterpObj.BreakDepth := InterpObj.BreakDepth + 1;
  LoopDepth := InterpObj.BreakDepth;
  try
    while EvalCondition do
    begin
      BodyResult := InterpObj.ExecuteBlock(BodyBlock, Scope);
      if BodyResult <> nil then
      begin
        Result.Release;
        Result := BodyResult;
      end;
      if InterpObj.BreakDepth < LoopDepth then
      begin
        InterpObj.BreakDepth := LoopDepth;
        Break;
      end;
      if InterpObj.HasReturn then Break;
      if InterpObj.HasExit then Break;
    end;
  finally
    if InterpObj.BreakDepth >= LoopDepth then
      InterpObj.BreakDepth := InterpObj.BreakDepth - 1;
  end;
end;

function BuiltInLoop(Interp: TObject; Scope: TSardValue; Args: TSardValueArray; Blocks: TASTNode): TSardValue;
var
  Count: Int64;
  CountKnown: Boolean;
  I: Integer;
  BlockNode: TASTNode;
  BodyBlock: TASTNode;
  NewScopeObj: TSardValue;
  SavedReturn: TSardValue;
  SavedHasReturn: Boolean;
  LoopDepth: Integer;
  BodyResult: TSardValue;
  CountObj: TSardValue;
  Coerced: TSardValue;
  IndexValue: TSardValue;
  VarName: string;
  HaveVarName: Boolean;
  Iteration: Int64;
  InterpObj: TInterpreter;

  function BodyFinished: Boolean;
  begin
    Result := False;
    if InterpObj.BreakDepth < LoopDepth then
    begin
      InterpObj.BreakDepth := LoopDepth;
      Result := True;
      Exit;
    end;
    if InterpObj.HasReturn then Result := True;
    if InterpObj.HasExit then Result := True;
  end;

  procedure ExecuteBody(IterationScope: TSardValue);
  begin
    SavedReturn := InterpObj.ReturnValue;
    SavedHasReturn := InterpObj.HasReturn;
    InterpObj.ReturnValue := nil;
    InterpObj.HasReturn := False;
    try
      BodyResult := InterpObj.EvalStatements(BodyBlock, IterationScope);
    finally
      if InterpObj.ReturnValue <> nil then InterpObj.ReturnValue.Release;
      InterpObj.ReturnValue := SavedReturn;
      InterpObj.HasReturn := SavedHasReturn;
    end;
    if BodyResult <> nil then
    begin
      Result.Release;
      Result := BodyResult;
    end;
  end;

begin
  InterpObj := TInterpreter(Interp);
  BodyBlock := nil;
  if Blocks <> nil then
  begin
    for I := 0 to Blocks.ChildCount - 1 do
    begin
      BlockNode := Blocks.Children[I];
      if BlockNode.Name = '' then
        BodyBlock := BlockNode;
    end;
  end;

  // Determine count. When no argument is supplied (loop { ... } or loop() { ... })
  //  the loop runs forever. A supplied count of 0 or negative still skips the body.
  CountKnown := False;
  Count := 0;
  HaveVarName := False;
  VarName := '';
  if Length(Args) > 0 then
  begin
    CountObj := Args[0];
    if (CountObj <> nil) and (CountObj.Kind <> vkNull) then
    begin
      if CountObj.Kind = vkInteger then
        Count := CountObj.IntValue
      else if CountObj.Kind = vkNumber then
        Count := Trunc(CountObj.FloatValue)
      else if CountObj.Kind = vkString then
      begin
        Coerced := InterpObj.CoerceValue(CountObj, 'integer');
        try
          Count := Coerced.IntValue;
        finally
          Coerced.Release;
        end;
      end
      else
        raise ESardError.CreateFmt('loop count must be an integer, got %s', [CountObj.KindName]);
      CountKnown := True;
    end;
  end;

  { Optional second argument: an identifier that names the loop index variable. }
  if Length(Args) > 1 then
  begin
    if (Args[1] <> nil) and (Args[1].Kind = vkRawArg) and
       (Args[1].RawNode <> nil) and (Args[1].RawNode.Kind = nkIdentifier) then
    begin
      VarName := LowerCase(Args[1].RawNode.Name);
      HaveVarName := True;
    end
    else
      raise ESardError.Create('loop second argument must be a variable name');
  end;

  Result := InterpObj.NewValue;
  Result.Kind := vkNull;

  if BodyBlock = nil then Exit;

  { Pre-allocate index value to avoid per-iteration heap allocation }
  IndexValue := nil;
  if HaveVarName and CountKnown then
  begin
    IndexValue := InterpObj.NewValue;
    IndexValue.Kind := vkInteger;
  end;

  InterpObj.BreakDepth := InterpObj.BreakDepth + 1;
  LoopDepth := InterpObj.BreakDepth;
  try
    if not CountKnown then
    begin
      while True do
      begin
        NewScopeObj := InterpObj.NewScope(Scope);
        try
          ExecuteBody(NewScopeObj);
        finally
          NewScopeObj.Release;
        end;
        if BodyFinished then Break;
      end;
    end
    else
    begin
      for Iteration := 0 to Count - 1 do
      begin
        NewScopeObj := InterpObj.NewScope(Scope);
        if HaveVarName then
        begin
          IndexValue.IntValue := Iteration;
          NewScopeObj.SetMember(VarName, IndexValue);
        end;
        try
          ExecuteBody(NewScopeObj);
        finally
          NewScopeObj.Release;
        end;
        if BodyFinished then Break;
      end;
    end;
  finally
    if IndexValue <> nil then IndexValue.Release;
    if InterpObj.BreakDepth >= LoopDepth then
      InterpObj.BreakDepth := InterpObj.BreakDepth - 1;
  end;
end;

function BuiltInFor(Interp: TObject; Scope: TSardValue; Args: TSardValueArray; Blocks: TASTNode): TSardValue;
var
  I: Integer;
  BlockNode: TASTNode;
  BodyBlock: TASTNode;
  NewScopeObj: TSardValue;
  SavedReturn: TSardValue;
  SavedHasReturn: Boolean;
  LoopDepth: Integer;
  BodyResult: TSardValue;
  Container: TSardValue;
  VarName: string;
  ElemValue: TSardValue;
  Ch: Char;
  LenValue: Integer;
  StrValue: string;
  InterpObj: TInterpreter;

  procedure ExecuteBody(IterationScope: TSardValue);
  begin
    SavedReturn := InterpObj.ReturnValue;
    SavedHasReturn := InterpObj.HasReturn;
    InterpObj.ReturnValue := nil;
    InterpObj.HasReturn := False;
    try
      BodyResult := InterpObj.EvalStatements(BodyBlock, IterationScope);
    finally
      if InterpObj.ReturnValue <> nil then InterpObj.ReturnValue.Release;
      InterpObj.ReturnValue := SavedReturn;
      InterpObj.HasReturn := SavedHasReturn;
    end;
    if BodyResult <> nil then
    begin
      Result.Release;
      Result := BodyResult;
    end;
  end;

  function BodyFinished: Boolean;
  begin
    Result := False;
    if InterpObj.BreakDepth < LoopDepth then
    begin
      InterpObj.BreakDepth := LoopDepth;
      Result := True;
      Exit;
    end;
    if InterpObj.HasReturn then Result := True;
    if InterpObj.HasExit then Result := True;
  end;

begin
  InterpObj := TInterpreter(Interp);
  BodyBlock := nil;
  if Blocks <> nil then
  begin
    for I := 0 to Blocks.ChildCount - 1 do
    begin
      BlockNode := Blocks.Children[I];
      if BlockNode.Name = '' then
        BodyBlock := BlockNode;
    end;
  end;

  if Length(Args) < 2 then
    raise ESardError.Create('for requires two arguments: collection and variable name');

  Container := Args[0];
  if Container = nil then
    raise ESardError.Create('for collection is nil');

  if (Args[1] = nil) or (Args[1].Kind <> vkRawArg) or (Args[1].RawNode = nil) or (Args[1].RawNode.Kind <> nkIdentifier) then
    raise ESardError.Create('for second argument must be a variable name');

  VarName := LowerCase(Args[1].RawNode.Name);

  Result := InterpObj.NewValue;
  Result.Kind := vkNull;

  if BodyBlock = nil then Exit;

  InterpObj.BreakDepth := InterpObj.BreakDepth + 1;
  LoopDepth := InterpObj.BreakDepth;
  try
    if Container.Kind = vkArray then
    begin
      for I := 0 to Container.ArrayItems.Count - 1 do
      begin
        ElemValue := TSardValue(Container.ArrayItems[I]);
        if IsImmutableKind(ElemValue.Kind) then
          ElemValue.AddRef
        else
          ElemValue := ElemValue.Clone(True);
        try
          NewScopeObj := InterpObj.NewScope(Scope);
          NewScopeObj.SetMember(VarName, ElemValue);
          try
            ExecuteBody(NewScopeObj);
          finally
            NewScopeObj.Release;
          end;
          if BodyFinished then Break;
        finally
          ElemValue.Release;
        end;
      end;
    end
    else if Container.Kind = vkString then
    begin
      StrValue := Container.StrValue;
      LenValue := Length(StrValue);
      for I := 1 to LenValue do
      begin
        Ch := StrValue[I];
        ElemValue := InterpObj.NewValue;
        ElemValue.Kind := vkString;
        ElemValue.StrValue := Ch;
        NewScopeObj := InterpObj.NewScope(Scope);
        NewScopeObj.SetMember(VarName, ElemValue);
        ElemValue.Release;
        try
          ExecuteBody(NewScopeObj);
        finally
          NewScopeObj.Release;
        end;
        if BodyFinished then Break;
      end;
    end
    else
      raise ESardError.CreateFmt('for requires an array or string, got %s', [Container.KindName]);
  finally
    if InterpObj.BreakDepth >= LoopDepth then
      InterpObj.BreakDepth := InterpObj.BreakDepth - 1;
  end;
end;

function BuiltInBreak(Interp: TObject; Scope: TSardValue; Args: TSardValueArray; Blocks: TASTNode): TSardValue;
var
  InterpObj: TInterpreter;
begin
  InterpObj := TInterpreter(Interp);
  if InterpObj.BreakDepth > 0 then
    InterpObj.BreakDepth := InterpObj.BreakDepth - 1
  else
    raise ESardError.Create('break outside loop');
  Result := InterpObj.NewValue;
  Result.Kind := vkNull;
end;

function BuiltInExit(Interp: TObject; Scope: TSardValue; Args: TSardValueArray; Blocks: TASTNode): TSardValue;
var
  InterpObj: TInterpreter;
begin
  InterpObj := TInterpreter(Interp);
  if InterpObj.ExitValue <> nil then InterpObj.ExitValue.Release;
  if Length(Args) > 0 then
    InterpObj.ExitValue := Args[0].Clone(True)
  else
  begin
    InterpObj.ExitValue := InterpObj.NewValue;
    InterpObj.ExitValue.Kind := vkNull;
  end;
  InterpObj.HasExit := True;
  Result := InterpObj.ExitValue.Clone(False);
end;

function BuiltInLen(Interp: TObject; Scope: TSardValue; Args: TSardValueArray; Blocks: TASTNode): TSardValue;
var
  Arg: TSardValue;
  InterpObj: TInterpreter;
begin
  InterpObj := TInterpreter(Interp);
  if Length(Args) < 1 then
    raise ESardError.Create('len requires one argument');
  Arg := Args[0];
  Result := InterpObj.NewValue;
  Result.Kind := vkInteger;
  if Arg.Kind = vkArray then
    Result.IntValue := Arg.ArrayItems.Count
  else if Arg.Kind = vkString then
    Result.IntValue := Length(Arg.StrValue)
  else
  begin
    Result.Release;
    raise ESardError.CreateFmt('len requires an array or string, got %s', [Arg.KindName]);
  end;
end;

function BuiltInNow(Interp: TObject; Scope: TSardValue; Args: TSardValueArray; Blocks: TASTNode): TSardValue;
var
  InterpObj: TInterpreter;
begin
  InterpObj := TInterpreter(Interp);
  Result := InterpObj.NewValue;
  Result.Kind := vkDate;
  Result.FloatValue := Now;
end;

function BuiltInTimestamp(Interp: TObject; Scope: TSardValue; Args: TSardValueArray; Blocks: TASTNode): TSardValue;
var
  InterpObj: TInterpreter;
begin
  InterpObj := TInterpreter(Interp);
  Result := InterpObj.NewValue;
  Result.Kind := vkInteger;
  Result.IntValue := DateTimeToUnix(Now);
end;

function BuiltInSleep(Interp: TObject; Scope: TSardValue; Args: TSardValueArray; Blocks: TASTNode): TSardValue;
var
  Ms: Int64;
  InterpObj: TInterpreter;
begin
  InterpObj := TInterpreter(Interp);
  if Length(Args) < 1 then
    raise ESardError.Create('sleep requires one argument');
  if Args[0].Kind = vkInteger then
    Ms := Args[0].IntValue
  else if Args[0].Kind = vkNumber then
    Ms := Trunc(Args[0].FloatValue)
  else
    raise ESardError.CreateFmt('sleep requires an integer, got %s', [Args[0].KindName]);
  if Ms < 0 then Ms := 0;
  SysUtils.Sleep(Ms);
  Result := InterpObj.NewValue;
  Result.Kind := vkNull;
end;

function BuiltInClock(Interp: TObject; Scope: TSardValue; Args: TSardValueArray; Blocks: TASTNode): TSardValue;
var
  InterpObj: TInterpreter;
begin
  InterpObj := TInterpreter(Interp);
  Result := InterpObj.NewValue;
  Result.Kind := vkInteger;
  Result.IntValue := Int64(GetTickCount64);
end;

end.
