MMARK=mmark
XML2RFC=xml2rfc
SOURCES=rdbd-newrrs.md
XML=$(SOURCES:.md=.xml)
TXT=$(SOURCES:.md=.txt)

all: $(XML) $(TXT)

%.xml : %.md
	$(MMARK) -xml2 -page $< > $@ 
	
%.txt : %.xml
	$(XML2RFC) $< --text $@

rdbd-newrrs.md: appendix.md
	touch rdbd-newrrs.md

upload:
	scp rdbd-newrrs.md  down.dsg.cs.tcd.ie:/var/www/misc/
	scp rdbd-newrrs.xml  down.dsg.cs.tcd.ie:/var/www/misc/
	scp rdbd-newrrs.txt  down.dsg.cs.tcd.ie:/var/www/misc/

clean:
	rm $(XML)
	rm $(TXT)
