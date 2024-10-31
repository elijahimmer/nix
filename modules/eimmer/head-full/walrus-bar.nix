{
  lib,
  config,
  inputs,
  system,
  ...
}: let
  cfg = config.mein.eimmer.headFull.walrus-bar;
in
  with lib; {
    options.mein.eimmer.headFull.walrus-bar = {
      enable = mkEnableOption "enable walrus-bar" // {default = config.mein.eimmer.headFull.enable;};
      target = mkOption {
        type = types.listOf types.str;
        default = config.mein.eimmer.headFull.services.target;
        description = "the systemd targets to start on.";
      };
      #updatedLast = {
      #  enable = mkEnableOption "enable updated last widget" // {default = true;};
      #  timestamp = mkOption {
      #    type = types.str;
      #    default = builtins.readFile (inputs.self + /updated_last);
      #  };
      #};
    };

    config = mkIf cfg.enable {
      systemd.user.services.walrus-bar = {
        wantedBy = cfg.target;
        script = getExe inputs.walrus-bar.packages.${system}.default;
      };
    };
  }
