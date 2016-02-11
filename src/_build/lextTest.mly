%{
open Error
%}

%token <int> INTLITERAL
%token <float> FLOATLITERAL
%token <string> STRINGVAR
%token EOL

%start main
%type <unit> main
%%

main:
    expr EOL {()}

expr:
    INTLITERAL {()}
    | FLOATLITERAL {()}
    | STRINGVAR {()}
    ;
