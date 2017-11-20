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
}

function SwitchOpenboxTheme () {
	if [ "x`grep -R "Adapta" $HOME/.config/openbox/rc.xml`" != "x" ]; then
		RWORD=Adapta
	elif [ "x`grep -R "Numix" $HOME/.config/openbox/rc.xml`" != "x" ]; then
		RWORD=Numix
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
	# Switch GTK+ theme
	gtk-theme-switch2 /usr/share/themes/VimixDark/
	SwitchRofiTheme rofi_dark
	SwitchOpenboxTheme Numix	
elif [ "x$1" = "xlight" ]; then
	# light
	echo Light mode
	feh --bg-fill ~/Pictures/wallpaper/wallpaper_light.jpg
        # Switch GTK+ theme	
	gtk-theme-switch2 /usr/share/themes/Adapta/
	SwitchRofiTheme rofi_light
	SwitchOpenboxTheme Adapta
fi
