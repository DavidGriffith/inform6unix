## Automake template for standard include files.

INCLUDES = adhints.h altmenu.h center.h clothing.h compass.h dirs.h	    \
domenu.h doors.h footnote.h hints.h info.h istring.h longint.h manual.h	    \
menus.h money.h moveclass.h movie.h newmenu.h newmenus.h outofrch.h	    \
physics.h pluralob.h printtime.h showobj.h smartcantgo.h timepiece.h	    \
timesys.h timewait.h utility.h waittime.h whatis.h whowhat.h yesno.h znsi.h

DOCS = adhints.txt

pkgdata_DATA = $(INCLUDES)

EXTRA_DIST = $(INCLUDES) $(DOCS)

if CYGWIN
#	No symlinks required under Cygwin.
else
EXTRA_NAMES = AdHints.h NewMenu.h

install-data-local:
	@ for file in $(EXTRA_NAMES); do				\
		realfile=`echo $$file | tr '[A-Z]' '[a-z]'`;		\
		echo Linking $$file to $$realfile;			\
		cd $(pkgdatadir);					\
		rm -f $$file;						\
		$(LN_S) $$realfile $$file;				\
	done

uninstall-local:
	@ for file in $(EXTRA_NAMES); do				\
		echo Unlinking $$file;					\
		rm -f $(pkgdatadir)/$$file;				\
	done
endif

@make_include@
