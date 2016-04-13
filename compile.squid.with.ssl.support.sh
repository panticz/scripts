#!/bin/bash

# add Debian Wheezy backports repository
cat <<EOF> /etc/apt/sources.list.d/wheezy-backports.list
deb http://ftp.de.debian.org/debian wheezy-backports main
deb-src http://ftp.de.debian.org/debian wheezy-backports main
EOF
 
# update repository list
apt-get update
 
# install required dev packages
apt-get install -y wget openssl devscripts build-essential libssl-dev
 
# install debian squid3 source code
apt-get source -y squid3
 
# install all required dependeny packages
apt-get build-dep -y squid3
 
# enable SSL support
wget -q http://dl.panticz.de/squid/squid3-3.4.8_enable_ssl.diff -O - | patch -p2 squid3-3.4.8/debian/rules
 
# build packages
cd squid3-3.4.8
debuild -us -uc
