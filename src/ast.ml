exception AST_error of string

let ast_error msg = raise (AST_error msg)

type identifier =
	| Identifier of string
type literal =
	| Intliteral of int
	| Floatliteral of float 
	| Runeliteral of char (*Not sure about this*)
	| Stringliteral of string 

type type_i =
	| Definedtype of identifier
	| Primitivetype of string (*can accept INT, RUNE, BOOL, STRING, FLOAT64, *)
	| Arraytype of int * type_i
	| Slicetype of type_i
	| Structtype of (identifier list * type_i) list


type expression = 
	| OperandName of string
	| AndAndOp of expression * expression
	| OrOrOp of expression * expression
	| EqualEqualCmp of expression * expression
	| NotEqualCmp of expression * expression
	| LessThanCmp of expression * expression
	| GreaterThanCmp of expression * expression
	| LessThanOrEqualCmp of expression * expression
	| GreaterThanOrEqualCmp of expression * expression
	| AddOp of expression * expression
	| MinusOp of expression * expression
	| OrOp of expression * expression
	| CaretOp of expression * expression
	| MulOp of expression * expression
	| DivOp of expression * expression
	| ModuloOp of expression * expression
	| SrOp of expression * expression
	| SlOp of expression * expression
	| AndOp of expression * expression
	| AndCaretOp of expression * expression
	| OperandParenthesis of expression
	| Indexexpr of expression * expression
	| Unaryexpr of expression
	| Binaryexpr of expression
	| Sliceexpr of expression * expression * expression * expression (*May be we have to break it down to 6 cases if we cant pass null values*)
	| FuncCallExpr of identifier * expression list (*needs to be revised*)
	| UnaryPlus of expression
	| UnaryMinus of expression
	| UnaryNot of expression
	| UnaryCaret of expression
	| Value of literal
	| Selectorexpr of expression * identifier
	| TypeCastExpr of type_i * expression
	| Appendexpr of identifier * expression



(* type topleveldcl = 
	| Functiondcl of 
	| Variabledcl of 
	| Typedcl of 

type package =
	| Packagename of string

type prog = Prog of package * topleveldcl list *)