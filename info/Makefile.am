## Automake template for Inform documentation.

docdir = $(prefix)/info
doc_DATA = $(INFORM)

EXTRA_DIST = $(doc_DATA)

INFORM = inform inform-1 inform-2 inform-3 inform-4 inform-5 inform-6	\
inform-7 inform-8 inform-9 inform-10 inform-11 inform-12 inform-13	\
inform-14

INFO_FILES = inform.info

split:;	@ for file in $(INFO_FILES); do					\
		echo Splitting $$file;					\
		base=`basename $$file .info`;				\
		cp Info/$$file $$base;					\
		infosplit -v $$base;					\
	done

@make_include@
