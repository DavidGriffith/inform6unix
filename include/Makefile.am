## Automake template for standard include files.

INCLUDES = adhints.h altmenu.h center.h clothing.h compass.h dirs.h	    \
domenu.h doors.h footnote.h hints.h info.h istring.h longint.h manual.h	    \
menus.h money.h moveclass.h movie.h newmenu.h newmenus.h outofrch.h	    \
physics.h pluralob.h printtime.h showobj.h smartcantgo.h timepiece.h	    \
timesys.h timewait.h utility.h waittime.h whatis.h whowhat.h yesno.h znsi.h

EXTRA_NAMES = AdHints.h NewMenu.h

DOCS = adhints.txt

include_HEADERS = $(INCLUDES)

EXTRA_DIST = $(DOCS)

if CYGWIN
install-data-local: add-localdir
uninstall-local: remove-localdir
else
install-data-local: add-localdir add-names
uninstall-local: remove-localdir remove-names
endif

add-localdir:
	$(top_srcdir)/config/mkinstalldirs $(localincdir)

remove-localdir:
	rmdir $(localincdir)

add-names:
	@ for file in $(EXTRA_NAMES); do				\
		realfile=`echo $$file | tr '[A-Z]' '[a-z]'`;		\
		echo Linking $$file to $$realfile;			\
		cd $(includedir);					\
		rm -f $$file;						\
		$(LN_S) $$realfile $$file;				\
	done

remove-names:
	@ for file in $(EXTRA_NAMES); do				\
		echo Unlinking $$file;					\
		rm -f $(includedir)/$$file;				\
	done

@make_include@
