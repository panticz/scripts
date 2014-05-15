#!/bin/bash

# ensure that this script is run by root
if [ $(id -u) -ne 0 ]; then
  sudo $0
  exit
fi

# disable biosdevname in GRUB config
sed -i 's|GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"|GRUB_CMDLINE_LINUX_DEFAULT="biosdevname=0 quiet splash"|g' /etc/default/grub
update-grub

# rename first existing interface
IF_NAME=$(cat /etc/network/interfaces | grep iface | head -2 | tail -1 | cut -d" " -f2)
sed -i "s|${IF_NAME}|eth0|g" /etc/network/interfaces
