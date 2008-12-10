# Automake template for Inform tutorial examples.

include $(top_srcdir)/config/Makefile.inc

INFFILES = alice.inf aloneice.inf house01.inf house02.inf house03.inf	\
house04.inf house05.inf house06.inf house07.inf

ZFILES = alice.z5 aloneice.z5 house01.z5 house02.z5 house03.z5 house04.z5 \
house05.z5 house06.z5 house07.z5

INCPATH = $(top_srcdir)/lib,$(top_builddir)/lib
MODPATH = $(top_srcdir)/lib,$(top_builddir)/lib

INFORM = $(top_builddir)/src/inform

INFFLAGS = -ix -~D -E1 +include_path=$(INCPATH) +module_path=$(MODPATH)

EXTRA_DIST = $(INFFILES)

SUFFIXES = .inf .z5

.inf.z5:; $(INFORM) $(INFFLAGS) $<

all: $(ZFILES)

CLEANFILES = $(ZFILES)
