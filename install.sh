#!/bin/sh
CORE_DEPENDENCIES="xorg-server xorg-xinit xorg-xrandr xorg-xsetroot git i3-gaps"
AUDIO="pulseaudio-alsa alsa-utils"
DEPENDENCIES="rxvt-unicode feh rofi arandr"
THEME_DEPENDENCIES="papirus-icon-theme compton qt5ct qt5-styleplugins"
DESKTOP_THEME_TOOLS="lxappearance"
GNOME_DEPENDENCIES="pavucontrol gcolor2"
EXTRAS="firefox mplayer mpv mps-youtube youtube-dl aspell-en vim ranger w3m perl-anyevent-i3 perl-json-xs lshw pkgfile htop cmake llvm clang lua"
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
print "Making QT look like GTK+"
echo QT_QPA_PLATFORMTHEME=qt5ct | sudo tee -a /etc/environment > /dev/null
if [ ! -f .vc ]; then
	print "Installing vim stuff"
	vim_stuff
	touch .vc
fi
print "Updating databases.."
sudo pkgfile --update
sudo pacman -Sy
print "Done!"
touch .ic
