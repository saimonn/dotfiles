set et si
set ts=2
set hlsearch
syntax on
set relativenumber

filetype plugin indent on
au BufNewFile,BufRead *.pp  setlocal kp=pi

runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
call pathogen#helptags()
