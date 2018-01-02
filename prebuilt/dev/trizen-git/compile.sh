sudo pacman -S diffutils git pacman pacutils perl-data-dump perl-json perl-libwww perl-lwp-protocol-https perl-term-ui perl perl-json-xs perl-term-readline-gnu --noconfirm
makepkg
if [ "$?" = "0" ]; then
	sudo pacman -U *.pkg* --noconfirm
	mv *.pkg* ../../
	rm -rf trizen pkg src *.tar* README.md
else
	echo Compiling trizen-git failed
fi
