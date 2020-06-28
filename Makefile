.PHONY=website clean

CONVERT=_scripts/convert-md-to-html.sh

website: index.html

index.html: _src/index.md
	$(CONVERT) _src/index.md index.html

clean:
	rm -f *.html
