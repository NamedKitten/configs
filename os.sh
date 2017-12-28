#!/bin/sh
# installing stuff that I want on my os install
if [ $UID != 0 ]; then
	echo Execute this script as root!
	exit 1
fi
echo WARNING: THESE PACKAGES APPLY TO MY SYSTEM ONLY
echo WARNING: CONTINUE AT YOUR OWN RISK!
read none
# Locale stuff
echo Setting locale and generating locales
sed -i "s/#en/en/g" /etc/locale.gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
locale-gen
cp system/etc/pacman.conf /etc/pacman.conf
DRIVERS="nvidia lib32-nvidia-utils r8168 r8168"
TOOLS="lshw pkgfile nvidia-settings"
EXTRAS="mpv mps-youtube youtube-dl steam steam-native-runtime"
pacman -Sy --noconfirm $DRIVERS $TOOLS $EXTRAS
pkgfile --update
# Blacklist the r8169 driver, to force the use of the r8168 driver
echo blacklist r8169 > /etc/modprobe.d/ethernet.conf
sh install.sh
echo WARNING: REBOOT IS REQUIRED!
