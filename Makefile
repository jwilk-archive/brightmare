VERSION = $(shell sed -nre '1 s/.*"([0-9.]+)".*/\1/p' version.ml)

ML_FILES  = \
  version.ml tokenize.ml \
  render.ml render_math.ml \
  parse.ml \
  brightmare.ml
CMI_FILES = $(ML_FILES:ml=cmi)
CMO_FILES = $(ML_FILES:ml=cmo)
CMX_FILES = $(ML_FILES:ml=cmx)
O_FILES   = $(ML_FILES:ml=o)

DISTFILES = Makefile Makefile.dep $(ML_FILES)

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
	@echo $(shell cat ${ML_FILES} | wc -l) lines.
	@echo $(shell cat ${ML_FILES} | wc -c) bytes.

clean:
	rm -f brightmare $(CMI_FILES) $(CMO_FILES) $(CMX_FILES) $(O_FILES)
	$(OCAMLDEP) $(ML_FILES) > Makefile.dep

distclean:
	rm -f brightmare-$(VERSION).tar.*

dist: distclean
	fakeroot tar cf brightmare-$(VERSION).tar $(DISTFILES)
	bzip2 -9 brightmare-$(VERSION).tar

.PHONY: depend all clean distclean dist

# vim:tw=76 ts=4
