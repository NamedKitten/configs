#!/bin/sh
source ./install.sh --source
print Copying mirrorlist to mirrorlist.bak..
EOF sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
print Ranking mirrors..
rankmirrors -n 6 /etc/pacman.d/mirrorlist.bak | sudo tee /etc/pacman.d/mirrorlist > /dev/null
print Updating the db..
sudo pacman -Sy
print Done!
