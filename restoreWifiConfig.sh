#!/bin/bash

if [ $(grep sda1 /etc/mtab | wc -l) -eq 1 ]; then
  DEV=sda2
else
  DEV=sda1
fi

sudo mount /dev/${DEV} /mnt
for i in $(sudo grep -l wireless /mnt/etc/NetworkManager/system-connections/*); do
  sudo cp $i /etc/NetworkManager/system-connections/
done
sudo umount /mnt
