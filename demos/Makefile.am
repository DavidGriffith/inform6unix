# Makefile for Inform demos.

INFFILES = alice.inf balances.inf museum.inf ruins.inf ruinsplus.inf	\
toyshop.inf

ZFILES = alice.z5 balances.z5 museum.z5 ruins.z5 ruinsplus.z5 toyshop.z5

EXTRA_DIST = $(INFFILES)

ETAGS_ARGS = $(ETAGS_INFORM) $(INFFILES)

TAGS_DEPENDENCIES = $(INFFILES)

INFORM = inform -E1 -Ux

SUFFIXES = .inf .z5

.inf.z5:; $(INFORM) $<

zfiles: $(ZFILES)

CLEANFILES = $(ZFILES)

@make_include@
