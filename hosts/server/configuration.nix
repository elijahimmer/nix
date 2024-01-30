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

    env.common
    env.coding

    misc.ssh-host
    misc.tailscale
    misc.upgrade
    misc.common
  ];

  services = {
    openssh = {
      enable = true;
      startWhenNeeded = true;
      # TODO: Add age nix or another secrets method and get the authorized keys here!
      banner = ''
        ===========================================
          HERE BE DRAGONS; BEWARE OF WATERS AHEAD
        ===========================================
      '';
    };
    btrfs.autoScrub.enable = true;
    tailscale.useRoutingFeatures = "both";
  };

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
