## Master automake template for Inform.

AUTOMAKE_OPTIONS = foreign

SUBDIRS = src lib doc demos

EXTRA_DIRS = contrib config

dist-hook:
	@ for dir in $(EXTRA_DIRS); do \
		echo Adding $$dir to distribution; \
		cp -rp $(srcdir)/$$dir $(distdir); \
	done
