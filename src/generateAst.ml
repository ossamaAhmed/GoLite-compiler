open Printf
open Ast


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
let generate_type_assertion_expr identifier typename= Typeassertionexpr(identifier, typename)
let generate_slice_expr exp1 exp2 exp3 exp4 = Sliceexpr(exp1, exp2, exp3, exp4)
let generate_arguments_expr typename expressions = Argumentsexpr(typename, expressions)
let generate_index_expr expr1 expr2 = Indexexpr (expr1, expr2)
let generate_parathesis_expression exp = OperandParenthesis(exp)

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



