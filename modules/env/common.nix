{pkgs, ...}: {
  environment = {
    systemPackages = with pkgs; [
      btop
      conceal
      eza
      fd
      git
      gnumake
      pciutils
      ripgrep
      magic-wormhole
      skim
      wget
      page
    ];
    shellAliases = {
      l = "eza -al";
      ls = "eza";
      n = "nix-shell -p";
      rm = ''echo "do you really wanna rm? use cnc! (or use \rm)"'';
      nr = pkgs.writeScript "nr" ''
        export NIX_SHELL_RUN_COMMAND=$@
        nix-shell -p "$1" --command ${pkgs.writeScript "nix-run-in-shell" ''
            $NIX_SHELL_RUN_COMMAND
          unset NIX_SHELL_RUN_COMMAND
        ''}
      '';
    };
  };
  programs.skim = {
    fuzzyCompletion = true;
    keybindings = true;
  };
  environment.sessionVariables = rec {
    EDITOR = "nvim";
    PAGER = "page";
    VISUAL = PAGER;
  };

  programs.nixvim = {
    enable = true;
    clipboard.register = "unnamedplus";
    # Make Neovim's Yank and Paste use the system clipboard
    # This should not be an issue even on systems without clipboards
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
      #list = true;
      #      listchars = "tab:⇤–⇥,trail:·,precedes:⇠,extends:⇢,nbsp:×";
    };
  };
}
