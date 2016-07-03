""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                 Stuff From Example Vimrc                 "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect
set nocompatible
" allow backspacing over everything in insert mode
set backspace=indent,eol,start

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                         My Stuff                         "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set how many lines of history vim must remember
set history=1000

" Enables syntax highlighting
syntax enable
" Updates the swap file if nothing is typed after x milliseconds
" I set it to 5 minutes
set updatetime=30000

" Show relative line numbers because it makes prefixing a command easier,
" but still supports things like [lineNumber]G which I only really use
" if I get an error.
" set relativenumber
set number
set relativenumber
" Highlight the cursor line
" set cul
" Highlight results for your search while you're typing
set incsearch
" Set folding style (so you can use {{{ and }}} to make folds)
set foldmethod=marker
" Set a line at the 80th character for code style stuff
set colorcolumn=80
" Set the tab width to 4 spaces
set tabstop=4
" Set the auto indent (includes >>) width
set shiftwidth=4
" Use multiple of shiftwidth when indenting with '<' and '>'
set shiftround
" Makes coding much more comfortable as you no longer have to hit tab 5 times
" every time you open a new line
set autoindent
" When creating verical splits (:vsplit), put the new window on the right
set splitright
" When creating horizontal splits (:split), put the new window below
set splitbelow
" Tell vim where to look for tags to make this work you also need to use the command
" $ ctags -R -f ~/.vim/systags /usr/include /usr/local/include
set tags+=~/.vim/systags
" Allow omnicompletion because it's pretty sick even if it doesn't always work
" Languages that work out of the box: SQL, HTML, CSS, JS, PHP.
" C and PHP will also take advantage of tags files.
" Keyboard shortcut is C-x C-o
filetype plugin on
set omnifunc=syntaxcomplete#Complete

" Display tabs
set list
set listchars=tab:\|\ 
" Explanation of regexes below {{{
" \(\\\)\@<! matches any rest of regex not after '\' (at least it's supposed to)
" \s\+ matches one or more whitespace chars
" \%#\@<!$ matches any end of line NOT after the
" cursor position
" }}}
" match Error /\s\+\%#\@<!$/
" Matches any whitespace at the end of a line that is not preceded by
" an \ to escape it and does not have the cursor on it.
" match Error /\(\\\)\@<!\s\+\%#\@<!$/
" needs to be fixed. Currently does not work :'(
match Error /\(\\\)\@<!\s\+\%#\@<!$/
" Matches any whitespace at the end of a line that does not
" have the cursor on it. This is to show escaped trailing whitespace.
" match Visual /\(\\\)\@<=\s\+\%#\@<!$/
match Visual /\(\\\)\@<=\s\%#\@<!$/

" beefier 'syntax enable'?
" filetype plugin on

" Allow base16 to use the extra colours
let base16colorspace=256
" Set the colorcscheme
colorscheme base16-ocean

hi User1 ctermbg=18 ctermfg=7
hi User2 ctermbg=19 ctermfg=7
hi User3 ctermbg=8 ctermfg=7

function Modified()
	if &modified ==# 1
		return " [+] "
	elseif &modified ==# 0
		return ""
	endif
endfunction


" Always show the status bar
set laststatus=2
" Filename, file type, modified flag
set statusline=%3*\ %f\ %*
set statusline+=%2*\ %y\ %*
" Left/right separator
set statusline+=%1*%=%*
set statusline+=%2*%{Modified()}%*
" Cursor line number / total lines
set statusline+=%3*\ %l/%L\ %*

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                     Hard Mode Stuff!                     "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Unbind the arrow keys for insert mode
inoremap <Up> <NOP>
inoremap <Down> <NOP>
inoremap <Left> <NOP>
inoremap <Right> <NOP>
" Unbind the arrow keys hjkl for normal mode too
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
" noremap h <NOP>
" noremap j <NOP>
" noremap k <NOP>
" noremap l <NOP>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"         How To Get This Vimrc to Work With Sudo          "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Dont know if the command below is ever worth using. I don't think that
" folder is used
" sudo cp -vR ~/.vim /usr/share/vim

" These 2 commands are what you want. The first gives your substitute user
" your colorschemes. The second gives your substitute user your vimrc. Be
" careful with it though. Be sure to. read /etc/vimrc before you
" run that command.

" sudo cp -vR ~/.vim/colors/* /usr/share/vim/vim74/colors
" sudo sh -c 'cat /home/me/.vimrc | cat >/etc/vimrc'
