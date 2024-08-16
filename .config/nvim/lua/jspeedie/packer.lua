-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- For fuzzy finding files
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- My colourscheme of choice
  use 'ayu-theme/ayu-vim'

  -- nvim-treesitter (for significantly better syntax highlighting)
  ----------------------------------------------------------------
  use ({
    'nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' }
  })

  -- vim-commentary (for commenting with gc)
  ------------------------------------------
  -- - E.g. gcc comments out a line
  -- - E.g. you can select multiple lines with V, then comment them out with gcc
  use 'tpope/vim-commentary'

  -- vim-surround (for surrounding with cs)
  -----------------------------------------
  -- - E.g. while inside '[hello]' cs[) will give you '(hello)':
  --       [hello]
  -- - E.g. while inside a word 'hello', ysiw" will give you \"hello\":
  --       hello
  -- - E.g. while inside a word 'hello', ysiw<em> will give you <em>hello</em>:
  --       hello
  -- - Works with HTML tags, with 't' for tags. E.g. while inside <q>hi</q>, cst"
  --   will give you \"hi\":
  --       <q>hi</q>
  -- - yss to surround a line.
  use 'tpope/vim-surround'

  -- vim-gitgutter (shows which lines have been changed next to the line numbers on the left)
  -------------------------------------------------------------------------------------------
  use 'airblade/vim-gitgutter'

  -- vim-airline (for an informative status bar)
  ----------------------------------------------
  use 'vim-airline/vim-airline'
  -- For theming the status bar
  use 'vim-airline/vim-airline-themes'
end)
