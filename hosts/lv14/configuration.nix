{inputs, ...}: {
  imports = with inputs.self.nixosModules; [
    ./hardware-configuration.nix
    ./hardware.nix
    ./packages.nix

    users.eimmer

    env.common
    env.coding

    misc.common
    misc.tailscale
    misc.mullvad
    misc.networkmanager
    misc.pipewire
    misc.bluetooth
    misc.upgrade
  ];

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/Los_Angelese";

  boot = {
    tmp.useTmpfs = true;
    loader = {
      grub = {
        memtest86.enable = true;
        enableCryptodisk = true;
        timeoutStyle = "hidden";
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
