# Makefile for tutorial examples.  Assumes Inform has been installed.

ZFILES = alice.z5 aloneice.z5 house01.z5 house02.z5 house03.z5 house04.z5 \
house05.z5 house06.z5 house07.z5

INFFLAGS = -Ux

.SUFFIXES: .inf .z5

.inf.z5:; inform $(INFFLAGS) $<

all: $(ZFILES)

clean:; rm -f $(ZFILES)
