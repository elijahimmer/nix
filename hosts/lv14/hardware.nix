{pkgs, ...}: {
  services.btrfs.autoScrub.enable = true;

  security = {
    tpm2.enable = true;
  };

  hardware = {
    enableAllFirmware = true;
    opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        vulkan-validation-layers
        vulkan-extension-layer
        vulkan-loader
        vulkan-tools
      ];
    };

    cpu.intel.updateMicrocode = true;
  };

  systemd.sleep.extraConfig = "HibernateDelaySec=5m";
  services = {
    logind = {
      killUserProcesses = true;
      powerKey = "suspend-then-hibernate";
      powerKeyLongPress = "poweroff";

      lidSwitch = "suspend-then-hibernate";
      lidSwitchExternalPower = "suspend-then-hibernate";
      lidSwitchDocked = "ignore";
    };
    thermald.enable = true;
    tlp = {
      enable = true;
      settings = {
        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        PLATFORM_PROFILE_ON_AC = "balanced";
        PLATFORM_PROFILE_ON_BAT = "low-power";

        CPU_BOOST_ON_AC = "1";
        CPU_BOOST_ON_BAT = "0";

        CPU_HWP_DYN_BOOST_ON_AC = "1";
        CPU_HWP_DYN_BOOST_ON_BAT = "0";

        RUNTIME_PM_ON_AC = "auto";
        RUNTIME_PM_ON_BAT = "auto";

        SOUND_POWER_SAVE_ON_AC = 1;
        SOUND_POWER_SAVE_ON_BAT = 1;

        NATACPI_ENABLE = 1;

        STOP_CHARGE_THRESH_BAT0 = "95";
      };
    };
  };
}
