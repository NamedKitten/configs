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
		if [ "$ERRMSG" ]; then
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
	if command -v vim-huge > /dev/null 2>&1; then
		vim=$(which vim-huge)
	elif command -v vim > /dev/null 2>&1; then
		vim=$(which vim)
	else
		printError "Vim is not installed!"
		exit 1
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
        EOF $vim +PluginInstall +qa
	EOF make
	EOF $vim clang_complete.vmb -c 'so %' -c 'q'
	cd $BDIR
}
WARN=true
if [ $1 ]; then
	if [ "$1" = "--source" ]; then
		return
	elif [ "$1" = "--nowarn" ]; then
		WARN=false
	fi
fi
if [ "$WARN" = "true" ]; then
	echo -e "${RED}===> NOTE: This script WILL overwrite your i3, neofetch, weechat, ranger, trizen and vlc configs	${NC}"
	echo -e "${RED}===> NOTE: This script WILL also overwrite your bashrc AND weechat configs			${NC}"
	echo -e "${RED}===> NOTE: You HAVE BEEN WARNED, continue at your own risk					${NC}"
	echo -e "${RED}===> NOTE: Press enter to continue, press Control+C to exit 					${NC}"
	read confirm
fi
EOR
ask_sudo
print "Checking if platform is supported.."
SHARED_DEPENDENCIES="firefox curl rofi i3lock i3-gaps clang cmake llvm rxvt-unicode ranger feh pulseaudio alsa-utils lua w3m papirus-icon-theme"
if command -v pacman > /dev/null 2>&1; then
	print "Arch linux detected.."
	print "Installing packages for compiling packages"
	EOF sudo pacman -S --noconfirm base-devel
	print "Building packages from source.."
	bash ./packages/arch/build.sh
	print "Installing required packages for Arch linux!"
	EOF sudo pacman --needed --noconfirm -S xorg-server xorg-xinit xorg-xrandr xorg-xsetroot arandr \
		compton qt5ct qt5-styleplugins \
		pavucontrol gcolor2 aspell-en \
		vim perl-anyevent-i3 perl-json-xs pkgfile pulseaudio-alsa \
		$SHARED_DEPENDENCIES
	print "Updating databases.."
	EOF sudo pkgfile --update
	EOF sudo pacman -Sy 
elif command -v xbps-install > /dev/null 2>&1; then
	# function Install Void Package(s)
	function IVP {
		if [ $1 ]; then
			for package in $@; do
				if [ ! "$(xbps-query $package)" ]; then
					PACKAGES="$PACKAGES $package"
				fi
			done
			EOF sudo xbps-install -Sy $PACKAGES
		fi	
	}
	# function Enable Service(s)
	function ES {
		if [ $1 ]; then
			for service in $@; do
				if [ ! -d "/var/service/$service" ]; then
					EOF sudo ln -s /etc/sv/$service /var/service/
				fi
			done
		fi
	}
	print "Void linux detected.."
	print "Updating repos for Void linux"
	IVP void-repo-multilib
	print "Installing required packages for Void linux!"
	IVP noto-fonts-ttf 	adwaita-icon-theme lua-devel PAmix \
		xorg-minimal xorg-video-drivers xorg-apps xorg-fonts \
		vim-huge \
		rxvt-unicode-terminfo urxvt-perls ranger \
		ConsoleKit2 dbus bash-completion \
		$SHARED_DEPENDENCIES
	print "Enabling services"
	ES dbus cgmanager consolekit alsa
else
	printError "Unsupported platform detected.."
	printError "Press enter to continue anyways.."
	printError "It will copy the configs, compile weechat plugins etc.."
	printError "Continue at your own risk"
	read confirm
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
