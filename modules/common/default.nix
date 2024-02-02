{
  pkgs,
  hostName,
  stateVersion,
  ...
}: {
  imports = [
    ./age.nix
    ./nix.nix
  ];
  security.sudo.execWheelOnly = true;
  # needed to get flakes to work
  environment.systemPackages = with pkgs; [git];

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
