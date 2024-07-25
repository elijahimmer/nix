{
  pkgs,
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.mein.eimmer.headFull.enable {
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
