(* The type of tokens. *)
type token = 
  | STRINGVAR of (string)
  | INTLITERAL of (int)
  | FLOATLITERAL of (float)
  | EOL

(* This exception is raised by the monolithic API functions. *)
exception Error

(* The monolithic API. *)
val main: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (unit)

