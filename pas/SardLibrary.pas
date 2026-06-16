unit SardLibrary;

{$ifdef FPC}
{$mode objfpc}{$H+}
{$endif}

interface

uses
  SysUtils, Classes, SardTypes, SardInterp;

type
  { Base class for optional Sard libraries. Inherit from this, override
    RegisterIn, and call Interp.RegisterBuiltin for each function you expose. }
  TSardLibrary = class
  public
    procedure RegisterIn(Interp: TInterpreter); virtual; abstract;
  end;

{ Argument helpers ----------------------------------------------------------- }

function ArgCount(Args: array of TSardValue): Integer;
function HasArg(Args: array of TSardValue; Index: Integer): Boolean;

function ArgAsNumber(Interp: TInterpreter; Args: array of TSardValue;
  Index: Integer): Double;
function ArgAsInteger(Interp: TInterpreter; Args: array of TSardValue;
  Index: Integer): Int64;
function ArgAsString(Interp: TInterpreter; Args: array of TSardValue;
  Index: Integer): string;
function ArgAsBoolean(Interp: TInterpreter; Args: array of TSardValue;
  Index: Integer): Boolean;

{ Result helpers ------------------------------------------------------------- }

function NewNull(Interp: TInterpreter): TSardValue;
function NewInteger(Interp: TInterpreter; V: Int64): TSardValue;
function NewNumber(Interp: TInterpreter; V: Double): TSardValue;
function NewString(Interp: TInterpreter; const V: string): TSardValue;
function NewBoolean(Interp: TInterpreter; V: Boolean): TSardValue;

implementation

{ TSardLibrary }

{ No implementation: abstract base. }

{ Argument helpers ----------------------------------------------------------- }

function ArgCount(Args: array of TSardValue): Integer;
begin
  Result := Length(Args);
end;

function HasArg(Args: array of TSardValue; Index: Integer): Boolean;
begin
  Result := (Index >= 0) and (Index <= High(Args)) and (Args[Index] <> nil);
end;

function ArgAsNumber(Interp: TInterpreter; Args: array of TSardValue;
  Index: Integer): Double;
var
  Arg: TSardValue;
  Coerced: TSardValue;
begin
  if not HasArg(Args, Index) then
    raise ESardError.CreateFmt('Argument %d is required', [Index + 1]);
  Arg := Args[Index];
  case Arg.Kind of
    vkInteger: Result := Arg.IntValue;
    vkNumber:  Result := Arg.FloatValue;
    vkCurrency: Result := Arg.CurrencyValue / 1000000.0;
    vkString:
      begin
        Coerced := Interp.CoerceValue(Arg, 'number');
        try
          Result := Coerced.FloatValue;
        finally
          Coerced.Release;
        end;
      end;
  else
    raise ESardError.CreateFmt('Argument %d must be numeric, got %s',
      [Index + 1, Arg.KindName]);
  end;
end;

function ArgAsInteger(Interp: TInterpreter; Args: array of TSardValue;
  Index: Integer): Int64;
var
  Arg: TSardValue;
  Coerced: TSardValue;
begin
  if not HasArg(Args, Index) then
    raise ESardError.CreateFmt('Argument %d is required', [Index + 1]);
  Arg := Args[Index];
  case Arg.Kind of
    vkInteger: Result := Arg.IntValue;
    vkNumber:  Result := Trunc(Arg.FloatValue);
    vkCurrency: Result := Arg.CurrencyValue div 1000000;
    vkString:
      begin
        Coerced := Interp.CoerceValue(Arg, 'integer');
        try
          Result := Coerced.IntValue;
        finally
          Coerced.Release;
        end;
      end;
  else
    raise ESardError.CreateFmt('Argument %d must be an integer, got %s',
      [Index + 1, Arg.KindName]);
  end;
end;

function ArgAsString(Interp: TInterpreter; Args: array of TSardValue;
  Index: Integer): string;
var
  Arg: TSardValue;
begin
  if not HasArg(Args, Index) then
    raise ESardError.CreateFmt('Argument %d is required', [Index + 1]);
  Arg := Args[Index];
  Result := Arg.AsString;
end;

function ArgAsBoolean(Interp: TInterpreter; Args: array of TSardValue;
  Index: Integer): Boolean;
var
  Arg: TSardValue;
begin
  if not HasArg(Args, Index) then
    raise ESardError.CreateFmt('Argument %d is required', [Index + 1]);
  Arg := Args[Index];
  Result := Interp.IsTruthy(Arg);
end;

{ Result helpers ------------------------------------------------------------- }

function NewNull(Interp: TInterpreter): TSardValue;
begin
  Result := Interp.NewValue;
  Result.Kind := vkNull;
end;

function NewInteger(Interp: TInterpreter; V: Int64): TSardValue;
begin
  Result := Interp.NewValue;
  Result.Kind := vkInteger;
  Result.IntValue := V;
end;

function NewNumber(Interp: TInterpreter; V: Double): TSardValue;
begin
  Result := Interp.NewValue;
  Result.Kind := vkNumber;
  Result.FloatValue := V;
end;

function NewString(Interp: TInterpreter; const V: string): TSardValue;
begin
  Result := Interp.NewValue;
  Result.Kind := vkString;
  Result.StrValue := V;
end;

function NewBoolean(Interp: TInterpreter; V: Boolean): TSardValue;
begin
  Result := Interp.NewValue;
  Result.Kind := vkBoolean;
  Result.BoolValue := V;
end;

end.
