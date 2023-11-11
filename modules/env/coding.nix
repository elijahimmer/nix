{...}: {
  programs.nixvim = {
    plugins = {
      telescope.enable = true;
      treesitter.enable = true;
      gitsigns.enable = true;
      lsp-format.enable = true;
      fugitive.enable = true;
      nix.enable = true;
      undotree.enable = true;
      chadtree.enable = true;
      lsp = {
        enable = true;
        servers = {
          bashls.enable = true;
          elixirls.enable = true;
          java-language-server.enable = true; # I swear this is only for school, not my choice
          hls.enable = true;
          pylsp.enable = true;
          taplo.enable = true;
          texlab.enable = true;
          rust-analyzer.enable = true;
          zls.enable = true;
          nil_ls.enable = true;
        };
      };
    };
  };
}
