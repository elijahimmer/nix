{
  inputs,
  pkgs,
  lib,
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
    env.withCodingPkgs = true;
    syncthing.enable = true;

    bluetooth.enable = true;
    pipewire.enable = true;
    theme.enable = true;
    monitoring.enable = true;
    games.enable = true;
  };

  environment.systemPackages = with pkgs; [
    intel-gpu-tools
    acpi
  ];

  hardware.intelgpu = {
    driver = "xe";
    vaapiDriver = "intel-media-driver";
  };

  hardware.graphics = {
    enable = true;
    extraPackages = [pkgs.vpl-gpu-rt];
  };

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_stable;

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${lib.getExe' pkgs.toybox "chgrp"} video $sys$devpath/brightness" RUN+="${lib.getExe' pkgs.toybox "chmod"} g+w $sys$devpath/brightness"
  '';

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
        SOUND_POWER_SAVE_ON_AC = 1;
        SOUND_POWER_SAVE_ON_BAT = 1;
        SOUND_POWER_SAVE_CONTROLLER = "Y";

        NATACPI_ENABLE = 1;

        STOP_CHARGE_THRESH_BAT0 = "95";

        NMI_WATCHDOG=0;

        WIFI_PWR_ON_AC="off";
        WIFI_PWR_ON_BAT="on";

        # CPU settings 
        CPU_ENERGY_PERF_POLICY_ON_AC="performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT="power";

        PLATFORM_PROFILE_ON_AC="performance";
        PLATFORM_PROFILE_ON_BAT="low-power";

        CPU_BOOST_ON_AC = "1";
        CPU_BOOST_ON_BAT = "0";

        CPU_HWP_DYN_BOOST_ON_AC = "1";
        CPU_HWP_DYN_BOOST_ON_BAT = "0";

        CPU_SCALING_GOVERNOR_ON_AC="performance";
        CPU_SCALING_GOVERNOR_ON_BAT="powersave";

        MEM_SLEEP_ON_AC="s2idle";
        MEM_SLEEP_ON_BAT="deep";
     };
    };
  };
}
