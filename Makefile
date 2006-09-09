VERSION = $(shell sed -nre '1 s/.*"([0-9.]+)".*/\1/p' version.ml)

DIST_FILES = README README.devel Makefile Makefile.dep $(SOURCE_FILES)
TEST_FILES = $(wildcard test/*)
SOURCE_FILES = $(C_FILES) $(ML_FILES) $(MLI_FILES)
C_FILES = locale.c
ML_FILES = \
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
MLI_FILES = \
	locale.mli \
	listEx.mli strEx.mli \
	matrix.mli \
	dictionary.mli dictionary2.mli latex_dictionary.mli \
	unicore.mli unicore_convert.mli \
	unicode.mli unicode_html.mli unicode_ascii.mli unicode_konwert.mli \
	automaton.mli automaton2.mli

CMI_FILES = $(MLI_FILES:mli=cmi)
CMX_FILES = $(ML_FILES:ml=cmx)
CMXA_FILES = unix.cmxa str.cmxa
O_FILES = $(C_FILES:c=o)

OCAMLOPT = ocamlopt.opt
OCAMLDEP = ocamldep.opt -native
STRIP = strip -s
FLAGS =

all: brightmare brightmare-html

Makefile.dep: $(ML_FILES) $(MLI_FILES)
	$(OCAMLDEP) $(^) > Makefile.dep

include Makefile.dep

%.cmi: %.mli
	$(OCAMLOPT) $(FLAGS) -c $(<)

%.cmx: %.ml
	$(OCAMLOPT) $(FLAGS) -c $(<)

%.o: %.c
	$(OCAMLOPT) $(FLAGS) -c $(<)

brightmare: $(CMX_FILES) $(O_FILES)
	$(OCAMLOPT) $(FLAGS) $(CMXA_FILES) $(^) -o $(@)
	$(STRIP) $(@)

brightmare-html: brightmare
	ln -sf $(<) $(@)

.PHONY: test
test: all
	cat $(TEST_FILES) | \
		tr '\n' '\0' | \
		xargs -0 printf "\"%s\"\n" | \
		xargs ./brightmare

.PHONY: stats
stats:
	@echo $(shell cat $(SOURCE_FILES) | wc -l) lines.
	@echo $(shell cat $(SOURCE_FILES) | wc -c) bytes.

.PHONY: clean
clean: Makefile.dep
	$(RM) brightmare brightmare-html *.cmi *.cmo *.cmx *.o *~ a.out

.PHONY: all test stats clean

# vim:ts=4 sw=4
