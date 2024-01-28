{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    typst
    typst-live
    typstfmt

    gcc
    rustfmt

    elixir
    elixir-ls
    ghc
  ];

  programs.nixvim = {
    plugins = {
      which-key.enable = true;
      telescope.enable = true;
      treesitter.enable = true;
      typst-vim = {
        enable = true;
        concealMath = true;
      };
      gitsigns = {
        enable = true;
        attachToUntracked = true;
        currentLineBlame = true;
        numhl = true;
      };
      crates-nvim.enable = true;
      lsp-format.enable = true;
      #      nvim-cmp = {
      #        enable = true;
      #        sources = [
      #          {name = "nvim_lsp";}
      #          {name = "path";}
      #          {name = "buffer";}
      #          {name = "git";}
      #          {name = "crates";}
      #          {name = "clippy";}
      #        ];
      #      };
      #      cmp-greek.enable = true;
      #      cmp-nvim-lsp.enable = true;
      #      cmp-path.enable = true;
      #      cmp-git.enable = true;
      #      cmp-buffer.enable = true;
      #      cmp-clippy.enable = true;
      coq-nvim = {
        enable = true;
        alwaysComplete = true;
        autoStart = true;
        recommendedKeymaps = true;
      };
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
          typst-lsp.enable = true;
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
