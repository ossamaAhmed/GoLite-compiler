(* main *)

open Lexer

let _ =
    if Array.length Sys.argv > 1
    then
        try
            let file = Array.get Sys.argv 1 in
            let lexbuf= Lexing.from_channel (open_in file) in
            Parser.parse Lexer.golite lexbuf;
            (* Lexer.print_tokens lexbuf; *)
        with 
        | Parser.Error -> print_string("Invalid grammar\n"); exit 0;
