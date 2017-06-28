#!/bin/bash

# set font size
gsettings set org.gnome.desktop.interface font-name 'Ubuntu 10'

# configure panel clock
gsettings set com.canonical.indicator.datetime show-date true
gsettings set com.canonical.indicator.datetime show-day true
gsettings set com.canonical.indicator.datetime show-week-numbers true

# configure panel sound
gsettings set com.canonical.indicator.sound visible true
gsettings set org.gnome.desktop.sound event-sounds false

# remove keyboard switch indicator from panel
gsettings set com.canonical.indicator.keyboard visible false

# configure workspaces
gsettings set org.gnome.desktop.wm.preferences num-workspaces 2

# configure session
gsettings set org.gnome.desktop.session idle-delay 600

# configure touchpad
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false

# configure nautilus
gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'
gsettings set org.gnome.nautilus.list-view default-zoom-level 'smallest'

# configure caja
gsettings set org.mate.caja.preferences default-folder-viewer 'list-view'
gsettings set org.mate.caja.list-view default-zoom-level 'smallest'

# configure gedit
gsettings set org.gnome.gedit.preferences.editor display-line-numbers true
gsettings set org.gnome.gedit.preferences.editor tabs-size 4
gsettings set org.gnome.gedit.preferences.editor insert-spaces true
gsettings set org.gnome.gedit.preferences.editor bracket-matching true
gsettings set org.gnome.gedit.preferences.editor create-backup-copy false

# configure pluma
gsettings set org.mate.pluma editor-font "Ubuntu Mono 13"
gsettings set org.mate.pluma color-scheme 'classic'
gsettings set org.mate.pluma use-default-font false
gsettings set org.mate.pluma display-line-numbers true
gsettings set org.mate.pluma bracket-matching true
gsettings set org.mate.pluma insert-spaces true
gsettings set org.mate.pluma active-plugins "['docinfo', 'snippets', 'sort', 'filebrowser', 'changecase', 'quickopen', 'spell', 'time', 'modelines']"

# autostart
[ ! -d ~/.config/autostart ] && mkdir ~/.config/autostart && chmod 700 ~/.config/autostart
ln -s /usr/share/applications/chromium-browser.desktop ~/.config/autostart/
ln -s /usr/share/applications/thunderbird.desktop ~/.config/autostart/
ln -s /usr/share/applications/hamster-indicator.desktop  ~/.config/autostart/

# dont forward locale to server
sudo sed -i 's|    SendEnv LANG LC_*|#   SendEnv LANG LC_*|g' /etc/ssh/ssh_config

# set pluma as default text editor
sudo sed -i 's|text/plain=gedit.desktop|text/plain=pluma.desktop|g' /etc/gnome/defaults.list

# set caja as default file browser (for user)
xdg-mime default caja.desktop inode/directory application/x-gnome-saved-search
