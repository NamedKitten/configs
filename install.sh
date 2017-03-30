#!/bin/sh
FILE_DIR=`pwd`/files/configs
WALL_DIR=`pwd`/files/wallpaper
mkdir ~/Pictures/wallpaper
rm -rf ~/.config/openbox ~/.config/nitrogen
cp -r $FILE_DIR/openbox ~/.config/
cp -r $FILE_DIR/nitrogen ~/.config
cp $WALL_DIR/* ~/Pictures/wallpaper/
openbox --reconfigure
