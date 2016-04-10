
compiler:
	cd JOOSA-src && $(MAKE)
compiler_mac:
	cd JOOSA-src && $(MAKE) main_mac
bench01:
	cd PeepholeBenchmarks/bench01 && $(MAKE) >  code.size 
bench02:
	cd PeepholeBenchmarks/bench02 && $(MAKE) >  code.size 
bench03:
	cd PeepholeBenchmarks/bench03 && $(MAKE) >  code.size 
bench04:
	cd PeepholeBenchmarks/bench04 && $(MAKE) >  code.size 
bench05:
	cd PeepholeBenchmarks/bench05 && $(MAKE) >  code.size 
bench06:
	cd PeepholeBenchmarks/bench06 && $(MAKE) >  code.size 
bench07:
	cd PeepholeBenchmarks/bench07 && $(MAKE) >  code.size 
all: compiler bench01 bench02 bench03 bench04 bench05 bench06 bench07
	./codesize
mac: compiler_mac bench01 bench02 bench03 bench04 bench05 bench06 bench07
	./codesize
clean: clean_codesize clean_dump clean_optdump
	cd JOOSA-src && $(MAKE) clean
clean_codesize:
	(cd PeepholeBenchmarks && find . -type f -name 'code.size' -exec rm {} +)
clean_dump:
	(cd PeepholeBenchmarks && find . -type f -name '*.dump' -exec rm {} +)
clean_optdump:
	(cd PeepholeBenchmarks && find . -type f -name '*.optdump' -exec rm {} +)
runall:
	cd PeepholeBenchmarks/bench01 && $ make run
	cd PeepholeBenchmarks/bench02 && $ make run
	cd PeepholeBenchmarks/bench03 && $ make run
	cd PeepholeBenchmarks/bench04 && $ make run
	cd PeepholeBenchmarks/bench05 && $ make run
	cd PeepholeBenchmarks/bench06 && $ make run
	cd PeepholeBenchmarks/bench07 && $ make run
