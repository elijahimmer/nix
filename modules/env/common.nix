{...}: {
  imports = [./packages.nix];

  environment = {
    shellAliases = {
      l = "eza -al";
      ls = "eza";
      la = "eza -a";
      rm = ''echo "do you really wanna rm? use cnc! (or use \rm)"'';
    };
  };

  programs.skim = {
    fuzzyCompletion = true;
    keybindings = true;
  };

  environment.variables = rec {
    EDITOR = "nvim";
    GIT_PAGER = EDITOR;
    PAGER = "page";
    VISUAL = PAGER;
  };

  programs.nixvim = {
    enable = true;
    clipboard.register = "unnamedplus";
    # Make Neovim's Yank and Paste use the system clipboard
    # I think I should work on this at some point, always
    #    using the clipboard is annoying.

    colorschemes.rose-pine = {
      enable = true;
      transparentBackground = true;
      disableItalics = true;
    };

    options = {
      browsedir = "buffer";
      mouse = "";
      number = true;
      relativenumber = true;
      smartindent = true;
      tabstop = 2;
      shiftwidth = 2;
    };
  };
}
