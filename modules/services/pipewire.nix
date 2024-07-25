{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mein.pipewire;
in
  with lib; {
    options.mein.pipewire = {
      enable = mkEnableOption "enable pipewire for sound";
      noisetorch = {
        enable = mkEnableOption "enable noisetorch noise supression" // {default = true;};
        target = mkOption {
          type = types.listOf types.str;
          default = ["default.target"];
        };
      };
    };

    config = mkMerge [
      (mkIf cfg.enable {
        security.rtkit.enable = true;
        services.pipewire = {
          enable = true;
          alsa = {
            enable = true;
            support32Bit = true;
          };
          pulse.enable = true;
        };
      })
      (mkIf (cfg.enable && cfg.noisetorch.enable) {
        programs.noisetorch.enable = true;
        systemd.user.services.noisetorch = {
          wantedBy = cfg.noisetorch.target;
          after = ["pipewire.service"];
          script = "sleep 1; ${getExe pkgs.noisetorch} -i";
        };
      })
    ];
  }
