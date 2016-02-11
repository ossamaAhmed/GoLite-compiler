{

open LextTest 
open Error

(* keyword -> token translation table *)
let keywords = [
    "var", VARDCL;"float", FLOATDCL; "int", INTDCL;"string",STRINGDCL ;"read", READ; "print", PRINT; "if", IF;
    "then", THEN; "else", ELSE; "endif", ENDIF; "while", WHILE; "do", DO; "done", DONE
]

exception Syntax_error of string
exception Eof


}


let escaped_char = ('\\'('a'|'b'|'f'|'n'|'r'|'t'|'v'|'\\'|'\'')
let rune_lit = '\\'(alpha|escaped_char)

let interpreted_string_lit = ('"'(alpha|escaped_char|'"')*'"')
let raw_string_lit = ('`'(.*?)'`') 

let digit = ['0'-'9']
let decimal_lit = (['1'-'9']digit*)
let octal_digit = ('0'-'7')
let octal_lit = ( '0'octal_digit*)
let hex_digit = (['0'-'9'|'A'-'F'|'a'-'f'])
let hex_lit = ('0'('x'|'X')hex_digit+)
let int_lit = (decimal_lit|octal_lit|hex_lit)

let decimals = (digit+)
let float_lit = (decimals'.'decimals|'.'decimals|decimals'.')

let blank = [' ' '\r' '\t']
let alpha = ['a'-'z' 'A'-'Z']
let iden = (alpha | '_') (alpha | digit | '_')*
let notnewline = [^ '\n']
let comments = ('#')+ (notnewline)* '\n'

rule mini = parse
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


    | iden as i {
        (* try keywords if not found then it's identifier *)
        let l = i in
        try List.assoc l keywords
        with Not_found -> IDENTIFIER i   
    }
    | intdigits as d { 
        (* parse literal *)
        INTLITERAL (int_of_string d)
    }
    | floatdigits as f {
      FLOATLITERAL (float_of_string f)
    }
    | strings as s {
      STRINGVAR   (s)
    }
    | '\n'     {EOL} (* counting new line characters and increment line num FORGOT *)
    | blank    { mini lexbuf } (* skipping blank characters *)
    | comments { mini lexbuf }
    | eof      { raise Eof } (* no more tokens *)
    | _        { raise (MinilangError ("unknown char "^ "on line "^(string_of_int !line_num)))}


{
}
