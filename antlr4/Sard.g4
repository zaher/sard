grammar Sard;

// ============================================================
// Parser Rules
// ============================================================

program
    : statement* EOF
    ;

statement
    : declaration SEMI?
    | assignment SEMI?
    | returnStatement SEMI?
    | expression SEMI?
    | block
    | SEMI
    ;

declaration
    : IDENTIFIER COLON type EQ expression                  #DeclTypedInit
    | IDENTIFIER COLON type parameterList? block?          #DeclTypedCallable
    | IDENTIFIER COLON parameterList block                 #DeclCallableParams
    | IDENTIFIER COLON block                               #DeclCallableNoParams
    | IDENTIFIER COLON parameterList SEMI?                 #DeclForwardParams
    | IDENTIFIER COLON type SEMI?                          #DeclTyped
    ;

type
    : IDENTIFIER (DOT IDENTIFIER)*
    ;

parameterList
    : LPAREN (IDENTIFIER (COMMA IDENTIFIER)*)? RPAREN
    ;

assignment
    : lvalue (EQ | PLUS_ASSIGN | MINUS_ASSIGN) expression
    ;

lvalue
    : IDENTIFIER lvalueSuffix*
    ;

lvalueSuffix
    : DOT IDENTIFIER
    | LBRACKET expression RBRACKET
    ;

returnStatement
    : EQ expression
    ;

block
    : LBRACE statement* RBRACE
    ;

// ============================================================
// Expressions (precedence climbing)
// ============================================================

expression
    : logicalOrExpr
    ;

logicalOrExpr
    : logicalAndExpr ((BAR | OR) logicalAndExpr)*
    ;

logicalAndExpr
    : comparisonExpr ((AMPERSAND | AND) comparisonExpr)*
    ;

comparisonExpr
    : typeCheckExpr comparisonChain?
    ;

comparisonChain
    : ((EQ | NEQ | NNEQ | LT | GT | LTE | GTE) typeCheckExpr)+
    ;

typeCheckExpr
    : additiveExpr (TYPEEQ additiveExpr)?
    ;

additiveExpr
    : multiplicativeExpr ((PLUS | MINUS) multiplicativeExpr)*
    ;

multiplicativeExpr
    : powerExpr ((STAR | SLASH | MOD) powerExpr)*
    ;

powerExpr
    : unaryExpr (CARET powerExpr)?
    ;

unaryExpr
    : MINUS unaryExpr
    | PLUS unaryExpr
    | BANG unaryExpr
    | NOT unaryExpr
    | INC lvalue
    | DEC lvalue
    | postfixExpr
    ;

postfixExpr
    : primaryExpr postfixLink*
    ;

postfixLink
    : DOT IDENTIFIER                           #PostfixMember
    | LBRACKET expression RBRACKET             #PostfixIndex
    | argumentList block?                      #PostfixCall
    | namedBlock                               #PostfixNamedBlock
    | block                                    #PostfixBlock
    | PERCENT                                  #PostfixPercent
    | INC                                      #PostfixInc
    | DEC                                      #PostfixDec
    ;

argumentList
    : LPAREN (expression (COMMA expression)*)? RPAREN
    ;

namedBlock
    : IDENTIFIER argumentList? block
    ;

primaryExpr
    : literal
    | TRUE
    | FALSE
    | IDENTIFIER (DOT IDENTIFIER)*            #QualifiedOrSimpleId
    | LPAREN expression RPAREN
    | block
    | TILDE IDENTIFIER
    | TILDETILDE IDENTIFIER
    | AT expression
    | arrayLiteral
    ;

literal
    : INTEGER_LITERAL
    | NUMBER_LITERAL
    | HEX_LITERAL
    | STRING_LITERAL
    | COLOR_LITERAL
    | CURRENCY_LITERAL
    | ESCAPE_SEQ
    ;

arrayLiteral
    : LBRACKET (expression (COMMA expression)*)? RBRACKET
    ;

// ============================================================
// Lexer Rules
// ============================================================

// Named operators & keywords (case-insensitive)
AND          : [aA][nN][dD] ;
OR           : [oO][rR] ;
NOT          : [nN][oO][tT] ;
MOD          : [mM][oO][dD] ;
TRUE         : [tT][rR][uU][eE] ;
FALSE        : [fF][aA][lL][sS][eE] ;

// Preprocessor (must come before LBRACE)
PREPROCESSOR : '{?' .*? '?}' ;

// Multi-char operators (longest match first)
TILDETILDE   : '~~' ;
TYPEEQ       : '==' ;
NEQ          : '<>' ;
NNEQ         : '!=' ;
LTE          : '<=' ;
GTE          : '>=' ;
INC          : '++' ;
DEC          : '--' ;
PLUS_ASSIGN  : '+=' ;
MINUS_ASSIGN : '-=' ;

// Single-char operators and delimiters
PLUS         : '+' ;
MINUS        : '-' ;
STAR         : '*' ;
SLASH        : '/' ;
CARET        : '^' ;
PERCENT      : '%' ;
AMPERSAND    : '&' ;
BAR          : '|' ;
BANG         : '!' ;
TILDE        : '~' ;
AT           : '@' ;
EQ           : '=' ;
LT           : '<' ;
GT           : '>' ;
LPAREN       : '(' ;
RPAREN       : ')' ;
LBRACE       : '{' ;
RBRACE       : '}' ;
LBRACKET     : '[' ;
RBRACKET     : ']' ;
COLON        : ':' ;
SEMI         : ';' ;
COMMA        : ',' ;
DOT          : '.' ;

// Literals (order matters - more specific patterns first)
CURRENCY_LITERAL
    : '$' [0-9]+ ('.' [0-9] [0-9]? [0-9]? [0-9]? [0-9]? [0-9]?)?
    ;

COLOR_LITERAL
    : '#' [0-9a-fA-F] [0-9a-fA-F] [0-9a-fA-F] [0-9a-fA-F]? [0-9a-fA-F]? [0-9a-fA-F]?
    ;

HEX_LITERAL
    : '0' [xX] [0-9a-fA-F]+
    ;

NUMBER_LITERAL
    : [0-9]+ '.' [0-9]+
    ;

INTEGER_LITERAL
    : [0-9]+
    ;

ESCAPE_SEQ
    : '\\' [nrt\\0]
    ;

STRING_LITERAL
    : '"' (~["\r\n] | '\r'? '\n')* '"'
    | '\'' (~['\r\n] | '\r'? '\n')* '\''
    ;

// Identifiers (after keywords to allow keyword-matching priority)
IDENTIFIER
    : [a-zA-Z_] [a-zA-Z0-9_]*
    ;

// Comments
LINE_COMMENT
    : '//' ~[\r\n]* -> skip
    ;

BLOCK_COMMENT
    : '/*' .*? '*/' -> skip
    ;

CURLY_BLOCK_COMMENT
    : '{*' .*? '*}' -> skip
    ;

// Whitespace
WS
    : [ \t\r\n]+ -> skip
    ;