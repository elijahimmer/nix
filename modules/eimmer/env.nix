{
  lib,
  config,
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
      inputs,
      pkgs,
      ...
    }: {
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
            # Highlighting
            nvim-treesitter.withAllGrammars

            # nvim cmp
            nvim-cmp
            cmp-nvim-lsp

            # Lsp + language stuff
            nvim-lspconfig
            vim-nix
            statix
            luasnip
            vim-just
            typst-vim
            zig-vim

            # theme
            rose-pine
          ];

          extraPackages = with pkgs;
            [
              tree-sitter
            ]
            ++ lib.optionals config.mein.env.withCodingPkgs [
              zls
              nil
              elixir-ls
              typst-lsp
              rust-analyzer
              jdt-language-server
              lua-language-server
            ];

          extraLuaConfig = builtins.readFile ./init.lua;
        };
      };
    };
  };
}
