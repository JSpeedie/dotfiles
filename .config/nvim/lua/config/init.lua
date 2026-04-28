require("config.lazy")
require("config.remap")

--
-- Neovim Configuration File Structure:
--
-- ~/.config/nvim/init.lua                   -- Base init file, mostly calls on the files below:
-- ~/.config/nvim/lua/config/init.lua        -- This file. The core, vim-y part of my config
-- ~/.config/nvim/lua/config/lazy.lua        -- Configure the plugin manager itself
-- ~/.config/nvim/lua/config/remap.lua       -- Keymap rebinds
-- ~/.config/nvim/lua/plugins/spec.lua       -- Contains the list of plugins I want and configures them
-- ~/.config/nvim/after/plugin/[plugin].lua  -- Individual plugin config for configs that need it
-- ~/.config/nvim/after/plugin/nvim-cmp.lua        -- Configuration for my autocomplete tool
-- ~/.config/nvim/after/plugin/nvim-lspconfig.lua  -- Configuration for my LSP stuff

-- Run ":Lazy sync" to install/update all plugins

-- Plugins are specified in ~/.config/nvim/lua/plugins/spec.lua
-- and then individually configured in their own lua files
-- (if necessary) in ~/.config/nvim/after/plugin/[plugin].lua

-- Set how many lines of history vim must remember
vim.g.history = 1500

-- Use full color range if the terminal supports it (IMPORTANT)
if vim.fn.has("termguicolors") == 1 then
	vim.opt.termguicolors = true
	-- Set the custom colorscheme
	vim.g.colors_name = 'ayu'
	vim.g.ayucolor = 'light' -- light, mirage or dark
else
	-- For some reason the lua version doesn't work
	-- vim.g.colors_name = 'elflord'
	-- vim.cmd[[colorscheme elflord]]
end

-- Set the leader key to space
vim.g.mapleader = " "

-- Disable the mouse, jeez
vim.opt.mouse = ""

-- Show line numbers
vim.opt.number = true;
-- Make line numbers relative
vim.opt.relativenumber = true;

-- Updates the swap file if nothing is typed after x milliseconds
-- I set it to 5 minutes
vim.opt.updatetime = 30000

-- Display tabs as 4 spaces
vim.opt.tabstop = 4
-- Set the auto indent (includes >>) width
vim.opt.shiftwidth = 4
-- Each press of the tab key gives you a 4 space indent, which, if you
-- set tabstop to the same value, gives you your full tab size
vim.opt.softtabstop = 4
-- Use multiple of shiftwidth when indenting with '<' and '>'
vim.opt.shiftround = true
-- Set tab values so that when editing HTML and LUA files tabs are converted
-- to 2 spaces
vim.cmd[[autocmd FileType html set tabstop=2 softtabstop=2 shiftwidth=2 expandtab]]
vim.cmd[[autocmd FileType lua set tabstop=2 softtabstop=2 shiftwidth=2 expandtab]]
-- TODO:
-- " Makes coding much more comfortable as you no longer have to hit tab 5 times
-- " every time you open a new line
-- vim.cmd[[set autoindent]]

-- Show a few lines of context around the cursor after certain moves (affects
-- H, L, zt, zb, /, etc.)
vim.opt.scrolloff = 3
-- Make the minimum horizontal scroll increment 1 column so we can perform 1
-- column side-scrolls
vim.opt.sidescroll = 1
-- Ensure there is always 2 columns on the left or right of the cursor. The
-- `sidescrolloff` setting below (paired with the `sidescroll` setting above)
-- solve the problem of using `$` on a line that is wider than your screen and
-- seeing your `listchars` `extends` character rather than the final character
-- of the line.
vim.opt.sidescrolloff = 2

-- Have a block cursor instead of a line cursor when in insert mode
vim.opt.guicursor = ""

-- Don't highlight search results
vim.opt.hlsearch = false
-- Highlight the nearest result for your search as you type it (default is to
-- not highlight anything at all in the code as you construct your search)
vim.opt.incsearch = true

-- Don't wrap lines when displaying them on windows that aren't wide enough
vim.opt.wrap = false

-- Set folding style (so you can use {{{ and }}} to make folds)
vim.opt.foldmethod = "marker"

-- Highlight the cursor line
vim.opt.cursorline = true
-- Set default column line at the 80th character for code style stuff. This
-- should ideally change based on the type of file, but this is the default if
-- no rule is set for the currently open file type.
vim.opt.colorcolumn = "80"
-- Set a line at the 100th character for Rust (following the formatting
-- conventions specified in The Book)
vim.cmd[[autocmd FileType rust setlocal colorcolumn=100]]
-- Set a line at the 79th character for C (following PEP7 and GNU's standards)
vim.cmd[[autocmd FileType c setlocal colorcolumn=79]]
-- Set a line at the 100th character for java (checkstyle)
vim.cmd[[autocmd FileType java setlocal colorcolumn=100]]
-- Set a line at the 100th character for html and php
vim.cmd[[autocmd FileType html setlocal colorcolumn=100]]
vim.cmd[[autocmd FileType php setlocal colorcolumn=100]]

-- When creating verical splits (:vs[plit]), put the new window on the right
vim.opt.splitright = true
-- When creating horizontal splits (:sp[lit]), put the new window below
vim.opt.splitbelow = true

-- Mark whitespace characters with specific symbols to make them easier to see
vim.opt.list = true
vim.opt.listchars={ tab = '| ', eol = '$', space = '·', extends = '⟩', precedes = '⟨'}

-- Disable the additional sign columns that appear to the left of the line
-- numbers. nvim-cmp uses these columns to display 'E's on lines where there
-- are errors, but the column appears and disappears as errors come up and are
-- dealt, and the column disappears once you go into insert mode. It's super
-- annoying and jittery, and having the columns always visible takes up
-- valuable screen real estate, so I entirely disable them.
vim.opt.signcolumn = "no"

-- Set options related to "diff" mode, typically launched
-- with `vimdiff` of `nvim -d`. Here all we do is make it so
-- opening a new split to diff with `:diffs [file]` opens a
-- new vertical split (default is horizontal), and increase
-- the total number of lines in the diff hunk to 60 (at the
-- time of writing, default is 40).
vim.opt.diffopt="vertical,linematch:60"

------------------------------------------------
-- Vim remembers last cursor position in file --
------------------------------------------------
-- {{{
-- Note: Only do this part when Vim was compiled with the +eval feature.
vim.cmd[[
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
]]
-- }}}

----------------------------------------------------------------------------
-- Undo files but with a warning for when you are about to undo to a file --
-- state prior to the current session                                     --
----------------------------------------------------------------------------
-- TODO: this is not fully thought out. Vim's undo history is a tree, does this
-- code handle cases where we reopen a file, go back in the history and make
-- some new changes well? Further, do you want to store info for multiple
-- sessions to give more information?
-- {{{
vim.cmd[[
" Change to `if 0` to quickly disable
if 1
  " Enable undo files
  set undofile
  set undodir=~/.vim/undo
  
  augroup SessionUndoBoundary
    autocmd!
    " Mark the current undo sequence number as the start-of-session boundary
    autocmd BufReadPost * let b:undo_session_start = undotree().seq_cur
  augroup END
  
  function! SessionUndo()
    " If no session boundary exists or we are already behind or ahead of the boundary, just undo
    if !exists('b:undo_session_start') || undotree().seq_cur != b:undo_session_start
      return "u"
    endif
  
    " If we made it here, that means we are *at* the session boundary
    " (i.e. `undotree().seq_cur == b:undo_session_start`)

    " If we also happen to be at the very beginning of the file's undo history
    " (i.e. `undotree().seq_cur == 0`) then just return normally
    if undotree().seq_cur == 0
      return "u"
    endif
  
    " If we are at the session boundary but not at the beginning of the file's
    " undo history
    let l:choice = confirm("Undo into previous session?", "&Yes\n&No", 2)
    if l:choice == 1
      " User said yes, move the boundary back so they aren't prompted again 
      " for every single keystroke in the past history.
      " let b:undo_session_start = -1 
      return "u"
    else
      return ""
    endif
  endfunction
  
  nnoremap <expr> u SessionUndo()
endif
]]
-- }}}

-- Regexes that highlight trailing whitespace {{{
--
-- The problem with these regexes is they are slow and you can see your
-- terminal flicker sometimes on start up.
--
-- Explanation on how they work:
--   \\ matches a '\'. Used for matching an escaped or non escaped whitespace char
--   \@<! NOT anything before this atom. For example, NOT \ (non escaped)
--   \zs anything before this atom. For example, \ (escaped)
--   \s\+ matches one or more whitespace chars
--   \%# vim atom for cursor position
--   \@<! NOT anything before this atom. For example, NOT \%# (not cursor position)
--   $ matches the end of a line
-- }}}
-- Matches trailing whitespace that is not escaped and not at the cursor
--vim.cmd[[call matchadd('Error', '\\\@<!\s\+\%#\@<!$')]]
-- Matches an escaped whitespace character that is not at the cursor
--vim.cmd[[call matchadd('Visual', '\\\zs\s\%#\@<!$')]]
