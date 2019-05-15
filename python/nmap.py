#!/usr/bin/env python

# ////////////////////////////////////////////////////////////
# This script requires the python-nmap package to be installed.
# This can be installed from the apt or yum repos.
# Author: Zabel, S
# ////////////////////////////////////////////////////////////

import random
import os
import nmap
import datetime


# Message
os.system("clear")
print "This NMAP scan will run with this following options."
print " "
print "-vv -sT -Pn -n -g -d1 -T2 --max-retries 2 --scan-delay 1075ms --randomize-hosts --data-length -p"
print " "
print "----------------------------------------------------------------"
print " "

# Input Variables
ip_rang = raw_input("Enter IP, Range, or CIDR to scan.\n")
# ports = []
ports = raw_input("\nEnter ports to scan seperated by commas. Recommend not scanning more than 2 ports at a time.\n")
# output_dir = raw_input("\nEnter path to output results. Default is current directory.\n")
data_len = raw_input("\nEnter number of extra bytes to add to the packets. This helps avoid IDS detection. Recommend using 15.\n")


# Script Variables
src_range = [31420, 58372]
nm = nmap.PortScanner()


# Definitions
def nmap_run():
    nm.scan(hosts=ip_rang, arguments='-vv -n -sT -Pn -n -T2 --max-retries 2 --scan-delay 1075ms --randomize-hosts --data-length ' + data_len + ' -p ' + ports)
    nmap_reports()


def nmap_reports():
    now = datetime.datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    # f = open(working_dir + '/' + str(now) + '.csv')
    f = open(str(now) + '.csv', 'w')
    os.system("clear")
    print 'Running Nmap against ' + ip_rang
    print 'Scanning port(s)' + ports + ' with ' + data_len + ' bytes added to each packet.'
    print "The results will be saved to current directory in CSV format."
    print '-----------------------------------'
    f.write(nm.csv())
    f.close()


# Print Results in List Format
    for host in nm.all_hosts():
        print ' '
        print('Host : %s (%s)' % (host, nm[host].hostname()))
        print('State : %s' % nm[host].state())
        for proto in nm[host].all_protocols():
            print('----------')
            print('Protocol : %s' % proto)
            lport = nm[host][proto].keys()
            lport.sort()
            for port in lport:
                print ('port : %s\tstate : %s' % (port, nm[host][proto][port]['state']))


# Start Script
nmap_run()
