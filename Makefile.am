## Master automake template for Inform.

AUTOMAKE_OPTIONS = foreign

SUBDIRS = src lib include doc demos

EXTRA_DIST = AUTHORS VERSION BUGS

EXTRA_DIRS = config tutor

dist-hook:
	cd tutor; $(MAKE) clean
	@ for dir in $(EXTRA_DIRS); do \
		echo Adding $$dir to distribution; \
		cp -rp $(srcdir)/$$dir $(distdir); \
	done
