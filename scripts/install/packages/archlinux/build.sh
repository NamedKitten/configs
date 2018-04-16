#!/usr/bin/env bash
set -e
cd ./scripts/install/packages/archlinux/trizen-git
echo "==> Building trizen"
makepkg -sic --noconfirm --needed
rm -rf trizen *pkg*
