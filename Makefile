VERSION = $(shell sed -nre '1 s/.*"([0-9.]+)".*/\1/p' version.ml)

DIST_FILES = README Makefile Makefile.dep $(SOURCE_FILES)
SOURCE_FILES = $(C_FILES) $(MLI_FILES) $(ML_FILES)
C_FILES = locale.c
ML_FILES = \
	version.ml \
	list2.ml string2.ml \
	unicode.ml \
	dictionary.ml latex_dictionary.ml \
	render.ml rmath.ml \
	tokenize.ml parse.ml \
	brightmare.ml
MLI_FILES = \
	locale.mli version.mli \
	list2.mli string2.mli \
	unicode.mli \
	dictionary.mli latex_dictionary.mli \
	render.mli rmath.mli \
	tokenize.mli parse.mli 
CMI_FILES = $(ML_FILES:ml=cmi)
CMO_FILES = $(ML_FILES:ml=cmo)
CMX_FILES = $(ML_FILES:ml=cmx)
CO_FILES  = $(C_FILES:c=o)
O_FILES   = $(CO_FILES) $(ML_FILES:ml=o)

OCAMLC = ocamlopt.opt
OBJ_FILES = $(CMX_FILES) $(CO_FILES)
STRIP = strip -s
OCAMLDEP = ocamldep.opt

all: brightmare

include Makefile.dep

%.cmi: %.mli
	$(OCAMLC) -c ${<}

%.cmx: %.ml
	$(OCAMLC) -c ${<}

%.o: %.c
	$(OCAMLC) -c ${<}

brightmare: $(OBJ_FILES)
	$(OCAMLC) ${^} -o ${@}
	$(STRIP) ${@}

test: brightmare
	cat test/defaulttest | \
		tr '\n' '\0' | \
		xargs -0 printf "\"%s\"\n" | \
		xargs ./brightmare

stats:
	@echo $(shell cat ${SOURCE_FILES} | wc -l) lines.
	@echo $(shell cat ${SOURCE_FILES} | wc -c) bytes.

clean:
	rm -f brightmare $(CMI_FILES) $(CMO_FILES) $(CMX_FILES) $(O_FILES)
	$(OCAMLDEP) $(MLI_FILES) $(ML_FILES) > Makefile.dep

distclean:
	rm -f brightmare-$(VERSION).tar.*

dist: distclean
	fakeroot tar cf brightmare-$(VERSION).tar $(DIST_FILES)
	bzip2 -9 brightmare-$(VERSION).tar

.PHONY: all test stats clean distclean dist

# vim:ts=4 sw=4
