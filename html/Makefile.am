## Automake template for Inform documentation.

htmldir = $(pkgdatadir)/manual

html_DATA = chapter1.html chapter2.html chapter3.html chapter4.html	   \
chapter5.html chapter6.html chapterA.html contents.html index.html	   \
intro.html section1.html section10.html section11.html section12.html	   \
section13.html section14.html section15.html section16.html section17.html \
section18.html section19.html section2.html section20.html section21.html  \
section22.html section23.html section24.html section25.html section26.html \
section27.html section28.html section29.html section3.html section30.html  \
section31.html section32.html section33.html section4.html section5.html   \
section6.html section7.html section8.html section9.html sectionA1.html	   \
sectionA10.html sectionA11.html sectionA12.html sectionA2.html		   \
sectionA3.html sectionA4.html sectionA5.html sectionA6.html sectionA7.html \
sectionA8.html sectionA9.html

html_DIRS = answers1 answers2 icons

EXTRA_DIST = $(html_DATA)

EXTRA_DIRS = $(html_DIRS)

NORMAL_UNINSTALL = chmod -R u+w $(DESTDIR)$(pkgdatadir)

install-data-hook:
	for dir in $(EXTRA_DIRS); do					\
	    cp -rp $(srcdir)/$$dir $(DESTDIR)$(htmldir);		\
	    rm -rf $(DESTDIR)$(htmldir)/$$dir/CVS;			\
	done

uninstall-hook:
	rm -rf $(DESTDIR)$(htmldir)

dist-hook:
	for dir in $(EXTRA_DIRS); do					\
	    cp -rp $(srcdir)/$$dir $(distdir);				\
	    rm -rf $(distdir)/$$dir/CVS;				\
	done

@make_include@
