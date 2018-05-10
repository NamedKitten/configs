#!/usr/bin/env bash
set -e
if command -v pacman > /dev/null 2>&1
then
	sudo pacman -S gnome gnome-tweak-tool xorg-xinit chrome-gnome-shell --needed --noconfirm
fi
if [ ! -d "$HOME/.themes/X-Arc-Plus" ] 
then
	printf "Installing gtk theme...\n"
	mkdir -p "$HOME/.themes"
	git clone https://github.com/LinxGem33/X-Arc-Plus "$HOME/.themes/X-Arc-Plus"
fi
if [ ! -d "$HOME/.icons/Paper" ]
then
	printf "Installing icon theme...\n"
	mkdir -p tmp "$HOME/.icons"
	git clone https://github.com/LinxGem33/Arc-X-Icons tmp/icons
	cp -r tmp/icons/src/* "$HOME/.icons/"
fi
if [ ! -f "$HOME/Pictures/wallpaper/macOS-High-Sierra-Wallpaper.jpg" ]
then
	printf "Installing wallpaper...\n"
	mkdir -p "$HOME/Pictures/wallpaper"
	cp wallpaper/macOS-High-Sierra-Wallpaper.jpg "$HOME/Pictures/wallpaper/macOS-High-Sierra-Wallpaper.jpg"
fi
if [ -f "dconf_dump_patched.txt" ]
then
	printf "Cleaning previously patched dconf dump...\n"
	rm dconf_dump_patched.txt
fi
printf "Preparing xinitrc...\n"
printf "exec gnome-session\n" > "$HOME/.xinitrc"
printf "Patching dconf dump...\n"
cp dconf_dump.txt 			dconf_dump_patched.txt
sed -i "s<@HOME@<$HOME<g" 	dconf_dump_patched.txt
printf "Loading patched dconf dump...\n"
dconf load / < 			  	dconf_dump_patched.txt
printf "Please install these extensions yourself:\n"
for extension in $(cat extension_list.txt)
do
	printf "Extension: $(printf $extension | sed "s/-/ /g")\n"
done
printf "Cleaning up...\n"
rm -rf dconf_dump_patched.txt tmp
