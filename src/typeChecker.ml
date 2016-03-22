open Printf
open Ast
open Symboltbl

let file = ref "../your_program.go"
let oc = ref stdout
let set_file filename = (file := "../"^filename^".symboltable"); oc:= (open_out (!file))
let write_message message = fprintf (!oc) "%s" message   (* write something *)   
let close oc = close_out oc
let scope_counter = ref 1

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
											| Identifier(myvariable,linenum)-> 
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
				| SymType(symType)-> print_type symType				
				| Void -> "void"			 

let print_tuple x y= write_message ("var: "^x^" ,type:"^(print_type y)^" \n")
let print_table tbl= match tbl with 
					| Scope(table)->let _= write_message ("\n\nscope number"^(Printf.sprintf "%i" !scope_counter)^"\n\n") 
									in let _= Hashtbl.iter print_tuple table 
									in scope_counter:= !scope_counter+1

let print_stack s= List.iter print_table !symbol_table


let is_basetype_typecheck a= match a with 
						| SymInt -> true
						| SymFloat64-> true
						| SymRune-> true
						| SymBool-> true
						| SymString-> true
						| _ -> false


let rec is_exprs_of_base_type expr_list_types= match expr_list_types with 
				    				 	| []-> true
				    				 	| head::tail -> if (is_basetype_typecheck head) then is_exprs_of_base_type tail
				    				 					else false




let numeric_typecheck a b= match a,b with 
						| SymInt, SymInt -> SymInt
						| SymFloat64, SymFloat64 -> SymFloat64
						| SymInt, SymFloat64 ->SymInt
						| SymFloat64, SymInt -> SymFloat64
						| SymRune, SymRune->SymRune
						| SymRune, SymInt->SymRune
						| SymRune, SymFloat64-> SymRune
						| SymInt, SymRune->SymInt
						| SymFloat64, SymRune-> SymFloat64
						| _ ,_ -> type_checking_error "arithmetic operation should be done on a numeric value"
let comparable_typecheck a b= match a,b with 
						| SymInt, SymInt -> SymBool
						| SymFloat64, SymFloat64 -> SymBool
						| SymRune, SymRune->SymBool
						| SymString, SymString -> SymBool
						| SymBool, SymBool->SymBool 
						|_ ,_ -> type_checking_error "arguments are not comparable"
let ordered_typecheck a b= match a,b with 
						| SymInt, SymInt -> SymBool
						| SymFloat64, SymFloat64 -> SymBool
						| SymRune, SymRune->SymBool
						| SymString, SymString -> SymBool
						|_ ,_ -> type_checking_error "arguments are not comparable"

let numeric_string_typecheck a b= match a,b with 
						| SymInt, SymInt -> SymInt
						| SymFloat64, SymFloat64 -> SymFloat64
						| SymInt, SymFloat64 ->SymInt
						| SymFloat64, SymInt -> SymFloat64
						| SymRune, SymRune->SymRune
						| SymRune, SymInt->SymRune
						| SymRune, SymFloat64-> SymRune
						| SymInt, SymRune->SymInt
						| SymFloat64, SymRune-> SymFloat64
						| SymString, SymString -> SymString
						| SymInt, SymString -> SymInt
						| SymString, SymInt -> SymString
						| SymFloat64, SymString -> SymFloat64
						| SymString, SymFloat64-> SymString
						| SymString, SymRune->SymString
						| SymRune, SymString-> SymRune
						| _ ,_ -> type_checking_error "plus operation should be done on a numeric value or string"

let integer_typecheck a b= match a,b with 
						| SymInt, SymInt -> SymInt
						| _ ,_ -> type_checking_error "arithmetic operation should be done on a integer value"
let bool_typecheck a b= match a,b with 
						| SymBool, SymBool -> SymBool
						| _ ,_ -> type_checking_error "comparison operation should be done on bool values"

let typecheck_literal lit = match lit with
						| Intliteral(value,linenum) -> SymInt
						| Floatliteral(value,linenum) ->SymFloat64
						| Runeliteral(value,linenum) -> SymRune
						| Stringliteral(value,linenum) -> SymString

let get_primitive_type typestr = match typestr with
						| "int" -> SymInt
						| "float64" ->SymFloat64
						| "rune" -> SymRune
						| "string" -> SymString
						| "bool" -> SymBool

let helper mytype x= match x with 
			| Identifier(myvar,linenum)->(myvar,mytype)

let rec struct_field_types identifierlst typ= let mytype= typecheck_type_name typ in List.map (helper mytype) identifierlst

and create_field_types_list lst= match lst with 
								| []->[]
								| (identifierlst,typ)::tail-> (struct_field_types identifierlst typ)@(create_field_types_list tail)

and typecheck_type_name type_name = match type_name with
								| Definedtype(Identifier(value,linenum1),linenum2)->let x= search_current_scope value in (match x with | SymType(mytype)-> mytype)
								| Primitivetype(value,linenum)-> get_primitive_type value 
								| Arraytype(len, type_name2,linenum)-> SymArray((typecheck_type_name type_name2))
								| Slicetype(type_name2,linenum)-> SymSlice((typecheck_type_name type_name2))
								| Structtype([],linenum) -> SymStruct([])
								| Structtype(field_dcl_list,linenum) -> SymStruct(create_field_types_list field_dcl_list)
																

let rec typecheck_identifiers_with_type idenlist = match idenlist with
									| [] -> []
									| TypeSpec(Identifier(value,linenum1),return_type,linenum2)::tail -> let mytype = typecheck_type_name return_type in 
																						(value, mytype)::(typecheck_identifiers_with_type tail)

and typecheck_identifiers_with_type_new_scope idenlist = match idenlist with
									| [] -> ()
									| TypeSpec(value,return_type,linenum)::tail -> let mytype = typecheck_type_name return_type in 
																		    let _= add_variable_to_current_scope mytype value in
																			typecheck_identifiers_with_type_new_scope tail
and typecheck_type_declaration decl = match decl with
								| TypeSpec(value, typename,linenum)-> let mytype = typecheck_type_name typename in let result= add_variable_to_current_scope (SymType(mytype)) value in ()
								| _-> type_checking_error ("type_dcl error")
								
let rec pretty_typecheck_expression exp =
								(* 	let rec typecheck_expressions exprlist = match exprlist with
									| [] -> ""
									| head::[] -> pretty_typecheck_expression head
									| head::tail -> ((pretty_typecheck_expression head)^", "^(typecheck_expressions tail) )in  *)
									match exp with 
												| OperandName(value,linenum)->  search_previous_scopes value !symbol_table  (*  value *)
												| AndAndOp(exp1,exp2,linenum)-> let exp_type1= pretty_typecheck_expression exp1 in 
																	   let exp_type2= pretty_typecheck_expression exp2 in 
																	   bool_typecheck exp_type1 exp_type2(* "( "^(pretty_typecheck_expression exp1)^" && "^(pretty_typecheck_expression exp2 )^" )" *)
												| OrOrOp(exp1,exp2,linenum)-> let exp_type1= pretty_typecheck_expression exp1 in 
																	   let exp_type2= pretty_typecheck_expression exp2 in 
																	   bool_typecheck exp_type1 exp_type2(* "( "^(pretty_typecheck_expression exp1)^" || "^(pretty_typecheck_expression exp2 )^" )" *)
												| EqualEqualCmp(exp1,exp2,linenum)-> let exp_type1= pretty_typecheck_expression exp1 in 
																	   let exp_type2= pretty_typecheck_expression exp2 in 
																	   comparable_typecheck exp_type1 exp_type2(* "( "^(pretty_typecheck_expression exp1)^" == "^(pretty_typecheck_expression exp2 )^" )" *)
												| NotEqualCmp(exp1,exp2,linenum)->let exp_type1= pretty_typecheck_expression exp1 in 
																	   	let exp_type2= pretty_typecheck_expression exp2 in 
																	   comparable_typecheck exp_type1 exp_type2(*  "( "^(pretty_typecheck_expression exp1)^" != "^(pretty_typecheck_expression exp2 )^" )" *)
												| LessThanCmp(exp1,exp2,linenum)-> let exp_type1= pretty_typecheck_expression exp1 in 
																	  		let exp_type2= pretty_typecheck_expression exp2 in 
																	 	    ordered_typecheck exp_type1 exp_type2(*  "( "^(pretty_typecheck_expression exp1)^" < "^(pretty_typecheck_expression exp2 )^" )" *)
												| GreaterThanCmp (exp1,exp2,linenum)-> let exp_type1= pretty_typecheck_expression exp1 in 
																	 		  let exp_type2= pretty_typecheck_expression exp2 in 
																	 		  ordered_typecheck exp_type1 exp_type2(* "( "^(pretty_typecheck_expression exp1)^" >"^(pretty_typecheck_expression exp2 )^" )" *)
												| LessThanOrEqualCmp(exp1,exp2,linenum)-> let exp_type1= pretty_typecheck_expression exp1 in 
																	  			 let exp_type2= pretty_typecheck_expression exp2 in 
																	  			 ordered_typecheck exp_type1 exp_type2(* "( "^(pretty_typecheck_expression exp1)^" <= "^(pretty_typecheck_expression exp2 )^" )" *)
												| GreaterThanOrEqualCmp(exp1,exp2,linenum)->let exp_type1= pretty_typecheck_expression exp1 in 
																	   let exp_type2= pretty_typecheck_expression exp2 in 
																	   ordered_typecheck exp_type1 exp_type2(*  "( "^(pretty_typecheck_expression exp1)^" >= "^(pretty_typecheck_expression exp2 )^" )" *)
												| AddOp(exp1,exp2,linenum)-> let exp_type1= pretty_typecheck_expression exp1 in 
																	   let exp_type2= pretty_typecheck_expression exp2 in 
																	   numeric_string_typecheck exp_type1 exp_type2
												 					 (* "( "^(pretty_typecheck_expression exp1)^" + "^(pretty_typecheck_expression exp2 )^" )" *)
												| MinusOp(exp1,exp2,linenum)-> let exp_type1= pretty_typecheck_expression exp1 in 
																	   let exp_type2= pretty_typecheck_expression exp2 in 
																	   numeric_typecheck exp_type1 exp_type2(* "( "^(pretty_typecheck_expression exp1)^" - "^(pretty_typecheck_expression exp2 )^" )" *)
												| OrOp (exp1,exp2,linenum)-> let exp_type1= pretty_typecheck_expression exp1 in 
																	   let exp_type2= pretty_typecheck_expression exp2 in 
																	   integer_typecheck exp_type1 exp_type2(* "( "^(pretty_typecheck_expression exp1)^" | "^(pretty_typecheck_expression exp2 )^" )" *)
												| CaretOp (exp1,exp2,linenum)-> let exp_type1= pretty_typecheck_expression exp1 in 
																	   let exp_type2= pretty_typecheck_expression exp2 in 
																	   integer_typecheck exp_type1 exp_type2(* "( "^(pretty_typecheck_expression exp1)^" ^ "^(pretty_typecheck_expression exp2 )^" )" *)
												| MulOp (exp1,exp2,linenum)-> let exp_type1= pretty_typecheck_expression exp1 in 
																	   let exp_type2= pretty_typecheck_expression exp2 in 
																	   numeric_typecheck exp_type1 exp_type2(* "( "^(pretty_typecheck_expression exp1)^" * "^(pretty_typecheck_expression exp2 )^" )" *)
												| DivOp (exp1,exp2,linenum)-> let exp_type1= pretty_typecheck_expression exp1 in 
																	   let exp_type2= pretty_typecheck_expression exp2 in 
																	   numeric_typecheck exp_type1 exp_type2(* "( "^(pretty_typecheck_expression exp1)^" / "^(pretty_typecheck_expression exp2 )^" )" *)
												| ModuloOp (exp1,exp2,linenum)-> let exp_type1= pretty_typecheck_expression exp1 in 
																	   let exp_type2= pretty_typecheck_expression exp2 in 
																	   numeric_typecheck exp_type1 exp_type2(* "( "^(pretty_typecheck_expression exp1)^" % "^(pretty_typecheck_expression exp2 )^" )" *)
												| SrOp (exp1,exp2,linenum)-> let exp_type1= pretty_typecheck_expression exp1 in 
																	   let exp_type2= pretty_typecheck_expression exp2 in 
																	   integer_typecheck exp_type1 exp_type2(* "( "^(pretty_typecheck_expression exp1)^" >> "^(pretty_typecheck_expression exp2 )^" )" *)
												| SlOp (exp1,exp2,linenum)-> let exp_type1= pretty_typecheck_expression exp1 in 
																	   let exp_type2= pretty_typecheck_expression exp2 in 
																	   integer_typecheck exp_type1 exp_type2(* "( "^(pretty_typecheck_expression exp1)^" << "^(pretty_typecheck_expression exp2 )^" )" *)
												| AndOp (exp1,exp2,linenum)-> let exp_type1= pretty_typecheck_expression exp1 in 
																	   let exp_type2= pretty_typecheck_expression exp2 in 
																	   integer_typecheck exp_type1 exp_type2(* "( "^(pretty_typecheck_expression exp1)^" & "^(pretty_typecheck_expression exp2 )^" )" *)
												| AndCaretOp (exp1,exp2,linenum)-> let exp_type1= pretty_typecheck_expression exp1 in 
																	   let exp_type2= pretty_typecheck_expression exp2 in 
																	   integer_typecheck exp_type1 exp_type2(* "( "^(pretty_typecheck_expression exp1)^" &^ "^(pretty_typecheck_expression exp2 )^" )" *)
												| OperandParenthesis (exp1,linenum)-> pretty_typecheck_expression exp1
						(*    NOT DONE*)		| Indexexpr(exp1,exp2,linenum)-> SymInt  (* "( "^(pretty_typecheck_expression exp1)^"["^(pretty_typecheck_expression exp2 )^"]"^")" *)
												| Unaryexpr(exp1,linenum) -> pretty_typecheck_expression exp1
												| Binaryexpr(exp1,linenum) ->  pretty_typecheck_expression exp1
						(*    NOT DONE*)		| FuncCallExpr(expr,exprs,linenum)-> SymInt (* "( "^(pretty_typecheck_expression expr)^"("^(typecheck_expressions exprs)^")"^")" *)
												| UnaryPlus(exp1,linenum) -> let exp_type= pretty_typecheck_expression exp1 in 
																	 (match exp_type with 
																	 | SymInt-> SymInt
																	 | SymFloat64-> SymFloat64
																	 | SymRune -> SymRune
																	 | _ -> type_checking_error "Unary Plus should be done on a numeric value"
																		)(* "( +"^(pretty_typecheck_expression exp1)^" )" *)
												| UnaryMinus(exp1,linenum) -> let exp_type= pretty_typecheck_expression exp1 in 
																	 (match exp_type with 
																	 | SymInt-> SymInt
																	 | SymFloat64-> SymFloat64
																	 | SymRune -> SymRune
																	 | _ -> type_checking_error "Unary Negation should be done on a numeric value"
																		)(*  "( -"^(pretty_typecheck_expression exp1)^" )" *)
												| UnaryNot(exp1,linenum) -> let exp_type= pretty_typecheck_expression exp1 in 
																	 (match exp_type with 
																	 | SymBool-> SymBool
																	 | _ -> type_checking_error "Unary Logical Negation should be done on a bool value"
																		)(* "( !"^(pretty_typecheck_expression exp1)^" )" *)
												| UnaryCaret(exp1,linenum) -> let exp_type= pretty_typecheck_expression exp1 in 
																	 (match exp_type with 
																	 | SymInt-> SymInt
																	 | SymRune -> SymRune
																	 | _ -> type_checking_error "Unary Bitwise should be done on an integer value"
																		)(* "( ^"^(pretty_typecheck_expression exp1)^" )" *)
												| Value(value,linenum)-> (typecheck_literal value) 
						(*    NOT DONE*)		| Selectorexpr(exp1,Identifier(iden,linenum1),linenum2)->SymInt (* "("^(pretty_typecheck_expression exp1)^"."^iden^")" *)
						(*    NOT DONE*)		| TypeCastExpr (typename,exp1,linenum) -> SymInt(* "( "^(typecheck_type_name typename)^"("^(pretty_typecheck_expression exp1)^"))" *)
						(*    NOT DONE*)		| Appendexpr (Identifier(iden,linenum1),exp1,linenum2)->SymInt (* "( append("^iden^", "^(pretty_typecheck_expression exp1)^"))" *)
												| _-> type_checking_error ("expression error") 
(*
let rec typecheck_expressions exprlist = match exprlist with
									| [] -> ""
									| head::[] -> pretty_typecheck_expression head
									| head::tail -> (pretty_typecheck_expression head)^", "^(typecheck_expressions tail) *)

 and typecheck_variable_declaration decl= match decl with
									| VarSpecWithType (iden_list,typename,exprs,linenum) -> let mytype = typecheck_type_name typename in let result=List.map (add_variable_to_current_scope mytype) iden_list in ()
																					(* ( match exprs with
																							| [] -> "var "^(typecheck_identifiers iden_list)^" "^(typecheck_type_name typename)^";\n"
																							| head::tail -> "var "^(typecheck_identifiers iden_list)^" "^(typecheck_type_name typename)^" = "^(typecheck_expressions exprs)^";\n"
																					) *)
									| VarSpecWithoutType  (iden_list,exprs,linenum) -> ()
																						(* ( match exprs with
																							| [] -> "var "^(typecheck_identifiers iden_list)^";\n"
																							| head::tail -> "var "^(typecheck_identifiers iden_list)^" = "^(typecheck_expressions exprs)^";\n") *)
									| _ -> ast_error ("var_dcl error")
 
let rec  typecheck_stmts stmts = match stmts with
									| [] -> ()
									| head::tail -> let _=typecheck_stmt head in (typecheck_stmts tail)
and typecheck_stmt stmt = match stmt with
				    | Declaration(dcl,linenum)-> let _=typecheck_declaration in ()
	(*NOT DONE*)	| Return(rt_stmt,linenum)->() (* typecheck_return_stmt rt_stmt (*DONE*) *)
				    | Break(linenum) -> ()(* "break "  *)
				    | Continue(linenum) -> ()(* "continue " *)
				    | Block(stmt_list,linenum)-> let _= start_scope() in 
				    					 let _= typecheck_stmts stmt_list in
				    					 end_scope()
	(*NOT DONE*)    | Conditional(conditional,linenum)->() (* typecheck_conditional conditional (*DONE*) *)
	(*NOT DONE*)	| Switch(switch_clause, switch_expr, switch_case_stmts,linenum)->() (* "switch "^(typecheck_switch_clause switch_clause)^" "^(typecheck_switch_expression switch_expr)^" {\n"^(typecheck_switch_case_stmt switch_case_stmts)^"}" *)
				    | For(for_stmt,linenum)-> typecheck_for_stmt for_stmt (*DONE*) 
				    | Simple(simple,linenum)-> typecheck_simple_stmt simple 
				    | Print(exprs,linenum)-> let expr_list_types= List.map pretty_typecheck_expression exprs in
				    				  if (is_exprs_of_base_type expr_list_types) then ()
				    				  else type_checking_error "print only accepts base types" 
				    				  (* "print ("^(typecheck_expressions exprs)^") " (*DONE*) *)
				    | Println(exprs,linenum)-> let expr_list_types= List.map pretty_typecheck_expression exprs in
				    				  if (is_exprs_of_base_type expr_list_types) then ()
				    				  else type_checking_error "print only accepts base types" 
				    				  (* "println ("^(typecheck_expressions exprs)^") " (*DONE*) *)
(* and typecheck_return_stmt stmt= match stmt with
							| Empty -> "return "
							| ReturnStatement(expr)-> "return "^(pretty_typecheck_expression expr)
and typecheck_conditional cond = match cond with 
							| IfStmt(if_stmt)-> typecheck_if_stmt if_stmt
							| ElseStmt(else_stmt)-> typecheck_else_stmt else_stmt
and typecheck_if_stmt if_stmt = match if_stmt with
							| IfInit(if_init, condition, stmts)-> "if "^(typecheck_if_init if_init)^(typecheck_condition condition)^"{\n"^(typecheck_stmts stmts)^"}"
and typecheck_if_init if_init = match if_init with
							| Empty -> ""
							| IfInitSimple(simplestmt) -> (typecheck_simple_stmt simplestmt)^";" *)
and typecheck_simple_stmt stmt = match stmt with 
							| Empty -> ()
							| SimpleExpression(expr,linenum)-> let _=pretty_typecheck_expression expr in ()
				(*NOT DONE*)| IncDec(incdec,linenum)-> ()(* typecheck_inc_dec_stmt incdec  *)
							| Assignment(assignment_stmt,linenum)-> typecheck_assignment_stmt assignment_stmt 
				(*NOT DONE*)| ShortVardecl(short_var_decl,linenum)->() (* typecheck_short_var_decl short_var_decl *)
and  typecheck_condition cond = match cond with 
							| ConditionExpression (expr,linenum)->let cond_type= pretty_typecheck_expression expr in 
														   if cond_type == SymBool then ()
														   else type_checking_error "condition has to be bool" 
							| Empty -> ()
(* and typecheck_else_stmt stmt =  match stmt with 
							| ElseSingle(if_stmt,stmts)-> (typecheck_if_stmt if_stmt)^" else {\n "^(typecheck_stmts stmts)^"}"
						    | ElseIFMultiple(if_stmt,else_stmt)->(typecheck_if_stmt if_stmt)^" else "^(typecheck_else_stmt else_stmt)
						    | ElseIFSingle(if_stmt1,if_stmt2)->(typecheck_if_stmt if_stmt1)^" else "^(typecheck_if_stmt if_stmt2) *)
and typecheck_for_stmt stmt = match stmt with 
				    | Forstmt(stmts,linenum)-> let _= start_scope() in 
				    				   let _= typecheck_stmts stmts in 
				    					end_scope() (* "for {\n"^(typecheck_stmts stmts)^"}" *)
				    | ForCondition(condition, stmts,linenum)-> let _= typecheck_condition condition in 
				    								   let _= start_scope() in 
								    				   let _= typecheck_stmts stmts in 
								    					end_scope()
				    							    	(* "for "^(typecheck_condition condition)^"{\n"^(typecheck_stmts stmts)^"}" *)
				    | ForClause (for_clause, stmts,linenum)-> let _ = typecheck_clause for_clause in 
				    								  let _= start_scope() in 
								    				  let _= typecheck_stmts stmts in 
								    				  let _= end_scope() in 
								    				  end_scope()(* "for "^(typecheck_clause for_clause)^"{\n"^(typecheck_stmts stmts)^"}" *)
and typecheck_clause clause= match clause with (*NEEDS REVISION*)
						 | ForClauseCond(simple1,condition,simple2,linenum)-> let _= start_scope() in
						 											  let _= typecheck_simple_stmt simple1 in 
						 											  let _= typecheck_condition condition in
						 											  typecheck_simple_stmt simple2
						 (* " "^(typecheck_simple_stmt simple1)^"; "^(typecheck_condition condition)^"; "^(typecheck_simple_stmt simple2)^" " *)


(* and typecheck_switch_clause clause = match clause with
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
								| SwitchCasestmt(switch_case_clauses)->(typecheck_list(List.map typecheck_switch_case_clause switch_case_clauses))						 *)
(* and typecheck_inc_dec_stmt stmt = match stmt with 
						 | Increment(expr)->(pretty_typecheck_expression expr)^"++"
   						 | Decrement(expr)->(pretty_typecheck_expression expr)^"--" *)

and type_check_assignment_exprs exprs1 exprs2 linenum= match exprs1,exprs2 with
											| [] ,[] -> () 
											| head1::tail1, head2::tail2 -> let lhsexpr_type= pretty_typecheck_expression head1 in
																			let rhsexprs_type= pretty_typecheck_expression head2 in 
																			if lhsexpr_type==rhsexprs_type then type_check_assignment_exprs tail1 tail2 linenum
																			else type_checking_error ("assignment should have the same types linenum:="^(Printf.sprintf "%i" linenum))
and type_check_assignment_op exp1 exp2 assign_op = match assign_op with 
													    | "+="-> let exp_type1= pretty_typecheck_expression exp1 in 
															     let exp_type2= pretty_typecheck_expression exp2 in 
																 numeric_string_typecheck exp_type1 exp_type2
													    | "-="-> let exp_type1= pretty_typecheck_expression exp1 in 
															     let exp_type2= pretty_typecheck_expression exp2 in 
																 numeric_typecheck exp_type1 exp_type2
													    | "|="-> let exp_type1= pretty_typecheck_expression exp1 in 
																 let exp_type2= pretty_typecheck_expression exp2 in 
															     integer_typecheck exp_type1 exp_type2
													    | "^="-> let exp_type1= pretty_typecheck_expression exp1 in 
															     let exp_type2= pretty_typecheck_expression exp2 in 
																 integer_typecheck exp_type1 exp_type2
													    | "*="-> let exp_type1= pretty_typecheck_expression exp1 in 
															     let exp_type2= pretty_typecheck_expression exp2 in 
																 numeric_typecheck exp_type1 exp_type2
													    | "/="-> let exp_type1= pretty_typecheck_expression exp1 in 
															     let exp_type2= pretty_typecheck_expression exp2 in 
																 numeric_typecheck exp_type1 exp_type2
													    | "%="-> let exp_type1= pretty_typecheck_expression exp1 in 
															     let exp_type2= pretty_typecheck_expression exp2 in 
																 numeric_typecheck exp_type1 exp_type2
													    | ">>="-> let exp_type1= pretty_typecheck_expression exp1 in 
																  let exp_type2= pretty_typecheck_expression exp2 in 
																  integer_typecheck exp_type1 exp_type2
													    | "<<="-> let exp_type1= pretty_typecheck_expression exp1 in 
																  let exp_type2= pretty_typecheck_expression exp2 in 
																  integer_typecheck exp_type1 exp_type2
													    | "&="-> let exp_type1= pretty_typecheck_expression exp1 in 
															     let exp_type2= pretty_typecheck_expression exp2 in 
																 integer_typecheck exp_type1 exp_type2
													    | "&^="-> let exp_type1= pretty_typecheck_expression exp1 in 
																  let exp_type2= pretty_typecheck_expression exp2 in 
																  integer_typecheck exp_type1 exp_type2

and typecheck_assignment_stmt stmt = match stmt with 
						    | AssignmentBare(exprs1,exprs2,linenum)-> type_check_assignment_exprs exprs1 exprs2 linenum
   						    | AssignmentOp(exprs1, assign_op, exprs2,linenum)-> let _=type_check_assignment_op exprs1 exprs2 assign_op in ()


(* and typecheck_short_var_decl dcl = match dcl with
							| ShortVarDecl(idens, exprs)-> (typecheck_identifiers idens)^" := "^(typecheck_expressions exprs)


 *)
and typecheck_declaration decl = match decl with 
								| TypeDcl([],linenum)->  ()
								| TypeDcl(value,linenum)-> let result= (List.map typecheck_type_declaration value) in ()(* write_message(typecheck_list(List.map typecheck_type_declaration value)) *)
								| VarDcl([],linenum)->  ()
								| VarDcl(value,linenum)-> let result= (List.map typecheck_variable_declaration value) in ()
								| Function(func_name,signature,stmts,linenum)->let result=  typecheck_function_declaration func_name signature stmts in ()
								| _ -> ()

and typecheck_signature_return_type return_type = match return_type with
	| FuncReturnType(return_type_i,linenum) -> typecheck_type_name return_type_i  
	| Empty -> Void


and typecheck_signature signature func_name= match signature with
	FuncSig(FuncParams(func_params,linenum1), return_type,linenum2) -> let mytype=typecheck_signature_return_type return_type in 
													let params= typecheck_identifiers_with_type func_params in  
													let _= add_variable_to_current_scope (SymFunc(mytype,params)) (Identifier(func_name,linenum1)) in 
													let _= start_scope () in 
													let _= typecheck_identifiers_with_type_new_scope func_params in start_scope()
													 

and typecheck_function_declaration func_name signature stmts = let _= typecheck_signature signature func_name in 
															   let _=typecheck_stmts stmts  in 
															   let _= end_scope() in 
															   end_scope()

let type_check_program program filename= 
							let _= set_file filename in let _=start_scope () in
								 (match program with
									  | Prog(packagename,dcllist)->
									          (* let _=write_message ("package "^(packagename)^" ;\n") in  *)
											  let a= (List.map typecheck_declaration dcllist)in print_stack symbol_table) 


