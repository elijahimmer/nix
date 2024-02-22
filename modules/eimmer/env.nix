_: {
  home-manager.users.eimmer = {inputs, ...}: {
    programs = {
      bash.enable = true;

      zoxide = {
        enable = true;
        enableBashIntegration = true;
        options = ["--cmd cd"];
      };
    };

    # Neovim-flake
    imports = [ inputs.neovim-flake.homeManagerModules.default ];
    programs.neovim-flake = {
      enable = true;

      settings.vim = {
        viAlias = false;
        vimAlias = true;
        lsp.enable = true;
        autoIndent = true;
        autocomplete = {
          enable = true;
          mappings = {
            complete = "<C-CR>";
          };
          sources = {
            nvim-cmp = null;
            buffer = "[Buffer]";
          };
        };
        binds.whichKey.enable = true;
        comments.comment-nvim.enable = true;
        git.enable = true;

        theme = {
          enable = true;
          # only for now...
          name = "rose-pine";
          style = "main";
          transparent  = true;
        };

        treesitter.enable = true;

        lineNumberMode = "relNumber";

        notes.todo-comments.enable = true;
        searchCase = "smart";
        spellChecking.enable = true;
        splitBelow = true;
        splitRight = true;
        telescope.enable = true;
        
        useSystemClipboard = true;
        wordWrap = true;

        languages = {
          enableDAP = true;
          enableFormat = true;
          enableLSP = true;
          enableTreesitter = true;
          bash.enable = true;
          clang.enable = true;
          css.enable = true;
          elixir.enable = true;
          markdown.enable = true;
          nix = {
            enable = true;
            extraDiagnostics.enable = true;
          };
          python.enable = true;
          rust.enable = true;
          zig.enable = true;
          # only for school...
          java.enable = true;
        };
      };
    };
  };
}
  
  
