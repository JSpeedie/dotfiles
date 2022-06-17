" ~/.config/nvim/init.vim   < neovim specific config
"
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
set number
set relativenumber
" Show a few lines of context around the cursor (affects H, L, zt, zb, /, etc.)
set scrolloff=3
" Highlight the cursor line
set cursorline
" Highlight results for your search while you're typing
set incsearch
" Set folding style (so you can use {{{ and }}} to make folds)
set foldmethod=marker
" Set a line at the 80th character for code style stuff
set colorcolumn=80
" Set a line at the 79th character for C (following PEP7 and GNU's standards)
autocmd FileType c setlocal colorcolumn=79
" Set a line at the 100th character for java (checkstyle)
autocmd FileType java setlocal colorcolumn=100
" Set a line at the 100th character for html and php
autocmd FileType html setlocal colorcolumn=100
autocmd FileType php setlocal colorcolumn=100
" Set the tab width to 4 spaces
set tabstop=4
" Set the auto indent (includes >>) width
set shiftwidth=4
" Use multiple of shiftwidth when indenting with '<' and '>'
set shiftround
" Makes coding much more comfortable as you no longer have to hit tab 5 times
" every time you open a new line
set autoindent
" Allows proper use of zh and zl
set nowrap
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
set listchars=tab:\|\ ,eol:$,space:·,extends:⟩,precedes:⟨

" Set too less laggy regex engine
set regexpengine=1

" Explanation of regexes below {{{
" \\ matches a '\'. Used for matching an escaped or non escaped whitespace char
" \@<! NOT anything before this atom. For example, NOT \ (non escaped)
" \zs anything before this atom. For example, \ (escaped)
" \s\+ matches one or more whitespace chars
" \%# vim atom for cursor position
" \@<! NOT anything before this atom. For example, NOT \%# (not cursor position)
" $ matches the end of a line
" }}}

" Matches trailing whitespace that is not escaped and not at the cursor
call matchadd('Error', '\\\@<!\s\+\%#\@<!$')
" Matches an escaped whitespace character that is not at the cursor
call matchadd('Visual', '\\\zs\s\%#\@<!$')

" Theme
syntax on
" for vim 7
set t_Co=256

" for vim 8
if (has("termguicolors"))
	set termguicolors
endif

" Only do this part when Vim was compiled with the +eval feature.
if 1
	" Put these in an autocmd group, so that you can revert them with:
	" ":augroup vimStartup | exe 'au!' | augroup END"
	augroup vimStartup
		au!

		" When editing a file, always jump to the last known cursor position.
		" Don't do it when the position is invalid, when inside an event handler
		" (happens when dropping a file on gvim) and for a commit message (it's
		" likely a different one than last time).
		autocmd BufReadPost *
			\ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
			\ |	 exe "normal! g`\""
			\ | endif

	augroup END
endif

" syntax on
"let g:sierra_Sunset = 1

" Darker bg with darker fg (used for middle section of status line
" which has no text)
hi User1 ctermbg=0 ctermfg=15
" Used for file type of status line
" Medium bg with darker fg
hi User2 ctermbg=0 ctermfg=15
" Used for file name of status line
" Should be the lightest bg colour with brightest fg
hi User3 ctermbg=0 ctermfg=15

function! Modified()
	if &modified ==# 1
		return " [+] "
	elseif &modified ==# 0
		return ""
	endif
endfunction

function! GetSyntaxID()
    return synID(line('.'), col('.'), 1)
endfunction

function! GetSyntaxParentID()
    return synIDtrans(GetSyntaxID())
endfunction

function! GetSyntax()
    echo synIDattr(GetSyntaxID(), 'name')
    exec "hi ".synIDattr(GetSyntaxParentID(), 'name')
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
" Pseudo fix for delayed 'O' in normal mode following a C-[ input
set timeout timeoutlen=1000 ttimeoutlen=100

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"          Zoomy Goomy No Longer Vanilla Stuff :(          "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd FileType c noremap ;p oprintf("\n");<Esc>F\i
autocmd FileType java noremap ;p iSystem.out.println("");<Esc>F"i
autocmd FileType latex noremap ;c i\begin{lstlisting}<Enter>\end{lstlisting}<Enter><#^#><Esc>kO
" Code for markdown
autocmd FileType markdown noremap ;c i```<Enter>```<Esc>O
" Code for latex
" bold for markdown and latex
" italics for markdown and latex

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                     Hard Mode Stuff!                     "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Unbind the arrow keys for insert mode
inoremap <Up> <NOP>
inoremap <Down> <NOP>
inoremap <Left> <NOP>
inoremap <Right> <NOP>
" Unbind the arrow keys and hjkl for normal mode too
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"         How To Get This Vimrc to Work With Sudo          "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" These 2 commands are what you want. The first gives your substitute user
" your colorschemes. The second gives your substitute user your vimrc. Be
" careful with it though. Be sure to. read /etc/vimrc before you
" run that command.

" sudo cp -vR ~/.vim/colors/* /usr/share/vim/vim80/colors
" sudo sh -c 'cat /home/me/.vimrc | cat >/etc/vimrc'
