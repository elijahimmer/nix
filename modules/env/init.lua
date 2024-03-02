----   _____                           _   _____      _   _   _                 
----  |  __ \                         | | /  ___|    | | | | (_)                
----  | |  \/ ___ _ __   ___ _ __ __ _| | \ `--.  ___| |_| |_ _ _ __   __ _ ___ 
----  | | __ / _ \ '_ \ / _ \ '__/ _` | |  `--. \/ _ \ __| __| | '_ \ / _` / __|
----  | |_\ \  __/ | | |  __/ | | (_| | | /\__/ /  __/ |_| |_| | | | | (_| \__ \
----   \____/\___|_| |_|\___|_|  \__,_|_| \____/ \___|\__|\__|_|_| |_|\__, |___/
----                                                                   __/ |    
----                                                                  |___/     
-- Just some general things
vim.opt.spell = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.smarttab = true
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.mouse = ""
vim.opt.clipboard = "unnamedplus"
vim.opt.expandtab = true
vim.opt.shiftwidth = 4


----
---- _   __            ___  ___                  _                 
---- | | / /            |  \/  |                 (_)                
---- | |/ /  ___ _   _  | .  . | __ _ _ __  _ __  _ _ __   __ _ ___ 
---- |    \ / _ \ | | | | |\/| |/ _` | '_ \| '_ \| | '_ \ / _` / __|
---- | |\  \  __/ |_| | | |  | | (_| | |_) | |_) | | | | | (_| \__ \
---- \_| \_/\___|\__, | \_|  |_/\__,_| .__/| .__/|_|_| |_|\__, |___/
----              __/ |              | |   | |             __/ |    
----             |___/               |_|   |_|            |___/     
----
-- I don't wanna use many to keep it mostly vim-default
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<Up>', '<Nop>', opts)
vim.api.nvim_set_keymap('n', '<Down>', '<Nop>', opts)
vim.api.nvim_set_keymap('n', '<Left>', '<Nop>', opts)
vim.api.nvim_set_keymap('n', '<Right>', '<Nop>', opts)
vim.api.nvim_set_keymap('i', '<Up>', '<Nop>', opts)
vim.api.nvim_set_keymap('i', '<Down>', '<Nop>', opts)
vim.api.nvim_set_keymap('i', '<Left>', '<Nop>', opts)
vim.api.nvim_set_keymap('i', '<Right>', '<Nop>', opts)
vim.api.nvim_set_keymap('v', '<Up>', '<Nop>', opts)
vim.api.nvim_set_keymap('v', '<Down>', '<Nop>', opts)
vim.api.nvim_set_keymap('v', '<Left>', '<Nop>', opts)
vim.api.nvim_set_keymap('v', '<Right>', '<Nop>', opts)


---- _____ _                         
----|_   _| |                        
----  | | | |__   ___ _ __ ___   ___ 
----  | | | '_ \ / _ \ '_ ` _ \ / _ \
----  | | | | | |  __/ | | | | |  __/
----  \_/ |_| |_|\___|_| |_| |_|\___|
----                                 
-- Exquisite theme from `https://github.com/rose-pine/`
require('rose-pine').setup({
    variant = "main",

    enable = {
        -- terminal = true,
        migrations = true, -- Handle deprecated options automatically
    },

    styles = {
        bold = true,
        italic = false,
        transparency = true,
    },
})
vim.cmd('colorscheme rose-pine')

