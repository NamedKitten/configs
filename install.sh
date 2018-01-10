#!/bin/sh
CORE_DEPENDENCIES="xorg-server xorg-xinit xorg-xrandr tint2 git pulseaudio"
DEPENDENCIES="xterm rxvt-unicode feh rofi
		xfce4-screenshooter arandr"
THEME_DEPENDENCIES="arc-gtk-theme papirus-icon-theme compton qt5ct qt5-styleplugins"
DESKTOP_THEME_TOOLS="lxappearance lxmenu-data"
GNOME_DEPENDENCIES="gnome-calculator pavucontrol gnome-mplayer gedit
	gucharmap file-roller gimp gcolor2
	nautilus filemanager-actions"
EXTRAS="firefox chromium mplayer libreoffice-fresh pidgin pidgin-otr qt4 vlc redshift gksu gparted"
# Declare colors
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' 
# Print errors in red
printError () {
	echo -e "${RED}===> $@${NC}\n"
}
# Print with colors
print () {
	echo -e "${BLUE}===> $@${NC}\n"
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
EOR
if `which pacman > /dev/null 2>&1`; then
	ask_sudo
	print "Installing prebuilt packages!"
	EOF sudo pacman --needed --noconfirm -U prebuilt/*pkg*
	print "Installing required packages!"
	EOF sudo pacman --needed --noconfirm -S $CORE_DEPENDENCIES $DEPENDENCIES \
				$THEME_DEPENDENCIES $DESKTOP_THEME_TOOLS $GNOME_DEPENDENCIES $EXTRAS
else
	printError "pacman is not installed!"
fi
print "Installing configs"
mkdir -p ~/.config/
mkdir -p ~/.themes/
mkdir -p ~/Pictures/wallpaper/
mkdir -p ~/Templates/
print "Copying configs"
cp -R dotfiles/.config/* ~/.config/
print "Copying openbox gtk theme.."
cp -R dotfiles/.themes/* ~/.themes/
print "Copying wallpaper.."
cp -R wallpaper/* ~/Pictures/wallpaper/
print "Copying templates.."
cp -R dotfiles/Templates/* ~/Templates/
cp dotfiles/.gtkrc-2.0 ~/.gtkrc-2.0 
cp dotfiles/.Xdefaults ~/.Xdefaults
print "Preparing xinitrc"
echo "exec openbox-session" > ~/.xinitrc
print "Done!"
touch .ic
