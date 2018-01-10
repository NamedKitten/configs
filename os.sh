#!/bin/sh
DRIVERS="nvidia-dkms lib32-nvidia-utils opencl-nvidia"
TOOLS="lshw pkgfile nvidia-settings dnsmasq htop"
EXTRAS="mpv mps-youtube youtube-dl steam steam-native-runtime dotnet-host dotnet-runtime dotnet-sdk" 
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
	if [ -d ~/.bash_it ]; then
		rm -rf ~/.bash_it
	fi
	git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
	bash ~/.bash_it/install.sh --silent
	cp dotfiles/.bashrc ~/.bashrc
}
keep_sudo () {
	while [ ! -f .ks ]; do
		sleep 60
		sudo -v
	done
	rm .ks
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
if [ ! -f ".ic" ]; then
	sh install.sh
fi
#
#
echo Please provide your sudo password...
EOF sudo echo "Thank you for providing your sudo password..let's continue"
keep_sudo &
#
# Copy configs
sudo cp system/etc/*.conf /etc/
#
# Install required packages and update db
EOF sudo pacman -Sy $DRIVERS $TOOLS $EXTRAS --noconfirm --needed
sudo pkgfile --update
EOF trizen -S code-git r8168-dkms --noconfirm --needed
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
EOF code-git --install-extension ms-vscode.csharp --install-extension ph-hawkins.arc-plus --install-extension jmrog.vscode-nuget-package-manager
#
# 
touch .ks
#
#
echo WARNING: REBOOT IS REQUIRED!
