#Milestone 2 writeup
The milestone 2 writeup can be found in /doc/milestone2.pdf

# comp520-2016-02
Many code examples taken from:
* https://gobyexample.com
* http://caml.inria.fr/pub/docs/manual-ocaml-4.00/manual026.html
* https://realworldocaml.org/v1/en/html/parsing-with-ocamllex-and-menhir.html

##Valid Programs found in: 
* TEST\_PROGRAMS/VALID/conditionals.go
* TEST\_PROGRAMS/VALID/variables.go
* TEST\_PROGRAMS/VALID/hellowolrd.go

#To Compile:
* cd src
* make golite

#To run:
* ./run [filename]

#To test
* ./test
* cat test\_results.txt

#Milestone 1 report:

##Features implemented
* Lexer
* Parser
* Abstract syntax tree
* Pretty Printer

## Design Choices For Milestone 1
### Team
We found dividing the labor fairly a challenge. This is because a compiler is a sequential program and all parts are interdependant. For the lexer we were able to divide the distinct tokens among three partners. The parser was much more challenging because the grammer rules all depend on each other. We divided the grammar such that all three partners implement leaf nodes of the grammer when considering the grammer as a CST. For the AST, we each implemented the parts of the tree that corresponded to the grammar that we wrote

## Block quotes
We found it too difficult to properly lex through block quotes and dissallow nested block quotes. Therefore, we decided to catch nested block quotes in the weeder phase


### OpEquals
We decided to catch op-equals in our Lexer rather than our parser. An op-equals refers to (+= -= /= etc...). We did this in order to avoid white space error such as (+ =). Such an error would require us to keep track of whitespaces.

### Generate Statements
We decided to make our type constructors more modular. For all type constructors we've created a generateAST file which calls the constructors and the parser calls the generate statements. This way changing our AST would not affect our parser

### Programming language
We decided to program our compiler in Ocaml after trying two alternatives. We chose not to use Flex-bison because of the lack of flexibility of the c programming langugage for creating types. We would have to manually write a lot of boiler plate code. We chose not to use SableCC because it was very verbose and the lack of freedom to change the AST. SableCC is also lacking online code examples and documentation. We find it easier to generate ASTs due to the recursive nature of OCaml's type declarations. 
