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
