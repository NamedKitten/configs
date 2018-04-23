#!/usr/bin/env bash
set -e
BDIR="$(pwd)"
trap "echo '==> Command failed to execute!'; exit 1" ERR
cp dotfiles/.vimrc ~/.vimrc
if command -v vim-huge > /dev/null 2>&1; then
    vim=$(which vim-huge)
elif command -v vim > /dev/null 2>&1; then
    vim=$(which vim)
else
    exit 1
fi
if [ -d "$HOME/.vim/bundle" ]; then
    exit
fi
mkdir -p ~/.vim/bundle/
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
git clone https://github.com/jeaye/color_coded ~/.vim/bundle/color_coded
git clone https://github.com/Rip-Rip/clang_complete ~/.vim/bundle/clang_complete
cd ~/.vim/bundle/color_coded
mkdir build && cd build && cmake .. -DDOWNLOAD_CLANG=0
make -j5
make install -j5
make clean
cd ~/.vim/bundle/clang_complete
"$vim" +PluginInstall +qa!
make
"$vim" clang_complete.vmb -c 'so %' -c 'qa!'
cd "$BDIR"
