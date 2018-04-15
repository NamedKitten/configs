#!/usr/bin/env bash
set -e
trap "echo '==> Command failed to execute!'; exit 1" ERR
echo "==> Fixing audio"
if [ "$(grep "load-module module-udev-detect tsched=0" /etc/pulse/default.pa)" = "" ]; then
	sudo sed -i "s/load-module module-udev-detect/load-module module-udev-detect tsched=0/g" /etc/pulse/default.pa
fi
if [ ! -f .ic ]; then
	bash install.sh
	touch .ic
fi
echo "==> Copying system configs"
for file in system/arch/etc/*; do 
		sudo cp $file /etc/$(basename $file)
done
sudo cp system/etc/dnsmasq.conf /etc/dnsmasq.conf
sudo cp system/etc/resolv.dnsmasq /etc/resolv.dnsmasq
echo "==> Installing packages"
sudo pacman -S nvidia-dkms lib32-nvidia-utils opencl-nvidia \
		nvidia-settings dnsmasq \
		linux-headers steam steam-native-runtime weechat bitlbee \
		--noconfirm --needed
trizen -S r8168-dkms all-repository-fonts --noconfirm --needed
echo "==> Blacklisting the r8169 module"
echo blacklist r8169 | sudo tee /etc/modprobe.d/ethernet.conf > /dev/null
echo "==> Enabling services"
sudo systemctl enable dnsmasq
sudo systemctl enable dhcpcd
if [ ! -d "$HOME/bin" ]; then
	echo "==> Preparing $HOME/bin"
	git clone https://github.com/tim241/bin "$HOME/bin"
fi
echo "==> Enabling network time"
sudo timedatectl set-ntp true
