#!/bin/sh
# Source install.sh for EOF
source ./install.sh --source
rm -rf prebuilt/*pkg*
cd prebuilt/dev
DEVDIR=`pwd`
RMFILES="i3lock-color trizen toilet*.tar.gz cava"
for PKGdir in $EXTRA_DEP `find . -name "PKGBUILD" -not -path "*dep*" -execdir "pwd" \;`; do 	
	cd $PKGdir
	print "Building in $PKGdir"
	ERRMSG="Building in '$PKGdir' failed!"
	EOF makepkg -sic --noconfirm --needed
	mv *.pkg.* $DEVDIR/../
	rm -rf $RMFILES
	cd $DEVDIR		
done
print All packages have been built!
