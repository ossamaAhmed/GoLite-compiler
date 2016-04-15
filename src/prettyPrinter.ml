open Printf
open Ast

let print program filedir filename =
    let Prog(package_name, decl_list) = program in
    let output_filename = filedir^(Filename.dir_sep)^filename^".pretty.go" in
    let output_file = open_out output_filename in 
    let print_string s = output_string output_file s in
    let print_int value = print_string (string_of_int value) in
    let print_float value = print_string (string_of_float value) in
    let print_tab (level) = print_string (String.make level '\t') in

    let print_package package_name = print_string ("package "^(package_name)^";\n\n") in

    let rec print_identifier_list iden_list = match iden_list with
        | Identifier(iden, _)::[] -> print_string iden
        | Identifier(iden, _)::tail ->
            begin
                print_string (iden^", ");
                print_identifier_list tail
            end
        | _ -> ()
    in
    let rec print_type_name level type_name = match type_name with
        | Definedtype(Identifier(value, _),_, _) -> print_string value
        | Primitivetype(value, _) -> print_string value 
        | Arraytype(len, type_name2, _)-> 
            begin
                print_string "[ ";
                print_int len;
                print_string " ] ";
                print_type_name level type_name2;
            end
        | Slicetype(type_name2, _)->
            begin
                print_string "[] ";
                print_type_name level type_name2;
            end
        | Structtype([], _) -> ()
        | Structtype(field_dcl_list, _) -> 
            let print_field_dcl level field = match field with 
                | (iden_list,type_name1) -> 
                begin
                    print_tab (level);
                    print_identifier_list iden_list;
                    print_string " ";
                    print_type_name (level) type_name1;
                    print_string ";\n";
                end
                | _ -> ast_error ("field_dcl_print error")
            in
                print_string "struct {\n";
                List.iter (print_field_dcl (level+1)) field_dcl_list;
                print_tab (level);
                print_string "}";
    in
    let rec print_identifier_list_with_type iden_list = match iden_list with
        | [] -> ()
        | TypeSpec(Identifier(iden, _), iden_type, _)::[] -> 
            begin
                print_string iden;
                print_string " ";
                print_type_name 0 iden_type;
            end
        | TypeSpec(Identifier(iden, _), iden_type, _)::tail ->
            begin
                print_string iden;
                print_string " ";
                print_type_name 0 iden_type;
                print_string ", ";
                print_identifier_list_with_type tail;
            end
    in 
    let print_literal lit = match lit with
        | Intliteral(value, _) -> print_int value
        | Floatliteral(value, _) -> print_float value
        | Runeliteral(value, _) -> print_string value
        | Stringliteral(value, _) -> print_string value
    in
    let rec print_expr exp = match exp with 
        | OperandName(value, _, _) -> print_string value
        | AndAndOp(exp1, exp2, _, _) -> 
            begin
                print_string "( ";
                print_expr exp1;
                print_string " && ";
                print_expr exp2;
                print_string " )";
            end
        | OrOrOp(exp1, exp2, _, _) -> 
            begin
                print_string "( ";
                print_expr exp1;
                print_string " || ";
                print_expr exp2;
                print_string " )";
            end
        | EqualEqualCmp(exp1, exp2, _, _) -> 
            begin
                print_string "( ";
                print_expr exp1;
                print_string " == ";
                print_expr exp2;
                print_string " )";
            end
        | NotEqualCmp(exp1, exp2, _, _) -> 
            begin
                print_string "( ";
                print_expr exp1;
                print_string " != ";
                print_expr exp2;
                print_string " )";
            end
        | LessThanCmp(exp1, exp2, _, _) -> 
            begin
                print_string "( ";
                print_expr exp1;
                print_string " < ";
                print_expr exp2;
                print_string " )";
            end
        | GreaterThanCmp (exp1, exp2, _, _) -> 
            begin
                print_string "( ";
                print_expr exp1;
                print_string " > ";
                print_expr exp2;
                print_string " )";
            end
        | LessThanOrEqualCmp(exp1, exp2, _, _) -> 
            begin
                print_string "( ";
                print_expr exp1;
                print_string " <= ";
                print_expr exp2;
                print_string " )";
            end
        | GreaterThanOrEqualCmp(exp1, exp2, _, _) -> 
            begin
                print_string "( ";
                print_expr exp1;
                print_string " >= ";
                print_expr exp2;
                print_string " )";
            end
        | AddOp(exp1, exp2, _, _) -> 
            begin
                print_string "( ";
                print_expr exp1;
                print_string " + ";
                print_expr exp2;
                print_string " )";
            end
        | MinusOp(exp1, exp2, _, _) -> 
            begin
                print_string "( ";
                print_expr exp1;
                print_string " - ";
                print_expr exp2;
                print_string " )";
            end
        | OrOp (exp1, exp2, _, _) -> 
            begin
                print_string "( ";
                print_expr exp1;
                print_string " | ";
                print_expr exp2;
                print_string " )";
            end
        | CaretOp (exp1, exp2, _, _) -> 
            begin
                print_string "( ";
                print_expr exp1;
                print_string " ^ ";
                print_expr exp2;
                print_string " )";
            end
        | MulOp (exp1, exp2, _, _)-> 
            begin
                print_string "( ";
                print_expr exp1;
                print_string " * ";
                print_expr exp2;
                print_string " )";
            end
        | DivOp (exp1, exp2, _, _)-> 
            begin
                print_string "( ";
                print_expr exp1;
                print_string " / ";
                print_expr exp2;
                print_string " )";
            end
        | ModuloOp (exp1, exp2, _, _) -> 
            begin
                print_string "( ";
                print_expr exp1;
                print_string " % ";
                print_expr exp2;
                print_string " )";
            end
        | SrOp (exp1, exp2, _, _) -> 
            begin
                print_string "( ";
                print_expr exp1;
                print_string " >> ";
                print_expr exp2;
                print_string " )";
            end
        | SlOp (exp1, exp2, _, _) ->
            begin
                print_string "( ";
                print_expr exp1;
                print_string " << ";
                print_expr exp2;
                print_string " )";
            end
        | AndOp (exp1, exp2, _, _) -> 
            begin
                print_string "( ";
                print_expr exp1;
                print_string " & ";
                print_expr exp2;
                print_string " )";
            end
        | AndCaretOp (exp1, exp2, _, _) -> 
            begin
                print_string "( ";
                print_expr exp1;
                print_string " &^ ";
                print_expr exp2;
                print_string " )";
            end
        | OperandParenthesis (exp1, _, _) -> print_expr exp1
        | Indexexpr(exp1, exp2, _, _) -> 
            begin
                print_string "( ";
                print_expr exp1;
                print_string "[";
                print_expr exp2;
                print_string "]";
                print_string " )";
            end
        | Unaryexpr(exp1, _, _) -> print_expr exp1
        | Binaryexpr(exp1, _, _) -> print_expr exp1
        | FuncCallExpr(exp1, exprs, _, _) -> 
            begin
                print_string "( ";
                print_expr exp1;
                print_string "(";
                print_expr_list exprs;
                print_string ")";
                print_string " )";
            end
        | UnaryPlus(exp1, _, _) -> 
            begin
                print_string "( +";
                print_expr exp1;
                print_string " )";
            end
        | UnaryMinus(exp1, _, _) ->
            begin
                print_string "( -";
                print_expr exp1;
                print_string " )";
            end
        | UnaryNot(exp1, _, _) ->
            begin
                print_string "( !";
                print_expr exp1;
                print_string " )";
            end
        | UnaryCaret(exp1, _, _) ->
            begin
                print_string "( ^";
                print_expr exp1;
                print_string " )";
            end
        | Value(value, _, _)-> print_literal value
        | Selectorexpr(exp1, Identifier(iden, _), _, _) ->
            begin
                print_string "( ";
                print_expr exp1;
                print_string ".";
                print_string iden;
                print_string " )";
            end
        | TypeCastExpr(typename, exp1, _, _) ->
            begin
                print_type_name 0 typename;
                print_string "( ";
                print_expr exp1;
                print_string " )";
            end
        | Appendexpr(Identifier(iden, _),exp1, _, _)-> 
            begin
                print_string "( append(";
                print_string iden;
                print_string ", ";
                print_expr exp1;
                print_string ") )";
            end
        | _ -> ast_error ("expression error")
    and print_expr_list expr_list = match expr_list with
        | [] -> ()
        | head::[] -> print_expr head
        | head::tail ->
            begin
                print_expr head;
                print_string ", ";
                print_expr_list tail;
            end
    in
    let print_func_return_type return_type = match return_type with
        | FuncReturnType(return_type_i, _) -> 
            begin
                print_string " ";
                print_type_name 0 return_type_i;
            end
        | Empty -> ()
    in
    let print_func_sig signature = match signature with
        | FuncSig(FuncParams(func_params, _), return_type, _) ->
            begin
                print_string "(";
                print_identifier_list_with_type func_params;
                print_string ")";
                print_func_return_type return_type;
            end
    in
    let print_var_decl level decl = match decl with
        | VarSpecWithType(iden_list, typename, exprs, _) -> 
            (match exprs with
                | [] -> 
                    begin
                        print_tab (level);
                        print_string "var ";
                        print_identifier_list iden_list;
                        print_string " ";
                        print_type_name level typename;
                        print_string ";\n";
                    end
                | head::tail ->
                    begin
                        print_tab (level);
                        print_string "var ";
                        print_identifier_list iden_list;
                        print_string " ";
                        print_type_name level typename;
                        print_string " = ";
                        print_expr_list exprs;
                        print_string ";\n";     
                    end
            )
        | VarSpecWithoutType (iden_list, exprs, _) -> 
            (match exprs with
                | [] ->
                    begin
                        print_tab (level);
                        print_string "var ";
                        print_identifier_list iden_list;
                        print_string ";\n";
                    end
                | head::tail ->
                    begin
                        print_tab (level);
                        print_string "var ";
                        print_identifier_list iden_list;
                        print_string " = ";
                        print_expr_list exprs;
                        print_string ";\n";
                    end
            )
        | _ -> ast_error ("var_dcl error")
    in
    let print_type_decl level decl = match decl with
        | TypeSpec(Identifier(iden, _), typename, _)->
            begin
                print_tab (level);
                print_string "type ";
                print_string iden;
                print_string " ";
                print_type_name level typename;
                print_string "\n"
            end
        | _ -> ast_error ("type_dcl error")
    in
    let print_inc_dec_stmt stmt = match stmt with 
        | Increment(expr, _) ->
            begin
                print_expr expr;
                print_string "++";
            end
        | Decrement(expr, _) ->
            begin
                print_expr expr;
                print_string "--";
            end
    in
    let print_assignment_stmt stmt = match stmt with 
        | AssignmentBare(exprs1, exprs2, _) ->
            begin
                print_expr_list exprs1;
                print_string " = ";
                print_expr_list exprs2;
            end
        | AssignmentOp(exprs1, assign_op, exprs2, _) ->
            begin
                print_expr exprs1;
                print_string assign_op;
                print_expr exprs2;
            end
    in
    let print_short_var_decl_stmt dcl = match dcl with
        | ShortVarDecl(idens, exprs, _) ->
            begin
                print_identifier_list idens;
                print_string " := ";
                print_expr_list exprs;
            end
    in
    let print_simple_stmt stmt = match stmt with 
        | SimpleExpression(expr, _) -> print_expr expr
        | IncDec(incdec, _) -> print_inc_dec_stmt incdec 
        | Assignment(assignment_stmt, _) -> print_assignment_stmt assignment_stmt
        | ShortVardecl(short_var_decl, _) -> print_short_var_decl_stmt short_var_decl
        | Empty -> ()
    in
    let rec print_stmt level stmt = match stmt with
        | Declaration(decl, _) -> 
            (match decl with
                | TypeDcl([], _) -> ()
                | TypeDcl(decl_list, _) -> List.iter (print_type_decl level) decl_list
                | VarDcl([], _) ->  ()
                | VarDcl(decl_list, _) -> List.iter (print_var_decl level) decl_list
                | Function(func_name, signature, stmt_list, _) ->
                    begin
                        print_string "func ";
                        print_string func_name;
                        print_func_sig signature;
                        print_string " {\n";
                        List.iter (print_stmt (level+1)) stmt_list;
                        print_string "}\n";
                    end
                | _ -> ()
            )
        | Return(rt_stmt, _) -> 
            let print_return_stmt level stmt = match stmt with
                | ReturnStatement(expr, _) -> 
                    begin
                        print_tab level;
                        print_string "return ";
                        print_expr expr;
                        print_string "\n";
                    end
                | Empty -> print_string "return\n"
            in
            print_return_stmt level rt_stmt
        | Break(_) -> 
            begin
                print_tab level;
                print_string "break\n";
            end
        | Continue(_) ->
            begin
                print_tab level;
                print_string "continue\n";
            end
        | Block(stmt_list, _) -> print_stmt_list (level+1) stmt_list
        | Conditional(conditional, _) ->
            let print_if_init if_init = match if_init with
                | IfInitSimple(simplestmt, _) ->
                    begin
                        print_simple_stmt simplestmt;
                        print_string "; ";
                    end
                | Empty -> ()
            in
            let print_if_cond cond = match cond with 
                | ConditionExpression(expr, _) -> print_expr expr
                | Empty -> ()
            in
            let print_if_stmt level if_stmt = match if_stmt with
                | IfInit(if_init, condition, stmts, _) -> 
                    begin
                        print_string "if ";
                        print_if_init if_init;
                        print_if_cond condition;
                        print_string " {\n";
                        print_stmt_list (level+1) stmts;
                        print_tab level;
                        print_string "}";
                    end
            in
            let rec print_else_stmt level stmt =  match stmt with 
                | ElseSingle(if_stmt, stmts, _) -> 
                    begin
                        print_if_stmt level if_stmt;
                        print_string " else {\n ";
                        print_stmt_list (level+1) stmts;
                        print_tab level;
                        print_string "}";
                    end
                | ElseIFMultiple(if_stmt, else_stmt, _) ->
                    begin
                        print_if_stmt level if_stmt;
                        print_string " else ";
                        print_else_stmt level else_stmt;
                    end
                | ElseIFSingle(if_stmt1, if_stmt2, _) -> 
                    begin
                        print_if_stmt level if_stmt1;
                        print_string " else ";
                        print_if_stmt level if_stmt2;
                    end
            in
            let print_conditional_stmt level cond = match cond with 
                | IfStmt(if_stmt, _) -> 
                    begin
                        print_tab level;
                        print_if_stmt level if_stmt;
                        print_string "\n";
                    end
                | ElseStmt(else_stmt, _) ->
                    begin
                        print_tab level;
                        print_else_stmt level else_stmt;
                        print_string "\n";
                    end
            in
            print_conditional_stmt level conditional
        | Simple(simple, _) -> 
            begin
                print_tab level;
                print_simple_stmt simple;
                print_string ";\n"
            end
        | Print(exprs, _) -> 
            begin
                print_tab level;
                print_string "print(";
                print_expr_list exprs;
                print_string ")\n"
            end
        | Println(exprs, _) -> 
            begin
                print_tab level;
                print_string "println(";
                print_expr_list exprs;
                print_string ")\n";
            end
        | For(for_stmt, _) ->
            let print_for_cond cond = match cond with 
                | ConditionExpression(expr, _) -> print_expr expr
                | Empty -> ()
            in
            let print_for_clause clause = match clause with 
                | ForClauseCond(simple1, condition, simple2, _) -> 
                    begin
                        print_simple_stmt simple1;
                        print_string "; ";
                        print_for_cond condition;
                        print_string "; ";
                        print_simple_stmt simple2;
                    end
            in
            let print_for_stmt level stmt = match stmt with 
                | Forstmt(stmts, _) ->
                    begin
                        print_tab (level);
                        print_string "for {\n";
                        print_stmt_list (level+1) stmts;
                        print_tab (level);
                        print_string "}\n";
                    end
                | ForCondition(condition, stmts, _) -> 
                    begin
                        print_tab (level);
                        print_string "for ";
                        print_for_cond condition;
                        print_string " {\n";
                        print_stmt_list (level+1) stmts;
                        print_tab (level);
                        print_string "}\n";
                    end
                | ForClause (for_clause, stmts, _) ->
                    begin
                        print_tab (level);
                        print_string "for ";
                        print_for_clause for_clause;
                        print_string " {\n";
                        print_stmt_list (level+1) stmts;
                        print_tab (level);
                        print_string "}\n";
                    end
            in
            print_for_stmt level for_stmt
        | Switch(switch_clause, switch_expr, switch_case_stmts, _) -> 
            let print_switch_clause clause = match clause with
                | SwitchClause(simple_stmt, _) -> 
                    begin
                        print_simple_stmt simple_stmt;
                        print_string "; ";
                    end
                | Empty -> ()
            in
            let print_switch_expr expr = match expr with 
                | SwitchExpr(expr, _)->
                    begin
                        print_expr expr;
                        print_string " ";
                    end
                | Empty -> ()
            in
            let print_switch_case_clause level clause = match clause with 
                | SwitchCaseClause(exprs, stmts, _) -> 
                    (match exprs with
                        | [] -> 
                            begin
                                print_tab (level);
                                print_string "default :\n";
                                print_stmt_list (level+1) stmts;
                            end
                        | head::tail ->
                            begin
                                print_tab (level);
                                print_string "case ";
                                print_expr_list exprs;
                                print_string " :\n";
                                print_stmt_list (level+1) stmts;
                            end
                    )
                | Empty -> ()   
            in
            let print_switch_case_stmt level stmts = match stmts with
                | SwitchCasestmt([], _) -> ()
                | SwitchCasestmt(switch_case_clauses, _) -> List.iter (print_switch_case_clause level) switch_case_clauses
            in       
            begin
                print_tab (level);
                print_string "switch ";
                print_switch_clause switch_clause;
                print_switch_expr switch_expr;
                print_string "{\n";
                print_switch_case_stmt (level+1) switch_case_stmts;
                print_tab (level);
                print_string "}\n";
            end
        | _ -> ()
    and print_stmt_list level stmt_list = match stmt_list with
        | [] -> ()
        | head::[] -> print_stmt level head
        | head::tail ->
            begin
                print_stmt level head;
                print_stmt_list level tail;
            end
    and print_decl level decl = match decl with
        | TypeDcl([], _) -> ()
        | TypeDcl(decl_list, _) -> List.iter (print_type_decl level) decl_list
        | VarDcl([], _) ->  ()
        | VarDcl(decl_list, _) -> List.iter (print_var_decl level) decl_list
        | Function(func_name, signature, stmt_list, _) ->
            begin
                print_string "func ";
                print_string func_name;
                print_func_sig signature;
                print_string " {\n";
                print_stmt_list (level+1) stmt_list;
                print_string "}\n";
            end
        | _ -> ()
    and print_decl_list level decl_list = 
        List.iter (print_decl level) decl_list
    in
    print_package package_name;
    print_decl_list 0 decl_list;
    close_out output_file
