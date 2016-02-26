exception AST_error of string

let ast_error msg = raise (AST_error msg)

type return =
    | EmptyReturn
    | expression list
    and
    varspec = 
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
    and
    function_signature = 
    | Signature of func_params * result
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
    | SwitchClause of simple_stmt
    switch_expr = 
    | SwitchExpr of expression
    and
    switch_case = 
    | Empty
    | SwitchCase of expression list
    and
    switch_case_clause = 
    | SwitchCaseClause of switch_case * stmt list
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
    | Increment expression
    | Decrement expression
    and
    assign_op = 
    | PlusEq
    | StarEq
    and 
    assignment = 
    | AssignmentBare expression list * expression list
    | AssignmentOp expression * assign_op * expression
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
     stmt = 
    | Declaration of declaration 
    | Return of return
    | Break 
    | Continue 
    | Block of block
    | Conditional of conditional
    | Switch of switch
    | For of for_stmt
    | Simple of simple 
    | Print of expression list
    | Println of expression list
    | FunctionCall of function_call

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
