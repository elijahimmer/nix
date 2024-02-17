{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.parrot;
in
{
  options = {
    services.parrot = {
      enable = mkEnableOption (lib.mdDoc "Parrot Discord Music Bot");

      user = mkOption {
        type = types.str;
        default = "parrot";
        description = lib.mdDoc "User account under which Parrot runs.";
      };

      package = mkPackageOption pkgs "parrot" { };

      group = mkOption {
        type = types.str;
        default = "parrot";
        description = lib.mdDoc "Group under which Parrot runs.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.parrot = {
      description = "Parrot Discord Music Bot";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = "parrot";
        SyslogIdentifier = "parrot";
        ExecStart = "${lib.getExe cfg.package}";
        Restart = "on-failure";
        TimeoutSec = 15;
      };
    };

    users.users = mkIf (cfg.user == "parrot") {
      parrot = {
        inherit (cfg) group;
        isSystemUser = true;
        home = "/var/lib/${config.systemd.services.parrot.serviceConfig.StateDirectory}";
      };
    };

    users.groups = mkIf (cfg.group == "parrot") {
      parrot = {};
    };
  };

  meta.maintainers = [ ];
}
