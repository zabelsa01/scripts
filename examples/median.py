def median(x):
    x.sort()
    print x
    size = len(x)
    middle = size / 2
    middle = x[middle]
    if size % 2 == 0:
        print float(x[((size / 2) - 1)] + middle) / 2
    else:
        print middle
median([1, 5, 4, 8, 7, 9])
