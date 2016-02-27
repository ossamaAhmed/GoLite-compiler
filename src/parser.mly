%{
open Error
open GenerateAst
open Ast
%}

(* Tokens *)

%token <int> INTLITERAL
%token <float> FLOATLITERAL
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

%left PLUS MINUS
%left STAR SLASH

(* Start of parser *)
%start parse
%type <Ast.prog> parse

%%

parse:
    | PACKAGE IDENTIFIER SEMICOLON toplevel_declaration_list EOF { generate_program $2 $4  }
	| error { raise (GoliteError (Printf.sprintf "Syntax Error at %d" ((!line_number)) )) }
    ;
toplevel_declaration_list:
	| {[]}
	| toplevel_declaration SEMICOLON toplevel_declaration_list { $1::$3 }
	;

toplevel_declaration:
    | declaration { $1 }
	;
declaration:
    | variable_declaration { $1 }
	| type_declaration { $1 }
    | func_declaration { $1 } 
    ;
variable_declaration:
	| VAR varspec {generate_variable_decl [$2]}
	| VAR OPEN_PAREN varspec_list CLOSE_PAREN {generate_variable_decl $3}
	;
varspec_list:
    | {[]}
    | varspec SEMICOLON varspec_list { $1::$3 }
    ;
varspec:
	| identifier_list type_i EQ expression_list {
        if List.length $1 = List.length $4 then
            generate_variable_with_type_spec $1 $2 $4
        else
            raise (GoliteError (Printf.sprintf "Parser Error at %d: Number of variables must match number of expressions in assignment" ((!line_number)) ))
    }
    | identifier_list type_i { generate_variable_with_type_spec $1 $2 [] }
	| identifier_list EQ expression_list { 
        if List.length $1 = List.length $3 then
            generate_variable_without_type_spec $1 $3
        else
            raise (GoliteError (Printf.sprintf "Parser Error at %d: Number of variables must match number of expressions in assignment" ((!line_number)) ))
    }
	;
type_declaration:
	| TYPE type_spec { generate_type_decl [$2] }
	| TYPE OPEN_PAREN type_spec_list CLOSE_PAREN { generate_type_decl $3 }
	;
type_spec_list:
	| {[]}
	| type_spec SEMICOLON type_spec_list {$1::$3}
	;
type_spec:
	| IDENTIFIER type_i { generate_type_spec (generate_symbol $1) $2}
	;
type_i:
	| IDENTIFIER { generate_defined_type $1 } (*NOT SURE IF WE CAN DEFINE OUR OWN TYPES*)
	| type_lit { $1 }
	| OPEN_PAREN type_i CLOSE_PAREN { $2 }
	;
type_lit:
    | INT { generate_primitive_type "int" }
    | RUNE { generate_primitive_type "rune" }
    | STRING {generate_primitive_type "string"}
    | FLOAT64 {generate_primitive_type "float64"}
    | BOOL { generate_primitive_type "bool"}
	| array_type { $1 }
	| struct_type {$1}
	| slice_type { $1 }
	;
array_type:
	| OPEN_SQR_BRACKET INTLITERAL CLOSE_SQR_BRACKET type_i { generate_array_type $2 $4}
	;
struct_type:
	| STRUCT  OPEN_CUR_BRACKET field_dcl_list CLOSE_CUR_BRACKET { generate_struct_type $3 }
	;
field_dcl_list:
	| { [] }
	| field_dcl SEMICOLON field_dcl_list { $1::$3 }
	;
field_dcl:
	| identifier_list type_i  { ($1,$2) }
    ;
slice_type:
	| OPEN_SQR_BRACKET CLOSE_SQR_BRACKET type_i { generate_slice_type $3 }
	;

(* FUNCTION *)

func_declaration:
	| FUNC IDENTIFIER func_signature block { Function($2,$3,$4) }
    ;
func_signature:
    | func_params func_return { (FuncSig($1,$2)) }
    ;
func_return: 
    | { Empty }
    | type_i { FuncReturnType($1) }
    ;
func_params:
    | OPEN_PAREN func_params_list CLOSE_PAREN { FuncParams($2) }
    | OPEN_PAREN  CLOSE_PAREN { FuncParams([]) }
    ;
func_params_list:
    | identifier_list type_i COMMA func_params_list { (generate_type_spec_list $1 $2) @ $4 }
    | identifier_list type_i { generate_type_spec_list $1 $2 }
    ;

func_call_expr:
    | IDENTIFIER func_args { generate_func_expr (generate_symbol $1) $2}
    ;
func_args:
    | OPEN_PAREN CLOSE_PAREN {[]}
    | OPEN_PAREN expression_list CLOSE_PAREN {$2}
    ;
identifier_list:
	| IDENTIFIER { [generate_symbol $1] }
	| IDENTIFIER COMMA identifier_list { [generate_symbol $1]@$3 }
	;

(*TODO: CHECK THAT LHS IS AN LVALUE *)
assignment:
    | expression_list EQ expression_list {generate_assign_bare $1 $3 }
    | expression assign_op expression {generate_assign_op $1 $2 $3 }
    ;

assign_op:
    | add_op_eq {$1}
    | mul_op_eq {$1}
    ;
add_op_eq: 
    | PLUS_EQ {"+="}
    | MINUS_EQ {"-="}
    | BAR_EQ {"|="}
    | CARET_EQ {"^="}
    ;
mul_op_eq:
    | STAR_EQ {"*="}
    | SLASH_EQ {"/="}
    | PERCENT_EQ {"%="}
    | SHIFT_RIGHT_EQ {">>="}
    | SHIFT_LEFT_EQ {"<<="}
    | AND_EQ { "&="}
    | AND_CARET_EQ { "&^=" }
    ;

block:
    | OPEN_CUR_BRACKET stmt_list CLOSE_CUR_BRACKET {$2};

stmt: 
    | declaration {Declaration($1)}
    | return_stmt {  Return($1) }
    | break_stmt { $1 }
    | continue_stmt { $1 }
    | block {generate_block_stmt($1)}
    | conditional_stmt {generate_conditional_stmt($1)}
    | switch_stmt {$1}
    | for_stmt {generate_for_stmt($1)}
    | simple_stmt {generate_simple_stmt($1)}
    | print_stmt {(generate_print($1))}
    | println_stmt {generate_println($1)}
    ;

simple_stmt:
    | {Empty}  (*WHY WOULD A SIMPLE STMT BE EMPTY*)
    | expression_stmt {generate_simple_exp $1 }
    | incdec_stmt {generate_simple_incdec $1 }
    | assignment {generate_simple_assignment $1 }
    | short_var_decl {generate_simple_shortvardecl $1 }
    ;

stmt_list: 
    | {[]}
    | stmt SEMICOLON stmt_list {$1::$3}
    ;

short_var_decl: 
    | identifier_list COLON_EQ expression_list {ShortVarDecl($1,$3) }
    ;

incdec_stmt:
    | expression DOUBLE_PLUS {generate_inc $1 }
    | expression DOUBLE_MINUS {generate_dec $1 }
    ;

expression_stmt:
    | expression {$1}
    ;

print_stmt:
    | PRINT OPEN_PAREN expression_list CLOSE_PAREN { $3 }
    ;

println_stmt:
    | PRINTLN OPEN_PAREN expression_list CLOSE_PAREN { $3 }
    ;

condition: expression {generate_condition $1 };

(* golite does not support arbitrary number of return values *)
return_stmt:
    | RETURN expression {generate_return $2 }
    | RETURN { Empty }
    ;

if_init:
    | simple_stmt SEMICOLON { generate_if_init $1} (*I ADDED HERE A SEMICOLON*)
    ;

if_stmt:
    | IF condition block {generate_if_stmt Empty $2 $3 }
    | IF if_init condition block {generate_if_stmt $2 $3 $4 }
    ;

else_stmt: 
    | if_stmt ELSE block {generate_else_single $1 $3 }
    | if_stmt ELSE else_stmt {generate_else_multiple $1 $3 }
    | if_stmt ELSE if_stmt {generate_else_if $1 $3 }
    ;

conditional_stmt: 
    | if_stmt {(generate_conditional_if $1)}
    | else_stmt {generate_conditional_else $1 }
    ;

for_stmt:
    | FOR block {generate_for_block $2 }
    | FOR  condition block {generate_for_cond_block $2 $3 }
    | FOR  for_clause block {generate_for_clause_block $2 $3 } 
    ;
for_clause: (*GOLITE DOESNT SUPPORT INITSTMT FOR FORLOOP*)
    | init_stmt SEMICOLON  condition SEMICOLON post_stmt {generate_for_clause $1 $3 $5 }
    | init_stmt SEMICOLON  SEMICOLON post_stmt {generate_for_clause $1 Empty $4 }
    ;

init_stmt: 
    | simple_stmt {$1};
post_stmt: 
    | simple_stmt {$1};

switch_stmt:
    | SWITCH switch_clause switch_expr_clause OPEN_CUR_BRACKET expr_case_clause_list CLOSE_CUR_BRACKET {generate_switch $2 $3 (generate_switch_case_block($5))}
    | SWITCH switch_expr_clause OPEN_CUR_BRACKET expr_case_clause_list CLOSE_CUR_BRACKET {generate_switch Empty $2 (generate_switch_case_block($4)) }
    | SWITCH switch_clause  OPEN_CUR_BRACKET expr_case_clause_list CLOSE_CUR_BRACKET {generate_switch $2 Empty (generate_switch_case_block($4)) }
    | SWITCH OPEN_CUR_BRACKET expr_case_clause_list CLOSE_CUR_BRACKET {generate_switch Empty Empty (generate_switch_case_block($3)) }
    ;

switch_clause:
    | simple_stmt SEMICOLON  {generate_switch_clause $1 }
    ;

switch_expr_clause:
    | expression {generate_switch_expr $1 }
    ;
expr_case_clause_list:
    | { [] }
    | expr_case_clause expr_case_clause_list { $1::$2 }
    ;
expr_case_clause: 
    | expr_switch_case COLON stmt_list {generate_switch_case_clause $1 $3 }
    ;

expr_switch_case: 
    | CASE expression_list { $2 }
    | DEFAULT {[]}
    ;

break_stmt: 
    | BREAK { Break }
    ;

continue_stmt:
    | CONTINUE { Continue }
    ;

(*EXPRESSIONS PART*)
expression_list:
    | expression {[$1]}
    | expression COMMA expression_list {$1::$3}
    ;
expression: 
    | unary_expr { $1 }
    | expression binary_op expression {  generate_bin_expression $2 $1 $3  }  (*CAUSING SHIFT REDUCE CONFLICTS*)
    ;
unary_expr:
    | primary_expr {$1} 
    | unary_op unary_expr { generate_unary_expression $1 $2 }
    ;
primary_expr:
    | operand { $1 }
    | func_call_expr { $1}
    | append_expr { $1 }
    | primary_expr index { generate_index_expr $1 $2}
    | primary_expr selector { generate_selector_expr $1 $2 }
    | type_cast OPEN_PAREN primary_expr CLOSE_PAREN { generate_type_casting_expr $1 $3 }
   (* | primary_expr slice {()} *)   (*I SKIPPED GENERATING THIS FOR NOW*)
    ;
operand:
    | literal { $1 }
    | IDENTIFIER { generate_operator $1 }  (*REPITITION WITH TYPE_NAME*)
    | OPEN_PAREN expression CLOSE_PAREN { $2 }
    ;
literal:
      | basic_lit {$1}
(*   | composite_lit {()} *) (*CAUSING CONFLICT AND NOT SURE IF WE SHOULD SUPPORT THIS*)
(*    | function_lit {()} *)
    ;
basic_lit:
    | INTLITERAL { generate_integer $1 }
    | FLOATLITERAL { generate_float $1 }
    | RUNELITERAL { generate_rune $1 }
    | STRINGLITERAL { generate_string $1 }
    ;
index: 
    | OPEN_SQR_BRACKET expression CLOSE_SQR_BRACKET { $2 }
    ;
selector:
    | DOT IDENTIFIER { generate_symbol $2 }
    ;
slice: (*NOT SURE IF THIS SUPPORTED IN GOLITE*)
    | OPEN_SQR_BRACKET  COLON  CLOSE_SQR_BRACKET {()}
    | OPEN_SQR_BRACKET expression COLON expression CLOSE_SQR_BRACKET {()}
    | OPEN_SQR_BRACKET COLON expression CLOSE_SQR_BRACKET {()}
    | OPEN_SQR_BRACKET expression COLON  CLOSE_SQR_BRACKET {()}
    | OPEN_SQR_BRACKET  COLON expression COLON expression CLOSE_SQR_BRACKET {()}
    | OPEN_SQR_BRACKET expression COLON expression COLON expression CLOSE_SQR_BRACKET {()}
    ;
append_expr:
    | APPEND OPEN_PAREN IDENTIFIER COMMA expression CLOSE_PAREN { generate_append_expression (generate_symbol $3) $5}
    ;
type_cast: (* TYPE CASTING ONLY WORKS WITH PRIMITIVES EXCEPT STRING *)
 (*   | IDENTIFIER { generate_defined_type $1 }  *) (*SEE THE NOTE AT THE END OF TYPE CASTING, IT CREATES CONFLICTS*)
    | INT { generate_primitive_type "int" }
    | RUNE {generate_primitive_type "rune"}
    | FLOAT64 { generate_primitive_type "float64"}
    | BOOL {generate_primitive_type "bool"}
    ;
binary_op:
    | DOUBLE_BAR {"||"}
    | DOUBLE_AND {"&&"}
    | rel_op {$1}
    | add_op {$1}
    | mul_op {$1}
    ;
rel_op: 
    | DOUBLE_EQ {"=="}
    | NOT_EQ {"!="}
    | LT {"<"}
    | GT {">"}
    | LT_EQ {"<="}
    | GT_EQ { ">="}
    ;
add_op: 
    | PLUS {"+"}
    | MINUS {"-"}
    | BAR {"|"}
    | CARET {"^"}
    ;
mul_op:
    | STAR {"*"}
    | SLASH {"/"}
    | PERCENT {"%"}
    | SHIFT_RIGHT {">>"}
    | SHIFT_LEFT {"<<"}
    | AND { "&"}
    | AND_CARET { "&^" }
    ;
unary_op:
    | PLUS { '+' }
    | MINUS {'-'}
    | NOT {'!'}
    | CARET {'^'}
    ;
composite_lit: 
    | literal_type {()}
    | literal_value {()} 
    ; 
literal_type:
    | struct_type {()}
    | array_type {()}
    | OPEN_SQR_BRACKET TRIPLE_DOT CLOSE_SQR_BRACKET type_i {()}
    | slice_type {()}
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
%%
