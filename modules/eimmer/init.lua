-- this comment is to prevent conflicts
--

local opt = vim.opt
local g = vim.g
local keymap = vim.keymap

g.mapleader = ' '
g.maplocalleader = ' '

g.have_nerd_font = true 

-- [[ Setting options ]]
-- See `:help vim.opt`
--  For more options, you can see `:help option-list`

opt.spell = true
opt.mouse = ""
opt.expandtab = true
opt.shiftwidth = 2

opt.number = true
opt.relativenumber = true

-- Don't show the mode, since it's already in the status line
opt.showmode = false

vim.schedule(function()
  opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
opt.breakindent = true

-- Save undo history
opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
opt.ignorecase = true
opt.smartcase = true
opt.smartindent = true

-- Keep signcolumn on by default
opt.signcolumn = 'yes'

-- Decrease update time
opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
opt.timeoutlen = 300

-- Configure how new splits should be opened
opt.splitright = true
opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
opt.inccommand = 'split'

-- Show which line your cursor is on
opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
opt.scrolloff = 10

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
keymap.set('n', '<left>',  '<cmd>echo "Use h to move!!"<CR>')
keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
keymap.set('n', '<up>',    '<cmd>echo "Use k to move!!"<CR>')
keymap.set('n', '<down>',  '<cmd>echo "Use j to move!!"<CR>')

--
--  See `:help wincmd` for a list of all window commands
keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })


require('rose-pine').setup({
  variant = "main",
  enable = {terminal = true},

  styles = {
    bold = true,
    italic = true,
    transparency = true,
  },
})
vim.cmd('colorscheme rose-pine')

require('cmp').setup({
  sources = {
    { name = 'buffer' },
    { name = 'nvim_lsp' },
  },
})
require("which-key").add({
  { "<leader>f", group = "file" },
})


local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local telescope_builtin = require('telescope.builtin')

lspconfig.nil_ls.setup { capabilities = capabilities }

local map = function(keys, func, desc)
  vim.keymap.set('n', keys, func, { desc = 'LSP: ' .. desc })
end

map('gd', telescope_builtin.lsp_definitions, '[G]oto [D]efinition')
map('gr', telescope_builtin.lsp_references, '[G]oto [R]eferences')
map('gI', telescope_builtin.lsp_implementations, '[G]oto [I]mplementation')
map('<leader>D',  telescope_builtin.lsp_type_definitions, 'Type [D]efinition')
map('<leader>ds', telescope_builtin.lsp_document_symbols, '[D]ocument [S]ymbols')
map('<leader>ws', telescope_builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
