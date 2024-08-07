{inputs, config, pkgs, lib, ...}: {
  users.users.jellyfin.extraGroups = ["render" "video"];

  services = let
    enable = {enable = true;};
  in {
    jellyfin = enable;
    prowlarr = enable;
    qbittorrent = enable // {port = 8181;};
    sonarr = enable;
    radarr = enable;
    readarr = enable;
    scrutiny = enable // {settings.web.listen = {port = 7676; basepath = "/scrutiny";};};

    ombi = enable // {port = 5050;};

    nginx = {
      enable = true;

      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      clientMaxBodySize =  "20M";

      virtualHosts."127.0.0.1" = {
        locations = let 
          proxy = port: {
            proxyPass = "http://127.0.0.1:${port}";
            proxyWebsockets = true;
          };
          proxyRewrite = service: port: proxy port // {
            extraConfig = "rewrite ^/${service}/(.*) /$1 break;";
          };
        in {
          "/jellyfin" = proxyRewrite "jellyfin" "8096";
          "/qbit" = proxyRewrite "qbit" (toString config.services.qbittorrent.port);
          #"/ombi" = proxyRewrite "ombi" (toString config.services.ombi.port); # Get this to work
          "/sonarr" = proxy "8989";
          "/prowlarr" = proxy "9696";
          "/radarr" = proxy "7878";
          "/readarr" = proxy "8787";
          "/scrutiny" = proxy (toString config.services.scrutiny.settings.web.listen.port);
        };
      };
    };

    homepage-dashboard = enable // {
      widgets = [
        {
          resources = {
            cpu = true;
            memory = true;
          };
        }
        {
          resources = {
            label = "Root";
            disk = "/";
          };
        }
        {
          resources = {
            label = "Media";
            disk = "/disks/media";
          };
        }
        {
          resources = {
            label = "qBittorrent";
            disk = "/disks/qbit";
          };
        }
      ];
      services = [
        {
          sonarr = {
            type = "sonarr";
            url = "http://localhost:8989";
            key = "ce838b6e37f147d3b0447f9b2422b394";
            enableQueue = true;
          };
        }
      ];
    };
  };
}
