{
  inputs,
  config,
  ...
}: {
  users.users.jellyfin.extraGroups = ["render" "video"];

  age.secrets.helios-homepage.file = inputs.self + /secrets/helios-homepage.age;

  ## TODO: REMOVE THIS ONCE SONARR IS UPDATED
  nixpkgs.config.permittedInsecurePackages = [
    "aspnetcore-runtime-6.0.36"
    "aspnetcore-runtime-wrapped-6.0.36"
    "dotnet-sdk-6.0.428"
    "dotnet-sdk-wrapped-6.0.428"
  ];
  ##

  services = {
    jellyfin.enable = true;
    prowlarr.enable = true;
    qbittorrent.enable = true;
    qbittorrent.port = 8181;
    sonarr.enable = true;
    radarr.enable = true;
    readarr.enable = true;
    scrutiny = {
      enable = true;
      settings.web.listen = {
        port = 7676;
        basepath = "/scrutiny";
      };
    };
    grafana = {
      enable = true;
      settings = {
        server = {
          http_addr = "127.0.0.1";
          http_port = 3000;
          domain = "helios";
          root_url = "http://helios/grafana/";
          serve_from_sub_path = true;
        };
      };
    };

    #ombi = enable // {port = 5050;};

    homepage-dashboard = {
        enable = true;
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
