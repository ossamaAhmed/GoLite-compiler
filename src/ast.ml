exception AST_error of string

let ast_error msg = raise (AST_error msg)

type varspec = 
    | Identifierlist of identifier list * type_i * expression list
    and
    variable_declaration =
    | Varspec of varspec
    | Varspeclist of varspec list
    and
    block = 
    | Stmt_list of stmt list
    and
    result = 
    | Emtpy
    | Result of type_i
    and    
    params = 
    | ParamDeclaration of identifier list * type_i
    and
    func_params = 
    | FuncParams of params list
    | Empty
    and
    function_signature = 
    | Signature of func_params * result
    and
    func_signature = 
    | FunctionSignature of func_params * result
    and
    function_def = 
    | Function of func_signature * block
    and
    function_declaration = 
    | Functiondef of identifier * function_def
    | Functionsig of identifier * func_signature
    and
    declaration =
    | VariableDecl of variable_declaration
    | FunctionDecl of function_declaration
    and
    switch_clause = 
    | SwitchClause of simple
    | Empty
    and
    switch_expr = 
    | SwitchExpr of expression
    | Empty
    and
    switch_case = 
    | Empty
    | SwitchCase of expression list
    and
    switch_case_clause = 
    | SwitchCaseClause of switch_case * stmt list
    | Empty
    and
    switch_case_block =
    | SwitchCaseBlock of switch_case_clause list
    and
    switch = 
    | SwitchClauseExpr of switch_clause * switch_expr * switch_case_block
    | SwitchClasue of switch_clause * switch_case_block
    | SwitchExpr of switch_expr * switch_case_block
    | SwitchBare of switch_case_block
    and
    incdec = 
    | Increment of expression
    | Decrement of expression
    and
    assign_op = 
    | AssignmentOP of sting
    and 
    assignment = 
    | AssignmentBare of expression list * expression list
    | AssignmentOp of expression * assign_op * expression
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
    | ForClauseCond of simple *condition *simple
    and
    for_stmt = 
    | ForBlock of block
    | ForCondition of condition * block
    | ForClause of for_clause * block
    and
    else_stmt = 
    | ElseSingle of if_stmt * block
    | ElseIFMultitple of if_stmt * else_stmt
    | ElseIFSingle of if_stmt * if_stmt
    and
    if_init = 
    | IfInitSimple of simple
    and
    if_stmt = 
    | IfInit of if_init * condition * block
    | IfNoInit of condition * block
    and
    conditional = 
    | IfStmt of if_stmt
    | ElseStmt of else_stmt
    and
    func_args = 
    | Empty
    | FunctionArgs of expression list
    and
    function_call = 
    | FunctionCallExpr of identifier * func_args
    and
    rt_stmt = 
    |Empty
    | ReturnStatement of expression 
    and
    println_stmt =
    | PrintlnStatement of expression list
    and
    print_stmt =
    | PrintStatement of expression list
    and
     stmt = 
    | Declaration of declaration 
    | Ret of rt_stmt
    | Break 
    | Continue 
    | Block of block
    | Conditional of conditional
    | Switch of switch
    | For of for_stmt
    | Simple of simple 
    | Print of print_stmt
    | Println of println_stmt
    | FunctionCall of function_call
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
	| FuncDcl of string (*TEMPORARY*)
    and
    prog = 
    |Prog of string * dcl list