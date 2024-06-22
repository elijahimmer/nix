{pkgs, ...}: {
  services.btrfs.autoScrub.enable = true;

  security = {
    tpm2.enable = true;
  };

  hardware = {
    enableAllFirmware = true;
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        vulkan-validation-layers
        vulkan-extension-layer
        vulkan-loader
        vulkan-tools
      ];
    };

    cpu.amd.updateMicrocode = true;
  };

  systemd.sleep.extraConfig = "HibernateDelaySec=5m";
  services = {
    logind = {
      killUserProcesses = true;
      powerKey = "suspend-then-hibernate";
      powerKeyLongPress = "poweroff";
    };
    thermald.enable = true;
  };
}
