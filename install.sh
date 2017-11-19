CORE_DEPENDENCIES="xorg-server xorg-xinit xorg-xrandr openbox tint2"
DEPENDENCIES="rxvt-unicode feh gnome-alsamixer rofi nemo
		obconf lxappearance
		xfce4-screenshooter"
THEME_DEPENDENCIES="numix-gtk-theme adapta-gtk-theme 
	compton	gtk-theme-switch2"
if `which pacman > /dev/null 2>&1`; then
	sudo pacman --needed --noconfirm -S $CORE_DEPENDENCIES $DEPENDENCIES $THEME_DEPENDENCIES
	# Installing prebuilt packages
	echo Installing prebuilt packages!
	sudo pacman -U prebuilt/*pkg.tar*
else
	echo pacman is not installed!	
fi
echo Installing configs
echo "exec openbox-session" > ~/.xinitrc
cp -R dotfiles/.config/* ~/.config/
cp dotfiles/.Xdefaults ~/.Xdefaults
cp dotfiles/.gtkrc-2.0.mine ~/.gtkrc-2.0.mine
if [ ! -d $HOME/Pictures ]; then
	mkdir ~/Pictures
fi
cp wallpaper/* ~/Pictures/wallpaper/
echo Done!
