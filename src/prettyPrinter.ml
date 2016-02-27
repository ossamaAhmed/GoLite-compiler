open Printf
open Ast

let file = ref "../your_program.go"
let oc = ref stdout
let set_file filename = (file := "../"^filename^".pretty.go"); oc:= (open_out (!file))
let write_message message = fprintf (!oc) "%s" message   (* write something *)   
let close oc = close_out oc
let indentation = Stack.create()
let _= Stack.push "" indentation
let indent ="  "



let rec print_list lis = match lis with
						| last::[]-> last
						| head::tail -> head^ (print_list tail)
let rec print_identifiers idenlist = match idenlist with
									| Identifier(value)::[] -> value
									| Identifier(value)::tail -> value^", "^(print_identifiers tail)
let print_literal lit = match lit with
						| Intliteral(value) -> (Printf.sprintf "%i" value)
						| Floatliteral(value) -> (Printf.sprintf "%f" value)
						| Runeliteral(value) -> (Printf.sprintf "%c" value)
						| Stringliteral(value) -> value



let rec print_type_name type_name = match type_name with
								| Definedtype(Identifier(value))->value
								| Primitivetype(value)->value 
								| Arraytype(len, type_name2)-> "[ "^(Printf.sprintf "%i" len)^" ] "^(print_type_name type_name2)
								| Slicetype(type_name2)->  "[ ] "^(print_type_name type_name2)
								| Structtype(field_dcl_list) -> 
									let print_field_dcl field = match field with 
																| (iden_list,type_name1) -> (Stack.top indentation)^(print_identifiers iden_list)^" "^(print_type_name type_name1)^";\n"
																| _ -> ast_error ("field_dcl_print error")
																in 
																let last_indent = (Stack.top indentation) in 
																let _= Stack.push (last_indent^indent) indentation in
																let result ="struct {\n"^(print_list(List.map print_field_dcl field_dcl_list))^"}\n" in 
																let _= Stack.pop indentation in result
let rec print_identifiers_with_type idenlist = match idenlist with
									| TypeSpec(Identifier(value),return_type)::[] -> value
									| TypeSpec(Identifier(value),return_type)::tail -> value^" "^(print_type_name return_type)^", "^(print_identifiers_with_type tail)


let print_type_declaration decl = match decl with
								| TypeSpec(Identifier(value), typename)-> (Stack.top indentation)^"type "^value^" "^(print_type_name typename)^"\n"
								| _-> ast_error ("type_dcl error")
								
let rec pretty_print_expression exp =
									let rec print_expressions exprlist = match exprlist with
									| head::[] -> pretty_print_expression head
									| head::tail -> ((pretty_print_expression head)^", "^(print_expressions tail) )in 
									match exp with 
												| OperandName(value)-> value
												| AndAndOp(exp1,exp2)-> "( "^(pretty_print_expression exp1)^" && "^(pretty_print_expression exp2 )^" )"
												| OrOrOp(exp1,exp2)-> "( "^(pretty_print_expression exp1)^" || "^(pretty_print_expression exp2 )^" )"
												| EqualEqualCmp(exp1,exp2)-> "( "^(pretty_print_expression exp1)^" == "^(pretty_print_expression exp2 )^" )"
												| NotEqualCmp(exp1,exp2)-> "( "^(pretty_print_expression exp1)^" != "^(pretty_print_expression exp2 )^" )"
												| LessThanCmp(exp1,exp2)-> "( "^(pretty_print_expression exp1)^" < "^(pretty_print_expression exp2 )^" )"
												| GreaterThanCmp (exp1,exp2)-> "( "^(pretty_print_expression exp1)^" >"^(pretty_print_expression exp2 )^" )"
												| LessThanOrEqualCmp(exp1,exp2)-> "( "^(pretty_print_expression exp1)^" <= "^(pretty_print_expression exp2 )^" )"
												| GreaterThanOrEqualCmp(exp1,exp2)-> "( "^(pretty_print_expression exp1)^" >= "^(pretty_print_expression exp2 )^" )"
												| AddOp(exp1,exp2)-> "( "^(pretty_print_expression exp1)^" + "^(pretty_print_expression exp2 )^" )"
												| MinusOp(exp1,exp2)-> "( "^(pretty_print_expression exp1)^" - "^(pretty_print_expression exp2 )^" )"
												| OrOp (exp1,exp2)-> "( "^(pretty_print_expression exp1)^" | "^(pretty_print_expression exp2 )^" )"
												| CaretOp (exp1,exp2)-> "( "^(pretty_print_expression exp1)^" ^ "^(pretty_print_expression exp2 )^" )"
												| MulOp (exp1,exp2)-> "( "^(pretty_print_expression exp1)^" * "^(pretty_print_expression exp2 )^" )"
												| DivOp (exp1,exp2)-> "( "^(pretty_print_expression exp1)^" / "^(pretty_print_expression exp2 )^" )"
												| ModuloOp (exp1,exp2)-> "( "^(pretty_print_expression exp1)^" % "^(pretty_print_expression exp2 )^" )"
												| SrOp (exp1,exp2)-> "( "^(pretty_print_expression exp1)^" >> "^(pretty_print_expression exp2 )^" )"
												| SlOp (exp1,exp2)-> "( "^(pretty_print_expression exp1)^" << "^(pretty_print_expression exp2 )^" )"
												| AndOp (exp1,exp2)-> "( "^(pretty_print_expression exp1)^" & "^(pretty_print_expression exp2 )^" )"
												| AndCaretOp (exp1,exp2)-> "( "^(pretty_print_expression exp1)^" &^ "^(pretty_print_expression exp2 )^" )"
												| OperandParenthesis (exp1)-> (pretty_print_expression exp1)
												| Indexexpr(exp1,exp2)-> "( "^(pretty_print_expression exp1)^"["^(pretty_print_expression exp2 )^"]"^")"
												| Unaryexpr(exp1) -> (pretty_print_expression exp1)
												| Binaryexpr(exp1) -> (pretty_print_expression exp1)
												| FuncCallExpr(Identifier(iden),exprs)-> "( "^iden^"("^(print_expressions exprs)^")"^")"
												| UnaryPlus(exp1) -> "( +"^(pretty_print_expression exp1)^" )"
												| UnaryMinus(exp1) -> "( -"^(pretty_print_expression exp1)^" )"
												| UnaryNot(exp1) -> "( !"^(pretty_print_expression exp1)^" )"
												| UnaryCaret(exp1) -> "( ^"^(pretty_print_expression exp1)^" )"
												| Value(value)-> (print_literal value)
												| Selectorexpr(exp1,Identifier(iden))-> "("^(pretty_print_expression exp1)^"."^iden^")"
												| TypeCastExpr (typename,exp1) -> "( "^(print_type_name typename)^"("^(pretty_print_expression exp1)^"))"
												| Appendexpr (Identifier(iden),exp1)-> "( append("^iden^", "^(pretty_print_expression exp1)^"))"
												| _-> ast_error ("expression error")

let rec print_expressions exprlist = match exprlist with

									| head::[] -> pretty_print_expression head
									| head::tail -> (pretty_print_expression head)^", "^(print_expressions tail)

let print_variable_declaration decl= match decl with
									| VarSpecWithType (iden_list,typename,exprs) -> ( match exprs with
																							| [] -> "var "^(print_identifiers iden_list)^" "^(print_type_name typename)^";\n"
																							| head::tail -> "var "^(print_identifiers iden_list)^" "^(print_type_name typename)^" = "^(print_expressions exprs)^";\n"
																					)
									| VarSpecWithoutType  (iden_list,exprs) -> ( match exprs with
																							| [] -> "var "^(print_identifiers iden_list)^";\n"
																							| head::tail -> "var "^(print_identifiers iden_list)^" = "^(print_expressions exprs)^";\n")
									| _ -> ast_error ("var_dcl error")

let rec  print_stmts stmts = match stmts with
									| [] -> ""
									| head::[] -> print_stmt head
									| head::tail -> (print_stmt head)^";\n"^(print_stmts tail)
and print_stmt stmt = match stmt with
				    | Declaration(dcl)-> print_declaration dcl;"" (*DONE*)
				    | Return(rt_stmt)-> print_return_stmt rt_stmt (*DONE*)
				    | Break -> "break" 
				    | Continue -> "continue"
				    | Block(stmt_list)-> print_stmts stmt_list (*DONE*)
				    | Conditional(conditional)-> print_conditional conditional (*DONE*)
				    | Switch(switch_clause, switch_expr, switch_case_stmts)-> "switch "^(print_switch_clause switch_clause)^" "^(print_switch_expression switch_expr)^" {\n"^(print_switch_case_stmt switch_case_stmts)^"}"
				    | For(for_stmt)-> print_for_stmt for_stmt (*DONE*)
				    | Simple(simple)-> print_simple_stmt simple 
				    | Print(exprs)-> "print ("^(print_expressions exprs)^" )" (*DONE*)
				    | Println(exprs)-> "println ("^(print_expressions exprs)^" )" (*DONE*)
and print_return_stmt stmt= match stmt with
							| Empty -> "return"
							| ReturnStatement(expr)-> "return"^(pretty_print_expression expr)
and print_conditional cond = match cond with 
							| IfStmt(if_stmt)-> print_if_stmt if_stmt
							| ElseStmt(else_stmt)-> print_else_stmt else_stmt
and print_if_stmt if_stmt = match if_stmt with
							| IfInit(if_init, condition, stmts)-> "if "^(print_if_init if_init)^(print_condition condition)^"{\n"^(print_stmts stmts)^"}"
and print_if_init if_init = match if_init with
							| Empty -> ""
							| IfInitSimple(simplestmt) -> (print_simple_stmt simplestmt)^";"
and print_simple_stmt stmt = match stmt with 
							| Empty -> ""
							| SimpleExpression(expr)-> pretty_print_expression expr
							| IncDec(incdec)-> print_inc_dec_stmt incdec 
							| Assignment(assignment_stmt)-> print_assignment_stmt assignment_stmt
							| ShortVardecl(short_var_decl)-> print_short_var_decl short_var_decl
and  print_condition cond = match cond with 
							| Empty -> ""
							| ConditionExpression (expr)-> pretty_print_expression expr
and print_else_stmt stmt =  match stmt with 
							| ElseSingle(if_stmt,stmts)-> (print_if_stmt if_stmt)^" else {\n "^(print_stmts stmts)^"}"
						    | ElseIFMultiple(if_stmt,else_stmt)->(print_if_stmt if_stmt)^" else "^(print_else_stmt else_stmt)
						    | ElseIFSingle(if_stmt1,if_stmt2)->(print_if_stmt if_stmt1)^" else "^(print_if_stmt if_stmt2)
and print_for_stmt stmt = match stmt with 
				    | Forstmt(stmts)-> "for {\n"^(print_stmts stmts)^"}"
				    | ForCondition(condition, stmts)-> "for "^(print_condition condition)^"{\n"^(print_stmts stmts)^"}"
				    | ForClause (for_clause, stmts)-> "for "^(print_clause for_clause)^"{\n"^(print_stmts stmts)^"}"
and print_clause clause= match clause with 
						 | ForClauseCond(simple1,condition,simple2)-> "( "^(print_simple_stmt simple1)^"; "^(print_condition condition)^"; "^(print_simple_stmt simple2)^" )"


and print_switch_clause clause = match clause with
								| Empty -> ""
								| SwitchClause(simple_stmt) -> (print_simple_stmt simple_stmt)^";"
and print_switch_expression expr = match expr with 
								| Empty -> ""
								| SwitchExpr(expr)-> (pretty_print_expression expr)	
and print_switch_case_clause clause = match clause with 
								| SwitchCaseClause(exprs, stmts)-> (match exprs with
																	| []->	"default : "^(print_stmts stmts)
																	| head::tail -> "case "^(print_expressions exprs)^" : "^(print_stmts stmts)
																	)
								| Empty -> ""	

and print_switch_case_stmt stmts = match stmts with
								| SwitchCasestmt(switch_case_clauses)->(print_list(List.map print_switch_case_clause switch_case_clauses))						
and print_inc_dec_stmt stmt = match stmt with 
						 | Increment(expr)->(pretty_print_expression expr)^"++"
   						 | Decrement(expr)->(pretty_print_expression expr)^"--"

and print_assignment_stmt stmt = match stmt with 
						    | AssignmentBare(exprs1,exprs2)-> (print_expressions exprs1)^" = "^(print_expressions exprs2)
   						    | AssignmentOp(exprs1, assign_op, exprs2)-> (pretty_print_expression exprs1)^assign_op^(pretty_print_expression exprs2)

and print_short_var_decl dcl = match dcl with
							| ShortVarDecl(idens, exprs)-> (print_identifiers idens)^" := "^(print_expressions exprs)



and print_declaration decl = match decl with 
								| TypeDcl(value)-> write_message(print_list(List.map print_type_declaration value))
								| VarDcl(value)->  write_message (print_list(List.map print_variable_declaration value))
								| Function(func_name,signature,stmts)-> write_message (print_function_declaration signature stmts)

and print_signature signature = match signature with
	|FuncSig(FuncParams(func_params), FuncReturnType(return_type)) -> (print_identifiers_with_type func_params)^":"^(print_type_name return_type)

and print_function_declaration signature stmts =
	(print_signature signature)^(print_stmts stmts)

let pretty_print program filename= 
							let _= set_file filename in 
								 (match program with
									  | Prog(packagename,dcllist)->
									          let _=write_message ("package "^(packagename)^" ;\n") in 
											  (List.map print_declaration dcllist))


