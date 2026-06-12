unit sard_errors;

{$mode objfpc}{$H+}{$J-}

interface

uses
  SysUtils;

type
  ESardError = class(Exception)
  public
    Line: Integer;
    Column: Integer;
    constructor Create(const AMsg: string; ALine: Integer = 0; ACol: Integer = 0);
  end;

  ESardLexerError = class(ESardError);
  ESardParseError = class(ESardError);
  ESardRuntimeError = class(ESardError);

implementation

constructor ESardError.Create(const AMsg: string; ALine: Integer; ACol: Integer);
begin
  inherited Create(AMsg);
  Line := ALine;
  Column := ACol;
end;

end.