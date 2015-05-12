all: README.md

README.md: gen_readme.rb README.tmpl
	./$^ > $@.tmp && mv $@.tmp $@
