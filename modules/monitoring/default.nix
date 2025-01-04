{lib, config, ...}: 
let 
  cfg = config.mein.monitoring;
in with lib; {
  options.mein.monitoring = {
    enable = mkEnableOption "Enable monitoring and uploading to ";

    listenAddress =  mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = ''
        Address to listen on. This should be the tailscale address.
      '';
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Open port in firewall for incoming connections.
      '';
    };
  };

  config = mkIf cfg.enable {

    services.prometheus.exporters = let 
      enable = {
        enable = true;
        listenAddress = cfg.listenAddress;
        openFirewall = cfg.openFirewall;
      };

    in {
      node = enable;
      systemd = enable;

      smartctl = enable // {
        group = "disk";
        maxInterval = "5m";
      };
    };
  };
}
