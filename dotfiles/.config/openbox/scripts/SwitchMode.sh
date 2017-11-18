function SwitchRofiTheme () {
	if [ "x`grep -R "rofi_dark" $HOME/.config/openbox/rc.xml`" != "x" ]; then
		RWORD=rofi_dark
	elif [ "x`grep -R "rofi_light" $HOME/.config/openbox/rc.xml`" != "x" ]; then
		RWORD=rofi_light
	elif [ "x`grep -R "rofi" $HOME/.config/openbox/rc.xml`" != "x" ]; then
		RWORD=rofi
	fi
	if [ "x$1" != "x" ]; then
		sed -i "s/$RWORD/$1/g" $HOME/.config/openbox/rc.xml
	fi
	openbox --reconfigure
}


if [ "x$1" = "xdark" ]; then
	# dark
	echo Dark mode
	feh --bg-fill ~/Pictures/wallpaper/wallpaper_dark.jpg
	SwitchRofiTheme rofi_dark	
elif [ "x$1" = "xlight" ]; then
	# light
	echo Light mode
	feh --bg-fill ~/Pictures/wallpaper/wallpaper_light.jpg
	SwitchRofiTheme rofi_light
fi
