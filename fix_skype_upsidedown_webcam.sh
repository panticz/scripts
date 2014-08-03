#!/bin/bash

# install video4linux libraries 
sudo apt-get install libv4l-0:i386

# fix lib path
if [ ! -f /usr/lib/libv4l/v4l1compat.so ]; then
  sudo mkdir /usr/lib/libv4l
    if [ "$(uname -m)" == "x86_64" ]; then
      # 64 bit
      sudo ln -s /usr/lib/x86_64-linux-gnu/libv4l/v4l1compat.so /usr/lib/libv4l/v4l1compat.so
    else
      # 32 bit
      sudo ln -s /usr/lib/i386-linux-gnu/libv4l/v4l1compat.so /usr/lib/libv4l/v4l1compat.so
  fi
fi

# modify Skype launcher
sudo sed -i 's|env PULSE_LATENCY_MSEC=60 skype %U|env PULSE_LATENCY_MSEC=60 LD_PRELOAD=/usr/lib/i386-linux-gnu/libv4l/v4l1compat.so skype %U|g' /usr/share/applications/skype.desktop
