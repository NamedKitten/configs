#!/bin/sh
set -e
if [ "$UID" = "0" ]; then
	echo "Do not run this script as root!"
	exit 1
fi
KS=true
function print {
	echo "===> $@"
}
function sr {
	sudo rc-update add $@
}
function UserToGroups {
	for group in $@; do
		sudo gpasswd -a $USER $group
	done
}
function keep_sudo {
	while [ "$KS" = "true" ]; do
		sudo -v
		sleep 20
	done	
}
print "Installing openrc packages.."
sudo pacman -S js185 --noconfirm
keep_sudo &
trizen -S openrc-git openrc-arch-services-git net-tools consolekit-git --noconfirm 
print "Enabling openrc services.."
sr dhcpcd default
sr alsa default
sr udev sysinit
sr syslog-ng default
sr cronie default
sr dbus default
print "Adding user to required groups.."
UserToGroups audio video dbus wheel
KS=false
