VERSION = $(shell sed -nre '1 s/.*"([0-9.]+)".*/\1/p' version.ml)

DIST_FILES = Makefile Makefile.dep $(SOURCE_FILES)
SOURCE_FILES = $(MLI_FILES) $(ML_FILES)
MLI_FILES = \
	dictionary.mli tokenize.mli
ML_FILES = \
	dictionary.ml \
	version.ml \
	tokenize.ml \
	render.ml render_math.ml \
	parse.ml \
	brightmare.ml
CMI_FILES = $(ML_FILES:ml=cmi)
CMO_FILES = $(ML_FILES:ml=cmo)
CMX_FILES = $(ML_FILES:ml=cmx)
O_FILES   = $(ML_FILES:ml=o)

ifdef NATIVE
	OCAMLC = ocamlopt.opt
	OBJ_FILES = $(CMX_FILES)
	STRIP = strip -s
else
	OCAMLC = ocamlc.opt
	OBJ_FILES = $(CMO_FILES)
	STRIP = true
endif
OCAMLDEP = ocamldep.opt

all: brightmare

include Makefile.dep

%.cmi: %.mli
	$(OCAMLC) -c ${<}

ifdef NATIVE
%.cmx: %.ml
	$(OCAMLC) -c ${<}
else
%.cmo: %.ml
	$(OCAMLC) -c ${<}
endif

brightmare: $(OBJ_FILES)
	$(OCAMLC) ${^} -o ${@}
	$(STRIP) ${@}

test: brightmare devel/tests
	< devel/tests tr '\n' '\0' | xargs -0 printf "\"%s\"\n" | xargs ./brightmare

stats:
	@echo $(shell cat ${SOURCE_FILES} | wc -l) lines.
	@echo $(shell cat ${SOURCE_FILES} | wc -c) bytes.

clean:
	rm -f brightmare $(CMI_FILES) $(CMO_FILES) $(CMX_FILES) $(O_FILES)
	$(OCAMLDEP) $(ML_FILES) > Makefile.dep

distclean:
	rm -f brightmare-$(VERSION).tar.*

dist: distclean
	fakeroot tar cf brightmare-$(VERSION).tar $(DIST_FILES)
	bzip2 -9 brightmare-$(VERSION).tar

.PHONY: depend all clean distclean dist

# vim:tw=76 ts=4
