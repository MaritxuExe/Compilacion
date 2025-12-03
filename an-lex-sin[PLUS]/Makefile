CC = g++
SOURCES = main.cpp parser.cpp tokens.cpp Codigo.cpp 
TESTDIR = ./test

all: parser test

.PHONY: clean test

clean:
	rm -f parser.cpp parser.h parser tokens.cpp *.o *~

parser.cpp parser.h: parser.y
	bison -Wcounterexamples --defines=parser.h -o parser.cpp $^

tokens.cpp: tokens.l parser.h
	flex --yylineno -o $@ $<

%.o: %.cpp
	$(CC) $(CPPFLAGS) $(CFLAGS) -c -o $@ $<

parser: $(SOURCES:.cpp=.o)
	$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ $^ -ll

test: $(TESTDIR)/*.in
	@for f in $^ ; do \
		./parser < $${f} ; \
	done
