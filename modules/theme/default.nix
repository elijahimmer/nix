{pkgs, ...}: {
  stylix = {
    image = import ./background.nix;
    base16Scheme = ./rose-pine-base16.yaml;
    polarity = "dark";
    opacity.terminal = 0.9;
    targets = {
      console.enable = false;
      gtk.enable = false;
      plymouth = {
        logo = ./background-small.png;
        logoAnimated = false;
      };
      nixvim.enable = false;
      fish.enable = false;
    };
    fonts = {
      serif = {
        package = pkgs.nerdfonts;
        name = "Fira Go";
      };
      sansSerif = {
        package = pkgs.nerdfonts;
        name = "Fira Go";
      };
      monospace = {
        package = pkgs.nerdfonts;
        name = "FiraCode Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
}
