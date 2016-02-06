" Set how many lines of history vim must remember
set history=1000

" Enables syntax highlighting
syntax enable

" Show line numbers
set number
" Highlight the cursor line
"set cul
" Highlight results for your search while you're typing
set incsearch
" Set folding style
set foldmethod=marker
" Set a line at the 100th character for code style stuff
" set colorcolumn=100

" beefier 'syntax enable'?
"filetype plugin on

" Set the colorcscheme
colorscheme ryuuko

" Get the right color scheme thingy
" set background=dark
" let g:gruvbox_underline=1
" let g:gruvbox_bold=1
" let g:gruvbox_italic=1

""""""""""""""""""""""""""""""""""
"    Stuff From Example Vimrc    "
""""""""""""""""""""""""""""""""""

" Use Vim settings, rather than Vi settings (much better!).       
" This must be first, because it changes other options as a side effect
set nocompatible 
" allow backspacing over everything in insert mode
set backspace=indent,eol,start
" keep an undo file (undo changes after closing)
set undofile

"""""""""""""""""""""""""""""""""""""""""""""""""
"    How To Get This Vimrc to Work With Sudo    "
"""""""""""""""""""""""""""""""""""""""""""""""""

" sudo cp -vR ~/.vim /usr/share/vim
" sudo cp -vR ~/.vim/colors/* /usr/share/vim/vim74/colors
" sudo sh -c 'cat /home/me/.vimrc | cat >/etc/vimrc'
