## Automake template for Inform libraries.

pkgdata_DATA = $(MODULES) $(INCLUDES)

MODULES = parserm.m5 verblibm.m5

INCLUDES = English.h Grammar.h linklpa.h linklv.h Parser.h parserm.h	\
VerbLib.h verblibm.h infix.h

EXTRA_DIST = $(INCLUDES)

ETAGS_ARGS = $(ETAGS_INFORM) $(INCLUDES)

TAGS_DEPENDENCIES = $(INCLUDES)

SUFFIXES = .h .m5

INFORM = $(top_builddir)/src/inform

INFFLAGS = +include_path=$(srcdir)/ +module_path=$(srcdir)/

.h.m5:;	$(INFORM) $(INFFLAGS) -M $<

CLEANFILES = $(MODULES)

$(MODULES): $(INFORM)

@make_include@
