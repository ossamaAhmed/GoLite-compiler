open Ast

(* Traverse Tree and apply weeder rules *)
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
