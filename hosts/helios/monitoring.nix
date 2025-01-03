{config, inputs, pkgs, lib, ...}: {

  age.secrets = {
    helios-grafana-password = {
      file = inputs.self + /secrets/helios-grafana-password.age;
      mode = "550";
      owner = "grafana";
      group = "grafana";
    };

    #helios-sonarr-token = {
    #  file = inputs.self + /secrets/helios-sonarr-token.age;
    #  mode = "550";
    #  owner = "sonarr";
    #  group = "sonarr";
    #};
  };

  services.grafana = {
    enable = true;

    settings = {
      analytics.reporting_enabled = false;
      server = {
        http_addr = "127.0.0.1";
        http_port = 3000;
        domain = "helios";
        root_url = "http://helios/grafana/";
        serve_from_sub_path = true;
        enable_gzip = true;
      };
      security = {
        admin_user = "eimmer";
        admin_password = "$__file{${config.age.secrets.helios-grafana-password.path}}";
        disable_initial_admin_creation = true;
        disable_gravatar = true;
      };
    };

    provision = {
      enable = true;

      datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          access = "proxy";
          url = "http://127.0.0.1:${toString config.services.prometheus.port}";
        }
        {
          name = "Loki";
          type = "loki";
          access = "proxy";
          url = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}";
        }
      ];

      dashboards.settings.providers = [
        {
          name = "Dashboards";
          allowUiUpdates = false;
          options.path = ./grafana-dashboards;
        }
      ];

      alerting.contactPoints.settings.contactPoints = [
        {
          name = "ntfy";
          url = "http://127.0.0.1/ntfy/grafana";
        }
      ];

      alerting.rules.path = ./grafana-alert-rules;
    };
  };

  services.loki = {
    enable = true;
    configuration = {
      server.http_listen_port = 3030;
      auth_enabled = false;

      common = {
        ring = {
          instance_addr = "127.0.0.1";
          kvstore.store = "inmemory";
        };
        replication_factor = 1;
        path_prefix = "/tmp/loki";
      };

      schema_config.configs = 
      [
        {
          from = "2020-05-15";
          store = "tsdb";
          object_store = "filesystem";
          schema = "v13";
          index.prefix = "index_";
          index.period = "24h";
        }
      ];

      storage_config.filesystem.directory = "/tmp/loki/chunks";
    };
  };

  services.promtail = {
    enable = true;
    configuration = {
      server = {
        http_listen_port = 3031;
        grpc_listen_port = 0;
      };

      positions = {
        filename = "/tmp/positions.yaml";
      };

      clients = [{
        url = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}/loki/api/v1/push";
      }];

      scrape_configs = [
        {
          job_name = "journal";
          journal = {
            json = false;
            max_age = "12h";
            labels = {
              job = "systemd-journal";
              host = "127.0.0.1";
            };
          };
          relabel_configs = [{
            source_labels = [ "__journal__systemd_unit" ];
            target_label = "unit";
          }];
        }
      ];
    };
  };

  services.prometheus = {
    enable = true;
    port = 9001;
    scrapeConfigs = let
      mkScrapeJob = name:
        let
          job = config.services.prometheus.exporters.${name};
          port = toString job.port;
        in
        {
          job_name = name;
          scrape_interval = if job ? maxInterval then job.maxInterval else "1m";
          static_configs = [
            {
              targets = [
                "127.0.0.1:${port}" "gaea:${port}" "selene:${port}"
              ];
            }
        ];
      };
      #mkLocalScrapeJob = name:
      #  let port = toString config.services.prometheus.exporters.${name}.port; in {
      #    job_name = name;
      #    static_configs = [
      #    {
      #      targets = [ "127.0.0.1:${port}" ];
      #    }
      #  ];
      #};
    in [
      (mkScrapeJob "node")
      (mkScrapeJob "systemd")
      (mkScrapeJob "smartctl")
      #(mkLocalScrapeJob "exportarr-sonarr")
      #(mkLocalScrapeJob "exportarr-radarr")
      #(mkLocalScrapeJob "exportarr-readarr")
      #(mkLocalScrapeJob "exportarr-prowlarr")
    ];

    exporters = {
      node.enable = true;
      systemd.enable = true;

      smartctl = {
        enable = true;
        group = "disk";

        maxInterval = "5m";
      };

      ## TODO: Fix exportarr to accept the API keys.
      #exportarr-sonarr = {
      #  enable = true;
      #  url = "http://127.0.0.1:8989";
      #  group = config.services.sonarr.group;
      #  apiKeyFile = config.age.secrets.helios-sonarr-token.path;
      #};
      #exportarr-radarr.enable = true;
      #exportarr-readarr.enable = true;
      #exportarr-prowlarr.enable = true;
    };
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="nvme", KERNEL=="nvme[0-9]*", GROUP="disk"
  '';
}
