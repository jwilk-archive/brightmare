# Copyright © 2006-2013 Jakub Wilk <jwilk@jwilk.net>
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the “Software”),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.

test_files = $(wildcard test/*)
c_files = locale.c
ml_files = \
	signatures.ml \
	version.ml \
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
mli_files = \
	locale.mli \
	listEx.mli strEx.mli \
	matrix.mli \
	dictionary.mli dictionary2.mli latex_dictionary.mli \
	unicore.mli unicore_convert.mli \
	unicode.mli unicode_html.mli unicode_ascii.mli unicode_konwert.mli \
	automaton.mli automaton2.mli

cmx_files = $(ml_files:ml=cmx)
cmxa_files = unix.cmxa str.cmxa
o_files = $(c_files:c=o)

OCAMLOPT = ocamlopt.opt
OCAMLDEP = ocamldep.opt -native
OCAMLFLAGS =

.PHONY: all
all: brightmare brightmare-html

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

brightmare-html: brightmare
	ln -sf $(<) $(@)

.PHONY: test
test: all
	cat $(test_files) | \
		tr '\n' '\0' | \
		xargs -0 printf "\"%s\"\n" | \
		xargs ./brightmare

.PHONY: clean
clean: Makefile.dep
	rm -f brightmare brightmare-html *.cmi *.cmo *.cmx *.o *~ a.out

# vim:ts=4 sw=4
