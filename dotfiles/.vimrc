" Required stuff for the plugins/Vundle
set nocompatible 
filetype off

" Enable syntax color
syntax on

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
" Clang complete for C/C++ code completion
Plugin 'Rip-Rip/clang_complete'
" Better colors for C/C++ code
Plugin 'jeaye/color_coded'

call vundle#end()
" Required stuff
filetype plugin indent on
let g:color_coded_enabled = 1
