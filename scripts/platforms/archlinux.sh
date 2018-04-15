#!/usr/bin/env bash
set -e
echo "==> Building packages"
bash ./scripts/install/packages/archlinux/build.sh
echo "==> Installing packages"
trizen --needed --noconfirm -S xorg-server xorg-xinit xorg-xrandr xorg-xsetroot arandr \
        compton qt5ct qt5-styleplugins \
        pavucontrol gcolor2 aspell-en \
        vim perl-anyevent-i3 perl-json-xs pkgfile pulseaudio-alsa w3m adapta-gtk-theme \
	    firefox curl rofi i3-gaps clang cmake llvm rxvt-unicode ranger feh pulseaudio \
		alsa-utils lua w3m papirus-icon-theme scrot base-devel \
		betterlockscreen polybar toilet cava-git
echo "==> Preparing dotfiles"
 mkdir -p $HOME/.config/ $HOME/.themes/ $HOME/.weechat
echo "exec i3" > "$HOME/.xinitrc"
cp dotfiles/.bashrc "$HOME/.bashrc"
cp -R dotfiles/.weechat/* "$HOME/.weechat/"
cp -R dotfiles/.themes/* "$HOME/.themes/"
cp -R dotfiles/.config/* "$HOME/.config/"
if [ ! "$(grep 'qt5ct' /etc/environment)" ]; then
    echo "==> Making QT look like GTK+"
    echo QT_QPA_PLATFORMTHEME=qt5ct | sudo tee -a /etc/environment > /dev/null
fi
bash scripts/install/vim.sh
