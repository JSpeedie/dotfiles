local cmp = require'cmp'
local lspkind = require('lspkind')

-- setup() is also available as an alias
require('lspkind').init({
    -- Override preset symbols
    symbol_map = {
      Text = "󰦨",
      Method = "󰆧",
      Function = "󰊕",
      Constructor = "",
      Field = "󰓹",
      Variable = "󰀫",
      Class = "󰠱",
      Interface = "",
      Module = "",
      Property = "󰓹",
      Unit = "󰑭",
      Value = "󰎠",
      Enum = "",
      Keyword = "",
      Snippet = "",
      Color = "󰏘",
      File = "󰈙",
      Reference = "󰈇",
      Folder = "󰉋",
      EnumMember = "",
      Constant = "",
      Struct = "󰙅",
      Event = "",
      Operator = "󰆕",
      TypeParameter = "",
    },
})

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
  window = {
    completion = {
      winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
      -- Offset the autocompletion window 1 character to the right so the
      -- actual recommendation is in line with the cursor. This is necessary
      -- for the type of formatting (see the 'formatting' section below) I use.
      col_offset = 0,
      side_padding = 1,
    },
  },
  -- Display documentation by default once you start scrolling through the
  -- autocomplete recommendations
  view = {
    docs = {
      auto_open = true
    }
  },
  -- This 'formatting' section is necessary to:
  -- (1) Get icons next to the type of the autocompletion recommendation
  -- Part 2 where we:
  -- (2) Style the autocompletion recommendation so that:
  --     (a) Different types are different colours
  --     (b) The recommendation type shows its colour as its background
  -- ... is handled by the highlight groups specified in your colourscheme's
  -- file.
  formatting = {
    fields = {"abbr", "kind", "menu" },
    format = function(entry, vim_item)
      local reco = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
      -- Get the autorecommendation strings.
      -- 'strings[1]' = an icon representing the type.
      -- 'strings[2]' = text representing the type.
      local strings = vim.split(vim_item.kind, "%s", { trimempty = true })
      vim_item.kind = " " .. (strings[1] or "?") .. " "
      vim_item.menu = (strings[2] or "")

      return reco
    end,
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
-- vimls: requires installation with 'npm install -g vim-language-server'
local servers = { 'pyright' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    -- on_attach = my_custom_on_attach,
    capabilities = capabilities,
  }
end

-- For this to work, you have to install clang. On Arch, you would do that using
-- 'sudo pacman -S clang'
-- On Linux Mint, you would do that using
-- 'sudo apt install clang clangd'
lspconfig.clangd.setup {
  capabilities = capabilities,
}

-- For this to work, you have to install 'vim-language-server' using
-- 'npm install -g vim-language-server'
lspconfig.vimls.setup {
  capabilities = capabilities,
}

-- For this to work, you have to install 'rust-analyzer' and 'rust-src' using
-- 'rustup component add rust-analyzer' and
-- 'rustup component add rust-src'
lspconfig.rust_analyzer.setup {
  capabilities = capabilities,
}

-- For this to work, you have to install 'lua-language-server'. On Arch you
-- can run 'sudo pacman -S lua-language-server'
lspconfig.lua_ls.setup {
  -- on_attach = on_attach,
  capabilities = capabilities,
}

-- TODO: Possibly more complete lua LSP configuration
--
-- lspconfig.lua_ls.setup {
--   on_init = function(client)
--     local path = client.workspace_folders[1].name
--     if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
--       return
--     end

--     client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
--       runtime = {
--         -- Tell the language server which version of Lua you're using
--         -- (most likely LuaJIT in the case of Neovim)
--         version = 'LuaJIT'
--       },
--       -- Make the server aware of Neovim runtime files
--       workspace = {
--         checkThirdParty = false,
--         library = {
--           vim.env.VIMRUNTIME
--           -- Depending on the usage, you might want to add additional paths here.
--           -- "${3rd}/luv/library"
--           -- "${3rd}/busted/library",
--         }
--         -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
--         -- library = vim.api.nvim_get_runtime_file("", true)
--       }
--     })
--   end,
--   settings = {
--     Lua = {}
--   }
-- }
