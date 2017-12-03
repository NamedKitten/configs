#!/bin/sh
CORE_DEPENDENCIES="xorg-server xorg-xinit xorg-xrandr tint2 git pulseaudio"
DEPENDENCIES="xterm rxvt-unicode feh rofi nautilus
		obconf lxappearance
		xfce4-screenshooter arandr"
THEME_DEPENDENCIES="arc-gtk-theme papirus-icon-theme compton"
DESKTOP_THEME_TOOLS="obconf lxappearance"
GNOME_DEPENDENCIES="gnome-calculator pavucontrol gnome-mplayer gedit
	gucharmap file-roller gimp gcolor2"
EXTRAS="firefox chromium mplayer libreoffice-fresh pidgin vlc redshift gksu gparted"
if [ "x$1" != "x--source" ]; then
	if `which pacman > /dev/null 2>&1`; then
		echo Installing prebuilt packages!
		sudo pacman --needed --noconfirm -U prebuilt/*pkg.tar*
		echo Installing required packages!
		sudo pacman --needed --noconfirm -S $CORE_DEPENDENCIES $DEPENDENCIES \
					$THEME_DEPENDENCIES $DESKTOP_THEME_TOOLS $GNOME_DEPENDENCIES $EXTRAS
	else
		echo pacman is not installed!	
	fi
	echo Installing configs
	mkdir -p ~/.config/
	mkdir -p ~/.themes/
	mkdir -p ~/Pictures/wallpaper/
	cp -R dotfiles/.config/* ~/.config/
	cp -R dotfiles/.themes/* ~/.themes/
	cp -R wallpaper/* ~/Pictures/wallpaper/
	cp dotfiles/.gtkrc-2.0 ~/.gtkrc-2.0 
	cp dotfiles/.Xdefaults ~/.Xdefaults
	echo "exec openbox-session" > ~/.xinitrc
	xrdb ~/.Xdefaults
	echo Done!
fi
