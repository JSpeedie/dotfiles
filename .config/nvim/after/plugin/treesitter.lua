require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  -- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
  ensure_installed = { "c", "cpp", "rust", "python", "lua", "html", "javascript", "markdown", "markdown_inline" },
  -- ensure_installed = { "c", "cpp", "rust", "python", "lua", "html", "javascript", "latex", "markdown", "markdown_inline" },
  -- latex requires tree-sitter-cli, which can be installed using 'npm install -g tree-sitter-cli'

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = false,
  },
}