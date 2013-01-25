xsl = http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl
xml_files = $(wildcard *.xml)
man_files = $(xml_files:.xml=.1)
xsltproc_options = --param man.authors.section.enabled 0

.PHONY: all
all: $(man_files)

.PHONY: clean
clean:
	rm -f *.1

%.1: %.xml
	xsltproc $(xsltproc_options) --output $(@) $(xsl) $(<)

# vim:ts=4 sw=4
