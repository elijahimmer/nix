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

  # Not sure what uses this, but it is needed
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

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
  };
}
