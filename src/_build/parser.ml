exception Error

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

and _menhir_env = {
  _menhir_lexer: Lexing.lexbuf -> token;
  _menhir_lexbuf: Lexing.lexbuf;
  mutable _menhir_token: token;
  mutable _menhir_startp: Lexing.position;
  mutable _menhir_endp: Lexing.position;
  mutable _menhir_shifted: int
}

and _menhir_state

  
open Error
let _eRR =
  Error

let rec _menhir_goto_expr : _menhir_env -> 'ttv_tail -> (unit) -> 'ttv_return =
  fun _menhir_env _menhir_stack _v ->
    let _menhir_stack = (_menhir_stack, _v) in
    let _menhir_stack = Obj.magic _menhir_stack in
    assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
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
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        let _menhir_stack = Obj.magic _menhir_stack in
        raise _eRR

and _menhir_discard : _menhir_env -> token =
  fun _menhir_env ->
    let lexbuf = _menhir_env._menhir_lexbuf in
    let _tok = _menhir_env._menhir_lexer lexbuf in
    _menhir_env._menhir_token <- _tok;
    _menhir_env._menhir_startp <- lexbuf.Lexing.lex_start_p;
    _menhir_env._menhir_endp <- lexbuf.Lexing.lex_curr_p;
    let shifted = Pervasives.(+) _menhir_env._menhir_shifted 1 in
    if Pervasives.(>=) shifted 0 then
      _menhir_env._menhir_shifted <- shifted;
    _tok

and main : (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (unit) =
  fun lexer lexbuf ->
    let _menhir_env = let _tok = lexer lexbuf in
    {
      _menhir_lexer = lexer;
      _menhir_lexbuf = lexbuf;
      _menhir_token = _tok;
      _menhir_startp = lexbuf.Lexing.lex_start_p;
      _menhir_endp = lexbuf.Lexing.lex_curr_p;
      _menhir_shifted = max_int;
      } in
    Obj.magic (let _menhir_stack = () in
    assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | FLOATLITERAL _v ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let _ = _menhir_discard _menhir_env in
        let _menhir_stack = Obj.magic _menhir_stack in
        let _v : (unit) =                    (()) in
        _menhir_goto_expr _menhir_env _menhir_stack _v
    | INTLITERAL _v ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let _ = _menhir_discard _menhir_env in
        let _menhir_stack = Obj.magic _menhir_stack in
        let _v : (unit) =                (()) in
        _menhir_goto_expr _menhir_env _menhir_stack _v
    | STRINGVAR _v ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let _ = _menhir_discard _menhir_env in
        let _menhir_stack = Obj.magic _menhir_stack in
        let _v : (unit) =                 (()) in
        _menhir_goto_expr _menhir_env _menhir_stack _v
    | _ ->
        assert (Pervasives.(<>) _menhir_env._menhir_shifted (-1));
        _menhir_env._menhir_shifted <- (-1);
        let _menhir_stack = Obj.magic _menhir_stack in
        raise _eRR)



