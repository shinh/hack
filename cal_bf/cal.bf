# these fields will be used for data lookup
>>>>>>>>>>>>>>>>>>>>
# load year
>
,--------------------------------[---------------->,--------------------------------]
# 0 y y y y
<+
<[->++++++++++<]
<<[->++++++++++<]
<<<
# 0 0 y1 0 y2
# load month
,
------------------------------------------------
<,
+[-----------[-----------------------------[->+<]]]
>
[-<+<+>>>>+<<]
<<
# m 0 y1 0 y2

# data lookup (wday adjustment)
<<------<----<-<------<---<-------<-----<--<-------<----<----<-
[>]
>-[-<<[<]>[+]>[>]>]
-
<<<[>[+]<<]>
>+[-<[+>-<]>>+]

>[-<<<<+>>>>]
<<<<

# data lookup (num days per month minus 32)
<<-<--<-<--<-<-<--<-<--<-<----<-
[>]
>-[-<<[<]>[+]>[>]>]
-
<<[>[+]<<]>
>+[-<[+>-<]>>+]

# calculate correct num days (plus 32)
<++++++++++++++++++++++++++++++++

>>>
>>      
>>>

# m *0 y1 0 y2
>>[-<+>>>>>>>+<<<<<<]
>>>>>>
[>[-]>[-]>[-]>[-]<<<<<<++++<+>[->>[>]+[<]>-<<]>>]>[>]<<[>-<[<]>+[>]<<]
>[-<<<+>>>]
<<<----[++++<->>]<[<]
# m y1 0 0 y2 y1/4 y1%4
>-[-<+>>>>>>>+<<<<<<]
>>>>>>
++++
[>[-]>[-]>[-]>[-]<<<<<<++++<+>[->>[>]+[<]>-<<]>>]>[>]<<[>-<[<]>+[>]<<]
>[-<<<+>>>]
<<<----[++++<->>]
<<<<<<<<<[<]>
>>>>>>>-
# m y1 0 y2 0 y1/4 y1%4 *y2/4 y2%4
[-<<+>>]<<
<<[-<+<<<+>>>>]>>
[-<<<+>>>]<<<[->+<]
<
[->+>+++++<<]
>>

# m 0 y1 *wday 0 0 y1%4 0 y2%4

# leap (check y%100)
<<<<
<+>
[<->>>>>>+>>>>[<<<<->>>>[-]]<<<<<<<<<[-]]
<[->>>>>>+>>[<<->>[-]]<<<<<<<<]>
>>>>

# m 0 y1 *wday leap 0 y1%4 0 y2%4

# leap test
>[-
<<<<
# month minus 12
------------[+[+[+[+[+[+[+[+[+[
# only Jan or Feb can be here, let's adjust wday
>>>-<<<
# only Feb can be inside the loop, 28 to 29
++[<<<<<<<<+>>>>>>>>-]
[+]
]]]]]]]]]]
>>>>]
<

# moving wday data (ugly)
-
<<<<<<<<[+>>>>>>>>+<<<<<<<<]>>>>>>>>
[->>>>>>>>>+<<<<<<<<<]
>>>>>>>>>

# divide wday by 7
[>[-]>[-]>[-]>[-]>[-]>[-]>[-]<<<<<<<<<+++++++<+>[->>[>]+[<]>-<<]>>]>[>]<<[>-<[<]>+[>]<<]
>[-<<<+>>>]
<<<
<+>
# 0 0 y1 0 0 0 y1%4 0 y2%4 ?? *wday
-------
[+++++++>>+<]

>[<]>[-]<
<

[->+>+<<]>>

>++++++++++++++++++++++++++++++++<
[->...<]
>[-]
<+<-------
<[-]>  # unecessary

# 0 0 y1 0 0 0 y1%4 0 y2%4 ?? 0 *(wday minus 7) 0 1

>

# loop for printing numbers
<<<<<<<<<<<<<<<<<<<<
[
>>>>>>>>>>>>>>>>>>>>

# checks if day number is bigger than 9
[->+>+>+<<<]>>>
-[-[-[-[-[-[-[-[-[
[-]
<

[->>>+<<<]
>>>
[
>>>>>>>>>>>>>>>>>>>>
+
<<<<<<<<<<<<<<<<<<<<
# divide by 10 (ugly)
>[-]>[-]>[-]>[-]>[-]>[-]>[-]>[-]>[-]>[-]<<<<<<<<<<<<++++++++++<+>[->>[>]+[<]>-<<]>>]>[>]<<[>-<[<]>+[>]<<]

>

----------[++++++++++<
>>>>>>>>>>>>>>>>>>>>
-
<<<<<<<<<<<<<<<<<<<<
]
<<<[>]>>
>>>>>>>>>>>>>>>>>>>>
++++++++++++++++++++++++++++++++++++++++++++++++.[-]
<<<<<<<<<<<<<<<<<<<<
>++++++++++++++++++++++++++++++++++++++++++++++++.

[-]<[-]
<<<[-]
]]]]]]]]]

# else (day number is smaller than 10)
<[<]>>
[>++++++++++++++++++++++++++++++++.[-]
<
# 1 0 y1 0 0 0 y1%4 0 y2%4 ?? 0 (wday minus 7) 0 1 *1
++++++++++++++++++++++++++++++++++++++++++++++++.[-]
]

<<<
# 1 0 y1 0 0 0 y1%4 0 y2%4 ?? 0 *(wday minus 7) 0 1

# if wday % 7 then print space else print new line
+[>>>++++++++++++++++++++++<<<<]
>>[<<------->]
>>++++++++++.[-]
<[-<+>]<
+

[->+>+<<]
>[-<+>]
>
[-]

<<

<<<<<<<<<<<<<<<<<<<<
-

]
