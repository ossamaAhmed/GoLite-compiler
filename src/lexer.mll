{

open Parser
open Lexing
open Error

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
    lexbuf.Lexing.lex_curr_p.pos_bol
;;

let file_name lexbuf = 
    lexbuf.Lexing.lex_curr_p.pos_fname
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
    | "+"      { PLUS }
    | "&"      { AND }
    | "+="     { PLUS_EQ }
    | "&="     { AND_EQ }
    | "&&"     { DOUBLE_AND }
    | "=="     { DOUBLE_EQ }
    | "!="     { NOT_EQ }
    | "("      { OPEN_PAREN }
    | ")"      { CLOSE_PAREN }
    | "-"      { MINUS }
    | "|"      { BAR }
    | "-="     { MINUS_EQ }
    | "|="     { BAR_EQ }
    | "||"     { DOUBLE_BAR }
    | "<"      { LT }
    | "<="     { LT_EQ }
    | "["      { OPEN_SQR_BRACKET }
    | "]"      { CLOSE_SQR_BRACKET }
    | "*"      { STAR }
    | "^"      { CARET }
    | "*="     { STAR_EQ }
    | "^="     { CARET_EQ }
    | "<-"     { LT_MINUS }
    | ">"      { GT }
    | ">="     { GT_EQ }
    | "{"      { OPEN_CUR_BRACKET }
    | "}"      { CLOSE_CUR_BRACKET }
    | "/"      { SLASH }
    | "<<"     { SHIFT_LEFT }
    | "/="     { SLASH_EQ }
    | "<<="    { SHIFT_LEFT_EQ }
    | "++"     { DOUBLE_PLUS }
    | "="      { EQ }
    | ":="     { COLON_EQ }
    | ","      { COMMA }
    | ";"      { SEMICOLON }
    | "%"      { PERCENT }
    | ">>"     { SHIFT_RIGHT }
    | "%="     { PERCENT_EQ }
    | ">>="    { SHIFT_RIGHT_EQ }
    | "--"     { DOUBLE_MINUS }
    | "!"      { NOT }
    | "..."    { TRIPLE_DOT }
    | "."      { DOT }
    | ":"      { COLON }
    | "&^"     { AND_CARET }
    | "&^="    { AND_CARET_EQ }

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
    | _        { raise (GoliteError ("Unknown token in"^(file_name lexbuf)^"on line "^(string_of_int (line_num lexbuf))^":"^(string_of_int (char_num lexbuf)))) }

{

}
