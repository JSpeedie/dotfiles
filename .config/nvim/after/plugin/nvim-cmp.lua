local cmp = require'cmp'
local lspkind = require('lspkind')

local kind_icons = {
  Text = "",
  Method = "󰆧",
  Function = "󰊕",
  Constructor = "",
  Field = "󰇽",
  Variable = "󰂡",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  Color = "󰏘",
  File = "󰈙",
  Reference = "",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "󰅲",
}

cmp.setup({
  -- This completion section that disables autocompletion is important for adding
  -- a delay to when the autocompletion shows up.
  completion = {
    autocomplete = false
  },
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    -- ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ['<C-e>'] = cmp.mapping.abort(),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
  }, {
    { name = 'buffer' },
  }),
  -- This 'formatting' section is necessary to get icons next to the type of
  -- the autocompletion recommendation
  formatting = {
    format = lspkind.cmp_format(),
  },
})

-- Add a delay so that the auto complete only shows up after a 750ms pause
-- {{{
local completionDelay = 750
local timer = nil

function _G.setAutoCompleteDelay(delay)
  completionDelay = delay
end

function _G.getAutoCompleteDelay()
  return completionDelay
end

vim.api.nvim_create_autocmd({ "TextChangedI", "CmdlineChanged" }, {
  pattern = "*",
  callback = function()
    if timer then
      vim.loop.timer_stop(timer)
      timer = nil
    end

    timer = vim.loop.new_timer()
    timer:start(
      _G.getAutoCompleteDelay(),
      0,
      vim.schedule_wrap(function()
        cmp.complete({ reason = cmp.ContextReason.Auto })
      end)
    )
  end,
})
-- }}}

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  }),
  matching = { disallow_symbol_nonprefix_matching = false }
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')
-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { 'clangd', 'pyright' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    -- on_attach = my_custom_on_attach,
    capabilities = capabilities,
  }
end
-- For this to work, you may have to install rust-analyzer using
-- 'rustup component add rust-analyzer' and additionally installing rust-src:
-- 'rustup component add rust-src'
lspconfig.rust_analyzer.setup {
  -- Server-specific settings. See `:help lspconfig-setup`
  -- on_attach = my_custom_on_attach,
  -- capabilities = capabilities,
  -- settings = {
  --   ['rust-analyzer'] = {},
  -- },
}
