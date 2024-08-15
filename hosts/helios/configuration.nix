{
  pkgs,
  pkgs-stable,
  inputs,
  ...
}: {
  imports = with inputs.nixos-hardware.nixosModules; [
    ./hardware-configuration.nix
    ./services.nix

    common-cpu-intel
    common-gpu-amd
    common-pc
    common-pc-ssd
  ];

  mein = {
    sshHost.enable = true;
    syncthing.enable = true;
  };

  services.btrfs.autoScrub.enable = true;

  security = {
    tpm2.enable = true;
    protectKernelImage = true;
  };

  hardware = {
    enableAllFirmware = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs-stable; [
        vulkan-validation-layers
        vulkan-extension-layer
        vulkan-loader
        vulkan-tools
      ];
    };

    cpu.intel.updateMicrocode = true;
  };

  boot = {
    tmp.useTmpfs = true;
    loader = {
      grub = {
        memtest86.enable = true;
        enableCryptodisk = true;
        efiSupport = true;
        device = "nodev";
      };
      efi = {
        efiSysMountPoint = "/boot/efi";
        canTouchEfiVariables = true;
      };
    };
  };
}
