# Makefile


# Output quieting, choose one

# needs bash installed:
export QUIETPREFIX = tmp/
QUIET = ./bin/quiet

# needs moreutils installed:
#QUIET = chronic </dev/null

# verbose output (does not need anything):
#QUIET =


# Implicit Rules

PDFLATEX = $(QUIET) pdflatex -halt-on-error -file-line-error -output-directory tmp
FASTPDFLATEX = $(PDFLATEX) -draftmode

%.pdf: %.tex
	@mkdir -p tmp
	$(FASTPDFLATEX) $<
	$(PDFLATEX) $<
	@cp tmp/$@ $@

%-2x.pdf: %.pdf
	mkdir -p tmp/2x
	./bin/quiet pdf90 $< -o tmp/2x/90.pdf
	pdfseparate tmp/2x/90.pdf tmp/2x/%d.pdf
	pdfunite tmp/2x/1.pdf tmp/2x/1.pdf tmp/2x/2.pdf tmp/2x/2.pdf tmp/2x/united.pdf
	./bin/quiet pdfnup tmp/2x/united.pdf -o $@
	rm -r tmp/2x

sv-refcard-2x.pdf: sv-refcard.pdf
	# sv-refcard has a single page, so it needs a special rule
	# this can safely be removed once it reaches 2 pages
	mkdir -p tmp/2x
	./bin/quiet pdf90 $< -o tmp/2x/90.pdf
	pdfunite tmp/2x/90.pdf tmp/2x/90.pdf tmp/2x/united.pdf
	./bin/quiet pdfnup tmp/2x/united.pdf -o $@
	rm -r tmp/2x

# Making Rules

all: pl-refcard.pdf sv-refcard.pdf

2x: pl-refcard-2x.pdf sv-refcard-2x.pdf

mindmap: pl-mindmap.pdf

pl-mindmap.pdf:
	fdp -Tpdf pl-mindmap.dot > pl-mindmap.pdf

# Cleanup rules

.PHONY: clean cleanauxs cleanfigs
clean: cleanauxs cleanfigs
	rm -f pl-refcard.pdf pl-refcard-2x.pdf pl-mindmap.pdf

cleanauxs:
	rm -rf tmp

