(* main *)

open Lexer
open Weeder
open TypeChecker

let _ =
    if Array.length Sys.argv > 1
    then
        try
            let filepath = Array.get Sys.argv 1 in
            let filename = (Filename.basename filepath) in
            let filedir = (Filename.dirname filepath) in
            let out = (Filename.chop_extension filename) in
            let lexbuf = Lexing.from_channel (open_in filepath) in
            (* Lexer.print_tokens lexbuf; *)
            let tokens = Parser.parse Lexer.golite lexbuf in
            let weededProg = Weeder.weed tokens in 
            let _ = PrettyPrinter2.print tokens filedir out in
            let _ = TypeChecker.type_check_program tokens out in
            print_string ("Valid\n"); 
        with 
            | Parser.Error -> print_string("Invalid grammar\n"); exit 0;
