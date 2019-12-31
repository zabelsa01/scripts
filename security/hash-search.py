#!/usr/bin/python
 
# This script will check a hash against hashes.org using an API key
 
import requests
import os
import subprocess
import time
 
api = '4KmEeB7GVC3pjB8doRKPi2FKCwGrur'
url = 'https://hashes.org/api.php'
 
 
def choice():
    os.system('clear')
    print('1: Hash List')
    print('2: Single Hash')
    print('=============== \n')
    choice = raw_input('Enter 1 or 2 \n')
    if (choice == '1'):
        os.system('clear')
        path = raw_input('Enter Path to Hash File \n')
        hashes = subprocess.check_output(["grep", "-oP", "[a-z0-9]{18,}", path])
        hashlist = hashes.splitlines()
        for i in hashlist:
            param = dict(key=api, query=i)
            execute(param)
            time.sleep(4)
    elif (choice == '2'):
        os.system('clear')
        hash = raw_input('Enter Hash: \n')
        param = dict(key=api, query=hash)
        execute(param)
    else:
        os.system('clear')
        print('You dumb')
 
def execute(x):
    res = requests.get(url, params=x)
    json = res.json()
    if res.status_code != 200:
        print('Error: ' + res.status_code)
    else:
        print(res.text)
 
choice()
