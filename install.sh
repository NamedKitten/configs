#!/bin/sh
CORE_DEPENDENCIES="xorg-server xorg-xinit xorg-xrandr xorg-xsetroot git i3-gaps"
AUDIO="pulseaudio-alsa alsa-utils"
DEPENDENCIES="rxvt-unicode feh rofi arandr"
THEME_DEPENDENCIES="papirus-icon-theme compton qt5ct qt5-styleplugins"
DESKTOP_THEME_TOOLS="lxappearance"
GNOME_DEPENDENCIES="pavucontrol gcolor2"
EXTRAS="firefox mplayer"
# Declare colors
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' 
# Print errors in red
printError () {
	echo -e "\n${RED}===> $@${NC}\n"
}
# Print with colors
print () {
	echo -e "\n${BLUE}===> $@${NC}\n"
}
# Exit On Fail
EOF () {
	$@
	exitcode=$?
	if [ $exitcode != 0 ]; then
		if [ "x$ERRMSG" != "x" ]; then
			printError "$ERRMSG"
		else 
			printError "Command: '$@' failed!"
		fi
		exit $exitcode
	fi
}
# Exit On Root, don't allow this script to be ran as root
EOR () {
	if [ $UID = 0 ]; then
		printError Execute this script as a user!
		exit 1
	fi
}
# Ask for sudo password
ask_sudo () {
	print Please provide your sudo password...
	EOF sudo -v
	print "Thank you for providing your sudo password..let's continue"
}
if [ "x$1" = "x--source" ]; then
	return
fi
bash_it () {
	if [ -d ~/.bash_it ]; then
		rm -rf ~/.bash_it
	fi
	EOF git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
	EOF bash ~/.bash_it/install.sh --silent
	EOF cp dotfiles/.bashrc $HOME/.bashrc
}
EOR
if `which pacman > /dev/null 2>&1`; then
	ask_sudo
	print "Installing prebuilt packages!"
	EOF sudo pacman --needed --noconfirm -U prebuilt/*pkg*
	print "Installing required packages!"
	EOF sudo pacman --needed --noconfirm -S $CORE_DEPENDENCIES $DEPENDENCIES \
				$THEME_DEPENDENCIES $DESKTOP_THEME_TOOLS $GNOME_DEPENDENCIES $EXTRAS $AUDIO
else
	printError "pacman is not installed!"
fi
print "Installing configs"
print "Creating directories.."
EOF mkdir -p $HOME/.config/ $HOME/.themes/ $HOME/Pictures/wallpaper/ $HOME/Templates/
print "Copying configs.."
EOF "cp -R dotfiles/.config/* $HOME/.config/"
print "Copying openbox gtk theme.."
EOF "cp -R dotfiles/.themes/* $HOME/.themes/"
print "Copying wallpaper.."
EOF "cp -R wallpaper/* $HOME/Pictures/wallpaper/"
print "Copying gtkrc.."
EOF "cp dotfiles/.gtkrc-2.0 $HOME/.gtkrc-2.0"
print "Preparing xinitrc"
echo "exec i3" > $HOME/.xinitrc
print "Installing bashrc.."
EOF "cp dotfiles/.bashrc $HOME/.bashrc"
print "Making QT look like GTK+"
echo QT_QPA_PLATFORMTHEME=qt5ct | sudo tee -a /etc/environment > /dev/null
print "Done!"
touch .ic
