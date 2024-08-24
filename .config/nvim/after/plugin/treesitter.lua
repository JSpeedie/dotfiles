require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  -- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
  ensure_installed = { "c", "cpp", "rust", "python", "lua", "html",
    "javascript", "markdown", "markdown_inline", "vim" },
  -- ensure_installed = { "latex", },
  -- latex requires tree-sitter-cli, which can be installed using 'npm install -g tree-sitter-cli'

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  highlight = {
    enable = false,
  },
}
