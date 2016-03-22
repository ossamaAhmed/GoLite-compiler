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
								    symbol_table_error ("variable is not defined in current_scope")

let rec search_previous_scopes x table= match table with (*called with !symbol_table*)
							| []-> symbol_table_error ("variable is not defined in current and previous scopes")
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
let is_basetype_numeric_typecheck a= match a with 
						| SymInt -> true
						| SymFloat64-> true
						| SymRune-> true
						| SymBool-> true
						| _ -> false

let rec is_exprs_of_base_type expr_list_types= match expr_list_types with 
				    				 	| []-> true
				    				 	| (_,head)::tail -> if (is_basetype_typecheck head) then is_exprs_of_base_type tail
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


let extract_type_from_expr_tuple a = match a with 
								| (_,x)->x

let extract_node_from_expr_tuple a = match a with 
								| (x,_)->x

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

let rec search_struct_field_list iden field_list linenum= match field_list with 
												| []-> type_checking_error ("Identifier not found in struct at linenum:="^(Printf.sprintf "%i" linenum))
												| (str, symType)::tail-> if str=iden then symType else  search_struct_field_list iden tail linenum

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
									| [] -> []
									| TypeSpec(value,return_type,linenum)::tail -> let mytype = typecheck_type_name return_type in 
																		    let _= add_variable_to_current_scope mytype value in
																			TypeSpec(value,return_type,linenum)::(typecheck_identifiers_with_type_new_scope tail)
and typecheck_type_declaration decl = match decl with
								| TypeSpec(value, typename,linenum)-> let mytype = typecheck_type_name typename in let result= add_variable_to_current_scope (SymType(mytype)) value in TypeSpec(value, typename,linenum)
								| _-> type_checking_error ("type_dcl error")


(*DONE*)

let rec check_func_call_args exprs args_list linenum= if List.length exprs != List.length args_list then
           										 type_checking_error ("function call and argument list length mismatch linenum:="^(Printf.sprintf "%i" linenum))
           									 else
											(match exprs, args_list with 
											| [],[]-> []
											| head1::tail1, (str,symType)::tail2-> let exp_type= pretty_typecheck_expression head1 in 
																		  		 let arg_type = symType in 
																		  		 if ((extract_type_from_expr_tuple exp_type)==arg_type) then (extract_node_from_expr_tuple exp_type)::(check_func_call_args tail1 tail2 linenum)
																		  		 else type_checking_error ("function call and argument list type mismatch linenum:="^(Printf.sprintf "%i" linenum)))



(*DONE*)
							
and pretty_typecheck_expression exp =
									match exp with 
												| OperandName(value,linenum,ast_type)-> let mytype= search_previous_scopes value !symbol_table in 
																						(OperandName(value,linenum,mytype),mytype)  (*  value *)
												| AndAndOp(exp1,exp2,linenum,ast_type)-> let exp_type1= extract_type_from_expr_tuple(pretty_typecheck_expression exp1) in 
																	   					 let exp_type2= extract_type_from_expr_tuple(pretty_typecheck_expression exp2) in 
																	   					 let mytype= bool_typecheck exp_type1 exp_type2 in 
																	   					 (AndAndOp(exp1,exp2,linenum,mytype), mytype)
												| OrOrOp(exp1,exp2,linenum,ast_type)-> let exp_type1= extract_type_from_expr_tuple(pretty_typecheck_expression exp1) in 
																	  				   let exp_type2= extract_type_from_expr_tuple(pretty_typecheck_expression exp2) in 
																	   				   let mytype= bool_typecheck exp_type1 exp_type2 in 
																	   				   (OrOrOp(exp1,exp2,linenum,mytype),mytype)
												| EqualEqualCmp(exp1,exp2,linenum,ast_type)-> let exp_type1= extract_type_from_expr_tuple(pretty_typecheck_expression exp1) in 
																	 						  let exp_type2= extract_type_from_expr_tuple(pretty_typecheck_expression exp2) in 
																	 						  let mytype= comparable_typecheck exp_type1 exp_type2 in 
																	 						  (EqualEqualCmp(exp1,exp2,linenum,mytype),mytype)
												| NotEqualCmp(exp1,exp2,linenum,ast_type)->let exp_type1= extract_type_from_expr_tuple(pretty_typecheck_expression exp1) in 
																	   					   let exp_type2= extract_type_from_expr_tuple(pretty_typecheck_expression exp2) in 
																	   					   let mytype= comparable_typecheck exp_type1 exp_type2 in 
																	   					   (NotEqualCmp(exp1,exp2,linenum,mytype),mytype)


												| LessThanCmp(exp1,exp2,linenum,ast_type)-> let exp_type1= extract_type_from_expr_tuple(pretty_typecheck_expression exp1) in 
																	  						let exp_type2= extract_type_from_expr_tuple(pretty_typecheck_expression exp2) in 
																	 	    				let mytype= ordered_typecheck exp_type1 exp_type2 in 
																	 	    				(LessThanCmp(exp1,exp2,linenum,mytype),mytype)
												| GreaterThanCmp (exp1,exp2,linenum,ast_type)-> let exp_type1= extract_type_from_expr_tuple(pretty_typecheck_expression exp1) in 
																	 		 					let exp_type2= extract_type_from_expr_tuple(pretty_typecheck_expression exp2) in 
																	 		 					let mytype= ordered_typecheck exp_type1 exp_type2 in 
																	 		 					(GreaterThanCmp (exp1,exp2,linenum,mytype),mytype)
												| LessThanOrEqualCmp(exp1,exp2,linenum,ast_type)-> let exp_type1= extract_type_from_expr_tuple(pretty_typecheck_expression exp1) in 
																	  							   let exp_type2= extract_type_from_expr_tuple(pretty_typecheck_expression exp2) in 
																	  							   let mytype=  ordered_typecheck exp_type1 exp_type2 in 
																	  							   (LessThanOrEqualCmp(exp1,exp2,linenum,mytype),mytype)
												| GreaterThanOrEqualCmp(exp1,exp2,linenum,ast_type)->let exp_type1= extract_type_from_expr_tuple(pretty_typecheck_expression exp1) in 
																	  								 let exp_type2= extract_type_from_expr_tuple(pretty_typecheck_expression exp2) in 
																	   								 let mytype= ordered_typecheck exp_type1 exp_type2 in 
																	   								 (GreaterThanOrEqualCmp(exp1,exp2,linenum,mytype),mytype)
												| AddOp(exp1,exp2,linenum,ast_type)-> let exp_type1= extract_type_from_expr_tuple(pretty_typecheck_expression exp1) in 
																	  				  let exp_type2= extract_type_from_expr_tuple(pretty_typecheck_expression exp2) in 
																	  				  let mytype= numeric_string_typecheck exp_type1 exp_type2 in 
																	  				  let exp_type1_node= extract_node_from_expr_tuple(pretty_typecheck_expression exp1) in 
																	  				  let exp_type2_node= extract_node_from_expr_tuple(pretty_typecheck_expression exp2) in 
															
																	  				  (AddOp(exp_type1_node,exp_type2_node,linenum,mytype), mytype)
												 					 
												| MinusOp(exp1,exp2,linenum,ast_type)-> let exp_type1= extract_type_from_expr_tuple(pretty_typecheck_expression exp1) in 
																	  					 let exp_type2= extract_type_from_expr_tuple(pretty_typecheck_expression exp2) in 
																	  					let mytype= numeric_typecheck exp_type1 exp_type2 in 
																	  					(MinusOp(exp1,exp2,linenum,mytype),mytype)
												| OrOp (exp1,exp2,linenum,ast_type)-> let exp_type1= extract_type_from_expr_tuple(pretty_typecheck_expression exp1) in 
																	 				  let exp_type2= extract_type_from_expr_tuple(pretty_typecheck_expression exp2) in 
																	  				  let mytype= integer_typecheck exp_type1 exp_type2 in 
																	  				  (OrOp (exp1,exp2,linenum,mytype),mytype)

												| CaretOp (exp1,exp2,linenum,ast_type)-> let exp_type1= extract_type_from_expr_tuple(pretty_typecheck_expression exp1) in 
																	  					 let exp_type2= extract_type_from_expr_tuple(pretty_typecheck_expression exp2) in 
																	  					let mytype= integer_typecheck exp_type1 exp_type2 in 
																	  					(CaretOp (exp1,exp2,linenum,mytype),mytype)

												| MulOp (exp1,exp2,linenum,ast_type)-> let exp_type1= extract_type_from_expr_tuple(pretty_typecheck_expression exp1) in 
																					   let exp_type2= extract_type_from_expr_tuple(pretty_typecheck_expression exp2) in 
																	  				   let mytype= numeric_typecheck exp_type1 exp_type2 in 
																	  				   (MulOp (exp1,exp2,linenum,mytype),mytype)
												| DivOp (exp1,exp2,linenum,ast_type)-> let exp_type1= extract_type_from_expr_tuple(pretty_typecheck_expression exp1) in 
																					   let exp_type2= extract_type_from_expr_tuple(pretty_typecheck_expression exp2) in 
																	 				   let mytype=  numeric_typecheck exp_type1 exp_type2 in 
																	 					(DivOp (exp1,exp2,linenum,mytype),mytype)
												| ModuloOp (exp1,exp2,linenum,ast_type)-> let exp_type1= extract_type_from_expr_tuple(pretty_typecheck_expression exp1) in 
																	 					  let exp_type2= extract_type_from_expr_tuple(pretty_typecheck_expression exp2) in 
																	  					  let mytype= numeric_typecheck exp_type1 exp_type2 in 
																	  					  (ModuloOp (exp1,exp2,linenum,mytype), mytype)
												| SrOp (exp1,exp2,linenum,ast_type)-> let exp_type1= extract_type_from_expr_tuple(pretty_typecheck_expression exp1) in 
																				  	  let exp_type2= extract_type_from_expr_tuple(pretty_typecheck_expression exp2) in 
																	  				  let mytype= integer_typecheck exp_type1 exp_type2 in 
																	  				  (SrOp (exp1,exp2,linenum,mytype),mytype)
												| SlOp (exp1,exp2,linenum,ast_type)-> let exp_type1= extract_type_from_expr_tuple(pretty_typecheck_expression exp1) in 
																	 				  let exp_type2= extract_type_from_expr_tuple(pretty_typecheck_expression exp2) in 
																					  let mytype=   integer_typecheck exp_type1 exp_type2 in 
																					  (SlOp (exp1,exp2,linenum,mytype),mytype )
												| AndOp (exp1,exp2,linenum,ast_type)-> let exp_type1= extract_type_from_expr_tuple(pretty_typecheck_expression exp1) in 
																					   let exp_type2= extract_type_from_expr_tuple(pretty_typecheck_expression exp2) in 
																	  					let mytype= integer_typecheck exp_type1 exp_type2 in 
																	  					(AndOp (exp1,exp2,linenum,mytype),mytype)
												| AndCaretOp (exp1,exp2,linenum,ast_type)-> let exp_type1= extract_type_from_expr_tuple(pretty_typecheck_expression exp1) in 
																	 						 let exp_type2= extract_type_from_expr_tuple(pretty_typecheck_expression exp2) in 
																	  						let mytype= integer_typecheck exp_type1 exp_type2 in 
																	  						(AndCaretOp (exp1,exp2,linenum,mytype),mytype)
												| OperandParenthesis (exp1,linenum,ast_type)-> let mytype= pretty_typecheck_expression exp1 in
																							   let mytype_name=  extract_type_from_expr_tuple mytype in
																							   let mytype_node= extract_node_from_expr_tuple mytype in 
																							   (OperandParenthesis (mytype_node,linenum,mytype_name),mytype_name)

												| Indexexpr(exp1,exp2,linenum,ast_type)-> let index_name_type= extract_type_from_expr_tuple(pretty_typecheck_expression exp1) in 
																						  let indexing= extract_type_from_expr_tuple(pretty_typecheck_expression exp2) in 
																						  if indexing!= SymInt then type_checking_error ("indexing should have an int expression linenum:="^(Printf.sprintf "%i" linenum))
																						  else (match index_name_type with 
																						  	| SymArray(symtype)-> (Indexexpr(exp1,exp2,linenum,symtype),symtype)
																						  	| SymSlice(symtype)-> (Indexexpr(exp1,exp2,linenum,symtype),symtype)
																						  	| _-> type_checking_error ("indexing should be done on an array or a slice linenum:="^(Printf.sprintf "%i" linenum))
																						  )
												| Unaryexpr(exp1,linenum,ast_type) -> let mytype= extract_type_from_expr_tuple(pretty_typecheck_expression exp1) in 
																					 (Unaryexpr(exp1,linenum,mytype),mytype)
												| Binaryexpr(exp1,linenum,ast_type) ->  let mytype= pretty_typecheck_expression exp1 in 
																						let mytype_name= extract_type_from_expr_tuple mytype in 
																						let mytype_node = extract_node_from_expr_tuple mytype in
																					 	(Binaryexpr(mytype_node,linenum,mytype_name),mytype_name)
												| FuncCallExpr(expr,exprs,linenum,ast_type)-> let exp_type= extract_type_from_expr_tuple(pretty_typecheck_expression expr) in
																							  ( match exp_type, expr,exprs with 
																							  	| SymFunc(symType,argslist),_,_-> let _= (check_func_call_args exprs argslist linenum) in (FuncCallExpr(expr,exprs,linenum,symType) ,symType)
																							  	| _ ,OperandName(iden,l,t),head::[] -> let mytype = extract_type_from_expr_tuple(pretty_typecheck_expression (TypeCastExpr(Definedtype(Identifier(iden,linenum),linenum),head,linenum,ast_type))) in 
																							  											(FuncCallExpr(expr,exprs,linenum,mytype),mytype )
																							  	| _ ,OperandName(iden,l,t),head::tail-> type_checking_error ("type casting expression only accepts one argument linenum:="^(Printf.sprintf "%i" linenum))
																							  ) 
												| UnaryPlus(exp1,linenum,ast_type) -> let exp_type= extract_type_from_expr_tuple(pretty_typecheck_expression exp1) in 
																	 (match exp_type with 
																	 | SymInt-> ( UnaryPlus(exp1,linenum,SymInt),SymInt)
																	 | SymFloat64-> ( UnaryPlus(exp1,linenum,SymFloat64),SymFloat64)
																	 | SymRune ->( UnaryPlus(exp1,linenum,SymRune),SymRune) 
																	 | _ -> type_checking_error "Unary Plus should be done on a numeric value"
																		)(* "( +"^(pretty_typecheck_expression exp1)^" )" *)
												| UnaryMinus(exp1,linenum,ast_type) -> let exp_type= extract_type_from_expr_tuple(pretty_typecheck_expression exp1) in 
																	 (match exp_type with 
																	 | SymInt-> (UnaryMinus(exp1,linenum,exp_type),exp_type)
																	 | SymFloat64-> (UnaryMinus(exp1,linenum,exp_type),exp_type)
																	 | SymRune -> (UnaryMinus(exp1,linenum,exp_type),exp_type)
																	 | _ -> type_checking_error "Unary Negation should be done on a numeric value"
																		)(*  "( -"^(pretty_typecheck_expression exp1)^" )" *)
												| UnaryNot(exp1,linenum,ast_type) -> let exp_type= extract_type_from_expr_tuple(pretty_typecheck_expression exp1) in 
																	 (match exp_type with 
																	 | SymBool-> (UnaryNot(exp1,linenum,exp_type),exp_type)
																	 | _ -> type_checking_error "Unary Logical Negation should be done on a bool value"
																		)(* "( !"^(pretty_typecheck_expression exp1)^" )" *)
												| UnaryCaret(exp1,linenum,ast_type) -> let exp_type= extract_type_from_expr_tuple(pretty_typecheck_expression exp1) in 
																	 (match exp_type with 
																	 | SymInt-> (UnaryCaret(exp1,linenum,exp_type),exp_type)
																	 | SymRune -> (UnaryCaret(exp1,linenum,exp_type),exp_type)
																	 | _ -> type_checking_error "Unary Bitwise should be done on an integer value"
																		)(* "( ^"^(pretty_typecheck_expression exp1)^" )" *)
												| Value(value,linenum,ast_type)-> let mytype= (typecheck_literal value) in 
																				(Value(value,linenum,mytype),mytype)
												| Selectorexpr(exp1,Identifier(iden,linenum1),linenum2,ast_type)-> let exp1_type= extract_type_from_expr_tuple(pretty_typecheck_expression exp1) in 
																												   ( match exp1_type with 
																												   	| SymStruct(field_list)-> let mytype= search_struct_field_list iden field_list linenum1 in 
																												   							  (Selectorexpr(exp1,Identifier(iden,linenum1),linenum2,mytype),mytype)
																												   	| _-> type_checking_error ("selector operator is only allowed on structs linenum:="^(Printf.sprintf "%i" linenum1))
																												   )
												| TypeCastExpr (typename,exp1,linenum,ast_type) -> let exp_type= extract_type_from_expr_tuple(pretty_typecheck_expression exp1) in 
																								    let mytype = typecheck_type_name typename in
																								    if (is_basetype_numeric_typecheck exp_type) && (is_basetype_numeric_typecheck mytype) then (TypeCastExpr (typename,exp1,linenum,mytype), mytype)
																								    else type_checking_error ("type casting is only allowed on numeric base types linenum:="^(Printf.sprintf "%i" linenum))

												| Appendexpr (Identifier(iden,linenum1),exp1,linenum2,ast_type)-> let iden_type_check= search_previous_scopes iden !symbol_table in 
																												  let exp_type= extract_type_from_expr_tuple(pretty_typecheck_expression exp1) in 
																												  (match iden_type_check with 
																												  | SymSlice(symtype)-> if exp_type!=symtype then type_checking_error ("expression inside append should have the same type as the slice linenum:="^(Printf.sprintf "%i" linenum2)) else ( Appendexpr (Identifier(iden,linenum1),exp1,linenum2,symtype),symtype)
																						  					      | _-> type_checking_error ("append expression done on slice type only linenum:="^(Printf.sprintf "%i" linenum2)) )(* "( append("^iden^", "^(pretty_typecheck_expression exp1)^"))" *)
												| _-> type_checking_error ("expression error") 


(*DONE*)

and typecheck_var_decl_without_type idenlist exprs linenum= match idenlist,exprs with 
															| [],[]-> []
															| head1::tail1, head2::tail2-> let exp_type=pretty_typecheck_expression head2 in 
																						   let _= add_variable_to_current_scope (extract_type_from_expr_tuple exp_type) head1 in 
																						   (extract_node_from_expr_tuple exp_type)::(typecheck_var_decl_without_type tail1 tail2 linenum)

(*DONE*)

and typecheck_exprs_of_type exprs typename linenum= match exprs with
										| [] -> [] 
										| head::tail -> let head_type= pretty_typecheck_expression head in 
														if (extract_type_from_expr_tuple head_type)==typename then (extract_node_from_expr_tuple head_type)::(typecheck_exprs_of_type tail typename linenum)
														else type_checking_error ("expressions have to be the same as variable declaration at linenum:="^(Printf.sprintf "%i" linenum))

(*DONE*)
and typecheck_variable_declaration decl= match decl with
									| VarSpecWithType (iden_list,typename,exprs,linenum) -> let mytype = typecheck_type_name typename in 
																							let result= typecheck_exprs_of_type exprs mytype linenum in   
																						    let _=List.map (add_variable_to_current_scope mytype) iden_list in VarSpecWithType (iden_list,typename,result,linenum)
																							 

									| VarSpecWithoutType  (iden_list,exprs,linenum) -> let result= typecheck_var_decl_without_type iden_list exprs linenum in VarSpecWithoutType(iden_list,result,linenum)
									| _ -> ast_error ("var_dcl error")
 

(*DONE*)
let rec  typecheck_stmts stmts = match stmts with
									| [] -> []
									| head::tail -> let head_result= (typecheck_stmt head) in 
													head_result::(typecheck_stmts tail)

(*DONE*)
and typecheck_stmt stmt = match stmt with
				    | Declaration(dcl,linenum)-> let _=typecheck_declaration dcl in stmt
	(*NOT DONE*)	| Return(rt_stmt,linenum)->type_checking_error ("return stmt not yet implemented linenum:="^(Printf.sprintf "%i" linenum)) (* typecheck_return_stmt rt_stmt (*DONE*) *)
				    | Break(linenum) -> stmt(* "break "  *)
				    | Continue(linenum) -> stmt(* "continue " *)
				    | Block(stmt_list,linenum)-> let _= start_scope() in 
				    					 		 let result= typecheck_stmts stmt_list in
				    							 let _= end_scope() in Block(result,linenum)
				    | Conditional(conditional,linenum)->let result= typecheck_conditional conditional in Conditional(result,linenum)
	(*NOT DONE*)	| Switch(switch_clause, switch_expr, switch_case_stmts,linenum)->type_checking_error ("switch stmt not yet implemented linenum:="^(Printf.sprintf "%i" linenum)) (* "switch "^(typecheck_switch_clause switch_clause)^" "^(typecheck_switch_expression switch_expr)^" {\n"^(typecheck_switch_case_stmt switch_case_stmts)^"}" *)
				    | For(for_stmt,linenum)-> let result= typecheck_for_stmt for_stmt in For(result,linenum) (*DONE*) 
				    | Simple(simple,linenum)-> let result= typecheck_simple_stmt simple in Simple(result,linenum)
				    | Print(exprs,linenum)-> let expr_list_types= List.map pretty_typecheck_expression exprs in
				    				  if (is_exprs_of_base_type expr_list_types) then Print((List.map extract_node_from_expr_tuple expr_list_types),linenum)
				    				  else type_checking_error ("print only accepts base types linenum:="^(Printf.sprintf "%i" linenum)) 
				    				  (* "print ("^(typecheck_expressions exprs)^") " (*DONE*) *)
				    | Println(exprs,linenum)-> let expr_list_types= List.map pretty_typecheck_expression exprs in
				    				  if (is_exprs_of_base_type expr_list_types) then Println((List.map extract_node_from_expr_tuple expr_list_types),linenum)
				    				  else type_checking_error ("print only accepts base types linenum:="^(Printf.sprintf "%i" linenum))
				    				  (* "println ("^(typecheck_expressions exprs)^") " (*DONE*) *)
(* and typecheck_return_stmt stmt= match stmt with
							| Empty -> "return "
							| ReturnStatement(expr)-> "return "^(pretty_typecheck_expression expr) *)
and typecheck_conditional cond = match cond with 
							| IfStmt(if_stmt,linenum)-> let result= typecheck_if_stmt if_stmt 
														in let _= end_scope() in 
														IfStmt(result,linenum)
							| ElseStmt(else_stmt,linenum)-> let result= typecheck_else_stmt else_stmt 
															in let _= end_scope() in 
															ElseStmt(result,linenum)
and typecheck_if_stmt if_stmt = match if_stmt with
							| IfInit(if_init, condition, stmts,linenum)-> let _= start_scope() in 
																  let result1= typecheck_if_init if_init in 
																  let result2= typecheck_condition condition in 
																  let _ = start_scope() in 
																  let result3= typecheck_stmts stmts in 
																  let _= end_scope() in 
																  IfInit(result1, result2, result3,linenum)
																
and typecheck_if_init if_init = match if_init with
							| IfInitSimple(simplestmt,linenum) -> let result= typecheck_simple_stmt simplestmt in IfInitSimple(result,linenum)
							| Empty -> Empty


and typecheck_simple_stmt stmt = match stmt with 
							| Empty -> Empty
							| SimpleExpression(expr,linenum)-> let result=pretty_typecheck_expression expr in SimpleExpression((extract_node_from_expr_tuple result),linenum)
							| IncDec(incdec,linenum)-> let result = typecheck_inc_dec_stmt incdec in IncDec(result,linenum)
							| Assignment(assignment_stmt,linenum)-> let result= typecheck_assignment_stmt assignment_stmt in Assignment(result,linenum)
				(*NOT DONE*)| ShortVardecl(short_var_decl,linenum)->type_checking_error ("shortvar decl not yet implemented linenum:="^(Printf.sprintf "%i" linenum)) (* typecheck_short_var_decl short_var_decl *)


and  typecheck_condition cond = match cond with 
							| ConditionExpression (expr,linenum)->
															let cond_type= pretty_typecheck_expression expr in 
														   if (extract_type_from_expr_tuple cond_type) == SymBool then ConditionExpression ((extract_node_from_expr_tuple cond_type),linenum)
														   else type_checking_error ("condition has to be bool linenum:="^(Printf.sprintf "%i" linenum))
							| Empty -> Empty
and typecheck_else_stmt stmt =  match stmt with 
							| ElseSingle(if_stmt,stmts,linenum)-> let result1= typecheck_if_stmt if_stmt in 
														 		 let _= start_scope() in 
														  		let result2= typecheck_stmts stmts in 
														  		let _= end_scope() in 
														  		ElseSingle(result1,result2,linenum)
						    | ElseIFMultiple(if_stmt,else_stmt,linenum)-> let result1= typecheck_if_stmt if_stmt in 
																  		  let result2 =typecheck_else_stmt else_stmt in 
																  		  ElseIFMultiple(result1,result2,linenum)
						    | ElseIFSingle(if_stmt1,if_stmt2,linenum)-> let result1= typecheck_if_stmt if_stmt1 in 
						    											 let result2=typecheck_if_stmt if_stmt2 in 
						    											 ElseIFSingle(result1,result2,linenum)


and typecheck_for_stmt stmt = match stmt with 
				    | Forstmt(stmts,linenum)-> let _= start_scope() in 
				    				  		 let result= typecheck_stmts stmts in 
				    						 let _= end_scope() in 
				    						 Forstmt(result,linenum)(* "for {\n"^(typecheck_stmts stmts)^"}" *)
				    | ForCondition(condition, stmts,linenum)-> let result1= typecheck_condition condition in 
				    								   let _= start_scope() in 
								    				   let result2= typecheck_stmts stmts in 
								    					let _= end_scope() in 
								    					ForCondition(result1, result2,linenum)
				    							    	(* "for "^(typecheck_condition condition)^"{\n"^(typecheck_stmts stmts)^"}" *)
				    | ForClause (for_clause, stmts,linenum)-> let result1 = typecheck_clause for_clause in 
				    										  let _= start_scope() in 
								    						  let result2= typecheck_stmts stmts in 
								    				 		 let _= end_scope() in 
								    				  		let _= end_scope() in 
								    				  		ForClause (result1, result2,linenum)(* "for "^(typecheck_clause for_clause)^"{\n"^(typecheck_stmts stmts)^"}" *)
and typecheck_clause clause= match clause with (*NEEDS REVISION*)
						 | ForClauseCond(simple1,condition,simple2,linenum)-> let _= start_scope() in
						 											  let result1= typecheck_simple_stmt simple1 in 
						 											  let result2= typecheck_condition condition in
						 											  let result3 = typecheck_simple_stmt simple2 in 
						 											  ForClauseCond(result1,result2,result3,linenum)
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
and typecheck_inc_dec_stmt stmt = match stmt with 
						 | Increment(expr,linenum)->let result= type_check_assignment_op expr expr "+=" in Increment((extract_type_from_expr_tuple result),linenum)
   						 | Decrement(expr,linenum)->let result= type_check_assignment_op expr expr "-=" in Decrement((extract_type_from_expr_tuple result),linenum)


and type_check_assignment_exprs exprs1 exprs2 linenum= match exprs1,exprs2 with
											| [] ,[] -> ([],[]) 
											| head1::tail1, head2::tail2 -> let lhsexpr_type= pretty_typecheck_expression head1 in
																			let rhsexprs_type= pretty_typecheck_expression head2 in 
																			if (extract_type_from_expr_tuple lhsexpr_type)==( extract_type_from_expr_tuple rhsexprs_type) 
																				then let result = type_check_assignment_exprs tail1 tail2 linenum in 
																				((extract_node_from_expr_tuple lhsexpr_type)::(extract_node_from_expr_tuple result), (extract_node_from_expr_tuple rhsexprs_type)::(extract_type_from_expr_tuple result))
																			else type_checking_error ("assignment should have the same type linenum:="^(Printf.sprintf "%i" linenum))
and type_check_assignment_op exp1 exp2 assign_op = match assign_op with 
													    | "+="-> let exp_type1= pretty_typecheck_expression exp1 in 
															     let exp_type2= pretty_typecheck_expression exp2 in 
																 let _= numeric_string_typecheck (extract_type_from_expr_tuple exp_type1) (extract_type_from_expr_tuple exp_type2) in 
																 ((extract_node_from_expr_tuple exp_type1),(extract_node_from_expr_tuple exp_type2))
													    | "-="-> let exp_type1= pretty_typecheck_expression exp1 in 
															     let exp_type2= pretty_typecheck_expression exp2 in 
																 let _= numeric_typecheck (extract_type_from_expr_tuple exp_type1) (extract_type_from_expr_tuple exp_type2) in 
																  ((extract_node_from_expr_tuple exp_type1),(extract_node_from_expr_tuple exp_type2))
													    | "|="-> let exp_type1= pretty_typecheck_expression exp1 in 
																 let exp_type2= pretty_typecheck_expression exp2 in 
															     let _= integer_typecheck (extract_type_from_expr_tuple exp_type1) (extract_type_from_expr_tuple exp_type2) in 
																  ((extract_node_from_expr_tuple exp_type1),(extract_node_from_expr_tuple exp_type2))
													    | "^="-> let exp_type1= pretty_typecheck_expression exp1 in 
															     let exp_type2= pretty_typecheck_expression exp2 in 
																 let _= integer_typecheck (extract_type_from_expr_tuple exp_type1) (extract_type_from_expr_tuple exp_type2) in 
																  ((extract_node_from_expr_tuple exp_type1),(extract_node_from_expr_tuple exp_type2))
													    | "*="-> let exp_type1= pretty_typecheck_expression exp1 in 
															     let exp_type2= pretty_typecheck_expression exp2 in 
																 let _= numeric_typecheck (extract_type_from_expr_tuple exp_type1) (extract_type_from_expr_tuple exp_type2) in 
																  ((extract_node_from_expr_tuple exp_type1),(extract_node_from_expr_tuple exp_type2))
													    | "/="-> let exp_type1= pretty_typecheck_expression exp1 in 
															     let exp_type2= pretty_typecheck_expression exp2 in 
																let _= numeric_typecheck (extract_type_from_expr_tuple exp_type1) (extract_type_from_expr_tuple exp_type2) in 
																  ((extract_node_from_expr_tuple exp_type1),(extract_node_from_expr_tuple exp_type2))
													    | "%="-> let exp_type1= pretty_typecheck_expression exp1 in 
															     let exp_type2= pretty_typecheck_expression exp2 in 
																 let _= numeric_typecheck (extract_type_from_expr_tuple exp_type1) (extract_type_from_expr_tuple exp_type2) in 
																  ((extract_node_from_expr_tuple exp_type1),(extract_node_from_expr_tuple exp_type2))
													    | ">>="-> let exp_type1= pretty_typecheck_expression exp1 in 
																  let exp_type2= pretty_typecheck_expression exp2 in 
																 let _= integer_typecheck (extract_type_from_expr_tuple exp_type1) (extract_type_from_expr_tuple exp_type2) in 
																  ((extract_node_from_expr_tuple exp_type1),(extract_node_from_expr_tuple exp_type2))
													    | "<<="-> let exp_type1= pretty_typecheck_expression exp1 in 
																  let exp_type2= pretty_typecheck_expression exp2 in 
																  let _= integer_typecheck (extract_type_from_expr_tuple exp_type1) (extract_type_from_expr_tuple exp_type2) in 
																  ((extract_node_from_expr_tuple exp_type1),(extract_node_from_expr_tuple exp_type2))
													    | "&="-> let exp_type1= pretty_typecheck_expression exp1 in 
															     let exp_type2= pretty_typecheck_expression exp2 in 
																 let _= integer_typecheck (extract_type_from_expr_tuple exp_type1) (extract_type_from_expr_tuple exp_type2) in 
																  ((extract_node_from_expr_tuple exp_type1),(extract_node_from_expr_tuple exp_type2))
													    | "&^="-> let exp_type1= pretty_typecheck_expression exp1 in 
																  let exp_type2= pretty_typecheck_expression exp2 in 
																  let _= integer_typecheck (extract_type_from_expr_tuple exp_type1) (extract_type_from_expr_tuple exp_type2) in 
																  ((extract_node_from_expr_tuple exp_type1),(extract_node_from_expr_tuple exp_type2))

and typecheck_assignment_stmt stmt = match stmt with 
						    | AssignmentBare(exprs1,exprs2,linenum)-> let result = type_check_assignment_exprs exprs1 exprs2 linenum in 
						    										  AssignmentBare((extract_node_from_expr_tuple result),(extract_type_from_expr_tuple result),linenum)
   						    | AssignmentOp(exprs1, assign_op, exprs2,linenum)-> let result=type_check_assignment_op exprs1 exprs2 assign_op in 
   						    											 AssignmentOp((extract_node_from_expr_tuple result),assign_op, (extract_type_from_expr_tuple result),linenum)


(* and typecheck_short_var_decl dcl = match dcl with
							| ShortVarDecl(idens, exprs)-> (typecheck_identifiers idens)^" := "^(typecheck_expressions exprs)


 *)
and typecheck_declaration decl = match decl with 
								| Function(func_name,signature,stmts,linenum)->let result=  typecheck_function_declaration func_name signature stmts in Function(func_name,signature,result,linenum)
								| TypeDcl([],linenum)->  decl
								| TypeDcl(value,linenum)-> let result= (List.map typecheck_type_declaration value) in  TypeDcl(result,linenum)(* write_message(typecheck_list(List.map typecheck_type_declaration value)) *)
								| VarDcl([],linenum)-> decl
								| VarDcl(value,linenum)-> let result= (List.map typecheck_variable_declaration value) in VarDcl(result,linenum)
								| _ -> decl

and typecheck_signature_return_type return_type = match return_type with
	| FuncReturnType(return_type_i,linenum) -> typecheck_type_name return_type_i  
	| Empty -> Void


and typecheck_signature signature func_name= match signature with
	FuncSig(FuncParams(func_params,linenum1), return_type,linenum2) -> 
																	let mytype=typecheck_signature_return_type return_type in 
																	let params= typecheck_identifiers_with_type func_params in  
																	let _= add_variable_to_current_scope (SymFunc(mytype,params)) (Identifier(func_name,linenum1)) in 
																	let _= start_scope () in 
																	let _= typecheck_identifiers_with_type_new_scope func_params in start_scope()
													 

and typecheck_function_declaration func_name signature stmts = let _= typecheck_signature signature func_name in 
															   let new_stmts=typecheck_stmts stmts  in 
															   let _= end_scope() in 
															   let _= end_scope() in 
															   new_stmts

(* 
and firstpass_typecheck_signature signature func_name= match signature with
	FuncSig(FuncParams(func_params,linenum1), return_type,linenum2) -> let mytype=typecheck_signature_return_type return_type in 
																	   let params= typecheck_identifiers_with_type func_params in  
																	   let _= add_variable_to_current_scope (SymFunc(mytype,params)) (Identifier(func_name,linenum1)) in 
																	   signature *)
																	   

(* and firstpass_typecheck_function_declaration func_name signature = let _= firstpass_typecheck_signature signature func_name in ()
 *)																		 
(* and firstpass_function_declaration decl = match decl with
								| TypeDcl([],linenum)->  decl
								| TypeDcl(value,linenum)-> let result= (List.map typecheck_type_declaration value) in  TypeDcl(result,linenum)(* write_message(typecheck_list(List.map typecheck_type_declaration value)) *)
								| VarDcl([],linenum)-> decl
								| VarDcl(value,linenum)-> let result= (List.map typecheck_variable_declaration value) in VarDcl(result,linenum)
								| Function(func_name,signature,stmts,linenum)->let result=  firstpass_typecheck_function_declaration func_name signature in decl
								| _ -> decl *)


let type_check_program program filename= 
							let _= set_file filename in let _= start_scope () in 
								 (match program with
									  | Prog(packagename,dcllist)->
									  		  (* et _= (List.map firstpass_function_declaration dcllist) in   *)
									          (* let _=write_message ("package "^(packagename)^" ;\n") in  *)
											  let new_decl_list= (List.map typecheck_declaration dcllist)in 
											  Prog(packagename,new_decl_list)) 

