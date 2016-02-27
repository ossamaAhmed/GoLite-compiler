# comp520-2016-02
Many code examples taken from:
* https://gobyexample.com
* http://caml.inria.fr/pub/docs/manual-ocaml-4.00/manual026.html
* https://realworldocaml.org/v1/en/html/parsing-with-ocamllex-and-menhir.html

##Valid Programs found in: 
* TEST\_PROGRAMS/VALID/for.go
* TEST\_PROGRAMS/VALID/arrays.go
* TEST\_PROGRAMS/VALID/hellowold.go

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

##Design Choices
###OpEquals
We decided to catch op-equals in our Lexer rather than our parser. An op-equals refers to (+= -= /= etc...). We did this in order to avoid white space error such as (+ =). Such an error would require us to keep track of whitespaces.

###Generate Statements
We decided to make our type constructors more modular. For all type constructors we've created a generateAST file which calls the constructors and the parser calls the generate statements. This way changing our AST would not affect our parser

###Programming language
We decided to program our compiler in Ocaml after trying two alternatives. We chose not to use Flex-bison because of the lack of flexibility of the c programming langugage for creating types. We would have to manually write a lot of boiler plate code. We chose not to use SableCC because it was very verbose and the lack of freedom to change the AST. SableCC is also lacking online code examples and documentation.
