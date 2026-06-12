unit sard_interpreter;

{$mode objfpc}{$H+}{$J-}

interface

uses
  SysUtils, Math, Classes, sard_lexer, sard_parser, sard_ast, sard_objects, sard_errors;

type
  TSardOutputProc = procedure(const S: string);

  EBreakSignal = class(Exception);
  EReturnSignal = class(Exception)
  public
    ReturnValue: PSardObject;
    constructor Create(AValue: PSardObject);
  end;

  TSardInterpreter = class
  private
    FGlobal: PSardObject;
    FOutput: TSardOutputProc;
    procedure PrintOutput(const S: string);
    function CreateGlobalScope: PSardObject;
    function MakePrint: PSardObject;
    function MakeIf: PSardObject;
    function MakeElse: PSardObject;
    function MakeWhile: PSardObject;
    function MakeNegate: PSardObject;
    function MakeBreak: PSardObject;

    function ExecProgram(Node: PSardNode): PSardObject;
    function ExecStatement(Node: PSardNode; Scope: PSardObject): PSardObject;
    function ExecDeclaration(Node: PSardNode; Scope: PSardObject): PSardObject;
    function ExecAssignment(Node: PSardNode; Scope: PSardObject): PSardObject;
    function ExecCompoundAssign(Node: PSardNode; Scope: PSardObject): PSardObject;
    function ExecReturn(Node: PSardNode; Scope: PSardObject): PSardObject;
    function ExecBlockNode(Node: PSardNode; ParentScope: PSardObject): PSardObject;
    function EvalNode(Node: PSardNode; Scope: PSardObject): PSardObject;
    function BinaryOp(Left: PSardObject; const Op: string; Right: PSardObject; Scope: PSardObject): PSardObject;
    function UnaryOp(const Op: string; Operand: PSardObject): PSardObject;
    function AssignTo(Target: PSardNode; Value: PSardObject; Scope: PSardObject): PSardObject;
    function CallObject(Callee: PSardObject; ArgsNode: PSardNode;
      Blocks: array of PSardNode; Scope: PSardObject; NamedBlockName: string = ''): PSardObject;

    function GetArgValues(ArgsNode: PSardNode; Scope: PSardObject): TElementArray;
  public
    constructor Create;
    destructor Destroy; override;
    function Run(const Source: string; const SourceName: string = '<script>'): PSardObject;
    procedure SetOutput(AOutput: TSardOutputProc);
    function GetVariable(const Name: string): PSardObject;
    procedure SetVariable(const Name: string; Value: PSardObject);
  end;

implementation

constructor EReturnSignal.Create(AValue: PSardObject);
begin
  inherited Create('');
  ReturnValue := AValue;
end;

constructor TSardInterpreter.Create;
begin
  inherited Create;
  FOutput := nil;
  FGlobal := CreateGlobalScope;
end;

destructor TSardInterpreter.Destroy;
begin
  FreeSardObject(FGlobal);
  inherited;
end;

procedure TSardInterpreter.PrintOutput(const S: string);
begin
  if Assigned(FOutput) then
    FOutput(S)
  else
    WriteLn(S);
end;

function TSardInterpreter.CreateGlobalScope: PSardObject;
var
  TypeNames: array[0..7] of string;
  I: Integer;
begin
  Result := SardObjectNew;
  Result^.IsCallable := False;

  ObjSetMember(Result, 'print', MakePrint);
  ObjSetMember(Result, 'if', MakeIf);
  ObjSetMember(Result, 'else', MakeElse);
  ObjSetMember(Result, 'while', MakeWhile);
  ObjSetMember(Result, 'negate', MakeNegate);
  ObjSetMember(Result, 'break', MakeBreak);
  ObjSetMember(Result, 'true', SardBoolean(True));
  ObjSetMember(Result, 'false', SardBoolean(False));

  TypeNames[0] := 'integer';
  TypeNames[1] := 'number';
  TypeNames[2] := 'string';
  TypeNames[3] := 'boolean';
  TypeNames[4] := 'color';
  TypeNames[5] := 'currency';
  TypeNames[6] := 'array';
  TypeNames[7] := 'object';
  for I := Low(TypeNames) to High(TypeNames) do
    ObjSetMember(Result, TypeNames[I], SardString(TypeNames[I]));
end;

type
  TSardBuiltinProc = function(Scope: PSardObject; Args: array of PSardObject; Blocks: array of PSardNode): PSardObject of object;

function TSardInterpreter.MakePrint: PSardObject;
var
  Obj: PSardObject;
begin
  Obj := SardCallable;
  Obj^.ObjType := objCallable;
  Obj^.IsCallable := True;
  Obj^.Params.Clear;
  Obj^.StrValue := '__print__';
  Result := Obj;
end;

function TSardInterpreter.MakeIf: PSardObject;
var
  Obj: PSardObject;
begin
  Obj := SardCallable;
  Obj^.ObjType := objCallable;
  Obj^.IsCallable := True;
  Obj^.Params.Clear;
  Obj^.StrValue := '__if__';
  Result := Obj;
end;

function TSardInterpreter.MakeElse: PSardObject;
var
  Obj: PSardObject;
begin
  Obj := SardCallable;
  Obj^.ObjType := objCallable;
  Obj^.IsCallable := True;
  Obj^.Params.Clear;
  Obj^.StrValue := '__else__';
  Result := Obj;
end;

function TSardInterpreter.MakeWhile: PSardObject;
var
  Obj: PSardObject;
begin
  Obj := SardCallable;
  Obj^.ObjType := objCallable;
  Obj^.IsCallable := True;
  Obj^.Params.Clear;
  Obj^.StrValue := '__while__';
  Result := Obj;
end;

function TSardInterpreter.MakeNegate: PSardObject;
var
  Obj: PSardObject;
begin
  Obj := SardCallable;
  Obj^.ObjType := objCallable;
  Obj^.IsCallable := True;
  Obj^.Params.Clear;
  Obj^.Params.Add('value');
  Obj^.StrValue := '__negate__';
  Result := Obj;
end;

function TSardInterpreter.MakeBreak: PSardObject;
var
  Obj: PSardObject;
begin
  Obj := SardCallable;
  Obj^.ObjType := objCallable;
  Obj^.IsCallable := True;
  Obj^.Params.Clear;
  Obj^.StrValue := '__break__';
  Result := Obj;
end;

function TSardInterpreter.Run(const Source: string; const SourceName: string): PSardObject;
var
  Lexer: TSardLexer;
  Parser: TSardParser;
  AST: PSardNode;
begin
  Lexer := TSardLexer.Create(Source, SourceName);
  try
    Parser := TSardParser.Create(Lexer.GetTokens, Lexer.GetTokenCount);
    try
      AST := Parser.Parse;
      try
        Result := ExecProgram(AST);
      finally
        FreeNode(AST);
      end;
    finally
      Parser.Free;
    end;
  finally
    Lexer.Free;
  end;
end;

procedure TSardInterpreter.SetOutput(AOutput: TSardOutputProc);
begin
  FOutput := AOutput;
end;

function TSardInterpreter.GetVariable(const Name: string): PSardObject;
var
  Lower: string;
  Obj: PSardObject;
begin
  Lower := LowerCase(Name);
  Obj := ObjLookup(FGlobal, Lower);
  if Obj = nil then
    raise ESardRuntimeError.Create('Undefined variable: ' + Name);
  Result := Obj;
end;

procedure TSardInterpreter.SetVariable(const Name: string; Value: PSardObject);
var
  Lower: string;
begin
  Lower := LowerCase(Name);
  ObjSetMember(FGlobal, Lower, Value);
end;

function TSardInterpreter.ExecProgram(Node: PSardNode): PSardObject;
var
  I: Integer;
begin
  Result := SardNull;
  for I := 0 to Node^.ChildCount - 1 do
    Result := ExecStatement(Node^.Children[I], FGlobal);
end;

function TSardInterpreter.ExecStatement(Node: PSardNode; Scope: PSardObject): PSardObject;
begin
  case Node^.NodeType of
    ntDeclaration: Result := ExecDeclaration(Node, Scope);
    ntAssignment: Result := ExecAssignment(Node, Scope);
    ntCompoundAssignment: Result := ExecCompoundAssign(Node, Scope);
    ntReturnStmt: Result := ExecReturn(Node, Scope);
    ntExpressionStmt:
    begin
      if Node^.ChildCount > 0 then
        Result := EvalNode(Node^.Children[0], Scope)
      else
        Result := SardNull;
    end;
    ntBlockStmt:
    begin
      if Node^.ChildCount > 0 then
        Result := ExecBlockNode(Node^.Children[0], Scope)
      else
        Result := SardNull;
    end;
    ntEmptyStmt: Result := SardNull;
  else
    Result := SardNull;
  end;
end;

function TSardInterpreter.ExecDeclaration(Node: PSardNode; Scope: PSardObject): PSardObject;
var
  Name: string;
  FirstChild, SecondChild, ThirdChild: PSardNode;
  Obj: PSardObject;
  TypeObj: TSardObjType;
  Val: PSardObject;
  Coerced: PSardObject;
  BlockScope: PSardObject;
  I: Integer;
begin
  Name := Node^.StrValue;
  if Node^.ChildCount = 0 then
  begin
    Obj := SardNull;
    ObjSetMember(Scope, Name, Obj);
    Result := Obj;
    Exit;
  end;

  FirstChild := Node^.Children[0];

  if FirstChild^.NodeType = ntTypeAnnotation then
  begin
    if Node^.ChildCount > 1 then
    begin
      SecondChild := Node^.Children[1];
      if SecondChild^.NodeType = ntParamList then
      begin
        Obj := SardCallable;
        Obj^.IsCallable := True;
        Obj^.StrValue := '';
        Obj^.Params.Clear;
        for I := 0 to SecondChild^.ChildCount - 1 do
          Obj^.Params.Add(LowerCase(SecondChild^.Children[I]^.StrValue));
        if Node^.ChildCount > 2 then
        begin
          ThirdChild := Node^.Children[2];
          if ThirdChild^.NodeType = ntBlockExpr then
          begin
            Obj^.Body := ThirdChild;
            Obj^.ScopeParent := Scope;
          end;
        end;
        ObjSetMember(Scope, Name, Obj);
        Result := Obj;
        Exit;
      end
      else if SecondChild^.NodeType = ntBlockExpr then
      begin
        Obj := SardCallable;
        Obj^.IsCallable := True;
        Obj^.StrValue := '';
        Obj^.Params.Clear;
        Obj^.Body := SecondChild;
        Obj^.ScopeParent := Scope;
        ObjSetMember(Scope, Name, Obj);
        Result := Obj;
        Exit;
      end
      else
      begin
        Val := EvalNode(SecondChild, Scope);
        TypeObj := TSardObjectTypeHelper.TypeFromName(FirstChild^.StrValue);
        if TypeObj <> objNull then
          Coerced := CoerceTo(Val, TypeObj)
        else
          Coerced := Val;
        ObjSetMember(Scope, Name, Coerced);
        Result := Coerced;
        Exit;
      end;
    end
    else
    begin
      Obj := SardNull;
      ObjSetMember(Scope, Name, Obj);
      Result := Obj;
      Exit;
    end;
  end
  else if FirstChild^.NodeType = ntParamList then
  begin
    Obj := SardCallable;
    Obj^.IsCallable := True;
    Obj^.StrValue := '';
    Obj^.Params.Clear;
    for I := 0 to FirstChild^.ChildCount - 1 do
      Obj^.Params.Add(LowerCase(FirstChild^.Children[I]^.StrValue));
    if Node^.ChildCount > 1 then
    begin
      SecondChild := Node^.Children[1];
      if SecondChild^.NodeType = ntBlockExpr then
      begin
        Obj^.Body := SecondChild;
        Obj^.ScopeParent := Scope;
      end;
    end;
    ObjSetMember(Scope, Name, Obj);
    Result := Obj;
    Exit;
  end
  else if FirstChild^.NodeType = ntBlockExpr then
  begin
    BlockScope := SardObjectNew;
    BlockScope^.ScopeParent := Scope;
    BlockScope^.ObjType := objObject;
    for I := 0 to FirstChild^.ChildCount - 1 do
    begin
      try
        ExecStatement(FirstChild^.Children[I], BlockScope);
      except
        on EReturnSignal do
          ;
      end;
    end;
    ObjSetMember(Scope, Name, BlockScope);
    Result := BlockScope;
    Exit;
  end
  else
  begin
    Val := EvalNode(FirstChild, Scope);
    ObjSetMember(Scope, Name, Val);
    Result := Val;
  end;
end;

function TSardInterpreter.ExecAssignment(Node: PSardNode; Scope: PSardObject): PSardObject;
var
  Target: PSardNode;
  Value: PSardObject;
begin
  Target := Node^.Children[0];
  Value := EvalNode(Node^.Children[1], Scope);
  Result := AssignTo(Target, Value, Scope);
end;

function TSardInterpreter.ExecCompoundAssign(Node: PSardNode; Scope: PSardObject): PSardObject;
var
  Op: string;
  Target: PSardNode;
  Current, RHS, NewVal: PSardObject;
begin
  Op := Node^.StrValue;
  Target := Node^.Children[0];
  try
    Current := EvalNode(Target, Scope);
  except
    on ESardRuntimeError do
    begin
      Current := SardInteger(0);
      AssignTo(Target, Current, Scope);
    end;
  end;
  RHS := EvalNode(Node^.Children[1], Scope);
  if Op = '+=' then
    NewVal := BinaryOp(Current, '+', RHS, Scope)
  else if Op = '-=' then
    NewVal := BinaryOp(Current, '-', RHS, Scope)
  else
    raise ESardRuntimeError.Create('Unknown compound assignment: ' + Op);
  Result := AssignTo(Target, NewVal, Scope);
end;

function TSardInterpreter.ExecReturn(Node: PSardNode; Scope: PSardObject): PSardObject;
var
  Val: PSardObject;
begin
  Val := EvalNode(Node^.Children[0], Scope);
  raise EReturnSignal.Create(Val);
end;

function TSardInterpreter.ExecBlockNode(Node: PSardNode; ParentScope: PSardObject): PSardObject;
var
  BlockScope: PSardObject;
  Result_: PSardObject;
  LastReturn: PSardObject;
  I: Integer;
  Child: PSardNode;
  R: PSardObject;
begin
  BlockScope := SardObjectNew;
  BlockScope^.ScopeParent := ParentScope;
  Result_ := SardNull;
  LastReturn := nil;
  for I := 0 to Node^.ChildCount - 1 do
  begin
    Child := Node^.Children[I];
    try
      R := ExecStatement(Child, BlockScope);
      if Child^.NodeType = ntReturnStmt then
      begin
        LastReturn := R;
        Result_ := R;
      end
      else if (Child^.NodeType = ntExpressionStmt) and (Child^.ChildCount > 0) then
        Result_ := R
      else if Child^.NodeType in [ntAssignment, ntCompoundAssignment, ntDeclaration] then
        Result_ := R;
    except
      on E: EReturnSignal do
      begin
        LastReturn := E.ReturnValue;
        Result_ := E.ReturnValue;
      end;
      on EBreakSignal do
        raise;
    end;
  end;
  if LastReturn <> nil then
    Result := LastReturn
  else
    Result := Result_;
  FreeSardObject(BlockScope);
end;

function NumVal(Obj: PSardObject): Double;
begin
  if Obj = nil then
    Result := 0.0
  else if Obj^.ObjType = objInteger then
    Result := Double(Obj^.IntValue)
  else if Obj^.ObjType = objNumber then
    Result := Obj^.FloatValue
  else if Obj^.ObjType = objCurrency then
    Result := Obj^.IntValue / 1000000.0
  else if Obj^.ObjType = objBoolean then
  begin
    if Obj^.BoolValue then Result := 1.0 else Result := 0.0;
  end
  else
    Result := 0.0;
end;

function TSardInterpreter.EvalNode(Node: PSardNode; Scope: PSardObject): PSardObject;
var
  Left, Right: PSardObject;
  Obj: PSardObject;
  I, J: Integer;
  Callee: PSardObject;
  TypeObj: TSardObjType;
  TypeNameStr: string;
  ProtoName: string;
  Proto: PSardObject;
  NewObj: PSardObject;
  Idx: PSardObject;
  IdxInt: Integer;
  Result_: PSardObject;
  OldVal, NewVal: PSardObject;
  Val: PSardObject;
  Ops: array of string;
  Operands: array of PSardObject;
  CompResult: PSardObject;
  Child: PSardNode;
  BlocksArr: array of PSardNode;
  InnerCall: PSardNode;
  BodyIdx, NBBlockIdx, OpCount: Integer;
begin
  case Node^.NodeType of
    ntLiteral:
    begin
      case Node^.LiteralKind of
        LIT_INTEGER: Result := SardInteger(Node^.IntValue);
        LIT_NUMBER: Result := SardNumber(Node^.FloatValue);
        LIT_HEX: Result := SardInteger(Node^.IntValue);
        LIT_STRING: Result := SardString(Node^.StrValue);
        LIT_COLOR: Result := SardColor(Node^.IntValue);
        LIT_CURRENCY: Result := SardCurrency(Node^.IntValue);
        LIT_BOOLEAN: Result := SardBoolean(Node^.BoolValue);
      else
        if Node^.StrValue <> '' then
          Result := SardString(Node^.StrValue)
        else
          Result := SardInteger(Node^.IntValue);
      end;
    end;

    ntIdentifier:
    begin
      Obj := ObjLookup(Scope, Node^.StrValue);
      if Obj = nil then
        raise ESardRuntimeError.Create('Undefined variable: ' + Node^.StrValue);
      Result := Obj;
    end;

    ntQualifiedId:
    begin
      Left := EvalNode(Node^.Children[0], Scope);
      for I := 1 to Node^.ChildCount - 1 do
      begin
        Obj := ObjGetMember(Left, Node^.Children[I]^.StrValue);
        if Obj = nil then
          raise ESardRuntimeError.Create('Member not found: ' + Node^.Children[I]^.StrValue);
        Left := Obj;
      end;
      Result := Left;
    end;

    ntBinaryOp:
    begin
      Left := EvalNode(Node^.Children[0], Scope);
      Right := EvalNode(Node^.Children[1], Scope);
      Result := BinaryOp(Left, Node^.StrValue, Right, Scope);
    end;

    ntUnaryOp:
    begin
      Left := EvalNode(Node^.Children[0], Scope);
      Result := UnaryOp(Node^.StrValue, Left);
    end;

    ntTypeCheck:
    begin
      Left := EvalNode(Node^.Children[0], Scope);
      Right := EvalNode(Node^.Children[1], Scope);
      TypeNameStr := Right^.StrValue;
      if TypeNameStr = '' then
        TypeNameStr := ObjToString(Right);
      TypeObj := TSardObjectTypeHelper.TypeFromName(TypeNameStr);
      if TypeObj <> objNull then
        Result := SardBoolean(Left^.ObjType = TypeObj)
      else
        Result := SardBoolean(False);
    end;

    ntComparisonChain:
    begin
      OpCount := 0;
      for J := 0 to Node^.ChildCount - 1 do
      begin
        Child := Node^.Children[J];
        if (Child^.NodeType = ntIdentifier) and
           ((Child^.StrValue = '=') or (Child^.StrValue = '<>') or
            (Child^.StrValue = '!=') or (Child^.StrValue = '<') or
            (Child^.StrValue = '>') or (Child^.StrValue = '<=') or
            (Child^.StrValue = '>=')) then
          Inc(OpCount)
        else
          Break;
      end;
      SetLength(Ops, OpCount);
      for J := 0 to OpCount - 1 do
        Ops[J] := Node^.Children[J]^.StrValue;
      SetLength(Operands, Node^.ChildCount - OpCount);
      for J := 0 to Length(Operands) - 1 do
        Operands[J] := EvalNode(Node^.Children[OpCount + J], Scope);
      Result_ := SardBoolean(True);
      for J := Low(Ops) to High(Ops) do
      begin
        CompResult := BinaryOp(Operands[J], Ops[J], Operands[J + 1], Scope);
        Result_ := BinaryOp(Result_, '&', CompResult, Scope);
      end;
      Result := Result_;
    end;

    ntMemberAccess:
    begin
      Left := EvalNode(Node^.Children[0], Scope);
      Obj := ObjGetMember(Left, Node^.StrValue);
      if (Obj = nil) and (Left^.Parent <> nil) then
        Obj := ObjGetMember(Left^.Parent, Node^.StrValue);
      if Obj = nil then
        raise ESardRuntimeError.Create('Member not found: ' + Node^.StrValue);
      Result := Obj;
    end;

    ntIndexAccess:
    begin
      Left := EvalNode(Node^.Children[0], Scope);
      Idx := EvalNode(Node^.Children[1], Scope);
      if Left^.ObjType = objArray then
      begin
        IdxInt := Trunc(Idx^.IntValue);
        if (IdxInt >= 0) and (IdxInt < Left^.ElementCount) then
          Result := Left^.Elements[IdxInt]
        else
          raise ESardRuntimeError.Create('Array index out of range: ' + IntToStr(IdxInt));
      end
      else
        raise ESardRuntimeError.Create('Index access on non-array');
    end;

    ntCall:
    begin
      Callee := EvalNode(Node^.Children[0], Scope);
      SetLength(BlocksArr, 0);
      if Node^.ChildCount > 2 then
      begin
        SetLength(BlocksArr, 1);
        BlocksArr[0] := Node^.Children[2];
      end;
      if Node^.ChildCount > 1 then
        Result := CallObject(Callee, Node^.Children[1], BlocksArr, Scope)
      else
        Result := CallObject(Callee, nil, BlocksArr, Scope);
    end;

    ntNamedBlock:
    begin
      if (Node^.StrValue = 'else') or (Node^.StrValue = 'ELSE') then
      begin
        InnerCall := Node^.Children[0];
        if InnerCall^.NodeType <> ntCall then
          raise ESardRuntimeError.Create('else block must follow a call');
        Callee := EvalNode(InnerCall^.Children[0], Scope);
        SetLength(BlocksArr, 0);
        BodyIdx := 2;
        if (InnerCall^.ChildCount > 1) and (InnerCall^.Children[1]^.NodeType <> ntArgList) then
          BodyIdx := 1;
        if InnerCall^.ChildCount > BodyIdx then
        begin
          SetLength(BlocksArr, 1);
          BlocksArr[0] := InnerCall^.Children[BodyIdx];
        end;
        NBBlockIdx := 1;
        if (Node^.ChildCount > 2) and (Node^.Children[1]^.NodeType = ntArgList) then
          NBBlockIdx := 2;
        if Node^.ChildCount > NBBlockIdx then
        begin
          SetLength(BlocksArr, Length(BlocksArr) + 1);
          BlocksArr[Length(BlocksArr) - 1] := Node^.Children[NBBlockIdx];
        end;
        if InnerCall^.ChildCount > 1 then
          Result := CallObject(Callee, InnerCall^.Children[1], BlocksArr, Scope)
        else
          Result := CallObject(Callee, nil, BlocksArr, Scope);
      end
      else
        Result := SardNull;
    end;

    ntBlockExpr:
      Result := ExecBlockNode(Node, Scope);

    ntObjectNew:
    begin
      ProtoName := Node^.StrValue;
      Proto := ObjLookup(Scope, ProtoName);
      if Proto = nil then
        raise ESardRuntimeError.Create('Undefined prototype: ' + ProtoName);
      NewObj := SardObjectNew;
      NewObj^.Parent := Proto;
      Result := NewObj;
    end;

    ntObjectCopy:
    begin
      ProtoName := Node^.StrValue;
      Proto := ObjLookup(Scope, ProtoName);
      if Proto = nil then
        raise ESardRuntimeError.Create('Undefined prototype: ' + ProtoName);
      Result := DeepCopy(Proto);
    end;

    ntReference:
    begin
      Left := EvalNode(Node^.Children[0], Scope);
      Result := Left;
    end;

    ntArrayLiteral:
    begin
      Result := CreateSardObject;
      Result^.ObjType := objArray;
      Result^.ElementCount := Node^.ChildCount;
      SetLength(Result^.Elements, Node^.ChildCount);
      for I := 0 to Node^.ChildCount - 1 do
        Result^.Elements[I] := EvalNode(Node^.Children[I], Scope);
    end;

    ntPostfixPercent:
    begin
      Left := EvalNode(Node^.Children[0], Scope);
      if Left^.ObjType in [objInteger, objNumber] then
        Result := SardNumber(Left^.FloatValue / 100.0)
      else if Left^.ObjType = objInteger then
        Result := SardNumber(Double(Left^.IntValue) / 100.0)
      else
        raise ESardRuntimeError.Create('% operator requires numeric operand');
    end;

    ntPostfixInc:
    begin
      try
        OldVal := EvalNode(Node^.Children[0], Scope);
      except
        on ESardRuntimeError do
        begin
          OldVal := SardInteger(0);
          AssignTo(Node^.Children[0], OldVal, Scope);
        end;
      end;
      NewVal := SardInteger(OldVal^.IntValue + 1);
      AssignTo(Node^.Children[0], NewVal, Scope);
      Result := OldVal;
    end;

    ntPostfixDec:
    begin
      try
        OldVal := EvalNode(Node^.Children[0], Scope);
      except
        on ESardRuntimeError do
        begin
          OldVal := SardInteger(0);
          AssignTo(Node^.Children[0], OldVal, Scope);
        end;
      end;
      NewVal := SardInteger(OldVal^.IntValue - 1);
      AssignTo(Node^.Children[0], NewVal, Scope);
      Result := OldVal;
    end;

    ntPrefixInc:
    begin
      try
        Left := EvalNode(Node^.Children[0], Scope);
      except
        on ESardRuntimeError do
        begin
          Left := SardInteger(0);
          AssignTo(Node^.Children[0], Left, Scope);
        end;
      end;
      NewVal := SardInteger(Left^.IntValue + 1);
      AssignTo(Node^.Children[0], NewVal, Scope);
      Result := NewVal;
    end;

    ntPrefixDec:
    begin
      try
        Left := EvalNode(Node^.Children[0], Scope);
      except
        on ESardRuntimeError do
        begin
          Left := SardInteger(0);
          AssignTo(Node^.Children[0], Left, Scope);
        end;
      end;
      NewVal := SardInteger(Left^.IntValue - 1);
      AssignTo(Node^.Children[0], NewVal, Scope);
      Result := NewVal;
    end;

    ntReturnStmt:
    begin
      Val := EvalNode(Node^.Children[0], Scope);
      raise EReturnSignal.Create(Val);
    end;

  else
    Result := SardNull;
  end;
end;

function TSardInterpreter.AssignTo(Target: PSardNode; Value: PSardObject; Scope: PSardObject): PSardObject;
var
  Name: string;
  Obj, MemberObj: PSardObject;
  Idx: PSardObject;
  IdxInt, I: Integer;
begin
  if Target^.NodeType = ntIdentifier then
  begin
    Name := Target^.StrValue;
    Obj := ObjLookup(Scope, Name);
    if Obj <> nil then
      ObjAssign(Scope, Name, Value)
    else
      ObjSetMember(Scope, Name, Value);
    Result := Value;
    Exit;
  end;

  if Target^.NodeType = ntQualifiedId then
  begin
    Obj := EvalNode(Target^.Children[0], Scope);
    for I := 1 to Target^.ChildCount - 2 do
    begin
      MemberObj := ObjGetMember(Obj, Target^.Children[I]^.StrValue);
      if (MemberObj = nil) and (Obj^.Parent <> nil) then
        MemberObj := ObjGetMember(Obj^.Parent, Target^.Children[I]^.StrValue);
      if MemberObj = nil then
        raise ESardRuntimeError.Create('Member not found: ' + Target^.Children[I]^.StrValue);
      Obj := MemberObj;
    end;
    ObjSetMember(Obj, Target^.Children[Target^.ChildCount - 1]^.StrValue, Value);
    Result := Value;
    Exit;
  end;

  if Target^.NodeType = ntMemberAccess then
  begin
    Obj := EvalNode(Target^.Children[0], Scope);
    ObjSetMember(Obj, Target^.StrValue, Value);
    Result := Value;
    Exit;
  end;

  if Target^.NodeType = ntIndexAccess then
  begin
    Obj := EvalNode(Target^.Children[0], Scope);
    Idx := EvalNode(Target^.Children[1], Scope);
    if Obj^.ObjType = objArray then
    begin
      IdxInt := Trunc(Idx^.IntValue);
      if (IdxInt >= 0) and (IdxInt < Obj^.ElementCount) then
        Obj^.Elements[IdxInt] := Value
      else
        raise ESardRuntimeError.Create('Array index out of range: ' + IntToStr(IdxInt));
      Result := Value;
      Exit;
    end;
    raise ESardRuntimeError.Create('Index assignment on non-array');
  end;

  raise ESardRuntimeError.Create('Invalid assignment target');
end;

function TSardInterpreter.BinaryOp(Left: PSardObject; const Op: string; Right: PSardObject; Scope: PSardObject): PSardObject;
var
  LV, RV: Double;
  IntResult: Int64;
  Count, AI, AJ: Integer;
begin
  if Op = '+' then
  begin
    if (Left^.ObjType = objString) or (Right^.ObjType = objString) then
      Result := SardString(ObjToString(Left) + ObjToString(Right))
    else if (Left^.ObjType = objCurrency) or (Right^.ObjType = objCurrency) then
    begin
      if Left^.ObjType = objCurrency then
        LV := Left^.IntValue
      else if Left^.ObjType = objInteger then
        LV := Left^.IntValue * 1000000
      else
        LV := Round(Left^.FloatValue * 1000000);
      if Right^.ObjType = objCurrency then
        RV := Right^.IntValue
      else if Right^.ObjType = objInteger then
        RV := Right^.IntValue * 1000000
      else
        RV := Round(Right^.FloatValue * 1000000);
      Result := SardCurrency(Round(LV + RV));
    end
    else if (Left^.ObjType = objInteger) and (Right^.ObjType = objInteger) then
      Result := SardInteger(Left^.IntValue + Right^.IntValue)
    else
      Result := SardNumber(Double(Left^.IntValue) + Double(Right^.IntValue));
  end
  else if Op = '-' then
  begin
    if (Left^.ObjType = objCurrency) or (Right^.ObjType = objCurrency) then
    begin
      if Left^.ObjType = objCurrency then LV := Left^.IntValue
      else if Left^.ObjType = objInteger then LV := Left^.IntValue * 1000000
      else LV := Round(Left^.FloatValue * 1000000);
      if Right^.ObjType = objCurrency then RV := Right^.IntValue
      else if Right^.ObjType = objInteger then RV := Right^.IntValue * 1000000
      else RV := Round(Right^.FloatValue * 1000000);
      Result := SardCurrency(Round(LV - RV));
    end
    else if (Left^.ObjType = objInteger) and (Right^.ObjType = objInteger) then
      Result := SardInteger(Left^.IntValue - Right^.IntValue)
    else
      Result := SardNumber(Double(Left^.IntValue) - Double(Right^.IntValue));
  end
  else if Op = '*' then
  begin
    if Left^.ObjType = objArray then
    begin
      Count := Trunc(NumVal(Right));
      Result := CreateSardObject;
      Result^.ObjType := objArray;
      if Count <= 0 then
      begin
        Result^.ElementCount := 0;
        SetLength(Result^.Elements, 0);
      end
      else
      begin
        Result^.ElementCount := Left^.ElementCount * Count;
        SetLength(Result^.Elements, Result^.ElementCount);
        for AI := 0 to Count - 1 do
          for AJ := 0 to Left^.ElementCount - 1 do
            Result^.Elements[AI * Left^.ElementCount + AJ] := DeepCopy(Left^.Elements[AJ]);
      end;
    end
    else if Right^.ObjType = objArray then
    begin
      Count := Trunc(NumVal(Left));
      Result := CreateSardObject;
      Result^.ObjType := objArray;
      if Count <= 0 then
      begin
        Result^.ElementCount := 0;
        SetLength(Result^.Elements, 0);
      end
      else
      begin
        Result^.ElementCount := Right^.ElementCount * Count;
        SetLength(Result^.Elements, Result^.ElementCount);
        for AI := 0 to Count - 1 do
          for AJ := 0 to Right^.ElementCount - 1 do
            Result^.Elements[AI * Right^.ElementCount + AJ] := DeepCopy(Right^.Elements[AJ]);
      end;
    end
    else if (Left^.ObjType = objCurrency) or (Right^.ObjType = objCurrency) then
    begin
      if (Right^.ObjType in [objInteger, objNumber]) and (Left^.ObjType = objCurrency) then
      begin
        IntResult := Left^.IntValue;
        if Right^.ObjType = objInteger then
          Result := SardCurrency(Round(IntResult * Right^.IntValue / 1000000))
        else
          Result := SardCurrency(Round(IntResult * Right^.FloatValue / 1000000));
      end
      else if (Left^.ObjType in [objInteger, objNumber]) and (Right^.ObjType = objCurrency) then
      begin
        IntResult := Right^.IntValue;
        if Left^.ObjType = objInteger then
          Result := SardCurrency(Round(IntResult * Left^.IntValue / 1000000))
        else
          Result := SardCurrency(Round(IntResult * Left^.FloatValue / 1000000));
      end
      else
        Result := SardCurrency(Round(Left^.IntValue * Right^.IntValue / 1000000));
    end
    else if (Left^.ObjType = objInteger) and (Right^.ObjType = objInteger) then
      Result := SardInteger(Left^.IntValue * Right^.IntValue)
    else
      Result := SardNumber(Double(Left^.IntValue) * Double(Right^.IntValue));
  end
  else if Op = '/' then
  begin
    if (Right^.ObjType = objInteger) and (Right^.IntValue = 0) then
      raise ESardRuntimeError.Create('Division by zero')
    else if (Right^.ObjType = objNumber) and (Right^.FloatValue = 0.0) then
      raise ESardRuntimeError.Create('Division by zero');
    if (Left^.ObjType = objInteger) and (Right^.ObjType = objInteger) then
      Result := SardInteger(Left^.IntValue div Right^.IntValue)
    else
      Result := SardNumber(Double(Left^.IntValue) / Double(Right^.IntValue));
  end
  else if Op = '^' then
    Result := SardNumber(Power(Double(Left^.IntValue), Double(Right^.IntValue)))
  else if Op = 'mod' then
  begin
    if (Right^.ObjType = objInteger) and (Right^.IntValue = 0) then
      raise ESardRuntimeError.Create('Modulo by zero');
    if (Left^.ObjType = objInteger) and (Right^.ObjType = objInteger) then
      Result := SardInteger(Left^.IntValue mod Right^.IntValue)
    else
      Result := SardNumber(Frac(Double(Left^.IntValue) / Double(Right^.IntValue)) * Double(Right^.IntValue));
  end
  else if Op = '=' then
    Result := SardBoolean(ValuesEqual(Left, Right))
  else if (Op = '<>') or (Op = '!=') then
    Result := SardBoolean(not ValuesEqual(Left, Right))
  else if Op = '<' then
    Result := SardBoolean(NumVal(Left) < NumVal(Right))
  else if Op = '>' then
    Result := SardBoolean(NumVal(Left) > NumVal(Right))
  else if Op = '<=' then
    Result := SardBoolean(NumVal(Left) <= NumVal(Right))
  else if Op = '>=' then
    Result := SardBoolean(NumVal(Left) >= NumVal(Right))
  else if (Op = '&') or (Op = 'and') then
    Result := SardBoolean(IsTruthy(Left) and IsTruthy(Right))
  else if (Op = '|') or (Op = 'or') then
    Result := SardBoolean(IsTruthy(Left) or IsTruthy(Right))
  else
    raise ESardRuntimeError.Create('Unknown binary operator: ' + Op);
end;

function TSardInterpreter.UnaryOp(const Op: string; Operand: PSardObject): PSardObject;
begin
  if Op = '-' then
  begin
    if Operand^.ObjType = objInteger then
      Result := SardInteger(-Operand^.IntValue)
    else if Operand^.ObjType = objNumber then
      Result := SardNumber(-Operand^.FloatValue)
    else if Operand^.ObjType = objCurrency then
      Result := SardCurrency(-Operand^.IntValue)
    else
      Result := SardNumber(-Operand^.FloatValue);
  end
  else if Op = '+' then
    Result := Operand
  else if (Op = '!') or (Op = 'not') then
    Result := SardBoolean(not IsTruthy(Operand))
  else
    raise ESardRuntimeError.Create('Unknown unary operator: ' + Op);
end;

function TSardInterpreter.CallObject(Callee: PSardObject; ArgsNode: PSardNode;
  Blocks: array of PSardNode; Scope: PSardObject; NamedBlockName: string): PSardObject;
var
  CallScope: PSardObject;
  ArgValues: TElementArray;
  I: Integer;
  CondObj: PSardObject;
  Body, ElseBlock: PSardNode;
  FirstLoop: Boolean;
  NegVal, WCond: PSardObject;
  PrintBuf: string;
begin
  if not Callee^.IsCallable then
    raise ESardRuntimeError.Create('Object is not callable');

  if Callee^.StrValue = '__print__' then
  begin
    PrintBuf := '';
    if ArgsNode <> nil then
    begin
      for I := 0 to ArgsNode^.ChildCount - 1 do
      begin
        if I > 0 then PrintBuf := PrintBuf + ' ';
        PrintBuf := PrintBuf + ObjToString(EvalNode(ArgsNode^.Children[I], Scope));
      end;
    end;
    PrintOutput(PrintBuf);
    Result := SardNull;
    Exit;
  end;

  if Callee^.StrValue = '__if__' then
  begin
    if ArgsNode <> nil then
      CondObj := EvalNode(ArgsNode^.Children[0], Scope)
    else
      CondObj := SardBoolean(False);
    if IsTruthy(CondObj) then
    begin
      if Length(Blocks) > 0 then
        Result := ExecBlockNode(Blocks[0], Scope)
      else
        Result := SardNull;
    end
    else
    begin
      if Length(Blocks) > 1 then
        Result := ExecBlockNode(Blocks[1], Scope)
      else
        Result := SardNull;
    end;
    Exit;
  end;

  if Callee^.StrValue = '__else__' then
  begin
    if Length(Blocks) > 0 then
      Result := ExecBlockNode(Blocks[0], Scope)
    else
      Result := SardNull;
    Exit;
  end;

  if Callee^.StrValue = '__while__' then
  begin
    Result := SardNull;
    if ArgsNode <> nil then
    begin
      Body := nil;
      ElseBlock := nil;
      if Length(Blocks) > 0 then Body := Blocks[0];
      if Length(Blocks) > 1 then ElseBlock := Blocks[1];
      FirstLoop := True;
      while True do
      begin
        WCond := EvalNode(ArgsNode^.Children[0], Scope);
        if not IsTruthy(WCond) then
        begin
          if FirstLoop and (ElseBlock <> nil) then
            Result := ExecBlockNode(ElseBlock, Scope);
          Break;
        end;
        FirstLoop := False;
        try
          if Body <> nil then
            Result := ExecBlockNode(Body, Scope);
        except
          on EBreakSignal do Break;
        end;
      end;
    end
    else
    begin
      if Length(Blocks) > 0 then
      begin
        while True do
        begin
          try
            Result := ExecBlockNode(Blocks[0], Scope);
          except
            on EBreakSignal do Break;
          end;
        end;
      end;
    end;
    Exit;
  end;

  if Callee^.StrValue = '__negate__' then
  begin
    if ArgsNode <> nil then
    begin
      NegVal := EvalNode(ArgsNode^.Children[0], Scope);
      if NegVal^.ObjType in [objInteger, objNumber] then
      begin
        if NegVal^.ObjType = objInteger then
          Result := SardInteger(-NegVal^.IntValue)
        else
          Result := SardNumber(-NegVal^.FloatValue);
      end
      else
        Result := SardNull;
    end
    else
      Result := SardNull;
    Exit;
  end;

  if Callee^.StrValue = '__break__' then
    raise EBreakSignal.Create('');

  CallScope := SardObjectNew;
  if Callee^.ScopeParent <> nil then
    CallScope^.ScopeParent := Callee^.ScopeParent
  else
    CallScope^.ScopeParent := Callee;

  if Callee^.Params.Count > 0 then
  begin
    SetLength(ArgValues, 0);
    if ArgsNode <> nil then
    begin
      for I := 0 to ArgsNode^.ChildCount - 1 do
      begin
        SetLength(ArgValues, Length(ArgValues) + 1);
        ArgValues[Length(ArgValues) - 1] := EvalNode(ArgsNode^.Children[I], Scope);
      end;
    end;
    for I := 0 to Callee^.Params.Count - 1 do
    begin
      if I < Length(ArgValues) then
        ObjSetMember(CallScope, Callee^.Params[I], ArgValues[I])
      else
        ObjSetMember(CallScope, Callee^.Params[I], SardNull);
    end;
  end;

  if Callee^.Body <> nil then
  begin
    try
      Result := ExecBlockNode(Callee^.Body, CallScope);
    except
      on E: EReturnSignal do
        Result := E.ReturnValue;
      on EBreakSignal do
        raise;
    end;
  end
  else
    Result := SardNull;
end;

function TSardInterpreter.GetArgValues(ArgsNode: PSardNode; Scope: PSardObject): TElementArray;
var
  I: Integer;
begin
  SetLength(Result, 0);
  if ArgsNode = nil then Exit;
  for I := 0 to ArgsNode^.ChildCount - 1 do
  begin
    SetLength(Result, Length(Result) + 1);
    Result[Length(Result) - 1] := EvalNode(ArgsNode^.Children[I], Scope);
  end;
end;

initialization

finalization

end.