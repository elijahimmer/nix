{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./alacritty.nix
    ./firefox
    ./hyprland.nix
    ./services.nix
    ./theme.nix
    ./walrus-bar.nix
    ./xdg.nix
  ];

  options.mein.eimmer.headFull.enable = lib.mkEnableOption "install GUI tools and environments";

  config = lib.mkIf config.mein.eimmer.headFull.enable {
    security.polkit.enable = true;

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "Hyprland";
          user = "eimmer";
        };
      };
    };

    home-manager.users.eimmer.home.packages = with pkgs; [
      wl-clipboard
      openjdk21
      google-java-format
      imv
      xdg-utils
      notify-desktop
      zathura
    ];
  };
}
