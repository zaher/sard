# No Global Scope: Lexical Parent-Chain Scoping

## Overview

In many languages (Python, JavaScript, C), there's a **global scope** where variables live at the top level that everyone can access. In Sard, there is **NO global scope**—instead, scopes form a **parent chain** hierarchy, and variables are looked up by walking UP that chain.

## The Key Difference

| Traditional Language | Sard |
|---------------------|------|
| Global scope exists | No global scope—only nested scopes |
| Top-level variables are "global" | Top-level is just the outermost scope, not special |
| Functions can access globals | Objects access their parent chain |

## How It Works

When resolving an identifier, Sard:
1. Looks in the current scope's members
2. If not found, looks in the parent scope
3. Continues up the parent chain
4. If not found anywhere, raises a runtime error

When assigning to a variable, Sard walks up the chain to find the **nearest** definition and updates it. If not found, it creates the variable in the **current** scope.

## Examples

### Example 1: Nested Blocks

```sard
// Top level scope (not global, just outermost)
outer = 10;

{
    // This block has the top-level as its parent
    inner = 20;
    print(outer);   // 10 — found by walking up parent chain
    print(inner);   // 20 — found in current scope
}

// print(inner);    // ERROR — inner not visible here
print(outer);      // 10 — outer is still in current scope
```

### Example 2: Callable Objects Create Their Own Scope

```sard
// Top-level variable
message = "Hello";

greet : (name) {
    // This callable's scope has top-level as parent
    full = message + " " + name;   // Can access "message" from parent
    = full;
}

print(greet("World"));  // "Hello World"
```

### Example 3: Deep Nesting

```sard
level1 = "I am at level 1";

{
    level2 = "I am at level 2";
    
    {
        level3 = "I am at level 3";
        
        print(level1);   // Found in grandparent (top-level)
        print(level2);   // Found in parent
        print(level3);   // Found in current scope
    }
    
    print(level1);   //  ✓
    print(level2);   //  ✓
    // print(level3); // ERROR — not in this scope chain
}
```

### Example 4: Assignment Walks UP the Chain

When you assign to a variable, Sard walks up the parent chain to find the **nearest** definition and updates it. If not found anywhere, it creates the variable in the **current** scope.

```sard
x = 1;          // Created in top-level scope

{
    x = 2;      // Updates the outer x (walks up and finds it)
    y = 3;      // Creates y in THIS scope only
}

print(x);       // 2 — was updated in nested block
// print(y);    // ERROR — y doesn't exist here
```

### Example 5: Callable Objects Have Parent Chain

```sard
counter : {
    // This object creates a scope
    value : integer = 0;
    
    inc : () {
        // This callable's parent is the "counter" object
        value = value + 1;    // Modifies the parent's "value"
        = value;
    };
    
    dec : () {
        value = value - 1;
        = value;
    };
}

// Create an instance
my_counter = ~counter;

print(my_counter.inc());   // 1
print(my_counter.inc());   // 2
print(my_counter.dec());   // 1
// print(value);           // ERROR — value is not in top-level scope
```

## Why "No Global Scope" Matters

1. **Isolation**: Different parts of your program can't accidentally interfere via global variables
2. **Closures**: Callables automatically capture their parent scope
3. **Predictability**: You always know where variables come from by looking at the parent chain

```sard
// In a language WITH global scope, this could modify a global "temp":
// temp = 999;  // Oops, polluted global namespace!

// In Sard, this is safe:
process_data : (data) {
    temp = data * 2;    // temp only exists in this callable's scope
    = temp;
}

temp = 10;          // This temp is in top-level scope
result = process_data(5);
print(temp);        // Still 10 — process_data didn't touch it!
```

## Comparison with Global Scope Languages

### JavaScript (has global scope)
```javascript
var x = 10;
function foo() {
    x = 20;  // Modifies global x — potentially dangerous!
}
```

### Sard (no global scope)
```sard
x = 10;     // Top-level scope, not global
foo : () {
    x = 20; // Modifies the nearest x in parent chain (top-level in this case)
}

// But inside objects:
counter : {
    x = 0;
    inc : () {
        x = x + 1;  // Modifies counter's x, NOT top-level!
    }
}
```

## Summary

- **No magical global namespace** — just nested scopes
- **Parent chain** — each scope knows its parent, variables are found by walking UP
- **Lexical** — the parent relationship is determined by where code is written (nested blocks), not runtime call stack
- **Assignment walks up** — finds the nearest definition to update, or creates locally if not found
