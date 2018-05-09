#!/usr/bin/env bash
set -e
if command -v pacman > /dev/null 2>&1
then
	sudo pacman -S gnome gnome-tweak-tool --needed --noconfirm
fi
if [ ! -d "$HOME/.themes/X-Arc-Plus" ] 
then
	echo Installing gtk theme...
	mkdir -p "$HOME/.themes"
	git clone https://github.com/LinxGem33/X-Arc-Plus "$HOME/.themes/X-Arc-Plus"
fi
if [ ! -d "$HOME/.icons/Arc-X-Icons" ]
then
	echo Installing icon theme...
	mkdir tmp 
	git clone https://github.com/LinxGem33/Arc-X-Icons tmp/icons
	cp -r tmp/icons/src "$HOME/.icons/Arc-X-Icons"
fi
if [ ! -f "$HOME/Pictures/wallpaper/macOS-High-Sierra-Wallpaper.jpg" ]
then
	echo Installing wallpaper...
	mkdir -p "$HOME/Pictures/wallpaper"
	cp wallpaper/macOS-High-Sierra-Wallpaper.jpg "$HOME/Pictures/wallpaper/macOS-High-Sierra-Wallpaper.jpg"
fi
if [ -f "dconf_dump_patched.txt" ]
then
	echo Cleaning previously patched dconf dump...
	rm dconf_dump_patched.txt
fi
echo Patching dconf dump...
cp dconf_dump.txt 			dconf_dump_patched.txt
sed -i "s<@HOME@<$HOME<g" 	dconf_dump_patched.txt
echo Loading patched dconf dump...
dconf load / < 			  	dconf_dump_patched.txt
echo Please install these extensions yourself:
for extension in $(cat extension_list.txt)
do
	echo "Extension: $(printf $extension | sed "s/-/ /g")"
done
echo Cleaning up...
rm -rf dconf_dump_patched.txt tmp