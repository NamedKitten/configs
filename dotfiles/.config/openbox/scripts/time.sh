# Change theme on time 
# If the time is 8 PM and up then change to the dark wallpaper
# if the time is 6 AM and up then change to the light wallpaper
while true; do
	T=`date +%H`
	if [ "x$T" != "x$OLDT" ]; then
		if [ "$T" -gt "19" ]; then
			$HOME/.config/openbox/scripts/SwitchMode.sh dark
			# Check if redshift is running
			if [ "x`ps aux | grep redshift-gtk | grep python`" = "x" ]; then
				redshift-gtk &			
			fi
		elif [ "$T" -gt "5" ]; then
			$HOME/.config/openbox/scripts/SwitchMode.sh light
			# Check if redshift is running
			if [ "x`ps aux | grep redshift-gtk | grep python`" != "x" ]; then
				killall redshift-gtk &		
			fi
		fi
		OLDT=$T
	fi
	sleep 300
done
