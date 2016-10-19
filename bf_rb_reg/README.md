# Brainfuck in Ruby's Regexp

Keywords: Ruby Brainfuck

[bf.rb](bf.rb)

This code runs some Brainfuck code in a single Ruby's Regexp. As far
as I know, Ruby's Regexp doesn't allow infinite loop and thus it's not
Turing-complete. However, it still can run some non-trivial Brainfuck
code like [cal.bf](../cal_bf/cal.bf):

    $ echo 2016 10 | ruby bf_rb_reg/bf.rb cal_bf/cal.bf
                       1
     2  3  4  5  6  7  8
     9 10 11 12 13 14 15
    16 17 18 19 20 21 22
    23 24 25 26 27 28 29
    30 31

The (fairly big) Regexp is defined as `BF_REG`. There's also a String
constant `BF_SUFFIX` which provides the list of characters. You can run
Brainfuck code `bf` by

    BF_REG =~ bf + BF_SUFFIX

The output is stored in `$~['o0']`, `$~['o1']`, ... You can get it by

    output = ''
    256.times do |i|
      o = $~["o#{i}"]
      break if !o
      output += o
    end

Here's the list of specifications of the implementation:

* 8bit cells
* EOF is -1
* There's only 256 cells
* Can output at most 256 bytes
* Can input at most 256 bytes
* The Regexp doesn't match if there's a non-Brainfuck character
* The Regexp doesn't match if there's an infinite loop (a loop stops
  after 256 iterations. This means a Brainfuck code which actually
  halts may fail)

Acknowledgement: The original code was 2400x slower for cal.bf, but
[https://twitter.com/saito_ta](@saito_ta) and
[https://twitter.com/yvl_](@yvl_) made significant performance
improvements.



