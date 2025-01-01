{config, inputs, pkgs, ...}: {
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
        };
      };

      provision = {
        enable = true;
        datasources.settings.datasources = [
          {
            name = "InfluxDB_v2_InfluxQL";
            type = "influxdb";
            access = "proxy";

            url = "http://127.0.0.1:8086";

            jsonData = {
              dbName = "SmartData";
              httpHeaderName1 = "Authorization";
            };

            secureJsonData.httpHeaderValue1 =
              "Token $__file{${config.age.secrets.helios-influxdb2-grafana-token.path}}";
          }
          {
            name = "InfluxDB_v2_Flux";
            type = "influxdb";
            access = "proxy";

            url = "http://127.0.0.1:8086";

            jsonData = {
              version = "Flux";
              organization = "SMART";
              defaultBucket = "Smart Data";
              tlsSkipVerify = true;
            };

            secureJsonData.token =
              "$__file{${config.age.secrets.helios-influxdb2-grafana-token.path}}";
          }
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
      # extraFlags
    };

    #services.prometheus = {
    #  enable = true;
    #  port = 9001;
    #  exporters = {
    #    node = {
    #      enable = true;
    #      enabledCollectors = [ "systemd" ];
    #      port = 9002;
    #    };
    #    smartctl.enable = true;

    #    systemd.enable = true;
    #    #exportarr-sonarr = {
    #    #  enable = true;
    #    #  url = "127.0.0.1/sonarr";
    #    #  group = config.services.sonarr.group;
    #    #  apiKeyFile = config.age.secrets.helios-sonarr-key.path;
    #    #};
    #    #exportarr-radarr.enable = true;
    #    #exportarr-readarr.enable = true;
    #    #exportarr-prowlarr.enable = true;
    #  };
    #};
}
