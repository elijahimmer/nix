{
  inputs,
  config,
  pkgs, lib,
  ... }: { users.users.jellyfin.extraGroups = ["render" "video"];

  age.secrets.helios-grafana-password = {
    file = inputs.self + /secrets/helios-grafana-password.age;
    mode = "550";
    owner = "grafana";
    group = "grafana";
  };

  age.secrets.helios-influxdb2-password = {
    file = inputs.self + /secrets/helios-influxdb2-password.age;
    mode = "550"; owner = "influxdb2";
    group = "influxdb2";
  };

  age.secrets.helios-influxdb2-admin-token = {
    file = inputs.self + /secrets/helios-influxdb2-admin-token.age;
    mode = "550";
    owner = "influxdb2";
    group = "influxdb2";
  };

  age.secrets.helios-telegraf-environment = {
    file = inputs.self + /secrets/helios-telegraf-environment.age;
    mode = "550";
    owner = "influxdb2";
    group = "influxdb2";
  };

  age.secrets.helios-influxdb2-telegraf-token = {
    file = inputs.self + /secrets/helios-influxdb2-telegraf-token.age;
    mode = "550";
    owner = "influxdb2";
    group = "influxdb2";
  };

  age.secrets.helios-influxdb2-grafana-token = {
    file = inputs.self + /secrets/helios-influxdb2-grafana-token.age;
    mode = "555";
    owner = "influxdb2";
    group = "grafana";
  };

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
      # Remove once I get away from IOS
      settings.upstream-base-url = "https://ntfy.sh";
    };

    jellyfin.enable = true;
    prowlarr.enable = true;
    sonarr.enable = true;
    radarr.enable = true;
    readarr.enable = true;

    qbittorrent.enable = true;
    qbittorrent.port = 8181;

    influxdb2 = {
      enable = true;
      package = pkgs.stable.influxdb2;
      provision = {
        enable = true;

        organizations."SMART" = {
          auths.grafana = {
            readPermissions = [ "buckets" ];
            writePermissions = [ "buckets" ];
            tokenFile = config.age.secrets.helios-influxdb2-grafana-token.path;
          };

          auths.telegraf = {
            readPermissions = [ "buckets" ];
            writePermissions = [ "buckets" ];

            tokenFile = config.age.secrets.helios-influxdb2-telegraf-token.path;
          };

          buckets."SmartData" = {};
        };

        initialSetup = {
          bucket = "SMART";
          username = "eimmer";
          organization = "SmartData";
          tokenFile = config.age.secrets.helios-influxdb2-admin-token.path;
          passwordFile = config.age.secrets.helios-influxdb2-password.path;
        };
      };
    };

    telegraf = {
      enable = true;
      environmentFiles = [ config.age.secrets.helios-telegraf-environment.path ];
      extraConfig = {
        agent = {
          interval = "10m";
          flush_interval = "10m";
          flush_jitter = "1m";
        };

        inputs = {
          smart = {
            path_smartctl = lib.getExe' pkgs.smartmontools "smartctl";
            path_nvme = lib.getExe pkgs.nvme-cli;
            attributes = true;
          };
        };

        outputs = {
          influxdb_v2 = {
            urls = ["http://127.0.0.1:8086"];
            token = ''''${INFLUX_TOKEN}'';
            organization = "SMART";
            bucket = "SmartData";
          };
        };
      };
    };
  };

  # TODO: let telegraf work without this terrible permissions issue
  systemd.services.telegraf.serviceConfig.User = lib.mkForce "root";
}
