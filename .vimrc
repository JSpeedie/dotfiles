" ~/.config/nvim/lua/config/init.lua   < neovim specific config

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Set how many lines of history vim must remember
set history=1500

" Disable the mouse jeez
set mouse=

" Show line numbers
set number
" Make line numbers relative
set relativenumber

" TODO:
" Enables syntax highlighting
" syntax enable

" Updates the swap file if nothing is typed after x milliseconds
" I set it to 5 minutes
set updatetime=30000

" Display tabs as 4 spaces
set tabstop=4
" Set the auto indent (includes >>) width
set shiftwidth=4
" Each press of the tab key gives you a 4 space indent, which, if you
" set tabstop to the same value, gives you your full tab size
set softtabstop=4
" Use multiple of shiftwidth when indenting with '<' and '>'
set shiftround
" TODO:
" Makes coding much more comfortable as you no longer have to hit tab 5 times
" every time you open a new line
"set autoindent

" Show a few lines of context around the cursor after certain moves (affects
" H, L, zt, zb, /, etc.)
set scrolloff=3
" Make the minimum horizontal scroll increment 1 column so we can perform 1
" column side-scrolls
set sidescroll=1
" Ensure there is always 2 columns on the left or right of the cursor. The
" `sidescrolloff` setting below (paired with the `sidescroll` setting above)
" solve the problem of using `$` on a line that is wider than your screen and
" seeing your `listchars` `extends` character rather than the final character
" of the line.
set sidescrolloff=2

" Have a block cursor instead of a line cursor when in insert mode
set guicursor = ""

" Don't highlight search results
set nohlsearch
" Highlight the nearest result for your search as you type it (default is to
" not highlight anything at all in the code as you construct your search)
set incsearch

" Don't wrap lines when displaying them on windows that aren't wide enough
set nowrap

" Set folding style (so you can use {{{ and }}} to make folds)
set foldmethod=marker

" Highlight the cursor line
set cursorline
" Set default column line at the 80th character for code style stuff. This
" should ideally change based on the type of file, but this is the default if
" no rule is set for the currently open file type.
set colorcolumn=80
" Set a line at the 100th character for Rust (following the formatting
" conventions specified in The Book)
autocmd FileType rust setlocal colorcolumn=100
" Set a line at the 79th character for C (following PEP7 and GNU's standards)
autocmd FileType c setlocal colorcolumn=79
" Set a line at the 100th character for java (checkstyle)
autocmd FileType java setlocal colorcolumn=100
" Set a line at the 100th character for html and php
autocmd FileType html setlocal colorcolumn=100
autocmd FileType php setlocal colorcolumn=100

" When creating verical splits (:vsplit), put the new window on the right
set splitright
" When creating horizontal splits (:split), put the new window below
set splitbelow

" Mark whitespace characters with specific symbols to make them easier to see
set list
set listchars=tab:\|\ ,eol:$,space:·,extends:⟩,precedes:⟨

" Set to less laggy regex engine
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

""""""""""""""""""""""""""""""""""""""""""""""
" Vim remembers last cursor position in file "
""""""""""""""""""""""""""""""""""""""""""""""
" {{{
" Note: Only do this part when Vim was compiled with the +eval feature.
" Change to `if 0` to quickly disable
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
" }}}

""""""""""""""""""""""""""""""""""""""""""
" Undo files but with a session boundary "
""""""""""""""""""""""""""""""""""""""""""
" {{{
" Change to `if 0` to quickly disable
if 1
  " Enable undo files
  set undofile
  set undodir=~/.vim/undo
  " On opening a file, mark the most recent undo as the boundary for the session
  " in the undo tree
  augroup SessionUndoBoundary
    autocmd!
    " If an undo file for the file exists, save the most recent undo sequence
    " number as the boundary marking the end of the current session's undo
    " history
    autocmd BufWinEnter *
      \ if &undofile
        \ | let b:session_seq = undotree().seq_last
      \ | endif
  augroup END
  function! SessionUndo()
    let ut = undotree()

    " No boundary stored (new file etc.)
    if !exists('b:session_seq')
      return 'u'
    endif

    " If we're already in the undo history prior to the current session
    if ut.seq_cur < b:session_seq
        echo "ut.seq_cur:" . ut.seq_cur . " and b:session_seq:" . b:session_seq
      " Undo normally
      return 'u'
    endif

    " If we're still in the undo history of the current session
    if ut.seq_cur > b:session_seq
      echo "ut.seq_cur:" . ut.seq_cur . " and b:session_seq:" . b:session_seq
      " Undo normally
      return 'u'
    endif

    " TODO: This `for` block below is ChatGPT generated. I don't exactly know
    " what it accomplishes or if it covers all cases

    " Find parent of current node
    for entry in ut.entries
      if entry.seq == ut.seq_cur
        if has_key(entry, 'alt')
          let parent = entry.alt[0]
        else
          let parent = entry.seq - 1
        endif
        break
      endif
    endfor

    " If the parent node of the current node is from a previous session
    if parent < b:session_seq
      " Confirm if we want to undo past our current session
      let choice = confirm(
          \ "Undo into previous session?", "&Yes\n&No", 2)

      " If the user chose not to undo into the next session
      if choice != 1
        " Do not undo normally
        return ''
      endif
    endif

    return 'u'
  endfunction

  nnoremap <expr> u SessionUndo()
endif
" }}}

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
"         How To Get This Vimrc to Work With Sudo          "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" These 2 commands are what you want. The first gives your substitute user
" your colorschemes. The second gives your substitute user your vimrc. Be
" careful with it though. Be sure to. read /etc/vimrc before you
" run that command.

" sudo cp -vR ~/.vim/colors/* /usr/share/vim/vim80/colors
" sudo sh -c 'cat /home/me/.vimrc | cat >/etc/vimrc'
