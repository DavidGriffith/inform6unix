## Automake template for Inform program.

bin_PROGRAMS = inform

SRCS = arrays.c asm.c bpatch.c chars.c directs.c errors.c expressc.c	 \
expressp.c files.c inform.c lexer.c linker.c memory.c objects.c states.c \
symbols.c syntax.c tables.c text.c veneer.c verbs.c

HDRS = header.h

INCLUDE_DIR = -DInclude_Directory=\"$(pkgdatadir)\"
MODULE_DIR = -DModule_Directory=\"$(pkgdatadir)\"

DEFS = -D$(HOST) $(INCLUDE_DIR) $(MODULE_DIR)

inform_SOURCES = $(SRCS) $(HDRS)

@make_include@
