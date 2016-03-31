############
OCAMLBUILD=/usr/bin/env ocamlbuild -tag debug -use-menhir -menhir 'menhir --explain'
############
all: golite
golite: goLite.ml lexer.mll parser.mly error.ml
	$(OCAMLBUILD) goLite.native
clean:
	(rm -r _build) || (rm goLite.native) || (cd ../ && find . -type f -name '*.pretty.go' -exec rm {} +) || (cd ../ && find . -type f -name '*.symboltable' -exec rm {} +) || (cd ../ && find . -type f -name '*.pptype' -exec rm {} +) || (cd ../ && find . -type f -name '*.symtab' -exec rm {} +)
