unit SardMath;

{$ifdef FPC}
{$mode objfpc}{$H+}
{$endif}

{ Optional math library for Sard.

  Usage:
    Interp := TInterpreter.Create;
    TMathLibrary.Create.RegisterIn(Interp);
    // now scripts can call sin, cos, sqrt, pi, etc.

  This unit is intended as a template: copy it, rename TMathLibrary, and add
  your own functions to build a custom library. }

interface

uses
  SysUtils, Math, SardTypes, SardInterp, SardLibrary;

type
  TMathLibrary = class(TSardLibrary)
  public
    procedure RegisterIn(Interp: TInterpreter); override;
  end;

implementation

{ Trigonometry --------------------------------------------------------------- }

function BuiltInSin(Interp: TObject; Scope: TSardValue;
  Args: TSardValueArray; Blocks: TASTNode): TSardValue;
var
  InterpObj: TInterpreter;
begin
  InterpObj := TInterpreter(Interp);
  Result := NewNumber(InterpObj, Sin(ArgAsNumber(InterpObj, Args, 0)));
end;

function BuiltInCos(Interp: TObject; Scope: TSardValue;
  Args: TSardValueArray; Blocks: TASTNode): TSardValue;
var
  InterpObj: TInterpreter;
begin
  InterpObj := TInterpreter(Interp);
  Result := NewNumber(InterpObj, Cos(ArgAsNumber(InterpObj, Args, 0)));
end;

function BuiltInTan(Interp: TObject; Scope: TSardValue;
  Args: TSardValueArray; Blocks: TASTNode): TSardValue;
var
  InterpObj: TInterpreter;
  V: Double;
begin
  InterpObj := TInterpreter(Interp);
  V := ArgAsNumber(InterpObj, Args, 0);
  if Cos(V) = 0 then
    raise ESardError.Create('tan is undefined for this value');
  Result := NewNumber(InterpObj, Tan(V));
end;

{ Powers, roots, logarithms -------------------------------------------------- }

function BuiltInSqrt(Interp: TObject; Scope: TSardValue;
  Args: TSardValueArray; Blocks: TASTNode): TSardValue;
var
  InterpObj: TInterpreter;
  V: Double;
begin
  InterpObj := TInterpreter(Interp);
  V := ArgAsNumber(InterpObj, Args, 0);
  if V < 0 then
    raise ESardError.Create('sqrt of negative number');
  Result := NewNumber(InterpObj, Sqrt(V));
end;

function BuiltInPower(Interp: TObject; Scope: TSardValue;
  Args: TSardValueArray; Blocks: TASTNode): TSardValue;
var
  InterpObj: TInterpreter;
  Base, Exponent: Double;
begin
  InterpObj := TInterpreter(Interp);
  Base := ArgAsNumber(InterpObj, Args, 0);
  Exponent := ArgAsNumber(InterpObj, Args, 1);
  Result := NewNumber(InterpObj, Power(Base, Exponent));
end;

function BuiltInExp(Interp: TObject; Scope: TSardValue;
  Args: TSardValueArray; Blocks: TASTNode): TSardValue;
var
  InterpObj: TInterpreter;
begin
  InterpObj := TInterpreter(Interp);
  Result := NewNumber(InterpObj, Exp(ArgAsNumber(InterpObj, Args, 0)));
end;

function BuiltInLn(Interp: TObject; Scope: TSardValue;
  Args: TSardValueArray; Blocks: TASTNode): TSardValue;
var
  InterpObj: TInterpreter;
  V: Double;
begin
  InterpObj := TInterpreter(Interp);
  V := ArgAsNumber(InterpObj, Args, 0);
  if V <= 0 then
    raise ESardError.Create('ln requires a positive number');
  Result := NewNumber(InterpObj, Ln(V));
end;

function BuiltInLog(Interp: TObject; Scope: TSardValue;
  Args: TSardValueArray; Blocks: TASTNode): TSardValue;
var
  InterpObj: TInterpreter;
  V: Double;
begin
  InterpObj := TInterpreter(Interp);
  V := ArgAsNumber(InterpObj, Args, 0);
  if V <= 0 then
    raise ESardError.Create('log requires a positive number');
  Result := NewNumber(InterpObj, Log10(V));
end;

{ Rounding and absolute value ------------------------------------------------ }

function BuiltInAbs(Interp: TObject; Scope: TSardValue;
  Args: TSardValueArray; Blocks: TASTNode): TSardValue;
var
  InterpObj: TInterpreter;
  V: Double;
begin
  InterpObj := TInterpreter(Interp);
  V := ArgAsNumber(InterpObj, Args, 0);
  Result := NewNumber(InterpObj, Abs(V));
end;

function BuiltInFloor(Interp: TObject; Scope: TSardValue;
  Args: TSardValueArray; Blocks: TASTNode): TSardValue;
var
  InterpObj: TInterpreter;
  V: Double;
begin
  InterpObj := TInterpreter(Interp);
  V := ArgAsNumber(InterpObj, Args, 0);
  Result := NewNumber(InterpObj, Double(Math.Floor(V)));
end;

function BuiltInCeil(Interp: TObject; Scope: TSardValue;
  Args: TSardValueArray; Blocks: TASTNode): TSardValue;
var
  InterpObj: TInterpreter;
  V: Double;
begin
  InterpObj := TInterpreter(Interp);
  V := ArgAsNumber(InterpObj, Args, 0);
  Result := NewNumber(InterpObj, Double(Math.Ceil(V)));
end;

function BuiltInRound(Interp: TObject; Scope: TSardValue;
  Args: TSardValueArray; Blocks: TASTNode): TSardValue;
var
  InterpObj: TInterpreter;
  V: Double;
begin
  InterpObj := TInterpreter(Interp);
  V := ArgAsNumber(InterpObj, Args, 0);
  Result := NewInteger(InterpObj, Int64(Round(V)));
end;

{ Min / max ------------------------------------------------------------------ }

function BuiltInMin(Interp: TObject; Scope: TSardValue;
  Args: TSardValueArray; Blocks: TASTNode): TSardValue;
var
  InterpObj: TInterpreter;
  I: Integer;
  Best, V: Double;
begin
  InterpObj := TInterpreter(Interp);
  if Length(Args) < 1 then
    raise ESardError.Create('min requires at least one argument');
  Best := ArgAsNumber(InterpObj, Args, 0);
  for I := 1 to High(Args) do
  begin
    V := ArgAsNumber(InterpObj, Args, I);
    if V < Best then Best := V;
  end;
  Result := NewNumber(InterpObj, Best);
end;

function BuiltInMax(Interp: TObject; Scope: TSardValue;
  Args: TSardValueArray; Blocks: TASTNode): TSardValue;
var
  InterpObj: TInterpreter;
  I: Integer;
  Best, V: Double;
begin
  InterpObj := TInterpreter(Interp);
  if Length(Args) < 1 then
    raise ESardError.Create('max requires at least one argument');
  Best := ArgAsNumber(InterpObj, Args, 0);
  for I := 1 to High(Args) do
  begin
    V := ArgAsNumber(InterpObj, Args, I);
    if V > Best then Best := V;
  end;
  Result := NewNumber(InterpObj, Best);
end;

{ Constants and random ------------------------------------------------------- }

function BuiltInPi(Interp: TObject; Scope: TSardValue;
  Args: TSardValueArray; Blocks: TASTNode): TSardValue;
var
  InterpObj: TInterpreter;
begin
  InterpObj := TInterpreter(Interp);
  Result := NewNumber(InterpObj, Pi);
end;

function BuiltInRandom(Interp: TObject; Scope: TSardValue;
  Args: TSardValueArray; Blocks: TASTNode): TSardValue;
var
  InterpObj: TInterpreter;
  MaxValue: Integer;
begin
  InterpObj := TInterpreter(Interp);
  if Length(Args) = 0 then
    Result := NewNumber(InterpObj, Random)
  else
  begin
    MaxValue := Integer(ArgAsInteger(InterpObj, Args, 0));
    if MaxValue <= 0 then
      raise ESardError.Create('random(n) requires n > 0');
    Result := NewInteger(InterpObj, Random(MaxValue));
  end;
end;

{ Registration --------------------------------------------------------------- }

procedure TMathLibrary.RegisterIn(Interp: TInterpreter);
begin
  Randomize; { seed the RNG once when the library is loaded }

  Interp.RegisterBuiltin('sin',    @BuiltInSin);
  Interp.RegisterBuiltin('cos',    @BuiltInCos);
  Interp.RegisterBuiltin('tan',    @BuiltInTan);
  Interp.RegisterBuiltin('sqrt',   @BuiltInSqrt);
  Interp.RegisterBuiltin('power',  @BuiltInPower);
  Interp.RegisterBuiltin('exp',    @BuiltInExp);
  Interp.RegisterBuiltin('ln',     @BuiltInLn);
  Interp.RegisterBuiltin('log',    @BuiltInLog);
  Interp.RegisterBuiltin('abs',    @BuiltInAbs);
  Interp.RegisterBuiltin('floor',  @BuiltInFloor);
  Interp.RegisterBuiltin('ceil',   @BuiltInCeil);
  Interp.RegisterBuiltin('round',  @BuiltInRound);
  Interp.RegisterBuiltin('min',    @BuiltInMin);
  Interp.RegisterBuiltin('max',    @BuiltInMax);
  Interp.RegisterBuiltin('pi',     @BuiltInPi);
  Interp.RegisterBuiltin('random', @BuiltInRandom);
end;

end.
