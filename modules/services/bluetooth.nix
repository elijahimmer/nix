{
  lib,
  config,
  ...
}:
with lib; {
  options.mein.bluetooth.enable = mkEnableOption "enable bluetooth";

  config = mkIf config.mein.bluetooth.enable {
    hardware.bluetooth.enable = mkForce true;
    services.blueman.enable = true;
  };
}
