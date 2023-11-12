{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = with inputs.self.nixosModules; [
    ./hardware-configuration.nix
    ./hardware.nix
    ./packages.nix

    users.eimmer

    env.common
    env.coding

    misc.tailscale
    misc.mullvad
    misc.networkmanager

    misc.upgrade
    misc.common
  ];

  nixpkgs.config.allowUnfree = true;

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/Los_Angelese";
  location.provider = "geoclue2";

  nix = {
    # From flake-utils-plus
    generateNixPathFromInputs = true;
    generateRegistryFromInputs = true;
    linkInputs = true;
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
    initrd.secrets = {"/luks.key" = /luks.key;};
  };
}
