## Automake template for Inform libraries.

pkgdata_DATA = $(MODULES) $(INCLUDES)

MODULES = parserm.m5 verblibm.m5

INCLUDES = English.h grammar.h linklpa.h linklv.h parser.h parserm.h	\
verblib.h verblibm.h

EXTRA_DIST = $(INCLUDES)

TYPES = \(Class\|Object\)

ETAGS_ARGS = -l none -r '/$(TYPES)\([ \t]+->\)*[ \t]+\([^ \t]+\)/\3/' \
-r '/\[[ \t]+\([^ \t;]+\)/\1/' $(INCLUDES)

SUFFIXES = .h .m5

INFORM = $(top_builddir)/src/inform

INFFLAGS = +include_path=$(srcdir)/ +module_path=$(srcdir)/

.h.m5:;	$(INFORM) $(INFFLAGS) -Mx $<

CLEANFILES = $(MODULES)

@make_include@
