{
  lib,
  config,
  system,
  inputs,
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

            pkgs.nil
          ];

          extraPackages = with pkgs;
            [
              tree-sitter
            ]
            ++ lib.optionals config.mein.env.withCodingPkgs [
              zls
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
