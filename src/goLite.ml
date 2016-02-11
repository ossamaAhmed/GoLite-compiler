(* main *)

open Lexer
let printtoken tokenenizer= match tokenenizer with 
					| INTLITERAL(int) -> "INTLITERAL"
					|	FLOATLITERAL(float) -> "FLOATLITERAL"
					| STRINGVAR(string) -> "IDENTIFIER"
					| EOL -> "EOL\n"
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
let _ = 
    try
        let lexbuf = Lexing.from_channel stdin in
        while true do
            let result = Lexer.golite lexbuf in 
                print_string ((printtoken result)^" "); flush stdout;
        done
    with Lexer. Eof -> print_newline();
        exit 0
