if [ "x$1" != "x--nodeps" ]; then
	sudo pacman -S xorg-server xorg-xinit xorg-xsetroot \
		base-devel \
		i3status i3blocks i3lock \	
		curl \
		feh rxvt-unicode compton rofi \
		vim nano \
		htop 
	# installing packages required to build the packages
	sudo pacman -S check meson imagemagick cairo \
		librsvg libxdg-basedir libxkbcommon libxkbcommon-x11 \
		pango \
		xcb-util-wm xcb-util-xrm xcb-util-keysyms xcb-util-cursor \
		asciidoc docbook-xsl
fi
if [ ! -d "pkg" ]; then 
	mkdir pkg
fi
for dir in PKGBUILDS/* ; do
	cd $dir
	makepkg
	if [ "$?" != "0" ]; then
		FAILED="$FAILED $dir"
	else
		echo "Moving the completed pkg.tar file to ../../pkg/ !"
		mv *.pkg.tar* ../../pkg/
		echo "Done!"
	fi
	cd ../../
done
if [ "x$FAILED" != "x" ]; then
	echo "Failed packages: $FAILED"	
else
	cd pkg
	for file in *; do
		sudo pacman -U $file --noconfirm
	done	
fi
