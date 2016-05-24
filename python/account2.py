#!/bin/python

import crypt
import getpass
import os
import re
import shutil
import subprocess
import pwd

# Variables
filepath = '/etc/ansible/roles/create-new-user/tasks/add-user.yml'
usernamepath = '/etc/ansible/roles/create-new-user/vars/main.yml'

# Create User Account
def create_account():
	#Check if running as root
	if os.geteuid() != 0:
		os.system('clear')
		print "This must be executed as root. Use sudo!"
		exit() 

	# User input for username
	person = raw_input('Enter Username: ')

	# Create Salted Passowrd
	os.system('clear')
	print "Creating password for "+ person
	print "====================="
	apswd = getpass.getpass('Enter your password: ')
	bpswd = getpass.getpass('Confirm password: ')

	while apswd!=bpswd:
		os.system('clear')
		print 'Passwords do not match'
		apswd = getpass.getpass('Enter your password: ')
		bpswd = getpass.getpass('Confirm password: ')

	else:
		os.system('clear')
		print '++====PASSWORD SALTED HASH====++'
		salthash = crypt.crypt(apswd, "$1$SomeSalt$")
		print salthash

	# Create User if does not exist and set the password
	def finduser(name):
		try:
			return pwd.getpwnam(name)
		except KeyError:
			return None

	if not finduser(person):
		subprocess.call(('useradd', person))
		print "User " + person + " added to the local system"
	subprocess.call(('usermod', '-p', salthash, person))
	print "Password set for " + person

	#Create local SSH Key
	os.system('clear')
	print "Creating SSH Key for " + person
	print "=================="
	subprocess.call(['su', person, '-c', 'ssh-keygen -f "$HOME/.ssh/id_rsa" -t rsa -b 4096 -N "" -q'])
	shutil.move('/home/' + person + '/.ssh/id_rsa.pub', '/etc/ansible/roles/create-new-user/files/' + person + '-id_rsa.pub')

# Ansible Additions
def ansible_stuff():
	#Copy username to ansible vars directory
	usernamepath2 = usernamepath + "2"
	f = open(usernamepath, 'r')
	data = f.read()
	f.close()
	change = re.sub('username.*', 'username: ' + person, data)
	f = open(usernamepath2, 'w')
	f.write(change)
	f.close()
	shutil.move(usernamepath2, usernamepath)
	print "Copied " + person + " variable to " + filepath

	# Copy Salted Hash to add-user.yml
	filepath2 = filepath + "2"
	f = open(filepath, 'r')
	data = f.read()
	f.close()
	change = re.sub('password.*', 'password: ' + salthash, data)
	f = open(filepath2, 'w')
	f.write(change)
	f.close()
	shutil.move(filepath2, filepath)
	print "Salt hash copied to " + filepath

create_account()
ansible_stuff()
