## Master automake template for Inform.

AUTOMAKE_OPTIONS = foreign

SUBDIRS = src lib include info html demos

EXTRA_DIST = AUTHORS VERSION

EXTRA_DIRS = config contrib doc tutor

dist-hook:
	cd $(srcdir)/tutor; $(MAKE) clean
	@ for dir in $(EXTRA_DIRS); do					\
		echo Adding $$dir directory to distribution;		\
		cp -rp $(srcdir)/$$dir $(distdir);			\
	done

@make_include@
