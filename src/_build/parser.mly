%{
open Error
%}

%token <int> INTLITERAL
%token <float> FLOATLITERAL
%token <string> STRINGVAR
%token <string> STRINGLITERAL
%token <string> IDENTIFIER
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
%token BREAK 
%token DEFAULT 
%token FUNC 
%token INTERFACE
%token SELECT
%token CASE
%token DEFER
%token GO
%token MAP
%token STRUCT
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
%token INT
%token FLOAT64 
%token BOOL 
%token RUNE 
%token STRING 
%token PRINT 
%token PRINTLN 
%token APPEND
%token EOL
%token EOF
%start sourcefile
%type <unit> sourcefile
%%

sourcefile:
    |	packageclause SEMICOLON topleveldeclaration_list EOF {()}
	| 	error { raise (GoliteError (Printf.sprintf "Syntax Error at (%d)" ((!line_num)) )) }
    ;
topleveldeclaration_list:
	| {()}
	| topleveldeclaration SEMICOLON topleveldeclaration_list {()}
	;
packageclause:
	|	package_name IDENTIFIER {()}
	;
topleveldeclaration:
	| variable_declaration {()}
	| type_declaration {()}
	| function_declaration {()}
	;


variable_declaration:
	| VAR varspec {()}
	| VAR OPEN_PAREN varspec* CLOSE_PAREN {()}
	;
varspec:
	| identifier_list type_i EQ expression_list {()}
	| identifier_list EQ expression_list {()}
	;
expression_list:
	| {()}
	;
type_declaration:
	| TYPE type_spec {()}
	| TYPE OPEN_PAREN type_spec_list CLOSE_PAREN {()}
	;
type_spec_list:
	| {()}
	| type_spec SEMICOLON type_spec_list {()}
	;
type_spec:
	| IDENTIFIER type_i {()}
	;
element_type:
	| type_i {()}
	;
type_i:
	| type_name {()}
	| type_lit {()}
	| OPEN_PAREN type_i CLOSE_PAREN {()}
	;
type_name:
	| IDENTIFIER {()}
	| qualified_ident {()}
	;
qualified_ident:
	| package_name DOT IDENTIFIER {()}
	;
type_lit:
	| array_type {()}
	| struct_type {()}
	| slice_type {()}
	;
array_type:
	| OPEN_SQR_BRACKET array_length CLOSE_SQR_BRACKET element_type {()}
	;
array_length:
	| expression {()}
	;
struct_type:
	| STRUCT  OPEN_CUR_BRACKET field_dcl_list CLOSE_CUR_BRACKET {()}
	;
field_dcl_list:
	| {()}
	| field_dcl SEMICOLON field_dcl_list {()}
	;
field_dcl:
	| identifier_list type_i optional_tag {()}
	| annonymous_field optional_tag {()}
optional_tag:
	| {()}
	| tag {()}
	;
tag:
	| STRINGLITERAL {()}
	;
annonymous_field:
	| type_name {()}
	| STAR type_name {()}
	;

slice_type:
	| OPEN_SQR_BRACKET CLOSE_SQR_BRACKET element_type {()}
	;

function_declaration:
	| {()}
	;
package_name:
	| IDENTIFIER {()}
	;
expression: 
	| {()}
	;
identifier_list:
	| IDENTIFIER {()}
	| IDENTIFIER COMMA identifier_list {()}
	;

%%
