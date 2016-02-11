############
OCAMLBUILD=/usr/bin/env ocamlbuild -use-menhir -menhir 'menhir --explain'
############
all: mini
mini: mini.ml lexer.mll lextTest.mly error.ml
	$(OCAMLBUILD) mini.native
	
############
clean:
	rm -r _build
	rm 	  mini.native