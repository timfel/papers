all:
	$(MAKE) build
	$(MAKE) remove_tempfiles

build:
	pdflatex paper
	bibtex paper
	pdflatex paper
	pdflatex paper
	mv paper.pdf WebDev12_FelgentreffTessenowThamsen.pdf

remove_tempfiles:
	$(RM) texput.log paper.out paper.toc paper.ind paper.ilg paper.idx paper.aux paper.log paper.bbl paper.blg

clean: remove_tempfiles
	$(RM) WebDev12_FelgentreffTessenowThamsen.pdf

rebuild: clean all
