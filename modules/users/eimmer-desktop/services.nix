{lib, ...}: {
  # enable virtual disks for garbage and the like
  services.gvfs.enable = true;

  home-manager.users.eimmer = {...}: {
    services.wlsunset = {
      enable = true;
      latitude = "46";
      longitude = "-121";
      temperature.day = 5500;
      temperature.night = 3500;
    };
    services.mako = {
      enable = true;
      #backgroundColor = "#26233a";
      #borderColor = "#1f1d2e";
      margin = "0";
      defaultTimeout = 10000; # 10 seconds
    };
  };

  /*
  stylix.targets.plymouth.enable = false;
  boot.plymouth = {
    enable = true;
    logo = lib.mkForce ./background-small.png;
  };
  */
}
