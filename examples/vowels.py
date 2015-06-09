my_input = raw_input("Enter a string: ")
def anti_vowel(x):
    vow = ['a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U']
    word = []
    for i in x:
        word += i
    for i in vow:
        while i in word:
             word.remove(i)
    print "".join(word)

anti_vowel(my_input)
