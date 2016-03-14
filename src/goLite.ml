(* main *)

open Lexer
open Weeder

let _ =
    if Array.length Sys.argv > 1
    then
        try
            let file = Array.get Sys.argv 1 in
            let filename= (Filename.basename file) in
            let out = (Filename.chop_extension filename) in
            let lexbuf= Lexing.from_channel (open_in file) in
(*              Lexer.print_tokens lexbuf;
 *)            let myprog = Parser.parse Lexer.golite lexbuf in
            let weededProg = Weeder.weed_program myprog in 
            let _ = PrettyPrinter.pretty_print myprog out in
            print_string ("Valid\n"); 
        with 
            | Parser.Error -> print_string("Invalid grammar\n"); exit 0;
