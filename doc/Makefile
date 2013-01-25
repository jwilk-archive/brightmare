DB2MAN = /usr/share/xml/docbook/stylesheet/nwalsh/manpages/docbook.xsl

XML_FILES = $(wildcard *.xml)
MAN_FILES = $(XML_FILES:.xml=.1)

.PHONY: all
all: $(MAN_FILES)

.PHONY: clean
clean:
	$(RM) $(wildcard *.1)

%.1: %.xml
	xsltproc --output $(@) $(DB2MAN) $(<)

# vim:ts=4 sw=4
