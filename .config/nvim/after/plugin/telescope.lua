-- telescope (for fuzzy file finding)
local builtin = require('telescope.builtin')
-- Create a keybinding <leader>ff to bring up the fuzzy file finding window
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
