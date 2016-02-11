/*File parser

Without %token WHILE DO DONE


*/
%{
	open Error
	open GenerateAST


(* let parse_error msg = raise Error *)
%}

%token EOF
%token INTDCL FLOATDCL STRINGDCL
%token <string> STRINGVAR
%token <string> IDENTIFIER
%token <int> INTLITERAL
%token <float> FLOATLITERAL
%token VARDCL
%token READ PRINT
%token IF THEN ELSE ENDIF 
%token WHILE DO DONE
%token ASSIGN 
%token ADD SUB TIMES DIV
%token LPAREN RPAREN
%token COLON SEMICOLON 
%left ADD SUB        /* lowest precedence */
%left TIMES DIV         /* medium precedence */
%nonassoc UMINUS        /* highest precedence */

%start main
%type <Ast.prog> main

%%

main: 
| 	declarations statements EOF { generate_program $1 $2 }
| 	error { raise (MinilangError (Printf.sprintf "Syntax Error at (%d)" ((!line_num))   )) }

;

declarations:
| 	{ [] }
|	declaration declarations { $1::$2 }

;
statements:
|	{ [] }
|	statement statements { $1::$2 }

;
declaration:
|	VARDCL IDENTIFIER COLON FLOATDCL SEMICOLON { generate_dcl 'f' $2 }
|	VARDCL IDENTIFIER COLON INTDCL SEMICOLON { generate_dcl 'i' $2 }
|	VARDCL IDENTIFIER COLON STRINGDCL SEMICOLON { generate_dcl 's' $2 }
|	VARDCL COLON INTDCL SEMICOLON { raise (MinilangError (Printf.sprintf "Missing identifier at (%d)" ((!line_num)))) }
|   VARDCL IDENTIFIER INTDCL SEMICOLON 
			{ raise (MinilangError (Printf.sprintf "Missing colon at (%d)" ((!line_num)))) }
|   VARDCL IDENTIFIER COLON SEMICOLON 
			{ raise (MinilangError (Printf.sprintf "Missing type declaration keyword at (%d)" ((!line_num)))) }

;
statement:
|	IDENTIFIER ASSIGN expression SEMICOLON {  generate_assignment_stmt $1 $3 }
|	PRINT expression SEMICOLON {  generate_print_stmt $2 }
|	READ IDENTIFIER SEMICOLON { generate_read_stmt $2 }
|	IF expression THEN statements ELSE statements ENDIF { generate_if_then_else_stmt $2 $4 $6 }
|	IF expression THEN  statements ENDIF	{  generate_if_then_stmt $2 $4  }
|	WHILE expression DO statements DONE { generate_while_do_stmt $2 $4 }
|	IDENTIFIER expression SEMICOLON 
		{  raise (MinilangError (Printf.sprintf "Missing assignment sign at (%d)" ((!line_num)))) }
|	IDENTIFIER  SEMICOLON 
		{  raise (MinilangError (Printf.sprintf "Missing assignment sign and expression at (%d)" ((!line_num)))) }
|	IDENTIFIER ASSIGN SEMICOLON 
		{  raise (MinilangError (Printf.sprintf "Missing expression at (%d)" ((!line_num)))) }
|	PRINT SEMICOLON
		{  raise (MinilangError (Printf.sprintf "Missing print expression at (%d)" ((!line_num)))) }
|	READ SEMICOLON
		{  raise (MinilangError (Printf.sprintf "Missing identifier to read at (%d)" ((!line_num)))) }
|	IF expression  statements ELSE statements ENDIF
		{  raise (MinilangError (Printf.sprintf "Missing then for the if specifed at (%d)" ((!line_num)))) }
|	WHILE expression  statements DONE
		{  raise (MinilangError (Printf.sprintf "Missing do for the while statement specifed at (%d)" ((!line_num)))) }


;
expression:
| 	value { $1 }
| 	LPAREN expression RPAREN      { generate_parathesis_expression $2 }
|	expression ADD expression { generate_bin_expression '+' $1 $3 }
|	expression SUB expression { generate_bin_expression '-' $1 $3 }
|	expression TIMES expression { generate_bin_expression '*' $1 $3 }
|	expression DIV expression { generate_bin_expression '/' $1 $3 }
|   SUB expression %prec UMINUS { generate_unary_expression $2 }
;
value:
|	IDENTIFIER { generate_symbol $1 }
|	INTLITERAL { generate_integer $1 }
|	FLOATLITERAL { generate_float $1 }
|   STRINGVAR   { generate_string $1 }
;

%%
