#!/bin/sh
SCRIPT_DIR=`dirname "$0"`
CONF_DIR=$SCRIPT_DIR/files/configs
WALL_DIR=$SCRIPT_DIR/files/wallpaper
mkdir ~/Pictures/wallpaper/
cp $WALL_DIR/*  ~/Pictures/wallpaper/
cd $CONF_DIR
for dir in * ; do
	rm -rf ~/.config/$dir
	cp -r $dir ~/.config/
done
