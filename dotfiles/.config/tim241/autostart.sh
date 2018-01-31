#!/bin/sh
# Set solid background as 'backup'
xsetroot -solid "#303642" 
# Fix for crashing DBUS processes: https://bbs.archlinux.org/viewtopic.php?id=224787
dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY 
if [ -f "$HOME/.config/tim241/themes/$DESKTOP_THEME/source.sh" ]; then
	source $HOME/.config/tim241/themes/$DESKTOP_THEME/source.sh
fi
# Load Xdefaults
$HOME/.config/tim241/bin/lxdef 
# Load correct gtk theme
$HOME/.config/tim241/bin/gtk
# Execute xrandr scripts
$HOME/.config/tim241/xrandr/*.sh && sh ~/.config/tim241/bin/wallpaper 
# Start compton
if [ "x$COMPTON" != "xfalse" ]; then
	$HOME/.config/tim241/bin/compton 
fi
# Load nvidia-settings config
if which nvidia-settings > /dev/null 2>&1; then
	nvidia-settings -l
fi
# Load pulseaudio
if which pulseaudio > /dev/null 2>&1; then
	pulseaudio -D
fi
# Load sc-controller 
if which sc-controller > /dev/null 2>&1; then
	sc-controller --gapplication-service		
fi
