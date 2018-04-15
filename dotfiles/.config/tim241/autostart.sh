#!/usr/bin/env bash
COMPTON=true
# Set solid background as 'backup'
xsetroot -solid "#303642" 
# Fix for crashing DBUS processes: https://bbs.archlinux.org/viewtopic.php?id=224787
dbus-update-activation-environment DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY 
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
if [ "$COMPTON" != "false" ]; then
	$HOME/.config/tim241/bin/compton 
fi
# Load nvidia-settings config
if command -v nvidia-settings > /dev/null 2>&1; then
	nvidia-settings -l
fi
# Load pulseaudio
if command -v pulseaudio > /dev/null 2>&1; then
	pulseaudio -D
fi
# Load sc-controller 
if command -v sc-controller > /dev/null 2>&1; then
	sc-controller --gapplication-service		
fi
# Load polybar
if command -v polybar > /dev/null 2>&1; then
	polybar i3
fi
# Load mopidy
if command -v mopidy > /dev/null 2>&1; then
	mopidy
fi
