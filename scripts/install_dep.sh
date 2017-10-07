if [ "x$1" = "x--help" ]; then
	echo "
sh $0 --nodeps

Install without any dependencies, it will only build the PKGBUILDs then

#################################

sh $0 --with-opt

Install base with optional programs
(weechat, firefox, mps-youtube etc)		
"
	exit 0
fi
if [ "x$1" != "x--nodeps" ]; then
	sudo pacman -S --noconfirm \
		xorg-server xorg-xinit xorg-xsetroot xorg-xrandr \
		base-devel \
		i3status i3blocks i3lock \
		curl xdg-utils \
		feh rxvt-unicode compton rofi \
		vim nano \
		htop \
		noto-fonts
	if [ "x$1" = "x--with-opt" ]; then
		sudo pacman -S --noconfirm \
				weechat bitlbee \
				aspell-en pkgfile \
				pulseaudio alsa-utils \
				mpv mps-youtube youtube-dl \
				firefox wget \
				screenfetch 
		echo "Updating repos for pkgfile!"		
		sudo pkgfile --update
		echo "Setting default player for mpsyt!"
		mpsyt set player mpv & mpsyt exit
	fi
	# installing packages required to build the packages
	sudo pacman -S --noconfirm \
		check meson clang imagemagick cairo \
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
