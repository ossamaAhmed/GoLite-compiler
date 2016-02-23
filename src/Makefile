############
OCAMLBUILD=/usr/bin/env ocamlbuild -tag debug -use-menhir -menhir 'menhir --explain'
############
all: mini
golite: goLite.ml lexer.mll parser.mly error.ml
	$(OCAMLBUILD) goLite.native
	
############
clean:
	rm -r _build
	rm 	  goLite.native
