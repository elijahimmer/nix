{
  lib,
  config,
  pkgs,
  inputs,
  system,
  ...
}: let
  cfg = config.mein.eimmer.headFull.services;
in
  with lib; {
    options.mein.eimmer.headFull.services = {
      enable = mkEnableOption "enable default services" // {default = config.mein.eimmer.headFull.enable;};
      target = mkOption {type = types.listOf types.str;};
    };

    config = mkMerge [
      (mkIf cfg.enable {
        # enable virtual disks for garbage and the like
        services.gvfs.enable = true;

        systemd.user.services = {
          swaybg = {
            wantedBy = cfg.target;
            script = "sleep 1; ${getExe pkgs.swaybg} --mode fit --color '#191724' --image ${toString config.mein.theme.image}";
          };
        };

        home-manager.users.eimmer = {
          services.wlsunset = {
            enable = true;
            latitude = "46";
            longitude = "-121";
            temperature.day = 5500;
            temperature.night = 3500;
          };

          services.mako = {
            enable = true;
            margin = "0";
            defaultTimeout = 10000; # 10 seconds
          };
        };
      })
    ];
  }
