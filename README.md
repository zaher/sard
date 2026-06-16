# Sard Script Language

> A prototype-based, expression-oriented scripting language with gradual typing, financial calculations, and modern conveniences.

## Overview

Sard is a small but expressive scripting language designed for clarity, flexibility, and precision.

Sard is not trying to be a generic "everyone" language — it is a BASIC/Pascal-flavored, expression-oriented scripting language for two specific audiences: kids making games and accountants doing calculations. That is a much more coherent identity.

### Key Characteristics

- **Gradual Typing**: Untyped variables for flexibility (`x = 10`) or typed variables for safety (`x : integer = 10`)
- **Everything is an Object**: No functions, only callable objects; no reserved words beyond built-in type names
- **Expression-Oriented**: Every block evaluates to a value; blocks are expressions, not just statements
- **Unicode-Aware**: Full Unicode support in identifiers and strings
- **Financial Precision**: Built-in `currency` type with 6 decimal places and accountant calculator mode
- **No Global Scope**: Lexical parent-chain scoping
- **Pascal-Style Casts**: Convert values with `integer(x)`, `number(x)`, `string(x)`, etc.
- **Date format**: d = 0t2026_10_20

## Quick Start

```sard
// Hello World
print("Hello, World!");

// Variables - untyped (dynamic)
name = "Sard"
version = 1.0
name = 42           // Valid - can change types

// Variables - typed (strict)
count : integer = 10;
count = 20;         // Valid - same type
count = "30";       // Auto-cast to 30
count = "test";     // Runtime error - invalid conversion

// Numeric literals with digit separators
population = 1_000_000;
pi = 3.14_15_92;
mask = 0xDE_AD_BE_EF;

// Arithmetic with power operator
area = 10 ^ 2;       // 100 (10 squared)
cube = 2 ^ 3;        // 8 (2 cubed)

// Financial calculations
price = $99.99;
tax = $12.3456;
total = price * 110%;     // 109.989 (add 10%)
discount = price * 75%;   // 74.9925 (25% off)

// Percent operator
rate = 50%;          // 0.5
tax_amount = 200 * 20%;   // 40

// Objects and prototypes
point : {
    x : integer = 0;
    y : integer = 0;
}

p = ~point;          // Create instance
p.x = 100;
p.y = 200;

// Callable objects (functions)
factorial : (n) {
    = if (n <= 1) {
        1
    } else {
        n * factorial(n - 1)
    }
}

print(factorial(5));  // 120

// Arrays
nums = [10, 20, 30];
print(nums[0]);      // 10
nums[1] = 99;

// Array repetition and append
zeros = [0] * 3;              // [0, 0, 0]
nums = nums + [40, 50];       // append elements

// Control flow
// There is no `else if`
score : integer = 85;

if (score >= 90) {
    print("Grade: A");
} else {
    if (score >= 80) {
        print("Grade: B");
    } else {
        print("Grade: C or lower");
    }
};

// Loops
i = 0;
while (i < 5) {
    print(i);
    i++;
}

loop(3) {
    print("hello");
}

loop(3, i) {
    print(i);        // 0, 1, 2
}

for([10, 20, 30], v) {
    print(v);
}

// Blocks as expressions
result = {
    temp = x + y;
    = temp * 2;       // Block returns this value
};

// String concatenation with escapes
greeting = "Hello" \n "World" \t "!";

// Dates
d : date = 0t1971_10_19;
print(now);          // current date/time (parens optional)
print(timestamp);    // current Unix timestamp
```

## Type System

Sard supports **gradual typing** — you choose between dynamic and static typing per variable:

### Untyped Variables (Dynamic)
```sard
x = 10;          // x is integer
x = "test";      // Valid - x becomes string
x = 3.14;        // Valid - x becomes number
```

### Typed Variables (Strict)
```sard
y : integer = 10;    // Strictly typed
y = 20;              // Valid
y = "30";            // Auto-cast to 30
y = "test";          // Runtime error!
```

### Core Types

| Type | Description | Example |
|------|-------------|---------|
| `integer` | Signed integer | `42` |
| `number` | Floating-point | `3.14` |
| `string` | Unicode string | `"hello"` |
| `boolean` | Boolean value | `true`, `false` |
| `color` | RGB (DWORD) | `#ff5733`, `#fff` |
| `currency` | Fixed-point 64-bit | `$99.99` |
| `date` | Date/time value | `0t2024_01_15`, `now()` |
| `array` | Ordered collection | `[1, 2, 3]` |
| `object` | User-defined | `~proto` |

### Type Comparison
```sard
is_int = (x == integer);     // Check if x is an integer
is_str = (x == string);      // Check if x is a string
```

### Type Casting
```sard
i = integer(3.14);        // 3
n = number("42");         // 42.0
s = string(42);           // "42"
b = boolean(1);           // true
c = currency(3.14);       // 3.140000
d = date(0);              // epoch date
```

## Operators

### Arithmetic
| Operator | Description |
|----------|-------------|
| `+` | Addition |
| `-` | Subtraction |
| `*` | Multiplication |
| `/` | Division |
| `^` | Power (exponentiation) |
| `mod` | Modulo (remainder) |
| `%` | Percent (divide by 100) |

### Assignment & Compound
| Operator | Description |
|----------|-------------|
| `=` | Assignment (statement) / Equality (expression) |
| `+=` | Add and assign |
| `-=` | Subtract and assign |
| `++` | Increment (prefix/postfix) |
| `--` | Decrement (prefix/postfix) |

### Comparison
| Operator | Description |
|----------|-------------|
| `=` | Value equality (in expressions) |
| `<>` `!=` | Not equal |
| `<` | Less than |
| `>` | Greater than |
| `<=` | Less or equal |
| `>=` | Greater or equal |
| `==` | Type check (like Pascal `is`) |

### Logical
| Operator | Description |
|----------|-------------|
| `&` `and` | Logical AND |
| `\|` `or` | Logical OR |
| `!` `not` | Logical NOT |

### Precedence (high to low)
1. `^` (power) - right-associative
2. `*`, `/`, `mod`
3. `+`, `-`
4. `=`, `<>`, `!=`, `<`, `>`, `<=`, `>=` (chaining supported)
5. `&`, `and`
6. `\|`, `or`
7. `==` (type comparison)

## Special Features

### Accountant Calculator Mode
When `%` is used with `+` or `-` at statement level, percentages are calculated relative to the left operand:

```sard
// Standard mode
result = (100 + 50%);   // 100.5

// Accountant mode (top level)
result = 100 + 50%;     // 150 (100 + 50% of 100)
result = 200 - 20%;     // 160 (200 - 20% of 200)
```

### Currency Type
Fixed-point decimal with 6 fractional digits, stored as 64-bit integer:

```sard
price = $100;           // 100.000000
tax = $12.3456;        // 12.345600
fraction = $0.000001;   // Smallest unit
salary = $1_000_000;    // 1000000.000000
```

### Numeric Literals
Numeric literals can use underscores as digit separators:

```sard
one_million = 1_000_000;
pi = 3.14_15_92;
hex = 0xDE_AD_BE_EF;
red = #FF_57_33;
price = $1_000.99;
```

### Color Shorthand
Colors support 3-digit CSS-like shorthand:

```sard
white = #fff;          // #ffffff
magenta = #f0f;        // #ff00ff
grey = #abc;           // #aabbcc
```

### Object Construction
```sard
p1 = ~point;       // New instance with prototype
p2 = ~~point;      // New instance with shallow copy
p3 = @p1;          // Reference to same object
```

### Chained Comparisons (Python-style)
```sard
if (0 <= x < 100) {     // Equivalent to (0 <= x) and (x < 100)
    print("valid index");
}
```

## Callable Objects

Callable parameters support type annotations, default values, open (variadic) parameters, and return type annotations:

```sard
// Simple callable
add : (a, b) {
    = a + b
}

// Typed parameters
divide : number (a: number, b: number) {
    = a / b
}

// Default values
greet : (name: string, suffix: string = "!") {
    = "Hello, " + name + suffix
}

// Open (variadic) parameters
sum : (values...) {
    result = 0
    for(values, v) {
        result += v
    }
    = result
}

print(sum(1, 2, 3, 4));   // 10
```

Parameterless callables can be invoked with or without parentheses:

```sard
greet : { = "Hello" }
print(greet);       // "Hello"
print(greet());     // "Hello"
```

## Arrays

### Array Literals
```sard
nums = [10, 20, 30];
mixed = [1, "hello", true];
empty = [];
```

### Array Multiplication
```sard
zeros = [0] * 3;       // [0, 0, 0]
ones = [1] * 5;        // [1, 1, 1, 1, 1]
pairs = [1, 2] * 3;    // [1, 2, 1, 2, 1, 2]
```

### Array Addition
```sard
arr = []
arr = arr + [10];      // [10]
arr += [20];           // [10, 20]
arr = arr + [30, 40];  // [10, 20, 30, 40]
```

Array addition creates a new array; the original is not modified.

## Object Model

### Prototype-Based
Objects inherit from prototypes via parent chain:

```sard
bank_account : {
    balance : currency = $0;

    deposit : (amount) {
        balance = balance + amount;
        = balance;
    };

    withdraw : (amount) {
        if (amount <= balance) {
            balance = balance - amount;
            = true;
        } else {
            = false;
        }
    };

    get_balance : () {
        = balance;
    };
}

acc = ~bank_account;
acc.deposit($100);
acc.withdraw($30);
print(acc.get_balance());   // $70
```

### Block Returns
Use `=` at statement level to set block return value:

```sard
result = {
    x = 10;
    y = 20;
    = x + y;        // Block returns 30
    print("This still executes!");
};
```

## Control Flow

### If/Else
```sard
if (condition) {
    // true branch
} else {
    // false branch
};
```

### While Loop
```sard
while (condition) {
    // loop body
}

// With else (runs if condition initially false)
while (condition) {
    // loop body
} else {
    // runs once if condition starts false
}

// Endless loop
while {
    // infinite loop
}
```

### Loop
```sard
// Repeat a fixed number of times
loop(5) {
    print("hello");
}

// With an index variable
loop(3, i) {
    print(i);        // 0, 1, 2
}

// Endless loop
loop {
    // loop forever until break
}
```

### For
```sard
// Iterate over an array
for([10, 20, 30], v) {
    print(v);
}

// Iterate over a string
for("hello", c) {
    print(c);
}

// Sum elements
sum = 0
for([1, 2, 3, 4, 5], v) {
    sum += v
}
print(sum);          // 15
```

## Built-ins

| Object | Description |
|--------|-------------|
| `print` | Print arguments to output |
| `len` | Length of array or string |
| `now` | Current date/time as `date` |
| `timestamp` | Current Unix timestamp as `integer` |
| `if` / `while` / `loop` / `for` | Control flow constructs |
| `break` | Exit loop or block (provided by runtime/addons) |

```sard
arr = [10, 20, 30];
print(len(arr));       // 3
print(len("hello"));   // 5
print(now);            // current date/time
print(timestamp);      // current Unix timestamp
```

## Comments

```sard
// Single-line comment

/*
 * Multi-line comment
 * (does not nest)
 */
```

## Examples

### Fibonacci
```sard
fib : (n) {
    = if (n <= 1) {
        n
    } else {
        fib(n - 1) + fib(n - 2)
    }
}

print(fib(10));  // 55
```

### Bank Account with Interest
```sard
account : {
    balance : currency = $0;

    deposit : (amount : currency) {
        balance = balance + amount;
        = balance;
    };

    apply_interest : (rate) {
        interest = balance * rate;
        balance = balance + interest;
        = balance;
    };
}

my_acc = ~account;
my_acc.deposit($1000);
my_acc.apply_interest(5%);    // Add 5% interest
print(my_acc.balance);       // $1050
```

### Array Operations
```sard
numbers = [10, 20, 30, 40, 50];

// Sum all elements
sum = 0;
for(numbers, v) {
    sum += v;
}
print(sum);  // 150
```

## Language Philosophy

1. **Consistency**: Everything is an object; blocks are expressions
2. **Flexibility**: Choose dynamic or static typing as needed
3. **Precision**: Built-in support for financial calculations
4. **Extensibility**: All constructs can be overridden or extended
5. **Clarity**: Minimal reserved words; symbols have fixed meanings

## Implementation Notes

- Can be embedded in host applications (Python, C, Rust, etc.)
- Supports multi-threaded execution with independent AST trees
- UTF-8 source encoding throughout
- Case-insensitive identifiers

---

**Version**: 1.0  
**License**: See LICENSE file  
**Repository**: https://github.com/zaher/sard
