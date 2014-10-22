#!/bin/bash

# configure clock
gsettings set com.canonical.indicator.datetime show-date true
gsettings set com.canonical.indicator.datetime show-day true

# configure workspaces
gsettings set org.gnome.desktop.wm.preferences num-workspaces 2

# configure nautilus
gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'
gsettings set org.gnome.nautilus.list-view default-zoom-level 'smallest'
