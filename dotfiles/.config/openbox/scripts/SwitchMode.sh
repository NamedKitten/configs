function SwitchGTK3Theme () {	
	function WriteGTK3Conf () {
		mkdir -p $HOME/.config/gtk-3.0/settings.ini
		echo "[Settings]" > $HOME/.config/gtk-3.0/settings.ini
		echo "gtk-theme-name=$@" >> $HOME/.config/gtk-3.0/settings.ini

	}
	if [ -f "$HOME/.config/gtk-3.0/settings.ini" ]; then
		if [ "x`grep -R gtk-theme-name $HOME/.config/gtk-3.0/settings.ini `" != "x" ]; then
			sed -i "/gtk-theme-name=/c\gtk-theme-name=$@" $HOME/.config/gtk-3.0/settings.ini
		else
			WriteGTK3Conf $@
		fi
	else
		WriteGTK3Conf $@
	fi

}
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
	elif [ "x`grep -R "KvArcDark" $HOME/.config/openbox/rc.xml`" != "x" ]; then
		RWORD=KvArcDark
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
	gtk-theme-switch2 /usr/share/themes/Arc-Dark/
	SwitchGTK3Theme Arc-Dark
	SwitchRofiTheme rofi_dark
	SwitchOpenboxTheme KvArcDark	
elif [ "x$1" = "xlight" ]; then
	# light
	echo Light mode
	feh --bg-fill ~/Pictures/wallpaper/wallpaper_light.jpg
        # Switch GTK+ theme	
	gtk-theme-switch2 /usr/share/themes/Adapta/
	SwitchRofiTheme rofi_light
	SwitchGTK3Theme Adapta
	SwitchOpenboxTheme Adapta
fi
