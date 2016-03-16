(* main *)

open Lexer
open Weeder
open TypeChecker

let _ =
    if Array.length Sys.argv > 1
    then
        try
            let filepath = Array.get Sys.argv 1 in
            let filename= (Filename.basename filepath) in
            let out = (Filename.chop_extension filename) in
            let lexbuf= Lexing.from_channel (open_in filepath) in
            (* Lexer.print_tokens lexbuf; *)
            let myprog = Parser.parse Lexer.golite lexbuf in
            let weededProg = Weeder.weed myprog in 
            let _ = PrettyPrinter.print myprog filepath out in
            let _ = TypeChecker.type_check_program myprog out in
            print_string ("Valid\n"); 
        with 
            | Parser.Error -> print_string("Invalid grammar\n"); exit 0;
