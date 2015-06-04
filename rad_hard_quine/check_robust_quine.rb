#!/usr/bin/env ruby

f = ARGV[0] || 'robust_quine.rb'

prog = 'ruby'
if f =~ /\.pl$/
  prog = 'perl'
end

c = File.read(f)
a = `#{prog} #{f}`
raise if c != a

c.size.times{|i|
  m = c.dup
  m[i, 1] = ''
  File.open('out.rb', 'w'){|of|of.print(m)}
  a = `#{prog} out.rb`
  if a == c
    puts "#{i}: OK"
  else
    puts "#{i}: FAIL at #{c[i-2,2]} '#{c[i]}' #{c[i+1,2]}"
  end
}
