VERSION = $(shell sed -nre '1 s/.*"([0-9.]+)".*/\1/p' version.ml)

DIST_FILES = README Makefile Makefile.dep $(SOURCE_FILES)
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
	tokenize.ml parse.ml \
	brightmare.ml
MLI_FILES = \
	locale.mli version.mli \
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
STRIP = strip -s
OCAMLDEP = ocamldep.opt -native

all: brightmare

Makefile.dep: $(ML_FILES) $(MLI_FILES)
	$(OCAMLDEP) ${^} > Makefile.dep

include Makefile.dep

%.cmi: %.mli
	$(OCAMLOPT) -c ${<}

%.cmx: %.ml
	$(OCAMLOPT) -c ${<}

%.o: %.c
	$(OCAMLOPT) -c ${<}

brightmare: $(CMX_FILES) $(O_FILES)
	$(OCAMLOPT) $(CMXA_FILES) ${^} -o ${@}
	$(STRIP) ${@}

test: brightmare
	cat test/defaulttest | \
		tr '\n' '\0' | \
		xargs -0 printf "\"%s\"\n" | \
		xargs ./brightmare

stats:
	@echo $(shell cat ${SOURCE_FILES} | wc -l) lines.
	@echo $(shell cat ${SOURCE_FILES} | wc -c) bytes.

clean: Makefile.dep
	rm -f brightmare *.cmi *.cmo *.cmx *.o *~

distclean:
	rm -f brightmare-$(VERSION).tar.*

dist: distclean
	fakeroot tar cf brightmare-$(VERSION).tar $(DIST_FILES)
	bzip2 -9 brightmare-$(VERSION).tar

.PHONY: all test stats clean distclean dist

# vim:ts=4 sw=4
