# Automake template for Inform demos.

INFFILES = advent.inf adventureland.inf balances.inf museum.inf ruins.inf \
ruinsplus.inf toyshop.inf

ZFILES = advent.z5 adventureland.z5 balances.z5 museum.z5 ruins.z5	\
ruinsplus.z5 toyshop.z5

zcodedir = $(datadir)/zcode

zcode_DATA = $(ZFILES)

EXTRA_DIST = $(INFFILES)

ETAGS_ARGS = $(ETAGS_INFORM) $(INFFILES)

TAGS_DEPENDENCIES = $(INFFILES)

INFORM = $(top_builddir)/src/inform

INCDIR = $(top_srcdir)/lib/
MODDIR = $(top_builddir)/lib/

INFFLAGS = -i -E1 -x +include_path=$(INCDIR) +module_path=$(MODDIR)

SUFFIXES = .inf .z5

.inf.z5:; $(INFORM) $(INFFLAGS) $<

all: demos

demos: $(ZFILES)

$(ZFILES): $(INFORM)

CLEANFILES = $(ZFILES)

@make_include@
