## Automake template for standard include files.

INCLUDES = adhints.h altmenu.h calyx_adjectives.h center.h clothing.h	    \
compass.h dirs.h domenu.h doors.h footnote.h hints.h info.h istring.h	    \
longint.h manual.h menus.h money.h moveclass.h movie.h newmenu.h newmenus.h \
outofrch.h physics.h pluralob.h printtime.h showobj.h smartcantgo.h	    \
timepiece.h timesys.h timewait.h utility.h waittime.h whatis.h whowhat.h    \
yesno.h znsi.h

EXTRA_NAMES = AdHints.h Menus.h NewMenu.h

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
	$(mkinstalldirs) $(DESTDIR)$(localincdir)

remove-localdir:
	rmdir $(DESTDIR)$(localincdir)

add-names:
	@ cd $(DESTDIR)$(includedir);					\
	for file in $(EXTRA_NAMES); do					\
	   realfile=`echo $$file | tr '[A-Z]' '[a-z]'`;			\
	   echo Linking $$file to $$realfile;				\
	   rm -f $$file;						\
	   $(LN_S) $$realfile $$file;					\
	done

remove-names:
	@ for file in $(EXTRA_NAMES); do				\
	   echo Unlinking $$file;					\
	   rm -f $(DESTDIR)$(includedir)/$$file;			\
	done

@make_include@
