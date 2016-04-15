let dumpsymtab = ref false

type symType =
	| SymInt 
	| SymFloat64
	| SymRune
	| SymString
	| SymBool
	| SymArray of symType
	| SymSlice of symType
	| SymStruct of (string * symType) list
	| SymFunc of symType * (string * symType) list (*resturn, args*)
	| SymType of symType
	| Void
	| VarDeclaredType of symType
	| NotDefined
and symTable = Scope of (string , symType) Hashtbl.t