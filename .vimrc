""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                 Stuff From Example Vimrc                 "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect
set nocompatible
" allow backspacing over everything in insert mode
" set backspace=indent,eol,start

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

" Display tabs
set list
set listchars=tab:\|\ 
" {{{ Explanation of regexes below
" \s\+ matches one or more whitespace chars
" \%# matches cursor position
" \@<! (plus the surrounding atoms) matches any end of line NOT after the
" cursor position
" match Error /\s\+\%#\@<!$/
" }}}
" Matches any whitespace at the end of a line that is not preceded by
" an \ to escape it and does not have the cursor on it.
match Error /\(\\\)\@<!\s\+\%#\@<!$/
" Matches any whitespace at the end of a line that does not
" have the cursor on it. This is to show escaped trailing whitespace.
match Visual /\(\\\)\@<=\s\+\%#\@<!$/

" beefier 'syntax enable'?
" filetype plugin on

" Allow base16 to use the extra colours
let base16colorspace=256
" Set the colorcscheme
colorscheme base16-ocean

hi User1 ctermbg=black ctermfg=black guibg=green guifg=red
hi User2 ctermbg=gray ctermfg=black guibg=green guifg=red
hi User3 ctermbg=lightgray ctermfg=black guibg=blue guifg=green
hi User4 ctermbg=red ctermfg=black guibg=red guifg=black

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
set statusline=%2*\ %f\ %*
set statusline+=%3*\ %y\ %*
" set statusline+=%4*\ %m\ %*
set statusline+=%4*%{Modified()}%*
" Left/right separator
set statusline+=%1*%=%*
" Cursor line number / total lines
set statusline+=%2*\ %l/%L\ %*

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
