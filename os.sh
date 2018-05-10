#!/usr/bin/env bash
set -e 
function trizen() {
	$(which trizen) --noconfirm --needed $* 
}
function print() {
	printf "\n==> $*\n\n"
}
print "Copying system configs..."
sudo cp system/etc/makepkg.conf /etc/makepkg.conf
if [ ! $(grep "sublime-text" /etc/pacman.conf) ]
then
	print Preparing sublime...
	curl -O https://download.sublimetext.com/sublimehq-pub.gpg 
	sudo pacman-key --add sublimehq-pub.gpg
	sudo pacman-key --lsign-key 8A8F901A
	rm sublimehq-pub.gpg
	print -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf > /dev/null
fi
print Installing tools
sudo pacman -S base-devel linux-headers dkms --noconfirm --needed
if ! command -v trizen > /dev/null 2>&1
then
	bdir="$(pwd)"
	print Installing trizen!
	mkdir -p /tmp/trizen-git/
	curl https://raw.githubusercontent.com/trizen/trizen/master/archlinux/PKGBUILD > /tmp/trizen-git/PKGBUILD
	cd /tmp/trizen-git/
	makepkg -sci
	cd "$bdir"
fi
print Installing programs...
trizen -Sy sublime-text all-repository-fonts firefox
if [ "x$(lspci | grep NVIDIA)" != "x" ]
then
	print Installing NVIDIA drivers and tools...
	trizen -S nvidia-dkms lib32-nvidia-utils opencl-nvidia nvidia-settings 
fi
if [ "x$(lspci | grep "RTL8111/8168/8411")" != "x" ]
then
	print Installing better LAN driver..
	trizen -S r8168-dkms
	print Blacklisting bad LAN driver...
	echo blacklist r8169 | sudo tee /etc/modprobe.d/ethernet.conf > /dev/null
fi 
if [ ! -f ".ic" ]
then
	bash install.sh
	touch ".ic"
fi
print Completed!
