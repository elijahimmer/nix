{
  lib,
  config,
  inputs,
  system,
  ...
}: let
  cfg = config.mein.eimmer.headFull.wlrs-bar;
in
  with lib; {
    options.mein.eimmer.headFull.wlrs-bar = {
      enable = mkEnableOption "enable wlrs-bar" // {default = config.mein.eimmer.headFull.enable;};
      target = mkOption {
        type = types.listOf types.str;
        default = config.mein.eimmer.headFull.services.target;
        description = "the systemd targets to start on.";
      };
      updatedLast = {
        enable = mkEnableOption "enable updated last widget" // {default = true;};
        timestamp = mkOption {
          type = types.str;
          default = builtins.readFile (inputs.self + /updated_last);
        };
      };
    };

    config = mkIf cfg.enable {
      systemd.user.services.wlrs-bar = {
        wantedBy = cfg.target;
        script = "${getExe inputs.wlrs-bar.packages.${system}.default} --updated-last ${cfg.updatedLast.timestamp}";
      };
    };
  }
