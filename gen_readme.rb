#!/usr/bin/env ruby

CATEGORIES = %w(Quine Polyglot Esolang Restricted Binary Golf)
LANGUAGES = %w(Ruby Perl Python Sed Brainfuck C JavaScript Befunge)

DESCS = {
  'Quine' => 'See http://en.wikipedia.org/wiki/Quine_%28computing%29',
  'Esolang' => 'See https://esolangs.org/wiki/Main_Page',
  'Restricted' => %q(Code written with some restrictions. For example, Ruby (>= 1.9), Perl, JavaScript, and Groovy are known to be turing complete only with symbolic characters (no alphabets, no numerals, no control characters, and no non-ascii characters.).),
  'Polyglot' => 'See http://en.wikipedia.org/wiki/Polyglot_(computing)',
}

cats = {}
langs = {}

tmpl = $<.read

Dir.glob('*/README.md').each do |md|
  c = File.read(md)
  if c !~ /\A# (.*)/
    raise "no titles in #{md}"
  end
  title = $1
  if c !~ /^Keywords: (.*)/
    raise "no keywords in #{md}"
  end

  $1.split.each do |c|
    if CATEGORIES.include?(c)
      cats[c] ||= []
      cats[c] << [title, md]
    elsif LANGUAGES.include?(c)
      langs[c] ||= []
      langs[c] << [title, md]
    else
      raise "unknown keyword: #{c}"
    end
  end
end

[['CATEGORIES', cats], ['LANGUAGES', langs]].each do |n, m|
  o = ''
  m.sort_by{|k, mds|k}.each do |k, mds|
    o += "\n### #{k}\n#{DESCS[k]}\n\n"
    mds.sort.each do |md|
      o += "- [#{md[0]}](#{md[1]})\n"
    end
  end
  tmpl.sub!("%#{n}%", o)
end

print tmpl
