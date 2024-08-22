-- Add key bindings for going to the next diagnostic. Useful for moving to
-- the next error or warning
vim.keymap.set("n", "]g", vim.diagnostic.goto_next)
vim.keymap.set("n", "[g", vim.diagnostic.goto_prev)
