-- Change the blue color of lualine's Ayu Light since it is erroneous
local custom_ayu_light = require'lualine.themes.ayu_light'
custom_ayu_light.normal.a.bg = '#36a3d9'
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = custom_ayu_light, -- Use the commented out line below for automatic detection
    -- theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'diagnostics'},
    lualine_c = { { 'filename', path=1 } },
    lualine_x = {
      'encoding',
      { 'fileformat', icons_enabled = false },
    },
    lualine_y = {
      { 'filetype', icons_enabled = false },
    },
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { 'filename', path=1 } },
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
