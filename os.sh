#!/bin/sh
_DRIVERS="nvidia-dkms lib32-nvidia-utils opencl-nvidia xf86-video-ati"
_TOOLS="nvidia-settings dnsmasq"
_EXTRAS="linux-headers steam steam-native-runtime weechat bitlbee"  
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
# Fail is install.sh doesn't exist
if [ ! -f install.sh ]; then
	echo Error: install.sh is missing
	exit 1
fi
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
print "Copying system configs"
EOF sudo cp system/etc/*.conf /etc/
EOF sudo cp system/etc/resolv.dnsmasq /etc/
#
# update db
print "Populating keys and updating the database"
EOF sudo pacman -Syy
EOF sudo pacman-key --populate archlinux
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
EOF sudo pacman -S $_DRIVERS $_TOOLS $_EXTRAS --noconfirm --needed
EOF trizen -S r8168-dkms --noconfirm --needed
# 
#
print Fixing audio, ethernet and enabling services!
audio
ethernet
services
#
#
print Setting up $HOME/bin
git clone https://github.com/tim241/bin ~/bin
#
touch .ks
#
print WARNING: REBOOT IS REQUIRED!
