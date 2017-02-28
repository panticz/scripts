#!/bin/bash

# create new restricted user
useradd tunnel --gid nogroup --create-home --skel /dev/null --shell /bin/rbash

# set random encrypted password to enable login
echo "tunnel:$(openssl rand -base64 32)" | chpasswd

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
chown tunnel:nogroup /home/tunnel -R
