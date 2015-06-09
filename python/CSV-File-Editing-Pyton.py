# Imports Modules
import csv
import os

# Sets Global Variables
global my_dict
my_dict = {}
global filtered_dict
filtered_dict = {}
dir_path = '/big/scott/temp/'

# Gets a list of all CSV files in a directory
csvs = []
for root, dirs, files in os.walk(dir_path):
    for file in files:
        if file.endswith('.csv'):
            csvs.append(root+file)

# Iterates through the list of CSV files and generates a dictionary
my_list = ['windows', 'linux']
for i in csvs:
    with open(i) as my_csv:
        f = csv.reader(my_csv)
        next(f)
        for row in f:
            for item in my_list:
                if item.upper() in row[1].upper():
                    my_dict[row[1]] = row[2]

# Prints Results
# print filtered_dict.items()
with open(dir_path+'results.txt', 'w') as results:
    for f in filtered_dict.keys():
        results.write(f + '\n')
