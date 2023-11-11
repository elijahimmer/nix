{
  pkgs,
  lib,
  ...
}: {
  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;
    packages = with pkgs; [nerdfonts fira-go];
  };

  environment.systemPackages = with pkgs; [
    rose-pine-gtk-theme
    rose-pine-icon-theme
  ];

  home-manager.users.eimmer = {config, ...}: {
    gtk = lib.mkForce {
      enable = true;
      gtk2 = {
        configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      };
      theme = {
        name = "rose-pine";
        package = pkgs.rose-pine-gtk-theme;
      };
      iconTheme = {
        name = "Rose-Pine";
        package = pkgs.rose-pine-icon-theme;
      };
    };
  };

  stylix = {
    image = ./background.png;
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
