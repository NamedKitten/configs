#!/bin/bash
if [ ! $2 ]; then
    echo Error: Missing arguments!
    echo Example: $0 [wallpaper] [theme_name] [transparency]
    exit 1
fi
if [ ! $3 ]; then
    TRANS=100
else
    TRANS=$3
fi
function execx {
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
execx mkdir "$HOME/.config/tim241/themes/$THEME" "$HOME/.config/tim241/themes/$THEME/gtk" "$HOME/.config/tim241/themes/$THEME/gtk/gtk3" \
        "$HOME/.config/tim241/themes/$THEME/wallpaper" "$HOME/.config/tim241/themes/$THEME/rofi"
echo Generating color scheme using pywal..
execx wal -i $WALLPAPER -c -a $TRANS -g
echo Copying wallpaper..
execx cp $WALLPAPER $HOME/.config/tim241/themes/$THEME/wallpaper/
echo Copying files..
execx cp $HOME/.cache/wal/colors.Xresources $HOME/.config/tim241/themes/$THEME/Xdefaults
execx cp $HOME/.cache/wal/colors-rofi-dark.rasi $HOME/.config/tim241/themes/$THEME/rofi/colors-rofi.rasi
execx cp $HOME/.cache/wal/sequences $HOME/.config/tim241/themes/$THEME/sequences
echo Done

