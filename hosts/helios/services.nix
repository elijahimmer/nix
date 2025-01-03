_: {
  users.users.jellyfin.extraGroups = ["render" "video"];

  ## TODO: REMOVE THIS ONCE SONARR IS UPDATED
  nixpkgs.config.permittedInsecurePackages = [
    "aspnetcore-runtime-6.0.36"
    "aspnetcore-runtime-wrapped-6.0.36"
    "dotnet-sdk-6.0.428"
    "dotnet-sdk-wrapped-6.0.428"
  ];
  ##

  services = {
    ntfy-sh = {
      enable = true;
      settings.base-url = "http://127.0.0.1:4906/";
      settings.listen-http = ":4906";
      # TODO: Set up push notifications on IOS with upstream server.
      # # Remove once I get away from IOS
      # settings.upstream-base-url = "https://ntfy.sh";
    };

    jellyfin.enable = true;
    prowlarr.enable = true;
    sonarr.enable = true;
    radarr.enable = true;
    readarr.enable = true;

    qbittorrent.enable = true;
    qbittorrent.port = 8181;
  };
}
