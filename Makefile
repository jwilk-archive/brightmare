VERSION = $(shell sed -nre '1 s/.*"([0-9.]+)".*/\1/p' version.ml)

DIST_FILES = README README.dep Makefile Makefile.dep $(SOURCE_FILES)
SOURCE_FILES = $(C_FILES) $(ML_FILES) $(MLI_FILES)
C_FILES = locale.c
ML_FILES = \
	zz_signatures.ml \
	version.ml \
	listEx.ml strEx.ml \
	unicore.ml unicode.ml unicode_html.ml unicode_konwert.ml \
	dictionary.ml latex_dictionary.ml \
	decoration.ml decoration_html.ml \
	render.ml rmath.ml \
	automaton.ml automaton2.ml \
	lexscan.ml \
	parsetree.ml parse.ml interpret.ml interpret_debug.ml \
	brightmare.ml
MLI_FILES = \
	locale.mli \
	listEx.mli strEx.mli \
	unicore.mli unicode.mli unicode_html.mli unicode_konwert.mli \
	decoration.mli decoration_html.mli \
	dictionary.mli latex_dictionary.mli \
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
	$(OCAMLDEP) ${^} > Makefile.dep

include Makefile.dep

%.cmi: %.mli
	$(OCAMLOPT) $(FLAGS) -c ${<}

%.cmx: %.ml
	$(OCAMLOPT) $(FLAGS) -c ${<}

%.o: %.c
	$(OCAMLOPT) $(FLAGS) -c ${<}

brightmare: $(CMX_FILES) $(O_FILES)
	$(OCAMLOPT) $(FLAGS) $(CMXA_FILES) ${^} -o ${@}
	$(STRIP) ${@}

brightmare-html: brightmare
	ln -sf ${<} ${@}

test: all
	cat test/defaulttest | \
		tr '\n' '\0' | \
		xargs -0 printf "\"%s\"\n" | \
		xargs ./brightmare

stats:
	@echo $(shell cat ${SOURCE_FILES} | wc -l) lines.
	@echo $(shell cat ${SOURCE_FILES} | wc -c) bytes.

clean: Makefile.dep
	rm -f brightmare{,-html} *.cmi *.cmo *.cmx *.o *~ a.out

distclean:
	rm -f brightmare-$(VERSION).tar.*

dist: distclean
	fakeroot tar cf brightmare-$(VERSION).tar $(DIST_FILES)
	bzip2 -9 brightmare-$(VERSION).tar

.PHONY: all test stats clean distclean dist

# vim:ts=4 sw=4
