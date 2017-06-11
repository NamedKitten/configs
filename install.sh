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
	sh $HOME/.bash_it/install.sh
}
install_dep_yaourt () {
	yaourt -S --noconfirm `cat files/dep/yaourt`
}
install_dep_pacman () {
	sudo pacman -S --noconfirm `cat files/dep/pacman`
}
install_usage () {
	echo "USAGE: sh install.sh [OPTIONS]"
	echo "OPTIONS:	"
	echo "|	--wallpaper"
	echo "|	--configs"
	echo "|	--bash_it"
	echo "|	--all"
}
if [ ! $1 ]; then
install_usage
fi
case $1 in
	"--wallpaper")
	install_wall
	;;
	"--configs")
	install_conf
	;;
	"--bash_it")
	install_bash_it
	;;
	"--all")
	install_wall
	install_conf
	install_bash_it
	;;
	*)
esac
