#!/bin/sh
install_wall () {
	if [ ! -d $HOME/Pictures ]; then
		mkdir $HOME/Pictures
	fi
	cp -r files/wallpaper $HOME/Pictures/
}
install_conf () {
	cd files/configs/
	for dir in * ; do
		rm -rf ~/.config/$dir
		cp -r $dir ~/.config/
	done
	cd ../../
}
install_bash_it () {
	git clone --depth=1 https://github.com/Bash-it/bash-it.git $HOME/.bash_it
	bash $HOME/.bash_it/install.sh --silent
	echo "Installing custom theme"
	cp -r files/themes/tim $HOME/.bash_it/themes/
	sed -i '/BASH_IT_THEME/d' $HOME/.bashrc
	sed -i '/bash_it.sh/d' $HOME/.bashrc
	echo "export BASH_IT_THEME='tim'" >> $HOME/.bashrc
	echo "source $HOME/.bash_it/bash_it.sh" >> $HOME/.bashrc
}
install_bashrc () {
	sudo cp files/custom/printarch /usr/bin/printarch
	sudo chmod 777 /usr/bin/printarch
	cat files/custom/bashrc >> $HOME/.bashrc
}
install_etc () {
	cp -r files/custom/bin ~/
	cat files/custom/Xresources > $HOME/.Xresources
	cat files/custom/gtkrc-2.0 > $HOME/.gtkrc-2.0
	echo "exec openbox-session" > $HOME/.xinitrc
}
install_dep_yaourt () {
	if [ ! -f files/dep/yaourt ]; then
	echo "Yaourt's dep file not found!"
		exit 1
	fi
	yaourt -S --noconfirm `cat files/dep/yaourt`
}
install_pacman_config () {
	sudo chmod 777 /etc/pacman.conf
	cat files/custom/pacman.conf > /etc/pacman.conf
	sudo chmod 644 /etc/pacman.conf
	sudo pacman -Syyu
}
install_dep_pacman () {
	if [ ! -f files/dep/pacman ]; then
	echo "Pacman's dep file not found!"
		exit 1
	fi
	sudo pacman -S --noconfirm `cat files/dep/pacman`
}
install_dnsmasq () {
	sudo chattr -i /etc/resolv.dnsmasq
	sudo chattr -i  /etc/resolv.conf
	sudo chmod 777 /etc/dnsmasq.conf
	sudo chmod 777 /etc/resolv.conf
	sudo touch /etc/resolv.dnsmasq
	sudo chmod 777 /etc/resolv.dnsmasq
	cat files/custom/dnsmasq/dnsmasq.conf > /etc/dnsmasq.conf
	cat files/custom/dnsmasq/resolv.dnsmasq > /etc/resolv.dnsmasq
	echo "nameserver 127.0.0.1" > /etc/resolv.conf
	sudo chmod 644 /etc/dnsmasq.conf
	sudo chmod 644  /etc/resolv.conf
	sudo chmod 644 /etc/resolv.dnsmasq
	sudo chattr +i /etc/resolv.dnsmasq
	sudo chattr +i  /etc/resolv.conf
}
install_services () {
	sudo systemctl enable systemd-swap
	sudo systemctl enable NetworkManager
	sudo systemctl disable dhcpcd
	sudo systemctl mask tmpfs.mount
	sudo systemctl enable dnsmasq
}
install_check () {
	sudo pacman -Syyu --noconfirm
	echo "Checking for dep files"
	for file in "pacman"  "yaourt" ; do
		if [ ! -f files/dep/$file ]; then
		echo "`pwd`/files/dep/$file not found"
			exit 1
		else
			echo "`pwd`/files/dep/$file found"
		fi
	done
	for program in "pacman" "git" "cat" "grep"; do
		which $program > /dev/null 2>&1
		if [ $? != 0 ]; then
			echo "$program is not installed"
				exit 1
		else
			echo "$program is installed"
		fi
	done
	which yaourt > /dev/null 2>&1
	if [ $? != 0 ]; then
		echo "Installing yaourt"
		install_pacman_config
		install_yaourt
	fi
}
install_yaourt () {
	sudo pacman -S yaourt --noconfirm
}
install_usage () {
	echo "USAGE: sh install.sh [OPTIONS]"
	echo "OPTIONS:	"
	echo "|	check"
	echo "|	etc"
	echo "|	dep"
	echo "|	dep_opt"
	echo "|	wallpaper"
	echo "|	configs"
	echo "|	bash_it"
	echo "|	bashrc"
	echo "|	services"
	echo "|	dnsmasq"
	echo "|	base"
	echo "|	full"
}
case $1 in
	"check")
	install_check
	;;
	"dep")
	install_check
	install_dep_pacman
	install_dep_yaourt
	;;
	"etc")
	install_check
	install_etc
	;;
	"wallpaper")
	install_check
	install_wall
	;;
	"configs")
	install_check
	install_conf
	;;
	"bash_it")
	install_check
	install_bash_it
	;;
	"bashrc")
	install_check
	install_bashrc
	;;
	"services")
	install_check
	install_services
	;;
	"dnsmasq")
	install_check
	install_dnsmasq
	;;
	"base")
	install_check
	install_dep_pacman
	install_dep_yaourt
	install_wall
	install_conf
	install_bash_it
	install_bashrc
	;;
	"full")
	install_check
	install_pacman_config
	install_dep_pacman
	install_dep_yaourt
	install_services
	install_etc
	install_wall
	install_conf
	install_bash_it
	install_bashrc
	install_dnsmasq
	install_services
	;;
	*)
	install_usage
	;;
esac
