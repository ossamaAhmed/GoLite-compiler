{

open Parser 
open Error

type token =
    | INTLITERAL of (int)
    | FLOATLITERAL of (float)
    | STRINGLITERAL of (string)
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
    | EOL
(* keyword -> token translation table *)
(*let keywords = [
    "var", VARDCL;"float", FLOATDCL; "int", INTDCL;"string",STRINGDCL ;"read", READ; "print", PRINT; "if", IF;
    "then", THEN; "else", ELSE; "endif", ENDIF; "while", WHILE; "do", DO; "done", DONE
]*)

exception Syntax_error of string
exception Eof


}

let alpha = ['a'-'z' 'A'-'Z']
let ascii = ['\x00' -'\x7F']

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
let comments = ('#')+ (notnewline)* '\n'

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
        (* parse literal *)
        INTLITERAL (int_of_string d)
    }
    | float_lit as f {
      FLOATLITERAL (float_of_string f)
    }
    | string_lit as s {
      STRINGLITERAL  (s)
    }
    | rune_lit as r{
      RUNELITERAL(String.get r 0)
    }
    | '\n'     { line_num:= !line_num+1; Lexing.new_line lexbuf; EOL} (* counting new line characters and increment line num FORGOT *)
    | blank    { golite lexbuf } (* skipping blank characters *)
    | comments { golite lexbuf }
    | eof      { raise Eof } (* no more tokens *)
    | _        { print_string ("unknown char "^Lexing.lexeme lexbuf);print_string(" on line "^(string_of_int !line_num)^"\n");golite lexbuf}


{
}
