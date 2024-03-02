----    ___        _          _____                       _      _       
----   / _ \      | |        /  __ \                     | |    | |      
----  / /_\ \_   _| |_ ___   | /  \/ ___  _ __ ___  _ __ | | ___| |_ ___ 
----  |  _  | | | | __/ _ \  | |    / _ \| '_ ` _ \| '_ \| |/ _ \ __/ _ \
----  | | | | |_| | || (_) | | \__/\ (_) | | | | | | |_) | |  __/ ||  __/
----  \_| |_/\__,_|\__\___/   \____/\___/|_| |_| |_| .__/|_|\___|\__\___|
----                                               | |                   
----                                               |_|                   
----
-- I don't want too much again, Mostly just a text editor
local cmp = require('cmp')

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  })
})

----   _      ___________   _____ _     _ _   
----  | |    /  ___| ___ \ /  ___| |   (_) |  
----  | |    \ `--.| |_/ / \ `--.| |__  _| |_ 
----  | |     `--. \  __/   `--. \ '_ \| | __|
----  | |____/\__/ / |     /\__/ / | | | | |_ 
----  \_____/\____/\_|     \____/|_| |_|_|\__|
----                                          
-- Just that, LSP Shit
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.elixirls.setup { capabilities = capabilities }
lspconfig.typst_lsp.setup { capabilities = capabilities }
lspconfig.nil_ls.setup { capabilities = capabilities }
lspconfig.lua_ls.setup { capabilities = capabilities }
-- java.... shall it ever haunt me again...
lspconfig.jdtls.setup {
  capabilities = capabilities,
  cmd = { 'jdtls' }
}
lspconfig.rust_analyzer.setup {	capabilities = capabilities }

