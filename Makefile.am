## Master automake template for Inform.

include $(top_srcdir)/config/Makefile.inc

AUTOMAKE_OPTIONS = check-news

SUBDIRS = src lib include contrib manual demos tutor

EXTRA_DIST = ARTISTIC AUTHORS VERSION autogen.sh

EXTRA_DIRS = config docs contrib

uninstall-local:
	@ echo " removing $(DESTDIR)$(moduledir)"
	@ rmdir --ignore-fail-on-non-empty $(DESTDIR)$(moduledir)
	@ echo " removing $(DESTDIR)$(includedir)"
	@ rmdir --ignore-fail-on-non-empty $(DESTDIR)$(includedir)
	@ echo " removing $(installdir)"
	@ rmdir --ignore-fail-on-non-empty $(installdir)
	@ echo " removing $(pkgdatadir)"
	@ rmdir --ignore-fail-on-non-empty $(pkgdatadir)

dist-hook:
	@ for dir in $(EXTRA_DIRS); do					\
	   echo adding $$dir directory to distribution;			\
	   cp -rfp $(srcdir)/$$dir $(distdir);				\
	done
