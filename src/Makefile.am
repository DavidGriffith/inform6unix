## Automake template for Inform program.

include $(top_srcdir)/config/commondefs

bin_PROGRAMS = inform

SRCS = arrays.c asm.c bpatch.c chars.c directs.c errors.c expressc.c	 \
expressp.c files.c inform.c lexer.c linker.c memory.c objects.c states.c \
symbols.c syntax.c tables.c text.c veneer.c verbs.c

HDRS = header.h

# Default path separator (:)
PATH_SEP = 072

# Default error format
ERROR_FMT = 1

HOST_DEF = -D$(HOST)
SEPARATOR = -DFN_ALT=$(PATH_SEP)
ERROR_FORMAT = -DDEFAULT_ERROR_FORMAT=$(ERROR_FMT)
INCLUDE_DIR = -DInclude_Directory=\"$(localdir):$(includedir):$(moduledir)\"
MODULE_DIR = -DModule_Directory=\"$(moduledir)\"

INCLUDES = $(HOST_DEF) $(SEPARATOR) $(ERROR_FORMAT) $(INCLUDE_DIR)	\
$(MODULE_DIR)

inform_SOURCES = $(SRCS) $(HDRS)

install-exec-hook:
if CYGWIN
#	Don't bother keeping old versions under Cygwin.
else
	mv $(bindir)/inform $(bindir)/inform-$(INFORM_VERSION)
	$(LN_S) $(bindir)/inform-$(INFORM_VERSION) $(bindir)/inform
endif
	$(top_srcdir)/config/mkinstalldirs $(localdir)
