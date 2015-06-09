my_input = str(raw_input("Enter a string: "))

def reverse(x):
    size = len(x) - 1
    new = []
    while size >= 0:
        new += x[size]
        size -= 1
    print "".join(new)

reverse(my_input)
