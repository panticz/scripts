#!/bin/bash

if [ $(grep sda1 /etc/mtab | wc -l) -eq 1 ]; then
  DEV=sda2
else
  DEV=sda1
fi

sudo mount /dev/${DEV} /mnt
sudo cp /mnt/etc/NetworkManager/system-connections/* /etc/NetworkManager/system-connections/
sudo umount /mnt
