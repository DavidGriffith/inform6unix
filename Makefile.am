## Master automake template for Inform.

AUTOMAKE_OPTIONS = check-news

SUBDIRS = src lib include manual demos

EXTRA_DIST = AUTHORS VERSION

EXTRA_DIRS = config docs contrib tutor

dist-hook:
	cd $(srcdir)/tutor; $(MAKE) clean
	@ for dir in $(EXTRA_DIRS); do					\
	   echo Adding $$dir directory to distribution;			\
	   cp -rfp $(srcdir)/$$dir $(distdir);				\
	done

@make_include@
