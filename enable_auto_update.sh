#!/bin/bash

sed -i '4s|//| |g' /etc/apt/apt.conf.d/50unattended-upgrades
sed -i 's|//Unattended-Upgrade::Mail|Unattended-Upgrade::Mail|g' /etc/apt/apt.conf.d/50unattended-upgrades
sed -i 's|APT::Periodic::Download-Upgradeable-Packages "0";|APT::Periodic::Download-Upgradeable-Packages "1";|g' /etc/apt/apt.conf.d/10periodic
sed -i 's|APT::Periodic::AutocleanInterval "0";|APT::Periodic::AutocleanInterval "1";|g' /etc/apt/apt.conf.d/10periodic
echo 'APT::Periodic::Unattended-Upgrade "1";' >> /etc/apt/apt.conf.d/10periodic
