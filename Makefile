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

# Making Rules

all: pl-refcard.pdf

# Cleanup rules

.PHONY: clean cleanauxs cleanfigs
clean: cleanauxs cleanfigs
	rm -f pl-refcard.pdf pl-refcard-2x.pdf

cleanauxs:
	rm -rf tmp

