set et si
set ts=2
set hlsearch
syntax on
set number

filetype plugin indent on
au BufNewFile,BufRead *.pp  setlocal kp=pi

runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
call pathogen#helptags()

set cursorline cursorcolumn
:hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
:hi CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white

" It is useful to toggle highlighting on and off by pressing one key
nnoremap H :set cursorline! cursorcolumn!<CR>

