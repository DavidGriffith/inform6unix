## Master automake template for Inform.

include $(top_srcdir)/config/Makefile.inc

AUTOMAKE_OPTIONS = check-news

SUBDIRS = src lib include manual demos tutor

EXTRA_DIST = AUTHORS VERSION

EXTRA_DIRS = config docs contrib

dist-hook:
	@ for dir in $(EXTRA_DIRS); do					\
	   echo Adding $$dir directory to distribution;			\
	   cp -rfp $(srcdir)/$$dir $(distdir);				\
	done
