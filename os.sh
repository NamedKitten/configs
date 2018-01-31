#!/bin/bash
audio () {
	# Fix audio issue I have
	print Fixing audio
	if [ "$(grep "load-module module-udev-detect tsched=0" /etc/pulse/default.pa)" ]; then
		sudo sed -i "s/load-module module-udev-detect/load-module module-udev-detect tsched=0/g" /etc/pulse/default.pa
	fi
}
keep_sudo () {
	while [ ! -f .ks ]; do
		sleep 60
		sudo -v
	done
	rm .ks
}
## Platforms ##
# Arch linux
arch () {
	print "Copying system configs for Arch linux!"
	EOF sudo cp system/arch/etc/*.conf /etc/
    print "Populating keys and updating the database"
    EOF sudo pacman -Syy
    EOF sudo pacman-key --populate archlinux
    # Install required packages and update db
    EOF sudo pacman -S nvidia-dkms lib32-nvidia-utils opencl-nvidia xf86-video-ati \
				nvidia-settings dnsmasq \
				linux-headers steam steam-native-runtime weechat bitlbee \
		  		--noconfirm --needed
    EOF trizen -S r8168-dkms --noconfirm --needed
    print Fixing stuff and enabling services!
    audio
	# Blacklist the r8169 driver, to force the use of the r8168 driver
    print Blacklisting the r8169 module
    echo blacklist r8169 | sudo tee /etc/modprobe.d/ethernet.conf > /dev/null
	print Enabling services
	EOF sudo systemctl enable dnsmasq
	EOF sudo systemctl enable dhcpcd
}
# Void linux
void () {
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
			print "Enabling service: $service"
			EOF sudo ln -sf /etc/sv/$service /var/service/
		done
	}
	print Installing multilib repo
    IVP void-repo-multilib
	print Installing nonfree repos
	IVP void-repo-nonfree void-repo-multilib-nonfree
	print Installing packages
	IVP nvidia weechat bitlbee steam 
	print "Enabling services.."
	ES bitlbee dnsmasq 
	
}

## END OF PLATFORMS ##
#####
# Fail when install.sh doesn't exist
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
# Make sure .ks doesn't exist
if [ -f ".ks" ]; then
	rm .ks
fi
# Ask for sudo and keep it
ask_sudo
keep_sudo &
# Detect platform and execute specifics
if [ -f /etc/os-release ]; then
	source /etc/os-release		
else
	echo "Error: no /etc/os-release found!"
	exit 1
fi
EOF $ID
# Copy configs
print "Copying system configs for dnsmasq"
EOF sudo cp system/etc/dnsmasq.conf /etc/dnsmasq.conf
EOF sudo cp system/etc/resolv.dnsmasq /etc/resolv.dnsmasq
#
# Make sure install.sh is executed
if [ ! -f ".ic" ]; then
	sh install.sh
fi
print Setting up $HOME/bin
git clone https://github.com/tim241/bin ~/bin
touch .ks
print WARNING: REBOOT IS REQUIRED!
