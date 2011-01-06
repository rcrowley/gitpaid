prefix=/usr/local
bindir=${prefix}/bin
libdir=${prefix}/lib
mandir=${prefix}/share/man

all:

clean:

install:
	install -d $(DESTDIR)$(bindir)
	install bin/gpbegin bin/gpend bin/gpinvoice $(DESTDIR)$(bindir)/
	install -d $(DESTDIR)$(libdir)
	install -m644 lib/gp.sh $(DESTDIR)$(libdir)/
	install -d $(DESTDIR)$(mandir)/man1
	install -m644 man/man1/gpbegin.1 man/man1/gpend.1 man/man1/gpinvoice.1 \
		$(DESTDIR)$(mandir)/man1/

uninstall:
	rm -f \
		$(DESTDIR)$(bindir)/gpbegin \
		$(DESTDIR)$(bindir)/gpend \
		$(DESTDIR)$(bindir)/gpinvoice \
		$(DESTDIR)$(libdir)/gp.sh \
		$(DESTDIR)$(mandir)/man1/gpbegin.1 \
		$(DESTDIR)$(mandir)/man1/gpend.1 \
		$(DESTDIR)$(mandir)/man1/gpinvoice.1
	rmdir -p --ignore-fail-on-non-empty \
		$(DESTDIR)$(bindir) \
		$(DESTDIR)$(libdir) \
		$(DESTDIR)$(mandir)
	

man:
	find man -name \*.ronn | xargs -n1 ronn --manual=Git\ Paid --style=toc

gh-pages: man
	mkdir -p gh-pages
	find man -name \*.html | xargs -I__ mv __ gh-pages/
	git checkout -q gh-pages
	cp -R gh-pages/* ./
	rm -rf gh-pages
	git add .
	git commit -m "Rebuilt manual."
	git push origin gh-pages
	git checkout -q master

.PHONY: all clean install uninstall man gh-pages
