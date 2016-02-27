exception AST_error of string

let ast_error msg = raise (AST_error msg)


type func_return = 
    | FuncReturnType of type_i
    | Empty
    and    
    func_params = 
    | FuncParams of typespec list
    and
    func_signature = 
    | FuncSig of func_params * func_return
    and
    switch_clause = 
    | SwitchClause of simple
    | Empty
    and
    switch_expr = 
    | SwitchExpr of expression
    | Empty
    and
    switch_case_clause = 
    | SwitchCaseClause of expression list * stmt list
    | Empty
    and
    switch_case_stmt =
    | SwitchCasestmt of switch_case_clause list
    and
    incdec = 
    | Increment of expression
    | Decrement of expression
    and
    assignment = 
    | AssignmentBare of expression list * expression list
    | AssignmentOp of expression * string * expression
    and
    short_var_decl = 
    | ShortVarDecl of identifier list * expression list
    and
    simple = 
    | Empty
    | SimpleExpression of expression
    | IncDec of incdec
    | Assignment of assignment
    | ShortVardecl of short_var_decl
    and
    condition = 
    | Empty
    | ConditionExpression of expression 
    and
    for_clause = 
    | ForClauseCond of simple * condition * simple
    and
    for_stmt = 
    | Forstmt of stmt list
    | ForCondition of condition * stmt list
    | ForClause of for_clause * stmt list
    and
    else_stmt = 
    | ElseSingle of if_stmt * stmt list
    | ElseIFMultiple of if_stmt * else_stmt
    | ElseIFSingle of if_stmt * if_stmt
    and
    if_init = 
    | Empty
    | IfInitSimple of simple
    and
    if_stmt = 
    | IfInit of if_init * condition * stmt list
    and
    conditional = 
    | IfStmt of if_stmt
    | ElseStmt of else_stmt
    and
    rt_stmt = 
    | ReturnStatement of expression
    | Empty
    and
    stmt = 
    | Declaration of dcl 
    | Return of rt_stmt
    | Break 
    | Continue 
    | Block of stmt list
    | Conditional of conditional
    | Switch of switch_clause * switch_expr * switch_case_stmt
    | For of for_stmt
    | Simple of simple 
    | Print of expression list
    | Println of expression list
    and
    identifier =
	| Identifier of string
    and
    literal =
	| Intliteral of int
	| Floatliteral of float 
	| Runeliteral of char (*Not sure about this*)
	| Stringliteral of string 
    and
    type_i =
	| Definedtype of identifier
	| Primitivetype of string (*can accept INT, RUNE, BOOL, STRING, FLOAT64, *)
	| Arraytype of int * type_i
	| Slicetype of type_i
	| Structtype of (identifier list * type_i) list
    and
    expression = 
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
	| FuncCallExpr of identifier * expression list (*needs to be revised*)
	| UnaryPlus of expression
	| UnaryMinus of expression
	| UnaryNot of expression
	| UnaryCaret of expression
	| Value of literal
	| Selectorexpr of expression * identifier
	| TypeCastExpr of type_i * expression
	| Appendexpr of identifier * expression
    and
    variablespec = 
	| VarSpecWithType of identifier list * type_i * expression list
	| VarSpecWithoutType of identifier list * expression list	
    and
    typespec =
	| TypeSpec of identifier * type_i
    and
    dcl =
	| TypeDcl of typespec list
	| VarDcl of variablespec list
	| Function of string * func_signature * stmt list
    and
    prog = 
    | Prog of string * dcl list
