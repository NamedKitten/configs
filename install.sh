CORE_DEPENDENCIES="xorg-server xorg-xinit xorg-xrandr openbox tint2"
DEPENDENCIES="rxvt-unicode feh gnome-alsamixer rofi nemo
		obconf lxappearance
		xfce4-screenshooter"
THEME_DEPENDENCIES="kvantum-qt5 numix-gtk-theme adapta-gtk-theme 
	compton	gtk-theme-switch2"
if `which pacman > /dev/null 2>&1`; then
	sudo pacman --needed --noconfirm -S $CORE_DEPENDENCIES $DEPENDENCIES $THEME_DEPENDENCIES
else
	echo pacman is not installed!	
fi
echo Installing configs
echo "exec openbox-session" > ~/.xinitrc
cp -R dotfiles/.config/* ~/.config/
cp dotfiles/.Xdefaults ~/.Xdefaults
cp dotfiles/.gtk* ~/
if [ ! -d $HOME/Pictures ]; then
	mkdir ~/Pictures
fi
cp wallpaper/* ~/Pictures/wallpaper/
echo Done!
