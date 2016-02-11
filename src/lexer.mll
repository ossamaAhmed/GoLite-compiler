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
	  | ':'	   { COLON }
    | '='      { ASSIGN }
    | '+'      { ADD }
    | '-'      { SUB }
    | '*'      { TIMES }
    | '/'      { DIV }
    | '('      { LPAREN }
    | ')'      { RPAREN }
    | ';'      { SEMICOLON }

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
