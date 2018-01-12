#!/bin/sh
DRIVERS="nvidia-dkms lib32-nvidia-utils opencl-nvidia"
TOOLS="lshw pkgfile nvidia-settings dnsmasq htop cmake llvm"
EXTRAS="mpv mps-youtube youtube-dl steam steam-native-runtime dotnet-host dotnet-runtime dotnet-sdk vim" 
audio () {
	# Fix audio issue I have
	print Fixing audio
	if [ "x`grep -R "load-module module-udev-detect tsched=0" /etc/pulse/default.pa`" = "x" ]; then
		sudo sed -i "s/load-module module-udev-detect/load-module module-udev-detect tsched=0/g" /etc/pulse/default.pa
	fi
}
ethernet () {
	# Blacklist the r8169 driver, to force the use of the r8168 driver
	print Blacklisting the r8169 module
 	echo blacklist r8169 | sudo tee /etc/modprobe.d/ethernet.conf > /dev/null
}
services () {
	# Enable services
	print Enabling services
	EOF sudo systemctl enable dnsmasq
	EOF sudo systemctl enable dhcpcd
}
bash_it () {
	if [ -d ~/.bash_it ]; then
		rm -rf ~/.bash_it
	fi
	EOF git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
	EOF bash ~/.bash_it/install.sh --silent
	EOF cp dotfiles/.bashrc $HOME/.bashrc
}
keep_sudo () {
	while [ ! -f .ks ]; do
		sleep 60
		sudo -v
	done
	rm .ks
}
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
	mkdir build && cd build && cmake ..
	EOF make -j5 && EOF make install -j5
	EOF make clean && EOF make clean_clang
	print "Enabling clang_complete"
        cd ~/.vim/bundle/clang_complete
        EOF vim +PluginInstall +qa
	EOF make
	EOF vim clang_complete.vmb -c 'so %' -c 'q' +qa
	cd $BDIR
}
# Source EOF from install.sh
source ./install.sh --source
# Exit On Root
EOR
print WARNING: THESE PACKAGES APPLY TO MY SYSTEM ONLY
read none
#
# Make sure .ks doesn't exist
if [ -f ".ks" ]; then
	rm .ks
fi
# Make sure install.sh is executed
if [ ! -f ".ic" ]; then
	sh install.sh
fi
#
#
ask_sudo
keep_sudo &
#
# Copy configs
EOF sudo cp system/etc/*.conf /etc/
#
# Install required packages and update db
EOF sudo pacman -Sy $DRIVERS $TOOLS $EXTRAS --noconfirm --needed
sudo pkgfile --update
EOF trizen -S code-git r8168-dkms --noconfirm --needed
# 
#
print Fixing audio, ethernet and enabling services!
audio
ethernet
services
# 
#
print Installing bash-it!
bash_it
#
#
print "Preparing VIM"
vim_stuff
#
#
print Setting up $HOME/bin
git clone https://github.com/tim241/bin ~/bin
#
#
print Setting up VSCode
EOF code-git --install-extension ms-vscode.csharp --install-extension ph-hawkins.arc-plus --install-extension jmrog.vscode-nuget-package-manager
#
# 
touch .ks
#
#
print WARNING: REBOOT IS REQUIRED!
