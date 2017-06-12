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
	echo "Installing custom theme"
	cp -r files/themes/tim ~/.bash_it/themes/
	sed -i '/BASH_IT_THEME/d' $HOME/.bashrc
	sed -i '/bash_it.sh/d' $HOME/.bashrc
	echo "export BASH_IT_THEME='tim'" >> $HOME/.bashrc
	echo "source $HOME/.bash_it/bash_it.sh" >> $HOME/.bashrc	
}
install_bashrc () {
	sudo cp files/custom/screenfetch /usr/bin/screenfetch
	echo "screenfetch -L" >> .bashrc
}
install_dep_yaourt () {
	if [ ! -f files/dep/yaourt ]; then
	echo "Yaourt's dep file not found!"
		exit 1
	fi
	yaourt -S --noconfirm `cat files/dep/yaourt`
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
	echo "|	--dep"
	echo "|	--wallpaper"
	echo "|	--configs"
	echo "|	--bash_it"
	echo "|	--bashrc"
	echo "|	--all"
}
if [ ! $1 ]; then
install_usage
fi
case $1 in
	"--dep")
	install_dep_pacman
	install_dep_yaourt	
	;;
	"--wallpaper")
	install_wall
	;;
	"--configs")
	install_conf
	;;
	"--bash_it")
	install_bash_it
	;;
	"--bashrc")
	install_bashrc
	;;
	"--all")
	install_dep_pacman
    install_dep_yaourt
	install_wall
	install_conf
	install_bashrc
	install_bash_it
	;;
	*)
esac
