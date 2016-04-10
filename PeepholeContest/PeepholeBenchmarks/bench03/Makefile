all:
	$(PEEPDIR)/joosc -O *.java *.joos

clean:
	rm -f *.j *.class
run:
	(cd lib; javac JoosBitwise.java) && (java Main < in1)
