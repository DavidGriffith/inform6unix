## Automake template for Inform program.

include $(top_srcdir)/config/Makefile.inc

bin_PROGRAMS = inform

inform_SOURCES = arrays.c asm.c bpatch.c chars.c directs.c errors.c	   \
expressc.c expressp.c files.c inform.c lexer.c linker.c memory.c objects.c \
states.c symbols.c syntax.c tables.c text.c veneer.c verbs.c header.h

INC = ,$(DESTDIR)$(localincdir),$(DESTDIR)$(localmoddir),$(DESTDIR)$(includedir),$(DESTDIR)$(moduledir)
MOD = ,$(DESTDIR)$(localmoddir),$(DESTDIR)$(moduledir)

MODDEF = -DModule_Directory=\"$(MOD)\"
INCDEF = -DInclude_Directory=\"$(INC)\"

INCLUDES = -D$(HOST) $(MODDEF) $(INCDEF)

PROGRAM = $(DESTDIR)$(bindir)/inform

install-exec-hook:
if CYGWIN
#	Don't bother keeping old versions under Cygwin.
else
	mv $(PROGRAM) $(PROGRAM)-$(INFORM_VERSION)
	$(LN_S) $(PROGRAM)-$(INFORM_VERSION) $(PROGRAM)
endif

uninstall-hook:
if CYGWIN
#	Ditto.
else
	- chmod u+w $(DESTDIR)$(bindir)
	rm -f $(PROGRAM)-$(INFORM_VERSION)
endif
