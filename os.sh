#!/usr/bin/env bash
set -e 
function _trizen() {
	$(which trizen) --noconfirm --needed $* 
}
function print() {
	printf "\n==> $*\n\n"
}
print "Copying user configs..."
mkdir -p "$HOME/.config" 
cp -r dotfiles/.config/* "$HOME/.config/"
if [ ! -d "$HOME/.mozilla" ]
then
	cp -r dotfiles/.mozilla "$HOME/.mozilla"
fi
print "Copying system configs..."
sudo cp system/etc/* /etc/
print Installing tools
sudo pacman -Sy base-devel linux-headers dkms pulseaudio pkgfile --noconfirm --needed
if ! which trizen > /dev/null 2>&1
then
	bdir="$(pwd)"
	print Installing trizen!
	mkdir -p /tmp/trizen-git/
	curl https://raw.githubusercontent.com/trizen/trizen/master/archlinux/PKGBUILD > /tmp/trizen-git/PKGBUILD
	cd /tmp/trizen-git/
	makepkg -sci --noconfirm
	cd "$bdir"
fi
print Installing programs...
_trizen -Sy sublime-text all-repository-fonts firefox steam-native-runtime steam
if [ "x$(lspci | grep NVIDIA)" != "x" ]
then
	print Installing NVIDIA drivers and tools...
	_trizen -S nvidia-dkms lib32-nvidia-utils opencl-nvidia nvidia-settings 
fi
if [ "x$(lspci | grep "RTL8111/8168/8411")" != "x" ]
then
	print Installing better LAN driver..
	_trizen -S r8168-dkms
	print Blacklisting bad LAN driver...
	echo blacklist r8169 | sudo tee /etc/modprobe.d/ethernet.conf > /dev/null
fi 
if [ "x$(lspci | grep "HD Audio Controller")" != "x" ] && \
	[ "x$(grep "load-module module-udev-detect tsched=0" /etc/pulse/default.pa)" = "x" ]
then
	print Fixing audio...
	sudo sed -i "s/load-module module-udev-detect/load-module module-udev-detect tsched=0/g" /etc/pulse/default.pa
fi
print Enabling network time...
sudo timedatectl set-ntp true
if [ ! -f ".ic" ]
then
	print Executing install.sh...
	bash install.sh
	touch ".ic"
fi
sudo pkgfile --update
print Completed!
