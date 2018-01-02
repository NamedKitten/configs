makepkg
if [ "$?" = "0" ]; then
	sudo pacman -U *.pkg* --noconfirm
	mv *.pkg* ../../../
	rm -rf openbox pkg src *.tar* README.md
else
	echo Compiling openbox-patched failed
fi
