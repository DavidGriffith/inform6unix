## Master automake template for Inform.

AUTOMAKE_OPTIONS = foreign check-news dist-bzip2

SUBDIRS = src lib include info html demos

EXTRA_DIST = AUTHORS VERSION

EXTRA_DIRS = config docs contrib tutor

dist-hook:
	cd $(srcdir)/tutor; $(MAKE) clean
	@ for dir in $(EXTRA_DIRS); do					\
	   echo Adding $$dir directory to distribution;			\
	   cp -rfp $(srcdir)/$$dir $(distdir);				\
	   rm -rf $(distdir)/$$dir/CVS;					\
	   rm -rf $(distdir)/$$dir/.cvsignore;				\
	done

@make_include@
