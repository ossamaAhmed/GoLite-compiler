open Ast

let generate_switch switchClause switchExpr switchCase linenum= Switch(switchClause,switchExpr,switchCase,linenum)

let generate_switch_clause simple linenum= SwitchClause(simple,linenum)
let generate_switch_expr exp linenum= SwitchExpr(exp,linenum)

let rec generate_type_spec_list identifier_list type_i linenum=
	match identifier_list with
	| x::xs -> TypeSpec(x,type_i,linenum) :: (generate_type_spec_list xs type_i linenum)
	| x::[] -> [TypeSpec(x,type_i,linenum)]
	| [] -> []

let generate_switch_case_clause expList stmtList linenum= SwitchCaseClause(expList,stmtList,linenum)
let generate_switch_case_block clauseList linenum= SwitchCasestmt(clauseList,linenum)
let generate_inc exp linenum= Increment(exp,linenum)
let generate_dec exp linenum= Decrement(exp,linenum)

let generate_assign_bare expl1 expl2 linenum= AssignmentBare(expl1,expl2,linenum)
let generate_assign_op exp1 op exp2 linenum= AssignmentOp(exp1,op,exp2,linenum)

let generate_simple_exp exp linenum= SimpleExpression(exp,linenum)
let generate_simple_incdec incdec linenum= IncDec(incdec,linenum)
let generate_simple_assignment assi linenum= Assignment(assi,linenum)
let generate_simple_shortvardecl svd linenum= ShortVardecl(svd,linenum)

let generate_condition exp linenum= ConditionExpression(exp,linenum)

let generate_for_stmt f linenum= For(f,linenum)
let generate_for_block stmtlst linenum= Forstmt(stmtlst,linenum)
let generate_for_cond_block cond stmtlst linenum= ForCondition(cond,stmtlst,linenum)
let generate_for_clause_block clause stmtlst linenum= ForClause(clause,stmtlst,linenum)

let generate_for_clause simple1 cond simple2 linenum= ForClauseCond(simple1,cond,simple2,linenum)

let generate_if_stmt ifinit cond stmtlst linenum= IfInit(ifinit,cond,stmtlst,linenum)
let generate_if_init simple linenum= IfInitSimple(simple,linenum)

let generate_conditional_if ifstmt linenum= IfStmt(ifstmt,linenum)
let generate_conditional_else elsestmt linenum= ElseStmt(elsestmt,linenum)

let generate_else_single ifstmt stmtlst linenum= ElseSingle(ifstmt,stmtlst,linenum)
let generate_else_multiple ifstmt elsestmt linenum= ElseIFMultiple(ifstmt,elsestmt,linenum)
let generate_else_if if1 if2 linenum= ElseIFSingle(if1,if2,linenum)
let generate_return exp linenum= ReturnStatement(exp,linenum)

let generate_symbol identifier linenum= Identifier(identifier,linenum)
let generate_operator identifier linenum= OperandName(identifier,linenum)
let generate_integer  literal linenum=  Value(Intliteral(literal,linenum),linenum)
let generate_float  literal linenum=   Value(Floatliteral(literal,linenum),linenum)
let generate_string  literal linenum=  Value(Stringliteral(literal,linenum),linenum)
let generate_rune  literal linenum=  Value(Runeliteral(literal,linenum),linenum)

let generate_defined_type identifier linenum= Definedtype(Identifier(identifier,linenum),linenum)
let generate_primitive_type typename linenum= Primitivetype(typename,linenum)
let generate_array_type len typedef linenum= Arraytype(len, typedef,linenum)
let generate_slice_type typedef linenum= Slicetype(typedef,linenum)
let generate_struct_type fieldslist linenum= Structtype(fieldslist,linenum)
let generate_selector_expr exp identifier linenum= Selectorexpr(exp, identifier,linenum)
let generate_type_casting_expr typename expr linenum= TypeCastExpr(typename, expr,linenum)
let generate_func_expr identifier expressions linenum= FuncCallExpr(identifier, expressions,linenum)
let generate_index_expr expr1 expr2 linenum= Indexexpr (expr1, expr2,linenum)
let generate_parathesis_expression exp linenum= OperandParenthesis(exp,linenum)
let generate_append_expression identifier exp linenum= Appendexpr (identifier, exp,linenum)
let generate_variable_with_type_spec identifiers typename expressions linenum= VarSpecWithType(identifiers,typename,expressions,linenum)
let generate_variable_without_type_spec identifiers expressions linenum= VarSpecWithoutType(identifiers,expressions,linenum)
let generate_variable_decl varspecs linenum= VarDcl(varspecs,linenum)
let generate_type_spec identifier typename linenum= TypeSpec(identifier, typename,linenum)
let generate_type_decl typespecs linenum= TypeDcl(typespecs,linenum)

let generate_println expressions linenum= Println(expressions,linenum)
let generate_print expressions linenum= Print(expressions,linenum)
let generate_simple_stmt stmt linenum= Simple(stmt,linenum)
let generate_conditional_stmt stmt linenum= Conditional(stmt,linenum)
let generate_block_stmt stmt linenum= Block(stmt,linenum)
let generate_unary_expression op exp linenum= match op with 
									| '-' -> Unaryexpr(UnaryMinus(exp,linenum),linenum)
									| '+' -> Unaryexpr(UnaryPlus(exp,linenum),linenum)
									| '^' -> Unaryexpr(UnaryCaret(exp,linenum),linenum)
									| '!' -> Unaryexpr(UnaryNot(exp,linenum),linenum)
let generate_bin_expression op exp1 exp2 linenum= match op with
									| "&&" -> Binaryexpr(AndAndOp(exp1,exp2,linenum),linenum)
									| "||" -> Binaryexpr(OrOrOp (exp1,exp2,linenum),linenum)
									| "==" -> Binaryexpr(EqualEqualCmp(exp1,exp2,linenum),linenum)
									| "!=" -> Binaryexpr(NotEqualCmp(exp1,exp2,linenum),linenum)
									| "<" -> Binaryexpr(LessThanCmp(exp1,exp2,linenum),linenum)
									| ">" -> Binaryexpr(GreaterThanCmp(exp1,exp2,linenum),linenum)
									| "<=" -> Binaryexpr(LessThanCmp(exp1,exp2,linenum),linenum)
									| ">=" -> Binaryexpr(GreaterThanOrEqualCmp(exp1,exp2,linenum),linenum)
									| "+" -> Binaryexpr(AddOp(exp1,exp2,linenum),linenum)
									| "-" ->Binaryexpr(MinusOp(exp1,exp2,linenum),linenum)
									| "|" -> Binaryexpr(OrOp(exp1,exp2,linenum),linenum)
									| "^" -> Binaryexpr(CaretOp(exp1,exp2,linenum),linenum)
									| "*" -> Binaryexpr(MulOp(exp1,exp2,linenum),linenum)
									| "/" -> Binaryexpr(DivOp(exp1,exp2,linenum),linenum)
									| "%" -> Binaryexpr(ModuloOp(exp1,exp2,linenum),linenum)
									| ">>" -> Binaryexpr(SrOp(exp1,exp2,linenum),linenum)
									| "<<" -> Binaryexpr(SlOp(exp1,exp2,linenum),linenum)
									| "&" -> Binaryexpr(AndOp(exp1,exp2,linenum),linenum)
									| "&^" ->Binaryexpr(AndCaretOp(exp1,exp2,linenum),linenum)

let generate_program packagename dcls= Prog(packagename,dcls)


