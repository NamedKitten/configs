makepkg
if [ "$?" = "0" ]; then
	sudo pacman -U *.pkg* --noconfirm
	mv *.pkg* ../../../
	rm -rf obconf pkg src *.tar* README.md
else
	echo Compiling obconf failed
fi
