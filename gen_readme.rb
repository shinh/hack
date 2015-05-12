#!/usr/bin/env ruby

CATEGORIES = %w(Quine Polyglot Esolang Restricted Binary Golf)
LANGUAGES = %w(Ruby Perl Python Sed)

tmpl = $<.read

print tmpl
