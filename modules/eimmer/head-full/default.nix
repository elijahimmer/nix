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
    ./wlrs-bar.nix
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

    environment.systemPackages = with pkgs; [
      wl-clipboard
      openjdk11
      google-java-format
      imv
      xdg-utils
      notify-desktop
      zathura
    ];
  };
}
