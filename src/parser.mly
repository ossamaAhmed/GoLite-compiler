%{
open Error
%}

(* Tokens *)

%token <int> INTLITERAL
%token <float> FLOATLITERAL
%token <string> STRINGVAR
%token <string> STRINGLITERAL
%token <string> IDENTIFIER
%token <char> RUNELITERAL
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

(* Associativity and precedence *)

%left SLASH
%left STAR
%left MINUS
%left PLUS

(* Start of parser *)

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
	|	PACKAGE package_name {()}
	;
topleveldeclaration:
    | declaration {()}
	| function_declaration {()}
	;
declaration:
    | variable_declaration {()}
	| type_declaration {()}

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
	| expression {()}
    | expression COMMA expression_list {()}
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
	| FUNC IDENTIFIER functiondef {()}
    | FUNC IDENTIFIER signature {()}
	;
functiondef: signature functionbody {()};

functionbody: block {()}

(*TODO: IMPLEMENT SIGNATURES *)
signature: {()};

package_name:
	| IDENTIFIER {()}
	;

identifier_list:
	| IDENTIFIER {()}
	| IDENTIFIER COMMA identifier_list {()}
	;

(*TODO: CHECK THAT LHS IS AN LVALUE *)
assignment:
    | expression_list EQ expression_list {()}
    | expression assign_op expression {()}
    ;

assign_op:
    | PLUS_EQ {()}
    | STAR_EQ {()}
    ;

block:
    | OPEN_CUR_BRACKET stmt_list CLOSE_CUR_BRACKET {()};

stmt: 
    | declaration {()}
    | return_stmt {()}
    | break_stmt {()}
    | continue_stmt {()}
    | block {()}
    | conditional_stmt {()}
    | switch_stmt {()}
    | for_stmt {()}
    | simple_stmt {()}
    | print_stmt {()}
    | println_stmt {()}
    ;

simple_stmt:
    | expression_stmt {()}
    | increment_stmt {()}
    | assignment {()}
    | short_var_decl {()}
    ;

stmt_list: 
    |  {()}
    | stmt SEMICOLON stmt_list {()}
    ;

short_var_decl: 
    | identifier_list COLON_EQ expression_list {()}
    ;

increment_stmt:
    | expression DOUBLE_PLUS {()}
    | expression DOUBLE_MINUS {()}
    ;

expression_stmt:
    | expression {()}
    ;

print_stmt:
    | PRINT OPEN_PAREN expression_list CLOSE_PAREN {()}
    ;

println_stmt:
    | PRINTLN OPEN_PAREN expression_list CLOSE_PAREN {()}
    ;

condition: expression {()};

return_stmt:
    | RETURN expression_list {()}
    ;

if_init:
    | simple_stmt {()}
    ;

if_stmt:
    | IF if_init condition block {()}
    | IF condition block {()}
    ;

else_stmt: 
    | if_stmt ELSE block {()}
    | if_stmt ELSE else_stmt {()}
    | if_stmt ELSE if_stmt {()}
    ;

conditional_stmt: 
    | if_stmt {()}
    | else_stmt {()}
    ;

for_stmt:
    | FOR block {()}
    | FOR  condition block {()}
    | FOR  for_clause block {()}
    ;
for_clause: 
    | init_stmt SEMICOLON  condition SEMICOLON post_stmt {()}
    | init_stmt SEMICOLON  condition SEMICOLON {()}
    | init_stmt SEMICOLON  SEMICOLON post_stmt {()}
    | init_stmt SEMICOLON  SEMICOLON {()}
    | SEMICOLON  condition SEMICOLON post_stmt {()}
    | SEMICOLON  condition SEMICOLON {()}
    | SEMICOLON  SEMICOLON post_stmt {()}
    | SEMICOLON  SEMICOLON {()}
    ;

init_stmt: 
    | simple_stmt {()};
post_stmt: 
    | simple_stmt {()};

switch_stmt:
    | SWITCH switch_clause OPEN_CUR_BRACKET expr_case_clause CLOSE_CUR_BRACKET {()}
    | SWITCH OPEN_CUR_BRACKET expr_case_clause CLOSE_CUR_BRACKET {()}
    ;

switch_clause:
    | SEMICOLON {()}
    | simple_stmt SEMICOLON {()}
    | expression {()}
    | simple_stmt SEMICOLON expression {()}
    ;

expr_case_clause: 
    | expr_switch_case COLON stmt_list {()}
    ;

expr_switch_case: 
    | CASE expression_list {()}
    | DEFAULT {()}
    ;

break_stmt: 
    | BREAK {()}
    ;

continue_stmt:
    | CONTINUE {()}
    ;

(*TODO: EXPRESSIONS*)
operand:
    | literal {()}
    | operand_name {()}
    | OPEN_PAREN expression CLOSE_PAREN {()}
    ;
literal:
    | basic_lit {()}
    | composite_lit {()}
    | function_lit {()}
    ;
basic_lit:
    | INTLITERAL {()}
    | FLOATLITERAL {()}
    | RUNELITERAL {()}
    | STRINGLITERAL {()}
    ;
operand_name:
    | IDENTIFIER {()}
    | qualified_ident {()}
    ;
(*TODO: COMPOSITELIT*)
composite_lit: 
    | literal_type {()}
    | literal_value {()}
    ;
literal_type:
    | struct_type {()}
    | array_type {()}
    | OPEN_SQR_BRACKET TRIPLE_DOT CLOSE_SQR_BRACKET element_type {()}
    | slice_type {()}
    | type_name {()}
literal_value:
    | OPEN_CUR_BRACKET element_list CLOSE_CUR_BRACKET {()}
    ;
element_list:
    | keyed_element {()}
    | keyed_element COMMA element_list {()}
    ;
keyed_element: 
    | element {()}
    | key COLON element {()}
    ;
key:
    | IDENTIFIER {()}
    | expression {()}
    | literal_value {()}
    ;
element:
    | expression {()}
    | literal_value {()}
    ;
function_lit:
    | FUNC function_i {()}
    ;
function_i: 
    | {()}
    ;
(*EXPRESSIONS PART*)
expression: 
    | unary_expr {()}
    | expression binary_op expression {()}
    ;
unary_expr:
    | primary_expr {()} 
    | unary_op unary_expr {()}
    ;
(*NOT SURE ABOUT PRIMARY EXPRESSION*)
primary_expr:
    | operand {()}
    (*| conversion {()}
    | primary_expr index {()}
    | primary_expr selector {()}
    | primary_expr slice {()}
    | primary_expr type_assertion {()}
    | primary_expr arguments {()}*)
    ;
selector:
    | DOT IDENTIFIER {()}
    ;
index: 
    | OPEN_SQR_BRACKET expression CLOSE_SQR_BRACKET {()}
    ;
slice:
    | OPEN_SQR_BRACKET option(expression) COLON option(expression) CLOSE_SQR_BRACKET {()}
    | OPEN_SQR_BRACKET option(expression) COLON expression COLON expression CLOSE_SQR_BRACKET {()}
    ;
type_assertion:
    | {()}
    ;
arguments:
    | {()}
    ;
conversion: 
    | {()}
    ;

binary_op:
    | DOUBLE_BAR {()}
    | DOUBLE_AND {()}
    | rel_op {()}
    | add_op {()}
    | mul_op {()}
    ;
rel_op: 
    | DOUBLE_EQ {()}
    | NOT_EQ {()}
    | LT {()}
    | GT {()}
    | LT_EQ {()}
    | GT_EQ {()}
    ;
add_op: 
    | PLUS {()}
    | MINUS {()}
    | BAR {()}
    | CARET {()}
    ;
mul_op:
    | STAR {()}
    | SLASH {()}
    | PERCENT {()}
    | SHIFT_RIGHT {()}
    | SHIFT_LEFT {()}
    | AND {()}
    | AND_CARET {()}
    ;
unary_op:
    | PLUS {()}
    | MINUS {()}
    | NOT {()}
    | CARET {()}
    | STAR {()}
    | AND {()}
    | LT_MINUS {()}
    ;
%%
