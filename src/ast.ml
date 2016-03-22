exception AST_error of string

let ast_error msg = raise (AST_error msg)


type func_return = 
    | FuncReturnType of type_i * int
    | Empty
    and    
    func_params = 
    | FuncParams of typespec list * int
    and
    func_signature = 
    | FuncSig of func_params * func_return * int
    and
    switch_clause = 
    | SwitchClause of simple * int
    | Empty
    and
    switch_expr = 
    | SwitchExpr of expression * int
    | Empty
    and
    switch_case_clause = 
    | SwitchCaseClause of expression list * stmt list * int
    | Empty
    and
    switch_case_stmt =
    | SwitchCasestmt of switch_case_clause list * int
    and
    incdec = 
    | Increment of expression * int
    | Decrement of expression * int
    and
    assignment = 
    | AssignmentBare of expression list * expression list * int
    | AssignmentOp of expression * string * expression * int
    and
    short_var_decl = 
    | ShortVarDecl of identifier list * expression list * int
    and
    simple = 
    | Empty
    | SimpleExpression of expression * int
    | IncDec of incdec * int
    | Assignment of assignment * int
    | ShortVardecl of short_var_decl * int
    and
    condition = 
    | Empty
    | ConditionExpression of expression * int
    and
    for_clause = 
    | ForClauseCond of simple * condition * simple * int
    and
    for_stmt = 
    | Forstmt of stmt list * int
    | ForCondition of condition * stmt list * int
    | ForClause of for_clause * stmt list * int
    and
    else_stmt = 
    | ElseSingle of if_stmt * stmt list * int
    | ElseIFMultiple of if_stmt * else_stmt * int
    | ElseIFSingle of if_stmt * if_stmt * int
    and
    if_init = 
    | Empty
    | IfInitSimple of simple * int
    and
    if_stmt = 
    | IfInit of if_init * condition * stmt list * int
    and
    conditional = 
    | IfStmt of if_stmt * int
    | ElseStmt of else_stmt * int
    and
    rt_stmt = 
    | ReturnStatement of expression * int
    | Empty
    and
    stmt = 
    | Declaration of dcl  * int
    | Return of rt_stmt * int
    | Break of int
    | Continue of int
    | Block of stmt list * int
    | Conditional of conditional * int
    | Switch of switch_clause * switch_expr * switch_case_stmt * int
    | For of for_stmt * int
    | Simple of simple * int
    | Print of expression list * int
    | Println of expression list * int
    and
    identifier =
	| Identifier of string * int
    and
    literal =
	| Intliteral of int * int
	| Floatliteral of float * int
	| Runeliteral of string * int
	| Stringliteral of string * int 
    and
    type_i =
	| Definedtype of identifier * int
	| Primitivetype of string * int(*can accept INT, RUNE, BOOL, STRING, FLOAT64, *)
	| Arraytype of int * type_i* int
	| Slicetype of type_i* int
	| Structtype of (identifier list * type_i) list* int
    and
    expression = 
	| OperandName of string* int
	| AndAndOp of expression * expression* int
	| OrOrOp of expression * expression* int
	| EqualEqualCmp of expression * expression* int
	| NotEqualCmp of expression * expression* int
	| LessThanCmp of expression * expression* int
	| GreaterThanCmp of expression * expression* int
	| LessThanOrEqualCmp of expression * expression* int
	| GreaterThanOrEqualCmp of expression * expression* int
	| AddOp of expression * expression* int
	| MinusOp of expression * expression* int
	| OrOp of expression * expression* int
	| CaretOp of expression * expression* int
	| MulOp of expression * expression* int
	| DivOp of expression * expression* int
	| ModuloOp of expression * expression* int
	| SrOp of expression * expression* int
	| SlOp of expression * expression * int
	| AndOp of expression * expression * int
	| AndCaretOp of expression * expression * int
	| OperandParenthesis of expression* int
	| Indexexpr of expression * expression * int
	| Unaryexpr of expression * int
	| Binaryexpr of expression * int
	| FuncCallExpr of expression * expression list * int(*needs to be revised*)
	| UnaryPlus of expression * int
	| UnaryMinus of expression * int
	| UnaryNot of expression * int
	| UnaryCaret of expression * int
	| Value of literal * int
	| Selectorexpr of expression * identifier * int
	| TypeCastExpr of type_i * expression * int
	| Appendexpr of identifier * expression * int
    and
    variablespec = 
	| VarSpecWithType of identifier list * type_i * expression list * int
	| VarSpecWithoutType of identifier list * expression list * int
    and
    typespec =
	| TypeSpec of identifier * type_i * int
    and
    dcl =
	| TypeDcl of typespec list * int
	| VarDcl of variablespec list * int
	| Function of string * func_signature * stmt list * int
    and
    prog = 
    | Prog of string * dcl list 
