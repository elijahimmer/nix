{
  lib,
  config,
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

            telescope-nvim

            nvim-lspconfig

            nvim-cmp
            cmp-buffer
            cmp-nvim-lsp
            cmp-calc
            cmp-spell
            cmp-rg

            #which-key-nvim
          ];

          extraPackages = with pkgs;
            [
              tree-sitter
              nil
            ]
            ++ lib.optionals config.mein.env.withCodingPkgs [
              zls
              elixir-ls
              tinymist
              typstyle
              rust-analyzer
              jdt-language-server
              lua-language-server
            ];

          extraLuaConfig =
            (builtins.readFile ./init.lua)
            + lib.optionalString config.mein.env.withCodingPkgs ''
              lspconfig.elixirls.setup { cmd = { 'elixir-ls' } }
              lspconfig.gleam.setup { }

              lspconfig.tinymist.setup { 
                root_dir = "-",
                settings = {
                  outputPath = "$dir/$name";
                  exportPdf = "onDocumentHasTitle",
                  formatterMode = "typstyle",
                }
              }

              lspconfig.lua_ls.setup { }
              lspconfig.jdtls.setup { cmd = { 'jdtls' } }
              lspconfig.rust_analyzer.setup { }
            '';
        };
      };
    };
  };
}
