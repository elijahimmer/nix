{
  pkgs,
  lib,
  ...
}: {
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      fira-code
      fira-code-symbols
      terminus_font
      powerline-fonts
      nerdfonts
      noto-fonts
      noto-fonts-cjk
      source-code-pro
      ttf_bitstream_vera
      terminus_font_ttf
      nerdfonts
      fira-go
      font-awesome
    ];
    fontDir.enable = true;
  };

  environment.systemPackages = with pkgs; [
    rose-pine-gtk-theme
    rose-pine-icon-theme
  ];

  home-manager.users.eimmer = {config, ...}: {
    gtk = lib.mkForce {
      enable = true;
      gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      theme = {
        name = "rose-pine";
        package = pkgs.rose-pine-gtk-theme;
      };
      iconTheme = {
        #name = "oomox-rose-pine";
        name = "rose-pine-icons";
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
