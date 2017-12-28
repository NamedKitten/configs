makepkg
if [ "$?" = "0" ]; then
	sudo pacman -U *.pkg* --noconfirm
	mv *.pkg* ../../
	rm -rf src pkg i3lock-fancy
else
	echo Compiling i3lock-fancy failed!
	exit 1
fi
