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

	and 
	symTable = 
	| Scope of (string , symType) Hashtbl.t