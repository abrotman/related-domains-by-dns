MMARK=mmark
XML2RFC=xml2rfc
SOURCES=rdbd.md
XML=$(SOURCES:.md=.xml)
TXT=$(SOURCES:.md=.txt)

all: $(XML) $(TXT)

%.xml : %.md
	$(MMARK) -xml2 -page $< > $@ 
	
%.txt : %.xml
	$(XML2RFC) $< --text $@

clean:
	rm $(XML)
	rm $(TXT)
