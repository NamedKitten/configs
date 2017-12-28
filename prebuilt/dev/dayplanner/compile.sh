# Install build requirements
sudo pacman --noconfirm -S perl-cpan-meta-check perl-class-load perl-class-load-xs perl-devel-globaldestruction \
		perl-devel-stacktrace perl-eval-closure perl-mro-compat \
		perl-package-deprecationmanager perl-sub-name perl-test-fatal perl-mouse gtk2-perl \
		perl-test-requires perl-file-find-rule perl-role-tiny perl-test-deep perl-test-tester perl-test-warnings \
		cpanminus perl-locale-gettext
# The build routine
function broutine () {
	cd $1
	makepkg -f
	if [ "$?" = "0" ]; then
		sudo pacman -U *.pkg* --noconfirm
		mv *.pkg* $2
	else
		FAILED="$FAILED $1"
	fi
}
function bClean () {
	for item in $@; do
		cd $item
		rm -rf pkg src *.tar*
	done
}
ITEMS="dep/perl-module-runtime-conflicts ../perl-devel-overloadinfo ../perl-file-find-rule-perl ../perl-test-cleannamespaces ../perl-moose ../perl-any-moose \
	../perl-date-holidayparser"
for item in $ITEMS; do
	broutine $item ../../../../
done
broutine ../../ ../../
if [ "x$FAILED" != "x" ]; then
	echo "$FAILED failed to compile"
else
	echo Cleaning
	bClean $ITEMS ../../
fi
