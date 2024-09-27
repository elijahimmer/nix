{
  pkgs,
  inputs,
  ...
}: {
  imports = with inputs.nixos-hardware.nixosModules; [
    ./hardware-configuration.nix

    common-cpu-amd
    common-cpu-amd-pstate
    common-gpu-amd
    common-pc
    common-pc-ssd
  ];

  mein = {
    eimmer.headFull.enable = true;
    env.withCodingPkgs = true;
    pipewire.enable = true;
    pipewire.noisetorch.enable = true;
    music.enable = true;
    theme.enable = true;
    games.enable = true;
    #games.starCitizen.enable = true;
  };

  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_stable;

  systemd.coredump.enable = true;

  boot = {
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

  services.btrfs.autoScrub.enable = true;

  security.tpm2.enable = true;

  hardware = {
    enableAllFirmware = true;
    graphics = {
      enable = true;
      extraPackages = with pkgs.stable; [
        vulkan-validation-layers
        vulkan-extension-layer
        vulkan-loader
        vulkan-tools
      ];
    };

    cpu.amd.updateMicrocode = true;
  };

  services = {
    logind = {
      killUserProcesses = true;
      powerKey = "suspend";
      powerKeyLongPress = "poweroff";
    };
    thermald.enable = true;
  };
}
