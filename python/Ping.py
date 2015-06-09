import os
f = range(1, 5)
ping_status = {}
my_range = '192.168.0.'
for i in f:
    i = str(i)
    response = os.system('ping -i 1 -c 1 192.168.0.' + i)
    if response == 0:
        ping_status.setdefault('Active', [])
        ping_status['Active'].append(my_range + i)
    else:
        ping_status.setdefault('Offline', [])
        ping_status['Offline'].append(my_range + i)
print ping_status.items()
for k, v in ping_status.items():
    if 'Offline' in k:
        print v
