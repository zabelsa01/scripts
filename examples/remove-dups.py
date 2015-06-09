def remove_duplicates(x):
    my_dict = {}
    dups_removed = []
    for i in range(len(x)):
        my_dict[x[i]] = i
    print my_dict
    for i in my_dict:
        dups_removed += [i]
    print dups_removed
remove_duplicates([1, 2, 2, 3, 3, 4, 4, 5, 5, 6])
