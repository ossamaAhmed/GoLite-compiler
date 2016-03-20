open Printf
open Ast
open Symboltbl

let file = ref "../your_program.go"
let oc = ref stdout
let set_file filename = (file := "../"^filename^".symboltable"); oc:= (open_out (!file))
let write_message message = fprintf (!oc) "%s" message   (* write something *)   
let close oc = close_out oc
let searched_type = ref "none"

exception Symbol_table_error of string

let symbol_table_error msg = raise (Symbol_table_error msg)

exception Type_checking_error of string

let type_checking_error msg = raise (Type_checking_error msg)


let symbol_table = ref []
let basic_table = (Hashtbl.create 20);;
Hashtbl.add basic_table "true" SymBool;;
Hashtbl.add basic_table "false" SymBool;;
symbol_table :=Scope(basic_table)::!symbol_table;;

let start_scope ()= symbol_table :=Scope(Hashtbl.create 50)::!symbol_table
let end_scope ()= match !symbol_table with 
				| head::tail -> symbol_table:= tail
let search_current_scope x= match !symbol_table with 
							| Scope(current_scope)::tail -> 
							if (Hashtbl.mem current_scope x) then 
									Hashtbl.find current_scope x
							else 
								    symbol_table_error ("variable is not defined")

let rec search_previous_scopes x table= match table with (*called with !symbol_table*)
							| []-> symbol_table_error ("variable is not defined")
							| Scope(current_scope)::tail -> 
							if (Hashtbl.mem current_scope x) then 
									Hashtbl.find current_scope x
							else 
								    search_previous_scopes x tail


let add_variable_to_current_scope mytype myvar=  match myvar with
											| Identifier(myvariable)-> 
												(match !symbol_table with
													| Scope(current_scope)::tail ->
													if not(Hashtbl.mem current_scope myvariable) then 
														Hashtbl.add current_scope myvariable mytype
													else 
														 symbol_table_error ("variable is defined more than one time")
												 ) 
let rec print_type y= match y with 
				| SymInt -> "int"
				| SymFloat64 -> "float"
				| SymRune -> "rune"
				| SymString -> "string"
				| SymBool -> "bool"	
				| SymArray(symType) -> "array"^(print_type symType) 
				| SymSlice (symType) -> "slice"^(print_type symType)
				| SymStruct (fieldlst)-> "struct" (*doesn't print out the fields*)
				| SymFunc(symType,argslist)->"function" (*doesn't print out the function args*) 							 

let print_tuple x y= write_message ("var: "^x^" ,type:"^(print_type y)^" \n")
let print_table tbl= match tbl with 
					| Scope(table)->Hashtbl.iter print_tuple table

let print_stack s= List.iter print_table !symbol_table









(* let rec typecheck_list lis = match lis with
						| last::[]-> last
						| head::tail -> head^ (typecheck_list tail)
let rec typecheck_identifiers idenlist = match idenlist with
									| Identifier(value)::[] -> value
									| Identifier(value)::tail -> value^", "^(typecheck_identifiers tail)
*)

let typecheck_literal lit = match lit with
						| Intliteral(value) -> SymInt
						| Floatliteral(value) ->SymFloat64
						| Runeliteral(value) -> SymRune
						| Stringliteral(value) -> SymString

let get_primitive_type typestr = match typestr with
						| "int" -> SymInt
						| "float64" ->SymFloat64
						| "rune" -> SymRune
						| "string" -> SymString
						| "bool" -> SymBool

let helper mytype x= match x with 
			| Identifier(myvar)->(myvar,mytype)

let rec struct_field_types identifierlst typ= let mytype= typecheck_type_name typ in List.map (helper mytype) identifierlst

and create_field_types_list lst= match lst with 
								| []->[]
								| (identifierlst,typ)::tail-> (struct_field_types identifierlst typ)@(create_field_types_list tail)

and typecheck_type_name type_name = match type_name with
								| Definedtype(Identifier(value))-> search_current_scope value
								| Primitivetype(value)-> get_primitive_type value 
								| Arraytype(len, type_name2)-> SymArray((typecheck_type_name type_name2))
								| Slicetype(type_name2)-> SymSlice((typecheck_type_name type_name2))
								| Structtype([]) -> SymStruct([])
								| Structtype(field_dcl_list) -> SymStruct(create_field_types_list field_dcl_list)
									(* let typecheck_field_dcl field = match field with 
																| (iden_list,type_name1) -> let mytype = typecheck_type_name typename in List.map (add_variable_to_current_scope mytype) iden_list
																| _ -> ast_error ("field_dcl_print error") *)
																
(*
let rec typecheck_identifiers_with_type idenlist = match idenlist with
									| [] -> ""
									| TypeSpec(Identifier(value),return_type)::[] -> value^" "^(typecheck_type_name return_type)
									| TypeSpec(Identifier(value),return_type)::tail -> value^" "^(typecheck_type_name return_type)^", "^(typecheck_identifiers_with_type tail)

let typecheck_type_declaration decl = match decl with
								| TypeSpec(Identifier(value), typename)-> (typecheck_indent)^"type "^value^" "^(typecheck_type_name typename)^"\n"
								| _-> ast_error ("type_dcl error")
*)								
(* let rec pretty_typecheck_expression exp =
									let rec typecheck_expressions exprlist = match exprlist with
									| [] -> ""
									| head::[] -> pretty_typecheck_expression head
									| head::tail -> ((pretty_typecheck_expression head)^", "^(typecheck_expressions tail) )in 
									match exp with 
												| OperandName(value)-> value
												| AndAndOp(exp1,exp2)-> "( "^(pretty_typecheck_expression exp1)^" && "^(pretty_typecheck_expression exp2 )^" )"
												| OrOrOp(exp1,exp2)-> "( "^(pretty_typecheck_expression exp1)^" || "^(pretty_typecheck_expression exp2 )^" )"
												| EqualEqualCmp(exp1,exp2)-> "( "^(pretty_typecheck_expression exp1)^" == "^(pretty_typecheck_expression exp2 )^" )"
												| NotEqualCmp(exp1,exp2)-> "( "^(pretty_typecheck_expression exp1)^" != "^(pretty_typecheck_expression exp2 )^" )"
												| LessThanCmp(exp1,exp2)-> "( "^(pretty_typecheck_expression exp1)^" < "^(pretty_typecheck_expression exp2 )^" )"
												| GreaterThanCmp (exp1,exp2)-> "( "^(pretty_typecheck_expression exp1)^" >"^(pretty_typecheck_expression exp2 )^" )"
												| LessThanOrEqualCmp(exp1,exp2)-> "( "^(pretty_typecheck_expression exp1)^" <= "^(pretty_typecheck_expression exp2 )^" )"
												| GreaterThanOrEqualCmp(exp1,exp2)-> "( "^(pretty_typecheck_expression exp1)^" >= "^(pretty_typecheck_expression exp2 )^" )"
												| AddOp(exp1,exp2)-> "( "^(pretty_typecheck_expression exp1)^" + "^(pretty_typecheck_expression exp2 )^" )"
												| MinusOp(exp1,exp2)-> "( "^(pretty_typecheck_expression exp1)^" - "^(pretty_typecheck_expression exp2 )^" )"
												| OrOp (exp1,exp2)-> "( "^(pretty_typecheck_expression exp1)^" | "^(pretty_typecheck_expression exp2 )^" )"
												| CaretOp (exp1,exp2)-> "( "^(pretty_typecheck_expression exp1)^" ^ "^(pretty_typecheck_expression exp2 )^" )"
												| MulOp (exp1,exp2)-> "( "^(pretty_typecheck_expression exp1)^" * "^(pretty_typecheck_expression exp2 )^" )"
												| DivOp (exp1,exp2)-> "( "^(pretty_typecheck_expression exp1)^" / "^(pretty_typecheck_expression exp2 )^" )"
												| ModuloOp (exp1,exp2)-> "( "^(pretty_typecheck_expression exp1)^" % "^(pretty_typecheck_expression exp2 )^" )"
												| SrOp (exp1,exp2)-> "( "^(pretty_typecheck_expression exp1)^" >> "^(pretty_typecheck_expression exp2 )^" )"
												| SlOp (exp1,exp2)-> "( "^(pretty_typecheck_expression exp1)^" << "^(pretty_typecheck_expression exp2 )^" )"
												| AndOp (exp1,exp2)-> "( "^(pretty_typecheck_expression exp1)^" & "^(pretty_typecheck_expression exp2 )^" )"
												| AndCaretOp (exp1,exp2)-> "( "^(pretty_typecheck_expression exp1)^" &^ "^(pretty_typecheck_expression exp2 )^" )"
												| OperandParenthesis (exp1)-> (pretty_typecheck_expression exp1)
												| Indexexpr(exp1,exp2)-> "( "^(pretty_typecheck_expression exp1)^"["^(pretty_typecheck_expression exp2 )^"]"^")"
												| Unaryexpr(exp1) -> (pretty_typecheck_expression exp1)
												| Binaryexpr(exp1) -> (pretty_typecheck_expression exp1)
												| FuncCallExpr(expr,exprs)-> "( "^(pretty_typecheck_expression expr)^"("^(typecheck_expressions exprs)^")"^")"
												| UnaryPlus(exp1) -> "( +"^(pretty_typecheck_expression exp1)^" )"
												| UnaryMinus(exp1) -> "( -"^(pretty_typecheck_expression exp1)^" )"
												| UnaryNot(exp1) -> "( !"^(pretty_typecheck_expression exp1)^" )"
												| UnaryCaret(exp1) -> "( ^"^(pretty_typecheck_expression exp1)^" )"
												| Value(value)-> (typecheck_literal value)
												| Selectorexpr(exp1,Identifier(iden))-> "("^(pretty_typecheck_expression exp1)^"."^iden^")"
												| TypeCastExpr (typename,exp1) -> "( "^(typecheck_type_name typename)^"("^(pretty_typecheck_expression exp1)^"))"
												| Appendexpr (Identifier(iden),exp1)-> "( append("^iden^", "^(pretty_typecheck_expression exp1)^"))"
												| _-> ast_error ("expression error") *)
(*
let rec typecheck_expressions exprlist = match exprlist with
									| [] -> ""
									| head::[] -> pretty_typecheck_expression head
									| head::tail -> (pretty_typecheck_expression head)^", "^(typecheck_expressions tail) *)

 let typecheck_variable_declaration decl= match decl with
									| VarSpecWithType (iden_list,typename,exprs) -> let mytype = typecheck_type_name typename in let result=List.map (add_variable_to_current_scope mytype) iden_list in ()
																					(* ( match exprs with
																							| [] -> "var "^(typecheck_identifiers iden_list)^" "^(typecheck_type_name typename)^";\n"
																							| head::tail -> "var "^(typecheck_identifiers iden_list)^" "^(typecheck_type_name typename)^" = "^(typecheck_expressions exprs)^";\n"
																					) *)
									| VarSpecWithoutType  (iden_list,exprs) -> ()
																						(* ( match exprs with
																							| [] -> "var "^(typecheck_identifiers iden_list)^";\n"
																							| head::tail -> "var "^(typecheck_identifiers iden_list)^" = "^(typecheck_expressions exprs)^";\n") *)
									| _ -> ast_error ("var_dcl error")
 
(*let rec  typecheck_stmts stmts = match stmts with
									| [] -> ""
									| head::[] -> (typecheck_indent)^(typecheck_stmt head)^";\n"
									| head::tail -> (typecheck_indent)^(typecheck_stmt head)^";\n"^(typecheck_stmts tail)
and typecheck_stmt stmt = match stmt with
				    | Declaration(dcl)-> (match dcl with 
				    			| TypeDcl([])->  ""
								| TypeDcl(value)-> typecheck_list(List.map typecheck_type_declaration value)
								| VarDcl([])->  ""
								| VarDcl(value)->   typecheck_list(List.map typecheck_variable_declaration value)
								| Function(func_name,signature,stmts)->  typecheck_function_declaration func_name signature stmts)
				    | Return(rt_stmt)-> typecheck_return_stmt rt_stmt (*DONE*)
				    | Break -> "break " 
				    | Continue -> "continue "
				    | Block(stmt_list)-> typecheck_stmts stmt_list (*DONE*)
				    | Conditional(conditional)-> typecheck_conditional conditional (*DONE*)
				    | Switch(switch_clause, switch_expr, switch_case_stmts)-> "switch "^(typecheck_switch_clause switch_clause)^" "^(typecheck_switch_expression switch_expr)^" {\n"^(typecheck_switch_case_stmt switch_case_stmts)^"}"
				    | For(for_stmt)-> typecheck_for_stmt for_stmt (*DONE*)
				    | Simple(simple)-> typecheck_simple_stmt simple 
				    | Print(exprs)-> "print ("^(typecheck_expressions exprs)^") " (*DONE*)
				    | Println(exprs)-> "println ("^(typecheck_expressions exprs)^") " (*DONE*)
and typecheck_return_stmt stmt= match stmt with
							| Empty -> "return "
							| ReturnStatement(expr)-> "return "^(pretty_typecheck_expression expr)
and typecheck_conditional cond = match cond with 
							| IfStmt(if_stmt)-> typecheck_if_stmt if_stmt
							| ElseStmt(else_stmt)-> typecheck_else_stmt else_stmt
and typecheck_if_stmt if_stmt = match if_stmt with
							| IfInit(if_init, condition, stmts)-> "if "^(typecheck_if_init if_init)^(typecheck_condition condition)^"{\n"^(typecheck_stmts stmts)^"}"
and typecheck_if_init if_init = match if_init with
							| Empty -> ""
							| IfInitSimple(simplestmt) -> (typecheck_simple_stmt simplestmt)^";"
and typecheck_simple_stmt stmt = match stmt with 
							| Empty -> ""
							| SimpleExpression(expr)-> pretty_typecheck_expression expr
							| IncDec(incdec)-> typecheck_inc_dec_stmt incdec 
							| Assignment(assignment_stmt)-> typecheck_assignment_stmt assignment_stmt
							| ShortVardecl(short_var_decl)-> typecheck_short_var_decl short_var_decl
and  typecheck_condition cond = match cond with 
							| Empty -> ""
							| ConditionExpression (expr)-> pretty_typecheck_expression expr
and typecheck_else_stmt stmt =  match stmt with 
							| ElseSingle(if_stmt,stmts)-> (typecheck_if_stmt if_stmt)^" else {\n "^(typecheck_stmts stmts)^"}"
						    | ElseIFMultiple(if_stmt,else_stmt)->(typecheck_if_stmt if_stmt)^" else "^(typecheck_else_stmt else_stmt)
						    | ElseIFSingle(if_stmt1,if_stmt2)->(typecheck_if_stmt if_stmt1)^" else "^(typecheck_if_stmt if_stmt2)
and typecheck_for_stmt stmt = match stmt with 
				    | Forstmt(stmts)-> "for {\n"^(typecheck_stmts stmts)^"}"
				    | ForCondition(condition, stmts)-> "for "^(typecheck_condition condition)^"{\n"^(typecheck_stmts stmts)^"}"
				    | ForClause (for_clause, stmts)-> "for "^(typecheck_clause for_clause)^"{\n"^(typecheck_stmts stmts)^"}"
and typecheck_clause clause= match clause with 
						 | ForClauseCond(simple1,condition,simple2)-> " "^(typecheck_simple_stmt simple1)^"; "^(typecheck_condition condition)^"; "^(typecheck_simple_stmt simple2)^" "


and typecheck_switch_clause clause = match clause with
								| Empty -> ""
								| SwitchClause(simple_stmt) -> (typecheck_simple_stmt simple_stmt)^";"
and typecheck_switch_expression expr = match expr with 
								| Empty -> ""
								| SwitchExpr(expr)-> (pretty_typecheck_expression expr)	
and typecheck_switch_case_clause clause = match clause with 
								| SwitchCaseClause(exprs, stmts)-> (match exprs with
																	| []->	"default : "^(typecheck_stmts stmts)
																	| head::tail -> "case "^(typecheck_expressions exprs)^" : "^(typecheck_stmts stmts)
																	)
								| Empty -> ""	

and typecheck_switch_case_stmt stmts = match stmts with
								| SwitchCasestmt([]) -> ""
								| SwitchCasestmt(switch_case_clauses)->(typecheck_list(List.map typecheck_switch_case_clause switch_case_clauses))						
and typecheck_inc_dec_stmt stmt = match stmt with 
						 | Increment(expr)->(pretty_typecheck_expression expr)^"++"
   						 | Decrement(expr)->(pretty_typecheck_expression expr)^"--"

and typecheck_assignment_stmt stmt = match stmt with 
						    | AssignmentBare(exprs1,exprs2)-> (typecheck_expressions exprs1)^" = "^(typecheck_expressions exprs2)
   						    | AssignmentOp(exprs1, assign_op, exprs2)-> (pretty_typecheck_expression exprs1)^assign_op^(pretty_typecheck_expression exprs2)

and typecheck_short_var_decl dcl = match dcl with
							| ShortVarDecl(idens, exprs)-> (typecheck_identifiers idens)^" := "^(typecheck_expressions exprs)

*)

let typecheck_declaration decl = match decl with 
								| TypeDcl([])->  ()
								| TypeDcl(value)->() (* write_message(typecheck_list(List.map typecheck_type_declaration value)) *)
								| VarDcl([])->  ()
								| VarDcl(value)-> let result= (List.map typecheck_variable_declaration value) in ()
								| Function(func_name,signature,stmts)->() (* write_message (typecheck_function_declaration func_name signature stmts) *)
								| _ -> ()

(*and typecheck_signature_return_type return_type = match return_type with
	| FuncReturnType(return_type_i) -> (typecheck_type_name return_type_i)^" "
	| Empty -> ""

and typecheck_signature signature = match signature with
	FuncSig(FuncParams(func_params), return_type) -> "("^(typecheck_identifiers_with_type func_params)^")"^" "^(typecheck_signature_return_type return_type)

and typecheck_function_declaration func_name signature stmts =
	"func "^(func_name)^(typecheck_signature signature)^"{\n"^(inc_indent)^(typecheck_stmts stmts)^(dec_indent)^"};\n" *)

let type_check_program program filename= 
							let _= set_file filename in let _=start_scope () in
								 (match program with
									  | Prog(packagename,dcllist)->
									          (* let _=write_message ("package "^(packagename)^" ;\n") in  *)
											  let a= (List.map typecheck_declaration dcllist)in print_stack symbol_table) 


