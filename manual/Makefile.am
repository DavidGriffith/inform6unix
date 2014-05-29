## Automake template for Inform designer's manual.

include $(top_srcdir)/config/Makefile.inc

man_MANS = inform.1

htmldir = $(pkgdatadir)/manual

HTML = app.html backcover.html ch1.html ch2.html ch3.html ch4.html ch5.html \
ch6.html ch7.html ch8.html cited.html colophon.html contents.html	    \
dm4index.html exdm4index.html index.html intro.html s1.html s10.html	    \
s11.html s12.html s13.html s14.html s15.html s16.html s17.html s18.html	    \
s19.html s2.html s20.html s21.html s22.html s23.html s24.html s25.html	    \
s26.html s27.html s28.html s29.html s3.html s30.html s31.html s32.html	    \
s33.html s34.html s35.html s36.html s37.html s38.html s39.html s4.html	    \
s40.html s41.html s42.html s43.html s44.html s45.html s46.html s47.html	    \
s48.html s49.html s5.html s50.html s51.html s52.html s6.html s7.html	    \
s8.html s9.html sa1.html sa2.html sa3.html sa4.html sa5.html sa6.html	    \
tables.html

JPEG = dm4-011_1.jpg dm4-015_1.jpg dm4-048_1.jpg dm4-057_1.jpg		\
dm4-084_1.jpg dm4-092_1.jpg dm4-097_1.jpg dm4-106_1.jpg dm4-116_1.jpg	\
dm4-122_1.jpg dm4-125_1.jpg dm4-126_1.jpg dm4-128_1.jpg dm4-132_1.jpg	\
dm4-135_1.jpg dm4-137_1.jpg dm4-141_1.jpg dm4-144_1.jpg dm4-148_1.jpg	\
dm4-154_1.jpg dm4-157_1.jpg dm4-162_1.jpg dm4-170_1.jpg dm4-176_1.jpg	\
dm4-178_1.jpg dm4-186_1.jpg dm4-198_1.jpg dm4-204_1.jpg dm4-211_1.jpg	\
dm4-216_1.jpg dm4-222_1.jpg dm4-225_1.jpg dm4-232_1.jpg dm4-241_1.jpg	\
dm4-247_1.jpg dm4-253_1.jpg dm4-260_1.jpg dm4-262_1.jpg dm4-267_1.jpg	\
dm4-279_1.jpg dm4-288_1.jpg dm4-295_1.jpg dm4-300_1.jpg dm4-314_1.jpg	\
dm4-318_1.jpg dm4-331_1.jpg dm4-336_1.jpg dm4-344_1.jpg dm4-349_1.jpg	\
dm4-352_1.jpg dm4-374_1.jpg dm4-378_1.jpg dm4-391_1.jpg dm4-392_1.jpg	\
dm4-406_1.jpg dm4-412_1.jpg dm4-538_1.jpg dm4-546_1.jpg dm4-572_1.jpg	\
roller2.jpg

html_DATA = $(HTML) $(JPEG)

EXTRA_DIST = $(html_DATA) $(man_MANS)

NORMAL_UNINSTALL = chmod -R u+w $(DESTDIR)$(pkgdatadir)

uninstall-hook:
	rm -rf $(DESTDIR)$(htmldir)
