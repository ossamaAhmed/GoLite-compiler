open Printf
open Ast

let file = ref "../your_program.go"
let oc = ref stdout
let set_file filename= (file := "../"^filename^".pretty.go"); oc:= (open_out (!file))
let write_message message= fprintf (!oc) "%s" message   (* write something *)   
let close oc= close_out oc
let indentstack = Stack.create

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



let print_type_declaration decl = match decl with
								| TypeSpec(Identifier(value), typename)-> (Stack.top indentation)^"type "^value^" "^(print_type_name typename)^"\n"
								| _-> ast_error ("type_dcl error")

let print_declaration decl = match decl with 
								| TypeDcl(value)-> write_message(print_list(List.map print_type_declaration value))
								| VarDcl(value)->  write_message ("var declaration here\n")
								| FuncDcl(value)-> write_message ("func declaration here\n")

let print_pretty_program program filename= 
							let _= set_file filename in 
								 (match program with
									  | Prog(packagename,dcllist)->
									          let _=write_message ("package "^(packagename)^" ;\n") in 
											  (List.map print_declaration dcllist))




