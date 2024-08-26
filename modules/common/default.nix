{
  pkgs,
  hostName,
  stateVersion,
  lib,
  config,
  headFull,
  ...
}: let
  cfg = config.mein.common;
in {
  imports = [./nix.nix];

  options.mein.common.enable = lib.mkEnableOption "enable common configuration" // {default = true;};

  config = lib.mkIf cfg.enable {
    users.mutableUsers = false;

    security.sudo.execWheelOnly = true;
    # needed to get flakes to work
    environment.systemPackages = with pkgs; [git];
    documentation.enable = config.mein.eimmer.headFull.enable;
    documentation.dev.enable = true;
    hardware.enableAllFirmware = true;

    i18n.defaultLocale = "en_US.UTF-8";
    time.timeZone = "America/Los_Angeles";
    location.provider = "geoclue2";

    services = {
      # I shouldn't need this, but that's the point of having it
      #   It's to prevent the senario that you need it.
      clamav = {
        package = pkgs.stable.clamav;
        daemon.enable = true;
        updater.enable = true;
      };

      # make sure to trim ssds
      fstrim.enable = true;

      # make sure disks are actually monitored
      smartd.enable = true;
    };

    networking = {inherit hostName;};
    system = {inherit stateVersion;};
  };
}
