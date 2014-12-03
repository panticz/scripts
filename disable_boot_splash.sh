#!/bin/bash

sed -i 's|quiet splash|text|' /etc/default/grub
update-grub
