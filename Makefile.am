## Master automake template for Inform.

AUTOMAKE_OPTIONS = foreign check-news

SUBDIRS = src lib include info html demos

EXTRA_DIST = AUTHORS VERSION README.bugs README.glulx README.paths	\
README.source

EXTRA_DIRS = config contrib tutor

dist-hook:
	cd $(srcdir)/tutor; $(MAKE) clean
	@ for dir in $(EXTRA_DIRS); do					\
	   echo Adding $$dir directory to distribution;			\
	   cp -rp $(srcdir)/$$dir $(distdir);				\
	   rm -rf $(distdir)/$$dir/CVS;					\
	done

@make_include@
