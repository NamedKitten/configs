#!/usr/bin/env bash
set -e 
if [ ! $(grep "sublime-text" /etc/pacman.conf) ]
then
	echo Installing sublime...
	curl -O https://download.sublimetext.com/sublimehq-pub.gpg 
	sudo pacman-key --add sublimehq-pub.gpg
	sudo pacman-key --lsign-key 8A8F901A
	rm sublimehq-pub.gpg
	echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf > /dev/null
	sudo pacman -Sy sublime-text --noconfirm --needed
fi
echo Installing other programs...
sudo pacman -S firefox --noconfirm --needed
if [ ! -f ".ic" ]
then
	bash install.sh
	touch ".ic"
fi
