#!/usr/bin/python

import requests

api = '4KmEeB7GVC3pjB8doRKPi2FKCwGrur'
hash = raw_input('Enter Hash: \n')
url = 'https://hashes.org/api.php'
parm = dict(key=api, query=hash)

res = requests.get(url, params=parm)
json = res.json()

if res.status_code != 200:
	print('Error: ' + res.status_code)
else:
	print(res.text)
