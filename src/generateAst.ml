open Ast

let generate_switch switchClause switchExpr switchCase = Switch(switchClause,switchExpr,switchCase)

let generate_func_sig f1 f2 = FuncSig(f1,f2)

let generate_switch_clause simple = SwitchClause(simple)
let generate_switch_expr exp = SwitchExpr(exp)

let generate_switch_case_clause expList stmtList = SwitchCaseClause(expList,stmtList)
let generate_switch_case_block clauseList = SwitchCasestmt(clauseList)
let generate_inc exp = Increment(exp)
let generate_dec exp = Decrement(exp)

let generate_assign_bare expl1 expl2 = AssignmentBare(expl1,expl2)
let generate_assign_op exp1 op exp2 = AssignmentOp(exp1,op,exp2)

let generate_simple_exp exp = SimpleExpression(exp)
let generate_simple_incdec incdec = IncDec(incdec)
let generate_simple_assignment assi = Assignment(assi)
let generate_simple_shortvardecl svd = ShortVardecl(svd)

let generate_condition exp = ConditionExpression(exp)

let generate_for_stmt f = For(f)
let generate_for_block stmtlst = Forstmt(stmtlst)
let generate_for_cond_block cond stmtlst = ForCondition(cond,stmtlst)
let generate_for_clause_block clause stmtlst = ForClause(clause,stmtlst)

let generate_for_clause simple1 cond simple2 = ForClauseCond(simple1,cond,simple2)

let generate_if_stmt ifinit cond stmtlst = IfInit(ifinit,cond,stmtlst)
let generate_if_init simple = IfInitSimple(simple)

let generate_conditional_if ifstmt = IfStmt(ifstmt)
let generate_conditional_else elsestmt = ElseStmt(elsestmt)

let generate_else_single ifstmt stmtlst = ElseSingle(ifstmt,stmtlst)
let generate_else_multiple ifstmt elsestmt = ElseIFMultiple(ifstmt,elsestmt)
let generate_else_if if1 if2 = ElseIFSingle(if1,if2)
let generate_return exp = ReturnStatement(exp)

let generate_symbol identifier = Identifier(identifier)
let generate_operator identifier = OperandName(identifier)
let generate_integer  literal =  Value(Intliteral(literal))
let generate_float  literal =   Value(Floatliteral(literal))
let generate_string  literal =  Value(Stringliteral(literal))
let generate_rune  literal =  Value(Runeliteral(literal))

let generate_defined_type identifier = Definedtype(Identifier(identifier))
let generate_primitive_type typename = Primitivetype(typename)
let generate_array_type len typedef = Arraytype(len, typedef)
let generate_slice_type typedef = Slicetype(typedef)
let generate_struct_type fieldslist = Structtype(fieldslist)
let generate_selector_expr exp identifier = Selectorexpr(exp, identifier)
let generate_type_casting_expr typename expr= TypeCastExpr(typename, expr)
let generate_func_expr identifier expressions = FuncCallExpr(identifier, expressions)
let generate_index_expr expr1 expr2 = Indexexpr (expr1, expr2)
let generate_parathesis_expression exp = OperandParenthesis(exp)
let generate_append_expression identifier exp = Appendexpr (identifier, exp)
let generate_variable_with_type_spec identifiers typename expressions = VarSpecWithType(identifiers,typename,expressions)
let generate_variable_without_type_spec identifiers expressions = VarSpecWithoutType(identifiers,expressions)
let generate_variable_decl varspecs = VarDcl(varspecs)
let generate_type_spec identifier typename = TypeSpec(identifier, typename)
let generate_type_decl typespecs = TypeDcl(typespecs)
let generate_func_decl funcname = FuncDcl(funcname)  (*TEMPORARY*)

let generate_println expressions = Println(expressions)
let generate_print expressions = Print(expressions)
let generate_simple_stmt stmt = Simple(stmt)
let generate_conditional_stmt stmt = Conditional(stmt)
let generate_block_stmt stmt = Block(stmt)
let generate_unary_expression op exp = match op with 
									| '-' -> Unaryexpr(UnaryMinus(exp))
									| '+' -> Unaryexpr(UnaryPlus(exp))
									| '^' -> Unaryexpr(UnaryCaret(exp))
									| '!' -> Unaryexpr(UnaryNot(exp))
let generate_bin_expression op exp1 exp2 = match op with
									| "&&" -> Binaryexpr(AndAndOp(exp1,exp2))
									| "||" -> Binaryexpr(OrOrOp (exp1,exp2))
									| "==" -> Binaryexpr(EqualEqualCmp(exp1,exp2))
									| "!=" -> Binaryexpr(NotEqualCmp(exp1,exp2))
									| "<" -> Binaryexpr(LessThanCmp(exp1,exp2))
									| ">" -> Binaryexpr(GreaterThanCmp(exp1,exp2))
									| "<=" -> Binaryexpr(LessThanCmp(exp1,exp2))
									| ">=" -> Binaryexpr(GreaterThanOrEqualCmp(exp1,exp2))
									| "+" -> Binaryexpr(AddOp(exp1,exp2))
									| "-" ->Binaryexpr(MinusOp(exp1,exp2))
									| "|" -> Binaryexpr(OrOp(exp1,exp2))
									| "^" -> Binaryexpr(CaretOp(exp1,exp2))
									| "*" -> Binaryexpr(MulOp(exp1,exp2))
									| "/" -> Binaryexpr(DivOp(exp1,exp2))
									| "%" -> Binaryexpr(ModuloOp(exp1,exp2))
									| ">>" -> Binaryexpr(SrOp(exp1,exp2))
									| "<<" -> Binaryexpr(SlOp(exp1,exp2))
									| "&" -> Binaryexpr(AndOp(exp1,exp2))
									| "&^" ->Binaryexpr(AndCaretOp(exp1,exp2))

let generate_program packagename dcls = Prog(packagename,dcls)


