three_and_fives = [x for x in range(1, 16) if (x % 3 == 0 or x % 5 == 0)]
print three_and_fives

my_list = [1, 2, 3, 4, 5, 6, 7, 8, 9]
print my_list[2:8:2]

garbled1 = "!XeXgXaXsXsXeXmX XtXeXrXcXeXsX XeXhXtX XmXaX XI"
message = garbled1[::-2]
print message

garbled2 = "IXXX aXXmX aXXXnXoXXXXXtXhXeXXXXrX sXXXXeXcXXXrXeXt mXXeXsXXXsXaXXXXXXgXeX!XX"
message = filter(lambda x: x != "X", garbled2)
print message

# Bitwise
h = 12345
b = 12345
o = 12345
print hex(h)
print bin(b)
print oct(o)
