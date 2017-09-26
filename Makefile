all: docs

docs: ana.pdf

%.pdf : %.dot
	dot -Tpdf -o$@ $<	
