{pkgs, lib, ...}: {
  environment.systemPackages = with pkgs; [
    # Language Stuff
    typst
    typstfmt

    gcc
    cargo
    rustfmt

    elixir
    ghc


    # Neovim Stuff
    tree-sitter

    nil
    elixir-ls
    typst-lsp
    rust-analyzer
    jdt-language-server
    lua-language-server
  ];
  programs.neovim = {
    configure = {
        customRC = lib.mkForce """
          lua << EOF
            ${builtins.readFile ./init.lua}
            ${builtins.readFile ./full.lua}
          EOF
        """;
        packages.mein = with pkgs.vimPlugins; {
          start = [
            # Highlighting
            nvim-treesitter.withAllGrammars

            # nvim cmp
            nvim-cmp
            cmp-nvim-lsp 

            # Lsp + language stuff
            nvim-lspconfig
            luasnip
            typst-vim
        ];
      };
    };
  };
}
