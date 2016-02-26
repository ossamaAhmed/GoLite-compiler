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
%token UMINUS
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

%left PLUS MINUS
%left STAR SLASH
%nonassoc UMINUS

(* Start of parser *)
%start parse
%type <unit> parse

%%

parse:
    | PACKAGE IDENTIFIER SEMICOLON toplevel_declaration_list EOF {()}
	| error { raise (GoliteError (Printf.sprintf "Syntax Error at (%d)" ((!line_number)) )) }
    ;
toplevel_declaration_list:
	| {()}
	| toplevel_declaration SEMICOLON toplevel_declaration_list {()}
	;

toplevel_declaration:
    | declaration {()}
	| func_declaration {()}
	;
declaration:
    | variable_declaration {()}
	| type_declaration {()}
    ;
variable_declaration:
	| VAR varspec {()}
	| VAR OPEN_PAREN varspec_list CLOSE_PAREN {()}
	;
varspec_list:
    | {()}
    | varspec SEMICOLON varspec_list {()}
    ;
varspec:
	| identifier_list type_i  varspec_optional_expression_list {()}
	| identifier_list EQ expression_list {()}
	;
varspec_optional_expression_list:
    | {()}
    | EQ expression_list {()}
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
	| IDENTIFIER {()}
    | IDENTIFIER selector {()}
	| type_lit {()}
	| OPEN_PAREN type_i CLOSE_PAREN {()}
	;
type_lit:
    | INT {()}
    | RUNE {()}
    | STRING {()}
    | FLOAT64 {()}
    | BOOL {()}
	| array_type {()}
	| struct_type {()}
	| slice_type {()}
	;
array_type:
	| OPEN_SQR_BRACKET array_length CLOSE_SQR_BRACKET element_type {()}
	;
array_length:
	| INTLITERAL {()}
	;
struct_type:
	| STRUCT  OPEN_CUR_BRACKET field_dcl_list CLOSE_CUR_BRACKET {()}
	;
field_dcl_list:
	| {()}
	| field_dcl SEMICOLON field_dcl_list {()}
	;
field_dcl:
	| identifier_list type_i  {()}
    ;
slice_type:
	| OPEN_SQR_BRACKET CLOSE_SQR_BRACKET element_type {()}
	;

(* FUNCTION *)

func_declaration:
	| FUNC IDENTIFIER func_def {()}
    | FUNC IDENTIFIER func_signature {()}
	;

func_def: func_signature func_body {()};

func_body: block {()}

func_type: 
    | FUNC func_signature {()}
    ;
func_signature:
    | func_params result {()}
    ;
result: 
    | {()}
    | type_i {()}
    ;
func_params:
    | OPEN_PAREN func_params_list CLOSE_PAREN {()}
    | OPEN_PAREN  CLOSE_PAREN {()}
    ;
func_params_list:
    | func_param_declaration {()}
    | func_param_declaration COMMA func_params_list {()}
    ;
func_param_declaration:
    | identifier_list  type_i {()}
    ;

func_call_expr:
    | IDENTIFIER func_args {()}
    ;

func_args:
    | OPEN_PAREN CLOSE_PAREN {()}
    | OPEN_PAREN expression_list CLOSE_PAREN {()}
   (* | OPEN_PAREN type_i COMMA expression_list  CLOSE_PAREN  {()}
    | OPEN_PAREN type_i   CLOSE_PAREN  {()} *)
    ;

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
    | func_call_expr {()}
    ;

simple_stmt:
    | {()}
    | expression_stmt {()}
    | incdec_stmt {()}
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

incdec_stmt:
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
    | simple_stmt SEMICOLON {()} (*I ADDED HERE A SEMICOLON*)
    ;

if_stmt:
    | IF condition block {()}
    | IF if_init condition block {()}
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
for_clause: (*GOLITE DOESNT SUPPORT INITSTMT FOR FORLOOP*)
    | init_stmt SEMICOLON  condition SEMICOLON post_stmt {()}
    | init_stmt SEMICOLON  SEMICOLON post_stmt {()}
    ;

init_stmt: 
    | simple_stmt {()};
post_stmt: 
    | simple_stmt {()};

switch_stmt:
    | SWITCH switch_clause switch_expr_clause OPEN_CUR_BRACKET expr_case_clause_list CLOSE_CUR_BRACKET {()}
    | SWITCH switch_expr_clause OPEN_CUR_BRACKET expr_case_clause_list CLOSE_CUR_BRACKET {()}
    | SWITCH switch_clause  OPEN_CUR_BRACKET expr_case_clause_list CLOSE_CUR_BRACKET {()}
    | SWITCH OPEN_CUR_BRACKET expr_case_clause_list CLOSE_CUR_BRACKET {()}
    ;

switch_clause:
    | simple_stmt SEMICOLON  {()}
    ;

switch_expr_clause:
    | expression {()}
    ;
expr_case_clause_list:
    | {()}
    | expr_case_clause expr_case_clause_list {()}
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
    | OPEN_PAREN expression CLOSE_PAREN {()}
    ;
literal:
    | basic_lit {()}
    | composite_lit {()}  (*CAUSING CONFLICT*)
    ;
basic_lit:
    | INTLITERAL {()}
    | FLOATLITERAL {()}
    | RUNELITERAL {()}
    | STRINGLITERAL {()}
    ;
(*TODO: COMPOSITELIT*)
composite_lit: 
    | literal_type {()}
  (*  | literal_value {()} *)
    ; 
literal_type:
    | struct_type {()}
    | array_type {()}
    | OPEN_SQR_BRACKET TRIPLE_DOT CLOSE_SQR_BRACKET element_type {()}
    | slice_type {()}
    | IDENTIFIER {()}
literal_value: (*NOT SURE IF WE SHOULD INCLUDE THIS IN GOLITE*)
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
    | expression binary_op expression {()}  (*CAUSING SHIFT REDUCE CONFLICTS*)
    ;
unary_expr:
    | primary_expr {()} 
    | unary_op unary_expr {()}
    ;
(*NOT SURE ABOUT PRIMARY EXPRESSION*)
primary_expr:
    | operand {()}
    | func_call_expr {()}
    | append_expr {()}
    | primary_expr index {()}
    | primary_expr selector {()}
    | primary_expr slice {()}
    | type_cast OPEN_PAREN primary_expr CLOSE_PAREN {()}
    ;
append_expr:
    | APPEND OPEN_PAREN IDENTIFIER COMMA expression CLOSE_PAREN {()}
selector:
    | DOT IDENTIFIER {()}
    ;
index: 
    | OPEN_SQR_BRACKET expression CLOSE_SQR_BRACKET {()}
    ;
slice:
    | OPEN_SQR_BRACKET  COLON  CLOSE_SQR_BRACKET {()}
    | OPEN_SQR_BRACKET expression COLON expression CLOSE_SQR_BRACKET
    | OPEN_SQR_BRACKET COLON expression CLOSE_SQR_BRACKET
    | OPEN_SQR_BRACKET expression COLON  CLOSE_SQR_BRACKET
    | OPEN_SQR_BRACKET  COLON expression COLON expression CLOSE_SQR_BRACKET {()}
    | OPEN_SQR_BRACKET expression COLON expression COLON expression CLOSE_SQR_BRACKET {()}
    ;
type_cast: (* TYPE CASTING ONLY WORKS WITH PRIMITIVES EXCEPT STRING *)
    | IDENTIFIER {()}
    | INT {()}
    | RUNE {()}
    | FLOAT64 {()}
    | BOOL {()}
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
    ;
%%
