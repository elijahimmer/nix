{pkgs, ...}: {
  config = {
    home-manager.users.eimmer = {pkgs, ...}: {
      services.wlsunset = {
        enable = true;
        latitude = "46.8521";
        longitude = "-121.7575";
        temperature.day = 5500;
        temperature.night = 3500;
      };
    };
  };
}
