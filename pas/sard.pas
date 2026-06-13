program Sard;

{$mode objfpc}{$H+}

uses
  SysUtils, Classes, SardTypes, SardLexer, SardParser, SardInterp;

var
  Source, FileName: string;
  Lexer: TLexer;
  Parser: TParser;
  AST: TASTNode;
  Interp: TInterpreter;
  SL: TStringList;
begin
  if ParamCount < 1 then
  begin
    WriteLn('Usage: sard <file.sard>');
    Halt(1);
  end;

  FileName := ParamStr(1);
  SL := TStringList.Create;
  try
    SL.LoadFromFile(FileName);
    Source := SL.Text;
  finally
    SL.Free;
  end;

  Lexer := TLexer.Create(Source);
  try
    Parser := TParser.Create(Lexer);
    try
      AST := Parser.ParseProgram;
      try
        Interp := TInterpreter.Create;
        try
          Interp.Execute(AST);
        finally
          Interp.Free;
        end;
      finally
        AST.Free;
      end;
    finally
      Parser.Free;
    end;
  finally
    Lexer.Free;
  end;
end.
