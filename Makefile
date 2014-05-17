BOOK = main-en
SRC = common-en.tex main-en.tex
CHAPTERS = others/preface/preface-en \
datastruct/tree/binary-search-tree/bstree-en \
sorting/insertion-sort/isort-en \
datastruct/tree/red-black-tree/rbtree-en datastruct/tree/AVL-tree/avltree-en \
datastruct/tree/trie/trie-en \
datastruct/tree/suffix-tree/stree-en datastruct/tree/B-tree/btree-en \
datastruct/heap/binary-heap/bheap-en sorting/select-sort/ssort-en \
datastruct/heap/other-heaps/kheap-en \
datastruct/elementary/queue/queue-en \
datastruct/elementary/sequence/sequence-en \
sorting/dc-sort/dcsort-en \
search/search-en \
others/appendix/list/list-en
CHAPTER_OBJS = $(foreach file, $(CHAPTERS), $(file).dvi)

all: $(BOOK).pdf

%.dvi : %.tex
	make -C $(@D) tex

image:
	make -C img

index:
	makeindex $(BOOK)

$(BOOK).pdf: image $(SRC) $(CHAPTER_OBJS)
	latex $(BOOK).tex
	makeindex $(BOOK).idx
	latex $(BOOK).tex
	dvipdfmx $(BOOK)

clean:
	rm -f *.aux *.toc *.lon *.lor *.lof *.ilg *.idx *.ind *.out *.log *.exa

distclean: clean
	rm -f *.pdf *.dvi *~
