CC = gcc
GIT = git

#OPTS = -g -Wall -Wextra

PREFIX = /usr/local
MAN_PREFIX = $(PREFIX)

COMPVERSION = 6.33
LIBVERSION = 6.12.1
NAME = inform
BINNAME = $(NAME)
BINDIR = $(PREFIX)/bin
DISTNAME = $(BINNAME)-$(COMPVERSION)-$(LIBVERSION)
distdir = $(DISTNAME)
LIBDIR = $(PREFIX)/share/$(BINNAME)/lib
INCLUDEDIR = $(PREFIX)/share/$(BINNAME)/include
MANPAGE = $(NAME).1
MANDIR = $(MAN_PREFIX)/man/man1

DEFINES= -DUNIX -DInclude_Directory=\",$(INCLUDEDIR),$(LIBDIR)\" -DTemporary_Directory=\"/tmp\"

SRC = src
LIBSRC = lib
DEMO = demos
TUTOR = tutor

SOURCES = $(wildcard ${SRC}/*.c)
OBJECTS = $(patsubst %.c,%.o,${SOURCES})

LIBRARY = lib
LIB_LINKS = English.h Grammar.h Parser.h Verblib.h VerbLib.h

DEMO_SRC = $(wildcard ${DEMO}/*.inf)
DEMO_Z5  = $(patsubst %.inf,%.z5,${DEMO})
DEMODIR = $(PREFIX)/share/$(BINNAME)/demos

TUTOR_SRC = $(wildcard ${TUTOR}/*.inf)
TUTOR_Z5  = $(patsubst %.inf,%.z5,${TUTOR_SRC})
TUTORDIR = $(PREFIX)/share/$(BINNAME)/tutor

.PHONY: all clean lib

all:	lib $(BINNAME) lib demos tutor

# Rules
%.o: %.c
	$(CC) $(DEFINES) $(OPTS) -o $@ -c $<

$(BINNAME): $(OBJECTS)
	$(CC) -o $@ $^

%.z5: %.inf $(BINNAME)
	$(PWD)/$(BINNAME) +lib $< $@

lib:
	@ cd $(LIBSRC);					\
	for file in $(LIB_LINKS); do				\
		realfile=`echo $$file | tr '[A-Z]' '[a-z]'`;	\
		echo $$realfile $$file;				\
		test -r $$file || ln -s $$realfile $$file;	\
	done

demos:	lib $(BINNAME) $(DEMO_Z5)

tutor:	lib $(BINNAME) $(TUTOR_Z5)

strip: $(BINNAME)
	strip $(BINNAME)

submodule: submodules
submodules:
ifneq ($(and $(wildcard .git),$(shell which git)),)
	rm -rf $(SRC) $(LIBSRC)
	@$(GIT) submodule init
	@$(GIT) submodule update
	@$(GIT) submodule update
else
	@echo "Not in a git repository or git command missing."
	@echo "Just try \"make\" now."
endif

install: $(BINNAME) lib
	install -d -m 755 $(BINDIR)
	install -c -m 755 $(BINNAME) $(BINDIR)
	install -d -m 755 $(LIBDIR)
	install -c -m 644 $(wildcard ${LIBSRC}/*) $(LIBDIR)
	install -d -m 755 $(INCLUDEDIR)
	install -c -m 644 $(wildcard include/*) $(INCLUDEDIR)
	install -d -m 755 $(MANDIR)
	install -c -m 644 $(MANPAGE) $(MANDIR)
	install -d -m 755 $(DEMODIR)
	install -c -m 644 $(wildcard ${DEMO}/*) $(DEMODIR)
	install -d -m 755 $(TUTORDIR)
	install -c -m 644 $(wildcard ${TUTOR}/*) $(TUTORDIR)
	install -c -m 755 contrib/pblorb.pl $(BINDIR)
	install -c -m 755 contrib/scanblorb.pl $(BINDIR)

install-strip: strip install

uninstall:
	rm -f $(PREFIX)/bin/$(BINNAME)
	rm -f $(PREFIX)/bin/pblorb.pl
	rm -f $(PREFIX)/bin/scanblorb.pl
	rm -rf $(LIBDIR)
	rm -rf $(INCLUDEDIR)
	rm -rf $(DEMODIR)
	rm -rf $(TUTORDIR)

dist: distclean
	mkdir $(distdir)
	@for file in `ls`; do \
		if test $$file != $(distdir); then \
			cp -Rp $$file $(distdir)/$$file; \
		fi; \
	done
	find $(distdir) -type l -exec rm -f {} \;
	rm -rf $(distdir)/${SRC}/.git* $(distdir)/${SRC}/.deps
	rm -rf $(distdir)/${LIBSRC}/.git* $(distdir)/${LIBSRC}/.deps
	tar chof $(distdir).tar $(distdir)
	gzip -f --best $(distdir).tar
	rm -rf $(distdir)
	@echo
	@echo "$(distdir).tar.gz created"
	@echo

clean:
	rm -f $(BINNAME)
	rm -f ${SRC}/*.o
	rm -f ${DEMO}/*z5
	rm -f ${TUTOR}/*z5
	cd $(LIBSRC); \
	for file in $(LIB_LINKS); do \
		rm -f $$file; \
	done

gitclean:
ifneq ($(and $(wildcard .git),$(shell which git)),)
	$(GIT) clean -fdx
else
	@echo "Not in a git repository or git command missing."
endif

distclean: clean
	find . -name *core -exec rm -f {} \;
	-rm -rf $(distdir)
	-rm -f $(distdir).tar $(distdir).tar.gz


