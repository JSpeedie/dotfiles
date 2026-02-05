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
    ['<C-CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false`
                                                         -- to only confirm explicitly selected items.
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

-- I think I prefer vim's standard ':' cmdline file matching stuff so I've disabled
-- this for now.
-- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(':', {
--   -- mapping = cmp.mapping.preset.cmdline(),
-- -- OR:
--   mapping = cmp.mapping.preset.cmdline({
--     -- This makes tab autocomplete if there's only 1 option. Unfortunately,
--     -- I haven't figured out how to disable the fuzzy matching for the cmdline
--     -- nor how to match the search case sensitive.
--     ['<Tab>'] = {
--       c = function(_)
--         if cmp.visible() then
--           if #cmp.get_entries() == 1 then
--             cmp.confirm({ select = true })
--           else
--             cmp.select_next_item()
--           end
--         else
--           cmp.complete()
--           if #cmp.get_entries() == 1 then
--             cmp.confirm({ select = true })
--           end
--         end
--       end,
--     }
--   }),
--   sources = cmp.config.sources({
--     { name = 'path' }
--   -- }, {
--   --   { name = 'cmdline' }
--   }),
--   -- I really don't want fuzzy matching so I tried disabling this stuff but
--   -- that didn't seem to work.
--   matching = {
--     -- disallow_fullfuzzy_matching = true,
--     -- disallow_fuzzy_matching = true,
--     -- disallow_partial_fuzzy_matching = true,
--     -- disallow_partial_matching = true,
--     -- disallow_prefix_unmatching = false,
--     -- disallow_symbol_nonprefix_matching = true,
--   }
-- })


-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')
-- Enable some language servers with the additional completion capabilities
-- offered by nvim-cmp. To get any of these LSPs to work, you need to install
-- the vim language server:
--
--     # Linux Mint:
--     sudo apt install npm
--     sudo npm install -g vim-language-server    # It won't work if you don't install this globally with `-g`

-- To get Python LSP working you need to install `pyright`:
--
--     # Linux Mint:
--     sudo npm install -g pyright    # It won't work if you don't install this globally with `-g`
--
local servers = { 'pyright' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    -- on_attach = my_custom_on_attach,
    capabilities = capabilities,
  }
end

-- To get the C/C++ LSP working you need to install Clang:
--
--     # Arch:
--     sudo pacman -S clang
--     # Linux Mint:
--     sudo apt install clang clangd
--
-- By default, when neovim attaches an LSP it overwrites 'formatexpr' and when
-- it comes to clang, this results in broken functionality. For example, if you
-- use 'V' to select multiple lines and then run 'gq', 'gq' will format lines
-- that were not a part of the selection, for some unknown reason. It also
-- indented too far and did so with spaces even though I've told vim to use
-- tabs. The solution is to write a custom 'on_attach' function which sets
-- 'formatexpr' to its default of "".
local on_attach_use_internal_formatexpr = function(client, bufnr)
  -- Disable lsp formatexpr (use the internal one)
  vim.opt.formatexpr = ""
end
lspconfig.clangd.setup {
  on_attach = on_attach_use_internal_formatexpr,
  capabilities = capabilities,
}
lspconfig.vimls.setup {
  capabilities = capabilities,
}

-- To get the Rust LSP working you need to install `rust-analyzer` and
-- `rust-src`:
--
--     rustup component add rust-analyzer
--     rustup component add rust-src
--
-- On Linux Mint (and Debian!), the the above commands were not enough to get
-- the Rust LSP to work.
-- 1. I first tested `rust-analyzer` to see if it was reporting any errors
--    using the following command:
--
--    cd [some-rust-project]
--    rust-analyzer analysis-stats -v .
--
--    `rust-analyzer` was reporting quite a few errors related to perf
--    counters. On investigation it seemed that `perf` was not properly setup
--    on my machine.
-- 2. To make sure `perf` was setup and working correctly, I ran the following
--    command looking for any errors (warnings are okay):
--
--    perf record /bin/ls
--
-- 3. Installing perf (fully) is (possibly) a multistep process on Linux Mint
--    so I installed the following packages:
--
--    (For Debian you can skip this installation step)
--
--    sudo apt install linux-tools-common linux-tools-generic linux-tools-`uname -r`
--
-- 4. You may need to adjust perfs monitoring and obervation permissions. If
--    these permissions are really causing you issues, running the test perf
--    command listed in step 2 will warn you about it. You can adjust the
--    permissions using the following command:
--
--    sudo sysctl kernel.perf_event_paranoid=-1
--
-- 5. Then to confirm everything works as expected, test-run rust-analyzer
--    again to make sure it's not erroring out:
--
--    rust-analyzer analysis-stats -v .
--
lspconfig.rust_analyzer.setup {
  capabilities = capabilities,
}

-- To get the Lua LSP working you need to install the Lua Language Server:
--
--     # Arch:
--     sudo pacman -S lua-language-server
--     # Debian and Linux Mint:
--     * Visit https://github.com/LuaLS/lua-language-server/releases/latest.
--       This page will tell you what the latest version of
--       `lua-language-server` is. We'll need to specify a version in one of
--       the upcoming commands, so if you want to install the latest version,
--       take note of what you see on that page.
--     mkdir -p ~/.local/share/lua-language-server
--     cd Downloads/
--     wget https://github.com/LuaLS/lua-language-server/releases/download/3.15.0/lua-language-server-3.15.0-linux-x64.tar.gz
--     tar xvf lua-language-server-3.15.0-linux-x64.tar.gz -C ~/.local/share/lua-language-server
--     sudo ln -s ~/.local/share/lua-language-server/bin/lua-language-server /usr/bin/lua-language-server
--     rm lua-language-server-3.15.0-linux-x64.tar.gz
--     cd
--
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
