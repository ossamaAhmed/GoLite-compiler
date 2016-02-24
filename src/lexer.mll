{

open Parser
open Lexing
open Error

(*type token =
    | INTLITERAL of (int)
    | FLOATLITERAL of (float)
    | STRINGLITERAL of (string)
    | IDENTIFIER of (string)
    | RUNELITERAL of (char)
    | PLUS 
    | AND 
    | PLUS_EQ 
    | AND_EQ 
    | DOUBLE_AND 
    | DOUBLE_EQ 
    | NOT_EQ 
    | OPEN_PAREN 
    | CLOSE_PAREN 
    | MINUS 
    | BAR 
    | MINUS_EQ 
    | BAR_EQ 
    | DOUBLE_BAR 
    | LT 
    | LT_EQ 
    | OPEN_SQR_BRACKET 
    | CLOSE_SQR_BRACKET 
    | STAR 
    | CARET 
    | STAR_EQ 
    | CARET_EQ 
    | LT_MINUS 
    | GT 
    | GT_EQ 
    | OPEN_CUR_BRACKET 
    | CLOSE_CUR_BRACKET 
    | SLASH 
    | SHIFT_LEFT 
    | SLASH_EQ 
    | SHIFT_LEFT_EQ 
    | DOUBLE_PLUS 
    | EQ 
    | COLON_EQ 
    | COMMA 
    | SEMICOLON 
    | PERCENT 
    | SHIFT_RIGHT 
    | PERCENT_EQ 
    | SHIFT_RIGHT_EQ 
    | DOUBLE_MINUS 
    | NOT 
    | TRIPLE_DOT 
    | DOT 
    | COLON 
    | AND_CARET 
    | AND_CARET_EQ 
    | BREAK 
    | DEFAULT 
    | FUNC 
    | INTERFACE
    | SELECT
    | CASE
    | DEFER
    | GO
    | MAP
    | CHAN 
    | ELSE
    | GOTO
    | PACKAGE
    | SWITCH
    | CONST
    | FALLTHROUGH
    | IF
    | RANGE
    | TYPE 
    | CONTINUE 
    | FOR 
    | IMPORT 
    | RETURN 
    | VAR 
    | INT
    | FLOAT64 
    | BOOL 
    | RUNE 
    | STRING 
    | PRINT 
    | PRINTLN 
    | APPEND
    | STRUCT
    | EOF
    | EOL*)


let keywords = Hashtbl.create 30;;
Hashtbl.add keywords "break" BREAK ;
Hashtbl.add keywords "default" DEFAULT ;
Hashtbl.add keywords "func" FUNC ;
Hashtbl.add keywords "interface" INTERFACE ;
Hashtbl.add keywords "select" SELECT ;
Hashtbl.add keywords "defer" DEFER ;
Hashtbl.add keywords "go" GO ;
Hashtbl.add keywords "map" MAP ;
Hashtbl.add keywords "struct" STRUCT ;
Hashtbl.add keywords "chan" CHAN ;
Hashtbl.add keywords "else" ELSE ;
Hashtbl.add keywords "goto" GOTO ;
Hashtbl.add keywords "package" PACKAGE ;
Hashtbl.add keywords "switch" SWITCH ;
Hashtbl.add keywords "const" CONST ;
Hashtbl.add keywords "fallthrough" FALLTHROUGH ;
Hashtbl.add keywords "if" IF ;
Hashtbl.add keywords "range" RANGE ;
Hashtbl.add keywords "type" TYPE ;
Hashtbl.add keywords "continue" CONTINUE ;
Hashtbl.add keywords "for" FOR ;
Hashtbl.add keywords "import" IMPORT ;
Hashtbl.add keywords "return" RETURN ;
Hashtbl.add keywords "var" VAR ;
Hashtbl.add keywords "int" INT  ;
Hashtbl.add keywords "float64" FLOAT64  ;
Hashtbl.add keywords "bool" BOOL ;
Hashtbl.add keywords "rune" RUNE ;
Hashtbl.add keywords "string" STRING ;
Hashtbl.add keywords "print" PRINT ;
Hashtbl.add keywords "println" PRINTLN ;
Hashtbl.add keywords "append" APPEND ;
Hashtbl.add keywords "case" CASE ;;

let line_num lexbuf =
    lexbuf.Lexing.lex_curr_p.pos_lnum
;;

let char_num lexbuf =
    lexbuf.Lexing.lex_curr_p.pos_cnum
;;
let last_token = ref EOL
;;
exception Syntax_error of string
exception Eof

}

let alpha = ['a'-'z' 'A'-'Z']
let ascii = ['\x00' -'\x5b' '\x5d'-'\x7f']

let escaped_char = ('a'|'b'|'f'|'n'|'r'|'t'|'v'|'\\'|'\'')
let rune_lit = '\''(ascii|'\\'escaped_char)'\''

let interpreted_string_lit = ('"'( ascii|'\\'escaped_char|'\\''"')*'"')
let raw_string_lit = ('`' (([^ '`'])*) '`') 
let string_lit = (interpreted_string_lit|raw_string_lit)

let digit = ['0'-'9']
let decimal_lit = (['1'-'9']digit*)
let octal_digit = ['0'-'7']
let octal_lit = ( '0'octal_digit*)
let hex_digit = ['0'-'9' 'A'-'F' 'a'-'f']
let hex_lit = ('0'('x'|'X')hex_digit+)
let int_lit = (decimal_lit|octal_lit|hex_lit)

let decimals = (digit+)
let float_lit = (decimals '.' decimals | '.' decimals | decimals '.')

let blank = [' ' '\r' '\t']

let iden = (alpha | '_') (alpha | digit | '_')*
let notnewline = [^ '\n']
let one_line_comment = ('/' '/') (notnewline)* '\n'
let block_comment = ('/' '*') (_)* ('*' '/')

let identifier = (alpha | '_') (alpha | digit | '_')*

rule golite = parse
    | "+"      { last_token:= PLUS; PLUS }
    | "&"      { last_token:= AND; AND }
    | "+="     { last_token:= PLUS_EQ; PLUS_EQ }
    | "&="     { last_token:= AND_EQ; AND_EQ }
    | "&&"     { last_token:= DOUBLE_AND; DOUBLE_AND }
    | "=="     { last_token:= DOUBLE_EQ; DOUBLE_EQ}
    | "!="     { last_token:= NOT_EQ; NOT_EQ }
    | "("      { last_token:= OPEN_PAREN; OPEN_PAREN }
    | ")"      { last_token:= CLOSE_PAREN; CLOSE_PAREN }
    | "-"      { last_token:= MINUS; MINUS }
    | "|"      { last_token:= BAR; BAR }
    | "-="     { last_token:= MINUS_EQ; MINUS_EQ  }
    | "|="     { last_token:= BAR_EQ; BAR_EQ }
    | "||"     { last_token:= DOUBLE_BAR; DOUBLE_BAR }
    | "<"      { last_token:= LT; LT }
    | "<="     { last_token:= LT_EQ; LT_EQ }
    | "["      { last_token:= OPEN_SQR_BRACKET; OPEN_SQR_BRACKET }
    | "]"      { last_token:= CLOSE_SQR_BRACKET; CLOSE_SQR_BRACKET }
    | "*"      { last_token:= STAR; STAR }
    | "^"      { last_token:= CARET; CARET }
    | "*="     { last_token:= STAR_EQ; STAR_EQ }
    | "^="     { last_token:= CARET_EQ; CARET_EQ }
    | "<-"     { last_token:= LT_MINUS; LT_MINUS }
    | ">"      { last_token:= GT; GT }
    | ">="     { last_token:= GT_EQ; GT_EQ }
    | "{"      { last_token:= OPEN_CUR_BRACKET; OPEN_CUR_BRACKET}
    | "}"      { last_token:= CLOSE_CUR_BRACKET; CLOSE_CUR_BRACKET}
    | "/"      { last_token:= SLASH; SLASH}
    | "<<"     { last_token:= SHIFT_LEFT; SHIFT_LEFT}
    | "/="     { last_token:= SLASH_EQ; SLASH_EQ }
    | "<<="    { last_token:= SHIFT_LEFT_EQ; SHIFT_LEFT_EQ }
    | "++"     { last_token:= DOUBLE_PLUS; DOUBLE_PLUS}
    | "="      { last_token:= EQ; EQ}
    | ":="     { last_token:= COLON_EQ;  COLON_EQ}
    | ","      { last_token:= COMMA; COMMA  }
    | ";"      { last_token:= SEMICOLON; SEMICOLON }
    | "%"      { last_token:= PERCENT; PERCENT }
    | ">>"     { last_token:= SHIFT_RIGHT;SHIFT_RIGHT }
    | "%="     { last_token:= PERCENT_EQ; PERCENT_EQ }
    | ">>="    { last_token:= SHIFT_RIGHT_EQ; SHIFT_RIGHT_EQ }
    | "--"     { last_token:= DOUBLE_MINUS; DOUBLE_MINUS }
    | "!"      { last_token:= NOT; NOT }
    | "..."    { last_token:= TRIPLE_DOT; TRIPLE_DOT }
    | "."      { last_token:= DOT; DOT }
    | ":"      { last_token:= COLON; COLON }
    | "&^"     { last_token:= AND_CARET; AND_CARET }
    | "&^="    { last_token:= AND_CARET_EQ; AND_CARET_EQ }

    | int_lit as d { 
      INTLITERAL (int_of_string d)
    }
    | float_lit as f {
      FLOATLITERAL (float_of_string f)
    }
    | identifier as i {
      let myvar = i in
      try Hashtbl.find keywords myvar
      with Not_found -> IDENTIFIER myvar
    }
    | string_lit as s {
      STRINGLITERAL (s)
    }
    | rune_lit as r {
      RUNELITERAL(String.get r 0)
    }
    | '\n'     { Lexing.new_line lexbuf; golite lexbuf} (* increment line number and char number *)
    | blank    { golite lexbuf } (* skipping blank characters *)
    | one_line_comment { golite lexbuf }
    | block_comment { golite lexbuf }
    | eof      { EOF } (* no more tokens *)
    | _        { raise (GoliteError ("Unknown token "^"on line "^(string_of_int (line_num lexbuf))^":"^(string_of_int (char_num lexbuf)))) }

{

}
