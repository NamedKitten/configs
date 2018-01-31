#!/bin/bash
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
# Install vim stuff..
vim_stuff () {
	cp dotfiles/.vimrc ~/.vimrc	
	BDIR=`pwd`
	if which vim-huge > /dev/null 2>&1; then
		alias vim='vim-huge'
	fi
	if [ -d "$HOME/.vim" ]; then
		rm -rf ~/.vim
	fi	
	mkdir -p ~/.vim/bundle/
	EOF git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	EOF git clone https://github.com/jeaye/color_coded ~/.vim/bundle/color_coded
	EOF git clone https://github.com/Rip-Rip/clang_complete ~/.vim/bundle/clang_complete
	print "Compiling color_coded"
	cd ~/.vim/bundle/color_coded	
	mkdir build && cd build && EOF cmake .. -DDOWNLOAD_CLANG=0
	EOF make -j5 && EOF make install -j5
	EOF make clean
	print "Enabling clang_complete"
        cd ~/.vim/bundle/clang_complete
        EOF vim +PluginInstall +qa
	EOF make
	EOF vim clang_complete.vmb -c 'so %' -c 'q' +qa
	cd $BDIR
}
if [ "x$1" = "x--source" ]; then
	return
fi
echo -e "${RED}===> NOTE: This script WILL overwrite your i3, neofetch, weechat, ranger, trizen and vlc configs	${NC}"
echo -e "${RED}===> NOTE: This script WILL also overwrite your bashrc AND weechat configs			${NC}"
echo -e "${RED}===> NOTE: You HAVE BEEN WARNED, continue at your own risk					${NC}"
echo -e "${RED}===> NOTE: Press enter to continue, press Control+C to exit 					${NC}"
read confirm
EOR
ask_sudo
print "Checking if platform is supported.."
if which pacman > /dev/null 2>&1; then
	print "Arch linux detected.."
	print "Installing prebuilt packages!"
	EOF sudo pacman --needed --noconfirm -U prebuilt/*pkg*
	print "Installing required packages for Arch linux!"
	EOF sudo pacman --needed --noconfirm -S xorg-server xorg-xinit xorg-xrandr xorg-xsetroot git i3-gaps \
		rxvt-unicode feh rofi arandr \
		papirus-icon-theme compton qt5ct qt5-styleplugins \
		pavucontrol gcolor2 lxappearance \
		firefox mplayer mpv mps-youtube youtube-dl aspell-en \
		vim ranger w3m perl-anyevent-i3 perl-json-xs lshw pkgfile htop cmake llvm clang \
		lua pulseaudio-alsa alsa-utils \
		i3lock
	print "Updating databases.."
	EOF sudo pkgfile --update
	EOF sudo pacman -Sy 
elif which xbps-install > /dev/null 2>&1; then
	# function Install Void Package(s)
	function IVP {
		for package in $@; do
			if [ ! "$(xbps-query $package)" ]; then
				EOF sudo xbps-install -S --yes $package
			fi
		done
	}
	# function Enable Service(s)
	function ES {
		for service in $@; do
			EOF sudo ln -sf /etc/sv/$service /var/service/
		done
	}

	print "Void linux detected.."
	print "Updating repos for Void linux"
	IVP void-repo-multilib
	print "Installing required packages for Void linux!"
	IVP noto-fonts-ttf i3lock i3-gaps \
		curl rofi \
		adwaita-icon-theme papirus-icon-theme \
		lua firefox alsa-utils pulseaudio pamix \
		xorg-minimal xorg-video-drivers \
		clang llvm \
		vim-huge \
		rxvt-unicode rxvt-unicode-terminfo urxvt-perls \
		ConsoleKit2 
	print "Enabling services"
	IVP dbus cgmanager consolekit alsa
else
	printError "Unsupported platform detected.."
fi
print "Installing configs"
print "Creating directories.."
EOF mkdir -p $HOME/.config/ $HOME/.themes/ $HOME/.weechat
print "Copying configs.."
EOF "cp -R dotfiles/.config/* $HOME/.config/"
print "Copying gtk themes.."
EOF "cp -R dotfiles/.themes/* $HOME/.themes/"
print "Copying weechat configs"
EOF "cp -R dotfiles/.weechat/* $HOME/.weechat/"
print "Patching weechat configs"
cat dotfiles/.weechat/irc.conf | sed "s/USER/$USER/g" > $HOME/.weechat/irc.conf
print "Preparing xinitrc"
echo "exec i3" > $HOME/.xinitrc
print "Installing bashrc.."
EOF "cp dotfiles/.bashrc $HOME/.bashrc"
if [ ! "$(grep 'qt5ct' /etc/environment)" ]; then
	print "Making QT look like GTK+"
	echo QT_QPA_PLATFORMTHEME=qt5ct | sudo tee -a /etc/environment > /dev/null
fi
if [ ! -f .vc ]; then
	print "Installing vim stuff"
	vim_stuff
	touch .vc
fi
print "Done!"
touch .ic
