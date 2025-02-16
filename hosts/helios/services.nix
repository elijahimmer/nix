{inputs, config, ...}: {

  ## Remarkable device sync
  services.rmfakecloud = {
    enable = true;
    port = 8909;
    environmentFile = config.age.secrets.helios-rmfakecloud-keys.path;
    storageUrl = "https://helios:${toString config.services.rmfakecloud.port}";
    extraSettings = {
      #DATADIR = "/disks/media/remarkable";
    };
  };

  age.secrets = {
    helios-rmfakecloud-keys = {
      file = inputs.self + /secrets/helios-rmfakecloud.age;
      mode = "400";
      owner = "root";
      group = "root";
    };
  };
  ##

  users.users.jellyfin.extraGroups = ["render" "video"];

  ## TODO: REMOVE THIS ONCE SONARR IS UPDATED
  nixpkgs.config.permittedInsecurePackages = [
    "aspnetcore-runtime-6.0.36"
    "aspnetcore-runtime-wrapped-6.0.36"
    "dotnet-sdk-6.0.428"
    "dotnet-sdk-wrapped-6.0.428"
  ];
  ##

  users.groups.media = {};

  services = {
    ntfy-sh = {
      enable = true;
      settings.base-url = "http://127.0.0.1:4906/";
      settings.listen-http = ":4906";
      # TODO: Set up push notifications on IOS with upstream server.
      # # Remove once I get away from IOS
      # settings.upstream-base-url = "https://ntfy.sh";
    };

    jellyfin = {
      enable = true;
      group = "media";
    };

    prowlarr.enable = true;

    sonarr = {
      enable = true;
      group = "media";
    };
    radarr = {
      enable = true;
      group = "media";
    };
    readarr = {
      enable = true;
      group = "media";
    };


    qbittorrent.enable = true;
    qbittorrent.port = 8181;
  };
}
