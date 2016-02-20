""""""""""""""""""""""""""""""""""
"    Stuff From Example Vimrc    "
""""""""""""""""""""""""""""""""""

" Use Vim settings, rather than Vi settings (much better!).       
" This must be first, because it changes other options as a side effect
set nocompatible 
" allow backspacing over everything in insert mode
" set backspace=indent,eol,start

""""""""""""""""""""""""""""""""""
"            My Stuff            "
""""""""""""""""""""""""""""""""""

" Set how many lines of history vim must remember
set history=1000

" Enables syntax highlighting
syntax enable

" Show relative line numbers because it makes prefixing a command easier,
" but still supports things like [lineNumber]G which I only really use
" if I get an error.
set relativenumber
" Highlight the cursor line
" set cul
" Highlight results for your search while you're typing
set incsearch
" Set folding style
set foldmethod=marker
" Set a line at the 100th character for code style stuff
" set colorcolumn=100

" beefier 'syntax enable'?
" filetype plugin on

" Set the colorcscheme
colorscheme ryuuko

""""""""""""""""""""""""""""""""""
"        Hard Mode Stuff!        "
""""""""""""""""""""""""""""""""""

" unbind the arrow keys for insert mode
inoremap <Up> <NOP>
inoremap <Down> <NOP>
inoremap <Left> <NOP>
inoremap <Right> <NOP>
" Unbind the arrow keys hjkl for normal mode too
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
noremap h <NOP>
noremap j <NOP>
noremap k <NOP>
noremap l <NOP> 

"""""""""""""""""""""""""""""""""""""""""""""""""
"    How To Get This Vimrc to Work With Sudo    "
"""""""""""""""""""""""""""""""""""""""""""""""""

" Dont know if the command below is ever worth using. I don't think that folder is used
" sudo cp -vR ~/.vim /usr/share/vim

" These 2 commands are what you want. The first gives your substitute user your colorschemes
" The second gives your substitute user your vimrc. Be careful with it though. Be sure to
" read /etc/vimrc before you run that command

" sudo cp -vR ~/.vim/colors/* /usr/share/vim/vim74/colors
" sudo sh -c 'cat /home/me/.vimrc | cat >/etc/vimrc'
