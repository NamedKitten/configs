#!/bin/sh
_DRIVERS="nvidia-dkms lib32-nvidia-utils opencl-nvidia xf86-video-ati"
_TOOLS="lshw pkgfile nvidia-settings dnsmasq htop cmake llvm clang"
_EXTRAS="linux-headers mpv mps-youtube youtube-dl steam steam-native-runtime dotnet-host dotnet-runtime dotnet-sdk vim ranger w3m perl-anyevent-i3 perl-json-xs" 
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
keep_sudo () {
	while [ ! -f .ks ]; do
		sleep 60
		sudo -v
	done
	rm .ks
}
code_ext () {
	for extension in $@; do
		EOF code-git --install-extension $extension
	done
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
#
# Copy configs
EOF sudo cp system/etc/*.conf /etc/
EOF sudo cp system/etc/resolv.dnsmasq /etc/
#
# update db
sudo pacman -Sy
#
# Make sure install.sh is executed
if [ ! -f ".ic" ]; then
	sh install.sh
fi
#
#
ask_sudo
keep_sudo &
#
# Install required packages and update db
EOF sudo pacman -Sy $_DRIVERS $_TOOLS $_EXTRAS --noconfirm --needed
sudo pkgfile --update
EOF trizen -S r8168-dkms --noconfirm --needed
# 
#
print Fixing audio, ethernet and enabling services!
audio
ethernet
services
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
#print Setting up VSCode
#code_ext ms-vscode.csharp ph-hawkins.arc-plus jmrog.vscode-nuget-package-manager ms-vscode.cpptools twxs.cmake
#
# 
touch .ks
#
#
print WARNING: REBOOT IS REQUIRED!
