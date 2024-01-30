{
  pkgs,
  hostName,
  stateVersion,
  ...
}: {
  # needed to get flakes to work
  environment.systemPackages = with pkgs; [git];

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/Los_Angeles";
  location.provider = "geoclue2";

  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
  };

  networking = {inherit hostName;};
  system = {inherit stateVersion;};
}
