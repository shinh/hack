# Keyword-only Perl

Keywords: Restricted Quine Perl

A program which converts any Perl code to a Perl code which only has
Perl keywords:

[ppencode.html](http://shinh.skr.jp/obf/ppencode.html)

Note, unlike other languages, Perl defines builtin functions as
"keywords". "open", "length", "s", and so on are keywords in Perl.

I think TAKESAKO's
[ppencode](http://namazu.org/~takesako/ppencode/demo.html)
is a pioneer work of this category.

[yuine_kw.pl](yuine_kw.pl) is a keyword-only Perl program which
generates [yuine_sym.pl](yuine_sym.pl), which is a symbol-only Perl
program which generates [yuine_kw.pl](yuine_kw.pl).
