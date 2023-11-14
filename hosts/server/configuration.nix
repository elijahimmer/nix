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

    misc.upgrade
    misc.common
  ];

  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    # TODO: Add age nix or another secrets method and get the authorized keys here!
    banner = ''      ===========================================
            HERE BE DRAGONS; BEWARE OF WATERS AHEAD
            ==========================================='';
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
