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
	cat files/custom/bashrc > $HOME/.bashrc
}
install_etc () {
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
install_yaourt_opt () {
	if [ ! -f files/dep/yaourt_opt ]; then
	echo "Yaourt's dep file not found!"
		exit 1
	fi
	yaourt -S --noconfirm `cat files/dep/yaourt_opt`
}
install_pacman_opt () {
	if [ ! -f files/dep/pacman_opt ]; then
	echo "Pacman's dep file not found!"
		exit 1
	fi
	sudo pacman -S --noconfirm `cat files/dep/pacman_opt`
}
install_dep_pacman () {
	if [ ! -f files/dep/pacman ]; then
	echo "Pacman's dep file not found!"
		exit 1
	fi
	sudo pacman -S --noconfirm `cat files/dep/pacman`
}
install_services () {
 sudo systemctl enable NetworkManager
 sudo systemctl disable dhcpcd
 sudo systemctl mask tmpfs.mount
}
install_check () {
	sudo pacman -Syyu --noconfirm
	echo "Checking for dep files"
	for file in "pacman" "pacman_opt" "yaourt" "yaourt_opt"; do
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
		install_yaourt
	fi
}
install_yaourt () {
	cat /etc/pacman.conf | grep "http://repo.archlinux.fr" > /dev/null 2>&1
	if [ $? != 0 ]; then
		sudo chmod 777 /etc/pacman.conf
		cat files/custom/pacman.conf >> /etc/pacman.conf
		sudo chmod 644 /etc/pacman.conf
		sudo pacman -Syyu --noconfirm
	fi
	sudo pacman -S yaourt --noconfirm
}
install_firefox () {
	WD=`pwd`
	git clone https://github.com/horst3180/arc-firefox-theme /tmp/arc-firefox-theme
	cd /tmp/arc-firefox-theme
	./autogen.sh --prefix=/usr
	sudo make install
	cd $WD
	rm -rf /tmp/arc-firefox-theme
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
	echo "| firefox"
	echo "| services"
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
	"dep_opt")
	install_check
	install_yaourt_opt
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
	"firefox")
	install_check
	install_firefox
	;;
	"services")
	install_check
	install_services
	;;
	"base")
	install_check
	install_dep_pacman
	install_dep_yaourt
	install_wall
	install_conf
	install_bashrc
	install_bash_it
	;;
	"full")
	install_check
	install_dep_pacman
	install_dep_yaourt
	install_yaourt_opt
	install_pacman_opt
	install_services
	install_etc
	install_wall
	install_conf
	install_bashrc
	install_bash_it
	install_firefox
	;;
	*)
	install_usage
	;;
esac
