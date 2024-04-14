{inputs, hostName, ...}: {
  imports = with inputs.self.nixosModules; [
    custom.qbittorrent
  ];

  services = {
    jellyfin = {
      enable = true;
      openFirewall = true;
    };
    jellyseerr = {
      enable = true;
      openFirewall = true;
    };
    sonarr = {
      enable = true;
      openFirewall = true;
    };
    prowlarr = {
      enable = true;
      openFirewall = true;
    };
    qbittorrent = {
      enable = true;
      openFirewall = true;
      port = 8181;
    };
    radarr = {
      enable = true;
      openFirewall = true;
    };
    readarr = {
      enable = true;
      openFirewall = true;
    };

    samba = {
      enable = true;
      enableWinbindd = true;
      openFirewall = true;
      shares = {
        public = {
          path = "/disks/";
          "read only" = true;
          browseable = "yes";
          "guest ok" = "yes";
          comment = "Public samba share.";
        };
      };
      extraConfig = ''
        guest account = nobody
        map to guest = bad user
      '';
    };
  };

  services.matrix-conduit = {
    enable = true;
    settings.global = {
      server_name = "Regnum Somnia";
      address = hostName;
      allow_registration = false;
      allow_federation = true;
      allow_encryption = true;

      trusted_servers = ["matrix.org"];
    };
  };
}
