#!/bin/sh
echo "This will require multilib and the french arch repo added to your pacman.conf!"
sudo pacman -S gparted xscreensaver pidgin steam chromium tint2 geany xorg-server xorg-xinit thunar xorg-xrandr xterm openbox lxterminal yaourt lxde lxappearance arandr nitrogen gksu vlc tint2 mate-system-monitor redshift hexchat pidgin-otr firefox aspell-en
yaourt -S gmrun adapta-gtk-theme gnome-alsamixer openbox-menu volumeicon galculator rofi compton plank
git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
sh ~/.bash_it/install.sh
