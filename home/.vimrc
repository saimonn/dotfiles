set si
set sw=2
set ts=2
set modeline
set hlsearch
syntax on
set number

" https://bepo.fr/wiki/Vim
"set listchars=nbsp:¤,tab:>-,trail:¤,extends:>,precedes:<
"set list

"let g:airline#extensions#tabline#enabled = 1
let g:vim_json_syntax_conceal = 0

filetype plugin indent on
au BufNewFile,BufRead *.pp  setlocal kp=pi

runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
call pathogen#helptags()

"set cursorline cursorcolumn
:hi CursorLine   cterm=NONE ctermbg=DarkBlue ctermfg=white guibg=darkred guifg=white
:hi CursorColumn cterm=NONE ctermbg=DarkBlue ctermfg=white guibg=darkred guifg=white

" It is useful to toggle highlighting on and off by pressing one key
nnoremap H :set cursorline! cursorcolumn!<CR>

" Search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

