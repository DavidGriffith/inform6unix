## Automake template for Inform libraries.

pkgdata_DATA = $(MODULES) $(INCLUDES)

MODULES = parserm.m5 verblibm.m5

INCLUDES = English.h grammar.h linklpa.h linklv.h parser.h parserm.h	\
verblib.h verblibm.h

EXTRA_DIST = $(INCLUDES)

ETAGS_ARGS = $(ETAGS_INFORM) $(INCLUDES)

TAGS_DEPENDENCIES = $(INCLUDES)

SUFFIXES = .h .m5

INFORM = $(top_builddir)/src/inform

INFFLAGS = +include_path=$(srcdir)/ +module_path=$(srcdir)/

.h.m5:;	$(INFORM) $(INFFLAGS) -M $<

EXTRA_NAMES = Grammar.h Parser.h Verblib.h VerbLib.h

all-local:
	@ for file in $(EXTRA_NAMES); do				\
		realfile=`echo $$file | tr '[A-Z]' '[a-z]'`;		\
		rm -f $$file;						\
		$(LN_S) $$realfile $$file;				\
	done

install-data-local:
	@ for file in $(EXTRA_NAMES); do				\
		realfile=`echo $$file | tr '[A-Z]' '[a-z]'`;		\
		echo Linking $$file to $$realfile;			\
		cd $(pkgdatadir);					\
		rm -f $$file;						\
		$(LN_S) $$realfile $$file;				\
	done

CLEANFILES = $(MODULES) $(EXTRA_NAMES)

@make_include@
