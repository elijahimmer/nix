{
  pkgs,
  inputs,
  ...
}: {
  environment = {
    systemPackages = with pkgs; [
      btop
      conceal
      eza
      fd
      git
      gnumake
      pciutils
      neovim
      magic-wormhole
      skim
      wget
    ];

    shellAliases = {
      l = "eza -al";
      ls = "eza";
      n = "nix-shell -p";
      r = "nix repl ${inputs.utils.lib.repl}";
    };
  };

  programs.bash = {
    enable = true;
    undistractMe = {
      enable = true;
      playSound = true;
    };
  };
  environment = {
    systemPackages = [
    ];
  };

  programs = {
    neovim = {
      enable = true;
      configure = {
        packages.myVimPackage = with pkgs.vimPlugins; [nvchad];
      };
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;
      withPython3 = false;
      withRuby = false;
      withNodeJs = false;
    };
  };
}
