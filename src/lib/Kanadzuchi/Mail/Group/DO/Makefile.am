# $Id: Makefile.am,v 1.1.2.1 2011/03/09 06:47:40 ak Exp $
# Copyright (C) 2011 Cubicroot Co. Ltd.
# This is the auto-Makefile for bounceHammer/src/lib/Kanadzuchi/Mail/Group/DO,
# is processed by automake to create Makefile.in.

distdir = $(BUILDROOT)/dist/lib/Kanadzuchi/Mail/Group/DO
pkgdatadir = @libdir@/Kanadzuchi/Mail/Group/DO
pkgdata_DATA = Smartphone.pm

all-am:
	test -d $(distdir) || mkdir -p $(distdir)
	cp -Rp $(pkgdata_DATA) $(distdir)/

.PHONY: clean
clean:
	rm -f $(distdir)/*.pm

