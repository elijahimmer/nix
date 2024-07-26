{inputs, ...}: {
  #imports = with inputs.self.nixosModules; [
  #  custom.qbittorrent
  #];

  users.users.jellyfin.extraGroups = ["render" "video"];

  services = let
    enable = {
      enable = true;
      openFirewall = true;
    };
  in {
    jellyfin = enable;
    prowlarr = enable;
    qbittorrent = enable // {port = 8181;};
    sonarr = enable;
    radarr = enable;
    readarr = enable;

    ombi = enable // {port = 5050;};
  };
}
