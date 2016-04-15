open Printf
open Ast
open Symboltbl 

exception Code_generation_error of string
let code_gen_error msg = raise (Code_generation_error msg)

let jasmin_main_class = ref "GoFile"
let jasmin_file_dir = ref "/"

(* ------------ Stack functions for locals manipulation ------------ *)

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

let search_iden_not_find_current_scope iden = match iden with
    | Identifier(x,_) -> 
        (match !symbol_table with
            | Scope(current_scope)::tail -> 
                if (Hashtbl.mem current_scope x) then true else false
        )

let rec search_previous_scopes x table = match table with (*called with !symbol_table*)
    | []-> code_gen_error ("variable is not defined in current and previous scopes")
    | Scope(current_scope)::tail -> 
        if (Hashtbl.mem current_scope x) then 
            Hashtbl.find current_scope x
        else 
            search_previous_scopes x tail

let add_variable_to_current_scope count iden = match iden with
    | Identifier(myvariable,linenum) -> 
        (match !symbol_table with
            | Scope(current_scope)::tail ->
                if not(Hashtbl.mem current_scope myvariable) then 
                    Hashtbl.add current_scope myvariable count
                else
                    code_gen_error ("variable is defined more than one time")
        )

let rec get_sym_type type_of_type_i = match type_of_type_i with
    | Primitivetype(value, _) -> 
        (match value with
            | "int" -> SymInt
            | "rune" -> SymRune
            | "bool" -> SymBool
            | "string" -> SymString
            | "float64" -> SymString
        )
    | Arraytype(len, type_name2, _)-> SymArray((get_sym_type type_name2))
    | Definedtype(Identifier(value, _), _,_) -> Void (*TO BE IMPLEMENTED*)
    | Slicetype(type_name2, _)-> SymSlice((get_sym_type type_name2))
    | Structtype([], _) -> SymStruct([])
    | Structtype(field_dcl_list, _) -> SymStruct([]) (*TO BE IMPLEMENTED*)

let rec sym_to_type symt = match symt with
    | SymInt -> "int"
    | SymFloat64 -> "float"
    | SymRune -> "char"
    | SymString -> "[Ljava/lang/String;"
    | SymBool -> "boolean"
    | SymArray(subType) ->"["^sym_to_type subType  
    | SymSlice(subType) -> "["^sym_to_type subType  
    | SymStruct(fieldlist) -> "struct" (*this needs to be fixed*) 
    | _ -> ""
    
let is_immediate exp_type linenum = match exp_type with
    | SymInt -> true 
    | SymFloat64 -> true 
    | SymRune -> true
    | SymString -> false 
    | SymBool -> true
    | SymArray(subType) -> false 
    | SymSlice(subType) -> false
    | SymStruct(fieldlist) -> false
    | SymFunc(subType,arglist) -> false
    | SymType(subType) -> false
    | Void -> true
    | NotDefined -> (let errMsg = "Symtype wasnt attached in type checking at line: "^string_of_int linenum in code_gen_error errMsg)

let get_expr_type exp1 = match exp1 with
	| OperandName(_,_,symType)-> symType
	| AndAndOp(_,_,_,symType)-> symType
	| OrOrOp(_,_,_,symType)-> symType
	| EqualEqualCmp(_,_,_,symType)-> symType
	| NotEqualCmp(_,_,_,symType)-> symType
	| LessThanCmp(_,_,_,symType)-> symType
	| GreaterThanCmp(_,_,_,symType)-> symType
	| LessThanOrEqualCmp(_,_,_,symType)-> symType
	| GreaterThanOrEqualCmp(_,_,_,symType)-> symType
	| AddOp(_,_,_,symType)-> symType
	| MinusOp(_,_,_,symType)-> symType
	| OrOp(_,_,_,symType)-> symType
	| CaretOp(_,_,_,symType)-> symType
	| MulOp(_,_,_,symType)-> symType
	| DivOp(_,_,_,symType)-> symType
	| ModuloOp(_,_,_,symType)-> symType
	| SrOp(_,_,_,symType)-> symType
	| SlOp(_,_,_,symType)-> symType
	| AndOp(_,_,_,symType)-> symType
	| AndCaretOp(_,_,_,symType)-> symType
	| OperandParenthesis(_,_,symType)-> symType
	| Indexexpr(_,_,_,symType)-> symType
	| Unaryexpr(_,_,symType)-> symType
	| Binaryexpr(_,_,symType)-> symType
	| FuncCallExpr(_,_,_,symType)-> symType
	| UnaryPlus(_,_,symType)-> symType
	| UnaryMinus(_,_,symType)-> symType
	| UnaryNot(_,_,symType)-> symType
	| UnaryCaret(_,_,symType)-> symType
	| Value(_,_,symType)-> symType
	| Selectorexpr(_,_,_,symType)-> symType
	| TypeCastExpr(_,_,_,symType)	-> symType
    | Appendexpr(_,_,_,symType)-> symType

let generate_load typename varname linenum = match typename with 
    | SymInt -> "iload"^" "^(search_previous_scopes varname !symbol_table)
    | SymFloat64 -> "fload"^" "^(search_previous_scopes varname !symbol_table)
    | SymRune -> "iload"^" "^(search_previous_scopes varname !symbol_table)
    | SymString -> "aload"^" "^(search_previous_scopes varname !symbol_table)
    | SymBool -> "iload"^" "^(search_previous_scopes varname !symbol_table)
    | NotDefined -> (let errMsg ="type wasnt attached in type checking at line: "^string_of_int linenum  in code_gen_error errMsg)
    | _ ->"aload"^" "^(search_previous_scopes varname !symbol_table)


let generate_store typename varnameIden = match typename, varnameIden with 
    | SymInt, Identifier(varname,_) -> "istore"^" "^(search_previous_scopes varname !symbol_table)
    | SymFloat64, Identifier(varname,_) -> "fstore"^" "^(search_previous_scopes varname !symbol_table)
    | SymRune, Identifier(varname,_) -> "istore"^" "^(search_previous_scopes varname !symbol_table)
    | SymString, Identifier(varname,_) -> "astore"^" "^(search_previous_scopes varname !symbol_table)
    | SymBool, Identifier(varname,_) -> "istore"^" "^(search_previous_scopes varname !symbol_table)
    | _,Identifier(varname,_) -> "astore"^" "^(search_previous_scopes varname !symbol_table) (*TODO: place holder *)

let apply_func_on_element_from_two_lsts lst1 lst2 func = match lst1,lst2 with 
    | [],[]-> ()
    | head1::tail1,head2::tail2-> func head1 head2

let rec combine_two_lists list1 list2 = match list1, list2 with
    | head1::[], head2::[] -> (head1, head2)::[]
    | head1::tail1, head2::tail2 -> (head1, head2)::(combine_two_lists tail1 tail2)

(* --------------------------------END-------------------------------- *)

(* ----------------------- Function call table ----------------------- *)

(* Store a table of function name => Jasmin function invocation string *)
type funcTable = (string, string) Hashtbl.t;;
let (func_table : funcTable) = Hashtbl.create 1234;;

(* Refer to print_type_name in prettyPrinter *)
let string_jasmin_type go_type = match go_type with 
    | Definedtype(Identifier(value, _), _,_) -> value
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
let init_func func_name func_sig = match func_sig with
    | FuncSig(FuncParams(params_list, _), FuncReturnType(return_type_i, _), _) ->
        Hashtbl.add func_table func_name (!jasmin_main_class^"/"^func_name^"("^(string_method_params_types params_list)^")"^(string_jasmin_type return_type_i))
    | FuncSig(FuncParams(params_list, _), _, _) ->
        Hashtbl.add func_table func_name (!jasmin_main_class^"/"^func_name^"("^(string_method_params_types params_list)^")V")
let invoke_func func_name = "invokestatic "^(Hashtbl.find func_table func_name)

(* --------------------------------END-------------------------------- *)

(* ----------------------- Struct manipulation ----------------------- *)

(* Store a table of struct type name => jasmin class string *)
type structTable = (string, string) Hashtbl.t;;
let (struct_table : structTable) = Hashtbl.create 1234;;

type structVarTable = (string, string) Hashtbl.t;;
let (struct_var_table : structVarTable) = Hashtbl.create 1234;;

let init_struct_type field_dcl_list struct_iden = 
    let struct_class_name = !jasmin_main_class^"_struct_"^struct_iden in 
    let struct_filename = !jasmin_file_dir^(Filename.dir_sep)^struct_class_name^".j" in
    let struct_file = open_out struct_filename in
    let print_struct_string s = output_string struct_file s in
    let println_struct_string s = output_string struct_file (s^"\n") in
    let println_struct_one_tab s = print_struct_string (String.make 1 '\t'); println_struct_string s in
    let print_struct_field_type type_name identifier = match identifier, type_name with
        | Identifier(field_iden, _), Definedtype(Identifier(value, _), _,_) -> () (* TODO *)
        | Identifier(field_iden, _), Primitivetype(value, _) ->
            (match value with
            | "int" -> println_struct_string (".field "^field_iden^" I")
            | "rune" -> println_struct_string (".field "^field_iden^" C")
            | "bool" -> println_struct_string (".field "^field_iden^" Z")
            | "string" -> println_struct_string (".field "^field_iden^" [Ljava/lang/String;")
            | "float64" -> println_struct_string (".field "^field_iden^" F")
            | _ -> code_gen_error ("unknown struct field type"))
        | Identifier(field_iden, _), Arraytype(len, type_name2, _) -> () (* TODO *)
        | Identifier(field_iden, _), Slicetype(type_name2, _) -> () (* TODO *)
        | Identifier(field_iden, _), Structtype([], _) -> () (* TODO *)
        | Identifier(field_iden, _), Structtype(dcl_list, _) -> () (* TODO *)
    in
    let print_struct_field field = match field with 
        | (iden_list,type_name) -> List.iter (print_struct_field_type type_name) iden_list 
        | _ -> ast_error ("field_dcl_print error")
    in
    begin
        (* Store struct name => jasmin class filename *)
        Hashtbl.add struct_table struct_iden struct_class_name;
        (* Print separate jasmin class file *)
        println_struct_string (".class public "^struct_class_name^"");
        println_struct_string ".super java/lang/Object\n";
        (* Print fields *)
        List.iter print_struct_field field_dcl_list;
        println_struct_string "\n.method public <init>()V";
        println_struct_one_tab ".limit locals 99";
        println_struct_one_tab ".limit stack 99";
        println_struct_one_tab "aload_0";
        println_struct_one_tab "invokenonvirtual java/lang/Object/<init>()V";
        println_struct_one_tab "return";
        println_struct_string ".end method";
        close_out struct_file
    end
let invoke_struct struct_iden = Hashtbl.find struct_table struct_iden

let is_struct_type struct_iden =
    if (Hashtbl.mem struct_table struct_iden) then true else false

let store_struct_var iden struct_class = match iden with
    | Identifier(var_name, _) -> Hashtbl.add struct_var_table var_name struct_class

let retrieve_struct_class_from_var struct_iden = Hashtbl.find struct_var_table struct_iden


(* let search_struct_field_type var_name field_name =
    let field_dcl_list = Hashtbl.find struct_table var_name in () *)
        (* (identifier list * type_i) *)


(* --------------------------------END-------------------------------- *)

(* ------------------------ Type manipulation ------------------------ *)

type typeTable = (string, symType) Hashtbl.t;;
let (type_table : structTable) = Hashtbl.create 1234;;

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
        | Definedtype(Identifier(value, _), _,_) -> print_string value
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
        | OperandName(value, linenum, symt) -> 
                (match value with 
                | "true"-> println_string_with_tab 1 "iconst_1"; symt
                | "false"-> println_string_with_tab 1 "iconst_0"; symt
                | _ ->  println_one_tab (generate_load symt value linenum); symt)
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
        | Indexexpr(exp1, exp2, linenum, symt) -> 
            begin
                let exp_type = get_expr_type exp1 in
                let symtype = (match exp_type with
                    |SymArray(inner) -> inner
                    |_ -> let errMsg = "not an array at line "^string_of_int(linenum) in code_gen_error errMsg
                ) in
                let is_i = is_immediate symtype linenum in 
                print_expr exp1; (*put array ref on stack*)
                print_expr exp2; (*put array index on stack*) 
                print_tab 1;
                if is_i then println_string "iaload" else println_string "aaload";
                symt;
            end
        
        | Selectorexpr(exp1, Identifier(iden,_), linenum1, symt1) ->
            (match exp1 with 
                | OperandName(struct_var_name, linenum, symt) ->
                    let rec find_field field_iden field_list =
                        match field_list with
                            | [] -> NotDefined
                            | (field_name, sym_type)::tail -> if field_name = field_iden then sym_type
                                                    else find_field field_iden tail
                    in
                    let struct_class = retrieve_struct_class_from_var struct_var_name in
                    let symt2 = (print_expr exp1) in
                    (match symt2 with 
                        | SymType(SymStruct(field_list)) -> let field_sym_type = find_field iden field_list in
                            (match field_sym_type with
                                | SymInt -> println_one_tab ("getfield "^struct_class^"/"^iden^" "^"I")
                                | SymFloat64 -> println_one_tab ("getfield "^struct_class^"/"^iden^" "^"F")
                                | SymRune -> println_one_tab ("getfield "^struct_class^"/"^iden^" "^"C")
                                | SymString -> println_one_tab ("getfield "^struct_class^"/"^iden^" "^"[Ljava/lang/String;")
                                | SymBool -> println_one_tab ("getfield "^struct_class^"/"^iden^" "^"Z")
                                | SymArray(sym_type) -> ()
                                | SymSlice(sym_type) -> ()
                                | SymStruct(fields) -> ()
                                | NotDefined -> ()
                            )
                        | _ -> code_gen_error ("struct type does not resolve")
                    );
                    symt1
                (* Do nested structs *)
                | _ -> code_gen_error ("selector type does not resolve")
            )
        | TypeCastExpr(typename, exp1, linenum, symbolType) ->
            let pType = get_sym_type typename in 
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
            let exp1_type = get_expr_type exp1 in
            let is_i = is_immediate exp1_type linenum in 
            let expType = sym_to_type exp1_type in
            begin
                generate_load symType iden linenum;
                println_string "arraylength";
                println_string "iconst_1";
                println_string "iadd";
                if is_i then (let ade="newarray "^expType in println_string ade) else( let ade ="anewarray "^expType in println_string ade);
                println_string "dup";
                println_string "dup";
                println_string "dup";
                generate_load symType iden linenum;
                println_string "swap";
                println_string "iconst_0";
                println_string "swap";
                println_string "iconst_0";
                generate_load symType iden linenum;
                println_string "arraylength";
                println_string "invokestatic java/lang/System.arraycopy:(Ljava/lang/Object;ILjava/lang/Object;II)V";
                generate_load symType iden linenum;
                println_string "arraylength";
                print_expr exp1;
                if is_i then println_string "iastore" else println_string "aastore" ;
                println_string (generate_store symType (Identifier(iden,linenum)));
                symType;
            end

        | _ -> code_gen_error ("expression error")
    and print_expr_list_switch expr_list start_label = match expr_list with
        | [] -> ()
        | head::[] ->
            begin
                print_tab 1;
                println_string "dup";
                print_expr head;
                print_tab 1;
                println_string ("ifeq "^start_label);
            end
        | head::tail ->
            begin
                print_tab 1;
                println_string "dup";
                print_expr head;
                print_tab 1;
                println_string ("ifeq "^start_label);
                print_expr_list_switch tail start_label;
            end
    and print_expr_list expr_list = match expr_list with
        | [] -> ()
        | head::[] -> print_expr head;()
        | head::tail ->
            begin
                print_expr head;
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
    let print_var_decl_default_value type_i iden = match type_i with 
        (* ONLY USED FOR STRUCTS ? *)
        | Definedtype(Identifier(value, _), _,_) -> 
            if (is_struct_type value) then
                let struct_class = invoke_struct value in
                    begin
                        store_struct_var iden struct_class;
                        println_one_tab ("new "^struct_class);
                        println_one_tab "dup";
                        println_one_tab ("invokenonvirtual "^struct_class^"/<init>()V")            
                    end
        | Primitivetype(value, _) -> 
            (match value with
                | "int" -> println_one_tab  "iconst_0"
                | "rune" -> println_one_tab  "iconst_0"
                | "bool" -> println_one_tab  "iconst_0"
                | "string" -> println_one_tab  "ldc \"\""
                | "float64" -> println_one_tab  "fconst_0"
            )
        | Arraytype(len, type_i2, _)-> () (*TO BE IMPLEMENTED*)
        | Slicetype(type_i2, _)-> () (*TO BE IMPLEMENTED*)
        | Structtype([], _) -> () (*TO BE IMPLEMENTED*)
        | Structtype(field_dcl_list, _) -> ()
    in
    let emit_var_decl type_i iden = 
        begin
            print_var_decl_default_value type_i iden;
            add_variable_to_current_scope (Printf.sprintf "%d" ((!localcount))) iden;
            localcounter();
            println_one_tab (generate_store (get_sym_type type_i) iden);
        end
    in
    let emit_var_decl_expr (iden, expr) =
        let symt = print_expr expr in
            begin 
                add_variable_to_current_scope (Printf.sprintf "%d" ((!localcount))) iden;
                localcounter();
                println_one_tab (generate_store symt iden);
            end
    in
    let print_var_decl level decl = match decl with
        (* STRUCT ARE DECLARED HERE, ALONG PRIMITIVES, ARRAYS AND SLICES *)
        | VarSpecWithType(iden_list, type_i, exprs, _) ->
            (match exprs with
            | [] -> List.iter (emit_var_decl type_i) iden_list
            | _ -> List.iter emit_var_decl_expr (combine_two_lists iden_list exprs)
            )
        (* NO STRUCT DECLARED HERE ONLY PRIMITIVES, ARRAYS AND SLICES *)
        | VarSpecWithoutType (iden_list, exprs, _) -> List.iter emit_var_decl_expr (combine_two_lists iden_list exprs)
        | _ -> ast_error ("var_dcl error")
    in
    let generate_assign_expr_lh expr exprtype= match expr with 
        | OperandName(iden,linenum,ast_type) -> generate_store exprtype (Identifier(iden,linenum))
            (* STRUCT ASSIGNMENT *)
        | Selectorexpr(exp1,Identifier(iden,linenum1),linenum2,ast_type) -> ""
        | _ -> code_gen_error "Lvalue function error"
    in 
    let generate_assignment expr1 expr2 = match expr1 with
        | OperandName(iden,linenum,ast_type) -> 
            let exprtype = print_expr expr2 in 
                println_one_tab (generate_assign_expr_lh expr1 exprtype); 
        | Indexexpr(exp1,exp2,linenum,ast_type) ->
                let exp_type = get_expr_type exp1 in
                let symtype = (match exp_type with
                    |SymArray(inner) -> inner
                    |_ -> let errMsg = "not an array at line "^string_of_int(linenum) in code_gen_error errMsg
                ) in
                let is_i = is_immediate symtype linenum in 
                print_expr exp1; (*put array ref on stack*)
                print_expr exp2; (*put array index on stack*) (* TODO: eval expression to immediate or ref*)
                print_expr expr2;
                print_tab 1;
                if is_i then println_string "iastore" else println_string "aastore";
                ();
        | Selectorexpr(exp1,Identifier(iden,linenum1),linenum2,ast_type) -> 
            print_expr expr2;
            (match exp1 with 
                | OperandName(struct_var_name, linenum, symt) ->
                    let rec find_field field_iden field_list =
                        match field_list with
                            | [] -> NotDefined
                            | (field_name, sym_type)::tail -> if field_name = field_iden then sym_type
                                                    else find_field field_iden tail
                    in
                    let struct_class = retrieve_struct_class_from_var struct_var_name in
                    let symt2 = (print_expr exp1) in
                    (match symt2 with 
                        | SymType(SymStruct(field_list)) -> let field_sym_type = find_field iden field_list in
                            (match field_sym_type with
                                | SymInt -> 
                                    begin
(*                                         println_one_tab (generate_load (SymStruct(field_list)) struct_var_name linenum2); *)
                                        println_one_tab "swap";
                                        println_one_tab ("putfield "^struct_class^"/"^iden^" "^"I");
                                    end
                                | SymFloat64 -> println_one_tab ("putfield "^struct_class^"/"^iden^" "^"F")
                                | SymRune -> println_one_tab ("putfield "^struct_class^"/"^iden^" "^"C")
                                | SymString -> println_one_tab ("putfield "^struct_class^"/"^iden^" "^"[Ljava/lang/String;")
                                | SymBool -> println_one_tab ("putfield "^struct_class^"/"^iden^" "^"Z")
                                | SymArray(sym_type) -> ()
                                | SymSlice(sym_type) -> ()
                                | SymStruct(fields) -> ()
                                | NotDefined -> ()
                            )
                        | _ -> code_gen_error ("struct type does not resolve")
                    )
                (* Do nested structs *)
                | _ -> code_gen_error ("selector type does not resolve")
            );
        | _ -> code_gen_error "Lvalue function error"
    in
    let print_inc_dec_stmt stmt = match stmt with 
        | Increment(expr, _) ->
            let exprtype = print_expr expr in
            begin
                print_tab 1;
                println_string "iconst_1";
                print_tab 1;
                println_string "iadd";
                println_one_tab (generate_assign_expr_lh expr exprtype);
            end
        | Decrement(expr, _) ->
            let exprtype = print_expr expr in
            begin
                print_tab 1;
                println_string "iconst_m1";
                print_tab 1;
                println_string "isub";
                println_one_tab (generate_assign_expr_lh expr exprtype);
            end
    in
    let print_assignment_stmt stmt = match stmt with 
        | AssignmentBare(exprs1, exprs2, _) ->
            begin
                apply_func_on_element_from_two_lsts exprs1 exprs2 generate_assignment; (*not working*)
            end
        | AssignmentOp(exprs1, assign_op, exprs2, _) ->
                let exprtype = print_expr exprs1 in
            begin
                print_expr exprs2;
                (*TODO: DO THIS FOR FLAOTS TOO*)
                (match assign_op with
                    | "+="-> println_one_tab "iadd";
                    | "-="-> println_one_tab "isub";
                    | "|="-> println_one_tab "ior";
                    | "^="-> println_one_tab "ixor";
                    | "*="-> println_one_tab "imul";
                    | "/="-> println_one_tab "idiv";
                    | "%="-> println_one_tab "irem";
                    | ">>="-> println_one_tab "ishr";
                    | "<<="-> println_one_tab "ishl";
                    |  "&="-> println_one_tab "iand";
                    |  "&^="-> println_one_tab "iand"; println_one_tab "ineg"; println_one_tab "iconst_m1"; println_one_tab "iadd";
                );
                println_one_tab (generate_assign_expr_lh exprs1 exprtype);
            end
    in
    let print_type_decl decl = match decl with
        | TypeSpec(Identifier(iden, _), type_i, _)->
            (match type_i with 
                | Structtype([], _) -> ()
                | Structtype(field_dcl_list, _) -> init_struct_type field_dcl_list iden
                | _ -> () (* Do nothing for type dcl *)
            )
        | _ -> ast_error ("type_dcl error")
    in
    let print_short_var_decl_stmt dcl = match dcl with
        | ShortVarDecl(idens, exprs, _) ->
            let short_var_decl_expr (iden, expr) =
                let symt = print_expr expr in
                    (match (search_iden_not_find_current_scope iden) with
                        | true ->
                            begin
                                add_variable_to_current_scope (Printf.sprintf "%d" ((!localcount))) iden;
                                localcounter();       
                            end
                        | false ->
                            begin
                                add_variable_to_current_scope (Printf.sprintf "%d" ((!localcount))) iden;
                                localcounter();    
                                println_one_tab (generate_store symt iden);
                            end
                    )     
            in
            List.iter short_var_decl_expr (combine_two_lists idens exprs)
    in
    let print_simple_stmt stmt = match stmt with 
        | SimpleExpression(expr, _) -> print_expr expr;()
        | IncDec(incdec, _) -> print_inc_dec_stmt incdec; ()
        | Assignment(assignment_stmt, _) -> print_assignment_stmt assignment_stmt
        | ShortVardecl(short_var_decl, _) -> print_short_var_decl_stmt short_var_decl
        | Empty -> ()
    in
    let rec print_stmt level stmt startlabel endlabel = match stmt with
        | Declaration(decl, _) -> 
            (match decl with
                | TypeDcl([], _) -> ()
                | TypeDcl(decl_list, _) -> List.iter print_type_decl decl_list
                | VarDcl([], _) ->  ()
                | VarDcl(decl_list, _) -> List.iter (print_var_decl level) decl_list
                | Function(func_name, func_sig, stmt_list, line) ->
                    begin
                        init_func func_name func_sig;
                        print_method_decl func_name func_sig stmt_list;
                    end
                | _ -> ()
            )
        | Return(rt_stmt, _) -> 
            let print_return_stmt level stmt = match stmt with
                | ReturnStatement(expr, _) ->
                    (match (print_expr expr) with
                        | SymInt -> println_one_tab "ireturn"
                        | SymFloat64 -> println_one_tab "freturn"
                        | SymRune -> println_one_tab "ireturn"
                        | SymString -> println_one_tab "areturn"
                        | SymBool -> println_one_tab "ireturn"
                        | NotDefined -> ()
                    )
                | Empty -> ()
            in
            print_return_stmt level rt_stmt
        | Break(_) -> 
            let breakpoint = "goto "^endlabel in
            begin
                print_tab level;
                print_string breakpoint;
            end
        | Continue(_) ->
            let contpoint = "goto "^startlabel in
            begin
                print_tab level;
                print_string contpoint; 
            end
        | Block(stmt_list, _) -> (*DONE*)
            begin
                start_scope();
                print_stmt_list (level+1) stmt_list startlabel endlabel;
                end_scope();
            end
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
            let print_if_stmt level if_stmt start_label end_label= match if_stmt with
                | IfInit(if_init, condition, stmts, _) -> (*DONE*)
                    begin
                        start_scope();
                        print_if_init if_init;
                        print_if_cond condition;
                        let currlabel= !labelcountfalse in 
                        let currlabelstr = "stop"^(string_of_int currlabel) in
                        labelcountertrue();
                        labelcounterfalse();
                        println_one_tab ("ifeq "^currlabelstr);
                        start_scope();
                        print_stmt_list 1 stmts start_label end_label;
                        end_scope();
                        println_one_tab ("stop"^(string_of_int currlabel)^":");
                    end
            in
            let print_if_stmt_with_else level if_stmt start_label end_label= match if_stmt with (*DONE*)
                | IfInit(if_init, condition, stmts, _) -> 
                    begin
                        start_scope();
                        print_if_init if_init;
                        print_if_cond condition;
                        let curr_else_label= !labelcountfalse in 
                        let currlabelstr = "stop"^(string_of_int curr_else_label) in
                        labelcountertrue();
                        labelcounterfalse();
                        println_string_with_tab 1 ("ifeq "^currlabelstr) ;
                        start_scope();
                        print_stmt_list 1 stmts start_label end_label; 
                        end_scope();
                        let curr_stop_label= !labelcountfalse in 
                        println_string_with_tab 1 ("goto stop"^(string_of_int curr_stop_label));
                        println_string_with_tab 1 ("stop"^(string_of_int curr_else_label)^":");
                    end
            in
            let rec print_else_stmt level stmt start_label end_label =  match stmt with 
                | ElseSingle(if_stmt, stmts, _) -> (*DONE*)
                    begin
                        print_if_stmt_with_else 1 if_stmt;
                        let curr_stop_label= !labelcountfalse in 
                        let currlabelstr = "stop"^(string_of_int curr_stop_label) in
                        labelcountertrue();
                        labelcounterfalse();
                        start_scope();
                        print_stmt_list 1 stmts start_label end_label; 
                        end_scope();
                        println_string_with_tab 1 (currlabelstr^":");
                    end
                | ElseIFMultiple(if_stmt, else_stmt, _) -> (*DONE*)
                    begin
                        print_if_stmt_with_else 1 if_stmt;
                        let curr_stop_label= !labelcountfalse in 
                        labelcountertrue();
                        labelcounterfalse();
                        print_else_stmt 1 else_stmt start_label end_label;
                        println_string_with_tab 1 ("stop"^(string_of_int curr_stop_label)^":");
                    end
                | ElseIFSingle(if_stmt1, if_stmt2, _) -> (*DONE*)

                    begin
                        print_if_stmt_with_else 1 if_stmt1 start_label end_label;
                        let curr_stop_label= !labelcountfalse in 
                        labelcountertrue();
                        labelcounterfalse();
                        
                        print_if_stmt_with_else 1 if_stmt2 start_label end_label;
                        let curr_stop_label2= !labelcountfalse in 
                        labelcountertrue();
                        labelcounterfalse();
                        

                        println_string_with_tab 1 ("stop"^(string_of_int curr_stop_label)^":");
                        println_string_with_tab 1 ("stop"^(string_of_int curr_stop_label2)^":");

                    end
            in
            let print_conditional_stmt level cond start_label end_label = match cond with (*needs testing*)
                | IfStmt(if_stmt, _) -> 
                    begin
                        print_if_stmt 1 if_stmt start_label end_label;
                        end_scope();
                    end
                | ElseStmt(else_stmt, _) ->
                    begin
                        print_else_stmt level else_stmt start_label end_label;
                        end_scope();
                    end
            in
            print_conditional_stmt level conditional startlabel endlabel
        | Simple(simple, _) -> 
            begin
                print_simple_stmt simple;
            end
        | Print(exprs, _) -> 
            let print_jasmin_exp exp = 
                println_one_tab "getstatic java/lang/System/out Ljava/io/PrintStream;";
                match (print_expr exp) with 
                    | SymInt -> println_one_tab "invokevirtual java/io/PrintStream/print(I)V";
                    | SymFloat64 -> println_one_tab "invokevirtual java/io/PrintStream/print(F)V";
                    | SymRune -> println_one_tab "invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V";
                    | SymString -> println_one_tab "invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V";
                    | SymBool -> println_one_tab "invokevirtual java/io/PrintStream/print(Z)V";
                    | NotDefined -> ()
            in
            List.iter print_jasmin_exp exprs;    
        | Println(exprs, _) -> 
            let println_jasmin_exp exp = 
                println_one_tab "getstatic java/lang/System/out Ljava/io/PrintStream;";
                match (print_expr exp) with 
                    | SymInt -> println_one_tab "invokevirtual java/io/PrintStream/println(I)V";
                    | SymFloat64 -> println_one_tab "invokevirtual java/io/PrintStream/println(F)V";
                    | SymRune -> println_one_tab "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V";
                    | SymString -> println_one_tab "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V";
                    | SymBool -> println_one_tab "invokevirtual java/io/PrintStream/println(Z)V";
                    | NotDefined -> ()
            in
            List.iter println_jasmin_exp exprs;  
        | For(for_stmt, _) ->
            let print_for_cond cond = match cond with 
                | ConditionExpression(expr, _) -> print_expr expr;()
                | Empty -> ()
            in
            let print_for_stmt level stmt = match stmt with 
                | Forstmt(stmts, _) ->
                    begin
                        let currlabelend = !labelcountfalse in
                        let currlabelstart = !labelcounttrue in
                        let currlabelendstr = "stop"^(string_of_int currlabelend) in
                        let currlabelstartstr = "start"^(string_of_int currlabelstart) in
                        labelcountertrue(); 
                        labelcounterfalse(); 
                        (*infinite loop*)
                        start_scope();
                        (*generate label*)
                        println_string ("start"^(string_of_int currlabelstart)^":");
                        print_stmt_list (level+1) stmts currlabelstartstr currlabelendstr;
                        (*print goto label *)
                    let gotocmd = "goto "^currlabelstartstr in
                        println_one_tab gotocmd;
                        println_string (currlabelendstr^":");
                        end_scope();
                    end

                | ForCondition(condition, stmts, _) -> 
                    begin
                        let currlabelend = !labelcountfalse in
                        let currlabelstart = !labelcounttrue in
                        let currlabelendstr = "stop"^(string_of_int currlabelend) in
                        let currlabelstartstr = "start"^(string_of_int currlabelstart) in
                        labelcountertrue(); 
                        labelcounterfalse(); 
                        println_string ("start"^(string_of_int currlabelstart)^":");
                        start_scope();
                        (*evaluate condition *)
                        print_for_cond condition;
                        (*check condition *)
                        println_string_with_tab 1 ("ifne "^currlabelendstr) ;
                        print_stmt_list (level+1) stmts currlabelstartstr currlabelendstr;
                    let gotocmd = "goto "^currlabelstartstr in
                        println_one_tab gotocmd;
                        println_string (currlabelendstr^":");
                        end_scope();
                    end
                | ForClause (ForClauseCond(simple1, condition, simple2, linenum), stmts, _) ->
                    begin
                        (*eval simple 1*)
                        print_simple_stmt simple1;
                        (*check condition*)
                        let currlabelend = !labelcountfalse in
                        let currlabelstart = !labelcounttrue in
                        let currlabelendstr = "stop"^(string_of_int currlabelend) in
                        let currlabelstartstr = "start"^(string_of_int currlabelstart) in
                        labelcountertrue(); 
                        labelcounterfalse(); 
                        println_string ("start"^(string_of_int currlabelstart)^":");
                        start_scope();
                        (*evaluate condition *)
                        print_for_cond condition;
                        (*check condition *)
                        println_string_with_tab 1 ("ifne "^currlabelendstr) ;
                        print_simple_stmt simple2;
                        print_stmt_list (level+1) stmts currlabelstartstr currlabelendstr;
                    let gotocmd = "goto "^currlabelstartstr in
                        println_one_tab gotocmd;
                        println_string (currlabelendstr^":");
                        end_scope();
                    end
            in
            print_for_stmt level for_stmt
        | Switch(switch_clause, switch_expr, switch_case_stmts, _) -> 
            let print_switch_clause clause = match clause with
                | SwitchClause(simple_stmt, _) -> 
                    begin
                        print_simple_stmt simple_stmt;
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
            let print_switch_case_clause level start_label end_label clause = match clause with 
                | SwitchCaseClause(exprs, stmts, _) -> 
                    (match exprs with
                        | [] -> 
                            begin
                                print_stmt_list (level+1) stmts start_label end_label;
                            end
                        | head::tail ->
                            begin
                                let currlabelend = !labelcountfalse in
                                let currlabelstart = !labelcounttrue in
                                let currlabelendstr = "stopcase"^(string_of_int currlabelend) in
                                let currlabelstartstr = "startcase"^(string_of_int currlabelstart) in

                                (*duplicate exp and check *)
                                print_expr_list_switch exprs currlabelstartstr;
                                println_string ("goto "^currlabelendstr);
                                println_string (currlabelstartstr^":");
                                print_stmt_list (level+1) stmts start_label end_label; 
                                println_string (currlabelendstr^":");
                            end
                    )
                | Empty -> ()   
            in
            let print_switch_case_stmt level stmts start_label end_label= match stmts with
                | SwitchCasestmt([], _) -> ()
                | SwitchCasestmt(switch_case_clauses, _) -> List.iter (print_switch_case_clause level start_label end_label) switch_case_clauses
            in       
            begin
                start_scope();
                (*do simple stmt*)
                print_switch_clause switch_clause;
                (*put expr on stack*)
                print_switch_expr switch_expr;
                
                (*make labels*)
                let currlabelend = !labelcountfalse in
                let currlabelstart = !labelcounttrue in
                let currlabelendstr = "stop"^(string_of_int currlabelend) in
                let currlabelstartstr = "start"^(string_of_int currlabelstart) in
                labelcountertrue(); 
                labelcounterfalse(); 
                
                print_switch_case_stmt (level+1) switch_case_stmts startlabel currlabelendstr;
                print_tab 1;
                println_string "pop";
                end_scope();
            end
        | _ -> ()
    and print_stmt_list level stmt_list startlabel endlabel= match stmt_list with
        | [] -> ()
        | head::[] -> print_stmt level head startlabel endlabel
        | head::tail ->
            begin
                print_stmt level head startlabel endlabel;
                print_stmt_list level tail startlabel endlabel;
            end
    and print_method_decl func_name signature stmt_list = match signature with
        | FuncSig(FuncParams(func_params, _), return_type, _) ->
            begin
                println_string (Printf.sprintf ".method public static %s(%s)%s" func_name "" (string_method_return_type return_type)); println_one_tab ".limit stack 99"; println_one_tab  ".limit locals 99"; print_stmt_list 1 stmt_list; println_string ".end method\n";
            end
    and print_decl level decl = match decl with
        | TypeDcl([], _) -> ()
        | TypeDcl(decl_list, _) -> List.iter print_type_decl decl_list
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
                    print_stmt_list 1 stmt_list "" "";
                    println_string "";
                    println_one_tab "return";
                    println_string ".end method";
                end
            | _ ->
                begin
                    init_func func_name signature;
                    print_method_decl func_name signature stmt_list;
                end
        | _ -> ()
    and print_decl_list level decl_list = 
        List.iter (print_decl level) decl_list
    in
    begin
        jasmin_main_class := filename;
        jasmin_file_dir := filedir;
        print_class_header filename;
        print_init_header filename;
        print_decl_list 0 decl_list;
        close_out output_file
    end
