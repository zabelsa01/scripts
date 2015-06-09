my_input = int(raw_input('Enter a number: '))
def is_prime(x):
    if x <= 1:
        print x, "is NOT Prime"
        return False
    my_list = range(2, x)
    my_dict = {}
    for i in my_list:
        my_dict[i] = (x % i)
    for i in my_dict:
        if my_dict[i] == 0:
            print x, "is NOT Prime"
            return False
    else:
        print x, "is Prime"
        return True


is_prime(my_input)
