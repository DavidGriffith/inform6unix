## Automake template for Inform libraries.

include $(top_srcdir)/config/commondefs

module_DATA = $(MODULES) $(INCLUDES)

MODULES = parserm.m5 verblibm.m5

INCLUDES = english.h grammar.h linklpa.h linklv.h parser.h parserm.h	\
verblib.h verblibm.h infix.h

EXTRA_DIST = $(INCLUDES)

ETAGS_ARGS = $(ETAGS_INFORM) $(INCLUDES)

TAGS_DEPENDENCIES = $(INCLUDES)

SUFFIXES = .h .m5

INFORM = $(top_builddir)/src/inform

INFFLAGS = -x +module_path=$(srcdir) +language_name=english

.h.m5:;	$(INFORM) $(INFFLAGS) -M $<

if CYGWIN
#	No symlinks required under Cygwin.
else
EXTRA_NAMES = English.h Grammar.h Parser.h Verblib.h VerbLib.h

all-local:
	@ for file in $(EXTRA_NAMES); do				\
		realfile=`echo $$file | tr '[A-Z]' '[a-z]'`;		\
		test -r $$file || $(LN_S) $$realfile $$file;		\
	done

install-data-local:
	@ for file in $(EXTRA_NAMES); do				\
		realfile=`echo $$file | tr '[A-Z]' '[a-z]'`;		\
		echo Linking $$file to $$realfile;			\
		cd $(moduledir);					\
		rm -f $$file;						\
		$(LN_S) $$realfile $$file;				\
	done

uninstall-local:
	@ for file in $(EXTRA_NAMES); do				\
		echo Unlinking $$file;					\
		rm -f $(moduledir)/$$file;				\
	done
endif

CLEANFILES = $(MODULES) $(EXTRA_NAMES)

$(MODULES): $(INFORM)
