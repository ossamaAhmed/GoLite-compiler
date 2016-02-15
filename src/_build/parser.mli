(* The type of tokens. *)
type token = 
  | VAR
  | TYPE
  | TRIPLE_DOT
  | SWITCH
  | STRUCT
  | STRINGVAR of (string)
  | STRINGLITERAL of (string)
  | STRING
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
  | RUNE
  | RETURN
  | RANGE
  | PRINTLN
  | PRINT
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
  | INT
  | IMPORT
  | IF
  | IDENTIFIER of (string)
  | GT_EQ
  | GT
  | GOTO
  | GO
  | FUNC
  | FOR
  | FLOATLITERAL of (float)
  | FLOAT64
  | FALLTHROUGH
  | EQ
  | EOL
  | EOF
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
  | BOOL
  | BAR_EQ
  | BAR
  | APPEND
  | AND_EQ
  | AND_CARET_EQ
  | AND_CARET
  | AND

(* This exception is raised by the monolithic API functions. *)
exception Error

(* The monolithic API. *)
val sourcefile: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (unit)

