{
  pkgs,
  hostName,
  ...
}: {
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
}
