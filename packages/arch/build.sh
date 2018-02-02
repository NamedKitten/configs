#!/bin/bash
# Print errors in red
printError () {
	echo -e "\n${RED}===> $@${NC}\n"
}
# Print with colors
print () {
	echo -e "\n${BLUE}===> $@${NC}\n"
}
# Exit On Fail
EOF () {
	$@
	exitcode=$?
	if [ $exitcode != 0 ]; then
		if [ "$ERRMSG" ]; then
			printError "$ERRMSG"
		else 
			printError "Command: '$@' failed!"
		fi
		exit $exitcode
	fi
}
DEVDIR=`pwd`
for PKGdir in `find . -name "PKGBUILD" -execdir "pwd" \;`; do 	
	cd $PKGdir
	print "Building in $PKGdir"
	ERRMSG="Building in '$PKGdir' failed!"
	EOF makepkg -sic --noconfirm --needed
	rm -rf i3lock-color trizen toilet*.tar.gz cava *pkg*
	cd $DEVDIR		
done
