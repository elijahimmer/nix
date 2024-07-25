{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.mein.theme;
in {
  imports = [inputs.stylix.nixosModules.stylix];

  options.mein.theme = {
    enable = lib.mkEnableOption "enable stylix theme";
    image = lib.mkOption {
      type = lib.types.path;
      default = ./background.png;
    };
  };

  config = lib.mkIf cfg.enable {
    stylix = {
      inherit (cfg) enable image;
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
  };
}
