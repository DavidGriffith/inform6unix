## Master automake template for Inform.

AUTOMAKE_OPTIONS = foreign

SUBDIRS = src lib doc

EXTRA_DIRS = contrib demos config

dist-hook:
	@ for dir in $(EXTRA_DIRS); do \
		echo Adding $$dir to distribution; \
		cp $(srcdir)/$$dir $(distdir); \
	done
