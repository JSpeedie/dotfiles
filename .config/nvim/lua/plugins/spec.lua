return {
  -- My colourscheme of choice
  {
    "ayu-theme/ayu-vim",
  name = "ayu",
    lazy = false, -- Load this on startup
    priority = 1000, -- High priority, load before all other plugins
    -- config = function()
    --   -- Set the colourscheme
    --   vim.cmd([[
    --     set background="dark"
    --     let ayucolor="light"
    --     colorscheme ayu
    --   ]])
    -- end,
  },

  -- For fuzzy finding files
  {
    "nvim-telescope/telescope.nvim",
    tag = '0.1.8',
    dependencies = {
      "nvim-lua/plenary.nvim"
    }
  },

  -- nvim-treesitter (for significantly better syntax highlighting)
  ----------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    -- build = function()
    --   local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
    --   ts_update()
    -- end,
  },

  -- vim-commentary (for commenting with gc)
  ------------------------------------------
  -- - E.g. gcc comments out a line
  -- - E.g. you can select multiple lines with V, then comment them out with gcc
  { "tpope/vim-commentary" },

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
  { "tpope/vim-surround" },

  -- vim-gitgutter (shows which lines have been changed next to the line numbers on the left)
  -------------------------------------------------------------------------------------------
  { "airblade/vim-gitgutter" },

  -- lualine (for a fast and informative status bar)
  --------------------------------------------------
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  },

  -- nvim-cmp (+all its dependencies)
  -----------------------------------
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-path", -- File path completions
      "hrsh7th/cmp-buffer", -- Completions for all words, based on the current buffer.
      "hrsh7th/cmp-cmdline", -- Completions for / searches, based on the current buffer.
                              -- For it to work, cmp-path and cmp-buffer are necessary.
      "hrsh7th/cmp-nvim-lsp",
      "neovim/nvim-lspconfig",
      "onsails/lspkind.nvim",  -- For icons in auto complete
      -- For vsnip users.
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip"
    }
  },
}
