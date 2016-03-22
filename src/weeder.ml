open Ast

let weed_literal lit = match lit with
    | Intliteral(value,linenum) -> ""
    | Floatliteral(value,linenum) -> ""
    | Runeliteral(value,linenum) -> ""
    | Stringliteral(value,linenum) -> ""

let rec weed_type_name type_name = match type_name with
    | Definedtype(Identifier(value,linenum1),linenum2) -> ""
    | Primitivetype(value,linenum) -> "" 
    | Arraytype(len, type_name2,linenum) -> ""
    | Slicetype(type_name2,linenum) -> ""
    | Structtype(field_dcl_list,linenum) -> ""
                                                                                  
let rec weed_identifiers_with_type idenlist = match idenlist with
    | [] -> ""
    | TypeSpec(Identifier(value,linenum1),return_type,linenum)::[] -> ""
    | TypeSpec(Identifier(value,linenum1),return_type,linenum)::tail -> ""

let weed_type_declaration decl = match decl with
    | TypeSpec(Identifier(value,linenum1), typename,linenum2) -> ""
                                
let rec weed_expression exp = match exp with
    | OperandName(value,linenum,ast_type) -> value
    | AndAndOp(exp1,exp2,linenum,ast_type) -> ""
    | OrOrOp(exp1,exp2,linenum,ast_type) -> ""
    | EqualEqualCmp(exp1,exp2,linenum,ast_type) -> ""
    | NotEqualCmp(exp1,exp2,linenum,ast_type) -> ""
    | LessThanCmp(exp1,exp2,linenum,ast_type) -> ""
    | GreaterThanCmp (exp1,exp2,linenum,ast_type) -> ""
    | LessThanOrEqualCmp(exp1,exp2,linenum,ast_type) -> ""
    | GreaterThanOrEqualCmp(exp1,exp2,linenum,ast_type) -> ""
    | AddOp(exp1,exp2,linenum,ast_type) -> ""
    | MinusOp(exp1,exp2,linenum,ast_type) -> ""
    | OrOp (exp1,exp2,linenum,ast_type) -> ""
    | CaretOp (exp1,exp2,linenum,ast_type) -> ""
    | MulOp (exp1,exp2,linenum,ast_type) -> ""
    | DivOp (exp1,exp2,linenum,ast_type) -> ""
    | ModuloOp (exp1,exp2,linenum,ast_type) -> ""
    | SrOp (exp1,exp2,linenum,ast_type) -> ""
    | SlOp (exp1,exp2,linenum,ast_type) -> ""
    | AndOp (exp1,exp2,linenum,ast_type) -> ""
    | AndCaretOp (exp1,exp2,linenum,ast_type) -> ""
    | OperandParenthesis (exp1,linenum,ast_type) -> ""
    | Indexexpr(exp1,exp2,linenum,ast_type) -> ""
    | Unaryexpr(exp1,linenum,ast_type) -> ""
    | Binaryexpr(exp1,linenum,ast_type) -> ""
    | FuncCallExpr(expr,exprs,linenum,ast_type) -> ""
    | UnaryPlus(exp1,linenum,ast_type) -> ""
    | UnaryMinus(exp1,linenum,ast_type) -> ""
    | UnaryNot(exp1,linenum,ast_type) -> ""
    | UnaryCaret(exp1,linenum,ast_type) -> ""
    | Value(value,linenum,ast_type) -> ""
    | Selectorexpr(exp1,Identifier(iden,linenum1),linenum2,ast_type) -> ""
    | TypeCastExpr (typename,exp1,linenum,ast_type) -> ""
    | Appendexpr (Identifier(iden,linenum1),exp1,linenum2,ast_type) -> ""

let weed_func_return stmts = ()

let rec weed_expressions exprlist = match exprlist with
    | head::[] -> ""
    | head::tail -> ""

let weed_variable_declaration decl = match decl with
    | VarSpecWithType (iden_list,typename,exprs,linenum) -> ""
    | VarSpecWithoutType (iden_list,exprs,linenum) -> ""

let rec weed_stmts stmts case = match stmts with
    | [] -> ""
    | head::[] -> weed_stmt head case
    | head::tail -> let _ = weed_stmt head case in weed_stmts tail case
and weed_stmts_without_break_continue stmts case = match stmts with
    | [] -> ""
    | Break(linenum)::tail ->  ast_error "Break statement outside a loop"
    | Continue(linenum)::tail ->  ast_error "Continue statement outside a loop"
    | head::[] -> weed_stmt head case
    | head::tail -> let _ = weed_stmt head case in weed_stmts_without_break_continue tail case
and weed_stmts_without_continue stmts case = match stmts with
    | [] -> ""
    | Continue(linenum)::tail ->  ast_error "Continue statement outside a loop"
    | head::[] -> weed_stmt head case
    | head::tail -> let _ = weed_stmt head case in weed_stmts_without_continue tail case
and weed_stmt stmt case =
    match stmt with
    | Declaration(dcl,linenum) -> ""
    | Return(rt_stmt,linenum) -> ""
    | Break(linenum) -> ""
    | Continue(linenum) -> ""
    | Block(stmt_list,linenum) -> (match case with
        | "withoutcontinue" -> weed_stmts_without_continue stmt_list case
        | "withoutbreakandcontinue" -> weed_stmts_without_break_continue stmt_list case
        | _ -> weed_stmts stmt_list case)
    | Conditional(conditional,linenum) -> weed_conditional conditional case
    | Switch(switch_clause, switch_expr, switch_case_stmts,linenum) -> 
    (match case with
        | "withoutcontinue" -> weed_switch_case_stmt switch_case_stmts case
        | "withoutbreakandcontinue" -> weed_switch_case_stmt switch_case_stmts "withoutcontinue"
        | _ ->  weed_switch_case_stmt switch_case_stmts "withbreakandcontinue") 
    | For(for_stmt,linenum) -> ""
    | Simple(simple,linenum) -> weed_simple_stmt simple
    | Print(exprs,linenum) -> ""
    | Println(exprs,linenum) -> ""
and weed_return_stmt stmt = match stmt with
    | Empty -> ""
    | ReturnStatement(expr,linenum) -> ""
and weed_conditional cond case = match cond with 
    | IfStmt(if_stmt,linenum) -> weed_if_stmt if_stmt case
    | ElseStmt(else_stmt,linenum) -> weed_else_stmt else_stmt case
and weed_if_stmt if_stmt case = match if_stmt with
    | IfInit(if_init, condition, stmts,linenum) -> (match case with
        | "withoutcontinue" -> weed_stmts_without_continue stmts case
        | "withoutbreakandcontinue" -> weed_stmts_without_break_continue stmts case
        | _ -> weed_stmts stmts case)
and weed_if_init if_init = match if_init with
    | IfInitSimple(simplestmt,linenum) -> ""
    | Empty -> ""
and weed_simple_stmt stmt = match stmt with 
    | SimpleExpression(expr,linenum) -> ""
    | IncDec(incdec,linenum) -> weed_inc_dec_stmt incdec
    | Assignment(assignment_stmt,linenum) -> weed_assignment_stmt assignment_stmt
    | ShortVardecl(short_var_decl,linenum) -> ""
    | Empty -> ""
and weed_condition cond = match cond with 
    | ConditionExpression (expr,linenum) -> ""
    | Empty -> ""
and weed_else_stmt stmt case = match stmt with 
    | ElseSingle(if_stmt,stmts,linenum) -> (match case with
        | "withoutcontinue" -> weed_stmts_without_continue stmts case
        | "withoutbreakandcontinue" -> weed_stmts_without_break_continue stmts case
        | _ -> weed_stmts stmts case)
    | ElseIFMultiple(if_stmt,else_stmt,linenum) -> let _=(weed_if_stmt if_stmt case) in weed_else_stmt else_stmt case
    | ElseIFSingle(if_stmt1,if_stmt2,linenum) -> let _=(weed_if_stmt if_stmt1 case) in weed_if_stmt if_stmt2 case
and weed_for_stmt stmt = match stmt with 
    | Forstmt(stmts,linenum) -> ""
    | ForCondition(condition, stmts,linenum) -> ""
    | ForClause (for_clause, stmts,linenum) -> ""
and weed_clause clause= match clause with 
    | ForClauseCond(simple1,condition,simple2,linenum) -> ""
and weed_switch_clause clause = match clause with
    | SwitchClause(simple_stmt,linenum) -> ""
    | Empty -> ""
and weed_switch_expression expr = match expr with 
    | SwitchExpr(expr,linenum) -> ""
    | Empty -> ""
and count_switch_case_defaults switchcaseclauses count= match switchcaseclauses with
    | [] -> if count>1 then ast_error "more than one default case" else count
    | SwitchCaseClause(exprs, stmts,linenum)::tail -> (match exprs with
        | []->  count_switch_case_defaults tail (count+1)
        | head::tail2 -> count_switch_case_defaults tail count
        )
    | Empty::tail -> count_switch_case_defaults tail count
and weed_switch_case_clause case clause = match clause with 
    | SwitchCaseClause(exprs, stmts,linenum) -> (match case with
        | "withoutcontinue" -> weed_stmts_without_continue stmts case
        | "withoutbreakandcontinue" -> weed_stmts_without_break_continue stmts case
        | _ -> weed_stmts stmts case)
    | Empty -> ""   

and weed_switch_case_stmt stmts case= match stmts with
    | SwitchCasestmt(switch_case_clauses,linenum) -> 
        let defaults_count= count_switch_case_defaults switch_case_clauses 0 in 
        let _ = (List.map (weed_switch_case_clause case) switch_case_clauses ) in ""

and lvalue_eval expr = match expr with 
    | OperandName(iden,linenum,ast_type) -> ""
    | Indexexpr(expr1,expr2,linenum,ast_type) -> ""
    (* | FuncCallExpr(expr,exprs) -> ""
    | Appendexpr (Identifier(iden),exp1) -> "" *)
    | Selectorexpr(exp1,Identifier(iden,linenum1),linenum2,ast_type) -> ""
    | _ -> ast_error "Lvalue error"
and weed_inc_dec_stmt stmt = match stmt with 
    | Increment(expr,linenum) ->  let _= ( lvalue_eval expr) in ""
    | Decrement(expr,linenum) ->  let _= ( lvalue_eval expr) in ""

and weed_assignment_stmt stmt = match stmt with 
    | AssignmentBare(exprs1,exprs2,linenum) -> let _= (List.map lvalue_eval exprs1) in ""
    | AssignmentOp(exprs1, assign_op, exprs2,linenum) -> lvalue_eval exprs1

and weed_short_var_decl dcl = match dcl with
    | ShortVarDecl(idens, exprs,linenum) -> ""

and weed_declaration decl = match decl with 
    | TypeDcl(value,linenum) -> List.map weed_type_declaration value
    | VarDcl(value,linenum) -> List.map weed_variable_declaration value
    | Function(func_name,signature,stmts,linenum) -> weed_function_declaration func_name signature stmts

and weed_signature_return_type return_type = match return_type with
    | FuncReturnType(return_type_i,linenum) -> ""
    | Empty -> ""

and weed_signature signature = match signature with
    FuncSig(FuncParams(func_params,linenum1), return_type,linenum2) -> ""

and weed_function_declaration func_name signature stmts =
    begin
        (weed_stmts stmts "withoutbreakandcontinue")::[];
    end
    
let weed program = match program with
    | Prog(packagename,dcllist) -> List.map weed_declaration dcllist
