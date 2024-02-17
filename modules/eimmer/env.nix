_: {
  home-manager.users.eimmer = {inputs, ...}: {
    
    programs.zoxide = {
      enable = true;
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
        autopairs.enable = true;
        binds.whichKey.enable = true;
        comments.comment-nvim.enable = true;
        git.enable = true;
        #hideSearchHighlight = true;

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
        # statusline.lualine = {};
        telescope.enable = true;
        
        useSystemClipboard = true;
        #utility.icon-picker.enable = true;
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
          # if I ever use it:
          # go.enable = true;
        };
      };
    };
  };
}
  
  
