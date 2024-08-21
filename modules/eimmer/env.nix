{
  lib,
  config,
  system,
  inputs,
  pkgs,
  ...
}: {
  config = lib.mkIf config.mein.eimmer.withEnv {
    programs.git = {
      enable = true;
      config = {
        core.editor = "nvim";
        user = {
          Email = "me@eimmer.me";
          Name = "Elijah M. Immer";
        };
      };
    };
    home-manager.users.eimmer = {
      programs = {
        bash.enable = true;

        zoxide = {
          enable = true;
          enableBashIntegration = true;
          options = ["--cmd cd"];
        };

        neovim = {
          enable = true;
          defaultEditor = true;
          vimAlias = true;
          vimdiffAlias = true;
          withNodeJs = false;
          withRuby = false;
          withPython3 = false;

          plugins = with pkgs.vimPlugins; [
            nvim-treesitter.withAllGrammars # Highlighting

            rose-pine

            inputs.lz-n.packages.${system}.default

            telescope-nvim

            nvim-lspconfig

            nvim-cmp
            cmp-buffer
            cmp-nvim-lsp
            cmp-calc
            cmp-spell
            cmp-rg
          ];

          extraPackages = with pkgs;
            [
              tree-sitter
              nil
            ]
            ++ lib.optionals config.mein.env.withCodingPkgs [
              zls
              elixir-ls
              pkgs.stable.typst-lsp
              rust-analyzer
              jdt-language-server
              lua-language-server
            ];

          extraLuaConfig =
            (builtins.readFile ./init.lua)
            + lib.optionalString config.mein.env.withCodingPkgs ''
              lspconfig.elixirls.setup {
                  capabilities = capabilities,
                  cmd = { 'elixir-ls' }
              }
              lspconfig.typst_lsp.setup { capabilities = capabilities }
              lspconfig.lua_ls.setup { capabilities = capabilities }
              lspconfig.jdtls.setup {
                capabilities = capabilities,
                cmd = { 'jdtls' }
              }
              lspconfig.rust_analyzer.setup { capabilities = capabilities }
            '';
        };
      };
    };
  };
}
