{pkgs, ...}: {
  imports = [./packages.nix];

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
      p7zip
      socat
      jq
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
      ns = pkgs.writeScript "ns" ''
        nix search nixpkgs $@
      '';
      nse = pkgs.writeScript "nse" ''
        nix search nixpkgs '\.$1$'
      '';
      ap = pkgs.writeScript "ap" ''
        search_results=nse $1

        if [ $? ]; then
          return 0
        fi

        echo "is $(printf $search_results | head -n 1)"

        match='    ### INSERT PACKAGES HERE'
        file='/flakes/nix/hosts/$HOSTNAME/packages.nix'

        sed -i "s/$match/$match\n$@/" $file
      '';
      apg = pkgs.writeScript "apg" ''
        packages=nix search nixpkgs --json $@ | jq 'keys[]'

        echo "Which package looks correct?"

        arr=()
        $packages | while read i
        do
          echo $i
          arr+=("$i")
        done


        package=test

        match='    ### INSERT PACKAGES HERE'
        file='/flakes/nix/modules/env/packages.nix'
        sed -i "s/$match/$match\n$package/" $file
      '';
    };
  };
  programs.skim = {
    fuzzyCompletion = true;
    keybindings = true;
  };
  environment.variables = rec {
    EDITOR = "nvim";
    PAGER = "page";
    VISUAL = PAGER;
    GIT_PAGER = "nvim";
  };

  stylix.targets.nixvim.enable = false;
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
