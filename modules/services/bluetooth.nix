{
  lib,
  config,
  ...
}:
with lib; {
  options.mein.services.bluetooth.enable = mkEnableOption "enable bluetooth";

  config = mkIf config.mein.services.bluetooth.enable {
    hardware.bluetooth.enable = lib.mkForce true;
    services.blueman.enable = true;
  };
}
