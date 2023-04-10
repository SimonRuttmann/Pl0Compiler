
program:  symtab.o debug.o assemblercodegenerator.o intermediatecode.o lex.yy.o y.tab.o pl-0.o
		g++ -o pl-0 symtab.o debug.o assemblercodegenerator.o intermediatecode.o lex.yy.o y.tab.o pl-0.o


symtab.o:			pl0-symtab.cpp pl0-symtab.hpp
		g++ -c pl0-symtab.cpp -o symtab.o

intermediatecode.o:			IntermediateCode.cpp
		g++ -c IntermediateCode.cpp -o intermediatecode.o

debug.o:			DebugConsole.cpp
		g++ -c DebugConsole.cpp -o debug.o

pl-0.o:			pl-0.cpp
		g++ -c pl-0.cpp -o pl-0.o

assemblercodegenerator.o: AssemblerCodegenerator.h
		g++ -c AssemblerCodegenerator.cpp -o assemblercodegenerator.o

lex.yy.o: lex.yy.c
	g++ -c lex.yy.c   

y.tab.o: y.tab.c
	g++ -c y.tab.c

y.tab.c: parser.y
	yacc -d parser.y 

lex.yy.c: scanner.l y.tab.c
	lex --header-file=lex.yy.h scanner.l 

clean: 
	rm -fr lex.yy.* *.o y.tab.* y.h pl-0