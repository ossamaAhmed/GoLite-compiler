open Printf
open Ast
open Symboltbl 

exception Code_generation_error of string
let code_gen_error msg = raise (Code_generation_error msg)

let jasmin_main_class = ref "GoFile"

(* Stack functions for locals manipulation *)

type symTable = Scope of (string , string) Hashtbl.t
let symbol_table = ref []
let labelcounttrue = ref 0
let labelcountertrue () = labelcounttrue :=! labelcounttrue+1
let labelcountfalse = ref 0
let labelcounterfalse () = labelcountfalse :=! labelcountfalse+1
let localcount = ref 0
let localcounter () = localcount :=! localcount+1

let start_scope () = symbol_table := Scope(Hashtbl.create 50)::!symbol_table
let end_scope () = match !symbol_table with 
                | Scope(head)::tail -> localcount := !localcount-(Hashtbl.length head); symbol_table:= tail

let search_current_scope key = match !symbol_table with 
    | Scope(current_scope)::tail -> 
    if (Hashtbl.mem current_scope key) then 
        Hashtbl.find current_scope key
    else 
        code_gen_error ("variable is not defined in current_scope")

let search_not_find_current_scope x = match !symbol_table with
    | Scope(current_scope)::tail ->
        if (Hashtbl.mem current_scope x) then true else false

let rec search_previous_scopes x table = match table with (*called with !symbol_table*)
    | []-> code_gen_error ("variable is not defined in current and previous scopes")
    | Scope(current_scope)::tail -> 
        if (Hashtbl.mem current_scope x) then 
            Hashtbl.find current_scope x
        else 
            search_previous_scopes x tail

let add_variable_to_current_scope mytype myvar = match myvar with
    | Identifier(myvariable,linenum)-> 
        (match !symbol_table with
            | Scope(current_scope)::tail ->
                if not(Hashtbl.mem current_scope myvariable) then 
                    Hashtbl.add current_scope myvariable mytype
                else
                    code_gen_error ("variable is defined more than one time")
        )

let get_primitive_type type_of_type_i = match type_of_type_i with
        | Primitivetype(value, _) -> 
            (match value with
                | "int" -> SymInt
                | "rune" -> SymRune
                | "bool" -> SymBool
                | "string" -> SymString
                | "float64" -> SymString
            )
        | Arraytype(len, type_name2, _)-> Void (*TO BE IMPLEMENTED*)
        | Definedtype(Identifier(value, _), _) -> Void (*TO BE IMPLEMENTED*)
        | Slicetype(type_name2, _)-> Void (*TO BE IMPLEMENTED*)
        | Structtype([], _) -> Void (*TO BE IMPLEMENTED*)
        | Structtype(field_dcl_list, _) -> Void (*TO BE IMPLEMENTED*)

let generate_load typename varname linenum= match typename with 
    | SymInt -> "iload"^" "^(search_previous_scopes varname !symbol_table)
    | SymFloat64 -> "fload"^" "^(search_previous_scopes varname !symbol_table)
    | SymRune -> "iload"^" "^(search_previous_scopes varname !symbol_table)
    | SymString -> "aload"^" "^(search_previous_scopes varname !symbol_table)
    | SymBool -> "iload"^" "^(search_previous_scopes varname !symbol_table)
    | NotDefined -> (let errMsg ="type wasnt attached in type checking at line: "^string_of_int linenum  in code_gen_error errMsg)

let generate_store typename varnameIden = match typename, varnameIden with 
    | SymInt, Identifier(varname,_) -> "istore"^" "^(search_previous_scopes varname !symbol_table)
    | SymFloat64, Identifier(varname,_) -> "fstore"^" "^(search_previous_scopes varname !symbol_table)
    | SymRune, Identifier(varname,_) -> "istore"^" "^(search_previous_scopes varname !symbol_table)
    | SymString, Identifier(varname,_) -> "astore"^" "^(search_previous_scopes varname !symbol_table)
    | SymBool, Identifier(varname,_) -> "istore"^" "^(search_previous_scopes varname !symbol_table)
    | _,_ -> "Other" (*TODO: place holder *)

let apply_func_on_element_from_two_lsts lst1 lst2 func= match lst1,lst2 with 
    | [],[]-> ()
    | head1::tail1,head2::tail2-> func head1 head2


(* --------------------------------END-------------------------------- *)

(* Function call table *)

(* Store a table of function name => Jasmin function invocation strings *)
type funcTable = (string, string) Hashtbl.t;;
let (func_table : funcTable) = Hashtbl.create 123456;;

(* Refer to print_type_name in prettyPrinter *)
let string_jasmin_type go_type = match go_type with 
    | Definedtype(Identifier(value, _), _) -> value
    | Primitivetype(value, _) ->
        (match value with 
            | "int" -> "I"
            | "bool" -> "Z"
            | "float64" -> "F"
            | "rune" -> "C"
            | "string" -> "[Ljava/lang/String;"
        )
    | Arraytype(len, type_name2, _) -> ""
        (* What is array type in jasmin? *)
    | Slicetype(type_name2, _) -> ""
        (* What is slice type in jasmin? *)
    | Structtype([], _) -> ""
        (*TO BE IMPLEMENTED*)
    | Structtype(field_dcl_list, _) -> ""
        (*TO BE IMPLEMENTED*)
let rec string_method_params_types iden_list = match iden_list with
    | [] -> ""
    | TypeSpec(Identifier(iden, _), iden_type, _)::[] -> 
        string_jasmin_type iden_type
    | TypeSpec(Identifier(iden, _), iden_type, _)::tail ->
        (string_jasmin_type iden_type)^(string_method_params_types tail)
let add_func func_name func_sig = match func_sig with
    | FuncSig(FuncParams(params_list, _), FuncReturnType(return_type_i, _), _) ->
        Hashtbl.add func_table func_name (!jasmin_main_class^"/"^func_name^"("^(string_method_params_types params_list)^")"^(string_jasmin_type return_type_i))
    | FuncSig(FuncParams(params_list, _), _, _) ->
        Hashtbl.add func_table func_name (!jasmin_main_class^"/"^func_name^"("^(string_method_params_types params_list)^")V")
let invoke_func func_name = "invokestatic "^(Hashtbl.find func_table func_name)

(* --------------------------------END-------------------------------- *)

let generate program filedir filename =

    (* Program AST unpacking *)
    let Prog(package_name, decl_list) = program in
    let output_filename = filedir^(Filename.dir_sep)^filename^".j" in
    let output_file = open_out output_filename in

    (* Utilities *)
    let print_string s = output_string output_file s in
    let println_string s = output_string output_file (s^"\n") in
    let print_tab (level) = print_string (String.make level '\t') in
    let print_string_with_tab (level) s =
        begin
            print_tab (level);
            print_string s
        end
    in
    let println_string_with_tab (level) s =
        begin
            print_tab (level);
            println_string s
        end
    in
    let println_one_tab s = 
        begin 
            print_tab 1;
            println_string s
        end
    in
    let print_int value = print_string (string_of_int value) in
    let print_float value = print_string (string_of_float value) in
    let rec print_symType sType linenum = match sType with
        | SymInt -> print_string "SymInt"
        | SymFloat64 -> print_string "SymFloat64"
        | SymRune -> print_string "SymRune" 
        | SymString -> print_string "SymString"
        | SymBool -> print_string "SymBool"
        | SymArray(subType) -> print_string "SymArray/"; print_symType subType linenum;
        | SymSlice(subType) -> print_string "SymSlice/"; print_symType subType linenum;
        | SymStruct(fieldlist) -> print_string "SymStruct/"(*TODO: this needs to be tested*)
        | SymFunc(subType,arglist) -> print_string "SymFunc/"; print_symType subType linenum;
        | SymType(subType) -> print_string "SymType/"; print_symType subType linenum;
        | Void -> print_string "Void"
        | NotDefined -> (let errMsg = "Symtype wasnt attached in type checking at line: "^string_of_int linenum in code_gen_error errMsg) ; in

    (* Jasmin initializations *)

    (*
    .class public examples/HelloWorld
    .super java/lang/Object
    *)
    let print_class_header filename = 
        begin
            println_string (".class public "^(filename)^"");
            println_string ".super java/lang/Object\n"
        end
    in
    (*
    .method public <init>()V
       aload_0
       invokenonvirtual java/lang/Object/<init>()V
       return
    .end method
    *)
    let print_init_header filename =
        begin
            println_string (".method public <init>()V");
            println_one_tab "aload_0";
            println_one_tab "invokenonvirtual java/lang/Object/<init>()V";
            println_one_tab "return";
            println_string ".end method\n"   
        end
    in
    let rec print_identifier_list iden_list = match iden_list with
        | Identifier(iden, _)::[] -> print_string iden
        | Identifier(iden, _)::tail ->
            begin
                print_string (iden^", ");
                print_identifier_list tail
            end
        | _ -> ()
    in
    let rec print_type_name level type_name = match type_name with
        | Definedtype(Identifier(value, _), _) -> print_string value
        | Primitivetype(value, _) -> ()
(*
            let _ = match value with
                | "int" -> print_string "I"
                | "rune" -> print_string "C"
                | "bool" -> print_string "B"
                | "string" -> print_string "[Ljava/lang/String;"
                | "float64" -> print_string "F"
                | _ -> print_string "V"
*)
        | Arraytype(len, type_name2, _)-> 
            begin
                print_string "[ ";
                print_int len;
                print_string " ] ";
                print_type_name level type_name2;
            end
        | Slicetype(type_name2, _)->
            begin
                print_string "[] ";
                print_type_name level type_name2;
            end
        | Structtype([], _) -> ()
        | Structtype(field_dcl_list, _) -> 
            let print_field_dcl level field = match field with 
                | (iden_list,type_name1) -> 
                begin
                    print_tab (level);
                    print_identifier_list iden_list;
                    print_string " ";
                    print_type_name (level) type_name1;
                    print_string ";\n";
                end
                | _ -> ast_error ("field_dcl_print error")
            in
                print_string "struct {\n";
                List.iter (print_field_dcl (level+1)) field_dcl_list;
                print_tab (level);
                print_string "}";
    in
    let rec print_identifier_list_with_type iden_list = match iden_list with
        | [] -> ()
        | TypeSpec(Identifier(iden, _), iden_type, _)::[] -> 
            begin
                print_string iden;
                print_string " ";
                print_type_name 0 iden_type;
            end
        | TypeSpec(Identifier(iden, _), iden_type, _)::tail ->
            begin
                print_string iden;
                print_string " ";
                print_type_name 0 iden_type;
                print_string ", ";
                print_identifier_list_with_type tail;
            end
    in 
    let print_literal lit = match lit with
        | Intliteral(value, _) -> println_one_tab ("ldc "^(string_of_int value))
        | Floatliteral(value, _) -> println_one_tab ("ldc "^(string_of_float value))
        | Runeliteral(value, _) -> ()   (*TO BE IMPLEMENTED*)
        | Stringliteral(value, _) -> println_one_tab ("ldc "^(value))
    in
    let generate_binary_arithmetic type1 type2 = match type1,type2 with 
                        | SymInt, SymInt -> print_string_with_tab 1 "i";
                        | SymFloat64, SymFloat64 -> print_string_with_tab 1 "f";
                        | SymInt, SymFloat64 -> println_one_tab "f2i";
                                                print_string_with_tab 1 "i";
                        | SymFloat64, SymInt -> println_one_tab "i2f";
                                                print_string_with_tab 1 "f";
                        | SymRune, SymRune-> ()  (*NOT YET IMPLEMENTED*)
                        | _ ,_ -> code_gen_error "addition function error"
    in
    let rec print_expr exp = match exp with 
        | OperandName(value, linenum, symt) -> println_one_tab (generate_load symt value linenum); symt (*handle true and false missing*)
        | AndAndOp(exp1, exp2, _, symt) -> (*DONE*)
                print_expr exp1;
                println_string_with_tab 1 ("dup");
                let cur_label= !labelcountfalse in 
                labelcountertrue(); (*NOT SURE IF WE SHOULD INCREMENT BOTH, NEED TO FIGURE THIS IN BREAK*)
                labelcounterfalse();
                println_string_with_tab 1 ("ifeq "^"false"^(string_of_int cur_label));
                println_string_with_tab 1 ("pop");
                print_expr exp2;
               println_string_with_tab 1 ("false"^(string_of_int cur_label)^":");
                symt
        | OrOrOp(exp1, exp2, _, symt) -> (*DONE*)
                print_expr exp1; 
                println_string_with_tab 1 ("dup");
                let cur_label= !labelcountfalse in 
                labelcountertrue(); (*NOT SURE IF WE SHOULD INCREMENT BOTH, NEED TO FIGURE THIS IN BREAK*)
                labelcounterfalse();
                println_string_with_tab 1 ("ifne "^"true"^(string_of_int cur_label));
                println_string_with_tab 1 ("pop");
                print_expr exp2;
                println_string_with_tab 1 ("true"^(string_of_int cur_label)^":");
                labelcountertrue();
                labelcounterfalse(); (*NOT SURE IF WE SHOULD INCREMENT BOTH, NEED TO FIGURE THIS IN BREAK*)
                symt
        | EqualEqualCmp(exp1, exp2, _, symt) ->  (*NOT COMPLETLY DONE*)
            let typeexpr1= print_expr exp1 in 
            let typeexpr2= print_expr exp2 in
            (match typeexpr1 with 
            | SymInt -> generate_comparable_binary_ints "eq";symt
            | SymFloat64 -> symt
            | SymRune -> symt
            | SymString -> symt
            | SymBool -> symt
            )
        | NotEqualCmp(exp1, exp2, _, symt) ->  (*NOT COMPLETLY DONE*)
            let typeexpr1= print_expr exp1 in
            let typeexpr2= print_expr exp2 in
            (match typeexpr1 with 
            | SymInt -> generate_comparable_binary_ints "ne";symt
            | SymFloat64 -> symt
            | SymRune -> symt
            | SymString -> symt
            | SymBool -> symt
            )
        | LessThanCmp(exp1, exp2, _, symt) ->  (*NOT COMPLETLY DONE*)
            let typeexpr1= print_expr exp1 in
            let typeexpr2= print_expr exp2 in
            (match typeexpr1 with 
            | SymInt -> generate_comparable_binary_ints "lt";symt
            | SymFloat64 -> symt
            | SymRune -> symt
            | SymString -> symt
            | SymBool -> symt
            )
        | GreaterThanCmp (exp1, exp2, _, symt) -> (*NOT COMPLETLY DONE*)
            let typeexpr1= print_expr exp1 in
            let typeexpr2= print_expr exp2 in
            (match typeexpr1 with 
            | SymInt -> generate_comparable_binary_ints "gt";symt
            | SymFloat64 -> symt
            | SymRune -> symt
            | SymString -> symt
            | SymBool -> symt
            )
        | LessThanOrEqualCmp(exp1, exp2, _, symt) -> (*NOT COMPLETLY DONE*)
            let typeexpr1= print_expr exp1 in
            let typeexpr2= print_expr exp2 in
            (match typeexpr1 with 
            | SymInt -> generate_comparable_binary_ints "le";symt
            | SymFloat64 -> symt
            | SymRune -> symt
            | SymString -> symt
            | SymBool -> symt
            )
        | GreaterThanOrEqualCmp(exp1, exp2, _, symt) -> (*NOT COMPLETLY DONE*)
            let typeexpr1= print_expr exp1 in
            let typeexpr2= print_expr exp2 in
            (match typeexpr1 with 
            | SymInt -> generate_comparable_binary_ints "ge";symt
            | SymFloat64 -> symt
            | SymRune -> symt
            | SymString -> symt
            | SymBool -> symt
            )
        | AddOp(exp1, exp2, _, symt) ->   (*DONE*)
                let typeexpr1= print_expr exp1 in
                let typeexpr2= print_expr exp2 in
                (match typeexpr1, typeexpr2 with 
                    | SymString, SymString ->  println_one_tab "invokevirtual java/lang/String/concat(Ljava/lang/String;)Ljava/lang/String;";symt
                    | _, _ -> let _= generate_binary_arithmetic typeexpr1 typeexpr2 in
                              let _= print_string "add\n" in symt
                )
                
        | MinusOp(exp1, exp2, _, symt) ->  (*DONE*)
                 let typeexpr1= print_expr exp1 in
                 let typeexpr2= print_expr exp2 in
                 let _= generate_binary_arithmetic typeexpr1 typeexpr2 in
                 let _= print_string "sub\n" in 
                 symt
        | OrOp (exp1, exp2, _, symt) ->  (*DONE*)
            let typeexpr1= print_expr exp1 in
            let typeexpr2= print_expr exp2 in
            let _= println_one_tab "ior\n" in 
            symt
        | CaretOp (exp1, exp2, _, symt) -> (*DONE*)
            let typeexpr1= print_expr exp1 in
            let typeexpr2= print_expr exp2 in
            let _= generate_binary_arithmetic typeexpr1 typeexpr2 in
            let _= print_string "ixor\n" in 
            symt
        | MulOp (exp1, exp2, _, symt)-> (*DONE*)
            let typeexpr1= print_expr exp1 in
            let typeexpr2= print_expr exp2 in
            let _= generate_binary_arithmetic typeexpr1 typeexpr2 in
            let _= print_string "mul\n" in 
            symt
        | DivOp (exp1, exp2, _, symt)-> (*DONE*)
            let typeexpr1= print_expr exp1 in
            let typeexpr2= print_expr exp2 in
            let _= generate_binary_arithmetic typeexpr1 typeexpr2 in
            let _= print_string "div\n" in 
            symt
        | ModuloOp (exp1, exp2, _, symt) ->  (*DONE*)
            let typeexpr1= print_expr exp1 in
            let typeexpr2= print_expr exp2 in
            let _= generate_binary_arithmetic typeexpr1 typeexpr2 in
            let _= print_string "rem\n" in 
            symt
        | SrOp (exp1, exp2, _, symt) ->  (*DONE*)
            let typeexpr1= print_expr exp1 in
            let typeexpr2= print_expr exp2 in
            let _= println_one_tab "ishr\n" in 
            symt
        | SlOp (exp1, exp2, _, symt) -> (*DONE*)
            let typeexpr1= print_expr exp1 in
            let typeexpr2= print_expr exp2 in
            let _= println_one_tab "ishl\n" in 
            symt
        | AndOp (exp1, exp2, _, symt) ->  (*DONE*)
            let typeexpr1= print_expr exp1 in
            let typeexpr2= print_expr exp2 in
            let _= println_one_tab "iand\n" in 
            symt
        | AndCaretOp (exp1, exp2, _, symt) -> (*NOT IMPLEMENTED*)
            begin
                print_string "( ";
                print_expr exp1;
                print_string " &^ ";
                print_expr exp2;
                print_string " )";
                symt
            end
        | OperandParenthesis (exp1, _, symt) -> print_expr exp1; symt (*DONE*)
        | Unaryexpr(exp1, _, symt) -> print_expr exp1; symt (*DONE*)
        | Binaryexpr(exp1, _, symt) -> print_expr exp1; symt (*DONE*)
        | FuncCallExpr(OperandName(value, linenum, symt), exprs, _, _) -> println_one_tab (invoke_func value); symt
        | UnaryPlus(exp1, _, symt) -> (*DONE*)
            let typeexpr1= print_expr exp1 in 
            symt
        | UnaryMinus(exp1, _, symt) -> (*MISSING FOR OTHER TYPES OTHER THAN INT*)
            let typeexpr1= print_expr exp1 in
            let _= println_one_tab "ineg\n" in 
            symt
        | UnaryNot(exp1, _, symt) -> (*DONE*)
                print_expr exp1;
                println_one_tab ("ifeq true"^(string_of_int !labelcounttrue));
                println_one_tab ("iconst_0");
                println_one_tab ("goto stop"^(string_of_int !labelcountfalse));
                println_one_tab ("true"^(string_of_int !labelcounttrue)^":");
                println_one_tab ("iconst_1");
                println_one_tab ("stop"^(string_of_int !labelcountfalse)^":");
                labelcountertrue();
                labelcounterfalse();    
                symt
        | UnaryCaret(exp1, _, symt) -> (*NOT IMPLEMENTED*)
            begin
                print_string "( ^";
                print_expr exp1;
                print_string " )";
                symt
            end
        | Value(value, _, symt) -> print_literal value; symt (*MISSING RUNES*)
        | Selectorexpr(exp1, Identifier(iden, _), linenum, symbolType) ->
            begin
                print_string "getfield ";
                print_expr exp1;
                print_symType symbolType linenum;
                symbolType
            end
        | Indexexpr(exp1, exp2, _, symt) -> 
            begin
                print_expr exp1;(*put array ref on stack*)
                print_expr exp2;(*put array index on stack*)
                (*if assignment -> load value, call iastore*)
                (*print_string "iaload"*)
            end
        | Unaryexpr(exp1, _, _) -> print_expr exp1
        | Binaryexpr(exp1, _, _) -> print_expr exp1
        | FuncCallExpr(exp1, exprs, _, symt) -> 
            begin
                print_string "( ";
                print_expr exp1;
                print_string "(";
                print_expr_list exprs;
                print_string ")";
                print_string " )";
                symt;
            end
        | UnaryPlus(exp1, _, symt) -> 
            begin
                print_string "( +";
                print_expr exp1;
                print_string " )";
                symt;
            end
        | UnaryMinus(exp1, _, symt) ->
            begin
                print_string "( -";
                print_expr exp1;
                print_string " )";
                symt
            end
        | UnaryNot(exp1, _, symt) ->
            begin
                print_string "( !";
                print_expr exp1;
                print_string " )";
                symt
            end
        | UnaryCaret(exp1, _,symt) ->
            begin
                print_string "( ^";
                print_expr exp1;
                print_string " )";
                symt
            end
        | Value(value, _, symt) -> print_literal value; symt;
        | Selectorexpr(exp1, Identifier(iden, _), linenum, symbolType) ->
                (*TODO: determine if put or get *)
            begin
                print_string "getfield ";
                print_expr exp1;
                print_symType symbolType linenum;
                symbolType
            end
        | TypeCastExpr(typename, exp1, linenum, symbolType) ->
            let pType = get_primitive_type typename in 
            (
            match symbolType, pType with
            | SymInt, SymInt -> print_expr exp1; symbolType;
            | SymInt, SymFloat64 -> print_expr exp1; print_string "i2f"; symbolType;
            | SymInt, SymRune -> print_expr exp1; symbolType;
            | SymInt, SymBool -> print_expr exp1; symbolType;
            | SymInt,_ -> (let errMsg = "Cannot cast expr of type int at line: "^string_of_int linenum in code_gen_error errMsg) ; symbolType;
            | SymFloat64, SymFloat64 -> print_expr exp1; symbolType;
            | SymFloat64, SymInt -> print_expr exp1; print_string "f2i"; symbolType;
            | SymFloat64, SymRune-> print_expr exp1; print_string "f2i"; symbolType;
            | SymFloat64, SymBool-> print_expr exp1; print_string "f2i"; symbolType;
            | SymFloat64,_ -> (let errMsg = "Cannot cast expr of type float64 at line: "^string_of_int linenum in code_gen_error errMsg) ; symbolType;
            | SymRune, SymRune -> print_expr exp1 ; symbolType;
            | SymRune, SymInt -> print_expr exp1 ; symbolType;
            | SymRune, SymBool -> print_expr exp1 ; symbolType;
            | SymRune, SymFloat64-> print_expr exp1; print_string "i2f"; symbolType;
            | SymRune,_ -> (let errMsg = "Cannot cast expr of type rune at line: "^string_of_int linenum in code_gen_error errMsg) ; symbolType;
            | SymBool , SymRune -> print_expr exp1 ; symbolType;
            | SymBool , SymInt -> print_expr exp1 ; symbolType;
            | SymBool , SymBool -> print_expr exp1 ; symbolType;
            | SymBool ,  SymFloat64-> print_expr exp1; print_string "i2f"; symbolType;
            | SymRune,_ -> (let errMsg = "Cannot cast expr of type bool at line: "^string_of_int linenum in code_gen_error errMsg) ; symbolType;
            | _,_ -> (let errMsg = "Cannot cast expr at line: "^string_of_int linenum in code_gen_error errMsg) ; symbolType;
            )
            
        | Appendexpr(Identifier(iden, _),exp1, linenum, symType)-> 
            begin
                generate_load symType iden linenum;
                print_string "arraylength";
                print_string "iconst_1";
                print_string "iadd";
                (*TODO: FINISH ALGO*) 
                symType;
            end

        | _ -> code_gen_error ("expression error")
    and print_expr_list expr_list = match expr_list with
        | [] -> ()
        | head::[] -> print_expr head;()
        | head::tail ->
            begin
                print_expr head;
                print_string ", ";
                print_expr_list tail;
            end
    and generate_comparable_binary_ints optype= 
                  println_one_tab ("if_icmp"^optype^" "^"true"^(string_of_int !labelcounttrue));
                  println_one_tab ("iconst_0");
                  println_one_tab ("goto stop"^(string_of_int !labelcountfalse));
                  println_one_tab ("true"^(string_of_int !labelcounttrue)^":");
                  println_one_tab ("iconst_1");
                  println_one_tab ("stop"^(string_of_int !labelcountfalse)^":");
                  labelcountertrue();
                  labelcounterfalse();    
    in
    let string_method_return_type return_type = match return_type with
        | FuncReturnType(type_i, _) -> string_jasmin_type type_i
        | Empty -> "V"
    in
    let print_var_default_value typename = match typename with 
        | Definedtype(Identifier(value, _), _) -> () (*TO BE IMPLEMENTED*)
        | Primitivetype(value, _) -> 
            (match value with
                | "int" -> println_one_tab  "iconst_0"
                | "rune" -> println_one_tab  "iconst_0"
                | "bool" -> println_one_tab  "iconst_0"
                | "string" -> println_one_tab  "ldc \"\""
                | "float64" -> println_one_tab  "fconst_0"
            )
        | Arraytype(len, type_name2, _)-> () (*TO BE IMPLEMENTED*)
        | Slicetype(type_name2, _)-> () (*TO BE IMPLEMENTED*)
        | Structtype([], _) -> () (*TO BE IMPLEMENTED*)
        | Structtype(field_dcl_list, _) -> () (*TO BE IMPLEMENTED*)
    in
    let emit_var_decl typename iden = 
        begin
            print_var_default_value typename;
            add_variable_to_current_scope (Printf.sprintf "%d" ((!localcount))) iden;
            localcounter();
            println_one_tab (generate_store (get_primitive_type typename) iden);
        end
    in
    let print_var_decl level decl = match decl with
        | VarSpecWithType(iden_list, typename, exprs, _) -> 
            if exprs = [] then
                begin
                    List.map (emit_var_decl typename) iden_list;
                    ();
                end
            else
                begin
                    print_tab (level);
                    print_string "var ";
                    print_identifier_list iden_list;
                    print_string " ";
                    print_type_name level typename;
                    print_string " = ";
                    print_expr_list exprs;
                    print_string ";\n";     
                end
        | VarSpecWithoutType (iden_list, exprs, _) -> 
            if exprs = [] then
                begin
                    print_tab (level);
                    print_string "var ";
                    print_identifier_list iden_list;
                    print_string ";\n"; 
                end
            else
                begin
                    print_tab (level);
                    print_string "var ";
                    print_identifier_list iden_list;
                    print_string " = ";
                    print_expr_list exprs;
                    print_string ";\n";                
                end
        | _ -> ast_error ("var_dcl error")
    in
    let print_type_decl level decl = match decl with
        | TypeSpec(Identifier(iden, _), typename, _)->
            begin
                print_tab (level);
                print_string "type ";
                print_string iden;
                print_string " ";
                print_type_name level typename;
                print_string "\n"
            end
        | _ -> ast_error ("type_dcl error")
    in
    let print_inc_dec_stmt stmt = match stmt with 
        | Increment(expr, _) ->
            begin
                print_expr expr;
                print_string "++";
            end
        | Decrement(expr, _) ->
            begin
                print_expr expr;
                print_string "--";
            end
    in
    let generate_assign_expr_lh expr exprtype= match expr with 
        | OperandName(iden,linenum,ast_type) -> generate_store exprtype (Identifier(iden,linenum))
        | Indexexpr(expr1,expr2,linenum,ast_type) -> "" (*NOT IMPLEMENTED*)
        | Selectorexpr(exp1,Identifier(iden,linenum1),linenum2,ast_type) -> "" (*NOT IMPLEMENTED*)
        | _ -> code_gen_error "Lvalue function error"
    in 
    let generate_assignment expr1 expr2 = 
        let exprtype = print_expr expr2 in 
            println_one_tab (generate_assign_expr_lh expr1 exprtype);
    in
    let print_assignment_stmt stmt = match stmt with 
        | AssignmentBare(exprs1, exprs2, _) ->
            begin
                apply_func_on_element_from_two_lsts exprs1 exprs2 generate_assignment;
            end
        | AssignmentOp(exprs1, assign_op, exprs2, _) ->
            begin
                print_expr exprs1;
                print_string assign_op;
                print_expr exprs2;
                ()
            end
    in
    let print_short_var_decl_stmt dcl = match dcl with
        | ShortVarDecl(idens, exprs, _) ->
            begin
                print_identifier_list idens;
                print_string " := ";
                print_expr_list exprs;
            end
    in
    let print_simple_stmt stmt = match stmt with 
        | SimpleExpression(expr, _) -> print_expr expr;()
        | IncDec(incdec, _) -> print_inc_dec_stmt incdec 
        | Assignment(assignment_stmt, _) -> print_assignment_stmt assignment_stmt
        | ShortVardecl(short_var_decl, _) -> print_short_var_decl_stmt short_var_decl
        | Empty -> ()
    in
    let rec print_stmt level stmt = match stmt with
        | Declaration(decl, _) -> 
            (match decl with
                | TypeDcl([], _) -> ()
                | TypeDcl(decl_list, _) -> List.iter (print_type_decl level) decl_list
                | VarDcl([], _) ->  ()
                | VarDcl(decl_list, _) -> List.iter (print_var_decl level) decl_list
                | Function(func_name, func_sig, stmt_list, line) ->
                    begin
                        add_func func_name func_sig;
                        print_method_decl func_name func_sig stmt_list;
                    end
                | _ -> ()
            )
        | Return(rt_stmt, _) -> 
            let print_return_stmt level stmt = match stmt with
                | ReturnStatement(expr, _) -> 
                    begin
                        print_expr expr;
                        ();
                    end
                | Empty -> ()
            in
            print_return_stmt level rt_stmt
        | Break(_) -> 
            begin
                print_tab level;
                print_string "break\n";
            end
        | Continue(_) ->
            begin
                print_tab level;
                print_string "continue\n";
            end
        | Block(stmt_list, _) -> print_stmt_list (level+1) stmt_list
        | Conditional(conditional, _) ->  (*DONE*)
            let print_if_init if_init = match if_init with
                | IfInitSimple(simplestmt, _) ->
                    begin
                        print_simple_stmt simplestmt;
                    end
                | Empty -> ()
            in
            let print_if_cond cond = match cond with (*DONE*)
                | ConditionExpression(expr, _) -> print_expr expr;()
                | Empty -> ()
            in
            let print_if_stmt level if_stmt = match if_stmt with
                | IfInit(if_init, condition, stmts, _) -> (*DONE*)
                    begin
                        start_scope();
                        print_if_init if_init;
                        print_if_cond condition;
                        let currlabel= !labelcountfalse in 
                        labelcountertrue();
                        labelcounterfalse();
                        println_one_tab ("ifeq stop"^(string_of_int currlabel));
                        start_scope();
                        print_stmt_list 1 stmts;
                        end_scope();
                        println_one_tab ("stop"^(string_of_int currlabel)^":");
                    end
            in
            let print_if_stmt_with_else level if_stmt = match if_stmt with (*DONE*)
                | IfInit(if_init, condition, stmts, _) -> 
                    begin
                        start_scope();
                        print_if_init if_init;
                        print_if_cond condition;
                        let curr_else_label= !labelcountfalse in 
                        labelcountertrue();
                        labelcounterfalse();
                        println_string_with_tab 1 ("ifeq stop"^(string_of_int curr_else_label));
                        start_scope();
                        print_stmt_list 1 stmts;
                        end_scope();
                        let curr_stop_label= !labelcountfalse in 
                        println_string_with_tab 1 ("goto stop"^(string_of_int curr_stop_label));
                        println_string_with_tab 1 ("stop"^(string_of_int curr_else_label)^":");


                    end
            in
            let rec print_else_stmt level stmt =  match stmt with 
                | ElseSingle(if_stmt, stmts, _) -> (*DONE*)
                    begin
                        print_if_stmt_with_else 1 if_stmt;
                        let curr_stop_label= !labelcountfalse in 
                        labelcountertrue();
                        labelcounterfalse();
                        start_scope();
                        print_stmt_list 1 stmts;
                        end_scope();
                        println_string_with_tab 1 ("stop"^(string_of_int curr_stop_label)^":");
                    end
                | ElseIFMultiple(if_stmt, else_stmt, _) -> (*DONE*)
                    begin
                        print_if_stmt_with_else 1 if_stmt;
                        let curr_stop_label= !labelcountfalse in 
                        labelcountertrue();
                        labelcounterfalse();
                        print_else_stmt 1 else_stmt;
                        println_string_with_tab 1 ("stop"^(string_of_int curr_stop_label)^":");
                    end
                | ElseIFSingle(if_stmt1, if_stmt2, _) -> (*DONE*)

                    begin
                        print_if_stmt_with_else 1 if_stmt1;
                        let curr_stop_label= !labelcountfalse in 
                        labelcountertrue();
                        labelcounterfalse();
                        
                        print_if_stmt_with_else 1 if_stmt2;
                        let curr_stop_label2= !labelcountfalse in 
                        labelcountertrue();
                        labelcounterfalse();
                        

                        println_string_with_tab 1 ("stop"^(string_of_int curr_stop_label)^":");
                        println_string_with_tab 1 ("stop"^(string_of_int curr_stop_label2)^":");

                    end
            in
            let print_conditional_stmt level cond = match cond with (*needs testing*)
                | IfStmt(if_stmt, _) -> 
                    begin
                        print_if_stmt 1 if_stmt;
                        end_scope();
                    end
                | ElseStmt(else_stmt, _) ->
                    begin
                        print_else_stmt level else_stmt;
                        end_scope();
                    end
            in
            print_conditional_stmt level conditional
        | Simple(simple, _) -> 
            begin
                print_simple_stmt simple;
            end
        | Print(exprs, _) -> 
            begin
                println_one_tab "getstatic java/lang/System/out Ljava/io/PrintStream;";
                print_expr_list exprs;
                println_one_tab "invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V";
            end
        | Println(exprs, _) -> 
            begin
                println_one_tab "getstatic java/lang/System/out Ljava/io/PrintStream;";
                print_expr_list exprs;
                println_one_tab "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V";
            end
        | For(for_stmt, _) ->
            let print_for_cond cond = match cond with 
                | ConditionExpression(expr, _) -> print_expr expr;()
                | Empty -> ()
            in
            let print_for_clause clause = match clause with 
                | ForClauseCond(simple1, condition, simple2, _) -> 
                    begin
                        print_simple_stmt simple1;
                        print_string "; ";
                        print_for_cond condition;
                        print_string "; ";
                        print_simple_stmt simple2;
                    end
            in
            let print_for_stmt level stmt = match stmt with 
                | Forstmt(stmts, _) ->
                    begin
                        print_tab (level);
                        print_string "for {\n";
                        print_stmt_list (level+1) stmts;
                        print_tab (level);
                        print_string "}\n";
                    end
                | ForCondition(condition, stmts, _) -> 
                    begin
                        print_tab (level);
                        print_string "for ";
                        print_for_cond condition;
                        print_string " {\n";
                        print_stmt_list (level+1) stmts;
                        print_tab (level);
                        print_string "}\n";
                    end
                | ForClause (for_clause, stmts, _) ->
                    begin
                        print_tab (level);
                        print_string "for ";
                        print_for_clause for_clause;
                        print_string " {\n";
                        print_stmt_list (level+1) stmts;
                        print_tab (level);
                        print_string "}\n";
                    end
            in
            print_for_stmt level for_stmt
        | Switch(switch_clause, switch_expr, switch_case_stmts, _) -> 
            let print_switch_clause clause = match clause with
                | SwitchClause(simple_stmt, _) -> 
                    begin
                        print_simple_stmt simple_stmt;
                        print_string "; ";
                    end
                | Empty -> ()
            in
            let print_switch_expr expr = match expr with 
                | SwitchExpr(expr, _)->
                    begin
                        print_expr expr;
                        print_string " ";
                    end
                | Empty -> ()
            in
            let print_switch_case_clause level clause = match clause with 
                | SwitchCaseClause(exprs, stmts, _) -> 
                    (match exprs with
                        | [] -> 
                            begin
                                print_tab (level);
                                print_string "default :\n";
                                print_stmt_list (level+1) stmts;
                            end
                        | head::tail ->
                            begin
                                print_tab (level);
                                print_string "case ";
                                print_expr_list exprs;
                                print_string " :\n";
                                print_stmt_list (level+1) stmts;
                            end
                    )
                | Empty -> ()   
            in
            let print_switch_case_stmt level stmts = match stmts with
                | SwitchCasestmt([], _) -> ()
                | SwitchCasestmt(switch_case_clauses, _) -> List.iter (print_switch_case_clause level) switch_case_clauses
            in       
            begin
                print_tab (level);
                print_string "switch ";
                print_switch_clause switch_clause;
                print_switch_expr switch_expr;
                print_string "{\n";
                print_switch_case_stmt (level+1) switch_case_stmts;
                print_tab (level);
                print_string "}\n";
            end
        | _ -> ()
    and print_stmt_list level stmt_list = match stmt_list with
        | [] -> ()
        | head::[] -> print_stmt level head
        | head::tail ->
            begin
                print_stmt level head;
                print_stmt_list level tail;
            end
    and print_method_return return_type = match return_type with
        | FuncReturnType(return_type_i, _) -> 
            (match return_type_i with
                    | Primitivetype(value, _) -> 
                        (match value with
                            | "int" -> println_one_tab "ireturn"
                            | "float64" -> println_one_tab "freturn"
                            | "bool" -> println_one_tab "ireturn"
                            | _ -> println_one_tab "areturn"
                        )   
                    | _ -> println_one_tab "areturn"
            )
        | Empty -> println_one_tab "return"
    and print_method_decl func_name signature stmt_list = match signature with
        | FuncSig(FuncParams(func_params, _), return_type, _) ->
            begin
                println_string (Printf.sprintf ".method public static %s(%s)%s" func_name "" (string_method_return_type return_type));
                println_one_tab ".limit stack 99";
                println_one_tab  ".limit locals 99";
                print_stmt_list 1 stmt_list;
                print_method_return return_type;
                println_string ".end method\n";
            end
    and print_decl level decl = match decl with
        | TypeDcl([], _) -> ()
        | TypeDcl(decl_list, _) -> List.iter (print_type_decl level) decl_list
        | VarDcl([], _) ->  ()
        | VarDcl(decl_list, _) -> List.iter (print_var_decl level) decl_list
        | Function(func_name, signature, stmt_list, line) ->
            match func_name with
            | "main" ->
                begin
                    start_scope ();
                    println_string ".method public static main([Ljava/lang/String;)V";
                    println_one_tab ".limit stack 99";
                    println_one_tab ".limit locals 99";
                    print_stmt_list 1 stmt_list;
                    println_string "";
                    println_one_tab "return";
                    println_string ".end method";
                end
            | _ ->
                begin
                    add_func func_name signature;
                    print_method_decl func_name signature stmt_list;
                end
        | _ -> ()
    and print_decl_list level decl_list = 
        List.iter (print_decl level) decl_list
    in
    begin
        jasmin_main_class := filename;
        print_class_header filename;
        print_init_header filename;
        print_decl_list 0 decl_list;
        close_out output_file
    end