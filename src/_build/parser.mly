%{
open Error
%}

%token <int> INTLITERAL
%token <float> FLOATLITERAL
%token <string> STRINGVAR
%token PLUS 
%token AND 
%token PLUS_EQ 
%token AND_EQ 
%token DOUBLE_AND 
%token DOUBLE_EQ 
%token NOT_EQ 
%token OPEN_PAREN 
%token CLOSE_PAREN 
%token MINUS 
%token BAR 
%token MINUS_EQ 
%token BAR_EQ 
%token DOUBLE_BAR 
%token LT 
%token LT_EQ 
%token OPEN_SQR_BRACKET 
%token CLOSE_SQR_BRACKET 
%token STAR 
%token CARET 
%token STAR_EQ 
%token CARET_EQ 
%token LT_MINUS 
%token GT 
%token GT_EQ 
%token OPEN_CUR_BRACKET 
%token CLOSE_CUR_BRACKET 
%token SLASH 
%token SHIFT_LEFT 
%token SLASH_EQ 
%token SHIFT_LEFT_EQ 
%token DOUBLE_PLUS 
%token EQ 
%token COLON_EQ 
%token COMMA 
%token SEMICOLON 
%token PERCENT 
%token SHIFT_RIGHT 
%token PERCENT_EQ 
%token SHIFT_RIGHT_EQ 
%token DOUBLE_MINUS 
%token NOT 
%token TRIPLE_DOT 
%token DOT 
%token COLON 
%token AND_CARET 
%token AND_CARET_EQ 

%token IDENTIFIER
%token BREAK 
%token DEFAULT 
%token FUNC 
%token INTERFACE
%token SELECT
%token CASE
%token DEFER
%token GO
%token MAP
%token CHAN 
%token ELSE
%token GOTO
%token PACKAGE
%token SWITCH
%token CONST
%token FALLTHROUGH
%token IF
%token RANGE
%token TYPE 
%token CONTINUE 
%token FOR 
%token IMPORT 
%token RETURN 
%token VAR 
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
