all: README.md README.html

README.md: gen_readme.rb README.tmpl $(wildcard */README.md)
	./gen_readme.rb README.tmpl > $@.tmp && mv $@.tmp $@

README.html: README.md
	markdown $< > $@.tmp && mv $@.tmp $@
