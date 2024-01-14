{
  inputs,
  pkgs,
  ...
}: {
  imports = with inputs.self.nixosModules; [
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

  security.polkit.enable = true;
  # Let video group access backlight
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.toybox}/bin/chgrp video $sys$devpath/brightness", RUN+="${pkgs.toybox}/bin/chmod g+w $sys$devpath/brightness"
  '';

  # Actually takes code dumps for debugging.
  systemd.coredump.enable = true;

  boot = {
    initrd.secrets = {"/luks.key" = "/luks.key";};
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
