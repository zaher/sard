unit SardTypes;

{$ifdef FPC}
{$mode objfpc}{$H+}
{$endif}

interface

uses
  SysUtils, Classes, RTTI;

type
  {$ifndef FPC}
  TStringArray = Array of string;
  {$endif}

  ESardError = class(Exception);

  { Token kinds }
  TTokenKind = (
    tkEOF,
    tkInteger, tkNumber, tkHex, tkString, tkColor, tkCurrency, tkDate, tkNone,
    tkIdentifier,
    tkColon, tkSemicolon, tkComma, tkDot,
    tkAssign, tkTypeCheck,
    tkLessGreater, tkBangEqual, tkLess, tkGreater, tkLessEqual, tkGreaterEqual,
    tkPlus, tkMinus, tkStar, tkSlash, tkCaret, tkPercent,
    tkMod, tkAmp, tkBar, tkAnd, tkOr, tkNot,
    tkBang, tkTilde, tkTildeTilde, tkAt,
    tkIncrement, tkDecrement, tkPlusEqual, tkMinusEqual, tkEllipsis,
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
    nkTypeCast,
    nkStatements
  );

  { Runtime value kinds }
  TValueKind = (
    vkNull, vkInteger, vkNumber, vkString, vkBoolean,
    vkColor, vkCurrency, vkDate, vkArray, vkObject, vkLazy
  );

  TASTNode = class;
  TASTNodeArray = array of TASTNode;

  { Simple open-addressing hash map for string -> integer lookups.
    Used to accelerate member/variable name lookup. Case-insensitive. }
  THashEntryState = (hesEmpty, hesUsed);

  THashEntry = record
    Key: string;
    Value: Integer;
    State: THashEntryState;
  end;

  TStringIntHashMap = class
  private
    FEntries: array of THashEntry;
    FCount: Integer;
    FCapacity: Integer;
    function HashKey(const Key: string): Cardinal;
    function SameKey(const A, B: string): Boolean;
    procedure Grow;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(const Key: string; Value: Integer);
    function IndexOf(const Key: string): Integer;
    procedure Clear;
    property Count: Integer read FCount;
  end;

  TSardValue = class;

  TSardValueArray = array of TSardValue;

  { Built-in function handler signature used by optional libraries.
    Interp is passed as TObject to avoid a circular unit reference; the
    dispatcher in SardInterp passes the interpreter instance directly. }
  TBuiltinHandler = function(Interp: TObject; Scope: TSardValue;
    Args: array of TSardValue; Blocks: TASTNode): TSardValue;

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
    IsDate: Boolean;
    IsNone: Boolean;
    Name: string;
    Op: string;
    Children: array of TASTNode;
    FChildCount: Integer;
    Left, Right: TASTNode;
    Typ: string;
    Params: TStringArray;
    ParamTypes: TStringArray;
    ParamDefaults: TASTNodeArray;
    ParamOpen: array of Boolean;
    OpenParamIndex: Integer;
    ReturnType: string;
    HasParamList: Boolean;
    constructor Create(AKind: TNodeKind; const AText: string; ALine, ACol: Integer);
    destructor Destroy; override;
    procedure AddChild(Child: TASTNode);
    procedure ClearChildren;
    function IsLValue: Boolean;
    function DeepClone: TASTNode;
    property ChildCount: Integer read FChildCount;
  end;
  
  { Runtime Value Object }
  TSardValue = class
  private
    FArrayItems: TList;
    FMembers: TStringList;
    FMemberMap: TStringIntHashMap;
    FParams: TStringList;
    FParamTypes: TStringList;
    function GetArrayItems: TList;
    function GetMembers: TStringList;
    function GetParams: TStringList;
    function GetParamTypes: TStringList;
    procedure RebuildMemberMap;
  public
    RefCount: Integer;
    IsSingleton: Boolean;
    Kind: TValueKind;
    IntValue: Int64;
    FloatValue: Double;
    StrValue: string;
    BoolValue: Boolean;
    ColorValue: LongWord;
    CurrencyValue: Int64;
    Parent: TSardValue;
    Callable: Boolean;
    ParamDefaults: array of TASTNode;
    ParamOpen: array of Boolean;
    OpenParamIndex: Integer;
    ReturnType: string;
    Body: TASTNode;
    DeclaredType: string;
    BuiltinName: string;
    BuiltinHandler: TBuiltinHandler;
    LazyArgIndexes: array of Integer; { argument positions passed as vkLazy AST wrappers }
    IsScope: Boolean;
    LazyNode: TASTNode; { for vkLazy values: condition expression to re-evaluate }
    property ArrayItems: TList read GetArrayItems;
    property Members: TStringList read GetMembers;
    property Params: TStringList read GetParams;
    property ParamTypes: TStringList read GetParamTypes;
    constructor Create;
    destructor Destroy; override;
    procedure AddRef;
    procedure Release;
    procedure SetParent(P: TSardValue);
    function Clone(Deep: Boolean = True): TSardValue;
    procedure SetMember(const Name: string; Value: TSardValue);
    procedure SetMemberAt(Index: Integer; Value: TSardValue);
    function GetMember(const Name: string): TSardValue;
    function FindLocalMember(const Name: string; out Index: Integer): Boolean;
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
{$ifndef FPC}
function BoolToStr(B: boolean; const TrueStr, FalseStr: string): string;
{$endif}

{ Shared immutable singletons. These are never freed. }
var
  ValueTrue: TSardValue;
  ValueFalse: TSardValue;
  ValueNone: TSardValue;

function BooleanValue(V: Boolean): TSardValue;
function NullValue: TSardValue;

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
  {$ifdef FPC}  
  Str(K, Result);
  {$else}
  Result := TRttiEnumerationType.GetName<TTokenKind>(K)
  {$endif}  
end;

{$ifndef FPC}
function BoolToStr(B: boolean; const TrueStr, FalseStr: string): string;
begin
  if B then Result := TrueStr else Result := FalseStr;
end;
{$endif}

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
    IsDate := False;
    IsNone := False;
    Name := '';
   Op := '';
    Typ := '';
    ReturnType := '';
     OpenParamIndex := -1;
     FChildCount := 0;
   end;

destructor TASTNode.Destroy;
var
  I: Integer;
begin
  for I := 0 to FChildCount - 1 do
    Children[I].Free;
  for I := 0 to High(ParamDefaults) do
    ParamDefaults[I].Free;
  Left.Free;
  Right.Free;
  inherited;
end;

procedure TASTNode.AddChild(Child: TASTNode);
var
  N, Cap: Integer;
begin
  N := FChildCount;
  Cap := Length(Children);
  if N >= Cap then
  begin
    if Cap < 4 then Cap := 4 else Cap := Cap * 2;
    SetLength(Children, Cap);
  end;
  Children[N] := Child;
  Inc(FChildCount);
end;

procedure TASTNode.ClearChildren;
begin
  FChildCount := 0;
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
   Result.IsDate := IsDate;
   Result.IsNone := IsNone;
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
  SetLength(Result.ParamDefaults, Length(ParamDefaults));
  for I := 0 to High(ParamDefaults) do
    if ParamDefaults[I] <> nil then
      Result.ParamDefaults[I] := ParamDefaults[I].DeepClone;
  SetLength(Result.ParamOpen, Length(ParamOpen));
  for I := 0 to High(ParamOpen) do
    Result.ParamOpen[I] := ParamOpen[I];
  Result.OpenParamIndex := OpenParamIndex;
  Result.HasParamList := HasParamList;
  if Left <> nil then Result.Left := Left.DeepClone;
  if Right <> nil then Result.Right := Right.DeepClone;
  SetLength(Result.Children, FChildCount);
  Result.FChildCount := FChildCount;
  for I := 0 to FChildCount - 1 do
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
    nkTypeCast: K := 'TypeCast';
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
  for I := 0 to Node.ChildCount - 1 do
    DumpAST(Node.Children[I], Indent + 1);
end;

{ TStringIntHashMap }

function TStringIntHashMap.HashKey(const Key: string): Cardinal;
var
  I: Integer;
  C: Char;
begin
  Result := 5381;
  for I := 1 to Length(Key) do
  begin
    C := Key[I];
    if (C >= 'A') and (C <= 'Z') then
      C := Char(Ord(C) + 32);
    Result := ((Result shl 5) + Result) xor Ord(C);
  end;
end;

function TStringIntHashMap.SameKey(const A, B: string): Boolean;
begin
  Result := SameText(A, B);
end;

constructor TStringIntHashMap.Create;
begin
  inherited;
  FCapacity := 16;
  SetLength(FEntries, FCapacity);
  FCount := 0;
end;

destructor TStringIntHashMap.Destroy;
begin
  SetLength(FEntries, 0);
  inherited;
end;

procedure TStringIntHashMap.Grow;
var
  OldEntries: array of THashEntry;
  I: Integer;
begin
  OldEntries := FEntries;
  FCapacity := FCapacity * 2;
  SetLength(FEntries, FCapacity);
  FCount := 0;
  for I := 0 to High(OldEntries) do
    if OldEntries[I].State = hesUsed then
      Add(OldEntries[I].Key, OldEntries[I].Value);
end;

function TStringIntHashMap.IndexOf(const Key: string): Integer;
var
  H, Slot: Cardinal;
begin
  if FCount = 0 then
  begin
    Result := -1;
    Exit;
  end;
  H := HashKey(Key);
  Slot := H mod Cardinal(FCapacity);
  while FEntries[Slot].State <> hesEmpty do
  begin
    if (FEntries[Slot].State = hesUsed) and SameKey(FEntries[Slot].Key, Key) then
    begin
      Result := FEntries[Slot].Value;
      Exit;
    end;
    Slot := (Slot + 1) mod Cardinal(FCapacity);
  end;
  Result := -1;
end;

procedure TStringIntHashMap.Add(const Key: string; Value: Integer);
var
  H, Slot: Cardinal;
begin
  if FCount * 2 >= FCapacity then Grow;
  H := HashKey(Key);
  Slot := H mod Cardinal(FCapacity);
  while FEntries[Slot].State = hesUsed do
  begin
    if SameKey(FEntries[Slot].Key, Key) then
    begin
      FEntries[Slot].Value := Value;
      Exit;
    end;
    Slot := (Slot + 1) mod Cardinal(FCapacity);
  end;
  FEntries[Slot].State := hesUsed;
  FEntries[Slot].Key := Key;
  FEntries[Slot].Value := Value;
  Inc(FCount);
end;

procedure TStringIntHashMap.Clear;
var
  I: Integer;
begin
  for I := 0 to High(FEntries) do
    FEntries[I].State := hesEmpty;
  FCount := 0;
end;

{ TSardValue }

function TSardValue.GetArrayItems: TList;
begin
  if FArrayItems = nil then
    FArrayItems := TList.Create;
  Result := FArrayItems;
end;

function TSardValue.GetMembers: TStringList;
begin
  if FMembers = nil then
  begin
    FMembers := TStringList.Create;
    FMembers.CaseSensitive := False;
    if FMemberMap = nil then
      FMemberMap := TStringIntHashMap.Create;
  end;
  Result := FMembers;
end;

function TSardValue.GetParams: TStringList;
begin
  if FParams = nil then
    FParams := TStringList.Create;
  Result := FParams;
end;

function TSardValue.GetParamTypes: TStringList;
begin
  if FParamTypes = nil then
    FParamTypes := TStringList.Create;
  Result := FParamTypes;
end;

constructor TSardValue.Create;
begin
  inherited;
  RefCount := 1;
  IsSingleton := False;
  Kind := vkNull;
  FArrayItems := nil;
  FMembers := nil;
  FMemberMap := nil;
  FParams := nil;
  FParamTypes := nil;
  Parent := nil;
    Callable := False;
    Body := nil;
    DeclaredType := '';
    IsScope := False;
    BuiltinHandler := nil;
    SetLength(LazyArgIndexes, 0);
    LazyNode := nil;
    OpenParamIndex := -1;
  end;

procedure TSardValue.AddRef;
begin
  Inc(RefCount);
end;

procedure TSardValue.Release;
begin
  Dec(RefCount);
  if IsSingleton then Exit;
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
  if FMembers <> nil then
  begin
    for I := 0 to FMembers.Count - 1 do
    begin
      V := TSardValue(FMembers.Objects[I]);
      if V <> nil then V.Release;
    end;
    FMembers.Free;
  end;
  if FMemberMap <> nil then
    FMemberMap.Free;
  if FArrayItems <> nil then
  begin
    for I := 0 to FArrayItems.Count - 1 do
    begin
      V := TSardValue(FArrayItems[I]);
      if V <> nil then V.Release;
    end;
    FArrayItems.Free;
  end;
  if FParams <> nil then FParams.Free;
  if FParamTypes <> nil then FParamTypes.Free;
  for I := 0 to High(ParamDefaults) do
    ParamDefaults[I].Free;
  Body.Free;
  inherited;
end;

procedure TSardValue.RebuildMemberMap;
var
  I: Integer;
begin
  if FMemberMap = nil then
    FMemberMap := TStringIntHashMap.Create;
  FMemberMap.Clear;
  if FMembers <> nil then
    for I := 0 to FMembers.Count - 1 do
      FMemberMap.Add(FMembers[I], I);
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
  if FParams <> nil then
    Result.Params.Text := FParams.Text;
  if FParamTypes <> nil then
    Result.ParamTypes.Text := FParamTypes.Text;
  SetLength(Result.ParamDefaults, Length(ParamDefaults));
  for I := 0 to High(ParamDefaults) do
    if ParamDefaults[I] <> nil then
      Result.ParamDefaults[I] := ParamDefaults[I].DeepClone;
  SetLength(Result.ParamOpen, Length(ParamOpen));
  for I := 0 to High(ParamOpen) do
    Result.ParamOpen[I] := ParamOpen[I];
  Result.OpenParamIndex := OpenParamIndex;
  Result.ReturnType := ReturnType;
    Result.DeclaredType := DeclaredType;
    Result.BuiltinName := BuiltinName;
    Result.BuiltinHandler := BuiltinHandler;
    SetLength(Result.LazyArgIndexes, Length(LazyArgIndexes));
    for I := 0 to High(LazyArgIndexes) do
      Result.LazyArgIndexes[I] := LazyArgIndexes[I];
    Result.IsScope := IsScope;
  if Body <> nil then
    Result.Body := Body.DeepClone;
  if Deep then
  begin
    Result.Parent := nil;
    if FArrayItems <> nil then
      for I := 0 to FArrayItems.Count - 1 do
      begin
        V := TSardValue(FArrayItems[I]);
        if V <> nil then
          Result.ArrayItems.Add(V.Clone(True));
      end;
    if FMembers <> nil then
      for I := 0 to FMembers.Count - 1 do
      begin
        V := TSardValue(FMembers.Objects[I]);
        if V <> nil then
          Result.Members.AddObject(FMembers[I], V.Clone(True));
      end;
  end
  else
  begin
    Result.Parent := Parent;
    if FArrayItems <> nil then
      for I := 0 to FArrayItems.Count - 1 do
      begin
        V := TSardValue(FArrayItems[I]);
        if V <> nil then V.AddRef;
        Result.ArrayItems.Add(V);
      end;
    if FMembers <> nil then
      for I := 0 to FMembers.Count - 1 do
      begin
        V := TSardValue(FMembers.Objects[I]);
        if V <> nil then V.AddRef;
        Result.Members.AddObject(FMembers[I], V);
      end;
  end;
  Result.RebuildMemberMap;
end;

procedure TSardValue.SetMember(const Name: string; Value: TSardValue);
var
  Idx: Integer;
  Old: TSardValue;
begin
  Idx := -1;
  if FMemberMap <> nil then
    Idx := FMemberMap.IndexOf(Name);
  if Idx >= 0 then
  begin
    Old := TSardValue(FMembers.Objects[Idx]);
    if Old <> nil then Old.Release;
    FMembers.Objects[Idx] := Value;
  end
  else
  begin
    Members.AddObject(Name, Value);
    FMemberMap.Add(Name, Members.Count - 1);
  end;
  if Value <> nil then Value.AddRef;
end;

procedure TSardValue.SetMemberAt(Index: Integer; Value: TSardValue);
var
  Old: TSardValue;
begin
  Old := TSardValue(FMembers.Objects[Index]);
  if Old <> nil then Old.Release;
  FMembers.Objects[Index] := Value;
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
    Idx := Curr.Members.IndexOf(Name);
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
  Result := (FMemberMap <> nil) and (FMemberMap.IndexOf(Name) >= 0);
end;

function TSardValue.FindLocalMember(const Name: string; out Index: Integer): Boolean;
begin
  if FMemberMap = nil then
  begin
    Index := -1;
    Result := False;
  end
  else
  begin
    Index := FMemberMap.IndexOf(Name);
    Result := Index >= 0;
  end;
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
    vkDate: Result := 'date';
    vkArray: Result := 'array';
    vkObject: Result := 'object';
    vkLazy: Result := 'lazy';
  else
    Result := 'unknown';
  end;
end;

function BooleanValue(V: Boolean): TSardValue;
begin
  if V then Result := ValueTrue else Result := ValueFalse;
end;

function NullValue: TSardValue;
begin
  Result := ValueNone;
end;

function TSardValue.AsString: string;
var
  I: Integer;
  S: string;
  V: TSardValue;
begin
  case Kind of
    vkNull: Result := 'none';
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
    vkDate: Result := FormatDateTime('yyyy-mm-dd hh:nn:ss', FloatValue);
    vkArray:
      begin
        S := '[';
        if FArrayItems <> nil then
        begin
          for I := 0 to FArrayItems.Count - 1 do
          begin
            if I > 0 then S := S + ', ';
            V := TSardValue(FArrayItems[I]);
            if V <> nil then S := S + V.AsString;
          end;
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

initialization
  ValueTrue := TSardValue.Create;
  ValueTrue.Kind := vkBoolean;
  ValueTrue.BoolValue := True;
  ValueTrue.IsSingleton := True;

  ValueFalse := TSardValue.Create;
  ValueFalse.Kind := vkBoolean;
  ValueFalse.BoolValue := False;
  ValueFalse.IsSingleton := True;

  ValueNone := TSardValue.Create;
  ValueNone.Kind := vkNull;
  ValueNone.IsSingleton := True;

end.
