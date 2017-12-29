#!/bin/sh
# installing stuff that I want on my os install
if [ $UID != 0 ]; then
	echo Execute this script as root!
	exit 1
fi
echo WARNING: THESE PACKAGES APPLY TO MY SYSTEM ONLY
echo WARNING: CONTINUE AT YOUR OWN RISK!
read none
# Fix audio issue I have
sed -i "s/load-module module-udev-detect/load-module module-udev-detect tsched=0/g" /etc/pulse/default.pa
# Locale stuff
echo Setting locale and generating locales
sed -i "s/#en/en/g" /etc/locale.gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
locale-gen
cp system/etc/*.conf /etc/
DRIVERS="nvidia lib32-nvidia-utils opencl-nvidia r8168"
TOOLS="lshw pkgfile nvidia-settings"
EXTRAS="mpv mps-youtube youtube-dl steam steam-native-runtime dnsmasq"
pacman -Sy --noconfirm $DRIVERS $TOOLS $EXTRAS
pkgfile --update
# Enable services
echo Enabling services
systemctl enable dnsmasq
systemctl enable dhcpcd
# Blacklist the r8169 driver, to force the use of the r8168 driver
echo blacklist r8169 > /etc/modprobe.d/ethernet.conf
sh install.sh
echo WARNING: REBOOT IS REQUIRED!
