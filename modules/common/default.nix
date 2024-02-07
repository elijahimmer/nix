{
  pkgs,
  hostName,
  stateVersion,
  ...
}: {
  imports = [
    ./nix.nix
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  users.mutableUsers = false;

  security.sudo.execWheelOnly = true;
  # needed to get flakes to work
  environment.systemPackages = with pkgs; [git];
  hardware.enableAllFirmware = true;

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/Los_Angeles";
  location.provider = "geoclue2";

  # I shouldn't need this, but that's the point of having it
  #   It's to prevent the senario that you need it.
  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
  };

  networking = {inherit hostName;};
  system = {inherit stateVersion;};
}
