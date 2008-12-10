# Automake template for Inform demos.

include $(top_srcdir)/config/Makefile.inc

zcode_DATA = $(ZFILES)

INFFILES = advent.inf adventureland.inf balances.inf museum.inf ruins1.inf \
ruins2.inf ruins3.inf toyshop.inf

ZFILES = advent.z5 adventureland.z5 balances.z5 museum.z5 ruins1.z5	\
ruins2.z5 ruins3.z5 toyshop.z5

EXTRA_DIST = $(INFFILES)

ETAGS_ARGS = $(ETAGS_INFORM) $(INFFILES)

TAGS_DEPENDENCIES = $(INFFILES)

all: demos

demos: $(ZFILES)

CLEANFILES = $(ZFILES)
