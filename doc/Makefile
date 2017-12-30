xsl = http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl
xsltproc_options = --nonet --param man.authors.section.enabled 0
xml_files = $(wildcard *.xml)
man_files = $(xml_files:.xml=.1)

.PHONY: all
all: $(man_files)

%.1: %.xml
	xsltproc $(xsltproc_options) --output $(@) $(xsl) $(<)

.PHONY: validate
validate: $(xml_files)
	xmllint --nonet --noout --valid $(^)

.PHONY: clean
clean:
	rm -f *.1

# vim:ts=4 sts=4 sw=4
