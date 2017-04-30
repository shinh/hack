#!/usr/bin/env ruby

def escapeHTML(c)
  c = c.gsub('&', '&amp;')
  c = c.gsub('"', '&quot;')
  c = c.gsub('<', '&lt;')
  c = c.gsub('>', '&gt;')
  c
end

D=28

CONVS = {
  "(" => ")()",
  ")" => "()(",
  "/" => "\\\\/",
  "\\" => "//\\",
  "<" => "><>",
  ">" => "<><",
  "[" => "][]",
  "]" => "[][",
  "{" => "}{}",
  "}" => "{}{",
}
%q( #*+-0:=HIOX|).each_char{|c|CONVS[c] = c*3}

c = File.read('very_symmetric_base.js')
c.gsub!(/^\/\/.*\n/, '')
c.gsub!(/^\n/, '')
c="///*\n"+c

var_chars = {}
c.scan(/str_(\w)/) do
  var_chars[$1]=$&
end
var_chars[' ']='str_sp'
var_chars['(']='str_op'
var_chars[')']='str_cp'
#var_chars['.']='str_dot'

lengthy_map = Hash.new{0}

c+="obj_function(obj_unescape("
code=%q((this.alert||this.print||console.log)("Hello, world!"))
a=[]
skip_next = false
code.each_char do |ch|
  if skip_next
    skip_next = false
    next
  end
  if ch == '|'
    skip_next = true
    a << "str_or"
  elsif var_chars[ch]
    a << var_chars[ch]
  else
    lengthy_map[ch] += 1
    a << "str_percent"
    ('%02x'%ch.ord).each_char do |d|
      d = d.hex
      a << case d
           when 0
             '0'
           when 1
             'num_1'
           when 2
             'num_2'
           when 3
             'num_3'
           when 4
             'num_2*num_2'
           when 5
             'num_5'
           when 6
             'num_2*num_3'
           when 7
             '(num_5+num_2)'
           when 8
             'num_2*num_2*num_2'
           when 9
             'num_3*num_3'
           when 10..15
             'str_' + d.to_s(16)
           end
    end
  end
end
c += a * '+'
c += '))()'

STDERR.puts lengthy_map

cnts = Hash.new{0}
c.scan(/(num|str|obj)_\w+/) do
  cnts[$&]+=1
end

sym_map={}
n = 0
cnts.sort_by{|_,c|-c}.each do |ident, _|
  n+=1
  sym_map[ident] = n.to_s(5).tr('01234', '0HIOX')
end
STDERR.puts sym_map

File.open('before_symmetric.js','w') do |of|
  of.print(c)
end

used_cnts = {}
sym_map.each do |k, _|
  used_cnts[k] = 0
end
c.gsub!(/(num|str|obj)_\w+/) do
  used_cnts[$&] += 1
  sym_map[$&]
end
STDERR.puts used_cnts.sort_by{|_,v|v}.inspect

c.gsub!(/;/, '')

File.open('only_symmetric.js','w') do |of|
  of.print(c)
end

STDERR.puts "#{c.size}"

R=57
R2=R-D
tmpl=[]
1.upto(R-1) do |i|
  n = Math.sqrt(R*R - (R-i*2)**2).to_i
  j = i-D/2
  n2 = j > 0 && j < R2 ? Math.sqrt(R2*R2 - (R2-j*2)**2).to_i : 0
  s = ' ' * (R-n-1)
  #s += '/' * (n-n2) + ' ' * (n2*2) + '/' * (n-n2)
  l = (n-n2)
  #if i==R/2
  #  l-=1
  #end
  s += '/' * l + ' ' * (n2*2) + ' ' * (n-n2)
  s += ' ' * ((R-1)*2-s.size)
  tmpl << s
end

lines=c.split("\n")
last_line=lines.pop+'+/ *\\\\*'
line=''
buf=''
last_line.each_char do |c|
  buf+=c
  if c=='+'||c=='*'
    if line.size+buf.size+1<=26
      line+=buf
      buf=''
    else
      lines << line.dup
      line=''
    end
  end
end
lines << line + buf

lines.each_with_index do |line, i|
  if !tmpl[i].sub!('/'*line.size){line.chomp}
    raise "#{line} at #{i}"
  end
end

hist=(tmpl*'').gsub(/[ \n\/*]/, '')

srand(27)

H = tmpl.size / 2
W = tmpl[0].size / 2
H.times do |y|
  l = tmpl[y][0,W]
  l=l.gsub(/\/\/+(?= |$)/) do
    n=$&.size
    b=''
    if H-1!=y
      b='//'
    end
    pch=nil
    while b.size<n
      while ch=hist[rand(hist.size)]
        #if ch=~/[\w+({\[]/ || H-1!=y
        #if ch=~/[\w]/ || H-1!=y
          break
        #end
      end
      b+=pch=ch
    end
    b
  end
  tmpl[y] = l+' '*W
  W.times do |x|
    ch = tmpl[y][x]
    xm, ym, rm = CONVS[ch].chars
    #raise "#{y} #{x}" if ch != ' ' && tmpl[y][-x-1] != '/'
    tmpl[y][-x-1] = xm
    tmpl[-y-1][x] = ym
    tmpl[-y-1][-x-1] = rm
  end
end

File.open('very_symmetric.js', 'w') do |of|
  of.puts tmpl
end

def test_smjs(fn)
  `smjs #{fn}` == "Hello, world!\n"
end

def test_node(fn)
  `node #{fn}` == "Hello, world!\n"
end

def is_only_symmetric(fn)
  ok = true
  c = File.read(fn)
  c.each_char do |ch|
    if !CONVS[ch] && ch != "\n"
      STDERR.puts "wrong char: #{ch}"
      ok = false
    end
  end
  ok
end

def is_very_symmetric(fn)
  ok = is_only_symmetric(fn)
  lines = File.read(fn).split("\n")

  h = lines.size
  w = lines[0].size
  lines.each do |line|
    if line.size != w
      ok = false
      STDERR.puts "wrong size"
    end
  end

  lines.each_with_index do |line, y|
    line.size.times do |x|
      ev, eh, er = CONVS[line[x]].chars
      if ev != line[-x-1]
        ok = false
        STDERR.puts "broken vertical line symmetry (#{ev} vs #{line[-x-1]}): #{line}"
      end
      if eh != lines[-y-1][x]
        ok = false
        STDERR.puts "broken horizontal line symmetry (#{eh} vs #{lines[-y-1][x]}): #{line}"
      end
      if er != lines[-y-1][-x-1]
        ok = false
        STDERR.puts "broken rotational symmetry (#{er} vs #{lines[-y-1][-x-1]}): #{line}"
      end
    end
  end

  ok
end

%w(before_symmetric.js only_symmetric.js very_symmetric.js).each do |fn|
  if test_smjs(fn)
    puts "smjs #{fn}: OK"
  else
    puts "smjs #{fn}: FAIL"
  end
  if test_node(fn)
    puts "node #{fn}: OK"
  else
    puts "node #{fn}: FAIL"
  end
end

if is_only_symmetric('only_symmetric.js')
  puts "only symmetric: OK"
else
  puts "only symmetric: FAIL"
end

if is_very_symmetric('very_symmetric.js')
  puts "very symmetric: OK"
else
  puts "very symmetric: FAIL"
end

tbl = '<table border="1">'
tbl += '<tr><th>orig<th>hflip<th>vflip<th>rot180</tr>'
CONVS.sort_by{|o, c|o}.each do |o, c|
  next if o == ' '
  tbl += '<tr>' + [o, *c.chars].map{|c|"<td>#{c}"}*'' + '</tr>'
end
tbl += '</table>'

convs = []
CONVS.sort_by{|o, c|o}.each{|o, c|convs << [o,*c.chars] if o != ' '}
tbl = '<table border="1">'
['Original', 'Flip horizontally', 'Flip vertically', 'Rotate 180 degrees'].each_with_index do |h, i|
  tbl += "<tr><th>#{h}"
  convs.each do |a|
    tbl += "<td>&nbsp;#{escapeHTML(a[i])} &nbsp;"
  end
  tbl += "</tr>"
end
tbl += '</table>'

html=File.read('very_symmetric_tmpl.html')
html.sub!('TBL', tbl)
html.sub!('TMPL'){
  c=File.read('very_symmetric.js')
  escapeHTML(c)
}
File.open('very_symmetric_js.html', 'w') do |of|
  of.print(html)
end
