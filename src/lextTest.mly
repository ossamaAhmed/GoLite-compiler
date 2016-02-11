open Lexer
open Parser
open Lexing
open Error

%token <int> INTLITERAL
%token <float> FLOATLITERAL
%token <string> STRINGVAR
%token EOL

%start main
%type <int> main
%%

main:
    expr E0L {$1}

expr:
    INTLITERAL {$1}
    | FLOATLITERAL {$1}
    | STRINGVAR {$1}
    ;
