exception AST_error of string

let ast_error msg = raise (AST_error msg)


type field_dcl =
	| Fielddcl of identifier list * type_i
type qualified_identifier=
	| Qulaifiedidentifier of identifier * identifier


type type_name =
	| Qualifiedtypename qualified_identifier
	| Newtypedeclared identifier
type array_type =
	| Arraytype of int * type_i
type struct_type =
	| Structtype of field_dcl list
type slice_type =
	| Slicetype of type_i
type type_i =
	| Definedtype of type_name
	| Primitivetype of string (*can accept INT, RUNE, BOOL, STRING, FLOAT64, *)
	| Arraytypedcl of array_type
	| Slicetypedcl of slice_type
	| Structtypedcl of struct_type

type basic_literal =
	| Intliteral of int
	| Floatliteral of float 
	| Runeliteral of rune (*Not sure about this*)
	| Stringliteral of string 
type operand = 
	| Operandexpr of expression
	| Operandname of type_name (*double check this*)
	| Basicliteral of basic_literal
	| Operandstructtype of struct_type
	| Operandarraytype of array_type
	| Operandslicetype of slice_type

type expression = 
	| Unaryexpr of unaryexpr
	| Binaryexpr of binaryexpr

type unaryexpr = 
	| Unaryop of unaryop
	| Primaryexpr of primaryexpr

type identifier =
	| Identifier of string

type primaryexpr =
	| Operand of operand 
	| Indexexpr of primaryexpr * expression
	| Selectorexpr of primaryexpr * identifier
	| Sliceexpr of primaryexpr * expression * expression * expression (*May be we have to break it down to 6 cases if we cant pass null values*)
	| Typeassertionexpr of primaryexpr * type_i
	| Argumentsexpr of type_i * expression list 
type unaryop =
	| Unaryplus of unaryexpr
	| Unaryminus of unaryexpr
	| Unarynot of unaryexpr
	| Unarycaret of unaryexpr
type binaryexpr =

type topleveldcl = 
	| Functiondcl of 
	| Variabledcl of 
	| Typedcl of 

type package =
	| Packagename of string

type prog = Prog of package * topleveldcl list