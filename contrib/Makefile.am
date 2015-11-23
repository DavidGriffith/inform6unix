## Automake template for Inform contributed utilities

include $(top_srcdir)/config/Makefile.inc

EXTRA_DIST = pblorb.pl scanblorb.pl

bin_SCRIPTS = pblorb scanblorb

CLEANFILES = pblorb scanblorb

pblorb:
	perl -cw pblorb.pl
	cp pblorb.pl pblorb
	chmod 755 pblorb

scanblorb:
	perl -cw scanblorb.pl
	cp scanblorb.pl scanblorb
	chmod 755 scanblorb

#dist-hook:
#	rm -f pblorb
#	rm -f scanblorb
