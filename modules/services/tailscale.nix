{
  lib,
  config,
  ...
}:
with lib; {
  options.mein.tailscale.enable = lib.mkEnableOption "enable the tailscale daemon" // {default = config.mein.env.enable;};

  config = mkIf config.mein.tailscale.enable {
    networking.firewall = {
      # Note from https://github.com/MatthewCroughan/nixcfg/blob/master/modules/profiles/tailscale.nix 10/21/2023
      # trace: warning: Strict reverse path filtering breaks Tailscale exit node
      # use and some subnet routing setups. Consider setting
      # `networking.firewall.checkReversePath` = 'loose'

      # Checked July 6th 2024: still needed.
      checkReversePath = "loose";
      trustedInterfaces = ["tailscale0"];
    };
    services.tailscale = {
      enable = true;
      extraUpFlags = ["--ssh"];
    };
  };
}
