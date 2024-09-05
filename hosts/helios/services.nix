{
  inputs,
  config,
  ...
}: {
  users.users.jellyfin.extraGroups = ["render" "video"];

  age.secrets.helios-homepage.file = inputs.self + /secrets/helios-homepage.age;
  age.secrets.nginx-passwords = {
    file = inputs.self + /secrets/nginx-passwords.age;
    mode = "770";
    owner = "nginx";
    group = "nginx";
  };

  services = let
    enable = {enable = true;};
  in {
    jellyfin = enable;
    prowlarr = enable;
    qbittorrent = enable // {port = 8181;};
    sonarr = enable;
    radarr = enable;
    #readarr = enable; # Disabled because I don't use it
    scrutiny = {
      enable = true;
      settings.web.listen = {
        port = 7676;
        basepath = "/scrutiny";
      };
    };

    #ombi = enable // {port = 5050;};

    nginx = let
      proxy = port: {
        proxyPass = "http://127.0.0.1:${port}";
        proxyWebsockets = true;
      };
      proxyRewrite = service: port:
        proxy port
        // {
          extraConfig = "rewrite ^/${service}/(.*) /$1 break;";
        };
    in {
      enable = true;

      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      clientMaxBodySize = "20M";

      virtualHosts."127.0.0.1".locations = {
        "/" = {return = "301 /jellyfin/web/";};
        "/jellyfin" = proxy "8096";
        "/media" = {
          root = "/disks";
          basicAuthFile = config.age.secrets.nginx-passwords.path;
          extraConfig = "
            autoindex on;
            autoindex_format html;
            autoindex_exact_size off;
            autoindex_localtime on;
          ";
          };
        #"/ombi" = proxyRewrite "ombi" (toString config.services.ombi.port); # Get this to work
      };

      tailscaleAuth = {
        enable = true;
        expectedTailnet = "orca-pythagorean.ts.net";
        virtualHosts = ["helios"];
      };
      virtualHosts."helios".locations = 
        config.services.nginx.virtualHosts."127.0.0.1".locations
      // {
        "/" = proxy "8082";
        "/qbit" = proxyRewrite "qbit" (toString config.services.qbittorrent.port);
        "/sonarr" = proxy "8989";
        "/prowlarr" = proxy "9696";
        "/radarr" = proxy "7878";
        #"/readarr" = proxy "8787";
        "/scrutiny" = proxy (toString config.services.scrutiny.settings.web.listen.port);
        "/influx" = proxy "8086";
      };
    };

    homepage-dashboard =
      enable
      // {
        environmentFile = config.age.secrets.helios-homepage.path;
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
            Services = [
              {
                Sonarr = {
                  icon = "http://helios/sonarr/Content/Images/logo.svg";
                  href = "/sonarr";
                  siteMonitor = "http://helios/sonarr/";
                  widget = {
                    type = "sonarr";
                    url = "http://helios/sonarr";
                    key = "{{HOMEPAGE_VAR_SONARR_API_KEY}}";
                    enableQueue = true;
                  };
                };
              }
              {
                Radarr = {
                  icon = "http://helios/radarr/Content/Images/logo.svg";
                  href = "/radarr";
                  siteMonitor = "http://helios/radarr";
                  widget = {
                    type = "radarr";
                    url = "http://helios/radarr";
                    key = "{{HOMEPAGE_VAR_RADARR_API_KEY}}";
                    enableQueue = true;
                  };
                };
              }
              #{
              #  Readarr = {
              #    icon = "http://helios/readarr/Content/Images/logo.svg";
              #    href = "/readarr";
              #    siteMonitor = "http://helios/readarr";
              #    widget = {
              #      type = "readarr";
              #      url = "http://helios/readarr";
              #      key = "{{HOMEPAGE_VAR_READARR_API_KEY}}";
              #      enableQueue = true;
              #    };
              #  };
              #}
              {
                Prowlarr = {
                  icon = "http://helios/prowlarr/Content/Images/logo.svg";
                  href = "/prowlarr";
                  siteMonitor = "http://helios/prowlarr";
                  widget = {
                    type = "prowlarr";
                    url = "http://helios/prowlarr";
                    key = "{{HOMEPAGE_VAR_PROWLARR_API_KEY}}";
                    enableQueue = true;
                  };
                };
              }
            ];
          }
          {
            Misc = [
              {
                Jellyfin = {
                  icon = "http://helios/jellyfin/web/39209dd2362c0db7c673.png";
                  href = "/jellyfin/web/";
                  siteMonitor = "http://helios/jellyfin/web/";
                  widget = {
                    type = "jellyfin";
                    url = "http://helios/jellyfin";
                    key = "{{HOMEPAGE_VAR_JELLYFIN_API_KEY}}";
                    enableNowPlaying = true;
                    enableUser = true;
                    showEpisodeNumber = true;
                    enableBlocks = true;
                  };
                };
              }
              {
                Scrutiny = {
                  icon = "http://helios/scrutiny/web/assets/images/logo/scrutiny-logo-dark.png";
                  href = "/scrutiny/";
                  siteMonitor = "http://helios/scrutiny/";
                  widget = {
                    type = "scrutiny";
                    url = "http://helios/scrutiny";
                  };
                };
              }
              {
                qBittorrent = {
                  icon = "http://helios/qbit/images/qbittorrent-tray.svg";
                  href = "/qbit/";
                  siteMonitor = "http://helios/qbit/";
                  widget = {
                    type = "qbittorrent";
                    url = "http://helios/qbit";
                    username = "{{HOMEPAGE_VAR_QBIT_USERNAME}}";
                    password = "{{HOMEPAGE_VAR_QBIT_PASSWORD}}";
                  };
                };
              }
              #{
              #  Ombi = {
              #    icon = "http://helios:5050/images/favicon/favicon.ico";
              #    href = "/ombi/";
              #    siteMonitor = "http://helios:5050/";
              #    widget = {
              #      type = "ombi";
              #      url = "http://helios:5050";
              #      key = "{{HOMEPAGE_VAR_OMBI_API_KEY}}";
              #      enableQueue = true;
              #    };
              #  };
              #}
            ];
          }
        ];
      };
  };
}
