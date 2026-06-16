# Sard Script: Parallel Execution & Thread Safety

## Short answer

**Yes — the AST can be shared; the interpreter cannot.**

You can safely parse once and run the same `TASTNode` tree from multiple threads **as long as each thread uses its own `TInterpreter` instance**.

## Why the AST is shareable

- `TASTNode` is a plain object tree that becomes **read-only after parsing**.
- During execution, the interpreter only **reads** `Kind`, `Left`, `Right`, `Children`, `Name`, `Op`, `Params`, etc. It does not mutate the original AST.
- Places that need temporary nodes (e.g. synthetic `nkCall` wrappers in `EvalStatements` / `EvalIdentifier`) create local `TASTNode` instances and detach the borrowed AST child before freeing the wrapper.

## Why you must NOT share `TInterpreter`

`TInterpreter` is full of mutable per-execution state:

```pascal
FRoot: TSardValue;
FBreakDepth: Integer;
FReturnValue: TSardValue;
FHasReturn: Boolean;
FExitValue: TSardValue;
FHasExit: Boolean;
FNoAutoCall: Boolean;
```

- These fields are modified during every `Execute()` call.
- `Execute()` does not fully reset all of them between runs (for example, `FBreakDepth` and `FReturnValue` are not reset at the top), so reusing one interpreter serially is already risky.
- Two threads calling `Execute()` on the same interpreter would corrupt control-flow flags, the return-value stack, and the global root scope.

## Why you must NOT share `TSardValue` objects across interpreters

`TSardValue` uses manual reference counting:

```pascal
procedure TSardValue.AddRef;
begin
  Inc(RefCount);
end;

procedure TSardValue.Release;
begin
  Dec(RefCount);
  if RefCount <= 0 then
    Free;
end;
```

`Inc` / `Dec` are not atomic / thread-safe. Sharing values between threads (or between interpreters that mutate the same value tree) will race on `RefCount`.

## Recommended pattern

```pascal
// Parse once, in one thread.
Parser := TParser.Create(Lexer);
AST := Parser.ParseProgram;

// Run many times, each in its own interpreter.
// One interpreter per thread; do not share it.
for each worker thread do
begin
  Interp := TInterpreter.Create;
  try
    Interp.Execute(AST);
  finally
    Interp.Free;
  end;
end;
```

## Caveats

- Each `TInterpreter` gets its own `FRoot` global scope, so scripts do not share globals across threads unless you explicitly wire that up.
- Built-ins such as `print`, `sleep`, and `clock` are per-interpreter. If you add custom built-ins that touch files, databases, etc., you must make those thread-safe yourself.
- If you ever want each thread to have its own isolated copy of the AST, `TASTNode.DeepClone` exists, but it is unnecessary for pure concurrent execution.
