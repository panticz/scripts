#!/bin/bash

# crate new user
useradd tunnel -m -s /bin/rbash -p $(openssl rand -base64 32)

# remove all user files
find /home/tunnel -name ".*" -delete

# create authorized_keys
mkdir /home/tunnel/.ssh
chmod 700 /home/tunnel/.ssh
touch /home/tunnel/.ssh/authorized_keys
chmod 600 /home/tunnel/.ssh/authorized_keys

# remove path to programs
echo 'PATH=' > /home/tunnel/.profile
chmod 400 /home/tunnel/.profile

# restrict permissions
chmod 500 /home/tunnel
chown tunnel:tunnel /home/tunnel -R
