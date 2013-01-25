xsl = http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl
xml_files = $(wildcard *.xml)
man_files = $(xml_files:.xml=.1)

.PHONY: all
all: $(man_files)

.PHONY: clean
clean:
	$(RM) $(wildcard *.1)

%.1: %.xml
	xsltproc --output $(@) $(xsl) $(<)

# vim:ts=4 sw=4
