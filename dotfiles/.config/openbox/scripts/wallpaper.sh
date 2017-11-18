# Change wallpaper on time 
# If the time is 8 PM and up then change to the dark wallpaper
# if the time is 6 AM and up then change to the light wallpaper
while true; do
	T=`date +%H`
	if [ "x$T" != "x$OLDT" ]; then
		if [ "$T" -gt "19" ]; then
			echo dark time!
			feh --bg-fill ~/Pictures/wallpaper/wallpaper_dark.jpg
		elif [ "$T" -gt "6" ]; then
			echo light time!
			feh --bg-fill ~/Pictures/wallpaper/wallpaper_light.jpg
		fi
		OLDT=$T
	fi
	sleep 300
done
