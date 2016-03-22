open Printf
open Ast

let file = ref "../your_program.go"
let oc = ref stdout
let set_file filedir filename = (file := filedir^(Filename.dir_sep)^filename^".pretty.go"); oc := (open_out (!file))
let write_message message = fprintf (!oc) "%s" message   (* write something *)   
let close oc = close_out oc
let indentation = Stack.create()
let _= Stack.push "" indentation
let indent ="   "

let rec print_list lis = match lis with
    | last::[]-> last
    | head::tail -> head^ (print_list tail)
let rec print_identifiers idenlist = match idenlist with
    | Identifier(value,linenum)::[] -> value
    | Identifier(value,linenum)::tail -> value^", "^(print_identifiers tail)
let print_literal lit = match lit with
    | Intliteral(value,linenum) -> (Printf.sprintf "%i" value)
    | Floatliteral(value,linenum) -> (Printf.sprintf "%f" value)
    | Runeliteral(value,linenum) -> (Printf.sprintf "%s" value)
    | Stringliteral(value,linenum) -> value

let rec print_type_name type_name = match type_name with
    | Definedtype(Identifier(value,linenum1),linenum2)->value
    | Primitivetype(value,linenum)->value 
    | Arraytype(len, type_name2,linenum)-> "[ "^(Printf.sprintf "%i" len)^" ] "^(print_type_name type_name2)
    | Slicetype(type_name2,linenum)->  "[ ] "^(print_type_name type_name2)
    | Structtype([],linenum) -> ""
    | Structtype(field_dcl_list,linenum) -> 
        let print_field_dcl field = match field with 
            | (iden_list,type_name1) -> (Stack.top indentation)^(print_identifiers iden_list)^" "^(print_type_name type_name1)^";\n"
            | _ -> ast_error ("field_dcl_print error") in 
                let last_indent = (Stack.top indentation) in 
                let _ = Stack.push (last_indent^indent) indentation in
                let result =(last_indent)^"struct {\n"^(print_list(List.map print_field_dcl field_dcl_list))^"}\n" in 
                let _ = Stack.pop indentation in 
                    result

let rec print_identifiers_with_type idenlist = match idenlist with
    | [] -> ""
    | TypeSpec(Identifier(value,linenum1),return_type,linenum2)::[] -> value^" "^(print_type_name return_type)
    | TypeSpec(Identifier(value,linenum1),return_type,linenum2)::tail -> value^" "^(print_type_name return_type)^", "^(print_identifiers_with_type tail)

let print_type_declaration decl = match decl with
                                | TypeSpec(Identifier(value,linenum1), typename,linenum2)-> "type "^value^" "^(print_type_name typename)^"\n"
                                | _-> ast_error ("type_dcl error")
                                
let rec pretty_print_expression exp =
                                    let rec print_expressions exprlist = match exprlist with
                                    | [] -> ""
                                    | head::[] -> pretty_print_expression head
                                    | head::tail -> ((pretty_print_expression head)^", "^(print_expressions tail) )in 
                                    match exp with 
                                                | OperandName(value,linenum)-> value
                                                | AndAndOp(exp1,exp2,linenum)-> "( "^(pretty_print_expression exp1)^" && "^(pretty_print_expression exp2 )^" )"
                                                | OrOrOp(exp1,exp2,linenum)-> "( "^(pretty_print_expression exp1)^" || "^(pretty_print_expression exp2 )^" )"
                                                | EqualEqualCmp(exp1,exp2,linenum)-> "( "^(pretty_print_expression exp1)^" == "^(pretty_print_expression exp2 )^" )"
                                                | NotEqualCmp(exp1,exp2,linenum)-> "( "^(pretty_print_expression exp1)^" != "^(pretty_print_expression exp2 )^" )"
                                                | LessThanCmp(exp1,exp2,linenum)-> "( "^(pretty_print_expression exp1)^" < "^(pretty_print_expression exp2 )^" )"
                                                | GreaterThanCmp (exp1,exp2,linenum)-> "( "^(pretty_print_expression exp1)^" >"^(pretty_print_expression exp2 )^" )"
                                                | LessThanOrEqualCmp(exp1,exp2,linenum)-> "( "^(pretty_print_expression exp1)^" <= "^(pretty_print_expression exp2 )^" )"
                                                | GreaterThanOrEqualCmp(exp1,exp2,linenum)-> "( "^(pretty_print_expression exp1)^" >= "^(pretty_print_expression exp2 )^" )"
                                                | AddOp(exp1,exp2,linenum)-> "( "^(pretty_print_expression exp1)^" + "^(pretty_print_expression exp2 )^" )"
                                                | MinusOp(exp1,exp2,linenum)-> "( "^(pretty_print_expression exp1)^" - "^(pretty_print_expression exp2 )^" )"
                                                | OrOp (exp1,exp2,linenum)-> "( "^(pretty_print_expression exp1)^" | "^(pretty_print_expression exp2 )^" )"
                                                | CaretOp (exp1,exp2,linenum)-> "( "^(pretty_print_expression exp1)^" ^ "^(pretty_print_expression exp2 )^" )"
                                                | MulOp (exp1,exp2,linenum)-> "( "^(pretty_print_expression exp1)^" * "^(pretty_print_expression exp2 )^" )"
                                                | DivOp (exp1,exp2,linenum)-> "( "^(pretty_print_expression exp1)^" / "^(pretty_print_expression exp2 )^" )"
                                                | ModuloOp (exp1,exp2,linenum)-> "( "^(pretty_print_expression exp1)^" % "^(pretty_print_expression exp2 )^" )"
                                                | SrOp (exp1,exp2,linenum)-> "( "^(pretty_print_expression exp1)^" >> "^(pretty_print_expression exp2 )^" )"
                                                | SlOp (exp1,exp2,linenum)-> "( "^(pretty_print_expression exp1)^" << "^(pretty_print_expression exp2 )^" )"
                                                | AndOp (exp1,exp2,linenum)-> "( "^(pretty_print_expression exp1)^" & "^(pretty_print_expression exp2 )^" )"
                                                | AndCaretOp (exp1,exp2,linenum)-> "( "^(pretty_print_expression exp1)^" &^ "^(pretty_print_expression exp2 )^" )"
                                                | OperandParenthesis (exp1,linenum)-> (pretty_print_expression exp1)
                                                | Indexexpr(exp1,exp2,linenum)-> "( "^(pretty_print_expression exp1)^"["^(pretty_print_expression exp2 )^"]"^")"
                                                | Unaryexpr(exp1,linenum) -> (pretty_print_expression exp1)
                                                | Binaryexpr(exp1,linenum) -> (pretty_print_expression exp1)
                                                | FuncCallExpr(expr,exprs,linenum)-> "( "^(pretty_print_expression expr)^"("^(print_expressions exprs)^")"^")"
                                                | UnaryPlus(exp1,linenum) -> "( +"^(pretty_print_expression exp1)^" )"
                                                | UnaryMinus(exp1,linenum) -> "( -"^(pretty_print_expression exp1)^" )"
                                                | UnaryNot(exp1,linenum) -> "( !"^(pretty_print_expression exp1)^" )"
                                                | UnaryCaret(exp1,linenum) -> "( ^"^(pretty_print_expression exp1)^" )"
                                                | Value(value,linenum)-> (print_literal value)
                                                | Selectorexpr(exp1,Identifier(iden,linenum1),linenum2)-> "("^(pretty_print_expression exp1)^"."^iden^")"
                                                | TypeCastExpr (typename,exp1,linenum) -> "( "^(print_type_name typename)^"("^(pretty_print_expression exp1)^"))"
                                                | Appendexpr (Identifier(iden,linenum1),exp1,linenum2)-> "( append("^iden^", "^(pretty_print_expression exp1)^"))"
                                                | _-> ast_error ("expression error")

let rec print_expressions exprlist = match exprlist with
                                    | [] -> ""
                                    | head::[] -> pretty_print_expression head
                                    | head::tail -> (pretty_print_expression head)^", "^(print_expressions tail)

let print_variable_declaration decl= match decl with
                                    | VarSpecWithType (iden_list,typename,exprs,linenum) -> ( match exprs with
                                                                                            | [] -> "var "^(print_identifiers iden_list)^" "^(print_type_name typename)^";\n"
                                                                                            | head::tail -> "var "^(print_identifiers iden_list)^" "^(print_type_name typename)^" = "^(print_expressions exprs)^";\n"
                                                                                    )
                                    | VarSpecWithoutType  (iden_list,exprs,linenum) -> ( match exprs with
                                                                                            | [] -> "var "^(print_identifiers iden_list)^";\n"
                                                                                            | head::tail -> "var "^(print_identifiers iden_list)^" = "^(print_expressions exprs)^";\n")
                                    | _ -> ast_error ("var_dcl error")

let rec  print_stmts stmts = match stmts with
                                    | [] -> ""
                                    | head::[] -> (print_stmt head)^";\n"
                                    | head::tail -> (print_stmt head)^";\n"^(print_stmts tail)
and print_stmt stmt = match stmt with
                    | Declaration(dcl,linenum)-> (match dcl with 
                                | TypeDcl([],linenum)->  ""
                                | TypeDcl(value,linenum)-> print_list(List.map print_type_declaration value)
                                | VarDcl([],linenum)->  ""
                                | VarDcl(value,linenum)->   print_list(List.map print_variable_declaration value)
                                | Function(func_name,signature,stmts,linenum)->  print_function_declaration func_name signature stmts)
                    | Return(rt_stmt,linenum)-> print_return_stmt rt_stmt (*DONE*)
                    | Break (linenum)-> "break " 
                    | Continue (linenum)-> "continue "
                    | Block(stmt_list,linenum)-> print_stmts stmt_list (*DONE*)
                    | Conditional(conditional,linenum)-> print_conditional conditional (*DONE*)
                    | Switch(switch_clause, switch_expr, switch_case_stmts,linenum)-> "switch "^(print_switch_clause switch_clause)^" "^(print_switch_expression switch_expr)^" {\n"^(print_switch_case_stmt switch_case_stmts)^"}"
                    | For(for_stmt,linenum)-> print_for_stmt for_stmt (*DONE*)
                    | Simple(simple,linenum)-> print_simple_stmt simple 
                    | Print(exprs,linenum)-> "print ("^(print_expressions exprs)^") " (*DONE*)
                    | Println(exprs,linenum)-> "println ("^(print_expressions exprs)^") " (*DONE*)
and print_return_stmt stmt= match stmt with
                            | Empty -> "return "
                            | ReturnStatement(expr,linenum)-> "return "^(pretty_print_expression expr)
and print_conditional cond = match cond with 
                            | IfStmt(if_stmt,linenum)-> print_if_stmt if_stmt
                            | ElseStmt(else_stmt,linenum)-> print_else_stmt else_stmt
and print_if_stmt if_stmt = match if_stmt with
                            | IfInit(if_init, condition, stmts,linenum)-> "if "^(print_if_init if_init)^(print_condition condition)^"{\n"^(print_stmts stmts)^"}"
and print_if_init if_init = match if_init with
                            | Empty -> ""
                            | IfInitSimple(simplestmt,linenum) -> (print_simple_stmt simplestmt)^";"
and print_simple_stmt stmt = match stmt with 
                            | Empty -> ""
                            | SimpleExpression(expr,linenum)-> pretty_print_expression expr
                            | IncDec(incdec,linenum)-> print_inc_dec_stmt incdec 
                            | Assignment(assignment_stmt,linenum)-> print_assignment_stmt assignment_stmt
                            | ShortVardecl(short_var_decl,linenum)-> print_short_var_decl short_var_decl
and  print_condition cond = match cond with 
                            | Empty -> ""
                            | ConditionExpression (expr,linenum)-> pretty_print_expression expr
and print_else_stmt stmt =  match stmt with 
                            | ElseSingle(if_stmt,stmts,linenum)-> (print_if_stmt if_stmt)^" else {\n "^(print_stmts stmts)^"}"
                            | ElseIFMultiple(if_stmt,else_stmt,linenum)->(print_if_stmt if_stmt)^" else "^(print_else_stmt else_stmt)
                            | ElseIFSingle(if_stmt1,if_stmt2,linenum)->(print_if_stmt if_stmt1)^" else "^(print_if_stmt if_stmt2)
and print_for_stmt stmt = match stmt with 
                    | Forstmt(stmts,linenum)-> "for {\n"^(print_stmts stmts)^"}"
                    | ForCondition(condition, stmts,linenum)-> "for "^(print_condition condition)^"{\n"^(print_stmts stmts)^"}"
                    | ForClause (for_clause, stmts,linenum)-> "for "^(print_clause for_clause)^"{\n"^(print_stmts stmts)^"}"
and print_clause clause= match clause with 
                         | ForClauseCond(simple1,condition,simple2,linenum)-> " "^(print_simple_stmt simple1)^"; "^(print_condition condition)^"; "^(print_simple_stmt simple2)^" "


and print_switch_clause clause = match clause with
                                | Empty -> ""
                                | SwitchClause(simple_stmt,linenum) -> (print_simple_stmt simple_stmt)^";"
and print_switch_expression expr = match expr with 
                                | Empty -> ""
                                | SwitchExpr(expr,linenum)-> (pretty_print_expression expr) 
and print_switch_case_clause clause = match clause with 
                                | SwitchCaseClause(exprs, stmts,linenum)-> (match exprs with
                                                                    | []->  "default : "^(print_stmts stmts)
                                                                    | head::tail -> "case "^(print_expressions exprs)^" : "^(print_stmts stmts)
                                                                    )
                                | Empty -> ""   

and print_switch_case_stmt stmts = match stmts with
                                | SwitchCasestmt([],linenum) -> ""
                                | SwitchCasestmt(switch_case_clauses,linenum)->(print_list(List.map print_switch_case_clause switch_case_clauses))                      
and print_inc_dec_stmt stmt = match stmt with 
                         | Increment(expr,linenum)->(pretty_print_expression expr)^"++"
                         | Decrement(expr,linenum)->(pretty_print_expression expr)^"--"

and print_assignment_stmt stmt = match stmt with 
                            | AssignmentBare(exprs1,exprs2,linenum)-> (print_expressions exprs1)^" = "^(print_expressions exprs2)
                            | AssignmentOp(exprs1, assign_op, exprs2,linenum)-> (pretty_print_expression exprs1)^assign_op^(pretty_print_expression exprs2)

and print_short_var_decl dcl = match dcl with
                            | ShortVarDecl(idens, exprs,linenum)-> (print_identifiers idens)^" := "^(print_expressions exprs)



and print_declaration decl = match decl with 
                                | TypeDcl([],linenum)->  ()
                                | TypeDcl(value,linenum)-> write_message(print_list(List.map print_type_declaration value))
                                | VarDcl([],linenum)->  ()
                                | VarDcl(value,linenum)->  write_message (print_list(List.map print_variable_declaration value))
                                | Function(func_name,signature,stmts,linenum)-> write_message (print_function_declaration func_name signature stmts)
                                | _ -> ()

and print_signature_return_type return_type = match return_type with
    | FuncReturnType(return_type_i,linenum) -> (print_type_name return_type_i)^" "
    | Empty -> ""

and print_signature signature = match signature with
    FuncSig(FuncParams(func_params,linenum1), return_type,linenum2) -> "("^(print_identifiers_with_type func_params)^")"^" "^(print_signature_return_type return_type)

and print_function_declaration func_name signature stmts =
    "func "^(func_name)^(print_signature signature)^"{\n"^(print_stmts stmts)^"};\n"

let print program filedir filename = 
    let _ = set_file filedir filename in 
        (match program with
            | Prog(packagename,dcllist)->
            let _ = write_message ("package "^(packagename)^" ;\n") in 
            (List.map print_declaration dcllist))


