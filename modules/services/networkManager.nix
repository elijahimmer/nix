{
  pkgs,
  hostName,
  config,
  lib,
  ...
}:
with lib; {
  options.mein.networkManager.enable = mkEnableOption "use NetworkManager for networking" // {default = config.mein.env.enable;};

  config = mkIf config.mein.networkManager.enable {
    networking = {
      inherit hostName;
      networkmanager = {
        enable = true;
        wifi = {
          scanRandMacAddress = true;
          powersave = true;
          macAddress = "preserve";
          backend = "wpa_supplicant";
        };
      };
    };
    environment.systemPackages = with pkgs; [wpa_supplicant_gui];
  };
}
