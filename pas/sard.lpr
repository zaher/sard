program sard;

{$mode objfpc}{$H+}

uses
  SysUtils,
  sard_lexer in 'sard_lexer.pas',
  sard_parser in 'sard_parser.pas',
  sard_ast in 'sard_ast.pas',
  sard_objects in 'sard_objects.pas',
  sard_interpreter in 'sard_interpreter.pas',
  sard_errors in 'sard_errors.pas';

var
  Interp: TSardInterpreter;
  Source: string;
  FileName: string;
  F: TextFile;
  LineBuf: string;

procedure PrintResult(const S: string);
begin
  WriteLn(S);
end;

begin
  if ParamCount < 1 then
  begin
    WriteLn('Usage: sard <filename>');
    Halt(1);
  end;

  FileName := ParamStr(1);
  if not FileExists(FileName) then
  begin
    WriteLn('Error: File not found: ' + FileName);
    Halt(1);
  end;

  AssignFile(F, FileName);
  try
    Reset(F);
    Source := '';
    while not EOF(F) do
    begin
      ReadLn(F, LineBuf);
      if Source <> '' then
        Source := Source + #10;
      Source := Source + LineBuf;
    end;
    CloseFile(F);
  except
    on E: Exception do
    begin
      WriteLn('Error reading file: ' + E.Message);
      Halt(1);
    end;
  end;

  Interp := TSardInterpreter.Create;
  try
    Interp.SetOutput(@PrintResult);
    try
      Interp.Run(Source, FileName);
    except
      on E: ESardLexerError do
        WriteLn('Lexer error: ' + E.Message);
      on E: ESardParseError do
        WriteLn('Parse error: ' + E.Message);
      on E: ESardRuntimeError do
        WriteLn('Runtime error: ' + E.Message);
      on E: Exception do
        WriteLn('Error: ' + E.Message);
    end;
  finally
    Interp.Free;
  end;
end.