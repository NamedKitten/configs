#!/bin/sh
if [ ! $2 ]; then
	echo Error: Missing arguments!
	echo Example: $0 [wallpaper] [theme_name]
	exit 1
fi
function execx () {
	$@
	exitcode=$?
	if [ "$exitcode" != "0" ]; then
		echo Error: "$@" failed
		exit $exitcode
	fi
}
WALLPAPER=$1
THEME=$2
if [ -d "$HOME/.config/tim241/themes/$THEME" ]; then
	rm -rf $HOME/.config/tim241/themes/$THEME
fi
echo Creating directories..
execx mkdir "$HOME/.config/tim241/themes/$THEME" "$HOME/.config/tim241/themes/$THEME/gtk" "$HOME/.config/tim241/themes/$THEME/gtk/gtk3" "$HOME/.config/tim241/themes/$THEME/wallpaper"
echo Generating color scheme using pywal..
execx wal -i $WALLPAPER -c
echo Copying wallpaper..
execx cp $WALLPAPER $HOME/.config/tim241/themes/$THEME/wallpaper/
echo Creating Xdefaults..
execx cp $HOME/.cache/wal/colors.Xresources $HOME/.config/tim241/themes/$THEME/Xdefaults
cat $HOME/.cache/wal/colors-rofi.Xresources >> $HOME/.config/tim241/themes/$THEME/Xdefaults
echo Done

