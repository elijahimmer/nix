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
        name = "rose-pine";
        #name = "rose-pine-icons";
        package = pkgs.rose-pine-icon-theme;
      };
    };
  };
}
