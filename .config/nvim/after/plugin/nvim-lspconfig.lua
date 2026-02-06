-- Configuration of `nvim-lspconfig`
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Enable some language servers with the additional completion capabilities
-- offered by nvim-cmp. To get any of these LSPs to work, you need to install
-- the vim language server:
--
--     # Linux Mint:
--     sudo apt install npm
--     sudo npm install -g vim-language-server    # It won't work if you don't install this globally with `-g`




-- Python LSP. This LSP requires installing `pyright`:
--
--     # Linux Mint:
--     sudo npm install -g pyright    # It won't work if you don't install this globally with `-g`
--
vim.lsp.config("pyright", {
  capabilities = capabilities,
})
vim.lsp.enable("pyright")




-- C/C++ LSP. This LSP requires installing Clang:
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
vim.lsp.config("clangd", {
  on_attach = on_attach_use_internal_formatexpr,
  capabilities = capabilities,
})
vim.lsp.enable("clangd")




-- The Vim Script LSP. This should work without installing any additional
-- software
vim.lsp.config("vimls", {
  capabilities = capabilities,
})
vim.lsp.enable("vimls")




-- Rust LSP. This requires installing `rust-analyzer` and `rust-src`:
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
vim.lsp.config("rust_analyzer", {
  capabilities = capabilities,
})
vim.lsp.enable("rust_analyzer")




-- Lua LSP. This requires installing `lua-language-server`:
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
vim.lsp.config("lua_ls", {
  capabilities = capabilities,
})
vim.lsp.enable("lua_ls")




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
