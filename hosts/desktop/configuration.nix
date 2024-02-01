{
  inputs,
  pkgs,
  ...
}: {
  imports = with inputs.self.nixosModules; [
    ./hardware-configuration.nix
    ./hardware.nix
    ./packages.nix

    users.eimmer

    common.all
    env.common
    env.coding

    misc.tailscale
    misc.mullvad
    misc.music
    misc.networkmanager
    misc.pipewire
  ];

  programs.noisetorch.enable = true;

  security.polkit.enable = true;
  # Let video group access backlight
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.toybox}/bin/chgrp video $sys$devpath/brightness", RUN+="${pkgs.toybox}/bin/chmod g+w $sys$devpath/brightness"
  '';

  # Actually takes code dumps for debugging.
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
}
