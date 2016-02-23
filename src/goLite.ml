(* main *)

open Lexer
(* 
let token_type_to_string token = match token with 
    | INTLITERAL(int) -> "INTLITERAL"
    | FLOATLITERAL(float) -> "FLOATLITERAL"
    | STRINGLITERAL(string) -> "STRINGLITERAL"
    | RUNELITERAL(char) -> "RUNELITERAL"
    | IDENTIFIER(string) -> "IDENTIFIER"
    | EOL -> "EOL\n"
    | EOF -> "EOF\n"
    | PLUS -> "PLUS"
    | AND -> "AND"
    | PLUS_EQ ->  "PLUS_EQ"
    | AND_EQ -> "AND_EQ"
    | DOUBLE_AND -> "DOUBLE_AND"
    | DOUBLE_EQ -> "DOUBLE_EQ"
    | NOT_EQ -> "NOT_EQ"
    | OPEN_PAREN -> "OPEN_PAREN"
    | CLOSE_PAREN -> "CLOSE_PAREN"
    | MINUS -> "MINUS"
    | BAR -> "BAR"
    | MINUS_EQ -> "MINUS_EQ"
    | BAR_EQ -> "BAR_EQ"
    | DOUBLE_BAR -> "DOUBLE_BAR"
    | LT -> "LT"
    | LT_EQ -> "LT_EQ"
    | OPEN_SQR_BRACKET -> "OPEN_SQR_BRACKET"
    | CLOSE_SQR_BRACKET -> "CLOSE_SQR_BRACKET"
    | STAR -> "STAR"
    | CARET -> "CARET"
    | STAR_EQ -> "STAR_EQ"
    | CARET_EQ -> "CARET_EQ"
    | LT_MINUS -> "LT_MINUS"
    | GT -> "GT"
    | GT_EQ -> "GT_EQ"
    | OPEN_CUR_BRACKET -> "OPEN_CUR_BRACKET"
    | CLOSE_CUR_BRACKET -> "CLOSE_CUR_BRACKET"
    | SLASH -> "SLASH"
    | SHIFT_LEFT -> "SHIFT_LEFT"
    | SLASH_EQ -> "SLASH_EQ"
    | SHIFT_LEFT_EQ -> "SHIFT_LEFT_EQ"
    | DOUBLE_PLUS -> "DOUBLE_PLUS"
    | EQ -> "EQ"
    | COLON_EQ -> "COLON_EQ"
    | COMMA -> "COMMA"
    | SEMICOLON -> "SEMICOLON"
    | PERCENT -> "PERCENT"
    | SHIFT_RIGHT -> "SHIFT_RIGHT"
    | PERCENT_EQ -> "PERCENT_EQ"
    | SHIFT_RIGHT_EQ -> "SHIFT_RIGHT_EQ"
    | DOUBLE_MINUS -> "DOUBLE_MINUS"
    | NOT -> "NOT"
    | TRIPLE_DOT -> "TRIPLE_DOT"
    | DOT -> "DOT"
    | COLON -> "COLON"
    | AND_CARET -> "AND_CARET"
    | AND_CARET_EQ -> "AND_CARET_EQ"
    | BREAK -> "BREAK"
    | DEFAULT -> "DEFAULT"
    | FUNC -> "FUNC"
    | INTERFACE ->"INTERFACE"
    | SELECT -> "SELECT"
    | CASE -> "CASE"
    | DEFER -> "DEFER"
    | GO -> "GO"
    | MAP -> "MAP"
    | CHAN -> "CHAN"
    | ELSE -> "ELSE"
    | GOTO -> "GOTO"
    | PACKAGE -> "PACKAGE"
    | SWITCH -> "SWITCH"
    | CONST -> "CONST"
    | FALLTHROUGH -> "FALLTHROUGH"
    | IF -> "IF"
    | RANGE -> "RANGE"
    | TYPE -> "TYPE"
    | CONTINUE -> "CONTINUE"
    | FOR -> "FOR"
    | IMPORT -> "IMPORT"
    | RETURN -> "RETURN"
    | VAR -> "VAR"
    | INT -> "INT"
    | FLOAT64 -> "FLOAT64"
    | BOOL -> "BOOL"
    | RUNE -> "RUNE"
    | STRING -> "STRING"
    | PRINT -> "PRINT"
    | PRINTLN -> "PRINTLN"
    | APPEND -> "APPEND"
    | STRUCT -> "STRUCT" *)

(* let print_token token = match token with
    | EOL -> print_string "EOL\n"
    | EOF -> print_string "EOF\n"
    | _ -> print_string ((token_type_to_string token)^" ") *)

(* let rec print_lexer_tokens lexbuf =
    let token = Lexer.golite lexbuf in 
    print_token token;
    flush stdout;
    if token = EOF then exit 0;
    print_lexer_tokens lexbuf *)

let _ =
    if Array.length Sys.argv > 1
    then
        try
            let file = Array.get Sys.argv 1 in
            let lexbuf= Lexing.from_channel (open_in file) in
            Parser.sourcefile Lexer.golite lexbuf;
        with 
        | Parser.Error -> print_string("Invalid grammar\n"); exit 0;
