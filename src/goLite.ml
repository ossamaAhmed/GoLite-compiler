(* main *)

open Lexer
open Weeder
open TypeChecker

let pptype = ref false
let dumpsymtab = ref false
let input_file = ref ""
let usage = "usage: "^Sys.argv.(0)^" [-pptype] [-dumpsymtab] input_filename"
let speclist = [
    ("-pptype", Arg.Set pptype, ": Pretty print the program with the type of each expression printed");
    ("-dumpsymtab", Arg.Set dumpsymtab, ": The top-most frame of the symbol table to be dumped each time a scope is exited");
]
let _ = Arg.parse speclist (fun x -> if !input_file = "" then input_file := x else raise (Arg.Bad ("Bad argument : " ^ x))) usage

let _ = if !dumpsymtab = true then 
    Symboltbl.dumpsymtab := true 
    else Symboltbl.dumpsymtab := false

let _ =
    try
        let filepath = !input_file in
        let filename = (Filename.basename filepath) in
        let filedir = (Filename.dirname filepath) in
        let out = (Filename.chop_extension filename) in
        let lexbuf = Lexing.from_channel (open_in filepath) in
        (* Lexer.print_tokens lexbuf; *)
        let tokens = Parser.parse Lexer.golite lexbuf in
        let weededProg = Weeder.weed tokens in 
        let _ = PrettyPrinter.print tokens filedir out in
        let typecheckedProg = TypeChecker.check tokens out in
        let _ = if !pptype = true then PrettyPrinterTyped.print typecheckedProg filedir out in
        let codeGeneratedProg = CodeGen.generate tokens filedir out in
        Sys.command ("java -jar ../jasmin.jar "^filedir^(Filename.dir_sep)^out^".j -d "^filedir);
        Sys.command ("java "^out);
        print_string ("Valid\n"); 
    with 
        | Parser.Error -> print_string("Invalid grammar\n"); exit 0;
