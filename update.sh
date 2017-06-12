#!/bin/sh
SCRIPT_DIR=`dirname "$0"`
CONF_DIR=$SCRIPT_DIR/files/configs
if [ ! $1 ]; then
	echo "Usage: sh update.sh [conf1] [conf2] "
	echo "Example usage: sh update.sh openbox "
fi
for conf_dir in $@ ; do
	if [ -d $CONF_DIR/$conf_dir ]; then
		rm -rf $CONF_DIR/$conf_dir
	fi
	cp -r ~/.config/$conf_dir $CONF_DIR/
done
