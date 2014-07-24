## Automake template for standard include files.

include $(top_srcdir)/config/Makefile.inc

INCLUDES = dmenus.h doors.h doors2.h howtoplay.h footnote.h mistype.h \
moveclass.h newbiegrammar.h seeno.h shuffle.h sound.h tmenus.h torch.h \
trinitystat.h

EXTRA_NAMES = DMenus.h SmartCantGo.h TMenus.h

DOCS =

include_HEADERS = $(INCLUDES) $(DOCS)

EXTRA_DIST = $(DOCS)

if CYGWIN
install-data-hook: add-localdir
uninstall-local: remove-localdir
else
install-data-hook: add-localdir add-names
uninstall-local: remove-localdir remove-names
endif

add-localdir:
	$(mkinstalldirs) $(DESTDIR)$(localincdir)

remove-localdir:
	rmdir $(DESTDIR)$(localincdir)

add-names:
	@ cd $(DESTDIR)$(includedir);					\
	for file in $(EXTRA_NAMES); do					\
	    if test ! -e $$file -o -L $$file; then			\
	        realfile=`echo $$file | tr '[A-Z]' '[a-z]'`;		\
	        echo " linking $$file to $$realfile";			\
	        rm -f $$file;						\
	        $(LN_S) $$realfile $$file;				\
	    fi								\
	done

remove-names:
	@ cd $(DESTDIR)$(includedir);					\
	for file in $(EXTRA_NAMES); do					\
	    if test -L $$file; then					\
	        echo " unlinking $$file";				\
	        rm -f $(DESTDIR)$(includedir)/$$file;			\
	    fi								\
	done
