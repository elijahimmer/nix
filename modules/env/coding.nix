{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    raylib
    gcc
    cargo
    rustfmt

    elixir
    elixir-ls

    ghc
  ];

  programs.nixvim = {
    plugins = {
      telescope.enable = true;
      treesitter.enable = true;
      gitsigns = {
        enable = true;
        attachToUntracked = true;
        currentLineBlame = true;
        numhl = true;
      };
      lsp-format.enable = true;
      fugitive.enable = true;
      nix.enable = true;
      undotree.enable = true;
      #      indent-blankline.enable = true;

      lsp = {
        enable = true;
        servers = {
          bashls.enable = true;
          clangd.enable = true;
          elixirls.enable = true;
          java-language-server.enable = true;
          # I swear Java is only for school, not my choice
          hls.enable = true;
          pylsp.enable = true;
          taplo.enable = true;
          texlab.enable = true;
          zls.enable = true;
          nil_ls.enable = true;

          rust-analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
          };
        };
      };
    };
  };
}
