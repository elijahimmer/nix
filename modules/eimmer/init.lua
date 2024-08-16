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

require("lz.n").load {
  {
    "cmp",
    after = function ()
      require('cmp').setup({
        sources = {
          { name = 'buffer' },
          { name = 'nvim_lsp' },
        },
      })
    end;
    event = "InsertEnter",
  },
  {
    "folke/which-key.nvim",
    after = function ()
      require("which-key").add({
        { "<leader>f", group = "file" },
      })
    end,
    keys = {
      { "<leader>f"}
    },
  },
}


local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.nil_ls.setup { capabilities = capabilities }

require("lz.n").load {
  "telescope.nvim",
  cmd = "Telescope",
}

