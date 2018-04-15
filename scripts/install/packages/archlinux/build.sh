#!/usr/bin/env bash
set -e
cd trizen-git
echo "==> Building trizen"
makepkg -sic --noconfirm --needed
rm -rf trizen *pkg*
