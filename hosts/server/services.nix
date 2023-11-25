{inputs, ...}: {
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
  };
  #  systemd.services.tailscaled.script = ''mullvad-exclude tailscaled'';
}
