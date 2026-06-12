unit sard_objects;

{$mode objfpc}{$H+}{$J-}

interface

uses
  SysUtils, Classes, sard_ast, sard_errors;

type
  TSardObjType = (
    objNull,
    objInteger,
    objNumber,
    objString,
    objBoolean,
    objColor,
    objCurrency,
    objArray,
    objCallable,
    objObject,
    objReference
  );

  TSardObjTypeSet = set of TSardObjType;

  PSardObject = ^TSardObject;

  TMemberEntry = record
    Key: string;
    Value: PSardObject;
  end;

  TMemberArray = array of TMemberEntry;
  TElementArray = array of PSardObject;

  TSardObject = record
    ObjType: TSardObjType;
    IntValue: Int64;
    FloatValue: Double;
    StrValue: string;
    BoolValue: Boolean;
    Members: TMemberArray;
    Parent: PSardObject;
    Params: TStringList;
    Body: PSardNode;
    IsCallable: Boolean;
    ScopeParent: PSardObject;
    Elements: TElementArray;
    ElementCount: Integer;
  end;

  TSardObjectTypeHelper = class
    class function TypeFromName(const Name: string): TSardObjType; static;
    class function TypeName(T: TSardObjType): string; static;
  end;

function SardNull: PSardObject;
function SardInteger(V: Int64): PSardObject;
function SardNumber(V: Double): PSardObject;
function SardString(const V: string): PSardObject;
function SardBoolean(V: Boolean): PSardObject;
function SardColor(V: Int64): PSardObject;
function SardCurrency(V: Int64): PSardObject;
function SardCallable: PSardObject;
function SardObjectNew: PSardObject;

function CreateSardObject: PSardObject;
procedure FreeSardObject(Obj: PSardObject);

function IsTruthy(Obj: PSardObject): Boolean;
function CoerceTo(Obj: PSardObject; TargetType: TSardObjType): PSardObject;

function ObjGetMember(Obj: PSardObject; const Name: string): PSardObject;
procedure ObjSetMember(Obj: PSardObject; const Name: string; Val: PSardObject);
function ObjLookup(Obj: PSardObject; const Name: string): PSardObject;
procedure ObjAssign(Obj: PSardObject; const Name: string; Val: PSardObject);
function ObjHas(Obj: PSardObject; const Name: string): Boolean;
function DeepCopy(Obj: PSardObject): PSardObject;

function ObjToString(Obj: PSardObject): string;
function ValuesEqual(Left, Right: PSardObject): Boolean;

implementation

class function TSardObjectTypeHelper.TypeFromName(const Name: string): TSardObjType;
var
  Lower: string;
begin
  Lower := LowerCase(Name);
  if Lower = 'integer' then Result := objInteger
  else if Lower = 'number' then Result := objNumber
  else if Lower = 'string' then Result := objString
  else if Lower = 'boolean' then Result := objBoolean
  else if Lower = 'color' then Result := objColor
  else if Lower = 'currency' then Result := objCurrency
  else if Lower = 'array' then Result := objArray
  else if Lower = 'object' then Result := objObject
  else Result := objNull;
end;

class function TSardObjectTypeHelper.TypeName(T: TSardObjType): string;
begin
  case T of
    objNull: Result := 'null';
    objInteger: Result := 'integer';
    objNumber: Result := 'number';
    objString: Result := 'string';
    objBoolean: Result := 'boolean';
    objColor: Result := 'color';
    objCurrency: Result := 'currency';
    objArray: Result := 'array';
    objCallable: Result := 'callable';
    objObject: Result := 'object';
    objReference: Result := 'reference';
  end;
end;

function CreateSardObject: PSardObject;
begin
  New(Result);
  FillChar(Result^, SizeOf(TSardObject), 0);
  Result^.ObjType := objNull;
  Result^.IntValue := 0;
  Result^.FloatValue := 0.0;
  Result^.StrValue := '';
  Result^.BoolValue := False;
  SetLength(Result^.Members, 0);
  Result^.Parent := nil;
  Result^.Params := TStringList.Create;
  Result^.Body := nil;
  Result^.IsCallable := False;
  Result^.ScopeParent := nil;
  Result^.ElementCount := 0;
  SetLength(Result^.Elements, 0);
end;

procedure FreeSardObject(Obj: PSardObject);
begin
  if Obj = nil then Exit;
  SetLength(Obj^.Members, 0);
  Obj^.Params.Free;
  SetLength(Obj^.Elements, 0);
  Obj^.ElementCount := 0;
  Dispose(Obj);
end;

function SardNull: PSardObject;
begin
  Result := CreateSardObject;
  Result^.ObjType := objNull;
end;

function SardInteger(V: Int64): PSardObject;
begin
  Result := CreateSardObject;
  Result^.ObjType := objInteger;
  Result^.IntValue := V;
end;

function SardNumber(V: Double): PSardObject;
begin
  Result := CreateSardObject;
  Result^.ObjType := objNumber;
  Result^.FloatValue := V;
end;

function SardString(const V: string): PSardObject;
begin
  Result := CreateSardObject;
  Result^.ObjType := objString;
  Result^.StrValue := V;
end;

function SardBoolean(V: Boolean): PSardObject;
begin
  Result := CreateSardObject;
  Result^.ObjType := objBoolean;
  Result^.BoolValue := V;
end;

function SardColor(V: Int64): PSardObject;
begin
  Result := CreateSardObject;
  Result^.ObjType := objColor;
  Result^.IntValue := V;
end;

function SardCurrency(V: Int64): PSardObject;
begin
  Result := CreateSardObject;
  Result^.ObjType := objCurrency;
  Result^.IntValue := V;
end;

function SardCallable: PSardObject;
begin
  Result := CreateSardObject;
  Result^.ObjType := objCallable;
  Result^.IsCallable := True;
end;

function SardObjectNew: PSardObject;
begin
  Result := CreateSardObject;
  Result^.ObjType := objObject;
end;

function IsTruthy(Obj: PSardObject): Boolean;
begin
  case Obj^.ObjType of
    objNull: Result := False;
    objBoolean: Result := Obj^.BoolValue;
    objInteger: Result := Obj^.IntValue <> 0;
    objNumber: Result := Obj^.FloatValue <> 0.0;
    objString: Result := Length(Obj^.StrValue) > 0;
    objCurrency: Result := Obj^.IntValue <> 0;
    objArray: Result := Obj^.ElementCount > 0;
  else
    Result := True;
  end;
end;

function CoerceTo(Obj: PSardObject; TargetType: TSardObjType): PSardObject;
var
  S: string;
begin
  if Obj^.ObjType = TargetType then
    Exit(Obj);

  case TargetType of
    objInteger:
    begin
      case Obj^.ObjType of
        objNumber: Result := SardInteger(Trunc(Obj^.FloatValue));
        objString:
        begin
          S := Trim(Obj^.StrValue);
          Result := SardInteger(StrToInt64Def(S, 0));
        end;
        objBoolean: Result := SardInteger(Ord(Obj^.BoolValue));
        objCurrency: Result := SardInteger(Obj^.IntValue div 1000000);
      else
        raise ESardRuntimeError.Create(
          Format('Cannot convert %s to integer', [TSardObjectTypeHelper.TypeName(Obj^.ObjType)]));
      end;
    end;
    objNumber:
    begin
      case Obj^.ObjType of
        objInteger: Result := SardNumber(Double(Obj^.IntValue));
        objString:
        begin
          S := Trim(Obj^.StrValue);
          Result := SardNumber(StrToFloatDef(S, 0.0));
        end;
        objCurrency: Result := SardNumber(Obj^.IntValue / 1000000.0);
      else
        raise ESardRuntimeError.Create(
          Format('Cannot convert %s to number', [TSardObjectTypeHelper.TypeName(Obj^.ObjType)]));
      end;
    end;
    objString:
      Result := SardString(ObjToString(Obj));
    objBoolean:
      Result := SardBoolean(IsTruthy(Obj));
  else
    raise ESardRuntimeError.Create(
      Format('Cannot convert %s to %s',
        [TSardObjectTypeHelper.TypeName(Obj^.ObjType),
         TSardObjectTypeHelper.TypeName(TargetType)]));
  end;
end;

function FindMemberIndex(Obj: PSardObject; const Name: string): Integer;
var
  I: Integer;
begin
  Result := -1;
  if Obj = nil then Exit;
  for I := 0 to Length(Obj^.Members) - 1 do
  begin
    if Obj^.Members[I].Key = Name then
    begin
      Result := I;
      Exit;
    end;
  end;
end;

function ObjGetMember(Obj: PSardObject; const Name: string): PSardObject;
var
  Idx: Integer;
begin
  Result := nil;
  if Obj = nil then Exit;
  Idx := FindMemberIndex(Obj, Name);
  if Idx >= 0 then
    Result := Obj^.Members[Idx].Value
  else if Obj^.Parent <> nil then
    Result := ObjGetMember(Obj^.Parent, Name);
end;

procedure ObjSetMember(Obj: PSardObject; const Name: string; Val: PSardObject);
var
  Idx: Integer;
begin
  if Obj = nil then Exit;
  Idx := FindMemberIndex(Obj, Name);
  if Idx >= 0 then
    Obj^.Members[Idx].Value := Val
  else
  begin
    SetLength(Obj^.Members, Length(Obj^.Members) + 1);
    Obj^.Members[Length(Obj^.Members) - 1].Key := Name;
    Obj^.Members[Length(Obj^.Members) - 1].Value := Val;
  end;
end;

function ObjLookup(Obj: PSardObject; const Name: string): PSardObject;
begin
  Result := ObjGetMember(Obj, Name);
  if (Result = nil) and (Obj^.ScopeParent <> nil) then
    Result := ObjLookup(Obj^.ScopeParent, Name);
end;

procedure ObjAssign(Obj: PSardObject; const Name: string; Val: PSardObject);
var
  LocalIdx: Integer;
begin
  LocalIdx := FindMemberIndex(Obj, Name);
  if LocalIdx >= 0 then
  begin
    Obj^.Members[LocalIdx].Value := Val;
  end
  else if (Obj^.ScopeParent <> nil) and ObjHas(Obj^.ScopeParent, Name) then
    ObjAssign(Obj^.ScopeParent, Name, Val)
  else
  begin
    SetLength(Obj^.Members, Length(Obj^.Members) + 1);
    Obj^.Members[Length(Obj^.Members) - 1].Key := Name;
    Obj^.Members[Length(Obj^.Members) - 1].Value := Val;
  end;
end;

function ObjHas(Obj: PSardObject; const Name: string): Boolean;
begin
  Result := False;
  if Obj = nil then Exit;
  if FindMemberIndex(Obj, Name) >= 0 then
    Result := True
  else if Obj^.ScopeParent <> nil then
    Result := ObjHas(Obj^.ScopeParent, Name);
end;

function DeepCopy(Obj: PSardObject): PSardObject;
var
  I: Integer;
  Len: Integer;
begin
  Result := CreateSardObject;
  Result^.ObjType := Obj^.ObjType;
  Result^.IntValue := Obj^.IntValue;
  Result^.FloatValue := Obj^.FloatValue;
  Result^.StrValue := Obj^.StrValue;
  Result^.BoolValue := Obj^.BoolValue;
  Result^.IsCallable := Obj^.IsCallable;
  Result^.Params.Assign(Obj^.Params);
  Result^.Body := Obj^.Body;
  Result^.ScopeParent := Obj^.ScopeParent;

  Len := Length(Obj^.Members);
  SetLength(Result^.Members, Len);
  for I := 0 to Len - 1 do
  begin
    Result^.Members[I].Key := Obj^.Members[I].Key;
    Result^.Members[I].Value := DeepCopy(Obj^.Members[I].Value);
  end;

  if Obj^.ObjType = objArray then
  begin
    Result^.ElementCount := Obj^.ElementCount;
    SetLength(Result^.Elements, Result^.ElementCount);
    for I := 0 to Result^.ElementCount - 1 do
      Result^.Elements[I] := DeepCopy(Obj^.Elements[I]);
  end;
end;

function ObjToString(Obj: PSardObject): string;
var
  I: Integer;
  S: string;
  Whole, Frac: Int64;
begin
  case Obj^.ObjType of
    objNull: Result := 'null';
    objInteger: Result := IntToStr(Obj^.IntValue);
    objNumber:
    begin
      S := FloatToStr(Obj^.FloatValue);
      Result := S;
    end;
    objString: Result := Obj^.StrValue;
    objBoolean:
      if Obj^.BoolValue then Result := 'true' else Result := 'false';
    objColor: Result := '#' + IntToHex(Obj^.IntValue, 6);
    objCurrency:
    begin
      Whole := Obj^.IntValue div 1000000;
      Frac := Obj^.IntValue mod 1000000;
      if Frac < 0 then Frac := -Frac;
      S := IntToStr(Whole) + '.' + Format('%.6d', [Frac]);
      while (Length(S) > 0) and (S[Length(S)] = '0') do
        Delete(S, Length(S), 1);
      if (Length(S) > 0) and (S[Length(S)] = '.') then
        Delete(S, Length(S), 1);
      Result := '$' + S;
    end;
    objArray:
    begin
      Result := '[';
      for I := 0 to Obj^.ElementCount - 1 do
      begin
        if I > 0 then Result := Result + ', ';
        Result := Result + ObjToString(Obj^.Elements[I]);
      end;
      Result := Result + ']';
    end;
    objCallable: Result := '<callable>';
  else
    Result := '<object>';
  end;
end;

function ValuesEqual(Left, Right: PSardObject): Boolean;
var
  LV, RV: Double;
begin
  if (Left^.ObjType = objNull) and (Right^.ObjType = objNull) then
    Exit(True);
  if (Left^.ObjType = objNull) or (Right^.ObjType = objNull) then
    Exit(False);
  if (Left^.ObjType = objString) or (Right^.ObjType = objString) then
    Exit(ObjToString(Left) = ObjToString(Right));
  if (Left^.ObjType in [objInteger, objNumber, objCurrency]) and
     (Right^.ObjType in [objInteger, objNumber, objCurrency]) then
  begin
    case Left^.ObjType of
      objInteger: LV := Left^.IntValue;
      objNumber: LV := Left^.FloatValue;
      objCurrency: LV := Left^.IntValue / 1000000.0;
    else
      LV := 0;
    end;
    case Right^.ObjType of
      objInteger: RV := Right^.IntValue;
      objNumber: RV := Right^.FloatValue;
      objCurrency: RV := Right^.IntValue / 1000000.0;
    else
      RV := 0;
    end;
    Exit(Abs(LV - RV) < 1e-10);
  end;
  if (Left^.ObjType = objBoolean) and (Right^.ObjType = objBoolean) then
    Exit(Left^.BoolValue = Right^.BoolValue);
  Result := False;
end;

end.