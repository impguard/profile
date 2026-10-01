-- A small, plugin-free starting point for Neovim 0.11+.
-- See :help nvim-defaults for built-in mappings (including LSP and diagnostics).
vim.g.mapleader = ','
vim.g.maplocalleader = ','

local opt = vim.opt
opt.number = true
opt.cursorline = true
opt.breakindent = true
opt.expandtab = true
opt.shiftwidth = 2
opt.softtabstop = 2
opt.tabstop = 2
opt.ignorecase = true
opt.smartcase = true
opt.splitbelow = true
opt.splitright = true
opt.scrolloff = 4
opt.undofile = true
opt.confirm = true

-- Use the system clipboard when a supported provider is available.
-- WSLClipboard supplies win32yank; desktop Linux can use wl-clipboard/xclip.
for _, provider in ipairs({ 'win32yank.exe', 'pbcopy', 'wl-copy', 'xclip', 'xsel' }) do
  if vim.fn.executable(provider) == 1 then
    opt.clipboard = 'unnamedplus'
    break
  end
end

local map = vim.keymap.set
map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlights' })
map('n', '<leader>e', '<cmd>Explore<CR>', { desc = 'Browse files (netrw)' })
map('n', '<leader>w', '<cmd>write<CR>', { desc = 'Save file' })
map('n', '<leader>q', '<cmd>quit<CR>', { desc = 'Close window' })
map('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Show diagnostic' })

vim.filetype.add({ filename = { Jenkinsfile = 'groovy' }, pattern = { ['.*%.Jenkinsfile'] = 'groovy' } })

-- Native LSP is available but needs a server and configuration for each language.
-- Add these when needed; mise can install the server's runtime.
-- Neovim 0.11+: vim.lsp.config('name', { cmd = {...}, filetypes = {...}, root_markers = {...} })
--              vim.lsp.enable('name')
-- Machine-specific additions can live in lua/local_config.lua.
local local_config = vim.fn.stdpath('config') .. '/lua/local_config.lua'
if vim.fn.filereadable(local_config) == 1 then
  dofile(local_config)
end
