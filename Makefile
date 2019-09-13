MMARK=mmark
XML2RFC=xml2rfc
SOURCES=rdbd-reorg.md
XML=$(SOURCES:.md=.xml)
TXT=$(SOURCES:.md=.txt)

all: $(XML) $(TXT)

%.xml : %.md
	$(MMARK) -xml2 -page $< > $@ 
	
%.txt : %.xml
	$(XML2RFC) $< --text $@

rdbd-reorg.md: newapp.md
	touch rdbd-reorg.md

upload:
	scp rdbd-reorg.md  down.dsg.cs.tcd.ie:/var/www/misc/
	scp rdbd-reorg.xml  down.dsg.cs.tcd.ie:/var/www/misc/
	scp rdbd-reorg.txt  down.dsg.cs.tcd.ie:/var/www/misc/

clean:
	rm $(XML)
	rm $(TXT)
