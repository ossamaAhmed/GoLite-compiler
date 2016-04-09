# assumes sablecc script is on your PATH

# to compile the code
joosc: clean
	$(PEEPDIR)/joosc -O *.java

java: clean
	javac *.java

check:	
	./check.py

clean:	
	rm -rf *.class *.j
run:
	java Main < in1