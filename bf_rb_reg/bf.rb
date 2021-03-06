#BF_CHARS = [*'0'..'9'] + [*'A'..'Z']

#BF_CHARS = (0..255).map do |i|
#  (i / 16).to_s(32) + (i % 16 + 16).to_s(32)
#end

#BF_CHARS = (0..127).map do |i|
#  (i + 128).chr
#end

BF_CHARS = (0..255).map(&:chr)

Z = BF_CHARS[0]

ANY = '.' * BF_CHARS[0].size

BF_SUFFIX = "#{BF_CHARS[-1]};;" + BF_CHARS * '' * 4

def h(c)
  if '()*+?[]\\#$.^|'.index(c)
    "\\#{c}"
  elsif c == "\t"
    "\\t"
  elsif c == "\n"
    "\\n"
  elsif c == "\f"
    "\\f"
  elsif c == "\r"
    "\\r"
  elsif c == " "
    "[ ]"
  else
    c
  end
end

def gen_set_mi
  a = []
  BF_CHARS.each_with_index do |c, i|
    a << "(?<set_m#{i}>(?<m#{i}>#{ANY})){0}"
  end
  a * ''
end

def gen_inc_p
  a = []
  BF_CHARS.each_with_index do |c, i|
    a << "(\\k<p>\\g<set_p>.*?(?=\\k<x>)\\g<set_m#{i}>.*?(?=\\k<m#{(i+1)%BF_CHARS.size}>)\\g<set_x>|#{h(c)}"
  end
  a * '' + ')' * BF_CHARS.size
end

def gen_dec_p
  a = []
  BF_CHARS.each_with_index do |c, i|
    a << "((?=#{ANY}\\k<p>)\\g<set_p>.*?(?=\\k<x>)\\g<set_m#{(i+1)%BF_CHARS.size}>.*?(?=\\k<m#{i}>)\\g<set_x>|#{h(c)}"
  end
  a * '' + ')' * BF_CHARS.size
end

def output
  a = []
  BF_CHARS.each_with_index do |c, i|
    a << "(?=.*(?=#{h(c)})\\k<op>)(?<o#{i}>#{ANY})"
  end
  a * '|'
end

def input
  a = []
  BF_CHARS.each_with_index do |c, i|
    a << "(?=.*(?=#{h(c)})\\k<ip>)(?=#{ANY*i}\\g<set_x>)"
  end
  a * '|'
end

def init_m
  a = []
  BF_CHARS.each_with_index do |c, i|
    a << "(?=.*;;.*(?=#{h(c)})\\g<set_p>)(?=.*;;.*(?=#{Z})\\g<set_m#{i}>)"
  end
  a.reverse * ''
end

def nest
  "(?=.*;;(?=#{Z})\\k<x>)\\g<skip_loop>|(?=\\g<loop>)(" * BF_CHARS.size + ")" * BF_CHARS.size
end

BF_REG = /^

#{gen_set_mi}

(?<set_p>(?<p>#{ANY})){0}

(?<set_op>(?<op>#{ANY})){0}
(?=.*;;.*?(?=#{Z})\g<set_op>)

(?<set_ip>(?<ip>#{ANY})){0}
(?=.*;;.*?(?=#{Z})\g<set_ip>)

(?<set_x>(?<x>#{ANY})){0}
(?=.*;;.*?(?=#{Z})\g<set_x>)

(?<inc_p>(?=.*;;#{gen_inc_p})){0}
(?<dec_p>(?=.*;;#{gen_dec_p})){0}

(?<output>#{output}){0}

(?<init_m>#{init_m}){0}
\g<init_m>

(?<skip_loop>[^\[\]]*(\[\g<skip_loop>\][^\[\]]*)*){0}

(?<loop>

(
 (
  \+(?=.*;;.*?\k<x>\g<set_x>)
 | -(?=.*;;.*?(?=#{ANY}\k<x>)\g<set_x>)
 | >\g<inc_p>
 | <\g<dec_p>
 | \[ ( #{nest} ) \]
 | \.(?=.*;;.*?(?=\k<x>)\g<output>)(?=.*;;.*?\k<op>\g<set_op>)
 | ,(?=.*?!(#{input}))(?=.*;;.*?\k<ip>\g<set_ip>)
 )
)+

){0}

\g<loop>

(!|#{BF_SUFFIX.chars.map{|_|h(_)}*''}$)/xms

def run_bf(bf)
  if BF_REG =~ bf + BF_SUFFIX
    $~
  else
    false
  end
end

def collect_output(m)
  r = ''
  BF_CHARS.size.times do |i|
    o = m["o#{i}"]
    if !o
      break
    end
    r += o
  end
  r
end

def check(bf, ep, em, eo='')
  start = Time.now
  ex = em[ep]

  m = run_bf(bf)
  if !m
    puts "FAIL(match): #{bf}"
    return
  end

  ap = BF_CHARS.index(m['p'])
  if ap != ep
    puts "FAIL(ptr): #{bf} expected=#{ep} actual=#{ap}"
    return
  end

  ax = BF_CHARS.index(m['x'])
  if ex && ax != ex
    puts "FAIL(x): #{bf} expected=#{ex} actual=#{ax}"
    return
  end

  am = []
  em.size.times do |i|
    if i == ep
      am << ax
    else
      am << BF_CHARS.index(m["m#{i}"])
    end
  end
  if am != em
    puts "FAIL(mem): #{bf} expected=#{em} actual=#{am}"
    return
  end

  ao = collect_output(m)
  if ao != eo
    puts "FAIL(out): #{bf} expected=#{eo} actual=#{ao}"
    return
  end

  puts "OK: #{bf} #{Time.now - start}"
end

if ARGV.empty?
  puts "Usage: %s <prog.bf> [input]" % $0

  puts "Running tests..."

  check('+++', 0, [3])

  check('>>', 2, [])

  check('+++++--+>+++<+>>', 2, [5, 3])

  check('[+]+', 0, [1])

  check('+++[-]+', 0, [1])

  check('+++[->++<]+', 0, [1, 6])

  check('[[]]+', 0, [1])

  check('+++[->++[->+++<]<]+', 0, [1, 0, 18])

  check('+' * 33 + '.', 0, [33], '!')

  check('+' * 33 + '.++.', 0, [35], '!#')

  check(',.!x', 0, [120], 'x')

  check(',.,.,.!foo', 0, [111], 'foo')
  check(',.,.,.,.!hoge', 0, [101], 'hoge')

  check(',+[-.,+]!xyz', 0, [0], 'xyz')

  check('-', 0, [BF_CHARS.size - 1])
  check('>' * (BF_CHARS.size + 1), 1, [])
  check('<<', BF_CHARS.size - 2, [])
  check('+' * (BF_CHARS.size + 2), 0, [2])

  check(',[-]!;;!',0, [0])
  check(',[-]!;;!' + BF_CHARS[1], 0, [0])

  check('+<<---------[>+++++>>+>++>+>++[+++<]>--]>.[->+>+>+<<<]>+.>..+++.>>>-.<----.<++.<.+++.------.<-.>>>+.', 3, [100, 108, 119, 33, 44], 'Hello, world!')
else
  bf = File.read(ARGV[0])
  bf = bf.chars.select{|c|'+-><[].,'.index(c)} * ''
  if ARGV[1]
    bf += "!#{ARGV[1]}"
  elsif bf.index(',')
    bf += "!#{STDIN.read}"
  end

  m = run_bf(bf)
  if m
    puts collect_output(m)
  else
    STDERR.puts "Program doesn't finish"
    exit 1
  end
end
