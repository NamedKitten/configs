#!/usr/bin/env bash
set -e
echo "==> Building packages"
bash ./scripts/install/packages/archlinux/build.sh
echo "==> Installing packages"
trizen --needed --noconfirm -S aspell-en pkgfile base-devel \
            polybar toilet cava-git
echo "==> Preparing dotfiles"
mkdir -p $HOME/.config/
cp dotfiles/.bashrc "$HOME/.bashrc"
cp -R dotfiles/.config/* "$HOME/.config/"

