# Common makefile targets, in -*- Makefile -*- mode.

# Version-specific installation directory.
installdir = $(pkgdatadir)/$(INFORM_VERSION)

# Place to put include files.
includedir = $(installdir)/include

# Place to put modules and headers.
moduledir = $(installdir)/module

# Place for users to put local include files.
localincdir = $(pkgdatadir)/include

# Place for users to put local modules and headers.
localmoddir = $(pkgdatadir)/module

# Place to put Z-code files.
zcodedir = $(datadir)/zcode

# Etags pattern to match Inform tags.
TYPES = \(Class\|Object\|Nearby\)
ETAGS_INFORM = -l none -r '/$(TYPES)\([ \t]+->\)*[ \t]+\([^ \t]+\)/\3/' \
-r '/\[[ \t]+\([^ \t;]+\)/\1/'

# Program to run to build Z-code files.
INFORM = $(top_builddir)/src/inform

# Include and module paths.
INCPATH = $(top_srcdir)/lib,$(top_builddir)/lib
MODPATH = $(top_srcdir)/lib,$(top_builddir)/lib

# Build flags.
INFFLAGS = -ix -~D -E1 +include_path=$(INCPATH) +module_path=$(MODPATH)

MODFLAGS = -x +include_path=$(srcdir)/ +module_path=$(srcdir)/	\
+language_name=english

# How to build things.
SUFFIXES = .inf .h .z5

.inf.z5:; $(INFORM) $(INFFLAGS) $<

.h.m5:;	$(INFORM) $(MODFLAGS) -M $< $@
