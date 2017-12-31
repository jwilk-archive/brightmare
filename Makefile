# Copyright © 2006-2017 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

DESTDIR =
PREFIX = /usr/local

OCAMLOPT = ocamlopt
OCAMLDEP = ocamldep -native
OCAMLFLAGS =

prefix = $(PREFIX)
exec_prefix = $(prefix)
bindir = $(exec_prefix)/bin
datarootdir = $(prefix)/share
mandir = $(datarootdir)/man

test_files = $(wildcard test/*)
c_files = $(wildcard *-impl.c)
ml_files = \
	signatures.ml \
	version.ml \
	locale.ml \
	listEx.ml strEx.ml \
	matrix.ml \
	dictionary2.ml dictionary.ml latex_dictionary.ml \
	unicore.ml unicore_convert.ml \
	unicode.ml unicode_html.ml unicode_ascii.ml unicode_konwert.ml \
	decoration.ml decoration_ansi.ml decoration_html.ml \
	render.ml rmath.ml \
	automaton.ml automaton2.ml \
	lexscan.ml \
	parsetree.ml parse.ml interpret.ml interpret_debug.ml \
	brightmare.ml
mli_files = $(wildcard *.mli)

cmx_files = $(ml_files:ml=cmx)
cmxa_files = unix.cmxa str.cmxa
o_files = $(c_files:c=o)

.PHONY: all
all: brightmare

Makefile.dep: $(ml_files) $(mli_files)
	$(OCAMLDEP) $(^) > Makefile.dep

include Makefile.dep

%.cmi: %.mli
	$(OCAMLOPT) $(OCAMLFLAGS) -c $(<)

%.cmx: %.ml
	$(OCAMLOPT) $(OCAMLFLAGS) -c $(<)

%.o: %.c
	$(OCAMLOPT) $(OCAMLFLAGS) -c $(<)

brightmare: $(cmx_files) $(o_files)
	$(OCAMLOPT) $(OCAMLFLAGS) $(cmxa_files) $(^) -o $(@)

.PHONY: install
install: brightmare
	install -d $(DESTDIR)$(bindir)
	install -m755 brightmare $(DESTDIR)$(bindir)/brightmare
ifeq "$(wildcard .git doc/*.1)" ".git"
	# run "$(MAKE) -C doc" to build the manpages
else
	install -d $(DESTDIR)$(mandir)/man1
	install -m644 doc/brightmare.1 $(DESTDIR)$(mandir)/man1/brightmare.1
endif

.PHONY: test
test: all
	cat $(test_files) | \
		xargs -d '\n' ./brightmare

.PHONY: clean
clean:
	rm -f brightmare *.cmi *.cmo *.cmx *.o *~ a.out Makefile.dep

# vim:ts=4 sts=4 sw=4
