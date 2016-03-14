open Ast



let weed_literal lit = match lit with
						| Intliteral(value) -> ""
						| Floatliteral(value) -> ""
						| Runeliteral(value) -> ""
						| Stringliteral(value) -> ""



let rec weed_type_name type_name = match type_name with
								| Definedtype(Identifier(value))->""
								| Primitivetype(value)->"" 
								| Arraytype(len, type_name2)-> ""
								| Slicetype(type_name2)-> ""
								| Structtype(field_dcl_list) -> ""
								
																
let rec weed_identifiers_with_type idenlist = match idenlist with
									| [] -> ""
									| TypeSpec(Identifier(value),return_type)::[] -> ""
									| TypeSpec(Identifier(value),return_type)::tail -> ""

let weed_type_declaration decl = match decl with
								| TypeSpec(Identifier(value), typename)-> ""
								
let rec weed_expression exp = match exp with
												| OperandName(value)-> value
												| AndAndOp(exp1,exp2)-> ""
												| OrOrOp(exp1,exp2)->""
												| EqualEqualCmp(exp1,exp2)->""
												| NotEqualCmp(exp1,exp2)-> ""
												| LessThanCmp(exp1,exp2)-> ""
												| GreaterThanCmp (exp1,exp2)-> ""
												| LessThanOrEqualCmp(exp1,exp2)-> ""
												| GreaterThanOrEqualCmp(exp1,exp2)-> ""
												| AddOp(exp1,exp2)-> ""
												| MinusOp(exp1,exp2)-> ""
												| OrOp (exp1,exp2)-> ""
												| CaretOp (exp1,exp2)-> ""
												| MulOp (exp1,exp2)-> ""
												| DivOp (exp1,exp2)-> ""
												| ModuloOp (exp1,exp2)-> ""
												| SrOp (exp1,exp2)-> ""
												| SlOp (exp1,exp2)-> ""
												| AndOp (exp1,exp2)-> ""
												| AndCaretOp (exp1,exp2)-> ""
												| OperandParenthesis (exp1)-> ""
												| Indexexpr(exp1,exp2)-> ""
												| Unaryexpr(exp1) -> ""
												| Binaryexpr(exp1) -> ""
												| FuncCallExpr(Identifier(iden),exprs)-> ""
												| UnaryPlus(exp1) -> ""
												| UnaryMinus(exp1) -> ""
												| UnaryNot(exp1) -> ""
												| UnaryCaret(exp1) -> ""
												| Value(value)-> ""
												| Selectorexpr(exp1,Identifier(iden))-> ""
												| TypeCastExpr (typename,exp1) -> ""
												| Appendexpr (Identifier(iden),exp1)-> ""

let rec weed_expressions exprlist = match exprlist with
									| head::[] -> ""
									| head::tail -> ""

let weed_variable_declaration decl= match decl with
									| VarSpecWithType (iden_list,typename,exprs) -> ""
									| VarSpecWithoutType  (iden_list,exprs) -> ""

let rec  weed_stmts stmts case = match stmts with
									| [] -> ""
									| head::[] -> weed_stmt head case
									| head::tail -> let _= weed_stmt head case in weed_stmts tail case
and weed_stmts_without_break_continue stmts case= match stmts with
									| [] -> ""
									| Break::tail ->  ast_error "Break statement outside a loop"
									| Continue::tail ->  ast_error "Continue statement outside a loop"
									| head::[] -> weed_stmt head case
									| head::tail -> let _= weed_stmt head case in weed_stmts_without_break_continue tail case

and weed_stmts_without_continue stmts case= match stmts with
									| [] -> ""
									| Continue::tail ->  ast_error "Continue statement outside a loop"
									| head::[] -> weed_stmt head case
									| head::tail -> let _= weed_stmt head case in weed_stmts_without_continue tail case
and weed_stmt stmt case=

					match stmt with
				    | Declaration(dcl)-> ""
				    | Return(rt_stmt)-> ""
				    | Break -> ""
				    | Continue -> ""
				    | Block(stmt_list)-> (match case with
				    					| "withoutcontinue" -> weed_stmts_without_continue stmt_list case
				    					| "withoutbreakandcontinue"-> weed_stmts_without_break_continue stmt_list case
				    					| _ -> weed_stmts stmt_list case)
				    | Conditional(conditional)-> weed_conditional conditional case
				    | Switch(switch_clause, switch_expr, switch_case_stmts)-> weed_switch_case_stmt switch_case_stmts case
				    | For(for_stmt)-> ""
				    | Simple(simple)-> weed_simple_stmt simple
				    | Print(exprs)-> ""
				    | Println(exprs)-> ""
and weed_return_stmt stmt= match stmt with
							| Empty -> ""
							| ReturnStatement(expr)-> ""
and weed_conditional cond case = match cond with 
							| IfStmt(if_stmt)-> weed_if_stmt if_stmt case
							| ElseStmt(else_stmt)-> weed_else_stmt else_stmt case
and weed_if_stmt if_stmt case= match if_stmt with
							| IfInit(if_init, condition, stmts)-> (match case with
				    					| "withoutcontinue" -> weed_stmts_without_continue stmts case
				    					| "withoutbreakandcontinue"-> weed_stmts_without_break_continue stmts case
				    					| _ -> weed_stmts stmts case)
and weed_if_init if_init = match if_init with
							| IfInitSimple(simplestmt) -> ""
							| Empty -> ""
and weed_simple_stmt stmt = match stmt with 
							| SimpleExpression(expr)-> ""
							| IncDec(incdec)-> weed_inc_dec_stmt incdec
							| Assignment(assignment_stmt)-> weed_assignment_stmt assignment_stmt
							| ShortVardecl(short_var_decl)-> ""
							| Empty -> ""
and  weed_condition cond = match cond with 
							| ConditionExpression (expr)-> ""
							| Empty -> ""

and weed_else_stmt stmt case=  match stmt with 
							| ElseSingle(if_stmt,stmts)->  (match case with
				    					| "withoutcontinue" -> weed_stmts_without_continue stmts case
				    					| "withoutbreakandcontinue"-> weed_stmts_without_break_continue stmts case
				    					| _ -> weed_stmts stmts case)
						    | ElseIFMultiple(if_stmt,else_stmt)-> let _=(weed_if_stmt if_stmt case) in weed_else_stmt else_stmt case
						    | ElseIFSingle(if_stmt1,if_stmt2)-> let _=(weed_if_stmt if_stmt1 case) in weed_if_stmt if_stmt2 case
and weed_for_stmt stmt = match stmt with 
				    | Forstmt(stmts)-> ""
				    | ForCondition(condition, stmts)-> ""
				    | ForClause (for_clause, stmts)-> ""
and weed_clause clause= match clause with 
						 | ForClauseCond(simple1,condition,simple2)->""


and weed_switch_clause clause = match clause with
								| SwitchClause(simple_stmt) -> ""
								| Empty -> ""
and weed_switch_expression expr = match expr with 
								| SwitchExpr(expr)-> ""
								| Empty -> ""
and count_switch_case_defaults switchcaseclauses count= match switchcaseclauses with
											| [] -> if count>1 then ast_error "more than one default case" else count
											| SwitchCaseClause(exprs, stmts)::tail -> (match exprs with
																	| []->	count_switch_case_defaults tail (count+1)
																	| head::tail2 -> count_switch_case_defaults tail count
																	)
											| Empty::tail -> count_switch_case_defaults tail count
and weed_switch_case_clause case clause= match clause with 
								| SwitchCaseClause(exprs, stmts)-> (match case with
				    					| "withoutcontinue" -> weed_stmts_without_continue stmts case
				    					| "withoutbreakandcontinue"-> weed_stmts_without_break_continue stmts case
				    					| _ -> weed_stmts stmts case)
								| Empty -> ""	

and weed_switch_case_stmt stmts case= match stmts with
								| SwitchCasestmt(switch_case_clauses)-> 
												let defaults_count= count_switch_case_defaults switch_case_clauses 0 in 
												let _= (List.map (weed_switch_case_clause case) switch_case_clauses ) in ""

and lvalue_eval expr = match expr with 
						| OperandName(iden)-> ""
						| Indexexpr(expr1,expr2)-> ""
						| FuncCallExpr(Identifier(iden),exprs)-> ""
						| Appendexpr (Identifier(iden),exp1)-> ""
						| Selectorexpr(exp1,Identifier(iden))-> ""
						| _ -> ast_error "Lvalue error"
and weed_inc_dec_stmt stmt = match stmt with 
						 | Increment(expr)->  let _= ( lvalue_eval expr) in ""
   						 | Decrement(expr)->  let _= ( lvalue_eval expr) in ""

and weed_assignment_stmt stmt = match stmt with 
						    | AssignmentBare(exprs1,exprs2)-> let _= (List.map lvalue_eval exprs1) in ""
   						    | AssignmentOp(exprs1, assign_op, exprs2)-> lvalue_eval exprs1

and weed_short_var_decl dcl = match dcl with
							| ShortVarDecl(idens, exprs)-> ""



and weed_declaration decl = match decl with 
								| TypeDcl(value)-> List.map weed_type_declaration value
								| VarDcl(value)->  List.map weed_variable_declaration value
								| Function(func_name,signature,stmts)->  weed_function_declaration func_name signature stmts

and weed_signature_return_type return_type = match return_type with
	| FuncReturnType(return_type_i) -> ""
	| Empty -> ""

and weed_signature signature = match signature with
	FuncSig(FuncParams(func_params), return_type) -> ""

and weed_function_declaration func_name signature stmts = (weed_stmts stmts "withoutbreakandcontinue")::[]

let weed_program program = match program with
									  | Prog(packagename,dcllist)-> List.map weed_declaration dcllist









(* (* Traverse Tree and apply weeder rules *)
let rec weed tree depth= match tree with 
    | Prog(packagename,dcl)-> weed dcl depth
    | FuncReturnType(type_i) -> ()
    | Empty -> ()
    | FuncParams(typespec) -> weed typespec depth
    | FuncSig (func_params, func_return) -> ()
    | SwitchClause(simple) -> ()
    | SwitchExpr (expression) -> weed expression depth
    | SwitchCaseClause (expression,stmt) -> weed stmt depth | SwitchCasestmt (switch_case_clause) -> weed switch_case_clause depth 
    | Increment (expression)-> weed expression depth
    | Decrement (expression)-> weed expression depth
    | AssignmentBare (exp1,exp2)-> weed exp1 depth; weed exp2 depth
    | AssignmentOp (exp1,str,exp2)-> weed expression depth; weed expression depth
    | ShortVarDecl (identifier,expression)-> weed identifier depth; weed expression depth
    | SimpleExpression (expression)-> weed expression depth
    | IncDec (incdec)-> weed incdec depth
    | Assignment (assignment)-> weed assignemnt depth
    | ShortVardecl (short_var_decl)-> weed short_var_decl depth
    | ConditionExpression (expression)->  weed expression depth
    | ForClauseCond (simple,condition,simple2)-> weed simple depth; weed condition depth, weed simple2 depth
    | Forstmt (stmt)-> weed stmt depth
    | ForCondition (condition,stmt)-> weed stmt depth; weed condition depth
    | ForClause (for_clause,stmt)-> weed stmt depth; weed for_clause depth
    | ElseSingle(if_stmt,stmt)-> weed if_stmt depth; weed stmt depth
    | ElseIFMultiple ( if_stmt , else_stmt)->()
    | ElseIFSingle ( if_stmt , if_stmt)->()
    | IfInitSimple ( simple)->()
    | IfInit ( if_init , condition , stmt )->()
    | IfStmt ( if_stmt)->()
    | ElseStmt ( else_stmt)->()
    | ReturnStatement ( expression)->()
    | Declaration ( dcl )->()
    | Return ( rt_stmt)->()
    | Break -> if depth<1 then raise (GoliteError(Printf "Break outside square brackets")) else () (*TODO: CHECK if inside block*)
    | Continue -> if depth<1 then raise (GoliteError(Printf "Continue outside square brackets")) else ()(*TODO: CHECK IF INSIDE BLOCK *)
    | Block (stmt)-> weed stmt depth+1
    | Conditional ( conditional)->()
    | Switch ( switch_clause , switch_expr , switch_case_stmt)->()
    | For ( for_stmt)->()
    | Simple ( simple )->()
    | Print_arg ( expression )->()
    | Print_argln ( expression )->()
	| Identifier ( str)->()
	| Intliteral ( int_arg)->()
	| Floatliteral ( float_arg )->()
	| Runeliteral ( str )->()
	| Stringliteral ( str )->()
	| Definedtype ( identifier)->()
	| Primitivetype ( str )->()
	| Arraytype ( int_arg , type_i)->()
	| Slicetype ( type_i)->()
	| Structtype ( identifier  , type_i )->()
	| OperandName ( str)->()
	| AndAndOp ( expression , expression)->()
	| OrOrOp ( expression , expression)->()
	| EqualEqualCmp ( expression , expression)->()
	| NotEqualCmp ( expression , expression)->()
	| LessThanCmp ( expression , expression)->()
	| GreaterThanCmp ( expression , expression)->()
	| LessThanOrEqualCmp ( expression , expression)->()
	| GreaterThanOrEqualCmp ( expression , expression)->()
	| AddOp ( expression , expression)->()
	| MinusOp ( expression , expression)->()
	| OrOp ( expression , expression)->()
	| CaretOp ( expression , expression)->()
	| MulOp ( expression , expression)->()
	| DivOp ( expression , expression)->()
	| ModuloOp ( expression , expression)->()
	| SrOp ( expression , expression)->()
	| SlOp ( expression , expression)->()
	| AndOp ( expression , expression)->()
	| AndCaretOp ( expression , expression)->()
	| OperandParenthesis ( expression)->()
	| Indexexpr ( expression , expression)->()
	| Unaryexpr ( expression)->()
	| Binaryexpr ( expression)->()
	| FuncCallExpr ( identifier , expression )->()
	| UnaryPlus ( expression)->()
	| UnaryMinus ( expression)->()
	| UnaryNot ( expression)->()
	| UnaryCaret ( expression)->()
	| Value ( literal)->()
	| Selectorexpr ( expression , identifier)->()
	| TypeCastExpr ( type_i , expression)->()
	| Appendexpr ( identifier , expression)->()
	| VarSpecWithType ( identifier  , type_i , expression )->()
	| VarSpecWithoutType ( identifier  , expression 	)->()
	| TypeSpec ( identifier , type_i)->()
	| TypeDcl ( typespec )->()
	| VarDcl ( variablespec )->()
	| Function ( str , func_signature , stmt )->()
 *)