#!/bin/sh
DRIVERS="nvidia lib32-nvidia-utils opencl-nvidia r8168"
TOOLS="lshw pkgfile nvidia-settings dnsmasq"
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
sudo pacman -Sy --noconfirm $DRIVERS $TOOLS $EXTRAS
sudo pkgfile --update
trizen -S dotnet-sdk-2.0 --noconfirm
# 
#
echo Fixing audio, ethernet and enabling services!
audio
ethernet
services
echo WARNING: REBOOT IS REQUIRED!
