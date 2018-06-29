all : paper.pdf
	pdflatex --shell-escape paper
	pdflatex --shell-escape paper
	bibtex paper
	pdflatex --shell-escape paper
	open paper.pdf
