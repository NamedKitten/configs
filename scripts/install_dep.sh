sudo pacman -S xorg-server xorg-xinit urxvt-unicode base-devel i3status i3blocks curl --noconfirm 
# installing packages required to build the packages
sudo pacman -S check meson --noconfirm
for dir in PKGBUILDS/* ; do
	cd $dir
	makepkg
	if [ "$?" != "0" ]; then
		FAILED="$FAILED $dir"
	else
		sudo pacman -U *.pkg.tar --noconfirm
	fi
	cd ../../
done
if [ "x$FAILED" != "x" ]; then
	echo "Failed packages: $FAILED"	
fi
