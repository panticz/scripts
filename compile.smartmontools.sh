#!/bin/bash

sudo apt-get update
sudo apt-get -y install build-essential

# download
wget http://heanet.dl.sourceforge.net/project/smartmontools/smartmontools/6.2/smartmontools-6.2.tar.gz -P /tmp/

# extract
tar xzf /tmp/smartmontools-*.tar.gz -C /tmp/
cd /tmp/smartmontools-*

# compile
./configure
make

# install
sudo make install
