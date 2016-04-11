open Printf
open Ast

exception Code_generation_error of string
let code_gen_error msg = raise (Code_generation_error msg)

(* Stack functions for locals manipulation *)

type symTable = Scope of (string , string) Hashtbl.t
let symbol_table = ref []

let start_scope () = symbol_table := Scope(Hashtbl.create 50)::!symbol_table
let end_scope () = match !symbol_table with 
    | head::tail -> symbol_table := tail
let search_current_scope key = match !symbol_table with 
    | Scope(current_scope)::tail -> 
    if (Hashtbl.mem current_scope key) then 
        Hashtbl.find current_scope key
    else 
        code_gen_error ("variable is not defined in current_scope")

let search_not_find_current_scope x = match !symbol_table with
    | Scope(current_scope)::tail ->
        if (Hashtbl.mem current_scope x) then true else false

let rec search_previous_scopes x table = match table with (*called with !symbol_table*)
    | []-> code_gen_error ("variable is not defined in current and previous scopes")
    | Scope(current_scope)::tail -> 
        if (Hashtbl.mem current_scope x) then 
            Hashtbl.find current_scope x
        else 
            search_previous_scopes x tail

let add_variable_to_current_scope mytype myvar = match myvar with
    | Identifier(myvariable,linenum)-> 
        (match !symbol_table with
            | Scope(current_scope)::tail ->
                if not(Hashtbl.mem current_scope myvariable) then 
                    Hashtbl.add current_scope myvariable mytype
                else
                    code_gen_error ("variable is defined more than one time")
        )

let labelcount = ref 0
let labelcounter () = labelcount :=! labelcount+1
let localcount = ref 0
let localcounter () = localcount :=! localcount+1

(* --------------------------------END-------------------------------- *)

let generate program filedir filename =

    (* Program AST unpacking *)
    let Prog(package_name, decl_list) = program in
    let output_filename = filedir^(Filename.dir_sep)^filename^".j" in
    let output_file = open_out output_filename in

    (* Utilities *)
    let print_string s = output_string output_file s in
    let println_string s = output_string output_file (s^"\n") in
    let print_tab (level) = print_string (String.make level '\t') in
    let print_string_with_tab (level) s =
        begin
            print_tab (level);
            print_string s
        end
    in
    let println_string_with_tab (level) s =
        begin
            print_tab (level);
            println_string s
        end
    in
    let print_int value = print_string (string_of_int value) in
    let print_float value = print_string (string_of_float value) in

    (* Jasmin initializations *)

    (*
    .class public examples/HelloWorld
    .super java/lang/Object
    *)
    let print_class_header filename = 
        begin
            print_string (".class public "^(filename)^"\n");
            print_string ".super java/lang/Object\n\n"
        end
    in
    (*
    .method public <init>()V
       aload_0
       invokenonvirtual java/lang/Object/<init>()V
       return
    .end method
    *)
    let print_init_header level =
        begin
            print_string (".method public <init>()V\n");
            print_string_with_tab (level) "aload_0\n";
            print_string_with_tab (level) "invokenonvirtual java/lang/Object/<init>()V\n";
            print_string_with_tab (level) "return\n";
            print_string ".end method\n\n"   
        end
    in
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
        | Definedtype(Identifier(value, _), _) -> print_string value
        | Primitivetype(value, _) -> ()
(*
            let _ = match value with
                | "int" -> print_string "I"
                | "rune" -> print_string "C"
                | "bool" -> print_string "B"
                | "string" -> print_string "[Ljava/lang/String;"
                | "float64" -> print_string "F"
                | _ -> print_string "V"
*)
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
        | OperandName(value, _, _) -> print_string ("ldc_"^(search_current_scope value)^"\n")
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
        | Value(value, _, _) -> print_literal value
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
    let string_return_type type_i = match type_i with
        | Primitivetype(value, _) -> match value with
            | "int" -> "I"
            | "rune" -> "C"
            | "bool" -> "B"
            | "string" -> "[Ljava/lang/String;"
            | "float64" -> "F"
            | _ -> "V"
        | _ -> "V"
    in
    let string_method_decl_return_type return_type = match return_type with
        | FuncReturnType(return_type_i, _) -> string_return_type return_type_i
        | Empty -> "V"
    in
    let print_method_decl level func_name signature stmt_list = match signature with
        | FuncSig(FuncParams(func_params, _), return_type, _) ->
            begin
                (* print_identifier_list_with_type func_params; *)
                println_string_with_tab level (Printf.sprintf ".method public %s(%s)%s" func_name "" (string_method_decl_return_type return_type));
                println_string_with_tab (level+1) ".limit stack 99";
                println_string_with_tab (level+1) ".limit locals 99";
(*                 print_method_decl_return_type return_type; *)
                println_string_with_tab (level+1) "return";
                println_string_with_tab level ".end method\n";
            end
    in
    let initialize_variable_default typename = match typename with 
        | Definedtype(Identifier(value, _), _) -> ()
        | Primitivetype(value, _) -> 

           ( match value with
                | "int" -> print_string "iconst_0\n"
                | "rune" -> print_string "iconst_0\n"
                | "bool" -> print_string "iconst_0\n"
                | "string" -> print_string "ldc \"\"\n"
                | "float64" -> print_string "fconst_0\n")

        | Arraytype(len, type_name2, _)-> ()
        | Slicetype(type_name2, _)-> ()
        | Structtype([], _) -> ()
        | Structtype(field_dcl_list, _) -> ()
    in
    let declare_variable_emit typename iden= 
        begin
            initialize_variable_default typename;
            add_variable_to_current_scope (Printf.sprintf "%d" ((!localcount))) iden;
            print_string (Printf.sprintf "istore_%d\n" ((!localcount)));
            localcounter();
        end
    in
    let print_var_decl level decl = match decl with
        | VarSpecWithType(iden_list, typename, exprs, _) -> 
            (match exprs with
                | [] -> 
                    begin
                        print_tab (level);
                        List.map (declare_variable_emit typename) iden_list;
                        print_string "";
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
                print_string_with_tab level "getstatic java/lang/System/out Ljava/io/PrintStream;\n";
                print_expr_list exprs;
                print_string "\n";
                print_string_with_tab level "invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V\n";
            end
        | Println(exprs, _) -> 
            begin
                print_string_with_tab level "getstatic java/lang/System/out Ljava/io/PrintStream;\n";
                print_expr_list exprs;
                print_string "\n";
                print_string_with_tab level "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n";
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
            match func_name with
            | "main" ->
                begin
                    start_scope ();
                    println_string ".method public static main([Ljava/lang/String;)V";
                    println_string_with_tab (level+1) ".limit stack 99";
                    println_string_with_tab (level+1) ".limit locals 99";
                    println_string_with_tab (level+1) ("new "^(filename)^"");
                    println_string_with_tab (level+1) "dup";
                    println_string_with_tab (level+1) ("invokespecial "^(filename)^"/<init>()V\n");
                    print_stmt_list (level+1) stmt_list;
                    println_string "";
                    println_string_with_tab (level+1) "return";
                    println_string ".end method";
                end
            | _ -> print_method_decl level func_name signature stmt_list
        | _ -> ()
    and print_decl_list level decl_list = 
        List.iter (print_decl level) decl_list
    in
    print_class_header filename;
    print_init_header 1;
    print_decl_list 0 decl_list;
    close_out output_file
