#!/bin/sh
# Source install.sh for EOF
source ./install.sh --source
rm -rf prebuilt/*pkg*
cd prebuilt/dev
DEVDIR=`pwd`
RMFILES="dayplanner-0.11.tar.bz2 Any-Moose-0.26.tar.gz Date-HolidayParser-0.41.tar.gz Devel-OverloadInfo-0.004.tar.gz File-Find-Rule-Perl-1.15.tar.gz \
	Module-Runtime-Conflicts-0.003.tar.gz Moose-2.2009.tar.gz Test-CleanNamespaces-0.16.tar.gz i3lock-fancy folder-color-nautilus-bzr \
	nautilus-open-terminal obconf openbox-menu-0.8.0.tar.bz2 openbox fonts trizen"
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
