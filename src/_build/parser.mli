(* The type of tokens. *)
type token = 
  | TRIPLE_DOT
  | STRINGVAR of (string)
  | STAR_EQ
  | STAR
  | SLASH_EQ
  | SLASH
  | SHIFT_RIGHT_EQ
  | SHIFT_RIGHT
  | SHIFT_LEFT_EQ
  | SHIFT_LEFT
  | SEMICOLON
  | PLUS_EQ
  | PLUS
  | PERCENT_EQ
  | PERCENT
  | OPEN_SQR_BRACKET
  | OPEN_PAREN
  | OPEN_CUR_BRACKET
  | NOT_EQ
  | NOT
  | MINUS_EQ
  | MINUS
  | LT_MINUS
  | LT_EQ
  | LT
  | INTLITERAL of (int)
  | GT_EQ
  | GT
  | FLOATLITERAL of (float)
  | EQ
  | EOL
  | DOUBLE_PLUS
  | DOUBLE_MINUS
  | DOUBLE_EQ
  | DOUBLE_BAR
  | DOUBLE_AND
  | DOT
  | COMMA
  | COLON_EQ
  | COLON
  | CLOSE_SQR_BRACKET
  | CLOSE_PAREN
  | CLOSE_CUR_BRACKET
  | CARET_EQ
  | CARET
  | BAR_EQ
  | BAR
  | AND_EQ
  | AND_CARET_EQ
  | AND_CARET
  | AND

(* This exception is raised by the monolithic API functions. *)
exception Error

(* The monolithic API. *)
val main: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (unit)

