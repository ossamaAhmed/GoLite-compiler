(* main *)

open Lexer
let printtoken tokenenizer= match tokenenizer with 
					  | INTLITERAL(int) -> "INTLITERAL"
					  |	FLOATLITERAL(float) -> "FLOATLITERAL"
					  | STRINGVAR(string) -> "IDENTIFIER"
					  | EOL ->"newline"
let _ = 
    try
        let lexbuf = Lexing.from_channel stdin in
        while true do
            let result = Lexer.mini lexbuf in 
                printtoken result; print_newline(); flush stdout;
        done

    with Lexer. Eof ->
        exit 0
