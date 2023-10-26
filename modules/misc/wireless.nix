{pkgs, ...}: {
  environment.systemPackages = with pkgs; [wpa_supplicant_gui];
  networking.wireless = {
    enable = true;
    userControlled.enable = true;
  };
}
