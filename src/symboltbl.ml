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

	and 
	symTable = 
	| Scope of (string , symType) Hashtbl.t