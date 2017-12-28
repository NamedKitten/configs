sudo pacman -S bzr python-distutils-extra python-setuptools --noconfirm
makepkg
if [ "$?" = "0" ]; then
	sudo pacman -U *.pkg* --noconfirm
	mv *.pkg* ../../
	rm -rf src pkg folder-color-nautilus-bzr
else
	echo Compiling folder-color-nautilus-bzr failed!
	exit 1
fi
