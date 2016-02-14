(* The type of tokens. *)
type token = 
  | VAR
  | TYPE
  | TRIPLE_DOT
  | SWITCH
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
  | SELECT
  | RETURN
  | RANGE
  | PLUS_EQ
  | PLUS
  | PERCENT_EQ
  | PERCENT
  | PACKAGE
  | OPEN_SQR_BRACKET
  | OPEN_PAREN
  | OPEN_CUR_BRACKET
  | NOT_EQ
  | NOT
  | MINUS_EQ
  | MINUS
  | MAP
  | LT_MINUS
  | LT_EQ
  | LT
  | INTLITERAL of (int)
  | INTERFACE
  | IMPORT
  | IF
  | IDENTIFIER
  | GT_EQ
  | GT
  | GOTO
  | GO
  | FUNC
  | FOR
  | FLOATLITERAL of (float)
  | FALLTHROUGH
  | EQ
  | EOL
  | ELSE
  | DOUBLE_PLUS
  | DOUBLE_MINUS
  | DOUBLE_EQ
  | DOUBLE_BAR
  | DOUBLE_AND
  | DOT
  | DEFER
  | DEFAULT
  | CONTINUE
  | CONST
  | COMMA
  | COLON_EQ
  | COLON
  | CLOSE_SQR_BRACKET
  | CLOSE_PAREN
  | CLOSE_CUR_BRACKET
  | CHAN
  | CASE
  | CARET_EQ
  | CARET
  | BREAK
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

