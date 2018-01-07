#!/bin/sh
DRIVERS="nvidia-dkms lib32-nvidia-utils opencl-nvidia"
TOOLS="lshw pkgfile nvidia-settings dnsmasq htop"
EXTRAS="mpv mps-youtube youtube-dl steam steam-native-runtime dotnet-host dotnet-runtime" 
audio () {
	# Fix audio issue I have
	echo Fixing audio
	if [ "x`grep -R "load-module module-udev-detect tsched=0" /etc/pulse/default.pa`" = "x" ]; then
		sudo sed -i "s/load-module module-udev-detect/load-module module-udev-detect tsched=0/g" /etc/pulse/default.pa
	fi
}
ethernet () {
	# Blacklist the r8169 driver, to force the use of the r8168 driver
	echo Blacklisting the r8169 module
 	echo blacklist r8169 | sudo tee /etc/modprobe.d/ethernet.conf
}
services () {
	# Enable services
	echo Enabling services
	sudo systemctl enable dnsmasq
	sudo systemctl enable dhcpcd
}
bash_it () {
	git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
	bash ~/.bash_it/install.sh --silent
	cp dotfiles/.bashrc ~/.bashrc
}
# Source EOF from install.sh
source ./install.sh --source
# installing stuff that I want on my os install
if [ $UID = 0 ]; then
	echo Execute this script as a user!
	exit 1
fi
echo WARNING: THESE PACKAGES APPLY TO MY SYSTEM ONLY
read none
#
# Make sure install.sh is executed
if [ ! -f "install_completed" ]; then
	sh install.sh
fi
#
# Copy configs
sudo cp system/etc/*.conf /etc/
#
# Install required packages and update db
eof sudo pacman -Sy --noconfirm $DRIVERS $TOOLS $EXTRAS
sudo pkgfile --update
eof trizen -S dotnet-sdk-2.0 code-git r8168-dkms --noconfirm --needed
# 
#
echo Fixing audio, ethernet and enabling services!
audio
ethernet
services
# 
#
echo Installing bash-it!
bash_it
#
#
echo Setting up $HOME/bin
git clone https://github.com/tim241/bin ~/bin
#
#
echo Setting up VSCode
eof code-git --install-extension ms-vscode.csharp --install-extension ph-hawkins.arc-plus --install-extension jmrog.vscode-nuget-package-manager
#
#
echo WARNING: REBOOT IS REQUIRED!
