# Source install.sh to get the dependency list
PREBUILT="dayplanner perl-any-moose perl-date-holidayparser perl-devel-overloadinfo perl-module-runtime-conflicts perl-moose openbox-patched"
echo "Are you sure you want to uninstall all the dependencies + configs? [Y/n]"
read input
if [ "x$input" != "x" ]; then
	if [ "x$input" != "xy" ]; then
		exit 1
	fi
fi
source install.sh --source
sudo pacman --noconfirm -Rsc $CORE_DEPENDENCIES $DEPENDENCIES \
		$THEME_DEPENDENCIES $DESKTOP_THEME_TOOLS $GNOME_DEPENDENCIES $EXTRAS $PREBUILT
rm -rf ~/.config/tint2 ~/.config/openbox ~/.config/gtk-3.0 \
		~/Pictures/wallpaper ~/.themes/Arc-Dark ~/.Xdefaults ~/.gtkrc-2.0 ~/.xinitrc
echo "Done!"
