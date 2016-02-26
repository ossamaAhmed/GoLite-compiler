open Ast

let generate_func_declaration funcSig stmtList = Function(funcSig,stmtList)
let generate_func_params paramsList = FuncParams(paramsList)
let generate_func_signature paramsList result = FunctionSignature(paramsList,result)

let generate_result typeiden = Result(typeiden)
let generate_params paramList typeiden = ParamDeclaration(paramList,typeiden)

let generate_switch switchClause switchExpr switchCase = Switch(switchClause,switchExpr,switchCase)

let generate_switch_clause simple = SwitchClause(simple)
let generate_switch_expr exp = SwitchExpr(exp)

let generate_switch_case_clause expList stmtList = SwitchCaseClause(expList,stmtList)
let generate_switch_case_block clauseList = SwithcCasestmt(clauseList)

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


