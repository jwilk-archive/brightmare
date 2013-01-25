XSL = http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl
XML_FILES = $(wildcard *.xml)
MAN_FILES = $(XML_FILES:.xml=.1)

.PHONY: all
all: $(MAN_FILES)

.PHONY: clean
clean:
	$(RM) $(wildcard *.1)

%.1: %.xml
	xsltproc --output $(@) $(XSL) $(<)

# vim:ts=4 sw=4
