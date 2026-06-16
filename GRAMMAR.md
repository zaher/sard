# Sard Script Language — Complete Grammar & Reference

> Version: 1.0  
> Based on the Python interpreter implementation.

---

## 1. Introduction

Sard is a prototype-based, expression-oriented scripting language where **everything is an object** — including variables, control structures, and even the language constructs themselves. **Symbol-based operators** (`+`, `-`, `*`, `/`, etc.) are syntactic primitives with fixed precedence, while **named operators** (`mod`, `and`, `or`, `not`) are implemented as extensible operator handler objects. Constructs like `if` resolve to built-in objects at runtime.

Key characteristics:
- **Case-insensitive** identifiers
- **Unicode-aware** lexing
- **No functions** — only callable objects
- **No global scope** — lexical parent-chain scoping
- **Blocks are expressions** — every block evaluates to a value
- **Assignment (`=`) is a statement-level construct**; in expression contexts, `=` is equality comparison
- Reserved words are limited to `true`, `false`, `none`, and built-in type names (`integer`, `number`, `string`, `boolean`, `color`, `currency`, `date`, `array`, `object`). Built-in constructs (`if`, `while`, etc.) are ordinary objects in the root scope and can be overridden or extended via addons
- **Extensible named operators** — `mod`, `and`, `or`, `not` are recognized as special tokens by the lexer, but their behavior is provided by operator handler objects that can be overridden or extended via addons. These can be shadowed by local declarations like any other identifier.

### Implementation Notes

For those looking to implement Sard in their own projects:

* **Can be embedded in other applications** — The Sard interpreter is designed to be embeddable. You can integrate it into host applications (written in Python, C, Rust, etc.) to provide scripting capabilities, configuration handling, or user-extensible logic.

* **Supports multi-threaded execution** — The interpreter can be compiled for use in threads, where multiple independent AST trees can be interpreted in parallel. This enables concurrent script execution without interference between contexts (each thread maintains its own scope and object tree).

---

## 2. Lexical Structure

### 2.1 Source Encoding

Source files are interpreted as **UTF-8**. Unicode characters are valid in identifiers and string literals.

### 2.2 Whitespace

Whitespace consists of spaces, tabs (`\t`), carriage returns (`\r`), and newlines (`\n`). Whitespace is insignificant **except** where it separates tokens or acts as a statement terminator.

**Statement Termination:** Newlines (`\n`) and carriage return-newline pairs (`\r\n`) act as statement terminators. This allows semicolon-free style when each statement is on its own line.

**Important:** Newlines terminate statements by default. To continue an expression across multiple lines, the line must end with an operator or opening bracket:

```sard
// INVALID - newline terminates statement before operator
x = 1
    * 2      // Parsed as: x = 1; *2; (second statement is a parse error)

// VALID - line ends with operator, expression continues
x = 1 +
    2        // Parsed as: x = 1 + 2

// VALID - expressions in parentheses can span lines
x = (1
    + 2)     // Parsed as: x = (1 + 2)
```

### 2.3 Comments

Two comment styles are supported:

```
single-line-comment  := "//" <any characters except newline>* newline
multi-line-comment   := "/*" <any characters>* "*/"
```

`/* ... */` does **not** nest.

```sard
// This is a single-line comment

/*
 * This is a multi-line comment
 * // nested comments do NOT work here
 */
```

### 2.4 Tokens

**Digit Separators:** Numeric literals (integer, number, hexadecimal, color, and currency) may contain underscore (`_`) characters between digits. These underscores are ignored by the lexer and serve only as visual separators, as in modern languages such as Python, Java, Rust, and C#.

```sard
one_million = 1_000_000
pi = 3.14_15_92
mask = 0xFF_FF_00_00
red = #FF_00_00
price = $1_000.00
```

#### 2.4.1 Integer Literals

```
integer-literal      := digit ("_"? digit)*

digit                := [0-9]
```

Underscores (`_`) may be used as digit separators between digits to improve readability. They are ignored by the lexer and do not affect the value.

```sard
0
42
999999
1_000_000
1_000_000_000
```

#### 2.4.2 Number Literals

```
number-literal      := digit ("_"? digit)* "." digit ("_"? digit)*
```

Underscores may appear between digits in both the whole and fractional parts.

```sard
3.14
0.001
123.456
1_000.000_001
3.14_15_92
```

#### 2.4.3 Hexadecimal Literals

```
hex-literal          := "0x" hex-digit ("_"? hex-digit)*

hex-digit            := [0-9a-fA-F]
```

Underscores may appear between hex digits.

```sard
0x0
0xff
0xDEADBEEF
0x1a2b3c
0xDE_AD_BE_EF
0xFF_FF_00_00
```

#### 2.4.4 String Literals

```
string-literal       := '"' <any characters except '"'>* '"'
                        | "'" <any characters except "'">* "'"
```

Strings may span multiple lines.

```sard
"Hello, World!"
'multiline
string here'
```

#### 2.4.5 Escape Sequences

Escape characters are placed **outside** string literals and concatenated implicitly. An escape sequence begins with a backslash `\` and is immediately followed by one of the valid escape characters.

```sard
// These are all equivalent:
"foo" \n\r "bar"      // Escape sequences between strings
"foo\n\rbar"          // Traditional inline escapes (NOT supported - shown for comparison only)

// In C: "line1\nline2"
// In Sard: "line1" \n "line2"
x = "line1" \n "line2"  // x = "line1" + newline + "line2"
```

**Lexical Rule:** An escape sequence is tokenized as a standalone token only when:
- It appears outside of a string literal
- It starts with `\` followed immediately by a valid escape character
- It is adjacent to (or separated by whitespace from) string literals or other escape sequences

```
escape-sequence      := <backslash> ("n" | "r" | "t" | <backslash> | "0")
```

Escape sequences are standalone tokens that appear outside string literals and are concatenated with adjacent strings at the tokenization stage.

Supported escape sequences (standalone tokens):

| Escape | Value |
|--------|-------|
| `\n` | newline (`0x0A`) |
| `\r` | carriage return (`0x0D`) |
| `\t` | tab (`0x09`) |
| `\\` | backslash |
| `\0` | null byte (`0x00`) |

**String Concatenation:** The lexer combines adjacent string literals and escape tokens into a single string value at the tokenization stage. Whitespace between tokens is ignored during this concatenation.

```sard
// All of these produce the same single string token:
"Hello" \n "World"
"Hello"\n"World"
"Hello" \n\n "World"
```



#### 2.4.6 Color Literals

```
color-literal        := "#" hex-digit ("_"? hex-digit){5}
                       | "#" hex-digit ("_"? hex-digit){2}

hex-digit            := [0-9a-fA-F]
```

Stored as a DWORD (4 bytes, e.g., `0x00FF5733`).

The 3-digit shorthand format (like CSS) expands by doubling each digit: `#abc` → `#aabbcc`.

Underscores may appear between hex digits.

```sard
#ff5733      // 6-digit format
#000000      // 6-digit format
#FFFFFF      // 6-digit format
#fff         // 3-digit shorthand → #ffffff
#f0f         // 3-digit shorthand → #ff00ff
#abc         // 3-digit shorthand → #aabbcc
#ff_57_33    // 6-digit format with separators
#f_f_f       // 3-digit shorthand with separators → #ffffff
```

#### 2.4.7 Currency Literals

```
currency-literal     := "$" digit ("_"? digit)* ("." fractional-digits)?

fractional-digits    := digit ("_"? digit){0,5}

digit                := [0-9]
```

Currency literals represent fixed-point decimal values with 6 fractional digits, stored internally as a signed 64-bit integer (similar to Pascal's `Currency` type or `DECIMAL(16, 6)`). The `$` prefix denotes the currency type. Values are stored as integer number of units × 10^6 (1,000,000 = 1.0).

Underscores may appear between digits in both the whole and fractional parts.

```sard
x = $100                // 100.000000
price = $99.99          // 99.990000
tax = $12.3456          // 12.345600
fraction = $0.000001    // 0.000001 (smallest unit)
salary = $1_000_000     // 1000000.000000
micro = $0.000_001      // 0.000001
```

**Precision:** Currency values support up to 6 decimal places. The lexer rejects literals with more than 6 fractional digits. Operations on currency values maintain precision by using 64-bit integer arithmetic internally.

#### 2.4.8 Date Literals

```
date-literal         := "0t" date-digit ("_"? date-digit){7,13}

date-digit           := [0-9]
```

Date literals represent a calendar date and optional time, stored internally as a `date` value (TDateTime). The literal begins with the prefix `0t` followed by digits in `YYYYMMDDHHNNSS` order. The shortest form is eight digits (`YYYYMMDD`) representing midnight on that date. Longer forms append the hour (`YYYYMMDDHH`), minute (`YYYYMMDDHHNN`), or second (`YYYYMMDDHHNNSS`). Underscores may be used as separators between digits and are entirely optional; after stripping underscores the literal must contain 8, 10, 12, or 14 digits.

```sard
d = 0t1971_10_19            // Valid date only
print(d)                    // 1971-10-19 00:00:00

d = 0t1971_10_19_03         // Valid date and hour
print(d)                    // 1971-10-19 03:00:00

d = 0t1971_10_19_03_35      // Valid date, hour and minutes
print(d)                    // 1971-10-19 03:35:00

d = 0t1971_10_19_03_35_52   // Valid date and time with seconds
print(d)                    // 1971-10-19 03:35:52

d : date = 0t19711019       // 1971-10-19 00:00:00
d = 0t19711019033552        // 1971-10-19 03:35:52
print(d == date)            // true
```

The lexer validates the date and time and raises an error for invalid dates such as `0t20211301` or `0t20210229` on non-leap years, and for invalid times such as `0t1971_10_19_25` or `0t1971_10_19_03_75`.

#### 2.4.9 None Literal

```
none-literal         := "none" | "None" | "NONE"
```

The `none` literal represents the absence of a value, equivalent to Python's `None`. It is a reserved word and is case-insensitive. Internally it is stored as the null value (`vkNull`).

```sard
x = none
print(x)                    // none
print(x == none)            // true

// none is falsy, like Python None
if (none) {
    print("yes")
} else {
    print("no")             // prints "no"
}

// Default values and omitted arguments are none
foo : (a) {
    print(a == none)        // true when called as foo()
}
foo()
```

### 2.5 Identifiers

```
letter               := [a-zA-Z]

digit                := [0-9]

identifier           := identifier-start identifier-continue*

identifier-start     := letter | "_" | unicode-letter
                        | unicode-number-letter | unicode-other-letter

identifier-continue  := identifier-start | digit
                        | unicode-mark-nonspacing | unicode-mark-spacing-combining
                        | unicode-number-decimal | unicode-punctuation-connector
```

**Unicode Categories Used:**
- **Start characters**: Lu (uppercase), Ll (lowercase), Lt (titlecase), Lm (modifier), Lo (other), Nl (number letter) - same as UAX #31 (Unicode Standard Annex #31)
- **Continue characters**: Start characters + Mn (nonspacing mark), Mc (spacing combining mark), Nd (decimal number), Pc (connector punctuation)

**Rules:**
- Identifiers are case-insensitive internally (stored in lowercase)
- Reserved words: `true`, `false`, `none`, and built-in type names (`integer`, `number`, `string`, `boolean`, `color`, `currency`, `date`, `array`, `object`)
- Words like `if`, `while` are **built-in root-scope objects**, not keywords. They can be shadowed by local declarations or replaced via addons, though this is not recommended for readability.
- Named operators (`mod`, `and`, `or`, `not`) are **operator handler objects** that can be defined, overridden, or extended via addons to provide custom behavior.

**Examples:**
```sard
foo
my_var
CamelCase
camelcase   // same as above
_underscore
_private   // convention: leading underscore for private

// Unicode examples (all valid)
mañana      // ñ - Ll (lowercase letter)
你好世界     // CJK Unified Ideographs - Lo (other letter)
Φυσική     // Greek - Lu/Ll (Greek letters)

// Valid: combining marks after start
mañana      // n + combining tilde (U+0303)

// Invalid: cannot start with digit or combining mark
123abc      // ERROR: starts with digit
̃name        // ERROR: starts with combining mark
```

**Implementation Note:** Follow [UAX #31 - Unicode Identifier and Pattern Syntax](https://unicode.org/reports/tr31/) for identifier parsing. This ensures compatibility with international text and proper handling of Unicode normalization.

### 2.6 Qualified Identifiers

```
qualified-identifier := identifier ("." identifier)*
```

```sard
point.x
my.object.deep.value
```

### 2.7 Operators and Punctuation

| Token | Symbol(s) |
|-------|-----------|
| Assignment (statement) / Equality (expression) / Block return | `=` |
| Colon | `:` |
| Semicolon | `;` |
| Comma | `,` |
| Dot | `.` |
| Type-Check | `==` |
| Less-Greater | `<>` |
| Bang-Equals | `!=` |
| Less | `<` |
| Greater | `>` |
| Less-Equals | `<=` |
| Greater-Equals | `>=` |
| Plus | `+` |
| Minus | `-` |
| Star | `*` |
| Slash | `/` |
| Caret | `^` |
| Percent (postfix) | `%` |
| Modulo | `mod` |
| Ampersand | `&` |
| Bar | `\|` |
| And | `and` |
| Or | `or` |
| Not | `not` |
| Bang | `!` |
| Tilde | `~` |
| Tilde-Tilde | `~~` |
| Increment | `++` |
| Decrement | `--` |
| Plus-Equals | `+=` |
| Minus-Equals | `-=` |
| LParen | `(` |
| RParen | `)` |
| LBrace | `{` |
| RBrace | `}` |
| LBracket | `[` |
| RBracket | `]` |

> **Note:** Symbol-based operators (`+`, `-`, `*`, `/`, `%`, `&`, `|`, etc.) are syntactic primitives with fixed precedence tables and cannot be changed at runtime. Named operators (`and`, `or`, `not`) are parsed as special tokens and implemented via operator handler objects that can be defined, overridden, or extended via addons. The `mod` operator is lexically a named operator but has multiplicative precedence (same as `*` and `/`) for mathematical consistency. The lexer recognizes named operators, but their behavior is defined at the object level.

---

## 3. Type System

Sard supports **gradual typing** with strict type enforcement when type annotations are provided:

- **Untyped variables** (`x = 10`): Dynamically typed — can hold any type and change types freely
- **Typed variables** (`x : integer = 10`): Strictly typed — the variable maintains its declared type throughout its lifetime

### 3.1 Type Annotations and Enforcement

When a variable is declared with a type annotation (`identifier : type`), the runtime enforces type safety:

1. **Type Constraint**: The variable can only hold values compatible with its declared type
2. **Auto-casting**: The interpreter attempts to auto-cast assigned values to the declared type
3. **Type Change Prohibited**: Assigning a value of incompatible type that cannot be auto-cast results in a runtime error

**Examples:**
```sard
// Untyped - can change types freely
x = 10          // x is integer
x = "test"      // valid - x becomes string
x = 3.14        // valid - x becomes number

// Typed - strict type enforcement
y : integer = 10    // y is strictly integer
y = 20              // valid - same type
y = "test"          // ERROR: cannot convert "test" to integer
y = "30"            // valid - auto-cast: "30" -> 30, y = 30
y = "abc"           // ERROR: cannot convert "abc" to integer (no valid conversion)

// Auto-cast examples
price : number = 100      // valid: integer -> number (100.0)
count : integer = 9.9      // valid: number -> integer (9, truncated)
flag : boolean = 1         // valid: integer -> boolean (true, non-zero = true)
```

**Callable Objects:** Callable parameters may include optional type annotations (`name : type`), and callable declarations may include an optional return type before the parameter list (`name : type (params) { ... }`). By default, these annotations serve as documentation and a hook for future static analysis; the runtime enforces types on variable declarations, but does not require callable parameter or return-type checks unless the implementation chooses to enforce them. If no type annotation is provided, the parameter or return value remains dynamically typed.

### 3.2 Type Expressions

```
type                 := identifier ("." identifier)*
```

```sard
x : integer;
y : my_module.point;
```

### 3.3 Core Types (Built-in)

| Type | Description | Example Literals |
|------|-------------|------------------|
| `integer` | Signed integer | `42`, `0` |
| `number` | Floating-point | `3.14`, `0.5` |
| `string` | Unicode string | `"hello"` |
| `boolean` | Boolean value | `true`, `false` (built-in objects, not literals) |
| `color` | RGB color value (DWORD 4 bytes) | `#ff0000` |
| `currency` | Fixed-point decimal (64-bit, 6 fractional digits) | `$100`, `$99.99` |
| `date` | Date/time value | `0t19711019`, `0t1971_10_19`, `0t1971_10_19_03_35_52`, `now()` |
| `array` | Ordered collection | `[1, 2, 3]` |
| `object` | User-defined object | `~my_proto` |

### 3.4 Type Casting

Sard supports **Pascal-style type casting** using built-in type names as cast operators:

```
type-cast            := type-name "(" expression ")"

type-name            := "integer" | "number" | "string" | "boolean"
                        | "color" | "currency" | "date" | "array" | "object"
```

A type-cast expression converts the value of the inner expression to the named type. Type casts are parsed as **primary expressions** and can appear anywhere a primary expression is allowed, including nested casts and arbitrary expressions.

**Supported conversions** follow the same rules as typed-variable auto-casting (see §3.1):

| From | To | Result |
|------|-----|--------|
| `number` | `integer` | Truncated toward zero (`integer(3.14)` → `3`) |
| `string` | `integer` | Parsed as integer (`integer("42")` → `42`) |
| `boolean` | `integer` | `true` → `1`, `false` → `0` |
| `integer` / `string` | `number` | Converted to floating-point |
| any | `string` | Human-readable string form |
| any | `boolean` | Truthiness test (`0`, `none`, `""` → `false`; others → `true`) |
| `integer` / `number` | `currency` | Fixed-point currency value |
| `integer` | `color` | RGB value (`color(255)` → `#0000FF`) |
| `array` | `array` | Copy of the array |
| `object` | `object` | Copy of the object |

```sard
i = integer(3.14)              // 3
n = number("42")               // 42.0
s = string(42)                 // "42"
b = boolean(1)                 // true
c = color(255)                 // #0000FF
m = currency(3.14)             // 3.140000

// In expressions and nested
result = integer(string(42)) + 1   // 43
```

Invalid conversions raise a runtime error:

```sard
x = integer("hello")           // ERROR: cannot convert "hello" to integer
```

> **Note:** Type names are reserved words in Sard. A type-name followed immediately by `(` is always parsed as a type cast, not as a callable invocation. This is consistent with Pascal's cast syntax (`Integer(X)`), not a function call.

---

## 4. Expressions

### 4.1 Literal Expressions

```
literal              := integer-literal
                         | number-literal
                         | hex-literal
                         | string-literal
                         | color-literal
                         | currency-literal
                         | date-literal
                         | none-literal
```

### 4.2 Identifier Expressions

```
identifier-expression := identifier
                        | qualified-identifier
```

### 4.3 Parenthesized Expressions

```
parenthesized-expression := "(" expression ")"
```

```sard
result = (a + b) * c;
```

### 4.4 Binary Expressions

```
binary-expression    := expression operator expression

operator             := "+" | "-" | "*" | "/" | "^" | "mod"
                       | "=" | "<>" | "!="
                       | "<" | ">" | "<=" | ">="
                       | "&" | "and" | "|" | "or"
                       | "=="                    (* type comparison, not value *)
```

Most binary operators are **left-associative** (see the precedence table below for exceptions like `^`). Comparison operators support **chaining** like Python — `a < b < c` forms a flat chain (see grammar note below), **not** a left-associative binary tree. Assignment is **right-associative** in the sense that `a = b = c` assigns the result of the comparison `(b = c)` to `a`.

Precedence (high to low):

1. `^`                                           (* power - right-associative *)
2. `*`, `/`, `mod`
3. `+`, `-`
4. `==`                                          (* type comparison, does NOT chain *)
5. `=`, `<>`, `!=`, `<`, `>`, `<=`, `>=`         (* chaining supported for value comparisons *)
6. `&`, `and`
7. `|`, `or`

```sard
a + b * c       // parsed as a + (b * c)
a - b - c       // parsed as (a - b) - c
a = b + c       // parsed as a = (b + c)   // value comparison in expression context
```

**Comparison Chaining (Python-style):** When multiple comparison operators are used in sequence within an **expression context**, they are evaluated as a chained comparison. Chained comparisons are transformed during semantic analysis into the logical AND of all individual comparisons with the middle operand shared:

```sard
// Chained comparisons (like Python) - ONLY in expression contexts
if (a < b < c) {        // semantically equivalent to (a < b) and (b < c)
    print("in range")
}
if (0 <= x < 100) {      // true if x is between 0 (inclusive) and 100 (exclusive)
    print("valid index")
}

// Result variable captures chained comparison result
all_equal = (a = b = c)   // semantically equivalent to (a = b) and (b = c)
```

**Important:** Chaining only works in **expression contexts** (inside parentheses, conditions, or as right-hand sides). At the statement level, the first `=` is parsed as **assignment**, not comparison:

```sard
// At statement level: first = is assignment, second = is comparison
a = b = c       // Parsed as: a = (b = c) - assigns boolean result of (b == c) to a
                // NOT chaining! b = c is comparison (b == c), not assignment to b

// Use explicit parentheses for chaining at statement level:
result = (a = b = c)      // Valid: chains in expression context, assigns to result
// Or use explicit and:
result = (a = b) and (b = c)
```

**Note on Right-Associativity in Assignment:** The assignment statement `a = b = c` is parsed with **right-associative semantics** as `a = (b = c)`. This is because the first `=` at statement level is assignment (left-associative would imply `(a = b) = c`, which makes no sense since `a = b` returns no value for assignment).

**Grammar Note:** The EBNF captures comparison chains as a flat sequence — `a < b < c` is parsed as a list of `[a, <, b, <, c]`, NOT as a left-associative binary tree `((a < b) < c)`. The semantic analyzer expands the flat chain into `(a < b) and (b < c)`. This follows Python's approach: the comparisons are never reduced as binary operations; instead each adjacent pair becomes a condition, and the full chain is the logical AND of all conditions.

**Note:** `=` is **value comparison** when it appears inside an expression (e.g., inside parentheses, as an operand, or in a condition). It is **assignment** only at the statement level (see Assignment Statement).

**Type Comparison (`==`):** The `==` operator checks if a value is of a **specific type** (like Pascal's `is` operator), not if two values are equal. It sits at precedence level 4 (between additive and value comparison operators), allowing natural expressions like `x == integer` without parentheses. **Type comparison does NOT chain** - attempting to chain (e.g., `x == integer == boolean`) is invalid; use `or` for multiple type checks.

> **Note:** Unlike C-style languages where `==` means equality, Sard uses `==` for **type checking** (Pascal-style). This is intentional and may differ from expectations if you're coming from C, Java, or JavaScript. Use `=` for value equality comparisons.

```sard
// Value comparison (=)
result = (x = 5)           // true if x equals 5

// Type comparison (==)
is_int = (x == integer)    // true if x is an integer type
is_string = (x == string)  // true if x is a string type
is_bool = (x == boolean)   // true if x is a boolean type

// Multiple type checks (type comparison does NOT chain)
is_number = (x == integer) or (x == number)   // true if x is integer OR x is number
```

### 4.5 Unary Expressions

```
unary                := "-" unary
                        | "+" unary
                        | "!" unary
                        | "not" unary
                        | "++" lvalue
                        | "--" lvalue
                        | postfix
```

The unary operators `-`, `+`, `!`, and `not` are right-associative and have the same precedence level. Pre-increment `++` and pre-decrement `--` also share this precedence level but require an `lvalue` operand (identifier with optional member/index access), not any unary expression.

**Operator Resolution:**
- `++` and `--` require an **lvalue** operand (identifier, member access, or array index)
- `-`, `+`, `!`, `not` operate on any unary expression (allowing nesting like `+ -x` or `- -5`)

```sard
-negative
+positive
!flag
++x      // pre-increment: increment then return new value
--y      // pre-decrement: decrement then return new value
not valid  // named operator NOT
!valid     // symbol operator NOT (same precedence)
- -5       // double negation: -(-5) = 5

// NOT valid:
// --5      // ERROR: 5 is not an lvalue
// ++(x)    // ERROR: (x) is an expression, not an lvalue
```

### 4.6 Object Construction

```
object-construction := "~" identifier
                      | "~~" identifier
                      | "@" expression
```

- `~Proto` — creates a new instance with `Proto` as its prototype; members are looked up in the prototype chain.
- `~~Proto` — creates a new instance with a **shallow copy** of all members from `Proto`.
- `@expr` — creates a **reference** to an existing object or variable (both point to the same value/object).

```sard
point : {
    x : integer = 0;
    y : integer = 0;
}

p1 = ~point;       // new instance, prototype = point
p2 = ~~point;      // new instance, shallow copy of members
p3 = @p1;          // reference - p3 and p1 are the same object

// Reading from p1 - inherits from prototype
print(p1.x);        // 0 (from point)

// Writing to p1 - creates shadowing property on p1
p1.x = 10;
print(p1.x);        // 10 (shadowed on p1)
print(point.x);     // 0 (unchanged - prototype not modified!)
print(p2.x);        // 0 (copied, unaffected)
print(p3.x);        // 10 (same object as p1)

// Modifying p3 affects p1 (they are the same object)
p3.x = 99;
print(p1.x);        // 99
```

### 4.7 Postfix and Call Expressions

```
postfix              := primary (postfix-link)*

postfix-link         := postfix-access
                        | postfix-call
                        | block
                        | postfix-final

postfix-access       := "." identifier
                        | "[" expression "]"

postfix-call         := argument-list block?
                        | named-block

postfix-final        := "%"
                        | "++" | "--"

argument-list        := "(" (argument ("," argument)*)? ")"
argument             := expression?

named-block          := identifier argument-list? block
```

Functions are callable objects. They can accept:
- An argument list: `func()` or `func(a, b)`
- An argument list with omitted arguments: `func(, b)` uses the declared default value (or `none` if none)
- Named blocks (`identifier block`): `if (cond) { } else { }`

**Postfix Chain Rules:**
- `postfix-access` (member/index) and `postfix-call` (argument list with optional block, or named block) are non-terminal links — further postfix operations may follow.
- `postfix-final` (`%`, `++`, `--`) are **terminal operations** — no further postfix links may follow them.
- `block` as a postfix link is non-terminal if followed by a named block continuation (e.g., `else`). Newlines between the closing `}` and the continuation keyword are ignored.
- At most one `argument-list` is allowed per postfix chain (no call chaining like `func()()`).
- Named blocks can only follow an `argument-list`, an anonymous `block`, or another named block (enforced semantically, not by EBNF). The named block keyword and its opening `{` may be separated by newlines.

**Calling with No Arguments:** Callable objects with no arguments can be called with or without parentheses, like in Pascal. When a parameterless callable is used as a value, it is automatically invoked. Parentheses are therefore optional for parameterless callables, both in statements and in expressions.

```
implicit-call        := identifier    (* resolved to parameterless callable → implicit invocation *)
```

```sard
// Both are valid for parameterless callables:
greet;        // Call without parentheses (natural syntax, implicit invocation)
greet();      // Call with empty parentheses (also valid)

// In expressions, the callable is also invoked automatically:
message = greet           // message = "Hello"
print(greet)              // prints the result of calling greet

// Member access uses the object itself, so the callable is not invoked:
print(greet.length)       // access a member of the greet object, if any
```

A callable is only auto-invoked when it is used as a value. When it appears as the base of a member access (`obj.member`) or index access (`arr[i]`), it is treated as the underlying object so that members and elements can be reached.

**Block Rules:**
- Anonymous blocks are permitted directly after a callable expression: `func { body }` passes the block as an argument to the callable
- Named blocks can have an optional argument list: `myname { }` or `myname(n) { }`
- Named blocks are only valid when they follow:
  - An argument list: `if (cond) { ... } else { ... }`
  - An anonymous block (which follows an argument list): `if (cond) { ... } else { ... }`
  - Another named block (chaining)
- Newlines are ignored around named block keywords: they may appear before the keyword (after the previous block's `}`) and between the keyword and its opening `{`.

**`else if` Chains:**

`if` supports chained alternatives using `else if`. Each `else if` provides its own condition and body. Conditions are evaluated in order, and the first body whose condition is true is executed. A final `else` block may follow the chain and runs only when none of the preceding conditions were true.

```sard
if (score >= 90) {
    print("Grade: A")
} else if (score >= 80) {
    print("Grade: B")
} else if (score >= 70) {
    print("Grade: C")
} else {
    print("Grade: D or F")
}
```

Syntactically, `else if` is a special named-block form: the keyword `else` is immediately followed by the identifier `if`, an argument-list with the condition, and a body block. The parser treats the whole `else if (cond) { ... }` sequence as a single continuation of the preceding `if` call. Newlines may appear before each `else`/`else if` keyword and between the keyword and its opening `{`.

**No Call Chaining:** Call expressions cannot be chained. The following are invalid:
```sard
func()()       // ERROR: cannot call result of call
func()()()     // ERROR: triple call chaining
obj.method()() // ERROR: cannot chain calls
```

**Invalid Usage (Semantic Error):**
```sard
obj.method else { print("error") };  // ERROR: named block after member access (not a call)
```

The parser syntactically recognizes `else { ... }` but rejects it semantically because it follows member access (`.method`) rather than a call chain.

```sard
// Arguments only
print("hello");

// Block form
while (count < 10) {
    print("loop");
    count++;
}

// Arguments and blocks
if (x > 0) {
    print("positive");
} else {
    print("non-positive");
};

// `else` (and its opening brace) may start on a new line
if (score >= 90)
{
    print("yes");
}
else
{
    print("no");
}
```

### 4.8 Array Literals

```
array-literal        := "[" (expression ("," expression)*)? "]"
```

```sard
empty = [];
nums = [1, 2, 3, 4];
mixed = [1, "hello", true];
```

#### Array Multiplication (Declaration with Repeated Elements)

```
array-multiplication   := "[" expression "]" "*" integer-literal
```

Arrays can be declared with multiple elements of the same value using the multiplication operator `*`. The expression inside the brackets is the initial value, and the integer literal specifies how many times to repeat it.

```sard
arr = [0] * 3      // declare with 3 elements of zeros: [0, 0, 0]
zeros = [0] * 10   // array of 10 zeros
ones = [1] * 5     // array of 5 ones: [1, 1, 1, 1, 1]
fives = [5] * 4    // array of 4 fives: [5, 5, 5, 5]
strs = [""] * 3    // array of 3 empty strings: ["", "", ""]
```

#### Array Addition (Appending Elements)

```
array-addition         := expression "+" "[" (expression ("," expression)*)? "]"
array-compound-add   := lvalue "+=" array-literal
```

Arrays can be appended to using the `+` operator or `+=` compound assignment. When an array is added to another array, the elements from the right-hand array are appended to the left-hand array, creating a new array with the combined elements.

```sard
arr = []
arr = arr + [10]     // arr is now [10]
arr += [20]          // arr is now [10, 20] using compound assignment
arr = arr + [30, 40] // arr is now [10, 20, 30, 40]

// Can also combine array multiplication with addition
base = [0] * 3       // [0, 0, 0]
extended = base + [1, 2]  // [0, 0, 0, 1, 2]
```

**Important Notes:**
- Array addition creates a **new array** with the combined elements (Sard arrays are immutable in this operation)
- The original array is not modified; a new array is returned
- `+=` works as syntactic sugar for `arr = arr + [...]`
- Both operands can be variables or array literals

### 4.9 Array Indexing

```
array-index          := postfix "[" expression "]"
```

```sard
nums = [10, 20, 30];
first = nums[0];       // 10
nums[1] = 99;          // update element
```

> **Note:** `postfix` is the non-terminal from the EBNF summary that includes `primary` followed by any chain of member access, index, call, or block links (see Section 4.7).

### 4.10 Block Expressions

```
block                := "{" block-body "}"

block-body           := statement*
```

Blocks can appear anywhere an expression is expected. They create a new child scope and evaluate to the value of the last statement:
- If the last statement is an expression statement (e.g., `x + 1` or `foo()`), the block evaluates to that expression's value
- If the last statement is a return statement (`= expr;`), the block evaluates to the returned value
- Empty blocks or blocks ending with declaration/assignment statements evaluate to `none`

```sard
result = {
    temp = x + y;
    temp * 2;      // Block evaluates to expression value
};

value = {
    temp = x + y;
    = temp * 2;    // Block evaluates to return value
};

empty = {}         // Evaluates to null
```

### 4.11 Postfix Operators

#### Increment and Decrement

```
postfix-inc-dec      := "++" | "--"
```

`++` and `--` are available as **postfix** operators (terminal operations in the postfix chain):

```sard
x = 5;
old = x++;    // old = 5, x = 6
y = 10;
old2 = y--;   // old2 = 10, y = 9
```

**Note:** Prefix and postfix forms have different return semantics:
- `++x` / `--x` — prefix: mutate first, then return the **new** value
- `x++` / `x--` — postfix: return the **old** value first, then mutate

Both forms operate on an lvalue operand (identifier with optional member access and/or array indexing). If the variable does not exist, it is created with an initial value of 0 before the increment/decrement operation.

#### Percent

```
postfix-percent      := "%"
```

The `%` postfix operator behaves like an **accountant calculator**: it divides the operand by 100, making percentage calculations read naturally for financial computations. It is a **terminal operation** — once applied, no further postfix links may follow (see Terminal Operation Rule below).

**Standard Behavior (Standard Precedence):**

```sard
rate = 50%;            // 0.5
rate = 15%;            // 0.15
tax = 100 * 20%;       // 20 (20% of 100 = 100 * 0.2)
price = 50 * 110%;     // 55 (50 * 1.1)
discount = 200 * 75%;  // 150 (200 * 0.75)
```

**Accountant Calculator Mode (Special + and - Handling):**

When `%` appears as the **immediate right operand** of `+` or `-` at the **top level of an expression statement**, the percentage is calculated **relative to the left operand**:

```sard
// Markup: Add X% of base value
value = 100 + 50%;     // 150 (100 + 50% of 100 = 100 + 100*0.5)
value = 200 + 10%;     // 220 (200 + 10% of 200 = 200 + 200*0.1)

// Discount: Subtract X% of base value
value = 100 - 20%;     // 80 (100 - 20% of 100 = 100 - 100*0.2)
value = 200 - 15%;     // 170 (200 - 15% of 200 = 200 - 200*0.15)

// Complex example: standard precedence applies, then special handling at top level
total = 200 * 10 + 5%; // 2100 (200 * 10 = 2000, then add 5% of 2000 = 100)
```

**Rules for Accountant Calculator Mode:**

1. **Only at top level:** The special handling applies only to the outermost `+` or `-` operator in an expression statement, not nested expressions.
2. **Only immediate right operand:** The `%` must directly follow `+` or `-` without parentheses.

```sard
// Standard mode (inside parentheses - no special handling)
result = (100 + 50%);  // 100.5 (100 + 0.5), NOT 150

// Accountant mode (top level)
result = 100 + 50%;    // 150 (special handling active)
```

**Precedence Rule:** `%` has higher precedence than all binary operators (`*`, `/`, `+`, `-`, etc.). It binds tightly to its immediately preceding primary expression.

**Semantic Transformation Note:** The accountant calculator mode (`left + X%` computing `left + left*X/100`) is implemented as a **post-parse semantic transformation**: the parser builds the standard AST (`100 + (50%)` = `100.5`), then a simple rewrite pass transforms the pattern `(additive (+|-) multiplicative)%` at the top level of expression statements into `additive * (1 +/- X/100)`. The EBNF strictly defines `100 + 50%` as `100 + (50%)` = `100.5`, but the semantic transformer converts it to `100 + 100*0.5` = `150`.

**Important:** Unlike `++` and `--`, `%` does **not** require an lvalue operand and does not mutate its operand. It can be applied to any expression.

#### Terminal Operation Rule for `%`, `++`, `--`

The `%`, `++`, and `--` postfix operators are **terminal operations** — once applied, no further postfix links (member access, index, call, block, or another terminal operator) may follow. The EBNF encodes this loosely and relies on the parser for enforcement.

**Invalid patterns (semantic errors):**

```sard
x%[0]            // ERROR: percent then index — terminal op followed by access
x[0]%[1]         // ERROR: percent then index
x++[0]           // ERROR: increment then index
x--.foo          // ERROR: decrement then member access
x%++             // ERROR: percent then increment — terminal ops cannot chain
func()%()        // ERROR: percent then call
50%{ }           // ERROR: percent then block
```

**Valid patterns:**
```sard
rate = 50%;            // OK: percent at end
x = arr[i]++;          // OK: index access then increment (arr[i] is lvalue)
y = obj.val--;         // OK: member access then decrement
price = 100 * 20%;     // OK: percent at end of expression, no further postfix links
```

**Rationale:** These operators return scalar/primitive values (number, boolean) — not objects with members, indices, or callability. Allowing further operations would be semantically meaningless.

---

## 5. Statements

### 5.1 Declaration Statement

```
declaration          := identifier ":" declaration-body statement-term?

declaration-body     := type ("=" expression)?
                       | type? (newline* parameter-list)? newline* block?
```

Introduces a new variable or callable object. The semicolon is optional at end of line.

**Newlines in Declarations:** Newlines normally terminate statements, but in a declaration they are ignored when they appear immediately before a parameter list or a block. This allows callable declarations to span lines naturally:

```sard
object1:
{
    print("Hi1")
}

add:
(a, b)
{
    = a + b
}
```

A newline before `=` does **not** continue a variable declaration; it terminates the declaration. Use `name : type = value` on one line (or only split after the `=`).

**Forms:**
- `name : type` — declares a variable with type annotation (strictly typed)
- `name : type = value` — declares and initializes a strictly typed variable
- `name : { ... }` — declares a callable object with no parameters
- `name : (params) { ... }` — declares a callable object with parameters
- `name : type { ... }` — declares a callable with return type and no parameters
- `name : type (params) { ... }` — declares a callable with return type and parameters
- `name : (params)` — declares a callable signature (parameters only, no body); serves as a forward declaration or abstract interface
- The above forms also work when a newline appears before `{` or before `(`

**Parameters:**

```
parameter            := identifier (":" type)? ("=" expression)?
open-parameter       := identifier "..."
parameter-list       := "(" (parameter ("," parameter)*)? ("," open-parameter)? ")"
```

Each parameter in a parameter list may optionally include a type annotation, and may optionally specify a default value. Default values are used when the corresponding argument is omitted at the call site. Untyped, typed, and defaulted parameters may be mixed freely in the same list.

**Open Parameters:**

An *open parameter* (variadic parameter) is declared by writing an identifier followed by three dots (`...`). It must be the last parameter in the list. When the callable is invoked, all remaining positional arguments are collected into an `array` value bound to the open parameter name. The elements are accessed with normal array indexing (`o[i]`).

```sard
// Open parameter only
sum : (o...) {
    = o[0] + o[1] + o[2]
}
print(sum(10, 20, 30))      // 60

// Mixed fixed and open parameters
foo : (prefix, values...) {
    = prefix + values[0]
}
print(foo("item: ", 1, 2))  // item: 1
```

An open parameter cannot have a type annotation or a default value, and no further parameters may appear after it. Passing arguments after an open parameter is not allowed.

```sard
// Untyped parameters
add : (a, b) { = a + b }

// Typed parameters
greet : (name: string) { = "Hello, " + name }

// Mixed typed and untyped
scale : (value, factor: number) { = value * factor }

// Multiple typed parameters
plot : (x: integer, y: integer) { ... }

// Typed parameters with return type
divide : number (a: number, b: number) { = a / b }

// Default parameter values
foo : (x, y = 10) { = x + y }
foo(5)              // x = 5, y defaults to 10 -> 15
foo(5, 2)           // x = 5, y = 2 -> 7

bar : (x = 5, y) { = x * y }
bar(, 10)           // x defaults to 5, y = 10 -> 50
bar(2, 10)          // x = 2, y = 10 -> 20

// Typed parameters with defaults
fmt : (value: integer, pad: string = "0") { ... }
```

Default expressions are evaluated at call time in the caller's scope, and only when the corresponding argument is omitted. An argument may be omitted by writing an empty slot before a comma, or by providing fewer arguments than parameters.

**Type Enforcement:**
When a variable is declared with a type annotation (`name : type`), the runtime enforces strict type safety:
- Assignments must be compatible with the declared type
- Auto-casting is attempted for compatible conversions
- Incompatible assignments cause runtime errors

**Untyped Variables:**
Variables declared without a type annotation (via simple assignment `name = value`) are untyped and dynamically typed. They can hold values of any type and change types freely. Note: grammatically, `name = value` is an assignment statement; the variable is created at runtime if it doesn't exist.

**Ambiguity Example:** The syntax `foo : { ... }` is syntactically ambiguous and requires disambiguation:

```sard
// Ambiguous: could be either interpretation
foo : {
    x = 1
    y = 2
}

// Interpretation A: Variable declaration with type `foo` and block initialization
//   foo : foo_type = { x = 1; y = 2 }
//   -> foo is a variable containing the block's return value

// Interpretation B: Callable declaration with no parameters
//   foo : () { x = 1; y = 2 }
//   -> foo is a callable object that can be invoked with foo()
```

**Resolution:** The grammar resolves this as **callable declaration** when a block immediately follows `:`. An `identifier : type` without a following block or parameter list is always a **variable declaration**. To declare a variable initialized with a block value, use explicit assignment syntax:

```sard
// Callable declaration (no = sign)
greet : {
    = "Hello"    // returns "Hello" when called
}
result = greet()   // result = "Hello"

// Variable declaration with block (use = sign)
value = {
    = 42         // immediately executes, value = 42
}

// With explicit type annotation for variable
data : object = {
    x = 1
    y = 2
    = this       // returns the object
}
```

```sard
// Variable declarations
x : integer
y : integer = 10
name : string = "Sard";

// Callable declarations (must use colon)
counter : {
    value : integer = 0
    inc : () {
        value = value + 1
        = value
    }
}

add : (a, b) {
    = a + b
}

// Immediate execution using assignment
myobject = {
    print("executing now")
    = 42
}
```

**Note:**
- `identifier : { ... }` — declares an object without executing; call later with `identifier()`
- `identifier : (params) { ... }` — declares with parameters; call later with `identifier(args)`
- `identifier : (params)` — declares a callable signature with no body (forward declaration); definition must be provided elsewhere
- `identifier = { ... }` — assigns block result to identifier (immediate execution)

**Declaration Ambiguity Resolution:** When a block follows a colon (`:`), it is **always** interpreted as a callable declaration, not a variable declaration with block initialization. To create a variable initialized with a block result, you **must** use the `=` assignment syntax, which immediately executes the block and stores its return value.

### 5.2 Empty Statement

```
empty-statement      := (";" | newline)+
```

Empty statements (consecutive semicolons or newlines) are valid but have no effect. They can be used for visual separation in code.

```sard
x = 1;;   // two semicolons - one empty statement

y = 2;   // newline acts as terminator
```

---

### 5.3 Assignment Statement

```
assignment           := lvalue "=" expression statement-term
                        | lvalue "+=" expression statement-term
                        | lvalue "-=" expression statement-term

lvalue               := lvalue-primary (lvalue-suffix)*
lvalue-primary       := identifier

lvalue-suffix        := "." identifier
                       | "[" expression "]"
```

**Note:** `lvalue` is an identifier (with optional member access and/or array indexing) that can be assigned to. Parenthesized expressions are NOT lvalues — `(x) = 5` is parsed as a comparison.

```sard
x = 42
point.x = 100
arr[0] = "first";

// Compound assignment
count = 10
count += 5       // count = 15
count -= 3       // count = 12

x = 0
x += 1           // x = 1
x -= 1           // x = 0

arr[0] += 1      // increment element
```

Assignment updates the variable in the **nearest enclosing scope** where it is defined. If not found anywhere, it creates a new variable in the current scope. The semicolon is optional at end of line.

**Assignment Target Restriction:** Assignment targets must be `lvalue` (identifier with optional member/index access). Parenthesizing the target changes it to an expression, causing `=` to be parsed as **comparison** instead of assignment:

```sard
x = 5           // Assignment: x is assigned 5
(x) = 5         // Comparison: checks if x equals 5, result is discarded
                // (x) is an expression, not an lvalue target

// For complex targets, use direct member/index access without extra parentheses:
arr[0] = 10     // Valid: array element assignment
point.x = 100   // Valid: member assignment
```

**Note:** This is intentional behavior. Parentheses create an expression context where `=` is always comparison. To use the value of a parenthesized expression in assignment, store it in a variable first:

```sard
result = (x)    // First evaluate (x), then assign to result
result = 5      // Now assign to result
```

For array values, assignment performs a **deep copy** (see Array Semantics).

**Context-Dependent Meaning of `=` (Three Meanings by Design):**

The same token `=` has **three different meanings** based on syntactic context — this is by design:

| Context | Meaning | Example |
|---------|---------|---------|
| Statement with `lvalue` LHS | **Assignment** | `x = 5;` assigns `5` to `x` |
| Expression | **Equality comparison** | `if (x = 5)` compares `x` and `5` for equality |
| Bare statement (no LHS) | **Block return** | `= result;` sets the block's return value |

The parser distinguishes based on position:
- At **statement level**, when `=` has an `lvalue` on the left side, it is **assignment**
- At **statement level**, when `=` appears alone with an expression (no left-hand side), it is a **block return statement**
- In **expressions**, `=` is always **value equality** comparison (along with `<>`, `!=`). `==` is **type comparison**.

**Prefix Inc/Dec with Comparison:** When a prefix `++` or `--` appears before an identifier, the identifier is no longer an `lvalue` at the statement level. Thus `=` becomes comparison:

```sard
// At statement level:
a = --b = c     // Parsed as: a = ((--b) = c)  // prefix dec, then comparison, then assign to a
                // NOT: a = --(b = c) -- b=c is comparison (b == c), returns boolean
                // a receives result of comparison between (b-1) and c

// Explicit grouping to clarify intent:
a = (--b) = c   // Same as above - prefix dec, comparison, assign to a
```

**Compound Assignment:** `+=` and `-=` are shorthand for addition/subtraction followed by assignment. `x += y` is semantically equivalent to `x = x + y`, and `x -= y` is equivalent to `x = x - y`. If the variable does not exist, it is created with an initial value of 0 before the operation.

### 5.4 Return Statement

```
return-statement     := "=" expression statement-term
```

Sets the block's return value. **Does NOT terminate execution** — subsequent statements continue to run. The last executed return statement determines the block's value. For early exit from a block, use `break` (if defined by addon, see §9.4). To return early from the current callable (like Pascal's `Exit` or C's `return`), use the built-in `exit(value)` callable (see §9.4). The semicolon is optional at end of line; return/newline acts as statement terminator.

At the statement level, a bare `= expression` (without a left-hand side) is parsed as a block return. This is unambiguous because assignment requires an `lvalue` on the left.

**Context Restriction:** A bare `=` is only valid as a direct statement within a block or at the top level of a program. It is **not valid** inside expression contexts such as:
- Within parentheses: `(= 5)` is invalid
- As a function argument: `print(= 5)` is invalid
- In conditions: `if (= 5) { ... }` is invalid

```sard
{
    x = 10
    = x * 2       // block value = 20 - valid as direct statement
    print("still running")  // this executes!
}

// Multiple returns - last one executed wins:
result = {
    = 10;        // first return, block value temporarily 10
    = 20;        // second return, block value becomes 20 (overrides)
    30;          // expression statement, value discarded
}               // result = 20 (the last executed return statement)

// Invalid usage (these will not parse):
// result = (= 5)           // ERROR: bare = inside expression
// if (= x) { ... }         // ERROR: bare = in condition
// print((= 5))             // ERROR: bare = in parentheses
```

### 5.5 Expression Statement

```
expression-statement := expression statement-term
```

Any expression can be used as a statement (e.g., function calls with side effects). The semicolon is optional at end of line.

```sard
print("hello")
do_something()
```

### 5.6 Block Statement

```
block-statement      := block
```

A block used as a statement creates a new scope but does not automatically capture its return value unless assigned.

**Block Termination Rule:** A `}` normally terminates the statement in which it appears. Statements ending with a block do not require an explicit semicolon. However, when `}` is followed by a continuation token (like `else`) — possibly after intervening newlines — parsing continues to form multi-block constructs (e.g., `if ... else`). In this case, the block boundary is recognized but the outer statement does not terminate until the last block closes.

```sard
{
    temp = 1;
    temp = temp + 1;
}
```

**Grammar Ambiguity:** `block` also appears as a `primary` expression (via `expression-statement`). A bare `{ ... }` as a statement is simultaneously valid as both a `block-statement` and an `expression-statement`. The parser resolves this by trying `block` before `expression-statement` — both produce the same AST, so the order does not affect behavior.

```sard
// Parsed as block-statement (not expression-statement):
{
    x = 1
    x + 2
}               // block value is discarded

// Same parse tree, different path:
//   statement → block-statement → block
//   OR
//   statement → expression-statement → expression → primary → block
// Both produce identical AST. Parser priority: try block-statement first.
```

The `block` alternative in `statement` exists for clarity in the grammar. Implementations can safely parse a bare block through the `expression-statement` path and get the same result.

---

## 6. Program Structure

```
program              := statement*
```

A Sard script is a flat sequence of statements. There is no explicit `main` function.

```sard
// Top-level declarations
x : integer = 10;

// Top-level expression
print(x);

// Top-level return value (program result)
= x * 2;
```

---

## 7. Scoping Rules

### 7.1 Scope Creation

Scopes are created by:
- Blocks (`{ ... }`)
- Callable object invocation

### 7.2 Variable Resolution

When resolving an identifier:
1. Look in the current scope's members.
2. If not found, look in the parent scope.
3. Continue up the parent chain.
4. If not found anywhere, raise a runtime error.

```sard
outer = 10;
{
    inner = 20;
    print(outer);   // 10 — found in parent
    print(inner);   // 20 — found in current
}
// print(inner);    // ERROR — inner not visible here
```

### 7.3 Assignment Scoping

When assigning to an existing variable, the interpreter walks up the parent chain and updates the **nearest** definition. If no definition exists, a new variable is created in the current scope.

```sard
x = 1;
{
    x = 2;          // updates outer x
    y = 3;          // creates new y in inner scope
}
print(x);           // 2
// print(y);        // ERROR
```

---

## 8. Object Model

### 8.1 Everything Is an Object

All values in Sard are `SardObject`s with:
- `value` — primitive value (int, float, str, bool, list, etc.)
- `members` — dictionary of child objects
- `parent` — parent object for scope resolution and prototype lookup
- `params` — parameter names (if callable)
- `body` — AST block (if callable)
- `callable` — boolean flag

### 8.2 Prototype Chain

When constructing with `~Proto`, the new instance's `parent` is set to `Proto`. Member lookup falls through to the prototype. Writing to a member creates a shadowing property on the instance, leaving the prototype unchanged.

When constructing with `~~Proto`, a shallow copy of all members is made; the new instance does **not** share state with the prototype.

### 8.3 Reference Operator

The `@` operator creates a **reference** to an existing object or variable. The new identifier points to the same underlying value or object instance — modifications through either identifier affect the same data.

```sard
obj : { x : integer = 0; }
ref = @obj;        // ref and obj are the same object

ref.x = 10;
print(obj.x);     // 10 (same object)
print(ref.x);     // 10

// Works with any value, not just objects
x = 10
p = @x;           // p references x
x = 20;
print(p);         // 20 (p reflects the updated value of x)
```

Use `@` when you need multiple names for the same data. Use `~` when you need a new instance that inherits from a prototype.

### 8.4 Callable Objects

Objects with `callable = true` can be invoked. Invocation:
1. Creates a new scope whose parent is the object's parent (or the object itself).
2. Binds arguments to parameter names. Omitted arguments use the parameter's default value if one was declared, otherwise `none`.
3. Executes the object's body block.
4. Returns the block's return value.

```sard
greet : (name) {
    msg = "Hello, " + name;
    print(msg);
    = msg;
}

result = greet("World");
```

### 8.5 Array Semantics

Arrays are ordered, mutable collections stored as the `value` of a `SardObject`. Array literals (`[...]`) create new array objects.

**Copy on Assignment:** When an array is assigned with `=`, a **deep copy** is performed. The target variable receives a new array with a full recursive copy of all elements, including nested arrays and objects. Mutations to the copy never affect the original at any depth.

```sard
a = [1, 2, 3];
b = a;         // b is a deep copy
b[0] = 99;
print(a[0]);   // 1 — a is unaffected
print(b[0]);   // 99

// Deep copy also applies to nested elements
nested = [[1, 2], [3, 4]];
copy = nested;
copy[0][0] = 99;
print(nested[0][0]);  // 1 — nested is unaffected (deep copy)
print(copy[0][0]);    // 99
```

**Element Assignment:** Array element assignment updates the array at the given index.

```sard
nums = [10, 20];
nums[0] = 100;    // nums is now [100, 20]
```

---

## 9. Built-in Objects

The runtime provides these built-in objects in the root scope:

### 9.1 Built-in Callable Objects

The following are callable objects provided by the runtime:

| Object | Behavior |
|--------|----------|
| `print` | Prints arguments to output |
| `if` | Conditional execution |
| `while` | Conditional loop construct |
| `loop` | Counted or endless loop construct |
| `for` | Iterate over array or string elements |
| `else` | Used with `if` for alternative branch |
| `negate` | Numeric negation (callable version) |
| `break` | Exits from loop or block (runtime-defined via addons, not reserved) |
| `exit` | Exits the current callable with an optional return value (not reserved) |
| `len` | Returns the length of an array or string |
| `now` | Returns the current date/time as a `date` value |
| `timestamp` | Returns the current Unix timestamp as an `integer` |
| `sleep` | Pauses execution for the specified number of milliseconds |

**Note on `else`**: `else` serves a dual role. Syntactically, `else { ... }` is parsed as a **named block** that is passed by name to the preceding callable (e.g., `if`, `while`). At the same time, `else` exists as a built-in callable object in the root scope, which is the default handler that `if` and `while` delegate to when evaluating the alternate branch. Overriding the `else` object changes the behavior of `else` blocks across all constructs.

**Note:** `break` is not a reserved word and is not built into the core language. It is declared at runtime by addons and can be shadowed by local declarations or replaced with custom implementations.

**Note:** `exit` is also not a reserved word. It is provided as a built-in callable object by the runtime and can be shadowed by local declarations like any other identifier.

These callable objects can be invoked with arguments, blocks, or both. They can be assigned to variables or passed as arguments.

```sard
my_print = print;
my_print("Hello");

my_if = if;
my_if (x > 0) { print("positive") } else { print("non-positive") };
```

### 9.2 Operators

Sard has two categories of operators with different extensibility models:

1. **Symbol-based operators** (`+`, `-`, `*`, `/`, etc.) — syntactic primitives with fixed precedence and behavior
2. **Named operators** (`mod`, `and`, `or`, `not`) — implemented as operator handler objects that can be defined, overridden, or extended via addons

---

**Symbol-Based Operators (syntactic primitives, fixed):**

These operators are built into the parser with fixed precedence tables. They cannot be changed at runtime.

**Arithmetic Operators:**
| Operator | Type | Behavior |
|----------|------|----------|
| `+` | Binary infix | Addition |
| `-` | Binary infix | Subtraction |
| `*` | Binary infix | Multiplication |
| `/` | Binary infix | Division |
| `^` | Binary infix | Power (exponentiation) |
| `%` | Postfix | Percent (divide by 100) |
| `++` | Prefix/postfix | Increment |
| `--` | Prefix/postfix | Decrement |

**Value Comparison Operators:**
| Operator | Behavior |
|----------|----------|
| `=` | Value equality |
| `<>` / `!=` | Inequality |
| `<` | Less than |
| `>` | Greater than |
| `<=` | Less or equal |
| `>=` | Greater or equal |

**Type Comparison Operator:**
| Operator | Behavior |
|----------|----------|
| `==` | Type check (like Pascal `is`) |

**Logical Operators:**
| Operator | Behavior |
|----------|----------|
| `&` | Logical AND (symbol-based) |
| `\|` | Logical OR (symbol-based) |
| `!` | Logical NOT (symbol-based) |

**Unary Operators:**
| Operator | Behavior |
|----------|----------|
| `-` | Numeric negation |
| `+` | Numeric identity |

---

**Named Operators (extensible object handlers):**

Named operators are parsed as operator tokens with fixed precedence, but their implementation is provided by operator handler objects in the runtime. These can be defined, overridden, or extended via addons.

| Operator | Type | Behavior | Symbol Equivalent |
|----------|------|----------|-------------------|
| `mod` | Binary infix | Modulo (remainder) | (none) |
| `and` | Binary infix | Logical AND | `&` |
| `or` | Binary infix | Logical OR | `\|` |
| `not` | Unary prefix | Logical NOT | `!` |

**Extending Named Operators:**
- Built-in named operators can be overridden by redefining their handler objects
- New named operators can be added via addons (registered with the lexer and runtime)
- Named operators integrate with the existing precedence system

```sard
sum = 10 + 20;
diff = 50 - 15;
prod = 6 * 7;
quot = 100 / 4;
pow = 2 ^ 8;          // 256 (2 to the power of 8)
rem = 17 mod 5;       // mod is a named operator
is_equal = a = b;     // first = is assignment, second = is comparison
is_diff = a <> b;
tax = price * 20%;

// Using both symbol and named operators (equivalent)
a_and_b = a & b;      // symbol-based
also_a_and_b = a and b;  // named operator (object-based)
```

```sard
neg = negate(5);      // -5
inv = not true;       // false (unary operator)
result = a mod b;     // modulo operation (named binary operator)
```

### 9.3 I/O

| Object | Behavior |
|--------|----------|
| `print` | Prints arguments separated by spaces, followed by newline |

```sard
print("hello", 42, true);
```

### 9.4 Control Flow

#### `if`

`if` is a built-in callable object that evaluates a condition and executes one of its received blocks.

**Note:** Control flow constructs (`if`, `else`, `while`, etc.) are built-in callable objects.

```sard
// Named else block
if (x < 10) {
    print("less than 10")
} else {
    print("10 or more")
};
```

**`else if`:**

`if` supports chained `else if` alternatives. Each `else if` has its own condition and body. Conditions are tested in order after the main `if` condition is false, and the first matching body runs. An optional final `else` block runs if none of the conditions matched.

```sard
score : integer = 85

if (score >= 90) {
    print("Grade: A")
} else if (score >= 80) {
    print("Grade: B")
} else if (score >= 70) {
    print("Grade: C")
} else {
    print("Grade: D or F")
}
```

**How it works:**
- `if` and `else` are both built-in objects in the root scope
- `if` accepts a condition, an anonymous block, and optionally named `else` and `else-if` blocks
- The `else { ... }` syntax is parsed as a **named block** passed to the preceding call
- The `else if (cond) { ... }` syntax is parsed as a special named block (name `else-if`) passed to the preceding `if` call
- Named blocks are part of the postfix syntax: `identifier { ... }` following a call
- Built-in objects inspect received blocks (by name or position) and decide which to execute

#### `while`

**Standard form** (condition in parentheses, body as block):
```sard
x = 0
while (x < 10) {
    print(x)
    x += 1          // or x++
}
```

**With else block** (else runs if condition is initially false):
```sard
n = 20
while (n < 10) {
    print(n)
    n++
} else {
    print("n is already over 10")
}
// Output: "n is already over 10" (else block runs once because n=20, condition initially false)
```

**Note:** `++`, `--`, `+=`, and `-=` are all available. The example above uses `x += 1` for clarity.

**Syntax Rules:**
- `while` requires an argument-list for the condition: `while (condition) { body }`
- With else: `while (condition) { body } else { alt }` - else runs if condition initially false
- **Endless loop:** `while { body }` - block-only form creates an endless loop (condition always true)
- **Valid:** `while (cond) { } else { }` — `else` is the named block; runs if condition is initially false

**Style Note:** Control flow statements ending with a `}` block conventionally omit the trailing semicolon — the closing brace visually terminates the statement. The grammar accepts semicolons after all statements, but they are typically omitted for readability when a block concludes the statement.

**Block Continuation Rule:** When a `}` is followed by specific continuation tokens (like `else`), parsing continues. Otherwise, the statement implicitly terminates:

```sard
// Block visually terminates - no semicolon needed (but allowed)
while (x < 10) {
    print(x)
}

// Block followed by continuation token (else) - continues parsing
if (x) {
    = 1
} else {          // 'else' continues the if statement
    = 2
}

// while with else - else block runs if condition initially false
while (x < 10) {
    print(x)
    x++
} else {
    print("skipped")
}
```

#### `loop`

`loop` is a built-in callable object that repeats a body block. It can run a fixed number of times, or it can run forever until a `break` is encountered.

```sard
// Repeat 5 times
loop(5) {
    print("hello")
}
```

**Syntax:**

```sard
loop(count) {
    body
}

loop(count, indexVar) {
    body
}

loop {
    body
}

loop() {
    body
}
```

- `count` — an expression that evaluates to an integer; specifies how many times to execute the body. When omitted (by writing `loop { ... }` or `loop() { ... }`), the loop runs forever.
- `indexVar` — an identifier that names an optional loop variable. In each iteration it is bound to the current zero-based index (`0`, `1`, … `count-1`).
- `body` — an anonymous block executed once per iteration.

**Behavior:**
- The `count` expression is evaluated once, before the first iteration.
- With a count, the body block is executed exactly that many times. A negative or zero count causes the body to be skipped.
- Without a count (`loop { ... }` or `loop() { ... }`), the loop runs endlessly until `break` is called.
- `break` can be used to exit the loop early.

```sard
// Count up with loop
loop(3) {
    print("hello")
}
// Output: hello, hello, hello

// Loop with an index variable
loop(3, i) {
    print(i)
}
// Output: 0, 1, 2

// Loop with a variable count
n = 4
loop(n) {
    print("tick")
}

// Endless loop with explicit break
i = 0
loop {
    print(i)
    i += 1
    if (i = 3) {
        break
    }
}
// Output: 0, 1, 2

// Empty parentheses are equivalent to no argument
loop() {
    print("once")
    break
}
// Output: once
```

**Note:** `loop` is an ordinary built-in callable object, not a reserved word. It can be shadowed by local declarations or passed around like any other callable.

#### `for`

`for` is a built-in callable object that iterates over the elements of an array or the characters of a string. It accepts two arguments and an anonymous body block.

```sard
for(collection, value) {
    body
}
```

- `collection` — an expression that evaluates to an `array` or a `string`
- `value` — an identifier that names the loop variable; in each iteration it is bound to the current array element or a single-character string
- `body` — an anonymous block executed once per element/character

**Behavior:**
- The collection expression is evaluated once, before the first iteration.
- For arrays, the body is executed once for each element, with the loop variable bound to a copy of that element.
- For strings, the body is executed once for each character, with the loop variable bound to a one-character string.
- A zero-length array or empty string causes the body to be skipped.
- `break` can be used to exit the loop early.
- Passing any other type raises a runtime error.

```sard
// Iterate over an array
nums = [10, 20, 30]
for(nums, v) {
    print(v)
}
// Output: 10, 20, 30

// Iterate over a string
for("hello", c) {
    print(c)
}
// Output: h, e, l, l, o

// Sum elements
sum = 0
for([1, 2, 3, 4, 5], v) {
    sum += v
}
print(sum)               // 15

// Break early
for([1, 2, 3, 4, 5], v) {
    if (v = 3) {
        break
    }
    print(v)
}
// Output: 1, 2
```

**Note:** `for` is an ordinary built-in callable object, not a reserved word. It can be shadowed by local declarations or passed around like any other callable.

#### `break`

`break` is a callable object (not a reserved word) that can be defined at runtime via addons. It terminates the current loop or exits from the current block, allowing for early exit from control flow structures.

**Note:** Since `break` is not a reserved word, it can be shadowed by local declarations or replaced by addons. The default implementation (if provided by an addon) allows breaking out of loops and blocks.

```sard
// Example usage if break is defined by an addon
i = 0;
while (i < 100) {
    if (i = 50) {
        break;        // exit the loop early (no parentheses needed)
    };
    print(i);
    i++;
}

// Can also be used to exit from a block early
result = {
    if (some_condition) {
        break;        // exit from the outer block (no parentheses needed)
    };
    = calculate_value();
};
```

**Implementation Note:** Addons can define `break` as a callable object that, when invoked, signals the interpreter to unwind the execution stack until the nearest enclosing loop or block boundary. The exact semantics (e.g., whether it accepts an argument to return a value) are defined by the addon implementation.

#### `exit`

`exit` is a built-in callable object (not a reserved word) that immediately terminates the current callable and returns a value to its caller. It behaves like Pascal's `Exit` procedure or C's `return` statement.

```sard
add_one : (n) {
    exit(n + 1)        // return early with n + 1
    print("unreachable")
}
print(add_one(5))      // 6

// Exit from nested control flow
find_first : (arr) {
    for(arr, v) {
        if (v > 5) {
            exit(v)    // return the first matching element
        }
    }
    = none             // only reached if no element matched
}
print(find_first([1, 2, 8, 9]))  // 8
print(find_first([1, 2, 3]))     // none

// Exit without a value returns none
void_callable : () {
    exit
    = "unreachable"
}
print(void_callable()) // none
```

**Behavior:**
- `exit(value)` stops execution of the current callable body immediately and returns `value` to the caller
- `exit` (or `exit()`) with no argument returns `none`
- `exit` propagates out of nested blocks, `if` branches, and loops inside the callable
- `exit` does **not** propagate past the current callable — calling another callable that uses `exit` does not cause the caller to exit
- `exit` at the top level of a program stops program execution
- Since `exit` is a callable object, it can be shadowed by a local declaration or assigned to a variable

**Note:** `exit` is distinct from the bare `= value` block return statement (§5.4). The block return sets the block's eventual value but does not terminate execution, whereas `exit` immediately returns from the enclosing callable.

### 9.5 Length Function

The built-in callable `len` returns the number of elements in an array or the number of characters in a string.

```sard
arr = [10, 20, 30]
print(len(arr))          // 3

s = "hello"
print(len(s))            // 5

empty = []
print(len(empty))        // 0

multiline = "line1" \n "line2"
print(len(multiline))    // 11
```

**Behavior:**
- `len(array)` returns the array element count as an `integer`
- `len(string)` returns the string length (in characters) as an `integer`
- Passing any other type raises a runtime error

### 9.6 Sleep Function

The built-in callable `sleep` pauses execution for a specified number of milliseconds. It accepts one integer argument and returns `none`.

```sard
sleep(1000)   // pause for one second
```

**Behavior:**
- `sleep(milliseconds)` suspends the current thread for at least the requested duration
- The argument must be an `integer` (negative values are treated as zero)
- Returns `none`

```sard
print("start")
sleep(500)    // pause for half a second
print("end")
```

### 9.7 Date and Time Functions

The runtime provides two built-in callable objects for working with date and time, plus date literals for fixed calendar dates and times:

```sard
print(now())                    // current date/time as a date value
print(timestamp())              // current Unix timestamp as an integer
print(0t19711019)               // 1971-10-19 00:00:00 as a date value
print(0t1971_10_19_03_35_52)    // 1971-10-19 03:35:52 as a date value
```

**Behavior:**
- `now()` returns the current date and time as a `date` value
- `timestamp()` returns the current Unix timestamp (seconds since epoch) as an `integer`
- Date literals support the forms `0tYYYYMMDD`, `0tYYYYMMDDHH`, `0tYYYYMMDDHHNN`, and `0tYYYYMMDDHHNNSS`, with optional underscores between digit groups. They produce a `date` value in local time.

Type checks work as expected:

```sard
print(now() == date)                  // true
print(timestamp() == integer)         // true
print(0t1971_10_19 == date)           // true
print(0t1971_10_19_03_35_52 == date)  // true

d : date = 0t1971_10_19_03_35_52
print(d)                              // 1971-10-19 03:35:52
```

### 9.8 Extending the Language

Sard supports extensibility through callable objects and addons:

1. **Custom Callable Objects** — Define new functions/objects using the `: (params) { ... }` syntax
2. **Prototype Extension** — Create new object types with `~` and `~~` construction
3. **Custom Named Operators** — Define new named operators (e.g., `xor`, `shl`, `shr`) by creating operator handler objects. Named operators are registered with the lexer (for token recognition) and the runtime (for behavior implementation), and they integrate with the existing precedence system.
4. **Override Built-in Named Operators** — Built-in named operators (`mod`, `and`, `or`, `not`) can be overridden by replacing their operator handler objects in the root scope.

```sard
// Custom callable object
pow : (base, exp) {
    result = 1;
    i = 0;
    while (i < exp) {
        result = result * base;
        i += 1;
    };
    = result;
};

val = pow(2, 8);   // 256
```

---

## 10. Preprocessor

Preprocessor regions are tokenized but left unprocessed by the interpreter. External tools can replace them.

```
preprocessor         := "{?" <any characters>* "?}"
```

**Lexer Note:** The lexer must check for `{?` before `{` as a standalone token. Since `{?` is a multi-character token, it takes priority over the single-character `{` when followed immediately by `?`. Without this prioritization, `{` would be tokenized as the start of a block, preventing preprocessor region recognition.

```sard
{?
    #include "config.sard"
?}
```

---

## 11. Complete Examples

### Example 1: Hello World

```sard
print("Hello, World!");
```

### Example 2: Variables and Arithmetic

```sard
width : integer = 10;
height : integer = 20;
area = width * height;
print(area);
```

### Example 3: Blocks and Return Values

```sard
result = {
    a = 5;
    b = 10;
    = a + b;
};
print(result);   // 15
```

### Example 4: Callable Objects (Functions)

```sard
factorial : (n) {
    = if (n <= 1) {
        1
    } else {
        sub = factorial(n - 1)
        n * sub
    }
}

print(factorial(5));   // 120
```

### Example 5: Objects and Prototypes

```sard
point : {
    x : integer = 0;
    y : integer = 0;
    to_string : () {
        = "(" + x + ", " + y + ")";
    };
}

p = ~point;
p.x = 100;
p.y = 200;
print(p.to_string());   // (100, 200)
```

### Example 6: Arrays

```sard
nums = [10, 20, 30, 40];
print(nums[0]);         // 10
print(nums[2]);         // 30
nums[1] = 99;
print(nums[1]);         // 99
```

### Example 7: String Concatenation with Escapes

```sard
greeting = "Hello" \n "World" \t "!";
print(greeting);
```

### Example 8: Bank Account

```sard
bank_account : {
    balance : integer = 0;

    deposit : (amount) {
        balance = balance + amount;
        = balance;
    };

    withdraw : (amount) {
        if (amount <= balance) {
            balance = balance - amount
            = true
        } else {
            = false
        }
    };

    get_balance : () {
        = balance;
    };
}

acc = ~bank_account;
acc.deposit(100);
acc.withdraw(30);
print(acc.get_balance());   // 70
```

### Example 9: Deep Qualified Access

```sard
app : {
    config : {
        debug : boolean = true;
        version : string = "1.0.0";
    };
}

print(app.config.version);
app.config.debug = false;
```

### Example 10: Control Flow with if/else/else if

```sard
score : integer = 85;

if (score >= 90) {
    print("Grade: A");
} else if (score >= 80) {
    print("Grade: B");
} else if (score >= 70) {
    print("Grade: C");
} else {
    print("Grade: D or F");
};
```

### Example 11: Percent Operator

```sard
price = 200;
tax_rate = 15%;
tax = price * tax_rate;       // 30
final = price * 115%;          // 230 (add 15%)
sale = price * 75%;             // 150 (25% discount)
print(tax);
print(final);
print(sale);
```

### Example 12: Length Function

```sard
arr = [10, 20, 30, 40]
print(len(arr))          // 4

s = "hello"
print(len(s))            // 5

empty = []
print(len(empty))        // 0
```

### Example 13: Counted Loop

```sard
sum = 0
loop(5) {
    sum += 1
}
print(sum)               // 5
```

### Example 14: Iterate Over Array or String

```sard
for([10, 20, 30], v) {
    print(v)
}
// Output: 10, 20, 30

for("hello", c) {
    print(c)
}
// Output: h, e, l, l, o
```

### Example 15: None Literal

```sard
x = none
print(x)                    // none
print(x == none)            // true

// none is falsy
if (none) {
    print("truthy")
} else {
    print("falsy")          // prints "falsy"
}

maybe : (value) {
    = if (value == none) {
        "missing"
    } else {
        "got: " + string(value)
    }
}

print(maybe(none))          // missing
print(maybe(42))            // got: 42
```

---

## 12. Error Handling

The interpreter raises three categories of errors:

### 12.1 Lexer Errors (`LexerError`)

- Unterminated string literal
- Unterminated comment
- Unexpected character

### 12.2 Parser Errors (`ParseError`)

- Unexpected token
- Missing semicolon
- Invalid assignment target
- Unmatched braces / parentheses / brackets

### 12.3 Runtime Errors (`SardRuntimeError`)

- Undefined identifier
- Non-callable object invoked
- Division by zero (Python propagates)
- Invalid array index
- Type mismatch in operations (Python propagates)

---

## 13. EBNF Summary

```ebnf
program              := statement*

statement            := declaration
                        | empty-statement
                        | assignment
                        | return-statement
                        | expression-statement
                        | block-statement

block-statement      := block

empty-statement      := (";" | newline)+

declaration          := identifier ":" declaration-body statement-term?

declaration-body     := type ("=" expression)?
                        | type? (newline* parameter-list)? newline* block?
                       (* Note: parameter-list is optional for parameterless callable declarations.
                        * When block is absent, this declares a callable signature (parameters only)
                        * that can be defined later or serves as a forward declaration.
                        * Newlines are ignored before a parameter list or block in callable declarations. *)

type                 := identifier ("." identifier)*

parameter-list       := "(" (parameter ("," parameter)*)? ")"

parameter            := identifier (":" type)? ("=" expression)?

assignment           := lvalue "=" expression statement-term
                        | lvalue "+=" expression statement-term
                        | lvalue "-=" expression statement-term

(* lvalue is an identifier (with optional member/index suffixes) suitable for assignment *)
(* Used for: assignment targets and postfix ++/-- *)
lvalue               := lvalue-primary (lvalue-suffix)*
lvalue-primary       := identifier
lvalue-suffix        := "." identifier
                        | "[" expression "]"

return-statement     := "=" expression statement-term

expression-statement := expression statement-term

statement-term       := ";" | newline | "}"

(* Block with implicit statement terminator at closing brace *)
block                := "{" block-body "}"

block-body           := statement*

expression           := logical_or

logical_or           := logical_and (("|" | "or") logical_and)*

logical_and          := comparison (("&" | "and") comparison)*

comparison           := type-comparison (("=" | "<>" | "!=" | "<" | ">" | "<=" | ">=") type-comparison)*
                        (* Chaining: a < b < c is captured as a flat sequence [a, <, b, <, c]
                         * and semantically expanded to (a < b) and (b < c) — like Python.
                         * The parser must NOT build a left-associative binary tree;
                         * instead it collects the chain as a flat list for later expansion. *)

type-comparison      := additive ("==" additive)?      (* Type comparison - like Pascal `is`; does NOT chain *)
                        (* Higher precedence than value comparisons — binds tighter than =, <>, <, etc. *)

additive             := multiplicative (("+" | "-") multiplicative)*

multiplicative       := power (("*" | "/" | "mod") power)*

power                := unary ("^" power)?     (* Right-associative: a ^ b ^ c = a ^ (b ^ c) *)

unary                := ("-" | "+" | "!" | "not") unary 
                       | prefix-inc-dec 
                       | postfix
                       (* Note: prefix inc/dec require lvalue; other unary ops take any unary expression *)

prefix-inc-dec       := ("++" | "--") lvalue

(* Postfix expressions - primary with chain of access operations, optional single call, more access, then final ops *)
postfix              := primary (postfix-link)*

(* Each link in the chain is one operation: access, call, block, or final operator *)
postfix-link         := postfix-access
                      | postfix-call
                      | block
                      | postfix-final

(* Access operations: member or index *)
postfix-access       := "[" expression "]" 
                      | "." identifier

(* Call operations: argument-list and named-block are separate call forms.
 * Multiple named-blocks can appear in a chain (if/else-if/else).
 * At most ONE argument-list is allowed per postfix chain.
 * func()() is invalid — the result of a call cannot be called again.
 * Standard EBNF cannot express "at most one" — this constraint is enforced
 * by the parser: after an argument-list is consumed, subsequent postfix-call
 * links may only contain named-blocks. *)
postfix-call         := argument-list block?
                       | named-block

(* Final postfix operations: end the chain, no further operations allowed *)
postfix-final        := postfix-percent
                      | postfix-inc-dec

postfix-percent      := "%"

postfix-inc-dec      := ("++" | "--")    (* Semantic constraint: the entire preceding postfix chain must be an lvalue (identifier, member access, or index); enforced by semantic analysis *)

named-block          := identifier argument-list? block
                      | "else" "if" argument-list block     (* else-if chain: else if (cond) { ... } *)
                      | "else" block                        (* final else block *)
                      (* SYNTACTIC CONSTRAINT: Named blocks can only follow: *)
                      (*   - argument-list: if (cond) { } else { } *)
                      (*   - anonymous block: while (cond) { } else { } *)
                      (*   - another named-block: chained named blocks *)
                      (* The EBNF above cannot express this constraint - it must be enforced by the parser. *)

primary              := literal
                        | identifier
                        | qualified-identifier
                        | "(" expression ")"
                        | block
                        | "~" identifier
                        | "~~" identifier
                        | "@" expression
                        | array-literal
                        | type-cast

type-cast            := type-name "(" expression ")"

type-name            := "integer" | "number" | "string" | "boolean"
                        | "color" | "currency" | "date" | "array" | "object"

literal              := integer-literal
                        | number-literal
                        | hex-literal
                        | string-literal
                        | color-literal
                        | currency-literal
                        | date-literal
                        | none-literal

none-literal         := "none"   (* case-insensitive *)

argument-list        := "(" (argument ("," argument)*)? ")"
argument             := expression?

array-literal        := "[" (expression ("," expression)*)? "]"

qualified-identifier := identifier ("." identifier)*
```

---

## 14. Summary of Symbols

| Symbol | Usage |
|--------|-------|
| `:` | Type annotation / declaration |
| `=` | Assignment (statement) / Equality comparison (expression) / Block return |
| `.` | Member access |
| `+` | Addition |
| `-` | Subtraction |
| `*` | Multiplication |
| `/` | Division |
| `^` | Power (exponentiation) |
| `mod` | Modulo |
| `<>` | Not equal |
| `!=` | Not equal (alternative) |
| `<` | Less than |
| `>` | Greater than |
| `<=` | Less or equal |
| `>=` | Greater or equal |
| `!` | Logical NOT (symbol operator) |
| `not` | Logical NOT (extensible named operator) |
| `&` | Logical AND (symbol operator) |
| `and` | Logical AND (extensible named operator) |
| `|` | Logical OR (symbol operator) |
| `or` | Logical OR (extensible named operator) |
| `~` | New object instance (prototype) |
| `~~` | New object instance with shallow copy |
| `@` | Reference (alias) to existing object |
| `++` | Increment (prefix or postfix) |
| `--` | Decrement (prefix or postfix) |
| `+=` | Compound addition assignment |
| `-=` | Compound subtraction assignment |
| `#` | Color literal prefix |
| `{ }` | Block / object body / named block body |
| `identifier { }` | Named block (e.g. `named_block { ... }`) |
| `else if (cond) { }` | Chained alternative branch for `if` |
| `type-name ( expr )` | Type cast (Pascal-style, e.g. `integer(x)`) |
| `( )` | Argument list / grouping |
| `[ ]` | Array literal / index |
| `;` | Statement terminator (optional at end of line) |
| `,` | Separator |
| `//` | Single-line comment |
| `/* */` | Multi-line comment |
| `{* *}` | Block comment |
| `{? ?}` | Preprocessor region |
