exception Error

type token = 
  | VAR
  | TYPE
  | TRIPLE_DOT
  | SWITCH
  | STRINGVAR of (string)
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
  | IDENTIFIER
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

and _menhir_env = {
  _menhir_lexer: Lexing.lexbuf -> token;
  _menhir_lexbuf: Lexing.lexbuf;
  _menhir_token: token;
  mutable _menhir_error: bool
}

and _menhir_state

  
open Error
let _eRR =
  Error

let rec _menhir_goto_expr : _menhir_env -> 'ttv_tail -> (unit) -> 'ttv_return =
  fun _menhir_env _menhir_stack _v ->
    let _menhir_stack = (_menhir_stack, _v) in
    let _menhir_stack = Obj.magic _menhir_stack in
    assert (not _menhir_env._menhir_error);
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | EOL ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _) = _menhir_stack in
        let _v : (unit) =              (()) in
        let _menhir_stack = Obj.magic _menhir_stack in
        let _menhir_stack = Obj.magic _menhir_stack in
        let _1 = _v in
        Obj.magic _1
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let _menhir_stack = Obj.magic _menhir_stack in
        raise _eRR

and _menhir_discard : _menhir_env -> _menhir_env =
  fun _menhir_env ->
    let lexer = _menhir_env._menhir_lexer in
    let lexbuf = _menhir_env._menhir_lexbuf in
    let _tok = lexer lexbuf in
    {
      _menhir_lexer = lexer;
      _menhir_lexbuf = lexbuf;
      _menhir_token = _tok;
      _menhir_error = false;
      }

and main : (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (unit) =
  fun lexer lexbuf ->
    let _menhir_env = let _tok = Obj.magic () in
    {
      _menhir_lexer = lexer;
      _menhir_lexbuf = lexbuf;
      _menhir_token = _tok;
      _menhir_error = false;
      } in
    Obj.magic (let _menhir_stack = () in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | FLOATLITERAL _v ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let _menhir_env = _menhir_discard _menhir_env in
        let _menhir_stack = Obj.magic _menhir_stack in
        let _v : (unit) =                    (()) in
        _menhir_goto_expr _menhir_env _menhir_stack _v
    | INTLITERAL _v ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let _menhir_env = _menhir_discard _menhir_env in
        let _menhir_stack = Obj.magic _menhir_stack in
        let _v : (unit) =                (()) in
        _menhir_goto_expr _menhir_env _menhir_stack _v
    | STRINGVAR _v ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let _menhir_env = _menhir_discard _menhir_env in
        let _menhir_stack = Obj.magic _menhir_stack in
        let _v : (unit) =                 (()) in
        _menhir_goto_expr _menhir_env _menhir_stack _v
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let _menhir_stack = Obj.magic _menhir_stack in
        raise _eRR)



