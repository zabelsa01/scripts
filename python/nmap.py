#!/usr/bin/env python

# ////////////////////////////////////////////////////////////
# This script requires the python-nmap package to be installed.
# This can be installed from the apt or yum repos.
# Author: Zabel, S
# ////////////////////////////////////////////////////////////

logo = """

     __                                    
  /\ \ \_ __ ___   __ _ _ __  _ __  _   _  
 /  \/ / '_ ` _ \ / _` | '_ \| '_ \| | | | 
/ /\  /| | | | | | (_| | |_) | |_) | |_| | 
\_\ \/ |_| |_| |_|\__,_| .__/| .__/ \__, | 
                       |_|   |_|    |___/  

"""

import os
import nmap
import datetime

# Message
os.system("clear")
print logo
print "This NMAP scan will run with this following options."
print " "
print "-vv -sT -Pn -n -g -d1 -T2 --max-retries 2 --scan-delay 1075ms --randomize-hosts --data-length -p"
print " "
print "----------------------------------------------------------------"
print " "

# User Input Variables
ip_rang = raw_input("Enter IP, Range, or CIDR to scan.\n")
ports = raw_input("\nEnter ports to scan seperated by commas. Recommend not scanning more than 2 ports at a time.\n")

# Script Variables
nmap_options = '-vv -sT -Pn -n -T2 --max-retries 2 --scan-delay 1075ms --randomize-hosts --data-length 15'
nm = nmap.PortScanner()

# Definitions


def nmap_run():
    os.system("clear")
    print logo
    print 'Running Nmap against ' + ip_rang
    print 'Scanning port(s) ' + ports
    print "The results will be saved to current directory in CSV format."
    print '-----------------------------------'

    nm.scan(hosts=ip_rang, arguments= nmap_options + ' -p ' + ports)
    nmap_reports()


def nmap_reports():
    now = datetime.datetime.now().strftime("%Y-%m-%d")
    # f = open(working_dir + '/' + str(now) + '.csv')
    os.system("clear")
    if os.path.isfile(str(now) + '.csv'):
        with open(str(now) + '.csv', 'a') as f:
            skip = nm.csv()
            skip = skip.splitlines()[1:]
            skip = '\n'.join(skip)
            f.write(skip + '\n')
    else:
        f = open(str(now) + '.csv', 'a')
        f.write(nm.csv())
    f.close()


# Print Results in List Format
    for host in nm.all_hosts():
        print ' '
        print logo
        print('Host : %s (%s)' % (host, nm[host].hostname()))
        print('State : %s' % nm[host].state())
        for proto in nm[host].all_protocols():
            print('----------')
            print('Protocol : %s' % proto)
            lport = nm[host][proto].keys()
            lport.sort()
            for port in lport:
                if nm[host][proto][port]['state'] == 'open':
                    print ('port : %s\tstate : %s' % (port, nm[host][proto][port]['state']))



# Start Script
nmap_run()
