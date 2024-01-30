{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = with inputs.self.nixosModules; [
    ./hardware-configuration.nix
    ./packages.nix
    ./services.nix

    users.eimmer

    common.all
    env.common
    env.coding

    misc.build-host
    misc.ssh-host
    misc.tailscale
  ];

  services.btrfs.autoScrub.enable = true;

  security = {
    tpm2.enable = true;
    protectKernelImage = true;
    polkit.enable = true;
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
