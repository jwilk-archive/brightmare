VERSION = $(shell sed -nre '1 s/.*"([0-9.]+)".*/\1/p' version.ml)

ML_FILES  = version.ml tokenize.ml parse.ml brightmare.ml
CMI_FILES = $(ML_FILES:ml=cmi)
CMX_FILES = $(ML_FILES:ml=cmx)
O_FILES   = $(ML_FILES:ml=o)

DISTFILES = Makefile $(ML_FILES)

OCAMLC = ocamlopt.opt
STRIP = strip -s

all: brightmare

brightmare: $(ML_FILES)
	$(OCAMLC) ${^} -o ${@}
	$(STRIP) ${@}

test: brightmare devel/tests
	< devel/tests tr '\n' '\0' | xargs -0 printf "\"%s\"\n" | xargs ./brightmare
            
clean:
	rm -f brightmare $(CMI_FILES) $(CMX_FILES) $(O_FILES)

distclean:
	rm -f brightmare-$(VERSION).tar.*

dist: distclean
	fakeroot tar cf brightmare-$(VERSION).tar $(DISTFILES)
	bzip2 -9 brightmare-$(VERSION).tar

.PHONY: all clean distclean dist

# vim:tw=76 ts=4
