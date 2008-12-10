# Automake template for Inform demos.

include $(top_srcdir)/config/Makefile.inc

zcodedir = $(datadir)/zcode
zcode_DATA = $(ZFILES)

INFFILES = advent.inf adventureland.inf balances.inf museum.inf ruins1.inf \
ruins2.inf ruins3.inf toyshop.inf

ZFILES = advent.z5 adventureland.z5 balances.z5 museum.z5 ruins1.z5	\
ruins2.z5 ruins3.z5 toyshop.z5

EXTRA_DIST = $(INFFILES)

ETAGS_ARGS = $(ETAGS_INFORM) $(INFFILES)

TAGS_DEPENDENCIES = $(INFFILES)

INFORM = $(top_builddir)/src/inform

INCPATH = $(top_srcdir)/lib,$(top_builddir)/lib
MODPATH = $(top_srcdir)/lib,$(top_builddir)/lib

INFFLAGS = -ix -~D -E1 +include_path=$(INCPATH) +module_path=$(MODPATH)

SUFFIXES = .inf .z5

.inf.z5:; $(INFORM) $(INFFLAGS) $<

all: demos

demos: $(ZFILES)

$(ZFILES): $(INFORM)

CLEANFILES = $(ZFILES)
