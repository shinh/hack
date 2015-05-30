#!/usr/bin/python

import sys

PYTHON_VER = sys.argv[1] if len(sys.argv) > 1 and sys.argv[1] else '2'
CHR='chr' if PYTHON_VER == '3' else 'unichr'
DIV='//' if PYTHON_VER == '3' else '/'

def d(r,n):
 for i in range(n):
  r="next(reversed(range(%s)))"%r
 return r

def e(v):
 a=[]
 v-=1
 while v:
  a.append(v%3)
  v/=3
 r=d("len(repr(repr(str())))",3-a[-1])
 for i in list(reversed(a))[1:]:
  r=d("len(repr(list(bytearray(%s))))"%r,2-i)
 return r

#print e(400)
#print eval(e(299))

#sys.exit(0)

# len(repr(list(bytearray(i))))

q='''q="q="+repr(q)+";exec(q)"
def d(r,n):
 for i in range(n):
  r="next(reversed(range(%s)))"%r
 return r

def e(v):
 if v<2:
  return"len(str(len(str())))"if v else"len(str())"
 a=[]
 v-=1
 while v:
  a+=[v%3]
  v'''+DIV+'''=3
 r=d("len(repr(repr(str())))",3-a[-1])
 for i in list(reversed(a))[1:]:
  v*=3
  v-=2-i
  r=d("len(repr(list(bytearray(%s))))"%r,2-i)
 return r
o=""
i=0
for c in q:
 o+="("+e(ord(c))+")if("+"'''+CHR+'''("+e(i)+")in('''+CHR+'''(i))"+")else"
 i+=1
'''
if PYTHON_VER == '3':
    q+='''print("exec(eval(str(bytearray("+o+"()for(i)in(range("+e(len(q))+"))))))")'''
else:
    q+='''print("exec(str(bytearray("+o+"()for(i)in(range("+e(len(q))+")))))")'''
exec(q)

sys.stderr.write("%s\n" % len(q))

#print len(q)
#len(repr(repr(repr(repr(repr(repr(repr(repr(repr(repr(repr(repr(repr(repr(repr(repr(repr(repr(repr(repr(repr(str()))))))))))))))))))))))

# 130:
# len(repr(repr(repr(repr(repr(repr(repr(repr(list())))))))))


#q = '(print(bytearray()))'
#
#for x in slice(bytearray([40,33]):
#    exec('print(x)')


