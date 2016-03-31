############
OCAMLBUILD=/usr/bin/env ocamlbuild -tag debug -use-menhir -menhir 'menhir --explain'
############
all: golite
golite: goLite.ml lexer.mll parser.mly error.ml
	$(OCAMLBUILD) goLite.native
clean: clean_pretty clean_symtab clean_pptype clean_j
	(rm -r _build) || (rm goLite.native)
clean_pretty:
	(cd ../ && find . -type f -name '*.pretty.go' -exec rm {} +) || (find . -type f -name '*.pretty.go' -exec rm {} +)
clean_symtab:
	(cd ../ && find . -type f -name '*.symtab' -exec rm {} +) || (find . -type f -name '*.symtab' -exec rm {} +)
clean_pptype:
	(cd ../ && find . -type f -name '*.pptype.go' -exec rm {} +) || (find . -type f -name '*.pptype.go' -exec rm {} +)
clean_j:
	(cd ../ && find . -type f -name '*.j' -exec rm {} +) || (find . -type f -name '*.j' -exec rm {} +)


