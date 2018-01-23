#!/bin/sh
if [ ! -f install.sh ] && [ ! -f ../install.sh ]; then
        echo Error: install.sh is missing
        exit 1
fi
if [ -f install.sh ]; then
        install_sh="./install.sh"
else
        install_sh="../install.sh"
fi
EOR
ask_sudo
print Copying mirrorlist to mirrorlist.bak..
EOF sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
print Ranking mirrors..
rankmirrors -n 6 /etc/pacman.d/mirrorlist.bak | sudo tee /etc/pacman.d/mirrorlist > /dev/null
print Updating the db..
sudo pacman -Sy
print Done!
