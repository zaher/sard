# Sard Script Language — Review

> Review date: 2026-06-16  
> Based on the repository at `D:\lab\pascal\sard`, including source code, grammar docs, and running the existing interpreter.

## What it is

Sard is a small, experimental scripting language with a Pascal-implemented interpreter. Its stated identity is: **prototype-based**, **expression-oriented**, **gradually typed**, **Unicode-aware**, and **financial-calculation-friendly**. The repository already contains a working FPC/Delphi interpreter plus an ANTLR4 grammar, and it runs real scripts.

## Strengths

| Area | Observation |
|------|-------------|
| **Real implementation** | This is not just a markdown spec. There is a complete lexer, parser, AST, and interpreter in Pascal, plus an ANTLR4 grammar. Tests run and produce output. |
| **Good documentation** | `README.md`, `GRAMMAR.md`, `doc/global.md`, and `TODO.md` are detailed and consistent with each other. The grammar doc is especially thorough. |
| **Interesting type choices** | Built-in `currency` (fixed 6-decimal, 64-bit) and `date` (`0tYYYYMMDD_HH_NN_SS`) show a practical focus on business/financial scripts. |
| **Prototype objects** | `~proto` / `~~proto` / `@ref` give a simple object model without classes. Combined with lexical parent-chain scoping, closures come naturally. |
| **Expression blocks** | `{ ... }` returns a value, which is a nice Lisp/Smalltalk-ish touch for an otherwise C-like syntax. |
| **Gradual typing** | You can write `x = 10` or `x : integer = 10`, which is a pragmatic way to let users opt into safety. |
| **Comfortable literals** | Underscore separators, hex, colors, currency, and date literals all make numeric data readable. |

## Concerns / Risks

| Area | Observation |
|------|-------------|
| **Ambiguous `=`** | One token means assignment, equality comparison, *and* block return depending on context. The docs spend a lot of words disambiguating it, which suggests users will trip over it. |
| **No `else if`** | The README explicitly says there is none. For a modern language, forcing nested `if/else` blocks is awkward. |
| **`==` means type check, not equality** | This inverts the C/Java/JavaScript convention. It is internally consistent (Pascal `is`-style), but it will confuse newcomers. |
| **Accountant `%` mode** | `100 + 50%` → `150` at statement level but `100.5` inside parentheses is clever for finance, yet it is a hidden context-dependent rewrite that can surprise users. |
| **Escape sequences outside strings** | `"line1" \n "line2"` is unusual. Most programmers expect `\n` inside the string. |
| **Limited test coverage** | There are ~50 small test files, but no automated runner, no expected-output assertions, and no stress tests. The language is still clearly in prototype phase. |
| **Missing big pieces** | Namespaces/modules, constructors/destructors, inheritance extension, a standard math library, and a real `break`/`continue` story are on the TODO list. |

## Overall Verdict

Sard is a **well-documented, thoughtfully designed hobby/prototype language** with some genuinely nice ideas — especially the currency/date literals, prototype objects, and expression blocks. It is far enough along to run programs, but still early enough that the ergonomics (notably the overloaded `=` and `==`) would need hardening before it could be used by anyone outside the author.

If you are building it as a personal learning project or a domain-specific calculator/embedded script engine, it is on a good path. If the goal is a general-purpose scripting language, the next priorities I would suggest are:

1. Add an automated test runner with expected outputs.
2. Resolve the `=` / `==` ergonomics or add very clear error messages.
3. Implement `else if` and a proper `break`/`continue`.
4. Add namespaces/modules before the object model becomes hard to scale.
