def censor(x, y):
    new_list = []
    my_list = x.split()
    for i in my_list:
        if y != i:
            new_list += i + " "
        else:
            star = "*" * len(i)
            new_list += star + " "
    filtered = "".join(new_list)
    print filtered

censor("This is some bull shit", "shit")

"""or you can use this
def censor(text, word):
    print text.replace(word, "*" * len(word))

censor("this hack is wack hack", "hack")
"""
