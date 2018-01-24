#!/bin/sh
# Set solid background as 'backup'
xsetroot -solid "#303642" 
# Fix for crashing DBUS processes: https://bbs.archlinux.org/viewtopic.php?id=224787
dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY 
# Load Xdefaults
$HOME/.config/tim241/bin/lxdef 
# Load correct gtk theme
$HOME/.config/tim241/bin/gtk
# Execute xrandr scripts
$HOME/.config/tim241/xrandr/*.sh && sh ~/.config/tim241/bin/wallpaper 
# Start compton
$HOME/.config/tim241/bin/compton 
# Load nvidia-settings config
if which nvidia-settings > /dev/null 2>&1; then
	nvidia-settings -l
fi
# Load sc-controller 
if which sc-controller > /dev/null 2>&1; then
	sc-controller --gapplication-service		
fi
