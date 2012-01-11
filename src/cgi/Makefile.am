# $Id: Makefile.am,v 1.3.2.4 2012/01/11 07:00:40 ak Exp $
# Copyright (C) 2009,2010 Cubicroot Co. Ltd.
# This is the auto-Makefile for bounceHammer/src/cgi, is processed by 
# automake to create Makefile.in.

pkgdatadir = @datarootdir@/script
distdir = $(BUILDROOT)/dist/script
pkgdata_DATA = api.cgi bouncehammer.cgi
SUFFIXES = .PL .cgi

$(pkgdata_DATA):
	test -d $(distdir) || mkdir -p $(distdir)
	$(CAT) $*.PL | $(SED) \
		-e 's|__KANADZUCHIROOT__|@prefix@|g' \
		-e 's|__KANADZUCHIDATA__|@datadir@|g' \
		-e 's|__KANADZUCHIETC__|@sysconfdir@|g' \
		-e 's|__KANADZUCHIBIN__|@bindir@|g' \
		-e 's|__PERLEXECUTABLE__|!$(PERL)|g' \
		-e 's|__PERLEXTERNALLIB__|$(PERL_EXTLIB)|g' \
		-e 's|\([^:]\)//|\1/|g' > $@.tmp
	mv $@.tmp $@
	test "X$(PERL_EXTLIB)" = "X" || ( $(GREP) -v PERL_EXTLIB $@ > $@.tmp && mv $@.tmp $@ )
	cp -Rp $@ $(distdir)/

.PHONY: clean
clean:
	rm -f $(pkgdata_DATA)
	rm -f $(distdir)/*
