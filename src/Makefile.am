## Automake template for Inform program.

bin_PROGRAMS = inform

SRCS = arrays.c asm.c bpatch.c chars.c directs.c errors.c expressc.c	 \
expressp.c files.c inform.c lexer.c linker.c memory.c objects.c states.c \
symbols.c syntax.c tables.c text.c veneer.c verbs.c

HDRS = header.h

INCPATH = ,$(DESTDIR)$(localincdir),$(DESTDIR)$(localmoddir),$(DESTDIR)$(includedir),$(DESTDIR)$(moduledir)
MODPATH = ,$(DESTDIR)$(localmoddir),$(DESTDIR)$(moduledir)

INCLUDES = -D$(HOST) -DModule_Directory=\"$(MODPATH)\" \
-DInclude_Directory=\"$(INCPATH)\"

inform_SOURCES = $(SRCS) $(HDRS)

install-exec-hook:
if CYGWIN
#	Don't bother keeping old versions under Cygwin.
else
	mv $(DESTDIR)$(bindir)/inform $(DESTDIR)$(bindir)/inform-$(INFORM_VERSION)
	$(LN_S) $(DESTDIR)$(bindir)/inform-$(INFORM_VERSION) $(DESTDIR)$(bindir)/inform
endif

@make_include@
