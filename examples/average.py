grades = [100, 100, 90, 40, 80, 100, 85, 70, 90, 65, 90, 85, 50.5]
def grades_sum(grades):
    total = 0
    for i in range(len(grades)):
        total = total + grades[i]
    print total
    return total
#grades_sum(grades)

def grades_average(grades):
    total = grades_sum(grades)
    size = len(grades)
    result = float(total) / size
    print result
    return result
    
grades_average(grades)
