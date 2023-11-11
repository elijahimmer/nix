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
    ];
    shellAliases = {
      l = "eza -al";
      ls = "eza";
      n = "nix-shell -p";
      rm = ''echo "do you really wanna rm or cnc? (use \rm)"'';
    };
  };

  programs.nixvim = {
    enable = true;
    clipboard.providers.wl-copy.enable = true;
    colorschemes.rose-pine = {
      enable = true;
      transparentBackground = true;
      disableItalics = true;
    };
  };
}
