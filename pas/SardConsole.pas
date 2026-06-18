unit SardConsole;

{$ifdef FPC}
{$mode objfpc}{$H+}
{$endif}

interface

uses
  SysUtils, Classes,
  SardTypes, SardLexer, SardParser, SardInterp, SardMath;

procedure RunConsole;

implementation

procedure Run;
var
  Source, FileName: string;
  Lexer: TLexer;
  Parser: TParser;
  AST: TASTNode;
  Interp: TInterpreter;
  MathLib: TMathLibrary;
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
      //DumpAST(AST, 0);
      try
        Interp := TInterpreter.Create;
        try
          MathLib := TMathLibrary.Create;
          try
            MathLib.RegisterIn(Interp);
          finally
            MathLib.Free;
          end;
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
end;

procedure RunConsole;
begin
  try
    Run;
  except
    on E: ESardError do
    begin
      WriteLn(E.Message);
      Halt(1);
    end;
    on E: Exception do
    begin
      WriteLn('Error: ', E.Message);
      Halt(1);
    end;
  end;
end;

end.
