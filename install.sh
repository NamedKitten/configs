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
	sh $HOME/.bash_it/install.sh --silent
	echo "Installing custom theme"
	cp -r files/themes/tim ~/.bash_it/themes/
	sed -i '/BASH_IT_THEME/d' $HOME/.bashrc
	sed -i '/bash_it.sh/d' $HOME/.bashrc
	echo "export BASH_IT_THEME='tim'" >> $HOME/.bashrc
	echo "source $HOME/.bash_it/bash_it.sh" >> $HOME/.bashrc	
}
install_bashrc () {
	sudo cp files/custom/printarch /usr/bin/printarch
	echo "printarch" >> .bashrc
}
install_etc () {
cat << END > $HOME/.Xresources
rofi.color-enabled: true
rofi.color-window: #002b37, #002b37, #003642
rofi.color-normal: #002b37, #819396, #002b37, #003642, #819396
rofi.color-active: #002b37, #008ed4, #002b37, #003642, #008ed4
rofi.color-urgent: #002b37, #da4281, #002b37, #003642, #da4281
END
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
install_usage () {
	echo "USAGE: sh install.sh [OPTIONS]"
	echo "OPTIONS:	"
	echo "| etc"
	echo "|	dep"
	echo "| dep_opt"
	echo "|	wallpaper"
	echo "|	configs"
	echo "|	bash_it"
	echo "|	bashrc"
	echo "|	all"
	echo "| full"
}
case $1 in
	"dep")
	install_dep_pacman
	install_dep_yaourt	
	;;
	"dep_opt")
	install_yaourt_opt
	;;
	"etc")
	install_etc
	;;
	"wallpaper")
	install_wall
	;;
	"configs")
	install_conf
	;;
	"bash_it")
	install_bash_it
	;;
	"bashrc")
	install_bashrc
	;;
	"base")
	install_dep_pacman
	install_dep_yaourt
	install_wall
	install_conf
	install_bashrc
	install_bash_it
	;;
	"full")
	install_dep_pacman
	install_dep_yaourt
	install_yaourt_opt
	install_pacman_opt
	install_etc
	install_wall
	install_conf
	install_bashrc
	install_bash_it
	;;
	*)
	install_usage
	;;
esac
