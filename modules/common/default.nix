{
  pkgs,
  hostName,
  pkgs-stable,
  stateVersion,
  ...
}: {
  imports = [
    ./nix.nix
  ];

  users.mutableUsers = false;

  security.sudo.execWheelOnly = true;
  # needed to get flakes to work
  environment.systemPackages = with pkgs; [git man-pages man-pages-posix];
  documentation.dev.enable = true;
  hardware.enableAllFirmware = true;

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/Los_Angeles";
  location.provider = "geoclue2";

  services = {
    # I shouldn't need this, but that's the point of having it
    #   It's to prevent the senario that you need it.
    clamav = {
      package = pkgs-stable.clamav;
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
}
