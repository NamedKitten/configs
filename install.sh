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
# Exit On Fail
EOF () {
	$@
	exitcode=$?
	if [ $exitcode != 0 ]; then
		echo "Command: '$@' failed!"
		exit $exitcode
	fi
}
if [ "x$1" = "x--source" ]; then
	return
fi
if `which pacman > /dev/null 2>&1`; then
	echo Installing prebuilt packages!
	EOF sudo pacman --needed --noconfirm -U prebuilt/*pkg*
	echo Installing required packages!
	EOF sudo pacman --needed --noconfirm -S $CORE_DEPENDENCIES $DEPENDENCIES \
				$THEME_DEPENDENCIES $DESKTOP_THEME_TOOLS $GNOME_DEPENDENCIES $EXTRAS
else
	echo pacman is not installed!
fi
echo Installing configs
mkdir -p ~/.config/
mkdir -p ~/.themes/
mkdir -p ~/Pictures/wallpaper/
mkdir -p ~/Templates/
echo Copying configs
cp -R dotfiles/.config/* ~/.config/
echo Copying openbox gtk theme..
cp -R dotfiles/.themes/* ~/.themes/
echo Copying wallpaper..
cp -R wallpaper/* ~/Pictures/wallpaper/
echo Copying templates..
cp -R dotfiles/Templates/* ~/Templates/
cp dotfiles/.gtkrc-2.0 ~/.gtkrc-2.0 
cp dotfiles/.Xdefaults ~/.Xdefaults
echo Preparing xinitrc
echo "exec openbox-session" > ~/.xinitrc
echo Done!
touch install_completed
