{
  inputs,
  pkgs,
  ...
}: {
  imports = with inputs.nixos-hardware.nixosModules; [
    ./hardware-configuration.nix

    common-cpu-intel
    common-gpu-intel
    common-pc-laptop
    common-pc-laptop-ssd
  ];

  mein = {
    eimmer.headFull.enable = true;
    env.withCodingPkgs = true; bluetooth.enable = true; pipewire.enable = true;
    theme.enable = true;
  };

  environment.systemPackages = with pkgs; [
    intel-gpu-tools
    brightnessctl
    acpi
  ];

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_stable;

  # Actually takes code dumps for debugging.
  systemd.coredump.enable = true;

  services.btrfs.autoScrub.enable = true;
  boot = {
    initrd.secrets = {"/luks" = "/luks";};
    tmp.useTmpfs = true;
    loader = {
      grub = {
        memtest86.enable = true;
        enableCryptodisk = true;
        timeoutStyle = "hidden";
        efiSupport = true;
        device = "nodev";
        extraConfig = "GRUB_TIMEOUT=0";
      };
      efi = {
        efiSysMountPoint = "/boot/efi";
        canTouchEfiVariables = true;
      };
    };
  };

  security.tpm2.enable = true;

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
