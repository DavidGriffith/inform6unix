# Automake template for Inform demos.

include $(top_srcdir)/config/commondefs

INFFILES = advent.inf adventureland.inf balances.inf museum.inf ruins.inf \
ruinsplus.inf toyshop.inf

ZFILES = advent.z5 adventureland.z5 balances.z5 museum.z5 ruins.z5	\
ruinsplus.z5 toyshop.z5

zcode_DATA = $(ZFILES)

EXTRA_DIST = $(INFFILES)

ETAGS_ARGS = $(ETAGS_INFORM) $(INFFILES)

TAGS_DEPENDENCIES = $(INFFILES)

INFORM = $(top_builddir)/src/inform

INCPATH = $(top_srcdir)/lib,$(top_builddir)/lib
MODPATH = $(top_builddir)/lib

INFFLAGS = -i -E1 -x +include_path=$(INCPATH) +module_path=$(MODPATH)

SUFFIXES = .inf .z5

.inf.z5:; $(INFORM) $(INFFLAGS) $<

all: demos

demos: $(ZFILES)

$(ZFILES): $(INFORM)

CLEANFILES = $(ZFILES)
